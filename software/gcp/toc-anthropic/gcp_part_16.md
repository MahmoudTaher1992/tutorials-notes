# GCP Complete Study Guide - Part 16: Phase 2 — Cloud Build/Deploy, Governance, Cost, Anthos/GDC

## 38.0 Cloud Build & Cloud Deploy

### 38.1 Cloud Build & Deploy Core
→ See Ideal §12.1 Cloud Build, §12.2 Cloud Deploy, §12.3 Artifact Registry

#### 38.1.1 Cloud Build-Unique Features
- **Unique: Serverless CI** — Docker step containers — any tool as build step — YAML config
  - 38.1.1.1 Parallel steps — waitFor: ['-'] — fan-out test matrix — reduce wall time
  - 38.1.1.2 Build approvals — manual gate — prod environment protection
  - 38.1.1.3 Private pools — VPC-connected — dedicated workers — on-prem access
- **Unique: Kaniko caching** — GCS layer cache — 85% faster Docker rebuilds
  - 38.1.1.4 --cache=true + --cache-ttl — inject Kaniko cache — persistent across builds
- **Unique: Build provenance** — SLSA level 3 — signed attestation — supply chain
  - 38.1.1.5 Binary Authorization integration — attest after build — require in GKE policy

#### 38.1.2 Cloud Deploy-Unique Features
- **Unique: Managed CD pipeline** — delivery pipeline → targets — promote through stages
  - 38.1.2.1 Rollout lifecycle — pending → in-progress → success/failure — immutable release
  - 38.1.2.2 Canary strategy — % traffic shift — automated canary analysis via Monitoring
  - 38.1.2.3 Verify phase — custom Cloud Monitoring metric — pass/fail gate before promote
- **Unique: Deploy to GKE/Cloud Run/Anthos/VM** — multi-target type — single pipeline
  - 38.1.2.4 Deploy parameters — per-target override — env-specific Helm values
  - 38.1.2.5 Rollback — one click — redeploy previous successful release — immutable

#### 38.1.3 Artifact Registry-Unique Features
- **Unique: Remote repos** — proxy Docker Hub/PyPI/Maven — cache + scan — air-gap builds
  - 38.1.3.1 Upstream policy — internal repo first — fallback to remote — supply chain control
  - 38.1.3.2 Vulnerability scanning — Container Analysis — block critical CVEs on push

---

## 39.0 Organization Policy & Governance

### 39.1 Org Policy Core
→ See Ideal §14.2 Organization Policy Service, §14.3 Cloud Asset Inventory

#### 39.1.1 Org Policy-Unique Features
- **Unique: Custom org constraints** — any resource field — CEL expression — beyond built-in
  - 39.1.1.1 resource.labels — require cost-center label on all compute resources
  - 39.1.1.2 resource.spec.template.spec.containers — restrict container image registry
- **Unique: Tag-conditional policies** — apply org policy only if resource has tag
  - 39.1.1.3 resource.hasTagKey('env') = 'prod' — tighter policy for prod resources
- **Unique: Cloud Asset Inventory** — real-time + 35-day history — all GCP resource state
  - 39.1.1.4 Export to BigQuery — daily/real-time change feed — compliance snapshots
  - 39.1.1.5 Search assets — type + IAM policy — cross-project — security investigations
  - 39.1.1.6 Feed — Pub/Sub notification on change — trigger remediation workflow
- **Unique: Security Command Center (SCC)** — unified security posture — findings + risks
  - 39.1.1.7 SCC Standard (free) — Security Health Analytics — basic vulnerability findings
  - 39.1.1.8 SCC Premium — Event Threat Detection — VM Threat Detection — SOC integration
  - 39.1.1.9 Chronicle integration — SCC findings → SIEM — automated playbooks
