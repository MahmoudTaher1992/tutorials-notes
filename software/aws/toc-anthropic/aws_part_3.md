# AWS Complete Study Guide - Part 3: Storage Systems (Phase 1 — Ideal)

## 3.0 Storage Systems

### 3.1 Object Storage
#### 3.1.1 Object Model & Namespace
- 3.1.1.1 Flat namespace — key-value — no true directory hierarchy
  - 3.1.1.1.1 Key prefix simulation — delimiter "/" for hierarchical listing
  - 3.1.1.1.2 Consistency model — strong read-after-write consistency (since 2020)
- 3.1.1.2 Object metadata — system metadata (Content-Type, ETag) + user metadata
  - 3.1.1.2.1 ETag — MD5 of single-part, partial hash for multipart uploads
  - 3.1.1.2.2 User metadata limit — 2KB per object

#### 3.1.2 Durability & Replication
- 3.1.2.1 Eleven nines durability (99.999999999%) — erasure coding across AZs
  - 3.1.2.1.1 Reed-Solomon coding — 3+N redundancy — tolerates multiple AZ failure
- 3.1.2.2 Cross-Region Replication (CRR) — async — RPO ~minutes
  - 3.1.2.2.1 Replication Time Control (RTC) — 99.99% within 15 minutes, SLA-backed
  - 3.1.2.2.2 Replication of delete markers — opt-in — prevent accidental cascade
- 3.1.2.3 Same-Region Replication (SRR) — log aggregation, compliance copies

#### 3.1.3 Storage Classes & Tiering
- 3.1.3.1 S3 Standard — 99.99% availability — 3 AZ — active data
  - 3.1.3.1.1 First byte latency — single-digit ms
- 3.1.3.2 S3 Intelligent-Tiering — auto-moves objects between tiers based on access
  - 3.1.3.2.1 Frequent → Infrequent after 30 days — no retrieval fee
  - 3.1.3.2.2 Archive Instant → Archive → Deep Archive tiers — optional
- 3.1.3.3 S3 Standard-IA — infrequent access — 99.9% availability — retrieval fee
- 3.1.3.4 S3 One Zone-IA — single AZ — 20% cheaper — non-critical replicas
- 3.1.3.5 S3 Glacier Instant Retrieval — millisecond access — archived data
- 3.1.3.6 S3 Glacier Flexible Retrieval — minutes to hours — bulk/expedited/standard
  - 3.1.3.6.1 Expedited retrieval — 1–5 minutes — Provisioned Capacity Units
- 3.1.3.7 S3 Glacier Deep Archive — 12hr restore — cheapest — regulatory retention

#### 3.1.4 Access Control
- 3.1.4.1 Bucket policies — resource-based — cross-account, public access
  - 3.1.4.1.1 Block Public Access — account-level override — 4 independent settings
- 3.1.4.2 ACLs — legacy — object-level — prefer bucket policies
- 3.1.4.3 Presigned URLs — time-limited — signed with caller's credentials
  - 3.1.4.3.1 Max expiry — IAM user: 7 days; STS role: min(36hrs, session TTL)
- 3.1.4.4 VPC Endpoint policy — restrict S3 access to specific buckets from VPC

#### 3.1.5 Performance Optimization
- 3.1.5.1 Multipart upload — >100MB recommended, >5GB required
  - 3.1.5.1.1 Part size 5MB–5GB — parallel threads — saturate network
  - 3.1.5.1.2 Abort incomplete multipart — lifecycle rule to avoid orphan charges
- 3.1.5.2 Transfer Acceleration — CloudFront edge ingestion → AWS backbone
- 3.1.5.3 Request rate — 3,500 PUT/COPY/DELETE + 5,500 GET per prefix per second
  - 3.1.5.3.1 Prefix sharding — hash prefix distribution for high-throughput

### 3.2 Block Storage (EBS)
#### 3.2.1 Volume Types
- 3.2.1.1 gp3 — general purpose SSD — 3,000 IOPS baseline, 125MB/s independent
  - 3.2.1.1.1 Tunable IOPS (up to 16,000) independent of capacity
  - 3.2.1.1.2 Tunable throughput (up to 1,000 MB/s) — separate from IOPS
- 3.2.1.2 io2 Block Express — 256,000 IOPS — 99.999% durability
  - 3.2.1.2.1 Sub-millisecond latency — NVMe-backed — Multi-Attach support
  - 3.2.1.2.2 Multi-Attach — up to 16 instances in same AZ — clustered DB
- 3.2.1.3 st1 — throughput-optimized HDD — 500MB/s — sequential big data
- 3.2.1.4 sc1 — cold HDD — 250MB/s — lowest cost — infrequent sequential

