Here is the bash script to generate the directory and file structure for your Static Site Generator study guide.

Copy the code block below into a file named `create_ssg_guide.sh`, make it executable, and run it.

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="SSG-Study-Guide"

# Create the root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating directory structure for: $ROOT_DIR"

# ==========================================
# PART I: Fundamentals of Modern Web Architectures
# ==========================================
DIR_NAME="001-Fundamentals-Modern-Web-Architectures"
mkdir -p "$DIR_NAME"

# A. The Evolution of Web Development
cat << 'EOF' > "$DIR_NAME/001-Evolution-Web-Development.md"
# The Evolution of Web Development

* The Static Era (Hand-coded HTML/CSS)
* The Dynamic Era (Server-Side Rendering: PHP, Ruby on Rails, Django)
* The Client-Side Era (Single Page Applications: React, Angular, Vue)
* The Return to Pre-rendering: The Rise of the Jamstack
EOF

# B. Defining Static Site Generators (SSGs)
cat << 'EOF' > "$DIR_NAME/002-Defining-SSGs.md"
# Defining Static Site Generators (SSGs)

* Core Philosophy: Pre-building the Frontend
* The Build Process: The "Generator" in SSG
* Key Concepts: Data Sources, Templating, and Static Assets
* The Jamstack Architecture (JavaScript, APIs, and Markup)
EOF

# C. The Rendering Spectrum
cat << 'EOF' > "$DIR_NAME/003-The-Rendering-Spectrum.md"
# The Rendering Spectrum

* SSR (Server-Side Rendering): Rendered on Request
* CSR (Client-Side Rendering): Rendered in the Browser
* SSG (Static Site Generation): Rendered at Build Time
* Hybrid Models: ISR (Incremental Static Regeneration) & DPR (Distributed Persistent Rendering)
EOF

# D. Comparison with Other Content Systems
cat << 'EOF' > "$DIR_NAME/004-Comparison-Content-Systems.md"
# Comparison with Other Content Systems

* SSG vs. Traditional Monolithic CMS (e.g., WordPress, Drupal)
* SSG vs. "Pure" Single Page Applications (SPAs)
* SSG vs. Site Builders (e.g., Squarespace, Wix)
EOF

# ==========================================
# PART II: Anatomy of a Static Site Generator Project
# ==========================================
DIR_NAME="002-Anatomy-SSG-Project"
mkdir -p "$DIR_NAME"

# A. Core Concepts & Project Structure
cat << 'EOF' > "$DIR_NAME/001-Core-Concepts-Project-Structure.md"
# Core Concepts & Project Structure

* The Source Directory vs. The Output/Build Directory
* Configuration Files (e.g., `eleventy.js`, `next.config.js`)
* Layouts and Templates
* Partials and Reusable Components
EOF

# B. Content Modeling & Data Sources
cat << 'EOF' > "$DIR_NAME/002-Content-Modeling-Data-Sources.md"
# Content Modeling & Data Sources

* Filesystem-based Content (Markdown, MDX)
* Front Matter (YAML, TOML, JSON) for Metadata
* Global and Local Data Files (e.g., `_data/*.json`)
* Fetching from External Sources: Headless CMS & APIs
EOF

# C. Routing and URL Structure
cat << 'EOF' > "$DIR_NAME/003-Routing-URL-Structure.md"
# Routing and URL Structure

* File-based Routing (e.g., `pages/about.md` -> `/about/`)
* Programmatic Page Generation (Creating pages from data collections)
* Permalinks and URL Customization
* Handling Slugs, Taxonomies (Tags, Categories), and Pagination
EOF

# D. Templating and Logic
cat << 'EOF' > "$DIR_NAME/004-Templating-And-Logic.md"
# Templating and Logic

* Common Templating Languages (Liquid, Nunjucks, Handlebars)
* Component-based Templating (JSX/TSX in Next.js/Gatsby, Vue in Nuxt)
* Filters, Shortcodes, and Helpers for data manipulation
EOF

