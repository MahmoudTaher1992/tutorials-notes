# DevOps Engineering Study Guide - Part 14: Phase 2 — Prometheus/Grafana & ELK/Loki/OTel

## 20.0 Prometheus & Grafana

### 20.1 Prometheus
→ See Ideal §7.1 Metrics Architecture, §7.2 TSDB, §7.3 Alerting

#### 20.1.1 Prometheus-Unique Features
- **Unique: Pull-based scraping** — Prometheus polls /metrics — service discovery
  - 20.1.1.1 Kubernetes SD — auto-discover pods/services/endpoints — annotations
  - 20.1.1.2 Relabeling — source_labels + regex + target_label — filter + transform
  - 20.1.1.3 Drop relabeling — __drop__ action — reduce cardinality before ingest
- **Unique: PromQL** — powerful query language — instant + range vectors
  - 20.1.1.4 rate() — per-second rate from counter — requires range vector [5m]
  - 20.1.1.5 irate() — instant rate — last 2 samples — spiky metrics
  - 20.1.1.6 histogram_quantile() — calculate percentiles — requires histogram type
  - 20.1.1.7 topk() / bottomk() — top N series — find hot services
  - 20.1.1.8 recording rules — pre-compute expensive queries — dashboards fast
- **Unique: AlertManager** — deduplicate + group + route + silence + inhibit
  - 20.1.1.9 Group_by — aggregate related alerts — single notification per group
  - 20.1.1.10 Inhibit rules — if infra alert → suppress app alerts — reduce noise
  - 20.1.1.11 Receiver routing — team-based — DB alerts → DBA, app → dev team
- **Unique: Pushgateway** — batch job metrics — push before exit — short-lived
  - 20.1.1.12 Stale metrics risk — job fails → stale metrics persist — use timestamps
- **Unique: Thanos / Cortex / Mimir** — long-term HA Prometheus — multi-tenant
  - 20.1.1.13 Thanos query — global view — de-duplicate — multi-cluster federation
  - 20.1.1.14 Mimir — horizontally scalable — 10B+ series — cloud-native

### 20.2 Grafana
→ See Ideal §7.5 Dashboarding

#### 20.2.1 Grafana-Unique Features
- **Unique: Multi-datasource** — Prometheus / Loki / Tempo / Elasticsearch / SQL — one pane
  - 20.2.1.1 Correlations — link metric panel → log query → trace — jump between
  - 20.2.1.2 Mixed datasource — single panel with multiple sources — overlay
- **Unique: Grafana Alerting** — multi-datasource alerts — Prometheus + Loki + others
  - 20.2.1.3 Alert rules — PromQL + LogQL — same UI — unified alert management
  - 20.2.1.4 Contact points — Slack/PagerDuty/webhook — per-team routing
- **Unique: Transformations** — server-side data manipulation — no PromQL needed
  - 20.2.1.5 Join by field — merge two query results — inner/outer join — combine
  - 20.2.1.6 Group by + reduce — aggregate in Grafana — useful for SQL sources
- **Unique: Grafana as code** — Grafonnet / dashboard JSON / Terraform provider
  - 20.2.1.7 grafana-dash-gen — TypeScript library — generate dashboard JSON
  - 20.2.1.8 Terraform grafana provider — provision dashboards + alerts + data sources

---

## 21.0 ELK / Loki / OpenTelemetry

### 21.1 ELK Stack
→ See Ideal §8.1 Log Collection, §8.2 Log Storage

#### 21.1.1 Elasticsearch-Unique Features
- **Unique: Inverted index** — term lookup — billion-document search in milliseconds
  - 21.1.1.1 Index template — auto-apply mappings + settings on index creation
  - 21.1.1.2 ILM policy — hot/warm/cold/delete — shard allocation + rollover — cost
  - 21.1.1.3 Data streams — append-only — time-series logs — ILM built-in
- **Unique: Kibana** — discovery / dashboards / maps / ML anomaly detection
  - 21.1.1.4 KQL — Kibana Query Language — simple field:value — auto-complete
  - 21.1.1.5 Lens — drag-drop visualization — auto chart type — layered views
  - 21.1.1.6 Elastic APM — traces + metrics + logs — correlated — single Kibana UI

### 21.2 Grafana Loki
→ See Ideal §8.2 Log Storage

#### 21.2.1 Loki-Unique Features
- **Unique: Labels-only index** — no full-text index — cheap — trade query speed for cost
  - 21.2.1.1 High cardinality anti-pattern — labels like trace_id — creates too many streams
  - 21.2.1.2 Chunk cache — Memcached — reduce object storage reads — query acceleration
- **Unique: LogQL** — labels filter + line filter + parsers + metric queries
  - 21.2.1.3 Log pipeline — | json | label_format | line_format — transform inline
  - 21.2.1.4 Metric query from logs — count_over_time + rate — derive metrics from logs
  - 21.2.1.5 Pattern matcher — | pattern <ip> - - — extract fields without regex
- **Unique: Grafana Alloy** — OTel collector + Loki agent + Prometheus — unified
  - 21.2.1.6 River config language — pipelines — source → transform → sink — typed

### 21.3 OpenTelemetry
→ See Ideal §7.4 Distributed Tracing

#### 21.3.1 OpenTelemetry-Unique Features
- **Unique: Vendor-neutral standard** — one API + one SDK — export to any backend
  - 21.3.1.1 OTLP — OpenTelemetry Protocol — gRPC + HTTP/JSON — standard wire format
  - 21.3.1.2 Semantic conventions — standard attribute names — service.name / http.method
- **Unique: OTel Collector** — agents + gateways — decouple apps from backends
  - 21.3.1.3 Tail sampling processor — complete trace before decide — keep errors/slow
  - 21.3.1.4 Span metrics connector — derive RED metrics from traces — no extra instrumentation
  - 21.3.1.5 Service graph connector — service topology from traces — dependency map
- **Unique: Auto-instrumentation** — zero-code — Java agent / .NET profiler / Node loader
  - 21.3.1.6 K8s Operator — inject OTel agent via webhook — no Dockerfile change
  - 21.3.1.7 Instrumentation CR — specify language + exporter — per-namespace — K8s native
