# GCP Complete Study Guide - Part 12: Phase 2 — IAM, Cloud Functions, GKE

## 24.0 GCP IAM

### 24.1 IAM Core
→ See Ideal §5.1 IAM Principals & Roles, §5.2 Workload Identity Federation

#### 24.1.1 IAM-Unique Features
- **Unique: IAM Recommender** — ML-based — remove excess permissions
  - 24.1.1.1 Analyzes last 90-day usage — suggest least-privilege replacement role
  - 24.1.1.2 Confidence level — HIGH/MEDIUM/LOW — only apply HIGH safely
  - 24.1.1.3 Policy Insights — unused role bindings — stale service accounts
- **Unique: IAM Deny Policies** — explicit deny — override any allow
  - 24.1.1.4 DenyRule — deniedPermissions + exceptionPrincipals + denialCondition
  - 24.1.1.5 Evaluated after allow — deny wins — org-level protective guardrails
- **Unique: Workforce Identity Federation** — external IdP → Google credentials — no Google account
  - 24.1.1.6 Attribute mapping — CEL — map SAML assertions to Google attributes
  - 24.1.1.7 Workforce pool — Okta/Azure AD/ADFS — SAML or OIDC
  - 24.1.1.8 Google Cloud console access — IdP users access console directly
- **Unique: Workload Identity Pool** — AWS/Azure/GitHub → GCP credentials — keyless auth
  - 24.1.1.9 GitHub Actions — no GCP SA key — WIF exchange — federated token
  - 24.1.1.10 AWS EC2 instance — exchange AWS credentials for GCP — cross-cloud
- **Unique: Service Account impersonation** — generate short-lived tokens — no key
  - 24.1.1.11 roles/iam.serviceAccountTokenCreator — generateAccessToken API
  - 24.1.1.12 Chained impersonation — SA-A impersonates SA-B — audit trail maintained
- **Unique: VPC Service Controls perimeter** — restrict Google APIs per VPC
  - 24.1.1.13 Service perimeter — block BigQuery/GCS API from outside perimeter
  - 24.1.1.14 Access levels — trusted IPs + devices — allow external exceptions

---

## 25.0 Cloud Functions

### 25.1 Cloud Functions Core
→ See Ideal §9.1 Serverless Functions, §9.1.1 Generations

#### 25.1.1 Cloud Functions-Unique Features
- **Unique: 2nd gen on Cloud Run** — same infrastructure — full Cloud Run features
  - 25.1.1.1 Request concurrency up to 1000 — multiple requests per instance
  - 25.1.1.2 60-minute timeout — vs. 9 minutes for 1st gen — long-running tasks
  - 25.1.1.3 32GB RAM / 8 vCPU — larger than 1st gen — ML inference possible
- **Unique: Eventarc triggers** — any GCP Audit Log event → function trigger
  - 25.1.1.4 Trigger on any GCP API call — BigQuery job complete, GCS create, etc.
  - 25.1.1.5 Pub/Sub + direct triggers — broader than Lambda event source mappings
- **Unique: Secret Manager integration** — mount secrets as env vars or volumes
  - 25.1.1.6 Secret version — latest or pinned — auto-refresh with volume mount
- **Unique: Concurrency per instance** — 2nd gen — set max-instance-request-concurrency
  - 25.1.1.7 Share warm instances across requests — reduce cold starts proportionally
- **Unique: Cloud Functions Framework** — open-source — local dev + portability
  - 25.1.1.8 Same framework as Cloud Run — functions.framework.php/node/python
  - 25.1.1.9 Local emulation — functions-framework --target=myFunction — docker-free
- **Unique: min-instances with CPU boost** — startup CPU boost — faster cold start
  - 25.1.1.10 Extra CPU during init — 2x vCPU during function init — reduce startup

---

## 26.0 Google Kubernetes Engine (GKE)

### 26.1 GKE Core
→ See Ideal §8.1 GKE Control Plane, §8.1.2 Node Pools, §8.1.3 Networking, §8.2 Autopilot

#### 26.1.1 GKE-Unique Features
- **Unique: GKE Autopilot** — serverless K8s — no node management — pod-level billing
  - 26.1.1.1 Pod billing — vCPU + memory + ephemeral storage — per millisecond
  - 26.1.1.2 Hardened security — no privileged pods, no hostPath, Workload Identity enforced
  - 26.1.1.3 Resource classes — Performance (GPU), Accelerator (TPU) — pod annotation
- **Unique: Dataplane V2 (eBPF/Cilium)** — replace kube-proxy — L7 network policy
  - 26.1.1.4 FQDN network policy — egress filter by domain — no IP management
  - 26.1.1.5 Hubble observability — pod-to-pod flow visibility — no sidecar required
  - 26.1.1.6 KubeProxy replacement — eBPF socket map — sub-ms service lookup
- **Unique: GKE Enterprise (Fleet)** — multi-cluster management — uniform policy
  - 26.1.1.7 Fleet scopes — logical grouping — apply Config Sync per scope
  - 26.1.1.8 Multi-cluster Services (MCS) — ServiceExport/ServiceImport — cross-cluster DNS
  - 26.1.1.9 Multi-cluster Gateway — global load balancer — span backend across clusters
- **Unique: Binary Authorization** — require image attestation — supply chain security
  - 26.1.1.10 Policy — require attestation from Artifact Analysis or custom attestors
  - 26.1.1.11 Continuous Validation (CV) — ongoing re-evaluation — post-deploy protection
- **Unique: Config Connector** — manage GCP resources as K8s CRDs
  - 26.1.1.12 SQLInstance CRD — declare Cloud SQL in YAML — GitOps infrastructure
  - 26.1.1.13 IAMPolicy CRD — manage GCP IAM from K8s — consistent tooling
- **Unique: GKE Sandbox (gVisor)** — userspace kernel — strong workload isolation
  - 26.1.1.14 RuntimeClass: gvisor — per-pod opt-in — syscall interception
  - 26.1.1.15 Compatible runtimes — runsc — drop-in replacement for runc
- **Unique: TPU workloads on GKE** — v4/v5 TPU node pools — JAX/PyTorch
  - 26.1.1.16 TPU slice — partition of TPU Pod — v5e-8 = 8-chip slice
  - 26.1.1.17 TopologyAwareScheduling — place pods on topologically optimal nodes
- **Unique: Vertical Pod Autoscaler** — right-size CPU/mem requests — in-place resize
  - 26.1.1.18 In-place pod resize (K8s 1.27+) — no restart for CPU — restart for mem
- **Unique: Node auto-provisioning (NAP)** — auto-create node pools — Autopilot-like on Standard
  - 26.1.1.19 Machine type selection — best fit for pending pod requests
  - 26.1.1.20 GPU node auto-provisioning — request GPU in pod spec → pool created
