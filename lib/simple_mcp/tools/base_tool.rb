# frozen_string_literal: true

require "mcp"
require_relative "shared/error_handler"

module SimpleMcp
  module Tools
    # Base class for all SimpleMcp tools with common functionality
    class BaseTool < MCP::Tool
      def self.extract_param(args, param_name, default = nil)
        args[param_name] || args[param_name.to_s] || default
      end

      def self.error_handler
        @error_handler ||= Shared::ErrorHandler.new(name.split("::").last)
      end

      def self.handle_error(error, context = {})
        error_handler.process_error(error, context)
      end
    end
  end
end
