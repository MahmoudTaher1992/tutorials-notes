# AWS Complete Study Guide - Part 1: Core Compute & Infrastructure (Phase 1 — Ideal)

## 1.0 Core Compute & Infrastructure

### 1.1 Virtual Machine Lifecycle
#### 1.1.1 Provisioning Pipeline
- 1.1.1.1 Hardware Resource Allocation — NUMA node assignment, physical CPU pinning
  - 1.1.1.1.1 Physical-to-virtual CPU mapping — vCPU threads vs. hyperthreading cores
  - 1.1.1.1.2 Memory balloon driver — dynamic DRAM reclamation from idle VMs
- 1.1.1.2 Hypervisor Configuration — Type-1 bare-metal KVM/Xen/Nitro
  - 1.1.1.2.1 Nitro System architecture — dedicated offload card for EBS/network/security
  - 1.1.1.2.2 SR-IOV — Single Root I/O Virtualization — direct PCIe NIC assignment
- 1.1.1.3 Boot Sequence — UEFI → bootloader → kernel init → cloud-init
  - 1.1.1.3.1 cloud-init phases — detect, network, config, final
  - 1.1.1.3.2 User data injection — base64 encoded, 16KB hard limit

#### 1.1.2 Instance State Machine
- 1.1.2.1 Pending → Running → Stopping → Stopped → Terminated transitions
  - 1.1.2.1.1 Hibernate — flush RAM to EBS, resume without cold boot
  - 1.1.2.1.2 Hibernate prerequisites — EBS root, ≤150GB RAM, encrypted EBS required
- 1.1.2.2 Reboot vs Stop/Start — same host vs. possible host migration
  - 1.1.2.2.1 Instance store data loss on stop — ephemeral NVMe wiped

#### 1.1.3 Placement & Affinity
- 1.1.3.1 Placement Groups — cluster, spread, partition
  - 1.1.3.1.1 Cluster PG — same rack, <10μs latency, single AZ constraint
  - 1.1.3.1.2 Spread PG — distinct racks, max 7 instances per AZ per group
  - 1.1.3.1.3 Partition PG — rack isolation for HDFS/Cassandra, max 7 partitions/AZ
- 1.1.3.2 Host Affinity — dedicated host vs. dedicated instance
  - 1.1.3.2.1 BYOL socket/core licensing — dedicated host physical binding

### 1.2 Instance Types & Hardware Classes
#### 1.2.1 CPU Architectures
- 1.2.1.1 x86_64 Intel (Ice Lake, Sapphire Rapids) — Turbo Boost, AVX-512
  - 1.2.1.1.1 Intel AMX — matrix multiply tile extensions for ML inference
- 1.2.1.2 x86_64 AMD (EPYC Milan/Genoa) — Zen 3/4, higher core density
  - 1.2.1.2.1 AMD Infinity Fabric — NUMA cross-CCD memory latency penalty
- 1.2.1.3 ARM Graviton 3/4 — custom Neoverse N2, 40% better perf/watt
  - 1.2.1.3.1 SVE — Scalable Vector Extension — variable-width SIMD operations
  - 1.2.1.3.2 LSE atomics — lock-free data structures, CAS without LL/SC overhead

#### 1.2.2 Memory-Optimized Classes
- 1.2.2.1 R-family (r8g) — up to 3TB RAM — in-memory databases (Redis, SAP)
  - 1.2.2.1.1 DRAM ECC — error correction overhead ~1.5% bandwidth
- 1.2.2.2 X-family (x2idn) — up to 24TB — SAP HANA certified
  - 1.2.2.2.1 Local NVMe SSD — sub-100μs latency for swap/temp tablespace
- 1.2.2.3 High Memory (u-*tb1) — 6TB/9TB/12TB for extreme OLAP workloads

#### 1.2.3 GPU & Accelerator Classes
- 1.2.3.1 P-family (p5.48xlarge) — NVIDIA H100 SXM5, NVLink 900GB/s
  - 1.2.3.1.1 NVLink topology — all-to-all GPU bandwidth, bypasses PCIe
  - 1.2.3.1.2 GPUDirect RDMA — GPU-to-GPU across nodes without CPU involvement
