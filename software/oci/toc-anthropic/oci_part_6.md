# OCI Complete Study Guide - Part 6: Phase 1 — Monitoring, Logging & Integration

## 6.0 Monitoring & Observability

### 6.1 OCI Monitoring
#### 6.1.1 Metrics Architecture
- 6.1.1.1 Metrics — namespace + resource group + dimensions + name — time series
  - 6.1.1.1.1 Service namespaces — oci_computeagent, oci_blockstore, oci_lbaas, etc.
  - 6.1.1.1.2 Custom metrics — PostMetricData API — push from app — custom namespace
- 6.1.1.2 MQL (Monitoring Query Language) — aggregate + transform + compare
  - 6.1.1.2.1 Functions — mean(), percentile(), rate(), absent() — time-series math
  - 6.1.1.2.2 GroupBy — aggregate across dimensions — sum per compartment
- 6.1.1.3 Alarms — MQL threshold → notification topic → PagerDuty/email/Slack
  - 6.1.1.3.1 Alarm state — FIRING / OK / RESET — de-duplication delay
  - 6.1.1.3.2 Pending duration — sustain threshold N minutes before alert — noise reduce
  - 6.1.1.3.3 Repeat notification — resend while firing — configurable interval

#### 6.1.2 Service Metrics Coverage
- 6.1.2.1 Compute — CPU utilization, memory (agent required), disk I/O, network
  - 6.1.2.1.1 OCI Compute Agent — must be running — memory + filesystem metrics
- 6.1.2.2 Block Volume — throughput, IOPS, latency — per volume
- 6.1.2.3 Load Balancer — active connections, error rate, backend health, throughput

### 6.2 OCI Logging
#### 6.2.1 Logging Architecture
- 6.2.1.1 Log types — Service Logs + Audit Logs + Custom Logs
  - 6.2.1.1.1 Service logs — enable per resource — LB access, VCN flow, Object Storage
  - 6.2.1.1.2 Audit logs — all API calls — Always On — 90-day retention
  - 6.2.1.1.3 Custom logs — app logs via OCI Logging Agent (Fluentd) — any format
- 6.2.1.2 Log groups — container for logs — IAM policies at group level
  - 6.2.1.2.1 Default log group — created automatically — console convenience
- 6.2.1.3 Log retention — 30 days default — extend to 60/90 days — archive to OS
  - 6.2.1.3.1 Service Connector Hub — continuous export → Object Storage/Streaming/Monitoring

#### 6.2.2 Log Analytics
- 6.2.2.1 Log Analytics — SIEM-lite — parse + search + visualize — OCI native
  - 6.2.2.1.1 Log sources — 200+ pre-built parsers — Syslog, Apache, Oracle DB, Linux
  - 6.2.2.1.2 Log Explorer — search language — cluster, link, classify commands
  - 6.2.2.1.3 Correlation — link related logs — IP + time + entity — investigation
- 6.2.2.2 Log Entity — represents source — host / compartment / VCN — tagged
  - 6.2.2.2.1 Entity associations — parent-child — drill-down from app to host to infra

### 6.3 Application Performance Monitoring (APM)
#### 6.3.1 APM Architecture
- 6.3.1.1 APM Domain — data plane endpoint — agent reports traces + spans
  - 6.3.1.1.1 APM Java Agent — instrument JVM — -javaagent flag — zero code change
  - 6.3.1.1.2 APM Browser Agent — JavaScript — RUM — frontend latency breakdown
- 6.3.1.2 Distributed Tracing — W3C TraceContext — propagate across services
  - 6.3.1.2.1 Trace Explorer — waterfall view — span duration + status + errors
  - 6.3.1.2.2 Service map — auto-discovered — dependency graph — latency heatmap
- 6.3.1.3 Synthetic monitoring — scheduled scripts — Selenium/REST — from OCI nodes
  - 6.3.1.3.1 Availability monitor — global vantage points — uptime SLA tracking

### 6.4 Notifications, Streaming & Queue
#### 6.4.1 Notifications
- 6.4.1.1 Notifications service — topic → subscription → deliver
  - 6.4.1.1.1 Subscription protocols — HTTPS endpoint, email, Slack, PagerDuty, SMS
  - 6.4.1.1.2 At-least-once delivery — retry with backoff — 60-second max latency
- 6.4.1.2 Integration with Alarms + Cloud Guard + Events — automatic topics

#### 6.4.2 Streaming (Kafka-compatible)
- 6.4.2.1 Stream — Kafka-compatible — partitioned — retention 1–168 hours
  - 6.4.2.1.1 Partitions — 1–5 per stream — parallel consumers — ordering per partition
  - 6.4.2.1.2 Kafka API compatibility — use Kafka producer/consumer SDK — no code change
- 6.4.2.2 Stream Pool — group streams — encryption key + access control
  - 6.4.2.2.1 Private stream pool — FQDN in VCN — no internet — private endpoint
- 6.4.2.3 Connectors — Service Connector Hub — stream → Object Storage / Functions

#### 6.4.3 Queue Service
- 6.4.3.1 OCI Queue — HTTP API — SQS-like — transactional message delivery
  - 6.4.3.1.1 Visibility timeout — message hidden after read — ack before timeout
  - 6.4.3.1.2 Dead letter queue — messages exceeding max delivery attempts — isolate
  - 6.4.3.1.3 FIFO — per-channel ordering — channel ID groups related messages

### 6.5 Events Service
#### 6.5.1 Events Architecture
- 6.5.1.1 Events — CloudEvents spec — emit on resource state change — OCI native
  - 6.5.1.1.1 Event types — resource.create / resource.update / resource.delete
  - 6.5.1.1.2 Rules — filter by event type + attributes — match subset of events
- 6.5.1.2 Event actions — Notifications, Streaming, Functions — fan-out targets
  - 6.5.1.2.1 Object Storage create event → trigger Function → process new file

### 6.6 API Gateway
#### 6.6.1 API Gateway Architecture
- 6.6.1.1 Managed API Gateway — regional — VCN-attached — public or private
  - 6.6.1.1.1 Deployment — set of routes — backend type (HTTP/HTTPS, Functions, stock)
  - 6.6.1.1.2 Route — path + methods → backend — regex path params supported
- 6.6.1.2 Authentication + Authorization
  - 6.6.1.2.1 JWT validation — public key / JWKS URL — token expiry + claims check
  - 6.6.1.2.2 OCI IAM Authorizer — OAuth 2 tokens — OCI scope-based
  - 6.6.1.2.3 Custom Authorizer — OCI Function — return 200 with context headers
- 6.6.1.3 Rate limiting — request/second per client — per-route or per-deployment
  - 6.6.1.3.1 Rate limit key — IP or JWT claim — per-user throttle
- 6.6.1.4 Request/response transformation — add/remove/rename headers — body transform
  - 6.6.1.4.1 Context variables — ${request.path.params}, ${request.headers.*}
- 6.6.1.5 CORS — origin allowlist — preflight handling — API Gateway managed
  - 6.6.1.5.1 Wildcard origin — allow all — dev mode — restrict in prod
