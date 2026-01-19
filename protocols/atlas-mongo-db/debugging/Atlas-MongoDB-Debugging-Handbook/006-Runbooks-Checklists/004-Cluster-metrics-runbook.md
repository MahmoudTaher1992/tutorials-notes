Based on the Table of Contents you provided, the file **`006-Runbooks-Checklists/004-Cluster-metrics-runbook.md`** (which corresponds to **Protocol 5** and **Section 6.4** in your TOC) focuses on the **holistic health of the MongoDB Replica Set** rather than just individual query performance.

While "Connection Analysis" looks at who is knocking at the door, and "Query Performance" looks at what they are asking for, **Cluster Metrics** looks at the **hardware and synchronization health** of the database itself.

Here is a detailed explanation of what would be inside this specific Runbook/Protocol.

---

# 📊 Detailed Breakdown: Cluster Metrics Runbook
### (Protocol 5 / Runbook 004)

## 1. 🎯 Purpose & Goal
**Objective:** To determine if the cluster *itself* is unstable, lagging, or hitting physical hardware limits (Disk/IOPS), regardless of how efficient the queries are.
**When to run this:**
*   When application latency is high, but queries *seem* optimized.
*   When there are alerts regarding "Replication Lag."
*   When you suspect disk saturation (IOPS throttling).
*   During write-heavy traffic spikes.

---

## 2. 🔑 Key Metrics to Inspect (The "What")

This runbook focuses on four specific pillars of cluster health that are specific to MongoDB architecture:

### A. 🔁 Replication Lag (Crucial)
*   **Definition:** The time delay (in seconds) between an operation happening on the **Primary** node and that detailed operation being applied to the **Secondary** nodes.
*   **The Danger:** If lag increases, your data is not consistent. If a failover happens (Primary dies), data that hasn't synced to the Secondary yet will be lost (rollback).
*   **Threshold:** > 10–20 seconds is alarming; > 60 seconds is critical.

### B. 📜 Oplog Window (Operations Log)
*   **Definition:** The amount of time (in hours/days) available in the replication log buffer.
*   **Why it matters:** If the Oplog window drops significantly (e.g., from 24 hours to 1 hour) due to a massive write volume, and a Secondary node goes down for 2 hours, it **cannot rejoin the cluster** automatically. It falls off the edge of the log and typically requires a full resync (dangerous/slow).

### C. 💾 Disk I/O & IOPS (Input/Output Operations Per Second)
*   **Disk Queue Depth:** If this is distinctively above 0, it means the disk cannot write data fast enough. The CPU is waiting on the Disk.
*   **IOPS Limit:** In Atlas/AWS/GCP, storage has a speed limit. If you hit the ceiling, your database effectively "freezes" momentarily.
*   **Burst Balance:** (AWS specific) Tracking if you have run out of "burst credits" for disk speed.

### D. 🔢 OpCounters (Throughput)
*   **Command vs. Query vs. Insert:** Analyzing the *type* of traffic.
*   **Why it matters:** A sudden spike in `Command` counts usually indicates a monitoring tool gone wild or a connection storm handshake issue, whereas a spike in `Insert` indicates a data ingestion job.

---

## 3. 🛠 The Runbook Workflow (The "How")

This is the step-by-step checklist the runbook would guide you through during an incident:

### Step 1: Check Replication Health
1.  Go to **Atlas Metrics** → **Replica Set**.
2.  Look at the **Replication Lag** graph.
    *   *Is it effectively zero?* (Good).
    *   *Is it climbing?* (Bad - The secondaries cannot keep up with the write volume).
3.  **Action:** If lag is high, stop non-essential write jobs or scale up the cluster tier (CPU/Disk) immediately.

### Step 2: Check Oplog Headroom
1.  Check the **Oplog GB/Hour** graph in Atlas.
2.  Did a massive `updateMany` or `deleteMany` operation recently occur? These bloat the oplog massively.
3.  **Action:** If the window is dangerously low, pause the application logic causing the writes.

### Step 3: Check System Saturation (Disk/CPU)
1.  Go to **Hardware Metrics**.
2.  **Toggle Max:** Always look at the "Max" of the cluster, not just the Primary. Sometimes a Secondary is the bottleneck.
3.  Look at **Disk Queue Depth**.
    *   *If > 10:* Your disk is too slow for your traffic.
4.  Look at **IOPS**.
    *   *Are you flatlining at the top?* (e.g., hitting exactly 3000 IOPS constantly). This means you are being throttled by the cloud provider.
5.  **Action:** If throttled, you must increase disk size (IOPS usually scales with disk size) or upgrade the cluster tier.

### Step 4: Identify Blocking Operations (Global Lock)
1.  Look at **Tickets Available** (WiredTiger).
2.  If *Read Tickets* or *Write Tickets* drops to zero, the database is fully locked.
3.  **Action:** This usually requires killing a specific slow query or restarting the application servers to stop a flood of requests.

---

## 4. 🩹 Common Diagnoses from this Runbook

If you are using this runbook, you usually conclude with one of these findings:

1.  **"The Disk is Saturated"**
    *   *Symptoms:* IOPS flatlining, high latency on simple queries.
    *   *Fix:* Upgrade storage speed (provisioned IOPS) or optimize queries to write less data.
2.  **"Replication Lag due to Write Load"**
    *   *Symptoms:* Secondaries are 5 minutes behind; `w:majority` writes are failing.
    *   *Fix:* Scale up the cluster CPU/RAM to process writes faster.
3.  **"Oplog Danger"**
    *   *Symptoms:* Oplog window dropped to < 1 hour.
    *   *Fix:* Stop the batch job immediately.

---

## 5. ⚡ Summary Command for ChatOps
When an engineer finishes this protocol, they might post this in Slack:

> "Ran **Protocol 5 (Cluster Metrics)**.
> - **Replication:** Healthy (0s lag).
> - **Oplog:** Window is stable at 48hrs.
> - **Disk:** 🚨 **Alert** - Primary node is hitting 100% of provisioned IOPS. Queue depth is 25.
> - **Conclusion:** The database is hardware-throttled. We need to increase provisioned IOPS or investigate the sudden spike in write operations."
