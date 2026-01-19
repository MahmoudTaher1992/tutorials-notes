Based on the structure of your handbook, here is the detailed content for **009-Common-Issues-Fixes/005-Disk-IO-saturation.md**.

This section focuses on diagnosing when the physical disk speed (IOPS) limits the database performance, causing a backup of operations.

---

# 💾 005-Disk-IO-saturation.md

## 1. 🚨 The Symptom: How to Recognize It
Disk I/O saturation occurs when MongoDB tries to read from or write to the disk faster than the underlying hardware allows. When this limit is reached, query latency spikes because operations are physically waiting in a queue to access storage.

### The "Smoking Gun" Indicators (Atlas Metrics)
1.  **Disk Queue Depth Spikes:**
    *   *Where:* Metrics > Disk > Disk Queue Depth.
    *   *Signal:* A sustained visible rise (above 0). If the queue depth correlates with your latency spikes, the disk is the bottleneck.
2.  **IOPS Maxed Out:**
    *   *Where:* Metrics > Disk > IOPS.
    *   *Signal:* Tapping the "flat top" of the graph (hitting the provisioned IOPS limit for your cluster tier).
3.  **High "System" CPU (IOWAIT):**
    *   *Where:* Metrics > System > CPU.
    *   *Signal:* **Process CPU** is low/moderate, but **System CPU** is high. This means the CPU is sitting idle waiting for the disk to return data (`iowait`).
4.  **Depleted Burst Balance (AWS/Azure):**
    *   *Where:* Metrics > Disk > Credits (Burst Balance).
    *   *Signal:* If this line drops to near 0%, your disk performance will be throttled to the baseline, causing a massive slowdown.

---

## 2. 🔍 Root Causes: Why is this happening?

There are usually three main drivers for Disk I/O saturation:

### A. The "Working Set" Exceeds RAM (Read Saturation)
MongoDB loves RAM. Ideally, all your "hot" data (indexes + frequently accessed documents) lives in memory (wiredTiger cache).
*   **The Issue:** If your active data > available RAM, MongoDB must constantly fetch data from the disk and swap old data out.
*   **Metric:** Look for a high correlation between **Disk Read IOPS** and **Page Faults**.

### B. Inefficient Queries (The "scan" problem)
A query with a missing index causes a **Collection Scan**.
*   **The Issue:** Instead of reading 1 index entry, the DB reads 1,000,000 documents from the disk to find the 10 you asked for.
*   **Result:** A massive spike in **Read IOPS** for very little actual data returned.

### C. Write Heavy Workloads (Write Saturation)
*   **The Issue:** Your application is inserting or updating data faster than the disk can persist the Write Ahead Log (WAL) or checkpoint data files.
*   **Context:** Common during bulk migrations, "while(true)" update loops in code, or massive logging ingestion.

---

## 3. 🩹 Immediate Fixes (Stop the Bleeding)

If your production is down due to Disk I/O, you need speed.

### Options 1 & 2: The "Scale Up" (Fastest)
1.  **Increase Provisioned IOPS:**
    *   Go to **Configuration** > **Storage**.
    *   Manually increase the IOPS allocated to your cluster (e.g., move from 3000 to 4000 or switch storage types).
    *   *Note:* This happens without downtime in Atlas but increases cost.
2.  **Scale Instance Size (NVMe / RAM):**
    *   Scaling up the cluster tier (e.g., M30 to M40) gives you more **RAM**.
    *   More RAM = Larger cache = Less need to read from the disk.

### Option 3: Kill Analyzed Ops
1.  Check **Real-Time Performance Panel (RTPP)** for operations doing a `COLLSCAN`.
2.  Identify the `opid`.
3.  Kill the operation (via shell or GUI) to relieve pressure on the disk.

---

## 4. 🛠 Long-Term Solutions (Prevent Recurrence)

Once the fire is out, you must fix the architectural issue.

### 1. Optimize Indexes (The #1 Fix)
*   **Action:** Use the **Performance Advisor** to find suggested indexes.
*   **Why:** Turning a collection scan into an index scan can reduce disk I/O by 99% instantly.

### 2. Project Fields (Covered Queries)
*   **Action:** Modify detailed queries to only return the fields you need (`{ projection: { name: 1, age: 1 } }`).
*   **Why:** If an index contains all the fields you need, MongoDB serves the data *only* from the index (RAM) and never touches the disk.

### 3. Archive Old Data (Reduce Working Set)
*   **Action:** Move data older than X months to "Cold Storage" (Atlas Online Archive or S3).
*   **Why:** If your collection shrinks, the remaining "hot" data fits inside your RAM, eliminating disk reads.

### 4. Optimize Schema
*   **Action:** If your documents are large, but you frequently update small fields, split the document.
*   **Why:** Updating a small field in a large document essentially requires rewriting the whole document block on disk.

---

## 5. 📉 Debugging Command Snippets

Use these in `mongosh` to prove I/O issues:

**Check Disk Status (Look for 'phys_usage' and page activity):**
```javascript
db.serverStatus().wiredTiger.cache
```
*Look for:* `pages read into cache` (High number = bad, means disk is being hit).

**Find Operations with High Disk usage:**
```javascript
db.currentOp({
    "active": true,
    "secs_running": { "$gt": 3 }
})
```
*Review the output for:* Plans using `COLLSCAN` or `SORT_KEY_GENERATOR` (implies disk sort).
