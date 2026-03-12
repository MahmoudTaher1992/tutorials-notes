# Azure Complete Study Guide - Part 13: Phase 2 — Azure Monitor, Service Bus, Event Hubs, APIM

## 25.0 Azure Monitor & Application Insights

### 25.1 Azure Monitor Core
→ See Ideal §6.1 Metrics, §6.2 Log Aggregation, §6.3 Distributed Tracing

#### 25.1.1 Azure Monitor-Unique Features
- **Unique: Azure Monitor Agent (AMA)** — unified agent — replaces MMA/OMS/Diagnostics
  - 25.1.1.1 Data Collection Rules (DCR) — define what/where to collect — per-VM or centrally
  - 25.1.1.2 XPath filtering — Windows Event Log — collect only specific event IDs
  - 25.1.1.3 Transformation at collection — KQL transform — filter before storing
- **Unique: Metrics Advisor** — AI anomaly detection service — multivariate anomaly
  - 25.1.1.4 Feed metrics time series — detect multi-metric correlated anomalies
- **Unique: Azure Monitor Pipeline** — centralized collection → route → enrich → store
  - 25.1.1.5 Pipeline endpoints — OTLP ingest — collect from any OTel SDK
- **Unique: Log Analytics Workspace — Commitment Tiers**
  - 25.1.1.6 100/200/300/400/500/1000/2000/5000 GB/day — 25–33% discount
  - 25.1.1.7 Cluster-level billing — dedicated cluster — CMK + advanced features
- **Unique: Container Insights** — AKS + Arc K8s — pod CPU/mem, node, PV metrics
  - 25.1.1.8 Prometheus scraping — managed Prometheus store — Grafana dashboard
  - 25.1.1.9 Live data view — real-time logs/events/metrics — no query needed

### 25.2 Application Insights-Unique Features
→ See Ideal §6.3 Distributed Tracing

- **Unique: Application Map** — auto-discovered dependency graph — health per component
  - 25.2.1.1 Cloud role name — set via TelemetryInitializer — multi-service in same workspace
- **Unique: Profiler** — CPU + memory profiler — production — 2-minute sampling
  - 25.2.1.2 Flame graphs — call stack aggregation — top CPU consumers
  - 25.2.1.3 Trigger on high CPU/memory — conditional profiling
- **Unique: Snapshot Debugger** — capture call stack + locals at exception — production
  - 25.2.1.4 Minidump uploaded to storage — view in VS/portal without reproducing
- **Unique: Availability Tests** — URL ping, multi-step webtest, custom TrackAvailability
  - 25.2.1.5 16 global PoPs — test from 5 locations simultaneously
- **Unique: OpenTelemetry Distro** — Azure Monitor OpenTelemetry exporter — all signals
  - 25.2.1.6 azure-monitor-opentelemetry package — auto-instrument + Azure-specific enrichment
- **Unique: Workspace-based App Insights** — data in Log Analytics — cross-resource KQL
  - 25.2.1.7 Cross-workspace query — correlate app telemetry + infra logs
  - 25.2.1.8 Role-based data access — table-level read permissions in workspace

---

## 26.0 Azure Service Bus & Event Hubs

### 26.1 Service Bus Core
→ See Ideal §7.1 Message Queues, §7.2 Pub/Sub, §7.1.2 Message Lifecycle

#### 26.1.1 Service Bus-Unique Features
- **Unique: Message sessions (ordered groups)** — FIFO within session — actor model
  - 26.1.1.1 AcceptSessionAsync — receive next available session — exclusive lock
  - 26.1.1.2 Session state — key-value store — workflow continuation data
  - 26.1.1.3 SessionTimeout — release lock after inactivity — requeue session
- **Unique: Duplicate detection window** — dedup window 20s–7d — message ID based
  - 26.1.1.4 Store message ID hash — discard duplicate within window
