Based on the Table of Contents you provided, **Part XV (Reference & Tooling) - Section A (CLI Tools)** focuses on the command-line interfaces used to run, configure, and maintain Jaeger.

When running Jaeger in production, you rarely just "double-click an icon." You run specific binaries with specific flags (arguments) to ensure they connect to the right storage, listen on the right ports, and secure the data.

Here is a detailed explanation of the three key areas listed in that section.

---

### 1. `jaeger-all-in-one`
This is the most famous Jaeger binary, designed for **local development, testing, and demos**.

*   **What it does:** It bundles **all** backend components (Agent, Collector, Query, UI) into a single executable running in a single process.
*   **Default Behavior:**
    *   It launches the UI at `http://localhost:16686`.
    *   It stores traces **in-memory**. If you restart the binary, all data is lost.
*   **Key CLI Arguments:**
    Since it contains all components, it accepts flags for all of them.
    *   `--memory.max-traces`: Sets the limit on how many traces to keep in RAM (default is usually 50,000). Once full, it drops the oldest traces.
    *   `--log-level`: Controls verbosity (e.g., `debug`, `info`, `error`).
*   **When to use it:** When learning Jaeger, debugging an application locally, or running a quick proof-of-concept.
*   **When NOT to use it:** High-load production environments. It cannot scale horizontally (you can't add more collectors without adding more UIs and splitting memory).

### 2. `jaeger-query` CLI Arguments
In a production architecture, the components are split up. The **Jaeger Query** service is responsible for hosting the UI and retrieving data from the database to show to the user.

Configuring this binary correctly is critical for the UI to work.

*   **Storage Configuration Flags:**
    You must tell the Query service which database to talk to.
    *   `--span-storage.type`: This is the master switch. Values include `elasticsearch`, `cassandra`, `kafka`, `badger`, or `grpc-plugin`.
    *   *Example:* If you set this to `elasticsearch`, you unlock a whole new set of flags like `--es.server-urls` and `--es.username`.

*   **UI Configuration Flags:**
    *   `--query.base-path`: Critical if Jaeger is running behind a Reverse Proxy (like Nginx) under a sub-path (e.g., `mycompany.com/jaeger/`).
    *   `--query.ui-config`: A path to a JSON file that customizes the UI (e.g., changing the menu links, setting default dependencies, or disabling specific tracking features).

*   **Port & Host Flags:**
    *   `--query.port`: The port the HTTP server listens on (default `16686`).
    *   `--admin.http-host-port`: The port for health checks and metrics (usually used by Kubernetes probes).

### 3. `es-rollover` and Maintenance Tools
This refers to the maintenance scripts required when using **Elasticsearch (ES)** or **OpenSearch** as the storage backend.

If you dump all your tracing data into a single Elasticsearch index, it will eventually become too large to search, and your cluster will crash. To prevent this, Jaeger uses a strategy called **Index Rollover** or **Daily Indices**.

There are usually two distinct CLI tools/scripts (often written in Python) provided in the Jaeger Docker images:

#### A. `jaeger-es-index-cleaner`
*   **Purpose:** Garbage collection.
*   **How it works:** You run this as a CronJob (e.g., every night). It connects to ES and deletes indices older than a certain number of days.
*   **Key Argument:** `NUM_DAYS` (Environment variable or arg). If set to `7`, it deletes trace data from 8 days ago.

#### B. `jaeger-es-rollover`
*   **Purpose:** Sharding and Write Management.
*   **The Problem:** Simply creating one index per day (`jaeger-span-2023-10-27`) is simple, but if you have massive traffic, that single day's index might be 5TB, which is too big for one shard.
*   **The Solution:** Rollover allows you to write to an "alias" (e.g., `jaeger-span-write`). When the backing index reaches a certain size (e.g., 50GB) or age, this tool commands Elasticsearch to "roll it over" to a new index automatically.
*   **Usage:** This is an advanced maintenance tool used by high-volume enterprises to ensure Elasticsearch remains performant.

---

### Summary Checklist for this Section

If you are studying for an exam or implementing this, ensure you understand:

1.  **Development:** Use `jaeger-all-in-one` for simplicity; know that it loses data on restart.
2.  **Configuration:** `jaeger-query` needs to know *where* the database is via the `--span-storage.type` flag.
3.  **Maintenance:** You cannot run Jaeger with Elasticsearch in production without setting up the **Cleaner** (to save disk space) and the **Rollover** (to keep indices performant).
