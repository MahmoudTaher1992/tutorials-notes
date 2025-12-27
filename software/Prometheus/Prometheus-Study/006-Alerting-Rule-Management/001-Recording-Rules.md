Based on the Table of Contents you provided, here is a detailed explanation of **Part VI: Alerting & Rule Management — A. Recording Rules**.

---

# 006-Alerting-Rule-Management / 001-Recording-Rules

## What are Recording Rules?

In Prometheus, a **Recording Rule** allows you to pre-calculate frequently needed or computationally expensive PromQL expressions and save their result as a **new set of time series**.

Think of it like a "Saved View" in SQL or a "Cached Calculation" in a spreadsheet. Instead of calculating a complex formula every time you look at it, Prometheus calculates it in the background and simply stores the answer.

---

### 1. Pre-computing Expensive Queries

Prometheus collects data (metrics) efficiently, but querying that data can become slow if you have high cardinality (lots of labels) or are aggregating over long timeframes.

#### The Problem
Imagine you want to see the global request rate of your API. You have 100 microservices, each running on 50 pods.
The query might look like this:
```promql
sum(rate(http_requests_total[5m]))
```
If you run this query on a dashboard that refreshes every 10 seconds:
1.  Prometheus has to find thousands of time series.
2.  It calculates the `rate` for the last 5 minutes for *each* of them.
3.  It `sum`s them all together.
4.  **Result:** High CPU usage on the Prometheus server and slow loading dashboards.

#### The Solution (Recording Rule)
Instead of calculating that every time a user opens Grafana, you tell Prometheus to calculate it periodically (e.g., every minute) and store the result as a new metric name, like `job:http_requests_total:rate5m`.

Now, your dashboard simply queries:
```promql
job:http_requests_total:rate5m
```
This query is instant because the math was already done.

---

### 2. Configuration & Syntax

Recording rules are defined in YAML files loaded by the Prometheus server.

**Example `rules.yaml`:**
```yaml
groups:
  - name: example_rules
    interval: 1m  # How often to calculate this rule
    rules:
      - record: job:http_requests_total:rate5m  # The new metric name
        expr: sum without(instance)(rate(http_requests_total[5m]))
        labels:
          environment: production # You can add static labels to the new metric
```

*   **record**: The name of the new metric being created.
*   **expr**: The PromQL query to run.
*   **labels**: (Optional) Extra labels to attach to the result.

---

### 3. Naming Conventions (`level:metric:operation`)

Since Recording Rules create *new* metrics, it is easy to clutter your database with confusing names. The Prometheus community strongly recommends a specific naming convention to keep things organized:

**Format:** `level:metric:operation`

*   **Level**: The aggregation level of the labels output by the rule.
    *   *Examples:* `job` (aggregated by job), `service` (aggregated by service), `cluster`, or `instance`.
*   **Metric**: The metric name under evaluation.
    *   *Example:* `http_requests_total`, `node_cpu_seconds`.
*   **Operation**: The function applied to the metric.
    *   *Examples:* `rate5m`, `sum`, `max`, `avg`.

#### Breakdown Examples:

| Raw Query | Bad Name | **Good Name** | Meaning |
| :--- | :--- | :--- | :--- |
| `sum(rate(http_requests_total[5m])) by (job)` | `total_requests_rate` | **`job:http_requests_total:rate5m`** | Sum of rates, aggregated by **Job**. |
| `sum(rate(node_cpu_seconds_total[1m]))` | `cluster_cpu` | **`cluster:node_cpu:rate1m`** | Sum of CPU rates, aggregated at the **Cluster** level. |
| `histogram_quantile(0.99, sum(rate(apiserver_request_duration_seconds_bucket[5m])) by (verb, le))` | `99th_percentile_latency` | **`verb:apiserver_request_duration_seconds:quantile99_5m`** | 99th quantile over 5m, aggregated by **Verb**. |

---

### 4. Performance Benefits of Recording Rules

Using recording rules provides three distinct performance advantages:

#### A. Faster Query Speed (Dashboards)
*   **Without Rules:** When a user changes the time range on Grafana from "Last 1 hour" to "Last 7 days," Prometheus must process millions of data points instantly. This often leads to timeouts.
*   **With Rules:** Prometheus simply reads the pre-calculated points. Querying 7 days of data becomes as fast as querying 1 hour.

#### B. Reduced Server Load (CPU/RAM)
*   **Without Rules:** Load is "bursty." The server is idle until someone opens a heavy dashboard, then CPU spikes to 100%.
*   **With Rules:** Load is "consistent." The server calculates the rule every minute in the background. It smooths out the CPU usage and prevents the server from crashing during heavy read traffic.

#### C. Federation Preparation
*   If you have a large setup with multiple Prometheus servers, you typically use **Federation** (one central Prometheus scraping other Prometheus servers).
*   You never want the central server to scrape *raw* data (too big).
*   You use Recording Rules on the smaller servers to aggregate data, and the central server scrapes only the *recording rules*.

### Summary Checklist
1.  **Identify** slow queries in your dashboards.
2.  **Create** a rule in a YAML file using the `record` field.
3.  **Name** it using `level:metric:operation`.
4.  **Reload** Prometheus config.
5.  **Update** your dashboards to use the new metric name.
