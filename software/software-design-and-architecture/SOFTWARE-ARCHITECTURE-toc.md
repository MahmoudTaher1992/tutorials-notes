SOFTWARE ARCHITECTURE
Complete Knowledge Tree & Table of Contents
A Comprehensive Study Reference
1.  FOUNDATIONS OF SOFTWARE ARCHITECTURE
1.1  Core Concepts
What is Software Architecture
Architecture vs. Design
The Role of the Software Architect
Architecture Drivers: Quality Attributes, Constraints, Business Goals
Architecture Decision Records (ADRs)
Technical Debt and Architecture Erosion
1.2  Quality Attributes (Non-Functional Requirements)
Performance & Throughput
Scalability (Horizontal vs. Vertical)
Availability & Reliability
Maintainability & Evolvability
Security & Privacy
Testability
Portability & Interoperability
Observability (Logging, Tracing, Metrics)
Usability & Accessibility
Cost Efficiency
1.3  Architecture Documentation
4+1 View Model (Logical, Process, Physical, Development, Scenarios)
C4 Model (Context, Container, Component, Code)
UML Diagrams (Class, Sequence, Component, Deployment)
Arc42 Template
Architecture Evaluation: ATAM, CBAM
2.  ARCHITECTURAL PATTERNS
2.1  Monolithic Architecture
Single-tier Monolith
Modular Monolith
Layered (N-Tier) Architecture
  Presentation Layer
  Business Logic Layer
  Data Access Layer
  Database Layer
2.2  Service-Oriented Architecture (SOA)
Enterprise Service Bus (ESB)
Web Services (SOAP, WSDL, UDDI)
Service Contracts and Registries
SOA Governance
2.3  Microservices Architecture
Microservice Design Principles
Service Decomposition Strategies
  Domain-Driven Design (DDD) Decomposition
  Strangler Fig Pattern
  Business Capability Decomposition
Inter-service Communication
  Synchronous (REST, gRPC)
  Asynchronous (Message Queues, Events)
Service Discovery (Client-side, Server-side)
API Gateway
Circuit Breaker & Resilience Patterns
Sidecar & Service Mesh
Containers & Orchestration (Docker, Kubernetes)
2.4  Event-Driven Architecture (EDA)
Event Notification
Event-Carried State Transfer
Event Sourcing
CQRS (Command Query Responsibility Segregation)
Message Brokers (Kafka, RabbitMQ, AWS SNS/SQS)
Choreography vs. Orchestration
Saga Pattern
2.5  Serverless Architecture
Function-as-a-Service (FaaS)
Backend-as-a-Service (BaaS)
Cold Start & Warm-up Strategies
Event Triggers & Bindings
Serverless Frameworks
2.6  Pipe-and-Filter Architecture
Filters, Pipes, and Data Sources
Batch Processing Pipelines
Stream Processing Pipelines
2.7  Space-Based Architecture
Processing Units
Virtualized Middleware
Data Pumps and Writers
2.8  Hexagonal Architecture (Ports & Adapters)
Domain Core
Ports (Primary & Secondary)
Adapters (Driving & Driven)
2.9  Clean Architecture
Dependency Rule
Entities, Use Cases, Interface Adapters, Frameworks & Drivers
Onion Architecture
3.  DESIGN PATTERNS
3.1  Creational Patterns
Singleton
Factory Method
Abstract Factory
Builder
Prototype
3.2  Structural Patterns
Adapter
Bridge
Composite
Decorator
Facade
Flyweight
Proxy
3.3  Behavioral Patterns
Chain of Responsibility
Command
Iterator
Mediator
Memento
Observer
State
Strategy
Template Method
Visitor
3.4  Architectural Design Patterns
MVC (Model-View-Controller)
MVP (Model-View-Presenter)
MVVM (Model-View-ViewModel)
MVVM-C (with Coordinator)
Flux & Redux
Repository Pattern
Unit of Work
Specification Pattern
Domain Events
4.  DISTRIBUTED SYSTEMS
4.1  Fundamentals
CAP Theorem (Consistency, Availability, Partition Tolerance)
BASE vs. ACID
Eventual Consistency
Fallacies of Distributed Computing
4.2  Communication Protocols
REST (REpresentational State Transfer)
GraphQL
gRPC & Protocol Buffers
WebSockets
Server-Sent Events (SSE)
AMQP, MQTT, STOMP
4.3  Consistency & Coordination
Distributed Transactions (2PC, 3PC)
Saga Pattern (Choreography & Orchestration)
Consensus Algorithms (Raft, Paxos)
Leader Election
Distributed Locks
4.4  Fault Tolerance & Resilience
Circuit Breaker Pattern
Retry & Backoff Strategies
Bulkhead Pattern
Timeout & Deadline Propagation
Health Checks & Heartbeats
Chaos Engineering
4.5  Data Replication
Single-Leader Replication
Multi-Leader Replication
Leaderless Replication (Dynamo-style)
Replication Lag
4.6  Partitioning (Sharding)
Key-Range Partitioning
Hash Partitioning
Consistent Hashing
Rebalancing Strategies
5.  PERFORMANCE OPTIMIZATION PATTERNS
5.1  Caching Architecture
5.1.1  Caching Strategies
Cache-Aside (Lazy Loading)
Read-Through Cache
Write-Through Cache
Write-Behind (Write-Back) Cache
Refresh-Ahead Cache
5.1.2  Caching Tiers
Single-Tier Caching
Two-Tier Caching Strategy  ◀ [Current Topic]
  L1: In-Process / Application-Level Cache (e.g., Caffeine, Guava)
  L2: Distributed / Remote Cache (e.g., Redis, Memcached)
  Cache Coordination & Invalidation between tiers
  Read Path: L1 miss → L2 → Origin
  Write Path strategies (write-through vs. invalidate)
