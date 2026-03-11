# AWS Complete Study Guide - Part 15: Phase 2 — Redshift/Athena/Glue, SageMaker/Bedrock

## 31.0 Amazon Redshift

### 31.1 Redshift Core
→ See Ideal §10.1 Data Warehousing, §10.1.1 Architecture, §10.1.2 Distribution & Sort Keys

#### 31.1.1 Redshift-Unique Features
- **Unique: Redshift Spectrum** — query S3 data lake — no load required
  - 31.1.1.1 External tables in Glue/Hive Catalog — partitioned Parquet
  - 31.1.1.2 Pushdown filtering — Redshift optimizer sends predicates to Spectrum
  - 31.1.1.3 $5/TB scanned — separate from Redshift node billing
- **Unique: AQUA (Advanced Query Accelerator)** — ra3 nodes — hardware cache in AZs
  - 31.1.1.4 FPGA-based predicate evaluation — offload CPU-intensive scans
  - 31.1.1.5 Transparent — no query change — automatic routing
- **Unique: Materialized Views with auto-refresh**
  - 31.1.1.6 Incremental refresh — only changed data recomputed
  - 31.1.1.7 AUTO REFRESH — background refresh on base table change
- **Unique: Data Sharing** — live cross-cluster/cross-account query — no data copy
  - 31.1.1.8 Datashare — producer creates, consumer queries read-only
  - 31.1.1.9 ADX data sharing — publish to AWS Data Exchange marketplace
- **Unique: Redshift ML** — CREATE MODEL SQL — SageMaker AutoPilot under hood
  - 31.1.1.10 PREDICT function — inference in SQL — no export required
- **Unique: Streaming Ingestion** — Kinesis Data Streams → Redshift — sub-second latency
  - 31.1.1.11 Materialized view over stream — micro-batch auto refresh
  - 31.1.1.12 No S3 staging — direct ingest — reduce copy latency

---

## 32.0 Amazon Athena & AWS Glue

### 32.1 Athena Core
→ See Ideal §10.6 Query Engines, §10.6.1 Architecture

#### 32.1.1 Athena-Unique Features
- **Unique: Iceberg table support** — ACID, schema evolution, time-travel in S3
  - 32.1.1.1 CREATE TABLE ... TBLPROPERTIES ('table_type'='ICEBERG')
  - 32.1.1.2 INSERT OVERWRITE PARTITION → merge operations via MERGE INTO
  - 32.1.1.3 Snapshot time-travel — SELECT ... AS OF TIMESTAMP
- **Unique: Athena for Spark** — interactive PySpark — Jupyter-compatible
  - 32.1.1.4 Spark sessions — auto-scaled — pay per DPU-hour
  - 32.1.1.5 Athena Notebooks — collaborative — S3-backed
- **Unique: Federated Query** — Lambda connectors — query any JDBC source
  - 32.1.1.6 Spill bucket — large intermediate results to S3 — automatic
  - 32.1.1.7 Available connectors — RDS, DynamoDB, CloudWatch, DocumentDB, Redis
- **Unique: Query result reuse** — identical query+data → cached up to 7 days
  - 32.1.1.8 Zero cost for reused results — significant savings for dashboards
- **Unique: EXPLAIN / EXPLAIN ANALYZE** — Trino execution plan — optimization insights

### 32.2 AWS Glue Core
→ See Ideal §10.2 ETL/ELT, §10.2.1 Glue Components

#### 32.2.1 Glue-Unique Features
- **Unique: Glue DataBrew** — visual no-code data preparation — 250+ transforms
  - 32.2.1.1 Profiling — data quality stats — missing values, distributions
  - 32.2.1.2 Recipes — shareable transform pipelines — apply to new datasets
- **Unique: Glue Data Quality** — DQ rules — DQDL language — pass/fail thresholds
  - 32.2.1.3 Anomaly detection — ML-based rule suggestions
  - 32.2.1.4 Publishing to CloudWatch — trend tracking of data quality metrics
