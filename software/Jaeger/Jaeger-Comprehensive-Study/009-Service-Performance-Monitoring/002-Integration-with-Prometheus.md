Based on **Part IX: Service Performance Monitoring (SPM)** of your table of contents, here is a detailed explanation of section **009-Service-Performance-Monitoring / 002-Integration-with-Prometheus**.

---

# 002-Integration with Prometheus (Service Performance Monitoring)

In the context of Jaeger, integration with Prometheus is not just about monitoring Jaeger's own health (CPU/Memory); it is about **deriving business metrics from trace data** and visualizing them to bridge the gap between Tracing and Metrics.

## 1. The Concept: Why Integrate?

In the "Three Pillars of Observability," **Traces** tell the story of a specific request, while **Metrics** show trends over time.

*   **The Problem:** Viewing individual traces is great for debugging a specific error, but it is terrible for understanding: *"Is my service getting slower overall?"* or *"What is my error rate compared to yesterday?"*
*   **The Solution:** You can aggregate the data found inside Spans to calculate **RED Metrics**:
    *   **R**ate (How many requests/spans per second).
    *   **E**rrors (How many spans failed).
    *   **D**uration (P50, P95, P99 latency).

Jaeger integrates with Prometheus to store these aggregated metrics and then queries them back to display high-level graphs in the Jaeger UI.

## 2. The Architecture: How data flows

The integration usually works in a loop. Spans generate metrics, Prometheus stores them, and Jaeger reads them back.

### A. Generating the Metrics (The Writer)
There are two main ways to generate Prometheus-compatible metrics from Traces:

1.  **The OpenTelemetry Collector (Recommended):**
    *   Your application sends Spans to the OpenTelemetry (OTel) Collector.
    *   The OTel Collector uses a processor called `spanmetrics`.
    *   This processor looks at every span passing through, calculates counts and latency buckets, and exports them as Prometheus metrics.
2.  **Jaeger Collector (Legacy/Native):**
    *   The Jaeger Collector itself can be configured to derive metrics from the spans it receives and expose a `/metrics` endpoint for Prometheus to scrape.

### B. Storing the Metrics (Prometheus)
Prometheus scrapes the endpoint provided above. It stores time-series data like:
*   `calls_total{service_name="frontend", span_name="get_user"}`
*   `latency_bucket{service_name="frontend", span_name="get_user", le="0.5"}`

### C. Visualizing the Metrics (Jaeger Query)
This is the specific integration point for Jaeger. The **Jaeger Query Service** (which powers the UI) is configured to connect to Prometheus. When a user clicks the **"Monitor"** tab in the Jaeger UI, Jaeger sends **PromQL** (Prometheus Query Language) queries to the Prometheus server to generate the graphs.

## 3. Configuration Steps

To enable this integration, you primarily configure the **Jaeger Query** component.

### Step 1: Metrics Generation (Example via OTel)
*If you are using the OpenTelemetry Collector, you configure the `spanmetrics` processor.*
```yaml
processors:
  spanmetrics:
    metrics_exporter: prometheus
    # Dimensions to turn into metric labels (e.g., http.status_code)
    dimensions:
      - name: http.status_code

exporters:
  prometheus:
    endpoint: "0.0.0.0:8889"
```

### Step 2: Configure Jaeger Query to Read from Prometheus
You must tell the Jaeger Query service that it should look for metrics in Prometheus. This is usually done via environment variables or flags on the Jaeger Query binary.

**Environment Variables:**
```bash
# Enable the Monitor tab
METRICS_STORAGE_TYPE=prometheus

# Point to your Prometheus Server
PROMETHEUS_SERVER_URL=http://prometheus:9090

# (Optional) Customize the query step duration
PROMETHEUS_QUERY_SUPPORT_SPANMETRICS_CONNECTOR=true
```

## 4. The "Monitor" Tab in Jaeger UI

Once integrated, a new tab appears in the Jaeger UI main menu called **Monitor**.

When you open this tab:
1.  **Selection:** You select a **Service** (e.g., `frontend`) and an **Operation** (e.g., `/checkout`).
2.  **Visualization:** Jaeger queries Prometheus and renders three graphs:
    *   **Latency:** A line graph showing P95, P75, and P50 latency over time.
    *   **Request Rate:** How many requests per second.
    *   **Error Rate:** The percentage of failed spans.

## 5. Benefits of this Integration

1.  **Context Preservation:** You don't have to switch tools. You can see the high-level trend (in the Monitor tab), notice a spike in latency, and immediately switch to the Trace view (Search tab) to find the specific traces causing that spike.
2.  **Consistency:** Because the metrics are derived directly from the spans, there is no discrepancy between what your Monitoring Dashboard says and what your Tracing backend shows.
3.  **Cross-Signal Analysis:** You can aggregate metrics by Span Tags (e.g., grouping metrics by `customer_id` or `deployment_version`) if you configure the processor correctly.

## 6. Common Challenges

*   **Cardinality Explosion:** If you try to turn too many Trace Tags (like `user_id` or `trace_id`) into Metric Labels, Prometheus will run out of memory. This integration requires careful selection of which span tags become metric labels.
*   **Storage Costs:** You are essentially storing data twice (once as a trace in Elasticsearch/Cassandra, and once as an aggregate in Prometheus).
*   **Sampling:** If you use "Head-Based Sampling" and only keep 10% of your traces, your generated metrics will only represent 10% of your traffic unless the generator accounts for the sampling rate. (Note: The OpenTelemetry `spanmetrics` connector generally handles this by seeing *all* spans before sampling decisions discard them, provided it is placed correctly in the pipeline).
