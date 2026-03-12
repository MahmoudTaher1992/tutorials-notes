# Azure Complete Study Guide - Part 11: Phase 2 — Azure SQL, Cosmos DB, Cache for Redis

## 19.0 Azure SQL Database & SQL Managed Instance

### 19.1 SQL DB & MI Core
→ See Ideal §4.1 Relational Databases, §4.1.1 Service Tiers, §4.1.5 HA & BCDR

#### 19.1.1 Azure SQL-Unique Features
- **Unique: Serverless compute tier** — auto-pause + auto-resume — billing per vCore-second
  - 19.1.1.1 Auto-pause delay — 1 hour to 7 days — cold start ~1min on first query
  - 19.1.1.2 Min-max vCores — scale range — 0.5 to 40 vCores configurable
- **Unique: Hyperscale architecture** — page servers + log service — 100TB+ scale
  - 19.1.1.3 Rapid scale up/down — decouple storage from compute — minutes not hours
  - 19.1.1.4 Named replicas — separate compute endpoint — reader isolation
  - 19.1.1.5 Geo-secondary — Hyperscale cross-region — read scaling + DR
- **Unique: Ledger tables** — blockchain-backed audit — tamper-evident history
  - 19.1.1.6 Updatable ledger — append-only with history table — full audit trail
  - 19.1.1.7 Verification — digest anchored to Azure Confidential Ledger / Storage
- **Unique: Query Performance Insight** — GUI top queries — DTU/CPU consumers
  - 19.1.1.8 Query Store — enabled by default — plan regression detection
  - 19.1.1.9 Automatic tuning — auto-create/drop indexes, force last-known-good plan
- **Unique: Elastic Jobs** — T-SQL jobs across multiple DBs — cron scheduling
  - 19.1.1.10 Job database — separate DB — stores job definitions + history
- **Unique: SQL Data Sync** — bi-directional sync between SQL DBs — change tracking
  - 19.1.1.11 Hub-member topology — sync group — conflict resolution policy
- **Unique: Azure SQL Managed Instance Link** — replicate to SQL Server 2022 on-prem
  - 19.1.1.12 Online migration — near-zero downtime cutover — fail back supported
- **Unique: Maintenance windows** — choose preferred maintenance window — 8hr window
  - 19.1.1.13 Notifications 24hr + 1hr prior — avoid planned maintenance surprise

---

## 20.0 Azure Cosmos DB

### 20.1 Cosmos DB Core
→ See Ideal §4.2 NoSQL Key-Value, §4.2.1 Global Distribution, §4.2.2 Consistency, §4.2.3 RU

#### 20.1.1 Cosmos DB-Unique Features
- **Unique: Multi-model natively** — single engine — NoSQL/Mongo/Cassandra/Gremlin/Table/PostgreSQL
  - 20.1.1.1 Single storage format — Apache format — API is protocol layer only
- **Unique: Analytical Store** — HTAP — row transactional + columnar analytical — no ETL
  - 20.1.1.2 Synapse Link integration — query analytical store from Spark/serverless SQL
  - 20.1.1.3 Auto-sync — changes propagate in seconds — no throughput impact
  - 20.1.1.4 Schema representation — well-defined (flat) vs. full fidelity — nested docs
- **Unique: Change Feed** — ordered per logical partition — push model via processor
  - 20.1.1.5 Change feed processor — load-balanced — lease container tracks progress
  - 20.1.1.6 All versions and deletes mode — full history — requires periodic mode or CF
  - 20.1.1.7 Azure Functions Cosmos trigger — change feed → serverless processing
- **Unique: Burst capacity** — consume accumulated capacity for spikes — minutes buffer
  - 20.1.1.8 Burst credit bucket — 5 minutes of unused RU — absorb traffic spikes
- **Unique: Hierarchical partition keys** — up to 3 levels — sub-partition within partition
  - 20.1.1.9 Format — /tenantId/userId/sessionId — reduces hot partitions
  - 20.1.1.10 Backward compatible — old queries still work without subpartition filter
- **Unique: Integrated vector database** — DiskANN index — billion-scale vector search
  - 20.1.1.11 Flat + quantized + DiskANN index types — recall vs. speed tradeoff
  - 20.1.1.12 CosmosDB + Azure OpenAI — RAG with transactional data in same store
- **Unique: Materialized views (preview)** — auto-maintained derived containers
  - 20.1.1.13 Builder function — transform source item → view item — async
- **Unique: Continuous backup & PITR** — restore to any second in retention window
  - 20.1.1.14 Container-level restore — granular — no full account restore required

---

## 21.0 Azure Cache for Redis

### 21.1 Redis Core
→ See Ideal §4.3 In-Memory Databases, §4.3.1 Cache Architecture, §4.3.2 Eviction Policies

#### 21.1.1 Azure Cache for Redis-Unique Features
- **Unique: Enterprise tier (Redis Stack)** — RediSearch, RedisJSON, RedisTimeSeries, RedisBloom
  - 21.1.1.1 RediSearch — full-text search + secondary index — no separate search service
    - 21.1.1.1.1 FT.CREATE index — field types: TEXT, TAG, NUMERIC, GEO, VECTOR
    - 21.1.1.1.2 Hybrid query — KNN vector search + filter — single RediSearch query
  - 21.1.1.2 RedisJSON — native JSON — partial updates — JSONPath queries
  - 21.1.1.3 RedisBloom — probabilistic — BloomFilter, CuckooFilter, TopK, CountMinSketch
- **Unique: Active geo-replication (Enterprise)** — multi-region active-active — CRDT-based
  - 21.1.1.4 Conflict-free replicated data types — no conflict resolution needed
  - 21.1.1.5 Replication latency < 1 second typical — async but CRDT ensures convergence
- **Unique: Zone redundancy** — Premium + Enterprise — 3 AZ replicas — 99.999% SLA
  - 21.1.1.6 Automatic failover — sub-second — transparent to clients
- **Unique: Geo-replication (Standard/Premium)** — passive secondary — manual failover
  - 21.1.1.7 Unlink before failover — promote to independent instance
- **Unique: Redis modules on Azure**
  - 21.1.1.8 RedisTimeSeries — time-series with labels — compaction rules — downsampling
  - 21.1.1.9 RedisBloom Bloom filter — 1% false positive — memory-efficient set membership
- **Unique: Persistence options (Premium)** — RDB snapshots or AOF
  - 21.1.1.10 RDB intervals — 15min/30min/60min/360min/720min/1440min — size vs. durability
  - 21.1.1.11 AOF fsync every second — at most 1 second data loss — performance penalty
- **Unique: VNet injection (Premium)** — private endpoint or classic VNet injection
  - 21.1.1.12 Firewall rules — IP allowlist — public endpoint filtering
- **Unique: Entra ID authentication** — token-based — no password — role assignment
  - 21.1.1.13 Data reader/contributor roles — per-user or managed identity
  - 21.1.1.14 Disable access key authentication — Entra-only — more secure
- **Unique: Flush on scale-out** — data cleared on shard count increase — plan carefully
  - 21.1.1.15 Blue-green scaling — provision new cluster → warm up → swap endpoint
