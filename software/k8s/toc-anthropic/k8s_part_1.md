# Kubernetes Complete Study Guide (Ideal / Angel Method)
## Part 1: Ideal Kubernetes — Architecture & Core Workloads

---

### 1. Architecture & Control Plane

#### 1.1 The Kubernetes Design Philosophy
- 1.1.1 Desired state reconciliation — declare what you want, control loops converge to it
- 1.1.2 Declarative vs imperative — `kubectl apply` vs `kubectl run/create`
- 1.1.3 Everything is an API object — uniform REST interface for all resources
- 1.1.4 Level-triggered vs edge-triggered — controllers react to current state, not events
- 1.1.5 Self-healing — automatic restart, rescheduling, replacement of failed components
- 1.1.6 Extensibility — CRDs, admission webhooks, custom controllers, operators

#### 1.2 Control Plane Components
- 1.2.1 kube-apiserver — RESTful gateway, validates + persists all objects to etcd
- 1.2.2 etcd — distributed key-value store, sole source of cluster truth, Raft consensus
- 1.2.3 kube-scheduler — watches unscheduled pods, selects optimal node via predicates + priorities
- 1.2.4 kube-controller-manager — runs built-in controllers (Deployment, ReplicaSet, Node, etc.)
- 1.2.5 cloud-controller-manager — cloud-specific control loops (LoadBalancer, Node lifecycle)
- 1.2.6 Control plane HA — multi-master, stacked vs external etcd, odd quorum (3/5/7)

#### 1.3 Node (Data Plane) Components
- 1.3.1 kubelet — node agent, watches PodSpecs, manages container lifecycle, reports status
- 1.3.2 kube-proxy — maintains iptables/IPVS rules for Service ClusterIP routing
- 1.3.3 Container runtime — CRI interface, containerd (default), CRI-O, Docker (deprecated)
- 1.3.4 Node conditions — Ready, MemoryPressure, DiskPressure, PIDPressure, NetworkUnavailable
- 1.3.5 Node lease — kubelet heartbeat via Lease objects in `kube-node-lease` namespace
- 1.3.6 Static pods — kubelet-managed pods defined in `/etc/kubernetes/manifests/`

#### 1.4 The Kubernetes API
- 1.4.1 API groups — core (`/api/v1`), named (`/apis/apps/v1`, `/apis/batch/v1`)
- 1.4.2 API versioning — `alpha` (unstable), `beta` (may change), `stable` (GA)
- 1.4.3 Resource vs subresource — `/pods` vs `/pods/{name}/exec`, `/pods/{name}/log`
- 1.4.4 Watch mechanism — long-poll streaming of resource changes (`?watch=true`)
- 1.4.5 `kubectl api-resources` — list all supported resource types
- 1.4.6 `kubectl explain` — inline API schema documentation

---

### 2. Pods

#### 2.1 Pod Fundamentals
- 2.1.1 Pod as atomic unit — one or more containers sharing network + PID namespace
- 2.1.2 Pod lifecycle phases — Pending → Running → Succeeded/Failed/Unknown
- 2.1.3 Container states — Waiting, Running, Terminated
- 2.1.4 Restart policies — Always, OnFailure, Never
- 2.1.5 Pod IP — unique per pod, ephemeral, not reused after restart
- 2.1.6 `kubectl get pod -o wide` — show node, IP, nominated node, readiness gates

#### 2.2 Multi-Container Patterns
- 2.2.1 Sidecar — extends main container (log shipper, service mesh proxy, secrets refresher)
- 2.2.2 Init container — sequential pre-run setup (migrations, wait-for-service, populate volume)
- 2.2.3 Ambassador — proxy local connections to outside world (env-specific routing)
- 2.2.4 Adapter — normalize output of main container for external consumers
- 2.2.5 Ephemeral containers — added to running pods for debugging (`kubectl debug`)
- 2.2.6 Shared volumes between containers — emptyDir, in-pod IPC via filesystem

