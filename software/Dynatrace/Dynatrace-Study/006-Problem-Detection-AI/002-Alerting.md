Here is a detailed explanation of **Part VI, Section B: Alerting** from your Dynatrace study roadmap.

In the Dynatrace ecosystem, **Alerting** is the bridge between detecting an issue (whether via AI or custom rules) and notifying the human teams or automated systems responsible for fixing it.

Here is a deep dive into the concepts within this section.

---

# 006-Problem-Detection-AI / 002-Alerting.md

### **1. The Philosophy: Smart Alerting vs. Noise**
Traditional monitoring tools rely heavily on static thresholds (e.g., "Alert me if CPU > 80%"). This often leads to **Alert Storms**—hundreds of emails during a spike that might actually be normal behavior.

Dynatrace takes a different approach:
1.  **Davis AI** detects a *Problem* first (analyzing dependencies and root causes).
2.  **Alerting** determines if that Problem is significant enough to notify someone and *who* that person should be.

---

### **2. Custom Alerting Rules**
While Dynatrace automatically detects most infrastructure and application anomalies, you often need to define specific rules for your unique business logic.

*   **What they are:** Manually configured conditions that trigger a Problem.
*   **Types of Custom Events:**
    *   **Metric Events:** Trigger when a specific metric (built-in or custom) violates a limit (e.g., "Number of items in shopping cart dropped to zero").
    *   **Log Events:** Trigger when a specific pattern appears in a log file (e.g., "CRITICAL_PAYMENT_FAILURE").
*   **Configuration:** You can define the scope (e.g., "Only apply this rule to Hosts with the tag `Role:Database`").

### **3. Thresholds vs. Baselines**
This is the most critical distinction in Dynatrace configuration.

#### **A. Static Thresholds**
*   **Definition:** A fixed number. If the metric crosses this line, it's an issue.
*   **When to use:** Hard limits where physics or SLAs apply.
    *   *Example:* "Disk Space Used > 95%" (Because if the disk is full, the server crashes, regardless of time of day).
    *   *Example:* "Response time > 5 seconds" (If your SLA guarantees 4 seconds).

#### **B. Auto-Adaptive Baselines**
*   **Definition:** Dynatrace learns the "normal" behavior of an application or host over time (usually a sliding window, e.g., the last 7 days). It understands **seasonality**.
*   **How it works:**
    *   High traffic on Monday morning is "normal." High traffic on Sunday at 3 AM is "abnormal."
    *   Dynatrace sets a dynamic confidence band. An alert is only triggered if the metric deviates significantly from the *predicted* baseline.
*   **Benefit:** drastically reduces false positives. You don't get woken up for a CPU spike that happens every night during backup.

---

### **4. Alerting Profiles**
Alerting Profiles act as a **filter**. Even if Davis detects a problem, you might not want to send a notification for *everything*.

*   **Severity Levels:** You can configure profiles to only alert on:
    *   **Availability Events:** (Server down, Process crashed) -> **P1 Critical**.
    *   **Error Events:** (High HTTP 500 rate) -> **P2 High**.
    *   **Performance Events:** (Slow response time) -> **P3 Warning**.
*   **Time Delays:** "Only alert me if this problem persists for more than 15 minutes" (prevents flapping alerts).
*   **Tags:** Create profiles for specific teams.
    *   *Profile A:* Matches tags `Team:Frontend`.
    *   *Profile B:* Matches tags `Team:Backend`.

---

### **5. Integration with Incident Management Tools**
Dynatrace doesn't just send emails; it integrates into your operations workflow (ChatOps/NoOps).

*   **Problem Notification Setup:**
    *   **Email:** The basic notification.
    *   **Slack/Teams:** Sends a message to a channel with a link to the root cause.
    *   **ITSM Tools (ServiceNow/Jira):** Automatically creates a Ticket when a problem is detected.
    *   **On-Call (PagerDuty/Opsgenie):** Triggers phone calls or SMS to the engineer on call.
*   **Webhooks (Advanced):**
    *   Dynatrace sends a JSON payload to a custom URL.
    *   *Use Case:* Trigger an Ansible Tower job or a Jenkins pipeline to restart a service automatically (Self-Healing).

---

### **Summary of the Workflow**

1.  **Ingestion:** Data comes in (Metrics, Logs, Traces).
2.  **Analysis:**
    *   **Baseline:** Is this normal?
    *   **Threshold:** Did it cross a hard limit?
3.  **Problem Creation:** If yes, Davis opens a "Problem" ticket internally and correlates data.
4.  **Alerting Profile:** Does this Problem match my filter? (Is it severe enough? Is it for my team?)
5.  **Notification:** If yes, send to Slack/PagerDuty/ServiceNow.

### **Study Exercise for this Section:**
1.  Go into your Dynatrace environment.
2.  Navigate to **Settings -> Anomaly Detection**.
3.  Look at the default rules for Infrastructure (e.g., High CPU). notice how it uses "Auto-adaptive."
4.  Create a **Custom Alert**:
    *   Select a metric (e.g., Disk Space).
    *   Set a static threshold (e.g., alert at 50% for testing).
5.  Setup an **Alerting Profile** that filters only for "Availability" issues.
