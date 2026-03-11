# AWS Complete Study Guide - Part 8: Data Analytics & Machine Learning (Phase 1 — Ideal)

## 10.0 Data Analytics & Big Data

### 10.1 Data Warehousing (Redshift)
#### 10.1.1 Redshift Architecture
- 10.1.1.1 Leader node — query planning, SQL parsing, compile — single node
  - 10.1.1.1.1 Query optimizer — cost-based — statistics via ANALYZE command
  - 10.1.1.1.2 Result caching — identical query — sub-second repeat execution
- 10.1.1.2 Compute nodes — parallel query execution — slices per node
  - 10.1.1.2.1 RA3 nodes — managed storage — S3-backed — scale storage independently
  - 10.1.1.2.2 dc2 nodes — SSD local storage — fixed storage/compute ratio
- 10.1.1.3 AQUA (Advanced Query Accelerator) — hardware-based cache — push-down predicates

#### 10.1.2 Redshift Distribution & Sort Keys
- 10.1.2.1 Distribution styles — EVEN, KEY, ALL, AUTO
  - 10.1.2.1.1 KEY distribution — co-locate join columns — minimize data movement
  - 10.1.2.1.2 ALL distribution — small dimension tables — broadcast copy
- 10.1.2.2 Sort keys — compound vs. interleaved
  - 10.1.2.2.1 Compound sort key — best for range filters + ORDER BY on leading columns
  - 10.1.2.2.2 Interleaved sort key — equal weighting — multiple filter columns
  - 10.1.2.2.3 Zone map pruning — skip 1MB blocks — 200x faster selective queries
- 10.1.2.3 Column encoding — AZ64, LZO, Zstandard — ANALYZE COMPRESSION

#### 10.1.3 Redshift Serverless
- 10.1.3.1 RPU (Redshift Processing Units) — auto-scale 8–512 RPUs
  - 10.1.3.1.1 Base capacity — minimum RPU for first 60s after idle
  - 10.1.3.1.2 Max RPU — cost cap — queries queue if cap reached

### 10.2 ETL/ELT Pipelines (AWS Glue)
#### 10.2.1 Glue Components
- 10.2.1.1 Glue Data Catalog — central metadata store — Hive-compatible
  - 10.2.1.1.1 Crawlers — detect schema — S3/RDS/DynamoDB/JDBC
  - 10.2.1.1.2 Table versions — schema evolution history — JSON stored in S3
- 10.2.1.2 Glue ETL Jobs — PySpark or Scala — DPU-based billing
  - 10.2.1.2.1 Glue DynamicFrame vs. Spark DataFrame — schema flexibility
  - 10.2.1.2.2 Job bookmarks — track processed data — incremental processing
  - 10.2.1.2.3 Pushdown predicates — filter at S3 source — reduce data scanned

#### 10.2.2 Glue Streaming
- 10.2.2.1 Micro-batch processing — Kinesis Data Streams or Kafka as source
  - 10.2.2.1.1 Checkpoint interval — save position — recover from failure
  - 10.2.2.1.2 Sliding/tumbling/session windows — time-based aggregation

### 10.3 Stream Processing
#### 10.3.1 Kinesis Data Firehose
- 10.3.1.1 Managed delivery — Kinesis/MSK → S3/Redshift/OpenSearch/HTTP
  - 10.3.1.1.1 Buffer size (1–128MB) and buffer interval (60–900s) — whichever first
  - 10.3.1.1.2 Dynamic partitioning — inline Lambda → partition by field value
  - 10.3.1.1.3 Format conversion — JSON → Parquet/ORC using Glue schema

#### 10.3.2 Amazon MSK (Managed Streaming for Kafka)
- 10.3.2.1 Kafka cluster — broker nodes — configurable retention, partitions
  - 10.3.2.1.1 MSK Serverless — auto-scales — per-partition-hour billing
  - 10.3.2.1.2 MSK Connect — Kafka Connect managed — Debezium CDC connector
- 10.3.2.2 Consumer group lag — CloudWatch metric — trigger Lambda scaling

### 10.4 Batch Processing (EMR)
#### 10.4.1 EMR Architecture
- 10.4.1.1 Master node → Core nodes (HDFS) → Task nodes (compute-only)
  - 10.4.1.1.1 Core node spot — data loss risk if interrupted — use On-Demand
  - 10.4.1.1.2 Task node spot — compute only — safe to interrupt
