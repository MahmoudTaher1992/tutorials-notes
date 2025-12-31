Here is the bash script to generate the folder and file structure for your **Lighthouse and Web Performance** study guide.

### Instructions:
1.  Copy the code block below.
2.  Open your terminal in Ubuntu.
3.  Create a new script file: `nano setup_lighthouse_study.sh`
4.  Paste the code into the file.
5.  Save and exit (Ctrl+O, Enter, Ctrl+X).
6.  Make the script executable: `chmod +x setup_lighthouse_study.sh`
7.  Run the script: `./setup_lighthouse_study.sh`

```bash
#!/bin/bash

# Define root directory name
ROOT_DIR="Lighthouse-Performance-Study"

# Create root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating study structure in: $(pwd)"

# ==============================================================================
# Part I: Fundamentals of Web Performance & Lighthouse
# ==============================================================================
DIR_01="001-Fundamentals-of-Web-Performance-Lighthouse"
mkdir -p "$DIR_01"

# A. Introduction to Web Performance
cat <<EOF > "$DIR_01/001-Introduction-to-Web-Performance.md"
# Introduction to Web Performance

* The User-Centric View vs. The Technical View of Performance
* Why Performance Matters: User Experience, Conversion, and SEO
* Core Concepts in Performance
    * The Critical Rendering Path
    * Loading vs. Rendering vs. Interactivity
    * Perceived Performance vs. Actual Metrics
EOF

# B. What is Lighthouse?
cat <<EOF > "$DIR_01/002-What-is-Lighthouse.md"
# What is Lighthouse?

* History, Philosophy, and Motivation (from PageSpeed to a comprehensive auditing tool)
* Purpose: An automated tool for improving the quality of web pages
* The Five Categories: Performance, Accessibility, Best Practices, SEO, and PWA
EOF

# C. The Core Web Vitals (CWV)
cat <<EOF > "$DIR_01/003-The-Core-Web-Vitals-CWV.md"
# The Core Web Vitals (CWV)

* Understanding the Vitals as the Foundation of User Experience
* **LCP (Largest Contentful Paint):** Measuring Loading Performance
* **INP (Interaction to Next Paint):** Measuring Responsiveness & Interactivity (Successor to FID)
* **CLS (Cumulative Layout Shift):** Measuring Visual Stability
EOF

# D. Lab Data vs. Field Data (Real User Monitoring - RUM)
cat <<EOF > "$DIR_01/004-Lab-Data-vs-Field-Data.md"
# Lab Data vs. Field Data (Real User Monitoring - RUM)

* Lighthouse as a Source of "Lab Data" (Controlled Environment)
* The Chrome User Experience Report (CrUX) as a Source of "Field Data"
* Understanding the Differences and Why Both are Essential
EOF


# ==============================================================================
# Part II: Running Audits & Understanding Reports
# ==============================================================================
DIR_02="002-Running-Audits-Understanding-Reports"
mkdir -p "$DIR_02"

# A. Execution Environments & Tools
cat <<EOF > "$DIR_02/001-Execution-Environments-Tools.md"
# Execution Environments & Tools

* **In-Browser:** Chrome DevTools (Audits/Lighthouse Panel)
* **Web-Based:** PageSpeed Insights & web.dev/measure
* **Command Line:** Lighthouse CLI (\`npm install -g lighthouse\`)
* **Programmatic:** The Lighthouse Node.js module
EOF

# B. Configuration and Audit Context
cat <<EOF > "$DIR_02/002-Configuration-and-Audit-Context.md"
# Configuration and Audit Context

* Desktop vs. Mobile Emulation
* Simulated Throttling vs. Applied Throttling
* Clearing Storage & Running in Incognito
* Auditing Authenticated Pages and User Flows (Recipes)
EOF

# C. Anatomy of a Lighthouse Report
cat <<EOF > "$DIR_02/003-Anatomy-of-a-Lighthouse-Report.md"
# Anatomy of a Lighthouse Report

* The Score Gauges: Interpreting the 0-100 scale
* The Metrics Section: Raw values and color-coding
* "Opportunities": Actionable suggestions to improve performance
* "Diagnostics": Additional information about app performance
* "Passed Audits": What you're doing right
EOF


# ==============================================================================
# Part III: Deep Dive into the Performance Score
# ==============================================================================
DIR_03="003-Deep-Dive-into-the-Performance-Score"
mkdir -p "$DIR_03"

# A. Metrics Breakdown
cat <<EOF > "$DIR_03/001-Metrics-Breakdown.md"
# Metrics Breakdown

* **FCP (First Contentful Paint):** The first moment of content
* **SI (Speed Index):** How quickly content is visually populated
* **LCP (Largest Contentful Paint):** Perceived loading speed
* **TTI (Time to Interactive):** When the page is fully interactive
* **TBT (Total Blocking Time):** Quantifying main-thread blockage
* **CLS (Cumulative Layout Shift):** Visual stability during load
* **INP (Interaction to Next Paint):** Real-user interaction latency
EOF

# B. Key "Opportunities" & "Diagnostics" Explained
cat <<EOF > "$DIR_03/002-Key-Opportunities-Diagnostics-Explained.md"
# Key "Opportunities" & "Diagnostics" Explained

* **Resource Optimization**
    * Eliminate render-blocking resources (CSS/JS)
    * Properly size images & Serve images in next-gen formats (AVIF, WebP)
    * Efficiently encode images & Defer offscreen images (lazy loading)
    * Minify CSS & JavaScript
    * Remove unused CSS & JavaScript
    * Enable text compression (Gzip, Brotli)
* **Server & Network**
    * Reduce initial server response time (TTFB)
    * Use HTTP/2 or HTTP/3
    * Preconnect to required origins
* **JavaScript Execution**
    * Reduce JavaScript execution time
    * Avoid long main-thread tasks
    * Minimize main-thread work
EOF

# C. Rendering Path Optimization
cat <<EOF > "$DIR_03/003-Rendering-Path-Optimization.md"
# Rendering Path Optimization

* Understanding how fonts affect rendering (\`font-display\`)
* The impact of third-party code
* Avoiding non-composited animations
EOF


# ==============================================================================
# Part IV: Auditing Beyond Performance
# ==============================================================================
DIR_04="004-Auditing-Beyond-Performance"
mkdir -p "$DIR_04"

# A. The Accessibility (a11y) Score
cat <<EOF > "$DIR_04/001-The-Accessibility-a11y-Score.md"
# The Accessibility (a11y) Score

* The Role of Automated vs. Manual Accessibility Testing
* Common Audit Groups
    * Contrast Ratios
    * ARIA Roles and Attributes
    * Names, Labels, and Alternative Text
    * Document Structure (Headings, Landmarks)
EOF

# B. The Best Practices Score
cat <<EOF > "$DIR_04/002-The-Best-Practices-Score.md"
# The Best Practices Score

* What "Best Practices" Means: Web Hygiene and Security
* Common Audit Groups
    * Trust & Safety: HTTPS, avoiding vulnerable libraries
    * User Experience: Preventing \`document.write()\`, proper aspect ratios
    * Browser Compatibility & General Health
EOF

# C. The SEO Score
cat <<EOF > "$DIR_04/003-The-SEO-Score.md"
# The SEO Score

* The Role of Automated vs. Holistic SEO Strategy
* Common Audit Groups
    * Crawlability & Indexability (\`robots.txt\`, \`meta\` tags)
    * Content Quality (Legible font sizes, tap targets)
    * Mobile Friendliness (\`<meta name="viewport">\`)
EOF


# ==============================================================================
# Part V: Automation, Monitoring, and Integration
# ==============================================================================
DIR_05="005-Automation-Monitoring-and-Integration"
mkdir -p "$DIR_05"

# A. Programmatic Usage
cat <<EOF > "$DIR_05/001-Programmatic-Usage.md"
# Programmatic Usage

* **Lighthouse CLI:**
    * Core commands and flags (\`--output\`, \`--view\`, \`--only-categories\`)
    * Working with JSON and HTML output
* **Using the Node Module:**
    * Basic programmatic runs
    * Advanced control with Puppeteer for complex user flows
EOF

# B. Integration into the Development Lifecycle (CI/CD)
cat <<EOF > "$DIR_05/002-Integration-into-Development-Lifecycle.md"
# Integration into the Development Lifecycle (CI/CD)

* Introducing Lighthouse CI (LHCI)
* Configuration (\`lighthouserc.js\`)
* Setting Performance Budgets (\`budget.json\`) to prevent regressions
* Integrating with GitHub Actions, Jenkins, etc.
EOF

# C. Monitoring and Trending Over Time
cat <<EOF > "$DIR_05/003-Monitoring-and-Trending-Over-Time.md"
# Monitoring and Trending Over Time

* Collecting and storing historical Lighthouse data
* Visualizing trends with dashboards
* Third-party services for performance monitoring (SpeedCurve, Calibre, etc.)
EOF


# ==============================================================================
# Part VI: Advanced Techniques & Broader Context
# ==============================================================================
DIR_06="006-Advanced-Techniques-Broader-Context"
mkdir -p "$DIR_06"

# A. Advanced Auditing Scenarios
cat <<EOF > "$DIR_06/001-Advanced-Auditing-Scenarios.md"
# Advanced Auditing Scenarios

* Auditing Single-Page Applications (SPAs) and navigation transitions
* Using Puppeteer scripts to audit user journeys (e.g., add-to-cart)
* Handling cookies and authentication
EOF

# B. Extending Lighthouse
cat <<EOF > "$DIR_06/002-Extending-Lighthouse.md"
# Extending Lighthouse

* Creating Custom Audits: Writing Gatherers and Audits
* Using Stack Packs for framework-specific advice (e.g., React, Angular)
EOF

# C. Lighthouse in the Wider Performance Ecosystem
cat <<EOF > "$DIR_06/003-Lighthouse-in-the-Wider-Performance-Ecosystem.md"
# Lighthouse in the Wider Performance Ecosystem

* Comparison with other tools: WebPageTest, Chrome Performance Profiler
* Combining Lab (Lighthouse) and Field (CrUX) data for a complete picture
* Connecting Performance Metrics to Business KPIs
EOF


# ==============================================================================
# Part VII: From Audit to Action: A Practical Workflow
# ==============================================================================
DIR_07="007-From-Audit-to-Action-Practical-Workflow"
mkdir -p "$DIR_07"

# A. Triage and Prioritization
cat <<EOF > "$DIR_07/001-Triage-and-Prioritization.md"
# Triage and Prioritization

* Identifying the low-hanging fruit vs. high-effort fixes
* Mapping opportunities to the Core Web Vitals they impact
EOF

# B. A Case Study: Optimizing a Sample Website
cat <<EOF > "$DIR_07/002-A-Case-Study-Optimizing-a-Sample-Website.md"
# A Case Study: Optimizing a Sample Website

* Initial Audit and Establishing a Baseline
* Implementing Key Fixes (Images, JS, CSS)
* Measuring the Impact and Verifying Improvements
EOF

# C. Cultivating a Performance Culture
cat <<EOF > "$DIR_07/003-Cultivating-a-Performance-Culture.md"
# Cultivating a Performance Culture

* Making performance a shared responsibility
* Communicating results to stakeholders
EOF

echo "Done! Structure created in $ROOT_DIR"
```
