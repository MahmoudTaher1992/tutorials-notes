# Azure Complete Study Guide - Part 10: Phase 2 — Azure VMs, VNet, Blob Storage

## Phase 2: Azure-Specific Implementations

---

## 16.0 Azure Virtual Machines

### 16.1 VM Core
→ See Ideal §1.1 VM Lifecycle, §1.2 VM Sizes, §1.3 Scale Sets, §1.4 Spot VMs

#### 16.1.1 Azure VM-Unique Features
- **Unique: Azure Boost** — offload storage + networking to DPU — free host CPU for workload
  - 16.1.1.1 Remote NVMe Direct — Boost-enabled VMs attach Ultra/Prem SSD v2 via RDMA
  - 16.1.1.2 Storage-optimized networking — 12.5 GB/s remote storage bandwidth (v6 series)
- **Unique: Ephemeral OS Disk** — store OS disk in VM cache or temp disk — zero latency
  - 16.1.1.3 Re-image = same disk — no OS disk roundtrip — VMSS stateless reimage
  - 16.1.1.4 Placement — cache disk (default) or temp disk — size constrained by VM SKU
- **Unique: Trusted Launch** — Secure Boot + vTPM + boot integrity monitoring
  - 16.1.1.5 Measured Boot attestation — Microsoft Defender — detect rootkits
  - 16.1.1.6 Required for Confidential VMs — DCasv5/ECasv5 — AMD SEV-SNP
- **Unique: Confidential VMs** — AMD SEV-SNP or Intel TDX — memory encrypted at hardware
  - 16.1.1.7 Hardware-based attestation — quote signed by AMD/Intel
  - 16.1.1.8 CVM disk encryption — integrity-protected — CMK in Managed HSM
- **Unique: Hibernation** — save VM state to OS disk — resume in seconds — no deallocation billing
  - 16.1.1.9 Supported SKUs — D/E series — OS disk must be large enough for RAM
- **Unique: Scheduled Events service** — query IMDS — 15-minute pre-notification
  - 16.1.1.10 Approve or delay — delay up to 15 minutes — host maintenance control
- **Unique: Run Command** — execute script via Azure control plane — no inbound port
  - 16.1.1.11 V2 (action run command) — async, cancellable, output streamed
- **Unique: Azure Serial Console** — OOB access — boot issues, grub, OS rescue

---

## 17.0 Azure Virtual Network (VNet)

### 17.1 VNet Core
→ See Ideal §2.1 VNet Architecture, §2.2 Subnetting, §2.3 Routing, §2.7 Network Security

#### 17.1.1 VNet-Unique Features
- **Unique: Azure Virtual Network Manager (AVNM)** — centralized VNet governance at scale
  - 17.1.1.1 Network groups — dynamic membership — policy-based VNet grouping
  - 17.1.1.2 Connectivity configuration — mesh or hub-spoke — apply to network group
  - 17.1.1.3 Security admin rules — enforce NSG rules centrally — override local NSGs
- **Unique: VNet Flow Logs** — VNet-level (vs. NSG-level) — single config for all traffic
  - 17.1.1.4 Traffic analytics — Log Analytics — geo-map, anomaly detection, top flows
  - 17.1.1.5 Parquet format in Storage Account — Athena-like Kusto queries on flows
- **Unique: Cross-tenant VNet Peering** — peer VNets in different Entra tenants
  - 17.1.1.6 Requires both sides to authorize — linked subscription to tenant
- **Unique: NAT Gateway** — outbound SNAT — up to 16 public IPs — 64K ports per IP
  - 17.1.1.7 Per-subnet association — all outbound goes through NAT GW
  - 17.1.1.8 No inbound — source IP preserved on asymmetric flows — stateless
- **Unique: Azure Bastion** — browser-based SSH/RDP — no public IP on VM required
  - 17.1.1.9 Standard SKU — native client support — file transfer — shareable links
  - 17.1.1.10 Premium SKU — private-only Bastion — session recording (preview)
- **Unique: DDoS Network Protection** — per-VNet — 99.99% uptime SLA + cost protection
  - 17.1.1.11 Adaptive tuning — ML per public IP — baselining over 14 days
  - 17.1.1.12 Diagnostic logs — mitigation flows — attack summary reports

---

## 18.0 Azure Blob Storage

### 18.1 Blob Core
→ See Ideal §3.1 Object Storage, §3.4 Lifecycle, §3.5 Replication, §3.6 Encryption

#### 18.1.1 Blob-Unique Features
- **Unique: Azure Data Lake Storage Gen2 (ADLS Gen2)** — Blob + hierarchical namespace
  - 18.1.1.1 POSIX-compatible ACLs — file+dir level — analytics access control
  - 18.1.1.2 Atomic directory rename — HNS enables O(1) rename — critical for Spark
  - 18.1.1.3 NFS 3.0 mount — direct Linux filesystem access — HPC workloads
- **Unique: Blob Storage Events** — native Event Grid integration — push on create/delete
  - 18.1.1.4 Fine-grained prefix/suffix filter — trigger only on matching blob paths
- **Unique: Object replication** — async copy blobs between accounts — filter by prefix
  - 18.1.1.5 Cross-tenant replication — different subscriptions — requires policy opt-in
- **Unique: Blob inventory** — weekly/daily — CSV or Parquet — all blobs + properties
  - 18.1.1.6 Analyze with Synapse/Athena-equivalent — cost + compliance auditing
- **Unique: Azure Blob NFSv3** — mount storage account as NFS share — premium block blob
  - 18.1.1.7 No ACLs in NFSv3 — POSIX permissions via NFS — HPC lift-and-shift
- **Unique: Storage Tasks (Preview)** — data management operations at scale — no Lambda
  - 18.1.1.8 Conditions + operations — tag, set tier, delete — triggered on schedule
- **Unique: Customer-provided encryption key (CPK)** — per-request AES key — no Key Vault
  - 18.1.1.9 Key hash stored with blob — must provide same key for read
- **Unique: Append blobs** — log files, audit data — concurrent appends supported
  - 18.1.1.10 Block-by-block append — CommitBlockList not needed — sequential only
- **Unique: Azure Storage Explorer** — cross-platform GUI — SAS/Entra/key — blob management
- **Unique: azcopy** — high-performance CLI — parallel chunks — checkpointing — resumable
  - 18.1.1.11 Service-to-service copy — server-side — no bandwidth on client machine
  - 18.1.1.12 Benchmark command — test storage account throughput
