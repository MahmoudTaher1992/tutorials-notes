# Azure Complete Study Guide - Part 9: DevOps, Cost, Compliance & Edge (Phase 1 — Ideal)

## 12.0 DevOps & Infrastructure as Code

### 12.1 ARM Templates
#### 12.1.1 ARM Template Structure
- 12.1.1.1 Sections — $schema, contentVersion, parameters, variables, functions, resources, outputs
  - 12.1.1.1.1 Resources array — type, apiVersion, name, location, properties, dependsOn
  - 12.1.1.1.2 dependsOn — explicit dependency — override implicit resourceId reference
- 12.1.1.2 ARM functions — resourceId(), reference(), concat(), variables(), parameters()
  - 12.1.1.2.1 reference() — get runtime properties — creates implicit dependency
  - 12.1.1.2.2 copyIndex() — resource iteration — create N resources from one definition

#### 12.1.2 ARM Deployment Modes
- 12.1.2.1 Incremental mode — add/update only — does not delete unlisted resources
- 12.1.2.2 Complete mode — delete unlisted resources — idempotent — use with care
  - 12.1.2.2.1 What-if — preview changes before apply — equivalent to CFN change set
- 12.1.2.3 Deployment stacks — manage lifecycle — prevent drift + deletion protection
  - 12.1.2.3.1 Deny settings — DenyDelete, DenyWriteAndDelete — protect critical resources
  - 12.1.2.3.2 Unmanaged resources — detach on stack delete vs. delete with stack

### 12.2 Bicep
#### 12.2.1 Bicep Language Features
- 12.2.1.1 DSL transpiles to ARM — no runtime state — ARM engine executes
  - 12.2.1.1.1 Type-safe — intellisense — VS Code extension essential
  - 12.2.1.1.2 Decompile ARM → Bicep — bicep decompile — migration path
- 12.2.1.2 Modules — separate .bicep files — reusable — scope override
  - 12.2.1.2.1 Private registry — ACR-hosted modules — versioned — share across teams
  - 12.2.1.2.2 Public registry (br/public:) — community modules — Microsoft maintained
- 12.2.1.3 Loops — [for item in array] — resource/module/variable/output iteration
- 12.2.1.4 Conditions — if(condition) — conditional resource deployment

#### 12.2.2 Bicep Advanced
- 12.2.2.1 User-defined types — custom type definitions — reusable across files
- 12.2.2.2 User-defined functions — custom functions — type-safe parameter + return
- 12.2.2.3 Extensibility providers — Kubernetes, AWS resources via Bicep — experimental
- 12.2.2.4 Bicep Linter — best practice rules — naming, resource API versions

### 12.3 Azure DevOps
#### 12.3.1 Azure Pipelines
- 12.3.1.1 YAML pipelines — stages → jobs → steps — version-controlled
  - 12.3.1.1.1 Templates — extend, include, parameters — DRY principles
  - 12.3.1.1.2 Environments — deployment tracking — approvals, checks, history
- 12.3.1.2 Agents — Microsoft-hosted (Windows/Linux/macOS) or self-hosted
  - 12.3.1.2.1 Scale Set agents — VMSS-backed — auto-provision on demand
  - 12.3.1.2.2 Container jobs — Docker-based — isolation per job
- 12.3.1.3 Service connections — Workload Identity Federation — no secrets stored
  - 12.3.1.3.1 OIDC token exchange — ADO → Entra — short-lived token
  - 12.3.1.3.2 Automatic — ADO creates app registration — manages federation

#### 12.3.2 Azure Repos, Artifacts & Boards
- 12.3.2.1 Repos — Git or TFVC — branch policies — PR required
  - 12.3.2.1.1 Branch protection — required reviewers, build validation, linked work items
- 12.3.2.2 Artifacts — package feeds — NuGet, npm, Maven, PyPI, Universal Packages
  - 12.3.2.2.1 Upstream sources — proxy public registries — cache + security scan
- 12.3.2.3 Boards — work items — sprints — backlogs — GitHub integration

### 12.4 GitHub Actions with Azure
#### 12.4.1 OIDC Federation with Azure
- 12.4.1.1 GitHub OIDC token → Azure Entra — no secrets in GitHub Secrets
  - 12.4.1.1.1 Federated credential — subject claim — repo:org/repo:ref:refs/heads/main
  - 12.4.1.1.2 Environment-specific claims — restrict to specific branch/env

---

## 13.0 Cost Management & FinOps

### 13.1 Pricing Models
#### 13.1.1 Pay-As-You-Go vs. Reserved vs. Savings Plans
- 13.1.1.1 Pay-As-You-Go — per-second/minute — maximum flexibility — maximum cost
- 13.1.1.2 Reserved Instances — 1/3-year — specific VM series+region — up to 72% savings
  - 13.1.1.2.1 Reservation scope — shared (subscription group) vs. single subscription
  - 13.1.1.2.2 Exchange — swap unused reservation for different size/region
- 13.1.1.3 Savings Plans — compute savings plan — flexible — up to 65% savings
  - 13.1.1.3.1 Compute SP — any region/size/OS — most flexible commitment
  - 13.1.1.3.2 Machine Learning SP — AML compute — 17–35% savings
