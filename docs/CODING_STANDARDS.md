# Coding Standards

## Standards Hierarchy
1. **BuoySoftware Guides** (primary): https://github.com/BuoySoftware/guides
2. **thoughtbot Guides** (fallback): https://github.com/thoughtbot/guides

## Ruby Standards
- POODR principles: Single responsibility, dependency injection, small methods
- RuboCop compliance: `bundle exec rubocop --autocorrect && bundle exec rubocop`

**Code Quality Guidelines:**
- Avoid conditional modifiers (lines that end with conditionals).
- Avoid multiple assignments per line (one, two = 1, 2).
- Avoid organizational comments (# Validations).
- Prefer simple ternary operators for basic assignments (value = condition ? true_val : false_val). Use multi-line if statements for complex logic or when branches contain multiple operations.
- Avoid bang (!) method names. Prefer descriptive names.
- Prefer safe navigation operators (&.) over explicit nil checks when appropriate.
- Prefer classes over modules for shared functionality
- Avoid monkey-patching
- Prefer method invocation over instance variables
- Order class methods above instance methods
- Prefer `def self.method`, over `class << self`.
- Use `def` with parentheses when there are arguments
- Use heredocs for multi-line strings.
- Prefix unused variables with underscore
- Prefer private when indicating scope. Use protected only with comparison methods like def ==(other), def <(other), and def >(other).
- Use descriptive method names
- Avoid optional parameters. Does the method do too much?

**Project Organization:**
- Order contents consistently: constants, macros, public methods, private methods
- Use alphabetical ordering for validations and i18n translations
- Use `ENV.fetch` for environment variables to detect unset variables

## Self-Documenting Code Principles
Code should read like prose through clear naming and structure:

**Descriptive Naming**: Use meaningful names for variables, functions, and classes

**While Writing Code:**
- Ask: "Will another developer understand this name without explanation?"
- If unsure → Choose the more descriptive name
- Avoid abbreviations unless universally understood

```ruby
# ✅ Good - self-explanatory
def calculate_monthly_payment(principal, rate, years)
  # Implementation
end

# ❌ Avoid - requires explanation
def calc(p, r, y)
  # Implementation
end
```

**Small, Focused Functions**: Single responsibility, maximum 15 lines

**While Writing Code:**
- Ask: "What is the single responsibility of this method?"
- If you can't describe it in one sentence → Split it
- Count lines: If over 15 → Extract smaller methods
- If method name contains "and" → Likely multiple responsibilities

```ruby
# ✅ Good - single responsibility
def extract_param(args, key, default)
  args[key] || args[key.to_s] || default
end

# ❌ Avoid - multiple responsibilities
def process_user_data_and_send_email(data)
  # Parsing, validation, and email sending mixed together
end
```

**Minimize Comments**: Comments explain "why", not "what"

**While Writing Code:**
- Before adding any comment, ask: "Am I explaining WHY this decision was made or WHAT the code does?"
- If explaining WHAT → Don't write the comment, make the code self-documenting instead
- Only write comments for: complex business logic, non-obvious decisions, or warnings
- Only comment for complex business logic, non-obvious decisions, or warnings
- Prefer self-explaining code over explanatory comments
- Use meaningful constants instead of magic numbers


**Examples of Natural Application:**
```ruby
# ❌ Don't write this - explains WHAT
def calculate_total(items)
  # Calculate the total of all items
  items.sum(&:price)
end

# ✅ Write this - self-documenting
def calculate_total(items)
  items.sum(&:price)
end

# ✅ Only comment for WHY
def calculate_total(items)
  # Apply bulk discount for orders over 100 items
  base_total = items.sum(&:price)
  base_total > 100 ? base_total * 0.9 : base_total
end
```

## RSpec Testing Standards

### BuoySoftware RSpec Guidelines
Following the [BuoySoftware RSpec Testing Guide](https://github.com/BuoySoftware/guides/tree/main/testing-rspec):

**Syntax and Structure:**
- Use RSpec's `expect` syntax (not `should`)
- Use `allow` syntax for method stubs
- Prefer `not_to` over `to_not`
- Use `eq` instead of `==`
- Separate test phases with newlines
- Prefer one expectation per `it` example

**Test Design:**
- Use a single abstraction level in scenarios
- Create an `it` example for each execution path
- Use shared examples for common behaviors
- Avoid using `private` keyword in specs
- Don't test private methods
- Avoid instance variables in tests
- Use `.method` for class methods, `#method` for instance methods
- Use `context` to describe testing preconditions
- Don't prefix `it` blocks with "should"
- Order tests matching class structure

**Mocking and Stubbing:**
- Use stubs and spies (not mocks) in isolated tests
- Avoid `any_instance`
- Use dependency injection
- Use stubs to assert outgoing messages
- Use "Fake" to stub external service requests
- Disable external HTTP requests

**Test Organization:**
- Prefer helper methods over `let`
- Avoid `its`, `specify`, and `before`
- Use descriptive scenario titles

### TDD: Red-Green-Refactor (Mandatory)
**While Writing Code:**
- **Before writing any production code** → Write a failing test first
- **Red Phase**: Test must fail for the right reason (not syntax errors)
- **Green Phase**: Write minimal code to make test pass (don't worry about quality yet)
- **Refactor Phase**: Improve code design while keeping tests green
- **Coverage**: Test all logic paths, edge cases, and error conditions

**Natural Application:**
1. Think: "What should this code do?"
2. Write test that describes that behavior
3. Run test → Should fail
4. Write minimal code to make test pass
5. Refactor while keeping tests green

### Avoid Stubbing System Under Test
**Never stub or mock the class/component being tested**

```ruby
# Good - Test real behavior
RSpec.describe UserGreeter do
  it "greets user with custom name" do
    greeter = UserGreeter.new
    result = greeter.greet("Alice")
    expect(result).to eq("Hello, Alice!")
  end
end

# Avoid - Stubbing the SUT
RSpec.describe UserGreeter do
  it "greets user with custom name" do
    greeter = UserGreeter.new
    allow(greeter).to receive(:greet).and_return("Hello, Alice!")  # ❌ Stubbing SUT
    result = greeter.greet("Alice")
    expect(result).to eq("Hello, Alice!")
  end
end
```

**Guidelines**:
- Only stub external collaborators and dependencies
- Test actual behavior, not test doubles
- If stubbing feels necessary, consider refactoring for better testability
- Stubbing the SUT often indicates design problems

### Four-Phase Testing Pattern (Required)
```ruby
RSpec.describe YourTool do
  describe ".call" do
    context "when condition" do
      it "describes expected behavior" do
        # Setup - Arrange test data
        args = { param: "value" }

        # Exercise - Execute the behavior
        result = described_class.call(**args)

        # Verify - Assert expected outcomes
        expect(result.content).to eq([{
          type: "text",
          text: "expected output"
        }])

        # Teardown - Cleanup if needed (usually implicit)
      end
    end
  end
end
```

## TDD Process (Non-Negotiable)
```bash
# Red Phase: Write failing tests
bundle exec rspec spec/path/to/test.rb  # Must fail for right reason

# Green Phase: Make tests pass
# Implement minimal code, focus on functionality only

# Refactor Phase: Improve code quality
bundle exec rubocop --autocorrect
bundle exec rubocop  # Fix remaining violations
bundle exec rspec    # Verify all tests still pass
```

## Quality Gates (All Must Pass)
1. `bundle exec rspec` - All tests green
2. `bundle exec rubocop` - Zero violations
3. Four-phase test pattern followed
4. POODR principles applied

## Architecture Requirements

### POODR Principles (Primary Object-Oriented Design in Ruby)
- **Single Responsibility**: Each class has one reason to change
- **Dependency Injection**: Dependencies are explicit and testable
- **Small Methods**: Maximum 15 lines, focused functionality
- **Interface Segregation**: Focused, minimal interfaces

### Tool Development Patterns
- **Inheritance**: All tools inherit from `SimpleMcp::Tools::BaseTool`
- **Parameter Handling**: Use `extract_param(args, :key, default)` for flexible key handling
- **Error Handling**: Use `handle_error(exception, context)` for consistent error processing
- **Response Format**: Always return `MCP::Tool::Response.new([{type: "text", text: "..."}])`

### Quality Benefits
- **Developer Experience**: Standardized patterns reduce boilerplate
- **Maintainability**: Clear separation of concerns and consistent APIs
- **Reliability**: Robust error handling and input validation
- **Scalability**: Resource management and workspace isolation support

## Failure Conditions
Work is incomplete if:
- Tests not written before implementation (TDD violation)
- RuboCop violations present
- Four-phase testing pattern not followed
- Ruby Standards violated
- RSpec Testing Standards violated
- POODR principles violated (single responsibility, dependency injection, small methods)
- System under test is stubbed or mocked in tests
- Code is not self-documenting (unclear naming, excessive comments)
- Self-documenting code was commented
- Functions exceed 15 lines or have multiple responsibilities
- Multiple tasks attempted simultaneously
- External dependencies not properly managed in gemspec

## RuboCop Configuration
- Inherits from BuoySoftware guides: https://raw.githubusercontent.com/BuoySoftware/guides/main/ruby/.rubocop.yml
- Project-specific overrides in `.rubocop.yml`
- Double quotes enforced (BuoySoftware standard), performance cops enabled
- Line length: 100 characters max with string splitting enabled