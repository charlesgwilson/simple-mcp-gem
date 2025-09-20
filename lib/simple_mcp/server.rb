# frozen_string_literal: true

require "mcp"

module SimpleMcp
  # Enhanced MCP Server for centralized tool execution and error handling
  class Server < MCP::Server
    def initialize(name:, version:, tools:)
      super
      @tool_invoker = ToolInvoker.new(self.tools)
    end

    # Delegate to ToolInvoker for consistent error handling and execution
    def call_tool(request)
      @tool_invoker.invoke_tool(request)
    end
  end
end
