This section of the syllabus, **011-Cost-Management-and-Governance/001-Understanding-Billing.md**, is arguably one of the most practical and critical parts of using Datadog. Datadog is a powerful tool, but it is notorious for becoming very expensive very quickly if you do not understand *how* they count your usage.

Here is a detailed explanation of the three key concepts listed in that section.

---

### 1. Committed Use vs. On-Demand
This refers to the contractual model of how you pay for Datadog. It functions similarly to AWS Reserved Instances vs. On-Demand instances.

*   **Committed Use (Annual Plan):**
    *   **What it is:** You sign a contract agreeing to pay for a specific volume of hosts or logs for a year.
    *   **Benefit:** significant discount (often 20-30% cheaper) compared to the on-demand rate.
    *   **How it works:** If you commit to 100 Hosts, you pay for 100 Hosts every month regardless of whether you use them.
*   **On-Demand:**
    *   **What it is:** Pay-as-you-go pricing.
    *   **Drawback:** It is significantly more expensive.
    *   **How it works:** This kicks in automatically for any usage *above* your committed amount.
*   **The "Overage" Trap:**
    *   If you commit to **100 Hosts**, but you spin up **120 Hosts**, you pay the cheaper rate for the first 100, and the expensive On-Demand rate for the extra 20.
    *   *Governance Tip:* It is crucial to monitor your usage against your commitment so you aren't paying on-demand rates for resources you plan to keep long-term.

### 2. High Water Marks (HWM)
This is the specific mechanism Datadog uses to count your Infrastructure (Hosts and Containers) to determine your bill for the month.

*   **The Problem:** In cloud environments, servers scale up and down constantly. You might have 50 servers at 9:00 AM, 200 servers at 12:00 PM (lunch rush), and 50 servers again at 3:00 PM. How does Datadog bill you?
*   **The Calculation (The "99th Percentile" Rule):**
    1.  **Hourly Measurement:** Every hour, Datadog looks at your infrastructure and records the **maximum** number of concurrent hosts running during that hour. This is the "High Water Mark" for that specific hour.
    2.  **Monthly Calculation:** At the end of the month, they have ~720 hourly measurements (24 hours x 30 days).
    3.  **The 99th Percentile:** They discard the top 1% of those hourly measurements (the highest spikes). The highest remaining number is what you are billed for.
*   **Why this matters:**
    *   This is "spike forgiveness." If you have a massive auto-scaling event that lasts only 3 hours (less than 1% of the month), you generally won't get billed for that maximum peak.
    *   However, if you run a test environment for 2 days with 1,000 extra servers, that is more than 1% of the month, and your bill will skyrocket to reflect those 1,000 servers for the whole month.
*   **Container Density:** Note that billing often includes a limit on containers per host (e.g., standard Pro plan includes 10 containers per host). If you run 50 containers on one host, you might be billed for "excess containers" even if your host count is low.

### 3. Estimating Log Indexing Costs
Logging is usually the source of the most unexpected costs in Datadog ("Bill Shock"). To control this, you must understand the difference between **Ingestion** and **Indexing**.

*   **Part A: Ingestion (The Traffic):**
    *   This is the cost of simply sending the log data over the network to Datadog.
    *   Cost is usually calculated per Gigabyte (GB).
    *   *Action:* It is relatively cheap. You usually ingest *everything* so that your "Live Tail" works and you can archive everything to S3/Azure Blob for compliance.
*   **Part B: Indexing (The Retention):**
    *   This is the cost of **keeping** the logs searchable in the Datadog Explorer for a set period (3 days, 7 days, 15 days, 30 days).
    *   **Cost Driver:** This is very expensive. Cost is calculated per **Million Events**.
    *   *The Strategy:* You should strictly filter which logs get indexed.
        *   *Debug logs:* Ingest them (so you can see them live), but **exclude** them from indexing. Do not pay to store "Debug" logs for 7 days.
        *   *Error logs:* Index all of them.
*   **Estimating the Cost:**
    *   To estimate costs, you cannot just look at disk size. You need to estimate the **volume of events**.
    *   *Example:* A Java stack trace is one "Event" but might be 2KB of text. An Nginx access log is one "Event" but only 200 bytes.
    *   Datadog billing provides an "Estimated Usage" dashboard. You must use Exclusion Filters to drop high-volume, low-value logs (like Load Balancer health checks) from Indexing to keep costs down.

### Summary: The Golden Rule of Datadog Billing
**Decouple Ingest from Index.**
Send everything to Datadog so you have a complete Archive (in S3) and Live Tail view (Ingest is cheap). But use **Exclusion Filters** to ensure you are only Indexing (paying the premium price) for logs that provide high value for searching later.
