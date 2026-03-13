# Cloud Design Patterns - Part 1: Foundations & Taxonomy

## 1.0 Foundations & Taxonomy

### 1.1 Pattern Theory & Classification
#### 1.1.1 Definition of a Cloud Design Pattern
- 1.1.1.1 Pattern vs. architecture vs. principle — granularity and applicability spectrum
- 1.1.1.2 Gang of Four roots — creational/structural/behavioral mapped to cloud domains
- 1.1.1.3 Cloud-specific extensions — distributed systems, operational, cost, and compliance concerns
- 1.1.1.4 Forces & context triad — problem statement, solution space, consequences
#### 1.1.2 Classification Systems
- 1.1.2.1 Microsoft Azure Well-Architected taxonomy
  - 1.1.2.1.1 8 pillars: Availability, Data Mgmt, Design & Impl, Messaging, Mgmt & Monitoring, Perf, Resilience, Security
- 1.1.2.2 AWS re:Invent quadrant — Reliable / Scalable / Secure / Cost-Efficient
- 1.1.2.3 Google Cloud Architecture Framework — operational excellence, security, reliability, performance, cost, privacy
- 1.1.2.4 CNCF landscape — microservices-native, container-first, 12-factor aligned
#### 1.1.3 Pattern Relationships & Composition
- 1.1.3.1 Supporting patterns — Health Endpoint enables Circuit Breaker; Cache-Aside enables Throttling
- 1.1.3.2 Conflicting patterns — Strong Consistency vs. High Availability (CAP-forced exclusion)
- 1.1.3.3 Pattern families — CQRS + Event Sourcing + Saga + Outbox form composable cluster
- 1.1.3.4 Pattern over-application — applying microservice patterns below team/traffic threshold
#### 1.1.4 Pattern Lifecycle
- 1.1.4.1 Emergent origins — Netflix Circuit Breaker, AWS Bulkhead born from production incidents
- 1.1.4.2 Standardization cycle — war story → OSS library → CNCF RFC → textbook chapter
- 1.1.4.3 Pattern obsolescence — service mesh absorbs retry/circuit-breaker from application code

### 1.2 CAP Theorem & Distributed Systems Trade-offs
#### 1.2.1 CAP Formal Properties
- 1.2.1.1 Consistency — linearizable reads; every read returns most recent write or error
  - 1.2.1.1.1 Linearizability — operations appear instantaneous and globally ordered
  - 1.2.1.1.2 Sequential consistency — agreed global order, not necessarily wall-clock order
- 1.2.1.2 Availability — every non-failed node returns a response within bounded time
  - 1.2.1.2.1 Nines budgets — 99.9%=8.7h/yr, 99.99%=52m/yr, 99.999%=5.2m/yr downtime
  - 1.2.1.2.2 Response-time SLA (latency bound) vs. uptime SLA (error rate bound)
- 1.2.1.3 Partition Tolerance — correct behavior despite arbitrary message loss/delay
  - 1.2.1.3.1 Partition taxonomy — hard split, packet loss, asymmetric routing, gray failure
#### 1.2.2 CAP Placement of Common Systems
- 1.2.2.1 CP — ZooKeeper, etcd, HBase — refuse writes rather than diverge during partition
- 1.2.2.2 AP — Cassandra, CouchDB, Riak, DynamoDB (eventual mode) — return possibly stale data
- 1.2.2.3 CA — single-node RDBMS; only coherent when partitions are impossible
#### 1.2.3 PACELC Extension
- 1.2.3.1 P branch — partition scenario: Availability vs. Consistency (as CAP)
- 1.2.3.2 E branch — else/normal operation: Latency vs. Consistency trade-off
- 1.2.3.3 PACELC cells — PA/EL (DynamoDB default), PA/EC (Megastore), PC/EC (Google Spanner)
#### 1.2.4 Consistency Models
- 1.2.4.1 Linearizability — single-copy illusion; reads reflect all preceding writes globally
- 1.2.4.2 Causal consistency — cause-effect ordering preserved; concurrent unrelated ops may diverge
- 1.2.4.3 Eventual consistency — all replicas converge given no new updates and sufficient time
  - 1.2.4.3.1 Conflict resolution strategies — LWW (timestamp-based), vector clocks, CRDTs
  - 1.2.4.3.2 CRDT types — G-Counter, PN-Counter, G-Set, OR-Set, MV-Register, RGA (text)
