# Databases Complete Study Guide - Part 15: Elasticsearch & Vector Databases

## 30.0 Elasticsearch / OpenSearch

### 30.1 Cluster Architecture
#### 30.1.1 Node Roles
- 30.1.1.1 Master-eligible node — cluster state management — shard allocation — settings
  - 30.1.1.1.1 Dedicated master — 3 nodes — Raft-based election — no data — stability
  - 30.1.1.1.2 Split-brain prevention — discovery.zen.minimum_master_nodes = (N/2)+1 — old
  - 30.1.1.1.3 cluster.initial_master_nodes — ES 7+ bootstrapping — one-time setting
- 30.1.1.2 Data nodes — store shards — execute search + indexing — CPU + memory + I/O
  - 30.1.1.2.1 Hot-warm-cold architecture — hot: NVMe — warm: HDD — cold: S3 — ILM tiers
  - 30.1.1.2.2 Frozen tier — fully searchable S3 — cached on demand — lowest cost
- 30.1.1.3 Coordinating node — route requests — scatter-gather — reduce phase — stateless
  - 30.1.1.3.1 Dedicated coordinating — off-load routing from data nodes — large clusters

#### 30.1.2 Shard Management
- 30.1.1.1 Primary + replica shards — write to primary — replicate to replica — read from both
  - 30.1.1.1.1 number_of_shards — set at index creation — immutable — plan ahead
  - 30.1.1.1.2 number_of_replicas — change at runtime — 1 replica = 1 copy = 2 total
- 30.1.1.2 Shard allocation — master assigns shards to nodes — awareness rules
  - 30.1.1.2.1 cluster.routing.allocation.awareness.attributes — AZ-aware placement
  - 30.1.1.2.2 Exclude node from allocation — for decommission — migrate shards away

### 30.2 Indexing & Search
#### 30.2.1 Mapping
- 30.2.1.1 Dynamic mapping — auto-detect field types — convenient — use with caution
  - 30.2.1.1.1 Mapping explosion — too many dynamic fields — performance degradation — cap with
  - 30.2.1.1.2 index.mapping.total_fields.limit — default 1000 — prevent explosion
- 30.2.1.2 Explicit mapping — define types upfront — keyword vs text — sub-fields
  - 30.2.1.2.1 keyword — exact match — aggregation — sorting — not analyzed
  - 30.2.1.2.2 text — full-text analyzed — posting list — BM25 scoring — not for aggregation
  - 30.2.1.2.3 Multi-field — title.keyword + title (text) — both exact + analyzed — common

#### 30.2.2 Query DSL
- 30.2.2.1 Query context — affects score — match / multi_match / query_string — BM25
  - 30.2.2.1.1 match — analyzed — tokenized — standard search — phrase match with slop
  - 30.2.2.1.2 multi_match — search across fields — boost per field — cross_fields type
- 30.2.2.2 Filter context — no scoring — cached — term / range / exists / bool.filter
  - 30.2.2.2.1 Filter bitset cache — cached per segment — reused across queries — fast
  - 30.2.2.2.2 bool query — must + should + must_not + filter — combine contexts
- 30.2.2.3 Aggregations — metrics + bucket + pipeline — faceted search + analytics
  - 30.2.2.3.1 Terms agg — top N buckets — doc_count — facets — cardinality limit
  - 30.2.2.3.2 date_histogram — time-series aggregation — calendar_interval — UTC offset
  - 30.2.2.3.3 Pipeline aggs — derivative / moving_avg / cumulative_sum — on bucket results

### 30.3 Index Lifecycle Management (ILM)
#### 30.3.1 ILM Phases
- 30.3.1.1 Hot → warm → cold → frozen → delete — time/size/doc triggers — automate rollover
  - 30.3.1.1.1 Rollover — new index when size/age/docs exceeds threshold — alias continues
  - 30.3.1.1.2 Shrink — reduce shard count — fewer nodes — warm phase — read-only required
  - 30.3.1.1.3 Force merge — merge to 1 segment — read-only — max compression + speed

---

## 31.0 Vector Databases (Dedicated)

### 31.1 Pinecone
#### 31.1.1 Serverless Architecture
- 31.1.1.1 Managed HNSW — serverless — auto-scale — no infrastructure management
  - 31.1.1.1.1 Namespaces — logical partitions — isolate tenants — shared index
  - 31.1.1.1.2 Metadata filtering — key-value filters — pre-filter or in-graph — combined with ANN
- 31.1.1.2 Sparse-dense hybrid — sparse BM25 + dense vectors — single index — hybrid search
  - 31.1.1.2.1 alpha weighting — weight dense vs. sparse — tune per use case

### 31.2 Weaviate
#### 31.2.1 GraphQL + Vector
- 31.2.1.1 Schema-based — classes + properties — typed — CRUD + vector search in one API
  - 31.2.1.1.1 Vectorizer modules — text2vec-openai / cohere / huggingface — auto-embed on insert
  - 31.2.1.1.2 nearText — semantic search by concept — nearVector — raw vector — combined
- 31.2.1.2 HNSW index — per class — ef / efConstruction / maxConnections — tunable
  - 31.2.1.2.1 Dynamic ef — auto-adjust ef at query time — recall/speed tradeoff — adaptive

### 31.3 Qdrant
#### 31.3.1 Architecture
- 31.3.1.1 Written in Rust — high performance — low memory footprint — production-ready
  - 31.3.1.1.1 Collections — named vector space — on-disk index — mmap support — large scale
  - 31.3.1.1.2 Payload — JSON metadata — filterable — indexed for fast pre-filtering
- 31.3.1.2 HNSW on disk — quantization — binary / scalar / product quantization — memory tradeoffs
  - 31.3.1.2.1 Rescore — retrieve with quantized index → rescore top N with original — quality
  - 31.3.1.2.2 Named vectors — multiple vector fields per record — multi-modal search
