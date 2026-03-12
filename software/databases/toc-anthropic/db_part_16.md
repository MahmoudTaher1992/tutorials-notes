# Databases Complete Study Guide - Part 16: CockroachDB & Google Spanner

## 32.0 CockroachDB & Google Spanner

### 32.1 CockroachDB
#### 32.1.1 Architecture
- 32.1.1.1 Layered architecture — SQL → KV → Distribution → Replication → Storage (Pebble)
  - 32.1.1.1.1 Pebble — RocksDB-compatible LSM — Go — CockroachDB's native storage engine
  - 32.1.1.1.2 Range — 512MB default — unit of replication — Raft group per range
  - 32.1.1.1.3 Leaseholder — range replica that serves reads — no remote round-trip — local
- 32.1.1.2 SQL gateway — any node accepts SQL — routes to leaseholder — distributed plan
  - 32.1.1.2.1 DistSQL — push partial execution to data nodes — reduce coordinator I/O
  - 32.1.1.2.2 Vectorized execution — columnar batches — SIMD — OLAP queries on CRDB

#### 32.1.2 Transactions
- 32.1.2.1 Serializable isolation — default — SSI via MVCC + timestamp ordering
  - 32.1.2.1.1 Write intents — provisional values — committed = resolved — visible to readers
  - 32.1.2.1.2 Transaction coordinator — timestamp assignment — retry on uncertainty restart
  - 32.1.2.1.3 Parallel commits — stage write intents + txn record atomically — latency win
- 32.1.2.2 Follower reads — as of system time — read from any replica — reduced latency
  - 32.1.2.2.1 AS OF SYSTEM TIME '-4.8s' — bounded staleness — follower read safe timestamp
  - 32.1.2.2.2 Experimental exact staleness — bounded_staleness() function — auto-pick freshest
- 32.1.2.3 Multi-region tables — REGIONAL BY ROW — row-level home region — low latency local
  - 32.1.2.3.1 GLOBAL table — fully replicated — read everywhere — low latency — write to primary
  - 32.1.2.3.2 REGIONAL BY TABLE — all rows home in one region — most use cases

### 32.2 Google Spanner
#### 32.2.1 TrueTime
- 32.2.1.1 TrueTime API — returns [earliest, latest] interval — GPS + atomic clocks — bounded ε
  - 32.2.1.1.1 TT.now().latest — safe commit timestamp — wait out interval — external consistency
  - 32.2.1.1.2 Commit wait — sleep until TT.now().earliest > commit timestamp — mandatory
  - 32.2.1.1.3 ε < 7ms typical — clock uncertainty — commit adds ~7ms to write latency
- 32.2.1.2 External consistency — if txn B starts after txn A commits — B sees A's writes — always
  - 32.2.1.2.1 Stronger than serializable — cross-machine — no logical clocks needed

#### 32.2.2 Architecture
- 32.2.2.1 Spanservers — Paxos groups per tablet — write log + SSTable storage (Colossus)
  - 32.2.2.1.1 Tablet — fine-grained split — 2GB default — Paxos group = 5 replicas
  - 32.2.2.1.2 Directory — unit of movement — set of contiguous keys — placed as unit
- 32.2.2.2 Read-write vs read-only transactions
  - 32.2.2.2.1 Read-write — acquire locks — 2PL — commit with TrueTime — serializable
  - 32.2.2.2.2 Read-only — snapshot at safe timestamp — no locks — parallel across Paxos groups
- 32.2.2.3 Interleaving — physical co-location of child rows with parent — CREATE TABLE ... INTERLEAVE IN PARENT
  - 32.2.2.3.1 Same Paxos group — parent + child — local join — avoid cross-shard transaction

### 32.3 Comparison
#### 32.3.1 CockroachDB vs Spanner
- 32.3.1.1 CockroachDB — open source — on-prem + cloud — HLC — ~ms clock uncertainty
  - 32.3.1.1.1 No commit wait overhead — HLC sufficient — slightly weaker than TrueTime
  - 32.3.1.1.2 PostgreSQL wire protocol compatible — easy migration — ecosystem reuse
- 32.3.1.2 Spanner — Google proprietary — GCP only — TrueTime — stronger guarantees
  - 32.3.1.2.1 Managed service — no ops burden — auto-scale — 99.999% SLA — Cloud Spanner
  - 32.3.1.2.2 Higher write latency — commit wait — but externally consistent — global apps
- 32.3.1.3 TiDB — MySQL compatible distributed SQL — TiKV storage — Raft — PD placement
  - 32.3.1.3.1 TiFlash — columnar storage — HTAP — same data in row (TiKV) + column (TiFlash)
  - 32.3.1.3.2 Optimistic + pessimistic transactions — MySQL compatible — auto-retry on conflict
