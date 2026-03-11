# AWS Complete Study Guide - Part 11: Phase 2 — RDS/Aurora, DynamoDB, ElastiCache

## 19.0 Amazon RDS & Aurora

### 19.1 RDS Core
→ See Ideal §4.1 Relational Databases, §4.7 Replication & HA, §4.8 Backup & PITR

#### 19.1.1 RDS-Unique Features
- **Unique: Managed patching** — maintenance windows — minor auto / major manual
  - 19.1.1.1 OS patching — multi-AZ = zero downtime — failover during patch
  - 19.1.1.2 Blue/Green deployments — create green copy → promote → zero downtime upgrade
    - 19.1.1.2.1 Logical replication used for sync during switchover
    - 19.1.1.2.2 Switchover takes <60s — DNS cutover to green
- **Unique: Parameter Groups** — DB engine configuration — static (restart) vs. dynamic (live)
  - 19.1.1.3 max_connections formula — DBInstanceClassMemory / 12582880 (bytes)
  - 19.1.1.4 Performance Insights — wait event analysis — top SQL — 7 day free / 2yr paid
    - 19.1.1.4.1 Average Active Sessions (AAS) — >vCPU count = bottleneck
    - 19.1.1.4.2 Dimensions — host, SQL, wait, user — drill-down correlation
- **Unique: Enhanced Monitoring** — OS-level metrics — 1-second granularity
  - 19.1.1.5 Metrics — RDS process, guest OS CPU steal, I/O wait breakdown

#### 19.1.2 Aurora-Unique Architecture
- **Unique: Aurora Storage** — shared cluster volume — 6 copies across 3 AZs
  - 19.1.2.1 Write quorum 4/6 — tolerate 2 failures without data loss
  - 19.1.2.2 Self-healing — background repair from remaining copies — no replica lag for storage
  - 19.1.2.3 Auto-expand — 10GB increments — up to 128TB — no pre-provision
- **Unique: Aurora Endpoints**
  - 19.1.2.4 Cluster endpoint — writer — follows primary after failover
  - 19.1.2.5 Reader endpoint — load balances across all read replicas
  - 19.1.2.6 Custom endpoint — subset of instances — analytics vs. OLTP separation
  - 19.1.2.7 Instance endpoint — direct — bypass load balancing
- **Unique: Aurora Serverless v2** — ACU (Aurora Capacity Units) — 0.5 to 128 ACUs
  - 19.1.2.8 Scale in 0.5 ACU increments — <1s scaling — no connection drop
  - 19.1.2.9 Pause to 0 ACUs — ~30s cold start — development workloads
- **Unique: Aurora Global Database** — up to 5 secondary regions — <1s replication lag
  - 19.1.2.10 Managed planned failover — promote secondary — RPO=0 RTO<1min
  - 19.1.2.11 Write forwarding — secondary accepts writes — forwards to primary
- **Unique: Aurora Parallel Query** — push down to storage layer — 100x faster analytics
- **Unique: Babelfish for Aurora PostgreSQL** — SQL Server T-SQL dialect compatibility

---

## 20.0 Amazon DynamoDB

### 20.1 DynamoDB Core
→ See Ideal §4.2 NoSQL Key-Value, §4.2.2 Capacity Modes, §4.2.4 Indexing

#### 20.1.1 DynamoDB-Unique Features
- **Unique: Single-digit millisecond latency** — sub-10ms p99 — in-memory cache layer
  - 20.1.1.1 Adaptive capacity — automatically shift capacity to hot partitions
  - 20.1.1.2 Global admission control — smooth burst beyond provisioned capacity briefly
- **Unique: DynamoDB Streams** — change data capture — 24-hour retention
  - 20.1.1.3 StreamViewType — KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES
  - 20.1.1.4 Lambda trigger — batch window, batch size, starting position — bisect on error
  - 20.1.1.5 Kinesis Data Streams export — longer retention, fan-out consumers
- **Unique: DynamoDB Accelerator (DAX)** — in-memory cache — microsecond latency
  - 20.1.1.6 Write-through cache — Item cache (individual items) + Query cache (result sets)
  - 20.1.1.7 DAX cluster — Multi-AZ — primary + replicas — cluster endpoint
  - 20.1.1.8 Not suitable for strongly consistent reads — cache bypassed
- **Unique: Global Tables** — multi-region active-active — conflict resolution last-write-wins
  - 20.1.1.9 Version attribute (_lastWriteTime) — monotonic — resolve conflicts
  - 20.1.1.10 2022 edition — automatic region add/remove — no stream management
- **Unique: DynamoDB Export to S3** — point-in-time — no capacity consumed
  - 20.1.1.11 Formats — DynamoDB JSON or ION — differential export supported
- **Unique: Table Classes**
  - 20.1.1.12 Standard — default — optimized for high access
  - 20.1.1.13 Standard-IA — 60% cheaper storage — higher per-request cost
- **Unique: PartiQL** — SQL-compatible — SELECT/INSERT/UPDATE/DELETE on DynamoDB
  - 20.1.1.14 Batch + transact PartiQL — ExecuteTransaction API

#### 20.1.2 DynamoDB Design Patterns
- **Unique: Single Table Design** — all entities in one table — GSI overloading
  - 20.1.2.1 Generic PK=PK, SK=SK — item type in prefix (USER#123, ORDER#456)
  - 20.1.2.2 Access pattern inventory drives schema — normalize by query not entity
- **Unique: Adjacency List Pattern** — graph relationships in DynamoDB
  - 20.1.2.3 Edge items — PK=from-node, SK=EDGE#to-node

---

## 21.0 Amazon ElastiCache

### 21.1 ElastiCache Core
→ See Ideal §4.3 In-Memory Databases, §4.3.1 Cache Architecture, §4.3.2 Eviction Policies

#### 21.1.1 ElastiCache for Redis OSS
- **Unique: Cluster Mode** — sharding — up to 500 nodes — 500GB per shard
  - 21.1.1.1 Hash slots — 16384 total — distributed across shards
  - 21.1.1.2 Keyspace notifications — publish to subscriber on key event (SET, DEL, EXPIRE)
  - 21.1.1.3 Shard rebalancing — move slots to new shards — no downtime
- **Unique: Global Datastore** — cross-region replication — <1s async — disaster recovery
  - 21.1.1.4 Promote secondary — new primary — manual operation
- **Unique: Serverless ElastiCache** — auto-scale — ECPU + data storage billing
  - 21.1.1.5 ECPU — ElastiCache Compute Unit — abstract CPU and I/O
  - 21.1.1.6 Zero scaling management — handles traffic spikes automatically
- **Unique: RBAC (Redis 6+)** — users and ACLs — command category restrictions
  - 21.1.1.7 Auth tokens — transport encryption + auth — TLS required for RBAC

#### 21.1.2 ElastiCache for Memcached
- **Unique: Simple, multi-threaded** — no persistence, no replication
  - 21.1.2.1 Auto Discovery — cluster endpoint — nodes join/leave transparently
  - 21.1.2.2 Use case — simple object cache — not for session store (no persistence)

#### 21.1.3 ElastiCache (Valkey)
- **Unique: AWS-supported open-source Redis fork** — post-Redis licensing change
  - 21.1.3.1 API-compatible — drop-in replacement — same client libraries
  - 21.1.3.2 Available in ElastiCache Serverless — preferred going forward
