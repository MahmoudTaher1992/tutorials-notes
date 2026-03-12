# Azure Complete Study Guide - Part 8: Data Analytics & Machine Learning (Phase 1 — Ideal)

## 10.0 Data Analytics & Big Data

### 10.1 Azure Synapse Analytics
#### 10.1.1 Synapse Architecture
- 10.1.1.1 Unified analytics — SQL + Spark + Pipelines + KQL — single workspace
  - 10.1.1.1.1 Synapse Studio — web IDE — notebooks, SQL scripts, pipelines, monitoring
  - 10.1.1.1.2 Managed VNet — isolated workspace — private endpoints to all sources
- 10.1.1.2 Dedicated SQL Pool (formerly SQL DW) — MPP — DistributionS × 60 nodes
  - 10.1.1.2.1 DWU (Data Warehouse Units) — DW100c to DW30000c — compute scale
  - 10.1.1.2.2 Pause/resume — billing stops — storage retained — dev/test pattern
  - 10.1.1.2.3 Distribution types — HASH, ROUND_ROBIN, REPLICATE — same as Redshift
- 10.1.1.3 Serverless SQL Pool — query parquet/CSV/JSON/Delta on ADLS Gen2 — pay per TB
  - 10.1.1.3.1 External tables — CREATE EXTERNAL TABLE — Parquet format optimal
  - 10.1.1.3.2 OPENROWSET — ad-hoc query — no external table needed
- 10.1.1.4 Spark Pools — auto-pause — node family + size — Synapse Spark runtime
  - 10.1.1.4.1 Package management — conda/pip — workspace packages — cached
  - 10.1.1.4.2 Spark Connect — thin client — IDE-to-Spark directly

#### 10.1.2 Synapse Link
- 10.1.2.1 Zero-ETL analytical store — Cosmos DB → Synapse Spark/SQL — no RU cost
  - 10.1.2.1.1 Columnar analytical store — decoupled from transactional row store
  - 10.1.2.1.2 Auto sync — new writes propagated — no ETL pipeline
- 10.1.2.2 Synapse Link for SQL Server 2022 / Azure SQL — CDC-based replication
  - 10.1.2.2.1 Landing zone — ADLS Gen2 parquet — then Synapse queries

### 10.2 Azure Data Factory (ETL/ELT)
#### 10.2.1 ADF Architecture
- 10.2.1.1 Integration Runtime (IR) — compute executing activities
  - 10.2.1.1.1 Azure IR — serverless — auto-scale — multi-region
  - 10.2.1.1.2 Self-hosted IR (SHIR) — on-prem or other cloud — private data access
  - 10.2.1.1.3 Azure-SSIS IR — lift SSIS packages to cloud — SSIS catalog (SSISDB)
- 10.2.1.2 Pipelines → Activities → Datasets → Linked Services
  - 10.2.1.2.1 90+ connectors — databases, SaaS, file systems, streaming
  - 10.2.1.2.2 Dataflows (mapping) — code-free Spark transformation — visual ETL

#### 10.2.2 ADF Advanced Features
- 10.2.2.1 Triggers — schedule, tumbling window, storage event, custom event
  - 10.2.2.1.1 Tumbling window — time-ordered — backfill with dependency chaining
- 10.2.2.2 Parameterization — pipeline + linked service + dataset parameters — reuse
- 10.2.2.3 Git integration — ADF Studio → GitHub/ADO — PR-based CI/CD
- 10.2.2.4 Managed airflow — Apache Airflow environment — bring own DAGs

### 10.3 Azure Databricks
#### 10.3.1 Databricks Architecture
- 10.3.1.1 Control plane (Databricks-managed) + Data plane (customer Azure subscription)
  - 10.3.1.1.1 NPIP (No Public IP) — secure cluster — all traffic via private endpoints
  - 10.3.1.1.2 VNet injection — Databricks VMs in customer VNet — private DNS
