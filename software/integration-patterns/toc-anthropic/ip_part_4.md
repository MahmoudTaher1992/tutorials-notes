# Integration Patterns Complete Study Guide - Part 4: Reliability & API Patterns

## 7.0 Reliability & Error Handling

### 7.1 Retry Patterns
#### 7.1.1 Retry with Backoff
- 7.1.1.1 Retry — attempt failed operation again — transient faults — network blips / throttling
  - 7.1.1.1.1 Fixed retry — wait same interval — simple — can hammer recovering service
  - 7.1.1.1.2 Exponential backoff — double wait each attempt — 1s / 2s / 4s / 8s — reduces load
  - 7.1.1.1.3 Jitter — add randomness to backoff — prevent thundering herd — synchronized retries
- 7.1.1.2 Max retry count — stop retrying after N attempts — avoid infinite retry loops
  - 7.1.1.2.1 On max retries exceeded — move to DLQ / alert / compensate — not silent discard
- 7.1.1.3 Retry on specific errors — 429 / 503 / 504 — not on 400 / 404 — selective retry
  - 7.1.1.3.1 Retryable vs non-retryable — classify errors — idempotent operations only — safe

#### 7.1.2 Timeout
- 7.1.2.1 Fail fast — do not wait indefinitely — set deadline — release blocked resources
  - 7.1.2.1.1 Connection timeout — time to establish connection — typically 1–5s
  - 7.1.2.1.2 Read timeout — time waiting for response bytes — longer — typically 5–30s
  - 7.1.2.1.3 Deadline propagation — pass remaining deadline downstream — prevent cascade wait

### 7.2 Stability Patterns
#### 7.2.1 Circuit Breaker
- 7.2.1.1 Monitor failure rate — open circuit on threshold — fast-fail until recovery — resilience
  - 7.2.1.1.1 Closed state — normal operation — track failure count — pass all requests
  - 7.2.1.1.2 Open state — circuit tripped — fail immediately — no calls to downstream — rest
  - 7.2.1.1.3 Half-open state — probe with single request — success → close — failure → reopen
- 7.2.1.2 Threshold configuration — 50% failure in 10s window — or 10 failures in 60s — tune
  - 7.2.1.2.1 Resilience4j / Polly / Hystrix — library implementations — configurable — standard
  - 7.2.1.2.2 Fallback — return default / cached / degraded response when open — graceful degrade

#### 7.2.2 Bulkhead
- 7.2.2.1 Isolate failures — separate thread pools per downstream — failure containment
  - 7.2.2.1.1 Thread pool bulkhead — dedicated executor per service — exhaust pool = local failure only
  - 7.2.2.1.2 Semaphore bulkhead — limit concurrent calls — lighter — no thread isolation
  - 7.2.2.1.3 Named from ship compartments — one leak does not sink ship — failure isolation

#### 7.2.3 Idempotency Keys
- 7.2.3.1 Client-supplied unique key — server deduplicates — safe retry — exactly-once effect
  - 7.2.3.1.1 Stripe / Braintree pattern — Idempotency-Key header — 24h dedup window — standard
  - 7.2.3.1.2 Server stores key + response — return cached response on duplicate — transparent

---

## 8.0 API Integration Patterns

### 8.1 Gateway Patterns
#### 8.1.1 API Gateway
- 8.1.1.1 Single entry point — routing / auth / rate limiting / SSL termination / logging — cross-cutting
  - 8.1.1.1.1 Request routing — path-based — host-based — version-based — to correct service
  - 8.1.1.1.2 Auth enforcement — validate JWT / API key — reject before reaching service — offload
  - 8.1.1.1.3 Rate limiting — per client / per endpoint — 429 Too Many Requests — protect backends

#### 8.1.2 Backend for Frontend (BFF)
- 8.1.2.1 Dedicated API per frontend type — mobile / web / third-party — tailored response
  - 8.1.2.1.1 BFF aggregates — call multiple downstream services — return shaped for client
  - 8.1.2.1.2 Avoids over-fetching — client gets exactly what it needs — no giant generic API
  - 8.1.2.1.3 BFF per team — mobile team owns mobile BFF — web team owns web BFF — autonomy

### 8.2 Structural Patterns
#### 8.2.1 Adapter Pattern
- 8.2.1.1 Wrap incompatible interface — expose expected interface — translation layer — legacy bridge
  - 8.2.1.1.1 SOAP to REST adapter — translate REST call → SOAP envelope → unmarshal response
  - 8.2.1.1.2 Database adapter — expose DB as REST API — abstraction — Hasura / PostgREST

#### 8.2.2 Anti-Corruption Layer (ACL)
- 8.2.2.1 Protect domain model from external model leakage — translate at boundary — DDD pattern
  - 8.2.2.1.1 Map external concepts to internal domain — never expose external types internally
  - 8.2.2.1.2 Isolates — change in external system → update only ACL — domain unaffected

#### 8.2.3 API Composition
- 8.2.3.1 Aggregate data from multiple services in one query — no client-side joins
  - 8.2.3.1.1 Synchronous composition — call services in parallel — join in memory — return
  - 8.2.3.1.2 GraphQL as composition layer — resolver per field — federated subgraphs
  - 8.2.3.1.3 Consistency caveat — composed data may be from different snapshots — eventual

#### 8.2.4 Strangler Fig
- 8.2.4.1 Incrementally replace legacy — new system grows around old — traffic shifted gradually
  - 8.2.4.1.1 Proxy in front — new feature → new service — old feature → legacy — coexist
  - 8.2.4.1.2 Feature by feature migration — strangler grows — legacy shrinks — no big bang
  - 8.2.4.1.3 Facade hides complexity — clients unaware of migration — transparent switchover
