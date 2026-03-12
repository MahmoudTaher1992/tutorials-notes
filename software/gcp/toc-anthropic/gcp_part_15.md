# GCP Complete Study Guide - Part 15: Phase 2 — Vertex AI, Gemini API, Agent Builder

## 35.0 Vertex AI

### 35.1 Vertex AI Core
→ See Ideal §11.1 Vertex AI Architecture, §11.1.2 Model Garden, §11.2 Feature Store, §11.3 Pipelines

#### 35.1.1 Vertex AI-Unique Features
- **Unique: Vertex AI Workbench** — managed JupyterLab — persistent disk — GPU attach
  - 35.1.1.1 User-managed instances — full root access — custom image — max flexibility
  - 35.1.1.2 Managed instances — auto-upgrade — idle shutdown — cost-controlled
- **Unique: Colab Enterprise** — managed Colab runtime — BigQuery + Vertex AI native
  - 35.1.1.3 Runtime templates — GPU type + disk — shareable — team standard config
  - 35.1.1.4 Direct BQ query in Colab — %%bigquery magic — no SDK setup required
- **Unique: AutoML** — structured data / image / text / video — no code training
  - 35.1.1.5 Tabular AutoML — classification/regression/forecasting — NAS under hood
  - 35.1.1.6 Training budget — node-hours — early stop — cost cap
- **Unique: Vertex AI Experiments** — MLflow-compatible — track params/metrics/artifacts
  - 35.1.1.7 Tensorboard — managed — GCS backend — compare across experiments
  - 35.1.1.8 Vertex AI SDK — log metrics inline — no separate tracking server
- **Unique: Model Registry** — versioned models — aliases — lineage tracking
  - 35.1.1.9 Aliases — champion/challenger/production — deploy by alias not version ID
  - 35.1.1.10 Model evaluation — sliced metrics — bias detection — pre-deploy gate
- **Unique: Vertex AI Endpoints** — online prediction — traffic split — dedicated GPU
  - 35.1.1.11 Traffic split — A/B model test — 90/10 split — canary model rollout
  - 35.1.1.12 Dedicated endpoint — single model — lower cold start — raw GPU allocation
- **Unique: Feature Store (New)** — Feature Group + Feature Online Store — Bigtable backend
  - 35.1.1.13 Feature Group — BigQuery source — offline features — batch materialized
  - 35.1.1.14 Online serving — low-latency reads — Bigtable/Optimized backend — ms latency
  - 35.1.1.15 Point-in-time retrieval — training dataset — no label leakage
- **Unique: Vertex AI Pipelines (KFP v2)** — managed Kubeflow Pipelines — GCS artifact store
  - 35.1.1.16 GCPC components — prebuilt Vertex wrappers — training + deploy in one pipeline
  - 35.1.1.17 Compiled to YAML — version-controlled — reproducible ML workflows
- **Unique: Model Monitoring** — feature skew + prediction drift — auto alert
  - 35.1.1.18 Training-serving skew — compare training distribution vs. live requests
  - 35.1.1.19 Prediction drift — output distribution shift — trigger retraining alert

---

## 36.0 Gemini API on Vertex AI

### 36.1 Gemini API Core
→ See Ideal §11.4 Gemini Models, §11.4.1 Vertex AI Gemini API

#### 36.1.1 Gemini API-Unique Features
- **Unique: Gemini 2.5 Pro/Flash** — multimodal — text/image/audio/video/code — 1M+ context
  - 36.1.1.1 Long-context reasoning — 1M token window — multi-document analysis
  - 36.1.1.2 Flash Thinking — extended thinking — visible reasoning trace — complex tasks
  - 36.1.1.3 Multimodal input — inline or GCS URI — video/audio understanding native
- **Unique: Vertex AI Gemini enterprise features** — VPC-SC — audit logs — no training on data
  - 36.1.1.4 Provisioned Throughput — committed QPM — SLA-backed latency
  - 36.1.1.5 Grounding — Google Search — real-time retrieval + inline citations
  - 36.1.1.6 Context caching — cache large system prompts — reduce cost + latency
- **Unique: Tuning** — supervised fine-tuning + RLHF — Vertex AI managed
  - 36.1.1.7 Supervised fine-tuning — JSONL dataset — uploaded to GCS — managed job
  - 36.1.1.8 RLHF — reinforcement learning from human feedback — preference dataset
- **Unique: Gemma open models** — Gemma 2 2B/9B/27B — deploy anywhere — fine-tune
  - 36.1.1.9 Model Garden one-click deploy — Vertex AI endpoint — GPU auto-selected
  - 36.1.1.10 PaliGemma — vision-language — image captioning + VQA — fine-tunable
- **Unique: Imagen** — text-to-image — image editing — product photography — GCP exclusive
  - 36.1.1.11 Imagen 3 — photorealistic — inpainting/outpainting — watermark (SynthID)
  - 36.1.1.12 SynthID — watermark embedded — detect AI-generated images — provenance

---

## 37.0 Vertex AI Agent Builder

### 37.1 Agent Builder Core
→ See Ideal §11.5 Vertex AI Agent Builder Architecture

#### 37.1.1 Agent Builder-Unique Features
- **Unique: Vertex AI Search** — enterprise document search — RAG — one-click setup
  - 37.1.1.1 Data Store — ingest GCS/BigQuery/websites/Cloud SQL — parse + chunk + embed
  - 37.1.1.2 Search app — query → retrieve → augment → generate — fully managed RAG
  - 37.1.1.3 Blended search — semantic + keyword — dynamic ranking — no config needed
- **Unique: Reasoning Engine** — managed agent runtime — LangChain/LlamaIndex/custom
  - 37.1.1.4 Deploy LangChain agent — Vertex-managed container — auto-scale
  - 37.1.1.5 Agent Evaluation — trajectory evaluation — tool call correctness — alignment
  - 37.1.1.6 Persistent session state — multi-turn — managed by Reasoning Engine
- **Unique: Grounding with Google Search** — real-time web retrieval — cited responses
  - 37.1.1.7 Dynamic retrieval — only ground when confidence low — cost optimized
  - 37.1.1.8 Citation metadata — URL + title + snippet — rendered in agent response
- **Unique: Conversation (Dialogflow CX integration)** — multi-turn state + NLU + LLM
  - 37.1.1.9 Generators — inject Gemini into Dialogflow flow — grounded at flow step
  - 37.1.1.10 CCAI Insights — conversation analytics — sentiment + topic — contact center
- **Unique: Model Armor** — safety filters — PII redaction — prompt injection defense
  - 37.1.1.11 Sanitize inputs + outputs — detect jailbreak attempts — enterprise compliance
  - 37.1.1.12 Template-based policies — per use-case safety level — reusable across agents
