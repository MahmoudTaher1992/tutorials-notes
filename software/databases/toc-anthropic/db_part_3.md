# Databases Complete Study Guide - Part 3: Relational Model, Normalization & Transactions

## 3.0 Relational Databases

### 3.1 Relational Algebra & SQL Foundations
#### 3.1.1 Relational Algebra Operations
- 3.1.1.1 Selection (σ) — filter rows — WHERE clause equivalent
  - 3.1.1.1.1 Predicate pushdown — apply selection early — reduce rows in pipeline
- 3.1.1.2 Projection (π) — select columns — SELECT list equivalent
  - 3.1.1.2.1 Column pruning — eliminate unused columns early — reduce memory
- 3.1.1.3 Cartesian product (×) — all combinations — base of JOIN
- 3.1.1.4 Join (⋈) — combine relations — natural / equi / theta / outer
- 3.1.1.5 Union / Intersection / Difference — set operations — same schema required
- 3.1.1.6 Aggregation — GROUP BY + aggregate functions — SUM/COUNT/AVG/MIN/MAX

### 3.2 Normalization
#### 3.2.1 Normal Forms
- 3.2.1.1 1NF — atomic values — no repeating groups — each cell = single value
  - 3.2.1.1.1 Violation example — phone1, phone2, phone3 columns — decompose to child table
- 3.2.1.2 2NF — 1NF + no partial dependency — non-key cols fully depend on whole PK
  - 3.2.1.2.1 Only relevant for composite PKs — single-column PK always in 2NF
  - 3.2.1.2.2 Partial dependency — attribute depends on part of composite key — separate table
- 3.2.1.3 3NF — 2NF + no transitive dependency — non-key cols depend only on PK
  - 3.2.1.3.1 Transitive dependency — A → B → C — remove B → C to separate table
- 3.2.1.4 BCNF — 3NF + every determinant is a candidate key — stricter than 3NF
  - 3.2.1.4.1 Violation — instructor → department — instructor not a candidate key
- 3.2.1.5 4NF — BCNF + no multi-valued dependencies — independent multi-valued facts
- 3.2.1.6 5NF — 4NF + no join dependencies — decompose losslessly — theoretical limit

#### 3.2.2 Denormalization
- 3.2.2.1 Intentional denormalization — accept redundancy — optimize read performance
  - 3.2.2.1.1 Derived columns — store computed value — avoid recalculation at query time
  - 3.2.2.1.2 Duplicated columns — avoid JOIN — read-heavy scenarios
  - 3.2.2.1.3 Risks — update anomalies — inconsistency — requires careful management

### 3.3 Schema Design Patterns
#### 3.3.1 Common Patterns
- 3.3.1.1 Surrogate key — artificial PK — UUID/serial — no business meaning — stable
  - 3.3.1.1.1 UUID v4 — random — globally unique — causes index fragmentation
  - 3.3.1.1.2 UUID v7 — time-ordered — reduces B-tree fragmentation — preferred
  - 3.3.1.1.3 ULID — sortable — base32 — compatible with B-tree inserts
- 3.3.1.2 Soft delete — deleted_at timestamp — never physically delete — audit trail
  - 3.3.1.2.1 Partial index on non-deleted — WHERE deleted_at IS NULL — index efficiency
  - 3.3.1.2.2 Risks — table bloat — performance degradation — must filter everywhere
- 3.3.1.3 Audit columns — created_at / updated_at / created_by — track changes
- 3.3.1.4 Polymorphic association — single FK to multiple tables — flexible but messy
  - 3.3.1.4.1 Alternatives — separate FKs (null) or exclusive arc pattern — cleaner
- 3.3.1.5 Entity-Attribute-Value (EAV) — dynamic schema — flexible but slow + untyped
  - 3.3.1.5.1 Anti-pattern — avoid for queryable data — JSONB column better alternative
- 3.3.1.6 Temporal tables — bitemporal — valid_time + transaction_time — full history
  - 3.3.1.6.1 System versioned — DB tracks row history — AS OF SYSTEM TIME queries

---

## 4.0 Transactions

