# Kubernetes Complete Study Guide (Ideal / Angel Method)
## Part 3: Ideal Kubernetes — Storage, Configuration & Security

---

### 6. Storage

#### 6.1 Volume Types
- 6.1.1 `emptyDir` — ephemeral, shared between containers in pod, wiped on pod removal
- 6.1.2 `hostPath` — mounts node filesystem path (dangerous, breaks pod portability)
- 6.1.3 `configMap` / `secret` — project ConfigMap/Secret data as files into pod
- 6.1.4 `projected` — combine multiple sources (SA token, ConfigMap, Secret, downwardAPI)
- 6.1.5 `downwardAPI` — expose pod metadata (labels, annotations, resource limits) as files
- 6.1.6 CSI volumes — Container Storage Interface, pluggable storage drivers

#### 6.2 Persistent Volumes
- 6.2.1 PersistentVolume (PV) — cluster-level storage resource (admin-provisioned or dynamic)
- 6.2.2 PersistentVolumeClaim (PVC) — namespaced request for storage (size, access mode, class)
- 6.2.3 Access modes — ReadWriteOnce, ReadOnlyMany, ReadWriteMany, ReadWriteOncePod
- 6.2.4 Reclaim policies — Retain (keep data), Delete (auto-delete), Recycle (deprecated)
- 6.2.5 Volume binding — Static (manual PV pre-created) vs Dynamic (StorageClass provisions)
- 6.2.6 Volume expansion — `allowVolumeExpansion: true` in StorageClass

#### 6.3 StorageClass
- 6.3.1 StorageClass — defines provisioner + parameters for dynamic PV creation
- 6.3.2 Default StorageClass — used when PVC omits `storageClassName`
- 6.3.3 Provisioners — `kubernetes.io/aws-ebs`, `pd.csi.storage.gke.io`, `disk.csi.azure.com`
- 6.3.4 `reclaimPolicy` on StorageClass — defaults for dynamically provisioned PVs
- 6.3.5 `volumeBindingMode: WaitForFirstConsumer` — delay binding until pod scheduled (zone-aware)
- 6.3.6 CSI drivers — `ebs.csi.aws.com`, `filestore.csi.storage.gke.io` for cloud storage

#### 6.4 StatefulSet Storage Pattern
- 6.4.1 `volumeClaimTemplates` — per-pod PVC created automatically by StatefulSet controller
- 6.4.2 PVC naming — `<claim-name>-<statefulset-name>-<ordinal>`
- 6.4.3 PVC retention policy — `whenDeleted`, `whenScaled` — Retain or Delete
- 6.4.4 Manual PVC cleanup — PVCs not auto-deleted on SS deletion (by default)

---

### 7. Configuration Management

#### 7.1 ConfigMaps
- 7.1.1 ConfigMap purpose — decouple configuration from container images
- 7.1.2 Data sources — literal key-value, file contents, directory of files
- 7.1.3 Consume as env vars — `envFrom.configMapRef`, `env.valueFrom.configMapKeyRef`
- 7.1.4 Consume as volume — mount ConfigMap as files, live-updates after ~60s
- 7.1.5 Immutable ConfigMaps — `immutable: true` — prevents updates, improves perf at scale
- 7.1.6 `kubectl create configmap` — from literal, from file, from env-file

#### 7.2 Secrets
- 7.2.1 Secret types — Opaque, kubernetes.io/tls, kubernetes.io/dockerconfigjson, token
- 7.2.2 Base64 encoding — NOT encryption, just encoding for YAML safety
- 7.2.3 Encryption at rest — EncryptionConfiguration with KMS provider (mandatory for prod)
- 7.2.4 Consume as env vars — `envFrom.secretRef`, `env.valueFrom.secretKeyRef`
- 7.2.5 Consume as volume — tmpfs mount, memory-backed (not written to node disk)
- 7.2.6 Immutable Secrets — `immutable: true` — cannot be modified after creation
- 7.2.7 External Secrets Operator — sync from Vault, AWS SSM, GCP Secret Manager
- 7.2.8 Sealed Secrets — encrypt Secret YAML for safe git storage

