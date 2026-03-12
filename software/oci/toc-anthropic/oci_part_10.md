# OCI Complete Study Guide - Part 10: Phase 2 — Compute & Networking

## Phase 2: OCI-Specific Implementations

---

## 10.0 OCI Compute

### 10.1 OCI Compute Core
→ See Ideal §1.1 VM Lifecycle, §1.2 Shape Types, §1.3 Instance Pools, §1.4 Preemptible, §1.5 Dedicated VM Hosts

#### 10.1.1 OCI Compute-Unique Features
- **Unique: OCPU model** — 1 OCPU = 1 physical core (2 vCPUs with HT) — different from AWS vCPU
  - 10.1.1.1 AMD EPYC — 1 OCPU = 1 physical core thread — not a virtual thread
  - 10.1.1.2 ARM A1.Flex — 1 OCPU = 1 Ampere Altra core — lowest price/OCPU on market
- **Unique: Live Migration for maintenance** — transparent — no notification required
  - 10.1.1.3 OCI migrates VMs during host maintenance — customer sees no interruption
  - 10.1.1.4 Not available for BM shapes — customer gets advance warning for BM
- **Unique: Capacity Reservations** — reserve without running — guaranteed at launch time
  - 10.1.1.5 Unused reservation billed — commitment for availability guarantee
  - 10.1.1.6 AD-scoped — specific AD — not region-wide
- **Unique: Oracle Cloud Agent** — plugin framework — OS Management, Monitoring, Bastion
  - 10.1.1.7 Plugin-based — enable/disable per plugin — console toggle
  - 10.1.1.8 Custom Scripts plugin — run scripts — scheduled — no SSM equivalent needed
- **Unique: Burstable instances** — VM.Standard.E2.1.Micro (Always Free) — baseline + burst
  - 10.1.1.9 Baseline 12.5% CPU — burst to 100% — credit model — free tier
- **Unique: RDMA Cluster Network** — private OCI network — low-latency GPU/HPC
  - 10.1.1.10 1.6 Tbps — per rack — BM.GPU4/H100 — HPC2 shapes — lossless fabric
  - 10.1.1.11 Cluster placement group — co-locate BM nodes — minimize latency
- **Unique: Shielded Instances** — Secure Boot + vTPM + Measured Boot — OCI native
  - 10.1.1.12 Integrity monitoring — detect boot-time rootkits — deviation alert
  - 10.1.1.13 Confidential Computing — AMD SEV-SNP — encrypted memory — attestation

---

## 11.0 OCI Virtual Cloud Network (VCN)

### 11.1 OCI VCN Core
→ See Ideal §2.1 VCN Architecture, §2.2 Subnets, §2.3 NSG, §2.4 Load Balancing, §2.5 FastConnect, §2.6 DNS, §2.7 WAF

#### 11.1.1 OCI VCN-Unique Features
- **Unique: Regional subnets** — span all ADs in region — simplify multi-AD HA design
  - 11.1.1.1 No subnet per AZ needed — one subnet, launch in any AD — simpler CIDR plan
- **Unique: Dynamic Routing Gateway (DRG) v2** — hub router — VCN + FastConnect + VPN + Remote Peering
  - 11.1.1.2 Transit routing — spoke VCNs route through DRG — centralized NVA insertion
  - 11.1.1.3 DRG route distribution — export policies per attachment — fine-grained
- **Unique: Service Gateway** — private path to OCI Services Network — no NAT — no internet
  - 11.1.1.4 Single route rule — covers all OCI services — simpler than AWS gateway endpoints
  - 11.1.1.5 Object Storage + ADW + Streaming — reach without public IP on instance
- **Unique: Private DNS with resolver endpoints** — forward DNS to on-prem — conditional fwd
  - 11.1.1.6 Listening endpoint — on-prem DNS forwards OCI queries here
  - 11.1.1.7 Forwarding endpoint — OCI DNS forwards on-prem domains there
- **Unique: Network Firewall (Palo Alto-backed)** — managed NGFW — IDS/IPS — TLS inspection
  - 11.1.1.8 Policy-as-code — security rules + address lists + URL lists — OCI managed
  - 11.1.1.9 Decryption profile — TLS inspection — outbound + inbound — certificate mgmt
- **Unique: Flexible Load Balancer bandwidth** — 10 Mbps to 8 Gbps — resize live
  - 11.1.1.10 No pre-provisioned instance type — bandwidth slider — pay for what you use
- **Unique: FastConnect public peering** — reach OCI public endpoints over private circuit
  - 11.1.1.11 No internet path for Object Storage — FastConnect public peering — compliance
- **Unique: IP Management (IPAM)** — BYOIP — bring own IP prefix — announce from OCI
  - 11.1.1.12 BYOIP — import /24 or larger — OCI advertises — static public IP blocks
- **Unique: VCN Flow Logs** — per-VNIC — capture accepted + rejected — Object Storage
  - 11.1.1.13 5-tuple + action + bytes + packets — security investigation + capacity
