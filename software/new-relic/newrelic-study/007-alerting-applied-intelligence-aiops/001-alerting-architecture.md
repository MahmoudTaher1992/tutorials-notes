This section of the study path covers the fundamental mechanism New Relic uses to detect problems and notify your team. It shifts the platform from a tool you *look at* (passive monitoring) to a tool that *tells you when something is wrong* (active alerting).

Here is a detailed breakdown of **Part VII: Alerting & Applied Intelligence (AIOps) / A. Alerting Architecture**.

---

### 1. The Core Hierarchy: Policies and Conditions

To understand New Relic alerting, you must understand the hierarchy of how alerts are organized. It is not just "one giant list of rules."

*   **Alert Policy:**
    *   Think of a Policy as a **folder** or a container. It groups related alert rules together.
    *   You usually organize Policies by team (e.g., "Checkout Team Policy"), by environment (e.g., "Production Critical"), or by stack (e.g., "Database Layer").
    *   **Why it matters:** It allows you to manage permissions and notification preferences for a whole group of alerts at once.

*   **Alert Condition:**
    *   This is the actual **rule**. It lives inside a Policy.
    *   It defines the specific metric to watch, the threshold to breach, and the time duration.
    *   *Example:* "If CPU usage is > 90% for at least 5 minutes."

### 2. NRQL Alert Conditions (Static vs. Baseline)

While New Relic offers "click-to-configure" alerts for standard metrics (like CPU or Error Rate), the most powerful way to alert is using **NRQL (New Relic Query Language)**. This allows you to alert on *anything* that exists in the database.

There are two distinct types of thresholds you can set here:

#### A. Static Thresholds
This is a fixed number. If the data crosses this line, trigger an alert.
*   **Use Case:** Hard limits where you know exactly what constitutes failure.
*   **Example:** "Alert if `diskPercent` is greater than 90."
*   **Pros:** Predictable, easy to understand.
*   **Cons:** Does not account for natural fluctuations (e.g., traffic is naturally lower at 3 AM).

#### B. Baseline Thresholds (Dynamic)
This uses New Relic’s algorithms to analyze historical data. It looks at what "normal" behavior is for *this specific time of day* and creates a dynamic band around the metric.
*   **Use Case:** Anomalies in user behavior or application throughput.
*   **Example:** "Alert if `WebTransaction` duration deviates 3 standard deviations from the baseline."
*   **Scenario:** If your site usually takes 200ms to load, a jump to 500ms is bad. But if you run a heavy batch job every night at 2 AM that takes 500ms, a Static alert would wake you up every night. A Baseline alert understands that 500ms is "normal" for 2 AM and stays silent, but would alert if it happened at 2 PM.

### 3. Signal Loss and Gap Filling

This is a technical nuance that often trips up beginners. It deals with how New Relic handles "Missing Data."

*   **Signal Loss:**
    *   What happens if your application crashes completely and stops sending data?
    *   If you have an alert set for "Error rate > 5%", and the app dies, the error rate technically isn't > 5%; it is **null** (non-existent). A standard alert might resolve itself because no data is coming in.
    *   **Feature:** You can configure a condition to say, "If the signal is lost (no data received) for T minutes, open a violation." This effectively acts as a "Server Down" detector.

*   **Gap Filling:**
    *   Sometimes data arrives sporadically (e.g., a background job that runs every minute). If you evaluate the alert every 30 seconds, you might see `Data -> Null -> Data -> Null`.
    *   **Feature:** You can tell New Relic to "fill the gaps" with the *Last Known Value* (carry the number forward) or with a *Static Value* (assume 0 if no data comes in). This prevents "flapping" alerts where the alarm turns on and off rapidly.

### 4. The Flow: Violations vs. Incidents vs. Issues

It is important to understand the vocabulary of the alerting lifecycle:

1.  **Violation:** The exact moment a condition (rule) is breached.
2.  **Incident:** The record of that violation opening. The incident stays open until the signal returns to normal.
3.  **Issue:** (Part of the newer "Applied Intelligence" / Workflows). New Relic tries to group related incidents together. If the database CPU goes high, and the API latency goes high, and the disk fills up all at the same time, New Relic groups these into a single **Issue** so you don't get 50 different emails.

### 5. Workflows and Destinations

In the modern New Relic architecture, we separate the "Logic" (Policies) from the "Notification" (Destinations). This is managed via **Workflows**.

*   **Destinations:**
    *   These are the "dumb" endpoints. You configure credentials here.
    *   *Examples:* A Slack Webhook URL, PagerDuty API Key, Email address, ServiceNow instance, or a generic Webhook.

*   **Workflows:**
    *   This is the logic engine that decides *where* to send an Issue.
    *   You use a query builder to filter issues.
    *   *Example Logic:*
        *   "IF the Issue priority is `Critical` AND the entity name contains `Production` -> Send to **PagerDuty**."
        *   "IF the Issue priority is `Warning` -> Send to **Slack Channel #dev-ops**."
    *   This allows you to route alerts intelligently without hard-coding email addresses into every single alert policy.

### Summary of the Architecture Flow

1.  **Telemetry Data** arrives (Ingestion).
2.  **NRQL Condition** queries the data every minute.
3.  If data breaches the **Threshold** (Static or Baseline), a **Violation** occurs.
4.  If **Signal Loss** is configured, it checks for silence.
5.  Violations are aggregated into an **Issue**.
6.  **Workflows** analyze the Issue tags/attributes.
7.  The notification is dispatched to the **Destination** (Slack/PagerDuty).
