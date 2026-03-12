# Databases Complete Study Guide - Part 10: PostgreSQL

## 21.0 PostgreSQL

### 21.1 Architecture
#### 21.1.1 Process Model
- 21.1.1.1 Multi-process architecture — one backend per connection — no threading — fork model
  - 21.1.1.1.1 Postmaster — parent process — listen + accept — fork backend per client
  - 21.1.1.1.2 Backend process — handles one session — shared memory + local memory
  - 21.1.1.1.3 Connection pooling essential — PgBouncer — pgpool-II — avoid fork overhead
- 21.1.1.2 Background workers — autovacuum / WAL writer / checkpointer / bgwriter / walreceiver
  - 21.1.1.2.1 Autovacuum — daemon — triggers on dead tuple threshold — reclaim + analyze
  - 21.1.1.2.2 Checkpointer — write dirty pages — checkpoint_completion_target — spread I/O
  - 21.1.1.2.3 WAL writer — flush WAL buffers to disk — commit latency — wal_sync_method

#### 21.1.2 Storage Layout
- 21.1.2.1 Base directory — $PGDATA — pg_wal / pg_tblspc / base / global subdirs
  - 21.1.2.1.1 base/{oid}/ — one dir per database — files named by relfilenode
  - 21.1.2.1.2 Tablespace — symlink to separate storage — move large tables to faster disk
- 21.1.2.2 Page layout — 8KB page — PageHeader + ItemId array + free space + tuples
  - 21.1.2.2.1 TOAST — The Oversized-Attribute Storage Technique — rows > 2KB → toast table
  - 21.1.2.2.2 TOAST strategies — plain / external / extended / main — per column
  - 21.1.2.2.3 Line pointer array — ItemId — (offset, length, flags) — points to tuple

### 21.2 MVCC & Vacuum
#### 21.2.1 MVCC Implementation
- 21.2.1.1 xmin / xmax — each tuple — xmin = inserting txn — xmax = deleting txn
  - 21.2.1.1.1 Visibility rule — xmin committed AND (xmax null OR xmax not committed)
  - 21.2.1.1.2 Combo CID — multiple updates in same txn — combo command ID tracking
- 21.2.1.2 Transaction snapshot — active XIDs at txn start — determine visibility
  - 21.2.1.2.1 xmin / xmax / xip_list — snapshot components — visible = committed before xmin
  - 21.2.1.2.2 Hot standby conflict — replay WAL vs. query snapshot — recovery_min_apply_delay

#### 21.2.2 Vacuum & Autovacuum
- 21.2.2.1 VACUUM — mark dead tuples reusable — not returned to OS — within page free space
  - 21.2.2.1.1 VACUUM FULL — rewrite table — compact — exclusive lock — avoid on prod
  - 21.2.2.1.2 pg_stat_user_tables — n_dead_tup — monitor for bloat — trigger manual VACUUM
- 21.2.2.2 Autovacuum thresholds — autovacuum_vacuum_threshold + scale_factor × table_size
  - 21.2.2.2.1 Default scale_factor=0.2 — 20% dead tuples → trigger — too high for large tables
  - 21.2.2.2.2 Per-table storage parameters — fillfactor / autovacuum_vacuum_scale_factor
- 21.2.2.3 XID wraparound prevention — vacuum_freeze_min_age — freeze old tuples — assign FrozenXID
  - 21.2.2.3.1 autovacuum_freeze_max_age=200M — trigger freeze vacuum — prevent data loss

### 21.3 Extensions & Advanced Features
#### 21.3.1 Key Extensions
- 21.3.1.1 pgvector — vector similarity search — HNSW + IVFFlat index — in-database AI
  - 21.3.1.1.1 CREATE INDEX USING hnsw (embedding vector_cosine_ops) — cosine ANN
  - 21.3.1.1.2 <-> operator — L2 distance — <#> dot product — <=> cosine — query syntax
- 21.3.1.2 pg_partman — partition management — time/serial auto-partition — retention
  - 21.3.1.2.1 run_maintenance() — create future partitions — drop old — schedule via pg_cron
- 21.3.1.3 TimescaleDB — time-series extension — hypertable — chunk-based — compression
  - 21.3.1.3.1 Hypertable — automatic partitioning by time — chunk auto-creation
  - 21.3.1.3.2 Compression policy — convert old chunks to columnar — 90%+ size reduction
- 21.3.1.4 PostGIS — spatial extension — geometry types — spatial indexes — GiST
  - 21.3.1.4.1 ST_Distance / ST_Intersects / ST_Within — spatial predicates — GiST accelerated

#### 21.3.2 Replication & HA
- 21.3.2.1 Streaming replication — WAL shipped via replication protocol — hot standby
  - 21.3.2.1.1 synchronous_standby_names — wait for N standbys — synchronous_commit levels
  - 21.3.2.1.2 Replication slots — prevent WAL removal until replica consumes — slot lag risk
- 21.3.2.2 Logical replication — publish/subscribe — table-level — cross-version migration
  - 21.3.2.2.1 Publication — CREATE PUBLICATION — specify tables or ALL TABLES
  - 21.3.2.2.2 Subscription — CREATE SUBSCRIPTION — connects to publisher — initial copy + stream
- 21.3.2.3 Patroni — HA framework — Etcd/Consul/ZooKeeper — leader election + auto-failover
  - 21.3.2.3.1 DCS (distributed config store) — consensus — leader lease — split-brain prevention
  - 21.3.2.3.2 HAProxy — route writes to leader — reads to replicas — Patroni REST API
