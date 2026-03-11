# AWS Complete Study Guide - Part 14: Phase 2 — Step Functions, Kinesis, CloudFront/Route 53

## 28.0 AWS Step Functions

### 28.1 Step Functions Core
→ See Ideal §7.5 Workflow Orchestration, §7.5.1 State Machine Types, §7.5.2 State Types

#### 28.1.1 Step Functions-Unique Features
- **Unique: Optimistic Locking via version token**
  - 28.1.1.1 Start execution with versionId — reject stale state machine updates
- **Unique: SDK Integrations (200+ AWS services)**
  - 28.1.1.2 .sync:2 pattern — wait for async job — polling internal — no Lambda needed
  - 28.1.1.3 EMR, Glue, SageMaker, ECS tasks — native orchestration — no wrapper Lambda
- **Unique: Activity Tasks** — worker polls for task — decoupled — on-prem workers
  - 28.1.1.4 Heartbeat timeout — worker must heartbeat — detect stuck workers
- **Unique: Distributed Map (for big data)**
  - 28.1.1.5 Process S3 objects in parallel — CSV, JSON, Parquet manifests
  - 28.1.1.6 MaxConcurrency 1–10,000 — tolerated failure threshold — auto-batch
  - 28.1.1.7 Child workflow execution — each item launches sub-execution
- **Unique: Test State API** — test individual state with mocked input — no full execution
  - 28.1.1.8 Pay-per-test — no execution costs — rapid iteration
- **Unique: Redrive execution** — resume failed Standard workflow from failed state
  - 28.1.1.9 Redrives count toward execution history
- **Unique: State machine versioning and aliases**
  - 28.1.1.10 Version published on deploy — alias points to 1-2 versions with weights
  - 28.1.1.11 Canary deployment of workflow changes — shift % to new version

---

## 29.0 Amazon Kinesis

### 29.1 Kinesis Data Streams Core
→ See Ideal §7.6 Streaming, §7.6.1 Shard Architecture, §7.6.2 Consumer Types

#### 29.1.1 Kinesis-Unique Features
- **Unique: Enhanced Fan-Out (EFO)** — dedicated 2MB/s per registered consumer
  - 29.1.1.1 HTTP/2 SubscribeToShard — push-based — sub-70ms p99 delivery
  - 29.1.1.2 Consumer deregistration — release reserved throughput
- **Unique: Kinesis Client Library (KCL 2.x)**
  - 29.1.1.3 Dynamic shard balancing — redistribute shards across workers
  - 29.1.1.4 Lease table in DynamoDB — checkpoint + worker assignment
  - 29.1.1.5 Multilang daemon — sidecar IPC — non-Java languages
- **Unique: On-Demand Capacity Mode**
  - 29.1.1.6 Auto-scale shards — double capacity per 24hrs — burst beyond previous peak
  - 29.1.1.7 No shard splits/merges manually — managed entirely
- **Unique: Server-Side Encryption** — KMS-based — transparent to producers/consumers
  - 29.1.1.8 Encryption at rest — each record encrypted with data key

### 29.2 Kinesis Data Firehose
→ See Ideal §10.3.1 Kinesis Firehose

#### 29.2.1 Firehose-Unique Features
- **Unique: Direct PUT** — Firehose as standalone ingest — no KDS required
  - 29.2.1.1 Source types — KDS, MSK, Direct PUT, Waf, CloudWatch, EventBridge
- **Unique: Dynamic partitioning** — inline Lambda extracts partition key from record body
  - 29.2.1.2 S3 prefix — !{partitionKeyFromQuery:customer_id}/year=!{timestamp:yyyy}/
  - 29.2.1.3 Buffer per partition — each partition gets own buffer — more S3 files
- **Unique: Format conversion** — JSON → Parquet/ORC using Glue Schema Registry
  - 29.2.1.4 Nested records flattened or preserved — Parquet schema evolution handling
- **Unique: Destinations**
  - 29.2.1.5 OpenSearch — index rotation — index pattern suffix
  - 29.2.1.6 Redshift COPY command — staging S3 → Redshift — automatic manifest
  - 29.2.1.7 HTTP endpoint — Datadog/Splunk/MongoDB Atlas — custom headers+access key

---

## 30.0 Amazon CloudFront & Route 53

### 30.1 CloudFront Core
→ See Ideal §2.8 CDN & Edge Delivery, §2.8.1 Architecture

#### 30.1.1 CloudFront-Unique Features
- **Unique: Origin Access Control (OAC)** — replace OAI — supports all S3 regions + SSE-KMS
  - 30.1.1.1 Signing behavior — always sign, never, no override
  - 30.1.1.2 KMS-encrypted S3 — grant CloudFront service principal kms:Decrypt
- **Unique: Continuous Deployment** — staging distribution — A/B test CloudFront config
  - 30.1.1.3 Traffic weight 0–15% to staging — header-based routing for testing
  - 30.1.1.4 Promote staging to primary — one-click — atomically
- **Unique: Cache Policies vs. Origin Request Policies**
  - 30.1.1.5 Cache policy — TTL + cache key components — separate from forward to origin
  - 30.1.1.6 Origin request policy — forward headers/cookies/query without caching them
- **Unique: Response Headers Policy** — add security headers at edge
  - 30.1.1.7 CORS, CSP, HSTS, X-Frame-Options — no origin code change
- **Unique: Geo restriction** — allowlist/blocklist — country-level — CloudFront standard
- **Unique: Field-Level Encryption** — encrypt specific POST fields at edge — only backend decrypts
  - 30.1.1.8 RSA 2048-bit key — encrypt credit card/PII before reaching origin
- **Unique: Real-time Logs** — sub-second delivery to Kinesis — configurable sampling %
  - 30.1.1.9 Fields — cs-uri-stem, time-to-first-byte, x-edge-result-type
- **Unique: CloudFront Functions** — sub-1ms — 10KB — Viewer req/resp only — URL rewrite/redirect
  - 30.1.1.10 Key-value store — read config at edge — A/B test vars, feature flags

### 30.2 Amazon Route 53
→ See Ideal §2.4 DNS Resolution, §2.4.2 Record Types

#### 30.2.1 Route 53-Unique Features
- **Unique: Route 53 Application Recovery Controller (ARC)**
  - 30.2.1.1 Routing controls — manually flip traffic between regions — operator panel
  - 30.2.1.2 Readiness checks — verify infra capacity before failover
  - 30.2.1.3 Safety rules — prevent flip if checks fail — prevent split-brain
- **Unique: Route 53 Resolver DNS Firewall**
  - 30.2.1.4 Domain block/allow lists — prevent DNS exfiltration — malware C2 blocking
  - 30.2.1.5 Managed domain lists — AWS-maintained — malware, botnet, crypto-mining
- **Unique: DNSSEC for Route 53 hosted zones**
  - 30.2.1.6 Key-signing key (KSK) in KMS — AWS manages zone-signing key (ZSK)
  - 30.2.1.7 DS record to parent zone — chain of trust
- **Unique: Traffic Flow** — visual policy builder — complex routing logic
  - 30.2.1.8 Geoproximity with bias — pull traffic toward/away from region
  - 30.2.1.9 Versioned policies — A/B test routing configs without outage
- **Unique: Health Checks**
  - 30.2.1.10 HTTP/S/TCP — interval 10s or 30s — 3 failure threshold
  - 30.2.1.11 Calculated health checks — AND/OR/NOT logic across child checks
  - 30.2.1.12 CloudWatch metric alarm as health check — custom business health
