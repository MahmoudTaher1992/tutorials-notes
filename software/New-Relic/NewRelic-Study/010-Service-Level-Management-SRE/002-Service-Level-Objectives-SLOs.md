Based on the study path provided, **Part X: Service Level Management (SRE)** focuses on shifting from basic monitoring (is the server up?) to Reliability Engineering (are users happy?).

Here is a detailed explanation of section **002-Service-Level-Objectives-SLOs**, broken down into concepts, New Relic implementation, and the logic behind them.

---

# 002 - Service Level Objectives (SLOs)

In the world of Site Reliability Engineering (SRE), **SLOs** are the most critical tool for aligning development teams (who want to ship features fast) and operations teams (who want stability).

## 1. The Core Concept: The SRE Trinity
To understand SLOs, you must first understand the three acronyms that always go together:

1.  **SLI (Service Level Indicator):** The **measurement**.
    *   *Example:* The response time of the Checkout API.
2.  **SLO (Service Level Objective):** The **goal**.
    *   *Example:* 99.0% of Checkout API requests must complete in under 500ms over a 7-day period.
3.  **SLA (Service Level Agreement):** The **consequence/contract** (usually business/legal).
    *   *Example:* If we don't hit 99.0%, we owe the customer a 10% refund. *Note: New Relic helps you track SLOs so you don't breach your SLAs.*

## 2. Creating Service Levels in New Relic
In the New Relic UI (under the "Service Levels" menu), setting up an SLO involves defining what "Success" looks like using NRQL logic.

There are generally two ways to calculate compliance:

### A. Request-Based SLOs (The most common)
This measures "Good" events against "Total" events.
$$Compliance \% = \left( \frac{\text{Good Events}}{\text{Total Valid Events}} \right) \times 100$$

*   **Total Events:** Every request hitting your service.
*   **Good Events:** Requests that were successful (HTTP 200) AND fast enough (e.g., < 0.5s).
*   **Bad Events:** Errors (HTTP 500) or slow requests.

**NRQL Conceptual Example:**
```sql
-- The "Good" logic
SELECT count(*) FROM Transaction WHERE httpResponseCode = '200' AND duration < 0.5

-- The "Total" logic
SELECT count(*) FROM Transaction
```

### B. Time-Based SLOs (Availability)
This measures "Good Minutes" against "Total Minutes."
*   "Was the system usable during this minute?"
*   If yes, it is a good minute.

## 3. Error Budgets
This is the most powerful concept in this section. The **Error Budget** is the inverse of your SLO.

If your SLO is **99.9%**, your Error Budget is **0.1%**.

*   **Why does this matter?** It changes the conversation from "We must have zero errors" (impossible) to "We have a budget for errors, let's spend it wisely."
*   **Scenario:**
    *   If your service is running at 99.99% reliability, you have **lots of Error Budget remaining**. The team can deploy risky new features, perform chaos engineering, or experiment.
    *   If you have had an outage and your reliability drops to 99.8% (below target), you have **exhausted your Error Budget**. The team should stop shipping features and focus purely on stability fixes until the budget recovers.

In New Relic, the Service Levels view visualizes this budget as a bar. If the bar is green, ship features. If it's red, freeze deployments.

## 4. Burn Rates
Looking at the remaining Error Budget is good, but looking at the **speed** at which you are losing it is better. This is called the **Burn Rate**.

*   **Burn Rate of 1:** You are consuming your error budget exactly as predicted. You will hit exactly 0% budget at the end of the time window (e.g., 30 days).
*   **Burn Rate of 10:** You are consuming your budget 10x faster than allowed. You will run out of budget in 3 days instead of 30.
*   **Burn Rate of 50+:** Major incident. You are burning budget immediately.

## 5. Alerting on Burn Rates
This section of the study path explains why you should **stop alerting on simple failures** and start alerting on **Burn Rates**.

### The Old Way (Static Thresholds)
*   *Alert:* "Trigger if Error Rate > 1% for 5 minutes."
*   *Problem:* This is noisy. A small spike at 3:00 AM might trigger a page, but if it self-corrects in 2 minutes, it didn't actually impact user happiness enough to wake up an engineer.

### The SRE Way (Burn Rate Alerts)
*   *Alert:* "Trigger if we are burning our error budget at a rate that will drain it completely within 4 hours."
*   *Benefit:*
    *   **Slow Burn:** If you have a tiny, consistent error (0.01% errors), New Relic won't wake you up at night. It will send a ticket to Jira to fix it during business hours because you won't run out of budget for weeks.
    *   **Fast Burn:** If the database goes down (100% errors), the Burn Rate spikes massively. New Relic notifies you immediately because at this rate, the budget will be gone in minutes.

## Summary of Learning Goals for this Section
By the end of this module in the study path, you should be able to:
1.  Navigate to the **Service Levels** view in New Relic.
2.  Define an SLO using the guided setup or custom NRQL (e.g., "99% of `Transaction` events for `App-A` must be error-free").
3.  Read the **Error Budget** visualization to determine if a system is healthy enough for new deployments.
4.  Configure an alert policy based on **Fast Burn** (critical) and **Slow Burn** (warning) to reduce alert fatigue.
