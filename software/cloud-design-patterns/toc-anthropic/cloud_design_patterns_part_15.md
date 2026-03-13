# Cloud Design Patterns - Part 15: Deployment & Release

## 8.0 Deployment & Release Patterns

### 8.1 Blue-Green Deployment
#### 8.1.1 Pattern Intent
- 8.1.1.1 Maintain two identical production environments — blue (live) and green (new)
- 8.1.1.2 Instant cutover with instant rollback capability
#### 8.1.2 Deployment Mechanics
- 8.1.2.1 Deploy new version to idle (green) environment while blue serves traffic
- 8.1.2.2 Run smoke tests and validation against green before cutover
- 8.1.2.3 Cutover — shift 100% traffic from blue to green (DNS update, LB weight, ingress change)
  - 8.1.2.3.1 DNS cutover — TTL must be low (30-60s) for fast switch; DNS propagation lag
  - 8.1.2.3.2 LB weight cutover — ALB/NLB target group swap; near-instant switchover
#### 8.1.3 Rollback Strategy
- 8.1.3.1 Rollback = shift traffic back to blue; no code changes required
- 8.1.3.2 Keep blue warm — do not decommission until green is fully stable (monitor 1+ hours)
#### 8.1.4 Database Schema Challenges
- 8.1.4.1 Schema must be backward-compatible — both versions run simultaneously during cutover
- 8.1.4.2 Expand-contract pattern — add new column, deploy, migrate data, remove old column
- 8.1.4.3 DB migration timing — run before deployment to ensure both blue/green can read new schema

### 8.2 Canary Releases
#### 8.2.1 Pattern Intent
- 8.2.1.1 Gradually shift traffic to new version — detect issues before full rollout
- 8.2.1.2 Named after canary-in-coal-mine — small exposure first, full rollout only if healthy
#### 8.2.2 Traffic Splitting Strategies
- 8.2.2.1 Random percentage split — route X% of requests to canary, 100-X% to stable
  - 8.2.2.1.1 LB weighted target groups, Istio VirtualService weights, Argo Rollouts
- 8.2.2.2 Sticky canary — same user always routed to canary via cookie/header
  - 8.2.2.2.1 Use case — UI changes need consistent experience per session
- 8.2.2.3 Cohort-based — route by user ID range, geography, or feature flag segment
#### 8.2.3 Canary Analysis
- 8.2.3.1 Automated analysis — compare error rate, latency, and business metrics between versions
  - 8.2.3.1.1 Argo Rollouts + Prometheus — automated canary analysis; auto-rollback on failure
- 8.2.3.2 Statistical significance — require sufficient request volume before declaring canary healthy
- 8.2.3.3 Canary promotion gates — manual approval or automated threshold pass required to proceed
#### 8.2.4 Progressive Delivery
- 8.2.4.1 0% → 5% → 20% → 50% → 100% rollout stages with health checks between
- 8.2.4.2 Flagger + Kubernetes — automated progressive delivery controller; integrates with service mesh

### 8.3 Feature Flags / Feature Toggles
#### 8.3.1 Toggle Types
- 8.3.1.1 Release toggle — hide incomplete feature; enables trunk-based development
- 8.3.1.2 Experiment toggle — A/B testing; measure impact of feature variant
- 8.3.1.3 Ops toggle — kill switch for production incidents; disable misbehaving feature instantly
- 8.3.1.4 Permission toggle — enable feature for specific users, tenants, or roles
#### 8.3.2 Feature Flag Services
- 8.3.2.1 LaunchDarkly — streaming SDK; per-user targeting; analytics; experiments
  - 8.3.2.1.1 Streaming vs. polling — streaming flag delivery in <100ms vs. polling interval
- 8.3.2.2 OpenFeature — open standard SDK; vendor-neutral; CNCF incubating project
- 8.3.2.3 Unleash — self-hosted; flexible strategy plugins; GitOps-compatible
#### 8.3.3 Flag Evaluation Architecture
- 8.3.3.1 Server-side evaluation — flags evaluated in app process; flag values not exposed to client
- 8.3.3.2 Client-side evaluation — flag values bootstrapped to browser/mobile app; fast evaluation
- 8.3.3.3 Edge evaluation — flags evaluated at CDN edge for zero-latency personalization
#### 8.3.4 Flag Hygiene
- 8.3.4.1 Flag debt — unused flags accumulate; require ownership and expiry dates on every flag
- 8.3.4.2 Flag testing — test all flag combinations (2^N paths); limit active flags to <20

### 8.4 Immutable Infrastructure
#### 8.4.1 Pattern Intent
- 8.4.1.1 Never modify running servers — replace with new instances built from updated image
- 8.4.1.2 Eliminates configuration drift and "snowflake" server problem
#### 8.4.2 Image-Based Deployment
- 8.4.2.1 Golden image — machine image (AMI, GCE image) baked with all dependencies pre-installed
- 8.4.2.2 Container image — Docker image; immutable layer stack; reproducible across environments
  - 8.4.2.2.1 Distroless/scratch base — minimal attack surface; no shell, no package manager
#### 8.4.3 Immutability Enforcement
- 8.4.3.1 Read-only root filesystem — Kubernetes securityContext.readOnlyRootFilesystem: true
- 8.4.3.2 No SSH access to running instances — connect via SSM Session Manager or ephemeral debug pods
- 8.4.3.3 Deny mutations — OPA/Kyverno policy denies image updates to running pods

### 8.5 GitOps / Declarative State
#### 8.5.1 Pattern Intent
- 8.5.1.1 Git repository is single source of truth for desired system state
- 8.5.1.2 Automated reconciliation — controller continuously syncs actual state to declared state
#### 8.5.2 GitOps Tooling
- 8.5.2.1 Argo CD — pull-based; compares live cluster to Git; syncs on drift; application health view
- 8.5.2.2 Flux CD — push and pull modes; image automation; multi-tenancy support
- 8.5.2.3 GitOps workflow — PR → review → merge → auto-sync; full audit trail in Git history
#### 8.5.3 GitOps Security
- 8.5.3.1 Branch protection — require PR approval; no direct pushes to main/production branch
- 8.5.3.2 Signed commits — GPG/sigstore commit signing; verify author identity
- 8.5.3.3 Sealed Secrets / External Secrets — secrets encrypted in Git or referenced from Vault

### 8.6 Rolling Updates & Pod Disruption
#### 8.6.1 Rolling Update Strategy
- 8.6.1.1 Replace pods incrementally — maxSurge (extra pods) and maxUnavailable (tolerated down)
  - 8.6.1.1.1 Default — maxSurge=25%, maxUnavailable=25%; safe for most stateless services
- 8.6.1.2 Readiness probe gates — new pods only added to LB after readiness check passes
#### 8.6.2 Pod Disruption Budgets (PDB)
- 8.6.2.1 minAvailable — guarantee minimum healthy pods during voluntary disruptions
- 8.6.2.2 maxUnavailable — limit pods that can be unavailable simultaneously
- 8.6.2.3 PDB blocks — node drain blocked if disruption would violate PDB; protects availability
