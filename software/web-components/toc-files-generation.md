Here is the bash script to generate the directory structure and files for your Web Components study guide.

To use this:
1.  Open your terminal in Ubuntu.
2.  Create a new file (e.g., `setup_study.sh`) or simply copy the code below.
3.  Paste the code into the terminal and press Enter.

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="WebComponents-Study"

# Create the root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating directory structure in $(pwd)..."

# --- Part I ---
DIR_NAME="001-Fundamentals-of-Component-Based-Architecture"
mkdir -p "$DIR_NAME"

# A. Introduction
cat << 'EOF' > "$DIR_NAME/001-Introduction-to-Web-Components-and-Encapsulation.md"
# Introduction to Web Components & Encapsulation

* The Problem: The "Div Soup" and Global Namespace Pollution
* The Solution: The Rise of Component-Based UI (React, Vue, Angular)
* The Promise of Web Components: A Native, Interoperable, Framework-Agnostic Standard
* Core Philosophy: Encapsulation, Reusability, and Composability
EOF

# B. Core Standards
cat << 'EOF' > "$DIR_NAME/002-The-Three-Core-Web-Component-Standards.md"
# The Three Core Web Component Standards

* **Custom Elements:** Defining new HTML tags with custom behavior (`customElements.define()`)
* **Shadow DOM:** Encapsulating markup and styles for isolation
* **HTML Templates & Slots:** Creating inert, reusable DOM fragments (`<template>` and `<slot>`)
EOF

# C. ES Modules
cat << 'EOF' > "$DIR_NAME/003-The-Fourth-Standard-ES-Modules.md"
# The "Fourth" Standard: ES Modules

* How ES Modules enable the packaging and distribution of Web Components
* Dynamic `import()` for lazy-loading components
EOF

# D. Comparison
cat << 'EOF' > "$DIR_NAME/004-Comparison-with-Frontend-Frameworks.md"
# Comparison with Frontend Frameworks

* Web Components vs. React/Vue/Angular Components
* Synergy: Using Web Components *inside* frameworks
* The Compiler Approach: Frameworks that generate Web Components (e.g., Stencil)
EOF


# --- Part II ---
DIR_NAME="002-Authoring-and-Designing-Components"
mkdir -p "$DIR_NAME"

# A. Design Principles
cat << 'EOF' > "$DIR_NAME/001-Component-Design-Principles-and-Strategy.md"
# Component Design Principles & Strategy

* Single Responsibility Principle for UI
* Designing a "Good" Public API (Properties, Attributes, Methods, Events)
* Composition over Inheritance
* Thinking in terms of a Component Tree
EOF

# B. Defining Custom Element
cat << 'EOF' > "$DIR_NAME/002-Defining-a-Custom-Element.md"
# Defining a Custom Element

* The `HTMLElement` base class
* The Component Class Structure (`constructor`, methods)
* Registering the element with `customElements.define()`
* Handling upgrades for elements already in the DOM
EOF

# C. Public API
cat << 'EOF' > "$DIR_NAME/003-Crafting-the-Components-Public-API-Surface.md"
# Crafting the Component's Public API Surface

* **Attributes (Declarative API):** For configuration from HTML
* **Properties (Imperative API):** For control from JavaScript
* **Attribute/Property Reflection:** Keeping them in sync
* **Public Methods:** Exposing actions (e.g., `myComponent.play()`)
* **Custom Events:** Communicating output and state changes to the outside world (`dispatchEvent`)
EOF

# D. Internal Markup
cat << 'EOF' > "$DIR_NAME/004-Structuring-Internal-Markup-with-Templates-and-Slots.md"
# Structuring Internal Markup with Templates and Slots

* Using `<template>` for initial, inert DOM
* Cloning and attaching the template content
* Using `<slot>` for content projection (Light DOM vs. Shadow DOM)
EOF


# --- Part III ---
DIR_NAME="003-Component-Internals-and-The-Lifecycle"
mkdir -p "$DIR_NAME"