- 1.2.3.2 G-family (g6) — NVIDIA L4/L40S — inference & video transcoding
- 1.2.3.3 Inf-family (inf2) — AWS Inferentia2 — transformer inference chips
  - 1.2.3.3.1 NeuronCore-v2 — systolic array for matrix multiply (GeMM)
  - 1.2.3.3.2 AWS Neuron SDK — XLA/PyTorch → NeuronCore compilation pipeline
- 1.2.3.4 Trn-family (trn1) — AWS Trainium — cost-optimized distributed training

#### 1.2.4 Network & Storage Optimized
- 1.2.4.1 C-family (c7g) — compute-optimized, 30Gbps ENA Express
  - 1.2.4.1.1 ENA Express — Scalable Reliable Datagram — sub-20μs p99 latency
- 1.2.4.2 I-family (i4i) — NVMe-optimized — up to 30TB local NVMe
- 1.2.4.3 D-family (d3en) — dense HDD — 336TB local spinning disk, MapReduce

### 1.3 Auto Scaling Mechanisms
#### 1.3.1 Horizontal Scaling Policies
- 1.3.1.1 Target Tracking — maintain CloudWatch metric at target value
  - 1.3.1.1.1 Cooldown period — default 300s — prevents scale-out thrashing
  - 1.3.1.1.2 Scale-in protection — per-instance flag prevents unwanted termination
- 1.3.1.2 Step Scaling — multiple adjustment steps at different breach thresholds
  - 1.3.1.2.1 Warm-up period — exclude new instances from aggregate metrics during boot
- 1.3.1.3 Simple Scaling — single add/remove on CloudWatch alarm (legacy, avoid)

#### 1.3.2 Predictive Scaling
- 1.3.2.1 ML-based forecast — 14-day historical CloudWatch pattern analysis
  - 1.3.2.1.1 Forecast accuracy scoring — MAD/MAPE metrics
  - 1.3.2.1.2 Pre-scaling lead time — default 5 minutes ahead of predicted load
- 1.3.2.2 Scheduled Scaling — cron-based min/max/desired override

#### 1.3.3 Lifecycle Hooks
- 1.3.3.1 Launch Hook — pause instance before InService — run bootstrap scripts
  - 1.3.3.1.1 Heartbeat timeout — default 1 hour — CompleteLifecycleAction required
- 1.3.3.2 Termination Hook — drain LB connections before instance termination
  - 1.3.3.2.1 Connection draining deregistration delay — default 300s

#### 1.3.4 Warm Pools
- 1.3.4.1 Pre-initialized stopped/running instances — faster scale-out response
  - 1.3.4.1.1 Reuse policy — return terminated instances to warm pool to save costs
  - 1.3.4.1.2 Hibernate warm pool — fastest response — RAM preserved on EBS

### 1.4 Bare Metal & Dedicated Hosts
#### 1.4.1 Bare Metal Instances (*.metal)
- 1.4.1.1 No hypervisor — direct hardware access, full CPU feature exposure
  - 1.4.1.1.1 Use cases — VMware Cloud on AWS, nested virtualization, custom hypervisors
- 1.4.1.2 Full PMU access — perf counters, CPUID, hardware watchpoints

#### 1.4.2 Dedicated Hosts
- 1.4.2.1 Physical server isolation — per-socket/core billing for BYOL compliance
  - 1.4.2.1.1 Host resource groups — pool management at AWS Organizations level
  - 1.4.2.1.2 Auto-placement toggle — enable/disable for new instance binding

### 1.5 Spot & Preemptible Instance Economics
#### 1.5.1 Spot Pricing Model
- 1.5.1.1 Capacity pool pricing — independent price per AZ per instance type
  - 1.5.1.1.1 Price history API — 3-month lookback — spot price volatility analysis
  - 1.5.1.1.2 Typical savings — 70–90% vs. On-Demand for interruptible workloads
- 1.5.1.2 Interruption signals — 2-minute warning via Instance Metadata Service
  - 1.5.1.2.1 IMDS polling — /latest/meta-data/spot/instance-action endpoint
  - 1.5.1.2.2 EventBridge integration — EC2 Spot Instance Interruption Warning event

#### 1.5.2 Spot Fleet & EC2 Fleet Strategies
- 1.5.2.1 Capacity-Optimized — select pools with highest available capacity
- 1.5.2.2 Diversified — spread across multiple pools for fault tolerance
- 1.5.2.3 Price-Capacity-Optimized — weighted balance of cost and interruption risk
  - 1.5.2.3.1 Allocation weight — normalize vCPU/memory across heterogeneous types
