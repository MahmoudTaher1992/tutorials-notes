Here is the comprehensive content for **Section 16: Index Fundamentals for Profiling**.

---

# 16. Index Fundamentals for Profiling

Profiling database performance inevitably leads to the study of indexes. An index is a data structure that improves the speed of data retrieval operations on a database table at the cost of additional writes and storage space. To effectively profile and optimize queries, one must understand not just *that* an index exists, but *how* it is structured, the algorithmic complexity of its operations, and how its physical health impacts I/O and CPU usage.

## 16.1 Index Types Overview

Different access patterns require different data structures. Profiling a query involves verifying that the optimizer has chosen the correct index type for the specific predicate (filter condition) being executed.

### 16.1.1 B-tree Indexes
The B-tree (Balanced Tree) is the default and most common index type in relational databases. It is designed to keep data sorted and allow searches, sequential access, insertions, and deletions in logarithmic time.

*   **16.1.1.1 Structure and characteristics:**
    *   **Hierarchical Structure:** Consists of a root node, intermediate (branch) nodes, and leaf nodes.
    *   **Balanced:** The tree self-balances, ensuring that the path from the root to any leaf node is roughly the same length. This guarantees predictable performance regardless of data insertion order.
    *   **Doubly Linked Leaves:** Leaf nodes are linked forward and backward, enabling efficient range scans (e.g., finding values between X and Y).
*   **16.1.1.2 Best use cases:**
    *   **Equality matches:** `WHERE id = 5`
    *   **Range queries:** `WHERE date > '2023-01-01'` (due to the sorted nature of the tree).
    *   **Sorting:** `ORDER BY date` (the database can read the index in order rather than sorting in memory).
    *   **Prefix matching:** `WHERE name LIKE 'Smith%'` (using the leftmost prefix of the key).

### 16.1.2 Hash Indexes
Hash indexes are based on a hash table data structure. They calculate a hash code for the key and map it to a bucket containing pointers to the row data.

*   **16.1.2.1 Structure and characteristics:**
    *   **Flat Structure:** Unlike B-trees, there is no hierarchy or ordering.
    *   **O(1) Access:** Theoretically provides constant-time access regardless of table size.
    *   **Memory Footprint:** Often more compact than B-trees.
*   **16.1.2.2 Limitations:**
    *   **Equality Only:** Can *only* be used for exact matches (`=`, `IN`). They cannot support range queries (`>`, `<`) because hash codes do not preserve the ordering of data.
    *   **No Sorting:** Cannot be used to optimize `ORDER BY` operations.
    *   **Collisions:** In high-concurrency environments with poor hash functions, collisions (multiple keys hashing to the same bucket) can degrade performance to linear time $O(n)$.

### 16.1.3 Bitmap Indexes
Bitmap indexes use bit arrays (sequences of 0s and 1s) to represent the presence or absence of a value.

*   **16.1.3.1 Low cardinality optimization:**
    *   Ideal for columns with few distinct values (low cardinality), such as `gender`, `status`, or `is_active`.
    *   Instead of storing a large value for every row, the index stores a bit; `1` implies the row contains the value, `0` implies it does not.
*   **16.1.3.2 Bitmap operations:**
    *   **Bitwise Efficiency:** Databases can perform extremely fast bitwise `AND`, `OR`, and `NOT` operations to combine multiple filters (e.g., `WHERE status='active' AND region='north'`).
    *   **Concurrency Issues:** Bitmap indexes generally suffer from high locking overhead during updates. Modifying a single bit often requires locking a larger section of the bitmap, potentially blocking updates to other rows. They are best suited for read-heavy Data Warehousing (OLAP) environments, not high-throughput OLTP.

### 16.1.4 Full-text Indexes
Standard B-trees are inefficient for searching for words *within* text fields. Full-text indexes are specialized structures for this purpose.

*   **16.1.4.1 Inverted index structure:**
    *   The core structure is an **inverted index**, which maps a term (word) to a list of document IDs (or row IDs) where that term appears.
    *   It is similar to the index at the back of a book.
*   **16.1.4.2 Text search profiling:**
    *   **Tokenization Overhead:** Profiling writes to full-text indexes must account for the CPU cost of analyzing text, removing stop words (e.g., "the", "and"), and stemming (reducing "running" to "run").
    *   **Result Set Size:** Queries can return massive result sets if searching for common terms, impacting I/O and memory.