# A. Lifecycle Callbacks
cat << 'EOF' > "$DIR_NAME/001-The-Custom-Element-Lifecycle-Callbacks.md"
# The Custom Element Lifecycle Callbacks

* `constructor()`: Element is created (but not yet in the DOM)
* `connectedCallback()`: Element is inserted into the DOM
* `disconnectedCallback()`: Element is removed from the DOM
* `attributeChangedCallback(name, oldValue, newValue)`: Reacting to attribute changes
* `adoptedCallback()`: Element is moved to a new document
EOF

# B. Mastering Shadow DOM
cat << 'EOF' > "$DIR_NAME/002-Mastering-the-Shadow-DOM.md"
# Mastering the Shadow DOM

* Creating and Attaching a Shadow Root (`attachShadow({ mode: 'open' | 'closed' })`)
* **Style Encapsulation:** The `:host`, `:host()`, and `:host-context()` pseudo-classes
* **DOM Encapsulation:** Event retargeting and understanding the shadow boundary
* Accessing the Shadow Root (`this.shadowRoot`)
EOF

# C. Advanced Templating
cat << 'EOF' > "$DIR_NAME/003-Advanced-Templating-with-Slots.md"
# Advanced Templating with Slots

* Default (Unnamed) Slots vs. Named Slots
* Styling Projected Content with `::slotted()`
* Detecting changes to slotted content with `slotchange` event
* Accessing slotted nodes via `slot.assignedNodes()`
EOF

# D. State & Rendering
cat << 'EOF' > "$DIR_NAME/004-Managing-State-and-Rendering.md"
# Managing State & Rendering

* Internal vs. Public State
* Triggering re-renders on state change
* Simple Rendering Patterns (e.g., setting `innerHTML`)
* Efficient DOM Diffing with helper libraries (e.g., `lit-html`)
EOF


# --- Part IV ---
DIR_NAME="004-Styling-and-Theming"
mkdir -p "$DIR_NAME"

# A. Challenge of Encapsulation
cat << 'EOF' > "$DIR_NAME/001-The-Challenge-of-Encapsulated-Styles.md"
# The Challenge of Encapsulated Styles

* Why global stylesheets don't pierce the Shadow DOM
* The benefits of style scoping
EOF

# B. Styling from Inside
cat << 'EOF' > "$DIR_NAME/002-Styling-from-the-Inside-Authors-Styles.md"
# Styling from the Inside (Author's Styles)

* Using `<style>` tags within the Shadow DOM
* Importing external stylesheets with `@import`
EOF

# C. Styling from Outside
cat << 'EOF' > "$DIR_NAME/003-Styling-from-the-Outside-Consumers-Styles.md"
# Styling from the Outside (Consumer's Styles)

* **CSS Custom Properties (Variables):** The primary theming mechanism
* **CSS Shadow Parts (`::part` and `::theme`):** Exposing specific internal elements for styling
* Inheritable CSS properties (e.g., `color`, `font-family`)
* Styling the host element itself as a regular tag
EOF

# D. Styling Strategies
cat << 'EOF' > "$DIR_NAME/004-Styling-Strategies-and-Patterns.md"
# Styling Strategies and Patterns

* Creating a theming API with Custom Properties
* Using Design Tokens
* Sharing styles between components (Constructable Stylesheets)
EOF


# --- Part V ---
DIR_NAME="005-Performance-Accessibility-and-Best-Practices"
mkdir -p "$DIR_NAME"

# A. Performance
cat << 'EOF' > "$DIR_NAME/001-Performance-Optimization.md"
# Performance Optimization

* Lazy-loading components with dynamic `import()`
* Efficient rendering strategies (avoiding unnecessary DOM manipulation)
* The performance benefits of Constructable Stylesheets
* Understanding paint/layout costs of component updates
EOF

# B. Accessibility
cat << 'EOF' > "$DIR_NAME/002-Accessibility-A11y.md"
# Accessibility (A11y)

