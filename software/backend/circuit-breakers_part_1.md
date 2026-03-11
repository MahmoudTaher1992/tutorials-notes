# Circuit Breakers — Complete Study Guide

## Table of Contents — Part 1: Theory, Concepts & Patterns

---

## Part I: Foundations

### 1. Introduction

#### 1.1 What is a Circuit Breaker?
- 1.1.1 Definition — a stability pattern that prevents cascading failures
- 1.1.2 The electrical analogy (fuse box / breaker panel)
- 1.1.3 Why retrying a dead service makes things worse
- 1.1.4 Circuit breaker vs retry — complementary, not competing
- 1.1.5 Origin — Michael Nygard's "Release It!" (2007)

#### 1.2 The Problem It Solves
- 1.2.1 Cascading failures in distributed systems
- 1.2.2 Thread pool exhaustion from hanging calls
- 1.2.3 Timeout accumulation under load
- 1.2.4 Resource starvation (connections, memory, CPU)
- 1.2.5 Thundering herd on recovery (all callers retry at once)

#### 1.3 Where Circuit Breakers Apply
- 1.3.1 HTTP/REST calls to external services
- 1.3.2 gRPC inter-service calls
- 1.3.3 Database connections and queries
- 1.3.4 Message broker producers
- 1.3.5 Third-party API calls (Stripe, Twilio, etc.)
- 1.3.6 DNS resolution and service discovery
- 1.3.7 File system / cloud storage operations

---

### 2. Core Concepts — The Three States

#### 2.1 Closed State (Normal Operation)
- 2.1.1 All requests pass through to the downstream service
- 2.1.2 Success and failure counters are tracked
- 2.1.3 Failure rate is calculated continuously
- 2.1.4 Transitions to Open when failure threshold is breached

#### 2.2 Open State (Failure — Fast Fail)
- 2.2.1 All requests fail immediately without calling downstream
- 2.2.2 Caller receives a predefined fallback or error
- 2.2.3 Protects the failing service from additional load
- 2.2.4 Frees caller's resources (threads, connections)
- 2.2.5 A timer starts — the "wait duration in open state"

#### 2.3 Half-Open State (Recovery Probe)
- 2.3.1 After the wait timer expires, a limited number of probe requests pass through
- 2.3.2 If probes succeed → transition back to Closed
- 2.3.3 If probes fail → transition back to Open (reset timer)
- 2.3.4 Configurable number of permitted calls in half-open
- 2.3.5 Gradual ramp-up vs single-probe strategies

#### 2.4 State Transition Diagram
- 2.4.1 Closed → Open (failure threshold exceeded)
- 2.4.2 Open → Half-Open (wait duration expires)
- 2.4.3 Half-Open → Closed (probes succeed)
- 2.4.4 Half-Open → Open (probes fail)
- 2.4.5 Forced state transitions (manual override, admin API)

---

### 3. Configuration Deep Dive

#### 3.1 Failure Detection
- 3.1.1 What counts as a failure? (exceptions, HTTP 5xx, timeouts, slow calls)
- 3.1.2 Ignoring certain exceptions (e.g., 404 is not a failure)
- 3.1.3 Slow call threshold — treating latency as failure
- 3.1.4 Slow call rate threshold vs error rate threshold

#### 3.2 Sliding Window Types
- 3.2.1 **Count-based sliding window** — last N calls (e.g., last 100 calls)
- 3.2.2 **Time-based sliding window** — calls in last N seconds (e.g., last 60 seconds)
- 3.2.3 Count-based: simple, predictable, but ignores time
- 3.2.4 Time-based: time-aware, but variable sample size
- 3.2.5 Minimum number of calls before evaluation (avoid tripping on 1 failure)

#### 3.3 Thresholds
- 3.3.1 Failure rate threshold (e.g., 50% of calls fail → trip)
- 3.3.2 Slow call rate threshold (e.g., 80% of calls are slow → trip)
- 3.3.3 Slow call duration threshold (e.g., > 2 seconds = "slow")
- 3.3.4 Minimum number of calls required to calculate rate

#### 3.4 Timing Configuration
- 3.4.1 Wait duration in open state (e.g., 60 seconds before trying half-open)
- 3.4.2 Permitted number of calls in half-open state
- 3.4.3 Max wait duration (for exponential backoff in open state)
- 3.4.4 Automatic transition from open to half-open vs manual

