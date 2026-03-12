# OCI Complete Study Guide - Part 9: Phase 1 — DevOps, Governance, Cost & Hybrid

## 9.0 DevOps & Infrastructure as Code

### 9.1 OCI DevOps Service (CI/CD)
#### 9.1.1 DevOps Project Architecture
- 9.1.1.1 DevOps project — container for pipelines + code repos + environments
  - 9.1.1.1.1 Notification topic — required — alerts on pipeline events
  - 9.1.1.1.2 Log group — pipeline execution logs — troubleshoot failures
- 9.1.1.2 Code Repositories — managed Git — private — SSH + HTTPS auth
  - 9.1.1.2.1 Mirror from GitHub/GitLab — sync schedule — bridge to OCI CI
  - 9.1.1.2.2 Pull request + code review — inline comments — approval gates

#### 9.1.2 Build Pipelines
- 9.1.2.1 Build pipeline — stages — managed build + deliver artifacts
  - 9.1.2.1.1 Managed Build Stage — spec.yaml — build commands — Docker-in-Docker
  - 9.1.2.1.2 build_spec.yaml — steps + outputArtifacts — version + env vars
  - 9.1.2.1.3 Build runner — default Oracle Linux or custom image — OCI-managed VM
- 9.1.2.2 Deliver Artifacts Stage — push to Artifact Registry or OCIR
  - 9.1.2.2.1 Generic artifacts — JAR/ZIP/YAML — versioned — parameterized path
  - 9.1.2.2.2 Docker images — push to OCIR — auto-tag with build run ID
- 9.1.2.3 Trigger — push to branch / tag / PR — GitHub/GitLab webhook — cross-repo

#### 9.1.3 Deployment Pipelines
- 9.1.3.1 Deployment pipeline — stages — Blue/Green, Canary, Rolling, A/B
  - 9.1.3.1.1 Blue/Green — deploy to idle — swap traffic — instant rollback
  - 9.1.3.1.2 Canary — % traffic shift — monitor — proceed or rollback
  - 9.1.3.1.3 Rolling — batch replace — maxSurge + maxUnavailable — in-place
- 9.1.3.2 Environments — OKE cluster / Compute group / Functions / OKE Namespace
  - 9.1.3.2.1 OKE environment — reference cluster + namespace — kubectl apply
  - 9.1.3.2.2 Instance group environment — rolling deploy to tagged instances
- 9.1.3.3 Approval gates — manual approval stage — multi-approver — audit trail
  - 9.1.3.3.1 Approval timer — auto-expire — fail pipeline if not approved in N hours
- 9.1.3.4 Deploy to Functions — upload artifact → OCIR → update function image

### 9.2 Resource Manager (Terraform)
#### 9.2.1 Resource Manager Architecture
- 9.2.1.1 Managed Terraform — OCI-hosted state — no backend config needed
  - 9.2.1.1.1 Stack — Terraform config + state — scoped to compartment
  - 9.2.1.1.2 Config source — Object Storage zip / Git repo / Template / Terraform Registry
- 9.2.1.2 Jobs — plan + apply + destroy + import — logged — state versioned
  - 9.2.1.2.1 Plan job — drift detection — preview changes — JSON plan output
  - 9.2.1.2.2 Destroy job — tear down stack — confirm required — non-reversible
- 9.2.1.3 Drift detection — compare desired state vs. actual — report divergence
  - 9.2.1.3.1 Drift report — per-resource — MODIFIED / DELETED / NOT_FOUND
- 9.2.1.4 Private runner — Resource Manager agent — access private resources
  - 9.2.1.4.1 Agent-based execution — instance runs Terraform — VPN/FastConnect access

#### 9.2.2 OCI Terraform Provider
- 9.2.2.1 terraform-provider-oci — all OCI services — versioned releases
  - 9.2.2.1.1 Authentication — instance principal / API key / session token
  - 9.2.2.1.2 Parallel resources — depends_on — explicit dependency graph

### 9.3 Compartment & Tag Governance
#### 9.3.1 Tag Namespaces & Tag Keys
- 9.3.1.1 Tag namespace — container for tag keys — versioned — lock to prevent edit
  - 9.3.1.1.1 Defined tag — key + optional value list — structured metadata
  - 9.3.1.1.2 Free-form tag — arbitrary key/value — unstructured — any resource
- 9.3.1.2 Tag defaults — auto-apply defined tags to new resources in compartment
  - 9.3.1.2.1 Required tag — user must supply value — enforced at API level
  - 9.3.1.2.2 Default value — auto-fill — opt override — convenience
- 9.3.1.3 Cost tracking tags — track spend by tag — billing reports per dimension
  - 9.3.1.3.1 Enable cost tracking — mark tag key — appears in Cost Analysis filter

### 9.4 Cost Management & Budgets
#### 9.4.1 Cost Analysis & Budgets
- 9.4.1.1 Cost Analysis — query by service / compartment / tag / region — interactive
  - 9.4.1.1.1 Granularity — daily / monthly — trend charts — CSV export
  - 9.4.1.1.2 Compartment hierarchy rollup — child compartment costs aggregate up
- 9.4.1.2 Budgets — set spend threshold — alert at % of budget — email / topic
  - 9.4.1.2.1 Budget scope — compartment or tag — per-project or per-team
  - 9.4.1.2.2 Actual vs. forecast threshold — fire at 80% forecast — proactive
- 9.4.1.3 Usage reports — detailed CSV — hourly per resource — Object Storage export
  - 9.4.1.3.1 Cost + Usage report — OCID + region + service + tag — billing reconcile

#### 9.4.2 OCI Pricing Models
- 9.4.2.1 Pay-as-you-go — per-second (compute) or per-hour — no commitment
- 9.4.2.2 Annual Universal Credits — commit to $X/year — 33-60% discount
  - 9.4.2.2.1 Flexible apply — any OCI service — no SKU lock-in
- 9.4.2.3 Monthly Flex — pay monthly — min commitment — SMB option
- 9.4.2.4 Free tier — Always Free resources — micro instances + ADB-S + Object Storage

### 9.5 Hybrid — Roving Edge & Exadata Cloud@Customer
#### 9.5.1 Roving Edge Infrastructure
- 9.5.1.1 Roving Edge Device (RED) — portable OCI datacenter — disconnected ops
  - 9.5.1.1.1 Form factor — half rack / full rack — rugged — military / disaster
  - 9.5.1.1.2 OCI services subset — Compute, Object Storage, OKE, Functions — edge
  - 9.5.1.1.3 Sync to OCI — reconnect — upload Object Storage data — reconcile
- 9.5.1.2 Roving Edge Cluster — multiple REDs — local cluster — expanded capacity

#### 9.5.2 Exadata Cloud@Customer (ExaCC)
- 9.5.2.1 Exadata hardware — OCI-managed — in customer DC — data sovereignty
  - 9.5.2.1.1 Control plane in OCI — provisioning + patching — management traffic only
  - 9.5.2.1.2 Data plane on-prem — DB traffic stays local — compliance requirement
- 9.5.2.2 VM Cluster — provision ADB or DB System — same OCI APIs — consistent
  - 9.5.2.2.1 Autonomous VM Cluster — run ADB on ExaCC — serverless on-prem
  - 9.5.2.2.2 Oracle Exadata Database Service on Cloud@Customer (ExaDB-C@C)
