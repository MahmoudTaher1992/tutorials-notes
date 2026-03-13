# Cloud Design Patterns - Part 9: Messaging & Event-Driven (I)

## 5.0 Messaging & Event-Driven Patterns

### 5.1 Publisher-Subscriber
#### 5.1.1 Pattern Intent
- 5.1.1.1 Decouple publishers from subscribers via a message channel (topic/event bus)
- 5.1.1.2 Publishers emit events without knowledge of who consumes them
- 5.1.1.3 Subscribers receive only events matching their subscription filter
#### 5.1.2 Topic-Based vs. Content-Based Routing
- 5.1.2.1 Topic-based — subscriber declares interest in named topic/queue
  - 5.1.2.1.1 AWS SNS topics, Kafka topics, Google Pub/Sub topics
- 5.1.2.2 Content-based — broker routes based on message attributes/headers/body
  - 5.1.2.2.1 SNS filter policy — JSON attribute matching; reduces fan-out cost
  - 5.1.2.2.2 EventBridge rules — pattern matching on event content fields
#### 5.1.3 Fan-Out Topology
- 5.1.3.1 One publisher → multiple subscriber queues (SNS → SQS fan-out)
  - 5.1.3.1.1 Delivery guarantee per subscriber — each subscriber queue gets its own copy
- 5.1.3.2 Competing consumers per subscriber queue — parallel processing of fan-out messages
- 5.1.3.3 Fan-out amplification — N subscribers × M messages per event = N×M deliveries
#### 5.1.4 Subscription Management
- 5.1.4.1 Durable subscriptions — messages queued even if subscriber is offline
- 5.1.4.2 Ephemeral subscriptions — messages dropped if subscriber not connected (WebSocket push)
- 5.1.4.3 Subscription filter expressions — reduce broker-to-subscriber data transfer
#### 5.1.5 Delivery Guarantees
- 5.1.5.1 At-most-once — fire and forget; possible message loss; no deduplication required
- 5.1.5.2 At-least-once — acknowledge after processing; possible duplicates; idempotency required
- 5.1.5.3 Exactly-once — deduplication + idempotent processing; highest complexity and cost
  - 5.1.5.3.1 Kafka exactly-once — transactional producer + idempotent consumer + atomic offsets
#### 5.1.6 Pub/Sub Observability
- 5.1.6.1 Message throughput (publish rate, consume rate) per topic
- 5.1.6.2 Consumer lag — number of unprocessed messages; alert on growing lag
- 5.1.6.3 Dead-letter queue depth — indicates sustained consumer processing failures

### 5.2 Message Broker Architecture
#### 5.2.1 Broker Roles & Responsibilities
- 5.2.1.1 Message routing — deliver messages from producer to correct consumer(s)
- 5.2.1.2 Message persistence — store messages durably until acknowledged
- 5.2.1.3 Protocol translation — AMQP, MQTT, STOMP, HTTP normalization
#### 5.2.2 Queue vs. Topic Semantics
- 5.2.2.1 Queue — point-to-point; one consumer per message; competing consumers model
- 5.2.2.2 Topic — broadcast; multiple subscribers each receive full copy
- 5.2.2.3 Hybrid — RabbitMQ exchanges: direct, fanout, topic (regex routing), headers
#### 5.2.3 Message Broker Internals
- 5.2.3.1 Write-ahead log (WAL) — persist message before acknowledging producer
  - 5.2.3.1.1 Kafka log segments — immutable segment files; configurable retention by size or time
- 5.2.3.2 Page cache utilization — OS page cache serves hot reads without disk I/O
  - 5.2.3.2.1 Kafka zero-copy — sendfile syscall bypasses user space; reduces CPU overhead
- 5.2.3.3 Partition replication — Kafka ISR (in-sync replica) set; leader election on failure
  - 5.2.3.3.1 min.insync.replicas — minimum ISR count to accept producer writes; durability config
#### 5.2.4 Broker High Availability
- 5.2.4.1 Kafka KRaft (Raft-based metadata) — eliminates ZooKeeper dependency; faster failover
- 5.2.4.2 RabbitMQ quorum queues — Raft-based; replaces classic mirrored queues
- 5.2.4.3 AWS SQS/SNS — managed; multi-AZ by default; 99.9% availability SLA
#### 5.2.5 Broker Performance Tuning
- 5.2.5.1 Batch size — larger batches improve throughput at cost of latency
  - 5.2.5.1.1 Kafka producer batch.size + linger.ms — tune for throughput vs. latency
- 5.2.5.2 Compression — lz4 for speed, gzip for ratio; broker-side or producer-side
- 5.2.5.3 Consumer fetch tuning — fetch.min.bytes, fetch.max.wait.ms; reduce poll overhead

### 5.3 Event Streaming (Log-Based)
#### 5.3.1 Log-Based Message Broker Model
- 5.3.1.1 Append-only log — all messages written to end of log; immutable historical record
- 5.3.1.2 Consumer offset — each consumer tracks its own position in the log; no destructive reads
  - 5.3.1.2.1 Offset storage — Kafka __consumer_offsets topic; checkpoint to external store
#### 5.3.2 Event Stream vs. Message Queue
- 5.3.2.1 Retention — stream retains messages by time/size; queue deletes on ACK
- 5.3.2.2 Replayability — stream consumers can replay from any offset; queues cannot
- 5.3.2.3 Fan-out — multiple independent consumer groups read same stream independently
  - 5.3.2.3.1 Zero coupling between consumer groups — one group's lag doesn't affect another
#### 5.3.3 Stream Processing
- 5.3.3.1 Stateless processing — transform/filter each event independently; no cross-event state
- 5.3.3.2 Stateful processing — aggregations, joins, sessionization require state store
  - 5.3.3.2.1 Kafka Streams state stores — RocksDB-backed; changelog topic for fault tolerance
- 5.3.3.3 Windowing — tumbling (fixed, non-overlapping), sliding (overlapping), session (activity-based)
  - 5.3.3.3.1 Tumbling window — hourly sales sum; window closes at exact boundary
  - 5.3.3.3.2 Session window — user activity session; gap-based boundary detection
#### 5.3.4 Stream-Table Duality
- 5.3.4.1 Stream as changelog — events are mutations; table is current state (materialized view)
- 5.3.4.2 Table as stream — any table can emit a change stream (CDC via Debezium/Kafka Connect)
- 5.3.4.3 KTable in Kafka Streams — compacted log; each key retains only latest value
#### 5.3.5 Late-Arriving Data
- 5.3.5.1 Event time vs. processing time — event timestamp vs. broker ingestion timestamp
- 5.3.5.2 Watermark — threshold declaring all events up to T have arrived; close window after watermark
- 5.3.5.3 Allowed lateness — extend window to accept late events up to N seconds past watermark
  - 5.3.5.3.1 Retractions — emit corrected aggregate when late event changes window result
