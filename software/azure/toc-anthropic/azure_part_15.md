# Azure Complete Study Guide - Part 15: Phase 2 — Azure ML, Azure OpenAI, AI Search

## 32.0 Azure Machine Learning (AML)

### 32.1 AML Core
→ See Ideal §11.1 Model Training, §11.2 Feature Stores, §11.3 Endpoints, §11.4 MLOps

#### 32.1.1 AML-Unique Features
- **Unique: Prompt Flow** — LLM app development — DAG-based — built into AML workspace
  - 32.1.1.1 Flow types — Standard (DAG), Chat (interactive), Evaluation (scoring)
  - 32.1.1.2 Connections — Azure OpenAI, Cognitive Search, custom — credential mgmt
  - 32.1.1.3 Variants — test different prompts/models — compare side-by-side
  - 32.1.1.4 Deploy as AML endpoint — Prompt Flow → managed online endpoint
- **Unique: Azure ML CLI v2** — YAML jobs — declarative — full MLOps pipeline
  - 32.1.1.5 az ml job create -f job.yml — repeatable — Git-friendly
  - 32.1.1.6 Component-based pipelines — reusable YAML steps — input/output ports
- **Unique: Serverless compute** — no cluster pre-create — pick VM SKU per job
  - 32.1.1.7 No idle billing — compute provisioned just for job duration
  - 32.1.1.8 Spot VMs available — managed spot — 70–90% savings with checkpoint
- **Unique: Responsible AI dashboard** — fairness, explainability, error analysis, causal
  - 32.1.1.9 Error Analysis — decision tree error slices — find underperforming cohorts
  - 32.1.1.10 SHAP + LIME integrated — global + local explanations — HTML report
- **Unique: Data labeling projects** — built-in labeling UI — ML-assisted labeling
  - 32.1.1.11 Export to COCO/CSV/JSONL — direct to training dataset
- **Unique: Azure ML Registries** — cross-workspace sharing — models/environments/data assets
  - 32.1.1.12 Dev → Staging → Prod promotion — registry as artifact store
- **Unique: Managed feature store** — integrated with AML workspace
  - 32.1.1.13 Feature sets — define features + source — materialization to Redis / offline store
  - 32.1.1.14 Point-in-time retrieval — training set joins — no leakage guarantee

---

## 33.0 Azure OpenAI Service

### 33.1 Azure OpenAI Core
→ See Ideal §11.2 Foundation Models / LLMs

#### 33.1.1 Azure OpenAI-Unique Features
- **Unique: Enterprise compliance** — data stays in your Azure region — no training on data
  - 33.1.1.1 Private endpoints — no public internet — VNet-only access
  - 33.1.1.2 HIPAA BAA eligible — SOC 2 Type 2 — FedRAMP High (Government)
- **Unique: Provisioned Throughput Units (PTU)** — reserved model capacity
  - 33.1.1.3 Consistent latency — not subject to noisy-neighbor — predictable SLA
  - 33.1.1.4 PTU billing — hourly — minimum 1 PTU-hour — commitment or PayG
  - 33.1.1.5 Global PTU — route across regions — higher utilization efficiency
- **Unique: On Your Data (RAG integration)**
  - 33.1.1.6 Direct integration — Azure AI Search, Blob, Cosmos DB, SQL — no code
  - 33.1.1.7 Role-based access — filter search results by user's Entra permissions
  - 33.1.1.8 Citation format — [doc1][doc2] — grounding reference in response
- **Unique: Azure OpenAI on your data — streaming + non-streaming**
  - 33.1.1.9 Hybrid search — BM25 + vector on AI Search — best retrieval quality
- **Unique: Fine-tuning on Azure**
  - 33.1.1.10 Models — GPT-4o, GPT-4o mini, GPT-3.5-turbo — JSONL training format
  - 33.1.1.11 Custom fine-tune stays in your subscription — no sharing to OpenAI
  - 33.1.1.12 Continuous fine-tuning — checkpoint from previous run — incremental updates
- **Unique: Batch deployment** — 50% cheaper — async — 24hr SLA
  - 33.1.1.13 JSONL input in Blob — output in Blob — cost-effective bulk processing
- **Unique: Content Filters + Groundedness Detection**
  - 33.1.1.14 Groundedness — detect hallucination vs. source context — score 1–5
  - 33.1.1.15 Protected material detection — copyright text, code detection
  - 33.1.1.16 Prompt Shield — jailbreak + indirect prompt injection detection
- **Unique: Model quota management** — tokens-per-minute per deployment
  - 33.1.1.17 Dynamic quota — request increase for PTU — portal approval flow

---

## 34.0 Azure AI Search

### 34.1 AI Search Core
→ See Ideal §11.3 Azure AI Search

#### 34.1.1 AI Search-Unique Features
- **Unique: Integrated vectorization** — auto-embed during indexing — no external pipeline
  - 34.1.1.1 Vectorizer — Azure OpenAI or AI Studio embedding model — inline at query
  - 34.1.1.2 Text split skill + embedding skill + index projection — end-to-end pipeline
- **Unique: Semantic Ranker** — Microsoft's cross-encoder — top 50 results re-ranked
  - 34.1.1.3 Semantic captions — extract key passages — highlighted answer
  - 34.1.1.4 Semantic answers — direct question answer if found in document
- **Unique: AI enrichment (skillsets)** — built-in cognitive skills — OCR, NER, translation
  - 34.1.1.5 Built-in skills — 30+ — image analysis, key phrase, language detect, merge
  - 34.1.1.6 Custom skills — Azure Function or container — AML model scoring
  - 34.1.1.7 Knowledge store — project enriched content to Blob/Table — reuse enrichments
- **Unique: Debug sessions** — inspect skillset execution — view enrichment tree per doc
  - 34.1.1.8 Edit-and-replay — fix skill inline — test without re-running full indexer
- **Unique: Index aliases** — point alias to index — hot-swap on rebuild — zero downtime
  - 34.1.1.9 Build new index → validate → flip alias → delete old — no downtime
- **Unique: Score profiles** — field boosting + distance function — tune relevance
  - 34.1.1.10 freshness function — boost recent documents — date field decay
  - 34.1.1.11 magnitude function — boost by numeric field — price/rating boost
- **Unique: Semantic hybrid search pattern**
  - 34.1.1.12 Vector query + keyword query + semantic reranker — 3-stage pipeline
  - 34.1.1.13 RRF fusion weight — l parameter — balance vector vs. keyword score
- **Unique: Security trimming** — filter by user identity at query time
  - 34.1.1.14 OData filter — groups field in index — Entra token groups claim → filter
