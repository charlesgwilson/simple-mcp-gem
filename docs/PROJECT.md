# Simple MCP Gem

Minimal Ruby MCP server implementation. Template for building MCP tools in Ruby.

## Project Type
- **MCP Server**: Ruby gem with stdio transport
- **Dependencies**: MCP SDK v0.3, RSpec, RuboCop
- **Target**: < 500ms startup, full protocol compliance

## Architecture

### Core Components
- **`SimpleMcp` module**: Server creation, startup, and workspace management
- **`SimpleMcp::Server`**: Custom server extending `MCP::Server` with enhanced functionality
- **`SimpleMcp::ToolInvoker`**: Centralized tool execution with error handling
- **`SimpleMcp::Tools::BaseTool`**: Base class providing common tool functionality
- **`lib/simple_mcp/tools/`**: Tool implementations inherit from `BaseTool`
- **`exe/simple-mcp`**: CLI executable with fast startup (<500ms)

### Key Patterns
- **Parameter Flexibility**: Tools handle both `:symbol` and `"string"` keys for MCP client compatibility
- **Error Handling**: Shared error processing with context preservation
- **Workspace Management**: Centralized workspace root management with thread safety
- **Tool Registry**: Automatic tool discovery and registration

## Commands
```bash
# Installation
gem install simple-mcp

# Usage
simple-mcp

# Development setup
bundle install

# Quality gates (all must pass)
bundle exec rspec      # All tests green
bundle exec rubocop    # Zero violations
echo '{"jsonrpc": "2.0", "id": 1, "method": "tools/list"}' | simple-mcp  # Protocol test
```

## MCP Client Configuration
`.claude/mcp.json`:
```json
{
  "tools": {
    "simple-mcp": {
      "command": "simple-mcp"
    }
  }
}
```

## Tool Development Process
1. TDD: Red → Green → Refactor (see AGENTS.md for detailed workflow)
2. Quality gates: Tests pass + RuboCop clean + Manual MCP testing
3. Add tool to `SimpleMcp.create_server` tools array

## Tool Implementation Pattern
```ruby
class NewTool < SimpleMcp::Tools::BaseTool
  description "Clear tool description"
  input_schema(
    properties: { param: { type: "string", description: "Parameter description" } },
    required: []
  )

  class << self
    def call(**args)
      param = extract_param(args, :param, "default")

      # Tool logic here
      result = process_param(param)

      MCP::Tool::Response.new([{
        type: "text",
        text: result
      }])
    rescue StandardError => e
      handle_error(e, { param: param })
    end
  end
end
```

## Workspace Management
```ruby
# Set workspace root for tools that need file access
SimpleMcp.workspace_root = "/path/to/project"

# Access in tools
workspace = SimpleMcp.workspace_root

# Reset when switching contexts
SimpleMcp.reset_workspace_root!
```

## Performance Requirements
- Startup: < 500ms
- Memory: Minimal footprint
- Protocol: Full MCP specification compliance
- Clients: Claude Code, Cursor compatibility verified

## Standards Hierarchy
1. **BuoySoftware guides** (primary)
2. **thoughtbot guides** (fallback)
3. **POODR principles** (architecture)
4. **TDD methodology** (development)