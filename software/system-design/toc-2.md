# Comprehensive System Design Study Guide — Detailed Table of Contents

---

## Part I: Foundations of System Design

### A. Introduction to System Design

1. **What is System Design?**
   - Definition and scope: from single-server apps to planet-scale distributed systems
   - The role of a system designer / architect in an engineering organization
   - Software architecture vs. system design vs. infrastructure design — distinctions and overlaps
2. **Why is System Design Important?**
   - Impact on scalability, reliability, cost, and developer velocity
   - Consequences of poor design: technical debt, outages, data loss, uncontrollable costs
   - Real-world case studies of design failures (e.g., Knight Capital, healthcare.gov launch)
3. **Key Challenges in Modern Systems**
   - Scale: handling millions/billions of users and requests
   - Data explosion: storage, processing, and retrieval at scale
   - Latency expectations in a global, real-time world
   - Heterogeneous environments: mobile, web, IoT, edge devices
   - Regulatory & compliance constraints (GDPR, HIPAA, SOC 2)
   - Evolving requirements and organizational growth
4. **Approaching System Design Interviews vs. Real-World Architecture**
   - Interview format: time-boxed, structured communication, demonstrating breadth & depth
   - Real-world: iterative, team-driven, data-informed, constrained by legacy systems and budgets
   - The RESHADED framework (Requirements, Estimation, Storage schema, High-level design, API design, Detailed design, Evaluation, Deployment)
   - Other popular frameworks: STAR for design, C4 model for diagramming
5. **How to Use This Guide**
   - Suggested study order, prerequisites, and companion resources
   - Practice habits: whiteboarding, mock interviews, writing design docs



### B. System Design Mindset & Methodology

1. **Requirements Gathering & Clarification**
   - **Functional Requirements (FRs)**
     - Core features, user stories, use-case diagrams
     - Identifying the "happy path" and edge cases
     - Prioritization: MVP vs. full feature set
   - **Non-Functional Requirements (NFRs)**
     - Scalability (horizontal vs. vertical targets)
     - Availability (SLA: 99.9%, 99.99%, 99.999% — what each means in downtime)
     - Latency (p50, p95, p99 targets)
     - Durability and data loss tolerance (RPO / RTO)
     - Consistency requirements (strong vs. eventual, per feature)
     - Security, compliance, auditability
     - Maintainability, extensibility, testability
   - **Constraints and Assumptions**
     - Technology constraints (existing stack, vendor lock-in)
     - Team constraints (size, expertise, on-call)
     - Budget constraints
     - Timeline and phased delivery
2. **Estimation Techniques (Back-of-the-Envelope Calculations)**
   - **Traffic Estimation**
     - Daily Active Users (DAU), Monthly Active Users (MAU)
     - Read-to-write ratio
     - Queries Per Second (QPS): average vs. peak (often $\text{peak} \approx 2\text{–}5 \times \text{average}$)
   - **Storage Estimation**
     - Per-record size calculation (metadata, payload, indexes)
     - Growth rate over 1, 3, 5 years
     - Hot vs. warm vs. cold storage tiers
   - **Bandwidth Estimation**
     - Ingress vs. egress in bytes/sec
     - Media-heavy vs. text-heavy workloads
   - **Memory / Cache Estimation**
     - 80/20 rule (cache the top 20% of hot data)
     - Working set size
   - **Key Numbers Every Engineer Should Know**
     - Latency numbers: L1 cache (~0.5 ns), RAM (~100 ns), SSD read (~150 µs), HDD seek (~10 ms), round-trip within datacenter (~0.5 ms), cross-continent (~150 ms)
     - Throughput numbers: SSD ~500 MB/s sequential, network 1–100 Gbps
     - Powers of two: $2^{10} = 1\text{K}$, $2^{20} = 1\text{M}$, $2^{30} = 1\text{G}$, $2^{40} = 1\text{T}$
3. **Common Bottlenecks and Pitfalls**
   - Single points of failure (SPOF)
   - Uneven load distribution / hotspots
   - Chatty inter-service communication
   - Unbounded queues and memory leaks
   - N+1 query problems
   - Lack of backpressure mechanisms
   - Over-engineering and premature optimization
4. **Trade-off Thinking**
   - Simplicity vs. flexibility
   - Cost vs. performance
   - Latency vs. consistency
   - Development speed vs. system robustness
   - Build vs. buy
   - Centralized vs. distributed
   - How to articulate trade-offs clearly in interviews and design docs



### C. High-Level Principles & Design Goals

1. **Performance vs. Scalability**
   - Performance: how fast for a single user
   - Scalability: maintaining performance as load grows
   - Vertical scaling (scale up) vs. horizontal scaling (scale out)
   - Amdahl's Law and its implications: $S = \frac{1}{(1-p) + \frac{p}{n}}$
   - Universal Scalability Law (USL): contention and coherence penalties
2. **Latency vs. Throughput**
   - Definitions and units (ms vs. requests/sec)
   - Little's Law: $L = \lambda \times W$
   - How optimizing for one can hurt the other
   - Batching, pipelining, and concurrency to improve throughput
   - Tail latency amplification in distributed systems
3. **Availability vs. Consistency**
   - The spectrum from strong consistency to eventual consistency
   - Business context: when is stale data acceptable?
   - SLA math: "nines" of availability and corresponding allowed downtime per year
     - 99.9% → ~8.76 hours/year
     - 99.99% → ~52.6 minutes/year
     - 99.999% → ~5.26 minutes/year
   - Composite availability for systems in series: $A_{\text{total}} = A_1 \times A_2 \times \ldots \times A_n$
   - Composite availability for systems in parallel: $A_{\text{total}} = 1 - (1-A_1)(1-A_2)\ldots(1-A_n)$
4. **Reliability vs. Maintainability**
   - Reliability: MTBF (Mean Time Between Failures), MTTR (Mean Time To Recovery)
   - Measuring reliability: $\text{Availability} = \frac{\text{MTBF}}{\text{MTBF} + \text{MTTR}}$
   - Maintainability: operability, simplicity, evolvability
   - The importance of good abstractions, documentation, and automation
5. **The "-ilities" Checklist**
   - Scalability, availability, reliability, maintainability, durability
   - Testability, observability, extensibility, portability
   - Security, compliance, cost-efficiency



---

## Part II: Core Concepts & Distributed Systems Theory

### A. Distributed Systems Fundamentals

1. **What Makes a System "Distributed"?**
   - Multiple networked nodes cooperating to achieve a task
   - Why distribute? Scalability, fault tolerance, latency reduction, data locality
2. **Fundamental Challenges**
   - Network is unreliable: packet loss, latency, partitions
   - Clocks are unreliable: clock skew, NTP drift
   - Processes can crash at any time
   - The "Eight Fallacies of Distributed Computing" (Deutsch & Gosling)
3. **Time, Ordering, and Causality**
   - Physical clocks vs. logical clocks
   - Lamport timestamps
   - Vector clocks
   - Hybrid Logical Clocks (HLC)
   - Happened-before relation and causal ordering
4. **Consensus Protocols**
   - The consensus problem: definition and impossibility results
   - FLP Impossibility Theorem (overview)
   - **Paxos**: basic Paxos, Multi-Paxos
   - **Raft**: leader election, log replication, safety (more intuitive than Paxos)
   - **Zab** (ZooKeeper Atomic Broadcast)
   - **PBFT** (Practical Byzantine Fault Tolerance) — brief overview
   - Real-world usage: etcd (Raft), ZooKeeper (Zab), Google Spanner (Paxos)
5. **Leader Election**
   - Why elect a leader? Coordination, ordering, single writer
   - Bully algorithm, ring algorithm
   - Lease-based leader election
   - Fencing tokens to prevent split-brain
   - Tools: ZooKeeper, etcd, Consul



### B. CAP Theorem & Its Extensions

1. **CAP Theorem — Definition and Implications**
   - Consistency (linearizability), Availability (every non-failing node responds), Partition Tolerance
   - "Pick two out of three" — why this is misleading
   - During a partition, you must choose between C and A
   - When there's no partition, you can have both C and A
2. **CA, CP, and AP Systems — Examples**
   - **CP systems**: HBase, MongoDB (with majority write concern), etcd, ZooKeeper
   - **AP systems**: Cassandra, DynamoDB (default config), CouchDB, Riak
   - **CA systems**: single-node RDBMS (but not truly distributed)
3. **Beyond CAP**
   - **PACELC Theorem**: if Partition → choose A or C; Else → choose Latency or Consistency
     - PA/EL systems (Cassandra, DynamoDB)
     - PC/EC systems (HBase, VoltDB)
     - PA/EC systems, PC/EL systems
   - **Harvest and Yield** (Fox & Brewer): quantifying trade-offs
4. **Impact on Database Selection and Architecture Decisions**
   - Mapping NFRs to CAP/PACELC trade-offs
   - Per-feature consistency requirements within a single system



### C. Consistency Models & Patterns

1. **The Consistency Spectrum**
   - From strict serializability to eventual consistency
2. **Strong Consistency (Linearizability)**
   - Definition: reads always return the most recent write
   - Implementation: consensus protocols, single-leader with synchronous replication
   - Cost: higher latency, lower availability during partitions
   - Use cases: financial transactions, inventory counts, leader election
3. **Sequential Consistency**
   - All processes see the same order of operations (but not necessarily real-time)
4. **Causal Consistency**
   - Causally related operations are seen in the same order by all nodes
   - Implementation: vector clocks, causal broadcast
5. **Eventual Consistency**
   - If no new updates, all replicas eventually converge
   - Convergence time and its factors
   - Conflict resolution: last-writer-wins (LWW), application-level merge, CRDTs
6. **Read-Your-Writes / Session Consistency**
   - A user always sees their own writes
   - Implementation: sticky sessions, version vectors, read from leader after write
