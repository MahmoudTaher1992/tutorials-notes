Based on the structure of your handbook, **Section 8 (Quick Diagnostic Queries)** is intended to be a "Cheat Sheet" for engineers who have SSH/Shell access to the database (via `mongosh`) and need immediate answers without clicking through the UI.

Here is the detailed content for **008-Quick-Diagnostic-Queries/001-Connection-operation-visibility.md**.

---

# 🔌 001 - Connection & Operation Visibility
**Context:** Use these queries when the Atlas UI is lagging, or when you need granular detail on exactly *who* is connected and *what* they are executing right now.

**Prerequisites:**
1.  Connect to your cluster via `mongosh`.
2.  Ensure you have `clusterMonitor` or `root` privileges.

---

## 1. The "Pulse Check": Global Connection Status
Before looking at specific queries, check how close the database is to its hard limit.

### 📝 The Command
```javascript
db.serverStatus().connections
```

### 🔎 Output Interpretation
Returns a JSON object like this:
```json
{
  "current": 1450,
  "available": 50,
  "totalCreated": 1205009,
  "active": 45
}
```
*   **current**: The total number of open TCP connections. **If this is close to (current + available), you are hitting the hard limit.**
*   **available**: How many *more* connections the server can accept.
*   **active**: The number of connections currently performing work (reading/writing). High `current` but low `active` usually indicates an idle connection pool issue.

---

## 2. The "Who is Doing What": Finding Active Operations
This is the most critical command for diagnosing "Why is the DB slow right now?"

### 📝 The Command: Basic Active Check
Show me operations that are active and have been running for more than **3 seconds**.
```javascript
db.currentOp({
    "active": true,
    "secs_running": { "$gt": 3 }
})
```

### 🔎 Output Interpretation (Key Fields)
*   **`opid`**: The Operation ID. You need this to kill the query.
*   **`secs_running`**: Duration. If this is high (e.g., >30s) for a simple find, you have a problem.
*   **`microsecs_running`**: Same as above but more precise.
*   **`ns`**: Namespace (Process.Collection). identifies which collection is being hit.
*   **`command`**: The actual query JSON. Look for empty filters `{}` (collection scans) or lack of indexed fields.
*   **`client`**: The IP address of the application server sending the query.
*   **`waitingForLock`**: If `true`, this query is stuck waiting for another operation to finish.

---

## 3. The "Client Audit": Count Connections by IP
If you suspect a "Connection Storm" (e.g., a specific microservice scaling out of control), use this aggregation to generate a leaderboard of connected IPs.

### 📝 The Command
```javascript
db.currentOp(true).inprog.reduce(
  (acc, o) => {
    if (o.client) {
      const ip = o.client.split(":")[0]; // Strip the port
      acc[ip] = (acc[ip] || 0) + 1;
    }
    return acc;
  },
  {}
);
```
*(Note: In large clusters, this may take a moment to run. Alternatively, use the aggregation framework on `$currentOp` if running Mongo 4.2+)*:

**Alternative (Clean Aggregation):**
```javascript
db.aggregate([
  { $currentOp: { allUsers: true, idleConnections: true } },
  { $group: { _id: "$client", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
])
```

### 🔎 Output Interpretation
*   Look for one specific IP with significantly higher connections than others.
*   Identify if the IP belongs to a misconfigured Kubernetes pod, an analytics script, or a developer's laptop.

---

## 4. The "Emergency Brake": Killing an Operation
If you identify a query in Step 2 that is locking the database or consuming 100% CPU, you can kill it.

### ⚠️ Warning
**Do not kill internal system operations** (usually recognizable by lack of strict `client` IP or appearing as `repl` or `command: fsync`). Only kill application queries.

### 📝 The Command
```javascript
db.killOp(<opid_number_from_currentOp>)
```
*Example:* `db.killOp(123456)`

---

## 5. Summary Cheat Sheet

| Goal | Command Concept |
| :--- | :--- |
| **Am I full?** | `db.serverStatus().connections` |
| **What's slow?** | `db.currentOp({"active":true, "secs_running":{$gt:3}})` |
| **Who is connecting?** | Aggregate `$currentOp` by `$client`. |
| **Stop it now!** | `db.killOp(opid)` |

---

### 💡 When to use this file in the Handbook flow?
You use this file during **Step 2.3 (Open real-time dashboards)** or **Step 4.1 (Connection & Pooling)**. If the Atlas UI is showing a spike, pop open your terminal and run the **Step 2** query above to immediately capture the "Smoking Gun" query JSON before the server crashes or recovers.
