Based on the Table of Contents provided, specifically **Part XIV: Development Workflow / A. Local Development**, here is a detailed explanation of what that section entails.

---

# Detailed Explanation: 014-Development-Workflow / 001-Local-Development

This section focuses on **"The Inner Loop"**—how developers integrate distributed tracing into their day-to-day coding process before deploying to a shared environment like Staging or Production.

The goal of this phase is to allow a developer to see traces immediately after writing code, helping them debug logic errors, latency issues, or database N+1 problems directly on their laptop.

Here are the specific concepts and technical details covered in this section:

## 1. The "All-in-One" Architecture
In a production environment, Jaeger is split into multiple microservices (Agent, Collector, Query, Ingester). However, running that complexity on a laptop is unnecessary and heavy.

For local development, Jaeger provides the **All-in-One** distribution.
*   **What it is:** A single executable binary (or Docker image) that contains *all* Jaeger backend components.
*   **Storage:** It uses **In-Memory** storage by default. This means it is very fast, but if you restart the container/binary, all trace data is lost (which is acceptable for local debugging).
*   **UI:** It bundles the UI, usually accessible at `http://localhost:16686`.

## 2. Running Jaeger Locally (Docker & Docker Compose)
The standard way to run Jaeger locally is via Docker. This section typically explains the command line arguments and port mappings required.

### A. The Docker Command
A typical command to start Jaeger looks like this:
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

### B. Understanding the Ports
For local development to work, you must understand which port your application should send data to:
*   **16686 (HTTP):** The Jaeger UI (open this in your browser).
*   **4317 (gRPC) & 4318 (HTTP):** The **OpenTelemetry (OTLP)** receivers. This is the modern standard. Your application (instrumented with OTel) will send data here.
*   **14268 (HTTP):** Direct write to Collector (Legacy Jaeger format).
*   **6831/6832 (UDP):** The legacy Jaeger Agent ports.

### C. Docker Compose Integration
Most developers use `docker-compose` to run their App + DB + Redis. This section explains adding Jaeger to that stack so your app can talk to it via the internal Docker network.

```yaml
version: '3'
services:
  my-app:
    build: .
    environment:
      - OTEL_EXPORTER_OTLP_ENDPOINT=http://jaeger:4317
  jaeger:
    image: jaegertracing/all-in-one:latest
    ports:
      - "16686:16686"
```

## 3. Configuring the Application (Instrumentation)
Once Jaeger is running, the application code on your local machine need to be told where to send the traces.

*   **Endpoint Configuration:** Pointing the OpenTelemetry SDK to `localhost` (if running binary) or the container name (if running inside Docker Compose).
*   **Sampling for Dev:** This is crucial. In production, you might sample 0.1% of requests. In local development, you want **100% Sampling** (`sampler.type=const`, `sampler.param=1`). You want to see *every* request you make while testing.
*   **Environment Variables:** Using standard OTel env vars for setup:
    *   `OTEL_SERVICE_NAME=my-local-service`
    *   `OTEL_TRACES_EXPORTER=otlp`

## 4. The Developer Workflow Loop
This describes the actual process a developer follows:
1.  **Code:** Modify a function (e.g., change a SQL query).
2.  **Run:** Start the app and the Jaeger container.
3.  **Trigger:** Hit the API endpoint via Postman, cURL, or the browser.
4.  **Verify:** Immediately switch to `localhost:16686`, find the trace, and verify:
    *   Did the SQL query execute as expected?
    *   Are the tags correct?
    *   Did the error propagate correctly?

## 5. Common "Local" Gotchas
This section covers troubleshooting specific to local dev:
*   **Networking issues:** Trying to reach `localhost` from inside a container (needs `host.docker.internal` on Mac/Windows).
*   **Clock Skew:** If running microservices locally in different VMs/Containers, slight time differences can make the trace timeline look broken (child spans appearing before parent spans).
*   **UDP Packet Size:** If using older UDP agents locally, large traces might be dropped (MTU limits).

## Summary
In essence, **001-Local-Development.md** teaches you how to spin up a "mini-production" observability stack on your laptop instantly so that you don't have to wait until deployment to realize your traces are missing or your performance is poor.
