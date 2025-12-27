Based on the Table of Contents provided, you are asking for a deep dive into **Part VIII: Performance Tuning & Scalability**, specifically section **B. Optimization**.

This section focuses on fine-tuning the Jaeger infrastructure to handle high loads without crashing, losing data, or costing a fortune in storage and CPU. When you implement distributed tracing at scale (e.g., millions of spans per minute), default configurations will usually fail.

Here is a detailed explanation of the three key pillars of Jaeger Optimization:

---

### 1. Reducing Span Size (Limit logs, efficient tagging)

The most effective way to optimize performance is to reduce the amount of data being generated at the source (the application code).

**The Problem:**
Developers often treat Tracing like Debug Logging. They might attach huge payloads (entire JSON response bodies, full stack traces, or massive user session objects) to a span.
*   **Storage Impact:** If a single span is 50KB instead of 1KB, and you have 1 million spans, your Elasticsearch storage costs skyrocket 50x.
*   **Network Impact:** Sending massive spans creates network congestion between the App, the Agent, and the Collector.
*   **UDP Limits:** Jaeger Agents often communicate via UDP, which has packet size limits (often 65KB). Huge spans get dropped silently.

**Optimization Strategies:**
*   **Selective Tagging:** Only tag low-cardinality, high-value data (e.g., `http.status_code`, `user_id`, `region`). Avoid tagging entire objects.
*   **Log Management:**
    *   Avoid attaching "Logs" (time-stamped events) to spans unless necessary for debugging critical failures.
    *   Truncate long strings. If capturing a SQL query, truncate it to 500 characters so a massive `INSERT` statement doesn't bloat the span.
*   **Remove PII:** Scrubbing Personally Identifiable Information (PII) reduces size and compliance risk.
*   **Reference, Don't Embed:** Instead of embedding a full error report in the span, embed a link (URL) to the log aggregation system (like Splunk or ELK) where the full log exists.

---

### 2. Tuning `queue-size` and `workers` in Collectors

The **Jaeger Collector** is the bottleneck component. It receives data from thousands of agents and pushes it to the backend storage (Elasticsearch/Cassandra). Internally, it uses a **Producer-Consumer** pattern.

**The Architecture:**
Incoming Spans $\rightarrow$ **Internal Queue (Buffer)** $\rightarrow$ **Workers** $\rightarrow$ Database

**The Parameters:**
*   **`queue-size`:** The number of spans the Collector keeps in memory waiting to be written to the DB.
*   **`num-workers`:** The number of parallel threads actively writing data to the DB.

**Optimization Logic:**
*   **Symptom: Dropped Spans:** If the DB slows down, the `workers` get stuck waiting for a response. The `queue` fills up. Once the queue is full, the Collector simply drops new incoming spans (data loss).
*   **Tuning `queue-size`:**
    *   Increase this to handle **bursty traffic**. If you have a traffic spike for 5 seconds, a larger queue acts as a shock absorber.
    *   *Risk:* Higher queue size = Higher RAM usage. If the Collector crashes, everything in the queue is lost.
*   **Tuning `num-workers`:**
    *   Increase this if your CPU is low but the queue is full. It means you aren't sending data to the DB fast enough.
    *   *Limit:* You cannot increase this infinitely. Eventually, the bottleneck becomes the Database itself (e.g., Elasticsearch cannot handle more concurrent indexing requests).

**Rule of Thumb:**
If you see "Dropped Span" metrics in the Collector:
1.  Check DB health.
2.  Increase `num-workers` (if DB allows).
3.  Increase `queue-size` (if RAM allows).

---

### 3. Handling "Hot Partitions" in Kafka

This applies to the **Streaming Architecture** (Agent $\rightarrow$ Collector $\rightarrow$ Kafka $\rightarrow$ Ingester $\rightarrow$ DB).

**The Concept:**
Kafka divides data into **Partitions** to scale. A specific **Jaeger Ingester** reads from a specific partition.
*   Standard behavior: Jaeger partitions traces by `TraceID`. Since TraceIDs are random UUIDs, traffic is usually distributed evenly.

**The Problem ("Hot Partitions"):**
A "Hot Partition" occurs when one partition receives significantly more data (or more processing-intensive data) than the others. This causes the Ingester assigned to that partition to fall behind (Consumer Lag), while other Ingesters sit idle.

**Causes & Solutions:**
*   **Bad Keying Strategy:** If you configured Jaeger/Kafka to partition by `Service Name` instead of `TraceID`, a massive service (e.g., the "Frontend") will dump all its spans into Partition 1, overloading it.
    *   *Fix:* Ensure partitioning is done by `TraceID` for uniform distribution.
*   **"Poison Pill" Traces:** Sometimes, a specific partition accumulates complex, massive traces that take a long time to process and write to the DB.
    *   *Fix:* Optimize Span Size (see section 1) to ensure uniform processing time.
*   **Insufficient Partitions:** If you have huge throughput but only 3 Kafka partitions, you can only run 3 Ingesters max.
    *   *Fix:* Increase Kafka partitions (e.g., to 32 or 64) so you can scale up the number of Ingester instances to spread the CPU load.

### Summary
This section teaches you that scalability isn't just about "adding more servers." It requires:
1.  **Discipline** in what developers record (Span size).
2.  **Tuning** the throughput pipeline (Queue/Workers).
3.  **Balancing** the data stream (Kafka Partitions).
