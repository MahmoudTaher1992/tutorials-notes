Based on the Table of Contents provided, here is a detailed explanation of **Part II, Section B: Deployment Topologies**.

This section describes the physical architecture of Jaeger—how you arrange the binaries/containers on your infrastructure depending on your scale and requirements.

---

# 002-Deployment-Topologies (Detailed Explanation)

Jaeger is a distributed system composed of several distinct binaries. Depending on how much traffic (spans) you generate and how robust your storage needs to be, you can deploy these binaries in three main configurations.

## 1. All-in-One (Development & Testing)

This is the simplest topology. It is intended for local development, trying out Jaeger, or lightweight integration testing (CI/CD).

*   **Architecture:** A single binary (executable) that launches the Jaeger UI, Collector, Query, and Agent all inside one process.
*   **Storage:** It typically uses **in-memory** storage.
*   **Data Flow:** Application → All-in-One Binary.
*   **Pros:** Zero configuration; simplest setup (one Docker command).
*   **Cons:**
    *   **Ephemeral:** If the container/process stops, you lose all trace data.
    *   **Not Scalable:** You cannot scale the collector separately from the query service.
*   **Use Case:** A developer running Jaeger on their laptop to debug a microservice.

## 2. Direct to Storage (Standard Production)

This is the standard approach for small-to-medium production clusters. In this topology, the components are decoupled and run as separate processes/containers.

*   **Architecture:**
    *   **Jaeger Agent:** Runs on the application host (DaemonSet or Sidecar).
    *   **Jaeger Collector:** Accepts data from Agents, processes it, and writes directly to the DB.
    *   **Jaeger Query + UI:** Reads directly from the DB.
    *   **Storage:** Persistent storage (usually Elasticsearch or Cassandra).
*   **Data Flow:**
    `App → Agent → Collector → Database`
*   **The Bottle-neck Risk:** In this setup, the Collector writes directly to the Database. If your database becomes slow (due to high load or maintenance), the Collector cannot write data fast enough. This creates **backpressure**. The Collector may drop spans, or the Agent may drop spans because the Collector is busy.
*   **Use Case:** Production environments with steady, predictable traffic loads where the database can easily handle the write throughput.

## 3. Streaming / Asynchronous (High Scale / Enterprise)

This is the architecture used by companies like Uber (where Jaeger was created). It introduces a buffering layer (Kafka) between the Collector and the Database to handle massive traffic spikes.

*   **Architecture:**
    *   **Jaeger Collector:** Instead of writing to the DB, it writes to a **Kafka Topic**.
    *   **Kafka:** Acts as a massive buffer/queue.
    *   **Jaeger Ingester:** A specific Jaeger component that reads from Kafka and writes to the Database at a controlled pace.
*   **Data Flow:**
    `App → Agent → Collector → Kafka → Ingester → Database`
*   **Why use this?**
    *   **Peak Shaving:** If your app traffic spikes by 500% (e.g., Black Friday), the Collectors dump that data into Kafka instantly. The Database might not be able to write that fast, but Kafka can ingest it. The **Ingester** then works through the Kafka backlog at whatever speed the Database allows, ensuring no data is lost.
    *   **Data Processing:** Having the raw spans in Kafka allows other data pipelines (like Flink or Spark) to analyze the stream for fraud detection or aggregation before it even hits the database.
*   **Use Case:** High-traffic environments, systems with "bursty" traffic, or when you need guaranteed data durability.

---

## 4. Scaling Considerations (When to scale what)

When deploying the production topologies (Direct or Streaming), you need to know which component to scale based on resource usage.

| Component | Limiting Factor | How/When to Scale |
| :--- | :--- | :--- |
| **Collector** | **CPU** | The Collector spends most of its time unmarshalling (decoding) data and validating it. If CPU usage is high, add more Collector replicas behind a Load Balancer. |
| **Agent** | **Network** | Agents are usually deployed as DaemonSets (one per Node). They scale automatically with your Kubernetes cluster size. |
| **Elasticsearch** | **Disk I/O** | This is usually the ultimate bottleneck. If writing is slow, you need more ES Data Nodes or faster disks. |
| **Ingester** | **Kafka Lag** | If the Ingester cannot keep up with the Kafka stream (lag is increasing), you add more Ingester replicas. |
| **Query/UI** | **Memory/CPU** | Usually low load. Only needs scaling if you have many developers querying the UI simultaneously or running very complex/long queries. |

### Summary for Decision Making

1.  **Just coding on my laptop?** $\rightarrow$ Use **All-in-One**.
2.  **Running a standard startup production?** $\rightarrow$ Use **Direct to Storage** (with Elasticsearch).
3.  **Running Twitter/Uber scale or have massive traffic spikes?** $\rightarrow$ Use **Streaming** (with Kafka).
