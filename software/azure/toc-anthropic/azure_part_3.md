# Azure Complete Study Guide - Part 3: Storage Systems (Phase 1 — Ideal)

## 3.0 Storage Systems

### 3.1 Blob Storage
#### 3.1.1 Storage Account & Blob Service
- 3.1.1.1 Storage account types — StorageV2 (GPv2), Blob, Premium BlockBlob, Premium Page, Premium File
  - 3.1.1.1.1 GPv2 — all services — tiering supported — recommended default
  - 3.1.1.1.2 Premium BlockBlob — SSD-backed — sub-10ms latency — analytics workloads
- 3.1.1.2 Blob types — Block Blob, Append Blob, Page Blob
  - 3.1.1.2.1 Block Blob — up to 190.7TB — max 50,000 blocks × 4000MB each
  - 3.1.1.2.2 Append Blob — append-only — log files — up to 195GB
  - 3.1.1.2.3 Page Blob — 512-byte pages — random read/write — Azure Disk (unmanaged)

#### 3.1.2 Access Tiers
- 3.1.2.1 Hot — frequent access — higher storage cost, lower access cost
- 3.1.2.2 Cool — infrequent — 30-day minimum — lower storage, higher access
- 3.1.2.3 Cold — rarely accessed — 90-day minimum — cheaper than Cool storage
- 3.1.2.4 Archive — offline — rehydration required — 180-day minimum
  - 3.1.2.4.1 Rehydration priority — Standard (up to 15hrs) vs. High (under 1hr)
  - 3.1.2.4.2 Rehydrate to Hot/Cool — not in-place — copy to different tier
- 3.1.2.5 Lifecycle management policy — auto-tier or delete based on last modified/accessed
  - 3.1.2.5.1 Last access time tracking — opt-in — enables access-based tiering
  - 3.1.2.5.2 Snapshot and version lifecycle — manage old versions automatically

#### 3.1.3 Access Control
- 3.1.3.1 Azure RBAC — Storage Blob Data Reader/Contributor/Owner
  - 3.1.3.1.1 Entra ID authorization — preferred over shared key
  - 3.1.3.1.2 Disable shared key — account-level setting — force Entra/SAS only
- 3.1.3.2 Shared Access Signatures (SAS) — time-limited delegated access
  - 3.1.3.2.1 Account SAS — storage account level — multiple services
  - 3.1.3.2.2 Service SAS — single service — Blob/Queue/Table/File
  - 3.1.3.2.3 User delegation SAS — signed with Entra ID — most secure SAS type
- 3.1.3.3 Stored Access Policies — server-side SAS policy — revoke without regenerating key

#### 3.1.4 Blob Performance & Features
- 3.1.4.1 Blob index tags — key-value metadata — filter/find blobs at scale
  - 3.1.4.1.1 FindBlobsByTags API — query across containers/accounts
- 3.1.4.2 Batch operations — BlobBatch — delete/set tier on up to 256 blobs per request
- 3.1.4.3 Blob versioning — automatic versions on overwrite/delete
  - 3.1.4.3.1 Restore previous version — copy version to base blob
  - 3.1.4.3.2 Cost of versioning — each version billed by unique block content
- 3.1.4.4 Soft delete — retain deleted blobs — 1 to 365 days
  - 3.1.4.4.1 Container soft delete — restore deleted containers
- 3.1.4.5 Immutable storage — WORM — time-based retention + legal hold
  - 3.1.4.5.1 Locked policy — cannot be shortened — SEC 17a-4(f) compliant

### 3.2 Disk Storage (Managed Disks)
#### 3.2.1 Disk Types
- 3.2.1.1 Ultra Disk — up to 400GB/s, 160K IOPS — configurable independently
  - 3.2.1.1.1 Sub-millisecond latency — financial services, SAP HANA
  - 3.2.1.1.2 Must be in same AZ as VM — no LRS cross-zone
- 3.2.1.2 Premium SSD v2 — 80K IOPS, 1.2GB/s — independent IOPS/throughput tuning
  - 3.2.1.2.1 No downtime to change IOPS/throughput — live adjustment
  - 3.2.1.2.2 Incremental snapshots — only changed regions since last snapshot
