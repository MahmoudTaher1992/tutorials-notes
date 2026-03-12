# GCP Complete Study Guide - Part 6: Monitoring & Observability + Integration (Phase 1 — Ideal)

## 6.0 Monitoring & Observability

### 6.1 Cloud Monitoring (Metrics)
#### 6.1.1 Metrics Platform
- 6.1.1.1 Cloud Monitoring — built on Monarch — Google's internal time-series DB
  - 6.1.1.1.1 Metric types — gauge, delta, cumulative — aligned vs. unaligned
  - 6.1.1.1.2 Retention — 6 weeks (1-min resolution) → 6 months (1-hr resolution)
- 6.1.1.2 Metric descriptors — type, kind, labels, unit — define metric schema
  - 6.1.1.2.1 System metrics — prefix: compute.googleapis.com, storage.googleapis.com
  - 6.1.1.2.2 Custom metrics — prefix: custom.googleapis.com — 500 per project
- 6.1.1.3 Prometheus collection — Managed Service for Prometheus (GMP)
  - 6.1.1.3.1 PodMonitoring CRD — scrape K8s pods — GKE auto-injection
  - 6.1.1.3.2 Global Prometheus API — query across clusters/projects — PromQL
  - 6.1.1.3.3 Rule evaluator — recording + alerting rules — managed by GKE operator

#### 6.1.2 Dashboards & SLOs
- 6.1.2.1 Dashboards — charts, scorecard, alert table — shareable JSON
  - 6.1.2.1.1 MQL (Monitoring Query Language) — powerful — filter, align, reduce
  - 6.1.2.1.2 Ratio metrics — divide numerator/denominator — error rate dashboards
- 6.1.2.2 Service monitoring — define SLIs + SLOs — error budget tracking
  - 6.1.2.2.1 Request-based SLI — good_requests / total_requests — availability
  - 6.1.2.2.2 Window-based SLI — % of good windows — latency-based SLO
  - 6.1.2.2.3 Error budget burn rate alerts — fast + slow burn alerting

### 6.2 Cloud Logging
#### 6.2.1 Log Architecture
- 6.2.1.1 Log buckets — _Required (400 days, non-configurable) + _Default (30 days)
  - 6.2.1.1.1 User-defined buckets — custom retention 1–3650 days — per region
  - 6.2.1.1.2 Analytics-enabled buckets — BigQuery-linked — Log Analytics via SQL
- 6.2.1.2 Log sinks — export subset of logs — filter by resource type, severity, labels
  - 6.2.1.2.1 Destinations — Cloud Storage, BigQuery, Pub/Sub, Splunk, SIEM
  - 6.2.1.2.2 Aggregated sinks — org/folder level — centralize all project logs
- 6.2.1.3 Log views — restrict which logs a user can see within a bucket
  - 6.2.1.3.1 IAM binding on view — logging.views.access — fine-grained log access

#### 6.2.2 Log Analytics (SQL on Logs)
- 6.2.2.1 Linked BigQuery dataset — query logs via SQL — no export needed
  - 6.2.2.1.1 _AllLogs view — query all log types — powerful cross-log correlation
  - 6.2.2.1.2 Saved queries — share across team — schedule via Cloud Scheduler
- 6.2.2.2 Log-based metrics — counter/distribution — from log filter → Cloud Monitoring
  - 6.2.2.2.1 Extract labels from logs — regex — add metric labels dynamically

### 6.3 Cloud Trace & Cloud Profiler
#### 6.3.1 Cloud Trace
- 6.3.1.1 Distributed tracing — OpenTelemetry-compatible — auto-instrument or manual
  - 6.3.1.1.1 Trace sampling — head-based (default) + tail-based (Cloud Trace)
  - 6.3.1.1.2 Latency histograms — p50/p95/p99 per URL/RPC — regression detection
- 6.3.1.2 Span data — HTTP attributes, gRPC status, DB query text
  - 6.3.1.2.1 Trace context propagation — W3C Trace-Context header — cross-service
  - 6.3.1.2.2 Linked logs — correlate trace spans with log entries via trace field

#### 6.3.2 Cloud Profiler
- 6.3.2.1 Continuous CPU/heap profiling — statistical — 1% overhead — production safe
  - 6.3.2.1.1 Flame graph — call stack aggregation — identify hottest functions
  - 6.3.2.1.2 Compare profiles — over time — detect regressions after deploy

### 6.4 Alerting & Incident Management
#### 6.4.1 Alerting Policies
- 6.4.1.1 Conditions — metric threshold, metric absence, log-based, uptime check
  - 6.4.1.1.1 Alignment period — aggregate data — must be >= ingest frequency
  - 6.4.1.1.2 Duration — condition must hold for N seconds before alert fires
- 6.4.1.2 Notification channels — email, PagerDuty, Slack, webhook, Pub/Sub, SMS
  - 6.4.1.2.1 Incident closure — auto-close when condition clears for N minutes
