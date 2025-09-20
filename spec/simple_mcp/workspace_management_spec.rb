# frozen_string_literal: true

require "spec_helper"

RSpec.describe SimpleMcp do
  describe "workspace management" do
    describe ".workspace_root" do
      it "returns current workspace root" do
        SimpleMcp.workspace_root = "/test/workspace"

        result = SimpleMcp.workspace_root

        expect(result).to eq("/test/workspace")

        SimpleMcp.reset_workspace_root
      end
    end

    describe ".workspace_root=" do
      it "sets workspace root with expanded path" do
        test_path = "test/workspace"

        SimpleMcp.workspace_root = test_path

        expect(SimpleMcp.workspace_root).to eq(File.expand_path(test_path))

        SimpleMcp.reset_workspace_root
      end

      it "sets workspace root to nil when given nil" do
        SimpleMcp.workspace_root = "/test/workspace"

        SimpleMcp.workspace_root = nil

        expect(SimpleMcp.workspace_root).to be_nil
      end
    end

    describe ".reset_workspace_root" do
      it "resets workspace root to nil" do
        SimpleMcp.workspace_root = "/test/workspace"

        SimpleMcp.reset_workspace_root

        expect(SimpleMcp.workspace_root).to be_nil
      end
    end
  end
end
