This section of the Table of Contents addresses the two biggest limitations of a standard, "vanilla" Prometheus setup: **Retention** (keeping data for a long time) and **Aggregation** (querying data from multiple distinct Prometheus servers at once).

By design, Prometheus is a single-server node with local storage. It is not distributed. When you need to scale beyond one server, or keep data for years, you need these "Meta-Frameworks."

Here is a detailed breakdown of **Part IX, Section B: Long-Term Storage & Global View**.

---

### 1. The Problems Being Solved

Before diving into the tools (Thanos, Cortex/Mimir, VictoriaMetrics), it is crucial to understand *why* they exist.

*   **The Retention Problem:** Prometheus stores data on a local disk (SSD). Storing terabytes of historical data on a local disk is expensive and risky. If the node dies, the history is lost.
*   **The Global View Problem:** If you have 3 Kubernetes clusters (US-East, EU-West, Asia-South), you typically have 3 separate Prometheus servers. To know the "Total CPU Usage" of your company, you cannot run one query; you have to check 3 different dashboards.
*   **The HA Problem:** To ensure High Availability, you usually run two Prometheus servers scraping the same targets. This results in duplicate data. You need a system that can merge these duplicates so the user sees only one clean stream of data.

---

### 2. Thanos

Thanos is likely the most popular open-source extension for Prometheus. It follows a **"Sidecar"** architecture. It transforms existing Prometheus setups into a distributed system without requiring you to fundamentally change how you run Prometheus.

#### Key Components:
*   **The Sidecar:** This small process runs right next to your Prometheus server.
    *   *Function 1:* It watches the local data files. Every 2 hours, Prometheus creates a block of data; the Sidecar uploads this block to cheap **Object Storage** (AWS S3, Google GCS, Azure Blob). This solves **Long-Term Storage**.
    *   *Function 2:* It acts as a proxy. When queried, it can read the very recent data directly from the Prometheus memory.
*   **The Store Gateway:** This component sits in the cloud and reads the historical data from the Object Storage (S3) bucket.
*   **The Querier (Global View):** This is the entry point for Grafana. It does not store data. Instead, it sends the query to *all* Sidecars (for real-time data) and *all* Store Gateways (for historical data).
    *   It aggregates the results.
    *   **Deduplication:** If you run two Prometheus servers for HA, the Querier sees both datasets and merges them into one, hiding the duplication from the user.
*   **The Compactor:** It runs in the background on the S3 bucket to apply **Downsampling**.
    *   *Example:* You don't need 15-second resolution for data from a year ago. The compactor creates 5-minute or 1-hour summaries of the data to speed up long-range queries (e.g., "Show me traffic trends over the last year").

**Summary:** Thanos is excellent if you want to keep your Prometheus servers autonomous but query them all from one place.

---

### 3. Cortex / Mimir

*Note: Cortex was the original CNCF project. Grafana Labs, the main contributors to Cortex, forked it to create **Mimir**, which is now the more modern, actively developed version. They share the same architectural DNA.*

Unlike Thanos (which pulls data from Sidecars), Mimir/Cortex relies on a **Centralized Push Architecture**.

#### Architecture:
*   **Remote Write:** Your Prometheus servers are configured to be "dumb." They scrape metrics and immediately forward (push) them to the central Mimir cluster using the `remote_write` API. Prometheus retains very little local data.
*   **Horizontally Scalable Microservices:** Mimir is a complex distributed system composed of:
    *   **Distributors:** Receive incoming data and hash it to specific ingesters.
    *   **Ingesters:** Hold data in memory and write it to object storage.
    *   **Queriers:** Fetch data for users.
*   **Multi-tenancy:** This is the "killer feature" of Mimir/Cortex. It is designed to host metrics for multiple different teams (Tenants) entirely separately within the same cluster. Team A cannot see Team B's metrics, even though they share the database.

**Summary:** Mimir is best if you want to build a centralized "Monitoring as a Service" platform for a large organization, where Prometheus agents are just data shippers.

---

### 4. VictoriaMetrics

VictoriaMetrics (VM) is an alternative storage solution that focuses on **Performance** and **Operational Simplicity**.

#### Key Characteristics:
*   **High Compression:** VM is famous for squeezing data down to incredibly small sizes on disk, often 10x smaller than standard Prometheus.
*   **Simplicity:** While Thanos and Mimir involve many microservices (Store, Querier, Compactor, Distributor, etc.), VictoriaMetrics can often be run as a **Single Binary** that handles everything (ingestion, storage, and querying) effectively, even at high scale. It also has a cluster version for massive scale.
*   **PromQL Compatible:** It speaks "PromQLish" (MetricsQL), so it works with Grafana and Alertmanager drop-in.
*   **Architecture:** It usually works via **Remote Write** (like Mimir). You point your Prometheus servers to write data into VictoriaMetrics.

**Summary:** VictoriaMetrics is the choice if you want maximum performance with minimum maintenance overhead and don't strictly require the complex microservice architecture of Mimir.

---

### 5. Architecture Comparisons (The "Cheat Sheet")

When deciding between these three for a Global View and Long-Term Storage:

| Feature | **Thanos** | **Cortex / Mimir** | **VictoriaMetrics** |
| :--- | :--- | :--- | :--- |
| **Primary Approach** | **Sidecar (Pull)** <br> Keeps Prometheus independent. | **Remote Write (Push)** <br> Centralizes everything immediately. | **Remote Write (Push)** <br> (Can also pull/scrape directly). |
| **Complexity** | Medium. Requires sidecars, store gateways, and bucket management. | High. Many microservices to manage and tune. | Low/Medium. Often a single binary or simple cluster. |
| **Global View** | **Federated View.** Queries fetch data from the edge locations live. | **Centralized View.** All data is already in the center. | **Centralized View.** All data is already in the center. |
| **Ideal Use Case** | You have many K8s clusters and want a unified view without moving all data to a central spot immediately. | You are a large Enterprise/SaaS provider needing multi-tenancy and strict isolation between teams. | You want cost efficiency, low RAM/Disk usage, and high speed without complexity. |

### Why is this in the "Scaling" section?
Because standard Prometheus hits a wall at around 1-5 million active time series per server (depending on hardware). To monitor a massive infrastructure with 50 million+ metrics, you **must** use one of these strategies to shard the data and store it globally.
