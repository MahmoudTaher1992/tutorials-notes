# Azure Complete Study Guide - Part 7: Containers & Serverless (Phase 1 — Ideal)

## 8.0 Container & Orchestration

### 8.1 Azure Kubernetes Service (AKS)
#### 8.1.1 AKS Control Plane
- 8.1.1.1 Managed control plane — Azure-operated — etcd, API server, scheduler
  - 8.1.1.1.1 Free control plane tier — 99.5% uptime — single replica
  - 8.1.1.1.2 Standard tier — 99.95% SLA — auto-managed with HA replicas
  - 8.1.1.1.3 Premium tier — 99.99% SLA — LTS Kubernetes — 2-year support
- 8.1.1.2 API server network — public or private cluster
  - 8.1.1.2.1 Private cluster — API server in VNet — requires DNS + connectivity
  - 8.1.1.2.2 Authorized IP ranges — restrict API access to specific CIDRs

#### 8.1.2 AKS Node Pools
- 8.1.2.1 System node pool — critical workloads — CriticalAddonsOnly taint
  - 8.1.2.1.1 Minimum 1 node — cannot be deleted — separate from user workloads
- 8.1.2.2 User node pools — application workloads — can scale to 0
  - 8.1.2.2.1 Windows node pools — WS2019/WS2022 — mix with Linux pools
- 8.1.2.3 Spot node pools — Azure Spot VMs — 60–80% cheaper — eviction handling
  - 8.1.2.3.1 kubernetes.azure.com/scalesetpriority=spot taint — tolerations required
- 8.1.2.4 Virtual nodes — ACI burst — schedule to serverless — no VM provisioning
  - 8.1.2.4.1 ACI integration — Virtual Kubelet — instant pod provisioning

#### 8.1.3 AKS Networking
- 8.1.3.1 Kubenet — simple — NAT — nodes get VNet IPs, pods get overlay IPs
  - 8.1.3.1.1 UDR for pod routing — Azure manages — limited scale (400 nodes)
- 8.1.3.2 Azure CNI — pods get VNet IPs — no overlay — direct routing
  - 8.1.3.2.1 IP exhaustion risk — pre-allocate per node — plan /16+ VNet
  - 8.1.3.2.2 Azure CNI Overlay — pod CIDRs separate from VNet — scalable
  - 8.1.3.2.3 Azure CNI Powered by Cilium — eBPF dataplane — network policy
- 8.1.3.3 Azure Load Balancer / Application Gateway Ingress Controller (AGIC)
  - 8.1.3.3.1 AGIC — K8s Ingress → App Gateway — native Azure WAF integration

#### 8.1.4 AKS Security
- 8.1.4.1 Workload Identity — OIDC + federated credential — replaces pod identity
  - 8.1.4.1.1 ServiceAccount token projected — mutating webhook injects env vars
  - 8.1.4.1.2 azure-workload-identity library — automatic token exchange
- 8.1.4.2 Microsoft Defender for Containers — runtime threat detection — K8s audit
  - 8.1.4.2.1 Image vulnerability scanning — ACR integration — CVE reporting
- 8.1.4.3 Azure Policy for AKS — Gatekeeper OPA — deny non-compliant pods
  - 8.1.4.3.1 Built-in initiatives — restrict privileged containers, require limits

#### 8.1.5 AKS Autoscaling
- 8.1.5.1 Cluster Autoscaler — add/remove nodes based on pending pods
  - 8.1.5.1.1 Scale-down delay — 10 minutes after last scale event — configurable
  - 8.1.5.1.2 Priority expander — prefer cheaper/spot nodes — custom priority classes
- 8.1.5.2 KEDA — event-driven autoscaling — HPA replacement for queue/stream
  - 8.1.5.2.1 Scalers — Service Bus, Event Hub, Blob, Prometheus, Cron — 50+ scalers
  - 8.1.5.2.2 Scale to zero — KEDA activates pods from 0 on trigger
- 8.1.5.3 Node Autoprovision (Karpenter) — right-size node pools per workload
  - 8.1.5.3.1 NodeClaim — declarative node request — SKU flexibility

### 8.2 Azure Container Apps
#### 8.2.1 Container Apps Architecture
- 8.2.1.1 Serverless containers — managed Kubernetes + Dapr + KEDA — no cluster ops
  - 8.2.1.1.1 Environment — shared network + Log Analytics — isolation boundary
  - 8.2.1.1.2 Workload profiles — Consumption (serverless) + Dedicated (VMs)
- 8.2.1.2 Ingress — internal or external — HTTP/TCP — HTTPS auto-managed
  - 8.2.1.2.1 Traffic splitting — revision weight — blue/green, canary
  - 8.2.1.2.2 Custom domains — managed TLS cert — automatic Let's Encrypt

#### 8.2.2 Container Apps Scaling
- 8.2.2.1 HTTP scalers — concurrent requests per instance
- 8.2.2.2 Event-driven scalers — KEDA-based — Service Bus, Event Hub, custom metrics
  - 8.2.2.2.1 Scale to zero — cold start — min 0 replicas — pay only on demand
