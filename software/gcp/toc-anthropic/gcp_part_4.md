# GCP Complete Study Guide - Part 4: Database Services (Phase 1 — Ideal)

## 4.0 Database Services

### 4.1 Cloud SQL
#### 4.1.1 Cloud SQL Architecture
- 4.1.1.1 Managed RDBMS — PostgreSQL 9.6–16, MySQL 5.7/8.0, SQL Server 2019/2022
  - 4.1.1.1.1 Instance tier — shared-core (micro/small) vs. dedicated (db-n1, db-n2, custom)
  - 4.1.1.1.2 Storage — SSD (default) or HDD — auto-increase — max 64TB
- 4.1.1.2 High Availability — failover replica — zonal — synchronous replication
  - 4.1.1.2.1 Failover time — 60s typical — DNS cutover — same IP endpoint
  - 4.1.1.2.2 Regional HA — cross-region read replicas — manual promotion
- 4.1.1.3 Read replicas — async — up to 10 — cross-region — cascade replicas
  - 4.1.1.3.1 Cascade replica — replica of replica — reduce primary replication load
- 4.1.1.4 Database flags — tuning parameters — per-engine — restart/no-restart
  - 4.1.1.4.1 Query Insights — slow query log — execution plan — wait events
  - 4.1.1.4.2 Database Query Insights — in-query plan visualization — production safe

#### 4.1.2 Cloud SQL Features
- 4.1.2.1 Cloud SQL Auth Proxy — IAM-authenticated connections — no IP whitelisting
  - 4.1.2.1.1 Unix/TCP sockets — app connects to proxy — proxy handles TLS+IAM
  - 4.1.2.1.2 Cloud SQL connector libraries — Java/Python/Go — connection pooling
- 4.1.2.2 Maintenance windows — preferred maintenance day + hour — 1hr window
- 4.1.2.3 Private IP — VPC peering to service networking — RFC 1918 — no public IP
  - 4.1.2.3.1 Private Service Connect — PSC endpoint — more secure than peering

### 4.2 Cloud Spanner
#### 4.2.1 Spanner Architecture
- 4.2.1.1 Globally distributed relational — ACID — external consistency (strong)
  - 4.2.1.1.1 TrueTime API — GPS + atomic clocks — bounded clock uncertainty
  - 4.2.1.1.2 External consistency = linearizability — strongest consistency model
- 4.2.1.2 Paxos replication — 3+ replicas — cross-zone (regional) or cross-region (multi)
  - 4.2.1.2.1 Regional — 3 read-write replicas — write latency <10ms
  - 4.2.1.2.2 Multi-region — up to 5 regions — write commits to Paxos majority
  - 4.2.1.2.3 Leader region — closest to writes — minimize latency
- 4.2.1.3 F1 Query — SQL dialect — ANSI 2011 + extensions — distributed joins

#### 4.2.2 Spanner Schema & Performance
- 4.2.2.1 Interleaved tables — co-locate child rows with parent — avoid cross-shard joins
  - 4.2.2.1.1 INTERLEAVE IN PARENT — physical locality — parent + children on same split
- 4.2.2.2 Split points — automatic shard boundaries — hotspot detection + splitting
  - 4.2.2.2.1 Key range splits — UUID keys recommended — avoid monotonic hotspot
- 4.2.2.3 Spanner nodes (compute units) — 1 node = 1,000 QPS reads + 2,000 writes
  - 4.2.2.3.1 Processing units — 100 PU = 1 node — granular scaling (100 PU increments)
- 4.2.2.4 Change Streams — CDC — ordered per key — Dataflow connector
  - 4.2.2.4.1 Partition-level ordering — total order per partition — not global
  - 4.2.2.4.2 Heartbeat record — inactivity marker — track progress in streaming jobs

### 4.3 AlloyDB for PostgreSQL
#### 4.3.1 AlloyDB Architecture
- 4.3.1.1 Google-managed PostgreSQL — intelligent storage — 4x faster OLTP than RDS PG
  - 4.3.1.1.1 Disaggregated storage — shared log — read replicas share storage layer
  - 4.3.1.1.2 ColumnStore — automatic columnar acceleration — analytical queries 100x faster
- 4.3.1.2 Primary instance + up to 20 read pool instances
  - 4.3.1.2.1 Read pool — auto-scale — add/remove nodes — zero downtime
  - 4.3.1.2.2 HA — cross-zone standby — automatic failover <60s
- 4.3.1.3 AlloyDB Omni — run AlloyDB locally or on other clouds — fully compatible
  - 4.3.1.3.1 Same wire protocol — pg_dump/restore — migration path

