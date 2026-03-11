# AWS Complete Study Guide - Part 7: Containers & Serverless (Phase 1 — Ideal)

## 8.0 Container & Orchestration

### 8.1 Container Runtime (ECS)
#### 8.1.1 ECS Architecture
- 8.1.1.1 Cluster — logical grouping of tasks/services — EC2 or Fargate capacity
  - 8.1.1.1.1 ECS Capacity Provider — manage EC2 Auto Scaling Group behind cluster
  - 8.1.1.1.2 Managed scaling — ECS controls ASG based on pending task count
- 8.1.1.2 Task Definition — blueprint — JSON — up to 10 containers per task
  - 8.1.1.2.1 CPU/memory units — 1024 units = 1 vCPU — hard/soft limits
  - 8.1.1.2.2 Task role — IAM role attached to running task — IMDS credential delivery
  - 8.1.1.2.3 Secrets injection — Secrets Manager / SSM Parameter Store → env vars
- 8.1.1.3 Service — desired count — rolling update — integration with ALB/NLB
  - 8.1.1.3.1 Service discovery — Cloud Map — Route 53 private DNS auto-register
  - 8.1.1.3.2 Service Connect — managed service mesh — no sidecar code change

#### 8.1.2 ECS Networking Modes
- 8.1.2.1 awsvpc — each task gets ENI — full VPC networking — security groups
  - 8.1.2.1.1 ENI trunking — trunk interface — more tasks per instance
  - 8.1.2.1.2 IPv6 with awsvpc — dual-stack ENI assignment
- 8.1.2.2 bridge — Docker bridge networking — port mappings — legacy
- 8.1.2.3 host — bind directly to EC2 host network — no port conflicts allowed

#### 8.1.3 ECS Scheduling
- 8.1.3.1 Service scheduler — AZ rebalancing — replace failed tasks
  - 8.1.3.1.1 binpacking — maximize utilization per instance
  - 8.1.3.1.2 spread — distribute evenly — AZ spread for availability
- 8.1.3.2 Task placement constraints — distinctInstance, memberOf
  - 8.1.3.2.1 Cluster query language — attribute:ecs.instance-type =~ g4*

### 8.2 Kubernetes (EKS)
#### 8.2.1 EKS Control Plane
- 8.2.1.1 Managed control plane — AWS-operated — etcd, API server, scheduler
  - 8.2.1.1.1 Multi-AZ etcd — 3-node Raft — ≥2 AZs for quorum
  - 8.2.1.1.2 EKS API endpoint — public/private — VPC endpoint option
  - 8.2.1.1.3 Kubernetes version upgrade — 14 months support — rolling updates
- 8.2.1.2 IRSA — IAM Roles for Service Accounts — OIDC provider per cluster
  - 8.2.1.2.1 ServiceAccount token mounted at /var/run/secrets/... — projected volume
  - 8.2.1.2.2 EKS Pod Identity — new mechanism — cleaner than IRSA annotations

#### 8.2.2 EKS Node Groups
- 8.2.2.1 Managed Node Groups — AWS provisions/patches EC2 — drain on update
  - 8.2.2.1.1 Bottlerocket OS — container-optimized — minimal attack surface
  - 8.2.2.1.2 Spot node groups — interruption handling — AWS Node Termination Handler
- 8.2.2.2 Karpenter — open-source node provisioner — right-size nodes per pod spec
  - 8.2.2.2.1 NodePool — defines constraints — instance families, zones, capacity type
  - 8.2.2.2.2 Consolidation — replace underutilized nodes — bin-pack to save cost
- 8.2.2.3 Fargate profiles — pod-level isolation — no node management

#### 8.2.3 EKS Networking
- 8.2.3.1 Amazon VPC CNI — pod IP from VPC CIDR — route without NAT
  - 8.2.3.1.1 IP warm pool — pre-allocated IPs on node — fast pod scheduling
  - 8.2.3.1.2 Custom networking — secondary ENI — separate CIDR for pods
- 8.2.3.2 CoreDNS — cluster DNS — 5 searches in resolv.conf — ndots:5
  - 8.2.3.2.1 DNS caching — NodeLocal DNSCache — reduce CoreDNS load
- 8.2.3.3 AWS Load Balancer Controller — create ALB/NLB from Ingress/Service

#### 8.2.4 EKS Security
- 8.2.4.1 aws-auth ConfigMap — map IAM to K8s RBAC — legacy — use EKS Access Entries
  - 8.2.4.1.1 EKS Access Entries — API-managed — no ConfigMap editing risk
- 8.2.4.2 Network policies — Calico or AWS Network Policy Controller
- 8.2.4.3 Secrets encryption — KMS envelope encryption for etcd secrets
  - 8.2.4.3.1 External Secrets Operator — sync Secrets Manager → K8s Secret

### 8.3 Container Registry (ECR)
#### 8.3.1 ECR Repository
- 8.3.1.1 Private vs. public registry — pull-through cache from public registries
  - 8.3.1.1.1 Image scanning — Basic (CVE database) vs. Enhanced (Inspector2)
  - 8.3.1.1.2 Lifecycle policy — expire untagged images after N days — cost control
