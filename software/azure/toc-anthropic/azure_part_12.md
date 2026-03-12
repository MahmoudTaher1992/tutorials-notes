# Azure Complete Study Guide - Part 12: Phase 2 — Entra ID, Azure Functions, AKS

## 22.0 Microsoft Entra ID

### 22.1 Entra ID Core
→ See Ideal §5.1 Identity & Access Management, §5.2 RBAC, §5.4 Managed Identities

#### 22.1.1 Entra ID-Unique Features
- **Unique: External Identities** — B2B + B2C in unified platform
  - 22.1.1.1 B2B Direct Connect — cross-tenant Teams channels — no guest account
  - 22.1.1.2 B2C — consumer identity — custom CIAM — branded user flows
  - 22.1.1.3 External Identities (CIAM) — new unified platform — Entra External ID
- **Unique: Entra ID Protection** — risk-based policies — sign-in + user risk
  - 22.1.1.4 Sign-in risk types — anonymous IP, unfamiliar location, malware-linked IP
  - 22.1.1.5 User risk types — leaked credentials, admin confirmed compromise
  - 22.1.1.6 Risk-based CA — require MFA on medium, block on high risk
- **Unique: Entra ID Governance** — access lifecycle beyond PIM
  - 22.1.1.7 Entitlement Management — access packages — bundles of resources
  - 22.1.1.8 Access packages — groups + apps + SharePoint + roles — request workflow
  - 22.1.1.9 Lifecycle workflows — automate joiner/mover/leaver — HR-driven
- **Unique: Entra Verified ID** — W3C verifiable credentials — decentralized identity
  - 22.1.1.10 Issue + verify credentials — privacy-preserving — selective disclosure
- **Unique: Authentication Methods policy** — centralized MFA + passwordless controls
  - 22.1.1.11 FIDO2 allow list — specific AAGUIDs — restrict to corporate keys
  - 22.1.1.12 Temporary Access Pass (TAP) — time-limited code — bootstrap passwordless
- **Unique: Cross-tenant synchronization** — sync users across Entra tenants
  - 22.1.1.13 Provision users into target tenant — B2B guest with member behavior

---

## 23.0 Azure Functions

### 23.1 Azure Functions Core
→ See Ideal §9.1 Lambda Architecture, §9.2 Cold Start, §9.3 Concurrency

#### 23.1.1 Azure Functions-Unique Features
- **Unique: Flex Consumption plan (Preview)** — VNet + scale to zero + fast cold start
  - 23.1.1.1 Concurrency-based scaling — number of in-flight requests per instance
  - 23.1.1.2 Always-ready instances — warm pool — faster than Consumption cold start
- **Unique: .NET Isolated Worker Process** — separate process — .NET 8/9 support
  - 23.1.1.3 Middleware pipeline — ASP.NET Core middleware — auth, logging, DI
  - 23.1.1.4 Custom worker — any language via custom worker protocol (gRPC)
- **Unique: Durable Functions** — stateful orchestrations — entity actor model
  - 23.1.1.5 → See §9.2 Durable Functions for full depth
- **Unique: Function chaining via Output Bindings** — zero infra plumbing
  - 23.1.1.6 Blob trigger → process → write to Cosmos DB + Service Bus — no code wiring
- **Unique: Azure Functions Core Tools** — local emulation — func start
  - 23.1.1.7 Azurite — local Storage emulator — full blob/queue/table
  - 23.1.1.8 func new — scaffold trigger types — templates for all trigger+binding combos
- **Unique: KEDA-based scaling (Container Apps hosting)**
  - 23.1.1.9 Deploy functions as containers — custom base images — any dependency
  - 23.1.1.10 KEDA HTTP scaler — scale to zero HTTP functions on Container Apps
- **Unique: Extensions bundle** — pre-packaged binding extensions — no NuGet per binding
  - 23.1.1.11 Version pinning — [4.0.0, 5.0.0) — prevent auto-update in prod
- **Unique: App Service Plan** — always-on setting — prevent idle timeout unload
  - 23.1.1.12 Private endpoint + VNet — outbound + inbound private connectivity
- **Unique: Azure Functions Premium plan unique behaviors**
  - 23.1.1.13 Pre-warmed instances — always-ready — 1 per plan default — no cold start
  - 23.1.1.14 Elastic scale — up to 200 instances — same VNet as App Service
  - 23.1.1.15 Unlimited execution duration — Consumption = 10min max; Premium = unlimited

---

## 24.0 Azure Kubernetes Service (AKS)

### 24.1 AKS Core
→ See Ideal §8.1 Container Runtime, §8.2 Kubernetes, §8.1.5 Autoscaling

#### 24.1.1 AKS-Unique Features
- **Unique: AKS Automatic** — fully managed — node provisioning, upgrades, scaling auto
  - 24.1.1.1 Karpenter node provisioning — right-size on demand — no node pool mgmt
  - 24.1.1.2 Automatic upgrades — latest stable channel — auto-node OS patching
  - 24.1.1.3 Azure RBAC only — no local accounts — Entra ID enforced
- **Unique: Fleet Manager** — multi-cluster AKS orchestration — at-scale updates
  - 24.1.1.4 Rollout strategy — staged update groups — safe multi-cluster upgrade
  - 24.1.1.5 Cluster resource placement — deploy workloads across fleet
- **Unique: AKS Workload Identity** — federated credential — OIDC issuer per cluster
  - 24.1.1.6 ServiceAccount annotation — azure.workload.identity/client-id
  - 24.1.1.7 Mutating webhook — inject env vars — AZURE_CLIENT_ID, AZURE_TENANT_ID
- **Unique: Azure CNI Powered by Cilium** — eBPF — replace kube-proxy — network policy
  - 24.1.1.8 L7 network policy — HTTP/gRPC path-level rules — without service mesh
  - 24.1.1.9 Hubble observability — built-in flow visibility — no sidecar
- **Unique: AGIC (Application Gateway Ingress Controller)** — native WAF integration
  - 24.1.1.10 Greenfield vs. brownfield — new App GW or bring existing
  - 24.1.1.11 Multi-cluster — single App GW serves multiple AKS clusters
- **Unique: Azure Policy add-on** — Gatekeeper — K8s-native policy enforcement
  - 24.1.1.12 Built-in initiatives — no privileged containers, enforce limits, approved registries
- **Unique: Node OS auto-upgrade channels** — Unmanaged/SecurityPatch/NodeImage/Rapid/Stable
  - 24.1.1.13 Maintenance window — schedule upgrades — node surge controls
  - 24.1.1.14 Node image upgrade — new image weekly — security patches rolled out
- **Unique: KAITO (Kubernetes AI Toolchain Operator)** — deploy LLMs on AKS easily
  - 24.1.1.15 Workspace CRD — specify model (Llama/Falcon) — auto-GPU node provision
