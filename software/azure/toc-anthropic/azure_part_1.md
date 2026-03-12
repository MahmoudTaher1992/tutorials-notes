# Azure Complete Study Guide - Part 1: Core Compute & Infrastructure (Phase 1 — Ideal)

## 1.0 Core Compute & Infrastructure

### 1.1 VM Lifecycle
#### 1.1.1 Provisioning Pipeline
- 1.1.1.1 Fabric Controller allocation — assign physical node, rack, blade
  - 1.1.1.1.1 NUMA-aware placement — minimize cross-node memory latency
  - 1.1.1.1.2 Hardware root of trust — vTPM provisioned at VM creation
- 1.1.1.2 Hypervisor layer — Azure Hypervisor (Hyper-V based, custom security)
  - 1.1.1.2.1 Root OS isolation — stripped Hyper-V root — no user process execution
  - 1.1.1.2.2 Azure Host Agent — communicates with Fabric Controller — heartbeat
- 1.1.1.3 Boot sequence — UEFI secure boot → cloud-init / Custom Script Extension
  - 1.1.1.3.1 cloud-init on Linux — phases: init-local, init, config, final
  - 1.1.1.3.2 Custom Script Extension — download + run script post-provision

#### 1.1.2 VM State Machine
- 1.1.2.1 Provisioning → Running → Deallocated → Deleted transitions
  - 1.1.2.1.1 Deallocated vs. Stopped — deallocated releases compute, stops billing
  - 1.1.2.1.2 OS disk retained on deallocate — ephemeral OS disk wiped
- 1.1.2.2 Maintenance events — Scheduled Events API — 15-minute warning
  - 1.1.2.2.1 Event types — Freeze, Reboot, Redeploy, Preempt, Terminate
  - 1.1.2.2.2 Approve/delay — PATCH to events endpoint — control maintenance window

#### 1.1.3 Placement & Availability
- 1.1.3.1 Availability Zones — physically separate datacenters within region
  - 1.1.3.1.1 99.99% SLA with 2+ VMs in different AZs
  - 1.1.3.1.2 Zone-redundant vs. zonal deployment — pinned vs. distributed
- 1.1.3.2 Availability Sets — fault domains (rack isolation) + update domains
  - 1.1.3.2.1 Max 3 fault domains, 20 update domains per availability set
  - 1.1.3.2.2 99.95% SLA — cannot span zones — legacy single-datacenter HA
- 1.1.3.3 Proximity Placement Groups — low-latency co-location within datacenter
  - 1.1.3.3.1 Colocation scope — zone or region — single datacenter guarantee

### 1.2 VM Sizes & Hardware Classes
#### 1.2.1 General Purpose Series
- 1.2.1.1 D-series (Dv5/Dav5/Dlv5) — balanced CPU:memory 1:4 ratio
  - 1.2.1.1.1 Dav5 — AMD EPYC Milan — up to 96 vCPUs, 384GB RAM
  - 1.2.1.1.2 Dlv5 — lower memory ratio — web servers, dev/test
- 1.2.1.2 B-series (Bsv2) — burstable — CPU credits accumulate when idle
  - 1.2.1.2.1 Base CPU % per vCPU — 20–100% — credit earn/spend rate
  - 1.2.1.2.2 Credit model — 1 credit = 1 vCPU at 100% for 1 minute

#### 1.2.2 Compute Optimized
- 1.2.2.1 F-series (Fsv2) — Intel Cascade Lake — 2 GiB RAM per vCPU
  - 1.2.2.1.1 Up to 72 vCPUs — high clock speed — web/app servers
- 1.2.2.2 FX-series — Intel Sapphire Rapids — 6 GiB per vCPU — EDA workloads

#### 1.2.3 Memory Optimized
- 1.2.3.1 E-series (Ev5/Easv5) — 8 GiB per vCPU — in-memory databases
  - 1.2.3.1.1 Easv5 — AMD EPYC — up to 672GB RAM
