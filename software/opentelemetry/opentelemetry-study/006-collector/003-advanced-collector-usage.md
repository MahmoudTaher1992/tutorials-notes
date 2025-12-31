Here is the detailed explanation for the module **Part VI, Section C: Advanced Collector Usage**.

This section represents the transition from using the Collector as a simple data mover (receive $\to$ batch $\to$ export) to using it as an **intelligent data processing engine**. This is where you implement cost control, data governance, and high-scale architecture strategies.

---

# 006-Collector / 003-Advanced-Collector-Usage.md

## 1. Tail Sampling Processor
**The "Smart Retention" Strategy**

In basic instrumentation, we often use "Head Sampling" (deciding at the start of the request whether to record it). However, Head Sampling is a guess. You might drop a trace that eventually throws a critical error, or keep a trace that is perfectly normal and boring.

**Tail Sampling** moves the decision to the Collector. The Collector buffers the spans in memory, waits for the trace to complete (or time out), and *then* decides whether to keep it based on what actually happened.

### Core Sampling Policies
You can combine multiple policies using `and` / `or` logic.

1.  **Status Code Sampling:** "Keep 100% of traces where `status_code == ERROR`." This ensures you never miss a failure, even if your overall sampling rate is low.
2.  **Latency Sampling:** "Keep any trace that took longer than 2 seconds." This helps you catch performance outliers.
3.  **Probabilistic Sampling:** "Keep 1% of the remaining (successful/fast) traffic." This gives you a baseline for general statistics.
4.  **String Attribute Sampling:** "Keep all traces coming from `customer_id: premium_123`."

### Configuration Example
```yaml
processors:
  tail_sampling:
    decision_wait: 10s   # Wait 10s for spans to arrive
    num_traces: 50000    # Buffer size in memory
    policies:
      [
        {
          name: error-policy,
          type: status_code,
          status_code: {action_keys: [ERROR]}
        },
        {
          name: latency-policy,
          type: latency,
          latency: {threshold_ms: 1000}
        }
      ]
```

### The Architectural Constraint
For Tail Sampling to work, **all spans** belonging to `TraceID: XYZ` must arrive at the **same** Collector instance. If Spans A and B go to Collector 1, and Spans C and D go to Collector 2, neither collector sees the full picture, and the sampling logic fails. This requires the **Load Balancing Exporter** (discussed in section 4).

---

## 2. Transform Processor (OTTL)
**The "Swiss Army Knife" of Data Manipulation**

The Transform Processor allows you to modify telemetry data on the fly using the **OpenTelemetry Transformation Language (OTTL)**. It replaces older, specific processors (like the `attribute` processor) with a unified, code-like syntax.

### Why use it?
*   **Normalization:** Different teams name things differently (e.g., `user_id` vs `userId`). You can standardize them here.
*   **PII Redaction:** Obfuscate credit card numbers or emails before they leave your infrastructure.
*   **Cardinality Reduction:** Truncate high-cardinality values or group them.

### OTTL Syntax
OTTL uses a standard format: `target`, `context`, and `statements`.

*   **Contexts:** `resource`, `scope`, `span`, `span_event`, `metric`, `log`, `datapoint`.

### Examples

**1. Renaming an Attribute (Standardization):**
```yaml
processors:
  transform:
    error_mode: ignore
    trace_statements:
      - context: span
        statements:
          - set(attributes["http.method"], attributes["http.request.method"])
          - delete_key(attributes, "http.request.method")
```

**2. Redacting PII (Security):**
```yaml
processors:
  transform:
    trace_statements:
      - context: span
        statements:
          - replace_pattern(attributes["db.statement"], "([0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4})", "****")
```
*This regex looks for a credit card pattern in a SQL query and replaces it with `****`.*

---

## 3. Routing Processor
**Traffic Control for Telemetry**

Standard exporters act as a "Fan-out" (Broadcast) system. If you define three exporters, the data goes to all three.

The **Routing Processor** introduces "If/Else" logic. It allows you to route specific data to specific backends based on the content of the data (usually HTTP headers or Resource attributes).

### Use Cases
1.  **Multi-Tenancy:**
    *   If `tenant_id` is "Acme", send to the Acme Jaeger instance.
    *   If `tenant_id` is "Globex", send to the Globex Jaeger instance.
2.  **Cost Management:**
    *   Send "Dev" environment data to a cheap, short-retention backend.
    *   Send "Prod" environment data to an expensive, long-retention backend (like Datadog or Splunk).

### Configuration Concept
The routing processor typically reads from the `OS context` or HTTP Headers (Metadata).

```yaml
processors:
  routing:
    from_attribute: "X-Tenant-ID"
    table:
      - value: "tenant-a"
        exporters: [otlp/tenant-a]
      - value: "tenant-b"
        exporters: [otlp/tenant-b]
    default_exporters: [otlp/default]
```

---

## 4. Load Balancing Exporter
**Scaling the Gateway Layer**

This is the solution to the **Tail Sampling problem** mentioned in Section 1.

When you run a cluster of OpenTelemetry Collectors (a Gateway), a standard Load Balancer (like AWS ALB or Nginx) distributes traffic using Round-Robin. This scatters the spans of a single trace across different collectors.

The **Load Balancing Exporter** is not a processor; it is an exporter that sits on a **first layer** of collectors and forwards data to a **second layer** of collectors.

### How it works
1.  **Layer 1 (Agents/LBs):** Receives the data. It calculates a hash of the `TraceID`.
2.  **Consistent Hashing:** Based on the hash, it determines exactly which Collector in Layer 2 owns that `TraceID`.
3.  **Export:** It forwards all spans with that ID to that specific collector.

### Architecture Topology
1.  **Application Sidecars:** Send data to $\rightarrow$
2.  **Load Balancing Collectors (Layer 1):** Very lightweight. Only configured with `loadbalancing` exporter. They hash the trace ID and forward to $\rightarrow$
3.  **Sampling Collectors (Layer 2):** Heavyweight. These run the **Tail Sampling Processor**. Because of the LB Exporter, they are guaranteed to receive *full traces*. They process, sample, and send to $\rightarrow$
4.  **Backend (Jaeger/HoneyComb/etc.)**

### Configuration Example
```yaml
exporters:
  loadbalancing:
    protocol:
      otlp:
        # Configuration for downstream collectors
        tls:
          insecure: true
    resolver:
      static:
        hostnames:
          - collector-1:4317
          - collector-2:4317
    routing_key: "traceID" # Ensures traces stick together
```

---

### Summary of Advanced Workflow
In a high-maturity production setup, these components often work together in this flow:

1.  **App** emits data.
2.  **LB Exporter** ensures all spans for a trace go to the same specific collector node.
3.  **Transform Processor (OTTL)** cleans the data, normalizes names, and scrubs PII.
4.  **Tail Sampling Processor** analyzes the full trace and drops 90% of success signals to save money, but keeps 100% of errors.
5.  **Routing Processor** checks the environment tag and sends the data to the appropriate vendor or storage bucket.