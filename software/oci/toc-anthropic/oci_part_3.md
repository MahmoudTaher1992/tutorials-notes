# OCI Complete Study Guide - Part 3: Phase 1 — Storage

## 3.0 Storage

### 3.1 Block Volume
#### 3.1.1 Block Volume Architecture
- 3.1.1.1 Persistent block storage — iSCSI or paravirtualized attachment — AD-local
  - 3.1.1.1.1 Paravirtualized — virtio driver — lower overhead — up to 32 Gbps
  - 3.1.1.1.2 iSCSI — more control — manual multipath — legacy compatibility
- 3.1.1.2 Volume sizes — 50 GB to 32 TB — resize online — no detach needed
  - 3.1.1.2.1 Online resize — extend filesystem after OCI resize — no downtime
  - 3.1.1.2.2 Boot volume resize — increase OS disk — cloud-init growpart

#### 3.1.2 Performance Tiers
- 3.1.2.1 Lower Cost — 2 IOPS/GB — 480 KB/s per GB — archive workloads
- 3.1.2.2 Balanced — 60 IOPS/GB — 480 KB/s per GB — default — general purpose
  - 3.1.2.2.1 Burst IOPS — up to 3000 IOPS for small volumes — token bucket
- 3.1.2.3 Higher Performance — 75 IOPS/GB — 600 KB/s per GB — databases
- 3.1.2.4 Ultra-High Performance — up to 225 IOPS/GB — 2880 KB/s per GB — OLTP
  - 3.1.2.4.1 Requires multipath — multiple attachments — aggregate IOPS
  - 3.1.2.4.2 Max 300,000 IOPS per volume — NVMe-equivalent without local SSD risk

#### 3.1.3 Block Volume Backups & Replication
- 3.1.3.1 Volume backup — incremental snapshots — stored in Object Storage
  - 3.1.3.1.1 Manual vs. scheduled backup policy — Bronze/Silver/Gold policies
  - 3.1.3.1.2 Gold policy — daily + weekly + monthly + yearly — full retention schedule
- 3.1.3.2 Cross-region copy — copy backup to another region — DR
  - 3.1.3.2.1 Block Volume Replication — async continuous — RPO minutes — cross-region
  - 3.1.3.2.2 Replication state — sync lag — monitor via metrics — failover trigger

#### 3.1.4 Volume Groups
- 3.1.4.1 Volume group — multiple volumes as unit — consistent backup
  - 3.1.4.1.1 Application-consistent — quiesce DB — group snapshot — coordinated
  - 3.1.4.1.2 Group replication — replicate all volumes together — cross-AD/cross-region

### 3.2 Object Storage
#### 3.2.1 Object Storage Architecture
- 3.2.1.1 Namespace — tenancy-scoped — globally unique — root of URI
  - 3.2.1.1.1 Bucket URI — https://objectstorage.{region}.oraclecloud.com/n/{ns}/b/{bucket}
  - 3.2.1.1.2 Object name — arbitrary path separator — flat namespace — prefix simulation
- 3.2.1.2 Storage tiers
  - 3.2.1.2.1 Standard — hot — immediate access — no retrieval fee
  - 3.2.1.2.2 Infrequent Access — 31-day minimum — lower storage cost — retrieval fee
  - 3.2.1.2.3 Archive — cold — requires restore before read — restore time 1–4 hours
- 3.2.1.3 Durability — 11 nines — erasure coding — multiple fault domains

#### 3.2.2 Object Storage Features
- 3.2.2.1 Multipart upload — parallel — up to 10,000 parts — resume on failure
  - 3.2.2.1.1 Part size — 10 MB to 50 GB — parallel upload threads — throughput
  - 3.2.2.1.2 Uncommitted parts — abort or auto-expire via lifecycle — cost control
- 3.2.2.2 Pre-Authenticated Requests (PAR) — time-limited URL — no credentials
  - 3.2.2.2.1 Object PAR — read/write — specific object — expiry date
  - 3.2.2.2.2 Bucket PAR — list + read/write — with/without prefix — bulk share
- 3.2.2.3 Object versioning — retain previous versions — delete marker support
  - 3.2.2.3.1 Version ID — immutable — restore by specifying version ID
  - 3.2.2.3.2 Lifecycle rule — expire non-current versions — cost management
- 3.2.2.4 Object lifecycle management — transition tier + expiry rules — automated
  - 3.2.2.4.1 Age-based — after N days transition — Standard → Infrequent → Archive
  - 3.2.2.4.2 Prefix-based — apply rules to prefix — separate policies per data set
- 3.2.2.5 Replication — cross-region — async — passive bucket — read-after-write
  - 3.2.2.5.1 Replication policy — source bucket → destination bucket — includes deletes
  - 3.2.2.5.2 Not retroactive — replicate objects created after policy creation
- 3.2.2.6 Events integration — object create/delete/update → OCI Events → trigger function
  - 3.2.2.6.1 Event filter — object name prefix — target specific paths

#### 3.2.3 Object Storage Security
- 3.2.3.1 Bucket visibility — Public vs. Private — public enables anonymous read
  - 3.2.3.1.1 Public bucket — allow unauthenticated GET — static website hosting
- 3.2.3.2 Encryption — SSE by default — Oracle-managed or customer-managed key
  - 3.2.3.2.1 CMEK — Vault master encryption key — per-bucket assignment
  - 3.2.3.2.2 Client-side encryption — encrypt before upload — OCI unaware of key
- 3.2.3.3 IAM policies — ObjectRead / ObjectWrite / ObjectDelete / manage — compartment scoped
  - 3.2.3.3.1 Condition — target.bucket.name — restrict policy to specific bucket

### 3.3 File Storage (NFS)
#### 3.3.1 File Storage Architecture
- 3.3.1.1 Managed NFS — NFSv3 — AD-scoped — scales to 8 exabytes per file system
  - 3.3.1.1.1 Mount target — NFS endpoint — in subnet — security list must allow 2048-2050
  - 3.3.1.1.2 Export — path on mount target — access control per export
- 3.3.1.2 Snapshots — immutable — taken instantly — .snapshot directory
  - 3.3.1.2.1 Clone from snapshot — create new file system — instant — no copy
  - 3.3.1.2.2 Snapshot policy — scheduled — hourly/daily/weekly/monthly retention
- 3.3.1.3 Replication — async — cross-AD or cross-region — RPO minutes
  - 3.3.1.3.1 Replication target — read-only — activate for failover — breaks replication

### 3.4 Archive Storage
#### 3.4.1 Archive Tier Details
- 3.4.1.1 Archive objects — require explicit restore — RESTORE API call
  - 3.4.1.1.1 Restore time — 1–4 hours — object available for 24 hours after restore
  - 3.4.1.1.2 Auto-expire after restore period — re-archive — no manual action needed
- 3.4.1.2 Cost model — lowest per GB — higher retrieval + restore fee
  - 3.4.1.2.1 Minimum storage duration — 90 days — delete before = still charged