#### 3.5 Configuration Anti-Patterns
- 3.5.1 Threshold too low → false positives (trips on normal error rate)
- 3.5.2 Threshold too high → too slow to detect real outages
- 3.5.3 Wait duration too short → hammering a recovering service
- 3.5.4 Wait duration too long → unnecessary downtime after recovery
- 3.5.5 Window too small → noisy, trips on outliers
- 3.5.6 Window too large → slow to react

---

## Part II: Patterns & Integration

### 4. Fallback Strategies

#### 4.1 Fallback Types
- 4.1.1 Default value (e.g., "unknown" for a name lookup)
- 4.1.2 Cached response (return last known good value)
- 4.1.3 Degraded response (partial data, fewer features)
- 4.1.4 Alternative service (backup provider, secondary region)
- 4.1.5 Queue for later (accept request, process when service recovers)
- 4.1.6 Graceful error message (user-friendly, not a stack trace)

#### 4.2 Fallback Design Principles
- 4.2.1 Fallbacks must not call the same failing dependency
- 4.2.2 Fallbacks should be fast and reliable
- 4.2.3 Fallbacks need their own monitoring
- 4.2.4 Stale data trade-offs — how stale is acceptable?
- 4.2.5 Communicating degraded state to the caller

---

### 5. Integration with Other Resilience Patterns

#### 5.1 Circuit Breaker + Retry
- 5.1.1 Retry inside the circuit breaker (retry before counting as failure)
- 5.1.2 Retry outside the circuit breaker (retry after breaker rejects)
- 5.1.3 Recommended: Retry wraps Circuit Breaker (Retry → CB → Call)
- 5.1.4 Avoiding retry storms when circuit is half-open

#### 5.2 Circuit Breaker + Timeout
- 5.2.1 Timeout defines how long to wait for a response
- 5.2.2 Timeout expiry = failure counted by circuit breaker
- 5.2.3 Timeout should be shorter than circuit breaker's slow call threshold

#### 5.3 Circuit Breaker + Bulkhead
- 5.3.1 Bulkhead isolates resources per downstream service
- 5.3.2 Circuit breaker per bulkhead partition
- 5.3.3 Thread pool bulkhead vs semaphore bulkhead
- 5.3.4 Combined: bulkhead limits blast radius, CB stops the bleeding

#### 5.4 Circuit Breaker + Rate Limiter
- 5.4.1 Rate limiter protects the downstream from overload
- 5.4.2 Circuit breaker protects the caller from a failing downstream
- 5.4.3 Complementary: rate limiter prevents, circuit breaker reacts

#### 5.5 Circuit Breaker + Cache
- 5.5.1 Cache-aside with circuit breaker fallback to cache
- 5.5.2 Stale-while-revalidate when circuit is open
- 5.5.3 Cache warming strategies for circuit breaker recovery

---

### 6. Advanced Patterns

#### 6.1 Per-Endpoint Circuit Breakers
- 6.1.1 One breaker per downstream service (coarse-grained)
- 6.1.2 One breaker per endpoint/operation (fine-grained)
- 6.1.3 Trade-offs: granularity vs complexity vs resource usage
- 6.1.4 Example: `/users` healthy but `/reports` failing — fine-grained prevents over-isolation

#### 6.2 Distributed Circuit Breakers
- 6.2.1 Problem: each instance has its own breaker state → inconsistent behavior
- 6.2.2 Shared state via Redis, Consul, or database
- 6.2.3 Gossip-based state propagation
- 6.2.4 Trade-offs: consistency vs latency vs complexity
- 6.2.5 When local-only breakers are good enough

#### 6.3 Adaptive Circuit Breakers
- 6.3.1 Dynamic thresholds based on historical baselines
- 6.3.2 Machine learning-based anomaly detection
- 6.3.3 Load-aware circuit breaking (trip earlier under high load)
- 6.3.4 Time-of-day awareness (different thresholds for peak hours)

#### 6.4 Circuit Breaker at Infrastructure Level
- 6.4.1 Service mesh circuit breaking (Istio, Linkerd, Envoy)
- 6.4.2 API gateway circuit breaking (Kong, AWS API Gateway)
- 6.4.3 Load balancer health checks as circuit breakers
- 6.4.4 Application-level vs infrastructure-level — when to use which
- 6.4.5 Layered approach: infrastructure + application breakers

---

> **Navigation:** [Part 2: Implementations, Monitoring & Testing →](circuit-breakers_part_2.md)
