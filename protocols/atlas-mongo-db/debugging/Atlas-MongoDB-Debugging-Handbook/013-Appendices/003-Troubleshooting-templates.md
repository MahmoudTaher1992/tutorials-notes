Based on the Table of Contents you provided, the section **013-Appendices/003-Troubleshooting-templates.md** is a collection of **pre-formatted, fill-in-the-blank documents** designed to be used during or after an incident.

When your database is down or slow, panic sets in. You might forget to check specific metrics or record what time the issue started. These templates act as a checklist and a logbook to ensure you gather the right data every time.

Here is the detailed explanation of what is typically inside this file and how to use it.

---

### 📝 What is inside this file?
This file contains **boilerplate Markdown (or text) templates** for three specific scenarios:

#### 1. The "Incident War Room" Log (Real-Time)
A template used *during* the outage to track live observations and actions. This ensures that when the incident is over, you have a timeline of exactly what happened.

**Example Structure:**
> **🚨 Incident Tracking Sheet**
> *   **Cluster Name:** `[e.g., PROD-01]`
> *   **Time Detected:** `[UTC Time]`
> *   **Trigger:** `[e.g., OpsGenie Alert: Connections > 80%]`
> *   **Current State:**
>     *   Primary Node CPU: `__%`
>     *   Connection Count: `__ / max`
>     *   App Error Rate: `__%`
> *   **Recent Changes:** `[Did we deploy code 10 mins ago? Yes/No]`
> *   **Actions Taken:**
>     *   `[Time]` - Rolled back deployment.
>     *   `[Time]` - Killed long-running query ID #1234.

---

#### 2. The "MongoDB Support" Escalation Template
If you cannot fix the issue and need to open a ticket with MongoDB Atlas Support, they will ask for specific information. This template prepares that info beforehand so you don't waste time going back and forth.

**Example Structure:**
> **🆘 MongoDB Atlas Support Ticket Request**
> *   **Impact:** `[Production Down / Performance Degraded]`
> *   **Cluster Link:** `[URL to Atlas Cluster]`
> *   **Specific Symptoms:** `[e.g., Latency spiked to 2000ms at 14:00 UTC]`
> *   **Evidence Attached:**
>     *   ✅ Screenshot of Metrics (Network/Connections)
>     *   ✅ Profiler Logs of slow queries
>     *   ✅ Application Driver Logs
> *   **What we have tried so far:** `[e.g., We restarted the app servers, but DB CPU remains at 100%]`

---

#### 3. The "Post-Mortem" Brief (RCA)
A template to fill out *after* the fire is put out. It aligns with Section 12 (Evidence Pack). It summarizes the root cause to prevent it from happening again.

**Example Structure:**
> **🧠 Incident Post-Mortem (RCA)**
> *   **Root Cause:** `[e.g., Missing index on users collection caused collection scan during traffic spike]`
> *   **Detection Time:** 10 mins
> *   **Resolution Time:** 25 mins
> *   **Fix Implemented:** Created index `{ "email": 1 }`
> *   **Prevention Plan:** Add index review to CI/CD pipeline.

---

### 🚀 Why is this section important?

1.  **Reduces Cognitive Load:** When an alert wakes you up at 3 AM, you don't have to "think" about what to check. You just fill in the blanks.
2.  **Standardization:** It ensures every engineer on the team debugs the same way and collects the same metrics.
3.  **Audit Trail:** If management asks, "What did you do to fix the DB?", you can simply hand them the filled-out template.
4.  **Speed:** Copy-pasting a pre-written template into a Slack channel or Jira ticket is much faster than typing updates manually.

**In summary:** This file is your "administrative safety net." It turns a chaotic debugging session into a structured, professional engineering process.
