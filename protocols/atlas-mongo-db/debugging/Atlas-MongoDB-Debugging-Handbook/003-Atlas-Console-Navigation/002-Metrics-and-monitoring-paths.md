Based on the Table of Contents you provided, here is the detailed explanation and content expansion for **Section 3.2: Metrics and monitoring paths**.

This section of your handbook is the "Cockpit Controls" guide. It tells the engineer exactly **where to click** to find the specific charts needed to diagnose the issue. It ensures they aren’t wasting time looking for the right graph during an incident.

---

# 📂 File: `003-Atlas-Console-Navigation/002-Metrics-and-monitoring-paths.md`

## 1. The Context
When an alert fires (e.g., "Connections > 80%"), you need to validate the alert against the raw data. This section guides you to the two main sources of truth in Atlas: **System Metrics** (Graphs) and **Alert History** (Logs).

## 2. Path 1: Monitor → Metrics (The Dashboard)
This is your primary dashboard for cluster health.

### **Navigation Steps:**
1.  Log in to Atlas.
2.  Select your **Project**.
3.  Locate the target **Cluster**.
4.  Click the **Metrics** button (usually next to "Overview" and "Collections").

### **Key Metrics Tabs to Check:**
Once inside the Metrics view, you will see several sub-tabs. These are the specific paths you must navigate:

#### **A. 🔌 Connections (Top Priority)**
*   **Where:** Metrics → **Connections**
*   **What to look for:**
    *   **Current Connections:** The generated number of active TCP connections.
    *   **Available Connections:** The hard limit based on your instance size (e.g., M30, M50).
    *   **Behavior:** Look for a "sawtooth" pattern (connection storm) or a steady climb to 100% (leak).

#### **B. 🖥 System (CPU & Memory)**
*   **Where:** Metrics → **System**
*   **What to look for:**
    *   **System CPU (Normalized):** Is the hardware maxing out?
    *   **CPU Steal:** (If on shared tier) Are "noisy neighbors" slowing us down?
    *   **Memory Usage:** Is the Working Set fitting in RAM?

#### **C. 💾 Disk (I/O & Space)**
*   **Where:** Metrics → **Disk**
*   **What to look for:**
    *   **Disk IOPS:** Are we hitting the IOPS limit of the provisioned storage?
    *   **Disk Queue Depth:** If this is high, the disk cannot keep up with write/read requests, causing latency.

#### **D. 🌐 Network**
*   **Where:** Metrics → **Network**
*   **What to look for:**
    *   **Network Bytes In/Out:** A sudden spike here usually correlates with massive queries returning too much data (lack of projection) or a bulk insert operation.

---

## 3. Path 2: Monitoring → Alerts (Details + History)
While charts show *trends*, the Alerts page shows *triggers*. This tells you exactly when the threshold was crossed.

### **Navigation Steps:**
1.  Click **Alerts** in the left-hand sidebar (sometimes under "Monitoring" or just "Alerts" depending on UI version).
2.  Filter by **Status: Open** (for current issues) or **Closed** (for past patterns).

### **What to Analyze Here:**
*   **The Specific Trigger:**
    *   *Example:* "Connections % > 80% on Primary node."
    *   *Why it matters:* Tells you if the issue is only on the Primary (write heavy) or Secondary (read heavy).
*   **Duration:**
    *   How long has the alert been open? Is this a spike (1 minute) or a plateau (2 hours)?
*   **Text/Email Confirmation:**
    *   Validate that the PagerDuty/Slack alert matches what Atlas sees.
*   **Host Identification:**
    *   Atlas will list the specific hostname (e.g., `cluster0-shard-00-01...`). Use this to filter your Metrics graphs to that specific node.

---

## 💡 Navigation Pro-Tips (To include in the handbook)

1.  **Scope the Host:** By default, Atlas often shows an average of the Replica Set. **Always** use the dropdown at the top of the charts to select the **Primary** node specifically. Secondary lag is different from Primary saturation.
2.  **Granularity/Zoom:**
    *   If debugging a crash that happened 10 minutes ago, change the time range from `Last 24 Hours` to `Last 1 Hour`.
    *   Be aware that M0/M2/M5 clusters have lower granularity (less accurate charts) than M10+ clusters.
3.  **Mouse-Over Correlation:**
    *   When you hover your mouse over a spike in "Connections," Atlas draws a vertical line across *all* reflected charts (CPU, Disk, etc.). Use this to see if CPU spiked *at the exact same second* connections went up.

---

### Summary of Differences:
| Feature | **Metrics (Path 1)** | **Alerts (Path 2)** |
| :--- | :--- | :--- |
| **Goal** | Visualize trends and correlations. | Identify exact timestamps and thresholds. |
| **Question Answered** | *"Is the CPU high while connections are high?"* | *"At what exact minute did we cross 80%?"* |
| **Best For** | Deep investigation. | Initial component identification. |
