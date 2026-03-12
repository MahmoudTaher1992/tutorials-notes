# GCP Complete Study Guide - Part 9: DevOps, Cost, Compliance & Hybrid (Phase 1 — Ideal)

## 12.0 DevOps & Infrastructure as Code

### 12.1 Cloud Build
#### 12.1.1 Cloud Build Architecture
- 12.1.1.1 Managed CI — Docker-based — YAML build config — serverless
  - 12.1.1.1.1 Build steps — sequential or parallel — any container as step
  - 12.1.1.1.2 Build machines — e2-medium default — up to n1-highcpu-32 — custom workers
- 12.1.1.2 Triggers — push to branch/tag, PR, manual, Pub/Sub, webhook
  - 12.1.1.2.1 Included/excluded files — regex — only trigger on relevant changes
  - 12.1.1.2.2 Build approval — require manual approval before execution — prod gate
- 12.1.1.3 Private pools — dedicated workers — VPC-connected — on-prem access
  - 12.1.1.3.1 WorkerPool — specify machine type + disk size — consistent builds
  - 12.1.1.3.2 No public IP — egress via NAT — private artifact + source access
- 12.1.1.4 Build caching — GCS bucket — layer caching — 85% faster rebuilds
  - 12.1.1.4.1 Kaniko cache — intermediate layers — inject via --cache flag
  - 12.1.1.4.2 Docker layer caching — BuildKit — only on private pools

### 12.2 Cloud Deploy
#### 12.2.1 Cloud Deploy Architecture
- 12.2.1.1 Managed continuous delivery — pipeline → targets — GKE/Cloud Run/Anthos
  - 12.2.1.1.1 Delivery pipeline — ordered sequence of targets — promote through stages
  - 12.2.1.1.2 Release — immutable artifact bundle — deployed to targets
- 12.2.1.2 Rollouts — deployment to a single target — lifecycle: pending → in-progress → success/failure
  - 12.2.1.2.1 Approval gates — require approver before promotion to next stage
  - 12.2.1.2.2 Deploy parameters — override per target — environment-specific config
- 12.2.1.3 Canary deployments — % traffic shift — automated canary analysis
  - 12.2.1.3.1 Verify phase — Cloud Monitoring or custom — pass/fail before advance
  - 12.2.1.3.2 Rollback — one click — previous successful release

### 12.3 Artifact Registry
#### 12.3.1 Artifact Registry Features
- 12.3.1.1 Managed package registry — Docker, Maven, npm, Python, Go, apt, yum
  - 12.3.1.1.1 Region-specific — choose co-located with build/deploy — reduce latency
  - 12.3.1.1.2 IAM per repo — roles/artifactregistry.reader/writer/admin
- 12.3.1.2 Remote repos — proxy public registries — Docker Hub, Maven Central, PyPI
  - 12.3.1.2.1 Cache in Artifact Registry — reduce public egress — vulnerability scan
  - 12.3.1.2.2 Upstream policy — priority order — internal first then remote
- 12.3.1.3 Vulnerability scanning — Container Analysis — CVE database
  - 12.3.1.3.1 On-push scanning — trigger on image push — block if critical CVEs

### 12.4 Config Sync & Policy Controller
#### 12.4.1 Config Sync (GitOps)
- 12.4.1.1 GitOps for GKE — sync K8s manifests from Git to clusters
  - 12.4.1.1.1 RootSync + RepoSync — cluster-wide + namespace-scoped sync
  - 12.4.1.1.2 Reconciliation interval — periodic sync — drift detection + correction
- 12.4.1.2 Policy Controller — OPA Gatekeeper — enforce constraints on K8s resources
  - 12.4.1.2.1 Constraint templates — Rego — define policy logic
  - 12.4.1.2.2 Constraint — instantiate template — scope to namespaces + exclusions

---

## 13.0 Cost Management & FinOps

### 13.1 Pricing Models
#### 13.1.1 On-Demand, CUDs, SUDs
- 13.1.1.1 On-Demand — per-second billing (1-min minimum) — maximum flexibility
- 13.1.1.2 Sustained Use Discounts (SUDs) — automatic — no commitment required
  - 13.1.1.2.1 25% off at 100% usage — linear increments — CPU + RAM separate
  - 13.1.1.2.2 Only for N1/N2/N2D/C2/C2D/M1/M2 — not for Spot or E2
- 13.1.1.3 Committed Use Discounts (CUDs) — 1/3-year — resource-based or spend-based
  - 13.1.1.3.1 Resource CUD — specific vCPU + memory — up to 57% off
  - 13.1.1.3.2 Spend CUD — commit to $X/hr — flexible — any eligible resource
  - 13.1.1.3.3 CUD sharing — resource pool across project family — optimize utilization
- 13.1.1.4 Spot VMs — up to 91% cheaper — interruption risk — batch/fault-tolerant

