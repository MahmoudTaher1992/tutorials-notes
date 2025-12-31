Here is the detailed explanation of **Part III: Metrics & Aggregation — Section B: Aggregation and Temporality**.

While "Instruments" (Section A) determine how you *record* data in your code, **Aggregation and Temporality** determine how that data is *calculated and transmitted* to the backend. This is often the source of confusion when graphs look "weird" (e.g., a sawtooth pattern instead of a smooth line).

---

## B. Aggregation and Temporality

### 1. Delta vs. Cumulative Temporality

Temporality defines the mathematical relationship between the current data point and the previous one. It answers the question: *"Does this number represent the total since the app started, or just what happened in the last minute?"*

*   **Cumulative Temporality (The "Odometer"):**
    *   *Definition:* The value represents the total sum since the application started.
    *   *Example:*
        *   Time 12:00 -> Count: 10
        *   Time 12:01 -> Count: 25 (15 new events occurred, but we report the total 25).
        *   Time 12:02 -> Count: 30.
    *   *Who likes it:* **Prometheus**. Prometheus is designed to scrape cumulative counters. It calculates the rate of change itself (`rate()` function).
    *   *Pros:* Resilient to data loss. If the scraper goes down for 5 minutes, the next scrape will pick up the correct total, and you won't lose the count of what happened during the outage.

*   **Delta Temporality (The "Trip Counter"):**
    *   *Definition:* The value represents the change (increment) since the last export. The counter resets to zero after every export.
    *   *Example:*
        *   Time 12:00 -> Count: 10 (10 events happened).
        *   Time 12:01 -> Count: 15 (15 *new* events happened).
        *   Time 12:02 -> Count: 5.
    *   *Who likes it:* **Datadog, New Relic**, and most push-based systems.
    *   *Pros:* Easier to sum up across dimensions without knowing the history.
    *   *Cons:* If a packet is dropped, that data is gone forever.

*   **The OTel Role:** The OTel SDK allows you to convert between these. You can record data in your code, and the **Exporter** decides whether to send it as Delta or Cumulative based on what your backend expects.

### 2. Aggregation Types

When you record raw measurements (e.g., 1000 requests in a minute), OTel does not send 1000 individual numbers to the backend. That would be too expensive. It **Aggregates** them in memory first.

*   **Sum Aggregation:**
    *   Used for Counters. It simply adds the values together.
    *   *Result:* "15 requests" or "Total: 500 bytes".
*   **Last Value Aggregation:**
    *   Used for Gauges. It discards old values and only keeps the most recent one.
    *   *Result:* "CPU is 40%." (We don't care that it was 39% a millisecond ago).
*   **Explicit Bucket Histogram:**
    *   Used for Latency.
    *   *The Problem:* To calculate a P99 (99th percentile), you need the distribution.
    *   *The Solution:* You define specific boundaries (Buckets).
    *   *Example Buckets:* `[0-10ms, 10-100ms, 100-1000ms, >1000ms]`.
    *   *Logic:* If a request takes 50ms, the count for the `10-100ms` bucket increases by 1.
    *   *Drawback:* You must guess the boundaries beforehand. If you set your max bucket to `>500ms`, and your app gets slow (5 seconds), you won't distinguish between 600ms and 10 seconds because they all fall into the same top bucket.

### 3. Exponential Histograms (High-Fidelity, Low-Cost)

This is a modern OpenTelemetry feature designed to solve the "guessing buckets" problem.

*   **How it works:** Instead of you manually defining `[10, 50, 100]`, the SDK uses an algorithm based on powers of 2 (logarithmic scale) to automatically create buckets.
*   **Precision:** It creates many small buckets. It allows you to calculate P99 or P99.9 with extremely high accuracy and very low error margins.
*   **Efficiency:** Despite having "more" buckets, the data structure is compressed efficiently on the wire.
*   **Requirement:** Your backend database (e.g., Prometheus, Honeycomb) must support OTel Exponential Histograms to read this data.

### 4. Cardinality Explosion Risks

This is the most dangerous aspect of Metrics in OTel. It is the #1 reason for massive cloud bills and crashed monitoring databases.

*   **The Math:** Metrics are stored as unique time series. A new time series is created for every unique combination of Attribute Values.
    *   Formula: `(Unique HTTP Methods) * (Unique Regions) * (Unique Status Codes) * (Unique UserIDs)`
*   **The Explosion:**
    *   Attributes: `method` (4 values), `region` (5 values), `status` (5 values). Total series: $4 \times 5 \times 5 = 100$. This is fine.
    *   **The Mistake:** You decide to add `user_id` as an attribute to your metric. You have 1 million users.
    *   New Total: $100 \times 1,000,000 = 100,000,000$ unique time series.
*   **The Result:** Your database (Prometheus/Cortex/Mimir) runs out of RAM and crashes, or your vendor sends you a bill for thousands of dollars.
*   **The Rule:** **Never** put high-cardinality data (IDs, GUIDs, Emails, URLs with query parameters) into Metric Attributes. That data belongs in **Traces** or **Logs**, not Metrics.