Here is the comprehensive content for **Section 17: Index Usage Analysis**.

---

# 17. Index Usage Analysis

Creating an index is only the first step in performance tuning. To ensure a database operates efficiently, one must continuously profile how indexes are actually being used by the query optimizer. This section covers the metrics required to evaluate index utility, methods for identifying dead weight in the schema, and techniques for analyzing the efficiency of existing indexes.

## 17.1 Index Usage Metrics

Profiling tools and internal database statistics (such as `sys.dm_db_index_usage_stats` in SQL Server or `pg_stat_user_indexes` in PostgreSQL) provide vital metrics regarding how often and how effectively indexes are accessed.

-   **17.1.1 Index scan count:** This measures how often the database engine reads the index leaf nodes sequentially.
    -   **Interpretation:** A scan on a non-clustered index usually implies that the index covers the query (contains all necessary columns) but the sort order was not useful for the filter, or the filter was not selective enough. On a clustered index (or heap), a high scan count often equates to a full table scan, which is a primary target for optimization on large tables.
-   **17.1.2 Index seek count:** This measures how often the B-tree structure was traversed to find a specific key or range.
    -   **Interpretation:** This is generally the desired behavior for OLTP workloads. High seek counts indicate the index is effectively locating data without reading unnecessary pages.
-   **17.1.3 Index lookup count:** Also known as a "Key Lookup" or "Bookmark Lookup." This occurs when a non-clustered index is used to find a row, but the index does not contain all the columns requested by the query. The engine must "look up" the rest of the data in the clustered index or heap.
    -   **Interpretation:** High lookup counts can be performance killers. If the number of lookups is high, it often becomes faster for the optimizer to simply scan the whole table, ignoring the index entirely. This metric suggests a need for "Covering Indexes" (see 17.4.3).
-   **17.1.4 Rows returned via index:** This compares the number of rows scanned in the index versus the number of rows actually returned to the client.
    -   **Interpretation:** If an index scan reads 1,000,000 rows to return 10 rows, the index is inefficient (poor selectivity). Ideally, the number of rows scanned should be close to the number of rows returned.
-   **17.1.5 Index hit ratio:** The percentage of index pages found in the memory buffer pool versus those that had to be read from the disk.
    -   **Interpretation:** A low hit ratio on frequently used indexes indicates memory pressure; the "working set" of the index does not fit in RAM, causing latency due to physical I/O.

## 17.2 Unused Index Detection

Indexes incur a performance penalty on every write operation. Profiling must identify indexes that consume resources but provide no read benefit.

-   **17.2.1 Identifying never-used indexes:** By analyzing database uptime alongside index usage statistics, one can identify indexes with zero reads (seeks, scans, or lookups) over a significant period.
    -   **Action:** These are prime candidates for removal, provided the database has been up long enough to capture a full business cycle.
-   **17.2.2 Identifying rarely-used indexes:** Some indexes are used only once a month or once a year (e.g., for end-of-year financial reporting).
    -   **Risk:** Dropping these based on short-term profiling will cause massive performance regression during critical reporting windows. Profiling data must be persisted historically to identify these cyclic patterns.
-   **17.2.3 Write overhead of unused indexes:** Every `INSERT`, `UPDATE`, and `DELETE` on a table requires updating every index associated with that table.
    -   **Metric:** Compare the volume of index writes to index reads. An index with millions of updates and zero reads acts as a parasitic load on the I/O subsystem and transaction log.
-   **17.2.4 Safe index removal process:** "Scream testing" (deleting an index and waiting for complaints) is dangerous.
    -   **Best Practice:** Use "Invisible" or "Disabled" indexes (available in MySQL, PostgreSQL, Oracle). This makes the index unavailable to the optimizer but keeps the metadata and statistics intact. If performance degrades, the index can be instantly re-enabled without a costly rebuild.

## 17.3 Missing Index Analysis

Profiling is not just about analyzing what exists, but identifying what is absent.

