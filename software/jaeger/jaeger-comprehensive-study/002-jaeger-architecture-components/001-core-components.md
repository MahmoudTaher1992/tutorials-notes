Based on the Table of Contents you provided, here is a detailed explanation of **Part II: Jaeger Architecture & Components / A. Core Components**.

To understand Jaeger, you must visualize it as a **pipeline**. Data (traces) flows from your application code, moves through several processing stages, and finally lands in a database to be visualized.

Here is the deep dive into each component listed in your TOC.

---

### 1. Jaeger Client (The Source / Instrumentation)
**Status:** *Deprecated / Transitioning to OpenTelemetry*

*   **What it is:** These are language-specific libraries (e.g., `jaeger-client-java`, `jaeger-client-go`) that developers used to install directly into their application code.
*   **Role:**
    1.  **Instrumentation:** It "hooks" into your code to measure how long functions take.
    2.  **Context Propagation:** When Service A calls Service B, the Client injects headers (Trace IDs) into the HTTP request so Service B knows it belongs to the same trace.
    3.  **Sending:** It buffers the collected data in memory and sends it out (usually via UDP) to the **Jaeger Agent**.
*   **The Modern Shift:** As noted in your TOC, these clients are being retired. The industry has standardized on **OpenTelemetry (OTel)**. New architectures use the **OTel SDK** to generate traces, but they can still export data to the Jaeger backend.

### 2. Jaeger Agent (The Local Listener)
**Role: The "Mailbox"**

*   **What it is:** A network daemon that runs locally relative to your application.
    *   In **VMs**: It runs as a background process on the host.
    *   In **Kubernetes**: It usually runs as a **Sidecar** (inside the same Pod) or a **DaemonSet** (one per Node).
*   **Why do we need it?**
    *   **UDP Protocol:** The Client sends data via UDP (Fire and Forget) to the Agent on `localhost`. This is extremely fast and ensures your application doesn't slow down waiting for a TCP handshake to a remote server.
    *   **Abstraction:** The application doesn't need to know where the Jaeger Collector is located. It just dumps mail in the local mailbox (Agent).
    *   **Throttling:** The Agent acts as a buffer. It handles the connection to the backend Collector.
*   **Data Flow:** App $\to$ UDP $\to$ **Agent** $\to$ gRPC/TChannel $\to$ Collector.

### 3. Jaeger Collector (The Processor)
**Role: The "Sorting Facility"**

*   **What it is:** The heavy-lifting backend component. It is a stateless binary, meaning you can run many copies of it to handle high traffic.
*   **Core Responsibilities:**
    1.  **Validation:** It checks if the spans received are valid (correct format, not malformed).
    2.  **Transformation:** It standardizes the data.
    3.  **Sampling Decisions:** The Collector determines how much data to keep (e.g., "Keep 100% of traces" or "Keep 0.1%"). It sends these instructions back down to the Agent.
    4.  **Storage Writing:** This is the most critical part. The Collector writes the trace data to the persistent storage (Elasticsearch, Cassandra, etc.).
*   **Performance:** This component is usually CPU-bound because it has to serialize/deserialize massive amounts of data.

### 4. Jaeger Query (The Retriever)
**Role: The "Librarian"**

*   **What it is:** An API server that retrieves data.
*   **How it works:** When a user opens the Jaeger UI and searches for "Traces with Error tags," the UI sends a request to the Jaeger Query service.
*   **Responsibility:** It connects directly to the Database (Elasticsearch/Cassandra) to run queries. It formats the data into a structure the UI can display (JSON).
*   **Limitations:** In most architectures, the Query service is just reading what the Collector wrote. It does not ingest data.

### 5. Jaeger Ingester (The Asynchronous Worker)
**Role: The "Buffer Consumer"**

*   **Context:** This component **only** exists in the **Streaming (Kafka)** architecture. It is NOT used in the default "Direct-to-Storage" setup.
*   **The Problem:** Sometimes traffic spikes massively (e.g., Black Friday). If the Collector tries to write to the Database directly, the Database might crash or slow down, causing the Collector to drop data.
*   **The Solution:**
    1.  The **Collector** writes data to **Kafka** (a high-speed message queue) instead of the DB.
    2.  The **Ingester** reads from Kafka at its own pace.
    3.  The **Ingester** writes to the DB.
*   **Benefit:** If the DB slows down, the Ingester slows down, but the data is safe inside Kafka. It acts as a shock absorber.

### 6. Jaeger UI (The Visualizer)
**Role: The "Monitor"**

*   **What it is:** A React-based web frontend.
*   **Function:** It is the window into your data. It does not store or process data itself; it simply visualizes what the **Jaeger Query** service returns.
*   **Key Views:**
    *   **Timeline/Waterfall:** Shows bars representing time taken by services.
    *   **DAG (Directed Acyclic Graph):** A map showing how services connect to one another.
    *   **Comparisons:** Visualizing the difference between a fast trace and a slow trace.

---

### Summary of Data Flows

#### 1. Simple Flow (Direct to Storage)
> App (Client) $\rightarrow$ Agent $\rightarrow$ Collector $\rightarrow$ Database $\leftrightarrow$ Query $\leftrightarrow$ UI

#### 2. Advanced Flow (Streaming with Kafka)
> App (Client) $\rightarrow$ Agent $\rightarrow$ Collector $\rightarrow$ **Kafka** $\rightarrow$ **Ingester** $\rightarrow$ Database $\leftrightarrow$ Query $\leftrightarrow$ UI

This architecture ensures that the heavy burden of tracing does not impact the performance of your actual application microservices.
