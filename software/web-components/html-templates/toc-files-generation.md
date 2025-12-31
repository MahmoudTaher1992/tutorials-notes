Here is the bash script to generate the directory and file structure based on your Table of Contents.

To use this:
1.  Copy the code block below.
2.  Save it as a file (e.g., `setup_study.sh`).
3.  Make it executable: `chmod +x setup_study.sh`
4.  Run it: `./setup_study.sh`

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="Web-Components-Study"

# Create the root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating directory structure in $(pwd)..."

# --- Part I ---
DIR="001-Fundamentals-of-Component-Based-Web"
mkdir -p "$DIR"

# I.A
cat <<EOF > "$DIR/001-The-Why-of-Web-Components.md"
# A. The "Why" of Web Components: The Motivation

* The Pre-Component Era: "Div Soup" and jQuery Plugins
* The Problem: Lack of Encapsulation, Reusability, and Interoperability
* Component Model as a Solution: A Brief Comparison with Framework Components (React, Vue, Angular)
* The Goal: Browser-Native, Encapsulated, and Reusable UI Primitives
EOF

# I.B
cat <<EOF > "$DIR/002-The-Core-Technologies.md"
# B. The Core Technologies: The "What"

* Introduction to the Three Pillars of Web Components
* **Custom Elements:** Defining your own HTML tags
* **Shadow DOM:** Encapsulating markup and styles
* **HTML Templates:** Defining inert chunks of markup for later use
* The Unsung Hero: ES Modules for Definition and Distribution
EOF

# I.C
cat <<EOF > "$DIR/003-Anatomy-of-a-Simple-Web-Component.md"
# C. The Anatomy of a Simple Web Component

