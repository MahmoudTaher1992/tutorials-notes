Based on the Table of Contents provided, here is a detailed explanation of **Part VII: Dashboards & Visualization / Section B: Advanced Visualization**.

This section represents the transition from simply **viewing** data (standard dashboards) to actively **analyzing, querying, and manipulating** data to answer complex questions.

---

# 002-Advanced-Visualization.md: Detailed Breakdown

In this module, you move beyond the standard "traffic light" dashboards (Red/Green status) and learn how to mine the Dynatrace database for deep insights using custom queries, interactive documents, and business-logic extraction.

## 1. Data Explorer
The Data Explorer is the "engine room" for creating custom charts in Dynatrace. While standard screens show you what Dynatrace *thinks* you want to see, the Data Explorer allows you to ask exactly what *you* want to know.

*   **Metric Expressions:**
    *   Learning how to combine metrics using mathematical operations (e.g., `(Request Count / Total Errors) * 100`).
    *   Understanding **Aggregations**: How to switch between Average, Max, Min, and Percentiles (p95, p99). *Crucial for finding outliers that averages hide.*
*   **Multidimensional Analysis:**
    *   **Splitting:** taking a global metric (e.g., `CPU Usage`) and splitting it by dimensions (e.g., `Host`, `Service`, or `Data Center`).
    *   **Filtering:** Narrowing down data sets using specific tags (e.g., `OS:Linux`, `Environment:Production`) to isolate noise.
*   **Advanced Chart Types:**
    *   Moving beyond line charts to **Honeycombs** (great for visualizing cluster health), **Top Lists** (identifying resource hogs), and **Heatmaps**.

> **Real-World Scenario:** A standard dashboard shows "Average Response Time." Using Data Explorer, you create a custom chart showing the "98th percentile response time of the Checkout Service, split by AWS Region," revealing that only the US-East region is lagging.

## 2. Notebooks (The "New" Dynatrace Experience)
This is the modern way of interacting with Dynatrace data, powered by the **Grail** data lakehouse. It moves away from static dashboards toward interactive, document-style analysis (similar to Jupyter Notebooks for Data Science).

*   **DQL (Dynatrace Query Language):**
    *   This is the core skill here. You will learn to write SQL-like queries to fetch logs, metrics, traces, and events in a single query.
    *   Syntax structure: `fetch logs | filter matchesPhrase(content, "error") | summarize count(), by:bin(timestamp, 1h)`.
*   **Interactive Analysis:**
    *   Unlike a dashboard which is "read-only," Notebooks allow you to fetch data, manipulate it with code, add commentary (Markdown text), and visualize the results in one scrollable document.
    *   This is used for **exploratory debugging** (hunting for a root cause without knowing what you are looking for yet).
*   **Collaborative Workflows:**
    *   Sharing a live Notebook with your team during an incident so everyone sees the same data and queries in real-time.

> **Real-World Scenario:** You are conducting a Post-Incident Review (PIR). Instead of taking screenshots of graphs, you build a Notebook containing the specific DQL queries that isolate the error logs and the CPU spikes, combined with text explaining the timeline of the outage.

## 3. Business Analytics Dashboards (BizOps)
This section teaches you how to bridge the gap between **IT Metrics** (CPU, RAM, Latency) and **Business Goals** (Revenue, Conversions, User Satisfaction).

*   **Extracting Business Data:**
    *   Using **Request Attributes** to capture method arguments or HTTP parameters.
    *   *Example:* Configuring Dynatrace to "read" the value of a shopping cart or a User ID from the URL or payload.
*   **Funnel Analysis:**
    *   Visualizing the user journey step-by-step.
    *   Steps: `Landing Page` -> `Search` -> `Add to Cart` -> `Checkout`.
    *   Identifying exactly where users drop off (conversion rate).
*   **Business Events (BizEvents):**
    *   Capturing high-precision business data (like "Payment Processed") that must be 100% accurate (unlike sampling used for general monitoring).

> **Real-World Scenario:** Marketing runs a flash sale. The servers are green (low CPU), but sales are low. Your Business Dashboard shows a "Conversion Funnel" where 50% of users are dropping off at the "Payment" button. You investigate and find a 3rd-party payment gateway API error that standard server monitoring missed.

---

### Summary of Skills You Gain in This Section:
1.  **Custom Querying:** You stop relying on default views and start asking specific questions using dimensions and metrics.
2.  **DQL Fluency:** You learn the language needed for the future of Dynatrace (Grail).
3.  **Storytelling:** You learn to present data in a way that proves business value, not just server uptime.
