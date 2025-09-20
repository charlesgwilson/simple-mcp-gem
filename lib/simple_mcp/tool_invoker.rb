# frozen_string_literal: true

require "json"

module SimpleMcp
  # Handles tool invocation, execution, and error handling for MCP server
  class ToolInvoker
    MAX_BACKTRACE_LINES = 3
    def initialize(tools_registry)
      @tools_registry = tools_registry
    end

    def invoke_tool(request)
      parsed_request = parse_request(request)
      execute_tool_with_request(parsed_request)
    rescue StandardError => e
      handle_execution_error(e, parsed_request)
    end

    private

    def parse_request(request)
      {
        tool_name: extract_tool_name(request),
        arguments: extract_arguments(request),
      }
    end

    def extract_tool_name(request)
      request[:name] || request["name"]
    end

    def extract_arguments(request)
      request[:arguments] || request["arguments"] || {}
    end

    def execute_tool_with_request(parsed_request)
      tool_class = find_tool_class(parsed_request[:tool_name])
      execute_tool(tool_class, parsed_request[:arguments])
    end

    def handle_execution_error(error, parsed_request)
      handle_tool_execution_error(error, parsed_request[:tool_name], parsed_request[:arguments])
    end

    def find_tool_class(tool_name)
      tool_class = @tools_registry[tool_name]
      unless tool_class
        raise StandardError, "Tool not found: #{tool_name}"
      end

      tool_class
    end

    def execute_tool(tool_class, arguments)
      symbol_args = arguments.transform_keys(&:to_sym)
      result = tool_class.call(**symbol_args)

      build_success_response(result)
    end

    def handle_tool_execution_error(error, tool_name, arguments)
      if error.message.start_with?("Tool not found:")
        raise error
      end

      build_error_response(error, tool_name, arguments)
    end

    def build_success_response(result)
      {
        content: result.content,
        isError: false,
      }
    end

    def build_error_response(error, tool_name, arguments)
      {
        content: [{
          type: "text",
          text: build_error_message(error, tool_name, arguments),
        }],
        isError: true,
      }
    end

    def build_error_message(error, tool_name, arguments)
      error_details = build_error_details(error, tool_name, arguments)
      <<~MESSAGE
        Error in #{tool_name}: #{error.message}

        Details: #{JSON.pretty_generate(error_details)}
      MESSAGE
    end

    def build_error_details(error, tool_name, arguments)
      {
        error: error.class.name,
        message: error.message,
        tool: tool_name,
        arguments: arguments,
        backtrace: error.backtrace&.first(MAX_BACKTRACE_LINES) || [],
      }
    end
  end
end