- **Unique: Service Bus Explorer** — portal-based — peek/send/receive — dev/debug
- **Unique: Premium cross-entity transactions** — atomic across queues/topics
  - 26.1.1.5 Via send — receive from entity A → forward to entity B atomically
- **Unique: Auto-delete on idle** — idle queue → auto-delete — dev/test cleanup
- **Unique: Message lock renewal** — RenewMessageLockAsync — long processing
  - 26.1.1.6 Client-side renewals — until MaxLockDuration (5min) hit
- **Unique: Geo-disaster recovery (metadata only)** — namespace alias — manual failover
  - 26.1.1.7 Active-passive — metadata replicated — messages NOT replicated
  - 26.1.1.8 Geo-replication (Premium) — message replication — active-passive with data

### 26.2 Event Hubs Core
→ See Ideal §7.2 Streaming, §10.3 Stream Processing

#### 26.2.1 Event Hubs-Unique Features
- **Unique: Kafka surface** — no code change — existing Kafka apps → Event Hubs
  - 26.2.1.1 SASL/OAUTHBEARER — Entra auth — no SASL_SSL key management
  - 26.2.1.2 Kafka Connect — connectors for Cosmos, SQL, Blob — hosted on Event Hubs
- **Unique: Schema Registry** — Avro/JSON/Protobuf — schema groups — compatibility
  - 26.2.1.3 Serializer/deserializer SDK — schema ID in message header — auto-validate
- **Unique: Event Hubs Capture** — auto-write to ADLS Gen2 — Avro format — zero code
  - 26.2.1.4 Time + size window — capture when either threshold met
  - 26.2.1.5 Partition-aware path — year/month/day/hour/minute/second/partition structure
- **Unique: Event Processor Host (EPH) / Azure.Messaging.EventHubs**
  - 26.2.1.6 Checkpoint store — Azure Blob Storage — lease-based partition ownership
  - 26.2.1.7 Load balancing — dynamically distribute partitions across processors
- **Unique: Dedicated cluster** — 10–20 CUs — guaranteed throughput — no throttle
  - 26.2.1.8 1 CU = 1GB/s ingest — over-provision for burst headroom

---

## 27.0 Azure API Management (APIM)

### 27.1 APIM Core
→ See Ideal §7.4 API Gateway, §7.4.1 API Types, §7.4.2 Policies

#### 27.1.1 APIM-Unique Features
- **Unique: Self-hosted Gateway** — on-prem/edge deployment — same policy engine
  - 27.1.1.1 Docker/K8s deployment — connect to APIM cloud plane — local processing
  - 27.1.1.2 Disconnected mode — cached config — works without cloud connectivity
- **Unique: GraphQL passthrough + synthetic** — expose REST as GraphQL
  - 27.1.1.3 Synthetic GraphQL — APIM resolves fields to backend REST calls
  - 27.1.1.4 Field-level authorization — different JWT validation per GraphQL field
- **Unique: WebSocket API** — proxy WebSocket connections — policy on connect
  - 27.1.1.5 on-new-connection policy — auth + routing on WebSocket upgrade
- **Unique: AI Gateway features** — semantic caching — LLM token tracking
  - 27.1.1.6 azure-openai-token-limit — throttle by token count not request count
  - 27.1.1.7 azure-openai-semantic-caching — cache by semantic similarity — vector similarity
  - 27.1.1.8 Load balance across Azure OpenAI deployments — priority + weight
- **Unique: Developer portal** — auto-generated — try it — OAuth consent flow
  - 27.1.1.9 Custom domain + branding — publish for external developers
  - 27.1.1.10 Delegation — redirect signup/sign-in to custom portal
- **Unique: Workspaces** — isolated multi-team APIM — separate RBAC per workspace
  - 27.1.1.11 Workspace gateway — dedicated compute — no resource contention
- **Unique: Credential manager** — OAuth token for backend — manage app credentials
  - 27.1.1.12 Managed connection — APIM holds refresh token — auto-exchange for APIs
