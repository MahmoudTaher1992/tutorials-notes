Based on **Part V, Section B** of your Table of Contents, here is a detailed explanation of **Manual Instrumentation**.

---

# 005-Instrumentation / 002-Manual-Instrumentation

## What is Manual Instrumentation?

While **Auto-Instrumentation** (Zero-code) effectively captures generic operations (like "HTTP Request received" or "Database Query executed"), it fails to capture **Business Logic**.

Manual Instrumentation is the act of writing code to invoke the OpenTelemetry API directly within your application. You do this to answer questions like:
*   *How long did the "Calculate Tax" algorithm take?*
*   *Which user ID was being processed when this error occurred?*
*   *Why did the specific "Inventory Check" step fail?*

Here is the breakdown of the four key components defined in your Table of Contents.

---

### 1. Getting the `Tracer` and `Meter`

To manually create telemetry, you cannot simply instantiate a Span or a Metric. You must acquire a "handle" from the global providers.

#### The Concept of "Instrumentation Scope"
When you request a Tracer or Meter, you must provide a name (usually the package or library name) and a version. This is critical because OTel attaches this metadata to every piece of data produced. It allows you to disable specific noisy libraries later without turning off the whole system.

#### A. Getting a Tracer
The **Tracer** is the factory for creating Spans.
*   **Code Pattern (Python Example):**
    ```python
    from opentelemetry import trace

    # The name string identifies the library/module instrumenting the code
    tracer = trace.get_tracer("my.payment.service", "1.0.0")
    ```

#### B. Getting a Meter
The **Meter** is the factory for creating Metric Instruments (Counters, Histograms).
*   **Code Pattern:**
    ```python
    from opentelemetry import metrics

    meter = metrics.get_meter("my.payment.service", "1.0.0")
    ```

---

### 2. Creating Custom Spans to Measure Specific Logic

Auto-instrumentation might show you that a specific HTTP route is slow, but a **Custom Span** tells you *which part* of that route is slow.

#### The "Current Context" (Nested Spans)
OTel relies on **Context**. If a span is already active (e.g., created by auto-instrumentation when the request hit the server), your manual span should become a **child** of that span.

Most languages use a "Context Manager" or "Try/Finally" block to handle this automatically.

*   **Scenario:** You want to measure a function that encrypts data.
*   **Implementation:**
    ```python
    def encrypt_payload(data):
        # start_as_current_span automatically links to the parent trace
        with tracer.start_as_current_span("encrypt_data") as span:
            # logic here
            return _do_encryption(data)
            # Span automatically ends when the block exits
    ```

This creates a trace structure like this:
```text
[HTTP GET /checkout (Auto-Instr)] ----------------------------------------->
      |
      +--- [encrypt_data (Manual-Instr)] ----->
```

---

### 3. Adding Business-Specific Attributes

This is the most powerful aspect of manual instrumentation. Attributes are Key-Value pairs attached to a Span. They allow you to slice and dice your data in your backend (e.g., Honeycomb, Jaeger, Datadog).

#### What to Attribute?
*   **High Cardinality IDs:** `user.id`, `transaction.id`, `cart.id`.
*   **Business Segments:** `customer.tier` (Gold/Silver), `region`.
*   **Configuration:** `feature_flag.enabled`.

#### Implementation
```python
with tracer.start_as_current_span("process_order") as span:
    # Set attributes immediately
    span.set_attribute("order.id", "998877")
    span.set_attribute("user.tier", "premium")
    
    try:
        process(order)
        span.set_status(Status(StatusCode.OK))
    except Exception as e:
        # Record the error structurally
        span.record_exception(e)
        span.set_status(Status(StatusCode.ERROR, "Processing failed"))
```

#### Semantic Conventions
OpenTelemetry provides a dictionary of standard attribute names.
*   Don't use `db.host`; use `db.system` or `server.address`.
*   Don't use `http.url`; use `url.full`.
*   *Why?* Because backends know how to visualize these specific keys automatically.

---

### 4. Writing Custom Propagators or Samplers

These are advanced manual instrumentation tasks, usually done during the initialization of the SDK, not inside business logic.

#### A. Custom Propagators
**Context Propagation** is how the `TraceId` moves from Service A to Service B (usually via HTTP Headers like `traceparent`).
*   **Standard:** OTel uses W3C TraceContext by default.
*   **Manual Scenario:** Your company uses a legacy proprietary protocol over raw TCP, or you need to read a custom header like `X-Correlation-ID`.
*   **Implementation:** You would implement the `TextMapPropagator` interface. You must define an `inject` method (putting ID into the message) and an `extract` method (pulling ID out of the message).

#### B. Custom Samplers
**Sampling** decides whether a trace is recorded or dropped to save costs.
*   **Standard:** `ParentBasedAlwaysOn` (If parent exists, do what parent did; otherwise record).
*   **Manual Scenario:** You want to sample 100% of "Premium" users but only 1% of "Free" users.
*   **Implementation:** You write a class implementing the `Sampler` interface.
    1.  The `should_sample` method receives the `attributes`.
    2.  You check `attributes.get("user.tier")`.
    3.  Return `SamplingResult.RECORD_AND_SAMPLE` or `SamplingResult.DROP`.

---

### Summary Workflow of Manual Instrumentation

1.  **Init:** At app startup, configure the SDK (TracerProvider/MeterProvider).
2.  **Import:** In your business file, import the OTel **API**.
3.  **Get Tracer:** `tracer = trace.get_tracer(__name__)`.
4.  **Wrap Logic:** Surround critical code blocks with `start_span`.
5.  **Enrich:** Add Attributes (`user.id`) and Events ("cache miss").
6.  **Handle Errors:** Catch exceptions, record them to the span, and set Span Status to Error.