# GCP Complete Study Guide - Part 14: Phase 2 — BigQuery, Dataflow, Dataproc, Cloud Composer

## 31.0 BigQuery

### 31.1 BigQuery Core
→ See Ideal §10.1 BigQuery Architecture, §10.1.1 Slot Model, §10.1.2 Advanced Features

#### 31.1.1 BigQuery-Unique Features
- **Unique: Dremel engine** — query tree — leaf servers read Capacitor — mixers aggregate
  - 31.1.1.1 Slot = virtual CPU — buy or share — on-demand vs. edition capacity
  - 31.1.1.2 Editions — Standard/Enterprise/Enterprise Plus — autoscale baseline + burst
  - 31.1.1.3 Reservation + Assignment — project-level slot assignment — workload isolation
- **Unique: BigQuery Omni** — query AWS S3 + Azure Blob — BQ engine runs in partner cloud
  - 31.1.1.4 Cross-cloud join — BQ on GCP + BQ Omni result — multi-cloud analytics
  - 31.1.1.5 No data movement — compute goes to data — egress cost avoided
- **Unique: BigLake** — unified table format — GCS + BQ + Spark — CMEK + column security
  - 31.1.1.6 BigLake table — GCS-backed — column-level policy tags — row-level filters
  - 31.1.1.7 Open formats — Parquet/ORC/Iceberg — interoperable with Spark/Flink
- **Unique: BigQuery ML (BQML)** — CREATE MODEL in SQL — no Python needed
  - 31.1.1.8 Supported models — linear/logistic/boosted tree/DNN/ARIMA+ — SQL only
  - 31.1.1.9 Remote model — Vertex AI endpoint — ML_PREDICT() from BQ SQL
- **Unique: Continuous queries** — streaming SQL — output to Pub/Sub/Bigtable — real-time
  - 31.1.1.10 Trigger interval — seconds — aggregate streaming data — SQL window functions
- **Unique: Vector search** — VECTOR_SEARCH() function — HNSW/flat index — embedding
  - 31.1.1.11 CREATE VECTOR INDEX — approximate nearest neighbor — semantic search
  - 31.1.1.12 Hybrid search — combine BM25 text + vector — improve retrieval quality
- **Unique: Change Data Capture** — UPSERT + DELETE — row mutation type — merge target
  - 31.1.1.13 CDC target — clustered table — ordered merge — near-real-time sync

---

## 32.0 Dataflow

### 32.1 Dataflow Core
→ See Ideal §10.2 Dataflow Architecture, §10.2.1 Beam Programming Model

#### 32.1.1 Dataflow-Unique Features
- **Unique: Dataflow Shuffle Service** — managed off-VM shuffle — eliminate OOM — scale
  - 32.1.1.1 Batch shuffle — parallel sort — off-VM — workers scale independently
  - 32.1.1.2 Streaming Engine — managed state + timers — off-VM — reduce VM memory
- **Unique: Flex Templates** — containerized job template — any dependency — OCI image
  - 32.1.1.3 Launch from GCS — parameterized — CI/CD artifact — versioned templates
  - 32.1.1.4 Custom container — install any Python/Java dep — no init action workaround
- **Unique: Dataflow Prime** — automatic resource tuning — vertical autoscaling — smart optimization
  - 32.1.1.5 Vertical scaling — adjust worker memory — eliminate OOM without code change
  - 32.1.1.6 Auto-tuning — parallelism + batching — Dataflow Prime recommends configs
- **Unique: Dataflow SQL** — SQL-based pipelines — Beam under the hood — Cloud Console UI
  - 32.1.1.7 Pub/Sub → BigQuery — SQL SELECT on streaming data — visual pipeline
- **Unique: Runner V2 (Unified Worker)** — single binary — Beam + Dataflow native — faster
  - 32.1.1.8 Streaming at-least-once or exactly-once — configurable — performance tradeoff

---

## 33.0 Dataproc

### 33.1 Dataproc Core
→ See Ideal §10.3 Dataproc Architecture

#### 33.1.1 Dataproc-Unique Features
- **Unique: Ephemeral cluster pattern** — GCS-backed data — spin up / submit / delete
  - 33.1.1.1 Cluster creation < 90 seconds — GCS as HDFS replacement — no data on nodes
  - 33.1.1.2 Preemptible secondary workers — Spot VMs — batch-safe — 80% cost reduction
- **Unique: Dataproc Serverless (Spark)** — no cluster — submit PySpark/Spark SQL batch/session
  - 33.1.1.3 Batch workload — auto-provisioned — per-DPU billing — no cluster management
  - 33.1.1.4 Interactive sessions — Jupyter notebook — serverless compute — on-demand
  - 33.1.1.5 Persistent history server — view Spark UI after cluster deleted — shared
- **Unique: Dataproc Metastore** — serverless Hive Metastore — shared across clusters
  - 33.1.1.6 Multiple clusters + Dataflow + BigQuery — single metadata source — federation
  - 33.1.1.7 Export/import metadata — Avro — migration from self-managed Hive
- **Unique: Dataproc on GKE** — Spark on GKE — shared cluster — multi-tenant workloads
  - 33.1.1.8 Virtual cluster — logical Dataproc cluster on GKE — bin-pack with other pods
  - 33.1.1.9 GKE Autopilot compatible — no node management for Spark jobs
- **Unique: Initialization actions** — custom scripts at cluster start — install deps
  - 33.1.1.10 Baked images — custom Dataproc images — avoid init action latency

---

## 34.0 Cloud Composer

### 34.1 Cloud Composer Core
→ See Ideal §10.4 Cloud Composer Architecture

#### 34.1.1 Cloud Composer-Unique Features
- **Unique: Managed Apache Airflow** — GKE-based — private IP — auto-scaled workers
  - 34.1.1.1 Composer 2 — auto-scale workers 0→N — KubernetesExecutor — cost-efficient
  - 34.1.1.2 Composer 3 — isolated DAG runs — per-DAG compute boundary — preview
- **Unique: GCS-backed DAG storage** — put .py file in bucket → instant deploy
  - 34.1.1.3 PyPI packages — environment update — snapshot applied to all workers
  - 34.1.1.4 Airflow variables + connections — stored in Cloud Composer env — IAM-protected
- **Unique: Native GCP operators** — BigQueryOperator, DataflowTemplateOperator, etc.
  - 34.1.1.5 KubernetesPodOperator — run arbitrary Docker container — maximum flexibility
  - 34.1.1.6 DataprocCreateClusterOperator — full ephemeral cluster lifecycle in Airflow
- **Unique: Private IP environment** — Composer VPC — no public endpoints — PSC option
  - 34.1.1.7 VPC peering to Composer — DAGs access on-prem — Shared VPC support
  - 34.1.1.8 Web server access control — authorized networks — restrict UI access
- **Unique: Airflow DAG best practices on GCP**
  - 34.1.1.9 DAG versioning — Git source — Cloud Build trigger — auto-sync to GCS bucket
  - 34.1.1.10 Monitoring — Composer environment metrics — Airflow task duration in Monarch
