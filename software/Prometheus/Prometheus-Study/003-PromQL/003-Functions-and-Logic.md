This section is the mathematical "engine room" of Prometheus. While selecting metrics is simple, applying functions is where you transform raw data into actionable insights (like "requests per second," "error percentage," or "disk full in 4 hours").

Here is a detailed breakdown of **Part III, Section C: Functions and Logic**.

---

### 1. Rate Functions
These functions are designed specifically for **Counter** metrics (metrics that only go up, like `http_requests_total`). They are essential because a raw counter value (e.g., "1,000,000 total requests") is useless; you care about the *speed* at which it is increasing.

#### `rate()`
*   **What it does:** Calculates the per-second average rate of increase of the time series in the range vector.
*   **Key Behavior:** It automatically handles **counter resets**. If your server crashes and the counter goes from 1000 back to 0, `rate()` knows this happened and calculates the rate as if the counter continued increasing.
*   **Best for:** Alerting and slow-moving graphs. It "smooths" the data.
*   **Example:** `rate(http_requests_total[5m])` (Average requests per second over the last 5 minutes).

#### `irate()` (Instant Rate)
*   **What it does:** Calculates the per-second rate of increase based **only on the last two data points** in the range vector.
*   **Key Behavior:** It is extremely sensitive to spikes. It does not smooth the data over the whole time window.
*   **Best for:** High-resolution graphing (zooming in to see exactly when a spike happened).
*   **Warning:** **Do not use `irate` for alerting.** Because it looks at only two points, it is volatile. A momentary scrape delay could trigger a false alert.

#### `increase()`
*   **What it does:** Calculates the absolute increase in the counter value over the time range.
*   **The Math:** It is effectively `rate() * time_window`.
*   **The "Decimal" Confusion:** Users are often confused why `increase(errors_total[1m])` returns `4.5` instead of an integer.
    *   *Reason:* Prometheus **extrapolates**. If you ask for a 1-minute increase, but your scrapes happened at second 5 and second 55 (50s gap), Prometheus calculates the rate and extends it to cover the full 60s, resulting in decimal values.
*   **Example:** `increase(http_errors_total[1h])` (How many errors happened in the last hour?).

---

### 2. Histogram Functions
Histograms track the distribution of values (like latency) into "buckets."

#### `histogram_quantile()`
This is arguably the most complex but most powerful function in PromQL. It allows you to calculate the p95, p99, or median latency from a bucketed histogram.

*   **Syntax:** `histogram_quantile(φ, count_vector)`
*   **How it works:** It looks at the `le` (less than or equal to) labels in your buckets. If you want the 0.95 (95th percentile), it finds which bucket the 95th percentile falls into and performs **linear interpolation** within that bucket to guess the exact value.
*   **The Query Pattern:** You almost always wrap the metric in `rate()` first, then `sum()` by the `le` label to aggregate across instances.
    ```promql
    histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))
    ```
    *Translation: "Calculate the 95th percentile latency based on the rate of requests over the last 5 minutes."*

#### Apdex Score (Application Performance Index)
Prometheus doesn't have a function named `apdex()`, but you construct it using logic functions. Apdex is a ratio of "Satisfactory" requests to "Total" requests.

*   **Formula:** `(Satisfactory_reqs + (Tolerating_reqs / 2)) / Total_reqs`
*   **PromQL Implementation:** You use the specific bucket `le` labels to define what is "Satisfactory" (e.g., < 300ms).
    ```promql
    (
      sum(rate(http_req_duration_bucket{le="0.3"}[5m])) +
      sum(rate(http_req_duration_bucket{le="1.0"}[5m]))
    ) / 2
    /
    sum(rate(http_req_duration_count[5m]))
    ```

---

### 3. Prediction Functions
These functions act as a crystal ball, using simple linear regression (math to draw a straight line through existing points) to predict future values. They operate on **Gauges**.

#### `deriv()`
*   **What it does:** Calculates the per-second derivative (slope) of the time series.
*   **Use Case:** How fast is the temperature rising? Is the queue size growing or shrinking?
*   **Note:** Only works on Gauges. If you use it on a Counter, the resets will mess up the slope.

#### `predict_linear()`
*   **What it does:** Predicts the value of the time series `t` seconds in the future, based on the range vector provided.
*   **The Classic Use Case:** **Disk Space Alerting.**
    *   *Query:* `predict_linear(node_filesystem_free_bytes[4h], 4 * 3600) < 0`
    *   *Translation:* "Look at the trend of free disk space over the last 4 hours. If that trend continues, will the disk be full (less than 0 bytes) in the next 4 hours?"
*   **Pitfall:** It assumes the trend is linear. If you delete a massive file, the prediction might think you have infinite space. If you download a massive file quickly, it might panic unnecessarily.

---

### 4. Temporal Functions
These functions analyze how the data changes over time, returning simple counts.

#### `changes()`
*   **What it does:** Returns the number of times a value has changed within the provided time range.
*   **Use Case:** Detecting instability. "Has the Master DB leader changed more than once in the last hour?" or "Did the configuration hash change?"

#### `resets()`
*   **What it does:** Returns the number of times a counter reset (decreased).
*   **Use Case:** Debugging crash loops. Since counters only reset when a process restarts, `resets(process_start_time_seconds[1h]) > 5` tells you the service has crashed/restarted 5 times in the last hour.

---

### 5. Subqueries
Subqueries were added later in Prometheus (v2.7) to solve a specific problem: **Range Vectors of Range Vectors.**

#### The Problem
Standard functions like `rate()` take a range (e.g., `[5m]`) and return an **Instant Vector** (a single value for right now).
But what if you want to know: *"What was the maximum 5-minute rate that occurred anytime during the last day?"*

You cannot do `max_over_time(rate(metric[5m])[1d])`. Before subqueries, this syntax was invalid.

#### The Solution: Subquery Syntax
Syntax: `query_expr[range:resolution]`

*   **Range:** How far back to look (e.g., 1 day).
*   **Resolution:** How often to run the inner query (e.g., every 1 minute).

#### Example Use Case
"Find the peak 5-minute error rate over the last 24 hours."

```promql
max_over_time( 
    rate(http_errors_total[5m])[24h:1m] 
)
```

1.  **Inner part:** `rate(...[5m])` calculates the per-second rate.
2.  **Subquery `[24h:1m]`:** Prometheus goes back 24 hours, and effectively runs that `rate` calculation every 1 minute, creating a synthetic range of values.
3.  **Outer part:** `max_over_time` looks at that list of generated rates and picks the highest one.

### Summary Table

| Function Category | Key Functions | Operates On | Primary Use Case |
| :--- | :--- | :--- | :--- |
| **Rate** | `rate`, `irate`, `increase` | **Counters** | Converting "Total Requests" to "Requests Per Second". |
| **Histogram** | `histogram_quantile` | **Histograms** | Calculating Latency (p99, p95). |
| **Prediction** | `predict_linear`, `deriv` | **Gauges** | Alerting on "Disk will fill up soon". |
| **Temporal** | `changes`, `resets` | **Any** | Detecting instability or restarts. |
| **Subqueries** | `[range:resolution]` | **Queries** | Finding peaks/minima of rates over long periods. |
