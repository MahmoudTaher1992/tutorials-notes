Here is the bash script to generate the directory and file structure for your `Cache-Control` study guide.

To use this:
1.  Copy the code block below.
2.  Save it as a file on your Ubuntu machine (e.g., `setup-caching-guide.sh`).
3.  Make it executable: `chmod +x setup-caching-guide.sh`.
4.  Run it: `./setup-caching-guide.sh`.

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="Web-Caching-Guide"

# Create the root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating directory structure in $(pwd)..."

# ==========================================
# PART I: Fundamentals of Web Caching
# ==========================================
DIR_01="001-Fundamentals-of-Web-Caching"
mkdir -p "$DIR_01"

# A. The "Why": Core Motivations & Benefits
cat <<EOF > "$DIR_01/001-The-Why-Core-Motivations.md"
# The "Why": Core Motivations & Benefits

* Reducing Latency: The Impact on User Experience
* Reducing Bandwidth Consumption: The Impact on Cost
* Reducing Server Load: The Impact on Scalability & Infrastructure
* Improving Reliability: Offline Access & Resilience
EOF

# B. How Web Caching Works: The Big Picture
cat <<EOF > "$DIR_01/002-How-Web-Caching-Works.md"
# How Web Caching Works: The Big Picture

* The Request-Response Flow with and without a Cache
* A Taxonomy of Caches:
    * **Private Caches:** Browser Cache
    * **Shared Caches:** Proxy Caches, Gateway/Reverse Proxy Caches (Nginx, Varnish), and Content Delivery Networks (CDNs)
EOF

# C. Key HTTP Caching Concepts
cat <<EOF > "$DIR_01/003-Key-HTTP-Caching-Concepts.md"
# Key HTTP Caching Concepts

* **Freshness:** Determining if a cached resource can be used without checking the origin server.
* **Validation:** Checking with the origin server if a stale resource is still valid.
* Cacheable vs. Non-Cacheable Responses (Defaults for HTTP Methods and Status Codes)
* Strong vs. Weak Validation
EOF

# ==========================================
# PART II: The Cache-Control Header
# ==========================================
DIR_02="002-The-Cache-Control-Header"
mkdir -p "$DIR_02"

# A. Syntax and Core Principles
cat <<EOF > "$DIR_02/001-Syntax-and-Core-Principles.md"
# Syntax and Core Principles

