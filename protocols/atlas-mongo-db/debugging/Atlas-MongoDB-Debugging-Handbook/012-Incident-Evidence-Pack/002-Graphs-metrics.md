Based on the Table of Contents you provided, the file **`012-Incident-Evidence-Pack/002-Graphs-metrics.md`** corresponds to **Section 12.2 (Graphs & core metrics snapshots)**.

This file is essentially the **"Black Box Flight Recorder"** visualization for your incident. Its purpose is to move away from subjective statements (e.g., *"The database felt slow"*) to objective facts (e.g., *"CPU usage spiked to 99% at 14:02 UTC"*).

Here is a detailed explanation of what this file contains, why it exists, and how to structure it.

---

### 1. The Core Objective
This document is where you paste the **visual proof** of the incident. It validates the alert. If you receive a "Connection Saturation" alert, this file must contain the screenshot showing the connection graph hitting the limit.

**Why is this needed?**
1.  **Correlation:** It allows you to line up DB spikes with Application logs (e.g., "The app started throwing 502 errors exactly when DB connections hit 2000").
2.  **Post-Mortem (RCA):** You cannot fix what you cannot effectively visualize.
3.  **Vendor Support:** If you need to upgrade support tickets with MongoDB Atlas, these exact graphs are what they will ask for.

---

### 2. Detailed Structure (What goes inside this file?)

When filling out this file during or after an incident, it should be organized into these specific metric categories:

#### A. Global Time Window 📅
Before pasting graphs, you must define the timeframe.
*   **Incident Start:** `YYYY-MM-DD HH:MM UTC`
*   **Incident End:** `YYYY-MM-DD HH:MM UTC`
*   *Note: Always use UTC or explicitly state the Timezone to avoid confusion between App logs and DB logs.*

#### B. The "Smoking Gun" Graph 🔫
This is the single most important graph that matches the alert.
*   **If the alert was `Connections > 80%`:** Paste the **Connections** chart here.
*   **What to look for:** A sharp vertical line (cliff) or a gradual slope (memory leak) leading up to the failure.

#### C. Health & Resource Saturation 💻
These are supporting metrics to see if hardware limits caused the issue.
*   **CPU Utilization:** Did processing power max out? (e.g., due to a scan without an index).
*   **Disk I/O % & IOPS:** Did the disk get too slow? (Common during heavy backups or large batch inserts).
*   **Memory:** Did the WiredTiger cache fill up completely leading to eviction lag?

#### D. Throughput & Latency 📉
*   **Opcounters:** A graph showing Inserts/Updates/Queries per second. Did traffic suddenly double? Or did it drop to zero because the DB froze?
*   **Queues (Tickets):** *Critical for MongoDB.* A graph showing "Read/Write Tickets." If available tickets drop to 0, the DB is locked up.

---

### 3. Draft/Template Content
*If you were writing this file, here is exactly what it should look like:*

***

# 002 - Graphs & Core Metrics Snapshots

### 📅 Incident Timestamp Context
*   **Timezone:** UTC
*   **Impact Window:** 14:00 - 14:15
*   **Atlas Resolution:** *Graphs set to "1 Year - 1 Minute granular"* (or Zoomed into the specific hour).

### 🚨 Primary Trigger: Connection Saturation
*(Paste the screenshot from Atlas "Monitor" tab showing the connection spike)*
> **Observation:** Connections jumped from baseline (200) to max (1500) in under 30 seconds.

### 💻 Resource Utilization

#### 1. CPU Usage
*(Paste CPU % Graph)*
> **Observation:** CPU remained normal/low (20%) during the connection spike. This indicates the issue was likely **App-side (not closing connections)** rather than the DB struggling to process queries.

#### 2. Network In/Out
*(Paste Network Bytes Graph)*
> **Observation:** No significant spike in data transfer.

### 🧠 Performance & Queues

#### 1. Queued Operations
*(Paste Queues Graph from Real-Time or Metrics tab)*
> **Observation:** Read queue spiked. This suggests queries were waiting for a lock.

#### 2. Ticket Availability
*(Paste Read/Write Ticket Graph)*
> **Observation:** Read tickets dropped to 0.

---

### 4. How to use this in your Handbook
When a developer or SRE is following your **"Section 12: Incident Evidence Pack"**, they should open this Markdown file and simply **replace the placeholders with screenshots** from the MongoDB Atlas UI.

**Pro Tip for your documentation:**
Instruct users to **Snapshot immediately.** Atlas retains metric history, but "Real-Time Performance Panel" (RTPP) data is ephemeral. If they don't screenshot the RTPP during the incident, that granular data is lost forever.
