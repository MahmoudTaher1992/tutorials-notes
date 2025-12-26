Here is the detailed content for **Part XIII, Section B: Client-Side/RUM Evolution**, formatted as a study guide entry.

***

# 013-Emerging-Frontiers/002-Client-Side-RUM.md

## Client-Side and Real User Monitoring (RUM) Evolution

Historically, OpenTelemetry (OTel) matured rapidly on the backend (Go, Java, Python microservices), while the client-side (Browser JS, iOS, Android) lagged slightly behind. However, as of 2024/2025, Client-Side RUM (Real User Monitoring) has become a primary focus for the OTel project.

The goal is to move away from proprietary RUM agents (like New Relic Browser, Datadog RUM, or Google Analytics) and use a unified, open standard to track the user journey from the click in the browser all the way to the database query in the backend.

### 1. The Shift to "Full-Stack" Observability

The primary value proposition of OTel RUM is **End-to-End Visibility**.

*   **The Old Way:** You have a frontend monitoring tool and a backend monitoring tool. If a user clicks a button and it spins forever, you see an error in the frontend tool, but you have to manually guess which backend trace corresponds to that user action.
*   **The OTel Way:** The frontend generates a `TraceId`. It injects this ID into the HTTP headers of the API request. The backend extracts that ID. The result is a single distributed trace that starts in the DOM and ends in the database.

### 2. Web Vitals Integration

Google's **Core Web Vitals** (CWV) are the industry standard for measuring user experience quality. OTel has evolved to treat these not just as isolated numbers, but as **Metric Instruments** that can be correlated with spans.

#### The Metrics
By 2025, the standard set monitored via OTel includes:
*   **LCP (Largest Contentful Paint):** Loading performance.
*   **CLS (Cumulative Layout Shift):** Visual stability.
*   **INP (Interaction to Next Paint):** Responsiveness (replaced FID).

#### Implementation Mechanism
Instead of manually calculating these, the OTel ecosystem utilizes auto-instrumentation packages that wrap the native browser `PerformanceObserver` API.

**Code Concept (JavaScript):**
```javascript
import { WebVitalsInstrumentation } from '@opentelemetry/instrumentation-web-vitals';

registerInstrumentations({
  instrumentations: [
    new WebVitalsInstrumentation({
      // Maps browser performance entries to OTel Metrics
      applyCustomAttributes: (resource, attributes) => {
        // Add specific metadata like user_tier or app_version
        attributes['app.version'] = 'v2.5.1';
      },
    }),
  ],
});
```

When visualized in a backend (like Grafana or Honeycomb), you can slice Web Vitals by custom attributes. *Example: "Show me the INP scores for premium users on iOS devices."*

### 3. Session Replay Integration

One of the emerging frontiers is the intersection of OTel and **Session Replay** (tools that record a video-like reproduction of user interactions).

While OpenTelemetry does not define a protocol for transmitting video blobs (it is too heavy for the OTLP standard), the evolution lies in **Contextual Linking**.

#### The Correlation Pattern
1.  **Session ID Generation:** The OTel SDK (or the Session Replay tool) generates a unique `session.id`.
2.  **Attribute Injection:** This `session.id` is added as a **Resource Attribute** to every span and log emitted by the browser.
3.  **The Bridge:** When viewing a trace in your backend, a link is generated using the `session.id` that points to the Replay tool (e.g., LogRocket, PostHog, or a custom storage).

**The Future (Log-based Replay):**
There are experimental efforts to serialize DOM events (clicks, scrolls, mutations) as structured OTel **Logs**. If the backend can rehydrate these logs, you could theoretically build a Session Replay tool entirely on top of OTel data, eliminating the need for a separate vendor SDK.

### 4. Technical Challenges & Solutions in RUM

Client-side instrumentation faces distinct challenges compared to server-side.

#### A. The Clock Skew Problem
Backend servers use NTP to stay synchronized. A user's mobile phone or laptop clock might be minutes or hours off.
*   **Solution:** OTel collectors and backend processors now implement sophisticated **Clock Skew Correction**. They look at the timestamp of the HTTP request leaving the browser and the timestamp of it arriving at the server to calculate the offset and adjust the browser spans retroactively.

#### B. Payload Size & Network Constraints
Sending heavy telemetry data from a mobile device on a 3G network causes performance issues.
*   **Evolution:**
    *   **Protobuf over HTTP:** Moving away from JSON to OTLP/Protobuf in the browser to reduce payload size.
    *   **Beacon API:** Using `navigator.sendBeacon` to ensure telemetry is sent even if the user closes the tab.
    *   **Aggressive Sampling:** Implementing logic in the browser SDK to only sample 1% of sessions unless an error occurs.

#### C. Handling Single Page Applications (SPAs)
In an SPA (React, Vue, Angular), the page doesn't reload.
*   **The "Navigation" Span:** The OTel Document Load instrumentation has evolved to detect "Soft Navigations" (History API changes). It creates a root span for the route change (e.g., `/home` -> `/dashboard`) and attaches all subsequent XHR/Fetch requests as children of that navigation span.

### 5. Mobile OTel (iOS & Android)

RUM is not just for browsers. The Swift and Kotlin SDKs have matured to include:

*   **App Start Tracing:** Automatically measuring Cold Start and Warm Start times.
*   **ANR Detection (Application Not Responding):** Reporting UI freezes as specific Span Events or Logs.
*   **Fragment/View Tracking:** Automatically starting spans when a View Controller or Activity loads.

### 6. Summary: The OTel RUM Data Model

To standardize RUM, OTel has defined specific **Semantic Conventions** for client-side data. When studying this, look for these specific attributes in your telemetry:

| Attribute | Description | Example |
| :--- | :--- | :--- |
| `browser.platform` | The operating system | `MacIntel`, `Win32` |
| `browser.mobile` | Is it a mobile device? | `true`, `false` |
| `session.id` | Unique ID for the user session | `uuid-v4` |
| `http.request.method`| The method of the fetch call | `GET`, `POST` |
| `user_agent.original` | The raw UA string | `Mozilla/5.0...` |

### Key Takeaway
The "Emerging Frontier" here is the move toward **One Agent**. Instead of installing Google Analytics for marketing, Sentry for errors, and New Relic for performance, the goal is to install the **OpenTelemetry Web SDK**. It captures interactions, errors, and performance metrics, sending them to a Collector which then routes the relevant data to the marketing, error, and performance backends respectively.