# AWS Complete Study Guide - Part 6: Monitoring & Observability + App Integration (Phase 1 — Ideal)

## 6.0 Monitoring & Observability

### 6.1 Metrics Collection
#### 6.1.1 Metrics Data Model
- 6.1.1.1 Namespace/metric/dimensions/timestamp/value/unit hierarchy
  - 6.1.1.1.1 High-resolution metrics — 1-second granularity — $0.30/metric/month
  - 6.1.1.1.2 Standard resolution — 1-minute — retained 15 days at full resolution
- 6.1.1.2 CloudWatch retention periods — 1s→3hrs, 60s→15d, 5m→63d, 1hr→15mo
- 6.1.1.3 CloudWatch Metric Math — arithmetic across metrics — ANOMALY_DETECTION_BAND
  - 6.1.1.3.1 SEARCH() function — dynamic metric discovery for dashboards
  - 6.1.1.3.2 FILL() — interpolate missing data — treat-missing-data modes

#### 6.1.2 Custom Metrics
- 6.1.2.1 PutMetricData API — batch 1000 metrics per call
  - 6.1.2.1.1 CloudWatch Agent — EC2/on-prem — procstat, statsd, collectd support
  - 6.1.2.1.2 Embedded Metrics Format (EMF) — structured log → automatic metrics

### 6.2 Log Aggregation
#### 6.2.1 CloudWatch Logs Architecture
- 6.2.1.1 Log Groups → Log Streams → Log Events hierarchy
  - 6.2.1.1.1 Retention policy — 1 day to 10 years — default never expire
  - 6.2.1.1.2 Export to S3 — up to 12hrs delay — use Subscription Filter for real-time
- 6.2.1.2 Log Insights — analytics query language — index-free full scan
  - 6.2.1.2.1 stats, sort, filter, parse commands — up to 20 log groups per query
  - 6.2.1.2.2 @logStream, @timestamp, @message built-in fields

#### 6.2.2 Log Subscription Filters
- 6.2.2.1 Real-time streaming to Lambda, Kinesis Data Streams, Firehose
  - 6.2.2.1.1 Filter pattern syntax — { $.level = "ERROR" } — JSON or free-text
  - 6.2.2.1.2 Cross-account log sharing — destination with resource policy

### 6.3 Distributed Tracing
#### 6.3.1 AWS X-Ray Architecture
- 6.3.1.1 Trace — collection of segments — end-to-end request lifecycle
  - 6.3.1.1.1 Segment — one service's work — start/end time, metadata, annotations
  - 6.3.1.1.2 Subsegment — granular operations — HTTP call, DB query, AWS API
- 6.3.1.2 Sampling rules — reduce cost — default 5% + 1 req/s reservoir
  - 6.3.1.2.1 Custom sampling rules — service name, URL, HTTP method conditions
  - 6.3.1.2.2 Centralized sampling — rules managed in X-Ray console
- 6.3.1.3 Service map — dependency graph — response time, error rates per edge
  - 6.3.1.3.1 Error/fault/throttle classification — 4xx vs. 5xx vs. 429

#### 6.3.2 OpenTelemetry Integration
- 6.3.2.1 AWS Distro for OpenTelemetry (ADOT) — OTel collector → X-Ray / CloudWatch
  - 6.3.2.1.1 OTLP receiver — receive spans from any OTel SDK
  - 6.3.2.1.2 X-Ray exporter — convert OTel spans to X-Ray segments

### 6.4 Alerting & Incident Management
#### 6.4.1 CloudWatch Alarms
- 6.4.1.1 Metric alarm states — OK, ALARM, INSUFFICIENT_DATA
  - 6.4.1.1.1 Consecutive evaluation periods required — M of N breaching
  - 6.4.1.1.2 Treat missing data — missing, notBreaching, breaching, ignore
- 6.4.1.2 Composite alarms — logical AND/OR of multiple alarms — reduce noise
  - 6.4.1.2.1 Alarm hierarchies — service → component → dependency alarms