### 16.1.5 Spatial Indexes (R-tree, GiST)
Used for geospatial data (coordinates, polygons).
*   **R-tree:** Organizes data using Minimum Bounding Rectangles (MBRs). A search query drills down through overlapping rectangles to find points of interest.
*   **GiST (Generalized Search Tree):** An extensible data structure (popular in PostgreSQL) that acts as a template for implementing custom indexing schemes, including R-trees and full-text search.

### 16.1.6 Specialized Indexes
Profiling often reveals that generic indexes are insufficient. Specialized configurations can optimize specific bottlenecks.

*   **16.1.6.1 Partial indexes:** An index that includes entries only for rows that satisfy a specific condition (e.g., `WHERE status = 'unprocessed'`). This reduces index size and maintenance cost, making it perfect for queuing workflows.
*   **16.1.6.2 Expression indexes:** Also known as function-based indexes. They index the result of a function applied to a column (e.g., `UPPER(last_name)`). Without this, a query like `WHERE UPPER(last_name) = 'SMITH'` cannot use a standard index on `last_name` because the function transforms the data.
*   **16.1.6.3 Covering indexes:** An index that contains *all* the columns required by a query (both filters and selected columns). This allows the database to perform an **Index Only Scan**, satisfying the query purely from the index structure without ever looking up the actual table heap, drastically reducing I/O.
*   **16.1.6.4 Filtered indexes:** (Synonymous with Partial Indexes in some RDBMS terminologies like SQL Server).
*   **16.1.6.5 Clustered vs. non-clustered:**
    *   **Clustered:** The leaf nodes of the index *are* the actual data pages of the table. The table rows are physically stored in the index order. A table can have only one clustered index (usually the Primary Key).
    *   **Non-clustered:** The leaf nodes contain pointers (Row IDs) to the actual data location in the heap or clustered index. A table can have many non-clustered indexes. Profiling non-clustered indexes often involves measuring "Lookups" or "Bookmark Lookups," which represent the cost of jumping from the index to the data.

## 16.2 Index Structure Profiling

An index is not a static entity; it degrades over time as data is inserted, updated, and deleted. Profiling the physical health of an index is necessary to maintain performance.

### 16.2.1 Index depth/height
The number of levels in the B-tree from root to leaf.
*   **Profiling Impact:** A deeper tree requires more I/O operations (pages read) to traverse from the root to the target data.
*   **Typical values:** Most efficient B-trees have a depth of 3 or 4. If depth increases to 5 or 6, it may indicate improper index key selection (keys are too wide) or extreme fragmentation.

### 16.2.2 Index size (pages/blocks)
The total disk space consumed by the index.
*   **Profiling Impact:** Large indexes pollute the buffer pool (RAM cache). If an index is larger than the available RAM, the database must constantly swap index pages in and out of disk, causing "thrashing" and severe latency.

### 16.2.3 Index density
A measure of how much useful data is stored per page compared to metadata overhead. Higher density means fewer pages are needed to store the same amount of keys, resulting in fewer I/Os during scans.

### 16.2.4 Leaf page fill factor
A configuration setting (usually a percentage, e.g., 80%) that dictates how full a leaf page should be filled during index creation.
*   **Profiling Impact:**
    *   **High Fill Factor (100%):** Best for read-only data. Maximizes data density and minimizes size.
    *   **Lower Fill Factor (70-80%):** Leaves free space on pages for future inserts/updates. This minimizes **Page Splits** (an expensive operation where the database must split a full page into two to accommodate new data).

### 16.2.5 Index fragmentation
Fragmentation occurs when the logical order of the index does not match the physical storage, or when space is wasted.

*   **16.2.5.1 Internal fragmentation:** Occurs when pages have a significant amount of empty space (low fill factor) due to random deletes or page splits.
    *   *Symptom:* The index is much larger than necessary, wasting RAM and disk space.
*   **16.2.5.2 External fragmentation:** Occurs when the logical order of pages (page 1 -> page 2 -> page 3) does not match the physical order on the disk (page 1 is at sector 100, page 2 is at sector 5000).
    *   *Symptom:* Inhibits the OS and storage system's ability to perform efficient sequential read-ahead operations, forcing disk heads to seek randomly during range scans.
*   **16.2.5.3 Logical fragmentation:** Occurs when out-of-order inserts prevent the new keys from being appended to the end of the index, forcing them to be inserted into the middle. This disrupts the physical ordering of the data on disk relative to the index key order.