Multi-Tier (CDN + Regional + Local)
5.1.3  Cache Invalidation
TTL (Time-to-Live) Expiry
Event-Driven Invalidation
Cache Tags & Dependency-based Invalidation
Stampede / Dog-pile Prevention
5.1.4  Distributed Caching
Redis (Data Structures, Pub/Sub, Cluster)
Memcached
Hazelcast / Apache Ignite
Cache Sharding & Partitioning
Cache Replication
5.2  Load Balancing
DNS Load Balancing
Hardware vs. Software Load Balancers
Algorithms: Round Robin, Least Connections, IP Hash, Weighted
Layer 4 vs. Layer 7 Load Balancing
Sticky Sessions
Global Server Load Balancing (GSLB)
5.3  Database Optimization
Read Replicas
Query Optimization & Indexing Strategies
Connection Pooling
Database Sharding
Polyglot Persistence
Database Proxies (PgBouncer, ProxySQL)
5.4  Async & Queuing
Message Queues (RabbitMQ, SQS, ActiveMQ)
Job Queues & Background Processing
Task Scheduling
Backpressure Handling
5.5  Content Delivery
CDN Architecture (Edge Caching)
Cache-Control & Vary Headers
Static Asset Optimization
Edge Computing
6.  CLOUD ARCHITECTURE
6.1  Cloud Service Models
IaaS (Infrastructure as a Service)
PaaS (Platform as a Service)
SaaS (Software as a Service)
CaaS (Container as a Service)
FaaS (Function as a Service)
6.2  Cloud Deployment Models
Public Cloud (AWS, Azure, GCP)
Private Cloud
Hybrid Cloud
Multi-Cloud Strategy
6.3  Cloud Design Patterns
Ambassador Pattern
Anti-Corruption Layer
Backends for Frontends (BFF)
Bulkhead
Gateway Aggregation
Gateway Offloading
Gateway Routing
Scheduler Agent Supervisor
Strangler Fig
Throttling
Valet Key
6.4  Infrastructure as Code (IaC)
Terraform
AWS CloudFormation
Pulumi
Ansible
Configuration Drift & Immutable Infrastructure
6.5  Containers & Orchestration
Docker: Images, Containers, Registries
Kubernetes: Pods, Services, Deployments, Ingress
Helm Charts
Service Mesh (Istio, Linkerd)
Container Security
7.  DATA ARCHITECTURE
7.1  Database Types
Relational (RDBMS): PostgreSQL, MySQL, Oracle
Document Stores: MongoDB, CouchDB
Key-Value Stores: Redis, DynamoDB
Wide-Column Stores: Cassandra, HBase
Graph Databases: Neo4j, Amazon Neptune
Time-Series: InfluxDB, TimescaleDB
Search Engines: Elasticsearch, OpenSearch
NewSQL: CockroachDB, Google Spanner
7.2  Data Modeling
Relational Modeling & Normalization (1NF–BCNF)
Entity-Relationship (ER) Diagrams
Dimensional Modeling (Star & Snowflake Schemas)
Domain-Driven Design Aggregates
Schema Evolution & Migrations
7.3  Big Data Architecture
Lambda Architecture (Batch + Speed + Serving Layer)
Kappa Architecture
Data Lakes & Data Warehouses
Data Lakehouse (Delta Lake, Apache Iceberg)
Batch Processing (Hadoop MapReduce, Apache Spark)
Stream Processing (Apache Kafka Streams, Flink)
7.4  Data Integration
ETL vs. ELT Pipelines
Change Data Capture (CDC)
Data Mesh
API-led Connectivity
Event Streaming as Integration
8.  SECURITY ARCHITECTURE
8.1  Security Principles
Zero Trust Architecture
Principle of Least Privilege
Defense in Depth
Security by Design & Privacy by Design
8.2  Authentication & Authorization
OAuth 2.0 & OpenID Connect
JWT (JSON Web Tokens)
SAML
RBAC, ABAC, PBAC
Multi-Factor Authentication (MFA)
Single Sign-On (SSO)
Secrets Management (HashiCorp Vault, AWS Secrets Manager)
8.3  Network Security
TLS/SSL Termination
API Gateway Security
WAF (Web Application Firewall)
DDoS Mitigation
VPC & Network Segmentation
Service-to-Service mTLS
8.4  Application Security Patterns
Input Validation & Sanitization
OWASP Top 10 Mitigations
SQL Injection Prevention
XSS & CSRF Protection
Secure Headers
Threat Modeling (STRIDE)
9.  OBSERVABILITY & RELIABILITY
9.1  Observability Pillars
Logging (Structured Logging, Log Aggregation)
Metrics (Counters, Gauges, Histograms, Summaries)
Distributed Tracing (OpenTelemetry, Jaeger, Zipkin)
Profiling
9.2  Monitoring Patterns
RED Method (Rate, Errors, Duration)
USE Method (Utilization, Saturation, Errors)
Golden Signals (Latency, Traffic, Errors, Saturation)
SLIs, SLOs, and SLAs
Error Budgets
9.3  Alerting & Incident Management
Alerting Strategies & Runbooks
On-call Rotations
Post-mortems & Blameless Culture
AIOps & Anomaly Detection
9.4  Site Reliability Engineering (SRE)
Toil Reduction
Capacity Planning
Release Engineering
Chaos Engineering (Chaos Monkey, Gremlin)
10.  DEVOPS & DEPLOYMENT ARCHITECTURE
10.1  CI/CD Pipelines
Continuous Integration (CI)
Continuous Delivery vs. Continuous Deployment
Pipeline Stages: Build, Test, Scan, Deploy
Tools: Jenkins, GitLab CI, GitHub Actions, CircleCI
10.2  Deployment Strategies
Blue-Green Deployment
Canary Releases
Rolling Updates
Feature Flags / Feature Toggles
A/B Testing Infrastructure
Shadow Deployment
10.3  GitOps
Git as Single Source of Truth
Argo CD, Flux
Pull-based vs. Push-based Deployments
10.4  Platform Engineering
Internal Developer Platforms (IDPs)
Self-Service Infrastructure
Developer Experience (DevEx) Metrics
Golden Paths
11.  DOMAIN-DRIVEN DESIGN (DDD)
11.1  Strategic Design
Bounded Contexts
Context Mapping Patterns
  Shared Kernel
  Customer/Supplier
  Conformist
  Anti-Corruption Layer
  Open Host Service
  Published Language
