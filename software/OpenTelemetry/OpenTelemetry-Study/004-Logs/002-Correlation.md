Here is a detailed deep dive into Part IV, Section A of your study plan.

***

# 004-Logs / 001-Structured-Logging.md

In the observability triad (Traces, Metrics, Logs), Logs are the oldest and most familiar signal. However, in the context of OpenTelemetry (OTel), logs undergo a significant transformation. We move away from "writing lines of text to a file" toward "emitting structured events."

This document details why unstructured logs fail modern systems, how the OTel Data Model fixes this, and how to bridge existing logging libraries into the OTel ecosystem.

---

## 1. The Limitations of Unstructured Text Logs

For decades, logging meant printing a string to `stdout` or a file. While simple for humans to read one by one, this approach fails at scale.

### The "Grep" Trap
Consider a traditional log line:
```text
2023-10-27 14:02:10 [ERROR] Payment processing failed for user 89210: Connection timeout
```

To analyze this programmatically, a machine (like Splunk, ELK, or Loki) must apply a **Regular Expression (Regex)** to extract the user ID or the error type.
1.  **Fragility:** If a developer changes the log message to `[ERROR] Connection timeout - User: 89210`, the parsing rules break, and your dashboards go blank.
2.  **Performance:** Parsing text via Regex at ingestion time (or query time) is computationally expensive.
3.  **Ambiguity:** It is difficult to distinguish between the "message" (what happened) and the "context" (variables like User ID).

### The Solution: Structured Logging
Structured logging treats a log entry not as a string, but as an **Event Object**.

Instead of the text above, the application emits a payload (conceptually like JSON):
```json
{
  "timestamp": "2023-10-27T14:02:10Z",
  "severity": "ERROR",
  "message": "Payment processing failed",
  "attributes": {
    "user_id": 89210,
    "error_type": "ConnectionTimeout",
    "service_name": "payment-service"
  }
}
```

**Benefits:**
*   **Queryability:** You can write queries like `SELECT * WHERE attributes.user_id = 89210`.
*   **Cardinality Control:** The `message` remains constant ("Payment processing failed"), allowing for easy grouping, while the dynamic data lives in `attributes`.

---

## 2. The OTel Log Data Model

OpenTelemetry defines a strict schema for what a "Log Record" looks like. This is critical because it unifies logs coming from Java, Go, Python, and Rust into a single standard format that backends can understand without custom parsers.

The OTel Log Data Model consists of three distinct layers:

### A. Top-Level Fields
These are the standard metadata fields every log must have.
*   **Timestamp:** When the event occurred.
*   **ObservedTimestamp:** When the collection system (OTel) first saw the event (useful for calculating lag).
*   **SeverityNumber:** A normalized integer (1-24) representing importance (e.g., TRACE, DEBUG, INFO, WARN, ERROR, FATAL). This normalizes differences between languages (e.g., Python `CRITICAL` vs. Java `FATAL`).
*   **SeverityText:** The original string representation (e.g., "ERROR").
*   **Body:** The actual content of the log. While usually a string, OTel supports structured bodies (Maps/Arrays) as well.

### B. Attributes (Context)
Key-Value pairs that describe the *event*.
*   Examples: `http.status_code`, `user.id`, `db.statement`.
*   These allow you to filter and aggregate logs.

### C. Resource (Identity)
Key-Value pairs that describe the *source* (the entity emitting the log).
*   These are set **once** for the entire application, not per log line.
*   Examples: `service.name`, `host.name`, `k8s.pod.name`, `cloud.region`.
*   **Why it matters:** In unstructured logging, you often have to repeat the service name in every log line. In OTel, the Resource is attached automatically to every log emitted by that process, reducing data duplication in the code while maintaining context.

---

## 3. Mapping Legacy Logging Libraries (Log Appenders)

One of the biggest misconceptions about OpenTelemetry logging is that you must rewrite all your `console.log` or `logger.info` statements. **You do not.**

OpenTelemetry recognizes that developers have strong muscle memory with existing logging frameworks:
*   **Java:** Log4j2, Logback, SLF4J
*   **Python:** logging
*   **Node.js:** Winston, Bunyan, Pino
*   **Go:** Zap, Logrus

### The Strategy: "Bring Your Own Logger" (BYOL)
Instead of replacing the logging API, OTel provides **Appenders** (or Bridges/Handlers) that hook into your existing logging framework.

#### How the Pipeline Works:

1.  **Application Code:** The developer writes code exactly as before.
    ```java
    // Java example using SLF4J - No OTel code here!
    logger.error("Payment failed", exception);
    ```

2.  **Instrumentation Layer (The Interceptor):**
    *   You install an OTel-compatible "Appender" for your framework (e.g., `opentelemetry-logback-appender`).
    *   This appender sits alongside your File or Console appender.

3.  **Translation:**
    *   The Appender intercepts the log event.
    *   It grabs the **Message** ("Payment failed").
    *   It grabs the **MDC (Mapped Diagnostic Context)** and converts them to **OTel Attributes**.
    *   It grabs the **Timestamp** and **Severity**.
    *   It automatically injects the current **TraceId** and **SpanId** from the active context (if tracing is enabled).

4.  **Emission:**
    *   The log is converted into an **OTLP (OpenTelemetry Protocol)** object.
    *   It is sent to the OTel Collector or backend, bypassing the local disk (unless configured otherwise).

### Why this approach wins:
*   **Zero Code Change:** You don't change a single line of business logic. You only change the logger configuration (e.g., `logback.xml` or Python logging config).
*   **Automatic Correlation:** The biggest superpower of OTel Logs is that the Appender automatically links the Log to the Trace. If a Trace is active when `logger.error` is called, the Log Record receives that TraceID. This allows you to click a button in your backend labeled "Show logs for this trace."

### Example: Python Logic Flow

**Without OTel:**
`app.py` -> `logging` library -> Formatter -> `FileHandler` -> `app.log` file.

**With OTel:**
`app.py` -> `logging` library -> **`OTELHandler`** -> `BatchLogRecordProcessor` -> **OTLP Exporter** -> **Collector**.

## Summary

1.  **Unstructured logs** are expensive to parse and brittle to query.
2.  **Structured logging** turns logs into queryable data objects with distinct attributes.
3.  **The OTel Log Data Model** standardizes these objects with strict definitions for Severity, Body, Attributes, and Resources.
4.  **Adoption is easy:** You do not rewrite code. You attach OTel **Appenders** to your existing logging libraries (Log4j, Winston, Zap) to intercept logs, structure them, and ship them via OTLP.