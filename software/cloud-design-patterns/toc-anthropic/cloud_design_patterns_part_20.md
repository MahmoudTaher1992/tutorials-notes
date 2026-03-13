# Cloud Design Patterns - Part 20: Phase 2 — Azure Implementations

## 13.0 Phase 2 — Azure Implementations

### 13.1 Scalability & Elasticity — Azure
- 13.1.1 Horizontal Scaling → VMSS (Virtual Machine Scale Sets) + Azure Autoscale
  - 13.1.1.1 **Unique: VMSS Flexible Orchestration** — mix instance types; AZ spread; manual + auto scaling
- 13.1.2 Auto-Scaling → VMSS auto-scale + AKS Cluster Autoscaler + KEDA
  - 13.1.2.1 **Unique: Azure Container Apps** — KEDA-native; scale to zero; Dapr integration built-in
- 13.1.3 Competing Consumers → Azure Service Bus Queues + Azure Functions trigger
  - 13.1.3.1 **Unique: Service Bus Message Sessions** — FIFO per session key; competing consumers within session group
- 13.1.4 Queue-Based Load Leveling → Azure Storage Queues + Azure Service Bus + Azure Functions
  - 13.1.4.1 **Unique: Service Bus Dead Letter Queue** — separate DLQ entity; built-in max delivery count

### 13.2 Resilience — Azure
- 13.2.1 Circuit Breaker → → See Ideal §3.1
  - 13.2.1.1 **Unique: Polly library** — .NET standard; circuit breaker, retry, bulkhead, fallback policies
  - 13.2.1.2 **Unique: Azure API Management policy** — backend circuit breaker via retry + circuit-breaker policy
- 13.2.2 Retry → Polly + Azure SDK built-in retry policies
  - 13.2.2.1 **Unique: Azure Cosmos DB SDK retry** — built-in; handles 429 throttle with jitter automatically
- 13.2.3 Health Endpoint → Azure Load Balancer health probes + Application Gateway health
  - 13.2.3.1 **Unique: Azure Monitor Resource Health** — tracks Azure platform-level health events
- 13.2.4 Bulkhead → → See Ideal §3.3
  - 13.2.4.1 **Unique: Azure Functions host.json concurrency** — maxConcurrentCalls per function trigger type

### 13.3 Data Management — Azure
- 13.3.1 CQRS → Cosmos DB (write) + Azure Cognitive Search / Cosmos DB reads (read model)
  - 13.3.1.1 **Unique: Cosmos DB Change Feed** — ordered, append-only; drives read model projection updates
- 13.3.2 Event Sourcing → Cosmos DB Change Feed + Azure Event Hubs Capture
  - 13.3.2.1 **Unique: Cosmos DB Optimistic Concurrency (ETag)** — conditional writes via If-Match header
- 13.3.3 Sharding → Cosmos DB partitioning (logical + physical partitions)
  - 13.3.3.1 **Unique: Cosmos DB Hierarchical Partitioning** — up to 3-level partition key; sub-partition hotspot mitigation
- 13.3.4 Cache-Aside → Azure Cache for Redis (Premium tier with geo-replication)
  - 13.3.4.1 **Unique: Redis geo-replication (Premium)** — passive geo-replication across regions; read from nearest
- 13.3.5 Saga → Azure Durable Functions (orchestration-based)
  - 13.3.5.1 **Unique: Durable Functions Orchestrator** — replays from event history; deterministic execution
  - 13.3.5.2 **Unique: External Events** — pause orchestration waiting for human approval or external signal
- 13.3.6 CDC → Azure Data Factory CDC + Event Hubs Kafka surface

### 13.4 Messaging — Azure
- 13.4.1 Pub-Sub → Azure Service Bus Topics + Subscriptions + Event Grid
  - 13.4.1.1 **Unique: Event Grid Event Subscriptions** — 24-hour retry with exponential backoff; dead-letter to blob
- 13.4.2 Message Broker → Azure Service Bus (enterprise); Azure Storage Queue (simple)
  - 13.4.2.1 **Unique: Service Bus Premium** — dedicated capacity; 100MB messages; VNET integration
  - 13.4.2.2 **Unique: Service Bus Duplicate Detection** — automatic deduplication window (up to 7 days)
- 13.4.3 Event Streaming → Azure Event Hubs (Kafka-compatible API)
  - 13.4.3.1 **Unique: Event Hubs Capture** — auto-archive to Azure Blob/ADLS in Avro format
  - 13.4.3.2 **Unique: Event Hubs Kafka surface** — drop-in Kafka client compatibility; no client code changes

### 13.5 API & Integration — Azure
- 13.5.1 API Gateway → Azure API Management (APIM)
  - 13.5.1.1 **Unique: APIM Policy Expressions** — C# expressions in XML policies; powerful transformation
  - 13.5.1.2 **Unique: APIM Self-Hosted Gateway** — deploy APIM gateway on-premises or multi-cloud
- 13.5.2 Service Mesh → Azure Service Mesh (based on Istio) + Open Service Mesh
  - 13.5.2.1 **Unique: Istio-based AKS add-on** — managed Istio; integrated with Azure AD for mesh auth
- 13.5.3 Strangler Fig → Azure Front Door + APIM as routing facade for legacy migration

### 13.6 Security — Azure
- 13.6.1 Federated Identity → Azure Active Directory (Entra ID) + B2C for external identities
  - 13.6.1.1 **Unique: Azure AD Conditional Access** — policy-based access: MFA, device compliance, location
- 13.6.2 Zero Trust → Microsoft Entra Private Access + Defender for Cloud + Sentinel
  - 13.6.2.1 **Unique: Azure Defender for Containers** — runtime threat detection; Kubernetes audit log analysis
- 13.6.3 Secrets Management → Azure Key Vault + Managed Identity (zero credential access)
  - 13.6.3.1 **Unique: Key Vault Managed HSM** — FIPS 140-2 Level 3 hardware key storage
- 13.6.4 Valet Key → Azure SAS (Shared Access Signature) + Azure CDN Signed URLs

### 13.7 Observability — Azure
- 13.7.1 Distributed Tracing → Azure Application Insights (based on OpenTelemetry)
  - 13.7.1.1 **Unique: Application Map** — auto-generated service dependency map from trace data
- 13.7.2 Structured Logging → Azure Monitor Logs (Log Analytics Workspace) + KQL queries
  - 13.7.2.1 **Unique: KQL (Kusto Query Language)** — columnar analytics; powerful for log correlation
- 13.7.3 Metrics/SLOs → Azure Monitor Metrics + Alerts + Workbooks + SLO dashboard
  - 13.7.3.1 **Unique: Azure Monitor Workbooks** — interactive visual dashboards with parameterized queries
