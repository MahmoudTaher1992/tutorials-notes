Here is the bash script to generate the directory and file structure based on your specific Table of Contents.

I have handled special characters (like HTML tags `<script>`, `!DOCTYPE`, etc.) by using quoted heredocs (`cat << 'EOF'`), which ensures the script runs without syntax errors on Ubuntu.

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="Web-Frontend-Study"

# Create the root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

echo "Creating project structure in $(pwd)..."

# ==============================================================================
# Part I: Web & Frontend Fundamentals
# ==============================================================================
DIR_01="001-Web-Frontend-Fundamentals"
mkdir -p "$DIR_01"

# A. How the Web Works
cat << 'EOF' > "$DIR_01/001-How-the-Web-Works.md"
# How the Web Works

* Introduction: The Foundations of the Internet
* What is HTTP? (Brief overview of the protocol, request/response cycle)
* Domain Names, DNS (Domain Name System), and Hosting
* Web Browsers: Their Role and Function (Rendering, interpreting code)
EOF

# B. Introduction to Frontend Development
cat << 'EOF' > "$DIR_01/002-Intro-to-Frontend-Development.md"
# Introduction to Frontend Development

* What is Frontend Development? (Role, technologies involved)
* What are Markup Languages? (Purpose, HTML's place)
* The Core Trio: HTML, CSS, JavaScript (Overview of their individual roles)
* Setting Up Your Development Environment
EOF

# C. Your First HTML File
cat << 'EOF' > "$DIR_01/003-Your-First-HTML-File.md"
# Your First HTML File

* Creating a Basic HTML Document (Initial structure)
EOF


# ==============================================================================
# Part II: HTML - Structuring Web Content
# ==============================================================================
DIR_02="002-HTML-Structuring-Web-Content"
mkdir -p "$DIR_02"

# A. The Basic HTML Document Structure
cat << 'EOF' > "$DIR_02/001-Basic-HTML-Structure.md"
# The Basic HTML Document Structure

* `!DOCTYPE` Declaration (Significance)
* `html` Tag (The Root Element)
* `head` Tag (Document Metadata)
    * `title` Tag (Browser Tab Title)
    * `meta` Tags (Character Set, Viewport, Description, Keywords)
    * Including External CSS (`<link>` tag)
    * Including External JavaScript (`<script>` tag)
* `body` Tag (The Visible Content)
EOF

# B. Textual Content & Basic Elements
cat << 'EOF' > "$DIR_02/002-Textual-Content-and-Basic-Elements.md"
# Textual Content & Basic Elements

* Headings: `h1` to `h6` (Hierarchy and Importance)
* Paragraphs: `p`
* Line Break: `br`
* Horizontal Rule: `hr`
* Preformatted Text: `pre`
* Highlighting Text: `mark`
* **Emphasis and Importance**
    * Bold (`b`) vs. Strong Importance (`strong`)
    * Italic (`i`) vs. Emphasized Text (`em`)
* Subscript (`sub`) and Superscript (`sup`)
* Grouping Text: `div` (Block-level container)
* Inline Spanning: `span` (Inline-level container)
EOF

# C. Links & Media
cat << 'EOF' > "$DIR_02/003-Links-and-Media.md"
# Links & Media

* **Links (`a` Tag)**
    * Hyperlinks (Internal, External, Email, Phone)
    * Anchor Links (Navigating within a page)
* **Images**
    * `img` Tag (Source, Alt Text, Dimensions)
    * `img` vs. `figure` (Semantic Grouping with Captions)
* **Embedding Media**
    * `audio` Tag (Source, Controls, Autoplay, Loop)
    * `video` Tag (Source, Controls, Poster, Autoplay, Loop)
    * `iframe` Tag (Embedding External Documents/Content)
EOF

# D. Lists and Their Types
cat << 'EOF' > "$DIR_02/004-Lists-and-Types.md"
# Lists and Their Types

* Ordered Lists (`ol`, `li`)
* Unordered Lists (`ul`, `li`)
* Definition Lists (`dl`, `dt`, `dd`)
* Nested Lists (Combining different types)
EOF

# E. Tables
cat << 'EOF' > "$DIR_02/005-Tables.md"
# Tables

* `table` Tag (Basic Structure: `thead`, `tbody`, `tfoot`, `tr`, `th`, `td`)
* Creating Structured Tabular Data
EOF

# F. Forms - Collecting User Input
cat << 'EOF' > "$DIR_02/006-Forms-Collecting-Input.md"
# Forms - Collecting User Input

* `form` Tag (Action, Method, Enctype)
* Labels (`label`) and Inputs (`input` types: text, password, email, number, checkbox, radio, file, submit, reset, button, etc.)
* Textareas (`textarea`)
* Select Boxes (`select`, `option`, `optgroup`)
* File Uploads (`input type="file"`)
* Form Validation (HTML5 built-in validation attributes: `required`, `pattern`, `min`, `max`, etc.)
* Limitations of Client-Side Validation
EOF

# G. Semantic Markup & Document Outline
cat << 'EOF' > "$DIR_02/007-Semantic-Markup-and-Outline.md"
# Semantic Markup & Document Outline

* What is Semantic HTML? (Importance for accessibility and SEO)
* **Layout Tags (Structuring the page regions)**
    * `header`, `nav`, `main`, `section`, `article`, `aside`, `footer`
* **Quotation / Citation Tags**
    * `blockquote` (Block-level quotation)
    * `q` (Inline quotation)
    * `cite` (Title of a creative work)
    * `dfn` (Defining instance of a term)
    * `address` (Contact information for nearest `article` or `body`)
* Abbreviation: `abbr`
* Highlighting Changes: `del` (Deleted text) and `ins` (Inserted text)
EOF

# H. HTML Attributes
cat << 'EOF' > "$DIR_02/008-HTML-Attributes.md"
# HTML Attributes

* Tags and Attributes (General Concept)
* Case Insensitivity (HTML's flexibility)
* Standard Attributes (e.g., `lang`, `dir`, `hidden`)
* `id` Attribute (Unique Identifier for elements)
* `class` Attribute (Grouping elements for styling/scripting)
* `data-*` Attributes (Custom data storage)
* `style` Attribute (Inline CSS)
* HTML Entities (Special characters like `&nbsp;`, `&lt;`)
* HTML Comments (`<!-- -->`)
* Whitespaces in HTML (How browsers handle them)
EOF


# ==============================================================================
# Part III: CSS - Styling Web Content
# ==============================================================================
DIR_03="003-CSS-Styling-Web-Content"
mkdir -p "$DIR_03"

# A. Introduction to CSS
cat << 'EOF' > "$DIR_03/001-Introduction-to-CSS.md"
# Introduction to CSS

* What is CSS? (Purpose, Syntax, Relationship with HTML)
* CSS Roadmap (A guide for deeper learning in CSS)
EOF

# B. Basic Styling Concepts
cat << 'EOF' > "$DIR_03/002-Basic-Styling-Concepts.md"
# Basic Styling Concepts

* The Box Model (Content, Padding, Border, Margin)
* Styling Basics (Colors, Fonts, Backgrounds)
EOF

# C. Including CSS in HTML
cat << 'EOF' > "$DIR_03/003-Including-CSS-in-HTML.md"
# Including CSS in HTML

* Inline CSS (`style` attribute)
* Internal CSS (`<style>` tag in `head`)
* External CSS (`<link>` tag in `head`)
* The Cascade, Specificity, and Inheritance (How styles are applied)
EOF


# ==============================================================================
# Part IV: JavaScript - Adding Interactivity
# ==============================================================================
DIR_04="004-JavaScript-Adding-Interactivity"
mkdir -p "$DIR_04"

# A. Introduction to JavaScript
cat << 'EOF' > "$DIR_04/001-Introduction-to-JavaScript.md"
# Introduction to JavaScript

* What is JavaScript? (Purpose, Role in Frontend)
* JavaScript Roadmap (A guide for deeper learning in JS)
EOF

# B. Including JavaScript in HTML
cat << 'EOF' > "$DIR_04/002-Including-JavaScript-in-HTML.md"
# Including JavaScript in HTML

* `script` Tag (Inline scripts, external script files)
* `defer` and `async` Attributes (Script loading and execution strategies)
* Basic DOM Interaction (How JavaScript modifies HTML and CSS)
EOF


# ==============================================================================
# Part V: Web Standards, Performance, and Best Practices
# ==============================================================================
DIR_05="005-Web-Standards-Performance"
mkdir -p "$DIR_05"

# A. Accessibility (A11Y)
cat << 'EOF' > "$DIR_05/001-Accessibility-A11Y.md"
# Accessibility (A11Y)

* Basics of Accessibility (Why it's crucial for all users)
* Semantic HTML for Improved Accessibility
* (Brief mention of ARIA attributes if relevant to HTML structure)
EOF

# B. Search Engine Optimization (SEO)
cat << 'EOF' > "$DIR_05/002-SEO.md"
# Search Engine Optimization (SEO)

* What is SEO? (Fundamentals of how search engines rank pages)
* Basics of SEO (Impact of HTML structure, meta tags, content)
EOF

# C. Web Performance
cat << 'EOF' > "$DIR_05/003-Web-Performance.md"
# Web Performance

* Priority Hints (Optimizing resource loading priority)
* Image Optimization (Responsive images, lazy loading attributes)
EOF

# D. Web Security
cat << 'EOF' > "$DIR_05/004-Web-Security.md"
# Web Security

* Content Security Policy (CSP) (Mitigating cross-site scripting (XSS) and other attacks)
EOF

echo "Structure created successfully in $ROOT_DIR"
```

### Instructions:
1.  Save the code above into a file named `create_study_guide.sh`.
2.  Open your terminal.
3.  Give the script permission to run:
    ```bash
    chmod +x create_study_guide.sh
    ```
4.  Run the script:
    ```bash
    ./create_study_guide.sh
    ```
