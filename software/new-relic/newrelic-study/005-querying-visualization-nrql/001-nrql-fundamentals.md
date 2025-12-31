Based on the Table of Contents you provided, here is a detailed explanation of **Part V: Querying & Visualization (NRQL) -> Section A: NRQL Fundamentals**.

---

# What is NRQL?
**NRQL** (pronounced "nerkel") stands for **New Relic Query Language**. It is a query language similar to SQL (Structured Query Language) that allows you to retrieve data from the New Relic Database (NRDB).

While it looks like SQL, it is designed specifically for **time-series data** and is **read-only** (you cannot use it to delete or update data, only to read it).

Here is the breakdown of the fundamental concepts listed in your syllabus:

---

### 1. Syntax Structure (`SELECT`, `FROM`, `WHERE`)
Every valid NRQL query requires at least a `SELECT` and a `FROM` clause.

*   **SELECT:** Specifies *what* data (attributes or calculations) you want to see.
*   **FROM:** Specifies the *Event Type* (the table) you are querying. Common event types include `Transaction` (APM), `PageView` (Browser), or `SystemSample` (Infrastructure).
*   **WHERE:** Filters the results to specific criteria.

**Example:**
Imagine you want to see how long your backend requests are taking, but only for a specific application named "Checkout Service".

```sql
SELECT duration 
FROM Transaction 
WHERE appName = 'Checkout Service'
```
*   **Result:** This returns a list of raw duration numbers for every transaction in the default time window (last 60 minutes).

---

### 2. Aggregation Functions (`average`, `max`, `count`, `sum`)
Raw data is rarely useful on a dashboard because there are millions of events. You need to summarize the data using math functions.

*   **count(\*):** Counts how many events occurred. (e.g., "How many total page views did we have?")
*   **average(attribute):** Calculates the mean of a numerical value. (e.g., "What was the average load time?")
*   **max(attribute):** Finds the highest value. (e.g., "What was the slowest request?")
*   **sum(attribute):** Adds all values together. (e.g., "What is the total number of bytes sent?")

**Example:**
Instead of a list of raw numbers, let's get a summary of our application performance.

```sql
SELECT count(*) as 'Total Requests', average(duration), max(duration) 
FROM Transaction 
WHERE appName = 'Checkout Service'
```
*   **Result:** A single row showing the total volume, the average speed, and the slowest outlier.

---

### 3. Time Windows (`SINCE`, `UNTIL`, `COMPARE WITH`)
Since New Relic is all about monitoring over time, defining the time window is critical. If you don't specify one, NRQL defaults to `SINCE 60 minutes ago`.

*   **SINCE:** Sets the start time of the data. You can use phrases like `SINCE 1 day ago`, `SINCE '2023-12-25 00:00:00'`, or `SINCE yesterday`.
*   **UNTIL:** Sets the end time. Default is "now", but you can look at historical windows (e.g., `SINCE last week UNTIL yesterday`).
*   **COMPARE WITH:** This is a powerful feature for context. It compares the current value with a previous time period to show growth or decline.

**Example:**
"Show me the error count for the last 1 day, but compare it to the week before to see if it got worse."

```sql
SELECT count(*) 
FROM TransactionError 
WHERE appName = 'Checkout Service' 
SINCE 1 day ago 
COMPARE WITH 1 week ago
```
*   **Result:** A JSON result or chart showing two numbers: the error count today, and the error count from the same day last week, usually with a percentage change.

---

### 4. Grouping (`FACET`) and Ordering
In standard SQL, you use `GROUP BY`. In NRQL, this is called **FACET**.

*   **FACET:** Breaks the data down by a specific attribute. If you have a total count of errors, `FACET` allows you to see that count broken down *per host* or *per city*.
*   **ORDER BY:** Sorts the results. By default, `FACET` queries sort by the highest count, but you can force an order (e.g., `ORDER BY duration DESC`).
*   **LIMIT:** (Often used with Facet) Limits how many results appear. The default is usually 10, but you can raise it (e.g., `LIMIT MAX`).

**Example:**
"Show me the average response time, but break it down by which city the user is connecting from."

```sql
SELECT average(duration) 
FROM PageView 
FACET city 
LIMIT 5
```
*   **Result:** A table (or pie chart) showing the top 5 cities and the average page load speed for each.

---

### Summary of a "Fundamental" Query
Putting it all together, a fundamental NRQL query looks like this:

```sql
SELECT average(duration)      -- Aggregation
FROM Transaction              -- The Data Source
WHERE httpResponseCode = 200  -- Filter
FACET name                    -- Grouping (by endpoint name)
SINCE 6 hours ago             -- Time Window
LIMIT 20                      -- Limit results
```

**Why this section is important:**
You cannot build useful Dashboards or set up Alert conditions in New Relic without understanding these basics. Almost every chart you see in New Relic is powered by a query looking exactly like the examples above.
