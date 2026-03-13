# Integration Patterns Complete Study Guide - Part 1: Fundamentals & Messaging Channels

## 1.0 Integration Fundamentals

### 1.1 Integration Styles
#### 1.1.1 The Four Integration Styles
- 1.1.1.1 File transfer — system A writes file — system B reads on schedule — simplest coupling
  - 1.1.1.1.1 Strengths — decoupled — no shared technology — easy to implement — audit trail
  - 1.1.1.1.2 Weaknesses — latency — stale data — file format agreement required — no real-time
- 1.1.1.2 Shared database — multiple systems read/write same DB — tight data coupling
  - 1.1.1.2.1 Strengths — immediate consistency — no transformation — familiar tooling
  - 1.1.1.2.2 Weaknesses — schema coupling — performance bottleneck — no ownership — anti-pattern
- 1.1.1.3 Remote Procedure Invocation — system A calls B's API — synchronous request/reply
  - 1.1.1.3.1 RPC styles — REST / gRPC / SOAP / GraphQL — all request/reply semantics
  - 1.1.1.3.2 Temporal coupling — caller waits — receiver must be up — tight availability dependency
- 1.1.1.4 Messaging — exchange messages via channel — async — decoupled in time and space
  - 1.1.1.4.1 Temporal decoupling — sender and receiver don't operate at same time — resilient
  - 1.1.1.4.2 Foundation for EIP — Enterprise Integration Patterns book — Hohpe & Woolf

#### 1.1.2 Coupling Spectrum
- 1.1.2.1 Temporal coupling — caller blocked until response — REST/gRPC — tight
- 1.1.2.2 Behavioral coupling — caller knows receiver's API contract — moderate
- 1.1.2.3 Data format coupling — shared schema agreement — canonical model reduces this
- 1.1.2.4 Location coupling — caller knows receiver's address — service discovery reduces this
  - 1.1.2.4.1 Service registry — Consul / Kubernetes DNS — decouple from hardcoded URLs

### 1.2 Synchronous vs Asynchronous
#### 1.2.1 Synchronous Integration
- 1.2.1.1 Request/reply — caller sends request — blocks — awaits response — direct feedback
  - 1.2.1.1.1 Advantages — simple mental model — immediate error propagation — easy debugging
  - 1.2.1.1.2 Disadvantages — cascading failures — latency addition — availability dependency
- 1.2.1.2 Synchronous composition — chain of API calls — each adds latency — fan-out problem
  - 1.2.1.2.1 Parallel calls — Promise.all / async gather — reduce wall time — fan-out pattern

#### 1.2.2 Asynchronous Integration
- 1.2.2.1 Fire and forget — sender sends message — does not wait for reply — one-way
  - 1.2.2.1.1 Decoupled availability — receiver processes when ready — sender continues
  - 1.2.2.1.2 No immediate feedback — errors surface later — harder to debug — needs monitoring
- 1.2.2.2 Async request/reply — send message with correlation ID — reply via callback/polling
  - 1.2.2.2.1 Polling — sender checks status endpoint — simple — adds network overhead
  - 1.2.2.2.2 Callback/webhook — receiver pushes reply to return address — efficient — firewall concern

---

## 2.0 Messaging Channels

### 2.1 Channel Types
#### 2.1.1 Point-to-Point Channel
- 2.1.1.1 One producer — one consumer — exactly one receiver processes each message
  - 2.1.1.1.1 Queue semantics — FIFO delivery — competing consumers read from same queue
  - 2.1.1.1.2 Load balancing — multiple consumers — scale processing — each message once
  - 2.1.1.1.3 AWS SQS / RabbitMQ queue — point-to-point implementations — message deleted on ACK

#### 2.1.2 Publish-Subscribe Channel
- 2.1.2.1 One producer — many consumers — each subscriber receives every message independently
  - 2.1.2.1.1 Topic — Kafka topic / SNS topic / RabbitMQ fanout exchange — broadcast
  - 2.1.2.1.2 Durable subscription — subscriber receives messages even when offline — retained
  - 2.1.2.1.3 Kafka consumer group — group = P2P within group — groups = pub/sub between groups

### 2.2 Specialized Channels
#### 2.2.1 Dead Letter Channel
- 2.2.1.1 Messages that cannot be processed — move to DLC — no data loss — manual review
  - 2.2.1.1.1 Poison message — repeatedly fails — consumer rejects — DLQ after max retries
  - 2.2.1.1.2 DLQ monitoring — depth alerts — growing DLQ = persistent bug — SRE concern
  - 2.2.1.1.3 Reprocessing — fix bug → replay DLQ → idempotent consumer required

#### 2.2.2 Channel Patterns
- 2.2.2.1 Channel adapter — connect non-messaging system to messaging infrastructure — bridge
  - 2.2.2.1.1 Inbound adapter — poll DB / file system / API → produce message — source connector
  - 2.2.2.1.2 Outbound adapter — consume message → call target system — sink connector
- 2.2.2.2 Wire tap — non-destructive copy — intercept + forward to secondary channel — observability
  - 2.2.2.2.1 Use case — audit logging / testing / monitoring — parallel processing of copy
- 2.2.2.3 Guaranteed delivery — message persisted before ACK — survives broker restart — durable
  - 2.2.2.3.1 Acknowledgement — consumer ACKs after processing — broker retains until ACK
  - 2.2.2.3.2 At-least-once delivery — may redeliver — consumer must be idempotent — common
  - 2.2.2.3.3 Exactly-once — Kafka transactions / SQS FIFO deduplication — expensive — where critical
- 2.2.2.4 Message expiry — TTL on message — discard if not consumed in time — freshness
  - 2.2.2.4.1 Expired messages to DLQ — or silently dropped — policy decision — configure carefully
