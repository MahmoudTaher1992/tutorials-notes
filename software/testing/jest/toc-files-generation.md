Here is the bash script to generate the directory and file structure for your Jest study guide.

To use this:
1.  Open your terminal.
2.  Create a new file, e.g., `setup_jest_guide.sh`.
3.  Paste the code below into that file.
4.  Make it executable: `chmod +x setup_jest_guide.sh`.
5.  Run it: `./setup_jest_guide.sh`.

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="Jest-Study-Guide"

# Create the root directory and enter it
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

echo "Creating structure in $ROOT_DIR..."

# --- PART I ---
PART_DIR="001-Fundamentals-JS-Testing-Jest"
mkdir -p "$PART_DIR"

# A. Introduction to Software Testing
cat <<EOF > "$PART_DIR/001-Introduction-to-Software-Testing.md"
# Introduction to Software Testing

* The "Why" of Testing: Confidence, Maintainability, and Documentation
* The Testing Pyramid: Unit, Integration, and End-to-End (E2E) Tests
* Core Concepts
    * Assertions: Verifying that things are correct
    * Test Runners: Finding and executing tests
    * Mocks & Stubs: Isolating code for focused testing
EOF

# B. Introduction to Jest
cat <<EOF > "$PART_DIR/002-Introduction-to-Jest.md"
# Introduction to Jest

* What is Jest? (Philosophy: Zero-config, Batteries-included)
* Key Features: Built-in assertion library, mocking, code coverage, parallel execution
* Jest's Role in the JavaScript Ecosystem
EOF

# C. Setting Up Your First Jest Environment
cat <<EOF > "$PART_DIR/003-Setting-Up-First-Environment.md"
# Setting Up Your First Jest Environment

