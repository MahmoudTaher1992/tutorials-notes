Based on the Table of Contents you provided, specifically under **Section 5: Debugging Protocols**, here is the detailed explanation of **Protocol 2 — ⚡ RTPP Protocol** (corresponding to file `002-Protocol-RTPP.md`).

This protocol is arguably the most critical for **live incident response** because it shows you what is happening *right now*, whereas other tools (like the Profiler) are often delayed by a few minutes.

---

# ⚡ Protocol 2: Real-Time Performance Panel (RTPP) Strategy

### 1. Objective 🎯
To identify the specific operations causing immediate cluster stress, latency, or blocking during a live event. Unlike the "Metrics" tab (which averages data), the RTPP provides granular, second-by-second visibility into database throughput and execution.

### 2. When to Use This Protocol ⏱
*   **During** an active outage or slowdown.
*   When CPU is high (>80%) but you don't know if it's due to volume (too many queries) or complexity (bad queries).
*   When the application team reports "timeouts" but connection counts are stable.

---

### 3. Navigation (How to get there) 🗺
1.  Log in to **MongoDB Atlas**.
2.  Navigate to your target **Cluster**.
3.  Click the tab labeled **Real-Time**.
    *   *Note: If you have a sharded cluster, you must select the specific Shard or Mongos that is struggling, though usually, you start with the Primary node of the main replica set.*

---

### 4. Anatomy of the Protocol (What to Analyze)

The RTPP is divided into three critical sections using a specific visual language ("The Rainbow"):
*   **Updates (Green)**
*   **Inserts (Blue/Teal)**
*   **Queries (Blue)**
*   **Deletes (Red)**
*   **Commands (Grey)**

#### Step A: Analyze the "Operations per Second" Graph
*   **What to look for:** Sudden spikes in the height of the bars.
*   **The Diagnosis:**
    *   **High Blue Bars (Queries):** You are likely facing a "Read Storm." Look for unindexed queries or a cache stampede.
    *   **High Green/Teal Bars (Writes):** You are facing a "Write Storm." This might be a bulk import or a retry-storm from the application.
    *   **Flatline (Zero Ops):** If the App is sending traffic but RTPP shows 0 ops, the database is locked or the network is severed.

#### Step B: The "Hottest Collections" View
*   **Location:** Top right of the RTPP.
*   **What it tells you:** It ranks collections by activity.
*   **The Action:** If 90% of your load is coming from `Orders` collection, ignore the `Users` collection. Focus your debugging immediately on `Orders`.

#### Step C: The "Longest Running Operations" (The Killer Feature) 🕵️
*   **Location:** Bottom half of the screen.
*   **What it shows:** Queries currently executing that have not finished yet.
*   **The Protocol:**
    1.  Look for operations with a duration **> 3 seconds**.
    2.  Check the **Plan Summary**:
        *   `COLLSCAN`: **(CRITICAL START HERE)** This means the query is scanning every document. This is usually the root cause of CPU spikes.
        *   `IXSCAN`: The index is being used, but it might be the wrong one, or the dataset is just too large.
    3.  **Kill Switch:** If a specific query is running for 30+ seconds and blocking the DB, you can often click the **"Kill"** button (if your permissions allow) to free up resources immediately.

---

### 5. Common “Signature” Patterns in RTPP

When running this protocol, you are looking for one of these three patterns:

#### Scenario 1: The "Death Spiral" (High Latency, Low Ops)
*   **Visual:** The graph bars are very short (low ops/sec), but the "Average Execution Time" line is spiking high.
*   **Meaning:** The DB isn't doing *many* things, but the things it is doing are extremely heavy.
*   **Root Cause:** Usually a single bad query (COLLSCAN) on a large collection or a Schema Lock.
*   **Fix:** Use the "Longest Running Ops" to find the query and kill it/optimize it.

#### Scenario 2: The "DDOS" Effect (High Ops, Low Latency)
*   **Visual:** The graph bars are maxed out (thousands of ops/sec), mostly blue (read) or green (write). Execution time is low/normal.
*   **Meaning:** The queries are fast, but the application is sending too many of them. The DB is drowning in volume.
*   **Root Cause:** Infinite loop in code, bad retry logic, or marketing rush.
*   **Fix:** Scale up the cluster size (vertical scaling) immediately to survive the traffic, then fix the app code.

#### Scenario 3: The "Lock Up"
*   **Visual:** Activity suddenly drops to near zero despite application demand.
*   **Meaning:** A specific operation has taken a global or exclusive lock (W).
*   **Root Cause:** Often an index build in the foreground, or a massive delete operation.

---

### 6. Evidence Collection (For the Postmortem) 📸
Since RTPP is "Real-Time," the data disappears once it slides off the screen.
*   **Take a Screenshot:** As soon as you see the spike and the identifying query shapes.
*   **Note the Time:** Mark the exact minute the pattern changed.

---

### Summary Checklist for Protocol 2
1.  [ ] **Open Real-Time Tab.**
2.  [ ] **Identify Dominant Color:** (Read vs. Write).
3.  [ ] **Check Hottest Collection:** Narrow the scope.
4.  [ ] **Find Longest Running Op:** Look for `COLLSCAN`.
5.  [ ] **Decision:** Kill Op OR Scale Cluster.
