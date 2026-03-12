# Databases Complete Study Guide - Part 1: Fundamentals & Storage Engine Internals

## Phase 1: The Ideal Database Platform

---

## 1.0 Database Fundamentals

### 1.1 Data Models & Core Theory
#### 1.1.1 Data Models
- 1.1.1.1 Relational model — tables + rows + columns — set theory — Codd's 12 rules
  - 1.1.1.1.1 Relation — named set of tuples — no duplicate rows — no order
  - 1.1.1.1.2 Primary key — unique tuple identifier — minimal + stable + non-null
  - 1.1.1.1.3 Foreign key — referential integrity — child references parent — enforced
- 1.1.1.2 Document model — JSON/BSON tree — self-describing — flexible schema
  - 1.1.1.2.1 Denormalization — embed related data — optimize for read pattern
  - 1.1.1.2.2 Reference pattern — store ID — normalize — optimize for writes + consistency
- 1.1.1.3 Key-value model — simplest — O(1) lookup by key — opaque value
  - 1.1.1.3.1 Value types — string / blob / structured — depends on store
- 1.1.1.4 Wide-column model — row key + column families — sparse — sorted
  - 1.1.1.4.1 Column family — group of columns — stored together — physical locality
- 1.1.1.5 Graph model — nodes + edges + properties — relationship-first
  - 1.1.1.5.1 Property graph — labeled nodes + typed edges + key-value properties
  - 1.1.1.5.2 RDF model — subject–predicate–object triples — SPARQL query language

#### 1.1.2 ACID vs BASE
- 1.1.2.1 ACID — Atomicity + Consistency + Isolation + Durability
  - 1.1.2.1.1 Atomicity — all or nothing — transaction commits or fully rolls back
  - 1.1.2.1.2 Consistency — data integrity constraints preserved before + after
  - 1.1.2.1.3 Isolation — concurrent transactions appear serial — no interference
  - 1.1.2.1.4 Durability — committed data survives crash — written to durable storage
- 1.1.2.2 BASE — Basically Available + Soft state + Eventually consistent
  - 1.1.2.2.1 Basically Available — system responds even during partition
  - 1.1.2.2.2 Soft state — state may change without input — convergence in progress
  - 1.1.2.2.3 Eventually consistent — all replicas converge — given no new updates

### 1.2 CAP Theorem & PACELC
#### 1.2.1 CAP Theorem
- 1.2.1.1 Consistency — every read gets most recent write or error
  - 1.2.1.1.1 Linearizability — strongest form — single-copy illusion
- 1.2.1.2 Availability — every request gets non-error response — no latest-write guarantee
- 1.2.1.3 Partition tolerance — system continues despite network partition
  - 1.2.1.3.1 Partitions are inevitable — choose C or A during partition — not both
- 1.2.1.4 CA systems — not partition tolerant — single node — traditional RDBMS
- 1.2.1.5 CP systems — sacrifice availability — consistent during partition — HBase, ZooKeeper
- 1.2.1.6 AP systems — sacrifice consistency — available during partition — Cassandra, CouchDB

#### 1.2.2 PACELC (extended CAP)
- 1.2.2.1 During Partition — choose Availability or Consistency (same as CAP)
- 1.2.2.2 Else (no partition) — choose Latency or Consistency tradeoff
  - 1.2.2.2.1 PA/EL — Cassandra — available during partition + low latency else
  - 1.2.2.2.2 PC/EC — HBase/Spanner — consistent always — higher latency
  - 1.2.2.2.3 PA/EC — MongoDB — available during partition + consistent else

### 1.3 Consistency Models
#### 1.3.1 Strong Consistency
- 1.3.1.1 Linearizability — all ops appear instantaneous — total order
  - 1.3.1.1.1 Real-time constraint — if op1 finishes before op2 starts — op1 appears first
  - 1.3.1.1.2 Cost — coordination overhead — higher latency — consensus required
- 1.3.1.2 Sequential consistency — global total order — no real-time constraint
  - 1.3.1.2.1 Each process ops appear in order — across processes any interleaving

#### 1.3.2 Weak Consistency
- 1.3.2.1 Causal consistency — causally related ops seen in order — concurrent = any order
  - 1.3.2.1.1 Vector clocks — track causality — happen-before relationship
  - 1.3.2.1.2 COPS / Cassandra lightweight transactions — causal enforcement
