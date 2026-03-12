# Databases Complete Study Guide - Part 5: Replication & Sharding

## 7.0 Replication

### 7.1 Single-Leader Replication
#### 7.1.1 Architecture
- 7.1.1.1 Leader accepts writes — followers replicate — read scale via followers
  - 7.1.1.1.1 Synchronous replication — wait for follower ACK — zero data loss — slower writes
  - 7.1.1.1.2 Asynchronous replication — don't wait for follower — fast writes — data loss risk
  - 7.1.1.1.3 Semi-synchronous — wait for at least one follower — balance durability + perf
- 7.1.1.2 Replication log formats — statement-based / row-based / logical
  - 7.1.1.2.1 Statement-based — replay SQL — compact — non-deterministic functions break it
  - 7.1.1.2.2 Row-based — log changed rows — larger — safe — preferred for MySQL binlog
  - 7.1.1.2.3 Logical replication — higher-level — column-level — cross-version + cross-DB
- 7.1.1.3 Replication lag — follower behind leader — staleness risk on reads
  - 7.1.1.3.1 Read-your-writes — route reads to leader for own writes — or track latest LSN
  - 7.1.1.3.2 Monotonic reads — same user always hits same replica — session pinning
  - 7.1.1.3.3 Consistent prefix reads — causally related writes visible in order

#### 7.1.2 Failover & Leader Election
- 7.1.2.1 Automatic failover — detect leader failure — elect new leader — reconfigure
  - 7.1.2.1.1 Split-brain — two nodes think they're leader — data divergence — catastrophic
  - 7.1.2.1.2 STONITH — Shoot The Other Node In The Head — fencing — prevent split-brain
  - 7.1.2.1.3 VIP failover — virtual IP moves to new leader — transparent to clients
- 7.1.2.2 New leader selection — most up-to-date follower — highest LSN wins
  - 7.1.2.2.1 Lost writes risk — old leader had uncommitted writes — discard or merge
  - 7.1.2.2.2 Raft leader election — term + vote — majority quorum — safe choice

### 7.2 Multi-Leader Replication
#### 7.2.1 Architecture
- 7.2.1.1 Multiple leaders accept writes — useful for multi-datacenter + offline clients
  - 7.2.1.1.1 Per-datacenter leader — local writes — replicate between datacenters async
  - 7.2.1.1.2 Conflict risk — same row updated in two leaders — must resolve
- 7.2.1.2 Conflict resolution strategies
  - 7.2.1.2.1 Last-write-wins (LWW) — highest timestamp survives — data loss risk
  - 7.2.1.2.2 Merge — CRDT — combine both values — application-specific — safe
  - 7.2.1.2.3 On-write conflict handler — custom function — called when conflict detected
  - 7.2.1.2.4 On-read conflict handler — return all versions — app resolves — Amazon Dynamo

### 7.3 Leaderless Replication (Quorum)
#### 7.3.1 Quorum Reads & Writes
- 7.3.1.1 W + R > N — quorum — at least one node has latest value
  - 7.3.1.1.1 W = write quorum — nodes that must ACK write — durability control
  - 7.3.1.1.2 R = read quorum — nodes to read from — take newest version
  - 7.3.1.1.3 N = replication factor — total copies — typically 3 for RF=3
- 7.3.1.2 Common settings — W=2, R=2, N=3 — tolerates 1 failure for reads + writes
  - 7.3.1.2.1 W=1 — fast write — weak durability — data loss if node fails before replication
  - 7.3.1.2.2 R=1 — fast read — may read stale — W=3 compensates for consistency
- 7.3.1.3 Read repair — on read — newer value propagated to stale nodes — lazy sync
- 7.3.1.4 Anti-entropy — background process — compare replicas — sync differences
  - 7.3.1.4.1 Merkle tree — hash subtrees — efficiently find divergent ranges — DynamoDB

#### 7.3.2 Sloppy Quorum & Hinted Handoff
- 7.3.2.1 Sloppy quorum — write to reachable nodes even if not home nodes
  - 7.3.2.1.1 Hinted handoff — node stores write hint — sends to correct node when available
  - 7.3.2.1.2 Increases availability — at cost of consistency — may return stale read

---

## 8.0 Sharding & Partitioning

### 8.1 Horizontal Partitioning Strategies
#### 8.1.1 Range Partitioning
- 8.1.1.1 Divide key space into contiguous ranges — each shard owns range
  - 8.1.1.1.1 Hotspot risk — sequential inserts all go to one shard — partition hotspot
  - 8.1.1.1.2 Range queries efficient — rows in same range on same shard — no scatter
  - 8.1.1.1.3 PostgreSQL declarative partitioning — PARTITION BY RANGE (created_at)

#### 8.1.2 Hash Partitioning
- 8.1.2.1 Hash(key) mod N — distribute evenly — no hotspots — loses range locality
  - 8.1.2.1.1 Consistent hashing — reduce rebalancing on add/remove — virtual nodes
  - 8.1.2.1.2 Rendezvous hashing — alternative — pick highest-scoring node — smoother

### 8.2 Consistent Hashing
#### 8.2.1 Ring Architecture
- 8.2.1.1 Hash space as ring — nodes placed at positions — key goes to nearest clockwise node
  - 8.2.1.1.1 Adding node — only predecessor's keys move — minimal disruption
  - 8.2.1.1.2 Removing node — keys move to successor — graceful rebalance
- 8.2.1.2 Virtual nodes (vnodes) — each physical node = multiple ring positions
  - 8.2.1.2.1 150 vnodes per node — even distribution — heterogeneous nodes supported
  - 8.2.1.2.2 Failure handling — vnodes spread across ring — failure redistributed evenly

### 8.3 Cross-Shard Queries
#### 8.3.1 Scatter-Gather
- 8.3.1.1 Fan out to all shards — gather results — merge — sort — limit
  - 8.3.1.1.1 Latency = slowest shard — tail latency amplified — hedge requests
  - 8.3.1.1.2 Aggregation — SUM/COUNT — partial aggregates per shard — merge at coordinator
- 8.3.1.2 Cross-shard joins — expensive — avoid in schema design — denormalize
  - 8.3.1.2.1 Shard by same key — co-locate related data — e.g., all user data on same shard
  - 8.3.1.2.2 Broadcast small table — replicate lookup table to all shards — local join

### 8.4 Resharding & Rebalancing
#### 8.4.1 Rebalancing Strategies
- 8.4.1.1 Fixed partitions — pre-create many partitions — reassign whole partitions
  - 8.4.1.1.1 Elasticsearch — 5 shards fixed — can't split — plan ahead
- 8.4.1.2 Dynamic partitioning — split when too large — merge when too small — HBase
  - 8.4.1.2.1 Split threshold — 256MB HBase default — auto-split — reassign to new region server
- 8.4.1.3 Consistent hashing rebalance — add vnode positions — only move necessary data
  - 8.4.1.3.1 Gossip protocol — propagate routing table changes — Cassandra — eventual
