Here is a detailed breakdown of **Part XIV, Section B: Debugging OTel**, structured as a study guide entry for the file path `software/OpenTelemetry/OpenTelemetry-Study/014-Workflow/002-Debugging.md`.

---

# 014-Workflow / 002-Debugging.md

## Debugging OpenTelemetry

One of the most ironic challenges in observability is **debugging the debugger**. When your application is running but no traces or metrics appear in your backend, you are often flying blind. OpenTelemetry is designed to be "fail-safe," meaning if the SDK encounters an error, it swallows it to prevent crashing your production application. While this is good for production, it makes local development and troubleshooting difficult.

This guide covers how to expose those hidden errors, verify data generation locally, and diagnose why traces might be fragmented or broken.

---

### 1. Self-Diagnostics (`OTEL_DIAG_LEVEL`)

The OpenTelemetry SDKs possess an internal logging mechanism. By default, this is usually turned off or set to a very quiet level to avoid spamming your application logs. To see what is happening *inside* the SDK (e.g., "Connection refused to Collector," "Export timeout," or "Invalid configuration"), you must enable self-diagnostics.

#### Environment Variables
The standardized way to control this across most languages is via environment variables, though implementation maturity varies by language.

*   **`OTEL_SDK_DISABLED`**: If set to `true`, the SDK is disabled. Check this first if absolutely nothing is happening.
*   **`OTEL_LOG_LEVEL`** (or `OTEL_DIAG_LEVEL`): Controls the verbosity. Common values: `debug`, `info`, `warn`, `error`, `none`.

#### Language-Specific Implementation
Since the SDK simply writes to an output, you often need to tell it *where* to write (StdOut or a specific logger).

*   **Node.js / JavaScript:**
    You must set the diagnostic logger in your code before the SDK starts.
    ```javascript
    const { diag, DiagConsoleLogger, DiagLogLevel } = require('@opentelemetry/api');
    
    // Set level to Debug to see everything
    diag.setLogger(new DiagConsoleLogger(), DiagLogLevel.DEBUG);
    ```
    *Common finding:* This often reveals that the OTLP exporter cannot resolve the URL `localhost:4318`.

*   **Java (Auto-Instrumentation Agent):**
    Use the CLI flag or environment variable.
    ```bash
    java -Dotel.javaagent.debug=true -jar myapp.jar
    # OR
    export OTEL_JAVAAGENT_DEBUG=true
    ```
    This will print the configuration details on startup, showing exactly which exporters and propagators are active.

*   **Python:**
    Usually configured via environment variables but can be hooked into the standard Python `logging` module.
    ```bash
    export OTEL_LOG_LEVEL=debug
    ```

*   **Go:**
    Go requires explicitly setting the global error handler.
    ```go
    import "go.opentelemetry.io/otel"
    
    // Print errors to stdout
    otel.SetErrorHandler(otel.ErrorHandlerFunc(func(err error) {
        log.Println("OTel Error:", err)
    }))
    ```

---

### 2. The `debug` Exporter (Console Output)

The most effective way to debug OTel is to isolate **Generation** from **Transmission**.

If you don't see data in Jaeger or Datadog, is it because:
1.  Your app didn't generate the span?
2.  Or your app generated it, but the network dropped it?

To answer this, use the Console Exporter (often called `logging`, `console`, or `debug` exporter depending on the language). This prints the raw span data to `stdout`.

#### Configuration
You can switch your exporter using environment variables without changing code (if your setup supports config-driven initialization):

```bash
# Don't send to the collector, print to screen instead
export OTEL_TRACES_EXPORTER=console
export OTEL_METRICS_EXPORTER=console
export OTEL_LOGS_EXPORTER=console
```

#### What to look for in the output
When this is active, your terminal will spit out JSON-like structures for every request:

```json
{
  "traceId": "5b8aa5a2d2c872e8321cf37308d69df2",
  "parentId": "051581bf3cb55c1f",
  "name": "GET /api/users",
  "id": "35ba48b7d98c42ca",
  "kind": "SERVER",
  "timestamp": 1619472391000000,
  "duration": 5000,
  "attributes": {
    "http.method": "GET",
    "http.status_code": 200
  },
  "status": {
    "code": "UNSET"
  }
}
```

