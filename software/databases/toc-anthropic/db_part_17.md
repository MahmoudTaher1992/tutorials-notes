# Databases Complete Study Guide - Part 17: Snowflake, BigQuery & Redshift

## 33.0 Cloud Data Warehouses

### 33.1 Snowflake
#### 33.1.1 Architecture
- 33.1.1.1 Three-layer architecture — cloud storage (S3/GCS/ADLS) + query processing + services
  - 33.1.1.1.1 Micro-partitions — 50–500MB compressed columnar files — immutable — auto-clustered
  - 33.1.1.1.2 Metadata layer — partition pruning — min/max per column per micro-partition
  - 33.1.1.1.3 Virtual warehouse — compute cluster — independent — different size per workload
- 33.1.1.2 Multi-cluster virtual warehouses — auto-scale out — concurrency scaling — peak load
  - 33.1.1.2.1 Credit-based billing — per-second compute — suspend when idle — cost control
  - 33.1.1.2.2 Query result cache — 24h — identical query — no compute — global across users

#### 33.1.2 Storage & Optimization
- 33.1.2.1 Automatic clustering — Snowflake maintains natural sort order — no manual partitioning
  - 33.1.2.1.1 Cluster key — explicit clustering on high-cardinality column — fine-grained pruning
  - 33.1.2.1.2 Overlap coefficient — measure of clustering quality — lower = better pruning
- 33.1.2.2 Zero-copy cloning — clone tables/schemas/databases — instant — metadata-only
  - 33.1.2.2.1 Shared micro-partitions — clone shares underlying data — COW on modification
  - 33.1.2.2.2 Dev/test environments — clone prod instantly — no storage cost — zero-copy
- 33.1.2.3 Time Travel — query historical data — up to 90 days — BEFORE/AT clause
  - 33.1.2.3.1 Undrop table — recover accidentally dropped objects — within retention period
  - 33.1.2.3.2 Fail-safe — 7-day recovery by Snowflake support — beyond Time Travel — DR
- 33.1.2.4 External tables — query S3/GCS directly — Parquet/ORC — no data ingestion needed
  - 33.1.2.4.1 Iceberg tables — open table format — shared with Spark/Flink — interoperability

#### 33.1.3 Semi-Structured Data
- 33.1.3.1 VARIANT type — store JSON/Avro/XML — columnar encoding — ELT without schema
  - 33.1.3.1.1 Dot notation + bracket notation — variant:field.nested[0] — path extraction
  - 33.1.3.1.2 FLATTEN — lateral join on array — unnest JSON arrays — tabular output
- 33.1.3.2 Schema on read — VARIANT loaded raw — queried with path expressions — no DDL upfront
  - 33.1.3.2.1 Column projection — Snowflake extracts common VARIANT paths — partial columnarize

---

### 33.2 BigQuery
#### 33.2.1 Architecture
- 33.2.1.1 Dremel execution engine — distributed execution tree — root → intermediates → leaves
  - 33.2.1.1.1 Leaf servers — storage workers — read Capacitor columnar files — no local state
  - 33.2.1.1.2 Mixers — aggregation nodes — partial results combined — tree reduction
- 33.2.1.2 Colossus storage — Google distributed FS — columnar Capacitor format — automatic
  - 33.2.1.2.1 Automatic partitioning — by ingestion time or partition column — no manual design
  - 33.2.1.2.2 Automatic clustering — up to 4 columns — sorted within partitions — pruning
- 33.2.1.3 Serverless — no cluster management — slot-based compute — on-demand or reserved
  - 33.2.1.3.1 Flex slots — purchase for 60s — burst capacity — BigQuery reservations API

#### 33.2.2 BigQuery ML & Features
- 33.2.2.1 BQML — CREATE MODEL in SQL — train + predict without export — managed ML
  - 33.2.2.1.1 Model types — linear/logistic regression, k-means, ARIMA, XGBoost, DNN, LLM
  - 33.2.2.1.2 ML.PREDICT — score new data — join with training model — in-place inference
- 33.2.2.2 Omni — BigQuery on AWS/Azure — cross-cloud query — federated analytics
  - 33.2.2.2.1 External tables on S3 — query without data movement — cross-cloud joins

---

### 33.3 Redshift
#### 33.3.1 Architecture
- 33.3.1.1 Leader node + compute nodes — MPP — column-oriented — proprietary Redshift RA3
  - 33.3.1.1.1 RA3 nodes — managed storage — decouple compute/storage — S3 offload
  - 33.3.1.1.2 Redshift Spectrum — query S3 via external tables — push down to Spectrum layer
- 33.3.1.2 Distribution styles — KEY / EVEN / ALL / AUTO — co-locate join tables
  - 33.3.1.2.1 KEY distribution — hash on dist key — same key on same node — collocated join
  - 33.3.1.2.2 ALL — small dimension tables — replicate to all nodes — broadcast join free
  - 33.3.1.2.3 EVEN — round-robin — no preferred join — use for tables with no join key
- 33.3.1.3 Sort keys — interleaved / compound — data sorted on disk — zone maps prune blocks
  - 33.3.1.3.1 Compound sort key — leftmost prefix — range scan on leading column — efficient
  - 33.3.1.3.2 Interleaved sort key — equal weight per column — flexible but maintenance heavy
- 33.3.1.4 VACUUM — reclaim space — re-sort unsorted region — ANALYZE update stats
  - 33.3.1.4.1 Auto VACUUM — Redshift 1.0.8692+ — runs automatically — reduce manual ops
