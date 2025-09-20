# frozen_string_literal: true

module SimpleMcp
  module Tools
    module Shared
      # Standardized error handling for all tools
      class ErrorHandler
        PRESERVED_ERROR_PATTERNS = [
          /^File not found:/,
          /^LSP communication failed/,
          /^Invalid query:/,
          /^Failed to parse Ruby file/,
          /^Ruby LSP failed/,
          /^LSP returned/,
          /^Permission denied/,
          /^Path is a directory/,
          /^File path too long/,
          /^Invalid file path/,
          /^Broken pipe/,
          /^bad URI/,
        ].freeze

        def initialize(tool_name)
          @tool_name = tool_name
        end

        def process_error(error, context = {})
          if should_preserve_error_directly?(error)
            raise error
          end

          if should_convert_error_type?(error)
            raise_converted_error(error, context)
          end

          if should_preserve_error_pattern?(error)
            raise error
          end

          raise_wrapped_error(error, context)
        end

        private

        def should_preserve_error_directly?(error)
          error.is_a?(ArgumentError)
        end

        def should_convert_error_type?(error)
          error.is_a?(Errno::ENOENT)
        end

        def should_preserve_error_pattern?(error)
          PRESERVED_ERROR_PATTERNS.any? { |pattern| pattern.match?(error.message) }
        end

        def raise_converted_error(_error, context)
          file_path = context[:file] || "unknown file"
          raise StandardError, "File not found: #{file_path}"
        end

        def raise_wrapped_error(error, context)
          error_message = build_error_message(error, context)
          raise StandardError, error_message
        end

        def build_error_message(error, context)
          context_info = extract_context_info(context)
          base_message = "Failed to execute #{@tool_name}: #{error.message}"

          if context_info.empty?
            return base_message
          end

          context_string = format_context_info(context_info)
          "#{base_message} (#{context_string})"
        end

        def extract_context_info(context)
          relevant_keys = %i[file line character query]
          context.select { |k, v| relevant_keys.include?(k) && !v.nil? }
        end

        def format_context_info(context_info)
          context_info.map { |k, v| "#{k}=#{v}" }.join(", ")
        end
      end
    end
  end
end
