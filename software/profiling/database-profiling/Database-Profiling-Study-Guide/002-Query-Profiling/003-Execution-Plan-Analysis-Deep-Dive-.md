This section is the core of database performance engineering. It moves beyond simply identifying *which* query is slow and focuses on the internal mechanics of *how* the database decided to execute that query.

Here is the detailed explanation of **Execution Plan Analysis**.

---

# 6. Execution Plan Analysis (Deep Dive)

## 6.1 Cost Model Understanding
The "Cost" is the unit of currency the database optimizer uses to compare different execution strategies. It is **not** a measurement of time (seconds), but an arbitrary unit representing resource consumption.

### 6.1.1 What cost represents
Cost is a combined score of estimated **I/O** (reading from disk), **CPU** (processing rows), and **Memory** usage. The optimizer calculates the cost for Plan A (e.g., Hash Join) and Plan B (e.g., Nested Loop) and picks the lowest number.

### 6.1.2 Cost formula components
*   **6.1.2.1 I/O cost:** Usually the heaviest weight. It distinguishes between **Sequential I/O** (cheap, effectively reading a continuous stream) and **Random I/O** (expensive, jumping around the disk platter or SSD pages).
*   **6.1.2.2 CPU cost:** The cost of processing a row (parsing, filtering, function execution).
*   **6.1.2.3 Network cost:** Relevant in distributed databases (like CockroachDB or Sharded MySQL). It estimates the latency of moving data between nodes.

### 6.1.3 Cost calibration
Database administrators can tweak these weights.
*   *Example:* If you move from HDD to ultra-fast NVMe SSDs, you might lower the "Random Page Cost" setting so the optimizer is less afraid of using Index Scans.

### 6.1.4 Cost model limitations
The model assumes a "clean environment." It does not know if the disk is currently busy with a backup job, nor does it account for data already being in the RAM cache (buffer pool). It estimates the *worst-case* cold start.

---

## 6.2 Cardinality Estimation
This is the single most important factor in query optimization. "Cardinality" is the estimated number of rows that will be returned by a specific operation.

### 6.2.1 Statistics and histograms
To guess row counts, the database maintains metadata about the data distribution.
*   **6.2.1.1 Column statistics:** Basic data like "Number of distinct values" (NDV) and "Number of nulls."
*   **6.2.1.2 Multi-column statistics:** Detecting correlation. (e.g., `City` is highly correlated with `State`). Without this, the DB might assume City and State are independent variables, leading to math errors.
*   **6.2.1.3 Histogram types:**
    *   **Equi-width:** Buckets cover equal ranges (e.g., A-M, N-Z). Bad if data is skewed (e.g., 99% of names start with 'S').
    *   **Equi-depth:** Buckets contain equal numbers of rows. This handles data skew much better.

### 6.2.2 Selectivity estimation
The percentage of rows a filter will keep.
*   *Query:* `SELECT * FROM users WHERE active = true`
*   If stats say 90% of users are active, selectivity is 0.9. The DB will likely choose a Full Table Scan.
*   If stats say 1% are active, selectivity is 0.01. The DB will choose an Index Scan.

### 6.2.3 Join cardinality estimation
Calculating how many rows will result from joining Table A and Table B. If underestimated, the query runs out of memory.

### 6.2.4 Estimation errors
*   **6.2.4.1 Causes:** Stale statistics (data changed but stats weren't updated), complex predicates (e.g., `WHERE price * tax > 100`—the DB can't guess the result of the math), or unknown parameters.
*   **6.2.4.2 Impact:** The optimizer chooses a **Nested Loop** (good for small data) for a massive dataset, causing the query to hang for hours.
*   **6.2.4.3 Detecting:** Compare "Estimated Rows" vs. "Actual Rows" in the query plan. A difference of order of magnitude (e.g., 10 vs 10,000) indicates a stats failure.

### 6.2.5 Statistics maintenance
*   **6.2.5.1 Manual:** Running `ANALYZE` (Postgres) or `UPDATE STATISTICS` (SQL Server) explicitly.
*   **6.2.5.2 Auto-statistics:** The DB triggers updates when a certain % of rows change (e.g., 10% of table modified).
*   **6.2.5.3 Statistics staleness:** The gap between the actual data state and the statistics map.

---

## 6.3 Join Analysis
How the database combines two sets of data.

### 6.3.1 Join algorithm selection
*   **6.3.1.1 Nested loop joins:**
    *   *Algorithm:* Take one row from Table A, loop through Table B to match.
    *   *When chosen:* One table is very small, or an index exists on the join column of the larger table.