#### 6.4.2 Amazon EventBridge
- 6.4.2.1 Event Bus — default, custom, partner — rule-based routing
  - 6.4.2.1.1 Event pattern matching — exact, prefix, wildcard, anything-but
  - 6.4.2.1.2 Archive & replay — store events → replay for debugging/backfill

### 6.5 Cost Anomaly Detection
#### 6.5.1 AWS Cost Anomaly Detection
- 6.5.1.1 ML-based — learns seasonal patterns — relative % + absolute $ thresholds
  - 6.5.1.1.1 Monitor types — AWS services, linked accounts, cost categories, tags
  - 6.5.1.1.2 Alert frequency — individual or daily/weekly digest

---

## 7.0 Application Integration & Messaging

### 7.1 Message Queues (SQS)
#### 7.1.1 Queue Types
- 7.1.1.1 Standard Queue — at-least-once delivery, best-effort ordering
  - 7.1.1.1.1 Throughput — nearly unlimited TPS
  - 7.1.1.1.2 Message deduplication — application-level idempotency key required
- 7.1.1.2 FIFO Queue — exactly-once, strict order — 3,000 TPS with batching
  - 7.1.1.2.1 Message Group ID — ordered within group, parallel across groups
  - 7.1.1.2.2 Deduplication ID — 5-minute dedup window — content hash or custom

#### 7.1.2 SQS Message Lifecycle
- 7.1.2.1 Visibility Timeout — message invisible during processing — default 30s
  - 7.1.2.1.1 ChangeMessageVisibility — extend timeout for long processing
  - 7.1.2.1.2 Too-short timeout → duplicate processing — tune carefully
- 7.1.2.2 Dead Letter Queue (DLQ) — maxReceiveCount exceeded → DLQ
  - 7.1.2.2.1 DLQ redrive — move messages back to source — manual reprocessing
  - 7.1.2.2.2 DLQ alarm — CloudWatch metric — NumberOfMessagesSent to DLQ
- 7.1.2.3 Long polling — WaitTimeSeconds 1–20s — reduce empty responses
  - 7.1.2.3.1 Short polling — immediate return — higher cost, more empty calls

#### 7.1.3 SQS Advanced Features
- 7.1.3.1 Message attributes — up to 10 — filter without body deserialization
- 7.1.3.2 Delay queues — 0–900s delivery delay — per-queue or per-message
- 7.1.3.3 Lambda trigger — event source mapping — batch size 1–10,000
  - 7.1.3.3.1 Concurrent consumers = queue depth / batch size (approximate)
  - 7.1.3.3.2 Report batch item failures — partial batch success handling

### 7.2 Pub/Sub (SNS)
#### 7.2.1 SNS Topic & Subscriptions
- 7.2.1.1 Standard topic — fan-out to up to 12.5M subscriptions
  - 7.2.1.1.1 Protocols — SQS, Lambda, HTTP/S, Email, SMS, Mobile Push
  - 7.2.1.1.2 Message filtering — subscription filter policy — attribute matching
- 7.2.1.2 FIFO topic — ordered fan-out to FIFO SQS only — deduplication
  - 7.2.1.2.1 Message archiving — FIFO topics support archive + replay

#### 7.2.2 SNS Message Delivery
- 7.2.2.1 Delivery retries — HTTP — exponential backoff — 3 immediate + 100K over 23 days
  - 7.2.2.1.1 Dead letter queue — SQS DLQ for failed Lambda/SQS deliveries
- 7.2.2.2 Delivery status logging — CloudWatch Logs — per-protocol

### 7.3 Event Buses (EventBridge)
#### 7.3.1 EventBridge Fundamentals
- 7.3.1.1 Default event bus — AWS service events — CloudTrail API events
  - 7.3.1.1.1 Custom event bus — application domain events — isolation
- 7.3.1.2 Rules — event pattern + schedule — up to 300 targets per rule
  - 7.3.1.2.1 Input transformer — reshape event payload before target delivery
  - 7.3.1.2.2 Dead letter queue — failed invocations after retries exhausted
