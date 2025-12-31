This section of the roadmap focuses on one of Cloudflare’s primary value propositions: making websites faster and reducing the load on your origin server.

Here is a detailed breakdown of **002-Application-Services/001-Performance-and-Caching.md**.

---

# Part II: Application Services (Security & Performance)
## A. Performance & Caching

This module covers how Cloudflare sits between your users and your server (the "Origin") to speed up content delivery and ensure your site stays online even if your server struggles.

### 1. The Cloudflare Cache
The core of Cloudflare is its massive network of data centers (the Edge). Caching means storing copies of your files on these Edge servers so users download them from a location near them, rather than your server halfway across the world.

*   **Caching Fundamentals (TTL, Headers, ETag):**
    *   **TTL (Time To Live):** This determines how long a file stays on Cloudflare's servers before Cloudflare asks your server for a fresh copy.
    *   **Cache-Control Headers:** Cloudflare respects the headers your server sends. If your server sends `Cache-Control: max-age=3600`, Cloudflare will cache that file for one hour.
    *   **ETag:** A unique identifier for a file version. It allows Cloudflare to ask your server, "Has this file changed?" If the ETag is the same, your server says "No change," saving bandwidth.

*   **Default Cache Behavior (Static Content):**
    *   **The "Gotcha":** By default, Cloudflare **only** caches static files based on file extensions (e.g., `.css`, `.js`, `.jpg`, `.png`).
    *   **HTML is NOT cached by default:** If a user visits `yoursite.com/about-us`, Cloudflare proxies the request to your server every single time because it assumes HTML is dynamic (logged-in users, changing data).

*   **Customizing Caching (Page Rules & Cache Rules):**
    *   You often want to override default behavior.
    *   **Cache Rules (New):** The modern, granular way to control caching.
    *   **Page Rules (Classic):** The older method.
    *   **Example Use Case:** You have a WordPress blog. The HTML doesn't change often. You can create a rule to **"Cache Everything"** on `yoursite.com/blog/*`. Now, even the HTML is served from the edge, making the site instant.

*   **The Cache API:**
    *   This is for **Cloudflare Workers** (programmatic control). instead of relying on URL patterns, you can write code to check the cache, modify the response, and store it back.
    *   *Example:* You can cache a response to a specific API query (e.g., "Get Weather") inside a Worker script.

*   **Tiered Caching (Argo):**
    *   **Without Tiered Cache:** If you have visitors in London, Tokyo, and Sydney, the Cloudflare data centers in all three cities will ask your Origin server for the file *individually*. That is 3 requests to your server.
    *   **With Tiered Cache:** Cloudflare designates a "regional hub." The London, Tokyo, and Sydney edges ask the Hub. The Hub asks your server **once**.
    *   **Benefit:** dramatically reduces load on your server and saves on egress (bandwidth) costs.

### 2. Content Optimization
These are features that modify the actual code or assets of your site "on the fly" as they pass through Cloudflare, making them smaller and faster to download.

*   **Auto Minify:**
    *   Cloudflare removes unnecessary characters from your code (whitespace, comments, newlines) in HTML, CSS, and JavaScript files.
    *   *Result:* Slightly smaller file sizes without changing functionality.

*   **Brotli Compression:**
    *   Standard compression is Gzip. Brotli is a newer algorithm (supported by Google) that compresses files roughly 15-20% smaller than Gzip. Cloudflare handles this negotiation with the browser automatically.

*   **Polish (Image Optimization):**
    *   *Lossless:* Strips metadata (camera info, date taken) from images to reduce size.
    *   *Lossy:* Slightly reduces image quality (often unnoticeable to the human eye) to drastically reduce file size.
    *   *WebP Generation:* If a visitor's browser supports WebP (a modern, efficient image format), Cloudflare can convert your JPEGs/PNGs to WebP on the fly, serving a smaller file.

*   **Mirage:**
    *   Designed for mobile devices on slow networks.
    *   It lazy-loads images (only loads them when the user scrolls to them) and sends low-resolution placeholders first so the page looks "complete" instantly, then fills in the high-res image.

### 3. Routing & Reliability
This section moves beyond file storage into how data travels across the internet.

*   **Argo Smart Routing:**
    *   The "Internet's GPS." The standard path across the internet (BGP) looks for the shortest path, but that path might be congested.
    *   Argo analyzes real-time traffic across Cloudflare's massive network to route your traffic around congestion, packet loss, or cable cuts. It costs extra but decreases latency (lag).

*   **Load Balancing:**
    *   If you have **multiple** servers (e.g., one in the US, one in Europe), Cloudflare acts as the traffic controller.
    *   **Steering Policies:** You can route US users to the US server and EU users to the EU server (Geo-steering).
    *   **Health Checks:** Cloudflare constantly pings your servers. If the US server crashes, Cloudflare instantly stops sending traffic there and reroutes it to Europe.

*   **Always Online™:**
    *   If your origin server goes completely down (crashes, hosting error), Cloudflare steps in.
    *   It serves a limited version of your site from the Internet Archive (Wayback Machine) or its own internal cache.
    *   *Benefit:* Users see your content instead of a scary `502 Bad Gateway` error page, preserving your reputation while you fix the server.
