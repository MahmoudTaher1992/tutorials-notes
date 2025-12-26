Here is a detailed explanation of **Part XIV, Section A: Local Development** from your OpenTelemetry study plan.

This section focuses on the **"Inner Loop"** of development: how you, as a developer, can write code, instrument it, and immediately visualize the telemetry data on your machine without deploying to a cloud environment.

---

# 014-Workflow / 001-Local-Development.md

## 1. The Challenge of Local Observability

In a production environment, you send telemetry to robust, heavy backends like Datadog, New Relic, or a massive Grafana/Prometheus/Loki cluster. Running that entire stack on a developer laptop is resource-intensive and overkill.

However, developing "blind" (without seeing traces) leads to "it works on my machine" bugs. To solve this, we use lightweight, all-in-one tools that accept OTLP (OpenTelemetry Protocol) data and provide a UI for immediate feedback.

---

## 2. The OpenTelemetry Demo Application (Webstore)

Before you instrument your own code, the OTel community provides a reference implementation known as the **Astronomy Shop**.

### What is it?
It is a microservices-based e-commerce web store. It is crucial for local development study because it demonstrates **Polyglot Instrumentation**. It contains services written in:
*   **Java** (Ad Service)
*   **Go** (Frontend, Checkout)
*   **Python** (Recommendation Service)
*   **JavaScript/Node** (Payment Service)
*   **.NET**, **Rust**, **PHP**, etc.

### How to use it locally?
The demo relies heavily on **Docker Compose**.
1.  **Clone the repo:** `git clone https://github.com/open-telemetry/opentelemetry-demo`
2.  **Run it:** `docker compose up --no-build`
3.  **Explore:**
    *   **Webstore UI:** `http://localhost:8080`
    *   **Grafana:** `http://localhost:8080/grafana`
    *   **Jaeger (Traces):** `http://localhost:8080/jaeger/ui/`

**Study Goal:** Do not just run it. Look at the `docker-compose.yml` to see how environment variables (like `OTEL_EXPORTER_OTLP_ENDPOINT`) are passed to the containers, and look at the source code to see how the SDKs are initialized.

---

## 3. Viewing Traces Locally: The Tools

When developing your own application, you need a lightweight backend to visualize your traces. Here are the two industry standards for local dev:

### Option A: Jaeger "All-in-One"
Jaeger is the classic distributed tracing system. For local dev, they provide a single Docker image that contains the Collector, the Database (in-memory), and the UI.

*   **Pros:** Industry standard, very lightweight.
*   **Cons:** Visualizes **Traces only**. Does not handle Metrics or Logs well.

**How to run it:**
```bash
docker run -d --name jaeger \
  -e COLLECTOR_ZIPKIN_HOST_PORT=:9411 \
  -p 5775:5775/udp \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 14268:14268 \
  -p 14250:14250 \
  -p 4317:4317 \
  -p 4318:4318 \
  jaegertracing/all-in-one:latest
```
*   **Port 4317:** Your app sends OTLP gRPC data here.
*   **Port 4318:** Your app sends OTLP HTTP data here.
*   **Port 16686:** You open this in your browser to see the traces.

### Option B: The Aspire Dashboard (Recommended for 2025)
Originally part of .NET Aspire, the **Aspire Dashboard** was extracted as a standalone tool. It is rapidly becoming the favorite for local OTel development because it visualizes **Traces, Metrics, AND Logs** in a beautiful, modern UI.

*   **Pros:** Supports all three signals (Logs/Metrics/Traces), modern UI, very fast.
*   **Cons:** Newer, slightly larger image than Jaeger.

**How to run it:**
```bash
docker run --rm -it -p 18888:18888 -p 4317:18889 -p 4318:18890 \
  mcr.microsoft.com/dotnet/nightly/aspire-dashboard:8.0.0-preview.4
```
*   **Port 4317/4318:** Standard OTLP ingestion.
*   **Port 18888:** The Dashboard UI.

---

## 4. Configuring Your Local App (The Workflow)

To make "Local Development" work, you must configure your application (SDK) to talk to the local Docker container (Jaeger or Aspire).

### Step 1: Environment Variables
You should not hardcode configuration in your code. Use the standard OTel Environment Variables.

If running your app directly on your host machine (not in Docker), but your Jaeger/Aspire is in Docker:

```bash
# Linux/Mac
export OTEL_SERVICE_NAME=my-local-service
export OTEL_TRACES_EXPORTER=otlp
export OTEL_METRICS_EXPORTER=otlp
export OTEL_LOGS_EXPORTER=otlp

# Protocol: gRPC is efficient, HTTP is easier to debug
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc 

# Endpoint: Point to localhost because you are running the app on the host
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
```

### Step 2: The "Console Exporter" (Quick Debugging)
Sometimes you don't even want to spin up Docker. You just want to see if spans are being created. You can use the Console Exporter.

**Node.js Example:**
```javascript
const { ConsoleSpanExporter } = require('@opentelemetry/sdk-trace-base');
// ...
provider.addSpanProcessor(new SimpleSpanProcessor(new ConsoleSpanExporter()));
```
This prints the JSON structure of the Span directly to your terminal. It is messy for complex traces but perfect for verifying "Is my instrumentation actually running?"

---

## 5. Practical Example: `docker-compose.yaml` for Local Dev

The most robust workflow is to define your "Observability Stack" in a compose file that you spin up alongside your app.

**File:** `compose-o11y-local.yaml`
```yaml
version: "3"
services:
  # The Visualization Tool
  jaeger:
    image: jaegertracing/all-in-one:latest
    ports:
      - "16686:16686" # UI
      - "4317:4317"   # OTLP gRPC Receiver
      - "4318:4318"   # OTLP HTTP Receiver
    environment:
      - COLLECTOR_OTLP_ENABLED=true

  # (Optional) A local Collector to simulate production pipelines
  otel-collector:
    image: otel/opentelemetry-collector-contrib:latest
    command: ["--config=/etc/otel-collector-config.yaml"]
    volumes:
      - ./otel-config.yaml:/etc/otel-collector-config.yaml
    ports:
      - "1888:1888"   # pprof extension
      - "8888:8888"   # Prometheus metrics exposed by the collector
      - "13133:13133" # health_check extension
    depends_on:
      - jaeger
```

**Workflow:**
1.  Run `docker compose -f compose-o11y-local.yaml up -d`
2.  Start your application in your IDE/Terminal with `OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317`.
3.  Perform an action in your app (e.g., refresh a page).
4.  Open `http://localhost:16686` (Jaeger) to see the trace immediately.

---

## Summary Checklist for Local Development

1.  **Do not use production endpoints:** Ensure you aren't sending test data to your production DataDog/Honeycomb account (unless using a specific dev API key).
2.  **Use `SimpleSpanProcessor`:** In production, we use `BatchSpanProcessor` for performance. Locally, we often use `SimpleSpanProcessor` so spans appear instantly in the UI without waiting for a buffer to fill.
3.  **Standardize Ports:** Memorize **4317** (gRPC) and **4318** (HTTP).
4.  **Visualize:** Use **Jaeger** (for pure tracing) or **Aspire Dashboard** (for a complete view).