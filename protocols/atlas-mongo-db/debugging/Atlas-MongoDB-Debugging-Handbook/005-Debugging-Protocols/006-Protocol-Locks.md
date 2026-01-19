Based on the Table of Contents you provided, here is the detailed breakdown for **Protocol 6 — 🔒 Locks / Blocking Operations Protocol**.

In a "Handbook" context, this section answers the question: **"My database isn't out of CPU or RAM, but requests are stuck. Is something blocking traffic?"**

---

# 📘 Protocol 6: Locks & Blocking Operations

### 🎯 Objective
To identify, isolate, and resolve concurrency bottlenecks where database operations are waiting on one another (contention), causing request queuing and application latency.

### 🚨 When to use this Protocol (Triggers)
1.  **High Latency / Low Resource Usage:** The application is timing out, but MongoDB CPU and Memory usage are *not* maxed out.
2.  **"Spiky" Performance:** Traffic isn't smooth; it halts and then bursts.
3.  **Alerts:** You receive alerts for `asserts`, `queued operations`, or `ticket exhaustion`.
4.  **Application Logs:** Errors regarding "LockTimeout" or "WriteConflict".

---

### 1. The Core Concept: How MongoDB Locking Works
MongoDB uses **Document-Level Locking** (WiredTiger Storage Engine).
*   **Ideal State:** Multiple threads can read/write different documents simultaneously.
*   **The Problem:** If too many operations try to write to the *same* document, or if an administrative operation (like a foreground index build) grabs an *exclusive* lock on a collection, other operations must wait in a **Queue**.

**The Metaphor:** Think of it like a toll system.
*   **Normal:** 10 lanes open, cars flow freely.
*   **Locking:** One car breaks down in a lane; everyone behind it stops (Queue).
*   **Deadlock:** Two cars try to merge into the same spot and refuse to move (MongoDB usually detects this and kills one operation).

---

### 2. key Metrics to Analyze

#### A. Queued Operations (The #1 Indicator)
*   **Location:** Atlas Metrics → Real-Time
*   **What to watch:** The `globalLock.currentQueue.total` metric.
*   **Threshold:** This should ideally be **0**.
    *   If it spikes to 5, 10, or 100+, requests are piling up and not being processed.

#### B. WiredTiger Tickets (The Admission Gates)
The storage engine limits how many operations can happen simultaneously to prevent crashing the CPU. These are called **Tickets**.
*   **Read Tickets:** Default 128 available.
*   **Write Tickets:** Default 128 available.
*   **The Danger:** If `Available Tickets` drops to **0**, the database stops accepting new work until a ticket is freed.
    *   *Note:* A drop in tickets usually matches a spike in Latency.

---

### 3. Step-by-Step Diagnostic Workflow

#### Step 1: Check for "Global Lock" Saturation
Go to **Atlas Metrics** > **System Metrics**.
*   Look at the **Global Lock Current Queue** graph.
*   **Interpretation:**
    *   **Readers Queued:** You likely have a slow query holding resources, preventing other reads.
    *   **Writers Queued:** You likely have high contention (everyone writing to the same place) or a massive update blocking everything.

#### Step 2: The "CurrentOp" Investigation (The Smoking Gun)
If the queue is high, you need to find *exactly* which operation is blocking the others. You cannot see this easily in graphs; you need the command line (`mongosh`) or Compass.

Run this query to find operations that are **waiting for a lock**:

```javascript
db.currentOp({
   "waitingForLock": true,
   "secs_running": { "$gt": 1 } // Ops waiting longer than 1 second
})
```

**What to look for in the output:**
*   `type`: Is it an `op` (query/update) or a system command?
*   `mode`: Are they waiting for a `W` (Write) lock?
*   `ns` (Namespace): Which collection is being blocked?

#### Step 3: Find the "Blocker" (The Root Cause)
The query above shows the *victims* (the ops waiting). To find the *culprit* (the op holding the lock), you look for long-running operations that are **Write (X) or Intent Write (IX)** locks but are **Active** (not waiting).

```javascript
db.currentOp({
   "active": true,
   "secs_running": { "$gt": 3 }, // Running longer than 3 seconds
   "waitingForLock": false,      // Is NOT waiting (it holds the lock)
   "op": { "$in": ["update", "remove", "insert", "command"] }
})
```

---

### 4. Common Offenders (Root Causes)

1.  **Foreground Index Builds:**
    *   *Evidence:* A command `createIndexes` is running. Older versions of Mongo locked the DB during this.
    *   *Fix:* Always use rolling index builds (default in Atlas now, but be careful with unique constraints).

2.  **Unindexed Multi-Updates:**
    *   *Scenario:* `db.collection.updateMany({status: "A"}, {$set: {status: "B"}})`
    *   *Issue:* If `{status: "A"}` is not indexed, the DB scans *every document*, locking them as it goes. This blocks other writers.
    *   *Fix:* Kill the op, add an index on `status`, retry.

3.  **The "Hot Document" Problem:**
    *   *Scenario:* All app threads are trying to update `_id: 123` (e.g., a global counter document) at the exact same millisecond.
    *   *Fix:* Change app architecture to batch updates or shard the counter.

4.  **Transaction Contention:**
    *   *Scenario:* A transaction starts, updates a doc, then waits for an external API call before committing.
    *   *Issue:* The lock is held for the *entire duration* of the external API call (which might be slow).
    *   *Fix:* Keep transactions extremely short. Never do network I/O inside a transaction.

---

### 5. Immediate Remediation (Emergency Fixes)

If the database is locked up and downtime is occurring:

1.  **Identify the OpID:** From the `db.currentOp` command above, find the `"opid"`.
2.  **Kill the Operation:**
    ```javascript
    db.killOp(<opid>)
    ```
    *Warning:* Only kill operations if you know what they are. Killing an internal system process can cause a failover.

3.  **Step Down (Last Resort):**
    If you cannot find the op or the UI is unresponsive, force a **Primary Failover** in the Atlas Console. This reboots the Primary and severs all current locks.

---

### Summary Checklist for Protocol 6
*   [ ] Checked **Queued Operations** (Is it > 0?)
*   [ ] Checked **Available Tickets** (Is it < 128?)
*   [ ] Ran `db.currentOp` to identify the **Victims** (waitingForLock: true).
*   [ ] Ran `db.currentOp` to identify the **Blocker** (active: true, secs_running > 3).
*   [ ] Analyzed if the Blocker is an unindexed update or a bad schema pattern.
