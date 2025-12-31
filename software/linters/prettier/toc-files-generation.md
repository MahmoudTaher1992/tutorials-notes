Here is the bash script to generate the folder structure and files for your **Prettier Study Guide**.

### How to use this:
1.  Copy the code block below.
2.  Open your terminal in Ubuntu.
3.  Create a file, e.g., `setup_prettier_study.sh`:
    `nano setup_prettier_study.sh`
4.  Paste the code inside and save (Ctrl+O, Enter, Ctrl+X).
5.  Make the script executable:
    `chmod +x setup_prettier_study.sh`
6.  Run the script:
    `./setup_prettier_study.sh`

---

```bash
#!/bin/bash

# Define Root Directory Name
ROOT_DIR="Prettier-Study"

# Create Root Directory
echo "Creating root directory: $ROOT_DIR"
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

# ==========================================
# PART I: Fundamentals of Linters & Formatters
# ==========================================
DIR_NAME="001-Fundamentals-of-Linters-Formatters"
mkdir -p "$DIR_NAME"

# File 1
FILE_NAME="$DIR_NAME/001-Introduction-to-Code-Quality-Tools.md"
cat <<EOF > "$FILE_NAME"
# Introduction to Code Quality Tools

*   What are Linters? What are Formatters?
*   Why Code Quality Matters
*   Distinction: Linting vs. Formatting vs. Static Analysis
EOF

# File 2
FILE_NAME="$DIR_NAME/002-Ecosystem-Overview.md"
cat <<EOF > "$FILE_NAME"
# Ecosystem Overview

*   Types: Syntax Linters, Style Linters, Security Linters, Formatters
*   Popular Tools: ESLint, TSLint (deprecated), JSHint, Stylelint, Prettier, etc.
*   Integrations: Editors, CI/CD, Pre-commit Hooks
EOF

# ==========================================
# PART II: Prettier Fundamentals
# ==========================================
DIR_NAME="002-Prettier-Fundamentals"
mkdir -p "$DIR_NAME"

# File 1
FILE_NAME="$DIR_NAME/001-Introduction-to-Prettier.md"
cat <<EOF > "$FILE_NAME"
# Introduction to Prettier

*   What is Prettier? Mission & Philosophy
*   History and Adoption
*   Prettier vs. Linters (e.g., Prettier vs. ESLint)
EOF

# File 2
FILE_NAME="$DIR_NAME/002-Supported-Languages-and-Projects.md"
cat <<EOF > "$FILE_NAME"
# Supported Languages and Projects

*   JavaScript, TypeScript, JSON, CSS, HTML, Markdown, YAML, and more
*   Community Plugins & Extending Prettier
EOF

# File 3
FILE_NAME="$DIR_NAME/003-Installation-and-Setup.md"
cat <<EOF > "$FILE_NAME"
# Installation & Setup

*   Installing Prettier (npm, yarn, pnpm, global vs. local)
*   Editor Integration (VSCode, WebStorm, Sublime, Vim, etc.)
*   Command-Line Usage (CLI basics)
*   Setting up Prettier with project scripts
EOF

# ==========================================
# PART III: Usage and Configuration
# ==========================================
DIR_NAME="003-Usage-and-Configuration"
mkdir -p "$DIR_NAME"

# File 1
FILE_NAME="$DIR_NAME/001-Configuration-Options.md"
cat <<EOF > "$FILE_NAME"
# Configuration Options

*   Configuration Files: \`.prettierrc\`, \`package.json\`, \`prettier.config.js\`
*   Specifying Options:
    *   printWidth
    *   tabWidth
    *   useTabs
    *   semi
    *   singleQuote
    *   quoteProps
    *   trailingComma
    *   bracketSpacing
    *   jsxBracketSameLine / bracketSameLine
    *   arrowParens
    *   proseWrap
    *   endOfLine
*   Overriding Configuration: File-specific, EditorConfig, Ignore Files (\`.prettierignore\`)
EOF

# File 2
FILE_NAME="$DIR_NAME/002-Running-Prettier.md"
cat <<EOF > "$FILE_NAME"
# Running Prettier

*   Formatting Individual Files
*   Batch Formatting (folders, glob patterns)
*   Auto-format on Save in Editors
*   Dry-Run / Check Mode (\`--check\`, \`--list-different\`)
*   Handling Syntax Errors and Incomplete Code
EOF

# ==========================================
# PART IV: Prettier in Development Workflow
# ==========================================
DIR_NAME="004-Prettier-in-Development-Workflow"
mkdir -p "$DIR_NAME"

# File 1
FILE_NAME="$DIR_NAME/001-Collaboration-and-Consistency.md"
cat <<EOF > "$FILE_NAME"
# Collaboration and Consistency

*   Why Consistent Formatting Matters in Teams
*   Preventing “Style Wars”
*   Using Prettier in Open Source Projects
EOF

# File 2
FILE_NAME="$DIR_NAME/002-Automating-Formatting.md"
cat <<EOF > "$FILE_NAME"
# Automating Formatting

*   Pre-commit Hooks (lint-staged & husky)
*   CI/CD Integration: Ensuring Codebase Consistency
*   Editor/IDE Enforcements vs. Manual and Automatic Formatting
EOF

# ==========================================
# PART V: Integration with Other Tools
# ==========================================
DIR_NAME="005-Integration-with-Other-Tools"
mkdir -p "$DIR_NAME"

# File 1
FILE_NAME="$DIR_NAME/001-Prettier-Plus-ESLint.md"
cat <<EOF > "$FILE_NAME"
# Prettier + ESLint

*   Overlap and Cooperation: What Each Does
*   Configuring ESLint to Defer Formatting Rules to Prettier (eslint-config-prettier)
*   Using Prettier as an ESLint Rule (eslint-plugin-prettier)
*   Resolving Conflicts & Common Pitfalls
EOF

# File 2
FILE_NAME="$DIR_NAME/002-Integration-with-Frameworks-and-Tools.md"
cat <<EOF > "$FILE_NAME"
# Integration with Frameworks and Tools

*   Prettier in Create React App, Next.js, Vue CLI, Angular, etc.
*   Prettier with Stylelint (for CSS)
*   IDE/Editor Plugins and Their Configurations
EOF

# ==========================================
# PART VI: Advanced Usage & Customization
# ==========================================
DIR_NAME="006-Advanced-Usage-and-Customization"
mkdir -p "$DIR_NAME"

# File 1
FILE_NAME="$DIR_NAME/001-CLI-Advanced-Features.md"
cat <<EOF > "$FILE_NAME"
# CLI Advanced Features

*   Ignoring Files and Directories
*   Using Prettier with Git Hooks and Automation Scripts
EOF

# File 2
FILE_NAME="$DIR_NAME/002-Extending-Prettier.md"
cat <<EOF > "$FILE_NAME"
# Extending Prettier

*   Writing Plugins for Unsupported File Types
*   Community and Third-party Plugins
*   Contributing to Prettier Core
EOF

# File 3
FILE_NAME="$DIR_NAME/003-Troubleshooting-and-Limitations.md"
cat <<EOF > "$FILE_NAME"
# Troubleshooting & Limitations

*   Common Issues and FAQs
*   Limitations: Philosophy of “No Config” vs. Highly Custom
*   Handling Performance Issues with Large Codebases
EOF

# ==========================================
# PART VII: Prettier in Practice
# ==========================================
DIR_NAME="007-Prettier-in-Practice"
mkdir -p "$DIR_NAME"

# File 1
FILE_NAME="$DIR_NAME/001-Codebase-Migration.md"
cat <<EOF > "$FILE_NAME"
# Codebase Migration

*   Adopting Prettier in Existing Projects—Step-by-Step
*   Bulk Formatting and Managing Large Diffs
*   Communicating and Documenting Formatting Changes
EOF

# File 2
FILE_NAME="$DIR_NAME/002-Formatting-in-Mono-repos.md"
cat <<EOF > "$FILE_NAME"
# Formatting in Mono-repos and Multi-language Projects

*   Strategies for Managing Multiple Configurations
*   Cross-team Patterns
EOF

# File 3
FILE_NAME="$DIR_NAME/003-Case-Studies.md"
cat <<EOF > "$FILE_NAME"
# Case Studies

*   Teams’ Experiences (e.g., Engineering Blogs)
*   Open-source Project Migrations
EOF

# ==========================================
# PART VIII: Future Directions and Alternatives
# ==========================================
DIR_NAME="008-Future-Directions-and-Alternatives"
mkdir -p "$DIR_NAME"

# File 1
FILE_NAME="$DIR_NAME/001-The-Evolving-Role-of-Formatters.md"
cat <<EOF > "$FILE_NAME"
# The Evolving Role of Formatters

*   Prettier Roadmap & Upcoming Features
*   Alternatives & Competitors: Rome, dprint, Biome, StandardJS, etc.
EOF

# File 2
FILE_NAME="$DIR_NAME/002-Formatters-Across-Language-Ecosystems.md"
cat <<EOF > "$FILE_NAME"
# Formatters Across Language Ecosystems

*   Python: Black, Rust: rustfmt, Go: gofmt, etc.
*   Cross-language Consistency Challenges
EOF

echo "Structure created successfully in directory: $(pwd)"
```
