# Databases Complete Study Guide - Part 2: WAL, Buffer Pool & Row/Columnar Storage

## 2.3 Write-Ahead Log (WAL) & Crash Recovery

### 2.3.1 WAL Architecture
#### 2.3.1.1 WAL Fundamentals
- 2.3.1.1.1 Log before data — write WAL record before modifying page — durability guarantee
  - 2.3.1.1.1.1 WAL record — LSN + transaction ID + before-image + after-image
  - 2.3.1.1.1.2 LSN — Log Sequence Number — monotonically increasing — 64-bit integer
- 2.3.1.1.2 Force log before commit — flush WAL to disk before ack — durability
  - 2.3.1.1.2.1 Group commit — batch multiple txn WAL flushes — reduces fsync cost
  - 2.3.1.1.2.2 fsync — OS ensures data on durable storage — expensive — ~1ms
- 2.3.1.1.3 WAL segments — fixed-size files — rotate when full — archive or delete
  - 2.3.1.1.3.1 Segment size — 16MB PostgreSQL default — tunable for workload
  - 2.3.1.1.4 WAL archiving — ship WAL to standby / object storage — PITR + replication

#### 2.3.1.2 Crash Recovery (ARIES Algorithm)
- 2.3.1.2.1 Analysis phase — scan WAL from last checkpoint — identify dirty pages + active txns
  - 2.3.1.2.1.1 Checkpoint — flush dirty pages + write checkpoint record — bound recovery
  - 2.3.1.2.1.2 Dirty page table — pages modified but not flushed — need redo
- 2.3.1.2.2 Redo phase — replay all WAL from checkpoint forward — reapply all changes
  - 2.3.1.2.2.1 Redo even uncommitted txns — restore state at crash — then undo
- 2.3.1.2.3 Undo phase — reverse uncommitted transactions — restore consistency
  - 2.3.1.2.3.1 CLR — Compensation Log Record — logged during undo — idempotent recovery
- 2.3.1.2.4 Physiological logging — page-level + logical within page — compact + recoverable
  - 2.3.1.2.4.1 Logical logging — high-level ops — compact — hard to redo partially
  - 2.3.1.2.4.2 Physical logging — byte-level changes — large — fully recoverable

### 2.3.2 Checkpointing Strategies
- 2.3.2.1 Sharp checkpoint — flush all dirty pages — pause writes — simple — long stall
- 2.3.2.2 Fuzzy checkpoint — background flush — no stall — longer recovery window
  - 2.3.2.2.1 PostgreSQL checkpoint — max_wal_size — checkpoint_completion_target — spread I/O
- 2.3.2.3 Checkpoint frequency tradeoffs — frequent = faster recovery + more I/O — balance

---

## 2.4 Buffer Pool & Page Management

### 2.4.1 Buffer Pool Architecture
#### 2.4.1.1 Buffer Pool Structure
- 2.4.1.1.1 Page table — in-memory hash — page ID → frame — locate cached page
  - 2.4.1.1.1.1 Frame — buffer pool slot — holds one disk page — dirty flag + pin count
  - 2.4.1.1.1.2 Pin count — reference count — pinned page not evicted — safe access
- 2.4.1.1.2 Page size — 4KB (PostgreSQL) / 16KB (MySQL InnoDB) — matches OS page
  - 2.4.1.1.2.1 Larger pages — fewer I/Os for large rows — but more wasted space
- 2.4.1.1.3 Buffer pool size — most important tuning parameter — 70–80% of RAM typical
  - 2.4.1.1.3.1 Working set — hot pages — must fit in buffer pool — monitor hit ratio

#### 2.4.1.2 Page Replacement Policies
- 2.4.1.2.1 LRU — Least Recently Used — evict oldest accessed page — simple
  - 2.4.1.2.1.1 Sequential scan problem — evicts hot pages — "buffer pool pollution"
- 2.4.1.2.2 LRU-K — track last K accesses — better frequency estimate — K=2 common
  - 2.4.1.2.2.1 InnoDB uses LRU-K — young sublist + old sublist — prevents pollution
- 2.4.1.2.3 Clock (Second Chance) — circular buffer — reference bit — cheaper than LRU
- 2.4.1.2.4 ARC — Adaptive Replacement Cache — balance recency + frequency — ZFS
  - 2.4.1.2.4.1 T1 + T2 + B1 + B2 lists — self-tuning — responds to workload shifts

#### 2.4.1.3 Pre-fetching & I/O Scheduling
- 2.4.1.3.1 Sequential pre-fetch — detect sequential scan — read-ahead pages — amortize I/O
- 2.4.1.3.2 Index pre-fetch — prefetch leaf pages during index scan — reduce random I/O
- 2.4.1.3.3 Double-write buffer (InnoDB) — write page twice — partial write protection
  - 2.4.1.3.3.1 Write to contiguous area first → then actual page location — torn page safe

---

## 2.5 Row vs. Columnar Storage

### 2.5.1 Row-Oriented Storage (NSM — N-ary Storage Model)
- 2.5.1.1 Store complete row together — all columns for a row in same page
  - 2.5.1.1.1 Optimal for OLTP — point reads + updates — fetch all columns in one I/O
  - 2.5.1.1.2 Inefficient for OLAP — fetch all columns even when only few needed
- 2.5.1.2 Heap file — unordered rows — pages with free space — slotted page layout
  - 2.5.1.2.1 Slotted page — header with slot array → offsets → variable-length tuples
  - 2.5.1.2.2 Free space map — track available space — avoid full page scans on insert

### 2.5.2 Columnar Storage (DSM — Decomposition Storage Model)
- 2.5.2.1 Store each column separately — only read needed columns — column projection
  - 2.5.2.1.1 OLAP efficiency — SELECT SUM(revenue) — read only revenue column
  - 2.5.2.1.2 Compression — same-type values — dictionary / RLE / delta / bit-pack
- 2.5.2.2 Compression schemes
  - 2.5.2.2.1 Run-length encoding (RLE) — sorted column — (value, count) pairs — 100x
  - 2.5.2.2.2 Dictionary encoding — map values to integers — small dict in L1 cache
  - 2.5.2.2.3 Delta encoding — store differences — timestamp/ID columns — tiny values
  - 2.5.2.2.4 Bit-packing — pack small integers — e.g. enum with 4 values = 2 bits
- 2.5.2.3 Zone maps (min-max indexes) — per column chunk — skip non-matching blocks
  - 2.5.2.3.1 Predicate pushdown — WHERE date > X — skip zones entirely — 10–100x speedup
- 2.5.2.4 Vectorized execution — operate on column chunks — SIMD instructions
  - 2.5.2.4.1 Vector size — 1024 values — fits CPU cache — batch processing
  - 2.5.2.4.2 Morsel-driven parallelism — partition data into morsels — worker per morsel

### 2.5.3 PAX (Partition Attributes Across)
- 2.5.3.1 Hybrid — row pages internally columnar — group by row + store columns within
  - 2.5.3.1.1 Benefits both OLTP (row-level ops) + limited OLAP (column scans within page)
