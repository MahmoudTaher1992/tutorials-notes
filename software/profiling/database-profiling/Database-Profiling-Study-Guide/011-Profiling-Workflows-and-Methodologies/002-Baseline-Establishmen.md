Here is the comprehensive content for **Section 42. Baseline Establishment**, tailored to the provided Table of Contents.

---

# 42. Baseline Establishment

A **baseline** is a recorded state of the database’s performance metrics under normal operating conditions. Without a baseline, "troubleshooting" is merely guessing. You cannot determine if 60% CPU utilization is a problem or a luxury without knowing that the system historically runs at 20%—or 80%—at this time of day.

## 42.1 Why Baselines Matter

The primary purpose of a baseline is to provide context. It transforms raw numbers into actionable intelligence.

### 42.1.1 Normal behavior definition
A baseline answers the question: *"What does 'good' look like?"* It establishes the standard profile for resource consumption, query throughput, and latency during specific timeframes (e.g., Monday morning rush vs. Sunday night lull).

### 42.1.2 Anomaly detection foundation
An anomaly is a deviation from the baseline, not necessarily a threshold breach.
*   *Example:* If your database normally processes 5,000 TPS at 10 AM, and today it is processing 500 TPS, that is a critical anomaly—even if no server resource limits (CPU/RAM) are being breached.
*   *Example:* A sudden drop in CPU usage can be as alarming as a spike, potentially indicating an upstream application failure or a network partition.

### 42.1.3 Trend analysis enablement
Baselines allow for the comparison of performance over long horizons.
*   "Is the database getting slower by 50ms every month?"
*   "Is the disk filling up faster this quarter than last quarter?"
This perspective distinguishes between sudden incidents and slow-burning degradation (the "boiling frog" syndrome).

### 42.1.4 Capacity planning support
By plotting the growth of baseline metrics over time (e.g., "Data size increases by 5% monthly"), administrators can mathematically project when hardware upgrades will be necessary, shifting procurement from reactive panic to proactive budgeting.

### 42.1.5 Performance regression detection
When new code is deployed, the baseline acts as the control group. If a deployment causes the average query duration to jump from 100ms (baseline) to 150ms, a performance regression has occurred, warranting a potential rollback or hotfix.

---

## 42.2 Baseline Metrics Selection

Collecting too little data leaves you blind; collecting too much creates noise.

### 42.2.1 Key performance indicators (KPIs)
These are the non-negotiable "Golden Signals" of database health:
*   **Latency:** Time taken to service a request (p50 and p99).
*   **Traffic:** Demand placed on the system (TPS/QPS).
*   **Errors:** Rate of request failures (HTTP 500s, DB Connection Refused, Deadlocks).
*   **Saturation:** How "full" the service is (Queue depth, Disk I/O utilization).

### 42.2.2 Leading vs. lagging indicators
*   **Lagging Indicators:** Tell you what *has already happened*. (e.g., CPU temperature, Application Error Rate). By the time these spike, users are likely already affected.
*   **Leading Indicators:** Predict what *is about to happen*. (e.g., Connection Pool Utilization, Free Disk Space, Memory Paging rates). A baseline on leading indicators allows for intervention before an outage occurs.

### 42.2.3 Metric coverage balance
Adopt a methodology like the **USE Method** (Utilization, Saturation, Errors) for resources and the **RED Method** (Rate, Errors, Duration) for services to ensure no blind spots exist. A baseline that tracks CPU but ignores Disk Queue Depth is incomplete for a database.

### 42.2.4 Avoiding metric overload
Storing thousands of metrics per second is expensive and computationally heavy to query. Focus on high-level aggregations for the baseline. You do not need to baseline the execution time of *every* unique query; baselining the top 10 slow queries and the aggregate database load is usually sufficient.

---

## 42.3 Baseline Collection Process

A baseline is not a snapshot; it is a time-series dataset.

### 42.3.1 Collection duration
To capture a representative baseline, data must be collected over a sufficiently long period to account for cyclic variance.

*   **42.3.1.1 Daily patterns capture:** Capturing the difference between the 9:00 AM login spike, the lunchtime lull, and the nightly backup window.
*   **42.3.1.2 Weekly patterns capture:** Database load often differs significantly between weekdays (OLTP heavy) and weekends (Maintenance/Batch heavy). A 24-hour baseline is insufficient; a 7-day baseline is the minimum standard.
*   **42.3.1.3 Monthly/seasonal patterns:** Identifying macro-cycles such as End-of-Month reporting, Black Friday sales, or tax deadlines.

