# Databases Complete Study Guide - Part 7: Graph, Time-Series, Search & Vector Databases

## 12.0 Graph Databases

### 12.1 Graph Models
#### 12.1.1 Property Graph Model
- 12.1.1.1 Nodes — entities — labels — key-value properties
  - 12.1.1.1.1 Label — type tag — (:Person) (:Product) — multiple labels per node
  - 12.1.1.1.2 Properties — arbitrary key-value — string/int/boolean/date — per node
- 12.1.1.2 Edges — relationships — directed — typed — key-value properties
  - 12.1.1.2.1 Direction matters — (a)-[:FOLLOWS]->(b) ≠ (b)-[:FOLLOWS]->(a)
  - 12.1.1.2.2 Relationship properties — weight / since / strength — enrich traversal
- 12.1.1.3 Cypher query language — pattern matching — (n:Person)-[:KNOWS]->(m:Person)
  - 12.1.1.3.1 MATCH — find pattern — variable binding — graph pattern
  - 12.1.1.3.2 WHERE — filter on properties — in pattern or separate clause
  - 12.1.1.3.3 WITH — pipeline — aggregate + filter between clauses
  - 12.1.1.3.4 MERGE — create if not exists — ON CREATE / ON MATCH — upsert

#### 12.1.2 RDF & SPARQL
- 12.1.2.1 Triple — subject + predicate + object — everything is a URI or literal
  - 12.1.2.1.1 Blank nodes — anonymous resources — local identifiers — no global URI
- 12.1.2.2 SPARQL — SELECT + WHERE { triple patterns } — graph query language
  - 12.1.2.2.1 OPTIONAL — left outer join — missing triples → null binding
  - 12.1.2.2.2 UNION — combine patterns — flexible matching
  - 12.1.2.2.3 Named graphs — quads (subject, predicate, object, graph) — provenance

### 12.2 Graph Traversal Algorithms
#### 12.2.1 Path Finding
- 12.2.1.1 Breadth-First Search (BFS) — shortest path (unweighted) — queue-based
  - 12.2.1.1.1 Bi-directional BFS — meet in middle — faster for long paths
- 12.2.1.2 Dijkstra — shortest path (weighted) — priority queue — O((V+E) log V)
  - 12.2.1.2.1 A* — heuristic-guided Dijkstra — spatial graphs — faster in practice
- 12.2.1.3 Cypher shortest path — shortestPath() / allShortestPaths() — built-in

#### 12.2.2 Graph Analytics
- 12.2.2.1 PageRank — node importance — iterative — converge on authority scores
  - 12.2.2.1.1 Damping factor — 0.85 — probability of following link vs. random jump
- 12.2.2.2 Community detection — Louvain algorithm — maximize modularity — clusters
- 12.2.2.3 Centrality — betweenness (bridges) / closeness / degree — node importance
- 12.2.2.4 Label propagation — semi-supervised — spread labels across edges — fast

### 12.3 Graph Storage Internals
#### 12.3.1 Native Graph Storage
- 12.3.1.1 Fixed-size node record — stores first relationship + property pointer
  - 12.3.1.1.1 Constant-time adjacency traversal — follow pointer — O(1) per hop
  - 12.3.1.1.2 Neo4j native storage — node → relationship chain → property chain
- 12.3.1.2 Relationship records — doubly-linked lists — per node — source + target chains
  - 12.3.1.2.1 Dense nodes — separate relationship group store — avoid long chain scan

---

## 13.0 Time-Series Databases

### 13.1 Time-Series Data Model
#### 13.1.1 Data Characteristics
- 13.1.1.1 Immutable append-only — measurements at timestamps — rarely updated
  - 13.1.1.1.1 Monotonically increasing time — writes always at "now" — hot window
  - 13.1.1.1.2 High write throughput — millions of points per second — batch insert
- 13.1.1.2 Tag-based model — metric name + tags (labels) + fields + timestamp
  - 13.1.1.2.1 Tags — indexed dimensions — series identification — low cardinality
  - 13.1.1.2.2 Fields — measured values — not indexed — float/int/bool/string
  - 13.1.1.2.3 High cardinality tags — unique host per metric → millions of series — OOM risk

#### 13.1.2 Compression
- 13.1.2.1 Gorilla compression (Facebook) — XOR delta + leading/trailing zero encoding
  - 13.1.2.1.1 First value stored raw — subsequent = XOR with previous — exploit similarity
  - 13.1.2.1.2 12x compression typical — float values — IoT + metrics use case
- 13.1.2.2 Timestamp compression — delta-of-delta — regular intervals compress to near 0
  - 13.1.2.2.1 Variable-length encoding — small delta = few bits — large = more bits

