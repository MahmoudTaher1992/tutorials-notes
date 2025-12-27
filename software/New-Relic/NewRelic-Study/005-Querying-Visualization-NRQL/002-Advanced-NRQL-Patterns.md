This section, **"Advanced NRQL Patterns,"** is the bridge between being a casual user of New Relic (who just clicks pre-made charts) and a **Power User** who can extract deep, specific insights from data.

While basic NRQL handles simple counts and averages, advanced patterns allow you to handle complex logic, visualize trends over moving windows, and correlate data in ways standard dashboards cannot.

Here is a detailed breakdown of each concept in this section.

---

### 1. Subqueries and Nested Aggregation

In standard SQL, you often use subqueries to join tables. In NRQL, subqueries are primarily used for **Nested Aggregation**—performing a calculation on the result of another calculation.

**Why use it?**
Imagine you want to know the *Average* CPU usage across your fleet. That’s easy. But what if you want to know the **Average of the Maximums**? (i.e., "Find the peak CPU for every individual host, and then give me the average of those peaks"). You can't do this in a simple query.

**Syntax:**
```sql
SELECT average(max_cpu) 
FROM (
  SELECT max(cpuPercent) AS max_cpu 
  FROM SystemSample 
  FACET hostname
)
```

*   **Inner Query:** Calculates the max CPU for *each* host.
*   **Outer Query:** Takes those results and averages them.

---

### 2. Time Series and Sliding Windows

**Standard `TIMESERIES`:**
By default, NRQL returns a single number (e.g., "5 errors"). Adding `TIMESERIES` turns that number into a line chart over time.
*   `TIMESERIES 1 minute`: buckets data into distinct 1-minute blocks.

**Sliding Windows (`SLIDE BY`):**
This is an advanced variation used to smooth out "spiky" charts.
*   **Scenario:** You have a dashboard showing "Errors per minute." If an error spikes at 12:00:59 and ends at 12:01:01, a standard chart might split that spike into two small bumps.
*   **Solution:** A sliding window moves the "bucket" incrementally rather than jumping.

**Syntax:**
```sql
SELECT count(*) FROM Transaction 
WHERE error IS true 
TIMESERIES 5 minutes SLIDE BY 1 minute
```
*   This looks at a 5-minute window, calculates the data, slides the window forward by 1 minute, and calculates again. It creates a rolling average visualization.

---

### 3. Filter and Case Logic

These functions allow you to perform "If/Then/Else" logic directly inside your query aggregations.

#### A. `filter()`
This is the NRQL equivalent of Excel's `COUNTIF` or SQL's `CASE WHEN...`. It allows you to plot multiple specific metrics on one chart without `WHERE` clauses excluding the rest of the data.

**Example:** Show Total Transactions vs. Failed Transactions on one chart.
```sql
SELECT 
  count(*) AS 'All Traffic', 
  filter(count(*), WHERE error IS true) AS 'Errors',
  filter(count(*), WHERE duration > 1.0) AS 'Slow Requests'
FROM Transaction 
TIMESERIES
```

#### B. `cases()`
This is used to categorize results into "buckets" or labels based on thresholds.

**Example:** Categorize transactions by speed.
```sql
SELECT count(*) 
FROM Transaction 
FACET cases(
  WHERE duration < 0.1 AS 'Fast', 
  WHERE duration >= 0.1 AND duration < 1.0 AS 'Medium', 
  WHERE duration >= 1.0 AS 'Slow'
)
```

---

### 4. Funnels (`funnel()`)

Funnels are essential for **Digital Customer Experience** and marketing. They answer: "Of the users who started step A, how many made it to step B, and then step C?"

**Why use it?**
To find drop-off points in a checkout flow or registration process.

**Syntax:**
The order inside the parentheses matters.
```sql
SELECT funnel(session,
  WHERE pageUrl LIKE '%/login', 
  WHERE pageUrl LIKE '%/add-to-cart',
  WHERE pageUrl LIKE '%/checkout-success'
) 
FROM PageView 
SINCE 1 day ago
```
*   **Result:** returns the % of users who completed the journey and the drop-off at each specific step.

---

### 5. Math Operations and Casting

NRQL allows arithmetic directly in the `SELECT` clause. You can also change data types (Cast) if New Relic accidentally ingested a number as a string.

**Math Example:**
Calculate the percentage of total memory used.
```sql
SELECT average(memoryUsedBytes / memoryTotalBytes * 100) 
FROM SystemSample
```

**Casting Example:**
Sometimes, custom attributes are sent as strings (e.g., `"404"` instead of number `404`). You cannot perform math on strings (`> 500`).
```sql
SELECT count(*) 
FROM Transaction 
WHERE numeric(httpResponseCode) >= 500
```
*   **Functions:** `numeric()`, `string()`

---

### 6. Querying Metrics vs. Events vs. Logs

New Relic stores data in different data types. Advanced users must know which one they are querying because the syntax changes slightly.

#### A. Events (`FROM Transaction`, `FROM PageView`)
*   **What are they?** Individual records. "User X did Y at time Z."
*   **Query Style:** High granularity. You use `count(*)`, `percentile()`.
*   **Pros:** Infinite flexibility in filtering.
*   **Cons:** Data is sampled after 8 days (usually).

#### B. Metrics (`FROM Metric`)
*   **What are they?** Pre-aggregated numbers. "CPU was 50% average over this minute."
*   **Query Style:** You query the metric name.
*   **Syntax:**
    ```sql
    SELECT average(newrelic.timeslice.value) 
    FROM Metric 
    WHERE metricName = 'apm.service.cpu'
    ```
*   **Pros:** Retained for 13 months. Very fast.

#### C. Logs (`FROM Log`)
*   **What are they?** Unstructured text lines.
*   **Query Style:** Searching for text patterns.
*   **Syntax:**
    ```sql
    SELECT count(*) 
    FROM Log 
    WHERE message LIKE '%NullPointerException%'
    ```

### Summary of Learning Goals for this Section
By the end of this module, you should be able to:
1.  Write a query that calculates the **success rate** of a process manually using math.
2.  Create a **Funnel** chart to visualize user drop-off.
3.  Use **Filter** to show "Total" vs "Error" counts on a single line chart.
4.  Know when to query `Transaction` (Events) vs `Metric` (Long-term trends).
