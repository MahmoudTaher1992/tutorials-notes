I am your **Computer Science Teacher** specializing in Software Observability and Engineering.

Here is the summary of the material on Manual Instrumentation, structured as a tree for clarity.

### **Manual Instrumentation: Deep Dive**

*   **1. What is Manual Instrumentation?**
    *   **Definition**: The act of writing specific code to call the OpenTelemetry API directly within your application functions.
    *   **Comparison**:
        *   **Auto-Instrumentation**: Captures generic "black box" events [e.g., "HTTP Request Received" or "DB Query Sent"].
        *   **Manual Instrumentation**: Captures **Business Logic** [e.g., "How long did the Tax Calculation algorithm take?" or "Why did the Inventory Check fail?"].
    *   **Analogy**: If Auto-instrumentation is a security camera showing someone entering a building, Manual instrumentation is a diary entry explaining *why* they went in and exactly *what* they did in every room.

*   **2. The Four Key Components**
    *   **A. Getting the Handles (Tracer & Meter)**
        *   **Concept**: You cannot create data without a "factory" provided by the global system.
        *   **Instrumentation Scope**:
            *   You must provide a **Name** and **Version** when asking for a handle.
            *   **Why?**: It attaches metadata to the data, allowing you to disable or filter specific noisy libraries later without turning off the whole system.
        *   **The Factories**:
            *   **Tracer**: Creates Spans [tracks time/operations].
            *   **Meter**: Creates Metrics [tracks counts/numbers].

    *   **B. Creating Custom Spans**
        *   **Purpose**: To break down a large operation into smaller, measurable chunks.
        *   **The "Current Context"**:
            *   New manual spans should attach to the existing trace.
            *   **Nesting**: The manual span becomes a **child** of the auto-generated parent span.
            *   **Implementation**: Uses "Context Managers" [like `with` blocks or `try/finally`] to automatically start the timer, run the code, and stop the timer.

    *   **C. Adding Business Attributes** [The most powerful feature]
        *   **Definition**: Key-Value pairs attached to a Span to provide context.
        *   **What to Attach**:
            *   **High Cardinality IDs**: Unique identifiers [`user.id`, `order.id`].
            *   **Business Segments**: Categories [`user.tier`, `region`].
            *   **Flags**: Configuration states [`feature_flag.enabled`].
        *   **Semantic Conventions**:
            *   **Rule**: Use the OpenTelemetry standard dictionary for names.
            *   **Example**: Use `server.address` instead of `db.host`.
            *   **Reasoning**: Visualization tools automatically recognize and graph standard keys.
        *   **Error Handling**:
            *   You must manually catch exceptions.
            *   **Action**: Record the exception object and set the Span Status to **ERROR**.

    *   **D. Advanced Customization** [Done at initialization, not in business logic]
        *   **Custom Propagators**:
            *   **Goal**: Moving the Trace ID from Service A to Service B.
            *   **When to use**: If you use a non-standard protocol [not HTTP] or custom headers.
        *   **Custom Samplers**:
            *   **Goal**: Deciding which traces to keep (sample) and which to drop.
            *   **When to use**: When you want logic-based sampling rules [e.g., Keep 100% of "Premium User" traces, but only 1% of "Free User" traces].

*   **3. The Workflow Summary**
    *   **Init**: Configure the SDK at app startup.
    *   **Import**: Bring in the OTel API.
    *   **Get Tracer**: Instantiate your factory with a scope name.
    *   **Wrap Logic**: Surround critical code with `start_span`.
    *   **Enrich**: Add Attributes (Data) and Events (Logs).
    *   **Handle Errors**: Catch crashes and update Span Status.
