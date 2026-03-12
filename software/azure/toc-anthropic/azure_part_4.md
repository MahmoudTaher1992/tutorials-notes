# Azure Complete Study Guide - Part 4: Database Services (Phase 1 — Ideal)

## 4.0 Database Services

### 4.1 Azure SQL Database & SQL Managed Instance
#### 4.1.1 Azure SQL DB Service Tiers
- 4.1.1.1 DTU model — bundled CPU+IO+memory — Basic/Standard/Premium
  - 4.1.1.1.1 DTU ratio — 1 Basic DTU = fixed compute+storage bundle
  - 4.1.1.1.2 Legacy — migrate to vCore for more control and savings
- 4.1.1.2 vCore model — General Purpose / Business Critical / Hyperscale
  - 4.1.1.2.1 General Purpose — remote SSD — 5ms IO latency — most workloads
  - 4.1.1.2.2 Business Critical — local SSD — <2ms latency — 3 readable replicas
  - 4.1.1.2.3 Hyperscale — distributed architecture — up to 100TB — fast backups

#### 4.1.2 Azure SQL Hyperscale Architecture
- 4.1.2.1 Separation of compute and storage — page servers — log service
  - 4.1.2.1.1 Page servers — distributed storage — each caches subset of data
  - 4.1.2.1.2 Log service — write log records — async propagation to page servers
- 4.1.2.2 Named replicas — independently scaled read replicas — separate workloads
  - 4.1.2.2.1 Up to 30 replicas — high-read scenarios — reporting, analytics
- 4.1.2.3 Backup — snapshot-based — no impact to compute — minutes not hours

#### 4.1.3 SQL Managed Instance
- 4.1.3.1 Near 100% SQL Server compatibility — VNet-injected — private only
  - 4.1.3.1.1 SQL Agent, CLR, linked servers, Service Broker — not in SQL DB
  - 4.1.3.1.2 Subnet delegation — /24 minimum — dedicated to MI
- 4.1.3.2 Business Critical tier — Always On AG — 4 replicas — local SSD
  - 4.1.3.2.1 Read-scale — free readable secondary — no extra cost
- 4.1.3.3 Instance pools — share compute — multiple small MI on same vCore set
  - 4.1.3.3.1 Cost optimization — consolidate dev/test instances

#### 4.1.4 Elastic Pools
- 4.1.4.1 Shared eDTU or vCore pool — multiple DBs peak at different times
  - 4.1.4.1.1 Per-DB min/max — guarantee floor and ceiling per database
  - 4.1.4.1.2 Cost efficiency — 50+ DBs with varied peaks — pool saves ~50%

#### 4.1.5 High Availability & BCDR
- 4.1.5.1 Active Geo-Replication — up to 4 secondaries — async — any region
  - 4.1.5.1.1 Forced failover — secondary becomes primary — no data loss guarantee
  - 4.1.5.1.2 Online secondary — readable — offload analytics/reporting
- 4.1.5.2 Auto-Failover Groups — DNS abstraction — read/write + read-only endpoints
  - 4.1.5.2.1 GracePeriodWithDataLossHours — tolerate data loss before auto-failover
  - 4.1.5.2.2 Planned failover — zero data loss — swap roles gracefully

### 4.2 Azure Cosmos DB
#### 4.2.1 Cosmos DB Global Distribution
- 4.2.1.1 Multi-region writes — active-active — any region accepts writes
  - 4.2.1.1.1 Conflict resolution — last write wins (LWW) or custom merge procedure
  - 4.2.1.1.2 Conflict feed — read and resolve via stored procedure
- 4.2.1.2 Single-region write — hub + read replicas — 99.99% SLA
  - 4.2.1.2.1 Transparent replication — add/remove regions via portal/API — no downtime
  - 4.2.1.2.2 Preferred locations list — SDK-level read routing order

#### 4.2.2 Consistency Levels
- 4.2.2.1 Strong — linearizable reads — highest latency — 2x RU cost
- 4.2.2.2 Bounded Staleness — K versions or T seconds behind — global order guaranteed
  - 4.2.2.2.1 Default: 100K operations or 5 seconds — configurable
- 4.2.2.3 Session — read-your-writes within session token — default — most used
  - 4.2.2.3.1 Session token — vector clock — client SDK tracks automatically
- 4.2.2.4 Consistent Prefix — no out-of-order reads — weaker than session
- 4.2.2.5 Eventual — lowest latency — no ordering guarantee — 50% cheaper read