- 10.3.1.2 Cluster types — All-Purpose (interactive) vs. Job (automated) vs. SQL Warehouse
  - 10.3.1.2.1 Cluster policies — governance — limit SKUs, auto-terminate
  - 10.3.1.2.2 Instance pools — pre-provisioned VMs — eliminate startup latency
- 10.3.1.3 DBU (Databricks Unit) — per node per hour — light/standard/premium

#### 10.3.2 Delta Lake on Databricks
- 10.3.2.1 Delta format — Parquet + transaction log — ACID on data lake
  - 10.3.2.1.1 Delta log — JSON commit entries — append-only — time travel source
  - 10.3.2.1.2 Optimize + Z-ORDER — compact small files — co-locate related data
  - 10.3.2.1.3 Auto Optimize — autoOptimize.optimizeWrite + autoCompact — default on
- 10.3.2.2 Delta Live Tables (DLT) — declarative pipeline — streaming + batch unified
  - 10.3.2.2.1 Expectations — data quality constraints — warn/drop/fail
  - 10.3.2.2.2 Enhanced autoscaling — DLT-managed — stream-aware scaling
- 10.3.2.3 Unity Catalog — enterprise governance — fine-grained access on Delta tables
  - 10.3.2.3.1 3-level namespace — catalog.schema.table — cross-workspace sharing
  - 10.3.2.3.2 Column masking + row filtering — dynamic views — per-identity

### 10.4 Azure Stream Analytics
#### 10.4.1 Stream Analytics Jobs
- 10.4.1.1 SQL-like SAQL — windowing — tumbling, hopping, sliding, session, snapshot
  - 10.4.1.1.1 Tumbling window — non-overlapping fixed intervals — COUNT(*) per 5 min
  - 10.4.1.1.2 Hopping window — overlapping — emit every 1m over 5m window
  - 10.4.1.1.3 Session window — inactivity gap-based — variable length per entity
- 10.4.1.2 Streaming units (SU) — compute allocation — 1/3/6/12/... SU tiers
  - 10.4.1.2.1 6 SU = 1 node — parallelize beyond 6SU by partition key

#### 10.4.2 Stream Analytics Sources & Sinks
- 10.4.2.1 Inputs — Event Hub, IoT Hub, Blob Storage (reference data)
- 10.4.2.2 Outputs — Event Hub, Service Bus, Blob, ADLS, SQL DB, Cosmos DB, Power BI
- 10.4.2.3 Reference data — Blob or SQL DB — join streaming with static lookup data

### 10.5 Azure Data Lake Storage Gen2 (ADLS Gen2)
#### 10.5.1 ADLS Gen2 Architecture
- 10.5.1.1 Hierarchical Namespace (HNS) — true directories — atomic rename/delete
  - 10.5.1.1.1 HNS enabled at account creation — cannot be toggled later
  - 10.5.1.1.2 POSIX ACLs — file + directory level — user/group/other + mask
- 10.5.1.2 Multi-protocol access — Blob API + ADFS API — dual namespace
  - 10.5.1.2.1 NFS 3.0 mount — direct Linux mount — HPC use case
- 10.5.1.3 Zone-redundant storage — ZRS + HNS — recommended for analytics
  - 10.5.1.3.1 Lifecycle management — Hot → Cool → Archive — same as Blob

---

## 11.0 Machine Learning & AI

### 11.1 Azure Machine Learning (AML)
#### 11.1.1 AML Workspace Architecture
- 11.1.1.1 Workspace — top-level container — linked to storage, KV, ACR, App Insights
  - 11.1.1.1.1 Hub workspace — shared infrastructure — child project workspaces
  - 11.1.1.1.2 Managed network isolation — outbound rules — private endpoint to all
- 11.1.1.2 Compute targets — Compute Instance (dev), Compute Cluster (training), Serverless
  - 11.1.1.2.1 Compute Instance — JupyterLab + VS Code — auto-shutdown policy
  - 11.1.1.2.2 Serverless compute — no cluster management — job-level VM selection

