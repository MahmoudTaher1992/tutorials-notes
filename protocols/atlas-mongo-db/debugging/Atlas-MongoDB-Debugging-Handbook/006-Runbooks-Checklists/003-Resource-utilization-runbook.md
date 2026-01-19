Based on the hierarchy of your Table of Contents, the file **`006-Runbooks-Checklists/003-Resource-utilization-runbook.md`** corresponds to **Section 6 (Runbooks)** and details the execution steps for **Protocol 4 (Resource Utilization)**.

Here is a detailed explanation of what this specific runbook contains, why it exists, and how to use it.

---

### 📘 **003-Resource-utilization-runbook.md**
**("The Hardware Health Check")**

#### **1. What is this file?**
This is an operational checklist designed to be used when the database is slowing down not because of *connection limits*, but because the underlying infrastructure (CPU, RAM, or Disk) is hitting its physical or provisioned limits.

In Cloud environments like MongoDB Atlas, this is often called "saturation."

#### **2. When to use this Runbook?**
You open this specific file when:
*   **Alerts fire:** You receive alerts like `CPU > 90%` or `Disk Queue Depth High`.
*   **Performance drops:** Queries are slow, but connection counts are normal.
*   **Scale issues:** You suspect you have outgrown your current cluster tier (e.g., trying to do M50 work on an M30 cluster).
*   **Page Faults:** The database is reading from the disk too often because data doesn't fit in RAM.

---

### **3. Detailed Content Breakdown**

This runbook focuses on the "Big Three" resources. Here is what is likely inside that Markdown file:

#### **A. 🧠 CPU Saturation (The Processor)**
*   **The Diagnosis:**
    *   **User CPU vs. System CPU:** Is the CPU high because MongoDB is working hard on queries (User), or because the OS is struggling with overhead/context switching (System)?
    *   **Steal %:** (Specific to cloud/Atlas) Are "noisy neighbors" on the same physical host stealing CPU cycles?
*   **The Checklist Action:**
    *   Identify queries doing **COLLSCAN** (Collection Scans). These eat CPU because they engage the processor to look at every document.
    *   Check for **Missing Indexes**.
    *   **Immediate Fix:** Kill the specific heavy query op.
    *   **Strategic Fix:** Scale up the cluster tier temporarily or add the missing index.

#### **B. 📝 Memory & Working Set (RAM)**
*   **The Context:** MongoDB loves RAM. It will almost always use 80-90% of available RAM. High usage is **normal**.
*   **The Diagnosis (The "Bad" Memory usage):**
    *   **Page Faults:** This is the critical metric. It means the data needed isn't in RAM and the DB has to fetch it from the disk (which is slow).
    *   **Ticket Utilization:** If the *Read/Write Tickets* drop to zero, the CPU/RAM cannot accept new work.
*   **The Checklist Action:**
    *   Check the **Working Set** size vs. **Available RAM**.
    *   Identify if a specific query is doing an "In-Memory Sort" that exceeds the 100MB buffer limit.

#### **C. 💾 Disk I/O (Input/Output)**
*   **The Context:** Cloud disks have limits on how fast they can read/write (IOPS) and how much data they can move (Throughput).
*   **The Diagnosis:**
    *   **Queue Depth:** Are read/write requests piling up waiting for the disk to spin?
    *   **IOPS Saturation:** Have you hit the limit of your storage tier (e.g., 3000 IOPS)?
    *   **Disk Utilization %:** Is the disk working 100% of the time?
*   **The Checklist Action:**
    *   Look for un-indexed `update` or `delete` operations (these cause massive disk writes).
    *   Check if **Checkpointing** is causing spikes (writing RAM data to Disk).
    *   **Fix:** Upgrade disk IOPS (Atlas allows this without downtime) or fix the inefficient queries.

---

### **4. Summary of the Workflow**

If you were following this runbook during an incident, your workflow would look like this:

1.  **Assess:** "My alerts say CPU is 95%."
2.  **Navigate:** Go to **Atlas Metrics** -> **Hardware**.
3.  **Check:**
    *   **Is it Disk?** (High Queue Depth?) → *Result: No.*
    *   **Is it RAM?** (High Page Faults?) → *Result: No.*
    *   **Is it CPU?** (High User CPU?) → *Result: Yes.*
4.  **Investigate:** Use the **Profiler** to find the query doing a collection scan.
5.  **Remediate:** Create an index or terminate the operation.

### **In the Context of the TOC**
This file is the **Action Plan** for the concepts introduced in **Section 4.3** and detailed in **Protocol 4**. It strips away the theory and gives you the specific items to click and check to resolve a hardware bottleneck.