* Header Format: \`Cache-Control: <directive1>, <directive2>, ...\`
* Request vs. Response Directives (Client hints vs. Server instructions)
EOF

# B. Controlling Cacheability
cat <<EOF > "$DIR_02/002-Controlling-Cacheability.md"
# Controlling Cacheability (Can this be stored?)

* \`public\`: Can be stored by any cache (private or shared).
* \`private\`: Intended for a single user; must not be stored by a shared cache.
* \`no-store\`: The most restrictive; do not store the response in *any* cache.
* \`no-cache\`: Must revalidate with the origin server before using a cached copy (The name is misleading!).
EOF

# C. Controlling Expiration
cat <<EOF > "$DIR_02/003-Controlling-Expiration.md"
# Controlling Expiration (How long is it fresh?)

* \`max-age=<seconds>\`: The primary modern directive for freshness lifetime.
* \`s-maxage=<seconds>\`: Overrides \`max-age\` for shared caches only (essential for CDNs).
* The Legacy \`Expires\` Header (And its precedence relative to \`max-age\`).
EOF

# D. Controlling Revalidation
cat <<EOF > "$DIR_02/004-Controlling-Revalidation.md"
# Controlling Revalidation (How to behave when stale?)

* \`must-revalidate\`: A stale response *must* be successfully revalidated before use.
* \`proxy-revalidate\`: Same as \`must-revalidate\`, but only applies to shared caches.
EOF

# E. Advanced & Modern Directives
cat <<EOF > "$DIR_02/005-Advanced-and-Modern-Directives.md"
# Advanced & Modern Directives

* \`immutable\`: Indicates the response body will not change over time. A powerful hint for aggressive caching.
* \`stale-while-revalidate=<seconds>\`: Serve stale content while revalidating in the background (improves latency).
* \`stale-if-error=<seconds>\`: Serve stale content if the origin server returns an error (improves reliability).
EOF

# ==========================================
# PART III: Validation and Conditional Requests
# ==========================================
DIR_03="003-Validation-and-Conditional-Requests"
mkdir -p "$DIR_03"

# A. The Validation Mechanism
cat <<EOF > "$DIR_03/001-The-Validation-Mechanism.md"
# The Validation Mechanism

* Saving Bandwidth with the \`304 Not Modified\` Status Code.
EOF

# B. Validators: The Foundation of Conditional Requests
cat <<EOF > "$DIR_03/002-Validators.md"
# Validators: The Foundation of Conditional Requests

* \`ETag\` (Entity Tag) Header: The preferred, strong validator.
    * How ETags are generated (e.g., hash of content).
    * Strong vs. Weak ETags (e.g., \`W/"<etag>"\`).
* \`Last-Modified\` Header: The date-based, weaker validator.
    * Limitations (e.g., timestamp resolution, distributed systems).
EOF

# C. Conditional Request Headers (The Client's Side)
cat <<EOF > "$DIR_03/003-Conditional-Request-Headers.md"
# Conditional Request Headers (The Client's Side)

* \`If-None-Match\`: The counterpart to \`ETag\`. "Get the resource only if the ETag is different."
* \`If-Modified-Since\`: The counterpart to \`Last-Modified\`. "Get the resource only if modified since this date."
* Other conditional headers (\`If-Match\`, \`If-Unmodified-Since\`).
EOF

# D. Precedence Rules
cat <<EOF > "$DIR_03/004-Precedence-Rules.md"
# Precedence Rules

* Why \`ETag\` / \`If-None-Match\` is generally preferred over \`Last-Modified\` / \`If-Modified-Since\`.
EOF

# ==========================================
# PART IV: Practical Strategies, Patterns & Pitfalls
# ==========================================
DIR_04="004-Practical-Strategies-Patterns-and-Pitfalls"
mkdir -p "$DIR_04"

# A. Caching Strategies by Content Type
cat <<EOF > "$DIR_04/001-Caching-Strategies-by-Content-Type.md"
# Caching Strategies by Content Type

* **Static Assets (CSS, JS, Images):** Long \`max-age\` + \`immutable\` with cache-busting.
* **Application "Shell" (HTML):** \`no-cache\` or a very short \`max-age\` to ensure revalidation.
* **API Responses (Dynamic Content):** Short \`max-age\`, \`private\`, or \`no-cache\`.
* **User-Specific Data:** \`private, no-store\`.
EOF

# B. Cache Invalidation ("Cache Busting")
cat <<EOF > "$DIR_04/002-Cache-Invalidation.md"
# Cache Invalidation ("Cache Busting")

* URL Fingerprinting / Hashing (e.g., \`style.a3b4c5d6.css\`).
* Query String Versioning (e.g., \`script.js?v=1.2.0\`).
* The role of modern build tools (Webpack, Vite, etc.).
EOF

# C. The Vary Header
cat <<EOF > "$DIR_04/003-The-Vary-Header.md"
# The \`Vary\` Header: Caching Multiple Representations

* What is it and why is it essential?
* Common use cases: \`Vary: Accept-Encoding\`, \`Vary: Accept-Language\`, \`Vary: Cookie\`.
* The dangers of overusing \`Vary\` (fragmenting the cache).
EOF

# D. Common Pitfalls and Anti-Patterns
cat <<EOF > "$DIR_04/004-Common-Pitfalls-and-Anti-Patterns.md"
# Common Pitfalls and Anti-Patterns

* Confusing \`no-cache\` with \`no-store\`.
* Forgetting \`private\` on authenticated responses.
* Caching error responses (\`4xx\`, \`5xx\`) unintentionally.
* Forgetting \`Vary: Accept-Encoding\` when using Gzip/Brotli compression.
* Inconsistent headers across your infrastructure (App vs. CDN vs. Proxy).
EOF

# ==========================================
# PART V: Tooling, Debugging & Implementation
# ==========================================
DIR_05="005-Tooling-Debugging-and-Implementation"
mkdir -p "$DIR_05"

# A. Auditing and Debugging Caching Behavior
cat <<EOF > "$DIR_05/001-Auditing-and-Debugging.md"
# Auditing and Debugging Caching Behavior

* Using Browser Developer Tools (Network Tab, \`Cache-Control\` headers, \`Disable cache\` option).
* Using Command-line Tools (\`curl -I\`, \`httpie\`).
* Web-based Checkers (e.g., Redbot, GiftOfSpeed).
EOF

# B. Implementation Across the Stack
cat <<EOF > "$DIR_05/002-Implementation-Across-the-Stack.md"
# Implementation Across the Stack

* **Application-Level:** Setting headers programmatically in API code (Node.js/Express, ASP.NET Core, etc.).
* **Web Server / Reverse Proxy:** Configuring headers in Nginx, Apache, or Caddy.
* **CDN Configuration:** Setting cache policies and TTLs in Cloudflare, Fastly, AWS CloudFront, etc.
EOF

# C. Caching and Security Considerations
cat <<EOF > "$DIR_05/003-Caching-and-Security-Considerations.md"
# Caching and Security Considerations

* Preventing leakage of private data via shared caches.
* Cache-Poisoning and Deception Attacks.
* Interaction with \`Set-Cookie\` and \`Authorization\` headers.
EOF

echo "Done! Structure created in '$ROOT_DIR'."
```
