Here is a detailed explanation of **Part II, Section B: Prometheus: Open-Source Monitoring & Alerting**.

---

# B. Prometheus: Open-Source Monitoring & Alerting

**Prometheus** is the de facto standard for monitoring cloud-native applications, particularly those running in Kubernetes. Originally developed at SoundCloud, it is a Graduated CNCF project (like Kubernetes itself).

Unlike traditional monitoring systems that wait for applications to send them data, Prometheus actively goes out and collects it.

## 1. Core Concepts & Architecture: The "Pull" Model
The defining characteristic of Prometheus is that it is **Pull-based**.

*   **Push Model (Traditional):** Your app sends data to the monitoring server.
    *   *Risk:* If your app loops and spams the server, it can crash the monitoring system (DDoS yourself).
*   **Pull Model (Prometheus):** Your app exposes a lightweight HTTP endpoint (usually `/metrics`). Prometheus visits this endpoint periodically (e.g., every 15 seconds) to "scrape" the data.
    *   *Benefit:* Prometheus controls the load. If the app is under heavy load, Prometheus doesn't crash; it just misses a scrape.

### Key Components
1.  **Prometheus Server:** The core brain. It scrapes targets, stores the data in a local Time-Series Database (TSDB), and evaluates alerting rules.
2.  **Exporters:** Many third-party tools (like Linux, PostgreSQL, or Nginx) don't output Prometheus metrics natively. An **Exporter** is a small binary that runs alongside these services, queries their internal stats, and translates them into Prometheus format.
    *   *Example:* **Node Exporter** runs on a Linux server to translate CPU/Memory stats into metrics.
3.  **Pushgateway:** Used for **Short-lived Jobs** (batch scripts). If a script runs for 2 seconds, Prometheus might not scrape it in time. The script *pushes* data to the Pushgateway, and Prometheus *pulls* from the Gateway.
4.  **Alertmanager:** Prometheus detects *conditions* (e.g., "CPU > 90%"), but **Alertmanager** handles the *notifications*. It groups alerts (deduplication) and routes them (to Slack, PagerDuty, Email).

---

## 2. Prometheus Data Model
Prometheus does not store logs or traces; it stores **Time Series** data.

### The Structure
Every piece of data consists of:
1.  **Metric Name:** What is being measured (e.g., `http_requests_total`).
2.  **Labels (Key-Value Pairs):** This is Prometheus's superpower. It allows for multi-dimensional data.
3.  **Value:** A 64-bit float (the number).
4.  **Timestamp:** When it was scraped.

**Example:**
```text
http_requests_total{method="POST", handler="/api/login", status="500"}  12
```

### Metric Types
Prometheus has four core metric types:

1.  **Counter:** A number that **only goes up**. It never decreases (unless the app restarts).
    *   *Use case:* Total requests, total errors, total tasks completed.
2.  **Gauge:** A number that can go **up and down**.
    *   *Use case:* Current memory usage, number of running goroutines, temperature.
3.  **Histogram:** Samples observations and counts them in configurable buckets. It allows you to calculate quantiles (e.g., P95 latency) on the server side.
    *   *Use case:* Request duration (How many requests took < 0.1s? How many < 0.5s?).
4.  **Summary:** Similar to Histogram, but calculates the quantile on the *client* side. It is more accurate but less flexible for aggregation.

---

## 3. PromQL (Prometheus Query Language)
PromQL is a functional language designed for computing data on the fly. It is not SQL.

### Basic Selectors
*   Select all metrics with this name:
    `http_requests_total`
*   Filter by label:
    `http_requests_total{job="api-server", status="500"}`

### Functions & Operators (The Power of PromQL)
Since **Counters** only go up, the raw number (e.g., "1,500,000 errors") is useless. You need to know *how fast* it is increasing.

*   **`rate()`:** Calculates the per-second rate of increase over a time window.
    *   `rate(http_requests_total[5m])` -> "What is the average requests per second over the last 5 minutes?"
*   **Aggregation:** You can sum data across dimensions.
    *   `sum by (datacenter) (rate(http_requests_total[5m]))` -> This sums up the rates, grouped by the "datacenter" label, ignoring other labels like "instance" or "pod."

---

## 4. Service Discovery
In modern dynamic environments (like Kubernetes or AWS Auto Scaling), servers change IP addresses constantly. You cannot maintain a static list of IPs in a config file.

**Service Discovery** is how Prometheus finds what to monitor:
1.  Prometheus asks the **Kubernetes API**: "List all pods currently running."
2.  Kubernetes returns the list of current IPs.
3.  Prometheus automatically updates its target list and starts scraping the new pods immediately.

This ensures that as soon as a new microservice instance scales up, it is automatically monitored without human intervention.

---

## 5. Integration with Grafana
Prometheus has a built-in web UI, but it is basic and intended only for debugging queries.

**Grafana** is the visualization layer.
*   **The Workflow:** Prometheus acts as the **Data Source**. Grafana sends PromQL queries to Prometheus, gets the numbers back, and renders them into rich dashboards (Heatmaps, Bar charts, Gauges).
*   **Why they are paired:** Grafana excels at visualizing time-series data, and Prometheus excels at collecting it. They are almost always used together in the "Prometheus/Grafana stack."