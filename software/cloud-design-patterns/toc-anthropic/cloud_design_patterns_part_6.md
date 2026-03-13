# Cloud Design Patterns - Part 6: Data Management (I)

## 4.0 Data Management Patterns

### 4.1 CQRS (Command Query Responsibility Segregation)
#### 4.1.1 Pattern Intent
- 4.1.1.1 Separate read (query) and write (command) models into distinct components
- 4.1.1.2 Optimize each side independently — write side for consistency, read side for performance
#### 4.1.2 Command Side Design
- 4.1.2.1 Command objects — immutable intent messages: CreateOrder, CancelReservation
  - 4.1.2.1.1 Validation — business rule validation before state change; reject invalid commands
  - 4.1.2.1.2 Command handler — single handler per command type; enforces invariants
- 4.1.2.2 Aggregate pattern — consistency boundary for commands; only one aggregate per transaction
  - 4.1.2.2.1 Aggregate root — single entry point; guards internal invariants
  - 4.1.2.2.2 Aggregate size — small aggregates minimize contention; avoid "god aggregates"
- 4.1.2.3 Write model storage — normalized relational store or event store optimized for writes
#### 4.1.3 Query Side Design
- 4.1.3.1 Read model (projection) — denormalized, pre-joined view optimized for specific query patterns
  - 4.1.3.1.1 Multiple read models — different projections for different UIs or access patterns
- 4.1.3.2 Read model storage options — Redis (low latency), Elasticsearch (full-text), RDBMS read replica
- 4.1.3.3 Query handler — reads from optimized read store; no business logic
#### 4.1.4 Synchronization Between Sides
- 4.1.4.1 Event-driven projection update — command side publishes domain events; read side subscribes
  - 4.1.4.1.1 Eventual consistency gap — read models lag behind writes; surface this to users (e.g., "just updated")
- 4.1.4.2 Synchronous projection — update both sides in same transaction (simple but couples models)
- 4.1.4.3 Projection rebuild — replay all events to reconstruct read model from scratch
  - 4.1.4.3.1 Rebuild time — must complete within acceptable data-staleness window
#### 4.1.5 CQRS Variants
- 4.1.5.1 Simple CQRS — separate service methods for commands and queries; same datastore
- 4.1.5.2 Full CQRS — separate data stores for reads and writes; requires event/sync mechanism
- 4.1.5.3 CQRS + Event Sourcing — write side is event store; read side is event-driven projection
#### 4.1.6 CQRS Trade-offs & When NOT to Use
- 4.1.6.1 Added complexity — two models to maintain, synchronize, and test
- 4.1.6.2 Eventual consistency — not suitable for systems requiring immediate read-your-writes
- 4.1.6.3 Best fit — high-read/low-write ratio; complex domain logic; collaborative domains

### 4.2 Event Sourcing
#### 4.2.1 Pattern Intent
- 4.2.1.1 Store state as an ordered sequence of immutable domain events — not current state snapshot
- 4.2.1.2 Current state derived by replaying events from the beginning or from a snapshot
#### 4.2.2 Event Store Design
- 4.2.2.1 Event structure — eventId, aggregateId, aggregateType, eventType, payload, timestamp, version
  - 4.2.2.1.1 Event versioning — schema evolution strategy; backward/forward compatible event schemas
- 4.2.2.2 Append-only semantics — events never mutated or deleted; immutable audit log
- 4.2.2.3 Stream per aggregate — all events for one aggregate in ordered stream by sequence number
  - 4.2.2.3.1 Optimistic concurrency — write with expected version; conflict on concurrent writes
#### 4.2.3 Event Replay & State Reconstruction
- 4.2.3.1 Full replay — reconstruct aggregate state from event stream start
  - 4.2.3.1.1 Replay performance — O(n) events; acceptable for short streams; degrades with age
- 4.2.3.2 Snapshot optimization — periodically snapshot aggregate state; replay only from snapshot
  - 4.2.3.2.1 Snapshot strategy — every N events or time interval; store alongside event stream
#### 4.2.4 Event Schema Evolution
- 4.2.4.1 Upcasting — transform old event schema to new schema at read time
- 4.2.4.2 Weak schema (schema-on-read) — flexible JSON payload; consumer handles missing fields
- 4.2.4.3 Event versioning — OrderPlacedV1, OrderPlacedV2; consumers handle multiple versions
#### 4.2.5 Projections & Read Model Derivation
- 4.2.5.1 Synchronous projection — update read model inline with event publication
- 4.2.5.2 Asynchronous projection — event consumer updates read model via message bus
  - 4.2.5.2.1 Projection lag — read model may be seconds behind event store
- 4.2.5.3 Temporal queries — reconstruct state at any past point by replaying up to that timestamp
#### 4.2.6 Event Sourcing Trade-offs
- 4.2.6.1 Audit trail — complete, immutable history is the canonical use case advantage
- 4.2.6.2 GDPR "right to be forgotten" — challenge: events are immutable
  - 4.2.6.2.1 Crypto-shredding — encrypt PII in events; delete encryption key to "forget"
- 4.2.6.3 Event store size growth — long-lived aggregates accumulate large streams; snapshot mitigates
- 4.2.6.4 Eventual consistency — projections lag; not suitable for immediate consistency requirements
