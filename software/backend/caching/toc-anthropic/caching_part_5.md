# Caching in Software Engineering - Part 5: CDN, In-Process, HTTP, DB, DevOps & Cloud Caches

---

> Convention:
> → Ideal §X.X = identical to Phase 1 section
> **Unique:** = behavior/feature not covered in Phase 1

---

### 16.0 CDN Caching

#### 16.1 Core CDN Cache Model
- → Ideal §2.1.2 (edge cache / CDN tier)
- → Ideal §6.3 (surrogate-key / tag-based invalidation)
- → Ideal §3.3 (stale-while-revalidate at edge)

#### 16.2 Cloudflare
- **Unique: Cache Rules (Cache Rules UI)** — configure TTL, bypass, edge cache TTL per URL pattern
- **Unique: Cache Everything** — cache HTML responses (disabled by default); requires explicit rule
- **Unique: Tiered Cache** — upper-tier PoP shields lower-tier PoPs from origin; reduces origin load
- **Unique: Cache Reserve** — persistent cache backed by R2 object storage; survives PoP cache purge
- **Unique: Purge by tag / prefix / URL** — instant purge via API; Cache-Tag header required
- **Unique: Workers KV** — globally distributed key-value store at edge; programmatic cache logic
- **Unique: Cache API in Workers** — `caches.default.put/match`; fully programmable caching behavior

#### 16.3 AWS CloudFront
- **Unique: Behaviors** — path-pattern-based rules; each behavior has its own cache policy
- **Unique: Cache Policy** — define TTL (min/default/max), headers/cookies/query strings to include in key
- **Unique: Origin Request Policy** — control what is forwarded to origin (separate from cache key)
- **Unique: Cache invalidation** — invalidate by path pattern (`/images/*`); charged per path
- **Unique: Origin Shield** — regional intermediate cache layer; collapses requests to origin
- **Unique: Lambda@Edge / CloudFront Functions** — run logic at edge; modify request/response headers
- **Unique: Signed URLs / Cookies** — restrict cache access to authenticated requests

#### 16.4 Fastly
- **Unique: VCL at edge** — full Varnish VCL support in CDN; highly programmable
- **Unique: Instant Purge** — purge by URL or surrogate key propagates globally in ~150ms
- **Unique: Surrogate-Control header** — separate TTL for edge vs Cache-Control for browsers
- **Unique: Shielding** — designated shield PoP absorbs misses; only shield contacts origin
- **Unique: Compute@Edge** — WebAssembly runtime at edge for custom caching logic

---

### 17.0 In-Process / Application-Level Caches