- 13.1.1.4 Azure Hybrid Benefit — BYOL Windows/SQL Server — 40–85% savings
  - 13.1.1.4.1 AHB + RI stacking — combine both discounts — maximum savings
  - 13.1.1.4.2 Extended Security Updates — WS2008/SQL 2008 — 3 years free via AHB

### 13.2 Azure Cost Management + Billing
#### 13.2.1 Cost Analysis & Budgets
- 13.2.1.1 Cost analysis — accumulated, daily, by resource — pivot by tag/service/location
  - 13.2.1.1.1 Smart views — prebuilt analysis — resources by service, dept, project
  - 13.2.1.1.2 Forecast — ML-based — 30/60-day forward projection
- 13.2.1.2 Budgets — threshold alerts — 25/50/75/90/100% notification
  - 13.2.1.2.1 Budget actions — email + action group — auto-deallocate VMs on breach
- 13.2.1.3 Azure Advisor cost recommendations — right-size, shutdown, RI opportunities
  - 13.2.1.3.1 Right-size CPU < 5% average over 7 days → recommendation

---

## 14.0 Compliance & Governance

### 14.1 Management Groups & Subscriptions
#### 14.1.1 Management Hierarchy
- 14.1.1.1 Root tenant MG → Management Groups → Subscriptions → Resource Groups → Resources
  - 14.1.1.1.1 Max depth — 6 levels of MGs below root
  - 14.1.1.1.2 Policy + RBAC inheritance — down the hierarchy — cannot override above
- 14.1.1.2 Subscription limits — 980 per tenant — request increase
  - 14.1.1.2.1 Subscription per environment pattern — prod/dev/test isolation

### 14.2 Azure Policy Deep Dive
- 14.2.1.1 Compliance state — Compliant / Non-Compliant / Conflicting / Not Started / Exempt
- 14.2.1.2 Remediation tasks — DeployIfNotExists + Modify effects — background worker
  - 14.2.1.2.1 Managed identity for remediation — system-assigned — contributor role auto-assigned
- 14.2.1.3 Policy exemptions — waive specific resources — expiry date required
- 14.2.1.4 Guest configuration (Machine Configuration) — audit VM OS settings
  - 14.2.1.4.1 DSC/Chef InSpec — compliance inside VM — Windows + Linux

### 14.3 Azure Activity Log & Resource Graph
#### 14.3.1 Activity Log
- 14.3.1.1 Subscription-level control plane events — 90 days retention — free
  - 14.3.1.1.1 Export to Log Analytics/Storage/Event Hub — extend retention
  - 14.3.1.1.2 Event categories — Administrative, Security, ServiceHealth, Alert, Policy
- 14.3.1.2 Resource Graph — Kusto-like queries — across subscriptions — real-time inventory
  - 14.3.1.2.1 resources | where type == 'microsoft.compute/virtualmachines'
  - 14.3.1.2.2 Change data — last 14 days of resource property changes

---

## 15.0 Edge & Hybrid Cloud

### 15.1 Azure Arc
#### 15.1.1 Azure Arc Servers
- 15.1.1.1 Non-Azure VMs/physical servers — Azure control plane — any cloud/on-prem
  - 15.1.1.1.1 Arc agent (azcmagent) — heartbeat — extensions — MMA/AMA
  - 15.1.1.1.2 Azure Policy — audit/enforce OS config on Arc servers
- 15.1.1.2 Extensions — Deploy VM extensions — AMA, MDE, Key Vault cert sync
  - 15.1.1.2.1 Azure Automation DSC — configuration management at scale

#### 15.1.2 Azure Arc-enabled Kubernetes
- 15.1.2.1 Connect any K8s cluster — EKS, GKE, on-prem — Azure control plane
  - 15.1.2.1.1 Azure Policy + GitOps (Flux) — push configs to cluster
  - 15.1.2.1.2 Cluster extensions — Defender, Monitor, APIM gateway, ML extension
- 15.1.2.2 Arc-enabled data services — SQL MI + PostgreSQL on any K8s
  - 15.1.2.2.1 Direct + Indirect connectivity modes — air-gapped support

### 15.2 Availability Zones & Multi-Region
#### 15.2.1 Zone Architecture
- 15.2.1.1 3 independent AZs per region — separate power/cooling/network
  - 15.2.1.1.1 Zone-redundant services — PRS/ZRS/zone-redundant SKU
  - 15.2.1.1.2 Zonal services — pinned to specific zone — latency-sensitive

#### 15.2.2 Azure Site Recovery (DR)
- 15.2.2.1 Replication — Hyper-V/VMware/Azure VMs — recovery points
  - 15.2.2.1.1 RPO — 30-second crash-consistent, 1-hr app-consistent
  - 15.2.2.1.2 RTO — test failover — non-disruptive DR drill
- 15.2.2.2 Failover types — test (no impact), planned (zero data loss), unplanned
  - 15.2.2.2.1 Recovery plan — ordered failover groups — scripted pre/post actions
  - 15.2.2.2.2 Failback — re-protect + fail back to original region
