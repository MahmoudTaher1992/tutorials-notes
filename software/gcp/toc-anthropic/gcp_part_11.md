# GCP Complete Study Guide - Part 11: Phase 2 — Cloud SQL, Spanner, AlloyDB, Firestore, Bigtable

## 19.0 Cloud SQL

### 19.1 Cloud SQL Core
→ See Ideal §4.1 Cloud SQL, §4.7 Backup & PITR

#### 19.1.1 Cloud SQL-Unique Features
- **Unique: Cloud SQL Auth Proxy / Connector** — IAM-authenticated — no IP whititelisting
  - 19.1.1.1 cloud-sql-proxy binary — local TCP/Unix socket — TLS to Cloud SQL
  - 19.1.1.2 Connector libraries — Java/Python/Go/Node — built-in pool + automatic IAM
  - 19.1.1.3 Workload Identity + Cloud SQL — Pod SA → Cloud SQL client role
- **Unique: Private Service Connect for Cloud SQL** — PSC endpoint — most secure
  - 19.1.1.4 Replaces VPC peering — no CIDR overlap issue — per-instance endpoint
- **Unique: Cloud SQL Enterprise Plus edition** — Data Cache (Persistent Disk → SSD)
  - 19.1.1.5 Data Cache — buffer pool backed by local SSD — 3x read performance
  - 19.1.1.6 Maintenance window deferral — 7-day window — Enterprise Plus only
- **Unique: Query Insights** — production-safe query analysis — plan + wait events
  - 19.1.1.7 Top queries by duration/scan bytes — lock wait analysis
  - 19.1.1.8 Query plan — EXPLAIN ANALYZE equivalent — visual in console
- **Unique: PITR — transaction log replay** — restore to any second in retention
  - 19.1.1.9 Binary log (MySQL) / WAL (PostgreSQL) — stored in Cloud Storage
  - 19.1.1.10 Cross-region PITR — restore to a different region — DR scenario

---

## 20.0 Cloud Spanner

### 20.1 Spanner Core
→ See Ideal §4.2 Cloud Spanner, §4.2.1 Architecture, §4.2.2 Schema & Performance

#### 20.1.1 Spanner-Unique Features
- **Unique: TrueTime API** — GPS + atomic clocks — bounded uncertainty interval
  - 20.1.1.1 Commit timestamps — TT.now() — guaranteed after commit completes
  - 20.1.1.2 External consistency — globally linearizable — no other DB achieves this
- **Unique: Change Streams** — CDC ordered per key — native Dataflow connector
  - 20.1.1.3 Partition tokens — distribute stream processing — parallel consumers
  - 20.1.1.4 Heartbeat records — track progress during inactivity — prevent lag
- **Unique: Processing Units (granular billing)** — 100 PU = 1 node — fine-grained scale
  - 20.1.1.5 100 PU minimum for regional — 1000 PU for multi-region
  - 20.1.1.6 Autoscaling — min/max PU — Spanner manages scaling decisions
- **Unique: Spanner Graph (preview)** — graph queries on Spanner tables — GQL syntax
  - 20.1.1.7 Property graph definition — nodes + edges from existing tables
  - 20.1.1.8 Graph queries — path traversal — reachability — same ACID guarantees
- **Unique: Spanner INFORMATION_SCHEMA** — query metadata — schema + stats + locks
  - 20.1.1.9 SPANNER_SYS.QUERY_STATS_TOP_MINUTE — identify hot queries
  - 20.1.1.10 LOCK_STATS — identify lock contention — diagnose latency spikes

---

## 21.0 AlloyDB for PostgreSQL

### 21.1 AlloyDB Core
→ See Ideal §4.3 AlloyDB Architecture, §4.3.2 AI Features

#### 21.1.1 AlloyDB-Unique Features
- **Unique: Columnar Engine** — auto in-memory columnar acceleration — OLTP + OLAP
  - 21.1.1.1 Zero config — optimizer detects analytical queries — accelerates automatically
  - 21.1.1.2 Columnar cache — 100x faster analytical queries — no separate DW
- **Unique: AI/ML integration** — embeddings in PostgreSQL via AlloyDB AI
  - 21.1.1.3 google_ml_integration extension — call Vertex AI embedding from SQL
  - 21.1.1.4 ScaNN index — Google ANN — outperforms pgvector at scale — SQL native
  - 21.1.1.5 embedding() function — auto-embed text column — vector stored in table
- **Unique: AlloyDB Omni** — same engine — run anywhere — on-prem or other cloud
  - 21.1.1.6 Docker/K8s deployment — identical wire protocol — migration path
  - 21.1.1.7 Kubernetes operator — AlloyDB Omni operator — managed lifecycle

---

## 22.0 Firestore

### 22.1 Firestore Core
→ See Ideal §4.4 Firestore Architecture, §4.4.2 Queries

#### 22.1.1 Firestore-Unique Features
- **Unique: Real-time listeners** — onSnapshot — push to mobile/web — offline-first
  - 22.1.1.1 Persistent cache — local SQLite — offline reads + queued writes
  - 22.1.1.2 Multi-tab offline — shared web worker — single cache across tabs
- **Unique: Multi-database support** — multiple Firestore DBs per project — isolation
  - 22.1.1.3 Named databases — (default) + custom — separate IAM and billing
  - 22.1.1.4 Use case — per-customer isolation — dev/prod in same project
- **Unique: TTL policies** — auto-delete documents after expiry field value
  - 22.1.1.5 TTL field — Timestamp — Firestore deletes when past — eventually consistent
  - 22.1.1.6 Delete rate — best-effort — not guaranteed within seconds
- **Unique: Firestore vector search** — store + query embedding vectors in documents
  - 22.1.1.7 ARRAY type for vector — findNearest() query — KNN search
  - 22.1.1.8 Vector index — flat or IVF — dedicated index for performance
- **Unique: Count/Sum/Avg aggregation queries** — server-side — no full doc download
  - 22.1.1.9 AggregateQuery — RunAggregationQuery — pay per 1K docs scanned

---

## 23.0 Cloud Bigtable

### 23.1 Bigtable Core
→ See Ideal §4.5 Cloud Bigtable Architecture, §4.5.2 Key Design

#### 23.1.1 Bigtable-Unique Features
- **Unique: HBase API compatibility** — migrate from HBase — no app code change
  - 23.1.1.1 HBase client library — bigtable-hbase-beam — Dataflow integration
- **Unique: Key Visualizer** — heatmap of row key access — find hotspots visually
  - 23.1.1.2 Column family heatmap — identify hottest families — GC tuning
  - 23.1.1.3 Access patterns over time — scroll timeline — correlate with incidents
- **Unique: App profiles** — routing policies — multi-cluster load balancing
  - 23.1.1.4 Single-cluster routing — specific cluster — low-latency reads
  - 23.1.1.5 Multi-cluster routing — auto-failover — read from nearest cluster
  - 23.1.1.6 Single-row transactions — use single-cluster profile — consistent reads
- **Unique: Autoscaling** — node count auto-managed — CPU + storage targets
  - 23.1.1.7 Min/max nodes — CPU target % — storage utilization threshold
  - 23.1.1.8 Scale-up faster than scale-down — prevent latency spikes on traffic burst
- **Unique: Data Boost** — serverless read compute — no impact on cluster nodes
  - 23.1.1.9 Dataflow jobs — Bigtable Data Boost — reads don't consume node CPU
  - 23.1.1.10 Separate billing — per RU consumed — decouple analytics from serving
