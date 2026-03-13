# Cloud Design Patterns - Part 16: Observability & Operations (I)

## 9.0 Observability & Operations Patterns

### 9.1 Distributed Tracing
#### 9.1.1 Pattern Intent
- 9.1.1.1 Track a request as it flows through multiple services — reconstruct end-to-end latency
- 9.1.1.2 Identify bottlenecks, errors, and unexpected service-call patterns
#### 9.1.2 Trace Anatomy
- 9.1.2.1 Trace — complete request journey; identified by global unique trace ID
- 9.1.2.2 Span — single unit of work within a trace; has start time, duration, tags, logs
  - 9.1.2.2.1 Root span — entry point span at first service
  - 9.1.2.2.2 Child span — created per downstream call; parent-child linked by span/parent IDs
- 9.1.2.3 Context propagation — trace/span IDs carried in headers across service boundaries
  - 9.1.2.3.1 W3C TraceContext — standard: traceparent + tracestate headers
  - 9.1.2.3.2 B3 propagation — Zipkin format: X-B3-TraceId, X-B3-SpanId, X-B3-Sampled
#### 9.1.3 Sampling Strategies
- 9.1.3.1 Head sampling — sampling decision made at trace root; propagated to all children
  - 9.1.3.1.1 Fixed-rate sampling — sample 1% of all traces; misses low-frequency errors
- 9.1.3.2 Tail sampling — collect all spans; sampling decision after trace completes
  - 9.1.3.2.1 Error-biased tail sampling — always keep traces with errors or high latency
- 9.1.3.3 Adaptive sampling — dynamically adjust rate based on traffic volume and error rates
#### 9.1.4 Instrumentation
- 9.1.4.1 Auto-instrumentation — agent-based (OpenTelemetry Java Agent); zero code changes
- 9.1.4.2 Manual instrumentation — explicit span creation around custom business logic
- 9.1.4.3 OpenTelemetry (OTel) — vendor-neutral SDK; exports to Jaeger, Tempo, Zipkin, Datadog
  - 9.1.4.3.1 OTel Collector — receive, process, export pipeline; batching, sampling, routing
#### 9.1.5 Trace Analysis
- 9.1.5.1 Waterfall view — visualize sequential and parallel spans; identify critical path
- 9.1.5.2 Service dependency graph — auto-generated from trace data; visualize call patterns
- 9.1.5.3 Trace-metric correlation — link high-latency traces to corresponding metric anomalies

### 9.2 Structured Logging
#### 9.2.1 Log Levels & Semantics
- 9.2.1.1 ERROR — action required; system cannot complete intended operation
- 9.2.1.2 WARN — unexpected situation; system recovered but issue requires attention
- 9.2.1.3 INFO — normal operational events; service started, request completed, config loaded
- 9.2.1.4 DEBUG — diagnostic detail; verbose; disabled in production by default
#### 9.2.2 Structured Log Format
- 9.2.2.1 JSON logging — machine-parseable; enables log indexing and query on arbitrary fields
  - 9.2.2.1.1 Required fields — timestamp (ISO8601), level, service, version, traceId, spanId
- 9.2.2.2 Log correlation — embed traceId/spanId to correlate logs with distributed traces
- 9.2.2.3 Semantic conventions — OTel log semantic conventions; consistent field naming across services
#### 9.2.3 Log Aggregation Pipeline
- 9.2.3.1 Collection — DaemonSet agent per node (Fluentbit/Vector) tails container logs
- 9.2.3.2 Forwarding — ship to indexing backend via HTTP or gRPC with backpressure
- 9.2.3.3 Indexing — Elasticsearch/OpenSearch index; Loki label-based (no full indexing)
  - 9.2.3.3.1 Loki labels — index only metadata (service, env, pod); log line not indexed; cost-efficient
- 9.2.3.4 Retention policy — hot (7 days), warm (30 days), cold (1 year); lifecycle to S3 Glacier
#### 9.2.4 Log Security
- 9.2.4.1 PII redaction — scrub email, phone, SSN, card numbers before indexing
- 9.2.4.2 Log injection prevention — sanitize user input included in log messages
- 9.2.4.3 Log tampering prevention — write to immutable log store; hash chain verification

### 9.3 Metrics, SLIs, SLOs & Error Budgets
#### 9.3.1 Four Golden Signals (Google SRE)
- 9.3.1.1 Latency — time to serve request; distinguish success latency from error latency
- 9.3.1.2 Traffic — request rate; measure system demand
- 9.3.1.3 Errors — rate of failed requests; classify 5xx vs. 4xx vs. business errors
- 9.3.1.4 Saturation — how full is the resource? — CPU queue depth, disk IOPS limit
#### 9.3.2 SLI Definition
- 9.3.2.1 SLI (Service Level Indicator) — quantitative measure of service behavior
  - 9.3.2.1.1 Request success rate — (good_requests / total_requests) × 100
  - 9.3.2.1.2 Latency SLI — % of requests completing below threshold (e.g., 95% under 200ms)
- 9.3.2.2 SLI instrumentation — metrics emitted per request; histogram for latency distribution
#### 9.3.3 SLO & Error Budget
- 9.3.3.1 SLO (Service Level Objective) — target for SLI (e.g., 99.9% success rate over 30 days)
- 9.3.3.2 Error budget = 1 - SLO; budget of allowed failures (e.g., 43.8 min/month at 99.9%)
  - 9.3.3.2.1 Error budget burn rate — rate at which budget is consumed; alert at 2× normal rate
  - 9.3.3.2.2 Multi-window burn rate alerts — short window (1h) AND long window (6h) both breached
- 9.3.3.3 Error budget policy — freeze deployments when budget is exhausted; focus on reliability
#### 9.3.4 Alerting Strategy
- 9.3.4.1 Alert on symptoms (user-facing SLIs) not causes (CPU/disk)
- 9.3.4.2 Alert fatigue — too many alerts desensitize on-call; eliminate low-signal alerts
- 9.3.4.3 PagerDuty / OpsGenie — escalation policies; on-call rotation; incident deduplication

### 9.4 Chaos Engineering
#### 9.4.1 Pattern Intent
- 9.4.1.1 Proactively inject failures in controlled way to discover weaknesses before production
- 9.4.1.2 Build confidence in system's ability to handle turbulent conditions
#### 9.4.2 Steady State Hypothesis
- 9.4.2.1 Define measurable steady state — success rate > 99.9%, p99 latency < 200ms
- 9.4.2.2 Run experiment — inject failure; verify steady state holds or discover violation
#### 9.4.3 Failure Injection Types
- 9.4.3.1 Network failures — latency injection, packet loss, DNS failures, partition simulation
- 9.4.3.2 Resource failures — CPU pressure, memory exhaustion, disk full
- 9.4.3.3 Application failures — kill pods, crash processes, inject exception responses
- 9.4.3.4 Infrastructure failures — terminate EC2 instances, AZ blackout simulation
#### 9.4.4 Chaos Tooling
- 9.4.4.1 Chaos Monkey (Netflix) — randomly terminates EC2 instances in production
- 9.4.4.2 Chaos Mesh (Kubernetes) — pod kill, network chaos, stress, I/O chaos; CRD-based
- 9.4.4.3 Gremlin — SaaS; scenario-based; blast radius control; hypothesis-driven
- 9.4.4.4 AWS Fault Injection Simulator (FIS) — managed; IAM-controlled; experiment templates
