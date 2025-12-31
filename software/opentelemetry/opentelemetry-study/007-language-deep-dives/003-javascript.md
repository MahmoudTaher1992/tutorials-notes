Here is a detailed deep dive into **Part VII: Language-Specific Implementation Deep Dives -> C. JavaScript / TypeScript (Node.js & Browser)**.

In the JavaScript ecosystem, OpenTelemetry is unique because it must solve two completely different sets of problems:
1.  **Node.js (Backend):** Managing long-running processes, file systems, database connections, and concurrency via the Event Loop.
2.  **Browser (Frontend/RUM):** Managing user sessions, network latency, DOM rendering, and security constraints (CORS).

---

# 003-JavaScript.md: Deep Dive

## 1. Node.js Implementation

Node.js relies heavily on the **Event Loop** and asynchronous callbacks. In traditional threaded languages (like Java), thread-local storage is used to hold the current Trace ID. Since Node is single-threaded, OTel uses a different mechanism to keep track of "which request acts as the parent of the current operation."

### A. The Core: AsyncLocalStorage
Historically, Node.js required a library called `cls-hooked` or the `AsyncHooks` API to track context.
Modern OTel Node.js implementation relies on **`AsyncLocalStorage`** (native to Node.js).
*   **How it works:** When a request hits your server (e.g., Express), OTel creates a "Store." As your code `awaits` database calls or performs async logic, Node ensures that the context in that Store "follows" the execution chain.
*   **Why it matters:** Without this, if two users hit your API simultaneously, the logs and spans could get mixed up because they are running on the same thread.

### B. Node.js Automatic Instrumentation
The Node.js ecosystem is heavily modular. OTel provides a "meta-package" called `@opentelemetry/auto-instrumentations-node`.

**Mechanism (Monkey Patching):**
When the application starts, OTel "patches" `require`. When you `require('http')` or `require('pg')` (Postgres), OTel intercepts that call and wraps the library's functions with code that starts and ends Spans automatically.

**Example Configuration (TypeScript):**

```typescript
import * as opentelemetry from '@opentelemetry/sdk-node';
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node';
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-proto';

// 1. Setup Exporter (Sending data to Collector)
const traceExporter = new OTLPTraceExporter({
  url: 'http://localhost:4318/v1/traces',
});

// 2. Initialize the SDK
const sdk = new opentelemetry.NodeSDK({
  traceExporter,
  // 3. Enable Auto-Instrumentation
  instrumentations: [getNodeAutoInstrumentations()],
  serviceName: 'my-node-service',
});

// 4. Start the SDK
sdk.start();
```

### C. Manual Instrumentation
While auto-instrumentation covers HTTP and DB, you often need to measure your own business logic.

```typescript
import { trace } from '@opentelemetry/api';

const tracer = trace.getTracer('my-node-service');

async function processOrder(orderId: string) {
  return tracer.startActiveSpan('processOrder', async (span) => {
    span.setAttribute('order.id', orderId);
    
    try {
      await database.save(orderId); // Auto-instrumented
      await email.send(orderId);    // Auto-instrumented
      span.setStatus({ code: 1 }); // OK
    } catch (err) {
      span.recordException(err);
      span.setStatus({ code: 2, message: err.message }); // ERROR
    } finally {
      span.end();
    }
  });
}
```

---

## 2. OTel for the Browser (Real User Monitoring - RUM)

Instrumentation in the browser is distinct because you are monitoring the **user experience**, not just server latency. This is often called RUM.

### A. The Challenge: Context in the Browser
In Node, we have `AsyncLocalStorage`. In the browser, we do not.
If a user clicks a button -> triggers a `setTimeout` -> triggers a `fetch` request, standard JavaScript loses the link between the click and the fetch.

