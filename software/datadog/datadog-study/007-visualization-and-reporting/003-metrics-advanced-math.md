Based on the Table of Contents provided, **Section 007 (Visualization & Reporting) / Part C (Metrics Advanced Math)** is one of the most critical technical sections in Datadog. It moves you from simply "viewing data" to "analyzing data."

If you understand this section, you can troubleshoot complex issues and build accurate SLOs. If you don't, your dashboards might show misleading data without you realizing it.

Here is a detailed explanation of the three pillars of Metrics Advanced Math in Datadog.

---

# 003-Metrics-Advanced-Math.md: Detailed Explanation

This module focuses on the **Datadog Query Language**. Every graph in Datadog is built using a query string (even if you use the visual editor). The lifecycle of a metric query generally looks like this:
`Filter` $\rightarrow$ `Space Aggregation` $\rightarrow$ `Time Aggregation (Rollup)` $\rightarrow$ `Functions/Math`

## 1. Aggregations (Space Aggregation)

When you monitor infrastructure, you rarely look at a single raw data point. You usually have dozens or hundreds of hosts, pods, or containers. **Space Aggregation** determines how Datadog combines data from multiple sources into a single line or a set of lines on a graph.

### The Aggregators
*   **AVG (Average):** The default for most metrics. Good for latency or CPU usage across a cluster.
    *   *Example:* `avg:system.cpu.idle{*}` (Show me the average CPU idle across *all* my servers).
*   **SUM:** Essential for "counts." If you are tracking "Total Requests," you don't want the average number of requests per server; you want the global total.
    *   *Example:* `sum:trace.servlet.request.hits{*}`.
*   **MAX / MIN:** Critical for finding outliers. If 99 servers are at 10% CPU and 1 server is at 100%, the `avg` might be 11% (hiding the problem). The `max` aggregation will show 100%.

### The "By" Clause (Grouping)
This determines how many lines appear on your graph.
*   `avg:system.cpu.idle{*}` $\rightarrow$ Returns **1 line** (All hosts combined).
*   `avg:system.cpu.idle{*} by {host}` $\rightarrow$ Returns **1 line per host**.
*   `avg:system.cpu.idle{*} by {availability_zone}` $\rightarrow$ Returns **1 line per AZ** (averaging the hosts inside that AZ).

---

## 2. Rollups (Time Aggregation)

This is the concept that confuses people the most.
While Space Aggregation combines data across *servers* (Space), **Rollups** combine data across *time*.

### Why do we need Rollups?
Imagine you are looking at a dashboard spanning **4 hours**. Your agent sends metrics every **10 seconds**.
*   Total data points = thousands.
*   Pixels on your screen = a few hundred.
*   Datadog physically cannot draw every point. It must "bucket" time.

### How Rollup Works
The rollup function takes a slice of time (e.g., a 1-minute bucket) and reduces all data points inside that bucket to a single value.

**Syntax:** `.rollup(method, time)`

*   **Method:** How do we combine the points in the bucket? (`avg`, `sum`, `max`, `min`).
*   **Time:** How big is the bucket? (in seconds).

### The "Implicit" Rollup (Automatic)
Datadog automatically rolls up data based on your zoom level.
*   Zoomed into 1 hour $\rightarrow$ Rollup might be 10 seconds.
*   Zoomed out to 1 month $\rightarrow$ Rollup might be 4 hours.

### The "Explicit" Rollup (Manual)
You force the rollup when you need mathematical precision.
*   *Scenario:* You want to graph the number of errors per minute.
*   *Query:* `sum:my_app.errors{*}.rollup(sum, 60)`
*   This forces Datadog to sum up all errors in 60-second blocks, regardless of how far you zoom in or out.

---

## 3. Formulas and Functions

Once the data is aggregated (Space) and bucketed (Time), you can apply math to the result.

### A. Arithmetic (Formulas)
This allows you to perform math **between two different metrics**. This is done using the "Add Formula" button in the dashboard editor.

*   **Example: Calculating Error Rate**
    *   Query A: `sum:trace.servlet.request.errors{service:payment-api}`
    *   Query B: `sum:trace.servlet.request.hits{service:payment-api}`
    *   **Formula:** `(a / b) * 100`
    *   *Result:* A graph showing the percentage of requests that failed.

### B. Functions
Datadog provides a library of functions to apply to a single metric query.

#### 1. Interpolation (Handling missing data)
What happens if a server restarts and sends no data for 1 minute? The graph line breaks.
*   `fill(0)`: Replaces missing data with 0 (Good for error counts).
*   `fill(linear)`: Connects the gap with a straight line.
*   `fill(last)`: Continues the last known value (Good for gauges like Disk Space).

#### 2. Smoothing
If a graph is too "spiky" (jittery), it's hard to read trends.
*   `ewma_10()`: Exponential Weighted Moving Average. It smooths the line based on the last 10 points.

#### 3. Timeshifting (Comparison)
Comparing performance now vs. the past.
*   `timeshift(-1w)`: Takes the current data stream and shifts it back one week.
*   *Use Case:* You graph "Current Requests" and "Requests (-1w)" on the same widget to see if traffic is lower than usual for a Tuesday.

#### 4. Rates and Derivatives
*   `cumsum()`: Cumulative Sum. Shows the running total over the graph period (e.g., Total sales since 9 AM).
*   `derivative()`: Calculates the rate of change per second. Useful for converting a "Total Counter" (like total bytes sent since boot) into a "Rate" (bytes per second).

---

### Summary Scenario: The "Advanced Math" in Action

Imagine you want to alert if **latency increases by 50% compared to yesterday**.

1.  **Metric:** `trace.request.duration`
2.  **Space Aggregation:** `avg` by `service` (Average latency per service).
3.  **Time Rollup:** `.rollup(avg, 300)` (Smooth the data into 5-minute buckets so one slow request doesn't trigger the alert).
4.  **Formula:**
    *   `a = current_latency`
    *   `b = current_latency.timeshift(-1d)`
    *   `Formula = ((a - b) / b) * 100`
5.  **Result:** You now have a graph showing the **% change day-over-day**. You can set an alert threshold at `> 50`.
