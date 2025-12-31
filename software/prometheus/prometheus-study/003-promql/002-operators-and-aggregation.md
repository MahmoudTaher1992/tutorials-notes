This section, **003-PromQL/002-Operators-and-Aggregation**, is the engine room of Prometheus. While "Basics" teaches you how to fetch data, this section teaches you how to **calculate**, **filter**, and **summarize** that data.

Without these tools, you only have raw numbers. With them, you have actionable insights (percentages, error rates, cluster-wide totals).

Here is a detailed breakdown of the three main pillars of this section.

---

### 1. Binary Operators
These are standard programming operators adapted for Time Series vectors. They allow you to perform math or logic between two metrics or between a metric and a number (scalar).

#### A. Arithmetic Operators
`+`, `-`, `*`, `/`, `%` (modulo), `^` (power).

*   **Scalar-Vector Math:** Modifying a value by a constant.
    *   *Example:* Convert bytes to Megabytes.
        ```promql
        node_memory_MemFree_bytes / 1024 / 1024
        ```
*   **Vector-Vector Math:** calculating the ratio between two different metrics.
    *   *Example:* Calculate Error Rate (Errors divided by Total Requests).
        ```promql
        rate(http_requests_total{status="500"}[5m]) / rate(http_requests_total[5m])
        ```
    *   *Note:* For this to work, the labels on both sides must match exactly (unless you use Vector Matching, see below).

#### B. Comparison Operators
`==`, `!=`, `>`, `<`, `>=`, `<=`.

In PromQL, comparison operators act as **filters**.
*   **Scalar Comparison:** If you compare a metric to a number, PromQL removes any time series that does not meet the criteria.
    *   *Example:* Show me only instances where CPU usage is over 80%.
        ```promql
        instance:node_cpu:rate5m > 0.8
        ```
*   **Bool Modifier:** If you add `bool` to the end, it returns `0` (false) or `1` (true) instead of filtering. This is useful for math.
    *   *Example:* `up == bool 1` returns 1 if up, 0 if down.

#### C. Logical Operators
`and`, `or`, `unless`.

These are set operations based on **labels**.
*   **`and` (Intersection):** Returns results that exist in *both* the left and right query (matching exactly by labels).
*   **`or` (Union):** Returns results from the left; if none exist, checks the right.
*   **`unless` (Exclusion):** Returns results from the left *only if* there is NO match on the right.
    *   *Example:* Alert on instances that are using high CPU but are *not* part of the "backup" job.
        ```promql
        (instance_cpu > 0.9) unless (up{job="backup"})
        ```

---

### 2. Vector Matching (`on`, `ignoring`, `group_left`)
This is often considered the **hardest part of PromQL** to master.

When you do math between two metrics (like `Metric A / Metric B`), Prometheus requires the labels on both sides to be identical. If `Metric A` has a label `ip="10.0.0.1"` and `Metric B` does not, the calculation fails (returns no data).

Vector matching keywords solve this.

#### A. `on` and `ignoring` (Restricting the match)
These tell Prometheus which labels to compare and which to disregard.
*   **`ignoring(label_list)`**: Calculate based on all labels *except* the ones listed here.
*   **`on(label_list)`**: Calculate *only* based on the labels listed here.

*Example:* Calculate percentage of error codes.
*   `total_errors` has labels `{instance="A", code="500"}`
*   `total_requests` has labels `{instance="A"}` (no code label)
*   Direct division fails because labels don't match.
*   **Solution:**
    ```promql
    total_errors / ignoring(code) total_requests
    ```

#### B. Many-to-One and `group_left` / `group_right`
This is similar to a **SQL JOIN**. Sometimes one side has "more" cardinality (more specific labels) than the other.

*   **Scenario:** You have `http_requests` (Many series, one per endpoint) and `machine_role` (One series per machine). You want to join them to see Requests by Role.
*   **`group_left`**: The "Many" side is on the Left. The "One" side is on the Right.
    ```promql
    rate(http_requests_total[5m]) * on(instance) group_left(role) machine_info
    ```
    *   This says: Match them based on `instance`. Multiply them. And please **copy** the `role` label from the right side over to the result on the left.

---

### 3. Aggregation Operators
Aggregation takes a "vector" (a list of many time series) and squashes them into a single result or fewer results.

#### Syntax
```promql
<aggregator> (parameter) (<metric>) by (<label_list>)
// OR
<aggregator> (parameter) (<metric>) without (<label_list>)
```

#### A. Basic Aggregators
*   **`sum`**: Adds values together.
    *   *Example:* Total queries per second across the whole cluster.
        ```promql
        sum(rate(http_requests_total[5m]))
        ```
*   **`min` / `max`**: Finds the lowest or highest value.
*   **`avg`**: Calculates the mathematical mean.
*   **`count`**: Counts how many time series exist (useful for counting "How many pods are running?").

#### B. Grouping (`by` and `without`)
This determines the dimensions of the result.
*   **`by (code)`**: Sum everything up, but split the results by the HTTP `code` label. You get one result per code (200, 404, 500).
*   **`without (instance)`**: Sum everything up and preserve all labels *except* `instance`. Useful when you don't know what other labels might exist but you know you want to aggregate away the instance ID.

#### C. Statistical Aggregators
*   **`topk(X, metric)`**: Returns the top X series with the highest values.
    *   *Example:* Show me the top 3 most CPU-hungry containers.
        ```promql
        topk(3, container_cpu_usage_seconds_total)
        ```
*   **`quantile(φ, metric)`**: Calculates a distribution quantile (0 to 1) across dimensions (e.g., "What is the 95th percentile CPU usage across all my servers right now?").

### Summary of why this section matters:
1.  **Operators** allow you to create KPIs (ratios, percentages) rather than just raw counters.
2.  **Vector Matching** allows you to enrich metrics with metadata from other metrics (Joining).
3.  **Aggregation** allows you to zoom out from "Pod Level" to "Service Level" or "Cluster Level" views.
