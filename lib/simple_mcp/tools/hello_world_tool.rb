# frozen_string_literal: true

require "mcp"

module SimpleMcp
  module Tools
    # Demonstrates MCP tool pattern with parameter extraction and response formatting
    class HelloWorldTool < BaseTool
      description "Say hello world"
      input_schema(
        properties: {
          name: {
            type: "string",
            description: "Name to greet (defaults to 'World')",
          },
        },
        required: []
      )

      def self.call(**args)
        name = extract_param(args, :name, "World")
        greeting = "Hello, #{name}!"
        MCP::Tool::Response.new([{
          type: "text",
          text: greeting,
        }])
      end
    end
  end
end
