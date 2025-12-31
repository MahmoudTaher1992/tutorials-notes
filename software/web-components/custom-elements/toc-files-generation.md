Here is the bash script to generate the directory and file structure for your **Custom Elements** study guide.

### How to use this script:
1.  Open your terminal in Ubuntu.
2.  Create a new file, for example: `nano create_study_guide.sh`
3.  Paste the code below into that file.
4.  Save and exit (Ctrl+O, Enter, Ctrl+X).
5.  Make the script executable: `chmod +x create_study_guide.sh`
6.  Run the script: `./create_study_guide.sh`

The script will create a root folder named **`Custom-Elements-Study`** containing all the necessary directories and markdown files with the TOC content pre-filled.

```bash
#!/bin/bash

# Define the root directory name
ROOT="Custom-Elements-Study"

# Create the root directory
mkdir -p "$ROOT"
cd "$ROOT" || exit

echo "Creating directory structure for: $ROOT..."

# ==============================================================================
# PART I: Fundamentals of Component-Based Architecture & Web Components
# ==============================================================================
DIR_01="001-Fundamentals-Component-Architecture"
mkdir -p "$DIR_01"

# File A
cat <<EOF > "$DIR_01/001-Introduction-to-Modern-UI-Development.md"
# Introduction to Modern UI Development

* The Declarative vs. Imperative UI Paradigm
* The Need for Encapsulation, Reusability, and Interoperability
* A Brief History: From jQuery plugins to Framework Components (React, Vue, Angular)
EOF

# File B
cat <<EOF > "$DIR_01/002-The-Web-Components-Suite.md"
# The Web Components Suite: A Standardized Approach

* The Philosophy: "Use the platform"
* The Four Core Specifications
    * **Custom Elements:** For creating new HTML tags with custom behavior.
    * **Shadow DOM:** For encapsulated styling and markup.
    * **HTML Templates (\`<template>\`):** For inert, reusable DOM fragments.
    * **ES Modules:** For defining and sharing components.
EOF

# File C
cat <<EOF > "$DIR_01/003-Defining-Custom-Elements-Core-API.md"
# Defining Custom Elements: The Core API

* The Two Types of Custom Elements
    * Autonomous Custom Elements (e.g., \`<my-element>\`)
    * Customized Built-in Elements (e.g., \`<button is="my-button">\`) - *Note on status/support*
* The Custom Element Registry: \`customElements.define()\`
* The Element Class: Extending \`HTMLElement\`
* Rules for Naming and Construction
EOF

# File D
cat <<EOF > "$DIR_01/004-Comparison-with-JavaScript-Frameworks.md"
# Comparison with JavaScript Frameworks

* Web Components vs. React/Vue/Svelte Components
* Strengths: Interoperability, Longevity, Standardization
* Weaknesses: Verbosity, State Management, Rendering Optimizations (by default)
* Synergy: Using Web Components *within* Frameworks
EOF


# ==============================================================================
# PART II: Component Design & Public API
# ==============================================================================
DIR_02="002-Component-Design-and-Public-API"
mkdir -p "$DIR_02"

# File A
cat <<EOF > "$DIR_02/001-Component-Design-Principles.md"
# Component Design Principles

* Single Responsibility Principle
* Designing for Composability and Reusability
* API-First Design: Defining the "Contract" of Your Component
EOF

# File B
cat <<EOF > "$DIR_02/002-Defining-Public-API-Properties-Attributes.md"
# Defining the Public API: Properties, Attributes, and Methods

* **Attributes (The HTML API):** For declarative configuration, primitive data.
* **Properties (The JavaScript API):** For complex data (objects, arrays) and imperative control.
* Synchronizing Attributes and Properties (Observed Attributes & Getters/Setters)
EOF

# File C
cat <<EOF > "$DIR_02/003-Defining-Public-API-Events-and-Slots.md"
# Defining the Public API: Events and Slots

* **Custom Events:** Communicating outwards (\`new CustomEvent\`, \`this.dispatchEvent\`)
* **Slots (\`<slot>\`):** For content projection and composition (Light DOM vs. Shadow DOM).
    * Default Slots
    * Named Slots
EOF

# File D
cat <<EOF > "$DIR_02/004-State-Management.md"
# State Management

* Internal (Private) State vs. Public Properties
* Simple State Management with Properties and Re-rendering
* Approaches for Complex State (e.g., integration with external stores)
EOF


# ==============================================================================
# PART III: Implementation: Lifecycle, Rendering, and Styling
# ==============================================================================
DIR_03="003-Implementation-Lifecycle-Rendering-Styling"
mkdir -p "$DIR_03"

# File A
cat <<EOF > "$DIR_03/001-Custom-Element-Lifecycle-Callbacks.md"
# The Custom Element Lifecycle Callbacks

* \`constructor()\`: Element initialization (before DOM attachment).
* \`connectedCallback()\`: Element inserted into the DOM. (For setup, fetching data, adding listeners).
* \`disconnectedCallback()\`: Element removed from the DOM. (For cleanup, removing listeners).
* \`attributeChangedCallback(name, oldValue, newValue)\`: An observed attribute has changed.
* \`adoptedCallback()\`: Element moved to a new document.
EOF

# File B
cat <<EOF > "$DIR_03/002-Rendering-Strategies-and-Shadow-DOM.md"
# Rendering Strategies and the Shadow DOM

* Direct DOM Manipulation (e.g., \`this.innerHTML\`, \`this.appendChild\`)
* Using \`<template>\` for Performance and Structure
* **Deep Dive into Shadow DOM:**
    * Creating a Shadow Root (\`this.attachShadow({ mode: 'open' | 'closed' })\`)
    * Benefits: Style Encapsulation, DOM Encapsulation
    * Interaction between Light DOM (user content) and Shadow DOM (component internals)
EOF

# File C
cat <<EOF > "$DIR_03/003-Styling-the-Component.md"
# Styling the Component

* The Power and Limits of Encapsulated Styles
* Styling the Component Itself: The \`:host\` Pseudo-class
* Styling Projected Content: The \`::slotted()\` Pseudo-element
* Creating a Styling API with CSS Custom Properties
* Styling with "Shadow Parts": The \`::part()\` Pseudo-element
EOF


# ==============================================================================
# PART IV: Interoperability & Accessibility
# ==============================================================================
DIR_04="004-Interoperability-and-Accessibility"
mkdir -p "$DIR_04"

# File A
cat <<EOF > "$DIR_04/001-Framework-Integration.md"
# Framework Integration

* Using Custom Elements in React (Gotchas with properties vs. attributes, event handling)
* Using Custom Elements in Vue, Svelte, and Angular
* Wrapper Libraries and Patterns
EOF

# File B
cat <<EOF > "$DIR_04/002-Form-Participation.md"
# Form Participation

* Creating Form-Associated Custom Elements (\`static formAssociated = true\`)
* The \`ElementInternals\` API: \`setFormValue()\`, \`setValidity()\`, access to the parent form.
* Implementing validation, labels, and form submission behavior.
EOF

# File C
cat <<EOF > "$DIR_04/003-Accessibility-A11y.md"
# Accessibility (A11y)

* The Accessibility Object Model (AOM)
* Using ARIA roles, states, and properties (\`this.setAttribute('role', ...)\`).
* Managing Focus within the Shadow DOM (\`delegatesFocus: true\`).
* Keyboard Navigation and Interaction Patterns.
EOF


# ==============================================================================
# PART V: Performance & Optimization
# ==============================================================================
DIR_05="005-Performance-and-Optimization"
mkdir -p "$DIR_05"

# File A
cat <<EOF > "$DIR_05/001-Rendering-Performance.md"
# Rendering Performance

* Efficient DOM Updates (avoiding re-creating the entire Shadow DOM)
* Batching DOM changes
* Using libraries like \`lit-html\` for efficient rendering.
EOF

# File B
cat <<EOF > "$DIR_05/002-Loading-Performance.md"
# Loading Performance

* Code Splitting and Lazy Loading
* Defining components only when they are needed (Dynamic \`import()\`).
* The "Auto-defining" Element Pattern.
EOF

# File C
cat <<EOF > "$DIR_05/003-Memory-Management.md"
# Memory Management

* Proper Cleanup in \`disconnectedCallback\`
* Avoiding memory leaks from event listeners and object references.
EOF


# ==============================================================================
# PART VI: Ecosystem: Tooling, Testing & Distribution
# ==============================================================================
DIR_06="006-Ecosystem-Tooling-Testing-Distribution"
mkdir -p "$DIR_06"

# File A
cat <<EOF > "$DIR_06/001-Development-and-Build-Tooling.md"
# Development and Build Tooling

* Starter Kits and Dev Servers (Vite, Snowpack, Web Dev Server)
* Helper Libraries vs. Full Abstractions
    * **Libraries (Lit, Haunted):** Lightweight helpers for boilerplate.
    * **Compilers (Stencil):** Framework-like experience that outputs standard Web Components.
EOF

# File B
cat <<EOF > "$DIR_06/002-Testing-Strategies.md"
# Testing Strategies

* Unit Testing component logic (methods, state changes).
* DOM-based Testing: Verifying rendering, attributes, and events.
* Using testing frameworks like Web Test Runner, Jest with JSDOM, Playwright, Cypress.
* Visual Regression Testing.
EOF

# File C
cat <<EOF > "$DIR_06/003-Documentation-and-DevEx.md"
# Documentation and Developer Experience (DevEx)

* Auto-generating documentation from JSDoc comments (\`custom-elements-manifest\`).
* Interactive Component Showcases (Storybook, Web Component DevTools).
EOF

# File D
cat <<EOF > "$DIR_06/004-Distribution-and-Versioning.md"
# Distribution and Versioning

* Publishing to NPM
* Semantic Versioning (SemVer) for component libraries.
* Providing type definitions (\`.d.ts\`) for TypeScript users.
EOF


# ==============================================================================
# PART VII: Advanced & Emerging Topics
# ==============================================================================
DIR_07="007-Advanced-and-Emerging-Topics"
mkdir -p "$DIR_07"

# File A
cat <<EOF > "$DIR_07/001-Advanced-Rendering-and-Styling.md"
# Advanced Rendering & Styling

* **Declarative Shadow DOM:** For Server-Side Rendering (SSR).
* **Constructible Stylesheets:** Sharing CSS styles between multiple components efficiently.
EOF

# File B
cat <<EOF > "$DIR_07/002-Broader-Architectural-Context.md"
# Broader Architectural Context

* **Micro-Frontends:** Using Web Components as a framework-agnostic integration layer.
* **Design Systems:** Building a standardized, reusable component library for an organization.
EOF

# File C
cat <<EOF > "$DIR_07/003-Future-of-Web-Components.md"
# The Future of Web Components & Related APIs

* CSS Module Scripts
* Scoped Element Registries
* The \`popover\` attribute and its interaction with components.
EOF

echo "Done! Directory structure created in: $(pwd)"
```
