# Simple MCP

A minimal, fast, and reliable Model Context Protocol (MCP) server implementation for testing and development purposes.

## Overview

A minimal MCP server that runs within your Ruby application's process. Provides a foundation for building custom AI tools that can evolve alongside your codebase.

**Experiment with:** Custom MCP tools, AI-assisted workflows, and intelligent code interactions.

## Why an Embeddable Gem?

Most MCP servers run as separate processes. This gem explores a different approach by running within your application:

- **Shared Runtime**: Access to your project's loaded gems and Ruby environment
- **Workspace Awareness**: Tools know your project's root directory context
- **Extensible Foundation**: Simple architecture for building project-specific tools
- **Future Potential**: Foundation for deeper integrations with Ruby LSP, Rails, and other tooling

What could you build when AI tools understand your specific codebase and business domain?

## Installation

Add to your Ruby application's Gemfile:

```ruby
group :development do
  gem "simple-mcp", path: "simple-mcp-gem"
end
```

Then run:

```bash
bundle install
```

## Configuration

### Claude Code

Create `.claude/mcp.json` in your project root:

```json
{
  "mcpServers": {
    "simple-mcp": {
      "command": "bundle",
      "args": ["exec", "simple-mcp"],
      "cwd": "/path/to/your/project",
      "env": {}
    }
  }
}
```

### Cursor

Add to your MCP settings or configuration file with the same format as above.

## Usage

### Command Line

```bash
# Show help
bundle exec simple-mcp --help

# Show version
bundle exec simple-mcp --version

# Start MCP server (for testing)
bundle exec simple-mcp
```

### MCP Tool

The gem provides one tool:

#### `hello_world_tool`

Says hello to a provided name or defaults to "World".

**Parameters:**
- `name` (optional): Name to greet

**Example responses:**
```json
{"type": "text", "text": "Hello, World!"}
{"type": "text", "text": "Hello, Alice!"}
```

<img width="748" height="268" alt="Screenshot 2025-09-20 at 10 15 40 AM" src="https://github.com/user-attachments/assets/16b10bee-2d2e-4c70-8a8b-65f03cfb71c3" />

## Development

### Requirements

- Ruby 3.0+
- Bundler
- RSpec (testing)
- RuboCop (linting)

### Setup

```bash
bundle install
```

### Testing

```bash
# Run all tests
bundle exec rspec

# Run with coverage
bundle exec rspec --format documentation
```

### Code Quality

```bash
# Run RuboCop
bundle exec rubocop

# Check syntax
ruby -c exe/simple-mcp
```

### Manual Testing

```bash
# Test initialization
echo '{"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {"protocolVersion": "2024-11-05", "capabilities": {"tools": {}}}}' | bundle exec simple-mcp

# Test tool listing
echo '{"jsonrpc": "2.0", "id": 2, "method": "tools/list"}' | bundle exec simple-mcp

# Test tool call
echo '{"jsonrpc": "2.0", "id": 3, "method": "tools/call", "params": {"name": "hello_world_tool", "arguments": {"name": "Test"}}}' | bundle exec simple-mcp
```

## License

MIT License - see LICENSE file for details.

## Acknowledgments

Built with AI assistance from [Claude Code](https://claude.ai/code) and [Cursor](https://cursor.sh/), following standards from [BuoySoftware](https://github.com/BuoySoftware/guides) and [thoughtbot](https://github.com/thoughtbot/guides), with hat tip to [Cursor Rules](https://github.com/dgalarza/cursor-rules).

## Disclaimer

All documentation, including this file, was generated with AI assistance.
