# GCP Complete Study Guide - Part 8: Data Analytics & Machine Learning (Phase 1 — Ideal)

## 10.0 Data Analytics & Big Data

### 10.1 BigQuery
#### 10.1.1 BigQuery Architecture
- 10.1.1.1 Serverless — Dremel engine — disaggregated storage + compute
  - 10.1.1.1.1 Dremel — distributed query tree — slots = unit of compute
  - 10.1.1.1.2 Capacitor — columnar storage format — GCS under the hood
  - 10.1.1.1.3 Jupiter network — 1Pbps bisection bandwidth — shuffle at petabyte scale
- 10.1.1.2 Slot model — virtual CPU for query execution — flat-rate vs. on-demand
  - 10.1.1.2.1 On-demand — $5/TB scanned — 2000 slots soft limit per project
  - 10.1.1.2.2 Editions — Standard/Enterprise/Enterprise Plus — slot commitment levels
  - 10.1.1.2.3 Slot reservations — assign to projects — workload isolation
- 10.1.1.3 Storage — native tables + external tables + BigLake tables
  - 10.1.1.3.1 Managed storage — GCS Colossus — encrypted — versioned
  - 10.1.1.3.2 Partitioned tables — time-partitioned or range-partitioned — prune on query
  - 10.1.1.3.3 Clustered tables — co-locate rows by column values — block pruning

#### 10.1.2 BigQuery Advanced Features
- 10.1.2.1 BigQuery Omni — query AWS S3 / Azure Blob — BQ engine, no data move
  - 10.1.2.1.1 External connections — aws-us-east-1 / azure-eastus2 — network required
- 10.1.2.2 BigLake — unified storage layer — BigQuery + Spark access — CMEK + policy tags
  - 10.1.2.2.1 BigLake tables — GCS-backed — column-level security via policy tags
  - 10.1.2.2.2 Object tables — unstructured data — blob metadata + AI enrichment
- 10.1.2.3 Change Data Capture — BigQuery CDC — streaming inserts with row-level merge
  - 10.1.2.3.1 Row mutation type — UPSERT + DELETE — target clustered table
- 10.1.2.4 Continuous queries — SQL → Pub/Sub/Bigtable — streaming output
  - 10.1.2.4.1 Trigger interval — seconds to minutes — real-time aggregation
- 10.1.2.5 INFORMATION_SCHEMA — metadata — query history, slot usage, table storage
  - 10.1.2.5.1 JOBS view — past 180-day query history — billing bytes scanned
- 10.1.2.6 BigQuery ML — CREATE MODEL — train in SQL — BQML endpoint deploy
  - 10.1.2.6.1 Model types — linear, logistic, boosted tree, deep neural net, ARIMA+
  - 10.1.2.6.2 Remote models — Vertex AI endpoint — inference from BigQuery SQL
- 10.1.2.7 Vector search — VECTOR_SEARCH() — HNSW/flat index — embedding in BigQuery
  - 10.1.2.7.1 Create index — CREATE VECTOR INDEX — approximate + exact
  - 10.1.2.7.2 Hybrid search — combine BM25 text search + vector search

### 10.2 Dataflow (Apache Beam)
#### 10.2.1 Dataflow Architecture
- 10.2.1.1 Managed Apache Beam — horizontal auto-scale — batch + streaming unified
  - 10.2.1.1.1 Shuffle service — managed — off-VM — reduces OOM in batch jobs
  - 10.2.1.1.2 Streaming Engine — managed — state + timers off-VM — scalable
- 10.2.1.2 Dataflow Flex Templates — containerized — custom image — any dependency
  - 10.2.1.2.1 Launch template from GCS — parameterized — CI/CD-friendly
  - 10.2.1.2.2 Classic templates — JAR-based — legacy — migrate to Flex

#### 10.2.2 Beam Programming Model
- 10.2.2.1 PCollection → PTransform → PCollection — immutable distributed dataset
  - 10.2.2.1.1 ParDo — element-wise — DoFn — most used transform
  - 10.2.2.1.2 GroupByKey — shuffle — aggregate by key — streaming trigger required
- 10.2.2.2 Windowing — Fixed, Sliding, Session, Global — time-based grouping
  - 10.2.2.2.1 Event time vs. processing time — watermark — late data handling
  - 10.2.2.2.2 Triggers — AfterWatermark, AfterProcessingTime, AfterCount
- 10.2.2.3 Stateful processing — DoFn state + timers — per-key state — bag/value/set
  - 10.2.2.3.1 EventTimer — fire at watermark — per-key cleanup + aggregation

### 10.3 Dataproc (Managed Spark/Hadoop)
#### 10.3.1 Dataproc Architecture
- 10.3.1.1 Managed Hadoop ecosystem — Spark, Hive, Flink, Presto, Trino — cluster as cattle
  - 10.3.1.1.1 Ephemeral clusters — create + submit + delete — GCS for data persistence
  - 10.3.1.1.2 Preemptible workers — Spot VMs for task workers — data on GCS
- 10.3.1.2 Dataproc Serverless (Spark) — no cluster management — workload-based billing
  - 10.3.1.2.1 No cluster — submit PySpark/Spark SQL — auto-provision batch workers
  - 10.3.1.2.2 Dataproc Serverless sessions — interactive Jupyter — on-demand compute
- 10.3.1.3 Cluster images — versioned — 2.x — Spark 3.3 + Python 3.10+ support
  - 10.3.1.3.1 Custom images — bake dependencies — avoid init actions latency
  - 10.3.1.3.2 Dataproc Metastore — serverless Hive Metastore — shared across clusters

