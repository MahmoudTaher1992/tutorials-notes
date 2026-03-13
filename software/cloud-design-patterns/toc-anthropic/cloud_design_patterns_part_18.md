# Cloud Design Patterns - Part 18: Networking (II) + Cost Optimization

## 10.0 Networking & Topology Patterns (continued)

### 10.3 Traffic Splitting & Mirroring
#### 10.3.1 Traffic Splitting
- 10.3.1.1 Percentage-based split — weighted routing across service versions or backends
  - 10.3.1.1.1 Istio VirtualService weight — route 90% to v1, 10% to v2
- 10.3.1.2 Header-based routing — route specific users/tenants to different backend
  - 10.3.1.2.1 x-beta-user: true → route to canary; all others → stable
- 10.3.1.3 Session-consistent routing — ensure same user always goes to same version
#### 10.3.2 Traffic Mirroring (Shadow Testing)
- 10.3.2.1 Mirror live traffic to shadow service — shadow processes request but response discarded
  - 10.3.2.1.1 Istio traffic mirroring — mirror: {host: v2, subset: shadow} in VirtualService
- 10.3.2.2 Use cases — validate new version with production traffic before cutover
- 10.3.2.3 Shadow service side effects — must not write to production DB or send emails
  - 10.3.2.3.1 Mitigation — shadow uses separate database; mock external integrations

### 10.4 Static Content Hosting & CDN
#### 10.4.1 CDN Architecture
- 10.4.1.1 Edge Points of Presence (PoPs) — serve cached content from location nearest to user
- 10.4.1.2 Origin — canonical source; edge fetches from origin on cache miss (origin pull)
- 10.4.1.3 Cache key — URL + selected headers/cookies; vary carefully to avoid fragmentation
#### 10.4.2 Cache Control Strategy
- 10.4.2.1 Cache-Control: max-age=N — CDN and browser cache for N seconds
- 10.4.2.2 Cache-Control: s-maxage=N — CDN-specific TTL; overrides max-age for shared caches
- 10.4.2.3 Versioned asset URLs — hash in filename (app.a3f2b1.js); immutable cache; 1-year TTL
  - 10.4.2.3.1 Content hash — change file → change URL → automatic CDN cache bust
- 10.4.2.4 Cache invalidation — Cloudfront CreateInvalidation, Cloudflare Purge; costly if frequent
#### 10.4.3 CDN Security
- 10.4.3.1 Origin shield — restrict origin to accept requests only from CDN IP ranges
- 10.4.3.2 DDoS absorption — CDN absorbs volumetric L3/L4 attacks before reaching origin
- 10.4.3.3 Signed URLs/cookies — protect premium content; time-limited CDN access token

### 10.5 Private Endpoint & Network Segmentation
#### 10.5.1 Private Endpoints
- 10.5.1.1 AWS VPC Endpoint — access AWS service (S3, DynamoDB) without internet gateway
  - 10.5.1.1.1 Interface endpoint — elastic network interface in VPC; PrivateLink based
  - 10.5.1.1.2 Gateway endpoint — route table entry for S3/DynamoDB; no per-GB charge
- 10.5.1.2 Azure Private Link — private IP for PaaS service within VNet
- 10.5.1.3 Benefits — traffic stays on backbone; data exfiltration prevention; no NAT gateway cost
#### 10.5.2 Network Segmentation
- 10.5.2.1 VPC/VNet subnets — public (internet-routable), private (internal), isolated (no routing)
- 10.5.2.2 Security Groups — stateful L4 firewall; ingress/egress rules per resource
- 10.5.2.3 Network ACLs — stateless subnet-level rules; ordered evaluation; explicit allow/deny
- 10.5.2.4 Transit Gateway — hub-and-spoke multi-VPC routing; centralized routing table

---

## 11.0 Cost Optimization Patterns

### 11.1 Serverless Economics & Cold Start Trade-offs
#### 11.1.1 Serverless Cost Model
- 11.1.1.1 Pay-per-invocation — billed per request + duration (rounded to 1ms); no idle cost
- 11.1.1.2 Breakeven analysis — Lambda becomes cost-effective vs. EC2 below ~30% utilization
  - 11.1.1.2.1 EC2 right-sizing — over-provisioned EC2 often 60-80% idle; serverless eliminates this
#### 11.1.2 Cold Start Mitigation
- 11.1.2.1 Provisioned concurrency — pre-warmed instances; eliminates cold start; fixed monthly cost
- 11.1.2.2 Language runtime selection — Java/C# cold start ~1-3s; Node.js/Python ~100-500ms
- 11.1.2.3 Container reuse optimization — minimize Lambda init code; warm cache in global scope
- 11.1.2.4 SnapStart (Lambda Java) — snapshot initialized execution environment; near-zero cold start

### 11.2 Spot / Preemptible Instance Patterns
#### 11.2.1 Spot Instance Model
- 11.2.1.1 AWS Spot — spare EC2 capacity at 60-90% discount; 2-min termination notice
- 11.2.1.2 GCP Preemptible / Spot VMs — up to 91% discount; 30s preemption notice
#### 11.2.2 Spot Interruption Handling
- 11.2.2.1 Checkpoint workloads — save state every N minutes; resume after replacement instance starts
- 11.2.2.2 Drain on notification — receive spot interruption notice via metadata; drain in-flight
- 11.2.2.3 Spot + On-demand mix — run 80% spot, 20% on-demand; maintain capacity on interruption
  - 11.2.2.3.1 AWS Auto Scaling mixed instances policy — diversify across instance types and AZs
#### 11.2.3 Suitable Workloads for Spot
- 11.2.3.1 Batch processing — MapReduce, video transcoding, ML training; resumable
- 11.2.3.2 Stateless web tier — behind ALB; new instance replaces spot automatically
- 11.2.3.3 Unsuitable — databases, stateful services without replication

### 11.3 Right-Sizing & Bin-Packing
#### 11.3.1 Right-Sizing
- 11.3.1.1 CPU/memory utilization analysis — 2-week baseline; identify idle vs. over-provisioned
  - 11.3.1.1.1 AWS Compute Optimizer — ML-based recommendations; 10-30% cost reduction typical
- 11.3.1.2 VPA for Kubernetes — auto-adjust pod CPU/memory requests based on actual usage
- 11.3.1.3 Graviton/Arm instances — 20-40% better price/performance vs. x86; compatible workloads
#### 11.3.2 Bin-Packing
- 11.3.2.1 Pack multiple workloads on same instance to maximize utilization
- 11.3.2.2 Kubernetes scheduler packing strategy — LeastAllocated (spread) vs. MostAllocated (pack)
- 11.3.2.3 Multi-tenant density — co-locate non-competing workloads (CPU-bound + I/O-bound)

### 11.4 Resource Scheduling & Auto-Shutdown
#### 11.4.1 Non-Production Environment Scheduling
- 11.4.1.1 Shutdown dev/staging at night and weekends — 70% cost reduction on non-production
- 11.4.1.2 AWS Instance Scheduler — tag-based start/stop on cron; Lambda-driven
- 11.4.1.3 Kubernetes Goldilocks — namespace scale-down during off-hours; cronjob-driven
#### 11.4.2 Cost Tagging & Attribution
- 11.4.2.1 Mandatory cost tags — team, environment, product, cost-center on all resources
- 11.4.2.2 AWS Cost Allocation Tags — filter billing by tag in Cost Explorer
- 11.4.2.3 FinOps practice — shared ownership of cloud costs; weekly spend reviews per team
