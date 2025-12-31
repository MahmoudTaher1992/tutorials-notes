Here is a detailed breakdown of **Part VI, Section B: Core Processors**.

In the OpenTelemetry (OTel) Collector, **Processors** sit between Receivers (data coming in) and Exporters (data going out). If Receivers are the "mouth" and Exporters are the "hands," Processors are the "brain" and "digestive system." They clean, organize, enrich, and optimize the data before it is sent to the backend.

These four processors are considered "Core" because almost every production-grade Collector configuration will use them.

---

# 1. The Memory Limiter Processor (`memory_limiter`)
**The Safety Valve / Crash Prevention**

The OTel Collector is a Go application running on infrastructure. If it receives a massive spike in traffic (e.g., your system goes down and starts spamming error logs), the Collector might consume all available RAM and crash (OOM - Out of Memory). The Memory Limiter prevents this.

### How it works
It monitors the Collector’s memory usage at regular intervals. It generally uses two thresholds:
1.  **Soft Limit:** When memory hits this level, the processor starts refusing "new" data or triggering garbage collection to free up space. It tries to stabilize the system.
2.  **Hard Limit:** If memory hits this level, the processor aggressively forces data drops to prevent the process from crashing entirely.

### Configuration (`config.yaml`)
You can define limits by absolute size (`limit_mib`) or percentage of available system memory (`limit_percentage`).

```yaml
processors:
  memory_limiter:
    # Check memory usage every 1 second
    check_interval: 1s
    # Soft limit: Start shedding load at 800MB
    limit_mib: 800
    # Hard limit: Force drops at 1000MB (1GB)
    spike_limit_mib: 200
    # OR use percentages (better for containers):
    # limit_percentage: 50
    # spike_limit_percentage: 30
```

### Best Practice: Placement
**Critical Rule:** The `memory_limiter` must be the **first** (or very first) processor in your pipeline.
*   *Why?* You want to drop data *before* you spend CPU cycles modifying or batching it. If the boat is sinking, stop loading cargo immediately.

---

# 2. The Batch Processor (`batch`)
**The Performance Optimizer**

Network calls are expensive. If your application generates 10,000 spans per second, trying to send 10,000 individual HTTP/gRPC requests to Honeycomb, Datadog, or Jaeger will flood the network and crash the Collector.

The Batch Processor groups telemetry data into chunks (batches) to compress them and send them in a single request.

### How it works
It works on two triggers; whichever happens first causes the batch to send:
1.  **Time:** "I will wait 200ms to collect data."
2.  **Size:** "I will wait until I have 1,000 spans."

### Configuration (`config.yaml`)

```yaml
processors:
  batch:
    # Wait up to 200ms before sending whatever you have
    timeout: 200ms
    # Or send immediately once we hit 8192 items
    send_batch_size: 8192
    # Ensure a batch never exceeds this size (to prevent "packet too large" errors)
    send_batch_max_size: 11000
```

### Best Practice: Placement
**Critical Rule:** The `batch` processor should usually be the **last** processor in the pipeline (or right before the exporter).
*   *Why?* You want to modify, filter, and sample individual spans *before* you bundle them up. Once they are bundled, it's harder to inspect them individually.

---

# 3. The Resource Processor (`resource`)
**The Context Labeler (Infrastructure Identity)**

In OTel, a **Resource** represents the entity producing the telemetry (the "Who" and "Where"). Examples include `service.name`, `k8s.pod.name`, `cloud.region`, or `host.name`.

Sometimes, the SDK (auto-instrumentation) detects these automatically. Other times, the SDK running inside a container doesn't know it's in `env=production`. The Resource Processor allows the Collector to add, update, or delete these identity markers.

### Use Cases
1.  **Labeling Environments:** Tagging all data passing through this Collector as `deployment.environment: production`.
2.  **Cloud Identity:** Adding `cloud.zone: us-east-1a`.
3.  **Anonymization:** Removing internal IP addresses from the resource attributes.

### Configuration (`config.yaml`)

```yaml
processors:
  resource:
    attributes:
      - key: deployment.environment
        value: "production"
        action: insert # Only adds if it doesn't exist
      - key: service.name
        value: "checkout-service"
        action: upsert # Adds or overwrites existing value
      - key: internal.hostname
        action: delete # Removes this sensitive attribute
```

---

# 4. The Attributes Processor (`attributes`)
**The Data Janitor (Span/Metric Level)**

While the *Resource* Processor handles the "Who" (the entity), the *Attributes* Processor handles the "What" (the specific details inside a Span, Log, or Metric).

This is your primary tool for **Data Hygiene** and **PII (Personally Identifiable Information) Redaction**.

### Key Differences: Resource vs. Attributes Processor
*   **Resource Processor:** Modifies `resource.attributes` (Global to the app instance).
*   **Attributes Processor:** Modifies `span.attributes`, `log.attributes`, or `metric.attributes` (Specific to the request/event).

### Use Cases
1.  **PII Redaction:** A developer accidentally logged a user's email or password in a span attribute. You can mask it here.
2.  **Cost Reduction:** Dropping high-cardinality attributes (like a random UUID) that make your backend expensive.
3.  **Correction:** Renaming a key from `http.status_code` to `http.response.status_code` to match standards.

### Configuration (`config.yaml`)

```yaml
processors:
  attributes:
    actions:
      # 1. Redaction: Hash a user ID so we can correlate but not identify
      - key: user.id
        action: hash
      # 2. Security: Delete a password field entirely
      - key: db.password
        action: delete
      # 3. Standardization: Rename a key
      - key: old_key
        from_attribute: new_key
        action: insert
      # 4. Filter: Only apply changes to spans matching a specific library
    include:
      match_type: strict
      library: "my-custom-instrumentation"
```

---

# Summary: The "Golden" Pipeline Order

When you stitch these together in your `service` section, the order is critical for performance and correctness.

**Standard Recommendation:**
`Memory Limiter` -> `Sampling` (optional) -> `Resource/Attributes` -> `Batch`

```yaml
service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: 
        - memory_limiter  # 1. Protect the process first
        - resource        # 2. Tag the data (Identity)
        - attributes      # 3. Clean the data (Redaction/Filtering)
        - batch           # 4. Bundle it for transport
      exporters: [otlp/honeycomb]
```

### Why this order?
1.  **Memory Limiter:** If we are full, drop data immediately. Don't waste CPU adding attributes to data we are going to drop.
2.  **Resource/Attributes:** Now that the data is accepted, clean it up and tag it.
3.  **Batch:** Finally, pack the clean data into a box to ship it out efficiently.