7. **Monotonic Reads / Monotonic Writes**
   - Monotonic reads: once you see a value, you never see an older value
   - Monotonic writes: writes by a single process are applied in order
8. **Read/Write Quorums**
   - Quorum formula: $W + R > N$ guarantees overlap
   - Sloppy quorums and hinted handoff
   - Tunable consistency: choosing W, R, N for different workloads
9. **Consistency in Practice**
   - Cassandra: tunable consistency levels (ONE, QUORUM, ALL, LOCAL_QUORUM)
   - DynamoDB: eventually consistent reads vs. strongly consistent reads
   - Google Spanner: TrueTime and external consistency
   - CockroachDB: serializable isolation via timestamp ordering
   - PostgreSQL / MySQL: isolation levels (READ UNCOMMITTED, READ COMMITTED, REPEATABLE READ, SERIALIZABLE)



### D. Availability Patterns

1. **Defining Availability**
   - Uptime percentage, SLAs, SLOs, SLIs
   - Planned vs. unplanned downtime
   - Availability of compound systems (series and parallel)
2. **Failover Strategies**
   - **Active-Passive (Hot Standby)**
     - How it works, failover detection, promotion
     - Data synchronization: synchronous vs. asynchronous
     - Limitations: resource waste, failover time
   - **Active-Active (Multi-Master / Load-Shared)**
     - Both nodes serve traffic simultaneously
     - Conflict resolution challenges
     - Higher resource utilization but greater complexity
   - **Warm Standby vs. Cold Standby**
3. **Load Balancing as an Availability Mechanism** (detailed in Part III)
4. **Health Checking and Failure Detection**
   - Heartbeat-based detection
   - Gossip protocols (e.g., SWIM)
   - Phi accrual failure detector
   - Fencing: preventing split-brain with fencing tokens or STONITH
5. **Graceful Degradation**
   - Serving partial results or cached data during failures
   - Feature flags to disable non-critical features under load
   - Read-only mode, maintenance mode
   - Example: Netflix serving cached recommendations when the recommendation service is down
6. **Redundancy Patterns**
   - N+1, N+2, 2N redundancy
   - Geographic redundancy (multi-region, multi-AZ)
   - Data plane vs. control plane redundancy
7. **Disaster Recovery (DR)**
   - RPO (Recovery Point Objective) and RTO (Recovery Time Objective)
   - DR strategies: backup/restore, pilot light, warm standby, multi-site active/active
   - Chaos engineering to validate DR (Netflix Chaos Monkey, Gremlin)



### E. Data Replication Patterns

1. **Why Replicate Data?**
   - Fault tolerance, read scalability, latency reduction (geo-proximity)
2. **Single-Leader (Master-Slave) Replication**
   - Architecture: one writer, multiple readers
   - Replication lag and its consequences
   - Handling leader failure: failover, split-brain risks
   - Use cases: most RDBMS setups (PostgreSQL streaming replication, MySQL binlog replication)
3. **Multi-Leader (Master-Master) Replication**
   - Architecture: multiple nodes accept writes
   - Conflict detection and resolution
     - Conflict-free Replicated Data Types (CRDTs)
     - Operational Transformation (OT)
     - Last-Writer-Wins (LWW)
     - Custom application-level resolution
   - Topologies: star, circular, all-to-all
   - Use cases: multi-datacenter writes, collaborative editing
4. **Leaderless (Peer-to-Peer) Replication**
   - All nodes accept reads and writes
   - Quorum reads and writes: $W + R > N$
   - Anti-entropy: Merkle trees, read repair, hinted handoff
   - Use cases: Cassandra, DynamoDB, Riak
5. **Synchronous vs. Asynchronous Replication**
   - Synchronous: strong consistency guarantee, higher latency, reduced availability
   - Asynchronous: low latency, risk of data loss on leader failure
   - Semi-synchronous: one synchronous follower, rest asynchronous
   - Chain replication
6. **Replication Topologies and Their Trade-offs**
   - Single datacenter vs. cross-datacenter replication
   - WAN-optimized replication
   - Conflict windows and probabilistic guarantees



### F. Partitioning / Sharding Patterns

1. **Why Partition Data?**
   - Overcoming single-node storage and throughput limits
   - Data locality and regulatory requirements
2. **Horizontal Partitioning (Sharding)**
   - Splitting rows across multiple nodes
   - Shard key selection: importance and pitfalls
   - Hot partitions and skew
3. **Vertical Partitioning**
   - Splitting by columns / features (e.g., user profile vs. user activity)
   - Reducing row width, optimizing for access patterns
4. **Partitioning Strategies**
   - **Range-Based Partitioning**
     - Pros: efficient range queries
     - Cons: hot spots on sequential keys (e.g., timestamps)
   - **Hash-Based Partitioning**
     - Pros: even distribution
     - Cons: range queries require scatter-gather
   - **Consistent Hashing**
     - The hash ring concept
     - Virtual nodes (vnodes) for balance
     - Adding/removing nodes with minimal data movement
     - Applications: Cassandra, DynamoDB, CDN routing
   - **Directory-Based (Lookup) Sharding**
     - A lookup service maps keys to shards
     - Flexibility at the cost of an extra hop and SPOF risk
   - **Geo-Based Partitioning**
     - Data partitioned by geographic region
     - Compliance and latency benefits
5. **Database Federation (Functional Partitioning)**
   - Splitting by function/domain (e.g., users DB, orders DB, products DB)
   - Benefits: independent scaling, domain isolation
   - Drawbacks: cross-shard joins, distributed transactions
6. **Challenges of Sharding**
   - Cross-shard queries and joins
   - Distributed transactions (2PC, Saga)
   - Rebalancing / resharding
   - Maintaining referential integrity
   - Secondary indexes across shards (local vs. global indexes)
7. **When to Shard and When Not To**
   - Alternatives: read replicas, caching, vertical scaling, connection pooling
   - Sharding as a last resort for many workloads



### G. Transactions in Distributed Systems

1. **ACID Properties Review**
   - Atomicity, Consistency, Isolation, Durability
   - Isolation levels: Read Uncommitted, Read Committed, Repeatable Read, Serializable, Snapshot Isolation
2. **Distributed Transactions**
   - **Two-Phase Commit (2PC)**
     - Prepare phase, commit phase
     - Coordinator failure and blocking problem
     - Three-Phase Commit (3PC) — brief overview
   - **XA Transactions**
3. **Saga Pattern (Detailed)**
   - Choreography-based sagas: events trigger next steps
   - Orchestration-based sagas: a central orchestrator coordinates steps
   - Compensating transactions for rollback
   - Idempotency requirements
   - Saga execution coordinator (SEC)
   - Use cases: order processing, payment workflows, multi-service booking
4. **BASE vs. ACID**
   - Basically Available, Soft-state, Eventually consistent
   - When BASE is acceptable, when ACID is required
5. **Concurrency Control**
   - Optimistic concurrency control (version numbers, ETags)
   - Pessimistic concurrency control (locks, SELECT FOR UPDATE)
   - Multi-Version Concurrency Control (MVCC)
   - Conflict detection vs. conflict prevention



---

## Part III: Scalability & Load Distribution

### A. Load Balancing — In Depth

1. **What is Load Balancing & Why?**
   - Distributing traffic across multiple servers
   - Improving throughput, reducing latency, enabling fault tolerance
2. **Reverse Proxy vs. Load Balancer**
   - Reverse proxy: single backend possible, added features (caching, compression, SSL)
   - Load balancer: always implies multiple backends
   - Overlap and when to use both
3. **Load Balancing Algorithms**
   - **Round Robin**: simple, equal distribution, ignores server capacity
   - **Weighted Round Robin**: accounts for heterogeneous servers
   - **Least Connections**: routes to server with fewest active connections
   - **Weighted Least Connections**: combines connection count with server weight
   - **Least Response Time**: routes to fastest-responding server
   - **IP Hash**: consistent routing based on client IP (useful for session affinity)
   - **Consistent Hashing**: for distributed caches and stateful routing
   - **Random with Two Choices (Power of Two)**: pick two random servers, choose the less loaded one
   - **Resource-Based (Adaptive)**: considers CPU, memory, I/O utilization
4. **Layer 4 (Transport) vs. Layer 7 (Application) Load Balancing**
   - **L4**: operates on TCP/UDP, fast, no content inspection
   - **L7**: operates on HTTP/HTTPS, content-based routing, URL/header/cookie-based rules
   - Performance vs. flexibility trade-off
   - Use cases for each
5. **Health Checks**
   - Active health checks (periodic probes: TCP, HTTP, custom scripts)
   - Passive health checks (monitoring real traffic for errors)
   - Configuring intervals, thresholds, and timeouts
6. **Advanced Features**
   - **Sticky Sessions (Session Affinity)**: when and why, risks (uneven load)
   - **SSL/TLS Termination (Offloading)**: decrypt at LB, forward plaintext to backends
   - **SSL Passthrough**: end-to-end encryption, LB can't inspect content
   - **Connection Draining (Graceful Shutdown)**: finish in-flight requests before removing a node
   - **Rate Limiting at the LB**: per-IP, per-endpoint, token bucket
   - **Request Queuing and Priority**
7. **Global Server Load Balancing (GSLB)**
   - DNS-based load balancing (GeoDNS, latency-based routing)
   - Anycast routing
   - Multi-region traffic management
8. **Load Balancer as a Single Point of Failure**
   - HA pairs: active-passive, active-active LB clusters
   - Floating IP / Virtual IP (VIP)
   - DNS failover
9. **Popular Technologies**
   - Hardware: F5 BIG-IP, Citrix ADC
   - Software: NGINX, HAProxy, Envoy, Traefik
   - Cloud-native: AWS ALB/NLB/GLB, GCP Cloud Load Balancing, Azure Load Balancer/Application Gateway
