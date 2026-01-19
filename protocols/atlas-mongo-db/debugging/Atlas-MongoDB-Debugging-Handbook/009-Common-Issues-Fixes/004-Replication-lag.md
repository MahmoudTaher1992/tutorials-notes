Based on the Table of Contents you provided, here is the detailed content for **Section 9, Item 4: Replication Lag**.

This guide explains what replication lag is, why it occurs, how to detect it using MongoDB Atlas, and how to fix it.

---

# 🩹 009-Common-Issues-Fixes / 004-Replication-lag.md

## 1. What is Replication Lag?
In a MongoDB Replica Set, only the **Primary** node can accept writes. These writes are recorded in the **Oplog** (Operations Log). **Secondary** nodes continually read the Primary's Oplog and apply those operations to their own datasets.

**Replication Lag** is the delay (in seconds or operation time) between an operation occurring on the Primary and that same operation being applied to a Secondary.

*   **Ideally:** Lag is 0–1 seconds.
*   **Warning:** Lag > 10–30 seconds.
*   **Critical:** Lag approaching the "Oplog Window" (risk of falling off the log).

### Why is high lag dangerous?
1.  **Stale Reads:** If your application reads from secondaries (`readPreference: secondary/secondaryPreferred`), users will see old data.
2.  **Data Loss on Failover:** If the Primary crashes, any writes that haven't reached the Secondaries yet could be lost (depending on `writeConcern`).
3.  **Primary Throttling (Flow Control):** In modern MongoDB versions, if lag gets too high, the Primary may intentionally slow down writes to let Secondaries catch up, causing application timeouts.

---

## 2. 🔍 Diagnosis: How to verify Lag

### Method A: Atlas Metrics UI (Easiest)
1.  Go to your **Cluster** view in Atlas.
2.  Click **Metrics**.
3.  Filter for **"Replication Lag"**.
4.  Look for spikes where the line rises significantly above 0.
5.  *Check:* Is the lag occurring on all secondaries, or just one?

### Method B: Mongo Shell / Compass
Run the following command in the shell connected to the cluster:
```javascript
rs.printSecondaryReplicationInfo()
```
**Output Example:**
```text
source: m1-shard-00-01.mongodb.net:27017
    syncedTo: Thu Oct 05 2023 10:00:00 GMT+0000
    0 secs (0 hrs) behind the primary 
source: m1-shard-00-02.mongodb.net:27017
    syncedTo: Thu Oct 05 2023 09:55:00 GMT+0000
    300 secs (5 mins) behind the primary  <-- PROBLEM
```

### Method C: Check the Oplog Window
If lag exceeds your Oplog Window, the Secondary will stop replicating entirely and require an Initial Sync (hours/days of downtime for that node).
```javascript
rs.printReplicationInfo()
```
*Look for "Log length start to end" to see how many hours of buffer you have.*

---

## 3. 📉 Root Causes & Fixes

Here are the 4 most common reasons for replication lag and how to solve them.

### Cause 1: Write Bandwidth Saturation (The Primary is too fast)
The Primary node accepts writes faster than the Secondary can apply them. This often happens during bulk data imports, massive deletes, or index builds.

*   **Symptoms:** High CPU/Disk I/O on Secondaries; Primary flow control engaging.
*   **Fixes:**
    *   **Throttle Writes:** Break massive batch jobs into smaller chunks.
    *   **Write Concern:** Use `w: "majority"` to force the Primary to wait for Secondaries effectively (this slows the app but prevents lag).
    *   **Scale Up:** Increase cluster tier (e.g., M10 to M20) to get more IOPS/CPU.

### Cause 2: Heavy Reads on Secondaries
If you use Analytics nodes or send heavy reporting queries to Secondaries, those nodes might use all their RAM/CPU for *reading*, leaving no resources to apply *writes*.

*   **Symptoms:** Lag is isolated to specific Secondaries; High Query targeting/CPU on those nodes.
*   **Fixes:**
    *   **Redirect Reads:** Move heavy queries to a dedicated Analytics Node or back to the Primary (if capacity allows).
    *   **Missing Indexes:** Ensure the queries running on the Secondary are indexed. A collection scan on a Secondary blocks replication!

### Cause 3: Index Builds
Building an index on the Primary is a heavy operation. Once finished, that "Build Index" command replicates to the Secondary, which must then build the index itself.

*   **Symptoms:** Lag spikes suddenly after a deployment or DB change.
*   **Fixes:**
    *   **Rolling Index Builds:** Use Atlas's "Rolling Index Build" feature (default in Atlas) to build on one node at a time without stopping replication.
    *   **Wait it out:** If it's a foreground build, wait. If background, ensure the node has CPU headroom.

### Cause 4: Network Latency (Cross-Region)
If your Primary is in `AWS us-east-1` and a Secondary is in `AWS eu-west-1`, the speed of light sets a minimum lag floor.

*   **Symptoms:** Consistent, low-level lag (e.g., always 100ms-500ms), never zero.
*   **Fixes:**
    *   **Acceptance:** Some lag is unavoidable in cross-region setups.
    *   **Architecture:** ensure your `writeConcern` isn't set to wait for the distant node unless strictly necessary.

---

## 4. 🚀 Runbook: Steps to Resolve Active Lag

**Step 1: Identify the lagging node.**
Is it one node (hardware/read issue) or all nodes (write volume issue)?

**Step 2: Check for blockers.**
Run `db.currentOp()` on the **Secondary** node. Look for operations with `"type": "op"` waiting on locks.
*   *Is a large report running?* Kill it: `db.killOp(<opid>)`.
*   *Is a backup snapshot running?* This can sometimes pause Oplog application.

**Step 3: Check Hardware Saturation.**
Check the Metrics tab for the Secondary.
*   If **CPU** or **Disk IOPS** is flatlined at 100%, the node cannot keep up. You must either reduce write traffic on the Primary or Scale Up the cluster.

**Step 4: Emergency Throttling.**
If the Secondary is near "Falling off the Oplog" (Lag time $\approx$ Oplog Window):
1.  Pause non-essential write workers in your application.
2.  Enable specific Flow Control settings if familiar with `setParameter` (advanced users only).

---

## 5. 💡 Prevention Strategy

1.  **Monitor Oplog GB/Hour:** Know your churn rate. If you write 10GB/hour and have a 50GB Oplog, you have a 5-hour safety window.
2.  **Avoid Large Transactions:** Do not delete or update 100,000 documents in a single transaction. Chunk them into batches of 1,000.
3.  **Read Preference Hygiene:** Don't default to `secondaryPreferred` unless your app can tolerate stale data.
