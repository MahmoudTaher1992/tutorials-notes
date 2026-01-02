Hello! I am your **Computer Science & DevOps Instructor**. My role today is to guide you through the "Inner Loop" of software instrumentation—specifically, how to test and visualize your data on your own machine before sending it out to the "real world" servers.

Think of **Local Development** like working on a **Science Fair project in your garage**.
*   In the "Real World" (Production), you have massive power grids and huge monitoring stations.
*   In your "Garage" (Localhost), you don't have space for that equipment. You need small, handheld tools to check if your wires are connected correctly before you move the project to the big exhibition hall.

Here is the structured summary of your material:

*   **1. The "Inner Loop" Concept** (The immediate feedback cycle while coding)
    *   **The Challenge** (Why we can't just use production tools)
        *   **Resource Intensity** (Production backends like Datadog or massive Grafana clusters are too heavy to run on a developer laptop)
        *   **The Risk of "Flying Blind"** (Coding without seeing traces leads to "It works on my machine" bugs)
    *   **The Solution** (Lightweight Observability)
        *   Use **All-in-one tools** (Single Docker containers that accept telemetry data)
        *   Utilize **OTLP** (The standard OpenTelemetry Protocol to send data)

*   **2. The Reference: OpenTelemetry Demo App** (The "Astronomy Shop")
    *   **What is it?** (A microservices-based e-commerce store provided by the community)
        *   **Polyglot Instrumentation** (Demonstrates how services written in different languages talk to each other)
            *   **Java** (Ad Service)
            *   **Go** (Frontend)
            *   **Python** (Recommendation Service)
            *   **Node.js** (Payment Service)
    *   **How to study it** (Don't just run it, inspect it)
        *   **Docker Compose** (Look at how `OTEL_EXPORTER_...` environment variables are passed)
        *   **Source Code** (Look at how the SDKs are initialized in code)

*   **3. The Visualization Tools** (Where you see your data locally)
    *   **Option A: Jaeger** (The classic "All-in-One")
        *   **Function** (A single Docker image containing Collector, DB, and UI)
        *   **Limitations** (Visualizes **Traces Only**; does not support Metrics or Logs)
        *   **Key Ports**
            *   **16686** (The UI you open in the browser)
    *   **Option B: Aspire Dashboard** (The recommended modern choice)
        *   **Origin** (Extracted from .NET Aspire, now standalone)
        *   **Advantages** (Visualizes **Traces, Metrics, AND Logs** in one fast UI)
        *   **Key Ports**
            *   **18888** (The Dashboard UI)

*   **4. Configuration Workflow** (Connecting your code to the tools)
    *   **Environment Variables** (The standard way to configure OTel)
        *   **Service Name** (`export OTEL_SERVICE_NAME=my-local-service`)
        *   **The Endpoint** (`export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317`)
            *   (Points to your local Docker container)
        *   **The Protocol** (`export OTEL_EXPORTER_OTLP_PROTOCOL=grpc`)
    *   **Debugging Mode** (The "Console Exporter")
        *   **Usage** (Prints Span JSON directly to the terminal)
        *   **Purpose** (Quickly verifying "Is my instrumentation actually running?" without starting Docker)
    *   **Docker Compose Setup** (The robust workflow)
        *   Define services in `compose-o11y-local.yaml`
        *   Spin up **Jaeger** or **Aspire** alongside an optional **OTel Collector**

*   **5. Local Development Checklist** (Rules of thumb)
    *   **Endpoint Safety** (Ensure you are **not** sending test data to production backends)
    *   **Span Processor Selection**
        *   Use **`SimpleSpanProcessor`** locally (Sends data instantly so you see it immediately)
        *   Avoid `BatchSpanProcessor` locally (It buffers data for performance, which causes delays in seeing traces)
    *   **Port Memorization** (The universal OTLP ports)
        *   **4317** (gRPC - Efficient)
        *   **4318** (HTTP - Easier to debug)
