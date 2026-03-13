# Cloud Design Patterns - Part 5: Resilience & Fault Tolerance (II)

## 3.0 Resilience & Fault Tolerance Patterns (continued)

### 3.3 Bulkhead Isolation
#### 3.3.1 Pattern Intent & Ship Analogy
- 3.3.1.1 Isolate failures in one partition from spreading to others (compartmentalized hull)
- 3.3.1.2 Prevent thread/connection pool exhaustion from propagating across services
#### 3.3.2 Thread Pool Bulkhead
- 3.3.2.1 Dedicated thread pool per downstream dependency — isolates blocking I/O
  - 3.3.2.1.1 Pool sizing — Little's Law: N = λ × W (throughput × avg latency)
  - 3.3.2.1.2 Rejection policy — CallerRunsPolicy vs. AbortPolicy on queue overflow
- 3.3.2.2 Queue depth per pool — bound memory; reject fast when downstream is slow
#### 3.3.3 Semaphore Bulkhead
- 3.3.3.1 Limits concurrent in-flight calls without separate thread overhead
- 3.3.3.2 Suitable for non-blocking async code (reactive/coroutine stacks)
  - 3.3.3.2.1 Resilience4j SemaphoreBulkhead — maxConcurrentCalls, maxWaitDuration config
#### 3.3.4 Connection Pool Bulkhead
- 3.3.4.1 Separate database connection pools per tenant or service consumer
- 3.3.4.2 Prevents one runaway query from consuming all connections and starving others
#### 3.3.5 Bulkhead at Infrastructure Level
- 3.3.5.1 Separate ASGs/node groups per criticality tier (critical vs. non-critical workloads)
- 3.3.5.2 Separate VPCs or namespaces for blast-radius containment
- 3.3.5.3 Cell-based architecture — partition fleet into cells; failure contained within one cell
  - 3.3.5.3.1 Amazon Cell-Based Architecture — shuffle sharding minimizes blast radius per customer

### 3.4 Timeout & Deadline Propagation
#### 3.4.1 Timeout Types
- 3.4.1.1 Connection timeout — max time to establish TCP/TLS connection
- 3.4.1.2 Read timeout — max time to receive first byte after connection established
- 3.4.1.3 Request timeout — total max time for complete request/response cycle
- 3.4.1.4 Idle connection timeout — close unused pooled connections to prevent stale socket failures
#### 3.4.2 Timeout Sizing
- 3.4.2.1 Set at p99 of downstream latency distribution + safety margin (not p50 or average)
- 3.4.2.2 Timeout budget — total budget = caller SLA minus own processing time
  - 3.4.2.2.1 Example — 500ms SLA, 50ms processing → 450ms available for downstream calls
#### 3.4.3 Deadline Propagation
- 3.4.3.1 Propagate remaining deadline via gRPC deadline or HTTP header (X-Request-Deadline)
- 3.4.3.2 Each hop checks remaining deadline before initiating work — fail fast if budget exhausted
  - 3.4.3.2.1 gRPC deadline — automatically cancelled across the full call chain on expiry
- 3.4.3.3 Orphaned request problem — work continues downstream after caller timed out and moved on
  - 3.4.3.3.1 Mitigation — server-side deadline check before expensive operations; context cancellation
#### 3.4.4 Timeout Anti-patterns
- 3.4.4.1 Missing timeout — blocked thread never released; gradual resource exhaustion
- 3.4.4.2 Timeout too high — user-facing latency unacceptable; downstream errors masked
- 3.4.4.3 Equal timeouts at all layers — outer caller times out while inner calls still retry

### 3.5 Fallback & Graceful Degradation
#### 3.5.1 Fallback Strategies
- 3.5.1.1 Static fallback — return hardcoded safe default (empty list, zero, cached static page)
- 3.5.1.2 Cached fallback — return last-known-good value from local or distributed cache
  - 3.5.1.2.1 Stale-while-revalidate — serve stale cache entry while async refresh runs
