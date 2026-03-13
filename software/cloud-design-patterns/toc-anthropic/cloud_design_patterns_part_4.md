# Cloud Design Patterns - Part 4: Resilience & Fault Tolerance (I)

## 3.0 Resilience & Fault Tolerance Patterns

### 3.1 Circuit Breaker
#### 3.1.1 Pattern Intent & Motivation
- 3.1.1.1 Prevent cascading failures — stop calling a failing service before caller is overwhelmed
- 3.1.1.2 Fail fast — return error immediately rather than waiting for timeout to expire
- 3.1.1.3 Allow recovery — give downstream time to heal before resuming traffic
#### 3.1.2 State Machine
- 3.1.2.1 Closed state — normal operation; all requests pass through; failures counted
  - 3.1.2.1.1 Failure threshold — trip to Open when error rate > N% over sliding window
- 3.1.2.2 Open state — all requests fail immediately; no calls to downstream
  - 3.1.2.2.1 Sleep window — configurable duration (default 5-60s) before probing downstream
- 3.1.2.3 Half-Open state — allow limited probe requests through to test recovery
  - 3.1.2.3.1 Success threshold — close if M consecutive successes; re-open if any failure
#### 3.1.3 Failure Detection Configuration
- 3.1.3.1 Count-based window — trip after N failures in a fixed sample size (e.g., 5/10)
- 3.1.3.2 Time-based sliding window — trip when error rate > threshold over last X seconds
  - 3.1.3.2.1 Minimum request volume — don't trip on 1/1 failures; require minimum sample
- 3.1.3.3 Slow call rate threshold — treat latency > configuredTimeout as a failure signal
  - 3.1.3.3.1 Resilience4j slowCallDurationThreshold — e.g., calls > 2s count as slow
#### 3.1.4 Circuit Breaker Scoping
- 3.1.4.1 Per-dependency instance — separate breaker per downstream service prevents cross-contamination
- 3.1.4.2 Per-operation granularity — separate breaker for read vs. write endpoints
- 3.1.4.3 Shared vs. per-thread-pool breaker — interaction with Bulkhead pattern
#### 3.1.5 Implementation Libraries & Integration
- 3.1.5.1 Resilience4j (Java) — functional, non-blocking; decorator pattern; micrometer metrics
  - 3.1.5.1.1 Annotations — @CircuitBreaker(name="svc", fallbackMethod="fallback")
- 3.1.5.2 Polly (.NET) — policy-based; wraps any delegate; fluent API
- 3.1.5.3 Hystrix (legacy) — thread-pool isolation; dashboard; deprecated in favor of Resilience4j
- 3.1.5.4 Envoy proxy — service mesh circuit breaking; config in DestinationRule/cluster upstream
  - 3.1.5.4.1 Envoy outlier detection — passive ejection based on consecutive 5xx or latency
#### 3.1.6 Circuit Breaker Observability
- 3.1.6.1 State transition events — emit metric on Closed→Open, Open→Half-Open, Half-Open→Closed
- 3.1.6.2 Call volume metrics — success, error, slow, rejected counts per circuit
- 3.1.6.3 Alerting — alert on circuit Open duration > threshold (indicates sustained downstream outage)

### 3.2 Retry & Exponential Backoff
#### 3.2.1 Pattern Intent
- 3.2.1.1 Transparently recover from transient failures without surfacing errors to callers
- 3.2.1.2 Transient failure taxonomy — network blip, brief overload, timeout, restart, rate limit
#### 3.2.2 Retry Policies
- 3.2.2.1 Immediate retry — no delay; suitable only for idempotent operations on very transient errors
- 3.2.2.2 Fixed interval retry — constant delay between attempts; simple but may amplify load
- 3.2.2.3 Exponential backoff — delay doubles per attempt: base × 2^attempt
  - 3.2.2.3.1 Formula — delay = min(cap, base × 2^n); cap prevents unbounded wait
  - 3.2.2.3.2 AWS SDK default — base 100ms, cap 20s, max 3 retries
- 3.2.2.4 Decorrelated jitter — delay = random_between(base, prev_delay × 3)
  - 3.2.2.4.1 AWS recommendation — decorrelated jitter outperforms full jitter at high concurrency
#### 3.2.3 Jitter Strategies
- 3.2.3.1 No jitter — all clients retry simultaneously; thundering herd on recovery
- 3.2.3.2 Full jitter — delay = random_between(0, base × 2^n); spread but unpredictable
- 3.2.3.3 Equal jitter — delay = (base × 2^n / 2) + random(0, base × 2^n / 2)
- 3.2.3.4 Decorrelated jitter — adds per-client state; best dispersion across fleet
#### 3.2.4 Retry-Eligibility & Safety
- 3.2.4.1 Idempotency requirement — only retry idempotent operations (GET, PUT, DELETE)
  - 3.2.4.1.1 POST retry safety — requires idempotency token to prevent duplicate mutations
- 3.2.4.2 Error classification — retryable: 429, 503, timeout; non-retryable: 400, 401, 403, 404
- 3.2.4.3 Budget-based retry — limit total retry time not just count; respects caller SLA
  - 3.2.4.3.1 Retry budget (Google SRE) — fleet-wide budget; prevents overload from straggling callers
#### 3.2.5 Interaction with Other Patterns
- 3.2.5.1 Retry + Circuit Breaker — circuit breaker prevents retries when downstream is known-bad
- 3.2.5.2 Retry + Timeout — always combine retry with per-attempt timeout to bound total latency
- 3.2.5.3 Retry + Bulkhead — retry threads must not exhaust the bulkhead thread pool
#### 3.2.6 Retry Observability
- 3.2.6.1 Retry rate metric — retries/total_calls; high ratio signals systemic instability
- 3.2.6.2 Retry amplification ratio — total attempts / successful requests; detect storm conditions
- 3.2.6.3 Per-attempt latency distribution — measure each attempt separately to diagnose tail latency