### 13.2 Retention & Downsampling
#### 13.2.1 Retention Policies
- 13.2.1.1 Auto-expire old data — configurable per measurement / bucket — no manual delete
  - 13.2.1.1.1 Shard groups — data divided by time range — drop whole shard — efficient
- 13.2.1.2 Continuous queries — auto-aggregate — 1s → 1m → 1h → 1d — tiered retention
  - 13.2.1.2.1 Mean/max/min aggregation — downsample raw → summary — preserve trends

---

## 14.0 Search Engines

### 14.1 Inverted Index Internals (Lucene)
#### 14.1.1 Lucene Segment Architecture
- 14.1.1.1 Segment — immutable index unit — own inverted index + stored fields + doc values
  - 14.1.1.1.1 Immutability — never modified — new writes = new segments — merge later
  - 14.1.1.1.2 Segment merge — Tiered merge policy — reduce segment count — improve read
- 14.1.1.2 In-memory buffer — accumulate docs — flush to segment — configurable size
  - 14.1.1.2.1 Refresh — make buffered docs searchable — new segment — near-real-time
  - 14.1.1.2.2 Flush — write segment to disk — durability — WAL in ES/OpenSearch

#### 14.1.2 Index Components
- 14.1.2.1 Term dictionary — sorted terms — FST (Finite State Transducer) — compact
  - 14.1.2.1.1 FST — maps term → (docFreq, posting offset) — in-memory — fast lookup
- 14.1.2.2 Posting list — doc IDs — with positions + offsets — phrase queries need positions
  - 14.1.2.2.1 Frame of reference (FOR) — block compression — 128 doc IDs per block
  - 14.1.2.2.2 SIMD bitpacking — accelerated decode — vectorized intersection
- 14.1.2.3 Doc values — columnar stored fields — sorting + aggregations + scripting
  - 14.1.2.3.1 Separate from inverted index — column-oriented — compression per field

### 14.2 Relevance Scoring
#### 14.2.1 TF-IDF
- 14.2.1.1 TF (Term Frequency) — how often term appears in doc — higher = more relevant
- 14.2.1.2 IDF (Inverse Document Frequency) — how rare term is — log(N/df) — weighs rarity
  - 14.2.1.2.1 Common words — low IDF — "the", "and" — near zero weight
  - 14.2.1.2.2 Rare technical terms — high IDF — distinguish documents effectively

#### 14.2.2 BM25 (Best Match 25)
- 14.2.2.1 Improved TF-IDF — document length normalization — term saturation
  - 14.2.2.1.1 k1 parameter — term frequency saturation — default 1.2 — diminishing returns
  - 14.2.2.1.2 b parameter — length normalization — 0.75 default — penalizes long docs
  - 14.2.2.1.3 Elasticsearch default scorer — BM25 since v5.0 — better than TF-IDF

---

## 15.0 Vector Databases

### 15.1 Vector Embeddings & Similarity
#### 15.1.1 Embedding Models
- 15.1.1.1 Dense vectors — float32 arrays — 384 to 3072 dimensions — semantic meaning
  - 15.1.1.1.1 Cosine similarity — angle between vectors — normalize first — range [-1,1]
  - 15.1.1.1.2 Dot product — cosine × magnitude — biased toward large vectors — unnormalized
  - 15.1.1.1.3 Euclidean distance (L2) — geometric distance — image + audio embeddings

#### 15.1.2 ANN Algorithms
- 15.1.2.1 Brute-force exact NN — O(N×D) — small datasets only — ground truth baseline
- 15.1.2.2 HNSW — best recall vs. speed tradeoff — graph-based — memory-intensive
- 15.1.2.3 IVF-PQ — disk-friendly — quantization loss — billion-scale — Faiss
- 15.1.2.4 DiskANN — SSD-based ANN — graph index — billion vectors on single machine
  - 15.1.2.4.1 Beam search — explore multiple paths — vamana graph — quality/speed tradeoff

### 15.2 Hybrid Search
#### 15.2.1 Combining Semantic + Keyword
- 15.2.1.1 Reciprocal rank fusion (RRF) — merge ranked lists — 1/(k+rank) — no tuning
  - 15.2.1.1.1 k=60 default — reduces impact of top ranks — robust fusion
- 15.2.1.2 Weighted combination — α×vector_score + (1-α)×bm25_score — tunable
  - 15.2.1.2.1 Re-ranking — cross-encoder — expensive — top K results only — quality
- 15.2.1.3 Metadata filtering — pre-filter or post-filter — reduce candidate set
  - 15.2.1.3.1 Pre-filter then ANN — fewer candidates — index degradation risk if too few
  - 15.2.1.3.2 Post-filter — ANN then filter — may not return K results — pad with extras
