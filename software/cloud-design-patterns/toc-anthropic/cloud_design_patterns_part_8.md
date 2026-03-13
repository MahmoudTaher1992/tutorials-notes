# Cloud Design Patterns - Part 8: Data Management (III)

## 4.0 Data Management Patterns (continued)

### 4.5 Saga Pattern (Distributed Transactions)
#### 4.5.1 Pattern Intent
- 4.5.1.1 Manage long-running distributed transactions without 2PC across service boundaries
- 4.5.1.2 Each step is a local ACID transaction; saga coordinates the sequence
#### 4.5.2 Choreography-Based Saga
- 4.5.2.1 No central coordinator — each service reacts to events and publishes next event
  - 4.5.2.1.1 Event chain — OrderPlaced → InventoryReserved → PaymentCharged → OrderConfirmed
- 4.5.2.2 Decentralized — no single point of failure in coordination logic
- 4.5.2.3 Hard to debug — causal chain implicit in events; trace IDs essential
#### 4.5.3 Orchestration-Based Saga
- 4.5.3.1 Central orchestrator (saga executor) directs each participant step
  - 4.5.3.1.1 State machine — orchestrator tracks saga state; knows which step to call next
- 4.5.3.2 Explicit control flow — easier to understand, debug, and modify than choreography
- 4.5.3.3 Single point of failure risk — orchestrator must be highly available
  - 4.5.3.3.1 Mitigation — persist saga state durably; replay from last checkpoint on restart
#### 4.5.4 Compensation in Sagas
- 4.5.4.1 Each forward step defines compensating action (→ See §3.7)
- 4.5.4.2 Pivot transaction — last step that can succeed before compensation is required
- 4.5.4.3 Partial rollback — compensate only steps that completed; not future steps
#### 4.5.5 Saga Failure Modes
- 4.5.5.1 Backward recovery — trigger compensations in reverse order on failure
- 4.5.5.2 Forward recovery — retry failed step until success (idempotency required)
- 4.5.5.3 Stuck saga — compensation also fails; requires human intervention queue
#### 4.5.6 Saga Isolation Problem
- 4.5.6.1 Dirty reads — intermediate saga state visible to concurrent transactions
  - 4.5.6.1.1 Mitigation — semantic locks; reserve/hold pattern before committing
- 4.5.6.2 Lost updates — concurrent sagas modify same aggregate in opposite directions
- 4.5.6.3 No global isolation — sagas sacrifice isolation for availability (BASE semantics)

### 4.6 Index Table
#### 4.6.1 Pattern Intent
- 4.6.1.1 Create secondary indexes over fields that are not the primary partition key
- 4.6.1.2 Enables efficient queries on non-key attributes without full table scan
#### 4.6.2 Index Table Implementation
- 4.6.2.1 Separate index table — stores index-key → primary-key mapping
  - 4.6.2.1.1 Double write problem — main table and index table must be kept in sync
- 4.6.2.2 Native secondary indexes — DynamoDB GSI, Cassandra secondary index
  - 4.6.2.2.1 DynamoDB GSI — separate partition + sort key; eventually consistent reads
- 4.6.2.3 Inverted index — term → document list mapping (Elasticsearch, Lucene)
#### 4.6.3 Index Consistency
- 4.6.3.1 Synchronous index update — strong consistency; write amplification; reduced throughput
- 4.6.3.2 Asynchronous index update — eventual consistency; higher write throughput; temporary stale results

### 4.7 Materialized View
#### 4.7.1 Pattern Intent
- 4.7.1.1 Pre-compute and store denormalized query results for fast read access
- 4.7.1.2 Avoids expensive joins and aggregations at query time
#### 4.7.2 View Refresh Strategies
- 4.7.2.1 Eager refresh — update materialized view synchronously on source data change
- 4.7.2.2 Lazy refresh — refresh on first read access after TTL expires
- 4.7.2.3 Scheduled refresh — rebuild at regular intervals (hourly, daily)
  - 4.7.2.3.1 Incremental refresh — apply only changes (delta) since last refresh for efficiency
#### 4.7.3 Storage & Query Engines
- 4.7.3.1 RDBMS materialized views — Postgres, Oracle; database-managed refresh
- 4.7.3.2 Redis sorted sets — time-series aggregations, leaderboards
- 4.7.3.3 Elasticsearch — pre-indexed aggregation views; refresh on index update

### 4.8 Data Replication Strategies
#### 4.8.1 Replication Topologies
- 4.8.1.1 Single-leader replication — one primary accepts writes; replicas receive changes
  - 4.8.1.1.1 Synchronous replication — wait for replica ACK before confirming write
  - 4.8.1.1.2 Asynchronous replication — confirm write immediately; replica lags behind
  - 4.8.1.1.3 Semi-synchronous — wait for at least one replica ACK (MySQL default)
- 4.8.1.2 Multi-leader replication — multiple nodes accept writes; complex conflict resolution
  - 4.8.1.2.1 Use case — multi-datacenter active-active writes
  - 4.8.1.2.2 Conflict types — concurrent updates to same record; requires merge strategy
- 4.8.1.3 Leaderless replication — any node accepts writes; quorum-based consistency
  - 4.8.1.3.1 Quorum reads/writes — R + W > N ensures overlap (Dynamo-style)
  - 4.8.1.3.2 Sloppy quorum — accept writes to available nodes even if quorum not reachable
#### 4.8.2 Replication Lag
- 4.8.2.1 Replication lag measurement — seconds behind master metric; alert threshold
- 4.8.2.2 Read-after-write consistency — route reads to primary after user's own writes
- 4.8.2.3 Monotonic reads — ensure user always reads same or newer state across replicas
#### 4.8.3 Change Data Capture (CDC)
- 4.8.3.1 CDC via database log — read WAL/binlog; Debezium captures PostgreSQL WAL
  - 4.8.3.1.1 Debezium output — Kafka topic per table; schema registry for schema evolution
- 4.8.3.2 CDC use cases — real-time sync to search index, cache invalidation, audit logs

### 4.9 Polyglot Persistence
#### 4.9.1 Pattern Intent
- 4.9.1.1 Use different storage technologies optimized for each data access pattern
- 4.9.1.2 No single database fits all use cases well
#### 4.9.2 Storage Technology Selection Matrix
- 4.9.2.1 Relational (RDBMS) — structured data, ACID transactions, complex joins; PostgreSQL, MySQL
- 4.9.2.2 Document store — flexible schema, nested objects; MongoDB, DynamoDB
- 4.9.2.3 Key-value store — ultra-fast lookup by key; Redis, DynamoDB
- 4.9.2.4 Column-family — high-write timeseries, wide rows; Cassandra, HBase
- 4.9.2.5 Graph database — relationship-heavy queries; Neo4j, Amazon Neptune
- 4.9.2.6 Search engine — full-text, faceted search; Elasticsearch, OpenSearch
- 4.9.2.7 Time-series DB — metrics, telemetry, IoT; InfluxDB, TimescaleDB, Prometheus
#### 4.9.3 Polyglot Consistency Challenge
- 4.9.3.1 Cross-store transactions — impossible without distributed tx; use Saga/Outbox to coordinate
- 4.9.3.2 Synchronization lag — multiple stores reflect same data; eventual consistency across stores
- 4.9.3.3 Operational overhead — each store requires separate expertise, monitoring, and backup strategy
