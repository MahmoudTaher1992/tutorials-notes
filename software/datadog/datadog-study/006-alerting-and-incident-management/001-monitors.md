Based on the Table of Contents you provided, here is a detailed breakdown of **Part VI, Section A: Monitors**.

This section is critical because it represents the "Brain" of your observability stack. While metrics and logs provide data, **Monitors** provide the actionable intelligence that wakes you up when something breaks.

---

# Detailed Explanation: VI. Alerting & Incident Management > A. Monitors

## 1. Monitor Types
Datadog offers various monitor types depending on the data source and the behavior you want to track.

*   **Metric Monitor:** The most common type. It tracks a standard numerical value over time.
    *   *Example:* "Alert me if `system.cpu.idle` is less than 10% for 5 minutes."
    *   *Use case:* Infrastructure resource usage, custom business metrics (e.g., items sold).
*   **Log Monitor:** Alert based on the count of logs matching a specific search query.
    *   *Example:* "Alert me if the number of logs matching `status:error` AND `service:payment-api` exceeds 50 in the last 15 minutes."
    *   *Use case:* Detecting spikes in application exceptions or security access violations.
*   **APM (Trace) Monitor:** Alerts based on Application Performance Monitoring data (latency or error rates).
    *   *Example:* "Alert if the p95 latency of the `/checkout` endpoint is > 2 seconds."
    *   *Use case:* Ensuring User Experience (SLAs) and performance baselines.
*   **Integration Monitor:** Checks metrics specific to cloud integrations (AWS, Azure) or third-party tools. Often pre-configured.
    *   *Example:* "Alert if AWS ELB 5xx error count is high."
*   **Process Monitor:** Checks if a specific executable or process is running on a host.
    *   *Example:* "Alert if the `java` process is not running on any host tagged `role:web-server`."
    *   *Use case:* Ensuring critical daemons are alive.
*   **Custom Check Monitor:** Alerts on the status of a custom Agent check. These are binary checks (OK, WARNING, CRITICAL) rather than continuous metric streams.
    *   *Example:* A script that attempts to connect to a local database port and returns "CRITICAL" if the connection fails.

## 2. Evaluation Logic
This dictates *how* the data is calculated before it is compared to a threshold.

### Simple Alert vs. Multi Alert
This is the most important distinction in Datadog alerting:
*   **Simple Alert (Aggregate):** Aggregates data from *all* reporting sources into one line.
    *   *Scenario:* You have 50 web servers. A Simple Alert averages the CPU across all 50. If one server is at 100% CPU but the rest are at 10%, the average is low, and you won't get an alert.
*   **Multi Alert (Partitioned):** Applies the alert logic to *each* group defined by a tag (e.g., `host`, `availability-zone`, `service`).
    *   *Scenario:* You define the alert over `avg by {host}`. Now, Datadog runs 50 separate checks. If *any single* host hits 100% CPU, you get an alert specifically for that host.

### Query Logic
The query defines the mathematical window.
*   *Syntax:* `avg(last_5m):avg:system.cpu.idle{host:web} < 10`
*   **Time Aggregation (`avg(last_5m)`):** Looks at the rolling window of the last 5 minutes.
*   **Space Aggregation (`avg:`):** Determines how to combine multiple series if they aren't separated by tags.

## 3. Thresholds, Recovery Thresholds, and Delays
Setting the numbers correctly is the difference between a useful monitoring system and "alert fatigue."

### Thresholds
*   **Alert Threshold:** The point where the status changes to **CRITICAL**. (e.g., CPU > 90%).
*   **Warning Threshold:** An early indicator status (e.g., CPU > 80%). This usually triggers a Slack message but not a PagerDuty phone call.

### Recovery Thresholds (Hysteresis)
This prevents **"Flapping"**. Flapping occurs when a metric hovers right around the limit (e.g., 90.1%, then 89.9%, then 90.2%), causing the alert to resolve and re-trigger constantly.
*   *How it works:* You set the Alert at **90%**, but the **Recovery Threshold** at **80%**.
*   *Result:* The alert triggers when CPU hits 90%. It stays red even if CPU drops to 85%. It only turns green (OK) when CPU drops below 80%.

### Evaluation Delay
Metrics take time to travel from your server to Datadog's cloud. If you evaluate the "current second," data might be incomplete.
*   *Feature:* You can add a delay (e.g., 900 seconds or 15 minutes).
*   *Why:* To ensure all data points have arrived before deciding if there is an alert. This reduces false positives caused by network lag.

## 4. No Data / Missing Data Logic
What should the monitor do if the signal stops entirely?

*   *Scenario:* You are monitoring a server's heartbeat. Suddenly, the server crashes completely. It stops sending metrics.
*   *The Problem:* If the server sends *nothing*, the metric isn't "high" or "low"—it doesn't exist.
*   *Configuration Options:*
    1.  **Do not notify:** The monitor remains in its last known state. (Good for sparse metrics that only appear occasionally).
    2.  **Alert (Notify):** Interpret missing data as a CRITICAL issue. (Essential for "heartbeat" checks—if the server is silent, assume it is dead).
    3.  **Evaluate as Zero:** Treat missing data as the number 0. (Good for error logs—if no error logs are sent, it means 0 errors occurred).
