# Databases Complete Study Guide - Part 12: MongoDB & DynamoDB

## 24.0 MongoDB

### 24.1 Storage Engine (WiredTiger)
#### 24.1.1 WiredTiger Architecture
- 24.1.1.1 B-tree + LSM hybrid — row-oriented B-tree by default — LSM for write-heavy
  - 24.1.1.1.1 Collection file — .wt file per collection — B-tree of documents
  - 24.1.1.1.2 Index file — separate .wt file per index — B-tree keyed by field value + RecordId
- 24.1.1.2 Compression — snappy default — zlib / zstd for higher ratio — per-collection
  - 24.1.1.2.1 Prefix compression — shared key prefix in B-tree pages — compact index pages
  - 24.1.1.2.2 Block compression — page-level — read full page + decompress on access
- 24.1.1.3 Cache — wiredTigerCacheSizeGB — 50% RAM default — dirty eviction — checkpoint
  - 24.1.1.3.1 Checkpoint every 60s — write dirty pages — recovery point — journal between
  - 24.1.1.3.2 Journal (WAL) — 100ms flush interval — group commit — durability between checkpoints

#### 24.1.2 Document Storage
- 24.1.2.1 BSON — Binary JSON — typed — int32/int64/double/ObjectId/Date/Binary/Array
  - 24.1.2.1.1 ObjectId — 12 bytes — 4B timestamp + 5B random + 3B counter — monotone
  - 24.1.2.1.2 Padding factor removed — MongoDB 3.0+ — power-of-2 allocation — in-place update
- 24.1.2.2 In-place update vs. rewrite — small updates use in-place — growth triggers move
  - 24.1.2.2.1 Avoid field value growth — causes document relocation — index update + I/O

### 24.2 Replica Sets & Sharding
#### 24.2.1 Replica Set
- 24.2.1.1 Primary + secondaries — oplog-based replication — capped collection — idempotent ops
  - 24.2.1.1.1 Oplog — operations log — insert/update/delete as idempotent ops — TTL capped
  - 24.2.1.1.2 oplog size — covers lag window — if replica falls behind too far — initial sync
- 24.2.1.2 Write concern — w: majority — wait for majority ACK — durable — default since 5.0
  - 24.2.1.2.1 w:1 — primary ACK only — fast — data loss if primary crashes before replicate
  - 24.2.1.2.2 j: true — journal write before ACK — extra durability within node
- 24.2.1.3 Read preference — primary / primaryPreferred / secondary / nearest
  - 24.2.1.3.1 secondary reads — stale possible — eventual consistency — analytics workload

#### 24.2.2 Sharding Architecture
- 24.2.2.1 Sharded cluster — mongos router + config servers + shard replica sets
  - 24.2.2.1.1 Config servers — replica set — store cluster metadata — chunk ranges
  - 24.2.2.1.2 mongos — stateless router — query planner — scatter-gather for unsharded queries
- 24.2.2.2 Shard key selection — cardinality + frequency + monotone avoidance
  - 24.2.2.2.1 Hashed shard key — even distribution — no range query on shard key — scatter
  - 24.2.2.2.2 Ranged shard key — range queries efficient — hotspot if monotone (timestamp)
  - 24.2.2.2.3 Compound shard key — {userId, timestamp} — range per user — no global hotspot
- 24.2.2.3 Chunk — 128MB default — balancer moves chunks — jumbo chunk = unsplittable — avoid

### 24.3 Aggregation & Indexes
#### 24.3.1 Index Types
- 24.3.1.1 Single field — ascending/descending — compound — multikey (array field)
  - 24.3.1.1.1 Multikey index — each array element indexed — compound multikey restrictions
  - 24.3.1.1.2 Wildcard index — {$**:1} — index all fields — flexible schema — high overhead
- 24.3.1.2 Text index — inverted index — language-aware — only one per collection
  - 24.3.1.2.1 Atlas Search — Lucene-based — richer full-text — facets + autocomplete
- 24.3.1.3 Time series collection — MongoDB 5.0+ — columnar TSBS storage — auto-bucketing
  - 24.3.1.3.1 metaField + timeField — declare at creation — optimized compression — 10x smaller

---

## 25.0 DynamoDB

### 25.1 Data Model & Keys
#### 25.1.1 Table Structure
- 25.1.1.1 Items — schemaless — max 400KB — partition key mandatory — sort key optional
  - 25.1.1.1.1 Partition key only — simple table — PK uniquely identifies item — hash lookup
  - 25.1.1.1.2 Composite key — PK + sort key — multiple items per PK — range queries on SK
- 25.1.1.2 Attribute types — S (string) / N (number) / B (binary) / SS / NS / BS / L / M / NULL / BOOL
  - 25.1.1.2.1 Number — arbitrary precision string internally — no float precision issues
  - 25.1.1.2.2 Map (M) — nested attributes — DynamoDB path expression — nested update

#### 25.1.2 Access Patterns
- 25.1.2.1 Primary access — GetItem (PK) — BatchGetItem — O(1) — single partition
  - 25.1.2.1.1 Query — partition key = x AND SK condition — returns all items for PK — efficient
  - 25.1.2.1.2 Scan — full table — expensive — avoid for production queries — use GSI
- 25.1.2.2 Single-table design — all entities in one table — access patterns via GSI
  - 25.1.2.2.1 PK=USER#123, SK=PROFILE — PK=USER#123, SK=ORDER#456 — single table
  - 25.1.2.2.2 GSI — Global Secondary Index — alternate access pattern — eventually consistent

### 25.2 Capacity & Consistency
#### 25.2.1 Capacity Modes
- 25.2.1.1 Provisioned — specify RCU + WCU — auto-scaling — steady predictable workload
  - 25.2.1.1.1 RCU — 1 strongly consistent read per 4KB — 2 eventually consistent reads per 4KB
  - 25.2.1.1.2 WCU — 1 write per 1KB — transactional write = 2 WCU — careful for large items
- 25.2.1.2 On-demand — pay per request — no capacity planning — spiky / unknown traffic
  - 25.2.1.2.1 Auto-scales instantly — previous peak × 2 — no throttling for normal spikes

#### 25.2.2 Consistency & Transactions
- 25.2.2.1 Eventually consistent reads — default — read from any replica — may be stale
  - 25.2.2.1.1 Strongly consistent — ConsistentRead=true — latest committed — double RCU cost
- 25.2.2.2 DynamoDB Transactions — TransactWriteItems — up to 100 items — 2-phase commit
  - 25.2.2.2.1 Transactional read — TransactGetItems — snapshot isolation — consistent view
  - 25.2.2.2.2 Idempotency token — ClientRequestToken — safe retry — exactly-once semantics
- 25.2.2.3 DynamoDB Streams — item-level change log — 24h retention — trigger Lambda
  - 25.2.2.3.1 NEW_AND_OLD_IMAGES — before + after — full change capture — event sourcing
