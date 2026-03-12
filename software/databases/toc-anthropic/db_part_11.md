# Databases Complete Study Guide - Part 11: MySQL/MariaDB & SQLite

## 22.0 MySQL / MariaDB

### 22.1 InnoDB Storage Engine
#### 22.1.1 InnoDB Architecture
- 22.1.1.1 Clustered primary key — data rows in PK B-tree leaf — no heap — fast PK lookup
  - 22.1.1.1.1 Secondary index — leaf stores PK — double lookup — extra traversal
  - 22.1.1.1.2 Auto-increment PK — sequential inserts — minimal page splits — performance
  - 22.1.1.1.3 UUID PK — random inserts — excessive page splits — prefer UUID v7 or ULID
- 22.1.1.2 Buffer pool — LRU-based — young/old sub-lists — innodb_buffer_pool_size
  - 22.1.1.2.1 Young/old split — new page inserted to old sub-list — promoted after 1s read
  - 22.1.1.2.2 innodb_buffer_pool_instances — multiple pools — reduce mutex contention
  - 22.1.1.2.3 Warm-up — innodb_buffer_pool_dump_at_shutdown — reload on start
- 22.1.1.3 Doublewrite buffer — write page twice — prevent torn page on crash — 2x I/O cost
  - 22.1.1.3.1 FusionIO / ZFS — atomic writes — skip doublewrite — innodb_doublewrite=OFF

#### 22.1.2 InnoDB Transactions
- 22.1.2.1 MVCC with undo log — read view at txn start — undo log segments — history list
  - 22.1.2.1.1 Purge thread — remove old undo log — history list length — monitor for bloat
  - 22.1.2.1.2 Long-running transactions — hold read view — prevent undo purge — massive bloat
- 22.1.2.2 Gap locks — lock range between index records — prevent phantom inserts
  - 22.1.2.2.1 Next-key lock — record lock + gap lock below — default at REPEATABLE READ
  - 22.1.2.2.2 Disable gap locks — innodb_locks_unsafe_for_binlog — only READ COMMITTED
- 22.1.2.3 Deadlock detection — waits-for graph — rollback smallest transaction — auto-retry

### 22.2 Replication & Binlog
#### 22.2.1 Binary Log
- 22.2.1.1 Binlog formats — STATEMENT / ROW / MIXED
  - 22.2.1.1.1 ROW format — log changed rows — large — safe — preferred for replicas
  - 22.2.1.1.2 STATEMENT — log SQL — compact — non-deterministic functions unsafe
  - 22.2.1.1.3 MIXED — auto-choose — statement normally — row for unsafe statements
- 22.2.1.2 GTID replication — Global Transaction ID — server_uuid:seq — position-less
  - 22.2.1.2.1 GTID auto-position — replica self-identifies missing GTIDs — easier failover
  - 22.2.1.2.2 errant GTID — transaction on replica not on primary — breaks GTID chain — fix

#### 22.2.2 High Availability
- 22.2.2.1 MySQL Group Replication — Paxos-based — multi-master or single-primary
  - 22.2.2.1.1 Conflict detection — certify each txn — same row updated = abort one
  - 22.2.2.1.2 Single-primary mode — one writer — automatic primary election on failure
- 22.2.2.2 MySQL InnoDB Cluster — Group Replication + MySQL Router + MySQL Shell
  - 22.2.2.2.1 MySQL Router — transparent failover — route to current primary — no app change
- 22.2.2.3 ProxySQL — connection pooling + query routing + read-write split — production HA
  - 22.2.2.3.1 Query rules — regex-based routing — SELECT → replicas — DML → primary

### 22.3 Query Optimization
#### 22.3.1 EXPLAIN & Optimizer
- 22.3.1.1 EXPLAIN FORMAT=JSON — full plan — cost + row estimates — access type
  - 22.3.1.1.1 type: ALL — full table scan — bad — add index or rewrite query
  - 22.3.1.1.2 type: ref/eq_ref — index lookup — good — eq_ref = unique match
  - 22.3.1.1.3 Extra: Using filesort — sort without index — may be optimized with composite index
- 22.3.1.2 Index hints — USE INDEX / FORCE INDEX — override optimizer — last resort
  - 22.3.1.2.1 Optimizer trace — optimizer_trace=ON — full decision log — deep debugging

---

## 23.0 SQLite

### 23.1 SQLite Architecture
#### 23.1.1 Embedded Engine
- 23.1.1.1 Single file database — entire DB in one .sqlite file — portable — zero-config
  - 23.1.1.1.1 WAL mode — write-ahead log — readers don't block writers — concurrent reads
  - 23.1.1.1.2 Journal mode=DELETE — default — rollback journal — writers block readers
- 23.1.1.2 Serverless — library linked into app — no daemon — function calls = SQL
  - 23.1.1.2.1 Use cases — mobile apps / browsers / embedded / testing — not client-server
  - 23.1.1.2.2 Write serialization — only one writer at a time — WAL allows concurrent readers

#### 23.1.2 Storage & Limits
- 23.1.2.1 B-tree pages — 4KB default page — configurable 512B–65536B — PRAGMA page_size
  - 23.1.2.1.1 Without rowid tables — user-defined PK as clustering key — more like InnoDB
  - 23.1.2.1.2 Max DB size — 281 TB theoretical — practical limit ~1TB for single file
- 23.1.2.2 Type affinity — flexible typing — TEXT/NUMERIC/INTEGER/REAL/BLOB — duck typing
  - 23.1.2.2.1 Storage class mismatch — store '123' as INTEGER — no strict type enforcement
  - 23.1.2.2.2 STRICT tables — SQLite 3.37+ — enforce column types — production-safe

### 23.2 WAL Mode & Concurrent Access
#### 23.2.1 WAL Behavior
- 23.2.1.1 WAL file — -wal suffix — readers use checkpoint index — writers append
  - 23.2.1.1.1 Checkpointing — copy WAL back to main DB — PRAGMA wal_checkpoint(TRUNCATE)
  - 23.2.1.1.2 Auto-checkpoint — every 1000 pages by default — WAL_AUTOCHECKPOINT pragma
- 23.2.1.2 SHM file — -shm suffix — shared memory index — coordination between processes
  - 23.2.1.2.1 Multiple readers — full concurrency in WAL mode — no reader blocking
  - 23.2.1.2.2 One writer limit — serialize writes — queue — no row-level locking
