Based on the Table of Contents you provided, here is a detailed explanation of **Part IV, Section B: Amazon CloudFront**.

---

# Part IV - B: Amazon CloudFront (Content Delivery Network - CDN)

**Amazon CloudFront** is AWS’s Content Delivery Network (CDN).

**The Concept:** Imagine a pizza shop located in Italy. If you order a pizza from New York, it will arrive cold and take a long time (high latency). However, if that Italian shop opens a local branch in New York, you get the pizza fast and hot.
*   **The "Italian Shop"** is your **Origin Server** (e.g., S3 Bucket, EC2).
*   **The "New York Branch"** is the **Edge Location**.
*   **CloudFront** is the delivery system connecting them.

Here is the breakdown of the specific topics listed in your TOC:

### 1. How CloudFront Improves Performance with Edge Locations
CloudFront speeds up the distribution of your static and dynamic web content (like .html, .css, .js, and image files) to users using a global network of data centers known as **Edge Locations**.

*   **Global Network:** AWS has hundreds of Edge Locations scattered around the world (more than there are AWS Regions/Availability Zones).
*   **The Workflow:**
    1.  A user in London requests a file from your website (hosted in an S3 bucket in Virginia, USA).
    2.  DNS routes the user to the nearest CloudFront **Edge Location** (in London).
    3.  **Cache Hit:** If the file is already at the London Edge Location, it is delivered immediately (extremely fast).
    4.  **Cache Miss:** If the file is *not* there, the Edge Location requests it from the **Origin** (Virginia), delivers it to the user, and **caches (saves) it** locally in London for the next user.
*   **Regional Edge Caches:** An intermediate layer between the Edge Locations and the Origin to further reduce the load on your servers.

### 2. Distributions: Web vs. RTMP
A **Distribution** is the configuration unit within CloudFront. It tells CloudFront where your original content lives and how to track and manage it.

*   **Web Distribution:**
    *   This is the standard distribution used for HTTP and HTTPS protocols.
    *   **Use Cases:** Static websites, image files, CSS/JS, and even dynamic content (Rest APIs). It acts as the front door for almost all modern applications.
*   **RTMP Distribution (Legacy/Deprecated):**
    *   *Note: As of December 2020, AWS deprecated RTMP distributions.*
    *   Historically, this was used for streaming media using Adobe Flash Media Server’s RTMP protocol.
    *   **Modern Approach:** Today, you should use a standard **Web Distribution** for video streaming via protocols like Apple HLS (HTTP Live Streaming) or MPEG-DASH.

### 3. Origins and Behaviors (Caching Rules)
To configure a distribution, you must define the **Origin** and the **Behavior**.

*   **Origins:**
    *   This is the source of the truth—where the original file lives.
    *   **Common Origins:** Amazon S3 buckets, EC2 instances, Elastic Load Balancers (ELB), or even your own on-premise servers.
*   **Behaviors:**
    *   These allow you to configure different logic based on the URL path.
    *   *Example:* You can have one behavior for `*.jpg` (Cache for 24 hours) and another for `/api/*` (Do not cache; forward request directly to the server).
    *   **TTL (Time To Live):** This setting determines how long an object stays in the edge cache before CloudFront goes back to the origin to check for a new version (Default is usually 24 hours).
    *   **Invalidation:** If you update a file on your server, the Edge Location still has the old one cached. You perform an "Invalidation" to force CloudFront to delete the cache and fetch the new version immediately.

### 4. Securing Content with HTTPS and Signed URLs/Cookies
CloudFront is not just for speed; it is also for security (security at the Edge).

*   **HTTPS Support:**
    *   You can upload your own SSL/TLS certificate or use **AWS Certificate Manager (ACM)** to get a free public SSL certificate. This ensures traffic between the user and CloudFront is encrypted.
*   **Restricted Content:** Sometimes you want to serve premium content (like Netflix movies) that only paid users can see.
    *   **Signed URLs:** You generate a special URL (valid for a limited time) for a specific file. Best for individual file access.
    *   **Signed Cookies:** Used when you want to give access to groups of files (e.g., logging into a subscriber area and accessing all premium videos).
*   **Geo-Restriction:** You can block or allow specific countries from accessing your content (e.g., licensing rights allow a movie to be shown in the US but not in France).

### 5. CloudFront with S3 for Accelerated Content Delivery
This is one of the most common architectural patterns in AWS.

*   **The Problem:** If you leave an S3 bucket public, anyone can download files. This puts a heavy load on S3, costs more, and is slower for international users.
*   **The Solution (CloudFront + S3):**
    1.  **OAC (Origin Access Control) / OAI (Origin Access Identity):** You create a virtual identity for CloudFront. You then edit the S3 Bucket Policy to say: *"Deny everyone, EXCEPT this CloudFront Identity."*
    2.  Now, users **cannot** access the S3 bucket link directly. They **must** go through the CloudFront URL.
*   **Benefits:**
    *   **Security:** Your S3 bucket is private; only CloudFront can see it.
    *   **Speed:** Users get content from the Edge.
    *   **Cost:** Data transfer from S3 to CloudFront is often cheaper (or free) compared to data transfer directly from S3 to the public internet.

---

### Summary Checklist for the Exam/Study:
1.  **Reduced Latency:** CloudFront brings content closer to the user.
2.  **S3 Integration:** Always use OAI/OAC to keep S3 buckets private while serving content via CloudFront.
3.  **Caching:** Understand TTL (how long files stay) and Invalidation (how to remove files early).
4.  **Security:** Know the difference between Signed URLs (one file) and Signed Cookies (many files).