*   **6.3.1.2 Hash joins:**
    *   *Algorithm:* Create a Hash Map of the smaller table in memory ("Build phase"), then scan the larger table and check the map ("Probe phase").
    *   *When chosen:* Large, unsorted datasets.
*   **6.3.1.3 Merge joins:**
    *   *Algorithm:* Sort both tables, then zipper them together.
    *   *When chosen:* Efficient if input data is already sorted (e.g., by an index).
*   **6.3.1.4 Index nested loop joins:** A specific variation where the inner loop uses an Index Lookup rather than a table scan. Extremely fast for high-selectivity lookups.

### 6.3.2 Join order optimization
*   **6.3.2.1 Search strategies:** The optimizer tries to reorder joins (`A join B join C` vs `A join C join B`) to filter out rows as early as possible.
*   **6.3.2.2 Join order hints:** Forcing a specific order using `STRAIGHT_JOIN` when the optimizer gets confused by complex schemas.

### 6.3.3 Join performance profiling
*   **6.3.3.1 Spill to disk:** If a Hash Join requires 1GB of RAM for the hash map but only 100MB is allocated (`work_mem`), the DB writes the map to disk (tempdb). This kills performance.
*   **6.3.3.2 Memory pressure:** Concurrent complex joins can exhaust server RAM, causing swapping.

---

## 6.4 Scan Analysis
How the database retrieves raw data from a single table.

### 6.4.1 Sequential scans (Table Scans)
*   **6.4.1.1 When optimal:** When reading a large portion (> 5-10%) of the table. It uses sequential I/O, which is faster per-block than random I/O.
*   **6.4.1.2 Parallel sequential scans:** Using multiple CPU threads to read different blocks of the same table simultaneously.

### 6.4.2 Index scans
*   **6.4.2.1 Selection criteria:** Chosen when retrieving a small sliver of data.
*   **6.4.2.2 Index-only scans:** The Holy Grail of performance. The query only asks for columns present in the index. The DB reads the index and *never* touches the heavy table files (heap).
*   **6.4.2.3 Index scan vs. bitmap scan:** Standard index scans jump back and forth between the index and the table (Random I/O).

### 6.4.3 Bitmap scans
A hybrid approach used by PostgreSQL and others.
1.  **Index Scan:** Go to index, find all matching Row IDs.
2.  **Bitmap Creation:** Create a bitmap of these IDs in memory and sort them physically.
3.  **Table Scan:** Read the table pages in physical order (Sequential I/O) using the map.
*   **6.4.3.2 Bitmap AND/OR:** Allows combining multiple indexes (e.g., use Index A for "Color=Red" and Index B for "Size=Small", combine bitmaps, *then* read the table).

### 6.4.4 Covering indexes
An index that "covers" the query (includes all `SELECT`, `JOIN`, and `WHERE` columns) allows for Index-Only scans.

---

## 6.5 Advanced Plan Analysis

### 6.5.1 Parallel query plans
*   **6.5.1.1 Decision factors:** The DB checks if the table is big enough to justify the overhead of launching multiple threads.
*   **6.5.1.2 Gather/scatter:** The "Leader" process must split the work (scatter) and merge the results (gather). If the merge is complex, parallelism might be slower than single-threaded execution.

### 6.5.2 Partitioned table plans
*   **6.5.2.1 Partition pruning:** The optimizer detects `WHERE year = 2024` and physically skips scanning the files for 2023, 2022, etc.
*   **6.5.2.2 Partition-wise joins:** If two tables are partitioned by the same key (e.g., CustomerID), the DB can join Partition A to Partition A independently, often in parallel.

### 6.5.3 Subplan and CTE (Common Table Expression) analysis
*   **Materialization:** The DB runs the CTE once, saves it to a temp buffer, and reads it multiple times.
*   **Inlining:** The DB treats the CTE like a macro, pasting the code into the main query. (Modern optimizers prefer inlining for better optimization).

### 6.5.4 Plan caching and reuse
*   **6.5.4.1 Plan cache hit rates:** We want the DB to compile a plan once and reuse it 1,000 times (saves CPU).
*   **6.5.4.2 Plan cache pollution:** If queries are not parameterized (e.g., `SELECT ... ID=1`, `SELECT ... ID=2`), every query counts as "new," filling the cache with junk and forcing re-compilation.
*   **6.5.4.3 Prepared statement plans:** Can lead to "Parameter Sniffing" issues where a cached plan for a small parameter is reused for a large parameter, causing poor performance.