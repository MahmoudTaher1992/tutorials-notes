# DevOps Engineering Study Guide - Part 5: Phase 1 — K8s Networking, Storage & Scheduling

## 4.2 Kubernetes Networking
### 4.2.1 CNI & Pod Networking
#### 4.2.1.1 CNI Fundamentals
- 4.2.1.1.1 CNI spec — plugin called at pod create/delete — configure network namespace
  - 4.2.1.1.1.1 ADD command — create veth pair — assign IP — add route
  - 4.2.1.1.1.2 DEL command — tear down on pod delete — reclaim IP
- 4.2.1.1.2 Pod network requirements — every pod gets unique IP — routable
  - 4.2.1.1.2.1 Pod-to-pod — no NAT — any pod can reach any pod — flat network
  - 4.2.1.1.2.2 Pod-to-service — kube-proxy rules — clusterIP virtual IP

#### 4.2.1.2 CNI Plugins
- 4.2.1.2.1 Flannel — VXLAN overlay — simple — no NetworkPolicy support
- 4.2.1.2.2 Calico — eBPF or iptables — BGP routing — NetworkPolicy — performance
  - 4.2.1.2.2.1 BGP peering — advertise pod CIDRs — no encapsulation — pure L3
  - 4.2.1.2.2.2 Calico eBPF — replace kube-proxy — XDP — near wire speed
- 4.2.1.2.3 Cilium — eBPF-native — L7 policy — Hubble observability — best performance
  - 4.2.1.2.3.1 FQDN-based policy — egress by domain — no IP management
  - 4.2.1.2.3.2 Hubble — per-flow visibility — Grafana dashboard — no sidecar

### 4.2.2 Services
- 4.2.2.1 ClusterIP — virtual IP — iptables/IPVS DNAT — cluster-internal only
  - 4.2.2.1.1 Stable DNS — {svc}.{ns}.svc.cluster.local — pods rely on DNS not IP
- 4.2.2.2 NodePort — expose on every node — port 30000–32767 — external access
  - 4.2.2.2.1 Hairpin NAT — pod → service back to same pod — requires masquerade
- 4.2.2.3 LoadBalancer — cloud LB provisioned — EXTERNAL-IP — production ingress
  - 4.2.2.3.1 Cloud controller manager — watches Service — provisions LB — updates status
- 4.2.2.4 Headless Service — clusterIP: None — DNS A records per pod — stateful
  - 4.2.2.4.1 Used with StatefulSet — pod-0.svc.ns — direct pod addressing

### 4.2.3 Ingress & Gateway API
- 4.2.3.1 Ingress — L7 routing — host/path rules → Service — TLS termination
  - 4.2.3.1.1 IngressClass — multiple controllers — nginx / traefik / haproxy
  - 4.2.3.1.2 TLS — spec.tls — Secret with cert — controller handles termination
- 4.2.3.2 Gateway API — next-gen Ingress — HTTPRoute / GRPCRoute / TCPRoute
  - 4.2.3.2.1 Separation of concerns — Gateway (infra) + HTTPRoute (app) — multi-team
  - 4.2.3.2.2 Traffic weighting — HTTPRoute backendRefs — canary with standard K8s

---

## 4.3 Kubernetes Storage
### 4.3.1 Persistent Volumes
#### 4.3.1.1 PV / PVC Lifecycle
- 4.3.1.1.1 Static provisioning — admin creates PV — PVC claims by selector
- 4.3.1.1.2 Dynamic provisioning — PVC + StorageClass — controller creates PV
  - 4.3.1.1.2.1 StorageClass provisioner — cloud-specific — aws-ebs / gce-pd / oci-bv
  - 4.3.1.1.2.2 volumeBindingMode: WaitForFirstConsumer — delay until pod scheduled
- 4.3.1.1.3 Reclaim policy — Retain / Delete / Recycle — on PVC delete
  - 4.3.1.1.3.1 Retain — PV stays — manual cleanup — data preserved
  - 4.3.1.1.3.2 Delete — PV + underlying storage deleted — default for dynamic

#### 4.3.1.2 CSI Drivers
- 4.3.1.2.1 CSI spec — standardized — replaces in-tree drivers — 3 components
  - 4.3.1.2.1.1 Controller plugin — create/delete/attach/detach volumes — stateful
  - 4.3.1.2.1.2 Node plugin — DaemonSet — mount/unmount — per-node
  - 4.3.1.2.1.3 External provisioner — watches PVCs — calls CreateVolume
- 4.3.1.2.2 Volume snapshots — VolumeSnapshot CRD — point-in-time — restore to PVC
  - 4.3.1.2.2.1 VolumeSnapshotContent — actual snapshot — provisioner-managed

---

## 4.4 Scheduling & Resource Management
### 4.4.1 Node Affinity & Taints
#### 4.4.1.1 Node Selectors & Affinity
- 4.4.1.1.1 nodeSelector — simple label match — required hard rule
- 4.4.1.1.2 nodeAffinity — required + preferred — complex expressions
  - 4.4.1.1.2.1 requiredDuringSchedulingIgnoredDuringExecution — hard — no match = pending
  - 4.4.1.1.2.2 preferredDuringScheduling — soft — try best — place anywhere if fail
- 4.4.1.1.3 podAffinity / podAntiAffinity — co-locate or spread relative to other pods
  - 4.4.1.1.3.1 TopologyKey: kubernetes.io/hostname — anti-affinity per node — HA spread

#### 4.4.1.2 Taints & Tolerations
- 4.4.1.2.1 Taint — mark node — NoSchedule / PreferNoSchedule / NoExecute
  - 4.4.1.2.1.1 NoExecute — evict existing pods without toleration — immediate
  - 4.4.1.2.1.2 Dedicated nodes — taint for GPU — only GPU-requesting pods land
- 4.4.1.2.2 Toleration — pod allows taint — necessary but not sufficient (affinity needed)

### 4.4.2 Priority & Preemption
- 4.4.2.1 PriorityClass — integer value — higher = more important
  - 4.4.2.1.1 system-cluster-critical — 2000000000 — kube-system pods
  - 4.4.2.1.2 Preemption — scheduler evicts lower-priority pod — make room
- 4.4.2.2 PodDisruptionBudget (PDB) — min available / max unavailable — rolling safety
  - 4.4.2.2.1 Blocks drain — eviction API refuses if PDB violated — safe cluster upgrades

### 4.4.3 Topology Spread Constraints
- 4.4.3.1 topologySpreadConstraints — spread pods across zones/nodes — HA + efficiency
  - 4.4.3.1.1 maxSkew: 1 — max difference between zones — balanced distribution
  - 4.4.3.1.2 whenUnsatisfiable: DoNotSchedule — hard — ScheduleAnyway = soft
