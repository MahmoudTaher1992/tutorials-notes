# Caching in Software Engineering - Part 4: Implementations — Redis, Memcached, Varnish, Nginx

---

## Phase 2: Specific Implementations

> Convention:
> → Ideal §X.X = identical to Phase 1 section
> **Unique:** = behavior/feature not covered in Phase 1

---

### 12.0 Redis

#### 12.1 Cache Read/Write Strategies
- → Ideal §3 (cache-aside, read-through, refresh-ahead)
- → Ideal §4 (write-through, write-behind, write-around)
- **Unique: SET NX (SETNX)** — atomic "set if not exists"; safe distributed lock for stampede prevention
- **Unique: SET EX / PEXPIRE** — TTL set atomically with value; no race between SET and EXPIRE

#### 12.2 Eviction & Memory Configuration
- → Ideal §5 (LRU, LFU, TTL)
- **Unique: maxmemory-policy** — 8 policies: noeviction, allkeys-lru, volatile-lru, allkeys-lfu, volatile-lfu, allkeys-random, volatile-random, volatile-ttl
- **Unique: maxmemory-samples** — tune approximated LRU/LFU sample size (default 5; higher = more accurate, more CPU)
- **Unique: Active defragmentation** — `activedefrag yes`; online memory compaction without restart

#### 12.3 Data Structures as Cache Primitives
- **Unique: Hash** — store object fields individually; HGETALL vs per-field HGET; partial updates
- **Unique: Sorted Set** — leaderboards, time-windowed rate limiting, priority queues
- **Unique: Bitmap** — compact boolean arrays (DAU tracking with BITCOUNT)
- **Unique: HyperLogLog** — probabilistic unique count; fixed 12KB regardless of cardinality
- **Unique: Stream** — append-only log; consumer groups for event-driven cache invalidation

#### 12.4 Cluster Mode & Hash Slots
- → Ideal §7.2 (server-side sharding)
- **Unique: 16384 hash slots** — keyspace divided into fixed slots; each node owns a range
- **Unique: Hash tags {}** — `{user}.profile` and `{user}.sessions` map to same slot; enables multi-key ops
- **Unique: MOVED / ASK redirects** — client receives slot location on wrong-node request
- **Unique: Cluster bus port** — nodes gossip on port+10000; firewall must allow both ports

#### 12.5 Client-Side Caching (Tracking)
- **Unique: RESP3 + CLIENT TRACKING** — server pushes invalidation messages to client
- **Unique: Broadcasting mode** — server sends invalidations for all tracked key patterns
- **Unique: Opt-in tracking** — client registers keys to track; server notifies on change
- **Unique: Bcast mode prefix** — track all keys under `user:` prefix without registering each key

#### 12.6 Transactions & Atomic Operations
- → Ideal §8.4 (optimistic locking)
- **Unique: MULTI/EXEC** — queue commands; execute atomically; no interleaving guaranteed
- **Unique: WATCH** — optimistic lock; EXEC returns nil if watched key changed since WATCH
- **Unique: Lua scripting** — EVAL runs script atomically server-side; custom cache logic without round trips

#### 12.7 Persistence & Durability
- **Unique: RDB snapshots** — point-in-time dump; fast restart; risk of data loss between snapshots
- **Unique: AOF** — log every write; appendfsync: always/everysec/no trade-offs
- **Unique: Hybrid RDB+AOF** — AOF rewrite embeds RDB; fast load + minimal data loss
- **Unique: WAIT command** — block until N replicas acknowledge write; synchronous durability guarantee

---

### 13.0 Memcached

#### 13.1 Core Caching Model
- → Ideal §3.1 (cache-aside — only pattern supported natively)
- → Ideal §5.1 (LRU eviction)
- → Ideal §5.5 (TTL expiration — max 30 days)

#### 13.2 Slab Allocator Internals
- **Unique: Slab classes** — memory divided into fixed-size classes (64B, 128B, … 1MB)
- **Unique: No fragmentation within slabs** — items fit into nearest slab class; external fragmentation possible
- **Unique: Slab rebalancing** — automatic reallocation of slabs between classes (automove)
- **Unique: Per-slab LRU** — each slab class has independent LRU; no cross-class eviction competition

