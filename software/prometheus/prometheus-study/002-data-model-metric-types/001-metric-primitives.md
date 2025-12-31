Based on the Table of Contents you provided, here is a detailed explanation of **Part II, Section A: Metric Primitives**.

This section is fundamental to Prometheus because every single data point collected falls into one of these four categories. Understanding these distinctions is required to write valid queries (PromQL) and to avoid common alerting mistakes.

---

# 002-Data-Model-Metric-Types / 001-Metric-Primitives

In Prometheus, data is stored as time series. However, the client libraries (Go, Java, Python, etc.) send data types that define **how** that data behaves. There are four core primitives.

## 1. Counter

### Concept
A **Counter** is a cumulative metric that represents a single numerical value that **only increases** (monotonically).
*   It starts at 0.
*   It goes up.
*   It **never** goes down, except when the process restarts (resets to 0).

**Analogy:** Think of a car's **Odometer**. It tells you the total miles driven in the car's life. It does not tell you how fast you are going right now.

### Common Use Cases
*   Total number of HTTP requests received (`http_requests_total`).
*   Total number of errors logged.
*   Total number of tasks completed.

### How to Query It (Important)
You almost **never** want to graph the raw value of a Counter (a line that just goes up and up forever is useless). You are interested in the **speed** at which it is increasing.

You use PromQL "rate" functions with Counters:
*   `rate(http_requests_total[5m])`: Calculates the per-second rate of requests averaged over the last 5 minutes.
*   `increase(errors_total[1h])`: Calculates the exact increase (delta) over the last hour.

> **Warning:** Never use a Counter for a value that can decrease (like the number of currently running processes).

---

## 2. Gauge

### Concept
A **Gauge** is a metric that represents a single numerical value that can arbitrarily go **up and down**.

**Analogy:** Think of a car's **Speedometer** or a Thermometer. It tells you the current state at this exact moment.

### Common Use Cases
*   Current memory usage (`process_resident_memory_bytes`).
*   Current temperature of the CPU.
*   Size of a job queue.
*   Number of active goroutines/threads.

### How to Query It
You often look at the raw value of a Gauge.
*   `avg_over_time(memory_usage[1h])`: What was the average memory usage in the last hour?
*   `predict_linear(disk_free[4h], 24*3600)`: Based on how the gauge moved in the last 4 hours, where will it be in 24 hours? (Used for disk fill-up alerts).

> **Warning:** Do not use `rate()` on a Gauge. It creates nonsensical results because `rate` assumes the value resets to zero if it drops, which isn't true for a Gauge.

---

## 3. Histogram

### Concept
A **Histogram** samples observations (usually things like request durations or response sizes) and counts them in configurable buckets. It is the complex heavyweight of Prometheus metrics, but necessary for calculating **Aggregatable Percentiles**.

When you create a Histogram named `http_request_duration_seconds`, Prometheus actually creates **three** internal time series:

1.  **`..._bucket`**: A set of counters for each bucket. (e.g., How many requests took less than 0.1s? How many took less than 0.5s?).
2.  **`..._sum`**: The total sum of all observed values (Total time spent serving requests).
3.  **`..._count`**: The total count of events (identical to a standard Counter).

### Key Characteristic: Cumulative Buckets
Buckets are cumulative.
*   Bucket `le="0.1"` (Less than or equal to 0.1s) contains 5 requests.
*   Bucket `le="0.5"` contains those previous 5 requests **plus** 3 new ones (total 8).
*   Bucket `le="+Inf"` contains all requests.

### Common Use Cases
*   API Latency / Response time.
*   Payload size of requests.

### How to Query It
You use the special function `histogram_quantile`.
*   `histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))`
    *   *Translation:* "Show me the maximum latency that 95% of my users are experiencing."

### Pros & Cons
*   **Pro:** You can aggregate histograms from different servers (e.g., "Global P99 latency").
*   **Con:** You must define bucket sizes (e.g., 0.1s, 0.5s, 1s) in code before deploying. If you pick wrong buckets, your accuracy suffers.

---

## 4. Summary

### Concept
A **Summary** is similar to a Histogram (it tracks distributions like latency), but it calculates the quantiles (e.g., 95th percentile) **on the client side** (inside your application) rather than asking Prometheus to calculate it later.

Like Histograms, it exposes `_sum` and `_count`, but instead of `_bucket`, it exposes specific quantiles like `{quantile="0.9"}`.

### Common Use Cases
*   When you need highly accurate quantiles and don't know the range of values beforehand (so you can't define buckets).
*   Legacy systems.

### Pros & Cons
*   **Pro:** Very accurate calculation for that specific application instance. No need to define buckets.
*   **Con:** **You cannot aggregate Summaries.** You cannot take the P95 latency of Server A and the P95 of Server B and average them to get a "Global P95". It is mathematically impossible.

> **Best Practice:** In modern Cloud Native environments (Kubernetes), **Histograms** are generally preferred over Summaries because we usually need to aggregate metrics across many pods.

---

## 5. Naming Conventions & Best Practices

Prometheus relies heavily on standardized naming to make data discoverable.

### 1. Suffixes matter
*   Counters should usually end in `_total`.
*   Metrics measuring time should end in `_seconds`.
*   Metrics measuring data size should end in `_bytes`.
*   **Example:** `http_request_duration_seconds_bucket`

### 2. Base Units
Prometheus does not handle units (it essentially treats everything as a `float64`).
*   **Always use base units.**
*   Use **Seconds**, not milliseconds.
*   Use **Bytes**, not Megabytes.
*   *Why?* It allows Grafana/UI to auto-scale the axis (e.g., automatically displaying 0.001 seconds as 1ms).

### 3. Snake Case
Use `snake_case` (underscores), not `camelCase`.
*   Good: `service_memory_usage_bytes`
*   Bad: `serviceMemoryUsage`

### 4. Labels vs. Metric Names
Don't put data in the metric name.
*   **Bad:** `http_requests_total_error_404`, `http_requests_total_error_500`
*   **Good:** `http_requests_total{status="404"}`, `http_requests_total{status="500"}`

---

### Summary Table

| Metric Type | Behavior | Restart Behavior | Main PromQL Function | Example |
| :--- | :--- | :--- | :--- | :--- |
| **Counter** | Only goes UP | Resets to 0 | `rate()`, `increase()` | Total Requests |
| **Gauge** | Up and Down | Persists (usually) | `avg()`, `max()`, `min()` | Memory Usage |
| **Histogram** | Buckets (Complex) | Resets to 0 | `histogram_quantile()` | Latency (Server side calc) |
| **Summary** | Pre-calc Quantiles | Resets to 0 | Raw value lookup | Latency (Client side calc) |