- 1.2.4.4 Session guarantees — read-your-writes, monotonic reads, monotonic writes, writes-follow-reads
#### 1.2.5 Consensus Algorithms
- 1.2.5.1 Two Generals Problem — impossibility of guaranteed consensus over lossy channels
- 1.2.5.2 Paxos — single-decree; Proposer/Acceptor/Learner roles; two-phase protocol
  - 1.2.5.2.1 Phase 1 (Prepare/Promise) — Proposer claims ballot; Acceptors promise no lower ballot
  - 1.2.5.2.2 Phase 2 (Accept/Accepted) — Proposer sends value; quorum of Acceptors confirm
- 1.2.5.3 Raft — leader-based, log replication model, designed for understandability
  - 1.2.5.3.1 Leader election — randomized election timeout, term numbers, majority vote
  - 1.2.5.3.2 Log replication — AppendEntries RPC, commit index, snapshot compaction
- 1.2.5.4 Byzantine Fault Tolerance — tolerates malicious (non-crash) failures
  - 1.2.5.4.1 Safety requirement — 3f+1 total nodes to tolerate f Byzantine faults
  - 1.2.5.4.2 PBFT — pre-prepare, prepare, commit phases; O(n²) message complexity

### 1.3 Pattern Selection Criteria & Decision Frameworks
#### 1.3.1 Quality Attribute Trade-off Analysis (ATAM)
- 1.3.1.1 Reliability vs. performance — quorum reads add one RTT per request
- 1.3.1.2 Scalability vs. complexity — distributed patterns require expertise to operate
- 1.3.1.3 Security vs. performance — mTLS handshakes, token validation, secrets rotation add latency
- 1.3.1.4 Cost vs. resilience — active-active multi-region ≈2× cost vs. active-passive
#### 1.3.2 Architectural Decision Records (ADRs)
- 1.3.2.1 Template — Context, Decision, Status, Consequences
- 1.3.2.2 Reversibility — two-way door (safe to undo) vs. one-way door (schema/protocol changes)
- 1.3.2.3 Pattern-specific ADR templates per domain (data, resilience, security)
#### 1.3.3 Decision Trees by Problem Class
- 1.3.3.1 Resilience — Health Endpoint → Circuit Breaker → Bulkhead → Retry+Jitter
- 1.3.3.2 Data consistency — CQRS → Event Sourcing → Saga → Outbox
- 1.3.3.3 Scale — Sharding → Queue-Based Load Leveling → Auto-scaling → CDN offload
- 1.3.3.4 Security — Federated Identity → Zero Trust → Valet Key → Gatekeeper
#### 1.3.4 Fitness Functions for Pattern Validation
- 1.3.4.1 Automated fitness functions — CI-enforced architecture compliance tests
- 1.3.4.2 Per-pattern metrics — circuit breaker open rate, retry amplification ratio, cache hit rate

### 1.4 Anti-Pattern Taxonomy
#### 1.4.1 Distributed Monolith
- 1.4.1.1 Symptoms — shared database, synchronous chains, coordinated deployments
- 1.4.1.2 Detection — change coupling matrix; services that always deploy together
- 1.4.1.3 Remediation — Strangler Fig + Anti-Corruption Layer + bounded context decomposition
#### 1.4.2 Chatty I/O
- 1.4.2.1 Cause — N+1 query pattern extended across network boundaries via serial HTTP calls
- 1.4.2.2 Detection — distributed trace span count per logical op (target: <5 downstream hops)
- 1.4.2.3 Remediation — batching, DataLoader/GraphQL, BFF aggregation, read replica caching
#### 1.4.3 Noisy Neighbor
- 1.4.3.1 Cause — multi-tenant shared resources with no isolation guarantees
- 1.4.3.2 Manifestation — CPU throttle, I/O starvation, network bandwidth saturation
- 1.4.3.3 Remediation — Bulkhead thread pools, per-tenant quotas, dedicated pools, priority queues
#### 1.4.4 Retry Storm
- 1.4.4.1 Cause — synchronized client retries amplifying load on degraded downstream service
- 1.4.4.2 Amplification — N clients × M retries = N×M requests hitting already-failing service
- 1.4.4.3 Remediation — exponential backoff, full/decorrelated jitter, circuit breaker open state
#### 1.4.5 Premature Decomposition
- 1.4.5.1 Cause — microservice decomposition before domain boundaries and team structures stabilize
- 1.4.5.2 Symptoms — services that always change together; high inter-service call coupling
- 1.4.5.3 Remediation — monolith-first; decompose along stable bounded context lines
