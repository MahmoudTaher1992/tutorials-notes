# OpenTelemetry Architecture
Here is the detailed explanation of **Part I: Observability Fundamentals & Core Principles — Section B: The OpenTelemetry Architecture**.

Now that we understand the goal (Observability), we need to look at the engine. The architecture of OpenTelemetry is designed to be modular and loosely coupled. This section explains the components that live *inside* your application code.

---

## B. The OpenTelemetry Architecture

### 1. API vs. SDK: The Separation of Concerns

This is the single most important architectural decision in OpenTelemetry. OTel splits the "What" from the "How."

*   **The API (The Interface):**
    *   *Role:* This is what developers and library authors interact with. It contains the classes and interfaces to create Spans and Metrics (e.g., `tracer.startSpan()`).
    *   *Nature:* It is purely abstract and extremely lightweight. It has **no dependencies** on how data is processed or sent.
    *   *The "No-Op" Behavior:* If you use the API but do not install the SDK, the API effectively does nothing (No-Operation). It creates "dummy" objects that immediately vanish.
    *   *Why this matters:* It allows library maintainers (like the authors of an HTTP client or a Database driver) to add OTel instrumentation to their libraries without forcing the end-user to use a specific backend or configuration.

*   **The SDK (The Implementation):**
    *   *Role:* This is the engine that the application owner installs. It implements the API.
    *   *Nature:* It handles the heavy lifting: sampling (should we record this trace?), processing (adding attributes), and exporting (sending data to a server).
    *   *Configuration:* You configure the SDK to tell it where to send data (e.g., "Send traces to Jaeger").

**Analogy:** The **API** is like the electrical outlets in your house (standard interface). The **SDK** is the wiring behind the walls and the power plant connection (implementation). You plug your toaster (code) into the outlet (API), but it only works if the house is wired up (SDK).

### 2. The OTel Protocol (OTLP)

Before OTel, every vendor had their own language. Jaeger spoke "Thrift," Zipkin spoke JSON V2, Prometheus spoke a specific text format.

*   **OTLP (OpenTelemetry Protocol):** This is a new, vendor-agnostic protocol designed specifically for telemetry data. It is efficient, strongly typed, and capable of transmitting Traces, Metrics, and Logs in a single stream.
*   **Transports:** OTLP usually runs over two transports:
    *   **gRPC (default):** Uses Protocol Buffers (binary). It is faster, smaller, and supports multiplexing. Used for high-throughput internal traffic.
    *   **HTTP/JSON:** Uses standard HTTP POST requests. Easier to debug and friendlier to corporate firewalls/proxies that might block gRPC.

### 3. The Data Pipeline (Provider, Propagator, Exporters)

When data moves through the SDK inside your application, it passes through specific components:

*   **The Provider (`TracerProvider` / `MeterProvider`):**
    *   This is the factory and the entry point. It holds the configuration. When you ask for a `Tracer`, the Provider gives it to you based on how the SDK was set up.
*   **TextMapPropagator (Context Propagation):**
    *   This component is responsible for "Injecting" and "Extracting" context.
    *   When Service A calls Service B, the Propagator takes the `TraceId` from the current memory context and injects it into the HTTP Headers (or message queue metadata).
    *   It ensures the trace isn't broken when the request leaves the process.
*   **Processors:**
    *   Before data leaves the app, it hits Processors. They can batch data (for performance) or modify it (adding attributes).
*   **Exporters:**
    *   This is the exit door. The Exporter translates OTel's internal data format into the language of the destination.
    *   *Examples:* `OTLPExporter` (sends OTLP), `ConsoleExporter` (prints to stdout for debugging), `ZipkinExporter` (converts to Zipkin format).

### 4. Semantic Conventions (Standardizing Naming Schemes)

Naming things is hard. If Developer A calls a database name `db.name` and Developer B calls it `database_id`, you cannot query your data effectively.

*   **The Solution:** OpenTelemetry defines **Semantic Conventions**. This is a strict dictionary of attribute names that everyone agrees to use.
*   **Examples:**
    *   HTTP requests must use: `http.method`, `http.status_code`, `http.url`.
    *   Database calls must use: `db.system` (e.g., "mysql"), `db.statement` (the SQL query).
    *   Kubernetes data must use: `k8s.pod.name`, `k8s.namespace.name`.
*   **Benefit:** Because the names are standardized, backend tools (like Datadog or Grafana) can automatically generate dashboards for you because they know exactly what `http.status_code` means.

### 5. Resource Detection (Identifying the Source Environment)

A trace tells you *what* happened. A Resource tells you *where* it happened.

*   **Resource Attributes:** These are attributes that are **immutable** (do not change) for the lifetime of the process. They describe the entity producing the telemetry.
*   **Detectors:** The OTel SDK includes "Resource Detectors" that run automatically at startup. They scan the environment and populate the Resource.
    *   *If running in AWS:* It detects Region, EC2 Instance ID.
    *   *If running in Kubernetes:* It detects Pod Name, Namespace, Node Name.
    *   *If running locally:* It detects Hostname, OS version.
*   **Why it matters:** When you look at a metric (e.g., High CPU), the Resource attributes allow you to filter it down: "Show me CPU usage *only* for `service.name=cart-service` running in `k8s.cluster=production-us-east`."