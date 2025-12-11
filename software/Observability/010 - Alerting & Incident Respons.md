Here is a detailed explanation of **Part IV, Section B: Alerting & Incident Response**.

---

# B. Alerting & Incident Response

Collecting data (metrics, logs, traces) is passive. **Alerting** is the active component of observability—it is the mechanism that taps a human on the shoulder when the system needs help.

However, poorly designed alerting is the fastest way to burn out an engineering team. This section focuses on moving from "monitoring everything" to "alerting on what matters."

## 1. Actionable Alerting: Avoiding Alert Fatigue

**Alert Fatigue** occurs when engineers are bombarded with so many frequent, trivial, or false-positive alerts that they become desensitized. Eventually, they ignore a critical alert because they assume it's "just noise," leading to a major outage.

### The Golden Rule of Alerting
**"Page (wake up) a human only if action is immediately required."**

If an engineer receives an alert at 3:00 AM, wakes up, looks at the graph, says "Oh, that fixes itself," and goes back to sleep—**that alert should be deleted.** It should have been a log entry or a ticket, not a page.

### Symptom-Based vs. Cause-Based Alerting
*   **Cause-Based (The Old Way):** Alerting on the *cause* of a potential problem.
    *   *Example:* "CPU is at 90%."
    *   *Why it fails:* A database might run perfectly fine at 90% CPU. This alert causes panic when no users are actually impacted.
*   **Symptom-Based (The Modern Way):** Alerting on the *symptom* the user experiences.
    *   *Example:* "Homepage Latency is > 2 seconds" or "500 Error Rate is > 1%."
    *   *Why it works:* It doesn't matter *why* it's happening (CPU, network, bad code)—if users are suffering, you need to fix it. You use observability tools to find the cause *after* you are alerted to the symptom.

---

## 2. SLO-based Alerting (The Gold Standard)

Service Level Objective (SLO) alerting is widely considered the most mature form of alerting, popularized by Google's Site Reliability Engineering (SRE) handbook. It relies on math rather than arbitrary guesses.

### The Terminology
1.  **SLI (Indicator):** The metric (e.g., Latency).
2.  **SLO (Objective):** The goal (e.g., "99.9% of requests must be faster than 200ms").
3.  **Error Budget:** The 0.1% of requests that are *allowed* to fail.

### How it Works: "Burn Rate" Alerts
Instead of setting a static threshold (e.g., "Alert if latency > 200ms"), you alert on how fast you are **burning your Error Budget**.

*   **Scenario A:** You have a small spike of errors. You are burning your budget slowly. If this continues, you will run out of budget in 3 weeks.
    *   *Action:* **Do NOT page.** Send an email or Jira ticket. Deal with it during business hours.
*   **Scenario B:** You have a massive outage. You are burning budget 100x faster than normal. If this continues, you will run out of budget in 1 hour.
    *   *Action:* **PAGE IMMEDIATELY.**

**The Benefit:** This technique catches slow leaks (degraded performance) and catastrophic failures (outages) with a single alert configuration, while drastically reducing noise.

---

## 3. On-Call Management & Incident Response

Once an alert fires, the "Incident Response" phase begins. This is the workflow of *people* rather than software.

### A. The Incident Lifecycle
1.  **Triage:** The on-call engineer acknowledges the alert. Is it a false alarm? Is it a Sev-1 (Critical) or Sev-3 (Minor)?
2.  **Mitigation:** The goal is **not** to fix the root cause immediately; the goal is to **stop the pain**.
    *   *Example:* If a new code deploy caused the crash, **Rollback** immediately. Do not try to debug the code while the site is down.
3.  **Investigation:** Once the site is stable (mitigated), use Traces and Logs to find the root cause.
4.  **Remediation:** Fix the bug and deploy the patch.

### B. Runbooks (Playbooks)
Every alert must link to a **Runbook**.
*   **What is it?** A document explaining exactly what the alert means and steps to mitigate it.
*   **Why?** At 3:00 AM, an engineer's IQ drops significantly. They should not have to "figure out" what the `High_Kafka_Lag` alert means. The alert should link to a doc saying: *"This means the consumer is stuck. Step 1: Restart the consumer pod. Step 2: Check logs."*

### C. Tools of the Trade
*   **PagerDuty / OpsGenie:** These tools manage schedules. They ensure that if Engineer A doesn't answer the phone in 5 minutes, it escalates to Engineer B, and then to the Manager.
*   **ChatOps (Slack/Teams):** Modern incident response happens in a dedicated chat channel (e.g., `#incident-2023-10-27-checkout`). Bots automatically post updates there so stakeholders can watch without interrupting the engineers.

### D. The Blameless Post-Mortem
After the incident is over, the team writes a document analyzing the event.
*   **Rule:** You cannot blame a person (e.g., "Bob wrote bad SQL").
*   **Focus:** You blame the process (e.g., "Why did the CI/CD pipeline allow that bad SQL to pass testing?").
*   **Outcome:** Action items to improve observability or automated testing so this specific incident never happens again.