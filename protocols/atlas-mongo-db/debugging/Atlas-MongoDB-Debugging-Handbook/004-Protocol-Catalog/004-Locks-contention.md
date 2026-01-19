Based on the structure of your **Atlas MongoDB Debugging Protocols Handbook**, the section `004-Locks-contention.md` (Item **4.4** in your TOC) deals with one of the most silent but deadly performance killers in MongoDB.

When CPU is low but the application is timing out, the culprit is distinctively **Lock Contention**.

Here is the detailed explanation and content for that section, written in the style of your handbook.

---

# 🔒 Protocol 4.4: Locks, Contention & Queued Operations

### **1. The Core Concept: "The Traffic Jam"**
MongoDB (specifically the WiredTiger storage engine) uses **document-level locking** for most operations. This means multiple users can read/write to the same collection comfortably—as long as they aren't trying to modify the exact same document at the exact same time.

However, **Contention** occurs when:
1.  A "Bully" query grabs a lock on a resource (a document, a collection, or the database metadata).
2.  Other "Victim" queries queue up behind it, waiting for permission to proceed.
3.  The CPU might look fine (waiting requires little CPU), but the **Latency** spikes significantly.

### **2. Diagnostic Signals (The Symptoms)**
How do you know you are dealing with a Locking issue and not a Hardware issue?

*   **High Latency, Low CPU:** Response times trigger alerts, but Cluster CPU is under 50%.
*   **"Queued Operations" Spike:** In Atlas metrics, you see a spike in the *Queued Reads* or *Queued Writes* graph.
*   **WiredTiger Ticket Exhaustion:** The number of available "Read Tickets" or "Write Tickets" drops to zero (more on this below).
*   **Connection Spike:** Because queries are stuck waiting for locks, the application opens *more* connections to compensate, often leading to a Connection Storm.

### **3. The WiredTiger "Tickets" Concept**
This is the specific mechanic causing the bottleneck.
*   **The Bucket:** WiredTiger limits the number of concurrent active operations to prevent context-switching thrashing. By default, there are **128 Read Tickets** and **128 Write Tickets**.
*   **The Scarcity:** If 128 queries are currently processing (or waiting heavily on disk I/O), the 129th query isn't rejected—it is **Queued**.
*   **The Alert:** If you see the "Tickets Available" metric drop to 0, your database has stalled.

### **4. Root Causes of Contention**
In 90% of cases, locking issues come from these three scenarios:

#### A. The Unindexed Multi-Update (The "Collection Scan" Lock)
If you run an `updateMany` or `deleteMany` command based on a field that **does not have an index**:
*   MongoDB must perform a **COLLSCAN** (scan every document).
*   It may take "Intent Locks" on every document it inspects.
*   This blocks other writers from modifying those documents until the scan moves on.

#### B. Hot Documents (The "Hammer" Effect)
If all your application threads try to update the **same document** simultaneously (e.g., a single counter document like `order_id_sequence` or a global config doc):
*   Sequential locking occurs. Thread B cannot write until Thread A finishes. Thread C holds a generic "wait" ticket.
*   This creates a convoy effect.

#### C. Long-Running Transactions
If a developer opens a multi-document Transaction, performs a write, and then does *slow application-side processing* before committing:
*   The locks are held for the *entire duration* of the transaction (network call + app logic + commit).

---

### **5. Debugging Steps (The Action Plan)**

#### Step 1: Check the "Queues" Metric
Go to **Atlas Metrics** → **Detailed** → select **Queues**.
*   *Normal:* < 5 queued operations.
*   *Actionable:* > 20 queued operations.
*   *Critical:* > 100 queued operations (The database is effectively down for new requests).

#### Step 2: Identify the Blocking Op
You need to find the "Bully" holding the lock. Only `db.currentOp()` provides this visibility (Standard Atlas profiler may show the slow query *after* it finishes, but you need to see it *while* it's blocking).

**Run this in mongosh or Compass:**
```javascript
db.currentOp({
    "active": true,
    "secs_running": { "$gt": 3 },
    // We are looking for something holding a lock, or waiting for one
    "$or": [
        { "waitingForLock": true }, 
        { "lockStats.timeAcquiringMicros.w": { "$gt": 0 } }
    ]
})
```

#### Step 3: Analyze the Output
Look at the results from the command above.
1.  **Is `waitingForLock` true?** This is a *Victim*. It is stuck.
2.  **Look for the `opid` (Operation ID).**
3.  **Look for the `locks` section.** If a query has an `X` (Exclusive) or `W` (Global Write) lock on a Collection, and `secs_running` is high, **this is your Bully.**

#### Step 4: The Immediate Fix (Kill the Op)
If the DB is unresponsive, kill the operation identified in Step 3.
```javascript
db.killOp(<opid_from_step_3>)
```
*Warning: If the application logic simply retries the query immediately, the queue will fill up again. You must stop the application source or apply a code fix.*

### **6. Prevention Strategy**
1.  **Index Assurance:** Ensure all `update` and `delete` operations utilize an index.
2.  **Shorter Transactions:** Keep transactions extremely short. Do not make external API calls (HTTP) inside a MongoDB transaction.
3.  **Schema Design:** Avoid identifying "Counter" documents that receive 100+ writes per second. Use `$inc` operators or optimistic locking patterns instead.

---

### Summary Checklist for Protocol 4.4
*   [ ] **Check:** Are "Tickets Available" near 0?
*   [ ] **Check:** Is "Queued Reads/Writes" > 10?
*   [ ] **Action:** Run `db.currentOp()` filtered by `secs_running`.
*   [ ] **Action:** Identify if an unindexed `updateMany` or `deleteMany` is running.
*   [ ] **Decision:** Kill the blocking operation to drain the queue.
