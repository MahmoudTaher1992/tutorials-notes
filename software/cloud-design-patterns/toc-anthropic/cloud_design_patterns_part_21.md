# Cloud Design Patterns - Part 21: Phase 2 — GCP Implementations

## 14.0 Phase 2 — GCP Implementations

### 14.1 Scalability & Elasticity — GCP
- 14.1.1 Horizontal Scaling → Managed Instance Groups (MIG) + Autoscaler
  - 14.1.1.1 **Unique: GCP Autoscaler Cool-Down Period** — stabilization window before scale decisions
- 14.1.2 Auto-Scaling → MIG Autoscaler + GKE Cluster Autoscaler + Multidimensional Autoscaling
  - 14.1.2.1 **Unique: GKE Autopilot** — fully managed; GCP right-sizes nodes automatically; pay per pod
  - 14.1.2.2 **Unique: Cloud Run** — fully managed serverless containers; scale to zero; request-per-container model
- 14.1.3 Competing Consumers → Cloud Pub/Sub + Cloud Functions / Cloud Run consumers
  - 14.1.3.1 **Unique: Pub/Sub Exactly-Once Delivery** — deduplication window; enable per subscription
- 14.1.4 Queue-Based Load Leveling → Cloud Tasks + Pub/Sub
  - 14.1.4.1 **Unique: Cloud Tasks Rate Limits** — max dispatches/sec + max concurrent; built-in throttle

### 14.2 Resilience — GCP
- 14.2.1 Circuit Breaker → → See Ideal §3.1
  - 14.2.1.1 **Unique: Cloud Endpoints Extensible Service Proxy (ESP)** — Envoy-based; circuit breaking support
- 14.2.2 Retry → GCP SDK automatic retry + Cloud Tasks built-in retry scheduling
  - 14.2.2.1 **Unique: Cloud Tasks retry configuration** — max attempts, max retry duration, min/max backoff per queue
- 14.2.3 Health Endpoint → GCE Health Checks + GKE Readiness/Liveness probes
  - 14.2.3.1 **Unique: Traffic Director health checking** — xDS-based; service mesh health integration
- 14.2.4 Bulkhead → → See Ideal §3.3
  - 14.2.4.1 **Unique: Cloud Run concurrency per instance** — max concurrent requests per container instance (1-1000)

### 14.3 Data Management — GCP
- 14.3.1 CQRS → Firestore (write model) + BigQuery (read/analytics model) + Pub/Sub sync
  - 14.3.1.1 **Unique: Firestore real-time listeners** — push updates to clients on document change; live read model
- 14.3.2 Event Sourcing → Firestore + Datastore + Cloud Spanner (transactional event store)
  - 14.3.2.1 **Unique: Spanner External Consistency** — global linearizable reads; true time API
- 14.3.3 Sharding → Cloud Spanner (auto-split on hot keys) + Bigtable (tablet-based sharding)
  - 14.3.3.1 **Unique: Spanner Auto-Split** — detects hot key ranges; automatically splits tablets
  - 14.3.3.2 **Unique: Bigtable Tablet Rebalancing** — Tablet Server reassignment; transparent to client
- 14.3.4 Cache-Aside → Memorystore for Redis / Memcached (managed Cloud Memorystore)
  - 14.3.4.1 **Unique: Memorystore for Redis Cluster** — Cluster-mode; up to 300GB per instance
- 14.3.5 Saga → Cloud Workflows (orchestration-based saga)
  - 14.3.5.1 **Unique: Cloud Workflows built-in retry** — per-step retry + catch; declarative YAML/JSON definition
  - 14.3.5.2 **Unique: Cloud Workflows callbacks** — pause workflow waiting for HTTP callback from external service
- 14.3.6 CDC → Datastream (CDC service) — PostgreSQL/MySQL/Oracle WAL → BigQuery/GCS

### 14.4 Messaging — GCP
- 14.4.1 Pub-Sub → Google Cloud Pub/Sub (global, managed)
  - 14.4.1.1 **Unique: Pub/Sub Snapshot** — point-in-time snapshot of subscription; enable replay
  - 14.4.1.2 **Unique: Pub/Sub BigQuery Subscription** — write messages directly to BigQuery table
- 14.4.2 Message Broker → Cloud Pub/Sub + Cloud Tasks (task queuing)
  - 14.4.2.1 **Unique: Cloud Tasks OIDC token auth** — authenticate task delivery to Cloud Run/Cloud Functions
- 14.4.3 Event Streaming → Pub/Sub + Dataflow (Apache Beam streaming)
  - 14.4.3.1 **Unique: Dataflow Streaming Engine** — managed autoscaling streaming runner; shuffle off-VM
  - 14.4.3.2 **Unique: Pub/Sub Lite** — lower cost; zonal storage; user-managed partitions (Kafka-like)

### 14.5 API & Integration — GCP
- 14.5.1 API Gateway → Cloud Endpoints (ESP) + Apigee (enterprise API management)
  - 14.5.1.1 **Unique: Apigee Analytics** — API traffic analytics; monetization; developer portal
  - 14.5.1.2 **Unique: Apigee X** — runs in Google-managed VMs; peering to customer VPC
- 14.5.2 Service Mesh → Traffic Director (xDS control plane) + Anthos Service Mesh (Istio-based)
  - 14.5.2.1 **Unique: Traffic Director** — GCP-managed xDS control plane; no Istio overhead
  - 14.5.2.2 **Unique: Anthos Service Mesh** — Istio with GCP-managed control plane; multi-cluster
- 14.5.3 Strangler Fig → Cloud Load Balancing URL map + Traffic Director for gradual migration

### 14.6 Security — GCP
- 14.6.1 Federated Identity → Google Identity Platform + Firebase Auth + Workload Identity Federation
  - 14.6.1.1 **Unique: Workload Identity Federation** — external OIDC/SAML identities mapped to GCP IAM; no service account keys
- 14.6.2 Zero Trust → BeyondCorp Enterprise (context-aware access) + VPC Service Controls
  - 14.6.2.1 **Unique: VPC Service Controls** — perimeter around GCP services; block data exfiltration
  - 14.6.2.2 **Unique: Access Context Manager** — define access levels (device trust, IP, geo); enforce in IAM
- 14.6.3 Secrets Management → Secret Manager + Workload Identity (zero credential access)
  - 14.6.3.1 **Unique: Secret Manager regional replication** — pin secrets to specific region for data residency
- 14.6.4 Valet Key → GCS Signed URLs + IAM Conditions for fine-grained expiry

### 14.7 Observability — GCP
- 14.7.1 Distributed Tracing → Cloud Trace (OpenTelemetry compatible) + Cloud Profiler
  - 14.7.1.1 **Unique: Cloud Profiler** — continuous production profiling; flame graphs; CPU/heap/wall-time
- 14.7.2 Structured Logging → Cloud Logging (log-based metrics + sink to BigQuery/GCS)
  - 14.7.2.1 **Unique: Log-Based Metrics** — create custom Cloud Monitoring metrics from log patterns
- 14.7.3 Metrics/SLOs → Cloud Monitoring + Service Monitoring (native SLO management)
  - 14.7.3.1 **Unique: GCP Service Monitoring SLOs** — define SLOs on GCP services; error budget burn alerts
  - 14.7.3.2 **Unique: Cloud Monitoring Uptime Checks** — global synthetic monitoring from 6 regions
