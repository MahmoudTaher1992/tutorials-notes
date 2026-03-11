# AWS Complete Study Guide - Part 4: Database Services (Phase 1 — Ideal)

## 4.0 Database Services

### 4.1 Relational Databases
#### 4.1.1 ACID Properties & Implementation
- 4.1.1.1 Atomicity — write-ahead log (WAL/redo log) — all-or-nothing commit
  - 4.1.1.1.1 Group commit — batch WAL flushes — reduce fsync overhead
- 4.1.1.2 Consistency — constraint validation — triggers — foreign keys
- 4.1.1.3 Isolation levels — Read Uncommitted → Read Committed → Repeatable Read → Serializable
  - 4.1.1.3.1 MVCC (Multi-Version Concurrency Control) — readers don't block writers
  - 4.1.1.3.2 Snapshot Isolation — each transaction sees consistent snapshot
- 4.1.1.4 Durability — WAL persisted to disk before ACK — fsync behavior critical
  - 4.1.1.4.1 innodb_flush_log_at_trx_commit — 0/1/2 trade-off

#### 4.1.2 Replication Architectures
- 4.1.2.1 Synchronous replication — zero data loss — RPO=0 — latency penalty
  - 4.1.2.1.1 Quorum writes — majority ACK — Paxos/Raft-based commit
- 4.1.2.2 Asynchronous replication — near-zero latency — RPO > 0 — replica lag
  - 4.1.2.2.1 Replica lag monitoring — replication_delay metric — alert threshold
- 4.1.2.3 Logical replication — row-level changes — cross-version, selective tables
- 4.1.2.4 Physical/streaming replication — WAL shipping — binary identical replica

#### 4.1.3 High Availability Patterns
- 4.1.3.1 Multi-AZ standby — synchronous — automatic failover 30–120s
  - 4.1.3.1.1 DNS CNAME flip — no application change required post-failover
- 4.1.3.2 Read replicas — async — scale read workloads — up to 15 replicas
  - 4.1.3.2.1 Promote read replica — manual — new writable instance

#### 4.1.4 Storage Engine Internals
- 4.1.4.1 B+tree index — balanced — O(log n) reads — high fan-out branching factor
  - 4.1.4.1.1 Page size — default 16KB (MySQL InnoDB) — affects fill factor
  - 4.1.4.1.2 Index fragmentation — OPTIMIZE TABLE / VACUUM to reclaim space
- 4.1.4.2 Buffer pool — LRU cache — dirty page eviction — checkpoint mechanism
  - 4.1.4.2.1 Adaptive hash index — InnoDB-specific — hotspot index optimization

### 4.2 NoSQL — Key-Value
#### 4.2.1 Data Model & Access Patterns
- 4.2.1.1 Partition key — hash — even distribution mandatory
  - 4.2.1.1.1 Hot partition problem — single PK > 1000 RCU/WCU → throttle
  - 4.2.1.1.2 Write sharding — add random suffix to PK — scatter-gather read