10. **Service Mesh Load Balancing** (client-side LB via sidecars — covered more in Part V)



### B. Caching — In Depth

1. **Why Cache?**
   - Reduce latency, offload databases, absorb traffic spikes
   - The principle of locality (temporal and spatial)
2. **Cache Types by Location**
   - **Client-Side Cache**: browser cache, mobile app cache, HTTP cache headers (Cache-Control, ETag, Last-Modified)
   - **CDN Cache**: edge caching of static and dynamic content
   - **API Gateway / Reverse Proxy Cache**: NGINX, Varnish
   - **Application-Level Cache**: in-process (local memory, Guava, Caffeine) vs. out-of-process (Redis, Memcached)
   - **Database Cache**: query cache, buffer pool, materialized views
   - **DNS Cache**: TTL-based
3. **Caching Patterns (Read Strategies)**
   - **Cache-Aside (Lazy Loading)**
     - App checks cache → on miss, reads from DB → writes to cache
     - Pros: only caches what's needed; Cons: cache miss penalty, stale data risk
   - **Read-Through**
     - Cache itself fetches from DB on miss
     - Simpler application code, cache library handles loading
   - **Refresh-Ahead**
     - Proactively refreshes entries before expiry
     - Reduced latency for hot keys, but wastes resources on cold keys
4. **Caching Patterns (Write Strategies)**
   - **Write-Through**
     - Write to cache and DB synchronously
     - Strong consistency, but higher write latency
   - **Write-Behind (Write-Back)**
     - Write to cache immediately, asynchronously persist to DB
     - Low write latency, risk of data loss if cache node fails
     - Batching and coalescing writes
   - **Write-Around**
     - Write directly to DB, bypassing cache
     - Avoids cache pollution for infrequently read data
5. **Cache Invalidation**
   - TTL (Time-To-Live) based expiry
   - Event-driven invalidation (pub/sub on data change)
   - Manual / programmatic invalidation
   - Versioned keys
   - The "two hardest things in CS" — cache invalidation and naming things
6. **Cache Eviction Policies**
   - LRU (Least Recently Used) — most common
   - LFU (Least Frequently Used)
   - FIFO (First In, First Out)
   - Random eviction
   - TTL-based eviction
   - ARC (Adaptive Replacement Cache)
   - W-TinyLFU (used in Caffeine)
7. **Cache Consistency Challenges**
   - Stale data and acceptable staleness windows
   - Thundering herd / cache stampede
     - Mitigation: locking, request coalescing, probabilistic early expiration
   - Cache penetration (queries for non-existent keys)
     - Mitigation: bloom filters, caching null values
   - Cache pollution
   - Hot key problem
     - Mitigation: local caching, key replication, random suffix
8. **Distributed Caching**
   - Partitioning cache across nodes (consistent hashing)
   - Replication for HA
   - Cache cluster management and auto-discovery
9. **Popular Technologies**
   - **Redis**: data structures, persistence (RDB, AOF), Redis Cluster, Redis Sentinel, Pub/Sub, Lua scripting, streams
   - **Memcached**: simple key-value, multi-threaded, no persistence
   - **CDN Providers**: Cloudflare, Akamai, AWS CloudFront, Fastly
   - **Application-level**: Guava Cache, Caffeine (Java), lru-cache (Node.js), Django cache framework
10. **Cache Sizing and Performance Tuning**
    - Cache hit ratio and its impact on overall latency
    - Monitoring: hit rate, miss rate, eviction rate, memory usage
    - Benchmarking and capacity planning



### C. Asynchronous Processing & Message Queues

1. **Why Asynchronous Processing?**
   - Decoupling producers from consumers
   - Absorbing traffic spikes (buffering)
   - Enabling retry and fault tolerance
   - Improving perceived latency for users
2. **Message Queues (Point-to-Point)**
   - One message consumed by one consumer
   - FIFO ordering guarantees (or lack thereof)
   - Visibility timeout / acknowledgment
   - Dead Letter Queues (DLQ) for failed messages
   - Technologies: RabbitMQ, Amazon SQS, ActiveMQ
3. **Publish/Subscribe (Pub/Sub)**
   - One message delivered to all subscribers of a topic
   - Fan-out pattern
   - Technologies: Apache Kafka, Google Pub/Sub, Amazon SNS, Redis Pub/Sub, NATS
4. **Event Streaming Platforms**
   - **Apache Kafka — Deep Dive**
     - Topics, partitions, offsets, consumer groups
     - Producers: partitioning strategies (key-based, round-robin)
     - Consumers: consumer groups, rebalancing, offset management (auto-commit vs. manual)
     - Replication: ISR (In-Sync Replicas), leader/follower, acks config
     - Retention: time-based, size-based, compacted topics
     - Kafka Streams, KSQL for stream processing
     - Kafka Connect for integration
     - Exactly-once semantics (idempotent producer + transactional API)
   - **Apache Pulsar**: multi-tenancy, tiered storage, geo-replication
   - **Amazon Kinesis**: shards, enhanced fan-out
5. **Task Queues and Worker Patterns**
   - Celery (Python), Sidekiq (Ruby), BullMQ (Node.js)
   - Priority queues
   - Scheduled/delayed tasks
   - Cron-based (schedule-driven) vs. event-driven processing
   - Idempotent task execution
6. **Workflows and Orchestration**
   - Temporal, Apache Airflow, AWS Step Functions, Cadence
   - Long-running workflows and state management
   - Compensation and rollback in workflows
7. **Retry Strategies**
   - Immediate retry, fixed delay, exponential backoff with jitter
   - Maximum retry count
   - Dead Letter Queues (DLQ) and poison message handling
   - Circuit breaker integration
8. **Backpressure**
   - What is backpressure and why it matters
   - Strategies: rate limiting producers, bounded queues, dropping messages, load shedding
   - Reactive streams and backpressure protocols
9. **Guaranteed Delivery and Ordering**
   - At-most-once, at-least-once, exactly-once delivery semantics
   - Ordering guarantees: per-partition (Kafka), per-queue (SQS FIFO)
   - Idempotency as a complement to at-least-once delivery
   - Transactional outbox pattern
   - Change Data Capture (CDC) with Debezium
10. **Choosing the Right Messaging System**
    - Throughput requirements
    - Ordering guarantees
    - Message size
    - Retention needs
    - Ecosystem integration
    - Comparison table: Kafka vs. RabbitMQ vs. SQS vs. Pulsar vs. NATS



### D. Content Delivery Networks (CDNs)

1. **What is a CDN and Why Use One?**
   - Geographically distributed network of proxy servers
   - Reduces latency by serving content from the nearest edge node
   - Offloads origin server traffic
   - DDoS mitigation and security benefits
2. **CDN Architecture**
   - Edge servers (Points of Presence / PoPs)
   - Origin server
   - Mid-tier / shield servers (origin shielding)
3. **Push vs. Pull CDN Models**
   - **Push CDN**: content is proactively uploaded to CDN; ideal for static, infrequently changing content
   - **Pull CDN**: CDN fetches content from origin on first request; ideal for dynamic or high-volume content
   - Hybrid approaches
4. **CDN Caching Mechanics**
   - Cache keys: URL, query params, headers, cookies
   - Cache-Control headers: max-age, s-maxage, no-cache, no-store, stale-while-revalidate
   - Purging and invalidation strategies
   - Cache hit ratio optimization
5. **Advanced CDN Features**
   - Edge computing / serverless at the edge (Cloudflare Workers, Lambda@Edge, Fastly Compute)
   - Image optimization and transcoding
   - Video streaming: HLS, DASH, adaptive bitrate
   - WebSocket support
   - Bot management
   - WAF (Web Application Firewall) at the edge
6. **CDN Providers**
   - Cloudflare, Akamai, AWS CloudFront, Fastly, Google Cloud CDN, Azure CDN
7. **Best Practices**
   - Use versioned URLs for cache-busting
   - Separate static and dynamic content
   - Monitor cache hit ratios
   - Configure appropriate TTLs per content type
   - Use origin shielding to reduce origin load



### E. Autoscaling

1. **Horizontal vs. Vertical Autoscaling**
2. **Autoscaling Triggers and Metrics**
   - CPU, memory, request count, queue depth, custom metrics
3. **Scaling Policies**
   - Step scaling, target tracking, predictive (ML-based) scaling
4. **Scaling Challenges**
   - Cold start / warm-up time
   - Scaling databases vs. stateless services
   - Cost implications and scaling limits
5. **Technologies**
   - Kubernetes Horizontal Pod Autoscaler (HPA), Vertical Pod Autoscaler (VPA), KEDA
   - AWS Auto Scaling Groups, GCP Managed Instance Groups
6. **Capacity Planning**
   - Load testing to determine scaling thresholds
   - Headroom and buffer capacity



---

## Part IV: Storage, Databases & Data Management

### A. Database Fundamentals & Choices

1. **Relational Databases (SQL)**
   - ACID guarantees
   - Schema design: normalization (1NF, 2NF, 3NF, BCNF)
   - Denormalization for performance
   - Joins: inner, outer, cross, self
   - Stored procedures, triggers, views
   - Connection pooling (PgBouncer, ProxySQL)
   - Popular: PostgreSQL, MySQL, Oracle, SQL Server
