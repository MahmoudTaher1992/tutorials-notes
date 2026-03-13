# Data Observability Complete Study Guide - Part 3: Data Catalog & Monitoring

## 5.0 Data Catalog & Discovery

### 5.1 Catalog Fundamentals
#### 5.1.1 Catalog Purpose
- 5.1.1.1 Inventory of data assets — tables / dashboards / pipelines / ML models — searchable
  - 5.1.1.1.1 Data discovery — find datasets by keyword / tag / owner / domain — reduce duplication
  - 5.1.1.1.2 Context enrichment — business descriptions + ownership + usage stats — trust signal
- 5.1.1.2 Active vs. passive catalog — passive = documentation only — active = governance + lineage
  - 5.1.1.2.1 Active catalog — enforces policies — blocks access on PII tag violation — automated
  - 5.1.1.2.2 Passive catalog — searchable wiki — manually maintained — goes stale quickly

#### 5.1.2 Metadata Types
- 5.1.2.1 Technical metadata — schema / data types / partitioning / row counts / indexes
  - 5.1.2.1.1 Auto-ingested — crawlers pull from warehouse catalog — always up to date
  - 5.1.2.1.2 Profile statistics — min/max/mean/null_rate/cardinality per column — freshness
- 5.1.2.2 Operational metadata — pipeline run history / freshness / quality scores / SLA status
  - 5.1.2.2.1 Surfaced in catalog — last run timestamp / pass rate — reliability at-a-glance
- 5.1.2.3 Business metadata — descriptions / owners / domain / glossary terms / use cases
  - 5.1.2.3.1 Business glossary — canonical term definitions — link to columns — semantic layer
  - 5.1.2.3.2 Data stewardship — named owner per domain — accountable for accuracy + descriptions

### 5.2 Data Products & Governance
#### 5.2.1 Data Product Catalog
- 5.2.1.1 Data product — curated, documented, SLA-backed dataset — first-class asset
  - 5.2.1.1.1 Product spec — owner / consumers / schema / SLA / quality contract — declared
  - 5.2.1.1.2 Discoverability — registered in catalog — searchable — versioned — changelog
- 5.2.1.2 Data mesh catalog — federated — each domain publishes products — global search
  - 5.2.1.2.1 Interoperability — standard metadata schema — cross-domain lineage — unified view
- 5.2.1.3 Tagging taxonomy — environment (prod/dev) / PII / sensitivity / domain / status
  - 5.2.1.3.1 Tag propagation — lineage-aware — PII tag on source column → all derived columns

---

## 6.0 Data Monitoring & Alerting

### 6.1 Monitoring Architecture
#### 6.1.1 What to Monitor
- 6.1.1.1 Table-level — row count / null rate / freshness / schema change — per-table monitors
  - 6.1.1.1.1 Row count monitor — compare to rolling N-day average — deviation threshold
  - 6.1.1.1.2 Null rate monitor — per column — baseline from historical run — alert on spike
- 6.1.1.2 Pipeline-level — task duration / success rate / retry count / queue depth
  - 6.1.1.2.1 Task SLA — expected completion by HH:MM — alert if not done by deadline
  - 6.1.1.2.2 Pipeline throughput — records/sec processed — drop signals ingestion failure
- 6.1.1.3 Business metric monitors — revenue / signups / orders — sanity check layer
  - 6.1.1.3.1 Revenue anomaly — daily revenue drops 80% — may be pipeline issue not business
  - 6.1.1.3.2 Dual verification — both pipeline health + business metric — correlated alerting

#### 6.1.2 Threshold vs. ML Detection
- 6.1.2.1 Static thresholds — explicit lower/upper bounds — simple — brittle for seasonal data
  - 6.1.2.1.1 Hard threshold — row_count < 1000 → alert — fast to configure — false positives
  - 6.1.2.1.2 Relative threshold — deviation > 20% from yesterday — handles gradual growth
- 6.1.2.2 Dynamic / ML-based thresholds — learn historical patterns — detect true anomalies
  - 6.1.2.2.1 Prophet — Facebook time-series model — captures trend + seasonality — daily/weekly
  - 6.1.2.2.2 Z-score rolling — (value − rolling_mean) / rolling_std — |z| > 3 = anomaly
  - 6.1.2.2.3 Isolation Forest — unsupervised — multi-dimensional anomaly — multi-metric monitors
- 6.1.2.3 Sensitivity tuning — precision vs. recall tradeoff — alert fatigue vs. missed incidents
  - 6.1.2.3.1 Feedback loop — user marks false positive — model adjusts threshold — active learning

### 6.2 Alerting & Notification
#### 6.2.1 Alert Routing
- 6.2.1.1 Severity classification — P1 (data down) / P2 (degraded) / P3 (warning) — tiered response
  - 6.2.1.1.1 P1 — PagerDuty page — on-call data engineer — 15-min response SLA
  - 6.2.1.1.2 P2/P3 — Slack channel — async acknowledgment — business-hours resolution
- 6.2.1.2 Alert routing rules — by team / domain / table owner — right person notified
  - 6.2.1.2.1 Tag-based routing — table.domain = payments → payments-data-eng Slack channel
  - 6.2.1.2.2 Escalation — unacknowledged within 30 min → escalate to manager on-call
- 6.2.1.3 Alert deduplication — group related alerts — one incident per root cause — reduce noise
  - 6.2.1.3.1 Alert correlation — upstream failure → suppress downstream child alerts — causal
  - 6.2.1.3.2 Alert flapping — rapid on/off — debounce with N consecutive failures — stable alert

### 6.3 Observability Dashboards
#### 6.3.1 Dashboard Design
- 6.3.1.1 Data health overview — top-level KPIs — freshness compliance % / DQI / open incidents
- 6.3.1.2 Table health detail — per-table quality trend — row count history — schema change log
- 6.3.1.3 Pipeline health — DAG success rate / P95 duration / failure rate — operational view
- 6.3.1.4 SLA burn-down — remaining error budget — at-risk datasets — proactive view
