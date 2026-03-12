# DevOps Engineering Study Guide - Part 4: Phase 1 — Kubernetes Architecture & Workloads

## 4.0 Container Orchestration — Kubernetes

### 4.1 Kubernetes Architecture
#### 4.1.1 Control Plane Components
- 4.1.1.1 API Server (kube-apiserver) — REST gateway — all writes go through
  - 4.1.1.1.1 Admission controllers — ValidatingAdmissionWebhook + MutatingAdmissionWebhook
  - 4.1.1.1.2 Authentication — x509 certs / OIDC / service account tokens
  - 4.1.1.1.3 Authorization — RBAC / ABAC / Node / Webhook — evaluated in order
  - 4.1.1.1.4 Rate limiting — APF (API Priority & Fairness) — prevent starvation
- 4.1.1.2 etcd — distributed KV — Raft consensus — source of truth
  - 4.1.1.2.1 Raft quorum — (N/2)+1 nodes needed — 3 or 5 node cluster recommended
  - 4.1.1.2.2 etcd compaction — truncate old revisions — prevent disk exhaustion
  - 4.1.1.2.3 etcd backup — etcdctl snapshot save — restore path for disaster recovery
  - 4.1.1.2.4 Watch API — controller watches etcd via API server — event-driven
- 4.1.1.3 Controller Manager — reconciliation loop controllers
  - 4.1.1.3.1 ReplicaSet controller — watch RS + pods — create/delete to match desired
  - 4.1.1.3.2 Node controller — heartbeat monitor — mark NotReady — evict pods
  - 4.1.1.3.3 Endpoint controller — update Service endpoints on pod change
- 4.1.1.4 Scheduler — assign pods to nodes — scoring + filtering
  - 4.1.1.4.1 Filtering — predicates — PodFitsResources, NodeSelector, Taints
  - 4.1.1.4.2 Scoring — priorities — LeastRequestedPriority, ImageLocalityPriority
  - 4.1.1.4.3 Scheduler extender — webhook — custom scoring logic
  - 4.1.1.4.4 Binding — scheduler writes pod.spec.nodeName — API server persists

#### 4.1.2 Node Components
- 4.1.2.1 kubelet — node agent — reconcile PodSpecs — manage container lifecycle
  - 4.1.2.1.1 Static pods — /etc/kubernetes/manifests — run before API server
  - 4.1.2.1.2 Pod lifecycle — create/start/health check/stop — CRI calls
  - 4.1.2.1.3 Eviction manager — disk/memory pressure — evict BestEffort first
- 4.1.2.2 kube-proxy — network rules — iptables / ipvs / eBPF
  - 4.1.2.2.1 iptables mode — DNAT chains per Service — connection tracking
  - 4.1.2.2.2 IPVS mode — kernel LB — O(1) lookup — large cluster performance
  - 4.1.2.2.3 eBPF mode (Cilium replaces) — XDP/TC hooks — skip netfilter
- 4.1.2.3 Container runtime — containerd / CRI-O — via CRI — pulls images, runs containers

### 4.2 Workloads
#### 4.2.1 Pod
- 4.2.1.1 Pod — atomic unit — one+ containers — shared net + IPC + storage
  - 4.2.1.1.1 Pause container — infra container — holds network namespace
  - 4.2.1.1.2 Init containers — sequential — must succeed — before app containers
  - 4.2.1.1.3 Sidecar containers (K8s 1.29+) — native sidecar — lifecycle tied to pod
- 4.2.1.2 Pod QoS classes — Guaranteed / Burstable / BestEffort
  - 4.2.1.2.1 Guaranteed — requests == limits for all containers — first protected
  - 4.2.1.2.2 Burstable — requests < limits — medium priority — evicted after BestEffort
  - 4.2.1.2.3 BestEffort — no requests/limits — evicted first under pressure

#### 4.2.2 Deployment
- 4.2.2.1 Deployment — declarative — manages ReplicaSets — rolling update
  - 4.2.2.1.1 Revision history — revisionHistoryLimit — rollback to prior RS
  - 4.2.2.1.2 Pause/resume — pause deployment — batch changes — unpause = single rollout
  - 4.2.2.1.3 minReadySeconds — delay before pod considered available — stabilize traffic

#### 4.2.3 StatefulSet
- 4.2.3.1 StatefulSet — stable identity — ordered deploy/scale — persistent volumes
  - 4.2.3.1.1 Pod name — {name}-0, {name}-1 — predictable — DNS entry per pod
  - 4.2.3.1.2 Headless Service — clusterIP: None — per-pod DNS — direct addressing
  - 4.2.3.1.3 volumeClaimTemplate — creates PVC per pod — not shared — independent
  - 4.2.3.1.4 updateStrategy: OnDelete — explicit delete to upgrade — manual control

#### 4.2.4 DaemonSet & Job
- 4.2.4.1 DaemonSet — one pod per node — node agent pattern
  - 4.2.4.1.1 Toleration — schedule on master/tainted nodes — monitoring agents
  - 4.2.4.1.2 updateStrategy: RollingUpdate — maxUnavailable — staged rollout
- 4.2.4.2 Job — run-to-completion — parallelism + completions
  - 4.2.4.2.1 backoffLimit — retry count — exponential back-off — 10 max default
  - 4.2.4.2.2 ttlSecondsAfterFinished — auto-delete completed jobs — clean up
- 4.2.4.3 CronJob — schedule + Job template — suspend flag — missed runs tracking
  - 4.2.4.3.1 concurrencyPolicy — Allow / Forbid / Replace — overlapping runs
  - 4.2.4.3.2 startingDeadlineSeconds — skip if missed by N seconds — catchup prevention

#### 4.2.5 Resource Requests & Limits
- 4.2.5.1 Requests — scheduler uses — guaranteed allocation — minimum needed
  - 4.2.5.1.1 CPU request — CFS shares — proportional — not reserved
  - 4.2.5.1.2 Memory request — soft guarantee — node allocatable basis
- 4.2.5.2 Limits — enforcement ceiling — OOM kill on memory exceed
  - 4.2.5.2.1 CPU throttling — CFS quota — cpu.cfs_quota_us / cpu.cfs_period_us
  - 4.2.5.2.2 Memory OOM — kernel kill process — container restart — watch logs
- 4.2.5.3 LimitRange — namespace default + max limits — prevent unbounded pods
  - 4.2.5.3.1 Default requests — auto-inject if not set — avoid BestEffort pods
- 4.2.5.4 ResourceQuota — namespace total CPU/memory/object count cap
  - 4.2.5.4.1 Quota enforcement — admission — reject if quota exceeded
  - 4.2.5.4.2 Scoped quota — Terminating / NotTerminating / BestEffort — separate budgets
