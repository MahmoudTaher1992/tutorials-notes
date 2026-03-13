# Cloud Design Patterns - Part 2: Scalability & Elasticity (I)

## 2.0 Scalability & Elasticity Patterns

### 2.1 Horizontal & Vertical Scaling
#### 2.1.1 Definitions & Core Distinction
- 2.1.1.1 Vertical scaling (scale-up) — increase CPU/RAM/disk on a single node
  - 2.1.1.1.1 Hardware ceilings — NUMA boundaries, PCIe bandwidth, memory bus saturation
  - 2.1.1.1.2 Cost curve — non-linear pricing; highest-tier instances have diminishing ROI
- 2.1.1.2 Horizontal scaling (scale-out) — add identical nodes behind a load balancer
  - 2.1.1.2.1 Shared-nothing architecture requirement — stateless compute nodes mandatory
  - 2.1.1.2.2 State externalization — session store → Redis; local disk → object storage
#### 2.1.2 Stateless Service Design
- 2.1.2.1 Session affinity (sticky sessions) — anti-pattern for horizontal scale; single node SPOF
  - 2.1.2.1.1 Why harmful — node failure loses session; prevents even load distribution
- 2.1.2.2 JWT-based stateless auth — self-contained tokens remove server-side session store
  - 2.1.2.2.1 Token validation — JWKS endpoint, signature verify, claim expiry check, audience check
- 2.1.2.3 Idempotency tokens — enable safe retry without duplicating side effects
  - 2.1.2.3.1 Implementation — UUID in request header; deduplication table with TTL in datastore
#### 2.1.3 Amdahl's Law & Scalability Limits
- 2.1.3.1 Amdahl's Law — max speedup = 1 / (1 - P + P/N); P = parallelizable fraction
  - 2.1.3.1.1 Practical ceiling — 95% parallel code → max 20× speedup regardless of node count
- 2.1.3.2 Universal Scalability Law (USL) — adds contention and coherency cost terms
  - 2.1.3.2.1 Contention parameter α — serialized resource acquisition (locks, DB writes)
  - 2.1.3.2.2 Coherency parameter β — cross-node coordination (cache invalidation, gossip syncs)
- 2.1.3.3 Knee of the curve — optimal operating point before coherency cost degrades throughput
#### 2.1.4 AKF Scale Cube
- 2.1.4.1 X-axis scaling — horizontal cloning; identical code, multiple instances
- 2.1.4.2 Y-axis scaling — functional decomposition; split by domain/service/bounded context
- 2.1.4.3 Z-axis scaling — data partitioning; route by tenant/key/region (sharding)
  - 2.1.4.3.1 Combined strategies — most large-scale systems apply all three axes simultaneously

### 2.2 Auto-Scaling Mechanisms
#### 2.2.1 Reactive Auto-Scaling
- 2.2.1.1 Metric-based threshold scaling — scale when CPU > N%, queue depth > M, latency > Xms
  - 2.2.1.1.1 Scale-out lag — time from metric breach to healthy new instance (EC2: 2-5 min, container: 30s)
  - 2.2.1.1.2 Hysteresis/cooldown — prevent thrashing; default 5-10 min between scale events
- 2.2.1.2 Step scaling — multiple thresholds with different add/remove quantities
  - 2.2.1.2.1 Example — +1 instance at 70% CPU, +2 at 80%, +4 at 90%
- 2.2.1.3 Target tracking scaling — maintain metric at a desired target value
  - 2.2.1.3.1 PID controller analogy — proportional adjustment to close the error gap continuously
#### 2.2.2 Predictive Auto-Scaling
- 2.2.2.1 Scheduled scaling — pre-warm capacity for known traffic patterns
  - 2.2.2.1.1 Cron expression scaling — scale up at 08:00 UTC Mon-Fri, down at 20:00 UTC
- 2.2.2.2 ML-based predictive scaling — forecast future load from historical patterns
  - 2.2.2.2.1 AWS Predictive Scaling — trains on 14-day CloudWatch metrics window
  - 2.2.2.2.2 Forecast horizon — launches capacity in advance to eliminate reactive lag
- 2.2.2.3 Event-driven pre-scaling — scale before known events (launches, flash sales, batch jobs)
#### 2.2.3 Scaling Signals & Metrics Hierarchy
- 2.2.3.1 Infrastructure metrics — CPU utilization, memory pressure, disk I/O, network throughput
- 2.2.3.2 Application metrics — request latency (p50/p95/p99), RPS, error rate, queue depth
  - 2.2.3.2.1 Latency as primary signal — more representative of user impact than CPU utilization
- 2.2.3.3 Custom business metrics — active sessions, orders/min, API calls per tenant
  - 2.2.3.3.1 Ingestion — CloudWatch Custom Metrics, Datadog, Prometheus + KEDA adapters
- 2.2.3.4 Composite metrics — weighted combination of signals for nuanced scaling decisions
#### 2.2.4 Scale-In Safety & Draining
- 2.2.4.1 Connection draining — stop new requests, allow in-flight to complete before termination
  - 2.2.4.1.1 ALB deregistration delay — default 300s; tune down for fast-response stateless services
- 2.2.4.2 Scale-in protection — mark specific instances ineligible for termination
  - 2.2.4.2.1 Use case — protect long-running batch jobs from mid-execution interruption
- 2.2.4.3 Graceful shutdown hooks — SIGTERM handler drains requests, flushes buffers, closes connections
  - 2.2.4.3.1 Kubernetes terminationGracePeriodSeconds — default 30s; tune per workload type
#### 2.2.5 Serverless Scaling Model
- 2.2.5.1 Scale-to-zero — no idle cost; cold start latency is the primary trade-off
  - 2.2.5.1.1 Cold start taxonomy — container init → runtime init → app init → handler init
  - 2.2.5.1.2 Mitigation strategies — provisioned concurrency (Lambda), min-instances (Cloud Run)
- 2.2.5.2 Concurrency limits — per-function ceiling prevents thundering herd on downstream
  - 2.2.5.2.1 Lambda reserved vs. provisioned concurrency — reservation guarantees; provisioning pre-warms
- 2.2.5.3 Regional burst limits — cloud-provider cap on instantaneous scale rate
  - 2.2.5.3.1 Lambda burst quota — 500-3000 initial instances/min depending on region
  - 2.2.5.3.2 Burst exhaustion — RequestThrottledException; requires SQS buffering upstream
#### 2.2.6 Kubernetes Scaling Primitives
- 2.2.6.1 Horizontal Pod Autoscaler (HPA) — scales Deployment/StatefulSet replicas
  - 2.2.6.1.1 Metrics APIs — resource metrics (CPU/mem), custom metrics, external metrics
  - 2.2.6.1.2 Scaling algorithm — desired = ceil(current × currentValue/desiredValue)
- 2.2.6.2 Vertical Pod Autoscaler (VPA) — adjusts CPU/memory requests and limits per pod
  - 2.2.6.2.1 VPA modes — Off (recommend only), Initial (set at creation), Auto (evict + recreate)
- 2.2.6.3 KEDA — event-driven autoscaling; scales to zero based on external event sources
  - 2.2.6.3.1 Scalers — Kafka lag, SQS queue depth, Prometheus query, Cron, Redis list length
- 2.2.6.4 Cluster Autoscaler — adds/removes nodes based on pending pod resource requests
  - 2.2.6.4.1 Scale-down threshold — 50% node utilization default; configurable scan interval
