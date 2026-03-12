# OCI Complete Study Guide - Part 11: Phase 2 — Storage & Databases

## 12.0 OCI Storage

### 12.1 OCI Storage Core
→ See Ideal §3.1 Block Volume, §3.2 Object Storage, §3.3 File Storage, §3.4 Archive

#### 12.1.1 Block Volume-Unique Features
- **Unique: Ultra-High Performance tier** — up to 225 IOPS/GB — 300,000 IOPS max per volume
  - 12.1.1.1 Multipath required — multiple iSCSI paths — aggregate throughput
  - 12.1.1.2 No local SSD risk — block volume UHP — durable — replicated within AD
- **Unique: Volume group backups** — application-consistent — multiple volumes as one unit
  - 12.1.1.3 Quiesce + snapshot group — Oracle DB + ASM awareness — coordinated
  - 12.1.1.4 Cross-region group copy — DR — all volumes in group replicate together
- **Unique: Block Volume Replication** — async continuous — cross-AD or cross-region
  - 12.1.1.5 Automated without manual snapshots — RPO minutes — activate for failover
- **Unique: Online volume performance change** — change tier live — no detach
  - 12.1.1.6 Balanced → Higher Performance → Ultra-High Performance — no restart
- **Unique: Boot volume backup Gold policy** — daily + weekly + monthly + yearly retention
  - 12.1.1.7 Gold/Silver/Bronze pre-built policies — assign per volume — no custom scripting

#### 12.1.2 Object Storage-Unique Features
- **Unique: Pre-Authenticated Requests (PAR)** — time-limited URL — no credentials at all
  - 12.1.2.1 Object + Bucket scope — read/write/list — expiry — share with external parties
  - 12.1.2.2 No IAM policy needed for recipient — PAR URL is the auth token
- **Unique: Autotiering** — automatic per-object tier transition — Standard → Infrequent Access
  - 12.1.2.3 Object-level tracking — independent of bucket lifecycle rules
- **Unique: Object versioning + soft delete via retention rules**
  - 12.1.2.4 Retention rule — lock objects — WORM compliance — time-bound or indefinite
  - 12.1.2.5 Locked retention rule — immutable — cannot delete even as admin — legal hold
- **Unique: S3 Compatibility API** — use S3 SDK with OCI Object Storage — migration
  - 12.1.2.6 OCI namespace + region as S3 endpoint — aws-sdk compatible — no code rewrite

#### 12.1.3 File Storage-Unique Features
- **Unique: File System Clone** — instant from snapshot — no data copy — CoW
  - 12.1.3.1 Clone hierarchy — parent → child snapshot chains — efficient tree
  - 12.1.3.2 Dev/test cloning — clone prod file system instantly — no storage overhead
- **Unique: FSS Kerberos authentication** — integrate with Active Directory — secure NFS
  - 12.1.3.3 Kerberized NFS — krb5 / krb5i / krb5p — encryption in transit

---

## 13.0 OCI Databases

### 13.1 Oracle DB & ExaDB-Unique Features
→ See Ideal §4.1 Oracle DB, §4.2 ADB, §4.3 MySQL HeatWave, §4.4 NoSQL, §4.5 Cache

#### 13.1.1 ExaDB-Unique Features
- **Unique: Smart Scan** — Exadata storage cell offload — eliminates row filtering at DB layer
  - 13.1.1.1 Storage indexes — in-memory zone map — skip cells with no matching data
  - 13.1.1.2 Hybrid Columnar Compression (HCC) — Exadata-only — 10–50x compression
- **Unique: RDMA over InfiniBand** — 100 Gbps — direct DB server → storage cell memory
  - 13.1.1.3 Zero-copy I/O — no network stack overhead — sub-ms storage latency
- **Unique: Exadata Flash Cache** — NVMe tier — hot data auto-cached — write-back mode
  - 13.1.1.4 Write-back Flash Cache — absorbs write spikes — durable — 3-way mirror

#### 13.1.2 Autonomous Database-Unique Features
- **Unique: Automatic Indexing** — ML-based — create/validate/drop indexes — transparent
  - 13.1.2.1 No DBA required — ADB auto-tunes — workload-aware — continuous
  - 13.1.2.2 Index staging — test invisible index first — promote only if improves
- **Unique: Self-securing** — Data Safe built-in — auto audit — sensitive data detection
  - 13.1.2.3 Database Vault — separate privileged users — even DBA cannot read app data
  - 13.1.2.4 Column-level encryption — TDE — data stays encrypted in storage + memory
- **Unique: Scale compute independently** — OCPU + storage separate — live resize
  - 13.1.2.5 Auto-scale OCPU — 3x peak burst — no manual intervention — cost-aware
  - 13.1.2.6 Always Free ADB — 1 OCPU + 20 GB — perpetual — dev/test

#### 13.1.3 MySQL HeatWave-Unique Features
- **Unique: In-database OLAP** — HeatWave cluster — MySQL queries routed to columnar engine
  - 13.1.3.1 No ETL — no separate DW — MySQL → HeatWave → accelerated analytics
  - 13.1.3.2 HeatWave ML — train + infer — SQL API — no Python/R needed
  - 13.1.3.3 HeatWave Lakehouse — query OCI Object Storage files (CSV/Parquet) from MySQL
- **Unique: HeatWave AutoShape** — recommend optimal node count + type — cost/performance
  - 13.1.3.4 Estimate nodes needed based on table sizes — guided provisioning
