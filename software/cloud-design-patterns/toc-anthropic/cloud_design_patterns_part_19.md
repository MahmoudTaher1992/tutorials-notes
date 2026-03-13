# Cloud Design Patterns - Part 19: Phase 2 — AWS Implementations

## 12.0 Phase 2 — AWS Implementations

### 12.1 Scalability & Elasticity — AWS
- 12.1.1 Horizontal Scaling → EC2 Auto Scaling Groups (ASG) + Launch Templates
  - 12.1.1.1 **Unique: Lifecycle Hooks** — execute custom action on scale-out/scale-in before instance joins/leaves
- 12.1.2 Auto-Scaling → ASG Target Tracking + Step Scaling + Scheduled Scaling
  - 12.1.2.1 **Unique: Predictive Scaling** — ML-based forecasting on CloudWatch metrics; pre-warm capacity
- 12.1.3 Competing Consumers → SQS Standard/FIFO + Lambda Event Source Mapping
  - 12.1.3.1 **Unique: Lambda SQS Batch Window** — wait up to 5s to accumulate batch before invoking
- 12.1.4 Queue-Based Load Leveling → SQS + Lambda / ECS Consumers
  - 12.1.4.1 **Unique: SQS long polling** — WaitTimeSeconds up to 20s; reduce empty polls and cost
- 12.1.5 Rate Limiting → AWS WAF rate-based rules + API Gateway Usage Plans
  - 12.1.5.1 API GW throttle — burst limit (default 5000 RPS per account) + steady-state limit per stage

### 12.2 Resilience — AWS
- 12.2.1 Circuit Breaker → → See Ideal §3.1 (no native AWS managed circuit breaker; implement in SDK or service mesh)
  - 12.2.1.1 **Unique: AWS App Mesh** — Envoy-based; circuit breaking via DestinationRule / cluster config
- 12.2.2 Retry → AWS SDK built-in retry with exponential backoff + jitter
  - 12.2.2.1 **Unique: AWS SDK RetryMode** — legacy, standard, adaptive modes; adaptive uses token bucket
- 12.2.3 Health Endpoint → ELB health checks + Route 53 health checks
  - 12.2.3.1 **Unique: Route 53 DNS Failover** — health check drives automatic DNS failover to secondary region
- 12.2.4 Bulkhead → → See Ideal §3.3 (implement via separate ASGs, ECS capacity providers, Lambda reserved concurrency)
  - 12.2.4.1 **Unique: Lambda Reserved Concurrency** — hard cap per function; isolates blast radius

### 12.3 Data Management — AWS
- 12.3.1 CQRS → DynamoDB (write model) + Elasticsearch/OpenSearch (read model) + DynamoDB Streams
  - 12.3.1.1 **Unique: DynamoDB Streams** — ordered change log per shard; Lambda consumer for projection update
- 12.3.2 Event Sourcing → DynamoDB or EventStoreDB on EC2 + DynamoDB Streams
  - 12.3.2.1 **Unique: DynamoDB Conditional Writes** — optimistic concurrency; condition on version attribute
- 12.3.3 Sharding → DynamoDB partition key design; RDS horizontal sharding via Aurora Sharding
  - 12.3.3.1 **Unique: DynamoDB Adaptive Capacity** — auto-rebalances hot partitions; burst credit system
- 12.3.4 Cache-Aside → ElastiCache Redis / Memcached
  - 12.3.4.1 **Unique: ElastiCache Global Datastore** — cross-region Redis replication; active-passive
- 12.3.5 Saga → AWS Step Functions (orchestration saga)
  - 12.3.5.1 **Unique: Step Functions Standard vs. Express** — Standard: durable, exactly-once; Express: high-throughput, at-least-once
  - 12.3.5.2 **Unique: Compensation via Catch/Fail states** — declarative compensation path in ASL
- 12.3.6 Outbox → Transactional DynamoDB write + DynamoDB Streams → SNS/SQS relay (Lambda)
- 12.3.7 CDC → AWS DMS (Database Migration Service) + Kinesis Data Streams for real-time CDC

### 12.4 Messaging — AWS
- 12.4.1 Pub-Sub → SNS + SQS fan-out topology
  - 12.4.1.1 **Unique: SNS filter policies** — attribute-based subscription filtering; reduces per-subscriber cost
- 12.4.2 Message Broker → SQS (queuing), MSK (managed Kafka), EventBridge (event bus)
  - 12.4.2.1 **Unique: EventBridge Pipes** — point-to-point with filtering, enrichment, transformation
  - 12.4.2.2 **Unique: EventBridge Schema Registry** — auto-discover event schemas; generate SDK bindings
- 12.4.3 Event Streaming → Kinesis Data Streams + MSK (Amazon Managed Streaming for Kafka)
  - 12.4.3.1 **Unique: Kinesis Enhanced Fan-Out** — dedicated 2MB/s per consumer per shard; push-based
  - 12.4.3.2 **Unique: MSK Serverless** — auto-scales throughput; no shard/broker management

### 12.5 API & Integration — AWS
- 12.5.1 API Gateway → AWS API Gateway (REST/HTTP/WebSocket) + Lambda Authorizer
  - 12.5.1.1 **Unique: Lambda Authorizer caching** — cache auth decision for up to 3600s; reduce Lambda invocations
- 12.5.2 BFF → API Gateway + Lambda (separate API per client type)
- 12.5.3 Service Mesh → AWS App Mesh (Envoy-based) + ECS/EKS integration
  - 12.5.3.1 **Unique: App Mesh Virtual Nodes** — define logical service endpoints; traffic policy per node

### 12.6 Security — AWS
- 12.6.1 Federated Identity → AWS Cognito (OIDC/SAML IdP) + IAM Identity Center
  - 12.6.1.1 **Unique: Cognito User Pools + Identity Pools** — auth + AWS credential vending pipeline
- 12.6.2 Zero Trust → IAM Roles Anywhere + AWS Verified Access + PrivateLink
  - 12.6.2.1 **Unique: AWS Verified Access** — identity-aware app access proxy; no VPN required
- 12.6.3 Secrets Management → AWS Secrets Manager + SSM Parameter Store
  - 12.6.3.1 **Unique: Secrets Manager rotation Lambda** — built-in rotation for RDS, Redshift, DocumentDB
- 12.6.4 Valet Key → S3 Presigned URLs + CloudFront Signed URLs/Cookies

### 12.7 Observability — AWS
- 12.7.1 Distributed Tracing → AWS X-Ray + CloudWatch ServiceLens
  - 12.7.1.1 **Unique: X-Ray Insights** — anomaly detection on trace data; auto-surface root causes
- 12.7.2 Structured Logging → CloudWatch Logs + Logs Insights (query engine)
- 12.7.3 Metrics/SLOs → CloudWatch Metrics + CloudWatch Alarms + Application Signals
  - 12.7.3.1 **Unique: CloudWatch Composite Alarms** — AND/OR logic across multiple alarms; reduce noise
