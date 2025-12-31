Here is the bash script to generate the directory and file structure for your Shadow DOM study guide.

Copy the code below, save it as a file (e.g., `create_structure.sh`), give it execution permissions (`chmod +x create_structure.sh`), and run it (`./create_structure.sh`).

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="Shadow-DOM-Study"

# Create the root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating directory structure in $ROOT_DIR..."

# ==============================================================================
# Part I: Fundamentals of Component Encapsulation & The DOM
# ==============================================================================
PART_DIR="001-Fundamentals-Component-Encapsulation"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-The-Problem.md"
# The Problem: The Global Nature of the Web

* The "Global Namespace" Problem: CSS and JavaScript Collisions
* Leaky Abstractions and Unintended Side Effects
* The Document Object Model (DOM) as a Single, Shared Tree
* Historical Approaches to Encapsulation
    * Naming Conventions (e.g., BEM)
    * iframes and their limitations
    * Build-time solutions (CSS Modules, CSS-in-JS)
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Intro-Web-Components.md"
# Introduction to Web Components

* The Philosophy: Browser-Native, Interoperable, Reusable Components
* The Three Core Specifications
    * Custom Elements: Defining new HTML tags
    * **Shadow DOM: Encapsulating markup, style, and behavior**
    * HTML Templates: Efficiently stamping out DOM
EOF

# Section C
cat <<EOF > "$PART_DIR/003-Defining-Shadow-DOM.md"
# Defining the Shadow DOM

* Core Concepts: Encapsulation, Scoping, and Composition
* The Shadow Boundary: The "Magic Wall" between the Light DOM and Shadow DOM
* Key Terminology
    * Shadow Host: The element the Shadow DOM is attached to
    * Shadow Root: The root node of the hidden DOM subtree
    * Shadow Tree: The DOM nodes inside the Shadow Root
    * Light DOM: The regular child nodes of the Shadow Host
EOF

# ==============================================================================
# Part II: Core APIs & Mechanics
# ==============================================================================
PART_DIR="002-Core-APIs-Mechanics"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Creating-Attaching.md"
# Creating and Attaching a Shadow Root

