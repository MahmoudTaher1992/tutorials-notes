Based on the styling and structure of your handbook, **Protocol 5 — Cluster Metrics Protocol** is designed to look beyond specific queries or basic CPU usage and investigate the **internal physiology and health of the MongoDB nodes** themselves.

This protocol answers the question: *“Is the database engine healthy, or is it choking on internal processes?”*

Here is the detailed explanation of what that section (`005-Protocol-Cluster-Metrics.md`) covers:

---

# 📊 Protocol 5 Details: Cluster Metrics Protocol

### **1. Objective**
To assess stability, concurrency, and replication health. You use this protocol when CPU/Memory might seem fine (or high), but the application is experiencing "stalls," or when you suspect the specific node architecture (Primary/Secondary relationship) is the bottleneck.

### **2. The "Vital Signs" (Key Metrics to Analyze)**

This protocol focuses on three specific tabs in MongoDB Atlas: **Metrics**, **WiredTiger**, and **Replication**.

#### **A. WiredTiger Tickets (The "Hidden" Bottleneck)**
*   **What it is:** WiredTiger (the storage engine) uses a ticketing system to manage concurrency. By default, there are usually **128 Read Tickets** and **128 Write Tickets** available simultaneously.
*   **The Symptom:** If your "Available Tickets" drop to 0, the database stops processing new operations until a ticket is freed up.
*   **What to check:**
    *   Go to **Metrics** → **WiredTiger** → **Tickets Available**.
    *   **Healthy:** Line stays near the top (128).
    *   **Critical:** Deep dips toward 0. This indicates **congestion**. Even if CPU is at 50%, if tickets are at 0, the DB is effectively down.

#### **B. Replication Lag**
*   **What it is:** The time difference (in seconds) between an operation happening on the Primary node and it being applied to Secondary nodes.
*   **The Risks:**
    *   **Stale Reads:** Apps reading from secondaries get old data.
    *   **Failover Danger:** If the Primary dies while lag is high, data may be lost, or failover will fail.
    *   **Flow Control:** (See below).
*   **dWhat to check:** Go to **Metrics** → **Replica Set** → **Replication Lag**. Ideally, this should be **< 1-2 seconds**.

#### **C. Flow Control (The Self-Throttling Mechanism)**
*   **What it is:** If Secondaries fall too far behind, the Primary will *intentionally slow down* (throttle) write operations to let them catch up.
*   **The Symptom:** Your application sees massive latency on writes, but the server CPU isn't maxed out.
*   **What to check:** Look for **Flow Control Target** metrics. If this is active, your cluster is throttling itself to save the replication chain.

#### **D. Oplog Window**
*   **What it is:** The "time buffer" available in your transaction logs.
*   **The Check:** If your Oplog window drops from "24 hours" to "1 hour" during a heavy write operation, you are at risk of nodes falling off the network and requiring a full resync (which kills performance).

#### **E. Dirty Cache % (Disk I/O Precursor)**
*   **What it is:** Data in memory that hasn't been written to disk yet.
*   **The Threshold:** If "Dirty Cache" exceeds roughly **5% to 20%**, WiredTiger forces user threads to wait while it frantically writes to disk. This looks like "micro-stalls" or "jitter" in your application.

---

### **3. The Diagnostic Workflow (Step-by-Step)**

When executing **Protocol 5**, you follow this sequence:

1.  **Check Tickets:** Are read/write tickets available?
    *   *If Low/Zero:* You have a concurrency issue (slow queries holding locks). Move to **Protocol 3 (Query Profiler)**.
2.  **Check Queues:** Are operations queuing?
    *   *If High:* Usually caused by disk saturation or ticket exhaustion.
3.  **Check Replication Lag:** Is the secondary lagging?
    *   *If Yes:* Check if you are doing massive `updateMany` or `deleteMany` operations (Write Saturation).
4.  **Check IOPS/Disk:**
    *   Are you hitting the IOPS limit of your chosen Atlas tier (e.g., M30 vs M40)?

---

### **4. Summary of Findings (Scenario Mapping)**

| Observation | Diagnosis | Recommended Fix |
| :--- | :--- | :--- |
| **Tickets drop to 0** | Database is saturated by slow queries holding open slots. | Fix slow queries (Protocol 3) or add indexes. Scaling up helps, but query fixing is better. |
| **Replication Lag Spikes** | Write workload is too heavy for secondaries to apply. | Move to larger instance size or optimize write batches. |
| **Flow Control Active** | Primary is choking writes to save secondaries. | Same as above; reduce write intensity immediately. |
| **High Dirty Cache** | Disk cannot write fast enough. | Upgrade Disk IOPS (provisioned IOPS) or upgrade Cluster Tier. |

### **5. Protocol Output (Evidence)**
When you finish this protocol, your notes should say:
> *"Cluster metrics show Healthy Replication (0s lag) but **Critical Ticket Exhaustion** (dropped to 5 tickets available at 14:00 UTC). This suggests a concurrency pile-up, likely due to unindexed queries found in Protocol 3."*
