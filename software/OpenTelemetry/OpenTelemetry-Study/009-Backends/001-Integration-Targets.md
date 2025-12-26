Here is a detailed explanation of **Part IX: Backends and Visualization - Section A: Integration Targets**, based on the file path structure you provided.

---

# 009-Backends / 001-Integration-Targets.md

## Introduction: The "Not My Job" Philosophy
To understand integration targets, you must understand a core philosophy of OpenTelemetry: **OTel is a producer and conveyor belt, not a warehouse.**

OpenTelemetry generates data (Telemetry), processes it (Collector), and transports it (Exporters). It does **not** store data long-term, nor does it provide a UI to analyze graphs or trace waterfalls. For that, you need **Backends** (Integration Targets).

Because OTel is vendor-neutral, it allows you to switch these backends without rewriting your application code. You simply change the configuration in the OTel Collector.

---

## 1. Prometheus (Metrics)
Prometheus is the de facto standard for monitoring in Kubernetes and Cloud Native environments. However, OTel and Prometheus have historically used different data transmission models, leading to two distinct integration strategies.

### The Conflict: Pull vs. Push
*   **OpenTelemetry** is primarily **Push-based**. The application sends data to the Collector, which sends it to a backend.
*   **Prometheus** is primarily **Pull-based**. It expects to reach out to an HTTP endpoint (`/metrics`) and scrape data at a set interval.

### Strategy A: The Prometheus Exporter (Pull)
In this scenario, the OpenTelemetry Collector acts as a bridge. It accepts OTel data (via push), but then spins up a local server and exposes a `/metrics` endpoint. Prometheus scrapes this endpoint just like any other target.

*   **Flow:** App $\to$ OTel Collector $\to$ (holds data in memory) $\leftarrow$ Prometheus Scraper.
*   **Use Case:** When you have an existing standard Prometheus setup and want OTel metrics to look like standard legacy metrics.

### Strategy B: Prometheus Remote Write (Push)
This is becoming the preferred method for high-scale environments. Prometheus supports an API called "Remote Write." The OTel Collector can "push" metrics directly into Prometheus (or compatible stores like Thanos, Cortex, or Mimir) without waiting to be scraped.

*   **Flow:** App $\to$ OTel Collector $\to$ Prometheus (via Remote Write API).
*   **Use Case:** Large-scale environments where scraping becomes a bottleneck, or when using managed Prometheus services (like AWS Managed Prometheus).

**Collector Config Example:**
```yaml
exporters:
  prometheusremotewrite:
    endpoint: "http://my-prometheus:9090/api/v1/write"
```

---

## 2. Jaeger / Zipkin (Traces)
Before OTel, there were Jaeger and Zipkin. They are open-source distributed tracing systems that provide both storage and a UI (User Interface) to visualize "Waterfalls" (Gantt charts of requests).

### Jaeger
Jaeger is the most popular open-source tracing backend.
*   **Visualization:** It renders the Distributed Acyclic Graph (DAG) of your microservices. You can see exactly how long a request took in the database vs. the API.
*   **The OTel Integration:** Modern Jaeger versions natively accept **OTLP** (OpenTelemetry Protocol). This means you don't need to convert data formats; the OTel Collector simply points to the Jaeger endpoint.
*   **Architecture:** You send traces from the OTel Collector to the Jaeger Collector (or directly to Jaeger storage via the Jaeger OTel exporter).

### Zipkin
Zipkin is the "grandfather" of modern tracing.
*   **Legacy:** While less feature-rich than Jaeger, it is incredibly stable and widely supported.
*   **B3 Propagation:** Zipkin introduced the `X-B3-TraceId` headers. While OTel prefers W3C TraceContext, OTel provides exporters to translate OTel traces into Zipkin JSON format for backward compatibility.

**Collector Config Example:**
```yaml
exporters:
  otlp: # Sending to Jaeger via OTLP gRPC
    endpoint: "jaeger-collector:4317"
    tls:
      insecure: true
```

---

## 3. Grafana Stack (The "LGTM" Stack)
Grafana has moved beyond just being a dashboard tool. They have created a full observability stack (Loki, Grafana, Tempo, Mimir) explicitly designed to ingest OpenTelemetry data.

### Tempo (Traces)
Grafana Tempo is a high-volume, minimal-dependency trace backend.
*   **Differentiation:** Unlike Jaeger/Elasticsearch, Tempo does not index every single tag in the trace. It relies on **TraceID** lookup. This makes it incredibly cheap to store 100% of your traces (no sampling required) in object storage (S3).
*   **Integration:** It accepts OTLP natively. You view the traces inside the Grafana UI.

### Mimir (Metrics)
Mimir is Grafana's solution for long-term Prometheus storage.
*   **Role:** It acts as a massive, scalable Prometheus backend. You use the OTel **Prometheus Remote Write** exporter to send metrics here.

### Loki (Logs)
Loki is "Prometheus for Logs."
*   **Concept:** Instead of indexing the full text of logs (which is expensive), Loki only indexes the **labels** (metadata).
*   **OTel Integration:** The OTel Collector processes logs (parsing, filtering) and then uses a specific **Loki Exporter** to push them to Loki. This allows you to correlate logs with traces and metrics inside Grafana dashboards.

---

## 4. Elasticsearch (ELK Stack)
The ELK stack (Elasticsearch, Logstash, Kibana) is the enterprise giant for log analytics.

### The Use Case
While Grafana Loki is gaining popularity, Elasticsearch is still dominant for scenarios requiring **Full Text Search**. If you need to search logs for "Error: User 1234" across 500GB of logs instantly, Elasticsearch is the tool.

### The OTel Shift
Historically, people used **Filebeat** or **Logstash** to send logs to Elastic.
With OpenTelemetry:
1.  **Replaces Filebeat:** The OTel Collector (running as an Agent on the host) reads the log files.
2.  **Replaces Logstash:** The OTel Collector processes the logs (parsing JSON, masking PII).
3.  **Export:** The Collector uses the **Elasticsearch Exporter** to index the documents directly into Elasticsearch.

**Benefit:** You get a single agent (OTel) handling Traces, Metrics, and Logs, rather than running Filebeat (Logs) + Metricbeat (Metrics) + Jaeger Agent (Traces).

---

## Summary of Data Flow

To visualize how these fit together in a production architecture:

| Signal | Source (App) | Processor (OTel Collector) | Target (Backend) | Visualization (UI) |
| :--- | :--- | :--- | :--- | :--- |
| **Metrics** | OTel SDK | Batch / Renaming | **Prometheus** / Mimir | Grafana |
| **Traces** | OTel SDK | Tail Sampling | **Jaeger** / Tempo | Jaeger UI / Grafana |
| **Logs** | OTel SDK / Files | Parsing / Redacting | **Elasticsearch** / Loki | Kibana / Grafana |

### Why this matters for your study:
This section teaches you **interoperability**. The power of OTel is that you can start by sending traces to open-source Jaeger. A year later, you can switch to Grafana Tempo or a paid vendor (like Datadog) by changing *only* the `exporters` section of your Collector `config.yaml`, without touching a single line of application code.