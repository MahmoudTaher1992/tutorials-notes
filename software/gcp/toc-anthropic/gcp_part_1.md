# GCP Complete Study Guide - Part 1: Core Compute & Infrastructure (Phase 1 — Ideal)

## 1.0 Core Compute & Infrastructure

### 1.1 VM Lifecycle (Compute Engine)
#### 1.1.1 Provisioning Pipeline
- 1.1.1.1 Borg scheduler — Google's internal cluster manager — underlying VM orchestration
  - 1.1.1.1.1 Physical host selection — NUMA-aware — rack + power domain spreading
  - 1.1.1.1.2 Hardware root of trust — vTPM provisioned — Shielded VM attestation
- 1.1.1.2 Hypervisor — KVM-based — custom Google virtualization layer
  - 1.1.1.2.1 Titanium — custom security chip — Root of Trust on host — firmware validation
  - 1.1.1.2.2 Live migration — Google-patented — move VM between hosts without restart
- 1.1.1.3 Boot sequence — UEFI → Secure Boot → OS bootloader → startup scripts
  - 1.1.1.3.1 Startup scripts — metadata server delivery — Linux/Windows/Cloud-init
  - 1.1.1.3.2 Metadata server — 169.254.169.254 — instance attributes, service accounts

#### 1.1.2 VM State Machine
- 1.1.2.1 Provisioning → Staging → Running → Stopping → Terminated transitions
  - 1.1.2.1.1 Suspend/Resume — like hibernate — VM state to persistent disk
  - 1.1.2.1.2 TERMINATED vs. DELETED — terminated retains disk; deleted removes all
- 1.1.2.2 Maintenance events — live migration (default) or terminate+restart
  - 1.1.2.2.1 onHostMaintenance — MIGRATE or TERMINATE — per-instance policy
  - 1.1.2.2.2 maintenancePolicy.hostError — automaticRestart on host failure

#### 1.1.3 Placement Policies
- 1.1.3.1 Compact placement policy — low-latency — same physical cluster
  - 1.1.3.1.1 Collocation policy — max 8 VMs per compact group
  - 1.1.3.1.2 Use case — HPC, MPI, tightly coupled workloads — sub-μs fabric
- 1.1.3.2 Spread placement policy — max availability — different failure domains
- 1.1.3.3 Resource policies — commitment-based — reserve specific VM types + zones

### 1.2 Machine Types & Hardware Classes
#### 1.2.1 General Purpose
- 1.2.1.1 N-series (N4/N2D) — balanced — 0.5–8 GB RAM per vCPU
  - 1.2.1.1.1 N4 — Intel Emerald Rapids — up to 208 vCPUs, 1.5TB RAM
  - 1.2.1.1.2 N2D — AMD EPYC Milan — up to 224 vCPUs — cost-optimized
- 1.2.1.2 E2 — shared-core + standard — 30% cheaper than N2 — variable CPU
  - 1.2.1.2.1 e2-micro/small/medium — fractional vCPU — micro-services, dev
  - 1.2.1.2.2 e2-standard-2 to e2-standard-32 — best price for general workloads
- 1.2.1.3 Tau T2D / T2A — scale-out workloads
  - 1.2.1.3.1 T2D — AMD EPYC Milan — 60 vCPUs — 40% better perf/$ vs N2
  - 1.2.1.3.2 T2A — ARM Ampere Altra — up to 48 vCPUs — 40% cheaper than N1

#### 1.2.2 Compute Optimized
- 1.2.2.1 C3 / C3D — high frequency — Intel Sapphire Rapids / AMD Genoa
  - 1.2.2.1.1 C3 — up to 176 vCPUs — 5.5 GB RAM per vCPU — gaming, HFT
  - 1.2.2.1.2 H3 — Intel Sapphire Rapids — HPC — 88 vCPUs — compact placement
- 1.2.2.2 C2 — Intel Cascade Lake — up to 60 vCPUs — compute-intensive legacy

