# Kubernetes Complete Study Guide (Ideal / Angel Method)
## Part 2: Ideal Kubernetes — Networking

---

### 4. Kubernetes Networking Model

#### 4.1 Networking Fundamentals
- 4.1.1 Flat pod network — every pod gets a routable IP, no NAT between pods
- 4.1.2 Three networking challenges — container-to-container, pod-to-pod, pod-to-service
- 4.1.3 Node-to-pod routing — each node gets a pod CIDR subnet
- 4.1.4 `--cluster-cidr` — pod IP range for whole cluster
- 4.1.5 `--service-cluster-ip-range` — virtual IP range for Services
- 4.1.6 CNI spec — Container Network Interface, pluggable binary + config standard

#### 4.2 CNI Plugins
- 4.2.1 Flannel — simple VXLAN overlay, easy setup, limited features
- 4.2.2 Calico — BGP routing or overlay, NetworkPolicy, eBPF dataplane
- 4.2.3 Cilium — eBPF-based, L7 policy, observability (Hubble), no kube-proxy needed
- 4.2.4 Weave Net — mesh overlay, automatic encryption
- 4.2.5 AWS VPC CNI — native VPC IPs for pods (no overlay on EKS)
- 4.2.6 Azure CNI — native VNet IPs, integrates with NSGs
- 4.2.7 CNI plugin selection criteria — NetworkPolicy support, performance, cloud integration

---

### 5. Services

#### 5.1 Service Fundamentals
- 5.1.1 Service purpose — stable virtual IP + DNS name for a dynamic set of pods
- 5.1.2 Label selector — Service routes to pods matching `selector`
- 5.1.3 Endpoints / EndpointSlices — auto-maintained list of healthy pod IPs
- 5.1.4 `kube-proxy` modes — iptables (default), IPVS (scalable), eBPF (Cilium)
- 5.1.5 Session affinity — `ClientIP` sticky sessions, timeout configurable
- 5.1.6 External traffic policy — `Cluster` (SNAT, balanced) vs `Local` (no SNAT, node-local only)

#### 5.2 Service Types
- 5.2.1 ClusterIP — virtual IP reachable only within cluster (default)
- 5.2.2 NodePort — exposes service on `<nodeIP>:<nodePort>` (30000-32767)
- 5.2.3 LoadBalancer — provisions cloud LB, gets external IP from cloud controller
- 5.2.4 ExternalName — CNAME to external DNS name, no proxying
- 5.2.5 Headless Service (`clusterIP: None`) — DNS returns pod IPs directly, no virtual IP
- 5.2.6 Multi-port Services — multiple `ports` entries in one Service spec

#### 5.3 DNS & Service Discovery
- 5.3.1 CoreDNS — default cluster DNS, resolves `<svc>.<ns>.svc.cluster.local`
- 5.3.2 Service DNS record — A record (ClusterIP) or SRV records for named ports
- 5.3.3 Pod DNS record — `<pod-ip>.<ns>.pod.cluster.local`
- 5.3.4 StatefulSet pod DNS — `<pod>.<svc>.<ns>.svc.cluster.local`
- 5.3.5 `ndots:5` in resolv.conf — search suffixes tried before absolute lookup
- 5.3.6 CoreDNS ConfigMap — customize forward zones, stub zones, rewrite rules

#### 5.4 Ingress
- 5.4.1 Ingress purpose — L7 HTTP/HTTPS routing, single LB for many services
- 5.4.2 Ingress controller — must be deployed separately (nginx, traefik, HAProxy, Kong)
- 5.4.3 Host-based routing — `host: app.example.com` → route to Service
- 5.4.4 Path-based routing — `/api` → backend-svc, `/` → frontend-svc
- 5.4.5 TLS termination — `tls:` block, Secret with `tls.crt` / `tls.key`
- 5.4.6 `IngressClass` — select which controller handles this Ingress
- 5.4.7 Annotations — nginx-specific tuning (`proxy-read-timeout`, `ssl-redirect`)
- 5.4.8 Gateway API — successor to Ingress, `Gateway`, `HTTPRoute`, `GRPCRoute` resources

#### 5.5 Network Policy
- 5.5.1 Default behavior — all pods accept all traffic (deny-all requires explicit policy)
- 5.5.2 Ingress policy — restrict which pods/namespaces/IP blocks can reach this pod
- 5.5.3 Egress policy — restrict where this pod can send traffic
- 5.5.4 `podSelector` — apply policy to matching pods in same namespace
- 5.5.5 `namespaceSelector` — allow traffic from specific namespaces
- 5.5.6 `ipBlock` — allow traffic from CIDR ranges (external IPs)
- 5.5.7 Default deny-all pattern — empty `podSelector` + empty `ingress:[]`
- 5.5.8 CNI enforcement — NetworkPolicy is only enforced if CNI supports it (Calico, Cilium)

#### 5.6 Advanced Networking
- 5.6.1 Service mesh — Istio, Linkerd, Consul Connect — mTLS, traffic management, observability
- 5.6.2 Istio sidecar injection — Envoy proxy injected into every pod
- 5.6.3 VirtualService / DestinationRule — Istio traffic shifting, retries, circuit breaking
- 5.6.4 Multi-cluster networking — Istio multi-cluster, Submariner, Cilium ClusterMesh
- 5.6.5 IPv6 / dual-stack — `--dual-stack-support`, pods get IPv4 + IPv6
- 5.6.6 EndpointSlice — scalable replacement for Endpoints (sharded, max 100 endpoints each)