- 3.5.1.3 Alternate service fallback — route to secondary/degraded replica or read replica
- 3.5.1.4 Feature degradation — disable non-critical features (recommendations, analytics, ads)
  - 3.5.1.4.1 Feature flag integration — toggle degradation path without deployment
#### 3.5.2 Fallback Selection Criteria
- 3.5.2.1 Data freshness requirements — real-time data cannot use stale fallback
- 3.5.2.2 Business criticality — payment vs. recommendation require different fallback behaviors
- 3.5.2.3 Fallback cost — avoid fallbacks that trigger expensive backup calls (recursive failure)
#### 3.5.3 Graceful Degradation Architecture
- 3.5.3.1 Dependency classification — critical (system fails without it) vs. non-critical (nice-to-have)
- 3.5.3.2 Degradation hierarchy — document explicit degraded states with user-visible impact
- 3.5.3.3 Monitoring degraded states — alert when degraded mode active for > N minutes

### 3.6 Health Endpoint Monitoring
#### 3.6.1 Health Check Types
- 3.6.1.1 Liveness check — is the process alive? (should it be restarted?)
  - 3.6.1.1.1 Kubernetes livenessProbe — fail → kubelet kills and restarts container
- 3.6.1.2 Readiness check — is the service ready to serve traffic? (should it receive requests?)
  - 3.6.1.2.1 Kubernetes readinessProbe — fail → remove pod from Service endpoints, stop LB routing
- 3.6.1.3 Startup check — is the application finished initializing? (allow slow startup)
  - 3.6.1.3.1 Kubernetes startupProbe — disables liveness until startup probe succeeds
#### 3.6.2 Health Check Endpoint Design
- 3.6.2.1 Shallow check — returns 200 immediately; proves process is alive (for liveness)
- 3.6.2.2 Deep check — verifies DB connectivity, cache reachability, disk space (for readiness)
  - 3.6.2.2.1 Dependency timeout — check dependencies with short timeout (100-500ms)
  - 3.6.2.2.2 Cascading deregistration risk — if DB is slow, all instances deregister simultaneously
- 3.6.2.3 Health endpoint security — restrict to internal network or mTLS; avoid exposing internals
#### 3.6.3 Health Aggregation Patterns
- 3.6.3.1 Composite health — aggregate sub-component statuses: UP / DEGRADED / DOWN
- 3.6.3.2 Spring Boot Actuator `/actuator/health` — automatic sub-component aggregation
- 3.6.3.3 External health monitoring — Pingdom, Route53 health checks, Datadog Synthetics

### 3.7 Compensating Transactions
#### 3.7.1 Pattern Intent
- 3.7.1.1 Undo completed steps of a failed multi-step operation in a distributed system
- 3.7.1.2 Required when ACID 2PC is unavailable or too costly across service boundaries
#### 3.7.2 Compensation Step Design
- 3.7.2.1 Each forward step must have a defined compensating inverse action
  - 3.7.2.1.1 Example — charge card → refund card; reserve inventory → release inventory
- 3.7.2.2 Idempotency requirement — compensation must be safe to re-run on retry
- 3.7.2.3 Temporal coupling — compensations must execute in reverse order of forward steps
#### 3.7.3 Compensating Transaction vs. Rollback
- 3.7.3.1 Rollback — undo uncommitted changes within a transaction boundary (ACID)
- 3.7.3.2 Compensating transaction — undo already-committed changes via new forward operation
- 3.7.3.3 Temporal gap — other processes may observe intermediate state between forward and compensate
#### 3.7.4 Compensation Failure Handling
- 3.7.4.1 Compensation retry — must succeed eventually; persist compensation intent durably
- 3.7.4.2 Human escalation — alert operations team when automated compensation fails repeatedly
- 3.7.4.3 Saga pattern coordinates compensating transactions across service boundaries (→ See §5.4)