- 1.3.2.2 Eventual consistency — all replicas converge — unbounded time
  - 1.3.2.2.1 Read-your-writes — session guarantee — user sees own writes
  - 1.3.2.2.2 Monotonic reads — never read older value after newer read
  - 1.3.2.2.3 Monotonic writes — writes from same client applied in order

### 1.4 Storage Hierarchy
#### 1.4.1 Hardware Characteristics
- 1.4.1.1 CPU cache (L1/L2/L3) — nanoseconds — < 1ns L1 — scarce — 256KB–32MB
- 1.4.1.2 DRAM — ~100ns — abundant — volatile — 16–512 GB typical server
  - 1.4.1.2.1 Buffer pool — DB caches pages in DRAM — reduces disk I/O
- 1.4.1.3 NVMe SSD — ~100 microseconds — 1–8 TB — durable — fast random I/O
  - 1.4.1.3.1 IOPS — 500K–1M random IOPS — ideal for database storage
- 1.4.1.4 SATA SSD — ~500 microseconds — cheaper — fewer IOPS — 50K–100K
- 1.4.1.5 HDD — ~5ms seek — cheap — large — sequential OK — random I/O terrible
  - 1.4.1.5.1 Sequential vs. random — HDD: 200 MB/s seq vs. 1 MB/s random — 200x diff

---

## 2.0 Storage Engine Internals

### 2.1 B-Tree & B+Tree
#### 2.1.1 B-Tree Structure
- 2.1.1.1 Balanced tree — O(log n) search/insert/delete — page-aligned nodes
  - 2.1.1.1.1 Node = page (4KB/8KB/16KB) — fill with keys + pointers — minimize I/O
  - 2.1.1.1.2 Height — 3–4 levels typical — 1 billion rows in 4 reads
  - 2.1.1.1.3 Branching factor — keys per node — higher = shorter tree = fewer I/Os
- 2.1.1.2 B+Tree variant — data only in leaves — internal nodes = routing keys
  - 2.1.1.2.1 Leaf linked list — range scans efficient — sequential leaf traversal
  - 2.1.1.2.2 All data in leaves — internal node = pure index — better cache use
- 2.1.1.3 Insert path — find leaf → insert key → split if full → propagate up
  - 2.1.1.3.1 Page split — copy half keys to new page — add pointer to parent
  - 2.1.1.3.2 Root split — tree grows taller — root always in buffer pool
- 2.1.1.4 Delete path — find leaf → delete key → merge / redistribute if too empty
  - 2.1.1.4.1 Underflow — node half empty — steal from sibling or merge
- 2.1.1.5 Concurrent access — latch coupling — acquire child before releasing parent
  - 2.1.1.5.1 Optimistic latch coupling — read without latch → validate → retry if changed

### 2.2 LSM Tree (Log-Structured Merge Tree)
#### 2.2.1 LSM Architecture
- 2.2.1.1 Write path — append to WAL → insert into memtable → flush when full
  - 2.2.1.1.1 Memtable — in-memory sorted structure — red-black tree or skip list
  - 2.2.1.1.2 Flush — memtable → immutable SSTable on disk — batch sequential write
- 2.2.1.2 SSTable — Sorted String Table — immutable — sorted keys — bloom filter
  - 2.2.1.2.1 Bloom filter — probabilistic — "key definitely absent" or "maybe present"
  - 2.2.1.2.2 Sparse index — one entry per block — find block containing key
  - 2.2.1.2.3 Data block — key-value pairs — compressed — fixed block size
- 2.2.1.3 Read path — memtable → L0 SSTables → L1 → L2 — newest first wins
  - 2.2.1.3.1 Read amplification — check many SSTables — bloom filters reduce checks
  - 2.2.1.3.2 Row cache — cache full rows — bypass SSTable lookup for hot keys
- 2.2.1.4 Compaction — merge SSTables — eliminate duplicates + tombstones — sort
  - 2.2.1.4.1 Size-tiered compaction — merge similar-sized SSTables — write-optimized
  - 2.2.1.4.2 Leveled compaction — fixed per-level size budget — read-optimized
  - 2.2.1.4.3 FIFO compaction — time-series — drop oldest — simple — no merging
  - 2.2.1.4.4 Write amplification — data rewritten multiple times during compaction
- 2.2.1.5 LSM vs. B-Tree tradeoffs
  - 2.2.1.5.1 LSM wins — write-heavy — better write throughput — sequential I/O
  - 2.2.1.5.2 B-Tree wins — read-heavy — predictable latency — simpler
