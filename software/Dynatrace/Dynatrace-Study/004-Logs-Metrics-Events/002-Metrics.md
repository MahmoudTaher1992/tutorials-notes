Here is a detailed breakdown of **Part IV (Logs, Metrics & Events), Section B: Metrics**.

In the Dynatrace ecosystem, a **Metric** is a numerical data point measured over time (e.g., *CPU is at 45%*, *Response Time is 200ms*). While Logs tell you *what* happened and Traces tell you *where* it happened, Metrics tell you the **health and performance trends** of your system.

Here is the detailed explanation of the four sub-topics in your roadmap:

---

### 1. Built-in Metrics
Dynatrace is famous for its "Zero-Configuration" approach. As soon as you install the OneAgent on a host, it automatically begins collecting hundreds of standard metrics without you writing a single line of code.

*   **What they are:** These are standard infrastructure and application performance metrics defined by Dynatrace.
*   **Examples:**
    *   **Infrastructure:** Host CPU usage, Memory availability, Disk I/O, Network traffic, Connectivity.
    *   **Services/Application:** Throughput (requests/min), Response time (latency), Failure rate (5xx errors), Database calls per request.
    *   **Process:** JVM Heap usage, Garbage Collection time, Thread count.
*   **Key Concept:** OneAgent automatically detects the technology stack (e.g., Java, Node.js, Docker) and activates the specific built-in metrics relevant to that technology.

### 2. Custom Metrics API (Ingestion)
Sometimes, the built-in metrics aren't enough. You might want to track business data or specific internal application logic that the OneAgent cannot see automatically. This is where Custom Metrics come in.

*   **Metric Ingestion (MINT):** This is the engine Dynatrace uses to ingest custom data.
*   **How to send Custom Metrics:**
    1.  **Dynatrace API (v2/metrics/ingest):** You can send a JSON payload via HTTP POST to push metrics into Dynatrace.
    2.  **OneAgent Metric API:** Your code sends data locally to the OneAgent, which handles the upload (more efficient than HTTP).
    3.  **Extensions (StatsD/Telegraf/Prometheus):** You can configure Dynatrace to "scrape" or accept metrics from open-source tools like Prometheus.
*   **Examples of Custom Metrics:**
    *   *Business Logic:* "Number of items added to cart," "Revenue processed per minute."
    *   *IoT:* "Temperature of the server room."
    *   *External Tools:* "Number of build failures" (imported from Jenkins).
*   **Cost Implication:** Custom metrics consume **DDUs (Davis Data Units)**. It is important to understand the licensing cost before ingesting massive amounts of custom data.

### 3. Metric Dimensions & Tagging
A raw number (e.g., `cpu_usage = 80%`) is useless without context. **Dimensions** and **Tags** provide that context.

*   **Dimensions:** These are key-value pairs associated with a metric that allow you to slice and dice the data.
    *   *Example:* If you have a metric `http.requests`, the dimensions might be:
        *   `method="POST"`
        *   `status="200"`
        *   `geo_location="US-East"`
    *   *Why it matters:* Dimensions allow you to ask: "Show me the response time *split by* location."
*   **Tagging:** Tags are high-level metadata applied to entities (hosts, services).
    *   *Example:* You tag a host as `environment:production` or `owner:billing-team`.
    *   *Usage:* You can filter metrics in charts using tags. "Show me CPU usage ONLY for hosts tagged `environment:production`."
*   **Topology Awareness:** Because Dynatrace understands the topology (Smartscape), it automatically adds topological dimensions (Host ID, Process ID) to metrics, so you know exactly where the data came from.

### 4. Timeseries Analysis
Once metrics are collected, they are stored as a **Timeseries** (a sequence of data points indexed in time order). This section covers how to query, aggregate, and visualize that data.

*   **Aggregation:** Raw data is voluminous. Dynatrace aggregates data to make sense of it.
    *   **Average:** Good for general trends.
    *   **Max/Min:** Good for finding spikes or drops.
    *   **Percentiles (P95, P99):** Crucial for performance. *Example:* "95% of our users experience a load time under 2 seconds." (This ignores the few outliers).
*   **Resolution:**
    *   **0-14 days:** High resolution (1-minute intervals).
    *   **14-28 days:** 5-minute intervals.
    *   **Old data:** 1-hour intervals.
*   **The Data Explorer:** This is the UI tool in Dynatrace where you build charts.
    *   You select a Metric (e.g., `builtin:host.cpu.usage`).
    *   You choose an Aggregation (e.g., `Average`).
    *   You Split by Dimension (e.g., `Host`).
*   **Metric Selectors:** This is the query syntax used to fetch data via API or in advanced dashboards.
    *   *Example Syntax:* `builtin:host.cpu.usage:splitBy("dt.entity.host"):avg:sort(value(avg,descending))`

---

### Summary Checklist for this Section
If you are studying this for an exam or implementation, ensure you can answer:
1.  What is the difference between a built-in metric and a custom metric?
2.  How do I send a custom metric using the API?
3.  How do Dimensions help me filter data in the Data Explorer?
4.  Why would I use a P95 aggregation instead of an Average?
