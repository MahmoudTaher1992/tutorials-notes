# Integration Patterns Complete Study Guide - Part 10: AI Integration Patterns

## 15.0 AI Integration Patterns

### 15.1 Calling AI Models
#### 15.1.1 Model Gateway Pattern
- 15.1.1.1 Centralized proxy in front of LLM APIs — routing / auth / rate limiting / cost tracking
  - 15.1.1.1.1 Multi-provider routing — route to OpenAI / Anthropic / Gemini — fallback on error
  - 15.1.1.1.2 Model versioning — gateway maps logical name → specific model version — decouple
  - 15.1.1.1.3 Cost attribution — tag requests by team/feature — charge-back — budget enforcement
- 15.1.1.2 Request/response logging — capture all prompts + completions — audit / debug / replay
  - 15.1.1.2.1 PII scrubbing before logging — redact sensitive fields — compliance requirement
  - 15.1.1.2.2 Latency + token tracking — P95 latency / prompt tokens / completion tokens — cost
- 15.1.1.3 Semantic caching — cache by embedding similarity — return cached response on similar query
  - 15.1.1.3.1 GPTCache / Redis with pgvector — embed query → ANN lookup → return if similar enough
  - 15.1.1.3.2 Cache TTL — stale responses for dynamic queries — tune by use case

#### 15.1.2 Tool Use / Function Calling
- 15.1.2.1 Model invokes external tools — define tool schema — model returns tool call — app executes
  - 15.1.2.1.1 Tool schema — name + description + JSON Schema parameters — model decides when to call
  - 15.1.2.1.2 Execution loop — model response → parse tool call → execute → append result → re-call
  - 15.1.2.1.3 Parallel tool calls — model requests multiple tools simultaneously — reduce latency
- 15.1.2.2 Tool types — database query / API call / code execution / web search / file read
  - 15.1.2.2.1 Database tool — NL to SQL — query → results → model summarizes — text-to-SQL
  - 15.1.2.2.2 Code interpreter — execute Python — model writes code → run → return output — dynamic
- 15.1.2.3 Tool authorization — confirm high-impact tools — human-in-the-loop gate — confirm before run
  - 15.1.2.3.1 Dangerous tool confirmation — DELETE / charge card / send email — pause for approval
  - 15.1.2.3.2 Sandboxed execution — code runs in isolated container — no host access — security

### 15.2 RAG Pipeline
#### 15.2.1 Retrieval-Augmented Generation
- 15.2.1.1 Indexing pipeline — chunk documents → embed → store in vector DB — offline build
  - 15.2.1.1.1 Chunking strategy — fixed-size / sentence / semantic / document hierarchy — tradeoffs
  - 15.2.1.1.2 Chunk overlap — N tokens overlap between chunks — preserve context at boundaries
  - 15.2.1.1.3 Embedding model — text-embedding-3-small / Cohere embed / local BGE — choose by domain
- 15.2.1.2 Query pipeline — embed query → ANN search → retrieve chunks → augment prompt → generate
  - 15.2.1.2.1 Hybrid search — dense ANN + sparse BM25 — RRF fusion — better recall
  - 15.2.1.2.2 Re-ranking — cross-encoder re-ranks top K — improves precision — latency tradeoff
  - 15.2.1.2.3 Context window packing — fit retrieved chunks in context — trim if overflow — priority
- 15.2.1.3 Metadata filtering — filter chunks by date / source / tenant before ANN — scoped retrieval
  - 15.2.1.3.1 Multi-tenant RAG — filter by tenant_id — namespace isolation — per-user retrieval

### 15.3 Async AI Job Patterns
#### 15.3.1 Long-Running AI Tasks
- 15.3.1.1 Async job pattern — submit job → return job ID → poll status → retrieve result
  - 15.3.1.1.1 Job queue — AI task enqueued — worker processes — status: pending/running/done/failed
  - 15.3.1.1.2 Webhook on complete — push result to callback URL — no client polling needed
  - 15.3.1.1.3 SSE / WebSocket streaming — stream tokens as generated — progressive response — UX
- 15.3.1.2 Priority queues — interactive user requests > batch jobs — latency SLA per tier
  - 15.3.1.2.1 Separate queues per priority — workers drain high-priority first — starvation prevention

### 15.4 Prompt Chaining & Orchestration
#### 15.4.1 Chaining Patterns
- 15.4.1.1 Sequential chain — output of step N = input of step N+1 — multi-stage reasoning
  - 15.4.1.1.1 Extract → verify → format — three-step refinement — each step specialised
  - 15.4.1.1.2 Failure propagation — error in step 2 → abort or compensate — error handling
- 15.4.1.2 Parallel fan-out — send same input to N model calls — aggregate results — consensus
  - 15.4.1.2.1 Self-consistency — multiple reasoning paths → vote on answer — reliability
  - 15.4.1.2.2 Specialized sub-agents — one agent per domain — router dispatches — compose
- 15.4.1.3 Human-in-the-loop — pause execution — request human decision — resume with input
  - 15.4.1.3.1 Durable execution — Temporal.io / Step Functions — wait for signal — state persisted
  - 15.4.1.3.2 Approval webhook — send Slack message with approve/reject — workflow resumes on click

### 15.5 Webhook Integration for AI
#### 15.5.1 Webhook Patterns
- 15.5.1.1 AI service calls back to webhook on completion — async event-driven — no polling
  - 15.5.1.1.1 Webhook registration — register callback URL with AI provider — authenticated URL
  - 15.5.1.1.2 Signature verification — verify HMAC of payload — prevent spoofing — always validate
- 15.5.1.2 Idempotent webhook handler — deduplicate on event_id — safe retry — at-least-once delivery
  - 15.5.1.2.1 Return 200 fast — process async — avoid timeout — enqueue then ACK
  - 15.5.1.2.2 Retry with backoff — provider retries on non-200 — idempotency key prevents double work
