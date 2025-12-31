Here is a detailed explanation of **Part IV: Edge Data & Storage Solutions — Section B: R2 Storage**.

---

# 002-R2-Storage (Object Storage)

**Cloudflare R2** is Cloudflare's object storage solution. If you are familiar with Amazon S3 (Simple Storage Service), Google Cloud Storage, or Azure Blob Storage, R2 is the direct equivalent. It is designed to store large amounts of unstructured data—files, images, videos, backups, and logs.

Here is a breakdown of the specific topics outlined in the Table of Contents.

---

### 1. S3-Compatibility and the "Zero Egress Fee" Advantage

This is the most significant selling point of R2 and what separates it from AWS S3.

*   **S3-Compatibility:** R2 implements the S3 API standard. This means you don't need to learn a proprietary Cloudflare language to talk to R2.
    *   **Tooling:** You can use the existing AWS SDK (JavaScript, Python, Go, etc.) to interact with R2.
    *   **Migration:** If you have an existing application using S3, you can often switch to R2 simply by changing the `endpoint` URL and the authentication credentials in your configuration. You rarely need to rewrite your code.
*   **The "Zero Egress Fee" Advantage:**
    *   **The Problem:** Traditional cloud providers (like AWS) charge you for storage (cheap) and charge you for **egress** (bandwidth used when data is downloaded out of their cloud). This is often the hidden cost that kills startups; if a file goes viral, your bill explodes.
    *   **The R2 Solution:** Cloudflare charges for storage, **but charges $0 for egress**. It does not matter if your file is downloaded 1 time or 1 million times; the bandwidth cost is free. This makes R2 incredibly cost-effective for high-traffic applications.

### 2. Use Cases: Storing Assets, User Uploads, Large Files

R2 is distinct from Workers KV (which is for tiny bits of data) and D1 (which is a database). R2 is for **files**.

*   **Media Hosting:** Storing images, audio files, and PDFs that are served to your website visitors.
*   **User Uploads:** If you are building a social media app or a document portal, R2 is where you store the profile pictures and documents users upload.
*   **Data Lakes & Logs:** Storing massive JSON or CSV dumps, application logs, or analytics data for later processing.
*   **Static Site Hosting:** While Cloudflare Pages is great for this, you can also host static assets (HTML/JS/CSS) in an R2 bucket and serve them directly.

### 3. Bucket Operations (Creating, Listing)

In Object Storage, data is organized into containers called **Buckets**.

*   **Creation:** You can create buckets via the Cloudflare Dashboard, the Wrangler CLI (`wrangler r2 bucket create my-bucket`), or via the API.
*   **Location:** While R2 is global, you provide a "location hint" when creating a bucket to determine where the data primarily resides (e.g., North America, Europe) for compliance or initial latency reasons. However, Cloudflare generally abstracts the complexity of regions away from you.
*   **Listing:** Unlike a standard file system, object storage is flat. "Folders" are actually just part of the file name (key).
    *   *Example:* If you upload a file named `users/123/profile.png`, R2 treats the slash as just a character, though API tools can simulate folder structures by listing files that share the `users/` prefix.

### 4. Signed URLs for Private Objects (Presigned URLs)

By default, R2 buckets should be private (secure). You don't want the whole world to have read/write access to your database of files. So, how do you let a user upload a profile picture without giving them your master admin keys?

**Presigned URLs** are the industry standard solution.

1.  **The Flow:**
    *   The User (Client) requests to upload a file.
    *   Your Worker (Server) verifies the user is logged in.
    *   Your Worker generates a **Signed URL**. This is a special, long URL that contains a cryptographic signature and an expiration time (e.g., "valid for 5 minutes").
    *   Your Worker sends this URL back to the Client.
    *   The Client uses standard JavaScript (`fetch`) to upload the file directly to that URL.

2.  **Why this is important:** It offloads the heavy lifting. The file data goes from the User directly to R2. It does *not* have to pass through your Worker, saving you CPU time and money.

### 5. Integrating R2 with Workers for Dynamic Asset Serving

While you can connect a custom domain to an R2 bucket to make files public, the real power comes from accessing R2 inside a Cloudflare Worker using **Bindings**.

**What is a Binding?**
It is a bridge between your code and the storage bucket. In your `wrangler.toml`, you define a variable name (e.g., `MY_BUCKET`) that links to your R2 bucket.

**Code Example (The Worker API):**

Instead of using HTTP to talk to R2, the Worker talks to it directly over the internal Cloudflare network.

```typescript
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const key = url.pathname.slice(1); // Use the URL path as the file name

    // 1. GET Request: Serve a file
    if (request.method === 'GET') {
      // Direct access via the binding 'MY_BUCKET'
      const object = await env.MY_BUCKET.get(key);

      if (object === null) {
        return new Response('Object Not Found', { status: 404 });
      }

      // Return the file stream directly to the browser
      return new Response(object.body);
    }

    // 2. PUT Request: Upload a file (Small files only)
    if (request.method === 'PUT') {
      await env.MY_BUCKET.put(key, request.body);
      return new Response(`Put ${key} successfully!`);
    }

    return new Response('Method not allowed', { status: 405 });
  },
};
```

**Why serve via Workers?**
*   **Authentication:** You can check if a user is an admin before `await env.MY_BUCKET.get(key)`.
*   **Manipulation:** You can grab an image from R2, resize it using Cloudflare Workers, and serve the smaller version.
*   **Analytics:** You can log exactly who downloaded which file to a database.