2. **Non-Relational Databases (NoSQL)**
   - **Key-Value Stores**
     - Simple, fast, high throughput
     - Use cases: sessions, caching, configuration
     - Examples: Redis, DynamoDB, Riak, etcd
   - **Document Stores**
     - Flexible schema (JSON/BSON documents)
     - Nested structures, embedded vs. referenced documents
     - Use cases: content management, user profiles, catalogs
     - Examples: MongoDB, CouchDB, Amazon DocumentDB, Firestore
   - **Wide-Column Stores**
     - Column families, row keys, sparse columns
     - Optimized for large-scale analytical and time-series data
     - Use cases: IoT data, event logging, recommendation engines
     - Examples: Cassandra, HBase, Google Bigtable, ScyllaDB
   - **Graph Databases**
     - Nodes, edges, properties
     - Traversal queries (BFS/DFS over relationships)
     - Use cases: social networks, fraud detection, knowledge graphs
     - Examples: Neo4j, Amazon Neptune, JanusGraph, TigerGraph
3. **NewSQL Databases**
   - Combining SQL semantics with NoSQL scalability
   - Examples: Google Spanner, CockroachDB, TiDB, VoltDB, YugabyteDB
4. **Time-Series Databases**
   - Optimized for append-heavy, time-stamped data
   - Downsampling, retention policies, compression
   - Examples: InfluxDB, TimescaleDB, Prometheus, QuestDB
5. **Vector Databases**
   - Store and query high-dimensional vectors (embeddings)
   - Approximate Nearest Neighbor (ANN) search algorithms
   - Use cases: semantic search, recommendation, LLM applications
   - Examples: Pinecone, Weaviate, Milvus, Qdrant, pgvector
6. **Schema Design & Data Modeling Strategies**
   - **Star Schema**: fact tables + dimension tables (for analytics)
   - **Snowflake Schema**: normalized dimensions
   - **Wide Table / Denormalized Design**: for OLAP workloads
   - **Entity-Attribute-Value (EAV)**: flexible but complex
   - **Polyglot Persistence**: using different databases for different data needs within one system
7. **Choosing the Right Database**
   - Decision framework based on: data model, query patterns, consistency needs, scale requirements, team expertise
   - Comparison matrix: SQL vs. NoSQL subtypes



### B. Database Scalability Techniques

1. **Read Replicas**
   - Offloading reads from the primary
   - Replication lag and read-after-write consistency
   - Use cases: reporting, analytics, search
2. **Database Partitioning / Sharding** (covered in Part II-F, referenced here)
3. **Connection Pooling**
   - Why: reducing connection overhead, managing limited DB connections
   - PgBouncer, ProxySQL, HikariCP, RDS Proxy
4. **Database Proxy and Middleware**
   - Vitess (YouTube), ProxySQL, PlanetScale
   - Query routing, connection management, shard awareness
5. **CQRS (Command Query Responsibility Segregation)** — overview (detailed in Part VIII)
   - Separate read and write models/stores
   - Eventually consistent read stores optimized for queries
6. **Materialized Views and Precomputed Aggregates**
   - Trade compute time for storage to speed reads
   - Refresh strategies: on-demand, periodic, incremental



### C. Indexing & Search

1. **Indexing Fundamentals**
   - **B-Tree Indexes**: balanced tree, efficient for range queries and point lookups
   - **Hash Indexes**: O(1) lookups, not suitable for range queries
   - **LSM-Tree + SSTables**: write-optimized (Cassandra, LevelDB, RocksDB)
   - **B-Tree vs. LSM-Tree**: read-optimized vs. write-optimized trade-offs
2. **Secondary Indexes**
   - Non-unique indexes on non-primary columns
   - Impact on write performance (index maintenance)
3. **Composite Indexes**
   - Multi-column indexes, leftmost prefix rule
   - Covering indexes (index-only scans)
4. **Global vs. Local Indexes (in Distributed Systems)**
   - Local index: each partition has its own index (efficient writes, scatter-gather reads)
   - Global index: single index across all partitions (efficient reads, expensive writes)
5. **Full-Text Search**
   - Inverted indexes
   - Tokenization, stemming, stop words, analyzers
   - TF-IDF, BM25 scoring
6. **Search Engines**
   - **Elasticsearch**: distributed, REST API, JSON-based, built on Apache Lucene
   - **Apache Solr**: also built on Lucene, XML/JSON, mature
   - **OpenSearch**: fork of Elasticsearch (AWS-backed)
   - **Meilisearch, Typesense**: lightweight, typo-tolerant search
7. **Search Architecture Patterns**
   - Dual-write vs. CDC-based indexing
   - Keeping search indexes in sync with source of truth
   - Near real-time (NRT) search
8. **Specialized Index Types**
   - Geospatial indexes (R-tree, Geohash, S2 cells, H3)
   - Bloom filters (probabilistic membership test)
   - Bitmap indexes (for low-cardinality columns)
   - Skip lists (used in Redis sorted sets)



### D. Data Durability, Backup & Recovery

1. **Write-Ahead Log (WAL)**
   - Ensuring atomicity and durability
   - WAL in PostgreSQL, redo log in MySQL/InnoDB
2. **Backup Strategies**
   - Full backups, incremental backups, differential backups
   - Logical backups (pg_dump, mysqldump) vs. physical backups (filesystem snapshots)
   - Continuous archiving (WAL archiving)
3. **Point-In-Time Recovery (PITR)**
   - Restoring to any specific moment using base backup + WAL replay
4. **Snapshots**
   - Database snapshots (RDS snapshots, EBS snapshots)
   - Consistent snapshots in distributed systems
5. **Disaster Recovery & Geo-Redundancy**
   - Multi-AZ and multi-region replication
   - Automated failover vs. manual failover
   - DR drills and runbooks
   - RPO and RTO targets per tier of data criticality
6. **Data Archival and Lifecycle Management**
   - Hot, warm, cold, archive storage tiers
   - Automated lifecycle policies (e.g., S3 lifecycle rules)
   - Compliance-driven retention policies



### E. Data Warehousing, Data Lakes & Analytics

1. **OLTP vs. OLAP**
   - Transactional workloads vs. analytical workloads
   - Row-oriented vs. columnar storage
2. **Data Warehouse**
   - ETL (Extract, Transform, Load) vs. ELT (Extract, Load, Transform)
   - Dimensional modeling (star schema, snowflake schema)
   - Technologies: Snowflake, Amazon Redshift, Google BigQuery, Azure Synapse
3. **Data Lake**
   - Schema-on-read, storing raw data in any format
   - Data lake vs. data warehouse vs. data lakehouse
   - Technologies: AWS S3 + Athena, Delta Lake, Apache Iceberg, Apache Hudi
4. **Stream Processing vs. Batch Processing**
   - **Batch**: Hadoop MapReduce, Apache Spark
   - **Stream**: Apache Flink, Kafka Streams, Apache Storm, Spark Structured Streaming
   - **Lambda Architecture**: batch + speed layer
   - **Kappa Architecture**: stream-only
5. **Change Data Capture (CDC)**
   - Capturing row-level changes from database logs
   - Debezium, AWS DMS, Maxwell
   - Use cases: keeping derived data stores in sync, event sourcing, audit logs



### F. Object / Blob Storage

1. **What is Object Storage?**
   - Flat namespace, metadata + data, HTTP-accessible
   - vs. block storage vs. file storage
2. **Technologies**
   - AWS S3, Google Cloud Storage, Azure Blob Storage, MinIO (self-hosted)
3. **Design Considerations**
   - Bucket naming, key design for parallelism
   - Multipart uploads for large files
   - Presigned URLs for direct client uploads
   - Versioning, lifecycle policies, cross-region replication
   - Consistency model (S3: strong read-after-write as of Dec 2020)
4. **Use Cases**
   - Static asset hosting, backups, data lake storage, media storage



---

## Part V: Communication, Protocols & API Design

### A. Networking Fundamentals for System Design

1. **OSI Model and TCP/IP Model — Quick Review**
   - Layers relevant to system design: L3 (IP), L4 (TCP/UDP), L7 (HTTP)
2. **DNS (Domain Name System)**
   - How DNS resolution works (recursive, iterative, root, TLD, authoritative)
   - DNS record types: A, AAAA, CNAME, MX, NS, TXT, SRV
   - DNS-based load balancing and failover
   - TTL and caching
   - DNS providers: Route 53, Cloudflare DNS, Google Cloud DNS
3. **TCP vs. UDP**
   - TCP: reliable, ordered, connection-oriented, flow/congestion control
   - UDP: unreliable, unordered, connectionless, low overhead
   - Use cases: TCP for web/API traffic; UDP for video streaming, gaming, DNS
4. **HTTP/1.1 vs. HTTP/2 vs. HTTP/3 (QUIC)**
   - **HTTP/1.1**: text-based, head-of-line blocking, keep-alive, pipelining (rarely used)
   - **HTTP/2**: binary framing, multiplexing, header compression (HPACK), server push, stream prioritization
   - **HTTP/3**: built on QUIC (UDP-based), 0-RTT connection setup, solves TCP head-of-line blocking
   - When to upgrade, backward compatibility
5. **TLS/SSL**
   - TLS handshake (RSA vs. ECDHE)
   - Certificate management, certificate authorities, Let's Encrypt
   - mTLS (mutual TLS) for service-to-service communication



### B. API Paradigms & Design

