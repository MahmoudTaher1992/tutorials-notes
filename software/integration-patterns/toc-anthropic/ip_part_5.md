# Integration Patterns Complete Study Guide - Part 5: Event-Driven & Data Integration

## 9.0 Event-Driven Patterns

### 9.1 CQRS & Event Sourcing
#### 9.1.1 CQRS (Command Query Responsibility Segregation)
- 9.1.1.1 Separate write model (commands) from read model (queries) — different optimizations
  - 9.1.1.1.1 Write model — normalized — transactional — optimized for consistency — OLTP
  - 9.1.1.1.2 Read model — denormalized — optimized for query patterns — multiple projections
  - 9.1.1.1.3 Sync read from write — event/polling — eventual consistency between models
- 9.1.1.2 Benefits — scale reads independently — tailor read model per query — no read/write contention
- 9.1.1.3 Complexity — two models to maintain — eventual consistency lag — not always needed
  - 9.1.1.3.1 Use CQRS when — complex domain + high read/write ratio difference — not everywhere

#### 9.1.2 Event Sourcing
- 9.1.2.1 Store state as sequence of events — current state = replay of all events — append-only
  - 9.1.2.1.1 Event store — immutable log — OrderCreated / ItemAdded / OrderShipped — ordered
  - 9.1.2.1.2 Rebuild state — replay from beginning or from snapshot + recent events — flexible
  - 9.1.2.1.3 Snapshot — periodic state checkpoint — avoid full replay on every read — performance
- 9.1.2.2 Benefits — full audit trail — time travel queries — event replay for projections — debugging
- 9.1.2.3 Challenges — eventual read model — schema evolution of events — event versioning

### 9.2 Saga Pattern
#### 9.2.1 Choreography Saga
- 9.2.1.1 Each service reacts to events — publishes own events — no central coordinator
  - 9.2.1.1.1 OrderService publishes OrderPlaced → PaymentService reacts → publishes PaymentProcessed
  - 9.2.1.1.2 Simple for short sagas — complex for long — hard to track overall state — debug hard
  - 9.2.1.1.3 Cyclic dependencies risk — service A reacts to B reacts to A — design carefully

#### 9.2.2 Orchestration Saga
- 9.2.2.1 Central saga orchestrator — sends commands — waits for replies — manages state
  - 9.2.2.1.1 Orchestrator knows full flow — easy to understand — single place to debug — trace
  - 9.2.2.1.2 Commands to participants — PaymentService.ProcessPayment — await PaymentProcessed
  - 9.2.2.1.3 Temporal.io / AWS Step Functions — managed orchestration — durable execution
- 9.2.2.2 Compensating transactions — undo completed steps on failure — reverse semantics
  - 9.2.2.2.1 PaymentRefunded — CancelShipment — ReleaseInventory — semantic rollback
  - 9.2.2.2.2 Compensation is not rollback — cannot undo published events — forward correction

---

## 10.0 Data Integration Patterns

### 10.1 Data Synchronization
#### 10.1.1 ETL vs ELT
- 10.1.1.1 ETL — extract + transform externally + load — traditional — transform before load
  - 10.1.1.1.1 Transform outside DB — separate ETL engine — CPU + memory there — not warehouse
  - 10.1.1.1.2 Suitable — complex transformation — data masking — pre-load validation
- 10.1.1.2 ELT — extract + load raw + transform inside warehouse — modern — leverage DWH compute
  - 10.1.1.2.1 Load raw first — transform with SQL — BigQuery / Snowflake / Redshift power
  - 10.1.1.2.2 Raw layer preserved — reprocess with new logic — flexible — dbt pattern

#### 10.1.2 Change Data Capture (CDC)
- 10.1.2.1 Capture every row-level change in source DB — replicate to downstream in near-real-time
  - 10.1.2.1.1 Log-based CDC — read DB WAL/binlog — Debezium — low overhead — no polling queries
  - 10.1.2.1.2 Trigger-based CDC — DB triggers write to shadow table — higher overhead — flexible
  - 10.1.2.1.3 Timestamp-based CDC — poll for rows WHERE updated_at > last_run — simple — gaps risk
- 10.1.2.2 Debezium — Kafka Connect source connector — MySQL / Postgres / MongoDB / Oracle
  - 10.1.2.2.1 Before + after image — full row in event — enriched downstream — no extra lookup
  - 10.1.2.2.2 Tombstone event — delete emits null value — Kafka compact topic handles deletes

### 10.2 Consistency Patterns
#### 10.2.1 Dual Write Problem
- 10.2.1.1 Write to DB + send message — not atomic — one can fail — inconsistency risk
  - 10.2.1.1.1 Scenario A — DB write succeeds / message fails — downstream never notified — silent
  - 10.2.1.1.2 Scenario B — message sent / DB write fails — downstream acts on data that doesn't exist
  - 10.2.1.1.3 Solution — Outbox pattern — or CDC — never dual-write directly — always atomic

#### 10.2.2 Eventual Consistency Handling
- 10.2.2.1 Consumers tolerate stale reads — design for lag — compensate in UX
  - 10.2.2.1.1 Optimistic UI — assume success immediately — reconcile on next load — fast UX
  - 10.2.2.1.2 Read-your-writes — route user reads to write replica temporarily — session sticky
- 10.2.2.2 Upsert pattern — INSERT ... ON CONFLICT DO UPDATE — idempotent — safe reprocessing
  - 10.2.2.2.1 Merge by business key — not surrogate — converge on correct state — safe replay

### 10.3 Batch Integration
#### 10.3.1 Batch Processing Patterns
- 10.3.1.1 Batch window — accumulate messages — process together — efficiency vs latency tradeoff
  - 10.3.1.1.1 Tumbling window — fixed non-overlapping period — 1 min batches — simple
  - 10.3.1.1.2 Micro-batch — very small batch — Spark Structured Streaming — near-real-time
- 10.3.1.2 Bulk insert — batch DB writes — COPY / LOAD DATA — 100x faster than row-by-row
  - 10.3.1.2.1 Staging table — load to temp → merge to target — validate before commit
