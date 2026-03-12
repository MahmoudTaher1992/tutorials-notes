# Databases Complete Study Guide - Part 4: Indexing & Query Processing

## 5.0 Indexing

### 5.1 B-Tree Indexes
#### 5.1.1 Clustered vs. Non-Clustered
- 5.1.1.1 Clustered index — data rows stored in index leaf order — one per table
  - 5.1.1.1.1 InnoDB — PK is clustered index — secondary indexes store PK value
  - 5.1.1.1.2 Insert order — sequential PK = efficient — random UUID = page splits
  - 5.1.1.1.3 Range scan — clustered = sequential I/O — efficient — good for range predicates
- 5.1.1.2 Non-clustered (secondary) index — separate structure — contains key + row pointer
  - 5.1.1.2.1 Heap pointer — (page_id, slot) — fetch actual row after index lookup
  - 5.1.1.2.2 Index scan + heap fetch — 2 I/Os per row — random I/O pattern
  - 5.1.1.2.3 InnoDB secondary — stores PK — double lookup via PK clustered index

#### 5.1.2 Covering Indexes
- 5.1.2.1 Index contains all needed columns — no heap fetch — index-only scan
  - 5.1.2.1.1 INCLUDE columns — non-key columns in leaf — no ordering constraint
  - 5.1.2.1.2 Query matches covering index — zero table accesses — fastest possible
- 5.1.2.2 Visibility map — PostgreSQL — track all-visible pages — avoid heap fetch for frozen

### 5.2 Composite Indexes
#### 5.2.1 Column Order Rules
- 5.2.1.1 Leftmost prefix rule — index (A, B, C) — usable for (A), (A,B), (A,B,C)
  - 5.2.1.1.1 Column B predicate alone — cannot use index — full scan
  - 5.2.1.1.2 Equality then range — put equality columns first — (status, created_at)
- 5.2.1.2 Cardinality considerations — high cardinality first — better selectivity
  - 5.2.1.2.1 Exception — equality filter on low cardinality — leads range traversal

### 5.3 Partial & Functional Indexes
#### 5.3.1 Partial Indexes
- 5.3.1.1 WHERE clause in index definition — index only matching rows — smaller index
  - 5.3.1.1.1 CREATE INDEX ON orders(id) WHERE status = 'pending' — active only
  - 5.3.1.1.2 Use case — soft delete — WHERE deleted_at IS NULL — most queries hit
- 5.3.1.2 Functional / Expression indexes — index on expression — computed value
  - 5.3.1.2.1 LOWER(email) — case-insensitive search — must use same expression in query
  - 5.3.1.2.2 date_trunc('day', created_at) — group by day — match expression exactly

### 5.4 Full-Text Indexes (Inverted Index)
#### 5.4.1 Inverted Index Structure
- 5.4.1.1 Token → posting list — word to list of documents containing it
  - 5.4.1.1.1 Tokenization — split text into terms — lowercasing + stemming + stop words
  - 5.4.1.1.2 Posting list — document IDs + positions + frequency — sorted by doc ID
  - 5.4.1.1.3 Delta encoding — store doc ID differences — compresses large posting lists
- 5.4.1.2 tsvector (PostgreSQL) — preprocessed document — weighted lexemes
  - 5.4.1.2.1 to_tsvector('english', text) — apply dictionary — normalize terms
  - 5.4.1.2.2 GIN index on tsvector — fast lookup — suitable for document search

### 5.5 Vector Indexes
#### 5.5.1 HNSW (Hierarchical Navigable Small World)
- 5.5.1.1 Multi-layer graph — entry point at top — navigate down layers — approx nearest
  - 5.5.1.1.1 Layer 0 — all nodes — dense connections — fine-grained search
  - 5.5.1.1.2 Upper layers — long-range connections — coarse navigation — start here
  - 5.5.1.1.3 Greedy search — move to neighbor closer to query — per layer — then descend
- 5.5.1.2 Build parameters — M (connections per node) — ef_construction (build quality)
  - 5.5.1.2.1 Higher M — better recall — more memory — slower build
  - 5.5.1.2.2 ef_search — runtime tradeoff — higher = better recall + slower query

#### 5.5.2 IVF (Inverted File Index)
- 5.5.2.1 K-means cluster centroids — assign vectors to nearest cluster — probe N clusters
  - 5.5.2.1.1 nlist — number of clusters — tradeoff: more clusters = faster but lower recall
  - 5.5.2.1.2 nprobe — clusters to search at query time — higher = better recall + slower
