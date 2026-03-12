# GCP Complete Study Guide - Part 7: Containers & Serverless (Phase 1 — Ideal)

## 8.0 Container & Orchestration

### 8.1 Google Kubernetes Engine (GKE)
#### 8.1.1 GKE Control Plane
- 8.1.1.1 Fully managed control plane — Google-operated — etcd, API server, scheduler
  - 8.1.1.1.1 Standard tier — 99.95% SLA — Regional cluster = 99.95%, zonal = 99.5%
  - 8.1.1.1.2 Enterprise tier — 99.95% SLA — GKE Fleet + GKE Enterprise features
  - 8.1.1.1.3 Control plane endpoint — public or private — authorized networks
- 8.1.1.2 Private cluster — nodes no public IP — master authorized networks
  - 8.1.1.2.1 Private endpoint — API server in VPC — no public IP — most secure
  - 8.1.1.2.2 Cluster networking — master to node CIDR — /28 master range
- 8.1.1.3 Workload Identity — bind K8s SA to Google SA — preferred credentials method
  - 8.1.1.3.1 Workload Identity Federation for GKE — via WIF pool — more flexible
  - 8.1.1.3.2 Metadata server — GKE metadata server — intercept IMDS requests

#### 8.1.2 GKE Node Pools
- 8.1.2.1 Custom node pools — different machine types — labels + taints
  - 8.1.2.1.1 Node auto-provisioning (NAP) — create node pools on demand — Autopilot-like
  - 8.1.2.1.2 Node locations — spread across zones — regional cluster HA
- 8.1.2.2 Spot node pools — Spot VMs — 60–91% cheaper — eviction handling
  - 8.1.2.2.1 node.kubernetes.io/spot-vm taint — toleration required
- 8.1.2.3 Accelerator node pools — GPU/TPU — driver auto-installation
  - 8.1.2.3.1 NVIDIA GPU operator — device plugin — time-slicing config
  - 8.1.2.3.2 TPU node pools — v4/v5 slices — workload-based provisioning

#### 8.1.3 GKE Networking
- 8.1.3.1 VPC-native clusters — alias IPs — pods get VPC IPs — no overlay
  - 8.1.3.1.1 Secondary ranges — pod CIDR + service CIDR — pre-allocate
  - 8.1.3.1.2 Flexible Pod CIDR — per-node pod range from subnet secondary
- 8.1.3.2 Dataplane V2 — eBPF (Cilium-based) — replaces iptables — network policy
  - 8.1.3.2.1 FQDN network policy — egress filter by domain name — no IP management
  - 8.1.3.2.2 Advanced network policy — L7 — HTTP method/path rules
- 8.1.3.3 Gateway API — GKE Gateway controller — multi-cluster routing
  - 8.1.3.3.1 GatewayClass — gke-l7-global-external-managed — ALB-backed Gateway
  - 8.1.3.3.2 Multi-cluster Gateway — route across clusters — single gateway

#### 8.1.4 GKE Security
- 8.1.4.1 Binary Authorization — enforce container image policy — attestation
  - 8.1.4.1.1 Attestors — sign image — require attestation before deploy
  - 8.1.4.1.2 CV (Continuous Validation) — ongoing attestation — post-deploy checks
- 8.1.4.2 Config Connector — manage GCP resources via K8s CRDs
  - 8.1.4.2.1 GoogleSQL resource — create Cloud SQL via kubectl — GitOps-native
- 8.1.4.3 GKE Sandbox (gVisor) — userspace kernel — sandboxed containers
  - 8.1.4.3.1 RuntimeClass: gvisor — per-pod opt-in — stronger isolation
- 8.1.4.4 Shielded GKE nodes — Secure Boot + vTPM + integrity monitoring
  - 8.1.4.4.1 Integrity monitoring — compare vs. golden baseline — alert on change

#### 8.1.5 GKE Autoscaling
- 8.1.5.1 Horizontal Pod Autoscaler — CPU/memory/custom metrics — KEDA alternative
- 8.1.5.2 Vertical Pod Autoscaler — right-size requests/limits — recommendation mode
  - 8.1.5.2.1 Updatemode — Auto (restart), Recreate, Initial, Off (recommend only)
- 8.1.5.3 Cluster Autoscaler — add/remove nodes — pending pods trigger scale-out
  - 8.1.5.3.1 Scale-down delay — 10 minutes — utilization < 50% threshold
  - 8.1.5.3.2 Expander — most-pods / least-waste / price / priority / random
- 8.1.5.4 Multidimensional Pod Autoscaling — combine CPU HPA + memory VPA

