# The Ideal Backend — Complete Study Guide

## Table of Contents — Part 6: Infrastructure (§27–29)

---

### 27. Background Jobs & Queues

#### 27.1 Job Types
- 27.1.1 Fire-and-forget jobs
- 27.1.2 Delayed/scheduled jobs
- 27.1.3 Recurring/cron jobs
- 27.1.4 Job chains and workflows (sequential, parallel)
- 27.1.5 Priority queues

#### 27.2 Message Brokers
- 27.2.1 Redis-based queues (Bull, Sidekiq, Celery with Redis)
- 27.2.2 RabbitMQ (AMQP protocol)
- 27.2.3 Apache Kafka (event streaming)
- 27.2.4 AWS SQS / Azure Service Bus / GCP Pub/Sub
- 27.2.5 Choosing between brokers (latency, durability, ordering)

#### 27.3 Job Processing
- 27.3.1 Worker processes and concurrency
- 27.3.2 Job serialization and payloads
- 27.3.3 Retry strategies and dead letter queues
- 27.3.4 Job deduplication and idempotency
- 27.3.5 Job progress tracking and callbacks
- 27.3.6 Job timeout and cancellation

#### 27.4 Job Monitoring
- 27.4.1 Dashboard UIs (Bull Board, Sidekiq Web, Flower)
- 27.4.2 Queue depth monitoring
- 27.4.3 Failed job alerting
- 27.4.4 Job throughput metrics

---

### 28. Event-Driven Architecture

#### 28.1 Core Concepts
- 28.1.1 Events vs commands vs queries
- 28.1.2 Event producers and consumers
- 28.1.3 Event schemas and contracts
- 28.1.4 Domain events vs integration events

#### 28.2 Messaging Patterns
- 28.2.1 Publish/Subscribe (pub/sub)
- 28.2.2 Point-to-point (queue)
- 28.2.3 Fan-out pattern
- 28.2.4 Request/reply over messaging
- 28.2.5 Dead letter handling

#### 28.3 Event Sourcing
- 28.3.1 Storing events as source of truth
- 28.3.2 Event store design
- 28.3.3 Rebuilding state from events (projections)
- 28.3.4 Snapshots for performance
- 28.3.5 Event versioning and schema evolution

#### 28.4 Eventual Consistency
- 28.4.1 Why eventual consistency in event-driven systems
- 28.4.2 Saga pattern for distributed transactions
  - 28.4.2.1 Choreography-based sagas
  - 28.4.2.2 Orchestration-based sagas
- 28.4.3 Compensating transactions
- 28.4.4 Outbox pattern (transactional outbox)
- 28.4.5 Inbox pattern (idempotent consumers)

---

### 29. Microservices & Modular Architecture

#### 29.1 Monolith vs Microservices
- 29.1.1 Monolithic architecture (advantages and limits)
- 29.1.2 Modular monolith (best of both worlds)
- 29.1.3 Microservices architecture (advantages and complexity)
- 29.1.4 When to start with a monolith
- 29.1.5 When to migrate to microservices

#### 29.2 Microservice Design
- 29.2.1 Service boundaries (bounded contexts from DDD)
- 29.2.2 Single responsibility per service
- 29.2.3 Database-per-service pattern
- 29.2.4 Shared libraries vs duplication trade-off
- 29.2.5 API contracts between services

#### 29.3 Inter-Service Communication
- 29.3.1 Synchronous: REST, gRPC
- 29.3.2 Asynchronous: message queues, event bus
- 29.3.3 Service mesh (Istio, Linkerd)
- 29.3.4 Service discovery (Consul, Eureka, Kubernetes DNS)
- 29.3.5 API Gateway pattern (Kong, AWS API Gateway, Ocelot)

#### 29.4 Microservice Challenges
- 29.4.1 Distributed tracing across services
- 29.4.2 Distributed transactions (saga pattern)
- 29.4.3 Data consistency across services
- 29.4.4 Service versioning and backward compatibility
- 29.4.5 Testing microservices (contract testing with Pact)
- 29.4.6 Deployment complexity and orchestration

#### 29.5 Modular Monolith Patterns
- 29.5.1 Module boundaries with internal APIs
- 29.5.2 Module-level dependency injection
- 29.5.3 Shared kernel pattern
- 29.5.4 Preparing modules for future extraction

---

> **Navigation:** [← Part 5: Protection](toc-2_part_5.md) | [Part 7: Features (§30–39) →](toc-2_part_7.md)
