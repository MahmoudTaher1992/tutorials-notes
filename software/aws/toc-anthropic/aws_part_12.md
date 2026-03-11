# AWS Complete Study Guide - Part 12: Phase 2 — IAM, Lambda, ECS/EKS

## 22.0 AWS IAM

### 22.1 IAM Core
→ See Ideal §5.1 Identity & Access Management, §5.1.2 Policy Types, §5.1.3 Evaluation Logic

#### 22.1.1 IAM-Unique Features
- **Unique: IAM Identity Center (SSO)** — centralized workforce access — multi-account
  - 22.1.1.1 Permission sets — deployed as roles in member accounts — auto-sync
  - 22.1.1.2 Attribute-based access control (ABAC) — pass tags from IdP → permission set
  - 22.1.1.3 Trusted identity propagation — pass user identity to downstream services (S3, Redshift)
- **Unique: IAM Access Analyzer**
  - 22.1.1.4 External access findings — S3, IAM roles, KMS keys, Lambda, SQS — resource shared outside zone of trust
  - 22.1.1.5 Unused access findings — over-provisioned users/roles — last-used analysis
  - 22.1.1.6 Policy validation — 100+ security checks — before apply
  - 22.1.1.7 Policy generation — CloudTrail-based — generate least-privilege policy from actual usage
- **Unique: Service Control Policies (SCPs)**
  - 22.1.1.8 Prevent disabling CloudTrail — mandatory audit control
  - 22.1.1.9 Restrict to approved regions — deny all outside eu-west-1, us-east-1
  - 22.1.1.10 Require MFA for sensitive actions — Condition: MultiFactorAuthPresent
- **Unique: IAM Conditions**
  - 22.1.1.11 aws:RequestedRegion — restrict API calls to specific regions
  - 22.1.1.12 aws:PrincipalTag — ABAC — attribute on calling principal
  - 22.1.1.13 aws:SourceVpc / aws:SourceVpce — restrict to specific VPC
  - 22.1.1.14 s3:prefix, s3:delimiter — restrict S3 key namespace per user/team
- **Unique: Roles Anywhere** — X.509 certificates — on-prem workloads get AWS credentials
  - 22.1.1.15 Trust anchor — CA certificate — creates IAM role session via certificate auth

---

## 23.0 AWS Lambda

### 23.1 Lambda Core
→ See Ideal §9.1 Lambda Architecture, §9.2 Cold Start, §9.3 Concurrency

#### 23.1.1 Lambda-Unique Features
- **Unique: Function URLs** — HTTPS endpoint directly on Lambda — no API GW needed
  - 23.1.1.1 Auth types — NONE (public) or AWS_IAM — no usage plan/throttle from GW
  - 23.1.1.2 CORS configuration — streaming responses supported
- **Unique: Response Streaming** — stream_response decorator — first-byte faster
  - 23.1.1.3 invoke_with_response_stream API — chunked transfer encoding
  - 23.1.1.4 Max 20MB streamed — vs. 6MB sync limit
- **Unique: Lambda SnapStart (Java)**
  - 23.1.1.5 Tiered compilation — snapshot after Corretto JVM warmup
  - 23.1.1.6 Uniqueness hooks — random seed, unique ID reinit on restore
- **Unique: Lambda Power Tuning** — open-source — AWS Step Functions — find optimal memory
  - 23.1.1.7 Cost/performance trade-off curve — invocation cost vs. duration
- **Unique: Event Source Mappings**
  - 23.1.1.8 SQS — batch size 1–10,000 — batch window 0–300s
  - 23.1.1.9 DynamoDB Streams — starting position: TRIM_HORIZON/LATEST/AT_TIMESTAMP
  - 23.1.1.10 Kinesis — parallelization factor 1–10 — concurrent shards per function
  - 23.1.1.11 MSK/Kafka — consumer group — topic/partition assignment
