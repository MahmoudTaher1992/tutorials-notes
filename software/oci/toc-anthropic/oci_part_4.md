# OCI Complete Study Guide - Part 4: Phase 1 — Databases

## 4.0 Databases

### 4.1 Oracle Database on OCI (ExaDB & BaseDB)
#### 4.1.1 DB Systems Architecture
- 4.1.1.1 DB System — VM or BM — Oracle DB software managed by OCI
  - 4.1.1.1.1 VM.Standard — shared host — up to 2-node RAC — AD-spread
  - 4.1.1.1.2 BM.DenseIO — bare metal — local NVMe — single-node high throughput
  - 4.1.1.1.3 2-node RAC — Oracle Real Application Clusters — shared block storage
- 4.1.1.2 DB versions — 11g/12c/19c/21c/23ai — license included or BYOL
  - 4.1.1.2.1 License Included — Standard/Enterprise Edition — pay-as-you-go
  - 4.1.1.2.2 BYOL — Bring Your Own License — lower compute cost — compliance

#### 4.1.2 Exadata Cloud Infrastructure (ExaDB-D / ExaCS)
- 4.1.2.1 ExaDB-D (Dedicated Infrastructure) — Exadata hardware — customer-dedicated
  - 4.1.2.1.1 Quarter/Half/Full rack — 2/4/8 DB servers + 3/5 storage servers
  - 4.1.2.1.2 Smart Scan — storage cell offload — eliminates data movement — 10–100x
  - 4.1.2.1.3 RDMA over InfiniBand — 100 Gbps — storage cell direct memory access
- 4.1.2.2 ExaDB-XS (Exadata Cloud@Customer small) — on-prem Exadata — OCI managed
  - 4.1.2.2.1 2 DB nodes + 3 storage servers — smaller footprint — data sovereignty
- 4.1.2.3 Exadata features unique to OCI
  - 4.1.2.3.1 In-Memory Columnar Flash Cache — L2 cache — Optane PMem — analytics
  - 4.1.2.3.2 Automatic Storage Management (ASM) — striping + mirroring — managed
  - 4.1.2.3.3 Exadata Smart Flash Cache — NVMe tiers — hot data automatically cached

#### 4.1.3 Data Guard & RMAN Backup
- 4.1.3.1 Data Guard — standby DB — redo log shipping — RPO near-zero
  - 4.1.3.1.1 Maximum Availability — synchronous — zero data loss — potential latency
  - 4.1.3.1.2 Maximum Performance — asynchronous — low latency — small data loss risk
  - 4.1.3.1.3 Automatic failover — Observer — Fast-Start Failover — 30-second RTO
- 4.1.3.2 RMAN backup — OCI-managed — stored in Object Storage — encrypted
  - 4.1.3.2.1 Incremental backup schedule — daily incremental + weekly full
  - 4.1.3.2.2 PITR — recover to any SCN/timestamp within retention — WAL equivalent

### 4.2 Autonomous Database (ADB)
#### 4.2.1 ADB Architecture
- 4.2.1.1 Serverless ADB — shared Exadata infrastructure — auto-tune — no DBA tasks
  - 4.2.1.1.1 Autonomous Transaction Processing (ATP) — OLTP — index tuning — compression
  - 4.2.1.1.2 Autonomous Data Warehouse (ADW) — OLAP — columnar — partition pruning
  - 4.2.1.1.3 APEX Service — low-code platform — built on ADB — managed APEX
- 4.2.1.2 Dedicated ADB — Exadata Cloud@Customer or ExaDB-D — customer VCN
  - 4.2.1.2.1 Autonomous Exadata VM Cluster — provision ADBs — isolation control

#### 4.2.2 ADB Auto-Tuning Features
- 4.2.2.1 Automatic indexing — ML — create/drop indexes — background — transparent
  - 4.2.2.1.1 Advisor report — explain which indexes created — rationale + improvement
  - 4.2.2.1.2 Verification — auto-index tested before promoting to visible — safe deploy
- 4.2.2.2 Automatic statistics — gather fresh stats — query optimizer accuracy
- 4.2.2.3 Workload management — concurrency levels (MEDIUM/HIGH/LOW) — queuing
  - 4.2.2.3.1 Parallel degree policy — adaptive — scales based on OCPU count
  - 4.2.2.3.2 Consumer groups — app-level isolation — runaway query protection

#### 4.2.3 ADB Connectivity & Security
- 4.2.3.1 Private endpoint — ADB in VCN — no public IP — NSG support
  - 4.2.3.1.1 mTLS or TLS — wallet download or connection string
  - 4.2.3.1.2 Access Control Rules — CIDR allowlist — on-prem + VCN CIDRs
- 4.2.3.2 Oracle Wallet — credentials bundle — downloaded from console — auto-rotate
  - 4.2.3.2.1 Managed wallet — no download — connect via managed access — ADB-S
- 4.2.3.3 Data Safe integration — sensitive data discovery — masking — audit
  - 4.2.3.3.1 Security Assessment — CIS benchmark — risk scoring — remediation guide

### 4.3 MySQL HeatWave
#### 4.3.1 HeatWave Architecture
- 4.3.1.1 MySQL DB System — managed MySQL — InnoDB — Multi-AZ HA
  - 4.3.1.1.1 HA shape — primary + standby — synchronous replication — 60s failover
  - 4.3.1.1.2 Read replicas — up to 18 — async — horizontal read scale
- 4.3.1.2 HeatWave cluster — in-memory columnar acceleration — OLAP on MySQL
  - 4.3.1.2.1 HeatWave nodes — data partitioned in RAM — massively parallel query
  - 4.3.1.2.2 Auto parallel load — MySQL → HeatWave RAM — transparent to queries
  - 4.3.1.2.3 No ETL required — same MySQL DB — SELECT auto-routed to HeatWave

#### 4.3.2 HeatWave AutoML
- 4.3.2.1 HeatWave ML — train + infer in DB — SQL syntax — no Python needed
  - 4.3.2.1.1 ML.TRAIN — specify target column — auto feature engineering
  - 4.3.2.1.2 ML.PREDICT — inline inference in SQL SELECT — no external call
- 4.3.2.2 HeatWave GenAI — LLM integration — in-database — vector store
  - 4.3.2.2.1 Vector embeddings — store in MySQL — similarity search in SQL
  - 4.3.2.2.2 RAG — HeatWave retrieves context — passes to LLM — grounded answers

### 4.4 NoSQL Database
#### 4.4.1 OCI NoSQL Architecture
- 4.4.1.1 Managed NoSQL — key-value + document — JSON-native — Oracle KV Store engine
  - 4.4.1.1.1 Capacity modes — provisioned (RU/WU) — on-demand (pay per op)
  - 4.4.1.1.2 Tables — schema-on-write — typed columns — index secondary keys
- 4.4.1.2 Consistency models — Eventual (default) vs. Absolute (read from primary)
  - 4.4.1.2.1 Absolute consistency — higher latency — guaranteed latest value

### 4.5 Cache Service (Redis)
#### 4.5.1 OCI Cache Architecture
- 4.5.1.1 Managed Redis — Redis 7 compatible — cluster topology
  - 4.5.1.1.1 Node types — VM.Standard shapes — memory-optimized
  - 4.5.1.1.2 Cluster mode — automatic sharding — 6 nodes (3 primary + 3 replica)
- 4.5.1.2 Persistence — RDB snapshots — stored in attached block volume
  - 4.5.1.2.1 AOF persistence — append-only file — durable writes — slower performance
- 4.5.1.3 Private access — VCN subnet — no public IP — NSG port 6379
