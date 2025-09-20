# frozen_string_literal: true

require "spec_helper"

RSpec.describe SimpleMcp::ToolInvoker do
  describe "#initialize" do
    it "stores tools registry" do
      tools_registry = { "hello_world_tool" => SimpleMcp::Tools::HelloWorldTool }

      invoker = described_class.new(tools_registry)

      expect(invoker.instance_variable_get(:@tools_registry)).to eq(tools_registry)
    end
  end

  describe "#invoke_tool" do
    context "when tool exists" do
      it "returns successful response structure" do
        tools_registry = { "hello_world_tool" => SimpleMcp::Tools::HelloWorldTool }
        invoker = described_class.new(tools_registry)
        request = { name: "hello_world_tool", arguments: { name: "Test" } }

        result = invoker.invoke_tool(request)

        expect(result[:isError]).to be false
      end

      it "returns content array with text type" do
        tools_registry = { "hello_world_tool" => SimpleMcp::Tools::HelloWorldTool }
        invoker = described_class.new(tools_registry)
        request = { name: "hello_world_tool", arguments: { name: "Test" } }

        result = invoker.invoke_tool(request)

        expect(result[:content]).to be_an(Array)
        expect(result[:content].first[:type]).to eq("text")
      end
    end

    context "when tool does not exist" do
      it "raises tool not found error" do
        tools_registry = {}
        invoker = described_class.new(tools_registry)
        request = { name: "nonexistent_tool", arguments: {} }

        expect { invoker.invoke_tool(request) }.to raise_error(StandardError, /Tool not found/)
      end
    end

    context "when tool execution fails" do
      it "returns error response" do
        failing_tool_class = Class.new do
          def self.call(**_args)
            raise StandardError, "Test error"
          end
        end
        tools_registry = { "failing_tool" => failing_tool_class }
        invoker = described_class.new(tools_registry)
        request = { name: "failing_tool", arguments: {} }

        result = invoker.invoke_tool(request)

        expect(result[:isError]).to be true
        expect(result[:content]).to be_an(Array)
        expect(result[:content].first[:type]).to eq("text")
        expect(result[:content].first[:text]).to include("Error in failing_tool")
      end
    end
  end
end
