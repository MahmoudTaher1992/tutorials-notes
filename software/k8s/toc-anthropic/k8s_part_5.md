# Kubernetes Complete Study Guide (Ideal / Angel Method)
## Part 5: Implementations — Managed K8s, Tooling & Anti-Patterns

> **Ideal mappings** reference sections from Parts 1-4.
> Only features **unique** to each implementation are expanded here.

---

### Phase 2.1: Amazon EKS

#### Ideal Mappings
- Control plane → Ideal §1.2 (AWS-managed, multi-AZ)
- Networking → Ideal §4 (VPC CNI)
- Storage → Ideal §6 (EBS CSI, EFS CSI)
- Security → Ideal §8 (IRSA, OIDC)

#### **Unique: EKS**

##### EKS.1 Architecture
- EKS.1.1 Managed control plane — AWS runs etcd + API server, SLA 99.95%
- EKS.1.2 Node groups — managed (AWS handles upgrades) vs self-managed vs Fargate
- EKS.1.3 Fargate profiles — serverless nodes, pod-level isolation, no node management
- EKS.1.4 EKS Anywhere — EKS control plane running on-premises hardware
- EKS.1.5 EKS Auto Mode — fully automated node provisioning and management (2024)

##### EKS.2 Networking
- EKS.2.1 AWS VPC CNI — pods get VPC-native IPs from node ENIs
- EKS.2.2 ENI secondary IPs — `max-pods` limited by instance type ENI count
- EKS.2.3 Prefix delegation — `/28` prefixes on ENIs for more pod IPs
- EKS.2.4 Security Groups for Pods — assign SGs directly to pod network interface
- EKS.2.5 AWS Load Balancer Controller — provision ALB/NLB via Ingress/Service annotations

##### EKS.3 Authentication & IAM
- EKS.3.1 IRSA (IAM Roles for Service Accounts) — OIDC federation, SA-to-IAM role
- EKS.3.2 Pod Identity (EKS Pod Identity Agent) — simpler IRSA successor (2023)
- EKS.3.3 `aws-auth` ConfigMap — map IAM roles/users to K8s RBAC
- EKS.3.4 `kubectl` auth via `aws eks get-token` or `exec` credential plugin
- EKS.3.5 EKS access entries — IAM-native RBAC mapping (replaces aws-auth, 2024)

##### EKS.4 Operations
- EKS.4.1 Managed node group upgrades — rolling in-place upgrade with drain
- EKS.4.2 Karpenter — open-source node autoscaler, faster than CA, topology-aware
- EKS.4.3 EKS add-ons — managed VPC CNI, CoreDNS, kube-proxy, EBS CSI lifecycle
- EKS.4.4 EKS Blueprints / Terraform modules — opinionated cluster bootstrapping

---

### Phase 2.2: Google GKE

#### **Unique: GKE**

##### GKE.1 Architecture
- GKE.1.1 Autopilot vs Standard — fully managed (Autopilot) vs node control (Standard)
- GKE.1.2 GKE Autopilot — per-pod billing, no node management, enforced security policies
- GKE.1.3 Rapid / Regular / Stable release channels — auto-upgrade cadence
- GKE.1.4 Zonal vs Regional clusters — single control plane vs multi-zone HA

##### GKE.2 Networking
- GKE.2.1 VPC-native clusters — pod IPs from subnet alias IP ranges
- GKE.2.2 GKE Dataplane V2 (eBPF/Cilium) — built-in NetworkPolicy, Hubble observability
- GKE.2.3 Cloud Load Balancing — Ingress uses GCP L7 LB (global) or L4 NLB
- GKE.2.4 Private clusters — nodes have only private IPs, access via Cloud NAT / Bastion

##### GKE.3 Identity & Security
- GKE.3.1 Workload Identity — K8s SA → GCP service account via OIDC federation
- GKE.3.2 Binary Authorization — image signing policy enforcement at deploy time
- GKE.3.3 Config Connector — manage GCP resources as K8s CRDs
- GKE.3.4 GKE Sandbox (gVisor) — node pool option for untrusted workloads

---

### Phase 2.3: Azure AKS

#### **Unique: AKS**

##### AKS.1 Architecture
- AKS.1.1 Managed control plane — free, Azure-managed, no etcd access
- AKS.1.2 Node pools — system (critical pods) vs user (application workloads)
- AKS.1.3 Virtual Node (ACI) — burst to Azure Container Instances for serverless pods
- AKS.1.4 AKS Automatic — fully managed mode (Azure equivalent of GKE Autopilot)

##### AKS.2 Networking
- AKS.2.1 Azure CNI — pods get VNet IPs, integrates with NSGs
- AKS.2.2 Azure CNI Overlay — pod IP from overlay, VNet IP only for nodes (saves IPs)
- AKS.2.3 Cilium network dataplane — eBPF-based, AKS CNI + Cilium combination
- AKS.2.4 Application Gateway Ingress Controller (AGIC) — AGW as K8s Ingress