- **Unique: VPC Service Controls** — API-level perimeter — data exfiltration prevention
  - 39.1.1.10 Service perimeter — restrict BigQuery/GCS to trusted VPCs — perimeter bridge
  - 39.1.1.11 Dry-run mode — monitor before enforce — no-impact policy validation

---

## 40.0 Cost Management & FinOps

### 40.1 Cost Management Core
→ See Ideal §13.1 Pricing Models, §13.2 Billing, §13.3 Recommender

#### 40.1.1 Cost Management-Unique Features
- **Unique: Sustained Use Discounts (SUDs)** — automatic — no commitment — unique to GCP
  - 40.1.1.1 Linear — 25% off at 100% monthly usage — no opt-in needed — GCE only
  - 40.1.1.2 Not combinable with CUDs on same instance — choose best discount
- **Unique: Committed Use Discounts (CUDs)** — resource or spend-based — 1/3 year
  - 40.1.1.3 Resource CUD — specific vCPU/memory commitment — up to 57% off
  - 40.1.1.4 Spend CUD — commit $X/hr — flexible SKU — modern recommendation
  - 40.1.1.5 CUD sharing — commitment pool across project family — maximize utilization
- **Unique: Billing export to BigQuery** — detailed + pricing + resource datasets — SQL
  - 40.1.1.6 Resource labels — cost allocation per team/product — SQL aggregation
  - 40.1.1.7 FinOps dashboards — Looker Studio on BQ export — zero extra cost
- **Unique: Active Assist Recommenders** — ML-powered idle + right-size + CUD recommendations
  - 40.1.1.8 Idle VM — p50 CPU < 5% → suggest delete/downsize — automated remediations
  - 40.1.1.9 Right-size — p95 CPU sizing — avoid over-provisioning — SLO-aware

---

## 41.0 Anthos / GKE Enterprise & Google Distributed Cloud

### 41.1 Anthos Core
→ See Ideal §15.1 Anthos/GKE Enterprise, §15.2 Google Distributed Cloud

#### 41.1.1 Anthos/GKE Enterprise-Unique Features
- **Unique: Fleet** — logical cluster grouping — uniform policy application — multi-cloud
  - 41.1.1.1 Register any K8s cluster — GKE/EKS/AKS/on-prem — single Fleet API
  - 41.1.1.2 Config Sync fleet-level — push config to all clusters from single Git source
  - 41.1.1.3 Fleet scopes — subset of clusters — apply GitOps per team boundary
- **Unique: Multi-cluster Services (MCS)** — ServiceExport/ServiceImport — cross-cluster DNS
  - 41.1.1.4 Cluster-set DNS — svc.clusterset.local — DNS-based cross-cluster discovery
  - 41.1.1.5 Multi-cluster Gateway — global LB — span backend pods across GKE clusters
- **Unique: Cloud Service Mesh (managed Istio)** — fleet mesh — mTLS + telemetry
  - 41.1.1.6 Managed data plane — Google upgrades proxies — no manual Envoy management
  - 41.1.1.7 Fleet mesh — enable mTLS across entire fleet — consistent security policy
- **Unique: Policy Controller (OPA Gatekeeper)** — constraint templates — Rego policies
  - 41.1.1.8 Referential constraints — check across resources — e.g. deny if namespace missing label
  - 41.1.1.9 Mutation policies — automatically add labels/annotations — admission mutation

#### 41.1.2 Google Distributed Cloud-Unique Features
- **Unique: GDC Hosted** — Google-managed infra in customer DC — air-gap sovereign cloud
  - 41.1.2.1 Same GCP APIs — identical developer experience — data residency compliance
  - 41.1.2.2 Air-gap mode — no outbound internet — fully isolated — government use
- **Unique: GDC Edge** — small form factor — retail/telco edge — ruggedized hardware
  - 41.1.2.3 GKE workloads at edge — managed from GCP console remotely — low-latency apps
  - 41.1.2.4 GDC Edge appliance — GPU option — on-device ML inference — real-time processing
