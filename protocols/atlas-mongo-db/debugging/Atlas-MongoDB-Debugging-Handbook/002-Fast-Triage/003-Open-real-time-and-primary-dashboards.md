This section of your handbook (**002-Fast-Triage / 003-Open-real-time-and-primary-dashboards**) is the "Cockpit Check" moment.

In an emergency (like an 85% connection saturation alert), you cannot debug blindly. You must immediately open the specific visual interfaces that tell you the **current state** of the patient.

Here is the detailed breakdown of what this step entails, mapped to what you should actually see and do in the Mongo Atlas Interface.

---

# 📖 Deep Dive: 2.3 Open Real-Time and Primary Dashboards

### The Utility of this Step
**Goal:** Establish immediate situational awareness.
**Time spent:** 1–2 minutes.
**Action:** Open multiple browser tabs to view the database through three different "lenses" simultaneously.

---

## 👁️ Lens 1: The Real-Time Performance Panel (RTPP)
**Path:** `Login` → `Cluster` → `Three Dots (...)` → `Real-Time Performance Panel`

This is your most distinct tool because standard metrics have a delay (granularity). **RTPP is live.**

1.  **Why you open this first:**
    *   It shows you what is happening **right now** (second-by-second).
    *   It helps distinguish between a steady increase in load vs. a violent spike.

2.  **What you look for (The "Vitals"):**
    *   **The Top Graph (Ops/Sec):** Are you seeing a massive wall of Blue (Queries) or Green (Updates)?
        *   *Insight:* If Blue is spiking, you have a read-heavy Loop or a missing index. If Green is spiking, you are write-bottlenecked.
    *   **The Hottest Collection:** On the right side, RTPP lists which *specific collection* is taking the hit.
        *   *Example:* If you see `users` collection at 90%, you know immediately where to look in your code.
    *   **Slowest Operations:** The bottom list shows queries taking the longest *right now*.
        *   *Action:* Snapshot/Screenshot this list immediately for evidence.

---

## 📈 Lens 2: The Hardware Metrics (System Resources)
**Path:** `Cluster` → `Metrics` → `System` (Tab)

This tells you if the engine is running out of gas. You are checking against physical limits.

1.  **CPU Usage (The Brain):**
    *   **Look for:** Is it pegged at 100%? Or is it stealing credits (burstable capability)?
    *   *Interpretation:* 100% CPU usually means "Scanning Documents" (Missing Index). Low CPU but slow app usually means "Network" or "Locking."

2.  **Disk I/O & IOPS (The Storage):**
    *   **Look for:** Are you hitting the IOPS limit provided by your tier (e.g., 3000 IOPS on M30)?
    *   *Interpretation:* If you hit the limit, Atlas "throttles" you. Queries queue up, latency spikes, and the app times out.

3.  **Memory (The Workspace):**
    *   **Look for:** Do not panic if Memory is high (Mongo grabs what it can). Look for **Page Faults**.
    *   *Interpretation:* If Page Faults are high, Mongo is reading from Disk because RAM is full (very slow).

---

## 🔌 Lens 3: The Database Metrics (Connections & Queues)
**Path:** `Cluster` → `Metrics` → `Connections` (Tab)

This is the specific context for the "Connection Saturation" alert mentioned in your TOC intro.

1.  **Connections:**
    *   **The Shape:** Look for the "Hockey Stick." Did connections go from 100 to 1,500 in 10 seconds?
    *   *Interpretation:* If yes, this is a **Connection Storm**. The app servers are panicking and retrying, flooding the DB.
    *   *Action:* You may need to restart app servers to clear the pool.

2.  **Network In/Out:**
    *   **Look for:** A massive spike in "Network Out."
    *   *Interpretation:* Someone ran a query returning 10MB documents without a `limit()`, clogging the pipe.

3.  **Queues (The Hidden Killer):**
    *   *Note:* You often have to click "Add Chart" to see `Global Lock Current Queue`.
    *   **Look for:** Is the queue > 0?
    *   *Interpretation:* If there are operations in the "Readers" or "Writers" queue, the database is fully blocked. It cannot process requests fast enough.

---

## ⚡ Stress Test Observation context
The TOC mentions **"stress test observation."**

If you are running a load test or deploying a new feature:
*   You keep **RTPP** open on one screen.
*   You watch the **Connections** graph on another.
*   **The Goal:** Correlate the "Start Test" timestamp with the "Spike" timestamp. If the DB spikes *before* the traffic hits max, your query efficiency is poor.

---

### Summary Checklist for Step 2.3
When you complete this step, you should be able to say:
> *"I have the RTPP open showing the `orders` collection is hot. I have the Metrics open showing CPU is safe at 40%, but Connections have spiked to 90% and are queuing."*

Now you are ready to choose a **Protocol** in Section 4.
