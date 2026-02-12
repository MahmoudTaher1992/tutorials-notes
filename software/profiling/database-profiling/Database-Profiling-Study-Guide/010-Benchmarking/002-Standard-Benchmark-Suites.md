Here is the comprehensive content for **Section 38. Standard Benchmark Suites**, tailored to the provided Table of Contents.

---

# 38. Standard Benchmark Suites

To accurately profile and compare database systems, industry-standard benchmark suites provide defined schemas, data generation rules, and query patterns. These suites ensure that comparisons between different hardware, versions, or database engines are fair and reproducible.

## 38.1 OLTP Benchmarks

Online Transaction Processing (OLTP) benchmarks focus on the atomic, consistent, isolated, and durable (ACID) properties of a database. They typically involve high concurrency, short transactions, and a mix of reading and writing small amounts of data.

### 38.1.1 TPC-C
The Transaction Processing Performance Council (TPC) defined TPC-C as the industry standard for OLTP performance.

*   **38.1.1.1 Workload characteristics:**
    *   Simulates a wholesale supplier managing orders.
    *   The schema centers on a hierarchy of Warehouses, Districts, and Customers.
    *   It comprises five transaction types: New Order (heavy read-write), Payment (light write), Order Status (read-only), Delivery (batch write), and Stock Level (read-only).
    *   It is highly write-intensive and contention-heavy, specifically designing "hot spots" (e.g., updating the warehouse year-to-date sales) to test locking mechanisms.
*   **38.1.1.2 Metrics (tpmC):**
    *   The primary metric is **tpmC** (Transactions per minute type C).
    *   It measures the number of "New Order" transactions executed per minute while keeping other transaction types within a required mix ratio.
*   **38.1.1.3 Implementation considerations:**
    *   TPC-C scales by adding "Warehouses."
    *   Implementing TPC-C strictly to spec is difficult; most engineers use established implementations like **HammerDB** or **BenchmarkSQL** rather than writing their own drivers.

### 38.1.2 TPC-E
TPC-E is the modern successor to TPC-C, though TPC-C remains more widely used for marketing "hero numbers."

*   **38.1.2.1 Workload characteristics:**
    *   Simulates a brokerage firm (stock exchange).
    *   Unlike TPC-C, TPC-E is more read-intensive (approx. 77% reads) but involves more complex schema relationships and data constraints.
*   **38.1.2.2 Complexity vs. TPC-C:**
    *   TPC-E uses non-uniform data input (simulating real-world data skew more accurately than TPC-C).
    *   It requires generating pseudo-random data that maintains referential integrity across 33 tables, making it significantly harder to "game" via simple caching or partitioning strategies.

### 38.1.3 YCSB (Yahoo! Cloud Serving Benchmark)
YCSB is the de facto standard for benchmarking NoSQL and Key-Value stores, focusing on scale-out architecture and elasticity.

*   **38.1.3.1 Workload types (A through F):**
    *   **Workload A (Update heavy):** 50% Read, 50% Update. (Session store).
    *   **Workload B (Read mostly):** 95% Read, 5% Update. (Photo tagging).
    *   **Workload C (Read only):** 100% Read. (User profile cache).
    *   **Workload D (Read latest):** Insert new records, read mostly widely recent. (Status updates).
    *   **Workload E (Short ranges):** Scan short ranges of records. (Threaded conversations).
    *   **Workload F (Read-modify-write):** Atomic updates. (User database).
*   **38.1.3.2 Customization options:**
    *   Users can define field counts, field sizes, and crucially, the **request distribution** (Uniform, Zipfian, or Latest). Zipfian distribution is essential for testing caching layers as it simulates "hot keys."
*   **38.1.3.3 NoSQL focus:**
    *   It abstracts the database connection, allowing the same benchmark to run against Cassandra, MongoDB, HBase, Redis, and DynamoDB to compare latency/throughput trade-offs.

### 38.1.4 Sysbench
Sysbench is a scriptable multi-threaded benchmark tool, primarily used for MySQL and Linux system testing, but adaptable to other SQL databases.

*   **38.1.4.1 OLTP workloads:**
    *   It provides pre-packaged Lua scripts for common scenarios: `oltp_read_only`, `oltp_write_only`, and `oltp_read_write`.
*   **38.1.4.2 Read/write mix configuration:**
    *   It allows granular control via command-line flags (e.g., `--oltp-point-selects=10 --oltp-simple-ranges=1`).
    *   It is excellent for testing system limits (CPU/Memory/Disk) rather than complex business logic constraints.

### 38.1.5 pgbench
The native benchmarking tool included with PostgreSQL distributions.

*   **38.1.5.1 PostgreSQL-specific:**
    *   By default, it runs a scenario based on **TPC-B**, involving simple updates to account balances (SELECT, UPDATE, INSERT history).
    *   It is tightly integrated with `libpq` and is the standard for tuning PostgreSQL `postgresql.conf` parameters (like `shared_buffers` or `wal_buffers`).