##### AKS.3 Identity
- AKS.3.1 Managed Identity for AKS — cluster identity for Azure resource access
- AKS.3.2 Workload Identity — K8s SA → Azure Managed Identity OIDC federation
- AKS.3.3 Azure AD integration — K8s RBAC backed by Azure AD groups

---

### Phase 2.4: Helm (Package Manager for K8s)

#### Ideal Mappings
- Declarative config → Ideal §1.1.2
- Release management → Ideal §10.3

#### **Unique: Helm**

##### HLM.1 Helm Concepts
- HLM.1.1 Chart — package of K8s YAML templates + values + metadata
- HLM.1.2 Release — deployed instance of a chart in a namespace
- HLM.1.3 Revision — numbered history of every upgrade/rollback
- HLM.1.4 `values.yaml` — default configuration, overridden at install/upgrade
- HLM.1.5 Chart repository — HTTP server hosting `index.yaml` + chart tarballs
- HLM.1.6 OCI registry — charts stored as OCI artifacts (Helm 3.8+)

##### HLM.2 Core Commands
- HLM.2.1 `helm install <release> <chart> -f values.yaml`
- HLM.2.2 `helm upgrade --install` — idempotent install-or-upgrade
- HLM.2.3 `helm rollback <release> <revision>` — revert to previous revision
- HLM.2.4 `helm diff upgrade` — preview changes before applying (helm-diff plugin)
- HLM.2.5 `helm template` — render manifests locally without installing
- HLM.2.6 `helm test` — run test pods defined in `templates/tests/`

##### HLM.3 Chart Authoring
- HLM.3.1 `Chart.yaml` — name, version, appVersion, dependencies
- HLM.3.2 Go templates — `{{ .Values.image.tag }}`, `{{ include }}`, `{{ range }}`
- HLM.3.3 `_helpers.tpl` — reusable template partials, named templates
- HLM.3.4 `NOTES.txt` — post-install instructions rendered to user
- HLM.3.5 Subcharts / dependencies — `charts/` directory, `Chart.lock`
- HLM.3.6 Schema validation — `values.schema.json` for values type checking

---

### Phase 2.5: GitOps — ArgoCD & Flux

#### **Unique: ArgoCD**
- AC.1 Application CRD — desired state: git repo + path + target cluster/namespace
- AC.2 Sync — ArgoCD pulls from git, applies diff to cluster
- AC.3 App health — synced/out-of-sync, healthy/degraded, per-resource status
- AC.4 ApplicationSet — generate multiple Applications from template (generators)
- AC.5 RBAC in ArgoCD — projects, policies, SSO integration
- AC.6 `argocd app sync --prune` — remove resources no longer in git

#### **Unique: Flux**
- FL.1 GitRepository / HelmRelease / Kustomization CRDs — declarative sources
- FL.2 Source controller — polls git/OCI, triggers reconciliation
- FL.3 Helm controller — manages Helm releases via HelmRelease CR
- FL.4 Image automation — auto-update git with new image tags from registry
- FL.5 Notification controller — alerts on reconciliation events

---

### Phase 2.6: K8s Anti-Patterns

#### AP.1 Workload Anti-Patterns
- AP.1.1 No resource requests — scheduler blind, nodes overloaded, OOM kills
- AP.1.2 No liveness/readiness probes — broken pods stay in Service endpoints
- AP.1.3 Running as root — unnecessary privilege, fails Pod Security Standards
- AP.1.4 `latest` image tag — non-deterministic, breaks rollback
- AP.1.5 Storing state in pod — pod ephemeral, data lost on restart
- AP.1.6 Single replica for production — no HA, updates cause downtime

#### AP.2 Networking Anti-Patterns
- AP.2.1 No NetworkPolicy — all pods can reach all pods by default
- AP.2.2 NodePort in production — bypasses load balancing, exposes node IPs
- AP.2.3 `hostNetwork: true` unnecessarily — shares node network namespace

#### AP.3 Security Anti-Patterns
- AP.3.1 Wildcard RBAC (`*`) — violates least privilege, grants everything
- AP.3.2 Secrets in environment variables only — visible in `kubectl describe`
- AP.3.3 Disabled Pod Security — `privileged` namespace label disables all checks
- AP.3.4 Default Service Account — all pods share identity, overly permissive by default
- AP.3.5 etcd without encryption — secrets stored in plaintext in etcd

#### AP.4 Operations Anti-Patterns
- AP.4.1 No PodDisruptionBudget — node drains kill all pods of a deployment
- AP.4.2 Manual kubectl in production — no audit trail, no GitOps reconciliation
- AP.4.3 Ignoring resource quotas — one team can starve another namespace
- AP.4.4 No etcd backup — cluster unrecoverable if control plane corrupted
- AP.4.5 Skipping multiple minor versions in upgrade — unsupported, may corrupt state
