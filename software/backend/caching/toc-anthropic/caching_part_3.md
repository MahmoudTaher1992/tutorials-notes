# Caching in Software Engineering - Part 3: Security, Observability & Anti-Patterns

---

### 9.0 Security & Attack Vectors

#### 9.1 Cache Poisoning (Web & DNS)
- 9.1.1 HTTP cache poisoning — injecting malicious response into shared cache via crafted headers
- 9.1.2 Cache key normalization — unkeyed headers (X-Forwarded-Host) used to vary response
- 9.1.3 DNS cache poisoning — forged DNS responses cached by resolvers (Kaminsky attack)
- 9.1.4 BGP / ARP cache poisoning — routing table manipulation (network layer)
- 9.1.5 Mitigations — strict cache key definition, input validation, DNSSEC, cache-busting

#### 9.2 Side-Channel Attacks
- 9.2.1 Spectre / Meltdown — CPU cache timing used to read privileged memory
- 9.2.2 Cache-timing attacks — inferring secret data from cache hit/miss latency differences
- 9.2.3 Cross-tenant cache snooping — shared cache leaking data between tenants
- 9.2.4 Mitigations — namespace isolation, per-tenant cache clusters, constant-time comparisons

#### 9.3 Cache Enumeration & Probing
- 9.3.1 Key scanning — KEYS * command in Redis leaks data model in production
- 9.3.2 Timing-based key existence — response time reveals whether key exists in cache
- 9.3.3 Mitigations — disable KEYS in production (rename/ACL), use SCAN, rate-limit cache API

#### 9.4 Injection via Cache Keys
- 9.4.1 Key injection — user-controlled input in cache key contains delimiters or wildcards
- 9.4.2 Namespace collision — predictable key pattern allows cross-user data access
- 9.4.3 Mitigations — sanitize/hash user input in keys; avoid raw user data in key names

#### 9.5 Authentication, Authorization & Encryption
- 9.5.1 Cache server auth — Redis requirepass / ACL; Memcached SASL
- 9.5.2 ACL granularity — per-user command and key-pattern restrictions (Redis 6+)
- 9.5.3 TLS in transit — native TLS (Redis 6+), stunnel, or service-mesh mTLS
- 9.5.4 Encryption at rest — OS-level encryption (LUKS) or cloud-provider disk encryption
- 9.5.5 Network isolation — bind to private interfaces; firewall deny external access

---

### 10.0 Observability, Metrics & Tracing

#### 10.1 Hit Rate & Miss Rate
- 10.1.1 Cache hit ratio — primary health indicator; target depends on workload (>80% typical)
- 10.1.2 Per-key hit tracking — identify keys with chronic misses
- 10.1.3 Segmented hit rate — separate hit rates for different data categories
- 10.1.4 Hit rate degradation alerts — sudden drop signals cold-start, stampede, or eviction spike

#### 10.2 Latency Percentiles
- 10.2.1 p50 / p95 / p99 cache latency — track tail latency, not just average
- 10.2.2 Network RTT contribution — off-process cache adds baseline network cost
- 10.2.3 Slow command log — Redis SLOWLOG for commands exceeding threshold
- 10.2.4 Latency histogram — visualize distribution of GET/SET operation durations

#### 10.3 Memory & Eviction Metrics
- 10.3.1 used_memory vs maxmemory — headroom before eviction begins
- 10.3.2 Eviction rate — evicted_keys/sec; rising rate signals under-provisioning
- 10.3.3 Memory fragmentation ratio — RSS / used_memory; fragmentation wastes capacity
- 10.3.4 Key count and expiry rate — track key churn; high expiry rate may indicate TTL too short

#### 10.4 Distributed Tracing Integration
- 10.4.1 Span per cache operation — trace cache GET/SET as child spans of request
- 10.4.2 Cache hit/miss as span attribute — annotate spans with cache outcome
- 10.4.3 OpenTelemetry instrumentation — auto-instrumentation for Redis, Memcached clients
- 10.4.4 Trace correlation — link cache miss spans to downstream DB query spans

#### 10.5 Alerting & SLO Definitions
- 10.5.1 Cache availability SLO — % of cache reads that succeed within latency threshold
- 10.5.2 Hit rate SLO — alert when hit rate falls below baseline for sustained period
- 10.5.3 Eviction rate alert — threshold evictions/sec triggers capacity review
- 10.5.4 Connection pool exhaustion alert — no available connections to cache server

---

### 11.0 Performance Tuning & Anti-Patterns

#### 11.1 Key Design Best Practices
- 11.1.1 Hierarchical naming — `service:entity:id` (e.g., `users:profile:42`)
- 11.1.2 Key length — short keys save memory; avoid UUIDs as raw keys (hash them)
- 11.1.3 Key cardinality — avoid unbounded key spaces that exhaust memory
- 11.1.4 Versioned keys — embed version for schema changes: `v2:users:profile:42`

#### 11.2 Serialization Format Impact
- 11.2.1 JSON — human-readable, widely supported; larger payload, slower parsing
- 11.2.2 MessagePack — binary JSON-equivalent; smaller, faster; less tooling
- 11.2.3 Protocol Buffers — strongly typed, smallest size; requires schema management
- 11.2.4 Native types — use Redis native types (Hash, List) instead of serialized blobs

#### 11.3 Connection Pooling & Multiplexing
- 11.3.1 Connection pool sizing — too small: queuing; too large: server FD exhaustion
- 11.3.2 Pipelining — batch multiple commands in one round trip
- 11.3.3 Multiplexing — single connection shared across async requests (ioredis, lettuce)
- 11.3.4 Connection keepalive — prevent idle timeout disconnections

#### 11.4 Common Anti-Patterns
- 11.4.1 Cache-as-database — storing durable state only in cache; data loss on eviction
- 11.4.2 Over-caching — caching every query regardless of frequency; wastes memory
- 11.4.3 Large values — storing multi-MB blobs in cache; serialize chunked instead
- 11.4.4 Caching mutable shared state without invalidation — guaranteed stale reads
- 11.4.5 Ignoring serialization cost — CPU overhead of marshaling negates cache benefit
- 11.4.6 No TTL on keys — unbounded key accumulation; memory exhaustion over time