- 5.5.2.2 Product Quantization (PQ) — compress vectors — sub-vector codebooks
  - 5.5.2.2.1 IVF+PQ — combines clustering + compression — billion-scale search
  - 5.5.2.2.2 Quantization error — lossy — recall degrades — tune by dataset

### 5.6 Index Internals & Maintenance
#### 5.6.1 Index Bloat & Fill Factor
- 5.6.1.1 Fill factor — % of page to fill on initial write — leave space for updates
  - 5.6.1.1.1 Default 90% — 10% free — reduces page splits on updates — hot indexes
  - 5.6.1.1.2 Read-only index — 100% fill factor — maximum density — no updates
- 5.6.1.2 Index bloat — deleted rows leave dead entries — vacuum reclaims in PostgreSQL
  - 5.6.1.2.1 REINDEX CONCURRENTLY — rebuild without lock — PostgreSQL 12+
  - 5.6.1.2.2 Online DDL — pt-online-schema-change — MySQL — rebuild with triggers

---

## 6.0 Query Processing

### 6.1 Query Planner & Cost Model
#### 6.1.1 Query Optimization Pipeline
- 6.1.1.1 Parsing — SQL text → AST — syntax validation
- 6.1.1.2 Semantic analysis — resolve names — check permissions — type inference
- 6.1.1.3 Rewriting — apply transformation rules — view expansion — predicate simplification
- 6.1.1.4 Plan enumeration — generate candidate plans — join ordering — index choices
  - 6.1.1.4.1 Dynamic programming — optimal join order — consider all subsets — exponential
  - 6.1.1.4.2 Genetic algorithm — PostgreSQL — large join counts — geqo_threshold
- 6.1.1.5 Cost estimation — estimate I/O + CPU + network cost per plan
  - 6.1.1.5.1 Statistics — pg_statistic — histogram + MCV + null fraction — selectivity
  - 6.1.1.5.2 Row estimate error — stale stats → bad plan → ANALYZE to refresh
  - 6.1.1.5.3 Cost units — seq_page_cost=1.0 / random_page_cost=4.0 — tunable

### 6.2 Join Algorithms
#### 6.2.1 Nested Loop Join
- 6.2.1.1 For each outer row — scan inner relation — find matches — O(N×M)
  - 6.2.1.1.1 Index nested loop — inner has index — O(N log M) — efficient for small outer
  - 6.2.1.1.2 Batched NLJ — buffer outer rows — reduce inner index lookups — MySQL BKA

#### 6.2.2 Hash Join
- 6.2.2.1 Build phase — hash smaller relation into hash table — in memory
  - 6.2.2.1.1 Hash function — map join key → bucket — uniform distribution ideal
  - 6.2.2.1.2 Grace hash join — partition both sides — handle larger-than-memory
- 6.2.2.2 Probe phase — scan larger relation — probe hash table — O(N+M)
  - 6.2.2.2.1 Best for large unsorted inputs — parallelizable — OLAP joins

#### 6.2.3 Sort-Merge Join
- 6.2.3.1 Sort both inputs on join key — merge sorted streams — O(N log N + M log M)
  - 6.2.3.1.1 Pre-sorted input — already indexed or sorted — merge only — very fast
  - 6.2.3.1.2 External merge sort — when data > memory — multi-pass — sorted runs

### 6.3 Execution Engine
#### 6.3.1 Volcano / Iterator Model
- 6.3.1.1 Pull model — parent calls next() on child — row at a time — simple
  - 6.3.1.1.1 High function call overhead — one row per call — CPU inefficient
- 6.3.1.2 Vectorized execution — return batch of rows (vector) per next() call
  - 6.3.1.2.1 DuckDB / ClickHouse / Snowflake — SIMD on vector — 10–100x faster OLAP

#### 6.3.2 Parallel Query Execution
- 6.3.2.1 Intra-query parallelism — single query uses multiple workers — parallel scan
  - 6.3.2.1.1 Parallel seq scan — workers split heap pages — PostgreSQL parallel workers
  - 6.3.2.1.2 Parallel hash join — each worker builds partial hash table — merge
- 6.3.2.2 Exchange operator — shuffle data between workers — repartition by join key
