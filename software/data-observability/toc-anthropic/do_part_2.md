# Data Observability Complete Study Guide - Part 2: Freshness & Data Lineage

## 3.0 Data Freshness & Timeliness

### 3.1 Freshness Concepts
#### 3.1.1 Freshness Definition
- 3.1.1.1 Freshness — time elapsed since data was last successfully updated — staleness age
  - 3.1.1.1.1 Expected update interval — hourly / daily / streaming — defined per dataset
  - 3.1.1.1.2 Freshness SLA — data must be updated within N hours of source event — binding
  - 3.1.1.1.3 Freshness lag — current time − last_updated_at — measured continuously
- 3.1.1.2 Data latency — time from event occurrence to availability in consuming system
  - 3.1.1.2.1 Ingestion latency — source to landing zone — network + extraction time
  - 3.1.1.2.2 Processing latency — transformation time — DAG execution duration
  - 3.1.1.2.3 End-to-end latency — event time to query-available — sum of all stages

#### 3.1.2 Freshness Detection
- 3.1.2.1 Timestamp-based — MAX(updated_at) or MAX(event_time) — compare to NOW()
  - 3.1.2.1.1 Watermark — high-water mark timestamp — tracks furthest processed event
  - 3.1.2.1.2 Partition freshness — check latest partition key — date-partitioned tables
- 3.1.2.2 Metadata-based — table last_modified from catalog — no query on data itself
  - 3.1.2.2.1 information_schema — last_altered — fast check — no table scan
  - 3.1.2.2.2 Object storage metadata — S3/GCS last_modified — upstream file freshness

### 3.2 Freshness SLAs & Enforcement
#### 3.2.1 SLA Definition
- 3.2.1.1 Freshness SLO — objective — target 95% of days data arrives within 2 hours
  - 3.2.1.1.1 SLI — actual freshness lag distribution — measured hourly — SLO compliance
  - 3.2.1.1.2 Error budget — remaining tolerance — pause non-critical pipelines if budget exhausted
- 3.2.1.2 Dataset criticality tiers — Tier 1 (real-time SLA) vs Tier 2 (daily) vs Tier 3 (best-effort)
  - 3.2.1.2.1 Tier assignment — business impact × consumer count × revenue link
  - 3.2.1.2.2 Escalation policy — Tier 1 → PagerDuty — Tier 2 → Slack — Tier 3 → ticket
- 3.2.1.3 Freshness alerting — threshold-based or anomaly-based — grace period to reduce noise
  - 3.2.1.3.1 Grace period — tolerate 15min delay before alert — avoid transient noise
  - 3.2.1.3.2 Alert suppression — known maintenance window — silence scheduled downtime

---

## 4.0 Data Lineage

### 4.1 Lineage Concepts
#### 4.1.1 Lineage Types
- 4.1.1.1 Table-level lineage — which tables feed which downstream tables — coarse-grained
  - 4.1.1.1.1 Ingestion lineage — source system → raw table — first hop recorded
  - 4.1.1.1.2 Transformation lineage — raw → staging → mart — DAG of transformations
- 4.1.1.2 Column-level lineage — which source columns produce each output column — fine-grained
  - 4.1.1.2.1 Direct mapping — SELECT a.col → output.col — trivial pass-through
  - 4.1.1.2.2 Derived mapping — COALESCE(a.col, b.col) — multiple source inputs → one output
  - 4.1.1.2.3 Aggregation — SUM(revenue) → total_revenue — many rows → one value
- 4.1.1.3 Process lineage — which job / transformation produced the data — executable link
  - 4.1.1.3.1 Run-level lineage — specific DAG run + task — point-in-time execution trace

#### 4.1.2 Lineage Graph Model
- 4.1.2.1 Directed acyclic graph (DAG) — nodes = datasets / jobs — edges = data flow
  - 4.1.2.1.1 Source nodes — no incoming edges — external systems / raw ingestion
  - 4.1.2.1.2 Sink nodes — no outgoing edges — BI reports / ML features / exports
  - 4.1.2.1.3 Transformation nodes — jobs / dbt models / Spark applications — intermediate
- 4.1.2.2 Lineage metadata storage — graph database (Neo4j) or RDF store or specialized catalog
  - 4.1.2.2.1 OpenLineage — open standard — facets for inputs/outputs/run info — JSON events
  - 4.1.2.2.2 Marquez — OpenLineage server — REST API — stores + serves lineage graph

### 4.2 Lineage Collection
#### 4.2.1 Extraction Methods
- 4.2.1.1 Static analysis — parse SQL / Spark code — extract table references — offline
  - 4.2.1.1.1 SQL parsing — sqlglot / sqlparse — extract FROM / JOIN / INSERT INTO — AST walk
  - 4.2.1.1.2 Limitations — dynamic SQL — computed table names — incomplete lineage
- 4.2.1.2 Runtime instrumentation — capture lineage at execution time — complete + accurate
  - 4.2.1.2.1 OpenLineage Airflow integration — emit RunEvent on task start/complete — automatic
  - 4.2.1.2.2 Spark listener — SparkContext event listener — captures input/output datasets
- 4.2.1.3 Catalog API crawling — pull table metadata from warehouse — infer lineage from views
  - 4.2.1.3.1 BigQuery INFORMATION_SCHEMA.JOBS — query log — table references per query — mine

### 4.3 Lineage Use Cases
#### 4.3.1 Impact Analysis
- 4.3.1.1 Upstream impact — what changed upstream that could affect this table
  - 4.3.1.1.1 Schema change propagation — source column renamed → find all downstream consumers
  - 4.3.1.1.2 Data quality incident — identify root cause table in lineage chain — trace upstream
- 4.3.1.2 Downstream blast radius — if I change this table — what breaks downstream
  - 4.3.1.2.1 Forward traversal — BFS from changed node — enumerate all consumers
  - 4.3.1.2.2 Criticality scoring — blast radius × consumer tier — prioritize fixes
- 4.3.1.3 Compliance lineage — trace PII field from source → all destinations — GDPR right-to-erasure
  - 4.3.1.3.1 PII propagation map — column-level lineage + PII tags — find all derived PII columns
