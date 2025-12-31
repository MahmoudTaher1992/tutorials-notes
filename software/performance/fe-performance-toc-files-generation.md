Here is the bash script to generate the directory and file structure based on your Frontend Performance Table of Contents.

You can copy this code, save it as a file (e.g., `setup-performance-study.sh`), make it executable (`chmod +x setup-performance-study.sh`), and run it.

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="Frontend-Performance-Study"

# Create Root Directory
echo "Creating root directory: $ROOT_DIR"
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

# ==========================================
# PART I: Foundations & The "Why" of Performance
# ==========================================
DIR_NAME="001-Foundations-And-The-Why"
mkdir -p "$DIR_NAME"

# File 1
cat << 'EOF' > "$DIR_NAME/001-Introduction-to-Web-Performance.md"
# Introduction to Web Performance

- The Business Case for Performance (Conversion, Retention, Revenue)
- The User Experience Impact (Perception of Speed, Frustration)
- SEO and Performance (Google's Core Web Vitals)
- Establishing a Performance Culture in a Team
EOF

# File 2
cat << 'EOF' > "$DIR_NAME/002-Core-Metrics-And-Budgets.md"
# Core Performance Metrics & Budgets

- **Core Web Vitals (CWV)**
  - Largest Contentful Paint (LCP): Perceived Loading Speed
  - First Input Delay (FID) & Interaction to Next Paint (INP): Interactivity
  - Cumulative Layout Shift (CLS): Visual Stability
- **Traditional & Supporting Metrics**
  - Time to First Byte (TTFB): Server Response Time
  - First Contentful Paint (FCP): Initial Feedback
  - Time to Interactive (TTI): Page Usability
- **Setting Performance Budgets**
  - Defining Goals (e.g., < 1500KB total, < 3s LCP)
  - Tooling for Budget Enforcement (e.g., bundlesize, Lighthouse CI)
EOF

# File 3
cat << 'EOF' > "$DIR_NAME/003-Critical-Rendering-Path.md"
# Understanding the Critical Rendering Path (CRP)

- The Browser's Rendering Process (Parsing, Render Tree, Layout, Paint)
- Identifying and Optimizing Render-Blocking Resources (CSS, Synchronous JS)
- How `async` and `defer` Affect the CRP
EOF

# ==========================================
# PART II: Network & Delivery Optimization
# ==========================================
DIR_NAME="002-Network-And-Delivery"
mkdir -p "$DIR_NAME"

# File 1
cat << 'EOF' > "$DIR_NAME/001-Asset-Delivery-And-Protocols.md"
# Asset Delivery & Protocols

- Minimizing HTTP Requests (and the nuance with HTTP/2 & HTTP/3)
- HTTP/1.1 vs. HTTP/2 vs. HTTP/3 (Multiplexing, Header Compression)
- Gzip and Brotli Compression: Setup and Verification
- Leveraging a Content Delivery Network (CDN)
- Optimizing for TCP/SSL (Connection overhead)
EOF

# File 2
cat << 'EOF' > "$DIR_NAME/002-Caching-Strategies.md"
# Caching Strategies

- HTTP Caching Deep Dive
  - `Cache-Control`, `Expires`, `ETag`, `Last-Modified`
  - Patterns for different asset types (immutable assets vs. HTML)
- Service Workers for Advanced Caching
  - Caching Strategies (Cache First, Network First, Stale-While-Revalidate)
  - Offline Support
EOF

# File 3
cat << 'EOF' > "$DIR_NAME/003-Connection-And-Preloading.md"
# Connection & Pre-loading Techniques

- `preconnect`: Warming up connections to critical domains (e.g., APIs, font servers)
- `dns-prefetch`: Resolving DNS for third-party domains
- `preload`: Fetching high-priority resources for the current navigation
- `prefetch`: Fetching low-priority resources for future navigations
EOF

# ==========================================
# PART III: Asset Optimization (Code, Images, Fonts)
# ==========================================
DIR_NAME="003-Asset-Optimization"
mkdir -p "$DIR_NAME"

# File 1
cat << 'EOF' > "$DIR_NAME/001-JavaScript.md"
# JavaScript Optimization

- **Minification**: Removing whitespace, comments, and shortening variable names.
- **Code-Splitting & Tree Shaking**
  - Route-based splitting
  - Component-based splitting (`React.lazy`, dynamic `import()`)
  - Identifying and removing dead code (Tree Shaking)
- **Bundle Analysis**
  - Tools (Webpack Bundle Analyzer, Source Map Explorer, vite-plugin-visualizer)
  - Analyzing and Reducing Dependency Size (Bundlephobia)
- **Avoiding Unreachable Requests** (404s for JS files)
EOF

# File 2
cat << 'EOF' > "$DIR_NAME/002-CSS.md"
# CSS Optimization

- **Minification**: Removing comments and whitespace.
- **Critical CSS**
  - Identifying Above-the-Fold CSS
  - Inlining Critical CSS for faster FCP
  - Asynchronously loading the remaining CSS
- **Optimizing CSS Itself**
  - Removing Unused CSS (PurgeCSS, UnCSS)
  - Analyzing Stylesheet Complexity and Selector Performance
  - Avoiding `@import` in CSS files
  - Concatenation vs. HTTP/2 benefits
EOF

# File 3
cat << 'EOF' > "$DIR_NAME/003-Images.md"
# Image Optimization

- **Format Selection**
  - Vector (SVG) vs. Raster/Bitmap (JPEG, PNG)
  - Modern Formats (WebP, AVIF) and their use cases
  - Using the `<picture>` element for progressive enhancement
- **Compression and Sizing**
  - Lossy vs. Lossless Compression
  - Serving Responsive Images (`srcset`, `sizes` attributes)
  - Tools for optimization (Squoosh.app, ImageOptim)
- **Loading Strategy**
  - Native Lazy Loading (`loading="lazy"`)
  - Setting `width` and `height` to prevent CLS
  - Avoiding Base64 encoded images in initial load payloads
EOF

# File 4
cat << 'EOF' > "$DIR_NAME/004-Fonts.md"
# Font Optimization

- **Format and Subsetting**
  - Using WOFF2 for optimal compression
  - Font Subsetting (removing unused glyphs)
- **Loading Strategy**
  - `font-display` property (e.g., `swap`, `optional`) to prevent Flash of Invisible Text (FOIT)
  - Pre-loading key font files with `preload` and `preconnect`
EOF

# ==========================================
# PART IV: Runtime & Rendering Performance
# ==========================================
DIR_NAME="004-Runtime-And-Rendering"
mkdir -p "$DIR_NAME"

# File 1
cat << 'EOF' > "$DIR_NAME/001-Efficient-JavaScript-Execution.md"
# Efficient JavaScript Execution

- Understanding the Event Loop and the Main Thread
- Avoiding Long Tasks that block user interaction
- Throttling and Debouncing for event handlers (scroll, resize)
- Offloading heavy tasks to Web Workers or Service Workers
- Memoization and Caching Expensive Computations
EOF

# File 2
cat << 'EOF' > "$DIR_NAME/002-Rendering-Optimizations.md"
# Rendering Optimizations

- **DOM & Layout**
  - Minimizing DOM Size and Depth
  - Avoiding Layout Thrashing (batching DOM reads/writes)
  - Efficiently handling large lists (Virtualization / Windowing)
- **Animations & Transitions**
  - Using `transform` and `opacity` for hardware-accelerated animations
  - `requestAnimationFrame` vs. `setTimeout` for animation loops
  - The `will-change` CSS property: use cases and pitfalls
- **Third-Party Scripts**
  - Auditing impact (performance, security)
  - Loading strategies (`async`, `defer`, partytown)
EOF

# ==========================================
# PART V: Server-Side and Infrastructure Performance
# ==========================================
DIR_NAME="005-Server-Side-Infrastructure"
mkdir -p "$DIR_NAME"

# File 1
cat << 'EOF' > "$DIR_NAME/001-Server-Configuration.md"
# Server Configuration

- Achieving a low Time To First Byte (TTFB)
- Choosing Server Locations (proximity to users)
- Server-side Caching (Varnish, Redis)
- Ensuring HTTPS is enabled and configured correctly
EOF

# File 2
cat << 'EOF' > "$DIR_NAME/002-Modern-Rendering-Architectures.md"
# Modern Rendering Architectures

- **Server-Side Rendering (SSR)**: Benefits and tradeoffs for FCP/LCP.
- **Static Site Generation (SSG)**: The fastest approach for static content.
- **Incremental Static Regeneration (ISR)**: A hybrid approach.
- **Edge Computing**: Running logic closer to the user.
EOF

# ==========================================
# PART VI: Performance Auditing & Tooling
# ==========================================
DIR_NAME="006-Performance-Auditing-Tooling"
mkdir -p "$DIR_NAME"

# File 1
cat << 'EOF' > "$DIR_NAME/001-Lab-Data-Tools.md"
# Lab Data Tools (Controlled Environment)

- **Lighthouse**: Comprehensive audits in Chrome DevTools.
- **WebPageTest**: In-depth analysis from different locations and connection speeds.
- **Chrome DevTools**
  - Performance Panel (flame graphs, profiling)
  - Network Panel (waterfall charts, request analysis)
  - Rendering Panel (paint flashing, layout shift regions)
- **PageSpeed Insights**: Combines lab and field data with actionable advice.
EOF

# File 2
cat << 'EOF' > "$DIR_NAME/002-Field-Data-RUM.md"
# Field Data (Real User Monitoring - RUM)

- Collecting Core Web Vitals from actual users
- Using browser APIs (`PerformanceObserver`)
- RUM Services (Vercel Analytics, Google Analytics, Sentry, Datadog)
EOF

# File 3
cat << 'EOF' > "$DIR_NAME/003-CICD-And-Automation.md"
# CI/CD & Automation

- Integrating Lighthouse (Lighthouse CI) into your pull request checks
- Setting up performance budget assertions
- Automated image compression pipelines
EOF

# ==========================================
# PART VII: Framework-Specific Optimizations (e.g., React)
# ==========================================
DIR_NAME="007-Framework-Specific-Optimizations"
mkdir -p "$DIR_NAME"

# File 1
cat << 'EOF' > "$DIR_NAME/001-Avoiding-Unnecessary-Rerenders.md"
# Avoiding Unnecessary Re-Renders

- `React.memo` for functional components
- `useMemo` for expensive calculations
- `useCallback` for memoizing functions passed to child components
- Understanding dependency arrays in hooks
EOF

# File 2
cat << 'EOF' > "$DIR_NAME/002-Code-Splitting-Lazy-Loading.md"
# Code Splitting & Lazy Loading

- `React.lazy` and `<Suspense>` for component-level splitting
- Framework-level splitting (e.g., Next.js page-based splitting)
EOF

# File 3
cat << 'EOF' > "$DIR_NAME/003-State-Management.md"
# State Management

- Selector optimization in Redux/Zustand to prevent over-rendering
- Choosing the right tool (Context API vs. global state libraries) for performance
EOF

echo "Frontend Performance Study structure created successfully in ./$ROOT_DIR"
```
