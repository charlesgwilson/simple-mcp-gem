# frozen_string_literal: true

require "spec_helper"

RSpec.describe SimpleMcp do
  describe ".create_server" do
    it "creates an MCP server instance" do
      server = described_class.create_server

      expect(server).to be_a(MCP::Server)
    end

    it "sets correct server name" do
      server = described_class.create_server

      expect(server.name).to eq("simple-mcp")
    end

    it "sets correct server version" do
      server = described_class.create_server

      expect(server.version).to eq(SimpleMcp::VERSION)
    end

    it "includes HelloWorldTool in tools registry" do
      server = described_class.create_server

      expect(server.tools.values).to include(SimpleMcp::Tools::HelloWorldTool)
    end
  end

  describe ".start_server" do
    it "responds to start_server method" do
      expect(described_class).to respond_to(:start_server)
    end

    it "start_server method has correct arity" do
      expect(described_class.method(:start_server).arity).to eq(0)
    end
  end

  describe "HelloWorldTool integration" do
    it "server includes HelloWorldTool in registry" do
      server = described_class.create_server

      expect(server.tools.values).to include(SimpleMcp::Tools::HelloWorldTool)
    end

    it "HelloWorldTool executes with correct output" do
      args = { name: "Test" }

      result = SimpleMcp::Tools::HelloWorldTool.call(**args)

      expect(result.content.first[:text]).to eq("Hello, Test!")
    end
  end
end
