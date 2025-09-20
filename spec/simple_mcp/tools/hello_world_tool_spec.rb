# frozen_string_literal: true

require "spec_helper"

RSpec.describe SimpleMcp::Tools::HelloWorldTool do
  describe ".call" do
    context "with valid arguments" do
      it "returns greeting with provided name" do
        args = { name: "Alice" }

        result = described_class.call(**args)

        expect(result.content).to eq([{
          type: "text",
          text: "Hello, Alice!",
        }])
      end

      it "uses default name when not provided" do
        args = {}

        result = described_class.call(**args)

        expect(result.content).to eq([{
          type: "text",
          text: "Hello, World!",
        }])
      end

      it "accepts string keys for arguments" do
        args = { "name" => "Bob" }

        result = described_class.call(**args)

        expect(result.content).to eq([{
          type: "text",
          text: "Hello, Bob!",
        }])
      end
    end
  end

  describe "tool definition" do
    it "has correct description" do
      expect(described_class.description).to eq("Say hello world")
    end

    it "has object type schema" do
      schema = described_class.input_schema.to_h

      expect(schema[:type]).to eq("object")
    end

    it "has no required fields" do
      schema = described_class.input_schema.to_h

      expect(schema[:required]).to be_nil
    end

    it "has name parameter with string type" do
      schema = described_class.input_schema.to_h

      expect(schema[:properties][:name][:type]).to eq("string")
    end

    it "has name parameter with correct description" do
      schema = described_class.input_schema.to_h

      expect(schema[:properties][:name][:description]).to eq("Name to greet (defaults to 'World')")
    end
  end
end
