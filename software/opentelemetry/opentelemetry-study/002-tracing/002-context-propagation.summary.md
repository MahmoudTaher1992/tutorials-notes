Hello! **I am your Computer Science Teacher specializing in Distributed Systems and Cloud Architecture.** My job is to explain how complex software systems talk to each other without getting confused.

Here is the summary of the material on Context Propagation, structured as a deep tree for clarity.

---

### **Topic: Context Propagation in Distributed Tracing**

*   **1. The Core Concept: The "Glue"**
    *   **Definition**
        *   **Context Propagation** is the mechanism that connects Spans together across different services.
        *   [Think of it like a **Detective Case File**. If Detective A hands a task to Detective B, they must attach the "Case Number" to the request. If they don't, Detective B will open a brand new, unrelated case file, and the investigation (the Trace) will be split in two.]
    *   **The Problem**
        *   In **Monoliths** (single app), passing data is easy [variables passed in memory].
        *   In **Microservices**, services run on different servers/languages [Service A doesn't share memory with Service B].
        *   Without propagation, Service B generates a new `TraceId` [The link is lost].
    *   **The Solution**
        *   **Serialization**: Bundle the active `TraceId` and `SpanId`.
        *   **Transport**: Stuff them into network metadata [usually HTTP Headers].

*   **2. Standards for Propagation**
    *   **W3C Trace Context** (The Modern Standard)
        *   **`traceparent` Header** [Mandatory: carries core IDs]
            *   **Format**: `version-traceId-parentSpanId-traceFlags`
            *   **Breakdown**:
                *   **Version**: Currently `00`.
                *   **TraceId**: The Global ID [Uniquely identifies the entire transaction].
                *   **ParentSpanId**: The ID of the *caller* [Becomes the Parent ID for the receiver].
                *   **Sampled Flag**: `01` or `00` [Tells the backend: "Please record this" or "Ignore this"].
        *   **`tracestate` Header** [Optional]
            *   Purpose: Allows vendors (like AWS or Dynatrace) to keep their own internal IDs [ensures the trace doesn't break even if different monitoring tools are used].
    *   **B3 Propagation** (The Legacy Standard)
        *   **Origin**: Created for **Zipkin**.
        *   **Structure**: Uses multiple headers instead of one.
            *   `X-B3-TraceId`
            *   `X-B3-SpanId`
            *   `X-B3-Sampled`
        *   **Usage Strategy**:
            *   Still common in older Java/Spring Boot apps.
            *   **Composite Propagators**: OTel can check for W3C first, then B3, and inject *both* to be safe.

*   **3. Baggage: Moving Business Data**
    *   **Purpose**
        *   Carries **Business Context** [e.g., `CustomerId`, `TenantId`] rather than just technical Trace IDs.
    *   **Mechanism**
        *   Added at the source (Frontend).
        *   Automatically serialized into the `baggage` header.
        *   Propagates to **every** downstream service [even deep in the backend database layers].
    *   **Costs & Risks**
        *   **Network Overhead**: Adds size to every request [1KB of baggage = 1KB extra data on every single network call].
        *   **Not Indexed**: Baggage is for transport, not searching. You must copy baggage items into **Span Attributes** to search for them later.

*   **4. The Mechanism: How it works technically**
    *   **Inject (Client-Side Action)**
        *   Happens *before* the request leaves.
        *   OTel SDK interrupts the HTTP Client.
        *   **Action**: Takes context from memory → Puts it into HTTP Headers.
    *   **Extract (Server-Side Action)**
        *   Happens *when* the request arrives.
        *   OTel SDK interrupts the HTTP Server.
        *   **Action**: Reads HTTP Headers → Creates new Context in memory.
        *   **Result**: The new Span becomes a **Child** of the incoming Span.
    *   **The "Broken Trace" Risk**
        *   If a Proxy (like Nginx) scrubs/deletes unknown headers for security:
            *   The `traceparent` is lost.
            *   The trace breaks into two disconnected pieces.
