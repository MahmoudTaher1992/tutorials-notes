# Software System Design — Comprehensive Study Guide (Table of Contents)

---

## Part I: Foundations of Software Design

### 1. Introduction to Software System Design
- 1.1 What Is Software Design?
- 1.2 Why Design Matters: Cost of Poor Design
- 1.3 Design vs. Architecture vs. Engineering
- 1.4 The Role of a System Designer / Architect
- 1.5 Evolution of Software Design Paradigms
  - 1.5.1 Monolithic Era
  - 1.5.2 Client-Server Era
  - 1.5.3 Service-Oriented Architecture (SOA)
  - 1.5.4 Microservices & Cloud-Native Era
  - 1.5.5 Serverless & Edge Computing Era
- 1.6 Design Thinking in Software
- 1.7 Trade-offs and Decision Making in Design

### 2. Software Design Principles
- 2.1 Separation of Concerns (SoC)
- 2.2 Abstraction and Encapsulation
- 2.3 Modularity and Cohesion
- 2.4 Coupling (Tight vs. Loose)
- 2.5 DRY (Don't Repeat Yourself)
- 2.6 KISS (Keep It Simple, Stupid)
- 2.7 YAGNI (You Aren't Gonna Need It)
- 2.8 Principle of Least Surprise
- 2.9 Composition Over Inheritance
- 2.10 Dependency Inversion
- 2.11 Information Hiding
- 2.12 Law of Demeter (Principle of Least Knowledge)
- 2.13 Fail-Fast Principle
- 2.14 Design by Contract

### 3. SOLID Principles (Deep Dive)
- 3.1 Single Responsibility Principle (SRP)
  - 3.1.1 Defining "Responsibility"
  - 3.1.2 Identifying Violations
  - 3.1.3 Refactoring Toward SRP
  - 3.1.4 Real-World Examples
- 3.2 Open/Closed Principle (OCP)
  - 3.2.1 Open for Extension, Closed for Modification
  - 3.2.2 Strategy Pattern & OCP
  - 3.2.3 Plugin Architectures
- 3.3 Liskov Substitution Principle (LSP)
  - 3.3.1 Behavioral Subtyping
  - 3.3.2 Covariance & Contravariance
  - 3.3.3 Classic Violations (Rectangle–Square Problem)
- 3.4 Interface Segregation Principle (ISP)
  - 3.4.1 Fat Interfaces vs. Role Interfaces
  - 3.4.2 Designing Cohesive Interfaces
- 3.5 Dependency Inversion Principle (DIP)
  - 3.5.1 High-Level vs. Low-Level Modules
  - 3.5.2 Abstractions and Dependency Injection
  - 3.5.3 IoC Containers

### 4. Object-Oriented Design (OOD)
- 4.1 Classes, Objects, and Relationships
- 4.2 Inheritance Hierarchies
- 4.3 Polymorphism (Compile-Time & Run-Time)
- 4.4 Abstract Classes vs. Interfaces
- 4.5 Association, Aggregation, Composition
- 4.6 Object Modeling with UML
  - 4.6.1 Class Diagrams
  - 4.6.2 Object Diagrams
  - 4.6.3 Sequence Diagrams
  - 4.6.4 State Machine Diagrams
  - 4.6.5 Activity Diagrams
  - 4.6.6 Component Diagrams
  - 4.6.7 Deployment Diagrams
  - 4.6.8 Use Case Diagrams
- 4.7 Domain Modeling
- 4.8 CRC Cards (Class-Responsibility-Collaborator)
- 4.9 Common OOD Pitfalls

---

## Part II: Design Patterns

### 5. Creational Design Patterns
- 5.1 Singleton
  - 5.1.1 Lazy vs. Eager Initialization
  - 5.1.2 Thread-Safe Singleton
  - 5.1.3 Singleton Anti-Pattern Debate
- 5.2 Factory Method
- 5.3 Abstract Factory
- 5.4 Builder
  - 5.4.1 Fluent Builder API
  - 5.4.2 Director Pattern
- 5.5 Prototype (Clone)
- 5.6 Object Pool
- 5.7 Dependency Injection (as a Pattern)
  - 5.7.1 Constructor Injection
  - 5.7.2 Setter Injection
  - 5.7.3 Interface Injection
- 5.8 Multiton

### 6. Structural Design Patterns
- 6.1 Adapter (Wrapper)
- 6.2 Bridge
- 6.3 Composite
- 6.4 Decorator
- 6.5 Facade
- 6.6 Flyweight
- 6.7 Proxy
  - 6.7.1 Remote Proxy
  - 6.7.2 Virtual Proxy
  - 6.7.3 Protection Proxy
  - 6.7.4 Smart Reference Proxy
- 6.8 Module Pattern

### 7. Behavioral Design Patterns
- 7.1 Chain of Responsibility
- 7.2 Command
  - 7.2.1 Undo/Redo Implementation
  - 7.2.2 Command Queuing
- 7.3 Iterator
- 7.4 Mediator
- 7.5 Memento
- 7.6 Observer (Publish-Subscribe)
  - 7.6.1 Push vs. Pull Models
  - 7.6.2 Event Bus Implementations
- 7.7 State
- 7.8 Strategy
- 7.9 Template Method
- 7.10 Visitor
- 7.11 Interpreter
- 7.12 Null Object Pattern
- 7.13 Specification Pattern

### 8. Concurrency Patterns
- 8.1 Active Object
- 8.2 Monitor Object
- 8.3 Half-Sync / Half-Async
- 8.4 Leader/Followers
- 8.5 Thread Pool
- 8.6 Reactor Pattern
- 8.7 Proactor Pattern
- 8.8 Producer–Consumer
- 8.9 Read-Write Lock
- 8.10 Double-Checked Locking
- 8.11 Balking Pattern
- 8.12 Scheduler Pattern
- 8.13 Barrier Pattern

### 9. Architectural Patterns (Overview)
- 9.1 Model-View-Controller (MVC)
- 9.2 Model-View-Presenter (MVP)
- 9.3 Model-View-ViewModel (MVVM)
- 9.4 Clean Architecture
- 9.5 Hexagonal Architecture (Ports & Adapters)
- 9.6 Onion Architecture
- 9.7 Pipe and Filter
- 9.8 Layered (N-Tier) Architecture
- 9.9 Event-Driven Architecture (EDA)
- 9.10 Space-Based Architecture
- 9.11 Microkernel (Plugin) Architecture
- 9.12 Blackboard Pattern
- 9.13 Service-Oriented Architecture (SOA)
- 9.14 Broker Pattern

---

## Part III: Domain-Driven Design (DDD)

### 10. Strategic Domain-Driven Design
- 10.1 What Is Domain-Driven Design?
- 10.2 Ubiquitous Language
  - 10.2.1 Building a Shared Vocabulary
  - 10.2.2 Enforcing Language in Code
- 10.3 Bounded Contexts
  - 10.3.1 Defining Context Boundaries
  - 10.3.2 Context Mapping Patterns
    - 10.3.2.1 Shared Kernel
    - 10.3.2.2 Customer-Supplier
    - 10.3.2.3 Conformist
    - 10.3.2.4 Anti-Corruption Layer (ACL)
    - 10.3.2.5 Open Host Service
    - 10.3.2.6 Published Language
    - 10.3.2.7 Separate Ways
    - 10.3.2.8 Partnership
  - 10.3.3 Context Maps & Visualization
- 10.4 Subdomains
  - 10.4.1 Core Domain
  - 10.4.2 Supporting Subdomain
  - 10.4.3 Generic Subdomain
- 10.5 Distillation of the Core Domain
- 10.6 Large-Scale Structure

### 11. Tactical Domain-Driven Design
- 11.1 Entities
  - 11.1.1 Identity and Equality
  - 11.1.2 Entity Lifecycle
- 11.2 Value Objects
  - 11.2.1 Immutability
  - 11.2.2 Equality by Value
  - 11.2.3 When to Use Value Objects
- 11.3 Aggregates
  - 11.3.1 Aggregate Root
  - 11.3.2 Aggregate Boundaries and Invariants
  - 11.3.3 Designing Small Aggregates
  - 11.3.4 Referencing Other Aggregates by ID
  - 11.3.5 Eventual Consistency Between Aggregates
- 11.4 Domain Events
  - 11.4.1 Identifying Domain Events
  - 11.4.2 Publishing and Handling Events
  - 11.4.3 Event Storming (Workshop Technique)
- 11.5 Repositories
  - 11.5.1 Collection-Oriented Repositories
  - 11.5.2 Persistence-Oriented Repositories
  - 11.5.3 Repository Interfaces vs. Implementations
- 11.6 Domain Services
- 11.7 Application Services
- 11.8 Factories in DDD
- 11.9 Modules / Packages
- 11.10 Specifications
- 11.11 Domain Model Integrity Patterns

---

## Part IV: System Architecture & High-Level Design

### 12. Monolithic Architecture
- 12.1 Characteristics of a Monolith
- 12.2 Modular Monolith
  - 12.2.1 Module Boundaries
  - 12.2.2 Internal APIs
  - 12.2.3 Enforcing Modularity
- 12.3 Advantages and Disadvantages
- 12.4 When to Choose a Monolith
- 12.5 Strategies for Scaling a Monolith
- 12.6 Decomposing a Monolith (Migration Strategies)

### 13. Microservices Architecture
- 13.1 Microservices Principles and Characteristics
- 13.2 Service Decomposition Strategies
  - 13.2.1 Decompose by Business Capability
  - 13.2.2 Decompose by Subdomain (DDD)
  - 13.2.3 Strangler Fig Pattern
  - 13.2.4 Branch by Abstraction
- 13.3 Service Communication
  - 13.3.1 Synchronous Communication
    - 13.3.1.1 REST
    - 13.3.1.2 gRPC
    - 13.3.1.3 GraphQL
  - 13.3.2 Asynchronous Communication
    - 13.3.2.1 Message Queues (RabbitMQ, SQS)
    - 13.3.2.2 Event Streaming (Kafka, Pulsar)
    - 13.3.2.3 Pub/Sub Patterns
  - 13.3.3 Hybrid Communication
- 13.4 Service Discovery
  - 13.4.1 Client-Side Discovery
  - 13.4.2 Server-Side Discovery
  - 13.4.3 Service Registry (Consul, Eureka, etcd)
  - 13.4.4 DNS-Based Discovery
- 13.5 API Gateway Pattern
  - 13.5.1 Routing and Composition
  - 13.5.2 Rate Limiting, Throttling
  - 13.5.3 Authentication at the Gateway
  - 13.5.4 Backend for Frontend (BFF)
  - 13.5.5 API Gateway Tools (Kong, Envoy, AWS API Gateway)
- 13.6 Data Management in Microservices
  - 13.6.1 Database per Service
  - 13.6.2 Shared Database (Anti-Pattern?)
  - 13.6.3 Saga Pattern for Distributed Transactions
    - 13.6.3.1 Choreography-Based Saga
    - 13.6.3.2 Orchestration-Based Saga
  - 13.6.4 CQRS (Command Query Responsibility Segregation)
  - 13.6.5 Event Sourcing
  - 13.6.6 Outbox Pattern
  - 13.6.7 Change Data Capture (CDC)
- 13.7 Microservices Resilience Patterns
  - 13.7.1 Circuit Breaker
  - 13.7.2 Bulkhead
  - 13.7.3 Retry with Exponential Backoff
  - 13.7.4 Timeout Pattern
  - 13.7.5 Fallback
  - 13.7.6 Sidecar Pattern
- 13.8 Microservices Observability
  - 13.8.1 Distributed Tracing (Jaeger, Zipkin)
  - 13.8.2 Centralized Logging (ELK/EFK Stack)
  - 13.8.3 Metrics and Monitoring (Prometheus, Grafana)
  - 13.8.4 Health Checks
  - 13.8.5 Correlation IDs
- 13.9 Service Mesh
  - 13.9.1 What Is a Service Mesh?
  - 13.9.2 Sidecar Proxy Architecture
  - 13.9.3 Istio, Linkerd, Consul Connect
  - 13.9.4 mTLS, Traffic Shaping, Observability
- 13.10 Microservices Testing Strategies
  - 13.10.1 Unit Testing Services
  - 13.10.2 Contract Testing (Pact)
  - 13.10.3 Integration Testing
  - 13.10.4 End-to-End Testing
  - 13.10.5 Chaos Testing
- 13.11 Microservices Anti-Patterns
  - 13.11.1 Distributed Monolith
  - 13.11.2 Nano-Services (Too Fine-Grained)
  - 13.11.3 Shared Libraries Coupling
  - 13.11.4 Data Coupling via Shared Database

### 14. Event-Driven Architecture (EDA) — Deep Dive
- 14.1 Core Concepts of EDA
- 14.2 Event Types
  - 14.2.1 Domain Events
  - 14.2.2 Integration Events
  - 14.2.3 Notification Events
  - 14.2.4 Event-Carried State Transfer
- 14.3 Event Brokers and Streaming Platforms
  - 14.3.1 Apache Kafka (Architecture Deep Dive)
  - 14.3.2 Apache Pulsar
  - 14.3.3 AWS EventBridge / SNS / SQS
  - 14.3.4 RabbitMQ
  - 14.3.5 NATS
  - 14.3.6 Redis Streams
- 14.4 Event Sourcing
  - 14.4.1 Event Store Design
  - 14.4.2 Projections and Read Models
  - 14.4.3 Snapshotting
  - 14.4.4 Event Versioning and Upcasting
  - 14.4.5 Tombstone Events and Deletion
  - 14.4.6 Benefits and Challenges
- 14.5 CQRS (Deep Dive)
  - 14.5.1 Separating Read and Write Models
  - 14.5.2 Synchronization Strategies
  - 14.5.3 CQRS + Event Sourcing Combined
  - 14.5.4 When to Use CQRS
- 14.6 Choreography vs. Orchestration
- 14.7 Event Schema Management
  - 14.7.1 Schema Registry (Confluent, Apicurio)
  - 14.7.2 Schema Evolution (Avro, Protobuf, JSON Schema)
  - 14.7.3 Backward and Forward Compatibility
- 14.8 Idempotency in Event Processing
- 14.9 Ordering Guarantees
- 14.10 Exactly-Once Semantics
- 14.11 Dead Letter Queues (DLQ)

### 15. Serverless Architecture
- 15.1 What Is Serverless?
- 15.2 Function-as-a-Service (FaaS)
  - 15.2.1 AWS Lambda
  - 15.2.2 Azure Functions
  - 15.2.3 Google Cloud Functions
  - 15.2.4 Cloudflare Workers
- 15.3 Backend-as-a-Service (BaaS)
- 15.4 Cold Starts and Warm-Up Strategies
- 15.5 Serverless Design Patterns
  - 15.5.1 Event-Driven Functions
  - 15.5.2 Function Chaining / Orchestration (Step Functions)
  - 15.5.3 Fan-Out / Fan-In
  - 15.5.4 Throttling and Concurrency Control
- 15.6 Serverless Data Stores
- 15.7 Cost Model and Optimization
- 15.8 Limitations and When Not to Use Serverless
- 15.9 Serverless Frameworks (Serverless Framework, SAM, SST)

---

## Part V: Data System Design

### 16. Database Design Fundamentals
- 16.1 Relational Database Design
  - 16.1.1 Entity-Relationship (ER) Modeling
  - 16.1.2 Normalization (1NF through 5NF, BCNF)
  - 16.1.3 Denormalization Trade-Offs
  - 16.1.4 Indexing Strategies
    - 16.1.4.1 B-Tree Indexes
    - 16.1.4.2 Hash Indexes
    - 16.1.4.3 Bitmap Indexes
    - 16.1.4.4 Full-Text Indexes
    - 16.1.4.5 Composite / Covering Indexes
    - 16.1.4.6 Partial Indexes
  - 16.1.5 Query Optimization and Execution Plans
  - 16.1.6 Stored Procedures, Triggers, Views
  - 16.1.7 ACID Properties (Deep Dive)
  - 16.1.8 Transaction Isolation Levels
    - 16.1.8.1 Read Uncommitted
    - 16.1.8.2 Read Committed
    - 16.1.8.3 Repeatable Read
    - 16.1.8.4 Serializable
    - 16.1.8.5 Snapshot Isolation
  - 16.1.9 Locking Strategies (Pessimistic vs. Optimistic)
  - 16.1.10 Connection Pooling
- 16.2 NoSQL Database Design
  - 16.2.1 Document Stores (MongoDB, CouchDB)
    - 16.2.1.1 Schema Design Patterns
    - 16.2.1.2 Embedding vs. Referencing
    - 16.2.1.3 Indexing in Document Databases
  - 16.2.2 Key-Value Stores (Redis, DynamoDB, Riak)
    - 16.2.2.1 Data Modeling in Key-Value Stores
    - 16.2.2.2 TTL and Expiration
  - 16.2.3 Wide-Column Stores (Cassandra, HBase, ScyllaDB)
    - 16.2.3.1 Partition Keys and Clustering Keys
    - 16.2.3.2 Data Modeling Best Practices
    - 16.2.3.3 Compaction Strategies
  - 16.2.4 Graph Databases (Neo4j, Amazon Neptune, JanusGraph)
    - 16.2.4.1 Graph Modeling (Nodes, Edges, Properties)
    - 16.2.4.2 Traversal Queries (Cypher, Gremlin)
    - 16.2.4.3 Use Cases (Social Graphs, Fraud Detection)
  - 16.2.5 Time-Series Databases (InfluxDB, TimescaleDB, QuestDB)
  - 16.2.6 Vector Databases (Pinecone, Weaviate, Milvus, pgvector)
- 16.3 NewSQL Databases (CockroachDB, TiDB, Spanner, YugabyteDB)
- 16.4 Choosing the Right Database
  - 16.4.1 CAP Theorem (Deep Dive)
  - 16.4.2 PACELC Theorem
  - 16.4.3 Decision Matrix
  - 16.4.4 Polyglot Persistence

### 17. Data Partitioning and Sharding
- 17.1 Why Partition Data?
- 17.2 Horizontal Partitioning (Sharding)
  - 17.2.1 Range-Based Sharding
  - 17.2.2 Hash-Based Sharding
  - 17.2.3 Directory-Based Sharding
  - 17.2.4 Geographic Sharding
- 17.3 Vertical Partitioning
- 17.4 Functional Partitioning
- 17.5 Consistent Hashing
  - 17.5.1 Hash Ring
  - 17.5.2 Virtual Nodes
  - 17.5.3 Rebalancing
- 17.6 Hotspot Handling
- 17.7 Cross-Shard Queries and Joins
- 17.8 Resharding Strategies

### 18. Data Replication
- 18.1 Purpose of Replication
- 18.2 Single-Leader Replication
  - 18.2.1 Synchronous vs. Asynchronous Replication
  - 18.2.2 Replication Lag
  - 18.2.3 Read-After-Write Consistency
  - 18.2.4 Monotonic Reads
- 18.3 Multi-Leader Replication
  - 18.3.1 Conflict Detection and Resolution
  - 18.3.2 Last-Write-Wins (LWW)
  - 18.3.3 Merge Strategies
- 18.4 Leaderless Replication
  - 18.4.1 Quorum Reads and Writes ($W + R > N$)
  - 18.4.2 Sloppy Quorums and Hinted Handoff
  - 18.4.3 Anti-Entropy and Merkle Trees
  - 18.4.4 CRDTs (Conflict-Free Replicated Data Types)
- 18.5 Chain Replication
- 18.6 Replication Topologies
  - 18.6.1 Star
  - 18.6.2 Circular
  - 18.6.3 All-to-All

### 19. Caching Strategies
- 19.1 Why Caching Matters
- 19.2 Cache Types
  - 19.2.1 Client-Side Cache
  - 19.2.2 CDN Cache
  - 19.2.3 Application-Level Cache
  - 19.2.4 Database Query Cache
  - 19.2.5 Distributed Cache
- 19.3 Caching Patterns
  - 19.3.1 Cache-Aside (Lazy Loading)
  - 19.3.2 Read-Through
  - 19.3.3 Write-Through
  - 19.3.4 Write-Behind (Write-Back)
  - 19.3.5 Refresh-Ahead
- 19.4 Cache Eviction Policies
  - 19.4.1 LRU (Least Recently Used)
  - 19.4.2 LFU (Least Frequently Used)
  - 19.4.3 FIFO
  - 19.4.4 TTL-Based Eviction
  - 19.4.5 Random Eviction
- 19.5 Cache Invalidation Strategies
  - 19.5.1 Time-Based Invalidation
  - 19.5.2 Event-Based Invalidation
  - 19.5.3 Version-Based Invalidation
- 19.6 Cache Consistency Challenges
  - 19.6.1 Cache Stampede / Thundering Herd
  - 19.6.2 Cache Penetration
  - 19.6.3 Cache Avalanche
  - 19.6.4 Hot Key Problem
- 19.7 Caching Technologies
  - 19.7.1 Redis (Data Structures, Clusters, Sentinel)
  - 19.7.2 Memcached
  - 19.7.3 Hazelcast
  - 19.7.4 Application-Level (Caffeine, Guava)
- 19.8 Multi-Level Caching (L1/L2)
- 19.9 Cache Warming

### 20. Search Systems Design
- 20.1 Full-Text Search Architecture
- 20.2 Inverted Index
- 20.3 Tokenization, Stemming, Lemmatization
- 20.4 Relevance Scoring (TF-IDF, BM25)
- 20.5 Elasticsearch / OpenSearch Architecture
  - 20.5.1 Indices, Shards, Replicas
  - 20.5.2 Mappings and Analyzers
  - 20.5.3 Query DSL
  - 20.5.4 Aggregations
- 20.6 Solr
- 20.7 Search Indexing Pipelines
- 20.8 Autocomplete and Typeahead Design
- 20.9 Faceted Search
- 20.10 Geo-Spatial Search
- 20.11 Semantic / Vector Search
- 20.12 Search Ranking and Personalization

---

## Part VI: Distributed Systems Concepts

### 21. Fundamentals of Distributed Systems
- 21.1 What Is a Distributed System?
- 21.2 Characteristics and Challenges
  - 21.2.1 Network Is Unreliable
  - 21.2.2 Latency Is Non-Zero
  - 21.2.3 Bandwidth Is Finite
  - 21.2.4 Topology Changes
- 21.3 Fallacies of Distributed Computing (All 8)
- 21.4 Types of Failures
  - 21.4.1 Crash Failures
  - 21.4.2 Omission Failures
  - 21.4.3 Timing Failures
  - 21.4.4 Byzantine Failures
- 21.5 Failure Detection
  - 21.5.1 Heartbeats
  - 21.5.2 Phi Accrual Failure Detector
  - 21.5.3 Gossip-Based Detection

### 22. Consistency Models
- 22.1 Strong Consistency
- 22.2 Eventual Consistency
- 22.3 Causal Consistency
- 22.4 Sequential Consistency
- 22.5 Linearizability
- 22.6 Read-Your-Writes Consistency
- 22.7 Monotonic Read Consistency
- 22.8 Session Consistency
- 22.9 Tunable Consistency
- 22.10 Consistency in Practice: Real-World Trade-Offs

### 23. Consensus Algorithms
- 23.1 The Consensus Problem
- 23.2 FLP Impossibility Result
- 23.3 Paxos
  - 23.3.1 Basic Paxos
  - 23.3.2 Multi-Paxos
  - 23.3.3 Fast Paxos
- 23.4 Raft
  - 23.4.1 Leader Election
  - 23.4.2 Log Replication
  - 23.4.3 Safety and Liveness
  - 23.4.4 Membership Changes
- 23.5 Zab (ZooKeeper Atomic Broadcast)
- 23.6 Viewstamped Replication
- 23.7 Byzantine Fault Tolerance (BFT)
  - 23.7.1 PBFT
  - 23.7.2 Blockchain Consensus (PoW, PoS)
- 23.8 Comparison of Consensus Algorithms

### 24. Distributed Coordination
- 24.1 Distributed Locks
  - 24.1.1 Lock Services (ZooKeeper, etcd)
  - 24.1.2 Redlock Algorithm
  - 24.1.3 Fencing Tokens
- 24.2 Leader Election
  - 24.2.1 Bully Algorithm
  - 24.2.2 Ring-Based Election
  - 24.2.3 Using ZooKeeper/etcd for Election
- 24.3 Distributed Configuration Management
- 24.4 Distributed Scheduling
- 24.5 Barrier Synchronization
- 24.6 Clock Synchronization
  - 24.6.1 Physical Clocks (NTP, PTP)
  - 24.6.2 Logical Clocks (Lamport Timestamps)
  - 24.6.3 Vector Clocks
  - 24.6.4 Hybrid Logical Clocks (HLC)
  - 24.6.5 TrueTime (Google Spanner)

### 25. Distributed Transactions
- 25.1 Two-Phase Commit (2PC)
  - 25.1.1 Prepare Phase
  - 25.1.2 Commit Phase
  - 25.1.3 Failure Scenarios
  - 25.1.4 Blocking Problem
- 25.2 Three-Phase Commit (3PC)
- 25.3 Saga Pattern (Revisited in Detail)
  - 25.3.1 Compensating Transactions
  - 25.3.2 Saga Execution Coordinator
  - 25.3.3 Error Handling and Rollback
- 25.4 TCC (Try-Confirm-Cancel)
- 25.5 AT (Automatic Transaction) — Seata
- 25.6 Transactional Outbox Pattern
- 25.7 Idempotency Keys

---

## Part VII: Scalability & Performance

### 26. Scalability Fundamentals
- 26.1 Defining Scalability
- 26.2 Vertical Scaling vs. Horizontal Scaling
- 26.3 Scaling Dimensions (AKF Scale Cube)
  - 26.3.1 X-Axis: Horizontal Duplication
  - 26.3.2 Y-Axis: Functional Decomposition
  - 26.3.3 Z-Axis: Data Partitioning
- 26.4 Stateless vs. Stateful Services
- 26.5 Elasticity and Auto-Scaling
- 26.6 Amdahl's Law and Universal Scalability Law
- 26.7 Identifying Bottlenecks
- 26.8 Back-of-the-Envelope Estimation
  - 26.8.1 Latency Numbers Every Programmer Should Know
  - 26.8.2 Throughput Estimation
  - 26.8.3 Storage Estimation
  - 26.8.4 Bandwidth Estimation
  - 26.8.5 QPS (Queries Per Second) Calculations

### 27. Load Balancing
- 27.1 What Is Load Balancing?
- 27.2 Load Balancing Algorithms
  - 27.2.1 Round Robin
  - 27.2.2 Weighted Round Robin
  - 27.2.3 Least Connections
  - 27.2.4 Least Response Time
  - 27.2.5 IP Hash
  - 27.2.6 Consistent Hashing
  - 27.2.7 Random
  - 27.2.8 Power of Two Choices
- 27.3 Layer 4 vs. Layer 7 Load Balancing
- 27.4 Hardware vs. Software Load Balancers
- 27.5 Load Balancer Technologies
  - 27.5.1 NGINX
  - 27.5.2 HAProxy
  - 27.5.3 Envoy
  - 27.5.4 AWS ELB/ALB/NLB
  - 27.5.5 Google Cloud Load Balancer
- 27.6 Global Server Load Balancing (GSLB)
- 27.7 Health Checks and Failover
- 27.8 Session Affinity / Sticky Sessions
- 27.9 Load Balancing in Microservices (Client-Side)

### 28. Content Delivery Networks (CDNs)
- 28.1 How CDNs Work
- 28.2 Push vs. Pull CDNs
- 28.3 CDN Architecture (Edge, Origin, Shield)
- 28.4 Cache-Control Headers
- 28.5 CDN Invalidation
- 28.6 Edge Computing
- 28.7 CDN Providers (Cloudflare, Akamai, AWS CloudFront, Fastly)
- 28.8 Dynamic Content Acceleration

### 29. Asynchronous Processing & Queuing
- 29.1 Why Asynchronous Processing?
- 29.2 Message Queue Fundamentals
  - 29.2.1 Point-to-Point vs. Publish-Subscribe
  - 29.2.2 At-Most-Once / At-Least-Once / Exactly-Once Delivery
  - 29.2.3 Message Ordering
  - 29.2.4 Message Deduplication
  - 29.2.5 Poison Messages and Dead Letter Queues
- 29.3 Message Queue Technologies
  - 29.3.1 RabbitMQ (AMQP)
  - 29.3.2 Apache Kafka
  - 29.3.3 Amazon SQS
  - 29.3.4 Apache ActiveMQ / Artemis
  - 29.3.5 NATS / NATS JetStream
  - 29.3.6 Azure Service Bus
  - 29.3.7 Google Pub/Sub
- 29.4 Task Queues and Worker Systems
  - 29.4.1 Celery
  - 29.4.2 Sidekiq
  - 29.4.3 Bull / BullMQ
- 29.5 Priority Queues
- 29.6 Delayed / Scheduled Messages
- 29.7 Backpressure Handling
- 29.8 Queue-Based Load Leveling

### 30. Performance Optimization
- 30.1 Performance Metrics
  - 30.1.1 Latency (P50, P95, P99, P99.9)
  - 30.1.2 Throughput (RPS, TPS)
  - 30.1.3 Bandwidth
  - 30.1.4 Error Rate
  - 30.1.5 Saturation
- 30.2 Profiling and Benchmarking
- 30.3 Application-Level Optimization
  - 30.3.1 Algorithmic Optimization
  - 30.3.2 Data Structure Selection
  - 30.3.3 Connection Pooling
  - 30.3.4 Batch Processing
  - 30.3.5 Lazy Loading vs. Eager Loading
  - 30.3.6 Object Pooling
- 30.4 Database Performance Optimization
  - 30.4.1 Query Optimization
  - 30.4.2 Index Tuning
  - 30.4.3 Read Replicas
  - 30.4.4 Materialized Views
  - 30.4.5 Database Sharding
  - 30.4.6 Connection Pool Tuning
- 30.5 Network Optimization
  - 30.5.1 Compression (gzip, Brotli, zstd)
  - 30.5.2 Connection Keep-Alive
  - 30.5.3 HTTP/2 and HTTP/3 (QUIC)
  - 30.5.4 Connection Multiplexing
  - 30.5.5 Protocol Buffers / FlatBuffers
- 30.6 Concurrency and Parallelism
  - 30.6.1 Multi-Threading
  - 30.6.2 Async I/O (Event Loop, Coroutines)
  - 30.6.3 Non-Blocking I/O
  - 30.6.4 Thread-Per-Request vs. Event-Driven
  - 30.6.5 Green Threads / Virtual Threads
- 30.7 Memory Management and Garbage Collection Tuning

### 31. Rate Limiting & Throttling
- 31.1 Why Rate Limiting?
- 31.2 Rate Limiting Algorithms
  - 31.2.1 Token Bucket
  - 31.2.2 Leaky Bucket
  - 31.2.3 Fixed Window Counter
  - 31.2.4 Sliding Window Log
  - 31.2.5 Sliding Window Counter
- 31.3 Rate Limiting Levels
  - 31.3.1 Per-User / Per-API-Key
  - 31.3.2 Per-IP
  - 31.3.3 Per-Service
  - 31.3.4 Global
- 31.4 Distributed Rate Limiting
- 31.5 Rate Limiting with Redis
- 31.6 HTTP 429 and Retry-After Headers
- 31.7 Graceful Degradation Under Load

---

## Part VIII: API Design

### 32. RESTful API Design
- 32.1 REST Principles and Constraints
  - 32.1.1 Client-Server
  - 32.1.2 Statelessness
  - 32.1.3 Cacheability
  - 32.1.4 Uniform Interface
  - 32.1.5 Layered System
  - 32.1.6 Code on Demand (Optional)
- 32.2 Resource Naming Conventions
- 32.3 HTTP Methods and Semantics
- 32.4 Status Codes (Proper Usage)
- 32.5 Request/Response Body Design
- 32.6 Pagination Strategies
  - 32.6.1 Offset-Based
  - 32.6.2 Cursor-Based (Keyset)
  - 32.6.3 Page-Based
- 32.7 Filtering, Sorting, and Field Selection
- 32.8 HATEOAS
- 32.9 Versioning Strategies
  - 32.9.1 URL Path Versioning
  - 32.9.2 Query Parameter Versioning
  - 32.9.3 Header Versioning
  - 32.9.4 Content Negotiation
- 32.10 Idempotency in APIs
- 32.11 Bulk / Batch Operations
- 32.12 Long-Running Operations
- 32.13 Error Handling and Problem Details (RFC 7807)
- 32.14 OpenAPI / Swagger Specification

### 33. GraphQL API Design
- 33.1 GraphQL Fundamentals
- 33.2 Schema Definition Language (SDL)
- 33.3 Queries, Mutations, Subscriptions
- 33.4 Resolvers and Data Loaders
- 33.5 N+1 Problem and Batching
- 33.6 Pagination (Relay Specification)
- 33.7 Authentication and Authorization in GraphQL
- 33.8 Schema Stitching and Federation
- 33.9 Caching Challenges
- 33.10 Persisted Queries
- 33.11 Rate Limiting and Query Complexity Analysis
- 33.12 GraphQL vs. REST: When to Choose What

### 34. gRPC & Protocol Buffers
- 34.1 What Is gRPC?
- 34.2 Protocol Buffers (Protobuf)
  - 34.2.1 Message Definitions
  - 34.2.2 Scalar Types
  - 34.2.3 Nested Messages
  - 34.2.4 Enums
  - 34.2.5 Field Rules (Optional, Repeated, Map)
- 34.3 Service Definitions
- 34.4 Communication Patterns
  - 34.4.1 Unary RPC
  - 34.4.2 Server Streaming RPC
  - 34.4.3 Client Streaming RPC
  - 34.4.4 Bidirectional Streaming RPC
- 34.5 gRPC Interceptors (Middleware)
- 34.6 Load Balancing for gRPC
- 34.7 Error Handling
- 34.8 Deadlines and Timeouts
- 34.9 gRPC-Web for Browser Clients
- 34.10 gRPC vs. REST vs. GraphQL Comparison

### 35. WebSocket & Real-Time APIs
- 35.1 WebSocket Protocol
- 35.2 Server-Sent Events (SSE)
- 35.3 Long Polling
- 35.4 WebRTC (Peer-to-Peer)
- 35.5 Socket.IO
- 35.6 Designing Real-Time APIs
- 35.7 Scaling WebSocket Connections
- 35.8 Pub/Sub for Real-Time Delivery
- 35.9 Presence Detection
- 35.10 Connection Management and Reconnection

### 36. API Security
- 36.1 Authentication Mechanisms
  - 36.1.1 API Keys
  - 36.1.2 OAuth 2.0 Flows
    - 36.1.2.1 Authorization Code Flow (+ PKCE)
    - 36.1.2.2 Client Credentials Flow
    - 36.1.2.3 Implicit Flow (Deprecated)
    - 36.1.2.4 Resource Owner Password Flow
  - 36.1.3 OpenID Connect (OIDC)
  - 36.1.4 JWT (JSON Web Tokens)
    - 36.1.4.1 Structure (Header, Payload, Signature)
    - 36.1.4.2 Access Tokens vs. Refresh Tokens
    - 36.1.4.3 Token Revocation Strategies
  - 36.1.5 mTLS (Mutual TLS)
  - 36.1.6 HMAC-Based Authentication
- 36.2 Authorization
  - 36.2.1 RBAC (Role-Based Access Control)
  - 36.2.2 ABAC (Attribute-Based Access Control)
  - 36.2.3 ReBAC (Relationship-Based Access Control)
  - 36.2.4 Policy Engines (OPA, Casbin, Cedar)
  - 36.2.5 Scopes and Permissions
- 36.3 API Security Best Practices
  - 36.3.1 Input Validation
  - 36.3.2 Output Encoding
  - 36.3.3 CORS Configuration
  - 36.3.4 Rate Limiting (Security Perspective)
  - 36.3.5 Request Signing
  - 36.3.6 Encryption in Transit (TLS)
  - 36.3.7 Encryption at Rest

### 37. API Governance & Management
- 37.1 API Design Guidelines and Style Guides
- 37.2 API Lifecycle Management
- 37.3 Deprecation Strategies
- 37.4 API Documentation (Swagger UI, Redoc)
- 37.5 API Testing (Postman, Insomnia)
- 37.6 API Monitoring and Analytics
- 37.7 API Gateways (Revisited)
- 37.8 Developer Portal and Experience (DX)
- 37.9 Contract-First vs. Code-First Design
- 37.10 API Mocking and Virtualization

---

## Part IX: Reliability & Resilience

### 38. Reliability Engineering
- 38.1 Defining Reliability, Availability, Durability
- 38.2 Service Level Indicators (SLIs)
- 38.3 Service Level Objectives (SLOs)
- 38.4 Service Level Agreements (SLAs)
- 38.5 Error Budgets
- 38.6 Calculating Availability ($\text{nines}$ of availability)
  - 38.6.1 99.9% vs. 99.99% vs. 99.999%
  - 38.6.2 Composite System Availability
- 38.7 Mean Time to Failure (MTTF)
- 38.8 Mean Time to Recovery (MTTR)
- 38.9 Mean Time Between Failures (MTBF)
- 38.10 Toil Reduction

### 39. Fault Tolerance & High Availability
- 39.1 Redundancy
  - 39.1.1 Active-Active
  - 39.1.2 Active-Passive (Standby)
  - 39.1.3 N+1 Redundancy
  - 39.1.4 Geographic Redundancy
- 39.2 Failover Strategies
  - 39.2.1 Cold Failover
  - 39.2.2 Warm Failover
  - 39.2.3 Hot Failover
- 39.3 Replication for HA
- 39.4 Quorum-Based Systems
- 39.5 Split-Brain Problem and Resolution
- 39.6 Graceful Degradation
- 39.7 Circuit Breaker (Deep Dive)
  - 39.7.1 States: Closed, Open, Half-Open
  - 39.7.2 Thresholds and Timeouts
  - 39.7.3 Implementation Libraries (Resilience4j, Hystrix)
- 39.8 Bulkhead Pattern (Deep Dive)
- 39.9 Retry Strategies
  - 39.9.1 Simple Retry
  - 39.9.2 Exponential Backoff
  - 39.9.3 Jitter
  - 39.9.4 Max Retries
- 39.10 Timeout Design
- 39.11 Idempotency for Resilience
- 39.12 Self-Healing Systems

### 40. Disaster Recovery
- 40.1 Disaster Recovery Planning
- 40.2 Recovery Point Objective (RPO)
- 40.3 Recovery Time Objective (RTO)
- 40.4 Backup Strategies
  - 40.4.1 Full Backups
  - 40.4.2 Incremental Backups
  - 40.4.3 Differential Backups
  - 40.4.4 Snapshot-Based Backups
- 40.5 Disaster Recovery Strategies
  - 40.5.1 Backup and Restore
  - 40.5.2 Pilot Light
  - 40.5.3 Warm Standby
  - 40.5.4 Multi-Site Active-Active
- 40.6 Data Center Failure Scenarios
- 40.7 Cross-Region Replication
- 40.8 Disaster Recovery Testing
- 40.9 Runbooks and Playbooks

### 41. Chaos Engineering
- 41.1 Principles of Chaos Engineering
- 41.2 Steady-State Hypothesis
- 41.3 Experiment Design
- 41.4 Blast Radius Control
- 41.5 Chaos Engineering Tools
  - 41.5.1 Chaos Monkey (Netflix)
  - 41.5.2 Gremlin
  - 41.5.3 Litmus Chaos
  - 41.5.4 Chaos Mesh
  - 41.5.5 AWS Fault Injection Simulator
- 41.6 Game Days
- 41.7 Chaos in Production vs. Staging

---

## Part X: Security in System Design

### 42. Security Architecture
- 42.1 Security Design Principles
  - 42.1.1 Defense in Depth
  - 42.1.2 Principle of Least Privilege
  - 42.1.3 Zero Trust Architecture
  - 42.1.4 Fail Secure
  - 42.1.5 Security by Design
- 42.2 Threat Modeling
  - 42.2.1 STRIDE Framework
  - 42.2.2 DREAD Risk Assessment
  - 42.2.3 Attack Trees
  - 42.2.4 Data Flow Diagrams for Security
- 42.3 Network Security
  - 42.3.1 Firewalls and Security Groups
  - 42.3.2 VPNs and Private Networks
  - 42.3.3 DDoS Protection
  - 42.3.4 Web Application Firewalls (WAF)
  - 42.3.5 Network Segmentation
- 42.4 Application Security
  - 42.4.1 OWASP Top 10
  - 42.4.2 SQL Injection Prevention
  - 42.4.3 XSS (Cross-Site Scripting) Prevention
  - 42.4.4 CSRF Protection
  - 42.4.5 SSRF Prevention
  - 42.4.6 Injection Attacks (Command, LDAP, etc.)
  - 42.4.7 Secure Deserialization
  - 42.4.8 Content Security Policy (CSP)
- 42.5 Data Security
  - 42.5.1 Encryption at Rest
  - 42.5.2 Encryption in Transit (TLS 1.3)
  - 42.5.3 Key Management (KMS, Vault)
  - 42.5.4 Secrets Management (HashiCorp Vault, AWS Secrets Manager)
  - 42.5.5 Data Masking and Tokenization
  - 42.5.6 PII Handling
- 42.6 Identity and Access Management (IAM)
  - 42.6.1 Single Sign-On (SSO)
  - 42.6.2 Multi-Factor Authentication (MFA)
  - 42.6.3 Directory Services (LDAP, AD)
  - 42.6.4 Federated Identity
- 42.7 Audit Logging and Compliance
  - 42.7.1 Audit Trail Design
  - 42.7.2 Tamper-Proof Logs
  - 42.7.3 GDPR, HIPAA, SOC2, PCI-DSS Considerations
- 42.8 Security Testing
  - 42.8.1 SAST (Static Application Security Testing)
  - 42.8.2 DAST (Dynamic Application Security Testing)
  - 42.8.3 Penetration Testing
  - 42.8.4 Dependency Scanning (SCA)
  - 42.8.5 Bug Bounty Programs

---

## Part XI: Infrastructure & Deployment

### 43. Cloud Computing Fundamentals
- 43.1 Cloud Service Models
  - 43.1.1 IaaS (Infrastructure as a Service)
  - 43.1.2 PaaS (Platform as a Service)
  - 43.1.3 SaaS (Software as a Service)
  - 43.1.4 FaaS (Function as a Service)
  - 43.1.5 CaaS (Container as a Service)
- 43.2 Cloud Deployment Models
  - 43.2.1 Public Cloud
  - 43.2.2 Private Cloud
  - 43.2.3 Hybrid Cloud
  - 43.2.4 Multi-Cloud
- 43.3 AWS Architecture Overview
  - 43.3.1 Compute (EC2, ECS, EKS, Lambda, Fargate)
  - 43.3.2 Storage (S3, EBS, EFS, Glacier)
  - 43.3.3 Databases (RDS, DynamoDB, Aurora, ElastiCache, Redshift)
  - 43.3.4 Networking (VPC, Route 53, CloudFront, ELB)
  - 43.3.5 Messaging (SQS, SNS, EventBridge, Kinesis)
  - 43.3.6 Security (IAM, KMS, WAF, Shield)
- 43.4 Azure Architecture Overview
- 43.5 Google Cloud Architecture Overview
- 43.6 Cloud-Native Design Principles
  - 43.6.1 12-Factor App Methodology
  - 43.6.2 Beyond the 12 Factors (15-Factor)
- 43.7 Well-Architected Frameworks
  - 43.7.1 Operational Excellence
  - 43.7.2 Security
  - 43.7.3 Reliability
  - 43.7.4 Performance Efficiency
  - 43.7.5 Cost Optimization
  - 43.7.6 Sustainability

### 44. Containerization
- 44.1 Container Fundamentals
  - 44.1.1 Containers vs. Virtual Machines
  - 44.1.2 Linux Namespaces and Cgroups
  - 44.1.3 Container Images and Layers
- 44.2 Docker
  - 44.2.1 Dockerfile Best Practices
  - 44.2.2 Multi-Stage Builds
  - 44.2.3 Docker Compose
  - 44.2.4 Image Registries (Docker Hub, ECR, GCR, ACR)
  - 44.2.5 Image Security Scanning
- 44.3 Container Networking
- 44.4 Container Storage (Volumes, Bind Mounts)
- 44.5 Alternative Runtimes (containerd, CRI-O, Podman)

### 45. Container Orchestration (Kubernetes)
- 45.1 Kubernetes Architecture
  - 45.1.1 Control Plane (API Server, etcd, Scheduler, Controller Manager)
  - 45.1.2 Worker Nodes (Kubelet, Kube-Proxy, Container Runtime)
- 45.2 Core Concepts
  - 45.2.1 Pods
  - 45.2.2 ReplicaSets
  - 45.2.3 Deployments
  - 45.2.4 Services (ClusterIP, NodePort, LoadBalancer)
  - 45.2.5 Ingress and Ingress Controllers
  - 45.2.6 ConfigMaps and Secrets
  - 45.2.7 Namespaces
  - 45.2.8 Persistent Volumes and Claims
  - 45.2.9 StatefulSets
  - 45.2.10 DaemonSets
  - 45.2.11 Jobs and CronJobs
- 45.3 Advanced Kubernetes
  - 45.3.1 Horizontal Pod Autoscaler (HPA)
  - 45.3.2 Vertical Pod Autoscaler (VPA)
  - 45.3.3 Cluster Autoscaler
  - 45.3.4 Custom Resource Definitions (CRDs)
  - 45.3.5 Operators
  - 45.3.6 Helm Charts
  - 45.3.7 Kustomize
  - 45.3.8 Network Policies
  - 45.3.9 Pod Security Standards
  - 45.3.10 Resource Quotas and Limits
- 45.4 Managed Kubernetes (EKS, GKE, AKS)
- 45.5 Kubernetes Alternatives (Docker Swarm, Nomad)

### 46. CI/CD and Deployment Strategies
- 46.1 Continuous Integration (CI)
  - 46.1.1 Build Automation
  - 46.1.2 Automated Testing in CI
  - 46.1.3 Code Quality Gates
  - 46.1.4 Artifact Management
- 46.2 Continuous Delivery vs. Continuous Deployment
- 46.3 CI/CD Tools (Jenkins, GitHub Actions, GitLab CI, CircleCI, ArgoCD)
- 46.4 Deployment Strategies
  - 46.4.1 Rolling Deployment
  - 46.4.2 Blue-Green Deployment
  - 46.4.3 Canary Deployment
  - 46.4.4 A/B Testing Deployment
  - 46.4.5 Shadow Deployment (Traffic Mirroring)
  - 46.4.6 Feature Flags / Feature Toggles
    - 46.4.6.1 Release Toggles
    - 46.4.6.2 Experiment Toggles
    - 46.4.6.3 Ops Toggles
    - 46.4.6.4 Permission Toggles
  - 46.4.7 Dark Launches
- 46.5 GitOps
  - 46.5.1 Principles of GitOps
  - 46.5.2 ArgoCD
  - 46.5.3 Flux
- 46.6 Infrastructure as Code (IaC)
  - 46.6.1 Terraform
  - 46.6.2 AWS CloudFormation
  - 46.6.3 Pulumi
  - 46.6.4 Ansible, Chef, Puppet
  - 46.6.5 CDK (Cloud Development Kit)
- 46.7 Immutable Infrastructure
- 46.8 Configuration Management
- 46.9 Rollback Strategies

### 47. Observability
- 47.1 Three Pillars of Observability
  - 47.1.1 Logs
    - 47.1.1.1 Structured Logging
    - 47.1.1.2 Log Aggregation
    - 47.1.1.3 ELK Stack (Elasticsearch, Logstash, Kibana)
    - 47.1.1.4 EFK Stack (Fluentd variant)
    - 47.1.1.5 Loki + Grafana
  - 47.1.2 Metrics
    - 47.1.2.1 Counter, Gauge, Histogram, Summary
    - 47.1.2.2 Prometheus
    - 47.1.2.3 Grafana Dashboards
    - 47.1.2.4 StatsD + Graphite
    - 47.1.2.5 Datadog, New Relic
    - 47.1.2.6 RED Method (Rate, Errors, Duration)
    - 47.1.2.7 USE Method (Utilization, Saturation, Errors)
    - 47.1.2.8 Golden Signals (Latency, Traffic, Errors, Saturation)
  - 47.1.3 Traces
    - 47.1.3.1 Distributed Tracing Concepts
    - 47.1.3.2 OpenTelemetry
    - 47.1.3.3 Jaeger
    - 47.1.3.4 Zipkin
    - 47.1.3.5 AWS X-Ray
    - 47.1.3.6 Trace Context Propagation
- 47.2 Alerting
  - 47.2.1 Alert Design Principles
  - 47.2.2 Alert Fatigue
  - 47.2.3 PagerDuty, OpsGenie
  - 47.2.4 Runbook Automation
- 47.3 Synthetic Monitoring
- 47.4 Real User Monitoring (RUM)
- 47.5 Service Level Monitoring
- 47.6 Observability-Driven Development

---

## Part XII: Data Engineering & Analytics in System Design

### 48. Data Pipelines
- 48.1 Batch Processing
  - 48.1.1 MapReduce Paradigm
  - 48.1.2 Apache Hadoop Ecosystem
  - 48.1.3 Apache Spark
  - 48.1.4 ETL vs. ELT
- 48.2 Stream Processing
  - 48.2.1 Apache Kafka Streams
  - 48.2.2 Apache Flink
  - 48.2.3 Apache Storm
  - 48.2.4 Apache Beam
  - 48.2.5 Windowing (Tumbling, Sliding, Session)
  - 48.2.6 Watermarks and Late Data
  - 48.2.7 Exactly-Once Processing in Streams
- 48.3 Lambda Architecture
- 48.4 Kappa Architecture
- 48.5 Data Lake Architecture
  - 48.5.1 Data Lake vs. Data Warehouse
  - 48.5.2 Data Lakehouse (Delta Lake, Apache Iceberg, Apache Hudi)
- 48.6 Data Mesh
  - 48.6.1 Domain Ownership
  - 48.6.2 Data as a Product
  - 48.6.3 Self-Serve Data Platform
  - 48.6.4 Federated Governance
- 48.7 Change Data Capture (CDC)
  - 48.7.1 Debezium
  - 48.7.2 Log-Based CDC
  - 48.7.3 Trigger-Based CDC

### 49. Data Warehousing & OLAP
- 49.1 OLTP vs. OLAP
- 49.2 Star Schema and Snowflake Schema
- 49.3 Fact Tables and Dimension Tables
- 49.4 Columnar Storage
- 49.5 Data Warehouse Technologies
  - 49.5.1 Amazon Redshift
  - 49.5.2 Google BigQuery
  - 49.5.3 Snowflake
  - 49.5.4 Apache Druid
  - 49.5.5 ClickHouse
- 49.6 Materialized Views and Aggregation Tables
- 49.7 Query Federation

---

## Part XIII: Specific System Design Topics

### 50. Unique ID Generation
- 50.1 UUID (v1, v4, v6, v7)
- 50.2 Auto-Increment IDs (Single Node)
- 50.3 Database Sequences
- 50.4 Twitter Snowflake ID
- 50.5 ULID (Universally Unique Lexicographically Sortable Identifier)
- 50.6 Instagram ID Generation
- 50.7 MongoDB ObjectID
- 50.8 NanoID
- 50.9 Coordination-Free ID Generation
- 50.10 Trade-Offs: Sortability, Uniqueness, Size, Privacy

### 51. URL Shortener Design
- 51.1 Hash-Based Approach
- 51.2 Base62 / Base64 Encoding
- 51.3 Counter-Based Approach
- 51.4 Collision Handling
- 51.5 Redirection (301 vs. 302)
- 51.6 Custom Short URLs
- 51.7 Analytics and Click Tracking
- 51.8 Expiration and Cleanup
- 51.9 Scaling Considerations

### 52. Notification System Design
- 52.1 Notification Types (Push, SMS, Email, In-App)
- 52.2 Notification Service Architecture
- 52.3 Template and Preference Management
- 52.4 Delivery Guarantees
- 52.5 Rate Limiting Notifications
- 52.6 Priority and Urgency
- 52.7 Third-Party Integration (FCM, APNs, Twilio, SendGrid)
- 52.8 Notification Deduplication
- 52.9 Analytics (Open Rate, Click Rate)

### 53. Chat / Messaging System Design
- 53.1 1:1 and Group Messaging
- 53.2 Message Storage and Retrieval
- 53.3 Real-Time Delivery (WebSockets)
- 53.4 Message Ordering and Consistency
- 53.5 Read Receipts and Delivery Status
- 53.6 Presence (Online/Offline) System
- 53.7 Media and File Sharing
- 53.8 End-to-End Encryption
- 53.9 Push Notifications for Offline Users
- 53.10 Message Search
- 53.11 Scaling to Millions of Concurrent Users

### 54. Social Media Feed / News Feed Design
- 54.1 Fan-Out on Write vs. Fan-Out on Read
- 54.2 Hybrid Approach
- 54.3 Feed Ranking and Relevance
- 54.4 Feed Storage
- 54.5 Social Graph
- 54.6 Caching Hot Feeds
- 54.7 Media Content Delivery
- 54.8 Handling Celebrity/High-Follower Accounts

### 55. E-Commerce System Design
- 55.1 Product Catalog Service
- 55.2 Shopping Cart Design
- 55.3 Inventory Management
  - 55.3.1 Reservation Pattern
  - 55.3.2 Optimistic vs. Pessimistic Locking
- 55.4 Order Management Service
- 55.5 Payment Processing
  - 55.5.1 Payment Gateway Integration
  - 55.5.2 Idempotent Payments
  - 55.5.3 Payment State Machine
- 55.6 Pricing and Promotions Engine
- 55.7 Search and Recommendation
- 55.8 Checkout Flow Design
- 55.9 Handling Flash Sales / High Traffic Spikes

### 56. Video Streaming / Media System Design
- 56.1 Video Upload Pipeline
- 56.2 Video Transcoding and Encoding
  - 56.2.1 Codecs (H.264, H.265, VP9, AV1)
  - 56.2.2 Adaptive Bitrate Streaming (ABR)
  - 56.2.3 HLS and DASH Protocols
- 56.3 Content Delivery (CDN for Video)
- 56.4 Video Storage
- 56.5 Thumbnail Generation
- 56.6 Video Player Design
- 56.7 Live Streaming Architecture
- 56.8 DRM (Digital Rights Management)
- 56.9 View Counting at Scale
- 56.10 Recommendation Engine

### 57. File Storage / Cloud Drive Design
- 57.1 File Upload and Download
- 57.2 Chunked Upload and Resumable Uploads
- 57.3 File Deduplication
- 57.4 File Versioning
- 57.5 Synchronization (Conflict Resolution)
- 57.6 Metadata Service
- 57.7 Block Storage vs. Object Storage
- 57.8 Sharing and Permissions
- 57.9 Scaling Storage (Distributed File Systems)

### 58. Ride-Sharing / Location-Based System Design
- 58.1 Location Tracking and Updates
- 58.2 Geospatial Indexing
  - 58.2.1 Geohash
  - 58.2.2 Quadtree
  - 58.2.3 R-Tree
  - 58.2.4 S2 Geometry (Google)
  - 58.2.5 H3 (Uber)
- 58.3 Matching Riders and Drivers
- 58.4 ETA Estimation
- 58.5 Surge Pricing
- 58.6 Trip Management
- 58.7 Real-Time Location Broadcasting
- 58.8 Map Tile Serving

### 59. Search Engine Design
- 59.1 Web Crawling
  - 59.1.1 URL Frontier
  - 59.1.2 Politeness Policies
  - 59.1.3 Deduplication
  - 59.1.4 Robots.txt
- 59.2 Indexing Pipeline
- 59.3 Inverted Index (Detailed)
- 59.4 Ranking Algorithms
  - 59.4.1 PageRank
  - 59.4.2 TF-IDF / BM25
  - 59.4.3 Machine-Learned Ranking
- 59.5 Query Processing
- 59.6 Spell Correction and Query Suggestion
- 59.7 Personalization
- 59.8 Distributed Search Architecture

### 60. Distributed Task Scheduler Design
- 60.1 Task Definition and Submission
- 60.2 Scheduling Strategies (Cron, Interval, One-Time)
- 60.3 Task Queue and Priority
- 60.4 Worker Pool Management
- 60.5 At-Least-Once Execution Guarantee
- 60.6 Task Deduplication
- 60.7 Retry and Dead Letter Handling
- 60.8 Monitoring and Alerting
- 60.9 Distributed Locking for Scheduling
- 60.10 Comparison (Airflow, Temporal, Celery Beat)

### 61. Metrics / Monitoring System Design
- 61.1 Time-Series Data Model
- 61.2 Data Collection (Push vs. Pull)
- 61.3 Aggregation and Downsampling
- 61.4 Storage Engine Design
- 61.5 Query Language (PromQL, InfluxQL)
- 61.6 Alerting Rules Engine
- 61.7 Dashboard and Visualization
- 61.8 High Cardinality Challenges
- 61.9 Retention Policies

### 62. Payment System Design
- 62.1 Payment Lifecycle
- 62.2 Double-Entry Bookkeeping
- 62.3 Ledger Design
- 62.4 Reconciliation
- 62.5 Idempotent Payment Processing
- 62.6 Refunds and Chargebacks
- 62.7 Multi-Currency Support
- 62.8 PCI Compliance
- 62.9 Fraud Detection
- 62.10 Payment Gateway Integration (Stripe, PayPal, Adyen)

### 63. Authentication / Authorization System Design
- 63.1 User Registration and Login Flow
- 63.2 Password Hashing (bcrypt, scrypt, Argon2)
- 63.3 Session Management
  - 63.3.1 Server-Side Sessions
  - 63.3.2 Token-Based (JWT) Sessions
- 63.4 OAuth 2.0 Server Design
- 63.5 SSO (Single Sign-On) Architecture
- 63.6 MFA (Multi-Factor Authentication) Design
- 63.7 Permission and Role Management
- 63.8 API Key Management
- 63.9 Token Refresh and Rotation
- 63.10 Account Recovery and Security Questions
- 63.11 Passwordless Authentication (Magic Links, WebAuthn/Passkeys)

---

## Part XIV: Machine Learning System Design

### 64. ML System Design Fundamentals
- 64.1 ML System Lifecycle
- 64.2 Problem Framing
- 64.3 Data Collection and Labeling
- 64.4 Feature Engineering and Feature Stores
- 64.5 Model Training Infrastructure
- 64.6 Model Evaluation and Validation
- 64.7 Model Serving
  - 64.7.1 Batch Prediction
  - 64.7.2 Real-Time Prediction (Online Inference)
  - 64.7.3 Edge Inference
- 64.8 Model Versioning and Registry
- 64.9 A/B Testing and Shadow Testing for Models
- 64.10 Monitoring Model Performance (Drift Detection)
- 64.11 Feedback Loops

### 65. Recommendation System Design
- 65.1 Collaborative Filtering
- 65.2 Content-Based Filtering
- 65.3 Hybrid Approaches
- 65.4 Candidate Generation and Ranking
- 65.5 Real-Time vs. Batch Recommendations
- 65.6 Cold Start Problem
- 65.7 Embedding-Based Recommendations
- 65.8 Scaling Recommendations

### 66. Search Ranking & Relevance (ML)
- 66.1 Learning to Rank
- 66.2 Pointwise, Pairwise, Listwise Approaches
- 66.3 Feature Engineering for Ranking
- 66.4 Online Learning and Real-Time Ranking
- 66.5 Evaluation Metrics (NDCG, MRR, MAP)

---

## Part XV: System Design Process & Interview Preparation

### 67. System Design Process
- 67.1 Requirements Gathering
  - 67.1.1 Functional Requirements
  - 67.1.2 Non-Functional Requirements (Performance, Scalability, Availability, Security)
  - 67.1.3 Constraints and Assumptions
  - 67.1.4 Clarifying Questions
- 67.2 Back-of-the-Envelope Estimation (Revisited)
- 67.3 High-Level Design
  - 67.3.1 Component Identification
  - 67.3.2 API Design
  - 67.3.3 Data Flow Diagrams
- 67.4 Detailed Design
  - 67.4.1 Database Schema Design
  - 67.4.2 Algorithm Selection
  - 67.4.3 Component Deep Dives
- 67.5 Trade-Off Analysis
- 67.6 Identifying and Addressing Bottlenecks
- 67.7 Scaling the Design
- 67.8 Monitoring and Alerting Plan
- 67.9 Failure Scenarios and Mitigations

### 68. System Design Interview Framework
- 68.1 Step 1: Understand the Problem (3–5 min)
- 68.2 Step 2: Define Scope and Requirements (5 min)
- 68.3 Step 3: Capacity Estimation (5 min)
- 68.4 Step 4: High-Level Architecture (10 min)
- 68.5 Step 5: Detailed Design (15 min)
- 68.6 Step 6: Address Bottlenecks and Trade-Offs (5 min)
- 68.7 Step 7: Wrap-Up and Review (2 min)
- 68.8 Common Mistakes to Avoid
- 68.9 Communication and Whiteboarding Tips

### 69. Classic System Design Problems (Practice)
- 69.1 Design a URL Shortener (TinyURL)
- 69.2 Design a Paste Tool (Pastebin)
- 69.3 Design Twitter / Social Media Feed
- 69.4 Design Instagram / Photo Sharing
- 69.5 Design Facebook Messenger / WhatsApp
- 69.6 Design YouTube / Netflix (Video Streaming)
- 69.7 Design Google Drive / Dropbox
- 69.8 Design a Web Crawler
- 69.9 Design a Search Engine (Google)
- 69.10 Design a Typeahead / Autocomplete System
- 69.11 Design an API Rate Limiter
- 69.12 Design a Distributed Cache
- 69.13 Design a Key-Value Store
- 69.14 Design a Notification System
- 69.15 Design a Chat System
- 69.16 Design an Online Ticketing System (Ticketmaster)
- 69.17 Design a Hotel Booking System
- 69.18 Design Uber / Lyft
- 69.19 Design a Food Delivery System (DoorDash)
- 69.20 Design Google Maps
- 69.21 Design a Proximity Service (Yelp)
- 69.22 Design a Stock Exchange / Trading System
- 69.23 Design a Distributed Message Queue
- 69.24 Design a Metrics / Monitoring System
- 69.25 Design a Distributed Task Scheduler
- 69.26 Design a Payment System (Stripe)
- 69.27 Design an Ad Click Aggregation System
- 69.28 Design a Unique ID Generator
- 69.29 Design an Email System
- 69.30 Design a Collaborative Document Editor (Google Docs)
  - 69.30.1 Operational Transformation (OT)
  - 69.30.2 CRDTs for Collaboration

---

## Part XVI: Advanced Topics

### 70. Multi-Tenancy
- 70.1 What Is Multi-Tenancy?
- 70.2 Multi-Tenancy Models
  - 70.2.1 Shared Everything
  - 70.2.2 Shared Application, Separate Database
  - 70.2.3 Separate Everything
- 70.3 Tenant Isolation
- 70.4 Noisy Neighbor Problem
- 70.5 Data Partitioning for Multi-Tenancy
- 70.6 Customization and Configuration per Tenant
- 70.7 Billing and Metering

### 71. Internationalization & Localization (i18n/l10n)
- 71.1 Unicode and Character Encoding
- 71.2 Locale-Aware Formatting (Dates, Numbers, Currencies)
- 71.3 Translation Management
- 71.4 Right-to-Left (RTL) Support
- 71.5 Time Zones and Daylight Saving
- 71.6 Content Delivery by Region

### 72. Compliance & Regulatory Design
- 72.1 GDPR (General Data Protection Regulation)
  - 72.1.1 Right to Be Forgotten
  - 72.1.2 Data Portability
  - 72.1.3 Consent Management
  - 72.1.4 Data Processing Agreements
- 72.2 CCPA (California Consumer Privacy Act)
- 72.3 HIPAA (Health Insurance Portability and Accountability Act)
- 72.4 PCI-DSS (Payment Card Industry Data Security Standard)
- 72.5 SOC 2 (Service Organization Control)
- 72.6 Data Residency and Sovereignty
- 72.7 Audit Logging for Compliance
- 72.8 Privacy by Design

### 73. Edge Computing & IoT System Design
- 73.1 Edge Computing Architecture
- 73.2 IoT Device Communication Protocols (MQTT, CoAP, AMQP)
- 73.3 Device Registry and Management
- 73.4 Data Ingestion at Scale (Millions of Devices)
- 73.5 Edge-Cloud Data Synchronization
- 73.6 Time-Series Data Processing
- 73.7 Digital Twins
- 73.8 OTA (Over-The-Air) Updates

### 74. Blockchain & Decentralized System Design
- 74.1 Blockchain Fundamentals
- 74.2 Smart Contracts
- 74.3 Decentralized Application (dApp) Architecture
- 74.4 Consensus in Blockchain
- 74.5 Scalability Challenges (Layer 1 & Layer 2)
- 74.6 Decentralized Storage (IPFS, Filecoin)
- 74.7 Hybrid Centralized-Decentralized Systems

### 75. AI/LLM Application Architecture
- 75.1 LLM Integration Patterns
- 75.2 Prompt Engineering and Management
- 75.3 Retrieval-Augmented Generation (RAG)
  - 75.3.1 Document Chunking Strategies
  - 75.3.2 Embedding Generation
  - 75.3.3 Vector Store Design
  - 75.3.4 Retrieval and Reranking
- 75.4 Agent Architectures
- 75.5 Context Window Management
- 75.6 Caching LLM Responses
- 75.7 Cost Optimization for LLM APIs
- 75.8 Guardrails and Safety Filters
- 75.9 Evaluation and Testing of LLM Systems
- 75.10 Fine-Tuning vs. RAG Decision Framework

---

## Part XVII: Software Architecture Documentation & Communication

### 76. Architecture Documentation
- 76.1 Why Document Architecture?
- 76.2 C4 Model
  - 76.2.1 Context Diagram
  - 76.2.2 Container Diagram
  - 76.2.3 Component Diagram
  - 76.2.4 Code Diagram
- 76.3 Architecture Decision Records (ADRs)
  - 76.3.1 ADR Structure
  - 76.3.2 When to Write an ADR
  - 76.3.3 ADR Templates (Michael Nygard format)
- 76.4 Arc42 Documentation Template
- 76.5 Technical Design Documents (TDD)
- 76.6 Request for Comments (RFC) Process
- 76.7 Sequence Diagrams for Flows
- 76.8 Data Flow Diagrams
- 76.9 Deployment Diagrams
- 76.10 Living Documentation

### 77. Architecture Review & Governance
- 77.1 Architecture Review Boards
- 77.2 Fitness Functions for Architecture
- 77.3 Technical Debt Management
  - 77.3.1 Identifying Technical Debt
  - 77.3.2 Categorizing Debt (Deliberate vs. Inadvertent)
  - 77.3.3 Debt Reduction Strategies
  - 77.3.4 Tech Debt Tracking
- 77.4 Architecture Governance Frameworks
- 77.5 Evolutionary Architecture
  - 77.5.1 Incremental Change
  - 77.5.2 Guided by Fitness Functions
  - 77.5.3 Appropriate Coupling

---

## Part XVIII: Soft Skills & Professional Practice

### 78. Communicating Design Decisions
- 78.1 Stakeholder Management
- 78.2 Presenting Trade-Offs to Non-Technical Audiences
- 78.3 Writing Effective Design Proposals
- 78.4 Facilitating Design Reviews
- 78.5 Building Consensus

### 79. Team Organization & Conway's Law
- 79.1 Conway's Law
- 79.2 Inverse Conway Maneuver
- 79.3 Team Topologies
  - 79.3.1 Stream-Aligned Teams
  - 79.3.2 Enabling Teams
  - 79.3.3 Complicated-Subsystem Teams
  - 79.3.4 Platform Teams
- 79.4 Cognitive Load and Team Boundaries
- 79.5 API-First Team Collaboration

---

## Appendices

### Appendix A: Recommended Reading List
- A.1 *Designing Data-Intensive Applications* — Martin Kleppmann
- A.2 *System Design Interview* (Vol. 1 & 2) — Alex Xu
- A.3 *Clean Architecture* — Robert C. Martin
- A.4 *Domain-Driven Design* — Eric Evans
- A.5 *Building Microservices* — Sam Newman
- A.6 *Design Patterns: Elements of Reusable OO Software* — GoF
- A.7 *Fundamentals of Software Architecture* — Mark Richards & Neal Ford
- A.8 *Software Architecture: The Hard Parts* — Neal Ford et al.
- A.9 *Site Reliability Engineering* — Google SRE Team
- A.10 *Head First Design Patterns* — Eric Freeman et al.
- A.11 *Release It!* — Michael Nygard
- A.12 *The Art of Scalability* — Abbott & Fisher
- A.13 *Implementing Domain-Driven Design* — Vaughn Vernon
- A.14 *Database Internals* — Alex Petrov
- A.15 *Understanding Distributed Systems* — Roberto Vitillo

### Appendix B: Key Formulas & Cheat Sheets
- B.1 Latency Numbers Cheat Sheet
- B.2 Powers of 2 Table ($2^{10}$ to $2^{50}$)
- B.3 Availability Calculations
- B.4 Storage & Bandwidth Estimation Templates
- B.5 CAP/PACELC Quick Reference
- B.6 Consistency Models Comparison Chart

### Appendix C: Glossary of Terms

### Appendix D: Technology Comparison Tables
- D.1 Database Comparison Matrix
- D.2 Message Broker Comparison Matrix
- D.3 Cache Technology Comparison
- D.4 Load Balancer Comparison
- D.5 Container Orchestration Comparison
- D.6 API Protocol Comparison (REST vs. gRPC vs. GraphQL)

---

> **Total Chapters: 79 | Sections: 700+ | Estimated Study Time: 300–500 hours**