- 10.4.1.2 Frameworks — Spark, Hive, HBase, Flink, Presto, Trino
  - 10.4.1.2.1 EMR on EKS — submit Spark jobs to EKS cluster — no dedicated nodes
  - 10.4.1.2.2 EMR Serverless — no cluster management — auto-provisions workers

#### 10.4.2 Spark on EMR Optimization
- 10.4.2.1 EMRFS — S3-backed Hadoop filesystem — consistent view via DynamoDB
  - 10.4.2.1.1 EMRFS S3-optimized committer — replace FileOutputCommitter
- 10.4.2.2 Spark executor tuning — cores/memory/instances trade-off
  - 10.4.2.2.1 Dynamic allocation — scale executors based on work queue depth

### 10.5 Data Lake (Lake Formation)
#### 10.5.1 Lake Formation Architecture
- 10.5.1.1 Fine-grained access control — row/column-level — on top of Glue Catalog
  - 10.5.1.1.1 LF-tags — attribute-based — scale permissions without table rewrites
  - 10.5.1.1.2 Data filters — row filter + column mask — per-principal
- 10.5.1.2 Governed Tables — ACID transactions on S3 — Iceberg-backed
  - 10.5.1.2.1 Automatic compaction — small file problem — background optimization

### 10.6 Query Engines (Athena)
#### 10.6.1 Athena Architecture
- 10.6.1.1 Presto/Trino-based — serverless — scan S3, Glue Catalog tables
  - 10.6.1.1.1 Per-query billing — $5/TB scanned — partitioning critical for cost
  - 10.6.1.1.2 Columnar formats — Parquet/ORC — 70-90% cost reduction vs. JSON
- 10.6.1.2 Workgroups — query isolation — cost limits, result bucket, encryption
  - 10.6.1.2.1 Per-query data scanned limit — auto-cancel runaway queries
- 10.6.1.3 Federated query — Lambda-backed connectors — query RDS/DynamoDB/Redis
  - 10.6.1.3.1 Spill to S3 — large intermediate results — configurable spill threshold
- 10.6.1.4 Athena for Apache Spark — interactive PySpark notebooks — Jupyter API

---

## 11.0 Machine Learning & AI

### 11.1 Model Training (SageMaker)
#### 11.1.1 Training Job Architecture
- 11.1.1.1 Training containers — bring-your-own or managed framework images
  - 11.1.1.1.1 SageMaker Distributed Training — model parallel + data parallel
  - 11.1.1.1.2 SageMaker Model Parallel Library — partition large model across GPUs
- 11.1.1.2 Input channels — S3/EFS/FSx for Lustre — Pipe mode vs. File mode
  - 11.1.1.2.1 Pipe mode — stream S3 data directly — avoid full download
  - 11.1.1.2.2 FSx for Lustre — sub-ms latency — GPU-bound training workloads
- 11.1.1.3 Spot training — up to 90% cost savings — checkpoint required
  - 11.1.1.3.1 Managed spot training — automatic checkpoint on interruption
  - 11.1.1.3.2 Max wait time vs. max runtime — control spot interruption tolerance

#### 11.1.2 Hyperparameter Optimization (HPO)
- 11.1.2.1 Bayesian optimization — prior → posterior → next trial — efficient search
  - 11.1.2.1.1 Warm start HPO — use previous trials — faster convergence
- 11.1.2.2 Automatic Model Tuning — parallel jobs — concurrent trial limit

### 11.2 Feature Stores (SageMaker Feature Store)
#### 11.2.1 Feature Store Architecture
- 11.2.1.1 Online store — low-latency — DynamoDB-backed — real-time inference
  - 11.2.1.1.1 TTL on records — expire stale features automatically
- 11.2.1.2 Offline store — historical — S3/Glue Catalog — batch training
  - 11.2.1.2.1 Time-travel query — point-in-time correct features — avoid leakage
  - 11.2.1.2.2 Iceberg table format — efficient time-travel — compaction built-in