* The \`Element.attachShadow()\` Method
* Modes: \`open\` vs. \`closed\`
    * \`open\`: The Shadow Root is accessible from outside via \`element.shadowRoot\`
    * \`closed\`: The Shadow Root is inaccessible (\`element.shadowRoot\` returns \`null\`)
    * Implications and Best Practices (Why \`open\` is almost always preferred)
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Manipulating-Shadow-Tree.md"
# Manipulating the Shadow Tree

* Populating the Shadow DOM with content (\`innerHTML\`, \`appendChild\`, etc.)
* Querying within the Shadow Root (\`shadowRoot.querySelector()\`)
* The Role of \`<template>\` for performant DOM creation
EOF

# Section C
cat <<EOF > "$PART_DIR/003-Composition-Slots.md"
# Composition with Slots

* The \`<slot>\` Element: Creating "holes" for Light DOM content
* The Default Slot (Unnamed)
* Named Slots (\`<slot name="...">\`)
* Assigning Light DOM to Slots (\`element.slot = "..."\`)
* The \`slotchange\` Event: Reacting to changes in distributed nodes
* Fallback Content for Slots
EOF

# ==============================================================================
# Part III: Styling & CSS Scoping
# ==============================================================================
PART_DIR="003-Styling-CSS-Scoping"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Power-Style-Encapsulation.md"
# The Power of Style Encapsulation

* Styles defined inside the Shadow DOM do not leak out
* Styles from the outside document (Light DOM) do not bleed in (with exceptions)
* The \`!important\` rule stops at the Shadow Boundary
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Styling-Host.md"
# Styling the Host Element from Within

* The \`:host\` Pseudo-class
* Conditional Host Styling (e.g., \`:host(.active)\`, \`:host([disabled])\`)
* The \`:host-context()\` Pseudo-class (Styling based on an ancestor's state)
EOF

# Section C
cat <<EOF > "$PART_DIR/003-Styling-Distributed-Content.md"
# Styling Distributed (Slotted) Content

* The \`::slotted()\` Pseudo-element
* Limitations and Specificity (Can only style the top-level slotted element)
EOF

# Section D
cat <<EOF > "$PART_DIR/004-Public-Styling-API.md"
# Designing a Public Styling API (Theming)

* **Method 1: CSS Custom Properties (Variables)**
    * How they pierce the Shadow Boundary (by design)
    * Defining a default and allowing overrides
    * The most common and flexible theming pattern
* **Method 2: \`::part\` and \`::theme\` (deprecated)**
    * Exposing specific internal elements for external styling (\`part="..."\` attribute)
    * The \`::part()\` Pseudo-element for targeting exposed parts
* Inheritable CSS Properties (e.g., \`color\`, \`font-family\`)
EOF

# ==============================================================================
# Part IV: Events & Data Flow
# ==============================================================================
PART_DIR="004-Events-Data-Flow"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Shadow-Boundary-Events.md"
# The Shadow Boundary's Effect on Events

* Event Retargeting: How \`event.target\` is adjusted for encapsulation
* Bubbling and Composition
    * \`composed: false\` (Default for most): Events do not cross the Shadow Boundary
    * \`composed: true\`: Events can bubble out of the Shadow DOM into the Light DOM
* The \`Event.composedPath()\` method to see the true event path
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Communication-Patterns.md"
# Communication Patterns

* Dispatching Custom Events (\`new CustomEvent(...)\` with \`{composed: true, bubbles: true}\`)
* Data In: Using HTML Attributes and JavaScript Properties
* Data Out: Using Events
* Callbacks and other advanced patterns
EOF

# ==============================================================================
# Part V: Advanced Concepts & Real-World Patterns
# ==============================================================================
PART_DIR="005-Advanced-Concepts"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Accessibility-AOM.md"
# Accessibility (AOM)

* Focus Management and the Shadow Boundary (\`delegatesFocus: true\` option)
* Cross-root ARIA relationships (\`aria-labelledby\` referencing elements outside the shadow root)
* The Accessibility Object Model (AOM)
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Working-With-Forms.md"
# Working with Forms

* The \`ElementInternals\` object
* Making a Custom Element form-associated (\`static formAssociated = true\`)
* Setting validity, value, and interacting with \`<form>\`
EOF

# Section C
cat <<EOF > "$PART_DIR/003-Performance-Considerations.md"
# Performance Considerations

* Render Performance: When and how Shadow DOM affects paint times
* Memory Usage
* Best practices for large or complex components
EOF

# Section D
cat <<EOF > "$PART_DIR/004-SSR-Declarative-Shadow-DOM.md"
# Server-Side Rendering (SSR) & Declarative Shadow DOM

* The Problem: Hydrating Shadow DOM on the client
* The Solution: Declarative Shadow DOM (\`<template shadowrootmode="open">\`)
* Benefits for SEO and First Contentful Paint (FCP)
EOF

# ==============================================================================
# Part VI: Ecosystem, Tooling & Implementation
# ==============================================================================
PART_DIR="006-Ecosystem-Tooling"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Frameworks-Libraries.md"
# Frameworks & Libraries

* Vanilla JS: Building Web Components from scratch
* Libraries for simplification (e.g., Lit, Stencil)
* Using Web Components (with Shadow DOM) inside major frameworks (React, Vue, Angular, Svelte)
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Testing-Strategies.md"
# Testing Strategies

* Accessing the Shadow Root in testing frameworks (e.g., \`cy.get('my-el').shadow()\`)
* Unit testing component logic
* Visual Regression Testing for styled components
EOF

# Section C
cat <<EOF > "$PART_DIR/003-Polyfills-Browser-Support.md"
# Polyfills & Browser Support

* The \`@webcomponents/webcomponentsjs\` polyfill suite
* Assessing the need for polyfills in modern web development
EOF

# Section D
cat <<EOF > "$PART_DIR/004-Development-Debugging.md"
# Development & Debugging

* Browser DevTools: Inspecting the Shadow Tree (\`#shadow-root\`)
* Debugging event paths and style computations
EOF

# ==============================================================================
# Part VII: The Broader Context & The Future
# ==============================================================================
PART_DIR="007-Broader-Context-Future"
mkdir -p "$PART_DIR"

# Section A
cat <<EOF > "$PART_DIR/001-Comparison-Scoping.md"
# Comparison with Other Scoping Mechanisms

* Shadow DOM vs. CSS Modules
* Shadow DOM vs. CSS-in-JS (e.g., Styled Components)
* When to choose one over the other (or use them together)
EOF

# Section B
cat <<EOF > "$PART_DIR/002-Architectural-Role.md"
# Architectural Role

* Building entire applications with Web Components
* Shadow DOM in Micro-Frontends
* Creating robust, shareable Design Systems
EOF

# Section C
cat <<EOF > "$PART_DIR/003-Emerging-Specs.md"
# Emerging & Related Specifications

* Scoped Custom Element Registries
* CSS Scoping with \`@scope\`: A potential future alternative/complement
* Constructable Stylesheets for performance
EOF

echo "Done! Structure created in '$ROOT_DIR'."
```