Ubiquitous Language
Core, Supporting, and Generic Subdomains
11.2  Tactical Design
Entities
Value Objects
Aggregates & Aggregate Roots
Domain Events
Repositories
Domain Services
Factories
Application Services
11.3  DDD & Microservices
Mapping Bounded Contexts to Microservices
Event Storming
Context Map to Service Map
12.  FRONTEND ARCHITECTURE
12.1  Rendering Strategies
Client-Side Rendering (CSR)
Server-Side Rendering (SSR)
Static Site Generation (SSG)
Incremental Static Regeneration (ISR)
Island Architecture
Streaming SSR
12.2  Micro-Frontends
Vertical Split (per business domain)
Horizontal Split (per page section)
Integration Approaches: iframes, Web Components, Module Federation
Shared State & Communication
Design System Integration
12.3  State Management
Local Component State
Context / Prop Drilling Solutions
Global State Stores (Redux, MobX, Zustand)
Server State (React Query, SWR)
URL State
12.4  Performance Patterns
Code Splitting & Lazy Loading
Tree Shaking
Critical Rendering Path Optimization
PWA (Progressive Web Apps)
Web Vitals (LCP, CLS, INP)
13.  API DESIGN & GATEWAY PATTERNS
13.1  API Styles
REST — Richardson Maturity Model, HATEOAS
GraphQL — Schema, Resolvers, Subscriptions
gRPC — Proto Definitions, Streaming
AsyncAPI — Event-Driven APIs
Webhook Patterns
13.2  API Gateway Patterns
Request Routing
Protocol Translation
Rate Limiting & Throttling
Authentication Offloading
Response Transformation
API Composition & Aggregation
Backends for Frontends (BFF)
13.3  API Versioning Strategies
URI Versioning (/v1/resource)
Header Versioning
Query Parameter Versioning
Semantic Versioning
Consumer-Driven Contract Testing
13.4  API Security
OAuth 2.0 Flows
API Keys & HMAC Signing
Rate Limiting & Abuse Prevention
Input Validation & Schema Enforcement
14.  EMERGING & ADVANCED PATTERNS
14.1  AI/ML System Architecture
ML Pipeline Architecture (Training, Serving, Monitoring)
Feature Stores
Model Registries
MLOps & LLMOps
RAG (Retrieval-Augmented Generation) Architecture
Vector Databases (Pinecone, Weaviate, pgvector)
AI Agent Architecture
14.2  Real-Time Systems
WebSocket Architectures
CRDT (Conflict-free Replicated Data Types)
Operational Transformation
Live Collaboration Patterns
14.3  Edge Computing Architecture
Edge Nodes & CDN Computing
Fog Computing
IoT Architecture Patterns
Edge-Cloud Continuum
14.4  Reactive Architecture
Reactive Manifesto (Responsive, Resilient, Elastic, Message-Driven)
Actor Model (Akka, Erlang)
Reactive Streams (Project Reactor, RxJava)
Backpressure
15.  ARCHITECTURE GOVERNANCE & PROCESS
15.1  Architecture Review
Architecture Review Boards (ARB)
RFC (Request for Comments) Process
Architecture Decision Records (ADRs)
Fitness Functions (Evolutionary Architecture)
15.2  Architecture Assessment Methods
ATAM (Architecture Tradeoff Analysis Method)
CBAM (Cost Benefit Analysis Method)
Technical Radar
Architecture Debt Quantification
15.3  Team & Org Design
Conway's Law
Team Topologies (Stream-Aligned, Enabling, Complicated-Subsystem, Platform)
Inverse Conway Maneuver
Two-Pizza Teams
15.4  Evolutionary Architecture
Incremental & Guided Change
Fitness Functions as Architectural Tests
Anti-patterns & Migration Paths

── End of Table of Contents ──