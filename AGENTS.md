# AGENTS.md

This file provides guidance to AI agents (Claude Code, Cursor, etc.) when working with code in this repository.

## Development Workflow

### Single Task Focus (Mandatory)
- **ONE TASK AT A TIME**: Complete current task fully before starting next
- **Quality Gates First**: All gates must pass before moving to next task
- **Context Preservation**: Use scratch pad to maintain state across sessions

### Scratch Pad Management
```bash
# Create/update scratch pad for current work
echo "## Current Task: [Brief Description]
- Status: [Red/Green/Refactor phase]
- Next Steps:
  - [ ] Step 1
  - [ ] Step 2
- Quality Gates Status:
  - [ ] Tests passing
  - [ ] RuboCop clean
  - [ ] Manual MCP testing
- Notes: [Important context]" > SCRATCH_PAD.md

# Always check scratch pad when resuming work
cat SCRATCH_PAD.md
```

## Development Commands

### Testing (TDD Workflow)
```bash
# TDD Red Phase - Run failing tests (should fail for right reason)
bundle exec rspec spec/simple_mcp/tools/your_new_tool_spec.rb

# TDD Green Phase - Run tests until they pass
bundle exec rspec spec/simple_mcp/tools/your_new_tool_spec.rb

# TDD Refactor Phase - Run all tests after refactoring
bundle exec rspec

# Development Testing Commands
bundle exec rspec                                           # Run all tests
bundle exec rspec spec/simple_mcp/tools/hello_world_tool_spec.rb  # Run specific test file
bundle exec rspec --format documentation                   # Run with detailed output
bundle exec rspec --fail-fast                             # Stop on first failure (for TDD)
```

### Code Quality
```bash
# Run RuboCop linting (must be clean)
bundle exec rubocop

# Auto-fix RuboCop violations
bundle exec rubocop --autocorrect
```

### Manual MCP Testing
```bash
# Test MCP protocol initialization
echo '{"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {"protocolVersion": "2024-11-05", "capabilities": {"tools": {}}}}' | bundle exec simple-mcp

# List available tools
echo '{"jsonrpc": "2.0", "id": 2, "method": "tools/list"}' | bundle exec simple-mcp

# Test hello_world_tool
echo '{"jsonrpc": "2.0", "id": 3, "method": "tools/call", "params": {"name": "hello_world_tool", "arguments": {"name": "Test"}}}' | bundle exec simple-mcp
```

### Running the Server
```bash
# Start MCP server
bundle exec simple-mcp

# Show help
bundle exec simple-mcp --help

# Show version
bundle exec simple-mcp --version
```

## Architecture Overview

This is a minimal MCP (Model Context Protocol) server implementation designed as a Ruby gem with fast startup and clean architecture.

### Core Components

1. **SimpleMcp Module** (`lib/simple_mcp.rb`)
   - Main entry point with `create_server` and `start_server` methods
   - Configures MCP server with tools array and stdio transport
   - Uses official MCP Ruby SDK v0.3

2. **Custom Server Architecture** (`lib/simple_mcp/server.rb`, `lib/simple_mcp/tool_invoker.rb`)
   - `SimpleMcp::Server` extends `MCP::Server` with enhanced functionality
   - `ToolInvoker` class provides centralized tool execution with error handling
   - Comprehensive error response formatting and tool registry management

3. **MCP Tools** (`lib/simple_mcp/tools/`)
   - Tools inherit from `SimpleMcp::Tools::BaseTool` (which extends `MCP::Tool`)
   - Base class provides `extract_param`, `error_handler`, and `handle_error` methods
   - Shared error handling integration reduces boilerplate

4. **Shared Error Handling** (`lib/simple_mcp/tools/shared/error_handler.rb`)
   - `ErrorHandler` class with configurable error patterns
   - Automatic `ArgumentError` preservation and special handling for `Errno::ENOENT`
   - Context extraction for meaningful error messages

5. **Workspace Management** (`lib/simple_mcp.rb`)
   - Thread-safe workspace root management with `workspace_root` attribute
   - Automatic path expansion and `reset_workspace_root!` cleanup method
   - Support for multi-project scenarios

6. **CLI Executable** (`exe/simple-mcp`)
   - Fast startup with argument parsing before loading dependencies
   - Standard gem executable pattern with OptionParser

### Key Architectural Patterns

**Enhanced Parameter Handling**: Tools use `extract_param` from `BaseTool` for flexible key handling:
```ruby
# In BaseTool - handles both symbol and string keys
def extract_param(args, key, default)
  args[key] || args[key.to_s] || default
end

# Usage in tools
name = extract_param(args, :name, "World")
```

**Standardized Error Handling**: All tools can use consistent error processing:
```ruby
class << self
  def call(**args)
    param = extract_param(args, :param, "default")
    # Tool logic here
    result = process_param(param)
    MCP::Tool::Response.new([{ type: "text", text: result }])
  rescue StandardError => e
    handle_error(e, { param: param })
  end
end
```

**Workspace Context Management**: Tools can access centralized workspace settings:
```ruby
# Set workspace root
SimpleMcp.workspace_root = "/path/to/project"

# Access in tools
workspace = SimpleMcp.workspace_root
file_path = File.join(workspace, "relative/path")
```

**Fast Startup**: Minimal dependencies loaded only when needed for quick initialization.

**MCP Response Format**: All tools return `MCP::Tool::Response.new([{type: "text", text: "..."}])`.

## Quality Requirements

**IMPORTANT**: All code quality standards are defined in `docs/CODING_STANDARDS.md`.

### Task Completion Requirements
A task is NOT complete until ALL of the following are true:
- All quality gates pass (see CODING_STANDARDS.md)
- Feature is fully functional and tested
- Documentation updated if needed
- Scratch pad updated with completion status
- Ready to commit without further work

### Context Management Rules
- **ALWAYS** check `SCRATCH_PAD.md` when starting work
- **ALWAYS** update scratch pad before context switches
- **NEVER** start new task until current task fully complete
- **PRESERVE** important decisions and gotchas in scratch pad

## Documentation Structure

- **AGENTS.md**: Agent-specific development insights and Claude Code integration patterns
- **docs/PROJECT.md**: High-level project overview and quick start guide
- **docs/CODING_STANDARDS.md**: Complete coding standards and quality requirements
- **README.md**: User-facing documentation for installation and usage