**Workflow logic:**
1.  **If you see output here:** Your instrumentation is working. The problem is likely network firewalls, incorrect OTLP endpoint URLs, or authentication tokens for your backend.
2.  **If you see NO output here:** Your instrumentation is broken. You likely didn't register the SDK properly, or your auto-instrumentation libraries aren't compatible with your framework version.

---

### 3. Troubleshooting "Broken Traces"

A "Broken Trace" occurs when you expect to see one continuous timeline (Service A → Service B → Database), but instead you see two separate, disconnected traces, or huge gaps in time.

#### Scenario A: The Split Trace (Missing Context Propagation)
*   **Symptom:** You trigger a request. You see one trace for the Frontend and a *separate* trace for the Backend. They are not linked.
*   **Cause:** The Context (specifically `traceparent` header) was not propagated across the HTTP/gRPC boundary.
*   **Fix:**
    1.  Ensure you have `OTEL_PROPAGATORS=tracecontext,baggage` set.
    2.  Check your HTTP Client instrumentation. If you are manually making HTTP calls (e.g., using `fetch` in JS or `HttpClient` in Java), ensure the OTel instrumentation library for that client is loaded.
    3.  **Process Boundaries:** If you are using a message queue (Kafka/RabbitMQ), ensure the consumer is set to **extract** the context from the message headers.

#### Scenario B: The Orphaned Span (Sampling Issues)
*   **Symptom:** You see a trace for Service B (Child), but it says "Root Span" even though you know Service A called it. Or, the trace just disappears entirely.
*   **Cause:** Head Sampling. Service A decided *not* to sample the trace (to save cost), so it didn't send its data. Service B might have made a localized decision to record, but it lacks the parent data.
*   **Fix:**
    *   For debugging, set `OTEL_TRACES_SAMPLER=always_on`.
    *   Check `ParentBased` sampling logic. If the parent says "Drop," the child should usually drop too.

#### Scenario C: Missing Spans (The "Black Box")
*   **Symptom:** Trace A calls Trace C, but the time gap is huge. You suspect there is a database call or intermediate service B in the middle that isn't showing up.
*   **Cause:** Missing instrumentation for a specific library.
*   **Fix:**
    *   Check the "Span Events" or "Logs" of the surrounding spans.
    *   Manually wrap the suspicious code block:
        ```javascript
        // Manual debugging span
        const span = tracer.startSpan('debug-missing-logic');
        // do work
        span.end();
        ```

#### Scenario D: The Time Traveler (Clock Skew)
*   **Symptom:** A child span appears to start *before* the parent span.
*   **Cause:** The system clocks on the two different servers (or containers) are not synchronized.
*   **Fix:** OTel cannot fix physics. Ensure NTP (Network Time Protocol) is running on your infrastructure.

---

### 4. Debugging the Collector (Bonus)

If the SDK works (verified via Console Exporter) but data still doesn't arrive at the backend, the OpenTelemetry Collector is the likely culprit.

1.  **Enable Collector Logging:**
    In your `config.yaml`, set the telemetry logs for the collector service itself:
    ```yaml
    service:
      telemetry:
        logs:
          level: debug
    ```

2.  **The "Debug" Exporter (Collector Side):**
    Add a debug exporter to your pipeline to see what the Collector is actually receiving before it tries to push to the cloud.
    ```yaml
    exporters:
      debug:
        verbosity: detailed # Prints full payload content
    
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [batch]
          exporters: [debug, otlp/backend] # Fork data to console AND backend
    ```

3.  **zPages:**
    Enable the `zpages` extension in the Collector. This spins up a local webserver (default port `55679`) that shows live stats on dropped spans, queue sizes, and active trace processing.

### Summary Checklist for Troubleshooting

1.  **Check Env Vars:** Is `OTEL_SDK_DISABLED` true?
2.  **Turn on Console Exporter:** `OTEL_TRACES_EXPORTER=console`. Do you see JSON?
    *   *No:* Fix Instrumentation/SDK setup.
    *   *Yes:* Proceed to step 3.
3.  **Turn on Self-Diagnostics:** `OTEL_LOG_LEVEL=debug`. Do you see connection errors?
    *   *Yes:* Fix Network/Endpoint/Auth.
4.  **Check Propagation:** Inspect HTTP headers of outgoing requests. Do you see `traceparent`?
    *   *No:* Fix Propagator configuration.