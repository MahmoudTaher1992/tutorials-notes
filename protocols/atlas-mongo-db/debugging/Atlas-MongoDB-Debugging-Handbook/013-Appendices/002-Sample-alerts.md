Based on the Table of Contents provided, section **13. Appendices / 002-Sample-alerts.md** serves as a **reference library** for the specific alarm signals that trigger a debugging investigation.

When an incident occurs, you often receive a notification (via Slack, PagerDuty, or Email) from MongoDB Atlas. This file explains what those notifications look like, what they mean, and why they were set to specific numbers (thresholds).

Here is a detailed breakdown of what is contained in **013-Appendices/002-Sample-alerts.md**:

---

### 1. The Purpose of This Appendix
This file answers the question: **"What does 'normal' vs. 'critical' look like?"**
It prevents engineers from guessing whether a metric is dangerous or safe. It provides a baseline so that when an alert fires, you can compare the current situation against pre-defined danger zones.

### 2. Anatomy of a MongoDB Atlas Alert
The file outlines the standard structure of an alert so engineers can read them quickly:
*   **Metric Name:** (e.g., `Connections %`, `System CPU`, `Replication Lag`).
*   **Operator:** (e.g., Greater than `>`).
*   **Threshold:** The specific number that trips the wire (e.g., `80%`).
*   **Duration:** How long the problem must persist before alerting (e.g., `5 minutes`). *This prevents alerts from firing on 1-second blips.*

---

### 3. Detailed Contents: Maximum Priority Alerts
This section of the file details the specific "Red Alert" scenarios mentioned in the handbook.

#### A. Connection Saturation (The Primary Context)
*   **Alert Name:** `Connections % > 80`
*   **Threshold:** > 80% usage of the max allowed connections for your instance size.
*   **Duration:** 2+ minutes.
*   **Meaning:** The database is running out of "seats" for incoming app requests. If this hits 100%, the app will crash/timeout immediately.
*   **Action:** Triggers **Protocol 1 (Connection Analysis)**.

#### B. Resource Exhaustion (CPU/Disk)
*   **Alert Name:** `Normalized System CPU % > 90`
*   **Meaning:** The hardware is maxed out processing calculations.
*   **Action:** Indicates a need for **Protocol 4 (Resource Utilization)** or vertical scaling.
*   **Alert Name:** `Disk Queue Depth > 10`
*   **Meaning:** Requests are stuck waiting for the hard drive to write/read data.

#### C. Replication Lag (Cluster Health)
*   **Alert Name:** `Replication Lag > 60 seconds`
*   **Meaning:** The Secondary nodes are falling behind the Primary. If the Primary dies now, you lose 60 seconds of data.
*   **Action:** Triggers **Protocol 6 (Replication Runbook)**.

#### D. Query Efficiency (The Silent Killer)
*   **Alert Name:** `Query Targeting (Scanned / Returned) > 1000`
*   **Meaning:** For every 1 document propery found, the database had to read 1,000 documents. This indicates **missing indexes**.
*   **Action:** Triggers **Protocol 3 (Query Profiler)**.

---

### 4. How to Use This File During an Incident
1.  **Phone buzzes:** You get a PagerDuty alert saying "Atlas Alert: Connections High."
2.  **Check this Appendix:** You look at `002-Sample-alerts.md`.
3.  **Verify Severity:** You see that the threshold is set to 80% for a "Warning" and 95% for "Critical."
4.  **Compare:** If the live dashboard shows 82%, you have time to investigate. If it shows 99%, you need to shed load immediately.

### 5. Why "Thresholds" Matter
This file documents **why** the numbers were chosen.
*   *Why 80% and not 99%?* Because at 80%, you have time to fix it. At 99%, it is usually too late to run queries to fix the problem because the admin connection cannot get in.

### Summary
In short, **013-Appendices/002-Sample-alerts.md** is the **dictionary of danger signals**. It translates raw numbers (metrics) into actionable warnings so the team knows exactly which Protocol to start executing.
