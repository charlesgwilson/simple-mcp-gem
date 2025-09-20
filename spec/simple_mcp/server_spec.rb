# frozen_string_literal: true

require "spec_helper"

RSpec.describe SimpleMcp::Server do
  describe "#initialize" do
    it "creates server with tool invoker" do
      tools = [SimpleMcp::Tools::HelloWorldTool]

      server = described_class.new(name: "test-server", version: "1.0.0", tools: tools)

      expect(server).to be_a(SimpleMcp::Server)
      expect(server.instance_variable_get(:@tool_invoker)).to be_a(SimpleMcp::ToolInvoker)
    end
  end

  describe "#call_tool" do
    it "delegates to tool invoker" do
      tools = [SimpleMcp::Tools::HelloWorldTool]
      server = described_class.new(name: "test-server", version: "1.0.0", tools: tools)
      request = { name: "hello_world_tool", arguments: { name: "Test" } }

      result = server.call_tool(request)

      expect(result[:isError]).to be false
      expect(result[:content]).to be_an(Array)
      expect(result[:content].first[:type]).to eq("text")
      expect(result[:content].first[:text]).to eq("Hello, Test!")
    end
  end
end
