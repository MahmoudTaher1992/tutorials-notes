Based on the TOC structure you provided, the section **`007-Dashboards-Instrumentation/003-Alerting-thresholds.md`** (or Section 7.3) is the **operational "safety net"** of your handbook.

This section defines **when** your phone should buzz (Alerts) and **what** subtle changes indicate a storm is coming (Signals). It prevents "alert fatigue" by distinguishing between "Keep an eye on this" (Warning) and "Wake up the engineer" (Critical).

Here is the detailed content breakdown for that specific file.

---

# 🔔 007-Dashboards-Instrumentation / 003-Alerting-thresholds.md

## 1. The Strategy: Signal vs. Noise
Effective alerting requires distinguishing between transient spikes (noise) and sustained issues (signal).
*   **Warning (Yellow):** Indicates a trend that requires investigation during business hours.
*   **Critical (Red):** Indicates imminent downtime or severe performance degradation requiring immediate intervention.
*   **Duration:** Alerts should usually trigger only if the threshold is breached for **at least 5–10 minutes** to avoid paging on temporary hiccups.

## 2. Core Alerting Thresholds "Cheat Sheet"

The following table outlines the standard recommended thresholds for a healthy MongoDB Atlas cluster.

| Metric Category | Metric Name | ⚠️ Warning (Investigate) | 🚨 Critical (Wake Up) | Why it matters |
| :--- | :--- | :--- | :--- | :--- |
| **Connectivity** | **current connections** | **70-75%** of limit | **85-90%** of limit | If this hits 100%, the DB rejects new application requests. Immediate outage. |
| **Compute** | **Normalized CPU** | **75%** (sustained 10m) | **90%** (sustained 5m) | High CPU slows down every query. >95% usually causes the cluster to become unresponsive. |
| **Disk / Storage** | **Disk Utilization / IOPS** | **80%** of provisioned | **95%** of provisioned | If IOPS are capped, the DB "chokes" on reads/writes, causing massive latency. |
| **Memory** | **System Memory** | N/A (See note below) | **95%** (if swap is used) | MongoDB naturally uses massive RAM. Alert on **Swap Usage** instead (Swap > 1GB is bad). |
| **Replication** | **Replication Lag** | **> 15 Seconds** | **> 60 Seconds** | High lag means Secondaries aren't up to date. If Primary fails, you lose data. |
| **Availability** | **Asserts / Errors** | > 10 / hour | > 100 / hour | Indicates internal database errors or severe failures. |

---

## 3. Detailed Signal Explanations

### 🔌 A. Connections % (The "Bottleneck" Signal)
This is your most common alert during connection storms.
*   **The Signal:** The number of open TCP connections compared to the instance size limit (e.g., M30 allows 3,000 connections).
*   **The Risk:**
    *   **At 80%:** You have little room for a traffic spike or multiple app deployments restarting simultaneously.
    *   **At 100%:** Hard App Down. The driver throws `MongoTimeoutError`.
*   **Action:** Check for "connection leaks" in the app code or increase the cluster tier.

### 💻 B. CPU Utilization (The "Inefficiency" Signal)
*   **The Signal:** How hard the processor is working to find data.
*   **Steal Time (Wait Time):** If on AWS/Cloud, check "CPU Steal." If this is high, the noisy neighbor effect is happening, or you have exhausted your burst credits (on smaller instances like M10/M20).
*   **Action:** If CPU is high but traffic is normal, you likely have **unindexed queries** scanning documents unnecessarily.

### 🐢 C. WiredTiger Tickets (The "Concurrency" Signal)
*This is an advanced metric but crucial for high-load systems.*
*   **The Concept:** WiredTiger (the storage engine) gives out "tickets" for reading and writing. By default, there are 128 read tickets and 128 write tickets.
*   **The Threshold:**
    *   **Warning:** Available tickets drop below **60**.
    *   **Critical:** Available tickets drop to **0**.
*   **The Signal:** If tickets hit 0, operations queue up inside the database. This creates a "hockey stick" graph in latency.
*   **Action:** Limit concurrency on the application side or optimize query speed.

### 🔁 D. Replication Lag (The "Data Integrity" Signal)
*   **The Signal:** How far behind (in time) the Secondary nodes are from the Primary.
*   **The Risk:**
    *   **Read Consistency:** If your app reads from secondaries (`readPreference: secondary`), users will see old data.
    *   **Failover Risk:** If the Primary dies while lag is high, the new Primary might not have the latest writes, resulting in **data rollback/loss**.

### 📉 E. Disk Queue Depth (The "I/O Saturation" Signal)
*   **The Signal:** The number of I/O operations waiting to be written to disk.
*   **Threshold:** A queue depth consistently **> 10** indicates the disk cannot keep up.
*   **Action:** You need higher IOPS (Provisioned IOPS) or better indexes to reduce the amount of data being read from disk.

---

## 4. Operational "Rules of Thumb"

1.  **Don't Alert on Physical Memory:** MongoDB is designed to use ~80-90% of available RAM for the cache. Only alert if **Swap Usage** increases, which means Mongo is being forced to write RAM to Disk (very slow).
2.  **Correlate Metrics:** A spike in *Connections* often causes a spike in *CPU*. Always look at who moved first to find the root cause.
3.  **The "10-Minute" Rule:** Do not wake up on call for a CPU spike that lasts 1 minute (likely a cron job). Configuring alerts to trigger only after "condition persists for X minutes" significantly reduces burnout.

---

## 5. Recommended Alert Policy Configuration (JSON/Terraform context)

*If configuring via API or Terraform, aim for policies like this:*

*   `Event: OUTSIDE_METRIC_THRESHOLD`
*   `Metric: CONNECTIONS_PERCENT`
*   `Operator: GREATER_THAN`
*   `Threshold: 85.0`
*   `Units: PERCENT`
*   `Mode: AVERAGE` (filters out millisecond spikes)

---

### 📝 Summary Note for the Handbook
Use this section to set up your **PagerDuty** or **OpsGenie** integrations inside Atlas. If you do not have these thresholds set, you are flying blind. Start with the **Connectivity** and **CPU** alerts as priority #1.
