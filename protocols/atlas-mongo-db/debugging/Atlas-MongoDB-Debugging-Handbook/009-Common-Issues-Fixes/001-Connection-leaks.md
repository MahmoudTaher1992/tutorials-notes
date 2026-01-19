Based on the Table of Contents you provided, specifically **Section 9 (Common Issues & Fixes)**, here is a detailed explanation of item **009 - Connection Leaks**.

This explanation is structured as if it were the actual content page within that handbook.

---

# 🩹 009-Common-Issues-Fixes / 001-Connection-leaks

## 1. What is a Connection Leak?
A connection leak occurs when an application opens a notification network connection to the database but fails to close it or return it to the connection pool after the operation is finished.

Think of it like leaving a water tap running. Over time, these "open but abandoned" connections accumulate. Eventually, they consume all available slots allowed by the Atlas cluster (e.g., `maxIncomingConnections`), preventing new (legitimate) users or processes from connecting.

### The Mechanics
1.  **Request:** The App asks for a connection.
2.  **Allocation:** The Driver/Pool gives the App a connection.
3.  **Action:** The App runs a query.
4.  **Error (The Leak):** The App logic finishes or crashes but **does not** release the connection back to the pool.
5.  **Result:** The database thinks the connection is still active and holds the slot open. The App thinks it needs a *new* connection for the next request.

---

## 2. 📝 Symptoms & Identification (How to spot it in Atlas)

To confirm a leak versus just high traffic, look at the **Connections** chart in the Atlas Metrics tab.

### A. The "Staircase to Heaven" Pattern
*   **Normal Behavior:** The graph goes up and down (sawtooth pattern) matching your traffic/requests.
*   **Leak Behavior:** The graph moves **monotonically upward**. It goes up, plateaus briefly, goes up again, but **never returns to baseline**, even during low traffic periods.

### B. The Hard Ceiling
*   The connection count hits the explicit limit (e.g., 100% of configured limit) and forms a flat line at the top.
*   **Application Errors:** Your application logs will start showing errors like:
    *   `MongoTimeoutError: Timed out checking out a connection from connection pool`
    *   `Connection pool is full`

### C. The Restart Drop
*   If you restart your **Application Server** (ECS / K8s pods) and the connection count on Atlas immediately drops to near zero, **you have a leak in the application code.** (Restarting kills the TCP sockets, forcing the DB to release them).

---

## 3. 🕵️ Root Causes (Why it happens)

### Cause 1: The "Client Per Request" Anti-Pattern (Most Common)
In modern MongoDB drivers, the `MongoClient` is designed to be a **Singleton**. It should be initialized *once* when the app starts and reused.
*   **The Bug:** The developer initializes a `new MongoClient()` inside a specific API route or function.
*   **The Consequence:** Every time that API is hit, a whole new connection pool is created. It is never disposed of.

### Cause 2: Missing Cleanup Logic
If you are manually managing connections (rare in modern apps, but possible), you must explicitly close them.
*   **The Bug:** Using a connection in a `try` block, but failing to put a `.close()` in a `finally` block. If the code throws an error, the close command is skipped.

### Cause 3: Zombie Connections / Firewalls
Sometimes the application *does* close the connection, but a network device (load balancer or firewall) silently drops the packet.
*   **The Result:** The App thinks it's closed. The Atlas DB thinks it's still open and waits for the TCP KeepAlive timeout (which can be hours).

---

## 4. 🛠 Fixes & Remediation

### phase 1: Immediate Triage (Stop the Bleeding)
1.  **Restart the Application Services:** This is the fastest way to clear the "zombie" connections and restore service availability immediately.
2.  **Kill Sessions (Emergency only):** If you cannot restart the app, you can use the MongoDB shell to kill idle connections, though they will fill up again quickly if the code bugs exist.

### Phase 2: Code Investigation (The Permanent Fix)

#### 1. Implement the Singleton Pattern
Ensure your database connection code looks like this (pseudocode):

**✅ DO THIS:**
```javascript
// Connect ONCE outside the request handler
const client = new MongoClient(uri);
await client.connect();

function handleRequest(req, res) {
   // Reuse the existing client
   const db = client.db('myDB');
}
```

**❌ NOT THIS:**
```javascript
function handleRequest(req, res) {
   // BAD: Creates a new connection pool for every single user request
   const client = new MongoClient(uri);
   await client.connect(); 
   // ... query ...
   // If you forget client.close() here, you just leaked a connection.
}
```

#### 2. Max Pool Size Configuration
Check your connection string options. If your `maxPoolSize` is set too high (e.g., 100) and you have 50 containers (Kubernetes pods), you are allowing `100 * 50 = 5000` potential connections. Lower the `maxPoolSize` to fit your actual concurrency needs.

#### 3. Review Exception Handling
Ensure that any database logic is wrapped in `try / finally` blocks if you are not using a dependency injection framework that handles lifecycle management for you.

---

## 5. Summary Checklist

*   [ ] **Graph Check:** Does the connection count drop when traffic drops, or does it stay high?
*   [ ] **Code Review:** Search codebase for `new MongoClient`. Is it inside a route handler?
*   [ ] **Logs:** Are there "Timeout" errors relating to the "Pool"?
*   [ ] **Mitigation:** Restart App containers to verify if connections drop on DB.
