# Azure Complete Study Guide - Part 16: Phase 2 — ARM/Bicep/DevOps, Governance, Cost, Arc

## 35.0 ARM Templates & Bicep

### 35.1 ARM & Bicep Core
→ See Ideal §12.1 ARM Templates, §12.2 Bicep

#### 35.1.1 ARM/Bicep-Unique Features
- **Unique: Deployment Stacks** — manage resource lifecycle — prevent drift
  - 35.1.1.1 Deny settings — DenyDelete, DenyWriteAndDelete — immutable prod infra
  - 35.1.1.2 Detach vs. delete on unmanage — control orphan resources on stack delete
  - 35.1.1.3 Scope — resource group / subscription / management group
- **Unique: Template Specs** — store ARM/Bicep in Azure — versioned — share + govern
  - 35.1.1.4 Deploy from spec — az deployment group create --template-spec
  - 35.1.1.5 RBAC on template spec — restrict who can deploy which templates
- **Unique: What-If operation** — preview before deploy — no actual change
  - 35.1.1.6 Output types — Create, Modify, Delete, Ignore, NoChange, Deploy
- **Unique: Bicep Playground** — online transpile ARM ↔ Bicep — instant feedback
- **Unique: Bicep module registry (MCR)** — Microsoft-curated public modules
  - 35.1.1.7 br/public:avm/ — Azure Verified Modules — security + best practice baked in
  - 35.1.1.8 Semantic versioning — pin to patch version — stability in prod

---

## 36.0 Azure DevOps & GitHub Actions

### 36.1 Azure DevOps Core
→ See Ideal §12.3 CI/CD, §12.4 Blue/Green & Canary

#### 36.1.1 Azure DevOps-Unique Features
- **Unique: Environments with approvals + checks** — gate deployments to prod
  - 36.1.1.1 Required reviewers — named individuals or groups — sequential or any
  - 36.1.1.2 Business hours check — deploy only during approved windows
  - 36.1.1.3 Query-based gate — work item / test results — quality gate
- **Unique: YAML template library** — extends + parameters — DRY pipelines
  - 36.1.1.4 Repository resources — reference templates from other repos
  - 36.1.1.5 Template expressions — compile-time evaluation — not runtime
- **Unique: Workload Identity Federation** — no stored secrets in service connections
  - 36.1.1.6 Automatic — ADO manages app registration + federated cred — zero config
- **Unique: Scale set agents** — VMSS-backed — auto-provision on demand — spot VMs
  - 36.1.1.7 Pre-provision — N standby agents — reduce queue wait time
- **Unique: Test Plans** — manual + exploratory testing — defect linking
  - 36.1.1.8 Test case association — link to pipeline run — traceability

---

## 37.0 Azure Policy & Governance

### 37.1 Policy & Governance Core
→ See Ideal §14.2 Azure Policy, §14.1 Management Groups

#### 37.1.1 Azure Policy-Unique Features
- **Unique: Policy exemptions with expiry** — waive specific resources — auto-expire
  - 37.1.1.1 Category — Waiver (accepted risk) vs. Mitigated (compensating control)
- **Unique: Policy initiatives (compliance)**
  - 37.1.1.2 Microsoft cloud security benchmark — 300+ controls — default assignment
  - 37.1.1.3 Regulatory compliance blade — control mapping — evidence collection
- **Unique: Machine Configuration (Guest Config)** — audit/enforce inside VM
  - 37.1.1.4 DSC v3 + InSpec — Windows + Linux — compliance baselines
  - 37.1.1.5 Custom configurations — author in PowerShell DSC — package + publish
- **Unique: Policy as code workflow** — ADO/GitHub → policy JSON → deploy via pipeline
  - 37.1.1.6 Community policy repo — Azure/azure-policy GitHub — 300+ samples
- **Unique: Defender for Cloud recommendations** — CSPM → auto-map to policy
  - 37.1.1.7 Enable Defender plan → auto-assign initiative — linked recommendations

---

## 38.0 Azure Cost Management

### 38.1 Cost Core
→ See Ideal §13.1 Pricing Models, §13.2 Cost Allocation, §13.3 Rightsizing

#### 38.1.1 Azure Cost-Unique Features
- **Unique: Cost allocation rules** — redistribute shared costs — proportional/fixed/even
  - 38.1.1.1 Source — resource group, subscription, tag filter
  - 38.1.1.2 Target — split to N subscriptions/resource groups with weight
- **Unique: FinOps hubs** — open-source Power BI toolkit — normalized cost data
  - 38.1.1.3 FOCUS-compatible export — vendor-neutral cost schema
  - 38.1.1.4 ADX connector — query raw billing data — custom dashboards
- **Unique: Azure Hybrid Benefit tracking** — verify AHB applied — license compliance
  - 38.1.1.5 License utilization report — assigned vs. available — Windows + SQL
- **Unique: Budget alerts + action groups** — email/webhook/Logic App on threshold
  - 38.1.1.6 Forecasted cost alert — alert before actual breach — forward-looking
  - 38.1.1.7 Budget action — apply tag, resize VM, stop VM — automated enforcement
- **Unique: Azure Advisor cost recommendations**
  - 38.1.1.8 Rightsizing — P95 CPU < 5% over 7 days → downsize suggestion
  - 38.1.1.9 Reserved instance recommendations — break-even analysis per resource

---

## 39.0 Azure Arc

### 39.1 Arc Core
→ See Ideal §15.1 Hybrid Cloud, §15.3 Multi-Region

#### 39.1.1 Azure Arc-Unique Features
- **Unique: Arc-enabled SQL Managed Instance** — run SQL MI on any Kubernetes
  - 39.1.1.1 Direct connectivity mode — managed via Azure portal/CLI
  - 39.1.1.2 Business Critical — HA replicas on Arc K8s — Pacemaker-based
  - 39.1.1.3 Arc SQL MI billing — vCore per hour — Azure Hybrid Benefit eligible
- **Unique: Arc-enabled data services** — SQL MI + PostgreSQL (Citus) on any K8s
  - 39.1.1.4 Data controller — coordinates data services — Kubernetes operator
- **Unique: Arc Jumpstart** — reference architectures — automated deployment scenarios
  - 39.1.1.5 Agora — retail/manufacturing edge — pre-built Arc scenarios
- **Unique: Azure Arc + Defender for Cloud** — extend CSPM to on-prem/multi-cloud
  - 39.1.1.6 AWS/GCP connector — Arc-less — native cloud APIs — unified posture
  - 39.1.1.7 Secure score across clouds — single pane — prioritized recommendations
- **Unique: Azure Lighthouse** — service provider multi-tenant management
  - 39.1.1.8 Delegated resource management — access customer subscriptions without switching
  - 39.1.1.9 Authorization model — SP/group/managed identity — granular RBAC
  - 39.1.1.10 Audit trail — customer's activity log records Lighthouse actions