*   **38.1.5.2 Custom script support:**
    *   Its most powerful feature is the `-f` flag, allowing users to provide custom SQL script files. This enables DBAs to benchmark specific production queries in isolation under high concurrency without needing external load testing tools.

---

## 38.2 OLAP Benchmarks

Online Analytical Processing (OLAP) benchmarks focus on query complexity, large table scans, joins, aggregations, and the ability to process massive datasets efficiently.

### 38.2.1 TPC-H
The industry standard for ad-hoc decision support.

*   **38.2.1.1 Query types:**
    *   Consists of 22 complex SQL queries (Q1 through Q22) that answer business questions (e.g., "Pricing Summary Report").
    *   These queries test the optimizer's ability to handle large joins, subqueries, and aggregations.
*   **38.2.1.2 Scale factors:**
    *   Databases are tested at specific sizes (Scale Factors), e.g., 1GB, 10GB, 100GB, 1TB, 10TB.
*   **38.2.1.3 Metrics interpretation:**
    *   **Power Metric:** How fast a single stream of queries executes.
    *   **Throughput Metric:** How many concurrent streams of queries the system can handle.
    *   **QphH:** Composite Query-per-Hour Performance Metric.

### 38.2.2 TPC-DS
The successor to TPC-H, designed for Big Data and modern data warehousing.

*   **38.2.2.1 Complex query workload:**
    *   Uses a snowflake schema (more normalized than TPC-H) with 99 distinct SQL-99 queries.
    *   The queries are randomized and far more complex, often involving iterative patterns that challenge modern query optimizers more than TPC-H.
*   **38.2.2.2 Data maintenance operations:**
    *   Unlike TPC-H which is mostly static, TPC-DS includes an ETL phase (Insert/Delete) to measure how well the database maintains indexes and statistics under data churn.

### 38.2.3 Star Schema Benchmark (SSB)
Derived from TPC-H but simplified into a pure Star Schema structure. It is widely used to benchmark Columnar Stores (like ClickHouse, Druid, or Amazon Redshift) because it emphasizes large table scans and aggregations over complex join logic.

### 38.2.4 ClickBench
A modern benchmark emerging from the real-time analytics community. It uses a single large table of real-world web analytics data (hits logs) rather than synthetic data. It is excellent for comparing performance of databases intended for "interactive analytics" (sub-second responses on massive data).

---

## 38.3 Mixed Workload Benchmarks

Hybrid Transactional/Analytical Processing (HTAP) benchmarks measure a system's ability to handle heavy write traffic (OLTP) while simultaneously running complex analytical queries (OLAP) without one starving the other.

### 38.3.1 TPC-H + TPC-C combined approaches
Historically, organizations would run TPC-C on one node and TPC-H on a read-replica. In HTAP benchmarking, both are run against the same engine instance to test resource isolation and locking strategies.

### 38.3.2 CH-benCHmark
This is the standard academic and industrial benchmark for HTAP.
*   It combines the **TPC-C** schema (for order entry) with **TPC-H** equivalent queries adapted to run against the TPC-C schema.
*   It measures the degradation of transaction throughput when analytical queries are introduced.

### 38.3.3 HTAPBench
Similar to CH-benCHmark but introduces a constraint-based approach. It asks: "What is the maximum analytical throughput I can achieve provided that the transactional latency does not increase by more than 10%?" This reflects real-world SLA requirements.

---

## 38.4 Specialized Benchmarks

### 38.4.1 Graph benchmarks (LDBC)
The Linked Data Benchmark Council (LDBC) defines benchmarks for graph databases (like Neo4j or Amazon Neptune).
*   **Social Network Benchmark (SNB):** Simulates a social network.
    *   *Interactive Workload:* Short traversals (e.g., "Find friends of friends").
    *   *Business Intelligence Workload:* Global graph analytics (e.g., "Find the central influencer in this community").

### 38.4.2 Time-series benchmarks (TSBS)
The Time Series Benchmark Suite (maintained by InfluxData/Timescale).
*   Generates workloads for **DevOps** (CPU/Memory metrics from thousands of servers) and **IoT** (sensor data from fleets of trucks).
*   Focuses heavily on **Ingestion Rate** (points/sec) and **Compression Ratio** (disk usage), as well as windowed aggregation queries.

### 38.4.3 Key-value benchmarks (memtier_benchmark)
Developed by Redis Labs, this is a high-throughput benchmarking tool for Redis and Memcached.
*   It supports pipelining (sending multiple commands without waiting for responses), allowing users to test the network stack and memory speed limits of in-memory stores.

### 38.4.4 Full-text search benchmarks
*   **Elasticsearch Rally (esrally):** The official benchmarking tool for Elasticsearch. It tests indexing throughput (documents/sec) versus search latency, handling different text analysis complexities (stemming, tokenization).
*   **luceneutil:** Used for low-level Lucene benchmarking.