1. **REST (Representational State Transfer)**
   - Principles: stateless, resource-based, uniform interface, HATEOAS
   - HTTP methods: GET, POST, PUT, PATCH, DELETE
   - Status codes: 2xx, 3xx, 4xx, 5xx and their meanings
   - URL design: resource naming, nesting, filtering, pagination
   - Versioning strategies: URL path, query param, header-based
   - REST maturity model (Richardson's)
   - Pros: simplicity, ubiquity, cacheability
   - Cons: over-fetching, under-fetching, N+1 requests
2. **GraphQL**
   - Schema definition: types, queries, mutations, subscriptions
   - Resolvers and data loaders
   - Batching and caching (DataLoader pattern)
   - Pros: flexible queries, single endpoint, strongly typed schema
   - Cons: complexity, N+1 resolver problem, caching difficulty, security (query depth/complexity attacks)
   - When to use GraphQL vs. REST
3. **gRPC (Google Remote Procedure Call)**
   - Protocol Buffers (protobuf) for serialization
   - Streaming: unary, server streaming, client streaming, bidirectional streaming
   - HTTP/2-based transport
   - Pros: high performance, strong typing, code generation, streaming
   - Cons: limited browser support (gRPC-Web), less human-readable, tighter coupling
   - Use cases: inter-service communication, mobile backends, low-latency systems
4. **WebSockets**
   - Full-duplex communication over a single TCP connection
   - Handshake: HTTP upgrade mechanism
   - Use cases: real-time chat, live feeds, gaming, collaborative editing
   - Connection management: heartbeats, reconnection, scaling (sticky sessions or pub/sub)
5. **Server-Sent Events (SSE)**
   - Unidirectional (server → client) over HTTP
   - Auto-reconnection, event IDs
   - Use cases: live dashboards, notifications, stock tickers
   - SSE vs. WebSockets: when to choose which
6. **Webhooks**
   - HTTP callbacks: server pushes data to a registered URL on events
   - Reliability: retries, idempotency, signature verification
   - Use cases: payment notifications (Stripe), CI/CD triggers, integration
7. **Long Polling**
   - Client sends request, server holds until data is available or timeout
   - Simpler than WebSockets but less efficient
   - Use cases: legacy systems, environments where WebSockets aren't available
8. **API Design Best Practices**
   - Idempotent operations (and idempotency keys)
   - Pagination: offset-based, cursor-based, keyset pagination
   - Filtering, sorting, field selection
   - Error handling: consistent error format, meaningful error messages
   - Backward compatibility and deprecation strategy
   - API documentation: OpenAPI/Swagger, gRPC reflection
   - Rate limiting, authentication, and API keys



### C. Inter-Service Communication

1. **Synchronous Communication**
   - Request/Response: REST, gRPC
   - Pros: simple mental model, immediate feedback
   - Cons: temporal coupling, cascading failures, latency accumulation
2. **Asynchronous Communication**
   - Message-based: queues, topics, event streams
   - Pros: decoupling, resilience, buffering
   - Cons: complexity, eventual consistency, debugging difficulty
3. **API Gateway**
   - Single entry point for all client requests
   - Functions: routing, rate limiting, authentication, response aggregation, protocol translation
   - Technologies: Kong, AWS API Gateway, Apigee, Zuul, Ambassador
4. **Backend for Frontend (BFF)**
   - Separate API gateway per client type (web, mobile, IoT)
   - Tailoring response payloads per client
5. **Service Mesh**
   - Sidecar proxy pattern (Envoy)
   - Functions: service discovery, load balancing, circuit breaking, mTLS, observability
   - **Istio**: control plane + Envoy data plane
   - **Linkerd**: lightweight, Rust-based proxy
   - **Consul Connect**: service mesh with Consul
   - When a service mesh is overkill vs. essential
6. **Service Discovery**
   - **Client-Side Discovery**: client queries a registry (e.g., Eureka) and load-balances
   - **Server-Side Discovery**: load balancer queries the registry
   - Service registries: Consul, etcd, ZooKeeper, Eureka
   - DNS-based discovery (Kubernetes Services)
7. **Circuit Breaker Pattern (Inter-Service)**
   - States: closed, open, half-open
   - Monitoring failure rates and response times
   - Libraries: Resilience4j, Hystrix (deprecated but historically significant), Polly
   - Combining with retry, timeout, and bulkhead patterns



### D. Serialization Formats

1. **Text-Based**: JSON, XML, YAML
2. **Binary**: Protocol Buffers (protobuf), Apache Thrift, Avro, FlatBuffers, MessagePack
3. **Schema Evolution and Compatibility**
   - Forward compatibility, backward compatibility
   - Schema registries (Confluent Schema Registry for Kafka)
4. **Choosing a Serialization Format**
   - Human readability vs. performance
   - Schema enforcement vs. flexibility
   - Language support and tooling



---

## Part VI: Reliability, Observability & Security

### A. Reliability & Resilience Engineering

1. **Design for Failure**
   - "Everything fails, all the time" — Werner Vogels
   - Failure domains: process, machine, rack, datacenter, region
   - Blast radius reduction
2. **Circuit Breaker Pattern — Deep Dive**
   - Implementation: failure threshold, success threshold, timeout duration
   - Monitoring and alerting on circuit state changes
   - Cascading failure prevention
3. **Bulkhead Isolation**
   - Thread pool isolation, connection pool isolation
   - Limiting blast radius of a single failing dependency
   - Ship analogy: compartmentalized failure
4. **Timeout and Retry Strategies**
   - Setting appropriate timeouts (connect timeout vs. read timeout)
   - Retry budget: limiting total retries across the system
   - Exponential backoff: $\text{delay} = \text{base} \times 2^{\text{attempt}} + \text{jitter}$
   - Jitter: full jitter, equal jitter, decorrelated jitter
   - Retry amplification and its dangers
5. **Rate Limiting and Throttling**
   - Algorithms: Token Bucket, Leaky Bucket, Fixed Window, Sliding Window Log, Sliding Window Counter
   - Per-user, per-IP, per-API, global rate limits
   - Distributed rate limiting: Redis-based, centralized vs. local counters
   - HTTP 429 Too Many Requests, Retry-After header
6. **Idempotency**
   - Why it matters in distributed systems (retries, at-least-once delivery)
   - Idempotency keys
   - Designing idempotent APIs and message handlers
7. **Load Shedding and Admission Control**
   - Dropping low-priority requests under extreme load
   - Priority queues with admission control
   - Adaptive throttling
8. **Graceful Degradation**
   - Serving stale data, reduced functionality, or default responses
   - Feature flags for controlled degradation
   - Fallback services
9. **Compensating Transactions**
   - Rolling back distributed operations via compensation
   - Saga pattern implementation details
10. **Leader Election** (also covered in Part II-A)
    - Use cases in practice: partition leaders, job schedulers, single-writer patterns
    - Avoiding split-brain
11. **Chaos Engineering**
    - Principles of chaos engineering
    - Netflix Chaos Monkey, Gremlin, Litmus
    - Game days and failure injection in production
    - Steady-state hypothesis, blast radius control, automated rollback
12. **Self-Healing Systems**
    - Automatic restart (Kubernetes pod restart policies)
    - Auto-scaling in response to failures
    - Automated runbooks and remediation



### B. Observability & Monitoring

1. **The Three Pillars of Observability**
   - **Metrics**: numerical measurements over time
     - Types: counters, gauges, histograms, summaries
     - RED method: Rate, Errors, Duration
     - USE method: Utilization, Saturation, Errors
     - The Four Golden Signals (Google SRE): latency, traffic, errors, saturation
   - **Logging**: discrete events with contextual data
     - Structured logging (JSON) vs. unstructured
     - Log levels: DEBUG, INFO, WARN, ERROR, FATAL
     - Centralized log aggregation: ELK stack (Elasticsearch, Logstash, Kibana), Fluentd, Loki, Splunk
     - Log sampling and cost management
     - Correlation IDs for tracing through logs
   - **Tracing**: end-to-end request path through services
     - Distributed tracing concepts: trace, span, parent-child relationships
     - Trace context propagation (W3C Trace Context, B3 headers)
     - Technologies: Jaeger, Zipkin, AWS X-Ray, Google Cloud Trace
     - OpenTelemetry as the unified standard
2. **Health Checks**
   - **Liveness Probes**: is the process alive? (restart if not)
   - **Readiness Probes**: is the service ready to handle traffic? (remove from LB if not)
   - **Startup Probes**: has the service finished initializing?
   - Custom health check endpoints (deep health checks: checking dependencies)
3. **Alerting**
   - Alert on symptoms (user-facing) not causes
   - Severity levels and escalation policies
   - Reducing alert fatigue: meaningful thresholds, alert deduplication, runbooks
   - On-call practices: PagerDuty, Opsgenie
4. **Dashboards and Visualization**
   - Grafana, Datadog, New Relic, Kibana
   - Key dashboards: service health, infrastructure, business metrics, SLO tracking
5. **SLI, SLO, SLA**
   - **SLI (Service Level Indicator)**: the metric (e.g., % of requests < 200ms)
   - **SLO (Service Level Objective)**: the target (e.g., 99.9% of requests < 200ms)
   - **SLA (Service Level Agreement)**: the contract with consequences
   - Error budgets and their role in balancing reliability with feature velocity
6. **Profiling and Performance Analysis**
   - CPU profiling, memory profiling, flame graphs
   - APM tools: Datadog APM, New Relic, Dynatrace
7. **Cost Monitoring and Optimization**
   - Cloud cost dashboards
   - Tagging resources for cost attribution
   - Anomaly detection on spend



### C. Security in System Design

1. **Authentication (AuthN)**
   - Username/password, multi-factor authentication (MFA)
   - **OAuth 2.0**: authorization code flow, client credentials, PKCE
   - **OpenID Connect (OIDC)**: identity layer on top of OAuth 2.0
   - **JWT (JSON Web Tokens)**: structure (header, payload, signature), access tokens, refresh tokens, token rotation
   - **API Keys**: simple but limited, typically for server-to-server
   - **SAML**: enterprise SSO
   - **Session-based authentication**: server-side sessions, session stores (Redis)
   - **Passwordless authentication**: magic links, WebAuthn/FIDO2
2. **Authorization (AuthZ)**
   - **RBAC (Role-Based Access Control)**: roles → permissions
   - **ABAC (Attribute-Based Access Control)**: policies based on user/resource/environment attributes
   - **ReBAC (Relationship-Based Access Control)**: authorization based on relationships (e.g., Google Zanzibar)
   - **Policy-as-Code**: Open Policy Agent (OPA), Casbin
   - **ACLs (Access Control Lists)**: per-resource permission lists
   - Centralized vs. decentralized authorization
3. **Secure Communication**
   - **TLS/SSL**: in-transit encryption for all external and internal communication
   - **mTLS**: mutual authentication between services (service mesh, zero trust)
   - **Certificate Management**: PKI, certificate rotation, short-lived certificates
4. **Network Security**
   - Firewalls, Security Groups, NACLs
   - **Zero Trust Architecture**: never trust, always verify; micro-segmentation
   - VPNs, private networking (VPC peering, PrivateLink)
   - **DDoS Mitigation**: rate limiting, CDN-based protection, AWS Shield, Cloudflare
   - WAF (Web Application Firewall): OWASP rule sets
5. **Data Security**
   - **Encryption at Rest**: AES-256, AWS KMS, envelope encryption
   - **Encryption in Transit**: TLS 1.2/1.3
   - **Key Management**: HSMs (Hardware Security Modules), KMS services, key rotation
   - **Data Masking and Tokenization**: PCI DSS compliance for payment data
   - **Data Classification**: public, internal, confidential, restricted
6. **Application Security**
   - **OWASP Top 10**: injection (SQLi), XSS, CSRF, SSRF, broken authentication, security misconfiguration, insecure deserialization, etc.
   - Input validation and sanitization
   - Content Security Policy (CSP)
   - Parameterized queries / prepared statements
   - CORS (Cross-Origin Resource Sharing) configuration
   - Dependency scanning (Snyk, Dependabot)
   - SAST, DAST, SCA in CI/CD pipelines
7. **Secrets Management**
   - Vault (HashiCorp), AWS Secrets Manager, Google Secret Manager
   - Never hardcode secrets; inject via environment or secret stores
   - Secret rotation
8. **Audit Logging and Compliance**
   - Immutable audit trails
   - Who did what, when, from where
   - Compliance frameworks: SOC 2, GDPR, HIPAA, PCI DSS
   - Data residency and sovereignty requirements
9. **Security in Microservices**
   - Service-to-service authentication (mTLS, JWT propagation)
   - API gateway as a security boundary
   - Least privilege principle per service
   - Sidecar-based security enforcement (service mesh)



---

## Part VII: Cloud-Native & Modern Architecture

### A. Stateless vs. Stateful Services

1. **Stateless Services**
   - No local state; all state in external stores (DB, cache, object store)
   - Easy to scale horizontally, replace, and load balance
   - Examples: API servers, web servers, compute workers
2. **Stateful Services**
   - Maintain state locally (in-memory data, local disk)
   - Harder to scale, require sticky sessions or replication
   - Examples: databases, caches, real-time session managers, WebSocket servers
3. **Strategies for Managing State**
   - Externalize state (Redis, S3, DB)
   - StatefulSets in Kubernetes (stable identities, persistent volumes)
   - Session affinity when externalizing state isn't feasible
4. **Designing for Statelessness**
   - Twelve-Factor App methodology (factor VI: stateless processes)
   - Horizontal scaling becomes trivial



### B. Containerization & Orchestration

1. **Containers**
   - What is a container? Difference from VMs
   - Container images: layers, registries (Docker Hub, ECR, GCR, ACR)
   - **Docker**: Dockerfile best practices, multi-stage builds, image security scanning
   - Container runtimes: containerd, CRI-O
   - OCI standards
2. **Container Orchestration with Kubernetes**
   - **Core Concepts**: Pods, Nodes, Clusters, Namespaces
   - **Workloads**: Deployments, ReplicaSets, StatefulSets, DaemonSets, Jobs, CronJobs
   - **Networking**: Services (ClusterIP, NodePort, LoadBalancer), Ingress controllers, Network Policies
   - **Storage**: PersistentVolumes (PV), PersistentVolumeClaims (PVC), StorageClasses
   - **Configuration**: ConfigMaps, Secrets
   - **Scaling**: HPA, VPA, Cluster Autoscaler, KEDA
   - **Service Discovery**: CoreDNS, headless services
   - **Scheduling**: resource requests/limits, affinity/anti-affinity, taints/tolerations
   - **Health management**: liveness, readiness, startup probes
   - **Operators and Custom Resource Definitions (CRDs)**
   - **Helm**: package management for Kubernetes
3. **Deployment Strategies**
   - **Rolling Update**: gradually replace old pods with new ones
   - **Blue-Green Deployment**: two identical environments, switch traffic atomically
   - **Canary Deployment**: route small % of traffic to new version, gradually increase
   - **A/B Testing**: route based on user segment for experimentation
   - **Feature Flags**: decouple deployment from release (LaunchDarkly, Unleash)
   - **Shadow / Dark Launches**: mirror production traffic to new version without serving responses
   - **Rollback strategies and automation**
4. **Other Orchestrators**
   - Amazon ECS / Fargate
   - Docker Swarm (historical)
   - Nomad (HashiCorp)
5. **CI/CD Pipelines for Containers**
   - Build → Test → Scan → Push → Deploy
   - GitOps: ArgoCD, Flux
   - Progressive delivery: Argo Rollouts, Flagger



### C. Infrastructure as Code (IaC)

1. **Why IaC?**
   - Reproducibility, version control, auditability, automation
   - Eliminates configuration drift
2. **Declarative vs. Imperative IaC**
   - Declarative: Terraform, CloudFormation, Pulumi (desired state)
   - Imperative: scripts, Ansible playbooks (step-by-step instructions)
3. **Key Tools**
   - **Terraform**: multi-cloud, HCL language, state management, modules, providers
   - **AWS CloudFormation**: AWS-native, YAML/JSON templates, nested stacks
   - **Pulumi**: general-purpose programming languages (TypeScript, Python, Go)
   - **CDK (Cloud Development Kit)**: AWS CDK, CDKTF
   - **Ansible**: configuration management and provisioning
4. **IaC Best Practices**
   - Remote state management (S3 + DynamoDB locking for Terraform)
   - Modular, reusable components
   - Plan/Preview before apply
   - CI/CD integration for infrastructure changes
   - Drift detection
   - Secrets management in IaC (avoid hardcoding)



### D. Serverless & Event-Driven Architectures

1. **Serverless Computing**
   - **Functions as a Service (FaaS)**
     - AWS Lambda, Google Cloud Functions, Azure Functions, Cloudflare Workers
     - Trigger types: HTTP, queue, schedule, storage events, database streams
     - Cold starts: causes, mitigation (provisioned concurrency, keep-warm, SnapStart)
     - Execution limits: timeout, memory, payload size
     - Pricing: pay-per-invocation and compute-time
   - **Backend as a Service (BaaS)**
     - Firebase, Supabase, AWS Amplify
   - **Serverless Databases**: DynamoDB, Aurora Serverless, Neon, PlanetScale
   - **Serverless Containers**: AWS Fargate, Google Cloud Run, Azure Container Instances
2. **Event-Driven Architecture (EDA)**
   - Events as first-class citizens
   - Event producers, event routers/brokers, event consumers
   - Event types: domain events, integration events, notification events
   - Thin events vs. fat events
   - Event schemas and contracts
   - EventBridge, Kafka, SNS/SQS fan-out
3. **Event Sourcing**
   - Storing state as a sequence of immutable events
   - Rebuilding state by replaying events
   - Event store design
   - Snapshots for performance
   - Pros: complete audit trail, temporal queries, easy debugging
   - Cons: complexity, eventual consistency, storage growth, schema evolution
4. **CQRS (Command Query Responsibility Segregation)** — Deep Dive
   - Separate write model (commands) from read model (queries)
   - Independent scaling of reads and writes
   - Different storage technologies for each side
   - Projections: building read models from events
   - CQRS + Event Sourcing: the common pairing
   - When CQRS is overkill
5. **Choreography vs. Orchestration in Event-Driven Systems**
   - Choreography: services react to events independently (decentralized)
   - Orchestration: a central coordinator directs the flow
   - Trade-offs: flexibility vs. visibility, debugging complexity



### E. Multi-Cloud, Hybrid & Edge

1. **Multi-Cloud Strategies**
   - Avoiding vendor lock-in
   - Using best-of-breed services from different providers
   - Complexity and operational overhead
   - Abstraction layers: Kubernetes as a multi-cloud platform, Terraform for provisioning
2. **Hybrid Cloud**
   - On-premises + cloud integration
   - Use cases: compliance, legacy systems, data gravity
   - Technologies: AWS Outposts, Azure Arc, Google Anthos
3. **Geo-Distributed Deployments**
   - Multi-region active-active architectures
   - Data replication across regions
   - Latency-based routing (GeoDNS, anycast)
   - Challenges: cross-region consistency, conflict resolution, compliance
4. **Edge Computing**
   - Processing data closer to the source
   - Edge vs. cloud vs. fog computing
   - Use cases: IoT, autonomous vehicles, AR/VR, real-time video processing
   - CDN edge computing (Cloudflare Workers, Lambda@Edge)
   - 5G-driven edge: mobile edge computing (MEC)
5. **Data Sovereignty and Compliance**
   - Regulations requiring data to stay in specific regions
   - Architectural patterns for compliance (region-pinned services, data residency controls)



### F. Cost Optimization & Resource Planning

1. **Cloud Pricing Models**
   - On-demand, reserved instances, spot/preemptible instances, savings plans
   - Per-request pricing (serverless), per-hour pricing (VMs), per-GB pricing (storage/egress)
   - Data transfer costs (often the hidden cost)
2. **Cost Optimization Strategies**
   - Right-sizing instances
   - Autoscaling to match demand
   - Spot instances for fault-tolerant workloads
   - Reserved capacity for predictable workloads
   - Storage tiering (hot → warm → cold → archive)
   - Caching to reduce database and compute costs
   - Compression to reduce bandwidth and storage
   - Deleting unused resources (zombie resources)
3. **FinOps Practices**
   - Cost allocation via tagging
   - Budget alerts and anomaly detection
   - Cross-functional cost ownership
   - Continuous cost review in architecture decisions
4. **Build vs. Buy Decisions**
   - Managed services vs. self-hosted
   - Total cost of ownership (TCO): licensing, ops, engineering time
   - Vendor lock-in considerations



---

## Part VIII: Design & Architectural Patterns

### A. Architectural Styles

1. **Monolithic Architecture**
   - Single deployable unit
   - Pros: simplicity, easier debugging, single deployment
   - Cons: scalability limits, long deployment cycles, tight coupling
   - Modular monolith: a structured approach
2. **Service-Oriented Architecture (SOA)**
   - Enterprise Service Bus (ESB)
   - Historical context, relationship to microservices
3. **Microservices Architecture**
   - Independently deployable services, each owning its data
   - Domain-Driven Design (DDD) and bounded contexts
   - Pros: independent scaling, technology diversity, team autonomy, fault isolation
   - Cons: distributed system complexity, network latency, data consistency, operational overhead
   - When to use monolith vs. microservices (team size, system complexity, maturity)
4. **Event-Driven Architecture** (covered in Part VII-D)
5. **Space-Based Architecture**
   - In-memory data grids, processing units
   - Eliminating database as a bottleneck
   - Use cases: high-throughput, low-latency (trading platforms, gaming)



### B. Structural & Integration Patterns

1. **Strangler Fig Pattern**
   - Incrementally replacing a legacy system
   - Routing traffic between old and new systems
   - Phased migration strategy
2. **Sidecar Pattern**
   - Deploying a helper process alongside the main service
   - Use cases: logging, monitoring, security, configuration
   - Service mesh as sidecar-at-scale
3. **Ambassador Pattern**
   - A helper service that handles remote connections on behalf of the main service
   - Use cases: circuit breaking, retry logic, routing to external services
4. **Anti-Corruption Layer (ACL)**
   - A translation layer between two systems with different models
   - Protecting new systems from legacy system's domain model
5. **Gateway Routing / Gateway Aggregation / Gateway Offloading**
   - **Routing**: routing to appropriate backend based on request attributes
   - **Aggregation**: combining multiple backend responses into one
   - **Offloading**: handling cross-cutting concerns (auth, SSL, rate limiting)
6. **API Composition**
   - Composing API responses from multiple microservices
   - API Composer/Aggregator service
   - Challenges: latency, partial failures, data consistency
7. **Backends for Frontends (BFF)** (expanded)
   - Why a single API for all clients is problematic
   - One BFF per client type (mobile, web, IoT, third-party)
8. **Pipes and Filters**
   - Processing data through a sequence of transformations
   - Each filter is an independent component
   - Use cases: data processing pipelines, ETL
9. **Claim Check Pattern**
   - Storing large payloads in external storage, passing a reference ("claim check") in the message
   - Reducing message queue payload size
10. **Competing Consumers**
    - Multiple consumers pulling from the same queue
    - Automatic load distribution
    - Ordering considerations (per-partition ordering)



### C. Data Management Patterns

1. **CQRS** (detailed in Part VII-D)
2. **Event Sourcing** (detailed in Part VII-D)
3. **Transactional Outbox Pattern**
   - Writing events to an outbox table in the same transaction as the business data
   - A separate process polls the outbox and publishes to the message broker
   - Guarantees at-least-once event publishing
4. **Change Data Capture (CDC)**
   - Using database logs to capture changes and stream them
   - Debezium + Kafka Connect
   - Use cases: syncing databases, feeding search indexes, materializing views
5. **Database per Service**
   - Each microservice owns its data store
   - No shared databases
   - Challenges: distributed queries, data consistency, joins across services
6. **Shared Database (Anti-Pattern)**
   - Multiple services sharing a single database
   - Why it's problematic: tight coupling, schema changes affect all, scaling limitations
   - When it might be acceptable (small teams, early stages)
7. **Saga Pattern** (detailed in Part II-G)
8. **Materialized View Pattern**
   - Precomputed views for complex queries
   - Refresh strategies
9. **Index Table Pattern**
   - Secondary index in a separate table/store for efficient querying
10. **Data Sharding Pattern** (covered in Part II-F)



### D. Reliability & Deployment Patterns

1. **Circuit Breaker** (covered in Part VI-A)
2. **Bulkhead** (covered in Part VI-A)
3. **Retry with Backoff** (covered in Part VI-A)
4. **Deployment Stamps**
   - Deploying identical, independent copies of the system
   - Each stamp serves a subset of tenants
   - Scaling by adding stamps
   - Isolation between stamps for fault tolerance
5. **Geode Pattern**
   - Deploying a full stack per region/geography
   - Request routing based on user location
   - Each geode can operate independently
6. **Health Endpoint Monitoring**
7. **Queue-Based Load Leveling**
   - Using a queue between the producer and consumer to smooth out bursts
8. **Throttling Pattern**
   - Limiting resource consumption per tenant or per operation
   - Multi-tenant rate limiting
9. **Valet Key Pattern**
   - Granting direct, limited access to a resource (e.g., presigned S3 URL)
   - Reducing load on the application layer



---

## Part IX: Case Studies & Practical System Design Scenarios

### A. Systematic Approach to Solving Design Problems

1. **Step 1: Clarify Requirements**
   - Functional requirements (features)
   - Non-functional requirements (scale, latency, consistency, availability)
   - Constraints and assumptions
2. **Step 2: Back-of-the-Envelope Estimation**
   - Users, QPS, storage, bandwidth
3. **Step 3: Define API Interface**
   - Key endpoints or operations
4. **Step 4: Define Data Model / Schema**
   - Entities, relationships, storage choices
5. **Step 5: High-Level Architecture**
   - Block diagram: clients, LB, services, databases, caches, queues
6. **Step 6: Deep Dive into Key Components**
   - Address bottlenecks, scaling challenges, consistency issues
7. **Step 7: Address Non-Functional Requirements**
   - Availability, monitoring, security, cost
8. **Step 8: Discuss Trade-offs and Alternatives**
   - Justify decisions, acknowledge alternatives



### B. Classic System Design Problems

1. **Designing a URL Shortener (e.g., TinyURL, Bit.ly)**
   - Key generation: counter-based, hash-based, base62 encoding
   - Read-heavy system design
   - Redirection (301 vs. 302)
   - Analytics and click tracking
   - Custom aliases, expiration
   - Database choice, caching strategy
   - Scaling to billions of URLs

2. **Designing a Paste Service (e.g., Pastebin)**
   - Similar to URL shortener but with content storage
   - Object storage for paste content
   - Metadata storage
   - Syntax highlighting, expiration, privacy settings

3. **Designing a Social Media Feed / Timeline (e.g., Twitter, Instagram)**
   - Fan-out on write vs. fan-out on read (push vs. pull model)
   - Hybrid approach for celebrities (high follower count)
   - Feed ranking and sorting (chronological vs. algorithmic)
   - Timeline caching
   - Media storage and serving
   - Follower/following graph

4. **Designing a Chat / Messaging System (e.g., WhatsApp, Slack, Facebook Messenger)**
   - 1:1 messaging and group messaging
   - Real-time delivery: WebSockets, long polling
   - Message storage: per-user or per-conversation
   - Presence and typing indicators
   - Read receipts and delivery status
   - End-to-end encryption
   - Push notifications for offline users
   - Message ordering and consistency
   - Media sharing (images, videos, files)
   - Scaling WebSocket connections (connection servers)

5. **Designing a Notification System**
   - Notification types: push, SMS, email, in-app
   - Templating and personalization
   - Priority and rate limiting per user
   - Delivery guarantees and retry
   - User preferences and opt-out
   - Deduplication
   - Analytics (open rates, click-through)

6. **Designing a Rate Limiter**
   - Fixed window, sliding window, token bucket, leaky bucket algorithms
   - Distributed rate limiting with Redis
   - Per-user, per-IP, per-API rules
   - Race conditions and atomic operations
   - Hard vs. soft rate limiting

7. **Designing a Web Crawler**
   - BFS/DFS traversal of the web graph
   - URL frontier: priority, politeness (robots.txt, crawl delay)
   - Deduplication: URL dedup (bloom filter), content dedup (simhash, MinHash)
   - Distributed crawling: partitioning URLs, coordinating workers
   - Handling traps (infinite loops, dynamic content)
   - Parsing and storing crawled data
   - Scheduling recrawls (freshness)

8. **Designing a Search Engine (e.g., Google Search, simplified)**
   - Web crawling (above) → indexing → ranking → serving
   - Inverted index construction
   - PageRank and link analysis (brief overview)
   - Query processing: tokenization, stemming, spell correction
   - Relevance scoring (BM25, learning-to-rank)
   - Autocomplete / typeahead
   - Caching search results

9. **Designing a Typeahead / Autocomplete System**
   - Trie data structure
   - Precomputed suggestions with frequency/ranking
   - Updating the trie (offline vs. online)
   - Distributed trie (sharding by prefix)
   - Caching popular queries

10. **Designing a Video Streaming Platform (e.g., YouTube, Netflix)**
    - Video upload pipeline: transcoding, different resolutions/codecs
    - Adaptive bitrate streaming (HLS, DASH)
    - CDN for video delivery
    - Video metadata storage and search
    - Recommendation engine (brief)
    - View counting and analytics at scale
    - Live streaming vs. on-demand
    - Content moderation pipeline

11. **Designing a File Storage / Cloud Drive (e.g., Dropbox, Google Drive)**
    - File upload (chunked uploads, resumable uploads)
    - Deduplication (content-addressable storage, hashing chunks)
    - File syncing across devices
    - Conflict resolution for concurrent edits
    - Metadata service, block storage service
    - Versioning and trash/recovery
    - Sharing and permissions
    - Notification of changes (long polling, WebSocket)

12. **Designing a Ride-Sharing / Food Delivery System (e.g., Uber, Lyft, DoorDash)**
    - Matching drivers/riders (nearest driver, ETA-based)
    - Geospatial indexing (Geohash, S2, H3, quadtree)
    - Real-time location tracking and updates
    - Pricing engine (surge pricing, dynamic pricing)
    - Trip lifecycle and state management
    - Payment and receipt processing
    - ETA estimation
    - Dispatch and routing optimization
    - Driver/rider rating system

13. **Designing an E-Commerce Platform (e.g., Amazon)**
    - Product catalog service
    - Shopping cart (stateless with client-side vs. server-side storage)
    - Inventory management (avoiding overselling)
    - Order processing pipeline (saga for payment → inventory → shipping)
    - Search and recommendations
    - Review and rating system
    - Payment processing integration
    - Warehouse and fulfillment (brief)

14. **Designing a Distributed Key-Value Store (e.g., DynamoDB, Riak)**
    - Consistent hashing for partitioning
    - Replication and quorum reads/writes
    - Vector clocks for conflict detection
    - Gossip protocol for membership
    - Merkle trees for anti-entropy
    - Hinted handoff for temporary failures
    - Tunable consistency

15. **Designing a Distributed Message Queue (e.g., Kafka)**
    - Broker architecture, topics, partitions
    - Producer partitioning and batching
    - Consumer groups and offset management
    - Replication and leader election
    - Retention and compaction
    - Exactly-once delivery
    - Ordering guarantees

16. **Designing a Unique ID Generator**
    - UUID (v4): random, no coordination, 128-bit, non-sortable
    - Snowflake ID (Twitter): timestamp + machine ID + sequence number, 64-bit, sortable
    - Database auto-increment with range allocation
    - ULID: sortable, 128-bit
    - Considerations: uniqueness, sortability, size, performance, coordination

17. **Designing a Metrics / Monitoring System (e.g., Prometheus, Datadog)**
    - Data model: metric name, labels, timestamp, value
    - Ingestion pipeline: push vs. pull model
    - Time-series storage (compression, downsampling)
    - Query engine (PromQL-like)
    - Alerting rules and evaluation
    - Dashboard rendering
    - Retention and archival

18. **Designing a Ticketing System (e.g., Ticketmaster)**
    - Handling flash sales and high concurrency
    - Seat selection and reservation with locking
    - Virtual waiting room / queue
    - Payment processing with time-limited holds
    - Preventing bots and scalpers
    - Inventory consistency

19. **Designing a Hotel / Flight Booking System**
    - Availability search (calendar-based queries)
    - Reservation with double-booking prevention
    - Distributed locking or optimistic concurrency
    - Payment and cancellation workflows
    - Notification and confirmation
    - Third-party integration (GDS systems for flights)

20. **Designing a Collaborative Editing System (e.g., Google Docs)**
    - Real-time collaboration: Operational Transformation (OT) vs. CRDTs
    - WebSocket connections for live updates
    - Versioning and history
    - Conflict resolution
    - Access control and sharing
    - Offline mode and sync



### C. System Design Interview Tips & Walkthroughs

1. **Communication Best Practices**
   - Drive the conversation, ask clarifying questions
   - Think out loud, explain trade-offs
   - Start broad, then drill deep
   - Manage your time (don't spend 15 min on one component)
2. **Common Mistakes**
   - Jumping to solutions without understanding requirements
   - Over-engineering (adding every pattern you know)
   - Ignoring non-functional requirements
   - Not discussing trade-offs
   - Failing to estimate scale
3. **Evaluation Criteria (What Interviewers Look For)**
   - Problem-solving ability
   - Breadth of knowledge
   - Depth in specific areas
   - Trade-off analysis
   - Communication clarity
4. **Mock Interview Walkthroughs**
   - Step-by-step narrated design of 2-3 systems
   - Annotated diagrams
   - Red flags and how to avoid them



---

## Part X: Emerging Topics & Future Directions

### A. AI/ML in System Design

1. **ML Model Serving Infrastructure**
   - Online inference vs. batch inference
   - Model serving frameworks: TensorFlow Serving, TorchServe, Triton Inference Server
   - A/B testing and shadow models
   - Model versioning and rollback
2. **Feature Stores**
   - Centralized feature management for ML
   - Online (low-latency) vs. offline (batch) feature serving
   - Technologies: Feast, Tecton
3. **Training Infrastructure**
   - Distributed training: data parallelism, model parallelism
   - GPU/TPU cluster management
   - MLOps pipelines: Kubeflow, MLflow, SageMaker
4. **Vector Search and Embedding-Based Systems**
   - Embedding generation for search, recommendations, anomaly detection
   - ANN indexes: HNSW, IVF, Product Quantization
   - RAG (Retrieval-Augmented Generation) architectures for LLM applications
5. **AI-Driven System Optimization**
   - Autoscaling with ML predictions
   - Anomaly detection for monitoring
   - Intelligent caching and prefetching
   - ML-based query optimization
6. **LLM Application Architecture**
   - Prompt management, context window management
   - Chunking and retrieval strategies
   - Guardrails and content filtering
   - Cost optimization (caching, model routing, batching)
   - Streaming responses



### B. IoT Architectures

1. **IoT System Design Challenges**
   - Massive device scale (millions of devices)
   - Constrained devices (limited CPU, memory, battery)
   - Intermittent connectivity
2. **Communication Protocols**
   - MQTT (lightweight pub/sub), CoAP, AMQP, HTTP
3. **IoT Platform Architecture**
   - Device registry and management
   - Ingestion pipeline (IoT Hub, MQTT broker → event stream → processing)
   - Edge processing vs. cloud processing
   - Digital twins
   - OTA (Over-The-Air) firmware updates
4. **Technologies**
   - AWS IoT Core, Azure IoT Hub, Google Cloud IoT Core
   - Eclipse Mosquitto, EMQX



### C. Blockchain & Decentralized Systems

1. **Blockchain Fundamentals for System Designers**
   - Distributed ledger, consensus (PoW, PoS, BFT variants)
   - Immutability and transparency
2. **Decentralized Applications (dApps)**
   - Smart contracts, on-chain vs. off-chain storage
   - Scalability challenges: L1 vs. L2 solutions
3. **When Blockchain Makes Sense**
   - Multi-party trust, audit trails, tokenization
   - When it doesn't: single-owner systems, high-throughput requirements
4. **Web3 Architecture Patterns**
   - Decentralized storage (IPFS, Arweave)
   - Decentralized identity (DIDs)
   - Oracles (Chainlink) for external data



### D. Sustainability & Green Computing

1. **Environmental Impact of Computing**
   - Data center energy consumption, carbon footprint
   - Embodied carbon in hardware
2. **Green Architecture Principles**
   - Right-sizing resources
   - Region selection based on renewable energy
   - Efficient algorithms and data structures
   - Reducing data transfer and storage waste
3. **Carbon-Aware Computing**
   - Shifting workloads to times/regions with cleaner energy
   - Carbon-aware Kubernetes schedulers
   - Green Software Foundation principles
4. **Measuring and Reporting**
   - Cloud provider sustainability dashboards
   - Carbon intensity metrics



### E. Privacy-First & Regulation-Driven Architecture

1. **Privacy by Design Principles**
2. **Data Minimization and Purpose Limitation**
3. **Right to Erasure (GDPR Article 17)**
   - Architectural implications: soft deletes, crypto-shredding
4. **Consent Management Platforms**
5. **Data Processing Agreements and Cross-Border Transfers**



### F. Trends to Watch

1. **WebAssembly (Wasm) for Server-Side and Edge**
2. **eBPF for Observability and Networking**
3. **Cell-Based Architecture**
4. **Platform Engineering and Internal Developer Platforms**
5. **AI-Driven Software Engineering (AI Code Assistants, AI Ops)**



---

## Appendices

### Appendix A: Quick Reference — Key Formulas & Numbers

- Latency numbers every engineer should know
- Powers of two reference table
- Availability "nines" and corresponding downtime
- Little's Law: $L = \lambda \times W$
- Amdahl's Law: $S = \frac{1}{(1-p) + \frac{p}{n}}$
- Quorum formula: $W + R > N$
- Consistent hashing virtual nodes formula
- Back-of-the-envelope estimation templates



### Appendix B: Technology Comparison Tables

- SQL databases comparison (PostgreSQL, MySQL, SQL Server, Oracle)
- NoSQL databases comparison (MongoDB, Cassandra, DynamoDB, Redis, Neo4j)
- Message queue comparison (Kafka, RabbitMQ, SQS, Pulsar, NATS)
- Load balancer comparison (NGINX, HAProxy, Envoy, cloud-native)
- Cache comparison (Redis vs. Memcached)
- API paradigm comparison (REST vs. GraphQL vs. gRPC)



### Appendix C: Recommended Reading & Resources

- **Books**: *Designing Data-Intensive Applications* (Kleppmann), *System Design Interview* (Alex Xu, Vol. 1 & 2), *Building Microservices* (Newman), *Site Reliability Engineering* (Google SRE Book), *The Art of Scalability*, *Database Internals* (Petrov)
- **Papers**: Google MapReduce, Google File System, Amazon Dynamo, Google Bigtable, Google Spanner, Raft, Paxos Made Simple, Kafka
- **Online resources**: System Design Primer (GitHub), ByteByteGo, Grokking the System Design Interview, High Scalability blog, Martin Fowler's blog, AWS Architecture Center
- **Practice platforms**: mock interview platforms, design doc writing practice



### Appendix D: Glossary of Key Terms

- Comprehensive alphabetical glossary of all key terms, acronyms, and concepts referenced throughout the guide