### B. ZoneContextManager
To solve this, OTel Web uses the **`ZoneContextManager`**.
*   **What is it?** It is based on `zone.js` (created originally for Angular).
*   **How it works:** It monkey-patches global browser APIs (`window.setTimeout`, `window.fetch`, `Promise`, `document.addEventListener`).
*   **The Result:** It creates a "Zone" around the user's action. Any async work spawned from that action inherits the Trace ID of the Zone. This ensures that the HTTP request sent to the backend carries the context of the button click that caused it.

### C. Key Web Instrumentations

1.  **`@opentelemetry/instrumentation-document-load`**:
    *   Creates spans for the browser's critical rendering path.
    *   **Metrics captured:** `fetchStart`, `domInteractive`, `domContentLoaded`, `loadEventEnd`.
    *   *Why:* Helps you debug if your site is slow because of large assets (network) or heavy JavaScript parsing (CPU).

2.  **`@opentelemetry/instrumentation-user-interaction`**:
    *   Automatically creates spans when users click elements, submit forms, or drag/drop.
    *   *Example:* A span named `click #checkout-button`.

3.  **`@opentelemetry/instrumentation-fetch` / `XMLHttpRequest`**:
    *   Intercepts network calls.
    *   **Crucial Step:** It injects the `traceparent` header into the outgoing request so the Backend can link the frontend span to the backend trace.

**Example Browser Setup:**

```javascript
import { WebTracerProvider } from '@opentelemetry/sdk-trace-web';
import { ZoneContextManager } from '@opentelemetry/context-zone';
import { registerInstrumentations } from '@opentelemetry/instrumentation';
import { DocumentLoadInstrumentation } from '@opentelemetry/instrumentation-document-load';

const provider = new WebTracerProvider();

// REQUIRED for async context tracking in browser
provider.register({
  contextManager: new ZoneContextManager(),
});

registerInstrumentations({
  instrumentations: [
    new DocumentLoadInstrumentation(),
  ],
});
```

---

## 3. Handling CORS (Cross-Origin Resource Sharing)

This is the #1 pain point when implementing OTel in the browser.

### A. The Collector Issue
When the browser SDK exports data (traces/logs), it sends an HTTP POST to your OpenTelemetry Collector.
*   **Scenario:** Your website is `https://my-shop.com`. Your collector is `https://otel.my-corp.com`.
*   **The Error:** The browser will block this request due to CORS policies unless the Collector is configured explicitly to allow it.
*   **Fix:** You must configure the **Collector's OTLP Receiver** to allow headers from your website origin.

### B. The Propagation Issue (Trace Context)
When your Frontend (`my-shop.com`) calls your Backend API (`api.my-shop.com`), OTel injects the `traceparent` header.
*   **The Error:** The browser will perform a "Pre-flight" OPTIONS request to the API. If the API does not explicitly say "I accept the `traceparent` header," the browser will fail the request.
*   **Fix:** Your Backend (Express/Fastify/Nginx) must be configured to allow the headers `traceparent` and `tracestate` in CORS settings.

---

## 4. Bundle Size and Tree Shaking

In Node.js, library size rarely matters. In the browser, every kilobyte counts.

*   **The Problem:** The full OTel SDK can be large.
*   **Optimization:**
    *   Use **Tree Shaking** (via Webpack/Vite) to ensure you only bundle the exporters and instrumentations you actually use.
    *   **Tape Sampling:** Avoid sending 100% of frontend traces. Use the `SessionIdRatioBased` sampler to only track 10% of user sessions to reduce bandwidth usage and performance impact on the client.

## Summary Checklist for JS/TS
1.  **Node:** Use `AsyncLocalStorage` (via the SDK) to maintain context.
2.  **Node:** Prefer `auto-instrumentations-node` for 90% of the work; use manual tracing only for complex business logic.
3.  **Browser:** You **must** use `ZoneContextManager` if you want to connect user interactions to network requests.
4.  **Browser:** Configure CORS on both your Collector (to receive spans) and your Backend API (to accept trace headers).