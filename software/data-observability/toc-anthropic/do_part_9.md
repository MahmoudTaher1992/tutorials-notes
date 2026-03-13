# Data Observability Complete Study Guide - Part 9: Monte Carlo & DataHub

## 17.0 Monte Carlo

### 17.1 Architecture & Detection
#### 17.1.1 Automated Monitoring
- 17.1.1.1 No-config ML monitors — auto-learn table baselines — row count / freshness / field health
  - 17.1.1.1.1 Field health monitor — per-column distribution tracking — null rate / uniqueness / mean
  - 17.1.1.1.2 Volume monitor — row count time-series — anomaly if outside learned bounds
  - 17.1.1.1.3 Freshness monitor — last_updated inference — alert if table goes stale — no config
- 17.1.1.2 Circuit breakers — block downstream pipeline on data quality failure — manual or auto
  - 17.1.1.2.1 Monte Carlo API trigger — call from Airflow task — pause DAG if quality fails
  - 17.1.1.2.2 Threshold-based circuit breaker — set explicit bounds — override ML defaults

#### 17.1.2 Lineage in Monte Carlo
- 17.1.2.1 Automated lineage — ingest from query logs — BigQuery / Snowflake / Redshift — passive
  - 17.1.2.1.1 Query log parsing — extract table references — build lineage without instrumentation
  - 17.1.2.1.2 dbt integration — ingest manifest.json — combine SQL lineage + dbt model graph
- 17.1.2.2 Lineage visualization — interactive DAG — zoom to table — upstream / downstream expand
  - 17.1.2.2.1 Incident blast radius — highlight affected nodes — see consumer dashboards
  - 17.1.2.2.2 Root cause tracing — navigate upstream from anomalous table — find origin

### 17.2 Incident Management
#### 17.2.1 Monte Carlo Incidents
- 17.2.1.1 Incident creation — auto from alert or manual — owner assigned — status tracked
  - 17.2.1.1.1 Incident timeline — alert fired → acknowledged → investigating → resolved
  - 17.2.1.1.2 Root cause AI — LLM-powered — suggest probable causes — reduce MTTR
- 17.2.1.2 Notifications — Slack / PagerDuty / email / webhook — per-monitor routing
  - 17.2.1.2.1 Custom routing rules — table.domain → team channel — table.tier → pagerduty
- 17.2.1.3 Monte Carlo integrations — dbt / Airflow / Looker / Tableau / Databricks / Snowflake
  - 17.2.1.3.1 Looker lineage — tiles + explores + views mapped to underlying tables — full stack

---

## 18.0 DataHub

### 18.1 Architecture
#### 18.1.1 Core Components
- 18.1.1.1 Metadata service (GMS) — REST + GraphQL API — entity store — Spring Boot
  - 18.1.1.1.1 Entity — Dataset / DataJob / DataFlow / Dashboard / Chart / User / Group
  - 18.1.1.1.2 Aspect — modular metadata piece per entity — SchemaMetadata / Ownership / Tags
  - 18.1.1.1.3 Time-series aspects — DatasetProfile / DatasetRunEvent — versioned history
- 18.1.1.2 Metadata change proposal (MCP) — Kafka event — propose entity change — async write
  - 18.1.1.2.1 MAE (Metadata Audit Event) — emitted after write — downstream consumers react
  - 18.1.1.2.2 MCL (Metadata Change Log) — log of all metadata changes — replay / audit
- 18.1.1.3 Search & graph service — Elasticsearch + Neo4j — power browse + lineage graph
  - 18.1.1.3.1 Elasticsearch — full-text entity search — faceted — urn-based deduplication
  - 18.1.1.3.2 Graph (Neo4j or embedded) — lineage edges — upstream / downstream traversal

#### 18.1.2 Ingestion Framework
- 18.1.2.1 Ingestion sources — 50+ connectors — BigQuery / Snowflake / dbt / Kafka / Airflow
  - 18.1.2.1.1 Pull-based ingestion — DataHub CLI / Python SDK — scheduled cron / on-demand
  - 18.1.2.1.2 Push-based — emit MCPs from pipeline — real-time — Airflow DataHub operator
- 18.1.2.2 Ingestion recipe — YAML — source config + sink config + pipeline config
  - 18.1.2.2.1 source.type: bigquery — dataset_patterns: allow/deny — scoped ingestion
  - 18.1.2.2.2 Stateful ingestion — track last run — only ingest changed entities — efficient
- 18.1.2.3 Custom transformer — modify metadata mid-pipeline — add tags / enrich ownership
  - 18.1.2.3.1 PatternAddDatasetDomain — regex match dataset name → assign domain — auto-classify

### 18.2 DataHub Features
#### 18.2.1 Data Quality Integration
- 18.2.1.1 DatasetProfile aspect — column stats — null count / distinct count / min/max — freshness
  - 18.2.1.1.1 Profiling in ingestion — enable profiling in recipe — profile on ingest — auto
  - 18.2.1.1.2 Profile history — trend over runs — detect distribution drift — visual in UI
- 18.2.1.2 Assertions (DataHub 0.12+) — define data quality checks — track results over time
  - 18.2.1.2.1 Freshness assertion — max update time — SLA check — natively in DataHub
  - 18.2.1.2.2 Volume assertion — row count bounds — fail on drop — integrated alert

#### 18.2.2 Governance
- 18.2.2.1 Glossary terms — canonical business definitions — link to columns — semantic layer
  - 18.2.2.1.1 Glossary hierarchy — term groups → terms — organized by domain — browsable
  - 18.2.2.1.2 Propagated terms — attach to column → surface in lineage descendants — inherited
- 18.2.2.2 Ownership — assign users / groups — accountable for dataset quality + docs
  - 18.2.2.2.1 Ownership type — Technical Owner / Business Owner / Data Steward — tiered
