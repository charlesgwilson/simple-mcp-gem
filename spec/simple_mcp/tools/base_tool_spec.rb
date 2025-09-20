# frozen_string_literal: true

require "spec_helper"

# Create a test tool class that inherits from BaseTool
class TestTool < SimpleMcp::Tools::BaseTool
  description "Test tool for testing base functionality"
  input_schema(
    properties: {
      param: {
        type: "string",
        description: "Test parameter",
      },
    },
    required: []
  )

  def self.call(**args)
    param = extract_param(args, :param, "default")
    MCP::Tool::Response.new([{ type: "text", text: "Result: #{param}" }])
  end
end

RSpec.describe SimpleMcp::Tools::BaseTool do
  describe ".extract_param" do
    it "extracts parameter with symbol key" do
      args = { param: "test_value" }

      result = TestTool.extract_param(args, :param, "default")

      expect(result).to eq("test_value")
    end

    it "extracts parameter with string key" do
      args = { "param" => "test_value" }

      result = TestTool.extract_param(args, :param, "default")

      expect(result).to eq("test_value")
    end

    it "returns default when parameter not found" do
      args = {}

      result = TestTool.extract_param(args, :param, "default")

      expect(result).to eq("default")
    end

    it "prioritizes symbol key over string key" do
      args = { param: "symbol_value", "param" => "string_value" }

      result = TestTool.extract_param(args, :param, "default")

      expect(result).to eq("symbol_value")
    end
  end

  describe ".error_handler" do
    it "returns error handler instance" do
      handler = TestTool.error_handler

      expect(handler).to be_a(SimpleMcp::Tools::Shared::ErrorHandler)
      expect(handler.instance_variable_get(:@tool_name)).to eq("TestTool")
    end
  end
end
