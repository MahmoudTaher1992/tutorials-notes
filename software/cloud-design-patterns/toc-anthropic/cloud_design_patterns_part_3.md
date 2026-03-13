# Cloud Design Patterns - Part 3: Scalability & Elasticity (II)

## 2.0 Scalability & Elasticity Patterns (continued)

### 2.3 Load Balancing Algorithms
#### 2.3.1 Layer 4 vs. Layer 7 Load Balancing
- 2.3.1.1 L4 (transport layer) — routes on TCP/UDP 4-tuple; no HTTP awareness; sub-ms overhead
  - 2.3.1.1.1 AWS NLB, GCP TCP Proxy LB — millions of RPS; preserves client IP; static IP support
- 2.3.1.2 L7 (application layer) — routes on HTTP headers, path, hostname, cookies
  - 2.3.1.2.1 AWS ALB, GCP HTTPS LB — content-based routing, WAF integration, TLS termination
  - 2.3.1.2.2 Enables A/B testing, canary routing, host-based virtual hosting
#### 2.3.2 Balancing Algorithms
- 2.3.2.1 Round-robin — sequential distribution; best for homogeneous stateless backends
- 2.3.2.2 Weighted round-robin — proportional traffic by backend weight
  - 2.3.2.2.1 Use case — canary deployments; route 5% traffic to new version, 95% to stable
- 2.3.2.3 Least connections — route to backend with fewest active connections
  - 2.3.2.3.1 Best for — long-lived connections: WebSocket, gRPC streaming, database proxies
- 2.3.2.4 Least response time — combines active connections + measured average response latency
- 2.3.2.5 IP hash — deterministic routing by client IP; pseudo-session affinity without sticky flag
- 2.3.2.6 Consistent hashing — distributes keys across ring; minimizes remapping on node change
  - 2.3.2.6.1 Virtual nodes — improve distribution uniformity; Cassandra uses 256 tokens/node
#### 2.3.3 Health Checks for Load Balancers
- 2.3.3.1 Passive health checking — detect failures via observed 5xx/timeout on live traffic
- 2.3.3.2 Active health probes — periodic HTTP GET / TCP connect to registered backend
  - 2.3.3.2.1 Parameters — check interval (10s), healthy threshold (2), unhealthy threshold (3)
- 2.3.3.3 Deep health check endpoint — verify downstream dependencies (DB, cache) not just HTTP 200
  - 2.3.3.3.1 Risk — cascading deregistrations if shared DB is slow; use timeout not hard failure
#### 2.3.4 Global Load Balancing & Traffic Management
- 2.3.4.1 GeoDNS routing — resolve DNS to nearest regional endpoint
  - 2.3.4.1.1 Latency-based routing (Route 53) — route to region with lowest measured RTT
  - 2.3.4.1.2 Geolocation routing — route EU users to EU region for data residency compliance
- 2.3.4.2 Anycast routing — same IP announced from multiple POPs; BGP routes to nearest POP
- 2.3.4.3 Failover routing — primary region fails → automatic DNS TTL-based failover to secondary
  - 2.3.4.3.1 DNS TTL trade-off — low TTL enables fast failover; high TTL reduces DNS query load

### 2.4 Rate Limiting & Throttling
#### 2.4.1 Rate Limiting Algorithms
- 2.4.1.1 Token bucket — tokens replenish at fixed rate; burst up to bucket capacity allowed
  - 2.4.1.1.1 Parameters — refill rate r (tokens/sec), bucket size b (max burst tokens)
  - 2.4.1.1.2 Implementation — Redis INCR + EXPIRE or atomic Lua script for race safety
- 2.4.1.2 Leaky bucket — requests drain at constant rate; excess queued or dropped
  - 2.4.1.2.1 Vs. token bucket — no burst allowance; strict constant output rate; smooths spikes
- 2.4.1.3 Fixed window counter — count requests per discrete time window; resets at boundary
  - 2.4.1.3.1 Boundary burst attack — 2× burst possible straddling adjacent window edges
- 2.4.1.4 Sliding window log — track exact request timestamps; precise but memory-intensive
- 2.4.1.5 Sliding window counter — interpolates across two fixed windows; balances accuracy vs. memory
  - 2.4.1.5.1 Formula — rate = prev_count × (1 - elapsed_fraction) + current_count