-   **17.3.1 Query plan hints for missing indexes:** Execution plans often flag costly operators.
    -   **Signs:** Look for "Table Scan," "Clustered Index Scan," or specific warnings from the DBMS (e.g., SQL Server's "Missing Index" warning in XML plans) indicating that a query cost could be reduced by high percentages if an index existed.
-   **17.3.2 Missing index recommendations:** Many modern databases maintain internal lists of "virtual" indexes that the optimizer *wished* it had.
    -   **Profiling:** Querying these internal views (e.g., `sys.dm_db_missing_index_details`) provides a list of high-impact potential indexes, ranked by how much they would improve the overall workload cost.
-   **17.3.3 Workload-based index suggestions:** Rather than optimizing a single query, this approach analyzes a trace of the entire workload.
    -   **Context:** Adding an index to speed up Query A might slow down Query B (by locking resources) or Query C (by slowing down inserts). Holistic profiling tools (like Database Tuning Advisor) evaluate the net benefit across the total workload.
-   **17.3.4 Evaluating missing index impact:** Before creating a recommended index, profile the estimated size. A missing index recommendation that speeds up a query by 1% but consumes 500GB of disk space and slows down backups may not be worth implementing.

## 17.4 Index Efficiency Analysis

Even if an index is being used, it may be sub-optimal.

-   **17.4.1 Selectivity analysis:** Selectivity is the ratio of distinct values to total rows.
    -   **Profiling:** An index on a `Gender` column (low selectivity) is rarely useful for B-tree seeks because the database effectively retrieves 50% of the table. Profiling helps verify if column cardinality aligns with the chosen index type.
-   **17.4.2 Index column order impact:** For composite (multi-column) indexes, the order of columns is critical due to the **Leftmost Prefix Rule**.
    -   **Scenario:** An index on `(Last_Name, First_Name)` is useful for querying `Last_Name` or both, but useless for querying only `First_Name`. Profiling usage might reveal a composite index that is only ever utilized for its first column, suggesting the subsequent columns are dead weight or the query patterns have changed.
-   **17.4.3 Include columns effectiveness:** To solve the "Lookup" problem (17.1.3), non-key columns can be "included" in the leaf nodes of an index.
    -   **Analysis:** Check if high-frequency queries are effectively "covered" by existing indexes. If a query selects columns A, B, and C, but the index only has A and B, adding C as an included column can eliminate physical I/O to the heap.
-   **17.4.4 Index intersection usage:** If the optimizer chooses to use two separate indexes and combine the results (e.g., `Bitmap And`), it is often a sign that a single composite index would perform better.
    -   **Metric:** Look for "Index Intersection" or "Bitmap Heap Scan" in execution plans.
-   **17.4.5 Index skip scan patterns:** Some advanced optimizers (like Oracle or PostgreSQL 17+) can "skip" the first column of a composite index to search on the second.
    -   **Profiling:** While useful, skip scans are generally slower than a direct seek on a properly ordered index. Frequent skip scans suggest the index column order should be swapped or a new index created.

## 17.5 Index Maintenance Profiling

Indexes require care. The cost of this maintenance must be profiled against the maintenance windows.

-   **17.5.1 Index rebuild time:** Rebuilding an index drops the old structure and creates a new, defragmented one from scratch.
    -   **Profiling:** Measure the duration to ensure it fits within maintenance windows. Rebuilds generate massive transaction log volume, which can impact log shipping or replication lag.
-   **17.5.2 Index reorganization time:** This is a lighter-weight process that defragments leaf nodes in place.
    -   **Decision:** Profiling fragmentation levels helps decide between Rebuild (>30% fragmentation) vs. Reorganize (5-30% fragmentation).
-   **17.5.3 Online vs. offline maintenance:**
    -   **Impact:** Offline rebuilds hold exclusive locks, blocking all table access. Online rebuilds (Enterprise features) allow access but consume significantly more CPU and temporary space. Profiling server resource limits is crucial before triggering online operations.
-   **17.5.4 Index maintenance I/O impact:** Maintenance is I/O intensive.
    -   **Monitoring:** Ensure that maintenance jobs do not saturate disk throughput, which would starve other concurrent background processes (like backups) or latent user queries.
-   **17.5.5 Index statistics update frequency:** The optimizer relies on statistics (histograms) to choose indexes.
    -   **Profiling:** Monitor how often "auto-update stats" is triggered. If statistics are updated too frequently on large tables, it causes random performance dips. If too infrequently, query plans degrade. Profiling the "staleness" of statistics helps tune the update threshold.