- **Unique: Lambda Destinations** — async invocations only — success + failure routing
  - 23.1.1.12 Destinations — SQS, SNS, Lambda, EventBridge — full event envelope
  - 23.1.1.13 vs. DLQ — DLQ only on failure, destinations for both + richer payload
- **Unique: Container Image Deployment** — up to 10GB — OCI-compliant
  - 23.1.1.14 Lambda-optimized base images — pre-loaded runtime — faster cold start
  - 23.1.1.15 ECR cache — container layer caching — incremental pulls

#### 23.1.2 Lambda Networking Deep Dive
- **Unique: VPC Lambda** — Hyperplane ENI — shared across functions in same VPC config
  - 23.1.2.1 No longer per-function ENI — Hyperplane = massive scale improvement
  - 23.1.2.2 Internet access from VPC Lambda — requires NAT Gateway in public subnet
- **Unique: Lambda IPs** — VPC subnets assigned — no static IP without NAT/Elastic IP

---

## 24.0 Amazon ECS & EKS

### 24.1 ECS Core
→ See Ideal §8.1 Container Runtime, §8.1.2 Networking, §8.1.3 Scheduling, §8.4 Fargate

#### 24.1.1 ECS-Unique Features
- **Unique: Service Connect** — CloudMap + Envoy sidecar auto-injected — zero code change
  - 24.1.1.1 Client-side discovery — no DNS — service mesh lite
  - 24.1.1.2 CloudWatch metrics per client-server pair — request count, latency
- **Unique: ECS Exec** — SSM Session Manager — exec into running container
  - 24.1.1.3 IAM permission — ssmmessages:CreateControlChannel — audit in CloudTrail
- **Unique: ECS Service Auto Scaling**
  - 24.1.1.4 Target tracking — ALBRequestCountPerTarget — scale per LB request
  - 24.1.1.5 Step scaling — custom CloudWatch metrics — SQS queue depth
  - 24.1.1.6 Scheduled — cron-based — pre-scale for events
- **Unique: Capacity Providers**
  - 24.1.1.7 ASG Capacity Provider — managed scaling — target 100% cluster utilization
  - 24.1.1.8 Base + weight — guarantee On-Demand, burst to Spot
- **Unique: Task protection** — prevent scale-in during critical processing
  - 24.1.1.9 UpdateTaskProtection API — 2hr window default — extend as needed

### 24.2 EKS Core
→ See Ideal §8.2 Kubernetes, §8.2.1 Control Plane, §8.2.2 Node Groups, §8.2.3 Networking

#### 24.2.1 EKS-Unique Features
- **Unique: EKS Anywhere** — EKS on-premises — vSphere/bare metal — AWS Console visibility
  - 24.2.1.1 Curated packages — cert-manager, Harbor, MetalLB — EKS Marketplace
- **Unique: EKS Hybrid Nodes** — on-prem servers join EKS cloud cluster
  - 24.2.1.2 SSM-based registration — Node Agent — secure channel
- **Unique: EKS Auto Mode** — fully managed nodes — Karpenter + EBS CSI built-in
  - 24.2.1.3 NodePool auto-provisioning — zero node management — OS patches automated
  - 24.2.1.4 Consolidation enabled by default — bin-pack to minimize cost
- **Unique: Amazon VPC CNI Advanced Features**
  - 24.2.1.5 Security groups for pods — assign SG directly to pod — ENI branch
  - 24.2.1.6 VPC resource controller — manage branch ENI lifecycle
  - 24.2.1.7 IPAMD daemon — warm pool — pre-allocate IPs for fast pod scheduling
- **Unique: Bottlerocket** — container-optimized OS — immutable root FS — admin container
  - 24.2.1.8 API-driven updates — no SSH — SSM Session Manager for access
  - 24.2.1.9 dm-verity — kernel-signed root filesystem — supply chain attack mitigation
- **Unique: EKS Blueprints** — CDK/Terraform patterns — opinionated EKS clusters
  - 24.2.1.10 Add-ons — ADOT, Karpenter, ArgoCD, AWS LB Controller — curated
