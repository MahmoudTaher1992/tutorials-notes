Based on the Table of Contents you provided, the entry `006-Runbooks-Checklists/005-RTPP-runbook.md` refers to the operational guide for using the **Real-Time Performance Panel (RTPP)** in MongoDB Atlas.

Here is a detailed breakdown of what that specific runbook covers, how to interpret it, and actionable steps used during an incident.

---

# ⚡ Breakdown: The RTPP (Real-Time Performance Panel) Runbook

## 1. What is the RTPP?
Think of the **RTPP** as the **"live CCTV camera"** or the **"Emergency Room Heart Monitor"** of your database.
*   **Unlike the Query Profiler** (which looks at history), the RTPP shows you exactly what is happening **right now** (live operations).
*   **Goal:** To immediately identify **currently running** slow queries, blocked operations, or unexpected traffic spikes during an active incident.

---

## 2. When to Execute This Runbook
You open this runbook immediately when:
1.  **Latency Spikes:** The application is suddenly slow/timing out.
2.  **Alerts Fire:** You get a `Connection High` or `CPU High` alert.
3.  **Deployment Monitoring:** You just deployed new code and want to ensure it isn't locking the DB.

---

## 3. The Runbook Steps (Detailed Protocol)

### Step 1: Navigation & Setup
*   **Action:** Log in to MongoDB Atlas > Click your Cluster > Click the **"Real-Time"** tab.
*   **Critical Setting:** Look for the **"Pause"** button. The RTPP moves very fast. To analyze a spike, you must be ready to hit "Pause" when you see a long bar or a lag spike.

### Step 2: Analyze the "Operations" Graph (The Top Bar Chart)
This chart shows the volume of operations per second.
*   **Green Bars (Query):** Standard distinct reads. *Is there a massive spike?*
*   **Blue Bars (Update/Insert):** Writes. *Are writes blocking reads?*
*   **Yellow/Red (Command):** Administrative tasks or heavy aggregations.
*   **Diagnostic Question:** Is the traffic pattern normal, or is there a sudden explosion of one specific color?

### Step 3: Identify "The Longest Running Operation"
This is the most critical section for debugging outages.
*   **Action:** Look at the bubbles or list below the graph.
*   **What to look for:**
    *   **Execution Time:** Any operation running longer than **100ms** (for high-speed apps) or **seconds** is a red flag.
    *   **Operation Type:** Is it a `COLLSCAN` (Collection Scan)? This means a query is running without an index, checking every document one by one.
    *   **Action:** Snapshot the query shape (what the query looks like) to fix later.

### Step 4: Check "Hottest Collections"
*   **What it shows:** Which specific table (collection) is taking the most hits.
*   **Diagnosis:**
    *   If `Collection A` usually has 10 ops/sec but now has 5,000 ops/sec, your application has a logic bug or a "retry storm."

### Step 5: Emergency Intervention (The Kill Switch)
*   **Warning:** This is dangerous. Only do this if the DB is completely unresponsive.
*   **Action:** If you see a specific operation taking 30+ seconds and blocking everything else (e.g., a bad migration script), Atlas allows you to **Kill Op**.
*   **Procedure:** Locate the specific `opid` (Operation ID) in the panel > Select "Kill Operation."

---

## 4. Common Patterns & Interpretations (Cheatsheet)

This runbook usually includes a lookup table for common visual patterns:

| Pattern in RTPP | Probable Cause | Recommended Fix |
| :--- | :--- | :--- |
| **High number of Reads (Green), Low latency** | Normal traffic spike (Marketing push). | Scale up cluster tier temporarily. |
| **few Reads, but extremely High Latency** | Missing Index (COLLSCAN). | Add index immediately (Rolling build). |
| **High Writes (Blue), Reads dropping to zero** | Write Lock / Blocking. | Check for large batch updates or unoptimized deletes. |
| **"Queued" lines visible** | CPU Saturation. | The disk/CPU cannot keep up. Check hardware metrics. |
| **Empty Panel (No ops)** | Network Partition. | The app cannot reach the DB. Check VPC peering or App logs. |

---

## 5. Summary of Decision Flow
When using the `RTPP Runbook` in a live incident, your flow is:

1.  **Open RTPP.**
2.  **Is it Empty?** -> Yes? It's a Network issue.
3.  **Is it Full?** -> Yes? Look at the **Color**.
    *   **Mostly Green:** Check for unindexed queries (SLOW_QUERY).
    *   **Mostly Blue:** Check for locking/contention (LOCKS).
4.  **Identify the specific bad query.**
5.  **Kill the query** (if acute) OR **Scale user access** (if chronic).

This file (`005-RTPP-runbook.md`) essentially tells the engineer **how to read the live pulse of the database** and stop the bleeding before doing deep historical analysis.
