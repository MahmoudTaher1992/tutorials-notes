# Databases Complete Study Guide - Part 13: Redis & Cassandra/ScyllaDB

## 26.0 Redis

### 26.1 Persistence & Durability
#### 26.1.1 RDB Snapshots
- 26.1.1.1 Point-in-time snapshot — fork() child — write COW snapshot to .rdb file — async
  - 26.1.1.1.1 BGSAVE — non-blocking — child writes snapshot — parent continues serving
  - 26.1.1.1.2 save 3600 1 — save if ≥1 key changed in 3600s — configurable thresholds
  - 26.1.1.1.3 Fork overhead — large dataset — high memory pressure — COW page faults
- 26.1.1.2 RDB file — compact binary format — fast restart — but data loss since last snapshot
  - 26.1.1.2.1 LZF compression — compress string objects in RDB — smaller file

#### 26.1.2 AOF (Append-Only File)
- 26.1.2.1 Log every write command — RESP format — replay on restart — full durability option
  - 26.1.2.1.1 appendfsync always — fsync every command — slowest — max durability
  - 26.1.2.1.2 appendfsync everysec — fsync per second — default — at most 1s data loss
  - 26.1.2.1.3 appendfsync no — let OS decide — fastest — data loss risk
- 26.1.2.2 AOF rewrite — BGREWRITEAOF — compact log — current state only — shrink AOF
  - 26.1.2.2.1 auto-aof-rewrite-percentage 100 — trigger rewrite when AOF doubles — automatic
- 26.1.2.3 RDB+AOF combined — hybrid persistence — RDB as base + AOF since last RDB — Redis 4.0+

### 26.2 Clustering & Sentinel
#### 26.2.1 Redis Sentinel
- 26.2.1.1 Monitor — detect primary down — quorum vote — promote replica
  - 26.2.1.1.1 Sentinel quorum — majority agreement — prevent false failover — min 3 sentinels
  - 26.2.1.1.2 ODOWN — objectively down — quorum agrees — trigger failover
  - 26.2.1.1.3 SDOWN — subjectively down — one sentinel sees failure — not enough for failover
- 26.2.1.2 Client discovery — sentinel knows current primary — client queries sentinel on connect
  - 26.2.1.2.1 SENTINEL get-master-addr-by-name — return current primary IP:port — client reconnect

#### 26.2.2 Redis Cluster
- 26.2.2.1 16384 hash slots — CRC16(key) mod 16384 — slot assigned to node — horizontal scale
  - 26.2.2.1.1 Hash tags — {user123}.profile — same slot — multi-key ops on same node
  - 26.2.2.1.2 MOVED redirect — client routed to correct node — smart client caches slot map
- 26.2.2.2 Cluster topology — each master + N replicas — intra-cluster replication async
  - 26.2.2.2.1 Cluster failover — majority masters agree primary is down — replica promoted
  - 26.2.2.2.2 cluster-require-full-coverage — false — serve available slots even if some down

### 26.3 Advanced Features
#### 26.3.1 Lua Scripting & Modules
- 26.3.1.1 EVAL — run Lua script atomically — no interleaving — transactional batch
  - 26.3.1.1.1 EVALSHA — hash of script — reuse server-cached script — reduces payload
  - 26.3.1.1.2 redis.call() vs redis.pcall() — pcall catches error — Lua exception handling
- 26.3.1.2 Redis Modules — RedisJSON / RediSearch / RedisTimeSeries / RedisBloom
  - 26.3.1.2.1 RedisJSON — JSON.SET/GET — in-memory JSON — fast path expressions
  - 26.3.1.2.2 RediSearch — full-text + vector search on Redis — index fields — FT.SEARCH

---

## 27.0 Cassandra / ScyllaDB

### 27.1 Cassandra Architecture
#### 27.1.1 Ring & Gossip
- 27.1.1.1 Peer-to-peer ring — no master — every node equal — gossip state propagation
  - 27.1.1.1.1 Gossip — every second — exchange state with 3 random nodes — convergence
  - 27.1.1.1.2 Failure detection — Phi accrual detector — adaptive threshold — not binary
- 27.1.1.2 Token assignment — murmur3 hash — vnodes (256 default) — even distribution
  - 27.1.1.2.1 Virtual nodes — each node = 256 token ranges — balanced even on heterogeneous HW

#### 27.1.2 Write & Read Path
- 27.1.2.1 Write path — commit log → memtable → SSTable flush — same as LSM → See §2.2
  - 27.1.2.1.1 Coordinator — any node — route to replicas based on partition key
  - 27.1.2.1.2 Hinted handoff — if replica down — coordinator stores hint — replay on recovery
- 27.1.2.2 Read path — check memtable → bloom filter → key cache → partition index → SSTable
  - 27.1.2.2.1 Bloom filter — per SSTable — skip SSTables without partition — reduce I/O
  - 27.1.2.2.2 Key cache — partition key → SSTable offset — skip partition index lookup
  - 27.1.2.2.3 Row cache — entire partition — full hit — avoid SSTable read — rare use

### 27.2 Data Modeling
#### 27.2.1 CQL Schema Design
- 27.2.1.1 Partition key — determines node placement — queries must include partition key
  - 27.2.1.1.1 Wide row — partition key + clustering columns — time-series per entity — efficient
  - 27.2.1.1.2 Partition size limit — max 2GB — max 100K rows per partition — design guideline
- 27.2.1.2 Clustering columns — sort order within partition — range queries within partition
  - 27.2.1.2.1 ORDER BY must match clustering column direction — ascending/descending fixed
  - 27.2.1.2.2 Slice query — clustering column range — efficient — within same partition
- 27.2.1.3 Denormalize for each query — one table per query pattern — no joins
  - 27.2.1.3.1 Materialized view — auto-maintained denormalized table — write amplification
  - 27.2.1.3.2 Secondary index — allow non-PK queries — scatter-gather — avoid for high cardinality

### 27.3 ScyllaDB Differences
#### 27.3.1 Shard-per-Core Architecture
- 27.3.1.1 Seastar framework — each CPU core owns data shards — no inter-core locking
  - 27.3.1.1.1 Task scheduler — per-core event loop — async I/O — no context switching overhead
  - 27.3.1.1.2 10x throughput vs Cassandra — same hardware — JVM GC elimination — C++
- 27.3.1.2 Compaction scheduler — per-shard compaction — parallel — no compaction backpressure
  - 27.3.1.2.1 Incremental compaction strategy — ICS — continuous small merges — no pauses