# ==========================================
# PART III: The Build Process & Content Pipeline
# ==========================================
DIR_NAME="003-Build-Process-Content-Pipeline"
mkdir -p "$DIR_NAME"

# A. The Build Lifecycle
cat << 'EOF' > "$DIR_NAME/001-The-Build-Lifecycle.md"
# The Build Lifecycle

* Step 1: Data Ingestion & Collection
* Step 2: Content Transformation & Rendering
* Step 3: Asset Processing & Optimization
* Step 4: Writing to the Output Directory
EOF

# B. Content Processing
cat << 'EOF' > "$DIR_NAME/002-Content-Processing.md"
# Content Processing

* Markdown & MDX Parsing (Plugins for syntax highlighting, tables, etc.)
* Image Processing & Optimization (Resizing, responsive images, modern formats like WebP/AVIF)
* Handling Other Data Formats (CSV, YAML)
EOF

# C. The Asset Pipeline
cat << 'EOF' > "$DIR_NAME/003-The-Asset-Pipeline.md"
# The Asset Pipeline

* CSS Processing (Sass/SCSS, PostCSS)
* JavaScript Bundling (Module resolution, tree-shaking, minification)
* Asset Hashing (Cache Busting)
* Handling Static Files (Fonts, Robots.txt, Favicons)
EOF

# ==========================================
# PART IV: Enhancing & Securing the Static Site
# ==========================================
DIR_NAME="004-Enhancing-Securing-Static-Site"
mkdir -p "$DIR_NAME"

# A. The "Static" Security Advantage
cat << 'EOF' > "$DIR_NAME/001-Static-Security-Advantage.md"
# The "Static" Security Advantage

* Reduced Attack Surface (No server-side code execution, no database connection)
* Simplified Security Model
EOF

# B. Re-introducing Dynamic Functionality
cat << 'EOF' > "$DIR_NAME/002-Reintroducing-Dynamic-Functionality.md"
# Re-introducing Dynamic Functionality (The "A" in Jamstack)

* Client-side JavaScript for Interactivity
* Integrating with Third-Party APIs (Search, Comments, Analytics)
EOF

# C. Serverless Functions for Backend Logic
cat << 'EOF' > "$DIR_NAME/003-Serverless-Functions.md"
# Serverless Functions for Backend Logic

* Use Cases: Form Submissions, User Authentication, E-commerce Checkouts
* Implementation (Netlify Functions, Vercel Edge Functions, AWS Lambda)
* Securing API Keys and Secrets with Environment Variables
EOF

# D. Security Best Practices
cat << 'EOF' > "$DIR_NAME/004-Security-Best-Practices.md"
# Security Best Practices

* Content Security Policy (CSP)
* Cross-Origin Resource Sharing (CORS) for API calls
* Subresource Integrity (SRI) for third-party scripts
EOF

# ==========================================
# PART V: Performance, Deployment & Scalability
# ==========================================
DIR_NAME="005-Performance-Deployment-Scalability"
mkdir -p "$DIR_NAME"

# A. Core Performance Principles
cat << 'EOF' > "$DIR_NAME/001-Core-Performance-Principles.md"
# Core Performance Principles

* Why Pre-built Sites are Fast by Default
* The Power of Global CDNs (Content Delivery Networks)
* Measuring Performance: Core Web Vitals (LCP, FID, CLS)
EOF

# B. Advanced Optimization Techniques
cat << 'EOF' > "$DIR_NAME/002-Advanced-Optimization-Techniques.md"
# Advanced Optimization Techniques

* Code Splitting (Per-route or per-component)
* Lazy Loading (Images and Components)
* Critical CSS Extraction
* Prefetching and Preloading Assets
EOF

# C. Deployment & Hosting (CI/CD)
cat << 'EOF' > "$DIR_NAME/003-Deployment-Hosting.md"
# Deployment & Hosting (CI/CD)

