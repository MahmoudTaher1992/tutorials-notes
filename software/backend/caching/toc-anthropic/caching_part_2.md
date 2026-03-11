# Caching in Software Engineering - Part 2: Eviction, Invalidation, Distributed & Failure Modes

---

### 5.0 Eviction Policies & Memory Management

#### 5.1 LRU — Least Recently Used
- 5.1.1 Core mechanic — evict the key not accessed for the longest time
- 5.1.2 Doubly linked list + hash map — O(1) get and O(1) eviction implementation
- 5.1.3 Approximated LRU — Redis samples N random keys; evicts oldest sample
- 5.1.4 LRU weakness — scan-resistant failure; single sequential scan evicts hot keys
- 5.1.5 volatile-lru — LRU only among keys with TTL set

#### 5.2 LFU — Least Frequently Used
- 5.2.1 Core mechanic — evict the key accessed the fewest times
- 5.2.2 Frequency counter decay — counters halved over time to favor recency
- 5.2.3 W-TinyLFU — admission filter + main LRU + protected LRU segments (Caffeine)
- 5.2.4 LFU advantage over LRU — scan-resistant; new items don't flush hot items
- 5.2.5 volatile-lfu — LFU only among keys with TTL set

#### 5.3 ARC — Adaptive Replacement Cache
- 5.3.1 Four lists — T1 (recent once), T2 (recent twice), B1 (ghost recent), B2 (ghost freq)
- 5.3.2 Self-tuning — balance between recency and frequency shifts dynamically
- 5.3.3 Patent constraints — ARC patented by IBM; influenced CLOCK-Pro alternative

#### 5.4 CLOCK / Second-Chance Algorithm
- 5.4.1 Circular buffer — pointer sweeps through entries
- 5.4.2 Reference bit — set on access; cleared on first sweep; evict on second sweep
- 5.4.3 Lower overhead than full LRU — no pointer manipulation per access
- 5.4.4 CLOCK-Pro — extends CLOCK with cold/hot/ghost page classification

#### 5.5 TTL-Based Expiration
- 5.5.1 Absolute TTL — expires at fixed wall-clock time
- 5.5.2 Sliding TTL — TTL resets on each access
- 5.5.3 Lazy expiration — entry checked on access; deleted if expired
- 5.5.4 Active expiration — background sweep proactively deletes expired keys
- 5.5.5 TTL jitter — random ±% offset to prevent synchronized mass expiry

#### 5.6 Memory Fragmentation & Allocators
- 5.6.1 Memory fragmentation ratio — RSS / used_memory; >1.5 indicates fragmentation
- 5.6.2 jemalloc — default Redis allocator; thread-local arenas reduce contention
- 5.6.3 Slab allocator — Memcached; fixed-size slab classes; no fragmentation, rigid sizing
- 5.6.4 Active defragmentation — Redis can realloc live keys to compact memory

---

### 6.0 Cache Invalidation & Coherence

#### 6.1 TTL Passive Expiration
- 6.1.1 Simplest invalidation — set TTL at write time; let data expire naturally
- 6.1.2 Staleness window — acceptable if business logic tolerates eventual consistency
- 6.1.3 Short TTL trade-off — higher miss rate, more origin load

#### 6.2 Event-Driven Active Invalidation
- 6.2.1 Explicit delete — app deletes key on write to origin
- 6.2.2 Pub/sub invalidation — broadcast delete events to all cache nodes
- 6.2.3 Cache-aside + delete — write to DB first, then delete cache key (not update)
- 6.2.4 Why delete not update — avoids race where stale concurrent read overwrites new write

#### 6.3 Tag-Based / Surrogate-Key Invalidation
- 6.3.1 Tag keys — cache entries tagged with logical grouping (e.g., user:42)
- 6.3.2 Bulk invalidation — delete all keys associated with a tag in one operation
- 6.3.3 CDN surrogate keys — Fastly/Cloudflare support purge-by-tag at edge

#### 6.4 Versioning & Key Namespacing
- 6.4.1 Version prefix — embed schema/data version in key: `v2:user:42`
- 6.4.2 Namespace bumping — increment global namespace version to invalidate all keys
- 6.4.3 Key expiration vs key versioning — versioning leaves orphan keys (memory leak risk)

