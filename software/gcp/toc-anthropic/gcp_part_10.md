# GCP Complete Study Guide - Part 10: Phase 2 — Compute Engine, VPC, Cloud Storage

## Phase 2: GCP-Specific Implementations

---

## 16.0 Google Compute Engine

### 16.1 Compute Engine Core
→ See Ideal §1.1 VM Lifecycle, §1.2 Machine Types, §1.3 MIGs, §1.4 Spot VMs

#### 16.1.1 Compute Engine-Unique Features
- **Unique: Live Migration** — Google-patented — move VM between hosts without restart
  - 16.1.1.1 onHostMaintenance=MIGRATE — default for most VMs — zero downtime
  - 16.1.1.2 Migration window — ~200ms memory transfer pause — transparent to app
  - 16.1.1.3 Not available — GPUs, TPUs, local SSD (without swap), Confidential VMs
- **Unique: Shielded VMs** — Secure Boot + vTPM + Integrity Monitoring
  - 16.1.1.4 vTPM — virtual Trusted Platform Module — seals disk encryption keys
  - 16.1.1.5 Integrity monitoring — baseline vs. current boot — alert on deviation
  - 16.1.1.6 Shield-compatible OS required — most GCP-provided images support it
- **Unique: Confidential VMs** — AMD SEV or SEV-SNP — memory encrypted in hardware
  - 16.1.1.7 N2D/C3D machine types — AMD SEV — no attestation document
  - 16.1.1.8 N2D with SEV-SNP — full attestation — verify VM integrity remotely
  - 16.1.1.9 Confidential GKE nodes — confidential VMs as node pool
- **Unique: Google's TPU access via Cloud TPU** — v4/v5e/v5p — only on GCP
  - 16.1.1.10 TPU VM — direct access — JAX/PyTorch/TensorFlow — petaflop training
  - 16.1.1.11 TPU Pods — multi-host — ICI interconnect — 9000 chips v5p
- **Unique: Custom machine types** — any vCPU/memory ratio within constraints
  - 16.1.1.12 Extended memory — beyond standard ratio — up to 6.5GB per vCPU extra
- **Unique: Sole-Tenant Nodes** — physical server dedicated — BYOL + compliance
  - 16.1.1.13 In-place live migration between sole-tenant nodes — within same project
- **Unique: OS Config** — patch management — OS inventory — run commands at scale
  - 16.1.1.14 Patch job — zone/label filter — concurrency + disruption budget
  - 16.1.1.15 OS inventory — installed packages + versions — feed to SCC

---

## 17.0 GCP Virtual Private Cloud (VPC)

### 17.1 VPC Core
→ See Ideal §2.1 Global VPC, §2.2 Subnetting, §2.3 Routing, §2.7 Network Security

#### 17.1.1 GCP VPC-Unique Features
- **Unique: Global VPC** — single VPC spans all regions — unique to GCP
  - 17.1.1.1 Subnets are regional — VMs in us-central1 + europe-west1 share one VPC
  - 17.1.1.2 Cross-region traffic — no peering needed — same-VPC routing
  - 17.1.1.3 Global routing mode — dynamic routes propagated globally — vs. regional
- **Unique: Shared VPC (XPN)** — host project VPC shared to multiple service projects
  - 17.1.1.4 Host project — owns subnets — grants subnetUser role to service projects
  - 17.1.1.5 Service project — deploys VMs in shared subnets — no VPC ownership
  - 17.1.1.6 Centralized network governance — firewall rules in host project
- **Unique: Packet Mirroring** — clone traffic to IDS/monitoring VMs — no in-path
  - 17.1.1.7 Mirror from instance/subnet/tag → collector ILB → IDS appliance
  - 17.1.1.8 Filter by CIDR, protocol, direction — reduce mirroring cost
- **Unique: Network Intelligence Center** — visibility + troubleshooting suite
  - 17.1.1.9 Connectivity tests — source → destination — trace path + firewall analysis
  - 17.1.1.10 Firewall Insights — shadowed rules, deny hit count, overly permissive
  - 17.1.1.11 Network Analyzer — detect misconfigurations — auto-generated findings
  - 17.1.1.12 Performance Dashboard — loss + latency between GCP entities + regions
- **Unique: Cloud NAT** — managed SNAT — no NAT gateway VM — GCP-native
  - 17.1.1.13 Dynamic port allocation — auto-scale ports per VM — avoid SNAT exhaustion
  - 17.1.1.14 Static IP allocation — assign specific IPs — IP whitelist use case
- **Unique: Private Service Connect (PSC)** — expose managed services privately
  - 17.1.1.15 Publish service — attach to PSC forwarding rule — consumer creates endpoint
  - 17.1.1.16 PSC for Google APIs — private.googleapis.com — no internet path

---

## 18.0 Cloud Storage (GCS)

### 18.1 GCS Core
→ See Ideal §3.1 Object Storage, §3.4 Lifecycle, §3.5 Replication, §3.6 Encryption

#### 18.1.1 GCS-Unique Features
- **Unique: Autoclass** — per-object automatic tiering — no lifecycle policy needed
  - 18.1.1.1 Object moves Standard → Nearline → Coldline → Archive on inactivity
  - 18.1.1.2 Terminal storage class config — cap lowest tier — Standard-only option
- **Unique: Turbo Replication** — dual-region — 99% replicated within 15 minutes
  - 18.1.1.3 RPO SLA — not just best-effort — guaranteed time — disaster recovery
  - 18.1.1.4 Only for dual-region buckets — NAM4, EUR4, ASIA1 or custom pair
- **Unique: Pub/Sub Notifications** — push event on object finalize/delete/archive
  - 18.1.1.5 Filter by prefix/suffix — targeted workflows — event-driven pipelines
- **Unique: GCS FUSE** — mount GCS bucket as filesystem — AI training data access
  - 18.1.1.6 File cache — local NVMe — reduce remote reads — configurable TTL
  - 18.1.1.7 Parallel downloads — chunked fetches — saturate GPU server bandwidth
- **Unique: Soft delete** — configurable retention — delete → soft-deleted for N days
  - 18.1.1.8 bucket.softDeletePolicy.retentionDuration — 7 days default
  - 18.1.1.9 Restore via undelete API — self-service recovery
- **Unique: Storage Insights** — inventory reports — object metadata — BigQuery export
  - 18.1.1.10 Inventory report — daily/weekly — CSV or Parquet — cost analysis
- **Unique: gcloud storage + JSON API** — parallel composite uploads
  - 18.1.1.11 Parallel composite upload — 32 components — server-side reassembly
  - 18.1.1.12 gcloud storage rsync — incremental sync — delta only — checksums
