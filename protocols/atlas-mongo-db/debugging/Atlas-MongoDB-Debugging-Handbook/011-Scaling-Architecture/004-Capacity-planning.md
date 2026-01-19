Based on the file path (`011-Scaling-Architecture/004-Capacity-planning.md`) and the context of your handbook, **Capacity Planning** is the proactive process of calculating when your current hardware (Cluster Tier) will no longer support your application's growth.

Unlike "Debugging" (which is reactive—fixing something that is broken), Capacity Planning is about looking at historical trends to prevent the crash before it happens.

Here is a detailed explanation of what this protocol covers, broken down into the 4 pillars of MongoDB Atlas capacity.

---

# 🏗️ Capacity Planning Protocol (Start Detail)

### 1. The Core Concept: "The Cliff"
MongoDB performance is generally linear until it hits a resource limit, at which point performance falls off a "cliff." Capacity planning is about calculating the distance to that cliff.

**The Goal:** Ensure you have **30% headroom** on all metrics during peak traffic details.

---

### 2. The Four Pillars of Capacity

#### A. 🧠 RAM & The "Working Set" (Most Critical)
MongoDB is a memory-centric database. It performs best when your **Indexes** and **"Hot Data"** (data accessed frequently) fit entirely inside the RAM (specifically the WiredTiger Cache).

*   **The Risk:** If your Working Set exceeds RAM, MongoDB must fetch data from the Disk. RAM is nanoseconds; Disk is milliseconds. Your database slows down by 100x.
*   **Planning Calculation:**
    *   Total Size of Indexes + estimated 20% of your total storage = **Required RAM.**
    *   *Example:* If you have 10GB of Indexes and 50GB of Data (10GB hot), you need ~20GB of RAM. An M30 (8GB RAM) is too small; you need an M40 (16GB) or M50.

#### B. 💾 Disk I/O & Storage (The Bottleneck)
In Atlas, you pay for storage space, but the hidden limit is **IOPS (Input/Output Operations Per Second)**.

*   **The Risk:** Even if you have free CPU, if your disk cannot read/write fast enough, operations "queue" up.
*   **Planning Check:**
    *   Are you using Standard IOPS (usually 3 IOPS per GB)?
    *   **Example:** A 100GB disk gives you 300 IOPS. If your app does 500 writes/sec, the disk will choke. You need to provision more IOPS or increase disk size to get more baseline speed.

#### C. 💻 CPU (The Cruncher)
CPU is heavily used for **unoptimized queries** (scans), **compression**, **decryption** (TLS), and **Javascript execution**.

*   **The Risk:** Continuous CPU usage > 80% causes "Ticket Exhaustion" (the database stops accepting new reads/writes).
*   **Planning Check:**
    *   If CPU spikes only during specific hours, this is a capacity issue.
    *   If CPU is high all the time, it is usually a **Bad Index** issue, not a capacity issue. Fix queries before buying a bigger server.

#### D. 🔌 Connections (The Hard Limit)
This is explicitly referenced in your section **1.2**. Every Atlas Tier has a hard limit on concurrent connections (e.g., M30 allows ~3,000 connections).

*   **The Risk:** Connection Storms. If you use Serverless functions (Lambda/Vercel) without a proxy, you will exhaust this limit instantly.
*   **Planning Check:**
    *   Current Peak Connections vs. Tier Limit.
    *   If you are at 80% (your Alert threshold), you must either:
        1.  Optimize connection pooling in the code.
        2.  Scale up to the next Tier (e.g., M40 allows more connections).

---

### 3. Forecasting & The Calculation Strategy

This part of the document instructs you on how to predict the future.

#### The "Burn Rate" Formula:
$$
\text{Time to Saturation} = \frac{\text{Total Capacity} - \text{Current Usage}}{\text{Growth Rate (Last 30 Days)}}
$$

**Detailed Steps to Execute:**
1.  **Pull 3 Month Data:** Go to Atlas Metrics. Look at "Disk Usage" and "IOPS" over 90 days.
2.  **Identify Linear Growth:** Is data growing by 1GB per day?
3.  **Identify Peaks:** Look for Black Friday, Marketing Blasts, or End-of-Month processing.
4.  **The Decision Point:**
    *   **Vertical Scaling (Scale Up):** Move from M30 -> M40. Do this if your entire dataset is relatively small (< 2TB) but just needs more power.
    *   **Horizontal Scaling (Sharding):** Add more shards. Do this if you have massive data (> 2-4TB) and a single machine cannot hold the disk/write load.

---

### 4. Atlas Auto-Scaling Configuration
This section reviews the Auto-Scaling settings to ensure they are safe.

*   **Storage Auto-Scaling:** ALWAYS turn this ON. It prevents the DB from going Read-Only when the disk is full.
*   **Tier Auto-Scaling:** Use with caution.
    *   *Pros:* scales up CPU/RAM automatically.
    *   *Cons:* It can take 15-20 minutes to complete the scale-up (the "blue/green" deployment). A sudden traffic spike will crash the DB *before* the auto-scaler finishes.
    *   *Rule:* Auto-scaling handles gradual growth, not sudden spikes.

---

### Summary Checklist for Section 4.10:
When referring to this section in an incident, you are asking:
1.  [ ] Is our **Working Set** (Indexes + Hot Data) larger than our **RAM**?
2.  [ ] Is our **Disk IOPS** hitting the limit consistently?
3.  [ ] Is our **Connection count** creeping up toward the hard limit?
4.  [ ] Do we need to schedule a **Tier Upgrade** before the next marketing launch?
