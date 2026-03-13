# Cloud Design Patterns - Part 10: Messaging & Event-Driven (II)

## 5.0 Messaging & Event-Driven Patterns (continued)

### 5.4 Choreography vs. Orchestration
#### 5.4.1 Choreography
- 5.4.1.1 No central coordinator — services react to events and emit new events
  - 5.4.1.1.1 Implicit workflow — business process encoded in event chain across services
- 5.4.1.2 Advantages — fully decoupled; each service independently deployable
- 5.4.1.3 Disadvantages — workflow visibility requires distributed trace assembly; hard to debug
  - 5.4.1.3.1 Missing step detection — no single place to detect stuck/incomplete workflows
#### 5.4.2 Orchestration
- 5.4.2.1 Central orchestrator drives workflow — calls participants in defined sequence
  - 5.4.2.1.1 Orchestrator patterns — AWS Step Functions, Temporal, Netflix Conductor
- 5.4.2.2 Advantages — explicit state machine; easy to visualize, debug, and modify
- 5.4.2.3 Disadvantages — orchestrator becomes a hub; potential coupling and SPOF
#### 5.4.3 Selection Criteria
- 5.4.3.1 Use choreography — simple flows (<4 steps), high decoupling priority, event-driven culture
- 5.4.3.2 Use orchestration — complex long-running flows, human approvals, explicit SLA tracking
- 5.4.3.3 Hybrid — choreography between domains; orchestration within a domain

### 5.5 Outbox Pattern
#### 5.5.1 Pattern Intent
- 5.5.1.1 Guarantee at-least-once message delivery without distributed 2PC
- 5.5.1.2 Solve dual-write problem — DB write and message publish must both succeed or both fail
#### 5.5.2 Outbox Table Implementation
- 5.5.2.1 Write domain state + outbox event in single local ACID transaction
  - 5.5.2.1.1 Outbox table schema — id, aggregateType, aggregateId, type, payload, createdAt, publishedAt
- 5.5.2.2 Message relay — background process polls outbox for unpublished events; publishes to broker
  - 5.5.2.2.1 Polling relay — simple; adds latency (poll interval); requires locking for multi-instance
  - 5.5.2.2.2 CDC relay (Debezium) — tails DB WAL; near-real-time; no polling overhead
#### 5.5.3 Outbox Cleanup
- 5.5.3.1 Mark published — set publishedAt after successful broker ACK
- 5.5.3.2 Periodic archival — delete published entries older than retention window
- 5.5.3.3 Partitioned outbox — partition by aggregate to parallelize relay throughput

### 5.6 Idempotent Consumer (Inbox Pattern)
#### 5.6.1 Pattern Intent
- 5.6.1.1 Handle duplicate message delivery safely — process each logical message exactly once
- 5.6.1.2 Required when broker delivers at-least-once semantics
#### 5.6.2 Inbox Table Implementation
- 5.6.2.1 Record messageId in inbox table before processing; skip if already present
  - 5.6.2.1.1 Inbox + processing in same ACID transaction — prevent partial processing
- 5.6.2.2 Inbox cleanup — expire entries after safe deduplication window (message retention × 2)
#### 5.6.3 Application-Level Idempotency
- 5.6.3.1 Natural idempotency — upsert semantics; PUT with full resource state is idempotent
- 5.6.3.2 Idempotency key in API — client-supplied key; server deduplicates within key TTL
  - 5.6.3.2.1 Stripe/Braintree pattern — Idempotency-Key header; 24-hour deduplication window

### 5.7 Priority Queue
#### 5.7.1 Pattern Intent
- 5.7.1.1 Process high-priority messages before lower-priority ones
- 5.7.1.2 Ensure critical workloads are not starved by bulk background processing
#### 5.7.2 Implementation Strategies
- 5.7.2.1 Multiple queues — separate queue per priority tier; consumers poll high-priority first
  - 5.7.2.1.1 Weighted polling — consume 10 high-priority per 1 low-priority to prevent starvation
- 5.7.2.2 Broker-native priority — RabbitMQ x-max-priority property per message
- 5.7.2.3 Application-layer priority — consumer reads all; sorts by priority field before processing
#### 5.7.3 Starvation Prevention
- 5.7.3.1 Aging — increase priority of waiting low-priority messages over time
- 5.7.3.2 Fair scheduling — guarantee minimum throughput for each priority tier
  - 5.7.3.2.1 Token bucket per tier — each tier earns processing tokens at guaranteed rate

### 5.8 Claim Check Pattern
#### 5.8.1 Pattern Intent
- 5.8.1.1 Store large message payloads in external storage; pass only a reference (claim check) in the message
- 5.8.1.2 Keep message broker efficient — avoid broker memory exhaustion from large payloads
#### 5.8.2 Implementation
- 5.8.2.1 Producer stores payload in object storage (S3, Azure Blob); embeds URL/key in message
  - 5.8.2.1.1 Payload size threshold — apply pattern when payload > 256KB (SQS max is 256KB)
- 5.8.2.2 Consumer retrieves payload from object storage using claim check reference
- 5.8.2.3 Payload lifecycle — TTL on object storage; auto-delete after consumers have processed
#### 5.8.3 Security Considerations
- 5.8.3.1 Presigned URLs — time-limited access to payload; consumer fetches without credentials
  - 5.8.3.1.1 S3 presigned URL — signed HMAC; expiry typically 1 hour
- 5.8.3.2 Access control — ensure payload readable only by authorized consumers; IAM policy