#### 1.2.3 Memory Optimized
- 1.2.3.1 M3 — up to 30TB RAM — SAP HANA — Intel Sapphire Rapids
  - 1.2.3.1.1 m3-ultramem-128 — 30.5TB — largest VM on GCP
  - 1.2.3.1.2 NFS or local SSD for swap — SAP HANA scale-out
- 1.2.3.2 M2 / M1 — high memory — up to 12TB — legacy SAP workloads

#### 1.2.4 Accelerator Optimized
- 1.2.4.1 A3 — NVIDIA H100 — 8x per VM — NVLink + InfiniBand
  - 1.2.4.1.1 A3 Mega — H100 80GB SXM5 — 1.8TB/s NVLink per VM
  - 1.2.4.1.2 GPUDirect-TCPXO — Google custom RDMA — 3.2Tbps GPU-to-GPU
- 1.2.4.2 A2 — NVIDIA A100 — 1/2/4/8/16 GPUs — multi-instance GPU (MIG)
  - 1.2.4.2.1 A2 Ultra — A100 80GB — NVLink 600GB/s — LLM training
- 1.2.4.3 G2 — NVIDIA L4 — inference, gaming streaming, video transcoding
- 1.2.4.4 TPU v5e / v5p — Google's custom AI accelerator — matrix multiply
  - 1.2.4.4.1 TPU v5p Pod — 8960 chips — 459 exaflops — largest ML cluster
  - 1.2.4.4.2 TPU v5e — inference + training — 256 chips per pod slice

### 1.3 Managed Instance Groups (MIGs) & Autoscaling
#### 1.3.1 MIG Types
- 1.3.1.1 Zonal MIG — single zone — lowest latency — no cross-zone redundancy
- 1.3.1.2 Regional MIG — up to 3 zones — HA — spread across failure domains
  - 1.3.1.2.1 Target distribution — EVEN, BALANCED, ANY — zone spread control

#### 1.3.2 Autoscaling Policies
- 1.3.2.1 CPU utilization — target percentage — average across group
  - 1.3.2.1.1 Predictive autoscaling — ML forecast — scale before load arrives
  - 1.3.2.1.2 coolDownPeriodSec — default 60s — initialization time
- 1.3.2.2 HTTP load balancing serving capacity — utilization or rate per instance
- 1.3.2.3 Cloud Monitoring metric — custom metrics — Pub/Sub queue depth
- 1.3.2.4 Schedule-based autoscaling — cron — min instances override

#### 1.3.3 MIG Update Strategies
- 1.3.3.1 Rolling update — maxSurge + maxUnavailable — gradual replacement
  - 1.3.3.1.1 canary update — target size — test subset before full rollout
- 1.3.3.2 Stateful MIGs — preserve disk + IP per instance — stateful workloads
  - 1.3.3.2.1 Stateful policy — per-instance config — retain specific disks
  - 1.3.3.2.2 Auto-healing — recreate failed instance with same config + disks

### 1.4 Spot VMs (Preemptible)
#### 1.4.1 Spot VM Characteristics
- 1.4.1.1 Up to 91% cheaper than on-demand — variable pricing
  - 1.4.1.1.1 Preemption notice — 30-second ACPI G2 soft off signal
  - 1.4.1.1.2 preemptionNotice.minutes=0 — poll metadata for preemption signal
- 1.4.1.2 Max 24-hour runtime — then preempted — stateless workloads required
  - 1.4.1.2.1 Spot vs. preemptible — Spot has no 24hr limit — preferred
- 1.4.1.3 MIG spot VMs — mix on-demand + spot — base + burst pattern
  - 1.4.1.3.1 instanceFlexibilityPolicy — machine type fallback order

### 1.5 Sole-Tenant Nodes
#### 1.5.1 Sole-Tenant Architecture
- 1.5.1.1 Dedicated physical server — no VM sharing with other customers
  - 1.5.1.1.1 Node types — c3-node-176-1408 etc. — define vCPU/RAM budget
  - 1.5.1.1.2 Node affinity labels — bind VMs to specific node group
- 1.5.1.2 Maintenance policy — migrate or restart — control maintenance window
  - 1.5.1.2.1 In-place live migration between sole-tenant nodes — same project