#### 17.1 Caffeine (Java)
- → Ideal §5.2 (W-TinyLFU — Caffeine's native eviction algorithm)
- **Unique: W-TinyLFU internals** — Window LRU + Protected LRU + Probationary LRU segments
- **Unique: Frequency sketch** — Count-Min Sketch approximates access frequency with low memory
- **Unique: Async loading** — `AsyncLoadingCache`; non-blocking cache population via CompletableFuture
- **Unique: Refresh-after-write** — background refresh triggered after write TTL; stale-while-revalidate
- **Unique: Weak/soft references** — allow GC to evict entries under memory pressure
- **Unique: Stats recording** — built-in hit rate, load time, eviction count per cache instance

#### 17.2 Node.js — lru-cache / node-cache
- **Unique: lru-cache** — pure LRU; supports max size by count or byte size; TTL per entry
- **Unique: node-cache** — TTL-only eviction; periodic `checkperiod` sweep; clone-on-set/get option
- **Unique: Async limitations** — single-threaded JS; no lock primitives; stampede mitigation via async queuing
- **Unique: Memory limit** — no OS-level enforcement; app must set maxSize to prevent heap exhaustion

#### 17.3 Python — functools & cachetools
- **Unique: @lru_cache** — stdlib decorator; fixed maxsize; no TTL support; thread-safe
- **Unique: @cache (3.9+)** — unbounded LRU; simpler API; memory leak risk if keys are unbounded
- **Unique: cachetools.TTLCache** — LRU + TTL; thread-unsafe by default; wrap with `Lock`
- **Unique: cachetools.LFUCache** — LFU eviction; useful for skewed frequency distributions
- **Unique: dogpile.cache** — stampede prevention via distributed lock; pluggable backends (Redis, Memcached)

---

### 18.0 HTTP Caching (Browser & Proxy Layer)

#### 18.1 Cache-Control Directives (RFC 9111)
- **Unique: max-age** — TTL in seconds for client and shared caches
- **Unique: s-maxage** — overrides max-age for shared caches (CDN, proxy); browser ignores
- **Unique: no-store** — do not cache anywhere; every request hits origin
- **Unique: no-cache** — cache stores response; must revalidate with origin before serving
- **Unique: private** — only browser may cache; CDN/proxy must not store
- **Unique: public** — shared caches may cache even when Authorization header present
- **Unique: stale-while-revalidate** — serve stale for N seconds while refreshing in background
- **Unique: stale-if-error** — serve stale for N seconds when origin returns 5xx
- **Unique: immutable** — content never changes; browser skips revalidation during max-age

#### 18.2 ETag & Conditional Requests
- **Unique: ETag** — opaque identifier for resource version; strong (`"abc"`) vs weak (`W/"abc"`)
- **Unique: If-None-Match** — client sends ETag; server returns 304 if unchanged; no body transfer
- **Unique: Last-Modified / If-Modified-Since** — time-based revalidation; lower precision than ETag
- **Unique: Conditional PUT** — If-Match prevents lost-update problem in concurrent writes

#### 18.3 Vary Header & Content Negotiation
- **Unique: Vary: Accept-Encoding** — separate cache entries for gzip vs br vs identity
- **Unique: Vary: Accept-Language** — language-specific cached responses
- **Unique: Vary explosion** — too many Vary dimensions → cache fragmentation, low hit rate
- **Unique: CDN Vary handling** — many CDNs normalize or strip Vary; check vendor behavior

---

### 19.0 Database Query & Buffer Caching

#### 19.1 PostgreSQL
- **Unique: shared_buffers** — portion of RAM for PostgreSQL to cache data pages (default 128MB; tune to 25% RAM)
- **Unique: OS page cache** — PostgreSQL relies heavily on kernel page cache for additional buffering
- **Unique: pg_buffercache extension** — inspect buffer cache contents and usage per relation
- **Unique: Prepared statement cache** — server-side plan cache; `PREPARE` / `EXECUTE`
- **Unique: Connection pooling** — PgBouncer transaction mode; reduce parse/plan overhead per request

#### 19.2 MySQL / ProxySQL
- **Unique: Query cache (removed 8.0)** — deprecated in 5.7, removed in 8.0; mutex contention scaled poorly
- **Unique: InnoDB buffer pool** — equivalent to pg shared_buffers; tune innodb_buffer_pool_size
- **Unique: ProxySQL query cache** — proxy-layer query result cache; TTL-based; regex match rules
- **Unique: ProxySQL query routing** — route reads to replicas; writes to primary

---

### 20.0 DevOps & Infrastructure Caching

#### 20.1 Docker Layer Cache
- **Unique: Copy-on-write layers** — each Dockerfile instruction is a cached layer; reused on rebuild
- **Unique: Cache invalidation trigger** — any change to a layer invalidates all subsequent layers
- **Unique: Layer ordering strategy** — place frequently changing steps (COPY source) last in Dockerfile
- **Unique: --cache-from** — reuse layers from a remote image (e.g., previously pushed CI image)
- **Unique: BuildKit inline cache** — `--build-arg BUILDKIT_INLINE_CACHE=1`; embed cache metadata in image

#### 20.2 CI/CD Dependency Caching
- **Unique: GitHub Actions cache action** — cache node_modules / .gradle / pip by lockfile hash key
- **Unique: Cache key strategy** — `hashFiles('**/package-lock.json')` as key; fallback restore-keys
- **Unique: GitLab CI cache** — per-job or per-branch cache; `policy: pull` (read-only in non-main)
- **Unique: Cache invalidation** — lockfile change busts cache; new full install

#### 20.3 Kubernetes & DNS Caching
- **Unique: CoreDNS ndots** — `ndots:5` causes 5 failed search-domain lookups before absolute DNS
- **Unique: NodeLocal DNSCache** — DaemonSet-based local DNS cache; eliminates kube-dns RTT per pod
- **Unique: DNS TTL in k8s** — CoreDNS respects upstream TTL; short service TTLs cause churn
- **Unique: ConfigMap / Secret caching** — kubelet caches projected volumes; propagation delay ~1min
- **Unique: OCI image layer cache in containerd** — node-level layer cache; shared across pods on same node

---

### 21.0 Cloud-Managed Cache Services

#### 21.1 AWS ElastiCache
- → Ideal §7 (cluster topology, replication)
- **Unique: Serverless mode** — auto-scales capacity; pay-per-use; no cluster sizing decisions
- **Unique: Global Datastore** — cross-region active-passive replication for Redis
- **Unique: Enhanced I/O multiplexing** — AWS-specific: multiplexes client connections to reduce per-client overhead
- **Unique: Memcached mode** — managed Memcached; auto-discovery endpoint for cluster nodes

#### 21.2 GCP Memorystore
- **Unique: Redis + Valkey** — supports open-source Redis and Valkey (Redis fork)
- **Unique: Private Service Access** — peering-based connectivity; no public endpoint
- **Unique: RDB import/export** — migrate data via Cloud Storage RDB files
- **Unique: Maintenance windows** — scheduled updates with replica failover to minimize downtime

#### 21.3 Azure Cache for Redis
- **Unique: Active geo-replication** — multi-region active-active (Enterprise tier; CRDT-based)
- **Unique: Redis modules** — RedisJSON, RediSearch, RedisBloom available on Enterprise tier
- **Unique: Microsoft Entra authentication** — token-based auth instead of password; RBAC integration
- **Unique: Zone redundancy** — replicas spread across availability zones within a region