- 3.2.1.3 Premium SSD (v1) — per-size IOPS — P1 to P80 — capped per tier
  - 3.2.1.3.1 Bursting — on-demand or credit-based — P20–P50 eligible
  - 3.2.1.3.2 Read-only cache — host cache — Premium SSD only — reduce latency
- 3.2.1.4 Standard SSD — E-series — dev/test, low IOPS production
- 3.2.1.5 Standard HDD — S-series — backup, infrequent access

#### 3.2.2 Disk Features
- 3.2.2.1 Shared disks — multi-VM attach — clustered SQL, WSFC
  - 3.2.2.1.1 MaxShares limit — Ultra: 5, Prem SSD: 5, Std SSD: 2
- 3.2.2.2 Disk encryption — Azure Disk Encryption (ADE) — BitLocker/dm-crypt
  - 3.2.2.2.1 SSE with CMK — server-side encryption — Key Vault key
  - 3.2.2.2.2 Encryption at host — encrypt temp disk + host cache
- 3.2.2.3 Trusted Launch — vTPM + Secure Boot — Gen2 VMs — UEFI-based
  - 3.2.2.3.1 Measured Boot — attest boot chain — integrity monitoring
- 3.2.2.4 Incremental snapshots — cross-region copy — lower cost than full snapshot

### 3.3 File Storage
#### 3.3.1 Azure Files
- 3.3.1.1 SMB 3.x / NFS 4.1 — fully managed — no server to maintain
  - 3.3.1.1.1 Identity-based auth — Entra ID DS / on-prem AD DS / Entra Kerberos
  - 3.3.1.1.2 Share-level permissions — RBAC — directory/file-level — Windows ACLs
- 3.3.1.2 Tiers — Transaction Optimized, Hot, Cool, Premium (SSD)
  - 3.3.1.2.1 Premium Files — dedicated IOPS — <1ms latency — provisioned model
  - 3.3.1.2.2 Large file shares — up to 100TB — Standard tier — opt-in per account
- 3.3.1.3 Azure File Sync — replicate Files share to Windows Server — tiering
  - 3.3.1.3.1 Cloud tiering — least-recently-used files tiered to cloud — free local space
  - 3.3.1.3.2 Multi-server sync — same share — all servers stay in sync

#### 3.3.2 Azure NetApp Files
- 3.3.2.1 Enterprise NFS/SMB — bare-metal NetApp ONTAP — sub-millisecond latency
  - 3.3.2.1.1 Service levels — Standard (16MB/s/TiB), Premium (64MB/s/TiB), Ultra (128MB/s/TiB)
  - 3.3.2.1.2 Dynamic service level — change without data movement
- 3.3.2.2 Cross-region replication — async — SAP/Oracle DR
  - 3.3.2.2.1 RPO minutes — schedule-based — hourly/daily/weekly

### 3.5 Replication & Redundancy
#### 3.5.1 Storage Redundancy Options
- 3.5.1.1 LRS — Locally Redundant — 3 copies same datacenter — 99.9999999999% (11 nines)
- 3.5.1.2 ZRS — Zone Redundant — 3 copies across 3 AZs — 99.9999999999999% (12 nines)
  - 3.5.1.2.1 ZRS recommended for HA — survive zone failure without failover
- 3.5.1.3 GRS — Geo Redundant — LRS primary + LRS secondary region — async
  - 3.5.1.3.1 RA-GRS — read access to secondary — use before failover
  - 3.5.1.3.2 Failover — customer-initiated — RPO <1hr for most data
- 3.5.1.4 GZRS — Geo Zone Redundant — ZRS primary + LRS secondary
  - 3.5.1.4.1 RA-GZRS — read secondary + zone resilient primary — maximum HA

### 3.6 Encryption at Rest
#### 3.6.1 Azure Storage Encryption
- 3.6.1.1 Default SSE — AES-256 — Microsoft managed keys — free — all tiers
- 3.6.1.2 Customer Managed Keys (CMK) — Key Vault or Managed HSM
  - 3.6.1.2.1 Key auto-rotation — Key Vault policy — rotate without re-encrypting data
  - 3.6.1.2.2 Key revocation — immediately deny access — Managed Disk/Blob data inaccessible
- 3.6.1.3 Double encryption — infrastructure encryption — additional AES-256 layer
  - 3.6.1.3.1 Enable at account creation — cannot be changed after