- 7.3.1.3 Pipes — point-to-point — source → filter → enrich → target
  - 7.3.1.3.1 Sources — SQS, Kinesis, DynamoDB Streams, Kafka
  - 7.3.1.3.2 Enrichment — Lambda, API GW, Step Functions — transform between

#### 7.3.2 EventBridge Scheduler
- 7.3.2.1 Standalone scheduling — at/rate/cron — dedicated scheduler service
  - 7.3.2.1.1 Flexible time window — run within N-minute window — reduce burst

### 7.4 API Gateway
#### 7.4.1 API Types
- 7.4.1.1 REST API — full-featured — usage plans, API keys, caching, WAF
  - 7.4.1.1.1 Stage variables — environment-specific config — Lambda alias targeting
  - 7.4.1.1.2 Canary deployments — % of traffic to new stage — gradual rollout
- 7.4.1.2 HTTP API — 70% cheaper, lower latency — JWT authorizer, CORS
  - 7.4.1.2.1 Route key — METHOD /path — $default catch-all route
  - 7.4.1.2.2 No AWS integration type — only Lambda proxy + HTTP proxy
- 7.4.1.3 WebSocket API — stateful — connection management — $connect/$disconnect
  - 7.4.1.3.1 Route selection expression — route based on message body field
  - 7.4.1.3.2 Connection ID — send to specific client via management API

#### 7.4.2 API GW Performance
- 7.4.2.1 Edge-optimized (CloudFront) vs. Regional vs. Private (VPC endpoint)
  - 7.4.2.1.1 Regional — lower latency for same-region clients — WAF attachment
- 7.4.2.2 Caching — TTL 0–3600s — encryption at rest — per-method invalidation
  - 7.4.2.2.1 Cache key — URL path + selected query params + headers

### 7.5 Workflow Orchestration (Step Functions)
#### 7.5.1 State Machine Types
- 7.5.1.1 Standard — durable — at-most-once per step — up to 1yr — audit history
  - 7.5.1.1.1 Execution history — 25,000 events per execution — CloudWatch overflow
- 7.5.1.2 Express — high-throughput — at-least-once — up to 5min — cheaper
  - 7.5.1.2.1 Async Express — fire-and-forget — no sync response available

#### 7.5.2 State Types
- 7.5.2.1 Task — invoke Lambda, HTTP, SDK integration, ECS, Glue, etc.
  - 7.5.2.1.1 Request-Response vs. .sync:2 vs. .waitForTaskToken
  - 7.5.2.1.2 Optimistic lock — version token — prevent stale SDK integrations
- 7.5.2.2 Wait — pause N seconds or until timestamp
- 7.5.2.3 Parallel — concurrent branches — all must complete before continue
- 7.5.2.4 Map — iterate over array — MaxConcurrency — Distributed Map for S3
  - 7.5.2.4.1 Distributed Map — process 10M+ items — CSV/JSON/Parquet from S3

### 7.6 Streaming (Kinesis Data Streams)
#### 7.6.1 Shard Architecture
- 7.6.1.1 Shard capacity — 1 MB/s write, 2 MB/s read — 1000 records/s
  - 7.6.1.1.1 Partition key → MD5 hash → shard assignment — even distribution critical
  - 7.6.1.1.2 Hot shard — single key overloaded — hash collision — add randomness
- 7.6.1.2 On-demand mode — auto-scales shards — 200MB/s default cap
  - 7.6.1.2.1 Double capacity per 24hrs organic growth limit
- 7.6.1.3 Retention — 24hrs to 365 days — reprocess older data on demand

#### 7.6.2 Consumer Types
- 7.6.2.1 Shared throughput (GetRecords) — 2MB/s per shard split across consumers
  - 7.6.2.1.1 Polling interval — 200ms minimum — GetRecords returns 10MB max
- 7.6.2.2 Enhanced Fan-Out — 2MB/s per consumer per shard — push-based HTTP/2
  - 7.6.2.2.1 SubscribeToShard — persistent connection — sub-70ms p99 delivery
