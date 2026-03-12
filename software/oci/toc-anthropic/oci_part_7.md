# OCI Complete Study Guide - Part 7: Phase 1 — Containers & Serverless

## 7.0 Containers & Serverless

### 7.1 Oracle Kubernetes Engine (OKE)
#### 7.1.1 OKE Control Plane
- 7.1.1.1 Managed control plane — OCI-operated — multi-AD HA — no charge
  - 7.1.1.1.1 API server endpoint — public or private — VCN firewall rules
  - 7.1.1.1.2 Kubernetes version — LTS + standard — 3 versions supported simultaneously
  - 7.1.1.1.3 In-place upgrade — control plane first → node pools — version skew rules
- 7.1.1.2 Cluster types — Basic vs. Enhanced
  - 7.1.1.2.1 Basic — VCN-native pod networking not available — older CNI
  - 7.1.1.2.2 Enhanced — VCN-native pod networking — pod direct VNIC — full OCI features

#### 7.1.2 OKE Node Pools
- 7.1.2.1 Node pool — set of nodes — same shape + OS image + subnets
  - 7.1.2.1.1 Managed nodes — OCI manages OS — automatic security patches
  - 7.1.2.1.2 Self-managed nodes — customer-managed — custom AMI — BYOI
  - 7.1.2.1.3 Virtual nodes — serverless — no node management — pod-level billing
- 7.1.2.2 Node pool autoscaler — Kubernetes Cluster Autoscaler — min/max nodes
  - 7.1.2.2.1 Scale up — pending pods → add node — 2-4 min provisioning
  - 7.1.2.2.2 Scale down — underutilized node → drain + delete — safe eviction

#### 7.1.3 OKE Networking
- 7.1.3.1 VCN-native pod networking — each pod gets VNIC IP — no overlay
  - 7.1.3.1.1 Pod subnet — separate from node subnet — CIDR plan for scale
  - 7.1.3.1.2 NLB for services — type: LoadBalancer → OCI NLB provisioned — native
- 7.1.3.2 Flannel CNI — overlay network — VXLAN — default for Basic clusters
  - 7.1.3.2.1 Pod CIDR — 10.244.0.0/16 default — separate from node/VCN CIDR
- 7.1.3.3 Network policies — OCI Flannel does not support — requires Calico install
  - 7.1.3.3.1 Calico overlay — add-on — NetworkPolicy enforcement — pod microseg

#### 7.1.4 OKE Storage & Security
- 7.1.4.1 OCI CSI Driver — dynamic PVC provisioning — block volumes + file storage
  - 7.1.4.1.1 StorageClass — oci-bv — block volume — ReadWriteOnce
  - 7.1.4.1.2 StorageClass — oci-fss — file storage NFS — ReadWriteMany
- 7.1.4.2 OCI Vault secrets — inject into pods — External Secrets Operator
  - 7.1.4.2.1 ESO — ExternalSecret CRD — sync Vault secret → K8s Secret — TTL refresh
- 7.1.4.3 Workload Identity — pod SA → OCI IAM policy — keyless OCI API access
  - 7.1.4.3.1 OCI Instance Principals — node-level — less precise — avoid for prod
  - 7.1.4.3.2 OKE Workload Identity — pod-level principal — precise IAM — recommended

#### 7.1.5 OKE Add-ons
- 7.1.5.1 Managed add-ons — OCI manages lifecycle — CoreDNS, kube-proxy, metrics-server
  - 7.1.5.1.1 Add-on config — override via key/value — tuning without manual YAML
- 7.1.5.2 Cluster extensions — KEDA, Argo CD, OCI Service Operator — marketplace
  - 7.1.5.2.1 OCI Service Operator for Kubernetes (OSOK) — provision OCI resources as CRDs

### 7.2 Container Instances
#### 7.2.1 Container Instances Architecture
- 7.2.1.1 Serverless containers — no K8s — direct container run — OCI-managed
  - 7.2.1.1.1 Container Instance — 1+ containers — shared network + storage — pod-like
  - 7.2.1.1.2 Shape — Flex — specify OCPU + RAM — right-size per workload
- 7.2.1.2 Use cases — ephemeral jobs, CI steps, simple APIs — not persistent services
  - 7.2.1.2.1 Image pull — OCIR private registry — instance principal auth
  - 7.2.1.2.2 Environment variables + config file mounts — secret injection from Vault

### 7.3 Functions (Fn Project)
#### 7.3.1 Functions Architecture
- 7.3.1.1 Managed Fn Project — open-source base — Docker-based — event-driven
  - 7.3.1.1.1 Application — logical group of functions — config + network attachment
  - 7.3.1.1.2 Function — OCI container image — invoked via HTTPS — auto-scale to zero
- 7.3.1.2 Runtimes — Java, Python, Ruby, Go, Node.js — custom Docker image
  - 7.3.1.2.1 Custom image — FROM fnproject/python:3.9 — any dependency
  - 7.3.1.2.2 GraalVM native image — Java → native binary — sub-100ms cold start

#### 7.3.2 Function Invocation & Scaling
- 7.3.2.1 Synchronous invocation — HTTPS POST — wait for response — 300s timeout
  - 7.3.2.1.1 OCI CLI: fn invoke — SDK — API Gateway integration — Event trigger
- 7.3.2.2 Asynchronous invocation — via Events / Notifications / Streaming → Function
  - 7.3.2.2.1 OCI Events action — invoke function on resource change
  - 7.3.2.2.2 Service Connector Hub — stream messages → function batch processing
- 7.3.2.3 Scaling — cold start — container reuse — concurrency 1 per container
  - 7.3.2.3.1 Cold start factors — image size + runtime init + dependency loading
  - 7.3.2.3.2 Provisioned concurrency — pre-warm containers — consistent latency

#### 7.3.3 Functions Security & Networking
- 7.3.3.1 Dynamic groups + policies — function principal — access OCI resources
  - 7.3.3.1.1 Allow dynamic-group fn-dg to manage objects in compartment — policy example
- 7.3.3.2 VCN integration — function in subnet — access private resources — no internet needed
  - 7.3.3.2.1 Private endpoint — function → private DB — no public IP exposure
- 7.3.3.3 OCIR — Oracle Container Image Registry — store function images
  - 7.3.3.3.1 Auth token — docker login — namespace/repo:tag — deploy pipeline