---

### 8. Security

#### 8.1 RBAC (Role-Based Access Control)
- 8.1.1 Subjects — User, Group, ServiceAccount
- 8.1.2 Role — namespaced set of permissions (verbs on resources)
- 8.1.3 ClusterRole — cluster-scoped or namespaced-reusable permissions
- 8.1.4 RoleBinding — bind Role to subject in a namespace
- 8.1.5 ClusterRoleBinding — bind ClusterRole to subject cluster-wide
- 8.1.6 Common verbs — get, list, watch, create, update, patch, delete
- 8.1.7 Wildcard `*` — grants all verbs or all resources (avoid in production)
- 8.1.8 `kubectl auth can-i` — test permissions for current user or impersonated user

#### 8.2 Service Accounts
- 8.2.1 ServiceAccount — identity for pods, automatically mounted as token
- 8.2.2 Default SA — every namespace has `default` SA, auto-assigned if unspecified
- 8.2.3 Projected SA token — time-limited, audience-bound tokens (vs legacy auto-mount)
- 8.2.4 `automountServiceAccountToken: false` — disable for pods that don't need API access
- 8.2.5 Workload Identity — GKE/EKS map SA to cloud IAM role (no secret needed)
- 8.2.6 IRSA (IAM Roles for Service Accounts) — AWS EKS SA-to-IAM role annotation

#### 8.3 Pod Security
- 8.3.1 Pod Security Standards — Privileged, Baseline, Restricted profiles
- 8.3.2 Pod Security Admission (PSA) — enforced at namespace level via labels
- 8.3.3 `securityContext.runAsNonRoot: true` — reject pods running as root
- 8.3.4 `securityContext.readOnlyRootFilesystem: true` — immutable container root
- 8.3.5 `allowPrivilegeEscalation: false` — block setuid escalation
- 8.3.6 `capabilities.drop: ["ALL"]` — drop all Linux capabilities, add back only needed
- 8.3.7 Seccomp profiles — `RuntimeDefault`, `Localhost` custom profiles
- 8.3.8 AppArmor annotations — per-container AppArmor profile selection

#### 8.4 Admission Controllers
- 8.4.1 Admission webhook types — MutatingAdmissionWebhook, ValidatingAdmissionWebhook
- 8.4.2 Common built-in controllers — LimitRanger, ResourceQuota, NamespaceLifecycle
- 8.4.3 OPA/Gatekeeper — policy-as-code, ConstraintTemplate + Constraint resources
- 8.4.4 Kyverno — K8s-native policy engine, validate/mutate/generate resources
- 8.4.5 Webhook failure policy — `Fail` (block if webhook down) vs `Ignore`
- 8.4.6 `dry-run` mode — test webhook without enforcing

#### 8.5 etcd & API Security
- 8.5.1 etcd encryption at rest — EncryptionConfiguration, KMS envelope encryption
- 8.5.2 mTLS everywhere — all control plane communication uses TLS client certificates
- 8.5.3 API server audit logging — capture all API requests for compliance
- 8.5.4 `--anonymous-auth=false` — disable unauthenticated API access
- 8.5.5 `--authorization-mode=RBAC,Node` — ensure RBAC is enabled
- 8.5.6 CIS Kubernetes Benchmark — `kube-bench` tool to scan against hardening checklist

#### 8.6 Supply Chain & Image Security
- 8.6.1 Image scanning — Trivy, Grype, Snyk in CI pipeline and registry
- 8.6.2 Image signing — cosign + Sigstore, keyless OIDC signing
- 8.6.3 `imagePullPolicy: Always` — for mutable tags in production
- 8.6.4 Private registry pull secrets — `kubectl create secret docker-registry`
- 8.6.5 Admission image policy — block unsigned or vulnerable images via webhook
- 8.6.6 Falco — runtime threat detection via syscall monitoring
