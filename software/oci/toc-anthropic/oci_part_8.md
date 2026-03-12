# OCI Complete Study Guide - Part 8: Phase 1 — Analytics & Machine Learning

## 8.0 Analytics & Machine Learning

### 8.1 Data Flow (Managed Apache Spark)
#### 8.1.1 Data Flow Architecture
- 8.1.1.1 Managed Spark — serverless — no cluster management — job-based billing
  - 8.1.1.1.1 Run — submit PySpark/Spark SQL/Java/Scala — OCI-managed infrastructure
  - 8.1.1.1.2 Spark version — 3.x — managed upgrades — no patching required
- 8.1.1.2 Application — reusable definition — JAR/Python script in Object Storage
  - 8.1.1.2.1 Parameters — dynamic at run time — template substitution
  - 8.1.1.2.2 Logs — driver + executor — written to Object Storage — post-run analysis
- 8.1.1.3 Runs — execution instances — status: ACCEPTED → IN_PROGRESS → SUCCEEDED
  - 8.1.1.3.1 Spark UI — available during + after run — execution timeline
  - 8.1.1.3.2 Data Flow Studio — interactive Jupyter + Spark — live session
- 8.1.1.4 Private access — VCN-attached run — access private DB/Streaming — no internet
  - 8.1.1.4.1 Metastore integration — Data Catalog Hive Metastore — shared table defs
- 8.1.1.5 Cost model — per OCPU + GB-hr — driver + executor separately billed
  - 8.1.1.5.1 Spot (Preemptible) executors — cheaper — fault-tolerant jobs only

### 8.2 Data Integration (ETL)
#### 8.2.1 Data Integration Architecture
- 8.2.1.1 Workspace — managed ETL — design + run data pipelines — GUI
  - 8.2.1.1.1 Data assets — connections — Object Storage, ADW, ATP, REST, JDBC
  - 8.2.1.1.2 Data Flow — visual pipeline — source → transform → target
- 8.2.1.2 Tasks — pipeline steps — Integration Task / SQL Task / Data Loader Task
  - 8.2.1.2.1 Data Loader Task — bulk load to ADW — parallel — optimized connector
  - 8.2.1.2.2 Pipeline — orchestrate tasks — parallel branches + dependencies
- 8.2.1.3 Schedules + Task Schedules — cron-based — time zone aware — auto-trigger
  - 8.2.1.3.1 OCI Events integration — trigger on Object Storage create — event-driven

### 8.3 Data Catalog
#### 8.3.1 Data Catalog Architecture
- 8.3.1.1 Metadata catalog — harvest + curate — Object Storage, ADW, ATP, Hive
  - 8.3.1.1.1 Harvest — auto-discover schema + statistics — incremental delta harvest
  - 8.3.1.1.2 Data assets — catalog entries — logical → physical lineage
- 8.3.1.2 Business glossary — terms + categories — tag data entities — governance
  - 8.3.1.2.1 Term — definition + steward + workflow — approval process
  - 8.3.1.2.2 Tag — link term to data entity — sensitivity classification
- 8.3.1.3 Search — full-text + faceted — find datasets by term/owner/type
  - 8.3.1.3.1 Custom properties — extend metadata schema — domain-specific attributes
- 8.3.1.4 Hive Metastore — Data Catalog as Hive Metastore — Data Flow + Dataproc
  - 8.3.1.4.1 Metastore endpoint — JDBC compatible — Spark reads table definitions

### 8.4 OCI AI Services
#### 8.4.1 Vision AI
- 8.4.1.1 Image classification — scene labels — confidence scores — managed API
  - 8.4.1.1.1 Object detection — bounding boxes — confidence > threshold — filter
  - 8.4.1.1.2 Document AI — OCR — layout extraction — table detection
- 8.4.1.2 Custom model — project + dataset — label images — train in OCI
  - 8.4.1.2.1 Dataset — Object Storage images — annotation tool in console
  - 8.4.1.2.2 Model training — AutoML under hood — no ML expertise needed

#### 8.4.2 Language AI
- 8.4.2.1 NLP service — sentiment, key phrase extraction, NER, text classification
  - 8.4.2.1.1 Pre-trained models — production-ready — API call — no training needed
  - 8.4.2.1.2 Custom model — bring labeled text — fine-tune — classification/NER
- 8.4.2.2 Translation — 21 languages — neural MT — bulk document translation
  - 8.4.2.2.1 Custom translation — domain-specific glossary — technical accuracy

#### 8.4.3 Speech AI
- 8.4.3.1 Transcription — batch audio/video → text — multiple languages
  - 8.4.3.1.1 Speaker diarization — who spoke when — meeting transcript use case
  - 8.4.3.1.2 Custom transcription — vocabulary hints — domain terminology accuracy
- 8.4.3.2 Real-time transcription — streaming — WebSocket — low latency

#### 8.4.4 Anomaly Detection
- 8.4.4.1 Time-series anomaly detection — train on normal — detect deviations
  - 8.4.4.1.1 Multivariate — correlate multiple signals — more accurate detection
  - 8.4.4.1.2 Sensitivity — threshold — trade precision vs. recall — business tuning

### 8.5 Generative AI Service
#### 8.5.1 Generative AI Architecture
- 8.5.1.1 OCI Generative AI — managed LLMs — Cohere + Meta Llama — dedicated AI clusters
  - 8.5.1.1.1 Shared cluster — on-demand inference — no reservation — lower cost
  - 8.5.1.1.2 Dedicated AI cluster — private GPU cluster — highest throughput — isolation
- 8.5.1.2 Models — Cohere Command R / R+ — text gen — RAG optimized
  - 8.5.1.2.1 Cohere Embed — text + image embedding — semantic search
  - 8.5.1.2.2 Meta Llama 3.x — open-weight — deploy on dedicated cluster
- 8.5.1.3 Fine-tuning — supervised fine-tuning — JSONL dataset in Object Storage
  - 8.5.1.3.1 T-Few fine-tuning — parameter-efficient — faster + cheaper — few-shot
  - 8.5.1.3.2 Vanilla fine-tuning — full fine-tune — more data — better accuracy
- 8.5.1.4 Playground — console — experiment — compare models — prompt engineering

#### 8.5.2 Generative AI Agents
- 8.5.2.1 AI Agent — RAG pipeline — knowledge base → retrieve → generate
  - 8.5.2.1.1 Knowledge base — Object Storage documents — auto-chunk + embed + index
  - 8.5.2.1.2 Vector store — OCI-managed — OpenSearch under hood — semantic search
  - 8.5.2.1.3 Hybrid search — semantic + lexical — improve retrieval recall
- 8.5.2.2 Agent tools — function calling — structured output — OCI Functions backend
  - 8.5.2.2.1 Tool definition — JSON schema — model selects tool — invoke function

### 8.6 Big Data Service
#### 8.6.1 Big Data Service Architecture
- 8.6.1.1 Managed Hadoop — Cloudera CDH — OCI-managed — cluster on BM/VM
  - 8.6.1.1.1 Master + utility + worker nodes — separate roles — HA Namenode
  - 8.6.1.1.2 ODH (Oracle Distribution of Hadoop) — curated stack — Spark + Hive + Ranger
- 8.6.1.2 Auto-scaling — worker nodes — CPU + queue depth — cost-aware
  - 8.6.1.2.1 Scale out — add worker nodes — HDFS rebalance — automatic
- 8.6.1.3 Object Storage connector — replace HDFS — oci-hdfs-connector — spark.hadoop.*
  - 8.6.1.3.1 Data residency in Object Storage — ephemeral compute — elastic workers
