# OCI Complete Study Guide - Part 15: Phase 2 — DevOps, Governance, Cost & Hybrid

## 19.0 OCI DevOps & IaC

### 19.1 OCI DevOps Service-Unique Features
→ See Ideal §9.1 OCI DevOps, §9.2 Resource Manager

#### 19.1.1 OCI DevOps-Unique Features
- **Unique: Fully managed CI/CD on OCI** — no Jenkins/GitHub Actions needed — OCI native
  - 19.1.1.1 Build + Deploy in one service — integrated pipeline — no external orchestrator
  - 19.1.1.2 Managed build runner — Oracle Linux — OCI-hosted — no self-hosted agents
- **Unique: build_spec.yaml** — OCI-specific build spec — steps + outputArtifacts
  - 19.1.1.3 exportedVariables — pass values between stages — pipeline coordination
  - 19.1.1.4 Docker Layer Caching — OCI-native — faster Docker builds — same runner
- **Unique: Mirror from GitHub/GitLab** — sync schedule — cross-repo triggers
  - 19.1.1.5 GitLab / GitHub webhook → OCI build trigger — dual-SCM strategy
- **Unique: Deploy to OCI targets** — OKE / Functions / Instance Group / Container Instances
  - 19.1.1.6 Helm chart deployment to OKE — artifact + override values — managed rollout
  - 19.1.1.7 Instance group rolling deploy — tag-based — concurrency + health check gate
- **Unique: Blue/Green + Canary strategies** — built-in — traffic shift via LB
  - 19.1.1.8 OCI LB traffic shift — A/B deployment — no Istio required for basic canary

#### 19.1.2 Resource Manager-Unique Features
- **Unique: Managed Terraform state** — OCI-hosted — no S3 backend config — simple
  - 19.1.2.1 State locking — concurrent jobs blocked — prevent corruption
  - 19.1.2.2 State version history — rollback to prior state — audit trail
- **Unique: Drift detection** — built-in — compare stack vs. actual resources — MODIFIED
  - 19.1.2.3 Schedule drift detection — periodic — alert on unauthorized change
- **Unique: Template catalog** — OCI reference architectures — one-click deploy
  - 19.1.2.4 Architecture templates — 3-tier web app, DR pattern, VCN Hub-and-Spoke
- **Unique: OCI Terraform Provider** — official — all OCI services — OCID-aware
  - 19.1.2.5 Resource discovery — import existing infra into Terraform state

---

## 20.0 OCI Governance & Cost

### 20.1 Governance-Unique Features
→ See Ideal §9.3 Compartment & Tag Governance, §9.4 Cost Management

#### 20.1.1 Compartment + Tag Governance-Unique Features
- **Unique: Tag defaults** — auto-apply tags on resource creation — no user action needed
  - 20.1.1.1 Required tags — enforce cost-center + environment tag — API-level block
  - 20.1.1.2 Tag namespace locking — prevent tag schema changes — compliance freeze
- **Unique: Tag-based IAM conditions** — policy gate on resource tags — ABAC
  - 20.1.1.3 Allow if target.resource.tag.CostCenter = 'Engineering' — team isolation
- **Unique: Compartment quotas** — max N instances per compartment — guardrails
  - 20.1.1.4 Quota policies — same language as IAM — limit resource type + count
  - 20.1.1.5 Zero-quota compartment — prevent any resource creation — sandbox lockdown

#### 20.1.2 Cost Management-Unique Features
- **Unique: Annual Universal Credits** — commit to $ annually — any OCI service — flexible
  - 20.1.2.1 No SKU lock-in — use credits for DB + Compute + Storage + AI — fluid
  - 20.1.2.2 Credit pooling — enterprise agreement — multiple tenancies draw from pool
- **Unique: Usage Reports** — hourly CSV — per OCID — Object Storage auto-export
  - 20.1.2.3 15 months retention — automatic — query with Athena/BQ/ADB — reconcile
- **Unique: Always Free** — 2 AMD micro instances + ADB + Object Storage + Load Balancer
  - 20.1.2.4 Perpetual free tier — no expiry — dev/test — most generous in industry
- **Unique: OCI Cost Estimation tool** — pre-deployment estimate — interactive — export PDF
  - 20.1.2.5 Rate calculator — shape + storage + data transfer — accurate pre-project

---

## 21.0 Hybrid — Roving Edge & Exadata Cloud@Customer

### 21.1 Hybrid-Unique Features
→ See Ideal §9.5 Hybrid, Roving Edge, ExaCC

#### 21.1.1 Roving Edge-Unique Features
- **Unique: OCI Roving Edge Device** — portable OCI — no connectivity required — air-gap
  - 21.1.1.1 Offline operation — Compute + Object Storage + OKE + Functions — full stack
  - 21.1.1.2 Sync to OCI — reconnect → Object Storage sync → reconcile state
  - 21.1.1.3 Military/disaster use case — ship to remote location — deploy OCI workloads
- **Unique: Roving Edge Cluster** — multiple REDs — local cluster — expanded capacity
  - 21.1.1.4 OKE on cluster — distributed K8s — edge-native orchestration

#### 21.1.2 Exadata Cloud@Customer-Unique Features
- **Unique: OCI-managed ExaDB in customer DC** — OCI control plane — data stays on-prem
  - 21.1.2.1 Same APIs as OCI ExaDB — identical developer experience — no retraining
  - 21.1.2.2 Autonomous DB on ExaCC — serverless on-prem — data sovereignty + ADB features
- **Unique: Network control plane separation** — management over HTTPS to OCI — data never leaves
  - 21.1.2.3 Customer controls data network — no management traffic carries data
  - 21.1.2.4 Air-gap option — one-way firewall — management OK — data fully isolated
- **Unique: Oracle Zero Data Loss Autonomous Recovery Service** — ExaCC backup to OCI
  - 21.1.2.5 Real-time redo log upload — RPO near-zero — automatic recovery — no DBA
  - 21.1.2.6 Protected databases — charged per protected DB TB — SLA-backed recovery
