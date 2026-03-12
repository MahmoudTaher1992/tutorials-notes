# OCI Complete Study Guide - Part 13: Phase 2 — Containers, Serverless & Integration

## 16.0 OCI Containers & Serverless

### 16.1 OKE-Unique Features
→ See Ideal §7.1 OKE Architecture, §7.2 Container Instances, §7.3 Functions

#### 16.1.1 OKE-Unique Features
- **Unique: VCN-native pod networking** — pod gets real VNIC IP — no overlay — direct routing
  - 16.1.1.1 Pod subnet separate from node subnet — CIDR planning critical for scale
  - 16.1.1.2 Pod-to-service — no kube-proxy masquerade — native VCN route
  - 16.1.1.3 NSG on pods — security list/NSG rules apply to pod VNIC directly
- **Unique: Virtual Nodes** — OCI-managed serverless nodes — pod-level billing — no node mgmt
  - 16.1.1.4 Per-pod OCPU + memory — no node pool — scale to zero — cost-efficient
  - 16.1.1.5 Mix virtual + managed nodes — node selector — flex workload placement
- **Unique: OCI CSI Driver** — block volumes + file storage — dynamic PVC — ReadWriteMany
  - 16.1.1.6 FSS StorageClass — NFS multi-writer — shared volume across pods
  - 16.1.1.7 Block volume PVC — ReadWriteOnce — detach/reattach — preserve data on pod restart
- **Unique: Workload Identity** — pod SA → OCI IAM policy — keyless — pod-level principal
  - 16.1.1.8 No instance principal for pods — workload identity more precise
  - 16.1.1.9 OCI Service Operator (OSOK) — provision ADB/Streaming/Queue as K8s CRDs
- **Unique: OKE Cluster Add-ons** — OCI-managed — CoreDNS, kube-proxy, metrics-server
  - 16.1.1.10 Add-on lifecycle — OCI upgrades with cluster — no manual Helm chart updates
  - 16.1.1.11 KEDA, Argo CD — OCI marketplace add-ons — one-click install
- **Unique: Enhanced cluster** — OCI VCN-native pod networking + virtual nodes + workload identity
  - 16.1.1.12 Basic clusters lack VCN-native pod networking — always use Enhanced

#### 16.1.2 Container Instances-Unique Features
- **Unique: Serverless containers without K8s** — direct VNIC — VCN — OCI IAM
  - 16.1.2.1 Instance principal — no pod SA complexity — simpler IAM for jobs
  - 16.1.2.2 Flex shape — precise OCPU/RAM — no cluster overhead — cost-efficient batch

#### 16.1.3 Functions-Unique Features
- **Unique: Based on Fn Project (open-source)** — portable — run locally or on OCI
  - 16.1.3.1 fn CLI — local run + test — same as OCI deployment — dev parity
  - 16.1.3.2 Fn flow — orchestrate function chains — DAG — saga pattern
- **Unique: VCN-attached Functions** — access private endpoints — no internet required
  - 16.1.3.3 Private subnet — function → private DB / Streaming — no public IP
- **Unique: Dynamic group for Functions** — function.compartment.id condition
  - 16.1.3.4 keyless OCI API access — no credentials in function code
- **Unique: Service Connector Hub as function trigger** — stream/log/metric → function
  - 16.1.3.5 Bulk processing — batch of messages → function invocation — throughput

---

## 17.0 OCI Integration Services

### 17.1 Streaming & Messaging-Unique Features
→ See Ideal §6.4 Notifications, §6.5 Events

#### 17.1.1 OCI Streaming-Unique Features
- **Unique: Kafka API compatible** — drop-in Kafka producer/consumer — no code change
  - 17.1.1.1 SASL/PLAIN auth — Kafka client → OCI Streaming — auth token as password
  - 17.1.1.2 Kafka consumer groups — offset management — at-least-once delivery
- **Unique: Private Stream Pool** — VCN-attached endpoint — FQDN — no internet
  - 17.1.1.3 On-prem Kafka bridge via FastConnect → private stream pool — secure path
- **Unique: Service Connector Hub** — no-code pipeline — stream → Object Storage / Functions
  - 17.1.1.4 Log → stream → function pipeline — serverless log processing — OCI native

#### 17.1.2 OCI Queue-Unique Features
- **Unique: Guaranteed delivery + FIFO per channel** — more durable than Streaming
  - 17.1.2.1 Channel-based FIFO — ordered per channel — parallel channels for scale
  - 17.1.2.2 Visibility timeout + DLQ — transactional semantics — reliable processing
- **Unique: Stats endpoint** — queue depth + in-flight count — Monitoring integration
  - 17.1.2.3 Alarm on queue depth — scale consumer function — reactive throughput

#### 17.1.3 API Gateway-Unique Features
- **Unique: OCI Functions as backend** — serverless API — no compute needed
  - 17.1.3.1 Zero-infra API — API GW + Function — scale to zero — pay per request
- **Unique: OCI IAM Authorizer** — IDCS OAuth tokens — built-in — no custom authorizer
  - 17.1.3.2 Scope-based access — define scopes in IDCS — API GW validates inline
- **Unique: Dynamic routing** — multiple backend versions — header-based routing
  - 17.1.3.3 Canary API — route % to new function version — gradual rollout

#### 17.1.4 OCI Integration Cloud (OIC)-Unique Features
- **Unique: OIC** — iPaaS — 400+ pre-built adapters — Oracle SaaS native connectors
  - 17.1.4.1 Oracle ERP + HCM + SCM adapters — native SOAP/REST — no custom code
  - 17.1.4.2 Process Automation — BPMN workflows — human tasks — approval flows
  - 17.1.4.3 Visual Builder Studio — low-code apps — Oracle JET UI — integrated with OIC
