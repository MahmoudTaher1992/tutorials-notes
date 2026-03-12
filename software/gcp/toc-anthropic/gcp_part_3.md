# GCP Complete Study Guide - Part 3: Storage Systems (Phase 1 — Ideal)

## 3.0 Storage Systems

### 3.1 Cloud Storage (GCS)
#### 3.1.1 Buckets & Object Model
- 3.1.1.1 Global namespace — bucket name globally unique — flat key-value
  - 3.1.1.1.1 Bucket location — region / dual-region / multi-region
  - 3.1.1.1.2 Strong consistency — read-after-write — all object operations
- 3.1.1.2 Object metadata — content-type, cache-control, custom metadata
  - 3.1.1.2.1 Object holds — event-based vs. temporary — WORM-like
  - 3.1.1.2.2 Object versioning — noncurrent versions — lifecycle rules on versions

#### 3.1.2 Storage Classes
- 3.1.2.1 Standard — hot — no minimum storage duration — no retrieval fee
- 3.1.2.2 Nearline — infrequent — 30-day minimum — $0.01/GB retrieval
- 3.1.2.3 Coldline — cold — 90-day minimum — $0.02/GB retrieval
- 3.1.2.4 Archive — deepest archive — 365-day minimum — $0.05/GB retrieval
  - 3.1.2.4.1 No direct read — restore first — millisecond retrieval (no warm-up)
  - 3.1.2.4.2 Best for: regulatory data, disaster recovery backups
- 3.1.2.5 Autoclass — auto-transition per object based on last access — per-object granularity
  - 3.1.2.5.1 Terminal class — Standard or Nearline — cap class ceiling

#### 3.1.3 Access Control
- 3.1.3.1 Uniform bucket-level access (IAM) — disable per-object ACLs — recommended
  - 3.1.3.1.1 roles/storage.objectViewer/objectCreator/objectAdmin
  - 3.1.3.1.2 Conditions — request.path, resource.name — attribute-based access
- 3.1.3.2 Fine-grained ACLs — per-object ACL entries — legacy — avoid new projects
- 3.1.3.3 Signed URLs — HMAC or RSA — time-limited — V4 signing required
  - 3.1.3.3.1 V4 signing — max 7-day expiry — header-based or query-string
- 3.1.3.4 Public access prevention — block public access at org or bucket level
  - 3.1.3.4.1 Org policy constraint — storage.publicAccessPrevention — enforced

#### 3.1.4 GCS Performance
- 3.1.4.1 Parallel composite uploads — split into 32 chunks — gcloud storage cp
  - 3.1.4.1.1 Parts: minObjectSize / 32 — reassembled server-side — MD5 mismatch risk
- 3.1.4.2 Request rate — no pre-warming — auto-scale — millions of ops/sec
  - 3.1.4.2.1 Hotspot — sequential key names — shard prefix for high-throughput
- 3.1.4.3 Turbo replication — dual-region — 99% of data within 15 minutes RPO
  - 3.1.4.3.1 RPO SLA — Recovery Point Objective — 15-minute guarantee

#### 3.1.5 GCS Features
- 3.1.5.1 Object Lifecycle Management — delete/transition by age/version/condition
  - 3.1.5.1.1 Conditions — age, createdBefore, isLive, numberOfNewerVersions, matchesPrefix
- 3.1.5.2 Retention policies — bucket-level WORM — minimum retention period
  - 3.1.5.2.1 Locked retention policy — immutable — cannot shorten even by owner
- 3.1.5.3 Notifications — Pub/Sub — object finalize/delete/metadata update events
- 3.1.5.4 GCS FUSE — mount bucket as filesystem — AI/ML data access from VMs

