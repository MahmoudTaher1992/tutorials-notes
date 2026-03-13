# Data Observability Complete Study Guide - Part 5: Schema Management & Metadata

## 9.0 Schema Management & Evolution

### 9.1 Schema Change Types
#### 9.1.1 Change Classification
- 9.1.1.1 Backward-compatible changes — consumers continue to work without modification
  - 9.1.1.1.1 Add nullable column — existing queries unaffected — safe to deploy
  - 9.1.1.1.2 Add new table / topic — no existing consumer breaks — additive change
  - 9.1.1.1.3 Widen column type — INT → BIGINT — implicit cast — usually safe
- 9.1.1.2 Forward-compatible changes — old producers can write to new schema
  - 9.1.1.2.1 Add field with default — old writer omits field — default filled — safe read
- 9.1.1.3 Breaking changes — cause consumer failures — require coordinated migration
  - 9.1.1.3.1 Rename column — downstream SELECT fails — DWH queries break — blast radius
  - 9.1.1.3.2 Remove column — downstream consumers crash — requires deprecation cycle
  - 9.1.1.3.3 Change data type — FLOAT → STRING — implicit cast may fail — silent errors
  - 9.1.1.3.4 Change partitioning — rewrite queries + historical backfill — expensive

#### 9.1.2 Schema Registry
- 9.1.2.1 Schema registry — central store of schema versions — Kafka / Confluent / AWS Glue
  - 9.1.2.1.1 Schema ID — embedded in message header — consumer fetches schema on first seen
  - 9.1.2.1.2 Avro / Protobuf / JSON Schema — serialization formats — registry-registered
- 9.1.2.2 Compatibility modes — enforced at registry — BACKWARD / FORWARD / FULL / NONE
  - 9.1.2.2.1 BACKWARD — new schema can read old data — add nullable fields — remove with default
  - 9.1.2.2.2 FORWARD — old schema can read new data — consumers safe during rolling deploy
  - 9.1.2.2.3 FULL — both directions — safest — most restrictive — enterprise recommendation
  - 9.1.2.2.4 NONE — no validation — dangerous — only for dev/experimental topics

### 9.2 Schema Change Workflow
#### 9.2.1 Change Management
- 9.2.1.1 Schema change review — PR-based — dbt model diff — lineage impact visible before merge
  - 9.2.1.1.1 dbt state — compare prod vs. PR artifacts — surface modified models to reviewers
  - 9.2.1.1.2 Catalog diff — show added/removed/changed columns — consumer notification
- 9.2.1.2 Deprecation cycle — mark column deprecated → notify consumers → remove after N days
  - 9.2.1.2.1 Deprecation tag — catalog tag + description with removal date — discoverable
  - 9.2.1.2.2 Usage check — query logs — any consumer still reading deprecated column — block removal
- 9.2.1.3 Blue/green schema migration — new schema in parallel — migrate consumers — drop old
  - 9.2.1.3.1 Dual-write period — write to both old + new schema — zero consumer downtime
  - 9.2.1.3.2 Cutover — redirect consumers to new schema — validate — drop old table/column

---

## 10.0 Metadata Management

### 10.1 Metadata Architecture
#### 10.1.1 Metadata Layers
- 10.1.1.1 Technical metadata — physical structure — schema / types / partitions / row counts
  - 10.1.1.1.1 Auto-crawled — catalog ingestion jobs — always fresh — no human effort
  - 10.1.1.1.2 Profile metadata — statistical summaries — min/max/mean/nulls — per-column health
- 10.1.1.2 Operational metadata — pipeline runs / freshness / job history / data volumes
  - 10.1.1.2.1 Emitted by orchestration — Airflow run metadata / OpenLineage events — auto
  - 10.1.1.2.2 Queryable history — trace data back to pipeline run — audit capability
- 10.1.1.3 Business metadata — ownership / descriptions / glossary / classifications — manual
  - 10.1.1.3.1 Crowdsourced — domain experts annotate — gamified completeness score — incentive
  - 10.1.1.3.2 AI-assisted descriptions — LLM generates column description from name + samples

#### 10.1.2 Metadata Storage
- 10.1.2.1 Graph model — entities (tables/columns/jobs) as nodes — relationships as edges
  - 10.1.2.1.1 Entity types — Dataset / DataJob / Chart / Dashboard / DataProduct / User
  - 10.1.2.1.2 Aspect model — modular metadata per entity — each aspect independently updated
- 10.1.2.2 Search index — Elasticsearch-backed — full-text search — faceted filtering
  - 10.1.2.2.1 Metadata search — find tables with "user_id" column — browse by domain — quick
  - 10.1.2.2.2 Ranking — usage count + recency + completeness — popular datasets surface first

### 10.2 PII & Data Classification
#### 10.2.1 PII Classification
- 10.2.1.1 Auto-classification — scan column names + sample values — regex + ML classifiers
  - 10.2.1.1.1 Pattern matching — email regex / SSN format / credit card Luhn — high precision
  - 10.2.1.1.2 NLP classifier — column name semantics — "first_name" → PII — ML-based
  - 10.2.1.1.3 False positive review — human validation step — confirm before applying tag
- 10.2.1.2 Sensitivity levels — PUBLIC / INTERNAL / CONFIDENTIAL / RESTRICTED — tiered access
  - 10.2.1.2.1 Column-level masking — apply to RESTRICTED columns — dynamic masking per role
  - 10.2.1.2.2 Row-level filtering — RLS policy applied — user sees only their data — GDPR
- 10.2.1.3 Data retention metadata — retention period per classification — auto-expiry policy
  - 10.2.1.3.1 Retention tag propagation — lineage-aware — derived PII inherits retention
