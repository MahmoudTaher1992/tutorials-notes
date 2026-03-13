# Integration Patterns Complete Study Guide - Part 3: Transformation & Endpoint Patterns

## 5.0 Message Transformation

### 5.1 Data Translation
#### 5.1.1 Message Translator
- 5.1.1.1 Convert message format from one system's model to another — structural transformation
  - 5.1.1.1.1 Field mapping — source.customerId → target.client_id — name normalization
  - 5.1.1.1.2 Type conversion — string date → epoch timestamp — format normalization
  - 5.1.1.1.3 Structure reshape — flat record → nested JSON — or denormalize nested → flat
- 5.1.1.2 Canonical data model — intermediate neutral format — translate to/from canonical
  - 5.1.1.2.1 Hub-and-spoke — N systems × 2 translations — vs N² direct mappings — O(N) vs O(N²)
  - 5.1.1.2.2 Canonical schema ownership — governance challenge — must evolve carefully — versioned
  - 5.1.1.2.3 Industry canonical models — HL7 FHIR (health) / OAGIS (supply chain) / MISMO (mortgage)

#### 5.1.2 Normalizer
- 5.1.2.1 Multiple source formats for same semantic message — convert all to common format
  - 5.1.2.1.1 Multiple channel adapters — each adapter translates its native format — then merge
  - 5.1.2.1.2 Use case — receive orders from REST + EDI + CSV — normalize to canonical order

### 5.2 Content Enrichment & Reduction
#### 5.2.1 Content Enricher
- 5.2.1.1 Add missing data — fetch from external source — enrich message before routing
  - 5.2.1.1.1 Lookup enrichment — message has customer_id — fetch full customer profile — append
  - 5.2.1.1.2 Correlation — use message field as key — query enrichment store — add result
  - 5.2.1.1.3 Caching enrichment data — reduce latency — TTL per entity type — stale risk
- 5.2.1.2 Claim check — store large payload externally — replace with reference token in message
  - 5.2.1.2.1 S3 pre-signed URL as claim check — message carries URL — consumer fetches payload
  - 5.2.1.2.2 Avoids large messages in broker — broker handles small tokens — cheap + fast
  - 5.2.1.2.3 Retrieve on processing — fetch claim → process full payload → optionally delete

#### 5.2.2 Content Filter
- 5.2.2.1 Remove sensitive or irrelevant fields — reduce message size — enforce data minimization
  - 5.2.2.1.1 PII stripping — remove SSN/email before publishing to downstream analytics
  - 5.2.2.1.2 Field projection — select only needed fields — smaller message — faster transfer

#### 5.2.3 Envelope Wrapper
- 5.2.3.1 Wrap existing message in transport envelope — add routing/security metadata — unwrap at destination
  - 5.2.3.1.1 SOAP envelope — WS-Security header — body contains payload — legacy
  - 5.2.3.1.2 CloudEvents spec — standard envelope — source/type/id/time — vendor-neutral wrapper

---

## 6.0 Endpoint Patterns

### 6.1 Consumer Patterns
#### 6.1.1 Polling Consumer
- 6.1.1.1 Consumer periodically checks channel for messages — pull-based — simple
  - 6.1.1.1.1 Short polling — check immediately — empty response if no messages — wasteful
  - 6.1.1.1.2 Long polling — hold connection until message arrives — efficient — SQS default 20s
  - 6.1.1.1.3 Polling interval tradeoff — frequent = low latency + high cost — tune per SLA

#### 6.1.2 Event-Driven Consumer
- 6.1.2.1 Broker pushes message to consumer — consumer registers handler — reactive
  - 6.1.2.1.1 Push delivery — broker initiates — consumer always ready — lower latency
  - 6.1.2.1.2 Backpressure — consumer signals capacity — broker throttles — flow control
  - 6.1.2.1.3 Kafka push model — broker streams to consumer — fetch-based internally — fast

#### 6.1.3 Competing Consumers
- 6.1.3.1 Multiple consumer instances on same queue — horizontal scale — each message once
  - 6.1.3.1.1 Load distribution — each consumer gets subset of messages — throughput scales
  - 6.1.3.1.2 Consumer group — Kafka consumer group — partition assigned per consumer — fair
  - 6.1.3.1.3 Visibility timeout — SQS — message locked while processing — released on failure

### 6.2 Reliability Endpoint Patterns
#### 6.2.1 Idempotent Receiver
- 6.2.1.1 Process same message multiple times safely — deduplication — at-least-once safe
  - 6.2.1.1.1 Store processed message IDs — Redis SET / DB unique constraint — check before process
  - 6.2.1.1.2 Natural idempotency — upsert by business key — SET operation — safe by design
  - 6.2.1.1.3 TTL on processed IDs — 24h window — prevents infinite storage growth

#### 6.2.2 Service Activator
- 6.2.2.1 Connect messaging channel to service — trigger synchronous service from async message
  - 6.2.2.1.1 Adapter layer — receive message → call service method → optional reply
  - 6.2.2.1.2 Decouples service from messaging technology — service unaware of broker — testable

### 6.3 Transactional Messaging
#### 6.3.1 Transactional Outbox
- 6.3.1.1 Write event to outbox table in same DB transaction as business data — atomic
  - 6.3.1.1.1 Outbox table — event_id / aggregate_id / event_type / payload / created_at / sent_at
  - 6.3.1.1.2 Relay process — poll outbox → publish to broker → mark sent — CDC or polling
  - 6.3.1.1.3 Debezium CDC — watch outbox table changes — publish to Kafka — zero polling latency
  - 6.3.1.1.4 Solves dual-write — write DB + publish message in same atomic transaction — no loss
