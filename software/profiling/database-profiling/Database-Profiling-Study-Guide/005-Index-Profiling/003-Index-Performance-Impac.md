Here is the comprehensive content for **Section 18: Index Performance Impact**.

---

# 18. Index Performance Impact

While indexes are the primary tool for improving read performance, they are not without cost. Every index represents a trade-off: it consumes storage, memory, and CPU resources, and it imposes latency on data modification. Profiling the performance impact of an index requires a holistic view that balances the speed of retrieval against the overhead of maintenance and storage.

## 18.1 Index Read Performance

The primary purpose of an index is to reduce the I/O required to find data. Profiling read performance involves analyzing how efficiently the database engine utilizes index structures to satisfy queries.

### 18.1.1 Index scan efficiency
An index scan occurs when the database reads leaf pages of an index sequentially.
*   **Efficiency Metric:** Logical reads per row returned.
*   **Analysis:** A "Full Index Scan" can be efficient for aggregations (e.g., `SELECT SUM(salary)`), as the index is smaller than the table heap. However, if a scan reads 10,000 pages to find 5 records, it indicates poor selectivity or a missing predicate that could utilize an index seek.
*   **Fragmentation Impact:** In highly fragmented indexes, a scan requires random I/O rather than sequential I/O, significantly degrading performance.

### 18.1.2 Index-only scan coverage
This occurs when an index contains *all* the columns required by a query (SELECT clause, JOIN keys, WHERE clause).
*   **Performance Benefit:** The database reads the data directly from the B-tree structure without accessing the table heap/clustered index. This eliminates the second step of data retrieval.
*   **Profiling:** Execution plans explicitly label this as "Index Only Scan" (PostgreSQL) or imply it via the absence of lookups (SQL Server). It is often the single most effective optimization for high-frequency queries.

### 18.1.3 Key lookup overhead
When a non-clustered index is used to find a row, but the index does not contain all projected columns, the engine performs a "Key Lookup" to fetch the remaining data from the clustered index (Primary Key).
*   **Cost:** Each lookup is a random I/O operation.
*   **The Tipping Point:** Profiling often reveals a "tipping point" where the optimizer abandons the index in favor of a full table scan. This happens when the cost of N random lookups exceeds the cost of sequentially scanning the entire table (typically when retrieving >5-10% of rows).

### 18.1.4 Bookmark lookup analysis
Similar to Key Lookups, but specific to heaps (tables without a clustered index). The non-clustered index contains a Row Identifier (RID) pointing to a physical file/page/slot location.
*   **Volatility:** If the row moves (e.g., due to an update increasing row size), the RID changes, requiring updates to *all* non-clustered indexes.
*   **Profiling:** High bookmark lookup costs usually suggest that the table should be converted to a clustered index organization or that the non-clustered index needs `INCLUDE` columns to cover the query.

### 18.1.5 Index caching effectiveness
Indexes are most effective when they reside in RAM (Buffer Pool).
*   **Metric:** Buffer Cache Hit Ratio specifically for index pages.
*   **Analysis:** If the index is larger than available memory, the OS must swap pages in and out of disk (thrashing). Profiling I/O wait times specifically on index files helps identify when memory upgrades or index partitioning is required.

## 18.2 Index Write Overhead

There is no such thing as a free write. Every `INSERT`, `UPDATE`, or `DELETE` requires maintaining the index structures.

### 18.2.1 Insert overhead per index
For every row inserted into a table, an entry must be inserted into *every* active non-clustered index.
*   **Linear Scaling:** If a table has 10 indexes, a single SQL `INSERT` results in 11 write operations (1 heap + 10 indexes).
*   **Profiling:** High "Log Flush Wait" or "Write Latency" during bulk loads often indicates too many indexes. Dropping indexes before bulk loads and rebuilding them afterward is a common optimization pattern.

### 18.2.2 Update overhead analysis
*   **Non-Indexed Columns:** Updating a column that is not part of any index is cheap (in-place update in the heap).
*   **Indexed Columns:** Updating a column that is a key in an index requires a "delete" of the old key and an "insert" of the new key within the B-tree. This is significantly more expensive and generates more transaction log volume.