* Basic File Structure (\`my-component.js\`)
* Defining a Class that \`extends HTMLElement\`
* Registering the Component with \`customElements.define()\`
* A "Hello World" Example: From Definition to Usage in HTML
EOF

# --- Part II ---
DIR="002-Designing-Components-Public-API"
mkdir -p "$DIR"

# II.A
cat <<EOF > "$DIR/001-Component-Interface-and-State.md"
# A. Component Interface & State

* Attributes vs. Properties: The HTML/JS Divide
    * Mapping Attributes to Properties
    * Observing Attribute Changes with \`observedAttributes\` and \`attributeChangedCallback\`
* Exposing Public Methods for Imperative Control
* Emitting Custom Events to Communicate Outwards (\`new CustomEvent()\`)
EOF

# II.B
cat <<EOF > "$DIR/002-Content-Projection-with-Slots.md"
# B. Content Projection with Slots

* The Concept of "Light DOM" vs. "Shadow DOM"
* Using the \`<slot>\` Element for Content Distribution
* Default Slots and Fallback Content
* Named Slots for Structured Content Injection
EOF

# II.C
cat <<EOF > "$DIR/003-Styling-API-and-Theming.md"
# C. Styling API and Theming

* The Encapsulation Boundary: How CSS is Scoped by Shadow DOM
* CSS Custom Properties (Variables) for Theming
* The \`::part()\` and \`::slotted()\` CSS Pseudo-Elements for Exposing Style Hooks
* Inheritable vs. Non-Inheritable Styles Across the Shadow Boundary
EOF

# II.D
cat <<EOF > "$DIR/004-Designing-for-Accessibility.md"
# D. Designing for Accessibility (A11y)

* Using ARIA Roles, States, and Properties within the Component
* Managing Focus within the Shadow DOM
* Associating Labels with Form-Associated Components
EOF

# --- Part III ---
DIR="003-Core-Technology-Deep-Dive"
mkdir -p "$DIR"

# III.A
cat <<EOF > "$DIR/001-Custom-Elements.md"
# A. Custom Elements

* **Lifecycle Callbacks**
    * \`constructor()\`: Element is created
    * \`connectedCallback()\`: Element is inserted into the DOM
    * \`disconnectedCallback()\`: Element is removed from the DOM
    * \`adoptedCallback()\`: Element is moved to a new document
* Autonomous Custom Elements (e.g., \`<my-element>\`)
* Customized Built-in Elements (e.g., \`<button is="my-button">\`) and their Status
EOF

# III.B
cat <<EOF > "$DIR/002-Shadow-DOM.md"
# B. Shadow DOM

* Creating a Shadow Root: \`attachShadow({ mode: 'open' | 'closed' })\`
* Understanding the Shadow Boundary
* Event Retargeting and Bubbling Across the Boundary
* Styling the Host Element from Within: The \`:host\` Pseudo-class
* Conditional Host Styling: \`:host()\` and \`:host-context()\`
EOF

# III.C
cat <<EOF > "$DIR/003-HTML-Templates-and-Cloning.md"
# C. HTML Templates & Cloning

* **The \`<template>\` Element**
    * Properties: Inert by Default (Not Rendered, No Scripts Run)
    * Accessing the Content via the \`.content\` Property (\`DocumentFragment\`)
* **Cloning and Instantiation**
    * \`template.content.cloneNode(true)\`: The Standard Pattern
    * Populating and Attaching the Cloned Content to the Shadow Root
* **Combining Templates and Slots**
    * Defining a Component's Structure in a \`<template>\`
    * Placing \`<slot>\` elements inside the template as content placeholders
    * A Complete Workflow: Define in \`<template>\`, Clone, Attach to Shadow DOM
EOF

# --- Part IV ---
DIR="004-Advanced-Concepts-and-Patterns"
mkdir -p "$DIR"

# IV.A
cat <<EOF > "$DIR/001-State-Management.md"
# A. State Management

* Simple Property/Attribute-Based State
* Internal Reactive Properties (Triggering Re-renders)
* Integrating with External State Management Libraries
EOF

# IV.B
cat <<EOF > "$DIR/002-Forms-and-User-Input.md"
# B. Forms and User Input

* The Challenge: Making Custom Elements Participate in Forms
* The \`ElementInternals\` Object and Form-Associated Custom Elements
* Setting Validity, Validation Messages, and Form Values
EOF

# IV.C
cat <<EOF > "$DIR/003-Performance-Optimization.md"
# C. Performance Optimization

* Lazy Loading Component Definitions
* Strategies for Rendering Large Lists of Components
* The Cost of Shadow DOM and When to Avoid It
EOF

# IV.D
cat <<EOF > "$DIR/004-Interoperability-with-Frameworks.md"
# D. Interoperability with Frameworks

* Using Web Components in React, Vue, Angular, and Svelte
* Handling Data Binding (Properties vs. Attributes)
* Listening to Custom Events in Different Frameworks
* The Role of Wrapper Components
EOF

# --- Part V ---
DIR="005-Web-Component-Ecosystem-and-Tooling"
mkdir -p "$DIR"

# V.A
cat <<EOF > "$DIR/001-Development-and-Build-Tooling.md"
# A. Development and Build Tooling

* Project Scaffolding (Vite, Open-WC)
* Linting and Formatting Configurations
* Bundling for Production (Rollup, Webpack)
* Generating Custom Elements Manifests for IDEs
EOF

# V.B
cat <<EOF > "$DIR/002-Helper-Libraries-and-Frameworks.md"
# B. Helper Libraries and Frameworks

* Lit: Google's Lightweight Library for Boilerplate Reduction and Reactivity
* Stencil: A Compiler that Generates Standards-Compliant Web Components
* Hybrids, Atomico, and others
EOF

# V.C
cat <<EOF > "$DIR/003-Testing-Strategies.md"
# C. Testing Strategies

* Unit Testing Component Logic (e.g., with Vitest, Jest)
* DOM-based Integration Testing in a Browser (Web Test Runner, Playwright, Cypress)
* Visual Regression Testing
* Testing for Accessibility
EOF

# V.D
cat <<EOF > "$DIR/004-Documentation-and-Publishing.md"
# D. Documentation and Publishing

* Interactive Documentation with Storybook or Custom Tools
* Publishing to NPM (as ES Modules)
* Versioning and Dependency Management
EOF

# --- Part VI ---
DIR="006-Architecture-and-The-Future"
mkdir -p "$DIR"

# VI.A
cat <<EOF > "$DIR/001-Web-Components-in-Broader-Context.md"
# A. Web Components in a Broader Context

* Building Design Systems with Web Components
* Micro-Frontends Architecture with Web Components as the Integration Layer
* Server-Side Rendering (SSR) and Declarative Shadow DOM
EOF

# VI.B
cat <<EOF > "$DIR/002-Emerging-Standards-and-Future.md"
# B. Emerging Standards and the Future

* Scoped Custom Element Registries
* CSS Module Scripts and Import Assertions
* The Evolving Landscape of Web Standards
EOF

echo "Done! Directory structure created in '$ROOT_DIR'."
```
