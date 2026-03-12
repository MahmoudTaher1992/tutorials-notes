# Azure Complete Study Guide - Part 6: Monitoring & Observability + App Integration (Phase 1 — Ideal)

## 6.0 Monitoring & Observability

### 6.1 Azure Monitor (Metrics)
#### 6.1.1 Metrics Platform
- 6.1.1.1 Platform metrics — auto-collected — free — 93-day retention
  - 6.1.1.1.1 1-minute granularity — retained 93 days — no configuration needed
  - 6.1.1.1.2 Metric namespaces — per resource type — Microsoft.Compute/virtualMachines
- 6.1.1.2 Custom metrics — REST API / SDK / OTEL — 30-day retention
  - 6.1.1.2.1 Dimensions — up to 10 per metric — filter/split in charts
  - 6.1.1.2.2 Azure Monitor agent — VM guest metrics — CPU per core, disk queue
- 6.1.1.3 Metrics Explorer — time range, aggregation, splitting, filtering
  - 6.1.1.3.1 Pin to dashboard — shareable — cross-resource queries

#### 6.1.2 Prometheus Metrics
- 6.1.2.1 Azure Monitor managed Prometheus — AKS scraping — Grafana integration
  - 6.1.2.1.1 Remote write endpoint — store Prometheus metrics in Azure Monitor
  - 6.1.2.1.2 18-month retention — cheaper than self-managed Prometheus storage

### 6.2 Log Analytics / Azure Monitor Logs
#### 6.2.1 Log Analytics Workspace
- 6.2.1.1 Data store — Kusto (KQL) — columnar — compressed
  - 6.2.1.1.1 Retention — interactive 30–730 days — archive up to 12 years
  - 6.2.1.1.2 Basic Logs — $0.60/GB — 8-day retention — limited KQL — high-volume
  - 6.2.1.1.3 Analytics Logs — full KQL — $2.30/GB ingestion — default tier
- 6.2.1.2 Commitment tiers — 100GB–5000GB/day — 25–33% discount over PAYG
  - 6.2.1.2.1 Cluster dedication — 500GB/day minimum — CMK + security isolation

#### 6.2.2 KQL (Kusto Query Language)
- 6.2.2.1 Tabular operators — where, project, extend, summarize, join, union, render
  - 6.2.2.1.1 summarize — aggregation — count, avg, max, percentile, dcount
  - 6.2.2.1.2 join flavors — inner, leftouter, rightouter, fullouter, leftanti — bloom filter hint
- 6.2.2.2 Time series — make-series, series_decompose, series_outliers
  - 6.2.2.2.1 Anomaly detection — series_decompose_anomalies — ML built-in
- 6.2.2.3 Cross-resource queries — workspace union — all workspaces in subscription

#### 6.2.3 Diagnostic Settings
- 6.2.3.1 Resource logs (formerly diagnostic logs) — control + data plane operations
  - 6.2.3.1.1 Destinations — Log Analytics, Storage Account, Event Hub, Partner solution
  - 6.2.3.1.2 Category selection — per resource type — not all categories free

### 6.3 Application Insights (APM)
#### 6.3.1 Application Insights Architecture
- 6.3.1.1 Auto-instrumentation — Azure App Service, Functions, AKS — no code change
  - 6.3.1.1.1 SDK-based — manual — richer custom telemetry — TrackEvent, TrackMetric
  - 6.3.1.1.2 OpenTelemetry-based SDK — OTEL exporter → Azure Monitor
- 6.3.1.2 Telemetry types — requests, dependencies, exceptions, traces, events, metrics
  - 6.3.1.2.1 Sampling — adaptive (default) or fixed — reduce volume, keep distribution
  - 6.3.1.2.2 Telemetry initializers — enrich all telemetry — add tenant ID, version

#### 6.3.2 Application Insights Features
- 6.3.2.1 Application Map — dependency graph — latency + failure rate per edge
  - 6.3.2.1.1 Cloud role name — distinguish microservices on shared workspace
- 6.3.2.2 Live Metrics — real-time — 1-second refresh — no sampling — secure channel
  - 6.3.2.2.1 QuickPulse endpoint — filtered telemetry stream — prod debugging
- 6.3.2.3 Availability tests — URL ping, multi-step, TrackAvailability custom
  - 6.3.2.3.1 Standard test — SSL validity + response code + content match
  - 6.3.2.3.2 Up to 5 global PoPs — alert on partial failure
- 6.3.2.4 Smart Detection — automatic anomaly alerts — failure rate, latency, memory
  - 6.3.2.4.1 Adaptive learning — baselines per hour-of-day, day-of-week

### 6.4 Alerting & Action Groups
#### 6.4.1 Alert Rules
- 6.4.1.1 Metric alerts — static threshold or dynamic (ML baseline)
  - 6.4.1.1.1 Dynamic thresholds — High/Medium/Low sensitivity — 4 periods history
- 6.4.1.2 Log search alerts — KQL query — result count or metric measurement
  - 6.4.1.2.1 Dimension split — alert per VM/app — separate firing conditions
- 6.4.1.3 Activity log alerts — control plane events — policy violation, resource delete

#### 6.4.2 Action Groups
- 6.4.2.1 Notification types — email, SMS, push, voice
- 6.4.2.2 Action types — Logic App, Azure Function, webhook, ITSM, Runbook, Event Hub
  - 6.4.2.2.1 Secure webhook — Entra auth — validate caller is Azure Monitor
  - 6.4.2.2.2 ITSM — ServiceNow/Provance — create incident from alert