### 18.2.3 Delete overhead and ghost records
Database engines rarely physically remove data immediately upon deletion.
*   **Ghost Records:** The row is marked as "dead" (ghosted). A background process (Ghost Cleanup task in SQL Server, Vacuum in PostgreSQL) physically reclaims the space later.
*   **Profiling Impact:** A table with heavy deletes may appear bloated. Scans effectively read "empty" space until the cleanup process runs, degrading read performance.

### 18.2.4 Index page splits
When a new row is inserted into a B-tree page that is already full, the engine must split the page into two, move half the data, and update the parent pointers.
*   **18.2.4.1 Page split frequency:** Measured via performance counters (e.g., `Page Splits/sec`). High frequency indicates a mismatch between the fill factor and the insert pattern (e.g., inserting random GUIDs).
*   **18.2.4.2 Page split impact:** Splits are I/O intensive and cause "internal fragmentation," leaving pages partially empty. They also require exclusive latches, blocking other reads/writes to that page.
*   **18.2.4.3 Fill factor tuning:** Lowering the fill factor (e.g., to 80%) leaves 20% free space on leaf pages, allowing updates/inserts without immediate splits. This reduces write latency but increases the storage footprint and reduces read density.

### 18.2.5 Index locking during writes
To maintain structural integrity, the database takes latches (lightweight locks) on index pages during modification.
*   **Hotspots:** Profiling often reveals latch contention on the "last page" of an index when multiple threads insert sequentially increasing keys (like `IDENTITY` or `Serial`) simultaneously. This serialization point limits write throughput.

## 18.3 Index Memory Impact

Indexes compete with data pages and execution plans for limited memory resources.

### 18.3.1 Index buffer pool usage
*   **Analysis:** Determine what percentage of the buffer pool is consumed by indexes vs. data.
*   **Bloat:** Unused or duplicate indexes waste RAM that could be used to cache active data, indirectly slowing down the entire system.

### 18.3.2 Index cache hit rates
*   **Metric:** The ratio of logical reads (RAM) to physical reads (Disk) for index pages.
*   **Goal:** Should be near 100% for high-performance OLTP. Consistent dips indicate the "working set" of the indexes exceeds physical memory.

### 18.3.3 Index memory pressure
When the database is under memory pressure, it evicts the "Least Recently Used" (LRU) pages.
*   **Scenario:** A large reporting query scans a massive, rarely used index, flushing hot OLTP index pages out of the cache.
*   **Symptom:** "Page Life Expectancy" drops, and I/O spikes immediately following the large query.

### 18.3.4 Index preloading/warming
After a restart, the buffer pool is cold.
*   **Technique:** Explicitly running queries or using utilities (like `pg_prewarm` in PostgreSQL) to load critical index root and branch nodes into RAM before opening traffic to users prevents the initial performance slump.

## 18.4 Index and Query Optimization

Profiling data drives the strategy for index architecture.

### 18.4.1 Composite index design
*   **Column Order:** The order of columns in a composite index defines its utility. An index on `(LastName, FirstName)` supports queries on `LastName` but *not* queries on `FirstName` alone.
*   **Selectivity Rule:** Generally, place the most selective (highest cardinality) column first to narrow down the search range as quickly as possible.

### 18.4.2 Index consolidation opportunities
*   **Merging:** If Index A is on `(Col1)` and Index B is on `(Col1, Col2)`, Index A is redundant. Index B can satisfy queries for both.
*   **Trade-off:** Consolidation reduces write overhead and saves space, but may slightly increase read cost for queries only needing `Col1` (as Index B is wider).

### 18.4.3 Index hints and forcing
Developers can force the optimizer to use a specific index.
*   **Risk:** While useful for fixing immediate regressions, hints make the application brittle. If data distribution changes, the forced index might become a terrible choice, but the optimizer is forbidden from changing the plan.

### 18.4.4 Index anti-patterns
Profiling helps identify common design mistakes:
*   **18.4.4.1 Over-indexing:** Every column has an index. Result: Extremely slow inserts/updates and confusing choices for the optimizer.
*   **18.4.4.2 Redundant indexes:** Identical indexes created with different names, or indexes that are strict prefixes of other indexes.
*   **18.4.4.3 Wide indexes misuse:** Including large text fields (`VARCHAR(MAX)`, `TEXT`) in the index key. This creates massive B-trees with very low density, destroying cache efficiency.
*   **18.4.4.4 Wrong column order:** Placing a low-selectivity column (e.g., `Boolean IsActive`) as the first column of a composite index. This forces the engine to scan half the index to find specific values.