#### 2.4.2 Throttling Strategies
- 2.4.2.1 Per-user / per-API-key — quota per tenant prevents single consumer from starving others
- 2.4.2.2 Per-endpoint — different limits for reads vs. writes vs. expensive aggregations
- 2.4.2.3 Priority-based — premium tier requests bypass standard limits with dedicated quota
- 2.4.2.4 Adaptive throttling — dynamically adjust limits based on downstream health signals
  - 2.4.2.4.1 Google SRE client-side throttling — reject locally when error ratio > threshold
  - 2.4.2.4.2 Formula — P(reject) = max(0, (requests - K × accepts) / (requests + 1))
#### 2.4.3 Rate Limit Response Protocol
- 2.4.3.1 HTTP 429 Too Many Requests — standard status code for rate limit exceeded
- 2.4.3.2 Retry-After header — absolute date or delta seconds until quota window resets
- 2.4.3.3 Standard rate limit headers — X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset
#### 2.4.4 Distributed Rate Limiting
- 2.4.4.1 Centralized Redis counter — INCR atomic; single source of truth; adds one network hop
- 2.4.4.2 Approximate distributed limiting — gossip propagation; eventual consistency; small overage
- 2.4.4.3 Envoy rate limit service — gRPC sidecar service; separates rate logic from app code
  - 2.4.4.3.1 Descriptor-based config — limit by remote_address, header value, path combinations

### 2.5 Competing Consumers
#### 2.5.1 Pattern Intent & Forces
- 2.5.1.1 Multiple concurrent consumers pull from a shared queue to parallelize processing
- 2.5.1.2 Naturally scales horizontally — add consumers to increase throughput
- 2.5.1.3 Decouples producer rate from consumer rate via queue buffer
#### 2.5.2 Message Visibility & Locking
- 2.5.2.1 Visibility timeout — message hidden from other consumers while being processed
  - 2.5.2.1.1 SQS visibility timeout — default 30s; extend via ChangeMessageVisibility API
  - 2.5.2.1.2 Timeout calculation — set to p99 processing time + safety margin
- 2.5.2.2 Message leasing — consumer heartbeats to hold lease; failure returns message to queue
#### 2.5.3 Consumer Group Coordination
- 2.5.3.1 Kafka consumer groups — partition assignment; each partition consumed by one group member
  - 2.5.3.1.1 Rebalance trigger — join/leave/crash; processing pauses during reassignment
  - 2.5.3.1.2 Cooperative/incremental rebalancing — partial reassignment; reduces stop-the-world pauses
- 2.5.3.2 SQS model vs. Kafka model — competing (any consumer) vs. partitioned (assigned consumer)
#### 2.5.4 Poison Message Handling
- 2.5.4.1 Dead-letter queue (DLQ) — failed messages routed after maxReceiveCount exceeded
  - 2.5.4.1.1 DLQ depth alert — monitor for systematic processing failures vs. transient errors
- 2.5.4.2 Poison pill counter — track per-message failure count; quarantine after threshold

### 2.6 Queue-Based Load Leveling
#### 2.6.1 Pattern Intent & Forces
- 2.6.1.1 Absorb burst traffic in a queue; downstream consumes at sustainable rate
- 2.6.1.2 Protects downstream from spike-induced overload and cascade failure
#### 2.6.2 Queue Depth as Scaling Signal
- 2.6.2.1 Auto-scale consumers on queue depth — SQS → Lambda via event source mapping
- 2.6.2.2 KEDA ScaledObject — Kubernetes consumers scale to zero when queue is empty
- 2.6.2.3 Target depth per consumer — size fleet to maintain <100 messages/consumer at steady state
#### 2.6.3 Queue Selection Criteria
- 2.6.3.1 Delivery semantics — at-least-once (SQS standard) vs. exactly-once (SQS FIFO, Kafka + tx)
- 2.6.3.2 Ordering — FIFO (ordered, 300 TPS) vs. standard (unordered, 3000+ TPS)
- 2.6.3.3 Retention — SQS up to 14 days; Kafka configurable by size or time; critical for replay
#### 2.6.4 Back-pressure Propagation
- 2.6.4.1 Queue depth as back-pressure signal — growing depth triggers consumer scale-out
- 2.6.4.2 Explicit back-pressure — producer receives 503 when queue exceeds high-water mark
- 2.6.4.3 Load shedding — API Gateway returns 503 before queue overflows; preserves system integrity