- 1.2.3.2 M-series — up to 11.4TB RAM — SAP HANA certified
  - 1.2.3.2.1 Mv2 — 416 vCPUs, 11.4TB — Write Accelerator for SAP log
  - 1.2.3.2.2 MediumMemory Mv3 — NVMe local SSD — sub-100μs DB latency

#### 1.2.4 GPU & Accelerated
- 1.2.4.1 NC-series (NC_H100_v5) — NVIDIA H100 NVL — LLM training
  - 1.2.4.1.1 InfiniBand HDR (200Gbps) — RDMA — distributed training
  - 1.2.4.1.2 NVLink 4.0 — 900GB/s GPU-to-GPU — no PCIe bottleneck
- 1.2.4.2 ND-series (NDm_A100_v4) — 8x A100 80GB — MIG support
  - 1.2.4.2.1 MIG slicing — 7 instances per A100 — multi-tenant GPU sharing
- 1.2.4.3 NV-series (NVadsA10_v5) — visualization/VDI — NVIDIA A10
- 1.2.4.4 NG-series — AMD Radeon PRO — graphic-intensive virtual desktops

#### 1.2.5 Storage Optimized
- 1.2.5.1 L-series (Lsv3) — NVMe local SSD — up to 80TB — Cassandra/MongoDB
  - 1.2.5.1.1 Direct NVMe — sub-microsecond latency — no Azure Disk overhead
- 1.2.5.2 HX-series — 673K IOPS local — 3TB RAM — HPC + in-memory DB

### 1.3 Scale Sets & Auto Scaling
#### 1.3.1 Virtual Machine Scale Sets (VMSS)
- 1.3.1.1 Uniform vs. Flexible orchestration modes
  - 1.3.1.1.1 Uniform — identical VMs — older mode — auto OS upgrades
  - 1.3.1.1.2 Flexible — mix sizes/AZs — individual VM management — recommended
- 1.3.1.2 Scaling policies — metric-based, schedule-based, predictive
  - 1.3.1.2.1 Scale-out cooldown — default 5 minutes — prevent thrashing
  - 1.3.1.2.2 Scale-in cooldown — default 5 minutes — independent of scale-out

#### 1.3.2 Autoscale Profiles
- 1.3.2.1 Default profile — fallback — always active
- 1.3.2.2 Fixed date profile — one-time event override — product launch
- 1.3.2.3 Recurrence profile — weekly schedule — business hours

#### 1.3.3 Scaling Triggers
- 1.3.3.1 Azure Monitor metric rules — CPU%, memory%, custom metrics
  - 1.3.3.1.1 Aggregation types — Average, Minimum, Maximum, Total, Count
  - 1.3.3.1.2 Time grain vs. time window — granularity and evaluation period
- 1.3.3.2 Predictive autoscale — ML forecast — pre-scale before load arrives
  - 1.3.3.2.1 Forecast-only mode — visualize without acting — calibrate first

### 1.4 Spot VMs
#### 1.4.1 Spot VM Pricing & Eviction
- 1.4.1.1 Eviction policies — Deallocate vs. Delete
  - 1.4.1.1.1 Deallocate — retain disks — restart when capacity available
  - 1.4.1.1.2 Delete — remove all resources — stateless workloads
- 1.4.1.2 Eviction types — Capacity (Azure reclaim) vs. Price (bid exceeded)
  - 1.4.1.2.1 Max price setting — -1 = never evict for price — only capacity
- 1.4.1.3 Scheduled Events — Preempt event — 30-second warning for Spot
  - 1.4.1.3.1 IMDS endpoint — http://169.254.169.254/metadata/scheduledevents

### 1.5 Azure Dedicated Hosts
#### 1.5.1 Dedicated Host Architecture
- 1.5.1.1 Physical server isolation — single customer — BYOL compliant
  - 1.5.1.1.1 Host group — availability zone + fault domain placement
  - 1.5.1.1.2 Auto-placement — distribute VMs across hosts in group
- 1.5.1.2 Maintenance control — defer platform updates up to 35 days
  - 1.5.1.2.1 Maintenance configuration — schedule window — reboot vs. live migration
