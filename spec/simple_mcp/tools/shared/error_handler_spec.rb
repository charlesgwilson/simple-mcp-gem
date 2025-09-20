# frozen_string_literal: true

require "spec_helper"

RSpec.describe SimpleMcp::Tools::Shared::ErrorHandler do
  describe "#initialize" do
    it "stores tool name" do
      tool_name = "test_tool"

      handler = described_class.new(tool_name)

      expect(handler.instance_variable_get(:@tool_name)).to eq(tool_name)
    end
  end

  describe "#process_error" do
    context "when error is ArgumentError" do
      it "re-raises the error" do
        handler = described_class.new("test_tool")
        error = ArgumentError.new("Invalid argument")

        expect { handler.process_error(error) }.to raise_error(ArgumentError, "Invalid argument")
      end
    end

    context "when error is Errno::ENOENT" do
      it "raises file not found error" do
        handler = described_class.new("test_tool")
        error = Errno::ENOENT.new("No such file or directory")
        context = { file: "test.rb" }

        expect { handler.process_error(error, context) }.to raise_error(StandardError, "File not found: test.rb")
      end
    end

    context "when error matches preserved patterns" do
      it "re-raises the original error" do
        handler = described_class.new("test_tool")
        error = StandardError.new("File not found: test.rb")

        expect { handler.process_error(error) }.to raise_error(StandardError, "File not found: test.rb")
      end
    end

    context "when error is generic" do
      it "wraps error with tool context" do
        handler = described_class.new("test_tool")
        error = StandardError.new("Something went wrong")
        context = { file: "test.rb", line: 5 }

        expect { handler.process_error(error, context) }.to raise_error(StandardError, /Failed to execute test_tool: Something went wrong/)
      end
    end
  end
end