### 3.2 Persistent Disk & Hyperdisk
#### 3.2.1 Persistent Disk Types
- 3.2.1.1 pd-standard — HDD — sequential throughput — backup, batch
- 3.2.1.2 pd-balanced — SSD — balanced IOPS/throughput — general workloads
- 3.2.1.3 pd-ssd — SSD — high IOPS — databases, transactional
  - 3.2.1.3.1 IOPS proportional to disk size — 30 IOPS per GB (read), 30 (write)
- 3.2.1.4 pd-extreme — highest IOPS — 120K IOPS — user-configurable
  - 3.2.1.4.1 Provisioned IOPS independent of size — flexible provisioning

#### 3.2.2 Hyperdisk (Next-Gen Persistent Disk)
- 3.2.2.1 Hyperdisk Balanced — default for new workloads — independent IOPS/throughput
  - 3.2.2.1.1 Resize IOPS/throughput without downtime — live adjustment
  - 3.2.2.1.2 Up to 160K IOPS, 2.4 GB/s per disk
- 3.2.2.2 Hyperdisk Extreme — 350K IOPS — SAP HANA, Oracle — highest performance
- 3.2.2.3 Hyperdisk Throughput — high throughput — Hadoop, analytics — cheap
- 3.2.2.4 Hyperdisk ML — read-only multi-writer — 1200 VMs concurrently — ML model serving
  - 3.2.2.4.1 Checkpoint loading — shared model weights — zero data copy per VM

#### 3.2.3 Local SSD
- 3.2.3.1 NVMe or SCSI — physically attached — 375GB per partition
  - 3.2.3.1.1 Up to 24 partitions per VM — 9TB total local NVMe
  - 3.2.3.1.2 Ephemeral — data lost on VM stop/delete — survive reboot only
- 3.2.3.2 IOPS — 680K read / 360K write IOPS — sub-100μs latency
  - 3.2.3.2.1 RAID-0 — stripe across partitions — 2.4M IOPS aggregate

#### 3.2.4 Snapshots
- 3.2.4.1 Incremental — changed blocks — global deduplicated in Cloud Storage
  - 3.2.4.1.1 Instant snapshots — faster creation — regional — for rapid recovery
  - 3.2.4.1.2 Snapshot schedule policy — hourly/daily/weekly — retention count
- 3.2.4.2 Cross-region copy — disaster recovery — explicit copy operation

### 3.3 Filestore
#### 3.3.1 Filestore Tiers
- 3.3.1.1 Basic HDD/SSD — single zone — NFS v3 — 1TB–63.9TB
- 3.3.1.2 Zonal — high performance SSD — NFS v3 — 1–10TB
- 3.3.1.3 Enterprise — multi-zone HA — NFS v3 — 1–10TB — 99.99% SLA
  - 3.3.1.3.1 Regional replication — data replicated across 2 zones
- 3.3.1.4 High Scale — NFS v3/v4.1 — 10TB–100TB — HPC workloads

### 3.5 Replication & Durability
#### 3.5.1 GCS Replication Options
- 3.5.1.1 Regional — single region — 3+ data centers — 99.999999999% durability
- 3.5.1.2 Dual-region — 2 specific regions — geo-redundancy — Turbo replication
  - 3.5.1.2.1 ASIA1, EUR4, NAM4 — predefined pairs — or custom dual-region
- 3.5.1.3 Multi-region — US/EU/ASIA — widest geo — highest availability
  - 3.5.1.3.1 Data stored in at least 2 regions within multi-region geography

### 3.6 Encryption at Rest
#### 3.6.1 GCS Encryption
- 3.6.1.1 Google-managed encryption — AES-256 — default — no configuration
- 3.6.1.2 Customer-managed keys (CMEK) — Cloud KMS — per-bucket or per-object
  - 3.6.1.2.1 Key rotation — new encryption key version — old data re-encrypted lazily
  - 3.6.1.2.2 Key revocation — access denied immediately — all encrypted objects
- 3.6.1.3 Customer-supplied keys (CSEK) — AES-256 — per-request — Google discards
  - 3.6.1.3.1 Key hash stored — verify key on subsequent requests
