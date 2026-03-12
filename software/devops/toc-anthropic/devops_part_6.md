# DevOps Engineering Study Guide - Part 6: Phase 1 — K8s Autoscaling & Security

## 4.5 Kubernetes Autoscaling
### 4.5.1 Horizontal Pod Autoscaler (HPA)
#### 4.5.1.1 HPA Architecture
- 4.5.1.1.1 Control loop — 15s default — fetch metric → calculate desired replicas → scale
  - 4.5.1.1.1.1 Desired replicas = ceil(current * (current_metric / target_metric))
  - 4.5.1.1.1.2 Scale-down stabilization window — 5 min default — prevent thrash
- 4.5.1.1.2 Metrics sources — resource metrics (CPU/mem) + custom + external
  - 4.5.1.1.2.1 Metrics API — metrics-server for resource — Prometheus Adapter for custom
  - 4.5.1.1.2.2 Custom metrics — RPS / queue depth / business metrics — more accurate

### 4.5.2 Vertical Pod Autoscaler (VPA)
- 4.5.2.1 VPA — recommend or auto-set requests/limits — prevent over/under provisioning
  - 4.5.2.1.1 UpdateMode: Off — recommend only — no pod restart — safe start
  - 4.5.2.1.2 UpdateMode: Auto — evict + recreate with new requests — disruption risk
  - 4.5.2.1.3 HPA + VPA conflict — do not use both on same metric — resource type only VPA
- 4.5.2.2 VPA admission webhook — mutate pod spec at admission — inject recommendations

### 4.5.3 KEDA (Event-Driven Autoscaling)
- 4.5.3.1 KEDA — scale on external metrics — queue depth / stream lag / cron
  - 4.5.3.1.1 ScaledObject — CRD — target deployment + trigger — wraps HPA
  - 4.5.3.1.2 Scalers — Kafka lag / SQS / RabbitMQ / Redis / Prometheus / Cron
  - 4.5.3.1.3 Scale to zero — no queue messages → 0 replicas — cost save
  - 4.5.3.1.4 ScaledJob — scale Jobs not Deployments — parallel job workers

### 4.5.4 Cluster Autoscaler
- 4.5.4.1 Node group scaling — add/remove nodes — pending pods trigger
  - 4.5.4.1.1 Scale-up — unschedulable pod → pick node group → cloud API add node
  - 4.5.4.1.2 Scale-down — underutilized node — safe to evict — 10 min idle default
  - 4.5.4.1.3 PDB awareness — respects PDB — won't drain if would violate
- 4.5.4.2 Expander strategies — random / least-waste / priority / price — node selection
  - 4.5.4.2.1 Least-waste — pick node group with least wasted resources after pod

---

## 4.6 Kubernetes Security
### 4.6.1 RBAC
#### 4.6.1.1 RBAC Primitives
- 4.6.1.1.1 Role / ClusterRole — set of rules — namespace or cluster-scoped
  - 4.6.1.1.1.1 Rule — apiGroups + resources + verbs — fine-grained
  - 4.6.1.1.1.2 Aggregated ClusterRole — label selector — combine child roles
- 4.6.1.1.2 RoleBinding / ClusterRoleBinding — bind role to subject
  - 4.6.1.1.2.1 Subject — User / Group / ServiceAccount
  - 4.6.1.1.2.2 Impersonation — kubectl --as=user — audit trail — test RBAC
- 4.6.1.1.3 Least privilege — no cluster-admin for apps — namespace-scoped only
  - 4.6.1.1.3.1 audit2rbac — generate RBAC from audit logs — minimal permissions
  - 4.6.1.1.3.2 rbac-lookup — visualize bindings — find over-privileged SAs

### 4.6.2 Pod Security Admission (PSA)
- 4.6.2.1 PSA — built-in admission controller — enforce Pod Security Standards
  - 4.6.2.1.1 Privileged — no restrictions — kube-system only
  - 4.6.2.1.2 Baseline — prevent known privilege escalations — default target
  - 4.6.2.1.3 Restricted — hardened — no root, no privilege escalation, drop all caps
- 4.6.2.2 Modes — enforce / audit / warn — per namespace label
  - 4.6.2.2.1 audit mode — log violations without blocking — migration phase
  - 4.6.2.2.2 warn mode — API response warning — developer feedback

### 4.6.3 NetworkPolicy
- 4.6.3.1 NetworkPolicy — L3/L4 firewall — pod selector + namespace selector
  - 4.6.3.1.1 Default deny all — empty podSelector + empty ingress/egress — zero trust
  - 4.6.3.1.2 Allow specific — podSelector matchLabels — port + protocol
  - 4.6.3.1.3 Egress to external CIDR — ipBlock — allow DNS (53/UDP) + external API
- 4.6.3.2 CNI requirement — NetworkPolicy is declarative — CNI must enforce
  - 4.6.3.2.1 Flannel ignores NetworkPolicy — need Calico/Cilium for enforcement

### 4.6.4 Secrets Management
- 4.6.4.1 K8s Secrets — base64 encoded — NOT encrypted by default in etcd
  - 4.6.4.1.1 etcd encryption at rest — EncryptionConfiguration — AES-CBC / AES-GCM
  - 4.6.4.1.2 KMS plugin — envelope encryption — DEK per secret — MEK in KMS
- 4.6.4.2 External secrets — ESO / Secrets Store CSI Driver — pull from Vault/ASM/GSM
  - 4.6.4.2.1 ExternalSecret CRD — define source + key path — sync to K8s Secret
  - 4.6.4.2.2 SecretProviderClass (CSI) — mount as volume or env — auto-rotation
- 4.6.4.3 Secret rotation — update in Vault — ESO syncs → pod env updated
  - 4.6.4.3.1 Reloader — watch Secret changes — restart Deployment — zero downtime

### 4.6.5 OPA / Gatekeeper & Kyverno
- 4.6.5.1 OPA Gatekeeper — admission webhook — Rego policies — ConstraintTemplates
  - 4.6.5.1.1 ConstraintTemplate — Rego logic — define rule — parameterized
  - 4.6.5.1.2 Constraint — instantiate template — scope to namespaces — enforce
  - 4.6.5.1.3 Mutation — MutatingAdmission — add labels/annotations — auto-inject
- 4.6.5.2 Kyverno — K8s-native — YAML policies — no Rego — simpler
  - 4.6.5.2.1 ClusterPolicy — validate + mutate + generate — three modes
  - 4.6.5.2.2 generate — create ConfigMap per namespace — auto-provision resources