#### 13.3 Multi-Threading Model
- **Unique: True multi-threading** — worker threads handle I/O in parallel; no GIL equivalent
- **Unique: vs Redis single-thread** — Memcached scales with CPU cores; Redis uses I/O multiplexing
- **Unique: Thread contention** — lock contention on shared LRU can limit scaling at high core counts

#### 13.4 Protocol
- **Unique: Text protocol** — human-readable; GET, SET, DELETE, INCR over TCP
- **Unique: Binary protocol** — lower CPU overhead; supports pipelining and quiet commands
- **Unique: Meta protocol** — newer; combines get/set/cas/touch in a single command family
- **Unique: UDP support** — low-latency reads via UDP (no connection overhead); dropped packets = miss

#### 13.5 Deployment & Limitations
- **Unique: No persistence** — purely in-memory; restart = full data loss
- **Unique: No replication built-in** — replication handled at client layer (consistent hashing to replicas)
- **Unique: No native cluster** — client-side consistent hashing only (mcrouter, twemproxy)
- **Unique: Max value size** — 1MB default limit; configurable but not designed for large blobs

---

### 14.0 Varnish Cache

#### 14.1 VCL — Varnish Configuration Language
- **Unique: VCL pipeline** — request processed through vcl_recv → vcl_hash → vcl_hit/miss → vcl_deliver
- **Unique: vcl_recv** — decide to cache, pass, pipe, or synth (generate response)
- **Unique: vcl_hash** — define cache key; add/remove headers from key computation
- **Unique: vcl_backend_response** — inspect backend response; set TTL, grace, saint mode
- **Unique: inline C / VMOD** — extend VCL with C modules (vmods) for custom logic

#### 14.2 Storage Backends
- **Unique: malloc** — in-memory storage; default; bounded by RAM
- **Unique: file** — mmap-backed file on disk; survives minor restarts
- **Unique: persistent** — on-disk storage with index; survives full restart (experimental)
- **Unique: Transient** — short-lived objects stored separately; avoids polluting main cache

#### 14.3 Grace Mode & Stale Serving
- → Ideal §3.3 (stale-while-revalidate)
- **Unique: Grace period** — serve stale object while fetching fresh; `set beresp.grace`
- **Unique: Saint mode** — mark backend sick for specific URL on error; try next backend
- **Unique: Beresp.saintmode** — time window to avoid sick URL; prevent cascading errors

#### 14.4 ESI — Edge Side Includes
- **Unique: ESI tags** — `<esi:include src="/fragment"/>` in HTML; Varnish assembles page from parts
- **Unique: Per-fragment TTL** — each ESI fragment cached independently with own TTL
- **Unique: Use case** — high-traffic pages with personalized components; cache the frame, not the user bits

#### 14.5 Purging & Ban Invalidation
- → Ideal §6.2 (event-driven invalidation)
- **Unique: PURGE HTTP method** — send PURGE request to Varnish to evict specific URL
- **Unique: Ban expressions** — regex-based bulk invalidation: `ban req.url ~ "^/products"`
- **Unique: Lurker thread** — background thread evaluates ban list against cached objects
- **Unique: Surrogate keys (Xkey vmod)** — tag-based purging; purge all objects with a tag

---

### 15.0 Nginx Proxy Cache

#### 15.1 Cache Configuration
- **Unique: proxy_cache_path** — defines cache zone, size, levels (directory depth), inactive TTL
- **Unique: proxy_cache** — enables cache for a location block; references named zone
- **Unique: proxy_cache_key** — define cache key (default: scheme+host+URI)
- **Unique: proxy_cache_valid** — set TTL per response code (200, 301, 404)
- **Unique: proxy_cache_use_stale** — serve stale on error/updating/timeout conditions

#### 15.2 Cache Control & Bypass
- **Unique: proxy_cache_bypass** — condition to skip cache (e.g., cookie present)
- **Unique: proxy_no_cache** — condition to not store response in cache
- **Unique: Add_header X-Cache-Status** — expose HIT/MISS/BYPASS/EXPIRED to clients
- **Unique: proxy_cache_lock** — coalesces concurrent misses; only one upstream request per key

#### 15.3 Cache Purging
- **Unique: ngx_cache_purge module** — PURGE method support (third-party module)
- **Unique: proxy_cache_purge directive** — condition-based purge within config
- **Unique: Limitation** — no native tag-based invalidation; URL-level only without modules
