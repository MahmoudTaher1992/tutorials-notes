Here is the bash script to generate the folder structure and files for your Eleventy study guide.

Copy the code below, save it as a file (e.g., `setup_eleventy_study.sh`), and run it.

```bash
#!/bin/bash

# Define the root directory
ROOT_DIR="Eleventy-Study"

# Create the root directory
echo "Creating root directory: $ROOT_DIR"
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

# ==========================================
# PART I: Fundamentals of Static Site Generation & Eleventy
# ==========================================
PART_DIR="001-Fundamentals-SSG-Eleventy"
mkdir -p "$PART_DIR"

# A. Introduction to the Jamstack & Static Sites
FILE="$PART_DIR/001-Intro-Jamstack-Static-Sites.md"
cat <<EOT > "$FILE"
# Introduction to the Jamstack & Static Sites

* The Static-First Philosophy vs. Dynamic Server-Rendered Sites
* What is a Static Site Generator (SSG)?
* The Core Principles of Jamstack (JavaScript, APIs, Markup)
* Benefits: Performance, Security, Scalability, and Developer Experience
EOT

# B. Defining Eleventy (11ty)
FILE="$PART_DIR/002-Defining-Eleventy.md"
cat <<EOT > "$FILE"
# Defining Eleventy (11ty)

* History, Philosophy ("A simpler static site generator"), and Motivation
* The Zero-Config Promise: Works out of the box
* Core Concepts: Templating Agnosticism, Data Cascade, and Flexibility
* The Eleventy Build Process: An Overview
EOT

# C. Your First Eleventy Site: The "Zero to Hero" Path
FILE="$PART_DIR/003-Your-First-Eleventy-Site.md"
cat <<EOT > "$FILE"
# Your First Eleventy Site: The "Zero to Hero" Path

* Installation and Project Scaffolding (npm init)
* The Default Input (\`.\`) and Output (\`_site\`) Directories
* Creating Your First Template (e.g., \`index.md\`)
* Running the Eleventy Dev Server (\`npx @11ty/eleventy --serve\`)
* Performing a Production Build (\`npx @11ty/eleventy\`)
EOT

# D. Comparison with Other SSGs & Frameworks
FILE="$PART_DIR/004-Comparison-SSGs-Frameworks.md"
cat <<EOT > "$FILE"
# Comparison with Other SSGs & Frameworks

* Eleventy vs. Jekyll/Hugo (Simplicity, Language Choice)
* Eleventy vs. Next.js/Gatsby (JavaScript Framework vs. HTML-First)
* When to Choose Eleventy
EOT

# ==========================================
# PART II: Project Structure & Configuration
# ==========================================
PART_DIR="002-Project-Structure-Configuration"
mkdir -p "$PART_DIR"

# A. Site Architecture & Strategy
FILE="$PART_DIR/001-Site-Architecture-Strategy.md"
cat <<EOT > "$FILE"
# Site Architecture & Strategy

* Organizing Your Project: Input Directory Structure
* Planning for Different Content Types (e.g., Pages, Posts, Products)
* Separation of Concerns: Content, Data, Layouts, and Includes
EOT

# B. Content Modeling & Organization
FILE="$PART_DIR/002-Content-Modeling-Organization.md"
cat <<EOT > "$FILE"
# Content Modeling & Organization

* Creating Content with Markdown and Front Matter (YAML)
* Directory-Based Content vs. Flat Content Structures
* Leveraging File and Directory Naming Conventions
EOT

# C. The Configuration File (.eleventy.js)
FILE="$PART_DIR/003-Configuration-File.md"
cat <<EOT > "$FILE"
# The Configuration File (.eleventy.js)

* Moving Beyond Zero-Config: Creating your \`eleventy.js\`
* Changing Core Directories (input, output, includes, layouts, data)
* Setting Template Engine Defaults and Overrides
* Registering Custom Filters, Shortcodes, and Collections
EOT

# D. URL & Permalink Design
FILE="$PART_DIR/004-URL-Permalink-Design.md"
cat <<EOT > "$FILE"
# URL & Permalink Design

* How Eleventy Generates URLs by Default
* Customizing Permalinks in Front Matter
* Creating "Pretty URLs" (e.g., \`/about/\` instead of \`/about.html\`)
* Dynamic and Data-Driven Permalinks
* Ignoring Files from Processing
EOT

# ==========================================
# PART III: Core Concepts: Data, Templates, & Collections
# ==========================================
PART_DIR="003-Core-Concepts-Data-Templates"
mkdir -p "$PART_DIR"

# A. Templating & Layouts
FILE="$PART_DIR/001-Templating-Layouts.md"
cat <<EOT > "$FILE"
# Templating & Layouts

## Template Engines
* Liquid (The Default)
* Nunjucks (Powerful and Feature-Rich)
* Markdown (with a specified engine)
* JavaScript Templates (\`.11ty.js\`) for Programmatic Control
* Using Multiple Template Languages in a Single Project

## Layouts & The Layout Chain
* Creating and Applying a Base Layout
* Nested Layouts (Layout Chaining)
* Passing Data Up and Down the Chain

## Includes & Reusable Components
* Creating Partial Templates (Headers, Footers, Sidebars)
* Passing Data into Includes
EOT

# B. The Data Cascade: Sourcing and Using Data
FILE="$PART_DIR/002-Data-Cascade.md"
cat <<EOT > "$FILE"
# The Data Cascade: Sourcing and Using Data

* Hierarchy of Data Precedence (The Cascade)
* Front Matter Data (in individual templates)
* Template & Directory Data Files (\`.json\`, \`.js\`)
* Global Data Files (in \`_data\` directory)
* Computed Data for Dynamic Values
* Fetching Remote Data at Build Time (e.g., from a Headless CMS or API)
EOT

# C. Collections: Grouping & Navigating Content
FILE="$PART_DIR/003-Collections-Grouping-Content.md"
cat <<EOT > "$FILE"
# Collections: Grouping & Navigating Content

* The Default \`collections.all\`
* Creating Collections with Tags in Front Matter
* Custom Collections using \`addCollection\` in \`.eleventy.js\`
    * Filtering, Sorting, and Modifying Content Items
    * Creating Relationships Between Content
* Pagination: Automatically Generating Pages for a Collection
    * Paginating a Collection (e.g., for a blog index)
    * Paginating Data from a Global Data File
EOT

# D. Extending Templates: Shortcodes, Filters & Plugins
FILE="$PART_DIR/004-Extending-Templates.md"
cat <<EOT > "$FILE"
# Extending Templates: Shortcodes, Filters & Plugins

* **Filters**: Modifying data within a template (e.g., \`{{ myDate | dateFilter }}\`)
* **Shortcodes**: Injecting reusable HTML or logic (e.g., \`{% image "cat.jpg" %}\`)
* **Paired Shortcodes**: Wrapping content (e.g., \`{% callout %}...{% endcallout %}\`)
* Discovering and Using Official & Community Plugins
EOT

# ==========================================
# PART IV: Asset Pipeline & Frontend Build Process
# ==========================================
PART_DIR="004-Asset-Pipeline-Build-Process"
mkdir -p "$PART_DIR"

# A. Fundamentals of the Asset Pipeline
FILE="$PART_DIR/001-Fundamentals-Asset-Pipeline.md"
cat <<EOT > "$FILE"
# Fundamentals of the Asset Pipeline

* Understanding What Eleventy Processes vs. What It Ignores
* Passthrough File Copy for Static Assets (Images, Fonts, CSS)
EOT

# B. Processing CSS & JavaScript
FILE="$PART_DIR/002-Processing-CSS-JavaScript.md"
cat <<EOT > "$FILE"
# Processing CSS & JavaScript

* Strategies for Integrating Pre-processors (Sass, PostCSS)
* Bundling and Minifying JavaScript (e.g., with esbuild or Rollup)
* Using Eleventy as a Conductor for other Build Tools
EOT

# C. Image Optimization
FILE="$PART_DIR/003-Image-Optimization.md"
cat <<EOT > "$FILE"
# Image Optimization

* Using the Official \`eleventy-img\` Plugin
* Generating Multiple Sizes and Modern Formats (WebP, AVIF)
* Automating \`<img>\` and \`<picture>\` Markup Generation
EOT

# D. Event-Driven Build Customization
FILE="$PART_DIR/004-Event-Driven-Build-Customization.md"
cat <<EOT > "$FILE"
# Event-Driven Build Customization

* Hooking into the Build Process with Events (\`before\`, \`after\`, etc.)
* Running Custom Scripts during the Build (e.g., generating a search index)
EOT

# ==========================================
# PART V: Performance & Optimization
# ==========================================
PART_DIR="005-Performance-Optimization"
mkdir -p "$PART_DIR"

# A. Build Performance Optimization
FILE="$PART_DIR/001-Build-Performance-Optimization.md"
cat <<EOT > "$FILE"
# Build Performance Optimization

* Incremental Builds for Faster Development
* Using \`.eleventyignore\` to reduce the build scope
* Efficient Data Fetching and Caching (with \`eleventy-fetch\` plugin)
EOT

# B. Frontend Performance Optimization
FILE="$PART_DIR/002-Frontend-Performance-Optimization.md"
cat <<EOT > "$FILE"
# Frontend Performance Optimization

* Minifying HTML, CSS, and JS Output
* Inlining Critical CSS for Faster First Paint
* Lazy Loading Images and other Offscreen Content
* Generating a Service Worker for Offline Capabilities
EOT

# C. Scalability for Large Sites
FILE="$PART_DIR/003-Scalability-Large-Sites.md"
cat <<EOT > "$FILE"
# Scalability for Large Sites

* Strategies for Managing Thousands of Pages
* Memory Management during Large Builds
* On-Demand Builders and Distributed Rendering
EOT

# ==========================================
# PART VI: Development Workflow, Deployment & Maintenance
# ==========================================
PART_DIR="006-Workflow-Deployment-Maintenance"
mkdir -p "$PART_DIR"

# A. Development Workflow
FILE="$PART_DIR/001-Development-Workflow.md"
cat <<EOT > "$FILE"
# Development Workflow

* Leveraging the Dev Server and Hot-Reloading
* Debugging Data and Variables (\`{{ myVar | log }}\`)
* Creating Content Drafts
EOT

# B. Integrating with a Headless CMS
FILE="$PART_DIR/002-Integrating-Headless-CMS.md"
cat <<EOT > "$FILE"
# Integrating with a Headless CMS

* Connecting to Popular CMSes (Contentful, Sanity, Strapi, etc.)
* Fetching Data in the Global \`_data\` directory
* Setting up Webhooks to Trigger Automatic Builds on Content Changes
EOT

# C. Testing & Quality Assurance
FILE="$PART_DIR/003-Testing-Quality-Assurance.md"
cat <<EOT > "$FILE"
# Testing & Quality Assurance

* Linting and Formatting Code (ESLint, Prettier)
* Strategies for Testing Generated HTML Output
* Accessibility (a11y) Auditing
EOT

# D. Deployment & Hosting (CI/CD)
FILE="$PART_DIR/004-Deployment-Hosting.md"
cat <<EOT > "$FILE"
# Deployment & Hosting (CI/CD)

* Preparing the Project for Deployment
* Deploying to Static Hosting Platforms (Netlify, Vercel, GitHub Pages)
* Configuring a CI/CD Pipeline for Automated Builds and Deploys
* Using Environment Variables for Different Builds (Dev vs. Prod)
EOT

# ==========================================
# PART VII: Advanced & Ecosystem Topics
# ==========================================
PART_DIR="007-Advanced-Ecosystem-Topics"
mkdir -p "$PART_DIR"

# A. Adding Dynamic Functionality
FILE="$PART_DIR/001-Adding-Dynamic-Functionality.md"
cat <<EOT > "$FILE"
# Adding Dynamic Functionality

* Serverless Functions (for forms, authentication, etc.)
* Eleventy Edge for Dynamic Content at the Edge
* Client-side JavaScript for Interactivity
EOT

# B. Specialized Use Cases
FILE="$PART_DIR/002-Specialized-Use-Cases.md"
cat <<EOT > "$FILE"
# Specialized Use Cases

* Internationalization (i18n) and Localization
* Building a Documentation Site
* Generating non-HTML files (RSS Feeds, Sitemaps, JSON APIs)
EOT

# C. The Future of Eleventy & Web Development
FILE="$PART_DIR/003-Future-Eleventy.md"
cat <<EOT > "$FILE"
# The Future of Eleventy & Web Development

* Web Components and Eleventy
* Island Architecture Patterns
* The Evolving Eleventy Ecosystem and Roadmap
EOT

echo "Structure created successfully in directory: $(pwd)"
```

### How to use:
1.  Copy the content above.
2.  Open your terminal in Ubuntu.
3.  Create a file: `nano create_eleventy_guide.sh`
4.  Paste the content and save (Ctrl+O, Enter, Ctrl+X).
5.  Make it executable: `chmod +x create_eleventy_guide.sh`
6.  Run it: `./create_eleventy_guide.sh`
