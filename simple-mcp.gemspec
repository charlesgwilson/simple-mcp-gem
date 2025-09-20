# frozen_string_literal: true

require_relative "lib/simple_mcp/version"

Gem::Specification.new do |spec|
  spec.name = "simple-mcp"
  spec.version = SimpleMcp::VERSION
  spec.authors = ["Charles Wilson"]
  spec.email = ["charles@example.com"]

  spec.summary = "Simple MCP server for testing"
  spec.description = "A minimal MCP server with hello-world tool for testing MCP functionality"
  spec.homepage = "https://github.com/charleswilson/simple-mcp"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.glob("lib/**/*.rb") + Dir.glob("exe/**/*") + Dir.glob("spec/**/*")
  spec.bindir = "exe"
  spec.executables = ["simple-mcp"]
  spec.require_paths = ["lib"]

  spec.add_dependency "mcp", "~> 0.3"
end
