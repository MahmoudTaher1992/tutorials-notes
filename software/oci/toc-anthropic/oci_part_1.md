# OCI Complete Study Guide - Part 1: Phase 1 — Core Compute

## Phase 1: The Ideal Cloud Compute Platform

---

## 1.0 Core Compute

### 1.1 VM Lifecycle & Shapes
#### 1.1.1 Instance Lifecycle States
- 1.1.1.1 PROVISIONING — hardware allocated — VNIC attached — boot volume cloned
  - 1.1.1.1.1 Image pull — platform image / custom image / marketplace
  - 1.1.1.1.2 Cloud-init — user data — first-boot config — package installs
- 1.1.1.2 RUNNING → STOPPING → STOPPED — soft shutdown vs. force stop
  - 1.1.1.2.1 Graceful shutdown — ACPI signal — OS shutdown — 15-minute timeout
  - 1.1.1.2.2 Force stop — hypervisor kill — in-flight I/O risk
- 1.1.1.3 TERMINATING — boot volume detach — VNIC deallocated — public IP released
  - 1.1.1.3.1 Keep boot volume — preserve-boot-volume=true — reattach scenario
- 1.1.1.4 Instance metadata service (IMDS) — http://169.254.169.254 — v2 token auth
  - 1.1.1.4.1 IMDSv2 — PUT token first — TTL-bound — prevent SSRF exploitation
  - 1.1.1.4.2 Dynamic groups — instance principal — IMDS-backed — keyless auth

#### 1.1.2 Fault Domains & Availability Domains
- 1.1.2.1 Availability Domain (AD) — physically independent DC — per region (1–3 ADs)
  - 1.1.2.1.1 AD isolation — separate power + cooling + networking — blast radius control
  - 1.1.2.1.2 Single-AD regions — most OCI regions — no cross-AD replication guarantee
- 1.1.2.2 Fault Domain (FD) — logical grouping within AD — 3 FDs per AD
  - 1.1.2.2.1 Anti-affinity — spread instances across FDs — tolerate hardware failure
  - 1.1.2.2.2 FD assignment — explicit or OCI auto-spread — instance pool aware

### 1.2 Shape Types
#### 1.2.1 Flexible Shapes (VM.Standard.E4.Flex, E5.Flex, A1.Flex)
- 1.2.1.1 OCPU + Memory slider — 1 OCPU = 1 physical core thread (AMD/ARM)
  - 1.2.1.1.1 E4.Flex — AMD EPYC Milan — 1–114 OCPUs — 1–1760 GB RAM
  - 1.2.1.1.2 A1.Flex — Ampere Altra ARM — 1–80 OCPUs — cheapest per OCPU
  - 1.2.1.1.3 E5.Flex — AMD EPYC Genoa — next-gen — higher memory bandwidth
- 1.2.1.2 Network bandwidth — scales with OCPU count — max 40 Gbps
  - 1.2.1.2.1 1 Gbps per OCPU — up to max shape limit — predictable scaling

#### 1.2.2 GPU Shapes
- 1.2.2.1 VM.GPU3.x — NVIDIA V100 — 1/2/4 GPUs — ML training
  - 1.2.2.1.1 NVLink — GPU-to-GPU — 300 GB/s — multi-GPU training
- 1.2.2.2 BM.GPU4.8 — NVIDIA A100 — 8 GPUs — 640 GB HBM2e — LLM training
  - 1.2.2.2.1 RDMA cluster network — 1.6 Tbps — bare metal — no hypervisor overhead
- 1.2.2.3 BM.GPU.H100.8 — NVIDIA H100 SXM5 — 8 GPUs — 3.35 TB/s bandwidth
  - 1.2.2.3.1 NVSwitch — all-to-all GPU fabric — 900 GB/s NVLink per GPU

#### 1.2.3 High-Performance Computing (HPC) Shapes
- 1.2.3.1 BM.HPC2.36 — Intel Xeon Skylake — 36 cores — 25 Gbps RDMA
  - 1.2.3.1.1 RDMA cluster network — low-latency — MPI workloads — tight coupling
  - 1.2.3.1.2 Cluster placement groups — physical proximity — latency < 2 µs

#### 1.2.4 Bare Metal (BM) Shapes
- 1.2.4.1 BM.Standard — dedicated physical host — no hypervisor — full CPU/RAM
  - 1.2.4.1.1 SR-IOV NIC — direct PCIe passthrough — bare-metal network performance
  - 1.2.4.1.2 Local NVMe — BM.DenseIO — 51.2 TB NVMe — Ceph/Cassandra use case

### 1.3 Instance Pools & Autoscaling
#### 1.3.1 Instance Configurations & Pools
- 1.3.1.1 Instance configuration — template — shape + image + metadata + VNIC
  - 1.3.1.1.1 Secondary VNIC in config — multi-homed instances at launch
  - 1.3.1.1.2 Cloud-init user data — baked into config — immutable per config version
- 1.3.1.2 Instance pool — N instances from config — AD/FD spread — lifecycle managed
  - 1.3.1.2.1 Pool RUNNING state — replace unhealthy — maintain desired count
  - 1.3.1.2.2 Attach load balancer backend set — auto-register instances on create

#### 1.3.2 Autoscaling Configurations
- 1.3.2.1 Metric-based autoscaling — CPU utilization — scale out/in thresholds
  - 1.3.2.1.1 Cooldown period — seconds before re-evaluate — prevent thrash
  - 1.3.2.1.2 Min/max/initial capacity — hard bounds — cost protection
- 1.3.2.2 Schedule-based autoscaling — cron — predictive scale — known traffic patterns
  - 1.3.2.2.1 Multiple schedules — business hours vs. off-hours — cost optimization

### 1.4 Preemptible Instances & Capacity Reservations
#### 1.4.1 Preemptible Instances
- 1.4.1.1 Spot-equivalent — up to 50% cheaper — reclaimed with 30-second notice
  - 1.4.1.1.1 PreemptionAction — TERMINATE — no hibernate option on OCI
  - 1.4.1.1.2 Batch workloads — fault-tolerant — checkpointing required

#### 1.4.2 Capacity Reservations
- 1.4.2.1 On-demand capacity reservation — reserve without launching instances
  - 1.4.2.1.1 Reserved capacity billed at On-Demand rate whether used or not
  - 1.4.2.1.2 AD-scoped — reserve in specific AD — critical for DR scenarios

### 1.5 Dedicated VM Hosts
#### 1.5.1 Dedicated Host Architecture
- 1.5.1.1 DVH.Standard — physical server — tenant-exclusive — no co-tenancy
  - 1.5.1.1.1 BYOL compliance — licensing requires dedicated — SQL Server/Oracle DB
  - 1.5.1.1.2 Remaining capacity — pack multiple VMs — same shape family required
- 1.5.1.2 DVH placement — specify at instance launch — AD + FD assignment
  - 1.5.1.2.1 Live migration between DVHs — same AD only — host maintenance