* The Accessibility Object Model (AOM) and the Shadow DOM
* Managing Focus: `delegatesFocus` and manual focus management
* Using ARIA attributes and roles correctly within components
* Cross-root ARIA
EOF

# C. Form Participation
cat << 'EOF' > "$DIR_NAME/003-Form-Participation.md"
# Form Participation

* The `formAssociated` static property
* Using `ElementInternals` to make custom elements work like native form controls (`setFormValue`, `setValidity`)
EOF

# D. Data Flow
cat << 'EOF' > "$DIR_NAME/004-Data-Flow-Patterns.md"
# Data Flow Patterns

* One-way vs. Two-way data binding
* Parent-to-Child: via properties/attributes
* Child-to-Parent: via custom events
* Sibling/Global: via a shared service, event bus, or state management library
EOF


# --- Part VI ---
DIR_NAME="006-The-Component-Ecosystem-Tooling-and-Distribution"
mkdir -p "$DIR_NAME"

# A. Workflow
cat << 'EOF' > "$DIR_NAME/001-Development-Workflow-and-Authoring-Libraries.md"
# Development Workflow & Authoring Libraries

* Vanilla JavaScript vs. Helper Libraries
* Lightweight Libraries: Lit, Haunted
* Compilers: Stencil
* Development Servers and HMR (Vite, Snowpack, Web Dev Server)
EOF

# B. Testing
cat << 'EOF' > "$DIR_NAME/002-Testing-Strategies.md"
# Testing Strategies

* Unit Testing the component's class logic
* DOM/Integration Testing with a headless browser (Web Test Runner, Playwright, Cypress)
* Visual Regression Testing
* Accessibility Testing
EOF

# C. Building
cat << 'EOF' > "$DIR_NAME/003-Building-and-Publishing.md"
# Building and Publishing

* Bundling and minification for production (Rollup, esbuild)
* Publishing to a registry like NPM
* Defining package entry points (`exports` in `package.json`)
EOF

# D. Documentation
cat << 'EOF' > "$DIR_NAME/004-Documentation-and-Design-Systems.md"
# Documentation and Design Systems

* Using Storybook or similar tools for an interactive component library
* Auto-generating API documentation from comments (Custom Elements Manifest)
* Integrating Web Components as the foundation of a Design System
EOF


# --- Part VII ---
DIR_NAME="007-Advanced-Topics-and-The-Broader-Ecosystem"
mkdir -p "$DIR_NAME"

# A. Framework Interop
cat << 'EOF' > "$DIR_NAME/001-Framework-Interoperability-In-Depth.md"
# Framework Interoperability In-Depth

* The challenges of properties vs. attributes in frameworks like React
* Handling custom events across different frameworks
* Using wrapper components for a smoother developer experience
* Custom Element Registries like `custom-elements-everywhere.com`
EOF

# B. SSR
cat << 'EOF' > "$DIR_NAME/002-Server-Side-Rendering-SSR-of-Web-Components.md"
# Server-Side Rendering (SSR) of Web Components

* The hydration problem
* **Declarative Shadow DOM:** Enabling SSR and non-JS rendering
* Framework-specific SSR solutions for Web Components
EOF

# C. Emerging APIs
cat << 'EOF' > "$DIR_NAME/003-Emerging-and-Advanced-APIs.md"
# Emerging and Advanced APIs

* **Scoped Custom Element Registries:** Avoiding global naming collisions
* **Constructable Stylesheets:** Sharing CSSStyleSheet objects for performance
* **Customized Built-in Elements (`extends`):** The state and controversy of this feature
EOF

# D. Future
cat << 'EOF' > "$DIR_NAME/004-The-Future-and-Broader-Context.md"
# The Future and Broader Context

* Web Components in Micro-Frontends
* CSS Module Scripts and Import Assertions
* Integration with emerging browser APIs (Container Queries, etc.)
EOF

echo "Done! Structure created in '$ROOT_DIR'."
```