### 42.3.2 Collection granularity
*   **High Frequency (1-10 seconds):** Essential for identifying micro-bursts and jitter. Expensive to store long-term.
*   **Low Frequency (1-5 minutes):** Good for trending and capacity planning. Smoothes out spikes (aliasing), which can hide transient issues.
*   *Best Practice:* Collect high frequency, but downsample (roll up) to lower frequency for long-term baseline storage.

### 42.3.3 Workload representativeness
Ensure the baseline period represents "Business as Usual." Do not establish a baseline during a holiday outage, a planned maintenance window, or while a load test is running, as this will skew the definition of "normal."

### 42.3.4 Handling outliers
Decide how to treat outliers in the baseline data.
*   *Keep them:* If the nightly backup causes a spike, that *is* normal behavior and should be part of the baseline.
*   *Exclude them:* If a one-off network outage caused 0 TPS for 4 hours, exclude that time window so it doesn't artificially lower the average baseline.

### 42.3.5 Baseline storage and retention
Baselines should be stored in a dedicated Time-Series Database (TSDB) or monitoring system (Prometheus, CloudWatch, Datadog). Retention policies should keep high-granularity data for weeks and downsampled data (1-hour averages) for 1–2 years for Year-Over-Year analysis.

---

## 42.4 Baseline Analysis

Turning data points into statistical profiles.

### 42.4.1 Statistical characterization
*   **42.4.1.1 Central tendency:** Use **Median (p50)** rather than Mean for baselines, as Mean is easily skewed by outliers.
*   **42.4.1.2 Dispersion:** Calculate **Standard Deviation**. A baseline is not a line; it is a band. A narrow band implies predictable performance; a wide band implies volatility.
*   **42.4.1.3 Percentile distributions:** Establish baselines for p95 and p99. A system might have a steady p50 latency but a degrading p99 (tail latency), indicating intermittent locking issues.

### 42.4.2 Pattern identification
Visual inspection of baseline graphs helps identifying distinct shapes:
*   **The "Sawtooth":** Often indicates memory leaks followed by garbage collection or cache expirations.
*   **The "Plateau":** Indicates a resource cap (e.g., hitting network bandwidth limits).
*   **The "Camel Hump":** Morning and afternoon peaks separated by lunch.

### 42.4.3 Correlation discovery
Identify metrics that move in lockstep.
*   *Positive Correlation:* TPS goes up, CPU goes up. (Healthy).
*   *Negative Correlation:* TPS goes up, Free Memory goes down. (Healthy).
*   *Divergence:* TPS goes down, CPU goes up. (Unhealthy - indicates inefficient queries or contention).

### 42.4.4 Threshold derivation
Use the baseline to set dynamic alerting thresholds. Instead of a static "Alert at 80% CPU," use "Alert if CPU > Baseline + 3 Standard Deviations." This reduces false positives during expected high-load times and catches anomalies during low-load times.

---

## 42.5 Baseline Maintenance

A baseline is a living document. A baseline from 2024 is useless in 2026.

### 42.5.1 Baseline versioning
Maintain distinct versions of baselines labeled by timeframe (e.g., `baseline_q1_2025`, `baseline_q2_2025`). This allows you to compare "Normal" today vs. "Normal" a year ago.

### 42.5.2 Baseline refresh triggers
*   **42.5.2.1 After major changes:** A database version upgrade, a migration to new hardware/cloud instance types, or a major schema refactor invalidates the old baseline immediately.
*   **42.5.2.2 After growth milestones:** Significant user acquisition (e.g., 20% traffic increase) requires a new baseline to reflect the new "normal" load.
*   **42.5.2.3 Periodic refresh:** Even without major events, re-calculate baselines quarterly to account for organic data growth and minor code changes.

### 42.5.3 Historical baseline preservation
Never overwrite old baselines. Keep them as historical artifacts. They are the only way to answer the question: *"Is the system slower than it was two years ago?"*

### 42.5.4 Baseline documentation
Annotate the baseline data.
*   *Example:* "Baseline updated Jan 15th. Note: New caching layer implemented, expect lower DB read IOPS compared to Dec baseline."
*   Documentation prevents confusion when historical comparisons show massive, unexplained shifts in metrics.