### 13.2 Billing & Budget Alerts
#### 13.2.1 Billing Architecture
- 13.2.1.1 Billing account — linked to projects — 1:N — org-level billing
  - 13.2.1.1.1 Sub-accounts — reseller — billing hierarchy
  - 13.2.1.1.2 Invoicing vs. self-serve — enterprise contracts — credits management
- 13.2.1.2 Budgets + alerts — threshold % notifications — Pub/Sub programmatic action
  - 13.2.1.2.1 Budget alert thresholds — 50/90/100/110% — actual vs. forecasted
  - 13.2.1.2.2 Pub/Sub notification — trigger Cloud Function — cap billing automatically
- 13.2.1.3 Billing export — BigQuery — detailed + pricing + resource datasets
  - 13.2.1.3.1 Detailed usage — hourly — resource labels — tag-based allocation
  - 13.2.1.3.2 FinOps analysis — SQL on BQ export — cost per label, per project

### 13.3 Recommender & Active Assist
- 13.3.1.1 Idle VM recommender — p50 CPU < 5% → downsize or delete
- 13.3.1.2 Right-size recommender — overprovisioned — 95th percentile sizing
- 13.3.1.3 CUD recommender — analyze usage patterns → recommend commitments
  - 13.3.1.3.1 Estimated savings — based on historical spend + growth trend

---

## 14.0 Compliance & Governance

### 14.1 Resource Hierarchy
#### 14.1.1 Organization → Folder → Project → Resource
- 14.1.1.1 Organization node — root — created when Workspace domain used with GCP
  - 14.1.1.1.1 Organization Admin — roles/resourcemanager.organizationAdmin
- 14.1.1.2 Folders — department/team grouping — inherit parent IAM + org policies
  - 14.1.1.2.1 Max 10 folder levels deep — practical limit
- 14.1.1.3 Projects — billing + API + quota scope — 30 character project ID (immutable)
  - 14.1.1.3.1 Project lifecycle — ACTIVE → DELETE_REQUESTED → DELETE_IN_PROGRESS → DELETED
  - 14.1.1.3.2 30-day recycle bin — restore deleted project — before permanent deletion

### 14.2 Organization Policy Service
- 14.2.1.1 Constraints — boolean or list — restrict resource configs
  - 14.2.1.1.1 compute.vmExternalIpAccess — block external IPs org-wide
  - 14.2.1.1.2 iam.allowedPolicyMemberDomains — restrict IAM members to corp domain
- 14.2.1.2 Custom org constraints — CUSTOM — any resource field — CEL expression
  - 14.2.1.2.1 resource.name, resource.type, resource.labels — condition-based
- 14.2.1.3 Tags — org policy conditions — resource.hasTagKey — conditional enforcement

### 14.3 Cloud Asset Inventory & Audit Logs
- 14.3.1.1 Cloud Asset Inventory — real-time resource state — 35-day history
  - 14.3.1.1.1 Export to BigQuery/GCS — full or change-based — daily/real-time feeds
  - 14.3.1.1.2 Search assets — type + IAM policy — cross-project inventory
- 14.3.1.2 Cloud Audit Logs — Admin Activity (always on) + Data Access + System Event
  - 14.3.1.2.1 Data Access logs — off by default — expensive — enable per service
  - 14.3.1.2.2 Log retention — 400 days Admin Activity, 30 days Data Access (default)

---

## 15.0 Edge & Hybrid Cloud

### 15.1 Anthos / GKE Enterprise
#### 15.1.1 GKE Enterprise (Anthos)
- 15.1.1.1 Multi-cluster management — Fleet — register any K8s cluster
  - 15.1.1.1.1 Fleet — logical grouping of clusters — uniform policy application
  - 15.1.1.1.2 Config Sync fleet-level — push config to all clusters from single Git
- 15.1.1.2 Service Mesh — Cloud Service Mesh (Istio) — managed — mTLS + telemetry
  - 15.1.1.2.1 Fleet mesh — enable across fleet — consistent mTLS policy
  - 15.1.1.2.2 Traffic management — virtual services — fault injection — retries

### 15.2 Google Distributed Cloud
- 15.2.1.1 GDC Hosted — Google-managed infrastructure in customer DC — air-gap option
  - 15.2.1.1.1 Same API as GCP — sovereign cloud — data residency requirement
- 15.2.1.2 GDC Edge — small form factor — retail, telco edge — ruggedized
  - 15.2.1.2.1 Run GKE workloads at edge — managed from GCP console remotely

### 15.3 Multi-Region Architecture
#### 15.3.1 Failover Patterns
- 15.3.1.1 Regional failover — Cloud DNS + health checks → failover record
  - 15.3.1.1.1 Routing policy — FAILOVER — primary + backup endpoint
  - 15.3.1.1.2 GFE (Global Front End) — global anycast — route to healthy backend
- 15.3.1.2 Active-active multi-region — Cloud Spanner + Firestore multi-region
  - 15.3.1.2.1 Global LB — route to nearest healthy region — automatic
