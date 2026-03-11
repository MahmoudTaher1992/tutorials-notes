# Kubernetes Complete Study Guide (Ideal / Angel Method)
## Part 4: Ideal Kubernetes — Scheduling, Operations & Observability

---

### 9. Scheduling & Resource Management

#### 9.1 The Scheduler
- 9.1.1 Scheduling cycle — filter (predicates) → score (priorities) → bind
- 9.1.2 Filtering plugins — NodeResourcesFit, NodeAffinity, TaintToleration, PodTopologySpread
- 9.1.3 Scoring plugins — LeastAllocated, BalancedAllocation, NodeAffinity weight
- 9.1.4 Binding — kubelet watches for pods bound to its node, takes over
- 9.1.5 Scheduling queue — activeQ, backoffQ, unschedulableQ
- 9.1.6 `scheduler-config` — KubeSchedulerConfiguration, custom plugin weights

#### 9.2 Node Selection
- 9.2.1 `nodeSelector` — simple key-value label matching (hard requirement)
- 9.2.2 Node Affinity — `requiredDuringScheduling` (hard) vs `preferredDuringScheduling` (soft)
- 9.2.3 Pod Affinity — co-locate pods with other pods matching label selector
- 9.2.4 Pod Anti-Affinity — spread pods away from each other (HA across zones)
- 9.2.5 Taints — node repels pods that don't tolerate the taint (`NoSchedule`, `PreferNoSchedule`, `NoExecute`)
- 9.2.6 Tolerations — pod declares willingness to be scheduled on tainted nodes
- 9.2.7 `topologySpreadConstraints` — spread pods evenly across zones/racks
- 9.2.8 `nodeName` — bypass scheduler, assign pod directly to node (debugging)

#### 9.3 Resource Quotas & Limits
- 9.3.1 ResourceQuota — per-namespace cap on CPU, memory, object counts
- 9.3.2 LimitRange — default/min/max resource requests+limits per container
- 9.3.3 QoS classes — Guaranteed (req=limit), Burstable (req<limit), BestEffort (no req/limit)
- 9.3.4 OOM priority — BestEffort killed first, Guaranteed last
- 9.3.5 CPU throttling — limits enforced via CFS bandwidth, limit≠latency bound
- 9.3.6 `requests` for scheduling — scheduler bins pods by requested resources only

#### 9.4 Cluster Autoscaler & VPA
- 9.4.1 Cluster Autoscaler (CA) — add/remove nodes based on pending pods
- 9.4.2 CA scale-up trigger — pod Unschedulable → CA provisions new node
- 9.4.3 CA scale-down — node underutilized for 10min, pods safely evicted
- 9.4.4 Vertical Pod Autoscaler (VPA) — right-size resource requests based on actual usage
- 9.4.5 VPA modes — Off (recommend only), Initial, Auto (update running pods)
- 9.4.6 KEDA — event-driven autoscaling, scale to zero, 50+ scalers

---

### 10. Cluster Operations

#### 10.1 Namespaces
- 10.1.1 Namespace purpose — soft isolation boundary, scopes names and quota
- 10.1.2 Default namespaces — `default`, `kube-system`, `kube-public`, `kube-node-lease`
- 10.1.3 Resource quota per namespace — CPU, memory, object count limits
- 10.1.4 Cross-namespace access — Services via FQDN `svc.ns.svc.cluster.local`
- 10.1.5 Namespace lifecycle — Terminating state when deletion in progress
- 10.1.6 Multi-tenancy patterns — namespace-per-team, namespace-per-app, cluster-per-tenant

#### 10.2 Cluster Maintenance
- 10.2.1 `kubectl drain` — evict pods from node, cordon node first
- 10.2.2 `kubectl cordon` — mark node unschedulable (no new pods)
- 10.2.3 `kubectl uncordon` — return node to schedulable state
- 10.2.4 PodDisruptionBudget (PDB) — protect availability during voluntary disruptions
- 10.2.5 `minAvailable` / `maxUnavailable` — PDB constraints on disruptions
- 10.2.6 Node drain with PDB — drain waits for PDB compliance before evicting

#### 10.3 Cluster Upgrades
- 10.3.1 Upgrade order — control plane first, then worker nodes
- 10.3.2 kubeadm upgrade plan — check target version compatibility
- 10.3.3 `kubeadm upgrade apply` — upgrade control plane components
- 10.3.4 kubelet + kubectl upgrade — manual per-node after kubeadm
- 10.3.5 N-1/N-2 version skew — supported skew between components
- 10.3.6 Zero-downtime upgrades — rolling node upgrade with PDB protection

