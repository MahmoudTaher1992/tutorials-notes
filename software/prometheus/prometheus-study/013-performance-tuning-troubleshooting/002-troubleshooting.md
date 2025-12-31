This section of the syllabus, **Part XIII: Performance Tuning & Troubleshooting**, addresses the critical "Day 2" operations of running Prometheus. It focuses on the question: **"Who monitors the monitor?"** and what to do when Prometheus itself becomes slow, runs out of memory, or fails to collect data.

Here is a detailed breakdown of the concepts within this section.

---

### A. Self-Monitoring
Prometheus is an application just like any other. It exposes its own internal metrics at the `/metrics` endpoint. Watching these metrics is called "Meta-Monitoring."

#### 1. Key Prometheus Metrics to Watch
To keep Prometheus healthy, you must set up alerts on Prometheus itself. Here are the most critical internal metrics:

*   **`prometheus_tsdb_head_series`**:
    *   **What it is:** The number of time series currently held in memory (RAM).
    *   **Why it matters:** This is the primary driver of memory usage. If this number spikes, Prometheus will run out of RAM (OOM) and crash.
*   **`scrape_duration_seconds`**:
    *   **What it is:** How long it takes Prometheus to pull data from a specific target.
    *   **Why it matters:** If this approaches your `scrape_interval`, you will start missing data. It usually indicates the application being monitored is overloaded or exposing too many metrics.
*   **`prometheus_tsdb_wal_corruptions_total`**:
    *   **What it is:** Counts errors in the Write-Ahead Log (disk storage).
    *   **Why it matters:** A non-zero value means disk corruption; you are losing data or risking a crash on restart.
*   **`prometheus_target_scrapes_sample_out_of_order_total`**:
    *   **What it is:** Counts how often a target sends a timestamp that is older than what Prometheus already has.
    *   **Why it matters:** Prometheus TSDB is append-only. It rejects old data. This usually indicates a misconfigured client or clock skew issues.

#### 2. Detecting "Slow Rules" and Query Load
Prometheus runs **Recording Rules** and **Alerting Rules** periodically. If you write inefficient PromQL queries, they can choke the CPU.

*   **The Problem:** A query like `sum(rate({__name__=~".+"}[1h]))` (calculating rates for *every* metric in the database) creates massive CPU load.
*   **How to Debug:**
    *   **Web UI:** Go to `Status -> Rules`. It shows the evaluation time for every group.
    *   **Metric:** `prometheus_rule_group_last_duration_seconds`. If a rule group takes longer to evaluate than its execution interval (e.g., takes 70s to run but is scheduled every 60s), rules will start skipping.
    *   **Solution:** Optimize the PromQL or break the rule group into smaller groups.

---

### B. Troubleshooting
This subsection deals with the most common operational incidents SREs face when managing Prometheus.

#### 1. Debugging Scrape Failures
When a target is down in Prometheus (Status: `DOWN`), it is usually due to one of these reasons:

*   **Context Deadlines (Timeouts):**
    *   **Symptom:** The error message says `context deadline exceeded`.
    *   **Cause:** The application is taking too long to generate the text response for `/metrics`.
    *   **Fix:** Increase the `scrape_timeout` in Prometheus config, or (better) optimize the application code to generate metrics faster.
*   **Body Size Limits:**
    *   **Symptom:** The target returns a massive amount of text (e.g., 50MB of metrics).
    *   **Cause:** The application is exposing too much detail (e.g., a metric per user session).
    *   **Fix:** Use **Metric Relabeling** to drop specific heavy metrics *before* ingestion, or fix the application instrumentation.

#### 2. Handling "Missing Data" Gaps
Users often complain that "lines on the graph are broken" or disappear.

*   **Staleness:** Prometheus has a 5-minute "lookback delta." If a scrape fails, Prometheus will "look back" 5 minutes for the last valid point. If the gap is longer than 5 minutes, the graph line stops.
*   **Clock Skew:** If the time on the node running the exporter is significantly different from the Prometheus server time, the data might be rejected or appear in the past/future, causing visualization gaps.

#### 3. Analyzing High Memory Usage (Cardinality Analysis)
This is the **#1 killer** of Prometheus instances.

*   **The Concept:** **Cardinality** refers to the number of unique combinations of labels.
    *   *Low Cardinality (Good):* `http_requests_total{method="POST"}` (Only ~4 methods).
    *   *High Cardinality (Bad):* `http_requests_total{user_id="1029384"}` (Millions of users).
*   **The Cardinality Explosion:** If a developer adds a label with high cardinality (like `IP_address`, `user_id`, or `request_id`), the `prometheus_tsdb_head_series` count explodes, and RAM usage spikes until the container crashes (OOM Killed).
*   **How to Troubleshoot:**
    1.  **TSDB Status Page:** In the Prometheus UI, go to `Status -> TSDB`. It lists the "Top 10 label names with high memory usage."
    2.  **PromQL Investigation:** Run queries to find the offender:
        ```promql
        # Find the metric names with the most series
        topk(10, count by (__name__) ({__name__=~".+"}))
        ```
    3.  **Fix:** Identify the metric and use **Relabeling** (`action: drop`) to stop ingesting that specific label or metric.

### Summary of this Section
This section teaches you that Prometheus is not "set it and forget it." You must actively manage the **"Cardinality Budget"** (memory) and ensure that your scrape targets are responsive. Without these skills, a Prometheus setup will eventually crash as the infrastructure scales.
