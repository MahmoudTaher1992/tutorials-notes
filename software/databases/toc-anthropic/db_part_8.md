# Databases Complete Study Guide - Part 8: NewSQL, In-Memory & OLAP

## 16.0 NewSQL & Distributed SQL

### 16.1 Distributed SQL Architecture
#### 16.1.1 Shared-Nothing Architecture
- 16.1.1.1 Horizontal scaling — add nodes — no shared memory or disk — fully partitioned
  - 16.1.1.1.1 Range-based table partitioning — each node owns key range — automatic rebalancing
  - 16.1.1.1.2 Distributed transactions — cross-shard atomicity via consensus — Raft per range
- 16.1.1.2 SQL layer separation — stateless SQL routers — separate from storage nodes
  - 16.1.1.2.1 Query pushdown — filter/aggregate pushed to storage nodes — reduce data transfer
  - 16.1.1.2.2 Distributed joins — co-located join (same shard key) vs. broadcast join vs. hash shuffle

#### 16.1.2 Consensus-Based Replication
- 16.1.2.1 Raft per shard group — leader accepts writes — replicates to majority — commits
  - 16.1.2.1.1 Multi-Raft — each range has own Raft group — independent progress — CockroachDB
  - 16.1.2.1.2 Paxos variants — Spanner uses Paxos per shard — GPS/atomic clock timestamps
- 16.1.2.2 Leader lease — time-based lease — stale read without round-trip — TiDB
  - 16.1.2.2.1 Follower reads — read from follower at safe timestamp — reduces leader load

### 16.2 Distributed Transactions
#### 16.2.1 Timestamp Ordering
- 16.2.1.1 Hybrid Logical Clocks (HLC) — physical + logical — causally consistent timestamps
  - 16.2.1.1.1 HLC on each node — max(physical, received) + counter — monotone + close to wall
  - 16.2.1.1.2 CockroachDB uses HLC — transaction timestamps — serializable ordering
- 16.2.1.2 TrueTime (Spanner) — GPS + atomic clocks — bounded clock uncertainty
  - 16.2.1.2.1 Commit wait — wait out uncertainty interval — external consistency guaranteed
  - 16.2.1.2.2 Uncertainty interval — ε typically <7ms — wait before returning commit

#### 16.2.2 Serializable Distributed Transactions
- 16.2.2.1 2PC over Raft — coordinator proposes to all participants — majority acks
  - 16.2.2.1.1 Parallel commits — CockroachDB — finalize async — reduce 2PC latency
  - 16.2.2.1.2 Transaction record — coordinator writes intent + txn record — recovery on crash
- 16.2.2.2 Pessimistic vs optimistic distributed txns
  - 16.2.2.2.1 Optimistic — buffer writes — validate at commit — TiDB default for short txns
  - 16.2.2.2.2 Pessimistic — lock on read — MySQL compatible — avoid conflict retries

---

## 17.0 In-Memory Databases

### 17.1 In-Memory Architecture
#### 17.1.1 Memory-Optimized Storage
- 17.1.1.1 All data in DRAM — no buffer pool — direct pointer access — nanosecond latency
  - 17.1.1.1.1 Lock-free data structures — concurrent access without mutexes — higher throughput
  - 17.1.1.1.2 Cache-line alignment — 64-byte alignment — avoid false sharing — NUMA aware
- 17.1.1.2 Durability options — pure in-memory / snapshot / persistent WAL
  - 17.1.1.2.1 Snapshot to disk — periodic checkpoint — Redis RDB — fast restart
  - 17.1.1.2.2 Append-only file (AOF) — log every command — Redis AOF — higher durability
  - 17.1.1.2.3 Group commit WAL — batch fsync — VoltDB / H-Store — low write amplification

#### 17.1.2 Memory Management
- 17.1.2.1 Custom memory allocator — jemalloc / tcmalloc — reduce fragmentation + GC pauses
  - 17.1.2.1.1 Slab allocator — fixed-size object pools — zero fragmentation for uniform objects
  - 17.1.2.1.2 Arena allocator — per-transaction memory — bulk free on commit/abort
- 17.1.2.2 Memory capacity limits — data must fit in RAM — overflow handling
  - 17.1.2.2.1 Eviction to disk — Redis with RDB swap — transparent overflow to SSD
  - 17.1.2.2.2 Tiered memory — Intel Optane PMEM — persistent memory tier — byte-addressable