#### 6.5 Two-Phase Invalidation
- 6.5.1 Problem — gap between cache delete and DB write allows stale reads
- 6.5.2 Delete-before-write — delete cache key, write DB, let next read repopulate
- 6.5.3 Delayed double-delete — delete, write DB, wait replication lag, delete again
- 6.5.4 Applicable when — read replicas with replication lag are in use

---

### 7.0 Distributed Caching & Cluster Topology

#### 7.1 Consistent Hashing
- 7.1.1 Hash ring — nodes placed on ring; key maps to nearest clockwise node
- 7.1.2 Virtual nodes (vnodes) — multiple ring positions per node for balanced distribution
- 7.1.3 Node addition/removal — only ~1/N keys remapped; minimal reshuffling
- 7.1.4 Jump consistent hash — O(1) alternative; no ring data structure needed

#### 7.2 Sharding Strategies
- 7.2.1 Client-side sharding — client library computes target node from key
- 7.2.2 Proxy-based sharding — Twemproxy, mcrouter route requests to shards
- 7.2.3 Server-side sharding — Redis Cluster; server redirects with MOVED/ASK
- 7.2.4 Shard imbalance — hot key problem; one shard overloaded

#### 7.3 Replication Topologies
- 7.3.1 Primary-replica — async replication; replicas serve reads; primary serves writes
- 7.3.2 Replication lag — replica may serve stale data during propagation window
- 7.3.3 Multi-primary / active-active — CRDTs handle write conflicts (Redis Enterprise)
- 7.3.4 Sentinel — automated failover for primary-replica; quorum-based leader election

#### 7.4 Cross-Datacenter / Geo-Distributed Caching
- 7.4.1 Regional cache clusters — each region has own cluster; no cross-region reads
- 7.4.2 Global invalidation — events propagated across regions to invalidate stale data
- 7.4.3 CRDTs — conflict-free replicated data types for multi-region active-active writes
- 7.4.4 Latency vs consistency — region-local reads are fast; cross-region sync adds lag

---

### 8.0 Failure Modes & Resilience

#### 8.1 Cache Stampede (Thundering Herd)
- 8.1.1 Trigger — popular key expires; many concurrent misses all hit origin
- 8.1.2 Single-flight — collapse concurrent misses into one origin request
- 8.1.3 Mutex locking per key — first miss acquires lock; others wait or serve stale
- 8.1.4 Probabilistic early expiration — recompute key early with jitter before expiry

#### 8.2 Cache Avalanche
- 8.2.1 Trigger — mass simultaneous expiry (all keys set with same TTL)
- 8.2.2 Prevention — TTL jitter across keys; staggered expiration times
- 8.2.3 Cache warm-up — pre-populate before going live; gradual traffic ramp
- 8.2.4 Circuit breaker on origin — prevent cascade failure when origin is overwhelmed

#### 8.3 Hot Key Problem
- 8.3.1 Cause — single key receiving disproportionate traffic (celebrity post, flash sale)
- 8.3.2 Local replica cache — mirror hot keys in-process on each app server
- 8.3.3 Key sharding — split `hot-key` into `hot-key:{0..N}` and fan-out reads
- 8.3.4 Read replication — route hot key reads to multiple replicas

#### 8.4 Cache Poisoning (Data Integrity)
- 8.4.1 Stale-write race — concurrent writer stores outdated data after newer write
- 8.4.2 Compare-and-swap (CAS) — conditional set only if version matches
- 8.4.3 Optimistic locking with watch — WATCH key in Redis transactions
- 8.4.4 Idempotent population — safe to repopulate from authoritative source

#### 8.5 Cold-Start & Warm-Up
- 8.5.1 Cache pre-warming — background job populates cache before serving traffic
- 8.5.2 Gradual traffic shifting — canary or blue-green to warm new cache nodes
- 8.5.3 Persistent cache snapshots — restore RDB on restart to avoid cold start
- 8.5.4 Lazy warming with fallback — serve from origin until cache self-populates