#### 4.2.3 Request Units (RU)
- 4.2.3.1 Normalized cost unit — CPU + IO + memory + index — per operation
  - 4.2.3.1.1 1 RU = read 1KB item — point read cheapest operation
  - 4.2.3.1.2 Write cost — higher than read — 5–10 RUs for 1KB item
- 4.2.3.2 Provisioned throughput — manual or autoscale — RU/s per container
  - 4.2.3.2.1 Autoscale — 10% to 100% of max RU/s — sub-second scale
  - 4.2.3.2.2 Partition throughput limit — 10K RU/s per logical partition
- 4.2.3.3 Serverless — per-operation billing — no provisioned throughput
  - 4.2.3.3.1 Single region only — no global distribution in serverless

#### 4.2.4 Cosmos DB APIs
- 4.2.4.1 NoSQL (native) — JSON — SQL-like query — richest feature set
- 4.2.4.2 MongoDB — wire protocol — BSON — driver compatibility
  - 4.2.4.2.1 Version 4.2/4.0/3.6 supported — aggregation pipeline
- 4.2.4.3 Cassandra — CQL wire protocol — wide-column model
- 4.2.4.4 Gremlin — graph traversal — Apache TinkerPop compatible
- 4.2.4.5 Table — Azure Table Storage compatible — migration path
- 4.2.4.6 PostgreSQL (Citus) — distributed PostgreSQL — sharding built-in

#### 4.2.5 Cosmos DB Indexing
- 4.2.5.1 Default policy — all properties indexed — inverted index
  - 4.2.5.1.1 Exclude paths — reduce RU cost for write-heavy workloads
  - 4.2.5.1.2 Composite index — range queries + ORDER BY — required for multi-field sort
- 4.2.5.2 Spatial indexes — GeoJSON — geospatial queries — ST_WITHIN, ST_INTERSECTS

### 4.3 Azure Cache for Redis
#### 4.3.1 Cache Tiers
- 4.3.1.1 Basic — single node — no replication — dev/test only
- 4.3.1.2 Standard — primary + replica — 99.9% SLA — automatic failover
- 4.3.1.3 Premium — VNet injection, persistence, clustering, geo-replication
  - 4.3.1.3.1 Redis Cluster — up to 10 shards — linear scaling
  - 4.3.1.3.2 RDB persistence — point-in-time snapshot — configurable interval
  - 4.3.1.3.3 AOF persistence — every-second fsync — stronger durability
- 4.3.1.4 Enterprise (Redis Stack) — RediSearch, RedisJSON, RedisTimeSeries, RedisBloom
  - 4.3.1.4.1 Active geo-replication — multi-region active-active — CRDT-based
  - 4.3.1.4.2 99.999% SLA — highest availability tier

### 4.4 Azure Database for PostgreSQL & MySQL
#### 4.4.1 Flexible Server Architecture
- 4.4.1.1 Zone-redundant HA — standby in different AZ — 99.99% SLA
  - 4.4.1.1.1 Streaming replication — synchronous — RPO=0 — RTO <120s
  - 4.4.1.1.2 Same-zone HA — RPO=0 — cheaper — no AZ isolation
- 4.4.1.2 Read replicas — async — up to 5 — cross-region supported
  - 4.4.1.2.1 Promote replica — standalone — no data loss planned failover
- 4.4.1.3 Burstable compute — B-series VMs — dev/test — credits-based CPU

### 4.5 Backup & PITR
#### 4.5.1 Azure SQL Backup
- 4.5.1.1 Automated backups — full weekly, diff 12hr, log 5–12min
  - 4.5.1.1.1 Retention 1–35 days (SQL DB) / 1–35 days (MI)
  - 4.5.1.1.2 Long-term retention (LTR) — weekly/monthly/yearly — up to 10 years
- 4.5.1.2 PITR restore — new DB/MI — cannot overwrite source
  - 4.5.1.2.1 Restore time objective — typically <12 minutes for SQL DB

#### 4.5.2 Cosmos DB Backup
- 4.5.2.1 Continuous backup — PITR — any point in last 30 days (max)
  - 4.5.2.1.1 Restore granularity — account/database/container level
  - 4.5.2.1.2 Cross-region restore — restore to any region from backup
- 4.5.2.2 Periodic backup — default — every 4hrs — 2 copies — free