- 6.4.1.3 Uptime checks — HTTP/HTTPS/TCP — 6 global locations — SLA monitoring
  - 6.4.1.3.1 Private uptime checks — via VPC — check internal services

---

## 7.0 Application Integration & Messaging

### 7.1 Cloud Pub/Sub
#### 7.1.1 Pub/Sub Architecture
- 7.1.1.1 Global service — fully managed — at-least-once delivery — serverless
  - 7.1.1.1.1 Topics — global — publishers send messages — no partition concept
  - 7.1.1.1.2 Subscriptions — pull or push — per topic — multiple per topic (fan-out)
- 7.1.1.2 Message ordering — per ordering key — enabled per subscription
  - 7.1.1.2.1 Ordered delivery — same key → same subscriber → FIFO
  - 7.1.1.2.2 Flow control — max outstanding messages + bytes — prevent OOM
- 7.1.1.3 Exactly-once delivery — per region — enable idempotent consumers
  - 7.1.1.3.1 Exactly-once subscription — deduplication window — 10 minutes
  - 7.1.1.3.2 Higher latency — 2-phase commit — only use when ordering required

#### 7.1.2 Subscription Types
- 7.1.2.1 Pull subscriptions — subscriber calls Pull API — batch up to 1000 messages
  - 7.1.2.1.1 StreamingPull — bidirectional gRPC — high-throughput — preferred
  - 7.1.2.1.2 ack deadline — default 10s, max 600s — modifyAckDeadline to extend
- 7.1.2.2 Push subscriptions — Pub/Sub delivers to HTTPS endpoint
  - 7.1.2.2.1 Push-to-BigQuery — direct write — no intermediate service needed
  - 7.1.2.2.2 Push-to-Cloud Storage — batch — time/size based
- 7.1.2.3 Dead letter topic — maxDeliveryAttempts — forward unprocessed messages
  - 7.1.2.3.1 Requires dead letter topic subscription to consume DLQ messages
- 7.1.2.4 Snapshot + seek — rewind subscription to snapshot point in time
  - 7.1.2.4.1 Time-based seek — seek to timestamp — replay last N hours

### 7.2 Cloud Tasks
#### 7.2.1 Cloud Tasks Architecture
- 7.2.1.1 Managed task queues — guaranteed delivery — HTTP or App Engine targets
  - 7.2.1.1.1 Rate limits — maxDispatchesPerSecond + maxConcurrentDispatches
  - 7.2.1.1.2 Retry config — maxAttempts, maxBackoff, minBackoff, maxDoublings
- 7.2.1.2 Task scheduling — scheduleTime — future execution
  - 7.2.1.2.1 Task deduplication — same task ID → deduplicated for ~1 hour
  - 7.2.1.2.2 Task deletion — cancel before execution if not yet dispatched

### 7.3 Cloud Scheduler
#### 7.3.1 Scheduler Features
- 7.3.1.1 Cron jobs — Unix cron + special strings (@every 5m) — managed
  - 7.3.1.1.1 Targets — HTTP, Pub/Sub topic, App Engine — per job
  - 7.3.1.1.2 Time zones — IANA tz database — DST-aware
- 7.3.1.2 OAuth + OIDC — secure target — authenticate scheduled HTTP requests
  - 7.3.1.2.1 OIDC token — Cloud Run/Functions auth — service account identity

### 7.4 Eventarc
#### 7.4.1 Eventarc Architecture
- 7.4.1.1 Unified eventing — route events from GCP/custom sources → Cloud Run/GKE/Workflows
  - 7.4.1.1.1 Direct event sources — Pub/Sub, Audit Logs, BigQuery, Cloud Storage
  - 7.4.1.1.2 Cloud Events 1.0 format — spec-compliant — portable event schema
- 7.4.1.2 Triggers — filter events — route matching events to service
  - 7.4.1.2.1 Audit log trigger — any GCP API call → trigger — e.g., BigQuery job complete
  - 7.4.1.2.2 Pub/Sub trigger — subscribe to topic — wrap in Cloud Event envelope

### 7.5 Apigee API Management
#### 7.5.1 Apigee Architecture
- 7.5.1.1 Enterprise API gateway — hybrid deployment — cloud + on-prem
  - 7.5.1.1.1 Apigee X — Google Cloud native — VPC-integrated — managed runtime
  - 7.5.1.1.2 Apigee hybrid — control plane in cloud, runtime on-prem K8s
- 7.5.1.2 Proxy — API proxy definition — virtual host → backend target
  - 7.5.1.2.1 API proxy flow — Request PreFlow → Conditional Flows → PostFlow
  - 7.5.1.2.2 Policies — traffic management, security, mediation, extension
- 7.5.1.3 Developer portal — built-in or Drupal-based — API catalog + try-it
- 7.5.1.4 Monetization — rate plans — per-call, volume band, freemium — billing integration
- 7.5.1.5 Advanced API Security — bot detection, abuse detection, risk score
  - 7.5.1.5.1 Traffic detection — ML model — identify automated API abuse
  - 7.5.1.5.2 Security report — summary — at-risk APIs with recommendations