### 8.2 GKE Autopilot
#### 8.2.1 Autopilot Architecture
- 8.2.1.1 Serverless K8s — no node management — pod-level billing — managed nodes
  - 8.2.1.1.1 Bill by pod vCPU + memory + ephemeral storage — per ms
  - 8.2.1.1.2 Auto-provisioned nodes — Compute Engine VMs — never visible to user
- 8.2.1.2 Security hardened — nodes not accessible — read-only root — no SSH
  - 8.2.1.2.1 Privileged pods blocked — hostPath volumes blocked — secure defaults
  - 8.2.1.2.2 Workload Identity enforced — no node SA access — per-pod identity
- 8.2.1.3 Resource classes — General Purpose, Balanced, Scale-Out, Performance, Accelerator
  - 8.2.1.3.1 Accelerator class — GPU/TPU — auto-provision accelerator nodes

### 8.3 Cloud Run
#### 8.3.1 Cloud Run Architecture
- 8.3.1.1 Fully managed serverless containers — scale to zero — 0→N in seconds
  - 8.3.1.1.1 Execution environment — 1st gen (sandbox) vs. 2nd gen (micro-VM, gVisor)
  - 8.3.1.1.2 Container instance — request concurrency 1–1000 — default 80
- 8.3.1.2 Revision-based deployment — named revisions — traffic splitting
  - 8.3.1.2.1 Gradual rollout — split % between revisions — canary/blue-green
  - 8.3.1.2.2 --no-traffic flag — deploy without receiving traffic — warm before shift
- 8.3.1.3 Min instances — pre-warmed — eliminate cold start for latency-sensitive
  - 8.3.1.3.1 CPU always allocated — billed even idle — tradeoff vs. min-instances=0
- 8.3.1.4 Direct VPC egress — bypass VPC connector — native VPC networking
  - 8.3.1.4.1 VPC connector (legacy) — small VMs — bottleneck at scale
  - 8.3.1.4.2 Direct VPC egress — no connector — same speed as Compute Engine

---

## 9.0 Serverless Computing

### 9.1 Cloud Functions
#### 9.1.1 Cloud Functions Generations
- 9.1.1.1 1st gen — App Engine-based — 1 request per instance — legacy
- 9.1.1.2 2nd gen — Cloud Run-based — concurrency up to 1000 — 1GB default
  - 9.1.1.2.1 eventarc triggers — any Cloud Event — broader trigger surface
  - 9.1.1.2.2 Up to 60 min timeout — vs. 9 min for 1st gen
  - 9.1.1.2.3 1GB to 32GB RAM — up to 8 vCPUs — larger compute than 1st gen

#### 9.1.2 Function Triggers
- 9.1.2.1 HTTP triggers — HTTPS — authenticated or unauthenticated
- 9.1.2.2 Pub/Sub triggers — push subscription — wrapped Cloud Event
- 9.1.2.3 Cloud Storage triggers — Eventarc — finalize/delete/archive/metadataUpdate
- 9.1.2.4 Firestore triggers — document create/update/delete/write
- 9.1.2.5 Firebase triggers — Auth, Realtime Database, Analytics events

### 9.2 Cloud Run Jobs
#### 9.2.1 Cloud Run Jobs Architecture
- 9.2.1.1 Batch workloads — no HTTP traffic — run to completion — no server needed
  - 9.2.1.1.1 Task count + parallelism — split work across task instances
  - 9.2.1.1.2 CLOUD_RUN_TASK_INDEX + CLOUD_RUN_TASK_COUNT — env vars per task
- 9.2.1.2 Triggers — manual, Cloud Scheduler, Workflows, Eventarc
  - 9.2.1.2.1 --execute-now — immediate run — debugging/ad-hoc

### 9.3 Google Cloud Workflows
#### 9.3.1 Workflows Architecture
- 9.3.1.1 Serverless orchestration — YAML/JSON syntax — stateful execution
  - 9.3.1.1.1 Steps — sequential or parallel — assign, call, switch, for, try/except
  - 9.3.1.1.2 HTTP calls — any endpoint — auth with OIDC/OAuth tokens — inline
- 9.3.1.2 Connectors — GCP service integrations — BigQuery, GCS, Pub/Sub — generated
  - 9.3.1.2.1 No code — call connector step — auto-retry + polling built-in
  - 9.3.1.2.2 Await pattern — long-running job — poll for completion built-in
- 9.3.1.3 Callbacks — pause workflow — wait for external event — resume
  - 9.3.1.3.1 Callback endpoint — HTTPS — receive external signal — Pub/Sub or HTTP
  - 9.3.1.3.2 Human-in-the-loop — approval workflow — await callback before proceed
- 9.3.1.4 Parallel iteration — parallel.for — concurrency limit — map over list
  - 9.3.1.4.1 Shared variables — concurrency conflict — use branches + merge
