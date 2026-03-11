# AWS Complete Study Guide - Part 10: Phase 2 — EC2, VPC, S3

## Phase 2: AWS-Specific Implementations

---

## 16.0 Amazon EC2

### 16.1 EC2 Core Features
→ See Ideal §1.1 VM Lifecycle, §1.2 Instance Types, §1.3 Auto Scaling

#### 16.1.1 EC2-Unique Features
- **Unique: Nitro Hypervisor** — custom silicon offloads networking/storage/security — no EC2 hypervisor overhead on metal instances
  - 16.1.1.1 NitroTPM — vTPM 2.0 — Measured Boot — Windows BitLocker support
  - 16.1.1.2 Nitro Enclaves — isolated CPU+memory region — no persistent storage — cryptographic attestation
    - 16.1.1.2.1 vsock communication only — no network — KMS integration via attestation doc
    - 16.1.1.2.2 Use case — process credit cards, keys, PII in isolated enclave
- **Unique: EC2 Instance Metadata Service (IMDS)**
  - 16.1.1.3 IMDSv2 — session-oriented — PUT/GET pattern — prevents SSRF metadata theft
    - 16.1.1.3.1 Hop limit — default 1 — containers need 2 to access IMDS
    - 16.1.1.3.2 Require IMDSv2 — disable IMDSv1 — account-level policy
  - 16.1.1.4 Instance identity document — signed with RSA — verify region/instance/AMI
- **Unique: EC2 Serial Console** — out-of-band access — bootloader access — no network required
- **Unique: EC2 Image Builder** — automate AMI builds — CIS hardened images — test + distribute

#### 16.1.2 EC2 Networking
- **Unique: Elastic Network Adapter (ENA)** — custom AWS NIC driver — 100Gbps
  - 16.1.2.1 ENA Express — SRD protocol — consistent low latency — enable per-ENI
- **Unique: Elastic Fabric Adapter (EFA)** — HPC — MPI workloads — bypass OS network stack
  - 16.1.2.1 RDMA-like — libfabric API — latency <2μs — only in same AZ placement group
- **Unique: ENI (Elastic Network Interface)** — attach/detach — persist MAC address
  - 16.1.2.2 Warm-attach — attach stopped ENI to running instance
  - 16.1.2.3 ENI trunking — trunk ENI — up to 120 branch ENIs for ECS awsvpc mode

### 16.2 EC2 Storage Integration
- **Unique: Instance Store** — NVMe ephemeral — wiped on stop/terminate — survives reboot
  - 16.2.1.1 i4i.32xlarge — 30TB NVMe — 2M IOPS — fastest block storage on AWS
- **Unique: EBS-optimized** — dedicated bandwidth — 64K IOPS throughput isolation from network

---

## 17.0 Amazon VPC

### 17.1 VPC Core Architecture
→ See Ideal §2.1 Virtual Network Architecture, §2.2 Subnetting, §2.3 Routing

#### 17.1.1 VPC-Unique Features
- **Unique: VPC Lattice** — service-to-service networking — auth + observability built-in
  - 17.1.1.1 Service network — logical grouping — cross-VPC, cross-account
  - 17.1.1.2 Auth policies — IAM-based — per-service or per-service-network
  - 17.1.1.3 Access logs — request-level — ALB-like visibility without code change
- **Unique: PrivateLink (VPC Endpoint Services)** — expose service via NLB — consumer creates interface endpoint
  - 17.1.1.4 Interface endpoint — ENI in subnet — private IP — DNS override
  - 17.1.1.5 Gateway endpoint — S3/DynamoDB — route table entry — free
  - 17.1.1.6 Gateway Load Balancer endpoint — inline appliance insertion

#### 17.1.2 VPC Flow Logs Deep Dive
- **Unique: Per-flow metadata** — src/dst/port/protocol/bytes/packets/action/logStatus
  - 17.1.2.1 TCP flags field — SYN/ACK/FIN/RST — connection lifecycle analysis
  - 17.1.2.2 Flow direction — ingress/egress — traffic pattern analysis
  - 17.1.2.3 Parquet format — columnar — 50% cheaper Athena queries vs. text

#### 17.1.3 Network Access Analyzer
- **Unique: Automated path analysis** — identify unexpected internet exposure — no agents
  - 17.1.3.1 Finding types — public internet paths, cross-account paths

---

## 18.0 Amazon S3

### 18.1 S3 Core Features
→ See Ideal §3.1 Object Storage, §3.4 Lifecycle, §3.5 Replication, §3.6 Encryption

#### 18.1.1 S3-Unique Features
- **Unique: S3 Object Lambda** — intercept GetObject/HeadObject/ListObjects — transform on-the-fly
  - 18.1.1.1 Access point ARN — transparent to callers — same S3 API
  - 18.1.1.2 Use cases — redact PII, convert format, add watermark dynamically
- **Unique: S3 Select** — SQL-like query — push filter into S3 — up to 400% faster, 80% cheaper
  - 18.1.1.3 Supports CSV, JSON, Parquet — GZIP/BZIP2 compression
  - 18.1.1.4 WHERE clause pushdown — returns subset of object — reduce transfer
- **Unique: S3 Batch Operations** — large-scale — invoke Lambda, copy, tag, ACL, Restore on millions of objects
  - 18.1.1.5 Manifest — S3 Inventory output or CSV — targeted object list
  - 18.1.1.6 Job report — success/failure per object — S3 delivered
- **Unique: S3 Event Notifications** — ObjectCreated, ObjectRemoved, Replication targets
  - 18.1.1.7 Destinations — SQS, SNS, Lambda, EventBridge
  - 18.1.1.8 EventBridge integration — rich filtering — event replay — all events

#### 18.1.2 S3 Performance Features
- **Unique: S3 Multi-Region Access Points (MRAP)** — global S3 endpoint — Route traffic to nearest region
  - 18.1.2.1 Active-active multi-region replication — automatic failover routing
  - 18.1.2.2 Replication failover — 1-click enable — removes failed region from routing
- **Unique: Mountpoint for S3** — open-source FUSE driver — mount S3 as Linux filesystem
  - 18.1.2.3 Sequential read/write optimized — not random access — for ML training data

#### 18.1.3 S3 Security Features
- **Unique: Macie** — ML-based PII discovery — S3 bucket scanning
  - 18.1.3.1 Sensitive data findings — SSN, credit card, credentials, PHI detection
  - 18.1.3.2 Bucket inventory — public buckets, unencrypted, cross-account shared
- **Unique: S3 Access Analyzer** — identify buckets shared externally
  - 18.1.3.3 Policy check — validate policy before apply — no permission misconfiguration
