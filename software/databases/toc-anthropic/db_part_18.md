# Databases Complete Study Guide - Part 18: ClickHouse & Database Selection

## 34.0 ClickHouse

### 34.1 Architecture
#### 34.1.1 MergeTree Engine Family
- 34.1.1.1 MergeTree — primary storage engine — columnar — sorted by primary key — parts
  - 34.1.1.1.1 Data part — immutable directory — column files + marks + primary.idx — append only
  - 34.1.1.1.2 Granule — unit of index — 8192 rows default — primary index stores granule first row
  - 34.1.1.1.3 Merges — background process — merge small parts — reduce part count — read efficiency
- 34.1.1.2 ReplacingMergeTree — deduplicate rows by sorting key — last version wins on merge
  - 34.1.1.2.1 Eventual deduplication — async merge — query may see duplicates — FINAL keyword
  - 34.1.1.2.2 FINAL — force deduplication at query time — correct but slower — use where needed
- 34.1.1.3 AggregatingMergeTree — store aggregate states — pre-aggregate on merge — fast rollups
  - 34.1.1.3.1 AggregateFunction(sum, UInt64) — binary state — mergeState — for materialized views
- 34.1.1.4 CollapsingMergeTree — sign column — +1 insert / -1 delete — merge collapses pair
  - 34.1.1.4.1 VersionedCollapsingMergeTree — version column — order-independent — safe for updates
- 34.1.1.5 SummingMergeTree — auto-sum numeric columns on merge — simple aggregation workloads
- 34.1.1.6 ReplicatedMergeTree — ZooKeeper / ClickHouse Keeper — replicated — HA variant
  - 34.1.1.6.1 ZooKeeper stores part metadata — quorum insert — log of mutations — sync replicas

#### 34.1.2 Columnar Storage
- 34.1.2.1 Per-column files — .bin (data) + .mrk (marks) — each column independent — pruning
  - 34.1.2.1.1 LZ4 default compression — fast decompress — Zstd for better ratio — per column
  - 34.1.2.1.2 Delta codec — integers — store differences — sequential IDs compress to near-zero
  - 34.1.2.1.3 Gorilla codec — floats — XOR delta — metrics data — 10x compression
- 34.1.2.2 Sparse primary index — granule-level — fits in memory — binary search → data skip
  - 34.1.2.2.1 ORDER BY (date, user_id) — queries filter by date first — skip granules
  - 34.1.2.2.2 Skipping indexes — min_max / bloom_filter / set — secondary data skip — optional

### 34.2 Query Execution
#### 34.2.1 Vectorized Pipeline
- 34.2.1.1 Block-oriented processing — 65536 rows per block — SIMD on columns — cache-friendly
  - 34.2.1.1.1 Pipeline processors — DAG of transformations — multi-threaded per query
  - 34.2.1.1.2 Intrinsics — SSE4.2 / AVX2 — count bits / filter rows — hardware acceleration
- 34.2.1.2 Distributed query — table distributed engine — fan out to shards — merge at initiator
  - 34.2.1.2.1 Distributed table — virtual — routes to shards — transparent to application
  - 34.2.1.2.2 Global IN — avoid per-shard IN evaluation — broadcast subquery result to all shards

#### 34.2.2 Materialized Views
- 34.2.2.1 Trigger on insert — transform + insert to target table — real-time aggregation
  - 34.2.2.1.1 .inner table — hidden target — MV reads from source — writes aggregated
  - 34.2.2.1.2 Chained MVs — output of one MV feeds another — multi-stage pre-aggregation
- 34.2.2.2 Projections — pre-sorted + pre-aggregated stored alongside table — automatic use
  - 34.2.2.2.1 Defined inside table DDL — no separate MV — planner auto-selects — simpler

---

## 35.0 Database Selection Guide

### 35.1 Decision Framework
#### 35.1.1 Workload Classification
- 35.1.1.1 OLTP criteria — low latency (< 10ms) — high write rate — point lookups — ACID txns
  - 35.1.1.1.1 PostgreSQL — complex queries + JSON + extensions — general-purpose OLTP
  - 35.1.1.1.2 MySQL — ecosystem maturity — web apps — simple schema — high compatibility
  - 35.1.1.1.3 DynamoDB — key-value OLTP — extreme scale — serverless — single-digit ms
- 35.1.1.2 OLAP criteria — large scans — aggregations — columnar — batch ETL — BI dashboards
  - 35.1.1.2.1 ClickHouse — sub-second analytics — on-prem — high ingestion — open source
  - 35.1.1.2.2 BigQuery — serverless — GCP ecosystem — pay per query — ML integration
  - 35.1.1.2.3 Snowflake — multi-cloud — semi-structured — Time Travel — enterprise features
- 35.1.1.3 Specialized criteria — choose based on access pattern
  - 35.1.1.3.1 Graph relationships — Neo4j / Neptune — multi-hop traversal first priority
  - 35.1.1.3.2 Time-series metrics — InfluxDB / TimescaleDB — high-rate append — retention
  - 35.1.1.3.3 Full-text search — Elasticsearch / OpenSearch — inverted index — relevance
  - 35.1.1.3.4 Vector similarity — pgvector / Qdrant / Pinecone — embedding search — RAG

#### 35.1.2 Operational Considerations
- 35.1.2.1 Operational overhead — managed (RDS/Cloud SQL) vs. self-managed — team expertise
  - 35.1.2.1.1 Managed saves ops — patching / backups / HA automated — higher cost
  - 35.1.2.1.2 Self-managed — more control — custom tuning — requires DBA expertise
- 35.1.2.2 Consistency requirements — CP vs AP — serializable vs eventual — use case tolerance
  - 35.1.2.2.1 Financial systems — ACID + serializable — PostgreSQL / Spanner / CockroachDB
  - 35.1.2.2.2 User activity feeds — eventual consistency OK — Cassandra / DynamoDB
- 35.1.2.3 Scale requirements — single node sufficient vs. distributed — premature scaling cost
  - 35.1.2.3.1 Start with PostgreSQL — scale to CockroachDB/Spanner when needed — proven path
  - 35.1.2.3.2 Read replicas first — cheap horizontal read scale — before sharding