### 17.2 HTAP (Hybrid Transaction/Analytical Processing)
#### 17.2.1 Combined OLTP + OLAP
- 17.2.1.1 Row store for OLTP + columnar replica for OLAP — same data — dual format
  - 17.2.1.1.1 Delta store — new rows in row format — merged periodically into column store
  - 17.2.1.1.2 SAP HANA — in-memory row + column — automatic routing by query type
- 17.2.1.2 TiFlash (TiDB) — columnar replica — async replication from row store — Raft
  - 17.2.1.2.1 Learner role — replica receives raft log — no voting — zero OLTP impact

---

## 18.0 OLAP & Data Warehouses

### 18.1 MPP Architecture
#### 18.1.1 Massively Parallel Processing
- 18.1.1.1 Shared-nothing MPP — each node has CPU + memory + disk — no contention
  - 18.1.1.1.1 Query coordinator — parse + plan — distribute work — gather results
  - 18.1.1.1.2 Compute nodes — execute fragment — return partial aggregates — parallel
- 18.1.1.2 Data distribution methods — hash / round-robin / replicated
  - 18.1.1.2.1 Hash distribution key — collocate joined tables — avoid data shuffle
  - 18.1.1.2.2 Broadcast small table — replicate dimension table — local join on fact

#### 18.1.2 Query Execution in MPP
- 18.1.2.1 Pipeline fragments — break query into stages — exchange operators between stages
  - 18.1.2.1.1 Gather exchange — many-to-one — consolidate at coordinator — final sort/limit
  - 18.1.2.1.2 Repartition exchange — shuffle by new key — redistribute for next join
- 18.1.2.2 Vectorized execution — columnar batches — SIMD accelerated — DuckDB / ClickHouse
  - 18.1.2.2.1 Late materialization — process column references lazily — avoid unnecessary reads
  - 18.1.2.2.2 Code generation (codegen) — LLVM JIT — eliminate interpreter overhead — Spark

### 18.2 Columnar Storage Formats
#### 18.2.1 Parquet
- 18.2.1.1 Row groups — horizontal partitions — ~128MB — independent encoding per column chunk
  - 18.2.1.1.1 Column chunk → pages — data + dictionary + index pages — compressed independently
  - 18.2.1.1.2 Page index — min/max + bloom filter — skip row groups — predicate pushdown
- 18.2.1.2 Encoding types — dictionary / RLE / bit-packing / delta — per column type
  - 18.2.1.2.1 Dictionary encoding — map distinct values to integers — low cardinality optimal
  - 18.2.1.2.2 RLE_DICTIONARY — run-length encode dictionary IDs — sorted columns compress best

#### 18.2.2 ORC & Arrow
- 18.2.2.1 ORC — Optimistic Row Columnar — Hive — stripe-based — predicate pushdown + bloom
  - 18.2.2.1.1 ACID ORC — Hive transactions — delta files — compaction — row-level updates
- 18.2.2.2 Apache Arrow — in-memory columnar format — zero-copy IPC — language-agnostic
  - 18.2.2.2.1 Arrow Flight — gRPC-based data transport — push Arrow batches over network

### 18.3 Star & Snowflake Schema
#### 18.3.1 Dimensional Modeling
- 18.3.1.1 Fact table — measures + foreign keys — large — append-only — grain = one event
  - 18.3.1.1.1 Additive facts — can SUM across all dimensions — sales amount
  - 18.3.1.1.2 Semi-additive — SUM valid for some dims — account balance (not time)
  - 18.3.1.1.3 Non-additive — ratios / percentages — cannot SUM — compute from components
- 18.3.1.2 Dimension table — descriptive attributes — slowly changing — smaller
  - 18.3.1.2.1 SCD Type 1 — overwrite — no history — simple but loses past values
  - 18.3.1.2.2 SCD Type 2 — new row per change — surrogate key — full history — common
  - 18.3.1.2.3 SCD Type 3 — add column for previous value — limited history — rarely used
- 18.3.1.3 Snowflake schema — normalize dimension tables — reduce redundancy — more joins
  - 18.3.1.3.1 Star preferred for OLAP — fewer joins — faster query — denormalize dimensions