---

## 7.0 Application Integration & Messaging

### 7.1 Azure Service Bus
#### 7.1.1 Service Bus Namespaces & Tiers
- 7.1.1.1 Basic — queues only — no topics — low cost
- 7.1.1.2 Standard — queues + topics — variable throughput
- 7.1.1.3 Premium — dedicated resources — predictable perf — 1/2/4/8/16 Messaging Units
  - 7.1.1.3.1 Zone redundancy — 3 AZs — 99.99% SLA
  - 7.1.1.3.2 VNet integration — private endpoint or service endpoint

#### 7.1.2 Service Bus Queues
- 7.1.2.1 At-least-once delivery — lock-based — peek-lock vs. receive-and-delete
  - 7.1.2.1.1 Lock duration — 60s default — max 5 minutes — renew for long processing
  - 7.1.2.1.2 MaxDeliveryCount — 10 default — exceeded → Dead Letter Queue
- 7.1.2.2 Dead Letter Queue — poison messages — automatic transfer — reason header
  - 7.1.2.2.1 DeadLetterReason — MaxDeliveryCountExceeded, TTLExpiredException, etc.
- 7.1.2.3 Sessions — ordered FIFO — session ID groups — single consumer per session
  - 7.1.2.3.1 Session state — store per-session data — implement workflows
- 7.1.2.4 Deferred messages — park message — retrieve by sequence number later
- 7.1.2.5 Scheduled messages — EnqueuedTimeUtc — delay delivery up to 7 days

#### 7.1.3 Service Bus Topics & Subscriptions
- 7.1.3.1 Pub/sub fan-out — topic → N subscriptions — independent consumers
  - 7.1.3.1.1 Subscription filter — SQL filter or correlation filter — subset of messages
  - 7.1.3.1.2 Rule actions — modify message properties on match
- 7.1.3.2 Forwarding — auto-forward subscription to queue/topic — chaining
  - 7.1.3.2.1 Dead letter forwarding — route DLQ to processing queue

### 7.2 Azure Event Hubs
#### 7.2.1 Event Hubs Architecture
- 7.2.1.1 Partitioned log — ordered within partition — configurable 1–2048 partitions
  - 7.2.1.1.1 Partition key — hash → partition — order guarantee within key
  - 7.2.1.1.2 Throughput Units (Standard) / Processing Units (Premium) — 1TU = 1MB/s in, 2MB/s out
- 7.2.1.2 Tiers — Basic, Standard, Premium, Dedicated
  - 7.2.1.2.1 Premium — 4 PUs minimum — Kafka + schema registry + private link
  - 7.2.1.2.2 Dedicated — single-tenant cluster — 10GB/s+ — 1 to 20 CUs

#### 7.2.2 Event Hubs Features
- 7.2.2.1 Kafka surface — Topic = Event Hub, ConsumerGroup = $Default
  - 7.2.2.1.1 Protocol v2.1 compatible — producer + consumer — no Zookeeper
- 7.2.2.2 Capture — auto-write to Storage/Data Lake Gen2 — Avro format
  - 7.2.2.2.1 Time/size window — capture when threshold reached
- 7.2.2.3 Geo-disaster recovery — metadata replication — manual failover
  - 7.2.2.3.1 Alias name — DNS — swap primary/secondary without client change
- 7.2.2.4 Schema Registry — Avro/JSON/Protobuf — versioning + compatibility modes

### 7.3 Azure Event Grid
#### 7.3.1 Event Grid Architecture
- 7.3.1.1 Push-based event routing — HTTP/WebHook — reactive pub/sub
  - 7.3.1.1.1 Event schema — Event Grid schema or Cloud Events 1.0
  - 7.3.1.1.2 Topics — System (Azure resource events) / Custom / Partner
- 7.3.1.2 Event subscriptions — filter by event type, subject prefix/suffix
  - 7.3.1.2.1 Dead letter — undeliverable after retries — Storage Blob destination
  - 7.3.1.2.2 Retry policy — max attempts 30, max event TTL 1440 minutes
- 7.3.1.3 Push delivery targets — Function, Logic App, Service Bus, Event Hub, Webhook

### 7.4 Azure API Management (APIM)
#### 7.4.1 APIM Architecture & Tiers
- 7.4.1.1 Tiers — Developer, Basic, Standard, Premium, Consumption, Isolated
  - 7.4.1.1.1 Premium — multi-region, VNet integration, availability zones
  - 7.4.1.1.2 Consumption — serverless — pay-per-call — no SLA — lightweight
- 7.4.1.2 Inbound → Backend → Outbound + Error pipeline
  - 7.4.1.2.1 Policy expressions — C# inline — context.Request, context.Response

#### 7.4.2 APIM Policies
- 7.4.2.1 Rate limiting — rate-limit-by-key — token bucket per key
  - 7.4.2.1.1 quota-by-key — total calls + bandwidth over period
- 7.4.2.2 Caching — cache-lookup / cache-store — vary-by header/query
- 7.4.2.3 JWT validation — validate-jwt — Entra ID / custom OIDC
- 7.4.2.4 Backend circuit breaker — backend health — trip on error rate
- 7.4.2.5 Mock response — return-response — development/testing
- 7.4.2.6 Transform — set-header, set-query-parameter, rewrite-uri, set-body (XSLT/Liquid)
