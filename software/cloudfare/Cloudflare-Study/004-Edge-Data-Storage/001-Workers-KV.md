Here is a detailed explanation of **004-Edge-Data-Storage/001-Workers-KV.md**.

---

# 004-Edge-Data-Storage / 001-Workers-KV

**Workers KV (Key-Value)** is Cloudflare’s global, low-latency key-value data store. It is one of the foundational storage solutions for the Workers platform.

To understand KV, imagine a giant **Hashtable** or **Dictionary** (like a JSON object) that is replicated across Cloudflare’s entire global network (300+ locations).

## 1. The Core Philosophy: Read-Heavy, Eventual Consistency
The most important thing to understand about KV is its design goal: **High-volume reads with low latency.**

### The Architecture
*   **Reads are Local:** When a user in London requests data from KV, they read it from the London data center. When a user in Tokyo requests it, they read from Tokyo. This makes reads incredibly fast (low single-digit milliseconds).
*   **Writes are Centralized (then replicated):** When you write data to KV, it goes to a central authority and is then "gossiped" (propagated) out to the rest of the world.

### The "Eventual Consistency" Model
Unlike a traditional SQL database (which usually strives for Strong Consistency), Workers KV is **Eventually Consistent**.

*   **The Scenario:** You update a key (`welcome_msg`) from "Hello" to "Hola".
*   **The Reality:** It may take up to **60 seconds** for that change to propagate to all locations globally.
*   **The Risk:** If you write a value and immediately try to read it back in a different location (or sometimes even the same one), you might still see the old value for a short time.

**Therefore:** KV is *not* suitable for things that need instant accuracy, like checking bank balances or preventing double-spending. It *is* perfect for things that change infrequently but are read constantly.

## 2. Setting Up KV
In the Cloudflare ecosystem, you don't connect to KV using a connection string or URL. You connect using **Bindings**.

1.  **Create a Namespace:** A "Namespace" is like a database table or a bucket. You create it via the CLI (`wrangler kv:namespace create "MY_STORE"`) or the Dashboard.
2.  **Bind in `wrangler.toml`:** You verify the binding in your configuration file.
    ```toml
    [[kv_namespaces]]
    binding = "SETTINGS"
    id = "xxxxxxxxxxxxxxxxxxxxxxxx"
    ```
3.  **Access in Code:** In your Worker, `SETTINGS` becomes a global object available on the `env` parameter.

## 3. The KV API (Operations)

The API is very simple and mimics the standard Map API in JavaScript, but it is asynchronous (Promise-based).

### A. Writing Data (`put`)
You save a value against a key.
```typescript
// Simple string
await env.SETTINGS.put("site_title", "My Awesome Blog");

// Storing JSON (stringify it first)
const userPrefs = { theme: "dark", lang: "en" };
await env.SETTINGS.put("user_123", JSON.stringify(userPrefs));
```

### B. Reading Data (`get`)
You retrieve data by its key. You can tell KV how to format the data coming back (text, json, or arrayBuffer).
```typescript
// Get as text (default)
const title = await env.SETTINGS.get("site_title");

// Get as JSON automatically
const prefs = await env.SETTINGS.get("user_123", { type: "json" });
// prefs is now an object: { theme: "dark", ... }
```
*Note: If the key doesn't exist, `get` returns `null`.*

### C. Deleting Data (`delete`)
Removes the key and value.
```typescript
await env.SETTINGS.delete("user_123");
```

### D. Listing Keys (`list`)
This allows you to see what keys exist in your namespace.
```typescript
// Get a list of keys (returns an object with keys array and cursor for pagination)
const list = await env.SETTINGS.list({ prefix: "user_" });
```
*Use Case: Finding all keys that start with "user_".*

## 4. Advanced Features

### Metadata
You can store a small amount of JSON **metadata** alongside the value.
*   **Why?** Sometimes you need to know *about* the data without fetching the whole (potentially large) value.
*   **Example:** You store an image file as the Value, but you store the `filename` and `content-type` in the Metadata. When you `list` keys, you get the metadata for free without paying the cost of reading the images.

### Time-to-Live (TTL) / Expiration
You can tell KV to automatically delete a key after a certain time.
```typescript
// This key will self-destruct in 60 seconds
await env.SETTINGS.put("otp_code", "123456", { expirationTtl: 60 });
```
*   **Use Cases:** Session tokens, OTPs, temporary cache.
*   **Constraint:** The minimum TTL is 60 seconds.

## 5. Ideal Use Cases vs. Anti-Patterns

### ✅ When to use Workers KV
1.  **Configuration / Feature Flags:** Store booleans (`show_new_ui: true`) to turn features on/off globally without redeploying code.
2.  **Routing Rules:** Redirecting `/blog` to a specific URL based on a map stored in KV.
3.  **Content Caching:** Storing HTML fragments or API responses to serve them faster than hitting your origin server.
4.  **Localization:** Storing translation strings (`"hello": "bonjour"`).
5.  **Asset Storage:** Storing small static assets (though R2 is better for large files).

### ❌ When NOT to use Workers KV
1.  **Transactional Data:** A shopping cart or bank ledger (Use **Durable Objects** or **D1** instead).
2.  **Counters:** Attempting to implement a `count = count + 1` logic. Because of eventual consistency, multiple users might overwrite each other's updates.
3.  **Large Files:** Values are limited to 25MB. (Use **R2** for this).

## Summary Comparison

| Feature | Workers KV |
| :--- | :--- |
| **Speed** | Extremely fast Reads (Global). |
| **Consistency** | Eventual (writes take time to spread). |
| **Location** | Global (replicated everywhere). |
| **Data Structure** | Key-Value pairs only. |
| **Best For** | Config, Cache, routing, high-read/low-write data. |