### 4.1 ACID Deep Dive
#### 4.1.1 Atomicity Implementation
- 4.1.1.1 Undo log — record before-images — rollback restores original values
  - 4.1.1.1.1 Undo log in WAL — interleaved with redo — consistent crash recovery
  - 4.1.1.1.2 Savepoints — partial rollback — nested transaction simulation
- 4.1.1.2 Distributed atomicity — 2PC across nodes — coordinator + participants
  - 4.1.1.2.1 Phase 1 (Prepare) — coordinator asks all nodes — "can you commit?"
  - 4.1.1.2.2 Phase 2 (Commit/Abort) — all yes → commit all — any no → abort all
  - 4.1.1.2.3 Blocking problem — coordinator crash after prepare — participants stuck

### 4.2 Isolation Levels
#### 4.2.1 Anomalies
- 4.2.1.1 Dirty read — read uncommitted data — rolled-back later — never true
- 4.2.1.2 Non-repeatable read — same row read twice — different values — update between
- 4.2.1.3 Phantom read — same query twice — different row set — insert between
- 4.2.1.4 Lost update — two txns read-modify-write same row — one overwrites other
  - 4.2.1.4.1 SELECT ... FOR UPDATE — lock row — prevent concurrent update
- 4.2.1.5 Write skew — two txns read overlapping data — each writes disjoint — invariant broken
  - 4.2.1.5.1 Example — two doctors both read "1 on-call" → both go off-call → 0 on-call

#### 4.2.2 Isolation Level Definitions
- 4.2.2.1 Read Uncommitted — no isolation — dirty reads allowed — fastest — never use
- 4.2.2.2 Read Committed — no dirty reads — most common default (PostgreSQL, Oracle)
  - 4.2.2.2.1 Non-repeatable reads still possible — row re-read gets new version
- 4.2.2.3 Repeatable Read — no dirty + no non-repeatable — MySQL InnoDB default
  - 4.2.2.3.1 Phantom reads still possible in strict definition — MVCC prevents in practice
- 4.2.2.4 Serializable — full isolation — equivalent to serial execution — strictest
  - 4.2.2.4.1 SSI — Serializable Snapshot Isolation — PostgreSQL — tracks read-write deps
  - 4.2.2.4.2 Detects serialization anomalies — abort on conflict — optimistic

### 4.3 Concurrency Control
#### 4.3.1 MVCC (Multi-Version Concurrency Control)
- 4.3.1.1 Each write creates new row version — readers see snapshot — no read locks
  - 4.3.1.1.1 Transaction ID (XID) — stamp each version — visible based on snapshot
  - 4.3.1.1.2 Snapshot — set of committed XIDs at txn start — filter visible versions
  - 4.3.1.1.3 xmin / xmax — PostgreSQL — row visible if xmin committed + xmax not
- 4.3.1.2 MVCC garbage — old row versions accumulate — vacuum / GC must reclaim
  - 4.3.1.2.1 PostgreSQL VACUUM — mark dead tuples — autovacuum daemon — necessary
  - 4.3.1.2.2 Transaction ID wraparound — 32-bit XID — 2 billion txn limit — vacuum critical

#### 4.3.2 Two-Phase Locking (2PL)
- 4.3.2.1 Growing phase — acquire locks — never release — all locks held
- 4.3.2.2 Shrinking phase — release locks — never acquire — after first release
  - 4.3.2.2.1 Strict 2PL — hold all locks until commit — prevents cascading aborts
  - 4.3.2.2.2 Lock escalation — many row locks → table lock — reduces overhead
- 4.3.2.3 Deadlock detection — wait-for graph — cycle = deadlock — abort youngest
  - 4.3.2.3.1 Timeout-based — abort if wait > threshold — simpler but imprecise
  - 4.3.2.3.2 Prevention — order resources — wound-wait — wait-die — no cycle possible

#### 4.3.3 Optimistic Concurrency Control (OCC)
- 4.3.3.1 Read phase — read + buffer changes — no locks — assume no conflict
- 4.3.3.2 Validation phase — check if read set modified by others — detect conflict
- 4.3.3.3 Write phase — commit changes — or abort + retry — low conflict workloads
  - 4.3.3.3.1 CAS (Compare-and-Swap) — check version — update only if unchanged
