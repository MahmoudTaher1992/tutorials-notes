# DevOps Engineering Study Guide - Part 8: Phase 1 — Monitoring & Observability

## 7.0 Monitoring & Observability

### 7.1 The Three Pillars
#### 7.1.1 Metrics
- 7.1.1.1 Metric types — counter, gauge, histogram, summary
  - 7.1.1.1.1 Counter — monotonically increasing — rate() to get per-second — never reset
  - 7.1.1.1.2 Gauge — current value — memory usage / queue depth — up and down
  - 7.1.1.1.3 Histogram — bucket counts + sum + count — calculate quantiles server-side
  - 7.1.1.1.4 Summary — pre-computed quantiles — client-side — not aggregatable
- 7.1.1.2 Cardinality — number of unique label combinations — high cardinality = OOM
  - 7.1.1.2.1 Avoid user IDs in labels — unbounded cardinality — TSDB killer
  - 7.1.1.2.2 Label best practices — status code / method / endpoint — bounded sets

#### 7.1.2 Logs
- 7.1.2.1 Structured logging — JSON — machine-parseable — query by field
  - 7.1.2.1.1 Log levels — TRACE/DEBUG/INFO/WARN/ERROR/FATAL — filter in pipeline
  - 7.1.2.1.2 Correlation ID — inject trace ID into log — link logs to traces
- 7.1.2.2 Log sampling — high-volume services — keep 100% errors, 1% info
  - 7.1.2.2.1 Head-based sampling — decide at start — consistent per trace
  - 7.1.2.2.2 Tail-based sampling — decide after complete — keep slow/errored traces

#### 7.1.3 Traces
- 7.1.3.1 Distributed trace — tree of spans — follows request across services
  - 7.1.3.1.1 Span — single operation — start time + duration + status + attributes
  - 7.1.3.1.2 Trace context — W3C TraceContext — traceparent header — propagated
  - 7.1.3.1.3 Baggage — key/value propagated with trace — carry metadata cross-service
- 7.1.3.2 Instrumentation — automatic vs. manual
  - 7.1.3.2.1 Auto-instrumentation — agent — zero code change — library hooks
  - 7.1.3.2.2 Manual instrumentation — SDK — create spans — add attributes — precise

### 7.2 Metrics Architecture
#### 7.2.1 Time-Series Database (TSDB) Internals
- 7.2.1.1 Prometheus TSDB — head block (in-memory) + on-disk blocks — WAL
  - 7.2.1.1.1 WAL — write-ahead log — crash recovery — 2-hour segment files
  - 7.2.1.1.2 Head block — 2h in memory — compressed with XOR delta encoding
  - 7.2.1.1.3 Blocks — immutable — 2h chunks — compacted over time
  - 7.2.1.1.4 Compaction — merge blocks — tombstones for deletes — reduce files
- 7.2.1.2 Scrape model — pull — Prometheus polls /metrics endpoints — intervals
  - 7.2.1.2.1 Scrape interval — 15s default — jitter — avoid thundering herd
  - 7.2.1.2.2 Target discovery — static_configs / service_discovery — K8s SD
- 7.2.1.3 Long-term storage — Thanos / Cortex / Mimir — horizontally scalable TSDB
  - 7.2.1.3.1 Thanos sidecar — upload TSDB blocks to object storage — query unified
  - 7.2.1.3.2 Cortex/Mimir — multi-tenant — ingestors + queriers + store-gateways

### 7.3 Alerting, SLIs/SLOs/Error Budgets
#### 7.3.1 SRE Reliability Framework
- 7.3.1.1 SLI — Service Level Indicator — measurable metric — good/total requests
  - 7.3.1.1.1 Request-based SLI — (good requests / total requests) * 100 — most common
  - 7.3.1.1.2 Window-based SLI — % of windows where latency < threshold — rolling
- 7.3.1.2 SLO — target percentage — 99.9% over 30 days — contractual intent
  - 7.3.1.2.1 Error budget = 100% - SLO — 30 day budget = 43.8 min downtime for 99.9%
  - 7.3.1.2.2 Error budget policy — freeze deploys / do reliability work when depleted
- 7.3.1.3 SLA — external commitment — penalty if breached — SLO buffer from SLA
  - 7.3.1.3.1 SLO always more strict than SLA — buffer absorbs measurement variance

#### 7.3.2 Alert Design
- 7.3.2.1 Symptom-based alerting — user-visible impact — not cause-based
  - 7.3.2.1.1 Alert on SLO burn rate — fast burn (1h) + slow burn (6h) — tiered
  - 7.3.2.1.2 Multiwindow alerting — 1h window + 5m window — confirm sustained
- 7.3.2.2 Alert fatigue prevention — actionable alerts only — clear runbook link
  - 7.3.2.2.1 Inhibition rules — suppress child alerts when parent fires — reduce noise
  - 7.3.2.2.2 Silences — scheduled maintenance — time-bounded — no alert storm

### 7.4 Distributed Tracing & OpenTelemetry
#### 7.4.1 OpenTelemetry Architecture
- 7.4.1.1 OTel SDK — generate traces/metrics/logs — language SDKs — unified API
  - 7.4.1.1.1 Tracer Provider — configure exporters + samplers + propagators
  - 7.4.1.1.2 Context propagation — inject/extract headers — cross-process
- 7.4.1.2 OTel Collector — agent + gateway — receive, process, export
  - 7.4.1.2.1 Receivers — OTLP / Jaeger / Zipkin / Prometheus — ingest data
  - 7.4.1.2.2 Processors — batch / memory limiter / attribute — transform
  - 7.4.1.2.3 Exporters — OTLP / Jaeger / Datadog / Tempo — send to backend
- 7.4.1.3 Sampling strategies — never exceed budget — configured at collector
  - 7.4.1.3.1 Probabilistic sampler — sample N% — uniform — simple
  - 7.4.1.3.2 Tail sampling processor — evaluate complete trace — keep errors/slow

### 7.5 Dashboarding
#### 7.5.1 Grafana Dashboarding
- 7.5.1.1 Dashboard as code — JSON model — version control — grafonnet/libsonnet
  - 7.5.1.1.1 Grafana provisioning — YAML sidecar — load dashboards from ConfigMap
  - 7.5.1.1.2 Variables — template — select cluster/namespace/service — dynamic
- 7.5.1.2 USE Method — Utilization / Saturation / Errors — resource health
  - 7.5.1.2.1 CPU utilization — avg load — saturation — run queue — errors: throttle
- 7.5.1.3 RED Method — Rate / Errors / Duration — service health — request-centric
  - 7.5.1.3.1 HTTP rate — rps — error rate — p50/p95/p99 latency — per endpoint
