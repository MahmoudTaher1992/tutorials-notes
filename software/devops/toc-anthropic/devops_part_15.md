# DevOps Engineering Study Guide - Part 15: Phase 2 — Vault, Trivy, Cosign, ArgoCD, Flux & Istio

## 22.0 Vault / Trivy / Cosign

### 22.1 HashiCorp Vault
→ See Ideal §9.1 Secret Management

#### 22.1.1 Vault-Unique Features
- **Unique: Dynamic secrets** — generate short-lived DB credentials on demand
  - 22.1.1.1 Database engine — vault read db/creds/my-role — username + temp password
  - 22.1.1.2 Lease TTL — auto-revoke after expiry — no stale credential risk
  - 22.1.1.3 AWS secrets engine — generate IAM access keys — TTL-bound — no static keys
- **Unique: PKI secrets engine** — Vault as CA — issue short-lived certs — mTLS at scale
  - 22.1.1.4 Intermediate CA — Vault signs with root CA — chain of trust
  - 22.1.1.5 cert-manager + Vault Issuer — auto-renew K8s certs — integration
- **Unique: Agent Injector** — K8s — sidecar injects secrets to pod filesystem
  - 22.1.1.6 vault.hashicorp.com/agent-inject-secret — annotation-driven — no app change
  - 22.1.1.7 Template rendering — inject as .env file or JSON — flexible format
- **Unique: Vault Secrets Operator (VSO)** — CRD-based — sync to K8s Secrets — modern
  - 22.1.1.8 VaultStaticSecret + VaultDynamicSecret CRDs — declarative — GitOps-friendly
- **Unique: Namespaces (Enterprise)** — multi-tenant Vault — isolation per team
  - 22.1.1.9 Namespace isolation — separate policies + auth + secret engines
- **Unique: Raft storage** — built-in HA — no Consul dependency — auto-join
  - 22.1.1.10 Integrated storage — 3-node Raft cluster — performance standby nodes

### 22.2 Trivy (Security Scanner)
→ See Ideal §9.2 SAST/SCA, §3.4 Container Security

#### 22.2.1 Trivy-Unique Features
- **Unique: All-in-one scanner** — images / repos / filesystems / K8s / IaC / SBOM
  - 22.2.1.1 trivy image — OS packages + language deps + secrets — comprehensive
  - 22.2.1.2 trivy k8s — scan cluster live — workloads + infra + RBAC — risk report
  - 22.2.1.3 trivy fs — scan local directory — pre-commit or CI — no Docker needed
- **Unique: Misconfig scanning** — Dockerfile + Terraform + K8s YAML — IaC security
  - 22.2.1.4 Dockerfile best practices — USER root, ADD vs COPY — policy violations
  - 22.2.1.5 Custom Rego policies — OPA-based — org-specific rules — extend built-in
- **Unique: SBOM generation** — CycloneDX / SPDX — attach to release artifacts
  - 22.2.1.6 trivy sbom — generate + scan existing SBOM — CVE attribution

### 22.3 Cosign / Sigstore
→ See Ideal §2.5 Supply Chain Security

#### 22.3.1 Cosign-Unique Features
- **Unique: Keyless signing** — OIDC identity → Fulcio CA → ephemeral key — no key mgmt
  - 22.3.1.1 CI signing — GitHub OIDC → cosign sign — identity = workflow path
  - 22.3.1.2 Rekor log — transparency log — every signature recorded — public audit
- **Unique: Attach attestations to image** — SBOM + SLSA provenance in registry
  - 22.3.1.3 cosign attest — attach CycloneDX SBOM — predicate-type flag
  - 22.3.1.4 cosign verify-attestation — policy evaluation — OPA Rego — enforce at deploy
- **Unique: Policy Controller (Sigstore)** — K8s admission — enforce signed images
  - 22.3.1.5 ClusterImagePolicy — require signature + attestation — before pod runs

---

## 23.0 ArgoCD, Flux & Service Mesh

### 23.1 ArgoCD
→ See Ideal §10.0 GitOps

#### 23.1.1 ArgoCD-Unique Features
- **Unique: Application CRD** — declarative GitOps — sync to cluster — health status
  - 23.1.1.1 App of Apps pattern — root Application manages child Applications — scale
  - 23.1.1.2 ApplicationSet — generate Applications from template — multi-cluster/env
  - 23.1.1.3 syncPolicy.automated — enable self-heal + prune — full GitOps
- **Unique: Resource health** — custom health checks — Lua scripts — per resource type
  - 23.1.1.4 Degraded / Healthy / Progressing / Suspended — fine-grained status
- **Unique: Sync waves + hooks** — order resource apply — PreSync + Sync + PostSync
  - 23.1.1.5 argocd.argoproj.io/sync-wave — DB migration before app deployment
  - 23.1.1.6 argocd.argoproj.io/hook — PreSync Job — run DB migration before sync
- **Unique: Multi-cluster** — one ArgoCD — manage N clusters — central control
  - 23.1.1.7 Cluster secrets — register external clusters — RBAC per destination
- **Unique: ArgoCD Image Updater** — watch registry — update image tag in Git — auto
  - 23.1.1.8 Semver constraint — only update patch — no breaking version bumps

### 23.2 Flux
→ See Ideal §10.0 GitOps

#### 23.2.1 Flux-Unique Features
- **Unique: Toolkit approach** — small focused controllers — composable — GitOps Toolkit
  - 23.2.1.1 Source Controller — GitRepository / OCIRepository / HelmRepository — fetch
  - 23.2.1.2 Kustomize Controller — apply Kustomizations — patch + overlay — reconcile
  - 23.2.1.3 Helm Controller — HelmRelease CRD — upgrade + rollback — managed
  - 23.2.1.4 Notification Controller — alerts on events — Slack/GitHub status
- **Unique: OCI artifacts** — store Kustomize/Helm as OCI — no Git dependency
  - 23.2.1.5 flux push artifact — bundle YAML → OCI — air-gap friendly

### 23.3 Istio / Linkerd
→ See Ideal §13.0 Service Mesh

#### 23.3.1 Istio-Unique Features
- **Unique: Envoy sidecar** — iptables intercept — full L7 — traffic management
  - 23.3.1.1 VirtualService — HTTP routing — header match + weight — canary
  - 23.3.1.2 DestinationRule — outlier detection + connection pool — circuit breaker
  - 23.3.1.3 PeerAuthentication — STRICT mTLS — namespace or mesh-wide
- **Unique: Ambient mode** — no sidecar — ztunnel per node — waypoint per service
  - 23.3.1.4 ztunnel — L4 mTLS — lightweight — DaemonSet — no pod restart needed
  - 23.3.1.5 Waypoint proxy — L7 — per-service — only for advanced policy needs

#### 23.3.2 Linkerd-Unique Features
- **Unique: Rust data plane (proxy)** — ultra-low latency — low memory — no Envoy
  - 23.3.2.1 Automatic mTLS — zero config — cert rotation every 24h — safe default
  - 23.3.2.2 SMI compatible — TrafficSplit — canary via standard interface
- **Unique: Viz extension** — golden metrics — per-route — top/tap/stat CLI
  - 23.3.2.3 linkerd viz tap — live request stream — inspect headers + payloads
