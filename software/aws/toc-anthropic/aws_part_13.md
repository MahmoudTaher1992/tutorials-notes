# AWS Complete Study Guide - Part 13: Phase 2 — CloudWatch/X-Ray, SQS/SNS/EventBridge, API GW

## 25.0 Amazon CloudWatch & X-Ray

### 25.1 CloudWatch Core
→ See Ideal §6.1 Metrics, §6.2 Log Aggregation, §6.4 Alerting

#### 25.1.1 CloudWatch-Unique Features
- **Unique: Container Insights** — ECS/EKS/K8s metrics — CPU/mem per pod/task
  - 25.1.1.1 Enhanced observability — individual container GPU, disk, network metrics
  - 25.1.1.2 CloudWatch agent DaemonSet — FluentBit sidecar for log routing
- **Unique: Lambda Insights** — cold start, memory usage, init duration per invocation
  - 25.1.1.3 Installed as Lambda extension — low overhead
- **Unique: Application Signals** — auto-instrumentation — SLOs — service map
  - 25.1.1.4 OpenTelemetry-based — no code change — Java/Python/Node agent
  - 25.1.1.5 SLO definition — attainment goal — breach alarm
- **Unique: Metrics Streams** — real-time metrics to Firehose → S3/SIEM — sub-minute
  - 25.1.1.6 OpenTelemetry 0.7 or JSON format — 3rd party observability platforms
- **Unique: CloudWatch Internet Monitor** — ISP/city-level internet health — availability
  - 25.1.1.7 Traffic optimization — identify routing issues — inform Route 53 latency routing
- **Unique: Network Performance Monitor** — TCP probes between ENIs — latency/packet loss
  - 25.1.1.8 Cross-AZ, cross-region measurements — 30s intervals

### 25.2 AWS X-Ray Core
→ See Ideal §6.3 Distributed Tracing

#### 25.2.1 X-Ray-Unique Features
- **Unique: X-Ray SDK integrations** — AWS SDK, HTTP clients, SQL — auto-instrument
  - 25.2.1.1 AWSXRayRecorder — Lambda, EC2, ECS, Beanstalk — automatic segments
  - 25.2.1.2 OpenTelemetry ADOT → X-Ray — preferred for new applications
- **Unique: X-Ray Groups** — filter expressions — separate sampling rules per group
  - 25.2.1.3 Service Map per group — focused views — team-specific service maps
- **Unique: X-Ray Insights** — anomaly detection — error/fault/throttle trend analysis
  - 25.2.1.4 Incident timeline — root cause graph — correlated services

---

## 26.0 Amazon SQS, SNS & EventBridge

### 26.1 SQS Core
→ See Ideal §7.1 Message Queues, §7.1.1 Queue Types, §7.1.2 Message Lifecycle

#### 26.1.1 SQS-Unique Features
- **Unique: Server-Side Encryption (SSE-KMS)** — per-message encryption at rest
  - 26.1.1.1 SSE-SQS — AWS-managed key — free — default encryption option
- **Unique: VPC Endpoints for SQS** — private connectivity — no internet required
- **Unique: Message Timer** — individual message delay up to 15 minutes
  - 26.1.1.2 Override queue-level delay on per-message basis
- **Unique: Lambda Scaling Behavior**
  - 26.1.1.3 Standard SQS — scale up 60 concurrent per minute — max 1000 default
  - 26.1.1.4 FIFO SQS — scale up 60 per minute — max 300 (or 3000 with high throughput)
  - 26.1.1.5 ReportBatchItemFailures — partial success — failed items back to queue only

### 26.2 SNS Core
→ See Ideal §7.2 Pub/Sub, §7.2.1 Topics & Subscriptions

#### 26.2.1 SNS-Unique Features
- **Unique: Mobile Push** — APNs (iOS), FCM (Android), ADM, Baidu — device token mgmt
  - 26.2.1.1 Platform Application — pool of device endpoints — TTL for stale tokens
  - 26.2.1.2 Direct addressing — send to specific device — PersonalizeMessage
- **Unique: SMS messaging** — SMS Sandbox — origination identity (10DLC, shortcode)
  - 26.2.1.3 Spending limits — monthly budget cap — automatic stop
- **Unique: SNS Data Protection** — PII detection in messages — mask/deny/audit
  - 26.2.1.4 Managed data identifiers — credit cards, SSNs, PHI
- **Unique: Message Data Protection Policies** — applied at publish/subscribe time

### 26.3 EventBridge Core
→ See Ideal §7.3 Event Buses, §6.4.2 EventBridge

#### 26.3.1 EventBridge-Unique Features
- **Unique: Schema Registry** — auto-discover event schemas — versioned
  - 26.3.1.1 Code binding generator — typed classes — Python/Java/TypeScript
  - 26.3.1.2 OpenAPI schema format — download and import
- **Unique: Partner Event Sources** — 200+ SaaS integrations — Salesforce, Datadog, Stripe
  - 26.3.1.3 Partner source creates event bus — map to custom bus for processing
- **Unique: Cross-account event bus** — resource policy — receive events from other accounts
  - 26.3.1.4 Centralized event aggregation — all accounts → security/ops account bus

---

## 27.0 Amazon API Gateway

### 27.1 API Gateway Core
→ See Ideal §7.4 API Gateway, §7.4.1 API Types, §7.4.2 Performance

#### 27.1.1 API GW-Unique Features
- **Unique: Request/Response Transformation (REST API)**
  - 27.1.1.1 Mapping templates — VTL (Velocity Template Language) — reshape payload
  - 27.1.1.2 Direct integration — SQS/SNS/DynamoDB without Lambda — reduce cost
  - 27.1.1.3 Mock integration — static responses — dev/testing environments
- **Unique: Usage Plans & API Keys**
  - 27.1.1.4 Throttle: burst + rate — per-plan, per-stage, per-method granularity
  - 27.1.1.5 Quota: per-day/week/month request count limit — hard cap
- **Unique: Authorizers**
  - 27.1.1.6 Lambda authorizer (token-based) — JWT/OAuth — cache policy 0–3600s
  - 27.1.1.7 Lambda authorizer (request-based) — full request context — header+path
  - 27.1.1.8 Cognito User Pools authorizer — built-in JWT verification — zero Lambda
- **Unique: Private REST APIs** — VPC endpoint — internet not required
  - 27.1.1.9 Resource policy required — allow vpce or VPC as source
  - 27.1.1.10 Edge-optimized + private — distinct configurations — know difference
- **Unique: Mutual TLS (mTLS)** — client certificate validation — truststore on S3
  - 27.1.1.11 Passthrough certificate to Lambda — validate in custom authorizer
- **Unique: WebSocket $connect/$disconnect/$default routes**
  - 27.1.1.12 Connection management API — POST to @connections/{connectionId} — send to client
  - 27.1.1.13 Idle timeout — 10 minutes — max duration 2 hours
- **Unique: HTTP API JWT Authorizer** — zero-code — iss/aud validation built-in
  - 27.1.1.14 Scope-based authorization — require specific OAuth scopes per route