- 8.3.1.2 Cross-account image sharing — resource policy on repository
  - 8.3.1.2.1 Replication rules — cross-region, cross-account automatic sync

### 8.4 Fargate (Serverless Containers)
#### 8.4.1 Fargate Architecture
- 8.4.1.1 Task isolation — dedicated microVM per task — Firecracker-based
  - 8.4.1.1.1 No shared kernel — stronger isolation than traditional containers
  - 8.4.1.1.2 Fargate CPU/memory combos — 0.25–16 vCPU, 0.5–120GB RAM
- 8.4.1.2 Ephemeral storage — 20GB default — up to 200GB expandable
  - 8.4.1.2.1 No EBS attach — use EFS for persistent shared storage
- 8.4.1.3 Fargate Spot — 70% cheaper — interruption with 2-minute warning
  - 8.4.1.3.1 Capacity provider strategy — base On-Demand + remainder Spot

---

## 9.0 Serverless Computing

### 9.1 Lambda Architecture
#### 9.1.1 Execution Environment
- 9.1.1.1 MicroVM (Firecracker) — <125ms boot — dedicated per execution context
  - 9.1.1.1.1 Execution context reuse — init code → handler invocations
  - 9.1.1.1.2 /tmp storage — 512MB to 10GB — reuse across warm invocations
- 9.1.1.2 Runtime lifecycle — Init → Invoke → Shutdown
  - 9.1.1.2.1 Init phase — runtime bootstrap + extension initialization
  - 9.1.1.2.2 INIT_REPORT log line — breakdown of init vs. restore duration

#### 9.1.2 Lambda Concurrency
- 9.1.2.1 Account concurrency limit — 1,000 per region (default) — soft quota
  - 9.1.2.1.1 Burst limit — 500–3,000 per region — +500 per minute after burst
- 9.1.2.2 Reserved concurrency — guarantee + cap — never exceeds reserved
  - 9.1.2.2.1 0 reserved concurrency — effectively disables function (for debugging)
- 9.1.2.3 Provisioned concurrency — pre-initialized environments — no cold start
  - 9.1.2.3.1 Application Auto Scaling — scheduled or target-tracking PC scaling
  - 9.1.2.3.2 Cost — $0.015/hr per provisioned concurrency unit (us-east-1)

### 9.2 Cold Start Optimization
#### 9.2.1 Cold Start Anatomy
- 9.2.1.1 Container acquisition (AWS internal) → runtime init → function init
  - 9.2.1.1.1 Container acquisition hidden — ~50ms internal AWS provisioning
  - 9.2.1.1.2 Runtime init (Java) — JVM startup — 500ms–1s cold start typical
  - 9.2.1.1.3 Runtime init (Node/Python) — 50–200ms — much faster
- 9.2.1.2 Package size impact — large deployment → longer init — keep slim

#### 9.2.2 Cold Start Mitigation
- 9.2.2.1 Provisioned Concurrency — eliminates cold start — higher cost
- 9.2.2.2 SnapStart (Java) — snapshot initialized execution environment — ~10x faster init
  - 9.2.2.2.1 CRaC hooks — beforeCheckpoint/afterRestore — reinit connections
  - 9.2.2.2.2 Snapshot encrypted with customer KMS — published per version
- 9.2.2.3 Runtime selection — favor Node/Python/Go — avoid Java without SnapStart
- 9.2.2.4 Minimize dependencies — tree-shake — reduce init time proportionally

### 9.3 Concurrency & Throttling
#### 9.3.1 Throttling Behavior
- 9.3.1.1 Synchronous throttle — 429 TooManyRequestsException — caller handles
  - 9.3.1.1.1 API GW retry — max 2 retries on throttle — exponential backoff
- 9.3.1.2 Async throttle — retry queue — up to 6 hours — then DLQ
  - 9.3.1.2.1 Retry attempts — 0, 1, or 2 — configurable per function
  - 9.3.1.2.2 Maximum event age — 60s to 6hr — discard stale events

### 9.4 Lambda Layers & Extensions
#### 9.4.1 Lambda Layers
- 9.4.1.1 Shared dependencies — reuse across functions — up to 5 layers
  - 9.4.1.1.1 Layer size limit — 250MB unzipped — across all layers + function
  - 9.4.1.1.2 Layer versioning — immutable — functions reference specific version

#### 9.4.2 Lambda Extensions
- 9.4.2.1 External extensions — separate process — Datadog/Dynatrace/SentinelOne agents
  - 9.4.2.1.1 Extension lifecycle — register → invoked → shutdown — parallel
  - 9.4.2.1.2 Telemetry API — subscribe to function/extension/platform logs

### 9.5 Serverless Application Model (SAM)
#### 9.5.1 SAM Template Resources
- 9.5.1.1 AWS::Serverless::Function — shorthand + transform → CloudFormation
  - 9.5.1.1.1 Events section — API, S3, SQS, DynamoDB, Schedule, etc.
  - 9.5.1.1.2 Globals section — shared config — runtime, timeout, environment
- 9.5.1.2 SAM CLI — sam local invoke — Docker-based — local testing
  - 9.5.1.2.1 sam local start-api — local API GW emulator
  - 9.5.1.2.2 sam sync — hot-reload code changes to cloud — no redeploy
