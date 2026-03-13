# Integration Patterns Complete Study Guide - Part 7: Message Brokers

## 12.0 Message Brokers

### 12.1 Apache Kafka
#### 12.1.1 Core Architecture
- 12.1.1.1 Topics — partitioned — replicated — append-only log — durable — ordered per partition
  - 12.1.1.1.1 Partition — unit of parallelism — ordered within — unordered across — key determines partition
  - 12.1.1.1.2 Replication factor — N copies — leader + N-1 followers — ISR (in-sync replicas)
  - 12.1.1.1.3 Retention — time-based (7 days default) or size-based — configurable per topic
- 12.1.1.2 Producers — write to topic — choose partition — acks setting — delivery guarantee
  - 12.1.1.2.1 acks=0 — fire and forget — no confirmation — fastest — data loss possible
  - 12.1.1.2.2 acks=1 — leader ACK only — moderate — loss if leader fails before replication
  - 12.1.1.2.3 acks=all — all ISR ACK — slowest — no data loss if min.insync.replicas met
  - 12.1.1.2.4 Idempotent producer — enable.idempotence=true — exactly-once per partition — dedup
- 12.1.1.3 Consumers — pull model — consumer group — each partition assigned to one member
  - 12.1.1.3.1 Offset — position in partition — committed to __consumer_offsets — resumable
  - 12.1.1.3.2 auto.offset.reset — earliest (replay all) / latest (only new) — on new consumer group
  - 12.1.1.3.3 Consumer group rebalance — partition reassignment — on join/leave — pause processing

#### 12.1.2 Kafka Patterns
- 12.1.2.1 Log compaction — keep last value per key — delete old versions — compact topics
  - 12.1.2.1.1 Tombstone — null value for key — signals deletion — compacted away eventually
  - 12.1.2.1.2 Use case — latest state per entity — reference data — changelog topics
- 12.1.2.2 Kafka Streams — stream processing library — stateful — joins + aggregations — embedded
  - 12.1.2.2.1 KTable — changelog stream as table — materialized view — queryable state store
  - 12.1.2.2.2 KStream-KTable join — enrich event stream with reference data — local join
- 12.1.2.3 Kafka Connect — source + sink connectors — no-code integration — 100s of connectors
  - 12.1.2.3.1 SMT (Single Message Transform) — lightweight transformation — field rename / mask
  - 12.1.2.3.2 Exactly-once delivery — Kafka Connect 3.3+ — connector transactions — no duplicates
- 12.1.2.4 Schema Registry — Confluent / AWS Glue — Avro/Protobuf/JSON Schema — compatibility check
  - 12.1.2.4.1 Producer registers schema → schema ID embedded in message — consumer fetches schema

### 12.2 RabbitMQ
#### 12.2.1 Exchange & Queue Model
- 12.2.1.1 Exchange — routing node — direct / fanout / topic / headers — routes to queues
  - 12.2.1.1.1 Direct exchange — routing key exact match — one-to-one routing — default exchange
  - 12.2.1.1.2 Fanout exchange — broadcast to all bound queues — ignore routing key — pub/sub
  - 12.2.1.1.3 Topic exchange — routing key pattern — *.order.# — wildcard routing — flexible
  - 12.2.1.1.4 Headers exchange — route on message headers — ignore routing key — attribute-based
- 12.2.1.2 Queue — durable / transient — consumer pulls or push — FIFO — bounded capacity
  - 12.2.1.2.1 Durable queue — survives restart — persistent messages — production default
  - 12.2.1.2.2 Quorum queues — replicated — Raft-based — preferred over classic mirrored queues

#### 12.2.2 RabbitMQ Reliability Patterns
- 12.2.2.1 Publisher confirms — broker ACKs message written to disk — producer-side guarantee
  - 12.2.2.1.1 Async confirms — channel.basicPublish + addConfirmListener — non-blocking
- 12.2.2.2 Consumer ACK — manual ACK after processing — NACK + requeue on failure — at-least-once
  - 12.2.2.2.1 prefetchCount — consumer fetches N unACKed messages max — backpressure control
- 12.2.2.3 Dead letter exchange — expired / rejected / max-retry messages routed to DLE
  - 12.2.2.3.1 x-dead-letter-exchange queue arg — configure per queue — automatic DLQ routing

### 12.3 AWS SQS & SNS
#### 12.3.1 SQS Patterns
- 12.3.1.1 Standard queue — at-least-once — best-effort ordering — unlimited throughput
  - 12.3.1.1.1 Visibility timeout — message hidden during processing — extend to prevent redeliver
  - 12.3.1.1.2 Long polling — WaitTimeSeconds up to 20 — reduce empty receives — cost effective
- 12.3.1.2 FIFO queue — exactly-once — ordered — 3000 msg/s with batching — dedup ID
  - 12.3.1.2.1 Message group ID — ordering within group — parallel consumers per group
  - 12.3.1.2.2 Deduplication ID — 5-min window — reject duplicate — idempotent delivery

#### 12.3.2 SNS Fan-out
- 12.3.2.1 SNS topic → multiple SQS queues — pub/sub + durable delivery — decoupled fan-out
  - 12.3.2.1.1 Message filtering — subscription filter policy — JSON attribute match — per-subscriber
  - 12.3.2.1.2 SNS → SQS → Lambda — standard serverless integration — decoupled event flow
