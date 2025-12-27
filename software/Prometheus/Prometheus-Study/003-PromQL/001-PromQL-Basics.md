Based on the Table of Contents provided, here is a detailed explanation of **Part III, Section A: PromQL Basics**.

PromQL (Prometheus Query Language) is a functional language. Unlike SQL, which creates tables, PromQL extracts and mathematically manipulates time-series data.

---

### 1. Instant Vectors vs. Range Vectors

Understanding the difference between these two data types is the most critical step in learning PromQL. If you mix them up, you will get syntax errors.

#### **Instant Vectors**
An **Instant Vector** represents a set of time series containing a single sample for each time series, all sharing the same timestamp. Think of this as a **vertical slice** or a "snapshot" of the database at a specific moment.

*   **Syntax:** Just the metric name (and optional labels).
    *   `http_requests_total`
*   **What it returns:** The *latest* known value for that metric.
*   **Use Case:**
    *   Drawing a line on a graph (Grafana expects an Instant Vector per timestamp).
    *   Aggregation (e.g., `sum(http_requests_total)`).
    *   Math (e.g., `node_memory_active / node_memory_total`).

#### **Range Vectors**
A **Range Vector** is a set of time series containing a range of data points over time for each time series. Think of this as a **horizontal chunk** or a "video clip" of data history.

*   **Syntax:** The metric name followed by a time duration in brackets `[]`.
    *   `http_requests_total[5m]` (Selects all data points recorded in the last 5 minutes).
*   **What it returns:** A list of values and timestamps for every scrape that happened in that window.
*   **Use Case:**
    *   **Crucial Rule:** You cannot graph a Range Vector directly.
    *   It is strictly used as input for functions that calculate change over time, such as `rate()`, `increase()`, or `avg_over_time()`.

**Example of the difference:**
*   `http_requests_total`: Returns "100" (The count right now).
*   `rate(http_requests_total[5m])`: Calculates how fast the counter moved from 5 minutes ago to now (per second).

---

### 2. Selecting Series (Matchers)

To filter data, you use **Label Matchers** inside curly braces `{}`. This operates like a `WHERE` clause in SQL. PromQL provides four operators:

#### **A. Equality Matcher (`=`)**
Selects time series that have exactly this label value.
*   **Example:** Select all API HTTP requests.
    ```promql
    http_requests_total{job="api-server"}
    ```

#### **B. Negative Equality Matcher (`!=`)**
Selects time series that do **not** have this label value.
*   **Example:** Select all jobs *except* the backup job.
    ```promql
    up{job!="backup-cron"}
    ```

#### **C. Regular Expression Matcher (`=~`)**
Selects time series where the label value matches a provided **Regex** pattern. This is fully anchored (implicitly starts with `^` and ends with `$`).
*   **Example 1 (OR logic):** Select `staging` OR `prod` environments.
    ```promql
    http_requests_total{env=~"staging|prod"}
    ```
*   **Example 2 (Wildcards):** Select any instance starting with `10.`.
    ```promql
    node_cpu_seconds_total{instance=~"10\..+"}
    ```

#### **D. Negative Regular Expression Matcher (`!~`)**
Selects time series where the label value does **not** match the Regex pattern.
*   **Example:** Select all HTTP codes that do *not* start with 4 or 5 (i.e., exclude errors).
    ```promql
    http_requests_total{status!~"4..|5.."}
    ```

---

### 3. Lookback Deltas and Staleness

This concept explains how Prometheus behaves when data goes missing or scraping stops.

#### **Lookback Delta (The 5-minute rule)**
Prometheus is a sampling system. If you ask for the value of a metric at **12:00:00**, it is unlikely a scrape happened exactly at that millisecond. The scrape might have happened at **11:59:45**.

*   **How it works:** When you query an *Instant Vector*, Prometheus looks backward from the query time to find the most recent sample.
*   **The Limit:** By default, it looks back **5 minutes**.
*   **The Result:**
    *   If the last scrape was 1 minute ago, it returns that value.
    *   If the last scrape was 6 minutes ago (e.g., the server crashed), Prometheus returns **no value** (a gap in the graph).

*Why this matters:* This allows for small network jitters or missed scrapes without breaking your graphs immediately.

#### **Staleness**
"Staleness" is how Prometheus handles the *explicit* disappearance of a time series.

If you deploy a new version of your app and the old Pod/Container is deleted, the metrics for that old Pod stop updating.
*   **Without Staleness:** The graph would show a flat line for 5 minutes (due to Lookback Delta) before disappearing. This looks misleading (it looks like the app froze, not that it died).
*   **With Staleness:** When Prometheus detects a target is gone (via Service Discovery) or a timestamp is explicitly marked stale:
    1.  Prometheus inserts a special **Staleness Marker**.
    2.  PromQL queries encountering this marker immediately stop returning data.
    3.  **Result:** The line on the graph cuts off instantly when the container dies, rather than trailing off for 5 minutes.
