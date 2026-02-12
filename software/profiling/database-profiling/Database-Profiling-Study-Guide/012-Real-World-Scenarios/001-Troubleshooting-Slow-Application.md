Here is the comprehensive content for **Section 47. Troubleshooting Slow Application**, tailored to the provided Table of Contents.

---

# 47. Troubleshooting Slow Application

When users complain that "the system is slow," the database is often the "guilty until proven innocent" suspect. This section outlines a structured workflow to confirm if the database is the bottleneck, identify the specific cause, and resolve it systematically.

## 47.1 Initial Assessment

Before diving into SQL execution plans, you must triage the situation to understand the scope and nature of the slowness.

### 47.1.1 User-reported symptoms
Translate vague user complaints into technical constraints:
*   **Scope:** Is the entire application slow, or just the "Checkout" page? (Suggests a specific query vs. system-wide resource exhaustion).
*   **Timing:** Is it constant, periodic (every hour), or random spikes?
*   **Error Messages:** Are users seeing "504 Gateway Timeout" (Application gave up waiting) or "Connection Refused" (Database is down/full)?

### 47.1.2 Application vs. database distinction
Verify the bottleneck is actually the database.
*   **Check APM (Application Performance Monitoring):** Tools like New Relic, Datadog, or Jaeger will show a breakdown of transaction time. If "Database Duration" accounts for 90% of the request time, proceed with DB profiling. If it's 5%, the issue is likely in the application code (CPU loop) or external API calls.
*   **Network Latency:** Ensure the latency isn't due to a saturated network link between the App Server and DB Server.

### 47.1.3 Quick database health check
Perform a "vital signs" check to rule out catastrophic failure:
*   **Uptime:** Did the database restart recently? (Cold cache issues).
*   **Connectivity:** Can you connect via CLI?
*   **Disk Space:** Is the storage volume 100% full? (Causes writes to hang immediately).
*   **Backups:** Is a backup or snapshot currently running? (I/O heavy).

### 47.1.4 Recent changes review
80% of performance incidents are self-inflicted.
*   **Deployments:** Was new code deployed in the last 24 hours?
*   **Config:** Did a DBA change a parameter (`random_page_cost`, `innodb_buffer_pool`)?
*   **Traffic:** Did a marketing email go out, causing a 10x spike in traffic?

---

## 47.2 Database-Side Investigation

Once the database is confirmed as the bottleneck, look at what the instance is doing *right now*.

### 47.2.1 Active session analysis
Inspect currently running threads/processes.
*   **Tools:** `pg_stat_activity` (PostgreSQL), `SHOW FULL PROCESSLIST` (MySQL), `sys.dm_exec_requests` (SQL Server), `currentOp()` (MongoDB).
*   **Look for:** A pile-up of connections in states like "Waiting for lock," "Copying to tmp table," or "Sorting."

### 47.2.2 Slow query identification
If active sessions look normal but performance is poor, look for "death by a thousand cuts" (many moderately slow queries).
*   **Review:** Slow Query Logs or performance insights dashboards (e.g., AWS RDS Performance Insights).
*   **Metric:** Identify the top query by **Total Load** (Execution Count × Average Latency).

### 47.2.3 Lock contention check
Is the application slow because queries are waiting in line?
*   Identify "Blocking Sessions." Often, one idle transaction (a user who opened a transaction and went to lunch) can block hundreds of other writes.
*   Check for Deadlocks (circular blocking) in the error logs.

### 47.2.4 Resource utilization review
Check the "USE" metrics (Utilization, Saturation, Errors).
*   **CPU:** Is it at 100%? (Likely inefficient queries doing scans/hashing).
*   **Memory:** Is the instance swapping to disk? (Performance killer).
*   **I/O:** Is the Disk Queue Depth high? (Storage subsystem cannot keep up with read/write requests).

### 47.2.5 Connection pool status
*   Check the application side: Are threads waiting to *borrow* a connection?
*   Check the database side: Is `Max Connections` reached?
*   *Symptom:* If DB CPU is low but App is slow, the App might be starved for connections.

---

## 47.3 Query-Level Investigation

Deep dive into the specific SQL statement identified as the culprit.

### 47.3.1 Problematic query identification
Isolate the exact SQL text and parameters.
*   *Note:* A query might be fast with `ID=1` but slow with `ID=5000` (parameter sniffing/skew). Capture the actual parameters causing the issue.

