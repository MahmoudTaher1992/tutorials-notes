# Circuit Breakers — Complete Study Guide

## Table of Contents — Part 2: Implementations, Monitoring & Testing

---

## Part III: Library & Framework Implementations

### 7. Java / Spring Boot — Resilience4j

#### 7.1 Setup & Configuration
- 7.1.1 `resilience4j-spring-boot3` dependency
- 7.1.2 `application.yml` configuration (instances, sliding window, thresholds)
- 7.1.3 Programmatic configuration via `CircuitBreakerConfig.custom()`

#### 7.2 Usage Patterns
- 7.2.1 `@CircuitBreaker(name = "...", fallbackMethod = "...")` annotation
- 7.2.2 Functional decoration: `circuitBreaker.decorateSupplier()`
- 7.2.3 Combining with `@Retry`, `@Bulkhead`, `@RateLimiter`
- 7.2.4 Decorator ordering: Retry → CircuitBreaker → Bulkhead → RateLimiter → TimeLimiter

#### 7.3 Monitoring
- 7.3.1 Actuator endpoint (`/actuator/circuitbreakers`)
- 7.3.2 Micrometer metrics integration (Prometheus, Grafana)
- 7.3.3 Event consumers (`onStateTransition`, `onFailureRateExceeded`)

#### 7.4 Legacy: Netflix Hystrix
- 7.4.1 Why Hystrix is deprecated (maintenance mode since 2018)
- 7.4.2 Migration path from Hystrix → Resilience4j
- 7.4.3 Hystrix Dashboard (historical reference)

---

### 8. .NET — Polly

#### 8.1 Polly v8 (Microsoft.Extensions.Resilience)
- 8.1.1 `AddResiliencePipeline()` in DI container
- 8.1.2 `ResiliencePipelineBuilder` fluent API
- 8.1.3 Integration with `IHttpClientFactory` and `HttpClient`

#### 8.2 Configuration
- 8.2.1 `AddCircuitBreaker(new CircuitBreakerStrategyOptions { ... })`
- 8.2.2 Failure ratio, sampling duration, minimum throughput
- 8.2.3 Break duration, half-open permitted attempts

#### 8.3 Usage Patterns
- 8.3.1 Wrapping `HttpClient` calls with resilience pipeline
- 8.3.2 Combining retry + circuit breaker + timeout in a pipeline
- 8.3.3 `OnOpened`, `OnClosed`, `OnHalfOpened` event delegates
- 8.3.4 Fallback via `AddFallback<T>()`

#### 8.4 Legacy: Polly v7
- 8.4.1 Policy-based API (`Policy.Handle<Exception>().CircuitBreaker(...)`)
- 8.4.2 Migration from v7 to v8

---

### 9. Node.js / TypeScript

#### 9.1 cockatiel
- 9.1.1 `CircuitBreakerPolicy` with `ConsecutiveBreaker` or `SamplingBreaker`
- 9.1.2 `handleAll()`, `handleType()` for failure classification
- 9.1.3 `onBreak`, `onReset`, `onHalfOpen` events

#### 9.2 opossum
- 9.2.1 `new CircuitBreaker(asyncFunction, options)`
- 9.2.2 Options: `timeout`, `errorThresholdPercentage`, `resetTimeout`, `volumeThreshold`
- 9.2.3 Events: `open`, `close`, `halfOpen`, `fallback`, `reject`
- 9.2.4 Prometheus metrics via `opossum-prometheus`

#### 9.3 NestJS Integration
- 9.3.1 Custom decorators wrapping cockatiel/opossum
- 9.3.2 Interceptor-based circuit breaker

---

### 10. Go

#### 10.1 gobreaker (Sony)
- 10.1.1 `gobreaker.NewCircuitBreaker(settings)`
- 10.1.2 Settings: `MaxRequests`, `Interval`, `Timeout`, `ReadyToTrip`
- 10.1.3 Custom `ReadyToTrip` function for flexible thresholds
- 10.1.4 `cb.Execute(func() (interface{}, error))` pattern

