# Databases Complete Study Guide - Part 14: Neo4j, InfluxDB & TimescaleDB

## 28.0 Neo4j

### 28.1 Storage & Architecture
#### 28.1.1 Native Graph Storage
- 28.1.1.1 Fixed-record store — node/relationship/property stored in fixed-size files
  - 28.1.1.1.1 Node record — 15 bytes — first relationship ID + first property ID + label store
  - 28.1.1.1.2 Relationship record — 34 bytes — start/end node + type + prev/next per node
  - 28.1.1.1.3 Index-free adjacency — traverse via pointer — O(1) per hop — no index needed
- 28.1.1.2 Property store — linked list of property records — supports all primitive types
  - 28.1.1.2.1 Short string optimization — string ≤ 24 bytes inline in property record
  - 28.1.1.2.2 Dynamic property store — large strings/arrays — overflow to dynamic store file

#### 28.1.2 Neo4j Cluster
- 28.1.2.1 Causal cluster — core servers (Raft) + read replicas — read scale
  - 28.1.2.1.1 Core servers — Raft consensus — minimum 3 — writes committed on majority
  - 28.1.2.1.2 Read replicas — async replication — serve reads — no voting — scale-out
- 28.1.2.2 Causal consistency — bookmark — client sends bookmark with read — route to up-to-date
  - 28.1.2.2.1 Bookmark = last committed tx ID — replica catches up before answering — read-own-writes

### 28.2 Cypher Deep Dive
#### 28.2.1 Advanced Cypher
- 28.2.1.1 Variable-length path — (a)-[:KNOWS*1..5]->(b) — up to 5 hops — DFS expansion
  - 28.2.1.1.1 Bidirectional shortestPath() — from both ends — faster for long paths
  - 28.2.1.1.2 allShortestPaths() — all paths of minimum length — may be expensive
- 28.2.1.2 CALL subquery — correlated subquery — per row — inner MATCH per result
  - 28.2.1.2.1 CALL { } IN TRANSACTIONS — batched subquery — import large data — avoid OOM
- 28.2.1.3 GDS (Graph Data Science) library — PageRank / Louvain / Betweenness / Node2Vec
  - 28.2.1.3.1 In-memory graph projection — project subset of graph — run algorithm — write back
  - 28.2.1.3.2 Node2Vec — graph embedding — proximity-preserving vectors — ML features

### 28.3 Indexing in Neo4j
#### 28.3.1 Index Types
- 28.3.1.1 Range index — B-tree — equality + range on property — default index type
  - 28.3.1.1.1 CREATE INDEX FOR (n:Person) ON (n.name) — automatic use in query plan
- 28.3.1.2 Full-text index — Lucene-based — tokenized text search — multiple properties
  - 28.3.1.2.1 CALL db.index.fulltext.queryNodes() — Lucene query syntax — ranked results
- 28.3.1.3 Vector index — 5.11+ — HNSW-based — embeddings on nodes — semantic search
  - 28.3.1.3.1 db.index.vector.queryNodes() — k-nearest neighbors — graph + vector combined

---

## 29.0 InfluxDB & TimescaleDB

### 29.1 InfluxDB
#### 29.1.1 InfluxDB Data Model
- 29.1.1.1 Measurement — tags — fields — timestamp — Line Protocol ingestion
  - 29.1.1.1.1 Line Protocol — measurement,tag_key=val field_key=val timestamp — newline-delimited
  - 29.1.1.1.2 Series cardinality — unique tag set combinations — high cardinality → OOM
- 29.1.1.2 TSM (Time-Structured Merge Tree) — InfluxDB storage — optimized LSM for time-series
  - 29.1.1.2.1 TSM file — sorted by series key + timestamp — block compression per field type
  - 29.1.1.2.2 Cache — in-memory WAL buffer — flushed to TSM on threshold — snappy compressed
  - 29.1.1.2.3 Compaction — level-based — merge TSM files — reduce read amplification

#### 29.1.2 Flux & InfluxQL
- 29.1.2.1 InfluxQL — SQL-like — GROUP BY time(1m) — fill() — moving averages
  - 29.1.2.1.1 Continuous queries — deprecated — replaced by tasks in InfluxDB 2.x
- 29.1.2.2 Flux — functional pipeline — |> operator — filter + aggregate + join
  - 29.1.2.2.1 from(bucket:"metrics") |> range() |> filter() |> aggregateWindow() — pattern
  - 29.1.2.2.2 Tasks — scheduled Flux queries — downsample + alert — native in InfluxDB 2.x
- 29.1.2.3 Retention policies — InfluxDB 1.x — duration per database — auto-drop old data
  - 29.1.2.3.1 InfluxDB 2.x buckets — retention period at bucket level — simpler model

### 29.2 TimescaleDB
#### 29.2.1 Hypertable Architecture
- 29.2.1.1 Hypertable — PostgreSQL table — auto-partitioned into chunks by time (+ space)
  - 29.2.1.1.1 Chunk — 7-day default time interval — own physical table + indexes — prune by time
  - 29.2.1.1.2 Constraint exclusion — query WHERE time > X — planner skips old chunks
- 29.2.1.2 Continuous aggregates — materialized view — REFRESH POLICY — incremental update
  - 29.2.1.2.1 Real-time aggregates — union of materialized + recent raw — transparent
  - 29.2.1.2.2 Hierarchical continuous aggregates — 1m → 1h → 1d — multi-level rollup

#### 29.2.2 Compression & Retention
- 29.2.2.1 Native compression — convert old chunks to columnar — orderby + segmentby
  - 29.2.2.1.1 segmentby column — group rows — dictionary compression per segment
  - 29.2.2.1.2 orderby column — sort within segment — delta + gorilla compression — 90% savings
- 29.2.2.2 Retention policy — add_retention_policy('metrics', INTERVAL '30 days') — auto drop
  - 29.2.2.2.1 Drop chunk = DROP TABLE on chunk file — instant — no vacuum needed