- 8.2.2.3 CPU/Memory scalers — HPA-style — resource-based

#### 8.2.3 Dapr Integration
- 8.2.3.1 Dapr sidecar auto-injection — service discovery, pub/sub, state, bindings
  - 8.2.3.1.1 State stores — Redis, Cosmos DB, Azure Blob — pluggable backends
  - 8.2.3.1.2 Pub/sub components — Service Bus, Event Hub — abstract messaging

### 8.3 Azure Container Registry (ACR)
#### 8.3.1 ACR Tiers
- 8.3.1.1 Basic — dev/test — no private endpoint — limited throughput
- 8.3.1.2 Standard — production — private endpoint — 100GB storage
- 8.3.1.3 Premium — geo-replication, zone redundancy, 500GB — enterprise

#### 8.3.2 ACR Features
- 8.3.2.1 Geo-replication — push once → auto-replicate to all regions
  - 8.3.2.1.1 Regional pull — nearest replica — reduce latency + egress cost
- 8.3.2.2 Tasks — cloud-based build, test, patch — dockerfile + ACR task YAML
  - 8.3.2.2.1 Base image update trigger — auto-rebuild on base image change
  - 8.3.2.2.2 Multi-step tasks — parallel steps — build → test → push → notify
- 8.3.2.3 Content trust — Notary v2 — cosign — image signing + verification
- 8.3.2.4 Token-based auth — repo-scoped — CI/CD least privilege pull credentials

---

## 9.0 Serverless Computing

### 9.1 Azure Functions
#### 9.1.1 Hosting Plans
- 9.1.1.1 Consumption — auto-scale — pay-per-execution — cold starts
  - 9.1.1.1.1 Cold start — 1–5s — .NET isolated 300ms — avoid in SLA-critical paths
  - 9.1.1.1.2 Free grant — 1M executions + 400K GB-s/month
- 9.1.1.2 Premium (Elastic Premium) — pre-warmed instances — VNet — no cold start
  - 9.1.1.2.1 EP1/EP2/EP3 — 1/2/4 vCPU — always-ready instance count
  - 9.1.1.2.2 Max burst 200 instances — unlimited scale — VNET integration
- 9.1.1.3 Dedicated (App Service Plan) — fixed VMs — no auto-scale savings
- 9.1.1.4 Container Apps hosting — KEDA-driven — microservices colocation

#### 9.1.2 Function Triggers & Bindings
- 9.1.2.1 Triggers — HTTP, Timer, Service Bus, Event Hub, Cosmos DB, Blob, Queue, Event Grid
  - 9.1.2.1.1 HTTP trigger — route template — authorization levels (anonymous/function/admin)
  - 9.1.2.1.2 Service Bus trigger — sessions, dead lettering, message lock management
- 9.1.2.2 Output bindings — Cosmos DB, Service Bus, Blob, SignalR, Table, HTTP response
  - 9.1.2.2.1 Async output — IAsyncCollector — batch output multiple items
- 9.1.2.3 Input bindings — read data before function body — Cosmos DB document lookup

#### 9.1.3 Functions Isolation Model
- 9.1.3.1 In-process (legacy .NET 6) — shared process with host — tight coupling
- 9.1.3.2 Isolated worker process (.NET 8+) — separate process — independent versioning
  - 9.1.3.2.1 Middleware pipeline — ASP.NET Core middleware in function host
  - 9.1.3.2.2 .NET Aspire integration — orchestration for local dev

### 9.2 Durable Functions
#### 9.2.1 Durable Patterns
- 9.2.1.1 Function chaining — sequential — output of one = input of next
- 9.2.1.2 Fan-out/fan-in — parallel activities — wait all — aggregate results
  - 9.2.1.2.1 Parallel execution — Task.WhenAll — throttle with concurrency limit
- 9.2.1.3 Async HTTP polling — orchestration ID — poll status endpoint
  - 9.2.1.3.1 Built-in HTTP API — /orchestrators/{instanceId} — status polling
- 9.2.1.4 Monitor — flexible polling loop — wait until condition met
- 9.2.1.5 Human interaction — external event — approval workflow — timeout fallback
- 9.2.1.6 Aggregator (stateful entities) — actor model — single-threaded state

#### 9.2.2 Durable Storage Backend
- 9.2.2.1 Azure Storage (default) — queues + tables + blobs — history + instance table
  - 9.2.2.1.1 History table — event sourcing — replay on cold start
  - 9.2.2.1.2 Large message blob offloading — >64KB payload to blob
- 9.2.2.2 Netherite backend — Event Hubs + FASTER — 10–100x throughput
  - 9.2.2.2.1 Partitioned checkpoints — faster recovery — lower latency
- 9.2.2.3 MSSQL backend — SQL Server/Azure SQL — relational history store
