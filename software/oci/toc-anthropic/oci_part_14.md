# OCI Complete Study Guide - Part 14: Phase 2 — Analytics & AI

## 18.0 OCI Analytics & AI

### 18.1 Data Flow (Spark)-Unique Features
→ See Ideal §8.1 Data Flow, §8.2 Data Integration, §8.3 Data Catalog

#### 18.1.1 Data Flow-Unique Features
- **Unique: Serverless Spark** — no cluster management — submit → run → auto-terminate
  - 18.1.1.1 No cluster sizing decisions — OCI auto-provisions workers per job
  - 18.1.1.2 Preemptible executors — Spot VM workers — fault-tolerant Spark only
- **Unique: Data Flow Studio** — interactive Spark sessions — Jupyter notebooks — no cluster
  - 18.1.1.3 Session pools — warm sessions — reduce cold start for interactive use
  - 18.1.1.4 Git integration — notebook version control — DevOps pipeline publish
- **Unique: Private endpoint for Data Flow** — VCN-attached run — access private ADW/ATP
  - 18.1.1.5 No internet needed — private Spark run → private ADB — secure analytics
- **Unique: Data Catalog Metastore integration** — Hive Metastore from Data Catalog
  - 18.1.1.6 Spark reads tables from Data Catalog — shared schema — no duplicate defs

#### 18.1.2 Data Integration-Unique Features
- **Unique: Native ADB connector** — bulk load to Autonomous DB — parallel — optimized
  - 18.1.2.1 External tables + DBMS_CLOUD — Data Integration uses internal ADB bulk load
  - 18.1.2.2 Smart partitioning — hash partition source — parallel pipeline branches
- **Unique: Visual pipeline designer** — GUI drag-drop — no code ETL — data lineage
  - 18.1.2.3 Lineage graph — source → transform → target — column-level tracking

#### 18.1.3 Data Catalog-Unique Features
- **Unique: Hive Metastore endpoint** — Data Catalog as Metastore — Data Flow + Big Data
  - 18.1.3.1 Metastore JDBC URL — Spark conf — hive.metastore.uri — shared catalog
  - 18.1.3.2 Auto-harvest OCI resources — Object Storage buckets, ADW schemas — scheduled
- **Unique: Sensitive data discovery** — tag columns with classification — Data Safe bridge
  - 18.1.3.3 PII tagging — propagate from Data Catalog → Data Safe masking policies

### 18.2 OCI AI Services-Unique Features
→ See Ideal §8.4 OCI AI Services, §8.5 Generative AI

#### 18.2.1 Vision AI-Unique Features
- **Unique: Document AI** — OCI-native — layout analysis + OCR + table detection
  - 18.2.1.1 Key-value extraction — invoice/receipt processing — structured output JSON
  - 18.2.1.2 Custom document model — label document types — train in OCI Vision
- **Unique: Image Job (batch)** — Object Storage input → async analysis → results bucket
  - 18.2.1.3 Bulk image processing — thousands of images — no API rate limit concern

#### 18.2.2 Language AI-Unique Features
- **Unique: Custom NLP model** — fine-tune on domain text — text classification + NER
  - 18.2.2.1 Annotated dataset — OCI Data Labeling service — same console workflow
  - 18.2.2.2 Model evaluation — F1/precision/recall — before promotion to endpoint
- **Unique: Healthcare NLP** — clinical NER — ICD-10 codes — medical entity extraction
  - 18.2.2.3 HIPAA-compliant processing — OCI security controls — data residency

#### 18.2.3 Generative AI-Unique Features
- **Unique: Dedicated AI Cluster** — private GPU cluster — no shared tenancy — HIPAA/FedRAMP
  - 18.2.3.1 Cluster commitment — 1/3-year — reserved GPU capacity — predictable cost
  - 18.2.3.2 Fine-tuned model hosted on dedicated cluster — private endpoint — VCN
- **Unique: T-Few fine-tuning** — parameter-efficient — faster + cheaper — few-shot tasks
  - 18.2.3.3 Training dataset in Object Storage — JSONL prompts+completions — < 100 samples
  - 18.2.3.4 Evaluation metric — automated — ROUGE + semantic similarity
- **Unique: OCI Generative AI Agents** — managed RAG — Knowledge Base in Object Storage
  - 18.2.3.5 Vector store — OCI OpenSearch managed — auto-embed on ingest
  - 18.2.3.6 Hybrid retrieval — BM25 + semantic — fused ranking — better recall
  - 18.2.3.7 Agent tools — OCI Functions — structured JSON schema — function calling
- **Unique: Cohere Command R+ native** — retrieval-optimized — RAG-specific fine-tune
  - 18.2.3.8 Citations in response — document sources inline — grounded answers

#### 18.2.4 OCI Data Labeling-Unique Features
- **Unique: Integrated labeling service** — same console — label images/text/documents
  - 18.2.4.1 Annotations exported to Object Storage — JSONL — direct Vision/Language input
  - 18.2.4.2 Bulk labeling — pre-annotate with model predictions — human review only

### 18.3 Analytics Cloud-Unique Features
- **Unique: OAC (Oracle Analytics Cloud)** — managed Oracle Analytics Server — BI + ML
  - 18.3.1.1 Connect to ADW natively — Oracle semantic model — drag-drop dashboards
  - 18.3.1.2 Augmented analytics — ML insights — explain — auto-highlight anomalies
  - 18.3.1.3 Oracle ML Notebooks — Python/SQL — Zeppelin-based — ADB compute
