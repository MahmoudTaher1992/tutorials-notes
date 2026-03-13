# Cloud Design Patterns - Part 17: Observability & Operations (II) + Networking (I)

## 9.0 Observability & Operations Patterns (continued)

### 9.5 External Configuration Store
#### 9.5.1 Pattern Intent
- 9.5.1.1 Store application configuration externally — separate from deployment artifacts
- 9.5.1.2 Change configuration without redeployment; apply across multiple instances
#### 9.5.2 Configuration Store Types
- 9.5.2.1 Key-value stores — AWS Parameter Store, etcd, Consul KV, Azure App Configuration
  - 9.5.2.1.1 AWS SSM Parameter Store — tiered (Standard free, Advanced for >4KB); KMS encryption
  - 9.5.2.1.2 AWS AppConfig — feature flags + configuration; validation; gradual rollout
- 9.5.2.2 Environment-specific namespaces — /prod/service/db-url vs. /staging/service/db-url
#### 9.5.3 Configuration Access Patterns
- 9.5.3.1 Bootstrap loading — fetch all config at startup; simple but requires restart on change
- 9.5.3.2 Dynamic reload — watch for config changes; reload without restart
  - 9.5.3.2.1 Kubernetes ConfigMap reload — Reloader controller watches CM; triggers rolling restart
- 9.5.3.3 Hierarchical config — merge environment-specific over base config; override pattern
#### 9.5.4 Configuration Validation
- 9.5.4.1 Schema validation — validate config against JSON Schema or type system before applying
- 9.5.4.2 Pre-deployment validation — AWS AppConfig validators; reject invalid config before rollout
- 9.5.4.3 Canary config rollout — apply new config to 1% of fleet; verify before full rollout

### 9.6 Leader Election
#### 9.6.1 Pattern Intent
- 9.6.1.1 Elect a single leader among competing instances for singleton tasks
- 9.6.1.2 Prevent duplicate execution of scheduled jobs, DB maintenance, or coordination tasks
#### 9.6.2 Leader Election Algorithms
- 9.6.2.1 Distributed lock (Redis SETNX/SET NX PX) — first to acquire lock becomes leader
  - 9.6.2.1.1 Redlock — acquire lock on 3 of 5 Redis nodes; tolerate one node failure
  - 9.6.2.1.2 Lock TTL — auto-expire if leader crashes; new leader elected after TTL
- 9.6.2.2 etcd lease — leader holds lease; renews before expiry; follower watches for release
  - 9.6.2.2.1 Kubernetes leader election — used by kube-scheduler, kube-controller-manager
- 9.6.2.3 ZooKeeper ephemeral node — node deleted on crash; next sequential node becomes leader
#### 9.6.3 Leader Responsibilities & Failover
- 9.6.3.1 Leader does singleton work — all other instances idle on this task; standby mode
- 9.6.3.2 Failover latency — time from leader crash to new election + new leader start
  - 9.6.3.2.1 Minimize with short lease TTL — trade recovery speed vs. false failure detection
- 9.6.3.3 Split-brain prevention — ensure old leader stops work before new leader starts
  - 9.6.3.3.1 Fencing token — monotonically increasing token; downstream rejects stale leader operations

### 9.7 Scheduler Agent Supervisor
#### 9.7.1 Pattern Intent
- 9.7.1.1 Coordinate distributed multi-step tasks; recover from failures; maintain progress
- 9.7.1.2 Three roles: Scheduler (assigns tasks), Agent (executes tasks), Supervisor (monitors)
#### 9.7.2 Component Responsibilities
- 9.7.2.1 Scheduler — breaks work into tasks; assigns to agents; tracks overall progress state
- 9.7.2.2 Agent — executes assigned task; reports result (success/failure) to scheduler
- 9.7.2.3 Supervisor — monitors agents; detects failures; instructs scheduler to reschedule
#### 9.7.3 State Machine & Recovery
- 9.7.3.1 Task states — Pending → Assigned → Running → Completed / Failed → Rescheduled
- 9.7.3.2 Checkpointing — persist task progress; resume from checkpoint not from beginning
- 9.7.3.3 Idempotent task execution — safe to re-run if agent crashes mid-execution

---

## 10.0 Networking & Topology Patterns

### 10.1 Service Discovery
#### 10.1.1 Pattern Intent
- 10.1.1.1 Dynamically locate service instances — addresses change with scaling and failures
- 10.1.1.2 Decouple consumers from static service endpoint configuration
#### 10.1.2 Client-Side Discovery
- 10.1.2.1 Client queries registry; selects instance using client-side load balancing logic
  - 10.1.2.1.1 Eureka + Ribbon (Spring Cloud) — client fetches registry; Ribbon load balances
- 10.1.2.2 Client holds registry cache — resilient to registry outage; stale entries possible
#### 10.1.3 Server-Side Discovery
- 10.1.3.1 Client sends request to load balancer; LB queries registry and routes
  - 10.1.3.1.1 AWS ALB + ECS service discovery — LB queries target groups populated by ECS
- 10.1.3.2 DNS-based discovery — service name resolves to healthy instance IPs via DNS SRV records
  - 10.1.3.2.1 Kubernetes Services — ClusterIP DNS; kube-dns resolves service to stable virtual IP
#### 10.1.4 Service Registry
- 10.1.4.1 Consul — health-checked registry; KV store; multi-datacenter federation
- 10.1.4.2 etcd — strongly consistent KV; Kubernetes uses as service registry backbone
- 10.1.4.3 Kubernetes Endpoints / EndpointSlices — registry built into control plane; no separate service

### 10.2 DNS-Based vs. Client-Side Load Balancing
#### 10.2.1 DNS-Based Load Balancing
- 10.2.1.1 Return multiple A records per DNS query; client picks first or random
  - 10.2.1.1.1 DNS TTL problem — stale cached IPs after instance removal; client keeps routing to dead IP
- 10.2.1.2 Route 53 weighted records — DNS-layer weighted split for blue/green or canary
- 10.2.1.3 Low TTL trade-off — more DNS queries, higher DNS infrastructure load
#### 10.2.2 Client-Side Load Balancing
- 10.2.2.1 gRPC client-side LB — picks channel per RPC; understands server streams
  - 10.2.2.1.1 LB policies — round_robin, pick_first, weighted_round_robin, xDS-based
- 10.2.2.2 Service mesh client-side LB — Envoy sidecar intercepts and load balances
- 10.2.2.3 Locality-aware routing — prefer same AZ/zone for lower latency and reduced data transfer cost
  - 10.2.2.3.1 AWS target group AZ affinity — route within AZ before crossing AZ boundary
