Of course. Here is a similarly detailed and structured Table of Contents for studying Eleventy, following the logical progression and depth of the REST API example.

***

```markdown
*   **Part I: Fundamentals of Static Site Generation & Eleventy**
    *   **A. Introduction to the Jamstack & Static Sites**
        *   The Static-First Philosophy vs. Dynamic Server-Rendered Sites
        *   What is a Static Site Generator (SSG)?
        *   The Core Principles of Jamstack (JavaScript, APIs, Markup)
        *   Benefits: Performance, Security, Scalability, and Developer Experience
    *   **B. Defining Eleventy (11ty)**
        *   History, Philosophy ("A simpler static site generator"), and Motivation
        *   The Zero-Config Promise: Works out of the box
        *   Core Concepts: Templating Agnosticism, Data Cascade, and Flexibility
        *   The Eleventy Build Process: An Overview
    *   **C. Your First Eleventy Site: The "Zero to Hero" Path**
        *   Installation and Project Scaffolding (npm init)
        *   The Default Input (`.`) and Output (`_site`) Directories
        *   Creating Your First Template (e.g., `index.md`)
        *   Running the Eleventy Dev Server (`npx @11ty/eleventy --serve`)
        *   Performing a Production Build (`npx @11ty/eleventy`)
    *   **D. Comparison with Other SSGs & Frameworks**
        *   Eleventy vs. Jekyll/Hugo (Simplicity, Language Choice)
        *   Eleventy vs. Next.js/Gatsby (JavaScript Framework vs. HTML-First)
        *   When to Choose Eleventy

*   **Part II: Project Structure & Configuration**
    *   **A. Site Architecture & Strategy**
        *   Organizing Your Project: Input Directory Structure
        *   Planning for Different Content Types (e.g., Pages, Posts, Products)
        *   Separation of Concerns: Content, Data, Layouts, and Includes
    *   **B. Content Modeling & Organization**
        *   Creating Content with Markdown and Front Matter (YAML)
        *   Directory-Based Content vs. Flat Content Structures
        *   Leveraging File and Directory Naming Conventions
    *   **C. The Configuration File (`.eleventy.js`)**
        *   Moving Beyond Zero-Config: Creating your `eleventy.js`
        *   Changing Core Directories (input, output, includes, layouts, data)
        *   Setting Template Engine Defaults and Overrides
        *   Registering Custom Filters, Shortcodes, and Collections
    *   **D. URL & Permalink Design**
        *   How Eleventy Generates URLs by Default
        *   Customizing Permalinks in Front Matter
        *   Creating "Pretty URLs" (e.g., `/about/` instead of `/about.html`)
        *   Dynamic and Data-Driven Permalinks
        *   Ignoring Files from Processing

*   **Part III: Core Concepts: Data, Templates, & Collections**
    *   **A. Templating & Layouts**
        *   **Template Engines**
            *   Liquid (The Default)
            *   Nunjucks (Powerful and Feature-Rich)
            *   Markdown (with a specified engine)
            *   JavaScript Templates (`.11ty.js`) for Programmatic Control
            *   Using Multiple Template Languages in a Single Project
        *   **Layouts & The Layout Chain**
            *   Creating and Applying a Base Layout
            *   Nested Layouts (Layout Chaining)
            *   Passing Data Up and Down the Chain
        *   **Includes & Reusable Components**
            *   Creating Partial Templates (Headers, Footers, Sidebars)
            *   Passing Data into Includes
    *   **B. The Data Cascade: Sourcing and Using Data**
        *   Hierarchy of Data Precedence (The Cascade)
        *   Front Matter Data (in individual templates)
        *   Template & Directory Data Files (`.json`, `.js`)
        *   Global Data Files (in `_data` directory)
        *   Computed Data for Dynamic Values
        *   Fetching Remote Data at Build Time (e.g., from a Headless CMS or API)
    *   **C. Collections: Grouping & Navigating Content**
        *   The Default `collections.all`
        *   Creating Collections with Tags in Front Matter
        *   Custom Collections using `addCollection` in `.eleventy.js`
            *   Filtering, Sorting, and Modifying Content Items
            *   Creating Relationships Between Content
        *   Pagination: Automatically Generating Pages for a Collection
            *   Paginating a Collection (e.g., for a blog index)
            *   Paginating Data from a Global Data File
    *   **D. Extending Templates: Shortcodes, Filters & Plugins**
        *   **Filters**: Modifying data within a template (e.g., `{{ myDate | dateFilter }}`)
        *   **Shortcodes**: Injecting reusable HTML or logic (e.g., `{% image "cat.jpg" %}`)
        *   **Paired Shortcodes**: Wrapping content (e.g., `{% callout %}...{% endcallout %}`)
        *   Discovering and Using Official & Community Plugins

*   **Part IV: Asset Pipeline & Frontend Build Process**
    *   **A. Fundamentals of the Asset Pipeline**
        *   Understanding What Eleventy Processes vs. What It Ignores
        *   Passthrough File Copy for Static Assets (Images, Fonts, CSS)
    *   **B. Processing CSS & JavaScript**
        *   Strategies for Integrating Pre-processors (Sass, PostCSS)
        *   Bundling and Minifying JavaScript (e.g., with esbuild or Rollup)
        *   Using Eleventy as a Conductor for other Build Tools
    *   **C. Image Optimization**
        *   Using the Official `eleventy-img` Plugin
        *   Generating Multiple Sizes and Modern Formats (WebP, AVIF)
        *   Automating `<img>` and `<picture>` Markup Generation
    *   **D. Event-Driven Build Customization**
        *   Hooking into the Build Process with Events (`before`, `after`, etc.)
        *   Running Custom Scripts during the Build (e.g., generating a search index)

*   **Part V: Performance & Optimization**
    *   **A. Build Performance Optimization**
        *   Incremental Builds for Faster Development
        *   Using `.eleventyignore` to reduce the build scope
        *   Efficient Data Fetching and Caching (with `eleventy-fetch` plugin)
    *   **B. Frontend Performance Optimization**
        *   Minifying HTML, CSS, and JS Output
        *   Inlining Critical CSS for Faster First Paint
        *   Lazy Loading Images and other Offscreen Content
        *   Generating a Service Worker for Offline Capabilities
    *   **C. Scalability for Large Sites**
        *   Strategies for Managing Thousands of Pages
        *   Memory Management during Large Builds
        *   On-Demand Builders and Distributed Rendering

*   **Part VI: Development Workflow, Deployment & Maintenance**
    *   **A. Development Workflow**
        *   Leveraging the Dev Server and Hot-Reloading
        *   Debugging Data and Variables (`{{ myVar | log }}`)
        *   Creating Content Drafts
    *   **B. Integrating with a Headless CMS**
        *   Connecting to Popular CMSes (Contentful, Sanity, Strapi, etc.)
        *   Fetching Data in the Global `_data` Directory
        *   Setting up Webhooks to Trigger Automatic Builds on Content Changes
    *   **C. Testing & Quality Assurance**
        *   Linting and Formatting Code (ESLint, Prettier)
        *   Strategies for Testing Generated HTML Output
        *   Accessibility (a11y) Auditing
    *   **D. Deployment & Hosting (CI/CD)**
        *   Preparing the Project for Deployment
        *   Deploying to Static Hosting Platforms (Netlify, Vercel, GitHub Pages)
        *   Configuring a CI/CD Pipeline for Automated Builds and Deploys
        *   Using Environment Variables for Different Builds (Dev vs. Prod)

*   **Part VII: Advanced & Ecosystem Topics**
    *   **A. Adding Dynamic Functionality**
        *   Serverless Functions (for forms, authentication, etc.)
        *   Eleventy Edge for Dynamic Content at the Edge
        *   Client-side JavaScript for Interactivity
    *   **B. Specialized Use Cases**
        *   Internationalization (i18n) and Localization
        *   Building a Documentation Site
        *   Generating non-HTML files (RSS Feeds, Sitemaps, JSON APIs)
    *   **C. The Future of Eleventy & Web Development**
        *   Web Components and Eleventy
        *   Island Architecture Patterns
        *   The Evolving Eleventy Ecosystem and Roadmap
```