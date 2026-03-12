# Databases Complete Study Guide - Part 6: NoSQL Database Types

## 9.0 Document Databases

### 9.1 Document Model
#### 9.1.1 Document Structure
- 9.1.1.1 Self-describing JSON/BSON — nested objects + arrays — flexible schema
  - 9.1.1.1.1 Embedding — store related data in same document — single read retrieval
  - 9.1.1.1.2 Referencing — store _id pointer — normalize — join via application or $lookup
- 9.1.1.2 Embedding vs. referencing decision criteria
  - 9.1.1.2.1 Embed when — data accessed together — 1:1 or 1:few — rarely updated alone
  - 9.1.1.2.2 Reference when — 1:many (unbounded) — data accessed independently — shared
  - 9.1.1.2.3 16MB document limit (MongoDB) — embedding bloat causes limit hit — reference
- 9.1.1.3 Schema validation — JSON Schema — enforce structure optionally
  - 9.1.1.3.1 Strict vs. moderate validation — strict: reject unknown fields — moderate: warn

### 9.2 Aggregation Pipeline
#### 9.2.1 Pipeline Stages
- 9.2.1.1 $match — filter documents — early stage for index use — like WHERE
  - 9.2.1.1.1 Push $match early — reduces documents before expensive stages
- 9.2.1.2 $group — accumulate values — _id is group key — $sum/$avg/$push/$addToSet
  - 9.2.1.2.1 $group with null _id — aggregate entire collection — grand total
- 9.2.1.3 $lookup — left outer join — localField → foreignField — returns array
  - 9.2.1.3.1 Uncorrelated pipeline — lookup with full pipeline — more flexible
  - 9.2.1.3.2 $unwind — deconstruct array — combine with $lookup — flatten result
- 9.2.1.4 $project — reshape document — include/exclude/add computed fields
- 9.2.1.5 $sort + $limit + $skip — pagination — $sort before $group impacts memory
- 9.2.1.6 $facet — multiple aggregation pipelines in parallel — faceted search
- 9.2.1.7 $bucket / $bucketAuto — histogram — range-based grouping — analytics

---

## 10.0 Key-Value Stores

### 10.1 KV Model & Access Patterns
#### 10.1.1 Operations
- 10.1.1.1 GET(key) → value — O(1) lookup — hash table or B-tree backed
- 10.1.1.2 PUT(key, value) — upsert — overwrite existing — atomic
- 10.1.1.3 DELETE(key) — remove — tombstone in LSM stores
- 10.1.1.4 SCAN(start_key, end_key) — range scan — only ordered KV stores
  - 10.1.1.4.1 Unordered KV — hash-based — no range scan — point lookups only
  - 10.1.1.4.2 Ordered KV — B-tree or LSM — range scan efficient — RocksDB

#### 10.1.2 KV Data Structures (Redis-style)
- 10.1.2.1 String — bytes — max 512MB — SET/GET — INCR/DECR — atomic counter
- 10.1.2.2 Hash — field → value map — HSET/HGET/HMGET — object storage
  - 10.1.2.2.1 Small hash encoding — ziplist — compact — < 128 fields + < 64 bytes/field
- 10.1.2.3 List — doubly linked list — LPUSH/RPUSH/LPOP/RPOP — queue + stack
  - 10.1.2.3.1 Blocking pop — BLPOP — wait for element — message queue pattern
- 10.1.2.4 Set — unordered unique members — SADD/SISMEMBER/SUNION/SINTER/SDIFF
  - 10.1.2.4.1 SADD + SCARD — unique visitor counting — deduplication
- 10.1.2.5 Sorted Set (ZSet) — member + score — sorted by score — ZADD/ZRANGE/ZRANK
  - 10.1.2.5.1 Skip list implementation — O(log N) insert/delete/search — probabilistic
  - 10.1.2.5.2 Leaderboard — ZADD score userid — ZRANGE 0 9 WITHSCORES — top 10
- 10.1.2.6 HyperLogLog — probabilistic cardinality — 12KB fixed — 0.81% error
  - 10.1.2.6.1 PFADD + PFCOUNT — count unique visitors — huge data, small memory
- 10.1.2.7 Bitmap — bit array — SETBIT/GETBIT/BITCOUNT/BITOP — daily active users
- 10.1.2.8 Stream — append-only log — consumer groups — XADD/XREAD/XACK — Kafka-lite

### 10.2 TTL & Eviction
#### 10.2.1 TTL (Time To Live)
- 10.2.1.1 Per-key expiry — SET key value EX 300 — auto-delete after 300s
  - 10.2.1.1.1 Lazy expiry — delete on access — no background scan — may stay in memory
  - 10.2.1.1.2 Active expiry — periodic sampling — 20 random keys — delete expired
- 10.2.1.2 Use cases — session tokens + cache entries + rate limit windows + OTP codes

#### 10.2.2 Eviction Policies
- 10.2.2.1 noeviction — return error on write when memory full — default — safest
- 10.2.2.2 allkeys-lru — evict least recently used — general cache — recommended
- 10.2.2.3 volatile-lru — evict LRU from keys with TTL only — mixed workload
- 10.2.2.4 allkeys-lfu — evict least frequently used — access pattern aware
- 10.2.2.5 allkeys-random — random eviction — no access pattern — not recommended
- 10.2.2.6 volatile-ttl — evict key with shortest TTL — expiry-aware eviction

---

## 11.0 Wide-Column Stores

### 11.1 Data Model
#### 11.1.1 Column Families
- 11.1.1.1 Table — row key + column families — each row can have different columns
  - 11.1.1.1.1 Column qualifier — column name within family — arbitrary — dynamic
  - 11.1.1.1.2 Cell — (row_key, column_family, qualifier, timestamp) → value — versioned
- 11.1.1.2 Column family physical storage — stored together — co-located on disk
  - 11.1.1.2.1 Few column families — 1–3 recommended — each family = separate LSM tree
  - 11.1.1.2.2 Many column families — excessive compaction overhead — anti-pattern

### 11.2 Row Key Design
#### 11.2.1 Key Design Principles
- 11.2.1.1 Row key determines distribution — hash or sequential — hotspot risk
  - 11.2.1.1.1 Sequential keys — all writes to one region/shard — hotspot — anti-pattern
  - 11.2.1.1.2 Salt prefix — prepend hash — distribute writes — scatter-gather on read
  - 11.2.1.1.3 Reverse timestamp — MaxLong - timestamp — most recent row first
- 11.2.1.2 Access pattern drives key design — primary access = row key — secondary = index
  - 11.2.1.2.1 Composite key — user_id#timestamp — range scan for user timeline
  - 11.2.1.2.2 One-to-many modeling — prefix scan — user:123:tweets:* — all tweets

### 11.3 Read/Write Path (SSTable/Memtable)
#### 11.3.1 Write Path
- 11.3.1.1 Commit log → Memtable (sorted in memory) → SSTable flush — same as LSM
  - 11.3.1.1.1 Hint log — temporary — replay on restart — restore memtable state
- 11.3.1.2 Compaction strategies — same as LSM — size-tiered / leveled / FIFO
  - 11.3.1.2.1 TWCS (Time Window Compaction) — time-series — expire old SSTables
  - 11.3.1.2.2 Tombstone — delete marker — must survive until all replicas compacted