- 4.2.1.2 Composite key — PK + Sort Key — enables range queries within partition
  - 4.2.1.2.1 Sort key patterns — date-prefix, hierarchical (A#B#C), version suffixes

#### 4.2.2 Capacity Modes
- 4.2.2.1 Provisioned — set RCU/WCU — predictable workloads — Reserved pricing
  - 4.2.2.1.1 Auto Scaling — target utilization — min/max capacity — CloudWatch alarms
  - 4.2.2.1.2 Burst capacity — unused RCU/WCU up to 300s retained — short spikes
- 4.2.2.2 On-Demand — pay-per-request — up to 2x prior peak instantly
  - 4.2.2.2.1 Instantaneous traffic doubling limit — beyond requires table scaling

#### 4.2.3 Consistency Models
- 4.2.3.1 Eventually consistent reads — default — 2x cheaper — possible stale data
- 4.2.3.2 Strongly consistent reads — read from leader — 1 RCU per 4KB
  - 4.2.3.2.1 Not available on GSI — GSI always eventually consistent
- 4.2.3.3 Transactions — ACID — up to 100 items, 4MB — 2x cost
  - 4.2.3.3.1 TransactWriteItems — all-or-nothing — check conditions atomically

#### 4.2.4 Indexing
- 4.2.4.1 Local Secondary Index (LSI) — same PK, different SK — must define at creation
  - 4.2.4.1.1 10GB per PK limit with LSI — ItemCollections constraint
- 4.2.4.2 Global Secondary Index (GSI) — different PK+SK — own capacity — async
  - 4.2.4.2.1 Sparse index pattern — only items with attribute project to GSI
  - 4.2.4.2.2 GSI overloading — generic PK/SK names — store heterogeneous types

### 4.3 In-Memory Databases
#### 4.3.1 Cache Architecture
- 4.3.1.1 Lazy loading (cache-aside) — read-through with application logic
  - 4.3.1.1.1 Cache miss penalty — cold start — TTL and warming strategies
- 4.3.1.2 Write-through — write cache on DB write — consistent, more writes
- 4.3.1.3 Write-behind (write-back) — async DB write — risk of data loss on crash

#### 4.3.2 Eviction Policies
- 4.3.2.1 LRU (Least Recently Used) — evict coldest key — default Redis
  - 4.3.2.1.1 allkeys-lru vs. volatile-lru — TTL-keyed vs. all-key eviction
- 4.3.2.2 LFU (Least Frequently Used) — frequency counter per key
  - 4.3.2.2.1 Morris counter approximation — probabilistic O(1) counter
- 4.3.2.3 TTL expiry — lazy expiry + active sampling — memory reclaim mechanism

#### 4.3.3 Redis Data Structures
- 4.3.3.1 String — get/set/incr/decr — session tokens, counters
- 4.3.3.2 Hash — field-value map — user profiles, shopping carts
- 4.3.3.3 List — LPUSH/RPOP — task queues, activity feeds
- 4.3.3.4 Set — SADD/SINTER/SUNION — unique visitors, social graphs
- 4.3.3.5 Sorted Set — ZADD with score — leaderboards, rate limiting
  - 4.3.3.5.1 Skip list — O(log n) range queries — internal Sorted Set structure
- 4.3.3.6 Stream — consumer groups — at-least-once delivery — append-only log
  - 4.3.3.6.1 XACK — acknowledge message — prevent re-delivery to group

### 4.4 Graph Databases
#### 4.4.1 Property Graph Model (Amazon Neptune)
- 4.4.1.1 Vertices + edges — directed labeled — properties on both
  - 4.4.1.1.1 Gremlin traversal — g.V().hasLabel().out().values()
  - 4.4.1.1.2 SPARQL for RDF — subject-predicate-object triples
- 4.4.1.2 Storage — adjacency list — O(degree) traversal — not O(n) full scan

### 4.5 Time-Series Databases
#### 4.5.1 Time-Series Data Model (Timestream)
- 4.5.1.1 Dimensions — metadata — series cardinality driver
  - 4.5.1.1.1 High-cardinality pitfall — too many unique dimension combinations
- 4.5.1.2 Measures — numeric/boolean/varchar — time-series values
- 4.5.1.3 Memory store (1–8760hr TTL) → Magnetic store (unlimited) tier
  - 4.5.1.3.1 Adaptive query processing — automatically routes to correct tier

### 4.6 Database Proxies & Connection Pooling
#### 4.6.1 RDS Proxy
- 4.6.1.1 Connection multiplexing — hundreds→thousands of Lambda → RDS safely
  - 4.6.1.1.1 Pinning — transactions bypass pool when SET commands used
  - 4.6.1.1.2 Secrets Manager integration — automatic credential rotation
- 4.6.1.2 Failover acceleration — maintains connections during RDS failover
  - 4.6.1.2.1 Failover time reduction — 66% faster than direct connection

### 4.7 Replication & High Availability
#### 4.7.1 RDS Multi-AZ
- 4.7.1.1 Single standby — synchronous — automatic DNS failover
  - 4.7.1.1.1 Multi-AZ Cluster — 2 readable standbys — writer + 2 reader endpoints
  - 4.7.1.1.2 Failover trigger — instance failure, AZ failure, OS/DB patching
- 4.7.1.2 Aurora Multi-AZ — shared storage across 6 copies in 3 AZs
  - 4.7.1.2.1 Quorum writes — 4/6 quorum — tolerate 2 AZ failures
  - 4.7.1.2.2 Read replicas promoted in <30s — compared to 60–120s RDS

### 4.8 Backup & Point-in-Time Recovery
#### 4.8.1 Automated Backups
- 4.8.1.1 Daily snapshot + transaction logs — PITR to any second in retention window
  - 4.8.1.1.1 Retention window — 0–35 days — 0 disables automated backups
  - 4.8.1.1.2 Restore creates new DB instance — DNS endpoint changes
- 4.8.1.2 Manual snapshots — survive DB deletion — cross-region copy supported
  - 4.8.1.2.1 Encrypted snapshot sharing — requires re-encryption with sharable CMK
