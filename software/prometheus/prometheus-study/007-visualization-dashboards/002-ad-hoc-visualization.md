Based on the Table of Contents you provided, **Part VII, Section B (Ad-hoc Visualization)** focuses on the native capabilities built directly into Prometheus for viewing data without using external tools like Grafana.

"Ad-hoc" means "created for a specific purpose as necessary." In monitoring, this refers to quick, temporary visualizations used for debugging or exploration, rather than permanent, polished dashboards.

Here is a detailed explanation of the two sub-points in that section.

---

### 1. Prometheus Web UI (Graphing and Table view)

This is the interface you see when you navigate to `http://localhost:9090` (or wherever your Prometheus server is hosted). It is the primary tool for **debugging PromQL queries** and investigating data structure.

#### **The Expression Browser**
At the top of the UI is the expression bar. This is where you type your PromQL (Prometheus Query Language) queries.

#### **View Mode: Table**
When you execute a query and select "Table," Prometheus displays the **Instant Vector**.
*   **What it shows:** The value of the metric at the *specific single timestamp* when you hit "Execute."
*   **Use Case:**
    *   Checking exact values (e.g., "Is the disk usage at 80% or 81%?").
    *   Inspecting labels (e.g., seeing which specific `instance` or `pod` is reporting a metric).
    *   Verifying that a new scrape target is actually returning data.

#### **View Mode: Graph**
When you switch to "Graph," Prometheus displays a **Range Vector** visualized as a line chart.
*   **What it shows:** The evolution of the metric over a selected time range (e.g., the last 1 hour).
*   **Key Controls:**
    *   **Range:** How far back to look (1h, 1d, 1w).
    *   **Resolution:** The step interval (how many seconds between data points).
*   **Use Case:**
    *   Identifying trends (is memory leaking upwards?).
    *   Correlating events (did the CPU spike at the same time the errors went up?).
    *   **Debugging Alerts:** If an alert says "High Latency," you paste the alert's query here to visualize the spike that triggered it.

**Limitation:** The Web UI is not persistent. If you refresh the page, your query is usually gone (unless URL-encoded). It is not meant to replace Grafana; it is meant for engineers to explore data raw.

---

### 2. Console Templates (Legacy/Native approach)

Before Grafana became the industry standard for visualizing Prometheus data, Prometheus included a native way to create "Dashboards" directly on the Prometheus server using HTML and Go templating.

#### **How it works**
*   You write HTML files mixed with Go template syntax (similar to Jinja2 or Handlebars).
*   You place these files in a specific directory on the Prometheus server (e.g., `/etc/prometheus/consoles`).
*   Prometheus serves these files as web pages. When a user requests the page, the Prometheus server executes the queries embedded in the template and renders the HTML with the resulting data.

#### **The Syntax**
It uses the Go `text/template` engine. A snippet might look like this:

```html
<!-- Native Prometheus Console Template -->
<h1>CPU Usage</h1>
{{ range query "rate(node_cpu_seconds_total{mode='system'}[5m])" }}
  <div class="bar">
    Server: {{ .Labels.instance }} <br>
    Usage: {{ .Value | humanize }}%
  </div>
{{ end }}
```

#### **Why is it called "Legacy"?**
While this feature still exists and works, it is rarely used for modern dashboards because:
1.  **Hard to create:** You have to write raw HTML/CSS and Go code.
2.  **Hard to maintain:** Changing a chart requires editing code and redeploying files to the server.
3.  **Grafana is better:** Grafana offers drag-and-drop creation, rich plugins, and better user management.

#### **When is it still used?**
Despite being "legacy," it is useful in specific edge cases:
*   **No Grafana Available:** If you are running Prometheus on a restricted edge device or an embedded system where you cannot install Grafana.
*   **Status Pages:** Creating a simple, read-only status page that lives inside the Prometheus binary itself with zero external dependencies.

---

### Summary of Differences

| Feature | Prometheus Web UI | Console Templates | Grafana (For Context) |
| :--- | :--- | :--- | :--- |
| **Purpose** | Debugging & Exploration | Static, simple dashboards | Operational Monitoring |
| **Persistence** | None (Session based) | High (Saved as files) | High (Saved in DB) |
| **Skill Needed** | PromQL | HTML + Go + PromQL | GUI / Drag & Drop |
| **Best For** | "Why is this alert firing?" | "I need a status page without a database" | "I need a wall monitor for my NOC" |
