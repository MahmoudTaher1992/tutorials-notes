Based on the Table of Contents provided, here is a detailed explanation of **Part XI, Section B: Troubleshooting Jaeger Itself**.

This section addresses the meta-problem of observability: **"Who watches the watcher?"** When your distributed tracing system fails, you lose visibility into your applications. This section details how to monitor the health of Jaeger components and how to resolve the most common architectural issues.

---

# 011-Advanced-Analysis-Troubleshooting / 002-Troubleshooting-Jaeger-Itself

## 1. Self-Monitoring: Jaeger Metrics
Jaeger components (Collector, Agent, Query, Ingester) are production services that can crash, run out of memory, or experience network latency just like the microservices they monitor.

### How Jaeger Exposes Health
By default, Jaeger binaries expose an administrative port (usually **14269** or **8888**) that provides internal metrics in **Prometheus format**. To monitor Jaeger, you should configure your Prometheus server to scrape these endpoints.

### Key Metrics to Alert On
You should set up dashboards (typically in Grafana) to watch these specific metrics. If these spike, Jaeger is losing data.

| Component | Metric Name | Meaning | Criticality |
| :--- | :--- | :--- | :--- |
| **Collector** | `jaeger_collector_spans_dropped_total` | Spans arrived at the collector but were discarded (usually due to queue full or DB write errors). | **High** |
| **Collector** | `jaeger_collector_spans_saved_total` | Successful writes to the database. If this drops to zero while traffic exists, the DB is down. | **High** |
| **Agent** | `jaeger_agent_reporter_batches_failures_total` | The Agent failed to send a batch of spans to the Collector. | **Medium** |
| **Generic** | `process_resident_memory_bytes` | Standard Go runtime metric. Indicates if Jaeger is leaking memory or hitting limits (OOM Kill risk). | **Medium** |
| **Kafka** | `sarama_producer_outgoing_byte_rate` | (If using Kafka) Shows if the Ingester is keeping up with the topic lag. | **High** |

---

## 2. Common Error: UDPSender & Packet Size Limits
This is the most common issue when using the legacy **Jaeger Agent** architecture or older **Jaeger Clients** that default to UDP.

### The Problem
Historically, Jaeger Clients sent spans to the local Jaeger Agent via **UDP** (User Datagram Protocol) because it is "fire and forget" and adds minimal overhead to the application.
However, UDP has a strict **Maximum Transmission Unit (MTU)** size limit (typically around 65KB in Jaeger's implementation, but network fragmentation often limits it to ~1500 bytes on the wire).

**Scenario:** You have a trace with a very large SQL statement, or a stack trace in the logs, or a large JSON blob in the tags.
1. The Span size exceeds the UDP packet limit.
2. The OS network stack drops the packet silently.
3. The span never reaches the Agent.
4. **Result:** You see "Broken Traces" (missing children) or completely missing traces in the UI.

### The Solution
1. **Switch to HTTP/gRPC:** Configure your clients (or OpenTelemetry exporters) to send data directly to the Jaeger Collector using **gRPC** or **HTTP**. These protocols over TCP handle fragmentation automatically.
2. **Compact Data:** Remove unnecessary large logs or binary data from span tags.
3. **Increase Buffer (Temporary):** You can try to increase the UDP buffer size in the OS (`sysctl -w net.inet.udp.maxdgram=...`), but this is brittle.

---

## 3. Common Error: Clock Skew
Distributed tracing relies heavily on timestamps to generate the waterfall visualization.

### The Problem
If Service A calls Service B, but Service B's internal system clock is lagging 5 seconds behind Service A, the trace data will say that Service B received the request **before** Service A sent it.

### Symptoms in Jaeger UI
1. **Negative Duration:** Spans appear to finish before they start.
2. **Visual Glitches:** The waterfall view looks disjointed or spans overlap in impossible ways.
3. **Jaeger Adjustments:** The Jaeger UI attempts to algorithmically "fix" the view by shifting spans, but a yellow warning banner may appear saying "Clock Skew Detected."

### The Solution
*   **NTP (Network Time Protocol):** Ensure that **all nodes** (VMs, Kubernetes Nodes) in your cluster are running an NTP daemon (like `chrony` or `ntpd`) and are synchronized to a central time source.
*   **Drift Monitoring:** Set up alerts if node clock drift exceeds 100ms.

---

## 4. Common Error: Dropped Spans Reporting
"I instrumented my code, but I can't find the trace in the UI." This is the most frustrating issue for developers.

### Cause 1: Intentional Sampling
**Diagnosis:** The most common reason is that the system is working exactly as configured. If your sampling strategy is set to `probabilistic` at `0.1%`, then 999 out of 1000 traces are *supposed* to be dropped.
**Fix:** Force sampling to 100% (`param=1`) during debugging/development to verify connectivity.

### Cause 2: Queue Buffer Overflows (Backpressure)
**Diagnosis:** The Jaeger Collector has an internal memory queue. It reads spans from the Agent, holds them in memory, and writes them to the DB (Elasticsearch/Cassandra).
If the DB is slow (high write latency), the Collector's internal queue fills up. Once full, the Collector immediately drops new incoming spans.
**Fix:**
*   Check the metric `jaeger_collector_queue_length`.
*   Scale up the Storage Backend (add more Elasticsearch nodes).
*   Increase the `queue-size` configuration in the Jaeger Collector (consumes more RAM).

### Cause 3: Connectivity/Firewall
**Diagnosis:** The application cannot reach the Collector endpoint.
**Fix:**
*   Check Kubernetes NetworkPolicies.
*   Verify the correct port usage (e.g., sending **gRPC** traffic to the **HTTP** port, or vice versa).
    *   `14250`: gRPC (Model)
    *   `14268`: HTTP (Thrift)
    *   `4317`: OTLP gRPC (if using OTel)

### Cause 4: "Zombie" Spans
**Diagnosis:** The application crashes before the span is "finished" (i.e., `span.finish()` is never called in the code). The span remains in memory in the client and is never flushed to the collector.
**Fix:** Ensure `try/finally` blocks used in manual instrumentation ensure spans are finished even during exceptions.
