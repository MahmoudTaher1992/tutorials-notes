This section of the Table of Contents focuses on **Mental Models**.

When a system performs poorly, you have thousands of metrics available (CPU, memory, disk I/O, network packets, HTTP status codes, etc.). It is easy to get overwhelmed. **Analysis Frameworks** provide a systematic checklist to help you diagnose problems quickly without guessing.

Here is a detailed breakdown of the three industry-standard frameworks listed in your ToC.

---

### 1. The USE Method
**Creator:** Brendan Gregg (Netflix, Intel)
**Best For:** Analyzing **Resources** (Physical Hardware & Operating System components).

If you are debugging a server, a database, or a Docker container, and you want to know "Is the hardware the bottleneck?", you use the USE method. You apply these three checks to every resource (CPU, Memory, Disk, Network).

*   **U - Utilization:** The percentage of time the resource was busy doing work.
    *   *Example:* The CPU is running at 90%.
    *   *Interpretation:* 100% utilization is not necessarily bad (it means you are getting your money's worth), but it suggests you have no room for more work.
*   **S - Saturation:** The degree to which extra work is queued (waiting) because the resource is busy.
    *   *Example:* The CPU is at 100%, and the "Run Queue" (processes waiting for a turn) is growing.
    *   *Interpretation:* **This is the killer.** High utilization + High saturation = Performance degradation. If utilization is high but saturation is zero, the system might still be responsive.
*   **E - Errors:** The count of error events.
    *   *Example:* Disk read errors, dropped network packets, or "Out of Memory" (OOM) kills.
    *   *Interpretation:* Errors are usually immediate red flags that hardware is failing or misconfigured.

**How to apply it:**
> "I will check the CPU: Is it utilized? Is it saturated? Are there errors? Now I will check the Disk: Utilized? Saturated? Errors?"

---

### 2. The RED Method
**Creator:** Tom Wilkie (Grafana Labs)
**Best For:** Analyzing **Microservices** (Request-driven applications).

While USE looks at the *hardware*, RED looks at the *software service* and how it feels to the user. This is standard for API developers and is usually visualized in dashboards (Prometheus/Grafana).

*   **R - Rate:** The number of requests per second (Traffic).
    *   *Why it matters:* You need to know if a performance drop corresponds with a spike in traffic.
*   **E - Errors:** The number of requests that failed.
    *   *Why it matters:* Usually measured as a percentage of total traffic. Are we returning HTTP 500s?
*   **D - Duration:** The amount of time requests take (Latency).
    *   *Why it matters:* This is usually measured in distributions (P50, P90, P99) rather than averages. (e.g., "99% of requests finish in under 200ms").

**How to apply it:**
> "My users are complaining. Let's look at the RED dashboard. The **Rate** is normal, **Errors** are zero, but **Duration** (P99) has spiked from 200ms to 2 seconds. We have a latency issue, not a crash."

---

### 3. The Four Golden Signals
**Creator:** Google (SRE Book)
**Best For:** General **Distributed Systems Monitoring** (The "God View").

This is the grandfather of the RED method. It is slightly more comprehensive because it brings the concept of "Saturation" back into the service layer.

1.  **Latency:** The time it takes to service a request.
    *   *Nuance:* You should track latency for successful requests separately from failed requests (an error might return instantly, skewing your average speed).
2.  **Traffic:** A measure of how much demand is being placed on your system.
    *   *Examples:* HTTP requests per second, or I/O bandwidth for a video streaming service.
3.  **Errors:** The rate of requests that fail.
    *   *Nuance:* Includes explicit errors (HTTP 500), implicit errors (HTTP 200 but wrong content), and policy errors (response took > 1s).
4.  **Saturation:** How "full" is your service?
    *   *Difference from USE:* In USE, saturation is a hardware queue. In Golden Signals, saturation is a measure of the most constrained resource (e.g., "We are using 80% of our database connection pool" or "We are using 90% of our allocated memory").
    *   *Why it matters:* It predicts *when* the system will fail. If latency is fine now, but Saturation is 99%, the system will crash if traffic increases by even 1%.

---

### Summary Comparison

| Framework | Focus Area | The "Mantra" | When to use |
| :--- | :--- | :--- | :--- |
| **USE** | **Internal Resources** (CPU, Disk, RAM) | Utilization, Saturation, Errors | Debugging a slow Linux server or Database instance. |
| **RED** | **External Users** (APIs, Web Apps) | Rate, Errors, Duration | Monitoring Microservices; checking User Experience. |
| **Golden Signals** | **System Health** (SRE / DevOps) | Latency, Traffic, Errors, Saturation | High-level alerting and capacity planning. |
