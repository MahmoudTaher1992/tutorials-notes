# GCP Complete Study Guide - Part 13: Phase 2 — Cloud Monitoring, Logging, Pub/Sub, Apigee

## 27.0 Cloud Monitoring

### 27.1 Cloud Monitoring Core
→ See Ideal §6.1 Cloud Monitoring, §6.1.1 Monarch Architecture

#### 27.1.1 Cloud Monitoring-Unique Features
- **Unique: Monarch** — in-memory time-series DB — global distributed — no single TSDB
  - 27.1.1.1 Leaves → Roots → Mixer architecture — hierarchical aggregation — zone → region → global
  - 27.1.1.2 Target schema — resource type + labels — BigQuery table, GCE instance, k8s_pod
  - 27.1.1.3 Sub-minute metrics — 10-second resolution — faster than AWS CloudWatch default
- **Unique: Google Managed Prometheus (GMP)** — managed Prometheus — global ruler — GKE native
  - 27.1.1.4 PodMonitoring CRD — scrape config without Prometheus operator — K8s-native
  - 27.1.1.5 Global ruler — evaluate rules across clusters — cross-cluster alerting
  - 27.1.1.6 Managed collection — DaemonSet injection — no self-hosted Prometheus needed
- **Unique: Uptime checks** — global probes from 6 regions — synthetic monitoring
  - 27.1.1.7 HTTP/HTTPS/TCP checks — content match — latency + uptime SLA
  - 27.1.1.8 Private uptime checks — Cloud Monitoring agent — internal endpoint monitoring
- **Unique: SLO monitoring** — define SLIs + error budgets — burn rate alerts
  - 27.1.1.9 Request-based SLI — good requests / total — Cloud Monitoring native
  - 27.1.1.10 Window-based SLI — % good windows — latency distribution threshold
  - 27.1.1.11 Error budget burn rate alert — fast burn (1h) + slow burn (6h) — tiered paging
- **Unique: Metrics Explorer** — MQL — Monitoring Query Language — complex aggregations
  - 27.1.1.12 MQL — time-series aggregation, joins, fetch + filter + align
  - 27.1.1.13 PromQL support — GMP surfaces Prometheus metrics in standard PromQL

---

## 28.0 Cloud Logging

### 28.1 Cloud Logging Core
→ See Ideal §6.2 Cloud Logging, §6.2.1 Log Analytics

#### 28.1.1 Cloud Logging-Unique Features
- **Unique: Log Analytics (BigQuery backend)** — SQL on logs — analytics-grade queries
  - 28.1.1.1 Upgrade log bucket → analytics-enabled — BigQuery linked dataset
  - 28.1.1.2 SQL queries — GROUP BY, JOIN — correlate logs with BQ billing export
  - 28.1.1.3 No separate export needed — logs stored once — queryable via BQ engine
- **Unique: Log-based metrics** — counter/distribution — create Monitoring metrics from logs
  - 28.1.1.4 Filter expression → metric — track error rate from log messages
  - 28.1.1.5 Distribution metric — latency histogram from log field — percentile alerting
- **Unique: _Required bucket** — Admin Activity + System Events — non-deletable — 400 days
  - 28.1.1.6 Cannot disable — cannot shorten retention — compliance immutability
- **Unique: Aggregated sinks** — export from org/folder — single sink for all projects
  - 28.1.1.7 Org-level sink → single BigQuery dataset — centralized security analytics
  - 28.1.1.8 Intercept children — include inherited resources — multi-project capture
- **Unique: Cloud Logging agent (OPS Agent)** — single agent — logs + metrics from VMs
  - 28.1.1.9 Fluent Bit — log collection — OpenTelemetry — metrics pipeline
  - 28.1.1.10 Structured logging — parse JSON — label extraction — improved filtering

---

## 29.0 Pub/Sub

### 29.1 Pub/Sub Core
→ See Ideal §6.5 Pub/Sub Architecture, §6.5.1 Delivery Guarantees

#### 29.1.1 Pub/Sub-Unique Features
- **Unique: Exactly-once delivery** — subscription-level — sequence tokens — dedup window
  - 29.1.1.1 ACK IDs — immutable — no redelivery after ACK — exactly-once guarantee
  - 29.1.1.2 Ordering key — partition within topic — ordered per-key delivery
- **Unique: Pub/Sub Lite** — zonal service — 10x cheaper — predictable throughput
  - 29.1.1.3 Reserved throughput — pre-provisioned — no shared capacity fluctuation
  - 29.1.1.4 Zonal vs. regional Lite — single zone cheaper — regional for HA
- **Unique: BigQuery subscription** — write directly to BQ table — no Dataflow needed
  - 29.1.1.5 Schema enforcement — Avro/JSON → BQ table schema — native write
  - 29.1.1.6 Dead-letter topic — failed writes — troubleshoot schema mismatches
- **Unique: Cloud Storage subscription** — batch write messages to GCS — archive pipeline
  - 29.1.1.7 Avro/text format — filename prefix + suffix — configurable max duration
- **Unique: Message filtering** — server-side — filter by attribute — reduce subscriber load
  - 29.1.1.8 filter = 'attributes.env = "prod"' — subscriber only receives matching
- **Unique: Seek** — replay or fast-forward — to timestamp or snapshot
  - 29.1.1.9 Snapshot — capture subscription state — restore after failed processing
  - 29.1.1.10 Seek to timestamp — replay historical messages — backfill use case

---

## 30.0 Apigee

### 30.1 Apigee Core
→ See Ideal §6.8 Apigee Architecture, §6.8.1 API Management

#### 30.1.1 Apigee-Unique Features
- **Unique: Apigee hybrid** — runtime in customer cluster — control plane on GCP
  - 30.1.1.1 apigee-operator — Kubernetes-native deployment — hybrid runtime pods
  - 30.1.1.2 Data residency — payloads stay on-prem — only metadata to GCP
- **Unique: Apigee Advanced API Security** — bot detection + abuse detection — ML-based
  - 30.1.1.3 Security score — policy compliance — runtime threat detection
  - 30.1.1.4 Incident detection — anomalous traffic patterns — Apigee-specific ML
- **Unique: Monetization** — built-in billing plans — rate cards — developer revenue
  - 30.1.1.5 Rate plans — freemium, flat rate, variable — API product packages
  - 30.1.1.6 Developer portal — Drupal-based or Integrated Portal — API catalog + keys
- **Unique: Apigee X** — native GCP — VPC Peering — Private Service Connect
  - 30.1.1.7 Multi-region — runtime groups — global load balancing across regions
  - 30.1.1.8 Sharding — environment groups — host alias routing — multi-tenant
- **Unique: API Hub** — catalog all APIs — governance — OpenAPI spec registry
  - 30.1.1.9 Lint rules — API design standards — enforce before publish
  - 30.1.1.10 Dependency graph — which services call which APIs — impact analysis