- **Unique: Glue Schema Registry** — Avro/JSON/Protobuf schema management
  - 32.2.1.5 Schema versioning — compatibility modes — backward/forward/full
  - 32.2.1.6 Kafka + Kinesis integration — serialize/deserialize with schema validation
- **Unique: Glue Flex execution class** — 34% cheaper — uses spare capacity — non-urgent jobs
  - 32.2.1.7 Not SLA-backed — may take longer — batch/backfill jobs
- **Unique: Glue Iceberg write support** — native Iceberg sink — compaction built-in

---

## 33.0 Amazon SageMaker

### 33.1 SageMaker Core
→ See Ideal §11.1 Model Training, §11.2 Feature Stores, §11.3 Endpoints, §11.4 MLOps

#### 33.1.1 SageMaker-Unique Features
- **Unique: SageMaker Studio** — unified IDE — JupyterLab-based — domain/user profiles
  - 33.1.1.1 Code Editor — VS Code-compatible — persistent EFS-backed home dir
  - 33.1.1.2 JupyterLab spaces — per-user persistent EFS volumes
  - 33.1.1.3 Canvas — no-code ML — AutoML + pre-built models for non-data-scientists
- **Unique: Managed Spot Training** — up to 90% savings — checkpointing required
  - 33.1.1.4 MaxWaitTimeInSeconds — controls spot budget — max_run + max_wait
  - 33.1.1.5 CheckpointConfig — S3 checkpoint path — auto-resume on interruption
- **Unique: Inference Recommender** — benchmark multiple instance types — cost/perf
  - 33.1.1.6 Default job — 45min — recommend top instances
  - 33.1.1.7 Advanced job — 2hr — custom load tests — p50/p95/p99 latency
- **Unique: SageMaker Clarify** — explainability + bias detection
  - 33.1.1.8 SHAP values — feature importance per prediction
  - 33.1.1.9 Pre-training bias — class imbalance, labeling bias metrics
  - 33.1.1.10 Post-training bias — DPPL, DI, RD, TE metrics
- **Unique: SageMaker Ground Truth** — labeling workforce — Mechanical Turk / private
  - 33.1.1.11 Auto-labeling — train model on labeled subset → auto-label confident items
  - 33.1.1.12 Label job types — bounding box, segmentation, NER, video frame

---

## 34.0 Amazon Bedrock

### 34.1 Bedrock Core
→ See Ideal §11.5 Foundation Models/LLMs, §11.5.1 Architecture, §11.5.2 Customization

#### 34.1.1 Bedrock-Unique Features
- **Unique: Bedrock Inference Profiles** — system-defined cross-region routing
  - 34.1.1.1 Automatic failover across regions — higher availability during peak demand
  - 34.1.1.2 Application inference profiles — custom routing — cost tracking per team
- **Unique: Model Evaluation** — automated + human evaluation
  - 34.1.1.3 Automated metrics — ROUGE, BERTScore, accuracy on labeled datasets
  - 34.1.1.4 Human evaluation — AWS managed workers or bring your own team
- **Unique: Bedrock Flows** — visual workflow builder — prompt chaining
  - 34.1.1.5 Nodes — input, output, prompt, condition, iterator, collector, agent, KB
  - 34.1.1.6 FlowAliasId — versioned — immutable — A/B testing prompt chains
- **Unique: Prompt Management** — centralized prompt library — versions + variants
  - 34.1.1.7 Prompt versioning — test before prod — associate with flow/agent
- **Unique: Model Distillation** — large teacher model → small student model
  - 34.1.1.8 Synthetic data generation — teacher labels your corpus
  - 34.1.1.9 Lower cost, lower latency — 95% quality at 50% cost
- **Unique: Marketplace Models** — 100+ partner models — Stability AI, Llama, Mistral
  - 34.1.1.10 Subscribe → invoke via Bedrock API — same interface as first-party models
- **Unique: Bedrock Data Automation** — multimodal document processing
  - 34.1.1.11 PDF/image/video/audio → structured JSON — no code ML pipeline
  - 34.1.1.12 Standard output schema — consistent across document types
