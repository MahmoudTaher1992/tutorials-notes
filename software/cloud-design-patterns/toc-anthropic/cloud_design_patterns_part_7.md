# Cloud Design Patterns - Part 7: Data Management (II)

## 4.0 Data Management Patterns (continued)

### 4.3 Sharding / Data Partitioning
#### 4.3.1 Pattern Intent & Motivation
- 4.3.1.1 Distribute data across multiple nodes to exceed single-node capacity limits
- 4.3.1.2 Improve read/write throughput by parallelizing I/O across shards
#### 4.3.2 Partitioning Strategies
- 4.3.2.1 Range partitioning — partition by value range (e.g., userId 0-999 → shard A)
  - 4.3.2.1.1 Hot partition risk — sequential keys create write hotspot on latest range shard
- 4.3.2.2 Hash partitioning — shard = hash(key) % N; uniform distribution
  - 4.3.2.2.1 Hash function selection — consistent hash vs. modulo; consistent hash minimizes remapping
- 4.3.2.3 List partitioning — explicit mapping of key values to shards (e.g., by region/country)
- 4.3.2.4 Composite partitioning — combine strategies (e.g., range on date, hash within day)
#### 4.3.3 Consistent Hashing
- 4.3.3.1 Hash ring — nodes placed at positions on 0-2^32 ring; keys routed to next clockwise node
- 4.3.3.2 Virtual nodes (vnodes) — multiple ring positions per physical node; improves balance
  - 4.3.3.2.1 Cassandra tokens — 256 vnodes per node by default
- 4.3.3.3 Node addition/removal — only neighboring keys remapped; O(K/N) remapping vs. O(K)
#### 4.3.4 Cross-Shard Query Problem
- 4.3.4.1 Scatter-gather — fan out query to all shards; aggregate results in application layer
  - 4.3.4.1.1 Latency — max(shard_latencies); long tail amplified by number of shards
- 4.3.4.2 Denormalization — embed frequently queried cross-shard data to avoid scatter-gather
- 4.3.4.3 Secondary index — maintain global secondary index shard for non-partition-key queries
#### 4.3.5 Rebalancing
- 4.3.5.1 Manual rebalancing — operator assigns specific key ranges; predictable but labor-intensive
- 4.3.5.2 Automatic rebalancing — system detects imbalance and migrates data; risk during migration
- 4.3.5.3 Online rebalancing — double-write to old and new shard during migration; zero downtime
#### 4.3.6 Sharding Anti-patterns
- 4.3.6.1 Premature sharding — shard before hitting single-node limits; unnecessary complexity
- 4.3.6.2 Hot shard — celebrity/viral key concentrates all traffic on one shard
  - 4.3.6.2.1 Mitigation — random suffix on hot key; fan-out reads across synthetic shards

### 4.4 Caching Strategies
#### 4.4.1 Cache-Aside (Lazy Loading)
- 4.4.1.1 Application checks cache first; on miss, loads from DB and populates cache
  - 4.4.1.1.1 Cache population flow — read → miss → DB load → cache write → return value
- 4.4.1.2 Cache invalidation — explicit delete/update on write; or TTL-based expiry
- 4.4.1.3 Cache stampede — many concurrent misses all hit DB before first populates cache
  - 4.4.1.3.1 Mitigation — mutex/lock on cache miss; probabilistic early expiry (XFetch); request coalescing
#### 4.4.2 Write-Through
- 4.4.2.1 Every write goes to cache and DB synchronously; cache always consistent with DB
- 4.4.2.2 Write amplification — every write penalized by cache update overhead
- 4.4.2.3 Cache pollution — writes populate cold keys rarely read; wastes cache capacity
#### 4.4.3 Write-Behind (Write-Back)
- 4.4.3.1 Write to cache first; asynchronously flush to DB in background
  - 4.4.3.1.1 Durability risk — cache failure before flush = data loss
- 4.4.3.2 Batching writes — coalesce multiple writes to same key into single DB write
- 4.4.3.3 Suitable for — high-write workloads where eventual persistence is acceptable
#### 4.4.4 Read-Through
- 4.4.4.1 Cache handles DB loading transparently; application always talks to cache
- 4.4.4.2 Application code simplified — no explicit cache-aside logic
- 4.4.4.3 Cold start problem — cache empty on first deployment; DB hit spike
#### 4.4.5 Cache Eviction Policies
- 4.4.5.1 LRU (Least Recently Used) — evict item not accessed for longest time
  - 4.4.5.1.1 Implementation — doubly linked list + hash map; O(1) get and put
- 4.4.5.2 LFU (Least Frequently Used) — evict item with lowest access count
  - 4.4.5.2.1 Implementation — min-heap or O(1) with doubly linked lists indexed by frequency
- 4.4.5.3 FIFO — evict oldest inserted item; simple but ignores access patterns
- 4.4.5.4 TTL-based expiry — explicit time-to-live regardless of access pattern
  - 4.4.5.4.1 Sliding TTL — reset expiry on each access; keeps hot items alive
#### 4.4.6 Distributed Cache Topology
- 4.4.6.1 Client-side cache — in-process; zero network latency; consistency challenge on multi-instance
- 4.4.6.2 Sidecar cache — cache process co-located per application node; Envoy HTTP caching
- 4.4.6.3 Distributed cache cluster — Redis Cluster, Memcached; shared across app instances
  - 4.4.6.3.1 Redis Cluster — hash slots (16384); gossip protocol; replica per shard
  - 4.4.6.3.2 Redis Cluster failure — requires 3 masters for quorum; automatic failover
#### 4.4.7 Cache Warming & Consistency
- 4.4.7.1 Cache warming — pre-populate cache before traffic; avoids cold-start thundering herd
- 4.4.7.2 Cache-aside invalidation — on write, delete cache key; next read repopulates
- 4.4.7.3 Cache coherency in multi-region — cross-region invalidation adds latency; accept stale
