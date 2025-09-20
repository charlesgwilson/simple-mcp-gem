# frozen_string_literal: true

require "mcp"
require "mcp/server/transports/stdio_transport"
require_relative "simple_mcp/version"
require_relative "simple_mcp/server"
require_relative "simple_mcp/tool_invoker"
require_relative "simple_mcp/tools/shared/error_handler"
require_relative "simple_mcp/tools/base_tool"
require_relative "simple_mcp/tools/hello_world_tool"

# Minimal MCP server with fast startup and clean architecture
module SimpleMcp
  # Thread-safe workspace root management for multi-project scenarios
  def self.workspace_root
    @workspace_root
  end

  def self.workspace_root=(path)
    @workspace_root = expand_workspace_path(path)
  end

  def self.expand_workspace_path(path)
    return nil unless path

    File.expand_path(path)
  end

  def self.reset_workspace_root
    @workspace_root = nil
  end

  # Create and configure the MCP server
  def self.create_server
    Server.new(
      name: "simple-mcp",
      version: SimpleMcp::VERSION,
      tools: [SimpleMcp::Tools::HelloWorldTool]
    )
  end

  # Start the MCP server
  def self.start_server
    server = create_server
    transport = MCP::Server::Transports::StdioTransport.new(server)
    transport.open
  end
end
