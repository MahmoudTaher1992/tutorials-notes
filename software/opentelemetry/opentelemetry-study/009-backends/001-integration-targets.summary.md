I am your **Computer Science and Observability Master Teacher**. Today, we are looking at where our data actually goes after we collect it. Think of OpenTelemetry (OTel) as a complex system of conveyor belts and delivery trucks; today's lesson is about the warehouses and filing cabinets where those packages ultimately land.

Here is the summary of **Integration Targets**:

*   **1. The Core Philosophy: "Not My Job"**
    *   **OTel is a conveyor belt, not a warehouse**
        *   (OTel creates, processes, and transports data, but it refuses to store it long-term or draw graphs for you)
    *   **The need for Backends**
        *   (To see charts, analyze errors, or search logs, you must send data to a specialized vendor or tool called an "Integration Target")
    *   **The Superpower: Neutrality**
        *   (Because OTel is independent, you can switch from one storage brand to another just by changing a config file, without rewriting your app's code)

*   **2. Metrics: The Prometheus Integration**
    *   **The Conflict: Push vs. Pull**
        *   **OpenTelemetry's nature**
            *   (Push-based: The app actively throws data at the collector)
        *   **Prometheus's nature**
            *   (Pull-based: It likes to visit a URL and "scrape" or grab data at specific intervals)
    *   **Strategy A: The Prometheus Exporter (Pull)**
        *   **How it works**
            *   (The OTel Collector pauses, holds data in memory, and spins up a mini-webpage for Prometheus to come and read)
        *   **Use Case**
            *   (Best for traditional setups where you want OTel to behave like a standard legacy system)
    *   **Strategy B: Remote Write (Push) — **The Modern Standard****
        *   **How it works**
            *   (OTel forces data directly into Prometheus using the "Remote Write" API, skipping the waiting game)
        *   **Use Case**
            *   (Essential for high-scale cloud environments where waiting to be scraped is too slow or heavy)

*   **3. Traces: Jaeger & Zipkin**
    *   **Jaeger (The Popular Choice)**
        *   **Visualization**
            *   (Draws "Waterfalls" or DAGs, showing exactly how long a request spent in the database vs. the API)
        *   **Integration**
            *   (Modern Jaeger speaks OTel's language natively [OTLP], so no translation is needed—just point and shoot)
    *   **Zipkin (The "Grandfather")**
        *   **Status**
            *   (Older, very stable, but less feature-rich than Jaeger)
        *   **Compatibility**
            *   (Uses a different header format called `B3`; OTel can translate its data into Zipkin format if you are forced to use legacy systems)

*   **4. The Grafana Stack ("LGTM")**
    *   **Tempo (For Traces)**
        *   **Efficiency**
            *   (Unlike Jaeger which indexes everything, Tempo acts like a simple lookup storage based on TraceID)
        *   **Benefit**
            *   (It is incredibly cheap to store 100% of your data in cloud storage [S3] without filtering anything out)
    *   **Mimir (For Metrics)**
        *   (A massive, scalable storage engine for Prometheus data)
    *   **Loki (For Logs)**
        *   **Concept**
            *   ("Prometheus for Logs"—it only looks at the tags/labels on the log, not the full text sentence)
        *   **Synergy**
            *   (Allows you to easily connect a log error to a trace and a metric graph in one view)

*   **5. The ELK Stack (Elasticsearch)**
    *   **The Specialist Role**
        *   (Dominant when you need **Full Text Search**, like finding the specific phrase "User 1234" inside terabytes of text)
    *   **The OTel Takeover**
        *   **Replacing Legacy Agents**
            *   (Instead of running separate agents like Filebeat or Logstash, the OTel Collector reads, parses, and sends the logs itself)
        *   **The "All-in-One" Benefit**
            *   (One single software agent [OTel] now handles Metrics, Traces, and Logs simultaneously)

*   **6. Summary of Data Flow**
    *   **Metrics Flow**
        *   Source: App $\to$ Processor: Batching $\to$ Backend: **Prometheus** $\to$ UI: Grafana
    *   **Traces Flow**
        *   Source: App $\to$ Processor: Sampling $\to$ Backend: **Jaeger/Tempo** $\to$ UI: Jaeger UI
    *   **Logs Flow**
        *   Source: Files $\to$ Processor: Parsing $\to$ Backend: **Elasticsearch/Loki** $\to$ UI: Kibana