#### 3.2.2 Snapshots
- 3.2.2.1 Incremental — only changed blocks since last snapshot transferred
  - 3.2.2.1.1 Snapshot storage in S3 — managed by AWS — no bucket visible
  - 3.2.2.1.2 EBS Direct APIs — read/write snapshot blocks without restoring
- 3.2.2.2 Amazon Data Lifecycle Manager (DLM) — automated snapshot policies
  - 3.2.2.2.1 Cross-region copy — disaster recovery — automated policy
  - 3.2.2.2.2 Cross-account sharing — share encrypted snapshots via KMS key

#### 3.2.3 Encryption
- 3.2.3.1 AES-256 — encrypted at rest — envelope encryption with KMS CMK
  - 3.2.3.1.1 AWS-managed key (aws/ebs) vs. customer-managed CMK
  - 3.2.3.1.2 In-flight encryption — NVMe over TLS between host and EBS subsystem
- 3.2.3.2 Default encryption — account-level setting — encrypt all new volumes

### 3.3 File Storage
#### 3.3.1 Amazon EFS (Elastic File System)
- 3.3.1.1 NFS v4.1/4.2 — POSIX-compliant — multi-AZ shared mount
  - 3.3.1.1.1 Mount targets — one per AZ — Security Group controlled
  - 3.3.1.1.2 Access Points — enforced POSIX identity (UID/GID) per application
- 3.3.1.2 Performance modes — General Purpose vs. Max I/O (>10K EC2 clients)
  - 3.3.1.2.1 Bursting throughput — credits based on storage size
  - 3.3.1.2.2 Provisioned throughput — decouple throughput from storage size
  - 3.3.1.2.3 Elastic throughput — auto-scales to 3GiB/s read, 1GiB/s write
- 3.3.1.3 Storage classes — Standard, Standard-IA — lifecycle policy auto-tier

#### 3.3.2 Amazon FSx Family
- 3.3.2.1 FSx for Windows File Server — SMB, DFS, Active Directory integration
  - 3.3.2.1.1 Multi-AZ deployment — active/standby with automatic failover
  - 3.3.2.1.2 Shadow Copies — VSS — point-in-time self-service restore
- 3.3.2.2 FSx for Lustre — HPC — parallel filesystem — 1M+ IOPS
  - 3.3.2.2.1 S3 data repository — lazy load on access / batch export
  - 3.3.2.2.2 Scratch vs. Persistent — no replication vs. replicated 2x
- 3.3.2.3 FSx for NetApp ONTAP — NFS/SMB/iSCSI — SnapMirror replication
- 3.3.2.4 FSx for OpenZFS — ZFS snapshots — clone — NFS v3/4

### 3.4 Data Lifecycle & Tiering
#### 3.4.1 S3 Lifecycle Rules
- 3.4.1.1 Transition actions — move to cheaper class after N days
  - 3.4.1.1.1 Minimum storage duration charges — IA=30d, Glacier=90d, Deep=180d
  - 3.4.1.1.2 Object size minimum — IA/Glacier not cost-effective for <128KB objects
- 3.4.1.2 Expiration actions — delete objects/versions after N days
  - 3.4.1.2.1 Incomplete multipart cleanup — max-age 7 days best practice

### 3.5 Replication & Durability
#### 3.5.1 S3 Versioning
- 3.5.1.1 Versioning states — unversioned, versioning-enabled, versioning-suspended
  - 3.5.1.1.1 MFA delete — require MFA to delete versions or suspend versioning
  - 3.5.1.1.2 Version ID — URL-safe Base64 string — null for pre-versioning objects
- 3.5.1.2 Object Lock — WORM — Governance vs. Compliance mode
  - 3.5.1.2.1 Legal Hold — independent of retention period — disable anytime
  - 3.5.1.2.2 Compliance mode — cannot be overridden even by root

### 3.6 Encryption at Rest
#### 3.6.1 S3 Encryption Modes
- 3.6.1.1 SSE-S3 — AWS-managed AES-256 — no cost — each object unique key
- 3.6.1.2 SSE-KMS — customer-managed CMK — audit trail in CloudTrail
  - 3.6.1.2.1 S3 Bucket Keys — reduce KMS API calls 99% — per-bucket DEK
  - 3.6.1.2.2 KMS request rate limit — 10,000/s per region — Bucket Keys critical
- 3.6.1.3 SSE-C — customer-provided key — AWS performs encryption, discards key
- 3.6.1.4 CSE — client-side encryption — S3 stores ciphertext only
  - 3.6.1.4.1 AWS Encryption SDK — envelope encryption — data key wrapping