* Installation (\`npm install --save-dev jest\`)
* Configuring \`package.json\` scripts
* Writing and Running Your First Test
* Understanding the Test Lifecycle: Pass, Fail, Skip
EOF

# D. Comparison with Other Testing Frameworks
cat <<EOF > "$PART_DIR/004-Comparison-Other-Frameworks.md"
# Comparison with Other Testing Frameworks

* Jest vs. Mocha & Chai
* Jest vs. Vitest
* Jest vs. End-to-End Tools (Cypress, Playwright)
EOF


# --- PART II ---
PART_DIR="002-Core-Jest-API-Writing-Tests"
mkdir -p "$PART_DIR"

# A. Structuring Tests
cat <<EOF > "$PART_DIR/001-Structuring-Tests.md"
# Structuring Tests

* Test Files: Naming Conventions (\`.test.js\`, \`.spec.js\`)
* Grouping Tests with \`describe()\` blocks
* Defining Individual Test Cases with \`it()\` or \`test()\`
* Controlling Test Execution: \`.skip()\` and \`.only()\`
EOF

# B. The expect API & Matchers
cat <<EOF > "$PART_DIR/002-The-expect-API-and-Matchers.md"
# The expect API & Matchers

* The Core Idea: \`expect(value).matcher(expectedValue)\`
* Common Matchers
    * Equality: \`.toBe()\`, \`.toEqual()\`, \`.toStrictEqual()\`
    * Truthiness: \`.toBeNull()\`, \`.toBeUndefined()\`, \`.toBeDefined()\`, \`.toBeTruthy()\`, \`.toBeFalsy()\`
    * Numbers: \`.toBeGreaterThan()\`, \`.toBeLessThan()\`, \`.toBeCloseTo()\`
    * Strings: \`.toMatch()\` (with Regex)
    * Arrays & Iterables: \`.toContain()\`, \`.toHaveLength()\`
    * Objects: \`.toHaveProperty()\`, \`.toMatchObject()\`
    * Exceptions: \`.toThrow()\`
* Negating Matchers with the \`.not\` chain (\`expect(value).not.toBe(x)\`)
EOF

# C. Setup and Teardown
cat <<EOF > "$PART_DIR/003-Setup-and-Teardown.md"
# Setup and Teardown

* Running Code Before/After Each Test: \`beforeEach()\` and \`afterEach()\`
* Running Code Once Per Test File: \`beforeAll()\` and \`afterAll()\`
* Scoping Hooks within \`describe\` blocks
* Order of Execution
EOF

# D. Testing Asynchronous Code
cat <<EOF > "$PART_DIR/004-Testing-Asynchronous-Code.md"
# Testing Asynchronous Code

* Callbacks (The old way, using the \`done\` argument)
* Promises: Using \`.resolves\` and \`.rejects\`
* The Modern Approach: \`async/await\`
EOF


# --- PART III ---
PART_DIR="003-Mocking-Spying-Isolation"
mkdir -p "$PART_DIR"

# A. The Philosophy of Mocking
cat <<EOF > "$PART_DIR/001-Philosophy-of-Mocking.md"
# The Philosophy of Mocking

* Why Isolate? Speed, Determinism, and Focusing on the Unit Under Test
* Test Doubles: Dummies, Stubs, Spies, and Mocks
EOF

# B. Mock Functions (jest.fn())
cat <<EOF > "$PART_DIR/002-Mock-Functions.md"
# Mock Functions (jest.fn())

* Creating a "spy" or mock function
* Inspecting Mock Calls: \`.mock.calls\`, \`.mock.results\`
* Checking Invocations: \`.toHaveBeenCalled()\`, \`.toHaveBeenCalledWith()\`, \`.toHaveBeenCalledTimes()\`
* Controlling Return Values: \`.mockReturnValue()\`, \`.mockReturnValueOnce()\`, \`.mockResolvedValue()\`
* Mocking Implementations: \`.mockImplementation()\`
EOF

# C. Mocking Modules & Dependencies (jest.mock())
cat <<EOF > "$PART_DIR/003-Mocking-Modules-Dependencies.md"
# Mocking Modules & Dependencies (jest.mock())

* Auto-mocking Node modules (e.g., \`axios\`, \`fs\`)
* Creating Manual Mocks in a \`__mocks__\` directory
* Mocking Specific Functions within a Module
* Spying on existing implementations with \`jest.spyOn()\`
EOF

# D. Advanced Mocking Techniques
cat <<EOF > "$PART_DIR/004-Advanced-Mocking-Techniques.md"
# Advanced Mocking Techniques

* Mocking ES6 Classes
* Mocking Timers: \`jest.useFakeTimers()\` to control \`setTimeout\`, \`setInterval\`
* Clearing and Resetting Mocks: \`mockClear()\`, \`mockReset()\`, \`mockRestore()\`
EOF


# --- PART IV ---
PART_DIR="004-Configuration-Environment"
mkdir -p "$PART_DIR"

# A. Jest Configuration File (jest.config.js)
cat <<EOF > "$PART_DIR/001-Jest-Configuration-File.md"
# Jest Configuration File (jest.config.js)

* Core Options: \`testEnvironment\` (\`node\` vs. \`jsdom\`), \`testMatch\`
* Module Resolution: \`moduleNameMapper\` for path aliases
* Setup and Environment: \`setupFiles\`, \`setupFilesAfterEnv\`
* Coverage Configuration: \`collectCoverageFrom\`, \`coverageThreshold\`
EOF

# B. The Jest CLI
cat <<EOF > "$PART_DIR/002-Jest-CLI.md"
# The Jest CLI

* Running Specific Files or Tests (\`-t\` flag)
* Watch Mode (\`--watch\`, \`--watchAll\`)
* Generating and Viewing Coverage Reports (\`--coverage\`)
* Other useful flags: \`--silent\`, \`--verbose\`, \`--runInBand\`
EOF

# C. Integration with Modern Tooling
cat <<EOF > "$PART_DIR/003-Integration-Modern-Tooling.md"
# Integration with Modern Tooling

* Using Jest with TypeScript (\`ts-jest\` preset)
* Using Jest with Babel for modern JavaScript features
* Integration with bundlers (Webpack, Vite)
EOF


# --- PART V ---
PART_DIR="005-Advanced-Testing-Techniques-Scenarios"
mkdir -p "$PART_DIR"

# A. Snapshot Testing
cat <<EOF > "$PART_DIR/001-Snapshot-Testing.md"
# Snapshot Testing

* What are Snapshots and Why Use Them? (Testing complex outputs like UI components)
* Writing your first snapshot test: \`.toMatchSnapshot()\`
* Updating Snapshots (\`-u\` flag)
* Inline Snapshots: \`.toMatchInlineSnapshot()\`
* Best Practices and Pitfalls
EOF

# B. Testing Framework-Specific Code
cat <<EOF > "$PART_DIR/002-Testing-Framework-Specific-Code.md"
# Testing Framework-Specific Code

* **React:**
    * Using React Testing Library (\`@testing-library/react\`) for user-centric testing
    * Querying the DOM, Firing Events, and \`act()\`
    * Testing Custom Hooks
* **Node.js / Express:**
    * Unit testing controllers and services
    * Integration testing API endpoints with \`supertest\`
EOF

# C. Code Coverage
cat <<EOF > "$PART_DIR/003-Code-Coverage.md"
# Code Coverage

* Understanding the Coverage Report (Statements, Branches, Functions, Lines)
* Setting and Enforcing Coverage Thresholds
* What Coverage *Doesn't* Tell You (The quality of assertions)
EOF

# D. Extending Jest
cat <<EOF > "$PART_DIR/004-Extending-Jest.md"
# Extending Jest

* Custom Matchers with \`expect.extend()\`
* Custom Environment Setup
EOF


# --- PART VI ---
PART_DIR="006-Ecosystem-Patterns-Best-Practices"
mkdir -p "$PART_DIR"

# A. Writing Good Tests
cat <<EOF > "$PART_DIR/001-Writing-Good-Tests.md"
# Writing Good Tests

* The AAA Pattern: Arrange, Act, Assert
* Tests should be DAMP (Descriptive and Meaningful Phrases), not DRY
* Writing Clear Test Descriptions
* Testing the "What," not the "How" (Avoid testing implementation details)
EOF

# B. Integration into a Development Workflow
cat <<EOF > "$PART_DIR/002-Integration-Dev-Workflow.md"
# Integration into a Development Workflow

* Test-Driven Development (TDD): Red, Green, Refactor cycle
* Running Jest in a CI/CD Pipeline (e.g., GitHub Actions, GitLab CI)
* Using Git Hooks (e.g., \`husky\`) to run tests pre-commit
EOF

# C. Debugging Tests
cat <<EOF > "$PART_DIR/003-Debugging-Tests.md"
# Debugging Tests

* Using \`console.log\` effectively
* Leveraging your IDE's debugger (e.g., VS Code's Jest extension)
* Using \`.only\` to isolate a failing test
EOF

# D. Performance
cat <<EOF > "$PART_DIR/004-Performance.md"
# Performance

* Identifying and fixing slow tests
* Running tests in parallel vs. sequentially (\`--runInBand\`)
* Strategies for large codebases
EOF


# --- PART VII ---
PART_DIR="007-Specialized-Modern-Topics"
mkdir -p "$PART_DIR"

# A. Testing Non-Code Assets
cat <<EOF > "$PART_DIR/001-Testing-Non-Code-Assets.md"
# Testing Non-Code Assets

* Configuring Jest to handle CSS, images, and other files
EOF

# B. Advanced Asynchronous Patterns
cat <<EOF > "$PART_DIR/002-Advanced-Async-Patterns.md"
# Advanced Asynchronous Patterns

* Mocking network requests at the service worker level with MSW (Mock Service Worker)
EOF

# C. Accessibility (a11y) Testing
cat <<EOF > "$PART_DIR/003-Accessibility-Testing.md"
# Accessibility (a11y) Testing

* Integrating \`jest-axe\` to catch accessibility violations in the DOM
EOF

# D. Property-Based Testing
cat <<EOF > "$PART_DIR/004-Property-Based-Testing.md"
# Property-Based Testing

* Introduction to the concept (vs. example-based testing)
* Using libraries like \`fast-check\` with Jest
EOF

echo "All done! Directory structure created in '$ROOT_DIR'."
```