#### 4.3.2 AlloyDB AI Features
- 4.3.2.1 Vector support — pgvector built-in — HNSW + IVFFlat indexes
  - 4.3.2.1.1 ScaNN index — Google's ANN algorithm — billion-scale vectors in Postgres
  - 4.3.2.1.2 real_embedding() — call Vertex AI embedding model from SQL
- 4.3.2.2 Adaptive autovacuum — ML-tuned — reduces bloat — consistent latency

### 4.4 Firestore (NoSQL Document)
#### 4.4.1 Firestore Architecture
- 4.4.1.1 Serverless NoSQL — multi-region — strong consistency — real-time sync
  - 4.4.1.1.1 Native mode vs. Datastore mode — Native = mobile/web SDK support
  - 4.4.1.1.2 Collections → Documents → Subcollections — hierarchical data model
- 4.4.1.2 Real-time listeners — onSnapshot — mobile/web push updates
  - 4.4.1.2.1 Offline support — local cache — sync on reconnect — mobile-first
- 4.4.1.3 Atomic operations — transactions (read+write) and batched writes
  - 4.4.1.3.1 Transactions — up to 500 documents per transaction — optimistic locking
  - 4.4.1.3.2 Batched writes — up to 500 operations — no reads — fire-and-forget

#### 4.4.2 Firestore Queries
- 4.4.2.1 Composite indexes — required for multi-field queries — auto-suggested
  - 4.4.2.1.1 Ascending + descending — order matters — index per direction combo
- 4.4.2.2 Collection group queries — query across all subcollections with same ID
  - 4.4.2.2.1 Requires collection group index — single-field exemptions available
- 4.4.2.3 Count/Sum/Avg aggregations — server-side — no full document download

### 4.5 Cloud Bigtable
#### 4.5.1 Bigtable Architecture
- 4.5.1.1 Wide-column NoSQL — massive scale — petabytes — low-latency HBase-compatible
  - 4.5.1.1.1 Row key — sorted — lexicographic — single index — design critical
  - 4.5.1.1.2 Column families — grouped — separate GC policy per family
- 4.5.1.2 Storage — LSM tree (Log-Structured Merge) — Colossus (GFS successor)
  - 4.5.1.2.1 Tablet server — serves subset of table — rebalances automatically
  - 4.5.1.2.2 Compaction — minor (in memory) → major (merge SSTables) — background
- 4.5.1.3 Cluster types — SSD (latency-sensitive) vs. HDD (analytics, batch)
  - 4.5.1.3.1 SSD — single-digit ms — up to 1.5M QPS per cluster
  - 4.5.1.3.2 HDD — 10ms — 3x cheaper per GB — batch Hadoop/Dataflow
- 4.5.1.4 Replication — multi-cluster — routing policies — eventually consistent
  - 4.5.1.4.1 Routing policy — MULTI_CLUSTER_USE_ANY — any cluster handles reads
  - 4.5.1.4.2 Failover routing — survive cluster failure — automatic reroute

#### 4.5.2 Bigtable Key Design
- 4.5.2.1 Row key hotspot — sequential keys → single tablet overload
  - 4.5.2.1.1 Key reversal — reverse timestamp — most recent first — no hotspot
  - 4.5.2.1.2 Field promotion — composite key — tenantId#metric#reverse_timestamp
- 4.5.2.2 Key visualizer — heatmap — identify hotspots — read/write distribution

### 4.6 Memorystore
#### 4.6.1 Memorystore for Redis
- 4.6.1.1 Basic tier — single node — no HA — dev/test
- 4.6.1.2 Standard tier — HA — primary + replica — automatic failover — 99.9% SLA
  - 4.6.1.2.1 Failover time — <1 minute — DNS TTL 30s — reconnect required
- 4.6.1.3 Memorystore for Redis Cluster — horizontal sharding — 15 shard nodes max
  - 4.6.1.3.1 99.99% SLA — auto-shard rebalancing — read replicas per shard
- 4.6.1.4 Memorystore for Valkey — open-source Redis fork — future-proof choice

### 4.7 Backup & PITR
#### 4.7.1 Cloud SQL Backup
- 4.7.1.1 Automated backups — daily — 7 backups retained by default (1–365)
  - 4.7.1.1.1 On-demand backups — persist until deleted — not counted in retained count
  - 4.7.1.1.2 PITR — transaction log replay — restore to any second in retention window
- 4.7.1.2 Cross-region backup — replicate backup to another region — DR
  - 4.7.1.2.1 Requires binary logging enabled (MySQL) or WAL (PostgreSQL)
