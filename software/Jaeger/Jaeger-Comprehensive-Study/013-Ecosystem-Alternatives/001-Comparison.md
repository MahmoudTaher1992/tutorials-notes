Based on the Table of Contents you provided, **Part XIII: Ecosystem & Alternatives** is a critical section because it helps you understand where Jaeger fits in the broader landscape of observability tools.

Here is a detailed explanation of the **Comparison** section (`013-Ecosystem-Alternatives/001-Comparison.md`).

---

### 1. Jaeger vs. Zipkin (The Ancestor)

**Context:** Zipkin was one of the first open-source distributed tracing systems, developed by Twitter based on the Google Dapper paper. Jaeger (developed by Uber) came later.

*   **Technology Stack:**
    *   **Zipkin:** Traditionally written in **Java**. While robust, the JVM can be heavier to run as a sidecar or agent.
    *   **Jaeger:** Written in **Go**. This generally made Jaeger binaries smaller, faster to start, and more resource-efficient, which contributed to its rapid adoption in the Kubernetes/Cloud Native world.
*   **Architecture & Features:**
    *   Jaeger offers a more modern UI out-of-the-box compared to the standard Zipkin UI.
    *   Jaeger supports **dynamic sampling** (remotely controlling how much data agents send), a feature Zipkin lacked for a long time.
*   **Compatibility:**
    *   Jaeger was designed to be backward compatible with Zipkin. Jaeger Collectors can actually accept data in Zipkin formats (Thrift/JSON). If you have legacy applications sending data to Zipkin, you can switch the backend to Jaeger without changing the application code immediately.
*   **Verdict:** Jaeger is generally considered the "modern evolution" of the Zipkin model.

### 2. Jaeger vs. Grafana Tempo (High Volume, Object Storage)

**Context:** Grafana Tempo is a newer entrant designed to solve the "cost of storage" problem.

*   **The Indexing Philosophy:**
    *   **Jaeger (Traditional):** Heavily indexes traces. If you tag a span with `customer_id=123`, Jaeger indexes that so you can search for it instantly. This requires heavy storage backends like **Elasticsearch**, which are expensive to run.
    *   **Grafana Tempo:** Historically focuses on **Trace ID lookup**. It assumes you found a Trace ID in your *logs* (via Loki) or *metrics* (via Prometheus exemplars) and just want to see that specific trace. Because it doesn't index every tag heavily, it can store data in cheap **Object Storage (S3, GCS)**.
*   **Use Case:**
    *   **Choose Jaeger** if you need powerful **search capabilities** on traces (e.g., "Show me all traces longer than 5s where DB write failed").
    *   **Choose Tempo** if you have massive data volume, want to save money on storage, and are already deep into the Grafana ecosystem (using Loki and Prometheus). *Note: Tempo 2.0 (TraceQL) is adding more search capabilities, bridging this gap.*

### 3. Jaeger vs. SigNoz / SkyWalking (APM Bundles)

**Context:** Jaeger is a *specialized tool* (it does Tracing only). You usually need to pair it with Prometheus (for metrics) and Fluentd/ELK (for logs). SigNoz and SkyWalking are "All-in-One" platforms.

*   **Scope:**
    *   **Jaeger:** Do one thing and do it well (Tracing).
    *   **SkyWalking / SigNoz:** These act as full **APM (Application Performance Monitoring)** replacements. They collect Metrics, Logs, *and* Traces in a single binary/UI.
*   **Architecture:**
    *   **SkyWalking:** Very popular in the Java ecosystem (especially in China). It uses its own sophisticated agent mechanism.
    *   **SigNoz:** Built natively on **OpenTelemetry** and uses **ClickHouse** (a very fast columnar database) as its storage backend. It aims to be an open-source Datadog alternative.
*   **Verdict:**
    *   Use **Jaeger** if you want to build a composable stack (e.g., "I want Prometheus for metrics, Jaeger for tracing, and Grafana to view both").
    *   Use **SigNoz/SkyWalking** if you want a single "out-of-the-box" experience that handles everything without stitching tools together.

### 4. Jaeger vs. SaaS (Datadog, Honeycomb, New Relic)

**Context:** The decision between building it yourself (Jaeger) vs. buying it (SaaS).

*   **Total Cost of Ownership (TCO):**
    *   **Jaeger:** Software is free, but infrastructure (running Elasticsearch, Kafka, Collectors) is expensive and requires engineering time to maintain.
    *   **SaaS:** Very expensive monthly bills (often based on volume), but zero maintenance overhead.
*   **High Cardinality & Debugging:**
    *   **Honeycomb:** Revolutionized the industry by allowing "High Cardinality" (infinite unique tags like User IDs). They excel at asking "Why is this happening?" across billions of data points.
    *   **Jaeger:** While capable, doing high-cardinality analysis in Jaeger depends entirely on the backing storage (e.g., Elasticsearch) performance, which can degrade if you tag spans with too many unique values.
*   **Data Sovereignty:**
    *   **Jaeger:** You own the data. It never leaves your network (crucial for Banking/Healthcare/GDPR).
    *   **SaaS:** You send data to the vendor.

### Summary Table for the Exam/Study:

| Tool | Primary Focus | Storage | Best For |
| :--- | :--- | :--- | :--- |
| **Jaeger** | Pure Tracing, Searchable | Elasticsearch/Cassandra | Kubernetes native, deep search requirements, DIY stacks. |
| **Zipkin** | Pure Tracing (Legacy) | MySQL/Cassandra/ES | Java environments, legacy systems. |
| **Tempo** | Cost-efficient Tracing | Object Storage (S3) | High volume, Grafana users, strict budgets. |
| **SigNoz** | Full Stack APM | ClickHouse | Teams wanting an open-source "Datadog". |
| **SaaS** | Ease of use | Vendor Cloud | Teams with budget who don't want to manage infra. |
