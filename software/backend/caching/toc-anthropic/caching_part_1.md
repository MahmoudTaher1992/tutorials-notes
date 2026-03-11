# Caching in Software Engineering - Part 1: Foundations, Taxonomy & Access Strategies

---

## Phase 1: The Ideal Cache

### 1.0 Theoretical Foundations

#### 1.1 Mathematical Models
- 1.1.1 Cache hit rate formula — hits / (hits + misses)
- 1.1.2 Miss penalty — latency cost of fetching from origin on miss
- 1.1.3 Effective access time (EAT) — weighted average of hit & miss latency
- 1.1.4 Zipf's law — power-law frequency distribution; small % of keys = most traffic
- 1.1.5 Working set model — active dataset a process references in a time window

#### 1.2 CPU Cache Hierarchy (Analogy Foundation)
- 1.2.1 L1/L2/L3 cache — size vs latency trade-offs (1ns → 10ns → 40ns → 100ns RAM)
- 1.2.2 Cache line — 64-byte unit of transfer; spatial locality exploitation
- 1.2.3 Cache coherence — MESI/MOESI protocols for multi-core consistency
- 1.2.4 False sharing — two cores writing different data in the same cache line
- 1.2.5 Software analogy — same hierarchy trade-offs repeat at every system layer

#### 1.3 Locality Principles
- 1.3.1 Temporal locality — recently accessed data will likely be accessed again soon
- 1.3.2 Spatial locality — data near recently accessed data likely accessed next
- 1.3.3 Sequential locality — streaming/scan access patterns
- 1.3.4 Designing keys to exploit locality — grouping related keys with prefixes

#### 1.4 CAP Theorem Applied to Distributed Caches
- 1.4.1 Consistency vs availability — cache nodes may serve stale data during partition
- 1.4.2 Eventual consistency — acceptable staleness windows, TTL-bounded drift
- 1.4.3 Strong consistency — coordination cost (quorum reads, linearizable ops)
- 1.4.4 Read-your-writes — session affinity or sticky routing to same cache node

---

### 2.0 Cache Taxonomy & Architecture Layers

#### 2.1 Cache Placement Tiers
- 2.1.1 Client-side / browser cache — local HTTP cache, zero network cost
- 2.1.2 Edge cache / CDN — geographically distributed PoPs, closest to user
- 2.1.3 Reverse proxy cache — Varnish, Nginx; sits in front of app servers
- 2.1.4 Application-layer cache — in-process (JVM heap, Python dict, Go map)
- 2.1.5 Distributed shared cache — Redis, Memcached; shared across instances
- 2.1.6 Database buffer pool — InnoDB buffer pool, PostgreSQL shared_buffers

#### 2.2 Storage Media
- 2.2.1 In-process heap — fastest access; bounded by GC and process memory
- 2.2.2 Off-process in-memory — Redis, Memcached; network RTT cost (~0.1–1ms)
- 2.2.3 SSD-backed cache — Redis on Flash, Aerospike; hot/cold data tiering
- 2.2.4 Disk / OS page cache — kernel-managed; transparent to applications

#### 2.3 Cache Topology Patterns
- 2.3.1 Inline (transparent) cache — sits between client and origin invisibly
- 2.3.2 Look-aside (demand-fill) — app checks cache and manages population itself
- 2.3.3 Sidecar cache — co-located proxy per service instance (service mesh pattern)
- 2.3.4 Global shared cache — single cluster shared by all services; hot key risk

#### 2.4 Multi-Tier Stacking
- 2.4.1 L1 in-process + L2 Redis — local hit avoids network; L2 for cross-instance sharing
- 2.4.2 L1 Redis + L2 CDN — regional offload before hitting origin servers
- 2.4.3 Cache hierarchy invalidation — propagating invalidations down tiers consistently
- 2.4.4 Request routing strategy — which tier owns which content type

---

### 3.0 Read Strategies & Access Patterns

#### 3.1 Cache-Aside (Lazy Loading)
- 3.1.1 Read flow — check cache → miss → read origin → populate cache → return
- 3.1.2 Cold start — cache empty on first deploy; origin bears full read load
- 3.1.3 Stale data window — data can change at origin without cache update until TTL
- 3.1.4 Best for — irregular access patterns, read-heavy with unpredictable keys

#### 3.2 Read-Through
- 3.2.1 Read flow — app reads only from cache; cache itself fetches from origin on miss
- 3.2.2 Population logic owned by cache layer — app decoupled from data source
- 3.2.3 Consistency advantage — single read path through cache
- 3.2.4 Best for — uniform access patterns; cache as the primary read interface

#### 3.3 Refresh-Ahead / Prefetching
- 3.3.1 Proactive refresh — cache reloads key in background before TTL expires
- 3.3.2 Predictive prefetch — access pattern analysis drives pre-warming
- 3.3.3 Stale-while-revalidate — serve stale immediately; refresh asynchronously
- 3.3.4 Risk — wasted resources prefetching keys that won't be accessed again

#### 3.4 Request Coalescing (Thundering Herd Prevention)
- 3.4.1 Problem — many simultaneous misses all hit origin at once
- 3.4.2 Single-flight / promise coalescing — first miss fetches; all others wait on same promise
- 3.4.3 Lock-based coalescing — per-key mutex during cache population
- 3.4.4 Probabilistic early expiration (PER) — jittered TTL spreads miss timing

---

### 4.0 Write Strategies & Consistency

#### 4.1 Write-Through
- 4.1.1 Write flow — write cache and origin synchronously in same request
- 4.1.2 Strong consistency — cache always mirrors latest persisted state
- 4.1.3 Write latency cost — both stores must acknowledge before returning
- 4.1.4 Best for — read-heavy workloads where data is read immediately after write

#### 4.2 Write-Behind (Write-Back)
- 4.2.1 Write flow — write to cache immediately; async flush to origin later
- 4.2.2 Low write latency — origin write is non-blocking from client perspective
- 4.2.3 Durability risk — data loss if cache crashes before flush completes
- 4.2.4 Batch coalescing — multiple writes merged before flushing to origin

#### 4.3 Write-Around
- 4.3.1 Write flow — write directly to origin; bypass cache entirely
- 4.3.2 Cache pollution avoided — write-once / read-rarely data doesn't evict hot keys
- 4.3.3 Cache populated only on subsequent reads (reverts to cache-aside behavior)
- 4.3.4 Best for — bulk imports, log ingestion, archival writes

#### 4.4 Event-Driven Cache Population
- 4.4.1 Change Data Capture (CDC) — Debezium/DynamoDB Streams trigger cache updates
- 4.4.2 Outbox pattern — DB transaction writes event; consumer updates cache
- 4.4.3 Kafka consumer — cache updated as side-effect of event consumption
- 4.4.4 Delivery guarantees — at-least-once vs exactly-once and idempotency implications