#### 11.1.2 AML Training
- 11.1.2.1 Jobs — Command, Sweep, Pipeline, Spark, AutoML job types
  - 11.1.2.1.1 Command job — script + environment + compute — MLflow autolog
  - 11.1.2.1.2 Sweep job — hyperparameter tuning — Bayesian/Grid/Random — early termination
- 11.1.2.2 Environments — Docker image + conda/pip — versioned + cached in ACR
  - 11.1.2.2.1 Curated environments — pre-built — PyTorch, TensorFlow, sklearn
- 11.1.2.3 Distributed training — PyTorch DistributedDataParallel — MPI — DeepSpeed
  - 11.1.2.3.1 process_count_per_instance — nccl backend — GPU-to-GPU InfiniBand

#### 11.1.3 AML MLOps
- 11.1.3.1 Pipelines — DAG of components — reuse + cache — schedule triggers
  - 11.1.3.1.1 Components — reusable YAML-defined steps — input/output ports
  - 11.1.3.1.2 Pipeline schedule — cron or after data asset change
- 11.1.3.2 Model Registry — versioned — tags + properties — stage transitions
  - 11.1.3.2.1 Model lineage — trace to dataset + job — reproducibility
- 11.1.3.3 Prompt Flow — LLM app development — DAG-based — evaluation built-in
  - 11.1.3.3.1 Flow types — standard, chat, evaluation — test + trace + deploy
  - 11.1.3.3.2 Connections — Azure OpenAI, Cognitive Search, custom — credential store

### 11.2 Azure OpenAI Service
#### 11.2.1 Azure OpenAI Architecture
- 11.2.1.1 Models — GPT-4o/4o-mini, o1/o3, DALL-E 3, Whisper, text-embedding-3
  - 11.2.1.1.1 Deployment — named deployment — maps to model version
  - 11.2.1.1.2 Provisioned throughput units (PTU) — reserved capacity — consistent latency
- 11.2.1.2 Token-based billing — input + output tokens — prompt caching discounts
  - 11.2.1.2.1 Cached tokens — 50% discount — same system prompt reuse
  - 11.2.1.2.2 Batch API — 50% cheaper — async — 24hr completion window

#### 11.2.2 Azure OpenAI Features
- 11.2.2.1 On Your Data — RAG — Azure AI Search + Blob + Cosmos source
  - 11.2.2.1.1 System message injection — context from retrieved chunks
  - 11.2.2.1.2 Citations — source grounding — reduce hallucination
- 11.2.2.2 Assistants API — stateful — threads + messages + runs + tools
  - 11.2.2.2.1 Code interpreter — sandboxed Python — file I/O in container
  - 11.2.2.2.2 File Search — vector store — chunking + embedding built-in
- 11.2.2.3 Content Safety integration — input + output filtering — category thresholds
  - 11.2.2.3.1 Hate, violence, sexual, self-harm — Low/Medium/High filtering
- 11.2.2.4 Real-time audio API — GPT-4o Realtime — voice-to-voice — WebSocket

### 11.3 Azure AI Search
#### 11.3.1 AI Search Architecture
- 11.3.1.1 Full-text + vector + hybrid search — Lucene-based + HNSW index
  - 11.3.1.1.1 Hybrid search — keyword (BM25) + vector — RRF (Reciprocal Rank Fusion) merge
  - 11.3.1.1.2 Semantic reranking — cross-encoder — top N results re-ranked by meaning
- 11.3.1.2 Indexers — pull from SQL, Cosmos, Blob, ADLS, SharePoint — incremental
  - 11.3.1.2.1 Change detection — high watermark or soft delete — efficient refresh
  - 11.3.1.2.2 Skillsets — AI enrichment — OCR, entity extraction, key phrases
- 11.3.1.3 HNSW parameters — m (connections), efConstruction, efSearch — recall vs. speed
  - 11.3.1.3.1 Oversampling — retrieve 5x candidates → re-rank to final k
  - 11.3.1.3.2 Exhaustive KNN — smaller indices — brute force — highest recall
