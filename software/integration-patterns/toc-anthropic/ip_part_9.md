# Integration Patterns Complete Study Guide - Part 9: Integration Platforms

## 14.0 Integration Platforms

### 14.1 Apache Camel
#### 14.1.1 Core Concepts
- 14.1.1.1 Route — from(source).process().to(destination) — EIP pipeline in code or YAML/XML
  - 14.1.1.1.1 from() — consumer endpoint — file / timer / kafka / http / jms / rest — source
  - 14.1.1.1.2 to() — producer endpoint — destination — can chain multiple to() calls
  - 14.1.1.1.3 process() — custom Java/Groovy processor — arbitrary transformation — lambda
- 14.1.1.2 Exchange — message container in Camel — in + out body — headers — properties
  - 14.1.1.2.1 In message — received payload — headers from source — mutable during route
  - 14.1.1.2.2 Exchange pattern — InOnly (one-way) vs InOut (request/reply) — controls reply flow

#### 14.1.2 Camel EIP Implementations
- 14.1.2.1 Content-based router — .choice().when(predicate).to().otherwise().to() — DSL router
  - 14.1.2.1.1 Simple language — ${header.type} == 'order' — lightweight expression language
  - 14.1.2.1.2 JSONPath / XPath — route on message body field — rich expression — powerful
- 14.1.2.2 Splitter — .split(body().tokenize("\n")).to() — split lines/JSON array — parallel option
  - 14.1.2.2.1 .parallelProcessing() — concurrent sub-exchange processing — ordered option
  - 14.1.2.2.2 Aggregation strategy — collect split results — merge back — custom combiner
- 14.1.2.3 Aggregator — .aggregate(header("orderId"), strategy).completionSize(5).to()
  - 14.1.2.3.1 Completion conditions — size / timeout / predicate — trigger aggregate output
- 14.1.2.4 Error handling — errorHandler(deadLetterChannel("queue:dlq")) — onException — retry
  - 14.1.2.4.1 .maximumRedeliveries(3).redeliveryDelay(1000).backOffMultiplier(2) — retry config
- 14.1.2.5 700+ components — AWS / Azure / Kafka / REST / JMS / FTP / database / HTTP — vast

### 14.2 MuleSoft Anypoint
#### 14.2.1 Mule Runtime & Flows
- 14.2.1.1 Mule flow — source (listener) → processors → target — visual + XML/YAML — drag-drop
  - 14.2.1.1.1 HTTP Listener — expose REST endpoint — trigger flow — inbound request
  - 14.2.1.1.2 Transform Message — DataWeave — powerful ETL language — JSON/XML/CSV/Java
  - 14.2.1.1.3 DataWeave — Mule's transformation language — map / filter / groupBy — functional
- 14.2.1.2 Connectors — pre-built — Salesforce / SAP / Workday / ServiceNow — enterprise focus
  - 14.2.1.2.1 Anypoint Exchange — connector marketplace — reuse org-published connectors
- 14.2.1.3 API-led connectivity — experience API → process API → system API — 3-layer architecture
  - 14.2.1.3.1 System API — thin wrapper over backend system — stable contract — reused internally
  - 14.2.1.3.2 Process API — business logic — orchestrate system APIs — recombinable
  - 14.2.1.3.3 Experience API — client-specific — mobile / web / partner — tailored response

### 14.3 AWS EventBridge
#### 14.3.1 Event Bus Architecture
- 14.3.1.1 Event bus — default / custom / partner — receive events — route to targets via rules
  - 14.3.1.1.1 Event rule — event pattern match → target — JSON filter — up to 5 targets per rule
  - 14.3.1.1.2 Partner event bus — SaaS integrations — Zendesk / Datadog / Stripe — native events
- 14.3.1.2 Event pattern matching — prefix / suffix / exists / numeric / anything-but — flexible
  - 14.3.1.2.1 Content-based routing — route payment events to payment handler — order to order handler
- 14.3.1.3 Schema registry — discover + version event schemas — code bindings — auto-generated SDK
  - 14.3.1.3.1 Auto-discovery — events flowing through bus → schemas inferred — catalog built
- 14.3.1.4 Pipes — point-to-point enrichment pipeline — source → filter → enrich → target
  - 14.3.1.4.1 Source: SQS/Kinesis/DynamoDB streams → filter → Lambda enrichment → target

### 14.4 Azure Service Bus
#### 14.4.1 Service Bus Features
- 14.4.1.1 Queues — ordered / at-least-once / sessions for FIFO — enterprise messaging
  - 14.4.1.1.1 Message sessions — group related messages — session-aware receiver — ordered per session
  - 14.4.1.1.2 Scheduled delivery — enqueue at future time — delay processing — scheduled messages
- 14.4.1.2 Topics + subscriptions — pub/sub — filter rules per subscription — SQL-like filter
  - 14.4.1.2.1 Subscription filter — SQL filter or correlation filter — route to correct subscription
  - 14.4.1.2.2 Dead-letter sub — each subscription has own DLQ — expired / max-delivery exceeded
- 14.4.1.3 Premium tier — message isolation — VNET integration — large messages (100MB) — geo-DR
  - 14.4.1.3.1 Geo-disaster recovery — namespace pairing — failover — metadata replicated — alias
