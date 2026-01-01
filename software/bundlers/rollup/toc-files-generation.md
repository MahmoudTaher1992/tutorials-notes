Here is the bash script to generate the directory and file structure for your **Rollup** study guide.

You can save this code as `setup_rollup_study.sh`, make it executable with `chmod +x setup_rollup_study.sh`, and run it.

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="Rollup-Study"

# Create the root directory
mkdir -p "$ROOT_DIR"
echo "Created root directory: $ROOT_DIR"

# ---------------------------------------------------------
# Part I: Fundamentals of Module Bundling
# ---------------------------------------------------------
PART_DIR="$ROOT_DIR/001-Fundamentals-of-Module-Bundling"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-The-Evolution-of-JavaScript-Modules.md"
# The Evolution of JavaScript Modules

* Script Tags and Global Scope
* IIFE and Immediately-Invoked Function Patterns
* CommonJS: require, module.exports (Node.js)
* AMD and UMD Patterns
* ES6 Modules: import/export Syntax
EOF

# Section B
cat <<EOF > "$PART_DIR/002-The-Need-for-Bundling.md"
# The Need for Bundling in Modern Web Apps

* Module Proliferation and HTTP Requests
* Code Splitting and Performance Considerations
* Dependency Management Challenges
* Polyfills, Transpiling, and ESNext Compatibility
EOF

# Section C
cat <<EOF > "$PART_DIR/003-Overview-of-Module-Bundlers.md"
# Overview of Module Bundlers

* What is a Bundler? Concatenation vs. Understanding Imports
* Types: Rollup, Webpack, Parcel, esbuild, Vite (and comparison)
* Key Features: Tree-Shaking, Code-Splitting, Asset Management
EOF

# ---------------------------------------------------------
# Part II: Core Concepts of Rollup
# ---------------------------------------------------------
PART_DIR="$ROOT_DIR/002-Core-Concepts-of-Rollup"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Introduction-to-Rollup.md"
# Introduction to Rollup

* Rollup Philosophy: Minimal, Modern, ES Modules First
* Intended Use Cases: Libraries vs. Applications
* Supported Module Formats: ES, CommonJS, IIFE, UMD, SystemJS
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Key-Features-of-Rollup.md"
# Key Features of Rollup

* Tree-Shaking: Dead Code Elimination
* Output Formats and Compatibility
* Plugins Architecture and Ecosystem
* Source Maps Support
* Code Splitting and Dynamic Imports
EOF

# Section C
cat <<EOF > "$PART_DIR/003-How-Rollups-Bundling-Works.md"
# How Rollup's Bundling Works

* Graph Building: Entry Points and Dependency Resolution
* Static Analysis of ES Modules
* Import/Export Hoisting and Rewriting
* Chunking and Code Splitting Process
* Treeshake Phase: How Unused Exports are Pruned
EOF

# ---------------------------------------------------------
# Part III: Rollup Configuration
# ---------------------------------------------------------
PART_DIR="$ROOT_DIR/003-Rollup-Configuration"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Rollup-CLI-vs-JS-API.md"
# Rollup CLI vs. JavaScript API

* CLI Basics: Single-file Bundles
* Using rollup.config.js for Complex Builds
* Multi-Input and Multi-Output Support
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Anatomy-of-rollup-config-js.md"
# Anatomy of rollup.config.js

* Input Options (input, plugins, external)
* Output Options (file, dir, format, sourcemap, name, exports)
* External Dependencies: external, globals Mapping
* Watch Mode and Rebuild Strategies
* Environment Variables and Cross-Env Support
EOF

# Section C
cat <<EOF > "$PART_DIR/003-Common-Use-Cases.md"
# Common Use Cases

* Bundling a JavaScript Library (npm publish)
* Bundling for Browsers vs. Node.js
* Bundling for Multiple Module Formats (ESM, CJS, IIFE)
* Integrating Rollup with TypeScript
* Monorepo and Multi-Package Strategies
EOF

# ---------------------------------------------------------
# Part IV: Rollup Plugins Ecosystem
# ---------------------------------------------------------
PART_DIR="$ROOT_DIR/004-Rollup-Plugins-Ecosystem"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Plugin-Architecture-Overview.md"
# Plugin Architecture Overview

* What Can Plugins Do? (Loaders/Transformers/Resolvers)
* Writing a Custom Rollup Plugin (Hook Lifecycle)
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Essential-Rollup-Plugins.md"
# Essential Rollup Plugins

* @rollup/plugin-node-resolve (resolving node_modules)
* @rollup/plugin-commonjs (converting CJS to ES modules)
* @rollup/plugin-json (importing JSON)
* @rollup/plugin-replace (environment variables)
* @rollup/plugin-alias (path aliasing)
* @rollup/plugin-babel/Typescript/Sucrase (transpilation support)
* rollup-plugin-terser (minification)
* PostCSS, SCSS, and CSS Support Plugins
* Asset Importers: Images, SVG, etc.
EOF