### 11.3 Model Serving & Endpoints
#### 11.3.1 Endpoint Types
- 11.3.1.1 Real-time endpoint — persistent — auto-scaling — dedicated instances
  - 11.3.1.1.1 Multi-model endpoint (MME) — share GPU — hundreds of models
  - 11.3.1.1.2 Multi-container endpoint — pipeline inference — chained models
- 11.3.1.2 Serverless Inference — burst traffic — pay-per-invocation
  - 11.3.1.2.1 Cold start 1–2s — provisioned concurrency option
  - 11.3.1.2.2 Max payload 4MB, max latency 60s
- 11.3.1.3 Async Inference — large payloads/long processing — S3 input/output
  - 11.3.1.3.1 Notification via SNS on completion
- 11.3.1.4 Batch Transform — process full dataset — no persistent endpoint cost

#### 11.3.2 Inference Optimization
- 11.3.2.1 SageMaker Neo — cross-platform model compile — 2–10x faster inference
  - 11.3.2.1.1 TFLite/TVM backend — quantization + graph optimization
- 11.3.2.2 Elastic Inference — GPU fraction attachment — 75% cost reduction
- 11.3.2.3 Model Monitor — detect data/concept drift — CloudWatch integration
  - 11.3.2.3.1 Baseline statistics — SUGGEST_BASELINE from training data
  - 11.3.2.3.2 Constraint violations — p-value threshold — trigger alert

### 11.4 MLOps Pipelines (SageMaker Pipelines)
#### 11.4.1 Pipeline Components
- 11.4.1.1 Step types — Processing, Training, Transform, Register, Condition, Lambda
  - 11.4.1.1.1 Condition step — branch on metric threshold — auto-approve to registry
  - 11.4.1.1.2 Pipeline parameters — runtime overrides — reuse without re-authoring
- 11.4.1.2 Model Registry — versioning — approval workflow — staging/production

### 11.5 Foundation Models / LLMs (Amazon Bedrock)
#### 11.5.1 Bedrock Architecture
- 11.5.1.1 Fully managed — no infrastructure — model APIs via single endpoint
  - 11.5.1.1.1 Model providers — Anthropic (Claude), Meta (Llama), Mistral, AI21, Cohere
  - 11.5.1.1.2 Bedrock Marketplace — subscribe to third-party models
- 11.5.1.2 Invocation API — InvokeModel vs. InvokeModelWithResponseStream
  - 11.5.1.2.1 Streaming response — reduce perceived latency — token-by-token
  - 11.5.1.2.2 Converse API — provider-agnostic — tool use, vision, system prompts

#### 11.5.2 Bedrock Customization
- 11.5.2.1 Fine-tuning — labeled examples — model adapts to domain/style
  - 11.5.2.1.1 JSONL format — prompt/completion pairs — S3 input
  - 11.5.2.1.2 Continued pre-training — unlabeled corpus — domain adaptation
- 11.5.2.2 Knowledge Bases — RAG — embeddings in vector store (OpenSearch/Aurora)
  - 11.5.2.2.1 Chunking strategies — fixed size, semantic, hierarchical
  - 11.5.2.2.2 Hybrid search — keyword + vector — weighted fusion
- 11.5.2.3 Guardrails — content filtering — topic denial — PII redaction
  - 11.5.2.3.1 Grounding check — hallucination detection — reference text scoring

#### 11.5.3 Bedrock Agents
- 11.5.3.1 ReAct loop — Reasoning + Acting — tool use + knowledge base
  - 11.5.3.1.1 Action groups — Lambda functions — OpenAPI schema definition
  - 11.5.3.1.2 Session memory — multi-turn context — configurable retention
- 11.5.3.2 Inline agents — ephemeral — no pre-creation — dynamic tool injection

### 11.6 Pre-built AI Services
#### 11.6.1 Vision & Language
- 11.6.1.1 Rekognition — object detection, face compare, text in image, moderation
  - 11.6.1.1.1 Streaming video analysis — Kinesis Video Streams integration
- 11.6.1.2 Transcribe — STT — speaker diarization, custom vocabulary, PII redaction
- 11.6.1.3 Polly — TTS — neural voices — SSML — real-time + batch synthesis
- 11.6.1.4 Comprehend — NLP — entity, sentiment, key phrase, PII, topic modeling
- 11.6.1.5 Translate — 75+ languages — custom terminology — Active Custom Translation