#### 10.4 etcd Operations
- 10.4.1 etcd backup — `etcdctl snapshot save`, daily + before upgrades
- 10.4.2 etcd restore — `etcdctl snapshot restore`, then restart API server
- 10.4.3 etcd health — `etcdctl endpoint health`, `etcdctl member list`
- 10.4.4 etcd compaction — free old revisions, `--auto-compaction-retention`
- 10.4.5 etcd defragment — reclaim disk space after compaction
- 10.4.6 etcd quorum — 3-node needs 2 alive, 5-node needs 3 alive

---

### 11. Observability

#### 11.1 Logging
- 11.1.1 `kubectl logs` — `--follow`, `--previous`, `--since`, `--tail`, `--container`
- 11.1.2 Node-level logging — container logs written to node, rotated by kubelet
- 11.1.3 Cluster-level logging — DaemonSet agent (Fluentd/Fluent Bit) ships to central store
- 11.1.4 Log aggregation targets — Elasticsearch/OpenSearch, Loki, CloudWatch, Splunk
- 11.1.5 Structured logging — JSON format, log level field, trace ID in logs
- 11.1.6 Sidecar log streaming — sidecar container ships app log files to stdout

#### 11.2 Metrics
- 11.2.1 Metrics Server — in-cluster lightweight metrics pipeline, feeds HPA + `kubectl top`
- 11.2.2 `kubectl top pods/nodes` — current CPU/memory usage
- 11.2.3 Prometheus — pull-based metrics scraping, TSDB storage, PromQL
- 11.2.4 kube-state-metrics — expose object state as Prometheus metrics
- 11.2.5 node-exporter — OS-level metrics per node (CPU, disk, network)
- 11.2.6 Grafana dashboards — cluster overview, pod metrics, SLO tracking
- 11.2.7 `ServiceMonitor` (Prometheus Operator) — declarative scrape config for services

#### 11.3 Tracing
- 11.3.1 OpenTelemetry — vendor-neutral tracing SDK + collector
- 11.3.2 Jaeger / Tempo / Zipkin — distributed trace backends
- 11.3.3 Auto-instrumentation — OTel operator injects agent via init container
- 11.3.4 Trace context propagation — W3C TraceContext headers across services
- 11.3.5 Service mesh tracing — Istio/Linkerd inject trace headers automatically

#### 11.4 Events & Alerts
- 11.4.1 Kubernetes Events — `kubectl get events --sort-by=.lastTimestamp`
- 11.4.2 Event recorder — components write events to API server (warnings, normals)
- 11.4.3 Alertmanager — route Prometheus alerts to PagerDuty, Slack, email
- 11.4.4 AlertRules — PromQL expressions with severity, runbook annotations
- 11.4.5 `kubectl describe` — surfaces Events for specific object
- 11.4.6 Event TTL — events expire after 1 hour by default

---

### 12. Advanced Resources

#### 12.1 Custom Resources & Operators
- 12.1.1 CRD (Custom Resource Definition) — extend Kubernetes API with new types
- 12.1.2 CR (Custom Resource) — instance of a CRD, stored in etcd like built-in objects
- 12.1.3 Operator pattern — CR + custom controller implementing domain logic
- 12.1.4 controller-runtime / kubebuilder — framework for building operators in Go
- 12.1.5 Operator SDK — Helm-based, Ansible-based, Go-based operator scaffolding
- 12.1.6 Operator Hub / OLM — marketplace and lifecycle manager for operators

#### 12.2 Resource Validation & Webhooks
- 12.2.1 Structural schemas — OpenAPI v3 schema in CRD `validation` for type enforcement
- 12.2.2 CEL validation rules — `x-kubernetes-validations` for complex field validation
- 12.2.3 Conversion webhooks — serve multiple CRD versions simultaneously
- 12.2.4 Defaulting webhooks — MutatingWebhook sets defaults on create/update

#### 12.3 Multi-tenancy & Isolation
- 12.3.1 Virtual clusters (vcluster) — lightweight K8s inside K8s for full isolation
- 12.3.2 Hierarchical namespaces (HNC) — namespace trees with policy inheritance
- 12.3.3 Kata Containers — VM-based container isolation for untrusted workloads
- 12.3.4 gVisor — user-space kernel sandbox for syscall isolation