### 47.3.2 Execution plan analysis
Run `EXPLAIN` (or `EXPLAIN ANALYZE` for actual execution) on the query.
*   **Red Flags:**
    *   `SEQ SCAN` / `ALL`: Reading the whole table instead of using an index.
    *   `FILESORT` / `External Sort`: Sorting data on disk because RAM was insufficient.
    *   `High Cost`: The optimizer predicts this query is expensive.

### 47.3.3 Index usage verification
Does the query use the index you expect?
*   If an index exists but isn't used, the optimizer might believe a full scan is cheaper (often due to small table size or bad statistics).
*   Check for **Implicit Type Conversion** (e.g., comparing a String column to an Integer parameter), which disables index usage.

### 47.3.4 Statistics freshness check
*   If the database statistics (histograms of data distribution) are stale, the optimizer makes bad decisions (e.g., choosing a Nested Loop Join for two massive tables).
*   *Check:* `last_analyzed` timestamps on the involved tables.

---

## 47.4 Common Root Causes

These eight scenarios account for the vast majority of application performance issues.

### 47.4.1 Missing or inefficient indexes
The most common cause. The database must read 10 million rows to find the 10 you asked for.
*   *Fix:* Create a covering index for the `WHERE` and `ORDER BY` clauses.

### 47.4.2 Statistics staleness
The table grew from 1,000 to 1,000,000 rows, but the stats still say 1,000. The DB chooses a plan optimized for a small table, crashing performance.
*   *Fix:* Run `ANALYZE` / `UPDATE STATISTICS`.

### 47.4.3 Lock contention
High concurrency on a single row (e.g., updating a global counter) or table locks during backups/DDL.
*   *Fix:* Shard the counter, use optimistic locking, or reschedule maintenance.

### 47.4.4 Resource exhaustion
The server is simply undersized for the workload.
*   *Fix:* Upgrade hardware (Vertical Scaling) or optimize queries to reduce footprint.

### 47.4.5 Connection pool exhaustion
Application threads are blocked waiting for a database connection handle, appearing as "latency" to the end user.
*   *Fix:* Increase pool size (carefully), or fix "connection leaks" in code (connections not returned to pool).

### 47.4.6 N+1 query patterns
An Object-Relational Mapper (ORM) fetches a list of Parents, then runs a separate query for every Child.
*   *Symptom:* Low latency per query, but thousands of queries per request. High network/CPU overhead.
*   *Fix:* Use Eager Loading (`JOIN` or `prefetch`).

### 47.4.7 Large result sets
The application requests `SELECT * FROM Orders` without a limit, trying to fetch 500MB of data.
*   *Symptom:* High Network I/O and Application Out-Of-Memory errors.
*   *Fix:* Add pagination logic or strictly limit columns selected.

### 47.4.8 Inefficient pagination
Using `LIMIT 10 OFFSET 1000000`. The database must read 1,000,010 rows and throw away the first million.
*   *Fix:* Use Keyset Pagination (Seek Method) based on the last seen ID (`WHERE id > last_seen_id LIMIT 10`).

---

## 47.5 Resolution and Prevention

Closing the loop: Fixing the issue and ensuring it doesn't return.

### 47.5.1 Immediate fixes
*   **Kill the Query:** If a report is taking down the site, terminate the session.
*   **Reboot:** A last resort to clear stuck locks or memory leaks (but destroys diagnostic evidence).
*   **Scale Up:** Temporarily increase instance size (cloud) to survive a traffic spike.

### 47.5.2 Long-term solutions
*   **Code Refactoring:** Rewrite the N+1 loop or inefficient pagination.
*   **Indexing:** Add missing indexes (using "Concurrent" mode to avoid locking production).
*   **Caching:** Move heavy read loads (e.g., product catalog) to Redis/Memcached.

### 47.5.3 Monitoring improvements
*   If this incident took 1 hour to detect, add granularity to the monitoring dashboard.
*   Visualize "Connection Pool Wait Time" and "Top SQL by IO."

### 47.5.4 Alerting setup
*   Configure alerts for **Leading Indicators** (e.g., "Connection Pool > 80% full") rather than just **Lagging Indicators** (e.g., "CPU > 95%").
*   Set up "Slow Query" alerts (e.g., "Warn if any query takes > 5s").