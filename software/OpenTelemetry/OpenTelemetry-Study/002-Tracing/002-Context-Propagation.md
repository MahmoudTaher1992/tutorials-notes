Here is the detailed explanation of **Part II: Tracing (Distributed Tracing) — Section B: Context Propagation**.

If "Spans" are the bricks of distributed tracing, **Context Propagation** is the mortar. Without it, you do not have a distributed trace; you just have a collection of disconnected, standalone logs. This is arguably the most technical and critical concept to understand in OpenTelemetry.

---

## B. Context Propagation

### 1. The "Glue" of Distributed Tracing

In a monolithic application, passing data is easy: you pass variables through function arguments or use ThreadLocal storage. In a microservices architecture, services run on different servers, written in different languages, connected by a network.

*   **The Problem:** Service A calls Service B. Service B has no idea that Service A is already part of a trace. If Service B starts a new span, it will generate a brand new `TraceId`. The link is lost.
*   **The Solution:** Context Propagation. This is the process of bundling the active `TraceId` and `SpanId`, serializing them into string format, and stuffing them into the metadata of the network request (usually HTTP Headers) so the receiving service can "continue" the trace.

### 2. W3C Trace Context Standard (`traceparent`, `tracestate`)

For years, vendors used their own custom headers. If you sent a request from a Zipkin-instrumented service to a Datadog-instrumented service, they couldn't understand each other. The trace would break.

To solve this, the W3C (World Wide Web Consortium) created a standard that OTel adopts by default.

*   **`traceparent` Header:** This is the mandatory header that carries the core ID information.
    *   *Format:* `version-traceId-parentSpanId-traceFlags`
    *   *Example:* `00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01`
    *   *Breakdown:*
        *   `00`: Version (currently always 00).
        *   `4bf9...`: The Global **TraceId**.
        *   `00f0...`: The **SpanId** of the *caller* (this becomes the Parent ID of the receiver).
        *   `01`: **Sampled Flag**. (1 means "Record this trace", 0 means "Discard it"). This ensures that if the Frontend decides to sample a request, the Backend respects that decision.

*   **`tracestate` Header:** This is optional.
    *   *Purpose:* It allows different vendors (like Dynatrace, New Relic, or AWS X-Ray) to stash their own proprietary internal IDs alongside the standard trace without breaking the W3C standard.

### 3. B3 Propagation (Zipkin Legacy)

Before W3C Trace Context became the standard, the **B3** format (created for Zipkin) was the king of the industry.

*   **The Headers:** Instead of one single header string, B3 typically uses multiple headers:
    *   `X-B3-TraceId`
    *   `X-B3-SpanId`
    *   `X-B3-ParentSpanId`
    *   `X-B3-Sampled`
*   **Why you need to know this:** Many legacy systems (older Java Spring Boot apps, older service meshes) still speak B3.
*   **Composite Propagators:** OTel allows you to configure "Composite" propagation. You can tell the SDK: *"Check for W3C headers first. If not found, check for B3 headers. When sending data, inject BOTH to be safe."*

### 4. Baggage: Propagating Arbitrary Key-Value Pairs

While `traceparent` carries technical IDs, **Baggage** carries *business* context.

*   **The Concept:** Imagine you want to know the `CustomerId` or `TenantId` deep in your backend database service. That ID is available at the Frontend API, but the intermediate services don't need it and don't include it in their function arguments.
*   **How Baggage works:** You add a Key-Value pair to the "Baggage" in the Frontend. OTel automatically serializes this into the `baggage` header and propagates it to *every downstream service*.
*   **Example Header:** `baggage: userId=1234,subscription=premium`
*   **Caution:** Baggage is **not** free.
    1.  If you add 1KB of baggage, every network request between your microservices grows by 1KB.
    2.  Baggage is rarely indexed by default; you usually have to explicitly copy Baggage items into Span Attributes if you want to search by them.

### 5. Process Boundaries and Header Manipulation

Context Propagation relies on two distinct actions performed by the SDK:

*   **Inject (Client-Side):**
    *   Before an HTTP client (like `axios` or `HttpClient`) sends a request, the OTel SDK interrupts.
    *   It looks at the current Context in memory.
    *   It **Injects** the `traceparent` header into the outgoing HTTP headers.
*   **Extract (Server-Side):**
    *   When an HTTP server (like Express or Spring MVC) receives a request, the OTel SDK interrupts before your controller code runs.
    *   It looks at the incoming HTTP headers.
    *   It **Extracts** the `traceparent` header.
    *   It creates a new Context in memory using those IDs, ensuring the new span created by the server becomes the **Child** of the span sent by the client.

**The "Broken Trace" Risk:** If you use a proxy (like Nginx or HAProxy) or a message queue that is configured to "scrub" (remove) unknown headers for security reasons, it will delete `traceparent`. The trace will break, and you will see two separate traces instead of one connected graph.