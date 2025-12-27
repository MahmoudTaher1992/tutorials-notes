Based on the Table of Contents you provided, here is a detailed explanation of section **004-Storage-Backends-Persistence/002-Storage-Operations.md**.

This section focuses on the "Day 2" operations of running Jaeger. Once you have chosen a storage backend (usually Elasticsearch or Cassandra), you need to manage the lifecycle of the data, handle the database schema, and plan for storage capacity.

---

# Detailed Explanation: Storage Operations

This module covers how to keep your Jaeger storage backend healthy, performant, and cost-efficient. Since **Elasticsearch (or OpenSearch)** is the most common production backend, most operational tasks revolve around managing indices.

## 1. Index Cleaning and Rollover Strategies

Tracing data is **time-series data**. It is extremely write-heavy, and data is usually only valuable for a short window (e.g., 3 to 7 days). You cannot simply store everything in one massive database table forever; it would become too slow to query and too expensive to store.

### The Strategy: Time-Based Indices
Instead of one large index, Jaeger creates new indices based on time.
*   **Daily Indices:** The default behavior. Jaeger creates a new index every day (e.g., `jaeger-span-2023-10-27`, `jaeger-span-2023-10-28`).
*   **Rollover:** A more advanced strategy where a new index is created not just by time, but by **size**. If an index gets too large (e.g., >50GB) within a single day, it "rolls over" to a new index (e.g., `jaeger-span-000001`, `jaeger-span-000002`). This prevents performance degradation caused by massive shards.

### Index Cleaning (Data Retention)
You need an automated way to delete old data. Jaeger provides a tool for this (often deployed as a CronJob in Kubernetes).

*   **The Tool:** `jaeger-es-index-cleaner`
*   **How it works:** It looks at the index names (which contain dates). If the date in the name is older than your configured retention period (e.g., 7 days), it deletes the entire index.
*   **Why this is efficient:** Deleting a whole index is physically much faster and less resource-intensive for the database than deleting millions of individual rows/documents.

### Rollover Management
If you are processing massive volume, one index per day might still be too big. Jaeger uses the **Rollover API**.
*   **Write Alias:** The Jaeger Collector doesn't write to `index-v1`; it writes to an alias called `jaeger-span-write`.
*   **Rollover Logic:** A background job checks if the index behind `jaeger-span-write` is too big or too old. If it is, it creates a new index and points the alias to the new one seamlessly.
*   **Read Alias:** The Jaeger Query service reads from `jaeger-span-read`, which points to *all* active indices so you can search across them.

---

## 2. Schema Management

Just like a SQL database needs tables created before you can insert data, Jaeger's storage backend needs a **Schema** (in Elasticsearch terms: **Index Templates** and **Mappings**).

### Initialization
When Jaeger starts, it expects the storage to be ready.
*   **The `jaeger-es-init` job:** In Kubernetes deployments (via the Jaeger Operator or Helm charts), a specific "Job" runs before the Collector starts.
*   **What it does:** It pushes an "Index Template" to Elasticsearch. This template tells ES: *"Whenever a new index starting with 'jaeger-span' is created, apply these specific settings."*

### Key Schema Elements
1.  **Mappings (Types):**
    *   **Keywords:** Jaeger tags (like `http.method` or `env`) are stored as `keyword` types. This is crucial for exact-match filtering in the UI.
    *   **Text:** Log messages inside spans might be stored as `text` for full-text search capabilities.
    *   **Geo-point:** Occasionally used for location-based tags.
2.  **Shards and Replicas:** The schema defines how many shards each index has.
    *   *Too few shards:* Write bottleneck (slow ingestion).
    *   *Too many shards:* Wasted memory and slow queries.
    *   *Replicas:* Defines how many copies of the data exist for high availability (HA).

### Schema Upgrades
If you upgrade the Jaeger binary version, the required schema might change. The standard operation procedure is:
1.  Run the new `jaeger-es-init` image to update the template.
2.  The *next* time a new index is created (e.g., the next day), it will use the new schema.
3.  *Note:* Jaeger is generally backward compatible; it can read yesterday's old format while writing today's new format.

---

## 3. Calculating Storage Requirements

Before going to production, you must estimate how much disk space and memory you need. This calculation determines your hardware budget and retention policy.

### The Formula
To calculate storage, you need three variables:
1.  **Rate:** Spans per second.
2.  **Size:** Average size of a span (in bytes).
3.  **Retention:** How long you keep the data.

$$ \text{Total Storage} = (\text{Spans/sec} \times \text{Avg Size} \times 86,400) \times \text{Days} \times \text{Replication Factor} $$

*(Note: 86,400 is the number of seconds in a day)*

### Detailed Breakdown
1.  **Average Span Size:**
    *   A typical span might be **300 to 500 bytes**.
    *   *Warning:* If you attach large logs or huge payloads to spans (bad practice), this can balloon to 10KB+, destroying your storage budget.
2.  **Replication Factor (Overhead):**
    *   If you use Elasticsearch with 1 Primary Shard and 1 Replica, you are storing the data **twice**.
    *   You also need roughly **20% extra overhead** for the database's internal indexing structures (Inverted indices).

### Example Calculation
*   **Traffic:** 2,000 Spans per second.
*   **Size:** 500 Bytes per span.
*   **Retention:** 3 Days.
*   **Replication:** 1 (Total 2 copies).

1.  **Daily Ingestion:** $2,000 \times 500 \times 86,400 = 86,400,000,000 \text{ bytes} \approx 86 \text{ GB/day}$.
2.  **Total Raw Data:** $86 \text{ GB} \times 3 \text{ days} = 258 \text{ GB}$.
3.  **With Replication (x2):** $516 \text{ GB}$.
4.  **With Overhead (+20%):** $516 \times 1.2 \approx 620 \text{ GB}$.

**Result:** You need to provision a cluster with at least **620 GB** of usable disk space.

### Operational levers for reducing storage
If the calculation is too expensive, you have three knobs to turn:
1.  **Decrease Sampling:** Don't record 100% of traces; record 10% (Probabilistic Sampling).
2.  **Decrease Retention:** Keep data for 2 days instead of 7.
3.  **Reduce Span Size:** Configure clients (instrumentation) to truncate long database statements or remove verbose logs.