#### 2.3 Pod Spec Deep Dive
- 2.3.1 `containers[].command` vs `args` — override ENTRYPOINT vs CMD
- 2.3.2 `env` / `envFrom` — inline vars, ConfigMap refs, Secret refs, field refs
- 2.3.3 `resources.requests` — scheduler uses this for placement decisions
- 2.3.4 `resources.limits` — cgroup enforced caps; CPU throttle, memory OOM kill
- 2.3.5 `livenessProbe` — restart container if fails (HTTP, TCP, exec, gRPC)
- 2.3.6 `readinessProbe` — remove from Service endpoints if fails
- 2.3.7 `startupProbe` — protect slow-starting containers from liveness kill
- 2.3.8 `terminationGracePeriodSeconds` — SIGTERM → wait → SIGKILL window
- 2.3.9 `securityContext` — `runAsNonRoot`, `readOnlyRootFilesystem`, `capabilities`
- 2.3.10 `imagePullPolicy` — Always, IfNotPresent, Never

---

### 3. Core Workload Controllers

#### 3.1 ReplicaSet
- 3.1.1 Purpose — maintain N healthy pod replicas at all times
- 3.1.2 Label selector — pods owned by ReplicaSet via `matchLabels`/`matchExpressions`
- 3.1.3 Pod template — spec for creating replacement pods
- 3.1.4 Adoption — RS adopts existing pods matching its selector
- 3.1.5 Scaling — `kubectl scale rs <name> --replicas=5`
- 3.1.6 Direct use — rare; almost always managed by Deployment

#### 3.2 Deployment
- 3.2.1 Manages ReplicaSets — creates new RS per rollout, scales old RS down
- 3.2.2 Rolling update — `maxUnavailable`, `maxSurge` control rollout speed
- 3.2.3 Recreate strategy — delete all old pods, then create new (downtime accepted)
- 3.2.4 `kubectl rollout status` — watch rollout progress
- 3.2.5 `kubectl rollout undo` — rollback to previous ReplicaSet
- 3.2.6 `kubectl rollout history` — view revision history
- 3.2.7 Pausing rollout — `kubectl rollout pause/resume`
- 3.2.8 `.spec.progressDeadlineSeconds` — fail if rollout stalls this long

#### 3.3 StatefulSet
- 3.3.1 Stable network identity — `pod-0`, `pod-1` — predictable DNS names
- 3.3.2 Stable storage — each pod gets its own PVC via `volumeClaimTemplates`
- 3.3.3 Ordered deployment — pods created sequentially (0 → 1 → 2), deleted reverse
- 3.3.4 Ordered updates — `RollingUpdate` with `partition` for staged rollouts
- 3.3.5 Headless Service requirement — `clusterIP: None` for direct pod DNS
- 3.3.6 Pod DNS pattern — `<pod>.<svc>.<ns>.svc.cluster.local`

#### 3.4 DaemonSet
- 3.4.1 One pod per node — runs on every node (or subset via `nodeSelector`/`tolerations`)
- 3.4.2 Use cases — log collectors (Fluentd), node monitors, CNI plugins, storage agents
- 3.4.3 Node affinity with DS — schedule only on nodes with specific labels
- 3.4.4 Rolling updates — `maxUnavailable` controls update rollout
- 3.4.5 `kubectl get ds -o wide` — check desired/current/ready per node

#### 3.5 Jobs & CronJobs
- 3.5.1 Job — run one or more pods to completion, retry on failure
- 3.5.2 Job parallelism — `parallelism` + `completions` for work-queue patterns
- 3.5.3 Completion modes — NonIndexed, Indexed (stable pod identity per index)
- 3.5.4 `backoffLimit` — number of retries before Job marked Failed
- 3.5.5 `activeDeadlineSeconds` — hard timeout for entire Job
- 3.5.6 CronJob — schedule Jobs with cron syntax, `concurrencyPolicy` (Allow/Forbid/Replace)
- 3.5.7 `successfulJobsHistoryLimit` / `failedJobsHistoryLimit` — keep N old jobs
- 3.5.8 `startingDeadlineSeconds` — miss window → skip this run

#### 3.6 Horizontal Pod Autoscaler (HPA)
- 3.6.1 HPA controller — watches metrics, adjusts `.spec.replicas` of target workload
- 3.6.2 CPU-based autoscaling — `targetCPUUtilizationPercentage` (v1 API)
- 3.6.3 Custom metrics — HPA v2 supports memory, custom, external metrics
- 3.6.4 `minReplicas` / `maxReplicas` — guard rails for autoscaling
- 3.6.5 Stabilization window — cooldown to prevent thrashing
- 3.6.6 KEDA — Kubernetes Event-Driven Autoscaling, scale-to-zero support