### 10.4 Cloud Composer (Managed Airflow)
#### 10.4.1 Cloud Composer Architecture
- 10.4.1.1 Managed Apache Airflow — GKE-based — private IP option
  - 10.4.1.1.1 Composer 2 — auto-scale workers — DAG processor — cheaper
  - 10.4.1.1.2 Composer 3 — isolated DAG runs — per-DAG compute — preview
- 10.4.1.2 DAG storage — GCS bucket — Airflow auto-syncs — push DAG = instant deploy
  - 10.4.1.2.1 PyPI packages — environment variables — snapshot + apply
- 10.4.1.3 Operators — GCP-native — BigQueryOperator, DataflowTemplateOperator
  - 10.4.1.3.1 KubernetesPodOperator — run any container — arbitrary tasks

---

## 11.0 Machine Learning & AI

### 11.1 Vertex AI
#### 11.1.1 Vertex AI Architecture
- 11.1.1.1 Unified ML platform — train + deploy + manage — single API surface
  - 11.1.1.1.1 Workbench — managed JupyterLab — persistent disk — GPU support
  - 11.1.1.1.2 Colab Enterprise — Colab + BigQuery + Vertex AI — managed runtime
- 11.1.1.2 Training jobs — custom + AutoML + distributed + HPT
  - 11.1.1.2.1 Custom training — any framework — pre-built or custom container
  - 11.1.1.2.2 Distributed training — MultiWorkerMirroredStrategy — MPI — parameter server
  - 11.1.1.2.3 Reduction server — all-reduce network — gradients via dedicated server
- 11.1.1.3 Vertex AI Experiments — MLflow-compatible — track metrics/params/artifacts
  - 11.1.1.3.1 Tensorboard — managed — Cloud Storage backend — persistent experiments

#### 11.1.2 Vertex AI Model Garden & Deployment
- 11.1.2.1 Model Garden — 200+ OSS models — Llama, Gemma, Mistral — one-click deploy
  - 11.1.2.1.1 Model serve — Vertex AI endpoint — auto-scale — GPU/TPU backing
  - 11.1.2.1.2 Batch predictions — GCS input → GCS output — no endpoint needed
- 11.1.2.2 Vertex AI Endpoints — online serving — dedicated + shared machine types
  - 11.1.2.2.1 Traffic split — A/B testing — canary model updates
  - 11.1.2.2.2 Dedicated endpoint — single model — lower latency — raw compute
- 11.1.2.3 Model monitoring — feature skew + prediction drift — baseline comparison
  - 11.1.2.3.1 Input feature skew — training-serving skew — distribution comparison
  - 11.1.2.3.2 Prediction drift — model output distribution shift — alert threshold

### 11.2 Vertex AI Feature Store
#### 11.2.1 Feature Store Architecture
- 11.2.1.1 Centralized feature management — online + offline — consistency guarantee
  - 11.2.1.1.1 Feature Group — BigQuery table/view — offline source — batch materialized
  - 11.2.1.1.2 Feature Online Store — Bigtable/Optimized — low-latency serving — ms
- 11.2.1.2 Point-in-time retrieval — training dataset generation — no label leakage
  - 11.2.1.2.1 Batch serving — BigQuery job — join entity + feature by timestamp

### 11.3 Vertex AI Pipelines (MLOps)
#### 11.3.1 Pipeline Architecture
- 11.3.1.1 Kubeflow Pipelines v2 + TFX — compiled to YAML — GCS artifact store
  - 11.3.1.1.1 Components — Python function or container — type-annotated I/O
  - 11.3.1.1.2 GCPC (Google Cloud Pipeline Components) — prebuilt — Vertex AI wrappers
- 11.3.1.2 Model Registry — versioned — aliases (champion/challenger) — lineage
  - 11.3.1.2.1 Model evaluation — sliced metrics — compare across versions
  - 11.3.1.2.2 Managed deployment — deploy from registry — promote to production

### 11.4 Gemini API & Vertex AI Gemini
#### 11.4.1 Gemini Models
- 11.4.1.1 Gemini 2.5 Pro/Flash — multimodal — text/image/audio/video/code
  - 11.4.1.1.1 1M+ token context window — long-document reasoning
  - 11.4.1.1.2 Flash Thinking — extended thinking — reasoning trace visible
- 11.4.1.2 Vertex AI Gemini API — enterprise — VPC-SC — audit logs — no data training
  - 11.4.1.2.1 Provisioned throughput — committed QPM — predictable latency
  - 11.4.1.2.2 Grounding — Google Search — real-time web retrieval + citations
- 11.4.1.3 Gemma — open models — Gemma 2 2B/9B/27B — run on-prem or fine-tune
  - 11.4.1.3.1 PaliGemma — vision-language model — image captioning, VQA

### 11.5 Vertex AI Agent Builder
#### 11.5.1 Agent Builder Architecture
- 11.5.1.1 Grounding + RAG — Vertex AI Search — enterprise document search
  - 11.5.1.1.1 Data Store — ingest GCS/BQ/websites — parse + chunk + embed
  - 11.5.1.1.2 Search app — query → retrieve → augment → generate — one-click RAG
- 11.5.1.2 Agent (Reasoning Engine) — Gemini function calling + tools
  - 11.5.1.2.1 LangChain / LlamaIndex / custom agents — deploy to managed runtime
  - 11.5.1.2.2 Agent Evaluation — trajectory evaluation — tool call correctness
- 11.5.1.3 Conversation — Dialogflow CX backend — multi-turn — state management
  - 11.5.1.3.1 Generators — inject LLM into Dialogflow flow — grounded responses