#### 10.2 Other Go Libraries
- 10.2.1 `hystrix-go` (Netflix, archived)
- 10.2.2 `go-resilience` — modular resilience primitives
- 10.2.3 Custom implementation (Go's simplicity makes DIY viable)

---

### 11. Rust

- 11.1 `failsafe-rs` — circuit breaker with configurable policies
- 11.2 Custom implementation with `tokio` and `Arc<Mutex<State>>`
- 11.3 Type-safe state machines for circuit breaker FSM

### 12. Python

- 12.1 `pybreaker` — standard circuit breaker library
- 12.2 `circuitbreaker` decorator — `@circuit(failure_threshold=5, recovery_timeout=30)`
- 12.3 `tenacity` — retry library with circuit breaker integration
- 12.4 `aiobreaker` — async circuit breaker for asyncio

### 13. Infrastructure-Level Circuit Breakers

#### 13.1 Istio / Envoy
- 13.1.1 `DestinationRule` → `outlierDetection` configuration
- 13.1.2 `consecutiveErrors`, `interval`, `baseEjectionTime`, `maxEjectionPercent`
- 13.1.3 Ejection = removing unhealthy endpoints from load balancing pool
- 13.1.4 Difference from application-level: operates on connection/host level

#### 13.2 Linkerd
- 13.2.1 Failure accrual — consecutive failures or success rate
- 13.2.2 Automatic retry budgets with circuit breaking

#### 13.3 Kong / Cloud-Native
- 13.3.1 Kong circuit breaker plugin (per-route and per-service)
- 13.3.2 AWS App Mesh / Azure API Management / GCP Traffic Director

---

## Part IV: Monitoring, Testing & Operations

### 14. Monitoring Circuit Breakers

#### 14.1 Key Metrics to Track
- 14.1.1 Current state per breaker (closed/open/half-open)
- 14.1.2 State transition count and frequency
- 14.1.3 Failure rate within sliding window
- 14.1.4 Slow call rate
- 14.1.5 Number of calls (successful, failed, not permitted, buffered)
- 14.1.6 Time spent in open state

#### 14.2 Dashboards
- 14.2.1 Grafana dashboard for circuit breaker states (state timeline panel)
- 14.2.2 Per-service breaker status overview (green/yellow/red)
- 14.2.3 Correlation: breaker trips with downstream service metrics

#### 14.3 Alerting
- 14.3.1 Alert when circuit opens (immediate — something is wrong)
- 14.3.2 Alert when circuit stays open beyond expected recovery time
- 14.3.3 Alert on frequent open/close oscillation (flapping)
- 14.3.4 Runbooks linked to circuit breaker alerts

---

### 15. Testing Circuit Breakers

#### 15.1 Unit Testing
- 15.1.1 Test state transitions (inject failures → verify open state)
- 15.1.2 Test fallback execution when circuit is open
- 15.1.3 Test half-open recovery (inject success after failures)
- 15.1.4 Test configuration (thresholds, windows, timing)
- 15.1.5 Mocking the downstream to simulate failure scenarios

#### 15.2 Integration Testing
- 15.2.1 WireMock / MockServer to simulate slow/failing downstreams
- 15.2.2 Testcontainers with failure injection (Toxiproxy)
- 15.2.3 Testing retry + circuit breaker interaction

#### 15.3 Chaos Engineering
- 15.3.1 Injecting latency into downstream calls (Chaos Monkey, Gremlin, Litmus)
- 15.3.2 Killing downstream instances / network partition simulation
- 15.3.3 Verifying CB trips and recovers in production-like environments
- 15.3.4 Game days — planned failure injection with team observation

---

### 16. Anti-Patterns & Common Mistakes

#### 16.1 Configuration Mistakes
- 16.1.1 Using the same config for all services (each downstream has different characteristics)
- 16.1.2 Not setting a minimum call threshold (trips on first error)
- 16.1.3 Counting 4xx client errors as failures (only 5xx / timeouts should trip)
- 16.1.4 Wait duration too short causing oscillation (flapping)

#### 16.2 Design Mistakes
- 16.2.1 Circuit breaker without fallback (just throws a different exception)
- 16.2.2 Fallback that calls the same failing service
- 16.2.3 No monitoring — circuit breaker trips silently, nobody knows
- 16.2.4 Ignoring circuit breaker in load tests (tests pass, prod fails)

#### 16.3 Operational Mistakes
- 16.3.1 No manual override (can't force-close a breaker for emergency)
- 16.3.2 Not tuning after initial deployment (defaults rarely fit)
- 16.3.3 Missing runbooks for "what to do when circuit X opens"

---

### 17. Real-World Scenarios

- 17.1 Database connection pool exhaustion — CB protects against hanging queries
- 17.2 Third-party payment API outage — CB with cached fallback
- 17.3 Microservice chain (A → B → C) — CB at each hop prevents cascade
- 17.4 Cloud region failover — CB triggers failover to secondary region
- 17.5 Black Friday traffic spikes — gradual degradation via CB + bulkhead
- 17.6 Database migration causing slow queries — slow call CB trips

---

> **Navigation:** [← Part 1: Theory, Concepts & Patterns](circuit-breakers_part_1.md)