# Section C
cat <<EOF > "$PART_DIR/003-Advanced-Plugin-Patterns.md"
# Advanced Plugin Patterns

* Conditional Plugins and Build Modes
* Custom Plugin Pipelines (pre/post hooks)
* Troubleshooting Plugin Conflicts
EOF

# ---------------------------------------------------------
# Part V: Advanced Bundling Techniques & Optimizations
# ---------------------------------------------------------
PART_DIR="$ROOT_DIR/005-Advanced-Bundling-Techniques-Optimizations"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Tree-Shaking-Mastery.md"
# Tree-Shaking Mastery

* How Rollup Determines Dead Code
* Marking Side Effects and Pure Functions (sideEffects: false)
* Dynamic Imports and Lazy Loading
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Code-Splitting-in-Rollup.md"
# Code Splitting in Rollup

* Multi-Entry Builds and Output Chunks
* Shared Dependencies among Chunks
* Manual Chunking and Optimization Techniques
* Interoperation with Dynamic Imports
EOF

# Section C
cat <<EOF > "$PART_DIR/003-Output-Customization-Asset-Handling.md"
# Output Customization & Asset Handling

* Output Naming, Hashing, and Asset Renaming
* Emitting Additional Assets (CSS, Images)
* Injecting Banners/Footers and License Comments
* Bundle Analysis Tools and Visualizers
EOF

# Section D
cat <<EOF > "$PART_DIR/004-Build-Performance-and-CI.md"
# Build Performance and CI Integration

* Optimizing Plugin Usage and Caching
* Parallelization and Worker Threads
* Continuous Integration Recipes (GitHub Actions, GitLab, etc.)
EOF

# ---------------------------------------------------------
# Part VI: Rollup in Real-World Projects
# ---------------------------------------------------------
PART_DIR="$ROOT_DIR/006-Rollup-in-Real-World-Projects"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Bundling-JavaScript-Libraries.md"
# Bundling JavaScript Libraries

* Publishing ES Modules and Legacy Formats
* Peer Dependencies vs. Bundled Dependencies
* Type Declarations for TypeScript Libraries
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Bundling-for-App-Development.md"
# Bundling for App Development

* Rollup vs. Webpack/Vite for Single-Page Applications
* Using Rollup with Frameworks (Svelte, React, Vue)
* Integrating CSS/PostCSS and CSS-in-JS Workflows
* Integrating Service Workers and PWA Support
EOF

# Section C
cat <<EOF > "$PART_DIR/003-Hybrid-and-Micro-Frontend-Architectures.md"
# Hybrid and Micro-Frontend Architectures

* Exposing Modules for Consumption (e.g., via SystemJS or Module Federation)
* Building Widgets/Embeddable Components
EOF

# ---------------------------------------------------------
# Part VII: Troubleshooting, Debugging, and Best Practices
# ---------------------------------------------------------
PART_DIR="$ROOT_DIR/007-Troubleshooting-Debugging-Best-Practices"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Debugging-Common-Issues.md"
# Debugging Common Issues

* Resolving Module Not Found Errors
* Troubleshooting Tree-Shaking: Why Isn't Code Removed?
* Fixing Sourcemap Issues
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Best-Practices-for-Reliable-Builds.md"
# Best Practices for Reliable Builds

* Dependency Versioning and Lockfiles
* Clean Script and Cache Busting Strategies
* Maintaining a Stable Plugin Stack
EOF

# Section C
cat <<EOF > "$PART_DIR/003-Security-Considerations.md"
# Security Considerations

* Handling Untrusted Dependencies
* Supply Chain Vulnerabilities (npm audit, Snyk)
* Securely Bundling Third-Party Codes
EOF

# ---------------------------------------------------------
# Part VIII: Rollup Ecosystem, Community, and Future Directions
# ---------------------------------------------------------
PART_DIR="$ROOT_DIR/008-Rollup-Ecosystem-Community-Future"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Rollup-vs-Other-Bundlers.md"
# Rollup vs. Other Modern Bundlers

* Feature Comparison (Tree-Shaking, Plugin Ecosystem, Build Performance)
* Choosing the Right Bundler for Different Use Cases
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Community-and-Learning-Resources.md"
# Rollup Community and Learning Resources

* Official Docs, Recipes, and Guides
* Community Plugins and Starters
EOF

# Section C
cat <<EOF > "$PART_DIR/003-The-Future-of-Module-Bundling.md"
# The Future of Module Bundling

* Native ES Modules in Browsers
* ESBuild, SWC, and Rollup’s Place in the Evolving Toolchain
* Emerging Patterns (Micro-Frontends, Package Exports Fields)
EOF

echo "--------------------------------------------------------"
echo "Rollup Study Guide Structure Created Successfully!"
echo "Location: $(pwd)/$ROOT_DIR"
echo "--------------------------------------------------------"
```