* Git-based Workflow (Push to Deploy)
* Hosting Platforms (Netlify, Vercel, Cloudflare Pages, GitHub Pages)
* Atomic Deploys and Instant Rollbacks
* Build Caching and Optimization
EOF

# D. Caching & Invalidation
cat << 'EOF' > "$DIR_NAME/004-Caching-Invalidation.md"
# Caching & Invalidation

* CDN Caching Strategies
* Cache Invalidation (Manual, Webhooks from CMS)
* Service Workers for Offline Capabilities
EOF

# ==========================================
# PART VI: Development Workflow & Ecosystem
# ==========================================
DIR_NAME="006-Development-Workflow-Ecosystem"
mkdir -p "$DIR_NAME"

# A. Choosing Your SSG
cat << 'EOF' > "$DIR_NAME/001-Choosing-Your-SSG.md"
# Choosing Your SSG

* Key Players & Their Philosophies (Next.js, Eleventy, Hugo, Astro, Gatsby)
* Criteria for Selection: Language, Performance, Ecosystem, Learning Curve
EOF

# B. The Local Development Experience
cat << 'EOF' > "$DIR_NAME/002-Local-Development-Experience.md"
# The Local Development Experience

* Development Servers with Hot-reloading
* Linting, Formatting, and Code Quality Tools
* Debugging the Build Process
EOF

# C. Content Management & Editorial Workflow
cat << 'EOF' > "$DIR_NAME/003-Content-Management-Workflow.md"
# Content Management & Editorial Workflow

* Headless CMS Integration (Contentful, Sanity, Strapi)
* Git-based CMS (Decap CMS, TinaCMS)
* Preview Builds for Draft Content
EOF

# D. Testing & Quality Assurance
cat << 'EOF' > "$DIR_NAME/004-Testing-Quality-Assurance.md"
# Testing & Quality Assurance

* Unit & Component Testing
* End-to-End Testing (Cypress, Playwright)
* Automated Checks: Link Checking, Accessibility Audits (a11y), Visual Regression
EOF

# ==========================================
# PART VII: Advanced Architectures & The Future of SSG
# ==========================================
DIR_NAME="007-Advanced-Arch-Future-SSG"
mkdir -p "$DIR_NAME"

# A. Hybrid & Next-Generation Rendering
cat << 'EOF' > "$DIR_NAME/001-Hybrid-NextGen-Rendering.md"
# Hybrid & Next-Generation Rendering

* Incremental Static Regeneration (ISR): Rebuilding pages on-demand without a full deploy
* On-Demand Builders / Distributed Persistent Rendering (DPR)
* Streaming Server-Side Rendering
EOF

# B. Moving Logic to The Edge
cat << 'EOF' > "$DIR_NAME/002-Moving-Logic-To-Edge.md"
# Moving Logic to The Edge

* Edge Functions for Middleware and Personalization
* Edge-Side Rendering vs. Server-Side Rendering
* A/B Testing at the Edge
EOF

# C. SSG at Scale
cat << 'EOF' > "$DIR_NAME/003-SSG-At-Scale.md"
# SSG at Scale

* Managing Large & Enterprise Sites (Build times, content organization)
* Internationalization (i18n) and Localization (l10n) Strategies
* Multi-site Architectures (Monorepos)
EOF

# D. Emerging Architectural Patterns
cat << 'EOF' > "$DIR_NAME/004-Emerging-Architectural-Patterns.md"
# Emerging Architectural Patterns

* The Islands Architecture (Astro)
* Partial Hydration
* React Server Components (RSC) and their impact on SSG
EOF

echo "Done! SSG Study Guide structure created in: $(pwd)"
```

### How to use this script:

1.  Open your terminal.
2.  Create a new file:
    ```bash
    nano create_ssg_guide.sh
    ```
3.  Paste the code above into the editor.
4.  Save and exit (Ctrl+O, Enter, Ctrl+X).
5.  Make the script executable:
    ```bash
    chmod +x create_ssg_guide.sh
    ```
6.  Run the script:
    ```bash
    ./create_ssg_guide.sh
    ```
