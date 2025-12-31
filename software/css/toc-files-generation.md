Here is the bash script to generate the folder and file structure for your CSS study guide.

### Instructions:
1.  Copy the code block below.
2.  Save it as a file named `create_css_course.sh` (e.g., run `nano create_css_course.sh` and paste).
3.  Make the script executable: `chmod +x create_css_course.sh`.
4.  Run the script: `./create_css_course.sh`.

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="CSS-Comprehensive-Study"

# Create the root directory and enter it
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating CSS Study Guide structure in '$ROOT_DIR'..."

# ==============================================================================
# Part I: Core Concepts & Foundational Syntax
# ==============================================================================
PART_DIR="001-Core-Concepts-Foundational-Syntax"
mkdir -p "$PART_DIR"

# Section A
cat <<EOT > "$PART_DIR/001-Introduction-to-CSS.md"
# Introduction to Cascading Style Sheets (CSS)

* What is CSS? The Role of Presentation in Web Development
* Separation of Concerns: Content (HTML) vs. Presentation (CSS) vs. Behavior (JS)
* The Evolution of CSS: From CSS1 to Modern CSS
EOT

# Section B
cat <<EOT > "$PART_DIR/002-Integrating-CSS-with-HTML.md"
# Integrating CSS with HTML

* Inline CSS (The \`style\` attribute)
* Internal/Embedded CSS (The \`<style>\` tag)
* External CSS (The \`<link>\` tag)
* \`@import\` vs. \`<link>\`
EOT

# Section C
cat <<EOT > "$PART_DIR/003-The-Cascade-and-Inheritance.md"
# The "Cascade" and Inheritance

* The Core Principles of the Cascade
    1. Origin and Importance (\`!important\`)
    2. Specificity
    3. Source Order
* Understanding and Calculating Specificity
* Inheritance and the \`inherit\`, \`initial\`, \`unset\`, and \`revert\` keywords
EOT

# Section D
cat <<EOT > "$PART_DIR/004-Fundamental-CSS-Syntax.md"
# Fundamental CSS Syntax

* The Anatomy of a CSS Rule (Ruleset)
    * Selector
    * Declaration Block
    * Property & Value
* Comments in CSS (\`/* ... */\`)
EOT

# ==============================================================================
# Part II: Selectors & The Building Blocks of Style
# ==============================================================================
PART_DIR="002-Selectors-Building-Blocks"
mkdir -p "$PART_DIR"

# Section A
cat <<EOT > "$PART_DIR/001-CSS-Selectors.md"
# CSS Selectors: Targeting Elements

* **Basic Selectors**
    * Universal Selector (\`*\`)
    * Type/Element Selector (\`p\`, \`div\`)
    * Class Selector (\`.class-name\`)
    * ID Selector (\`#id-name\`)
* **Attribute Selectors** (\`[type="text"]\`, \`[href^="https"]\`)
* **Grouping Selector** (\`,\`)
* **Combinators**
    * Descendant Combinator (\` \`)
    * Child Combinator (\`>\`)
    * General Sibling Combinator (\`~\`)
    * Adjacent Sibling Combinator (\`+\`)
* **Pseudo-classes**
    * User Action Pseudos (\`:hover\`, \`:focus\`, \`:active\`)
    * Link/History Pseudos (\`:link\`, \`:visited\`)
    * Structural & Positional Pseudos (\`:first-child\`, \`:nth-child()\`, \`:last-of-type\`)
    * Input Pseudos (\`:checked\`, \`:disabled\`, \`:valid\`)
* **Pseudo-elements** (\`::before\`, \`::after\`, \`::first-letter\`, \`::selection\`)
EOT

# Section B
cat <<EOT > "$PART_DIR/002-The-Box-Model.md"
# The Box Model: The Foundation of Layout

* Core Components: Content, Padding, Border, Margin
* Controlling the Sizing Model: \`box-sizing: content-box\` vs. \`border-box\`
* Width and Height (\`width\`, \`height\`, \`min-/max-\`)
* Padding and Margin (Longhand vs. Shorthand)
* Border (\`border-style\`, \`border-width\`, \`border-color\`, \`border-radius\`)
* Outline vs. Border
EOT

# Section C
cat <<EOT > "$PART_DIR/003-Typography-and-Text.md"
# Typography and Text Styling

* Fonts (\`font-family\`, \`@font-face\` for web fonts, \`font-weight\`, \`font-style\`)
* Sizing and Spacing (\`font-size\`, \`line-height\`, \`letter-spacing\`, \`word-spacing\`)
* Text Alignment & Decoration (\`text-align\`, \`text-decoration\`, \`text-transform\`)
* Text Shadows (\`text-shadow\`)
* Advanced Properties (\`white-space\`, \`text-overflow\`, \`word-break\`)
EOT

# Section D
cat <<EOT > "$PART_DIR/004-Colors-Backgrounds-Units.md"
# Colors, Backgrounds, and Units

* **Color Models**
    * Named Colors, HEX, RGB(A), HSL(A)
    * The \`currentColor\` Keyword
* **Backgrounds**
    * \`background-color\`
    * \`background-image\` (including gradients)
    * \`background-repeat\`, \`background-position\`, \`background-size\`, \`background-attachment\`
    * Multiple Backgrounds
* **CSS Units**
    * Absolute Units (\`px\`, \`pt\`)
    * Relative Units (\`%\`, \`em\`, \`rem\`, \`ch\`)
    * Viewport Units (\`vw\`, \`vh\`, \`vmin\`, \`vmax\`)
EOT

# ==============================================================================
# Part III: Layout & Positioning
# ==============================================================================
PART_DIR="003-Layout-and-Positioning"
mkdir -p "$PART_DIR"

# Section A
cat <<EOT > "$PART_DIR/001-Fundamental-Display-Flow.md"
# Fundamental Display & Flow

* The \`display\` Property: \`block\`, \`inline\`, \`inline-block\`, \`none\`
* Normal Document Flow
* The \`visibility\` Property vs. \`display: none\`
EOT

# Section B
cat <<EOT > "$PART_DIR/002-Position-Property.md"
# The \`position\` Property

* \`static\` (Default)
* \`relative\`
* \`absolute\` (and the containing block)
* \`fixed\`
* \`sticky\`
* The Stacking Context and \`z-index\`
EOT

# Section C
cat <<EOT > "$PART_DIR/003-Legacy-Layout-Techniques.md"
# Legacy Layout Techniques (For Context & Maintenance)

* \`float\` and \`clear\`
* Inline-block layouts
* Table-based layouts (\`display: table\`)
EOT

# Section D
cat <<EOT > "$PART_DIR/004-Modern-Layout-Flexbox.md"
# Modern Layout: Flexbox

* Core Concepts: Main Axis vs. Cross Axis
* Flex Container Properties (\`display: flex\`, \`flex-direction\`, \`justify-content\`, \`align-items\`, \`flex-wrap\`, \`align-content\`)
* Flex Item Properties (\`flex-grow\`, \`flex-shrink\`, \`flex-basis\`, \`order\`, \`align-self\`)
EOT

# Section E
cat <<EOT > "$PART_DIR/005-Modern-Layout-Grid.md"
# Modern Layout: Grid

* Core Concepts: Tracks, Gutters, Lines, and Cells
* Grid Container Properties (\`display: grid\`, \`grid-template-columns/rows\`, \`grid-auto-flow\`, \`gap\`)
* Placing Grid Items (\`grid-column/row\`, \`grid-area\`)
* Implicit vs. Explicit Grids
* Alignment in Grid (\`justify-items\`, \`align-items\`, etc.)
EOT

# ==============================================================================
# Part IV: Visual Effects & Motion
# ==============================================================================
PART_DIR="004-Visual-Effects-Motion"
mkdir -p "$PART_DIR"

# Section A
cat <<EOT > "$PART_DIR/001-2D-3D-Transforms.md"
# 2D & 3D Transforms

* The \`transform\` property: \`translate()\`, \`rotate()\`, \`scale()\`, \`skew()\`
* Setting the Origin: \`transform-origin\`
* 3D Transforms (\`perspective\`, \`transform-style: preserve-3d\`)
EOT

# Section B
cat <<EOT > "$PART_DIR/002-Transitions.md"
# Transitions

* Smoothly Animating State Changes
* Properties: \`transition-property\`, \`transition-duration\`, \`transition-timing-function\`, \`transition-delay\`
EOT

# Section C
cat <<EOT > "$PART_DIR/003-Keyframe-Animations.md"
# Keyframe Animations

* Defining Animations with \`@keyframes\`
* Applying Animations: \`animation-name\`, \`animation-duration\`, \`animation-iteration-count\`, etc.
EOT

# Section D
cat <<EOT > "$PART_DIR/004-Filters-and-Blending.md"
# Filters and Blending

* \`filter\`: \`blur()\`, \`brightness()\`, \`grayscale()\`, \`drop-shadow()\`
* \`backdrop-filter\` for "frosted glass" effects
* \`mix-blend-mode\` and \`background-blend-mode\`
EOT

# ==============================================================================
# Part V: Responsive & Adaptive Design
# ==============================================================================
PART_DIR="005-Responsive-Adaptive-Design"
mkdir -p "$PART_DIR"

# Section A
cat <<EOT > "$PART_DIR/001-Core-Strategies.md"
# Core Strategies & Philosophies

* Fluid Grids, Flexible Images, and Media Queries
* Mobile-First vs. Desktop-First Design
EOT

# Section B
cat <<EOT > "$PART_DIR/002-Media-Queries.md"
# Media Queries

* Syntax (\`@media\`) and Logic ( \`and\`, \`,\`, \`not\`)
* Targeting Viewport Size, Resolution, and Orientation
* Feature Queries (\`@supports\`) for Progressive Enhancement
EOT

# Section C
cat <<EOT > "$PART_DIR/003-Responsive-Units-Techniques.md"
# Responsive Units & Techniques

* Fluid Typography (\`vw\`, \`clamp()\`)
* Responsive Images (\`object-fit\`, \`srcset\` in HTML)
* Intrinsic Web Design
EOT

# Section D
cat <<EOT > "$PART_DIR/004-Container-Queries.md"
# Container Queries

* The "Next Generation" of Responsiveness
* Styling a component based on its own container's size, not just the viewport's
EOT

# ==============================================================================
# Part VI: Architecture & Professional Practices
# ==============================================================================
PART_DIR="006-Architecture-Professional-Practices"
mkdir -p "$PART_DIR"

# Section A
cat <<EOT > "$PART_DIR/001-CSS-Methodologies.md"
# CSS Methodologies & Organization

* BEM (Block, Element, Modifier)
* OOCSS (Object-Oriented CSS)
* SMACSS (Scalable and Modular Architecture for CSS)
* ITCSS (Inverted Triangle CSS)
EOT

# Section B
cat <<EOT > "$PART_DIR/002-Maintainability-Reusability.md"
# Maintainability and Reusability

* CSS Custom Properties (Variables)
* Using \`calc()\`, \`min()\`, \`max()\`, and \`clamp()\` for dynamic values
EOT

# Section C
cat <<EOT > "$PART_DIR/003-Performance-Optimization.md"
# Performance Optimization

* Minification and Concatenation
* Critical CSS (Inlining above-the-fold styles)
* Selector Performance (and when it matters)
* Reducing Repaints and Reflows
EOT

# Section D
cat <<EOT > "$PART_DIR/004-Accessibility-A11y.md"
# Accessibility (a11y)

* Ensuring Color Contrast
* Styling Focus States (\`:focus-visible\`)
* Hiding Content Correctly (for screen readers)
* Respecting User Preferences (\`prefers-reduced-motion\`, \`prefers-color-scheme\`)
EOT

# ==============================================================================
# Part VII: The Modern CSS Ecosystem & Advanced Topics
# ==============================================================================
PART_DIR="007-Modern-CSS-Ecosystem"
mkdir -p "$PART_DIR"

# Section A
cat <<EOT > "$PART_DIR/001-CSS-Preprocessors.md"
# CSS Preprocessors

* Why use them? (Variables, Nesting, Mixins, Functions)
* Sass/SCSS
* LESS
EOT

# Section B
cat <<EOT > "$PART_DIR/002-CSS-Post-processors.md"
# CSS Post-processors

* PostCSS and its Plugin Ecosystem
* Autoprefixer for vendor prefixing
EOT

# Section C
cat <<EOT > "$PART_DIR/003-CSS-in-JS-Scoped-Styles.md"
# CSS-in-JS & Scoped Styles

* The Component-Based Styling Philosophy
* Styled Components, Emotion
* CSS Modules
EOT

# Section D
cat <<EOT > "$PART_DIR/004-Emerging-CSS-Features.md"
# Emerging CSS Features

* Cascade Layers (\`@layer\`) for managing specificity
* Native CSS Nesting
* The \`:has()\` relational pseudo-class
* CSS Scoping (\`@scope\`)
* The CSS Houdini APIs
EOT

echo "Done! Directory structure created in $(pwd)"
```
