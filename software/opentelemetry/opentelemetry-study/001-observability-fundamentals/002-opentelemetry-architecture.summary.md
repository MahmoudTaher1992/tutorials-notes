**Role:** I am your **Computer Science Teacher**, specializing in Software Architecture and Observability.

Here is the summary of the OpenTelemetry Architecture, structured as a deep tree for your study notes.

*   **Core Design Philosophy**
    *   **Separation of Concerns** (The architecture splits the "What" from the "How" to keep things modular)
        *   **The API** (The Interface)
            *   *Who uses it*: **Developers and Library Authors** (e.g., the person writing an HTTP client library)
            *   *Function*: Contains classes/interfaces to create telemetry (e.g., `tracer.startSpan()`)
            *   *Characteristics*:
                *   **Purely Abstract** (It is lightweight and has zero dependencies on how data is actually processed)
                *   **"No-Op" Behavior** (If the SDK is not installed, the API creates "dummy" objects that vanish immediately, ensuring the code doesn't crash)
        *   **The SDK** (The Implementation)
            *   *Who uses it*: **Application Owners** (The person deploying the app)
            *   *Function*: The engine that implements the API
            *   *Characteristics*:
                *   Handles the **Heavy Lifting** (Sampling decisions, processing data, and exporting to servers)
                *   Holds the **Configuration** (Tells the app where to send the data, like Jaeger or Datadog)
        *   *Analogy*: **Video Game Controller vs. Console**
            *   The **API** is like the **Controller** (The buttons and interface you interact with; it's standard regardless of the game).
            *   The **SDK** is the **Console Hardware** (The internal chips and processor that actually render the graphics and make the game work).

*   **Communication Protocol: OTLP** (OpenTelemetry Protocol)
    *   *Purpose*: A **Vendor-Agnostic** language for data (Replaces the need to speak specific languages like Thrift or JSON V2)
    *   *Capabilities*:
        *   **Efficient and Strongly Typed**
        *   **Unified Stream** (Transmits Traces, Metrics, and Logs together)
    *   *Transports* (The delivery method)
        *   **gRPC** (Default)
            *   Uses **Protocol Buffers** (Binary format)
            *   Benefit: **High Performance** (Faster, smaller size, supports multiplexing)
        *   **HTTP/JSON**
            *   Uses **Standard POST Requests**
            *   Benefit: **Firewall Friendly** (Easier to debug and rarely blocked by corporate proxies)

*   **The Data Pipeline** (How data moves inside the application)
    *   **The Provider** (The Factory)
        *   *Role*: The **Entry Point** (Holds configuration and generates Tracers/Meters based on SDK settings)
    *   **TextMapPropagator** (Context Propagation)
        *   *Role*: **The Connector** (Ensures traces aren't broken between services)
        *   *Action*:
            *   **Injects** context (Takes the `TraceId` from memory and puts it into HTTP Headers)
            *   **Extracts** context (Reads headers when receiving a request)
    *   **Processors** (The Modifiers)
        *   *Role*: Intermediary step before data leaves
        *   *Action*: **Batches data** (For performance) or adds/modifies attributes
    *   **Exporters** (The Exit Door)
        *   *Role*: **Translators** (Converts OTel internal data into the specific format required by the backend tool)
        *   *Examples*: `OTLPExporter` (Standard), `ConsoleExporter` (Debug print), `ZipkinExporter` (Conversion)

*   **Standardization Standards**
    *   **Semantic Conventions** (The Naming Dictionary)
        *   *Problem*: Random naming (e.g., `db.name` vs `database_id`) makes querying impossible
        *   *Solution*: A **Strict Dictionary** of agreed-upon attribute names
        *   *Examples*:
            *   HTTP: `http.method`, `http.status_code`
            *   Database: `db.system` (e.g., "mysql"), `db.statement`
        *   *Benefit*: **Automation** (Backend tools can auto-generate dashboards because they know exactly what `http.status_code` means)
    *   **Resource Detection** (The "Where")
        *   *Concept*: A Trace tells you *what* happened; a Resource tells you **where** it happened
        *   *Attributes*: **Immutable tags** describing the entity (Service Name, Region, OS Version)
        *   *Detectors*: **Auto-Scanners** that run at startup
            *   *Cloud*: Detects Region, Instance IDs
            *   *Kubernetes*: Detects Pod Name, Namespace
        *   *Benefit*: Allows for **Precise Filtering** (e.g., "Show me errors only from the `production-us-east` cluster")
