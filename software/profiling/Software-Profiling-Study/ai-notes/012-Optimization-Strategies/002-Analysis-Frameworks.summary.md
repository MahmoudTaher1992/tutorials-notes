Based on the material provided and your instructions in Prompt 3, here is the summary.

**Role:** I am your **Computer Systems Engineering Teacher**.

### 🌳 **Analysis Frameworks: Mental Models for Optimization**

*   **The Core Problem**
    *   **Information Overload** (When systems fail, you have thousands of metrics like CPU, memory, and I/O; it is easy to get overwhelmed).
    *   **The Solution: Analysis Frameworks** (These serve as systematic checklists to diagnose issues quickly without guessing).

*   **1. The USE Method**
    *   **Focus:** **Internal Resources / Hardware** (Used for checking physical limits like CPU, Memory, Disk, and Network).
    *   **Creator:** Brendan Gregg (Netflix/Intel).
    *   **The Checklist:**
        *   **U - Utilization** (How much time the resource is busy).
            *   (Example: CPU is running at 90%).
            *   (Interpretation: High utilization isn't always bad; it just means the machine is working hard).
        *   **S - Saturation** (The "Killer" Metric).
            *   **Definition:** (The degree to which work is queued/waiting because the resource is too busy to handle it).
            *   **Analogy:** (Think of the school cafeteria. If the lunch lady is busy 100% of the time [Utilization], that's fine. But if the line of students goes out the door [Saturation], that is a problem because people are waiting).
            *   **Rule:** **High Utilization + High Saturation = Performance Death**.
        *   **E - Errors** (Count of failure events).
            *   (Example: Disk read errors or "Out of Memory" crashes).
            *   (Interpretation: These are immediate red flags).

*   **2. The RED Method**
    *   **Focus:** **Microservices / User Experience** (Used for API developers to see how the software "feels" to the user).
    *   **Creator:** Tom Wilkie (Grafana).
    *   **The Checklist:**
        *   **R - Rate** (Traffic levels).
            *   (Number of requests per second).
        *   **E - Errors** (Failure rate).
            *   (Percentage of requests returning errors like HTTP 500).
        *   **D - Duration** (Latency).
            *   **Measurement:** (Do not use averages; use distributions like P99).
            *   (Example: "99% of requests finish in under 200ms").

*   **3. The Four Golden Signals**
    *   **Focus:** **Distributed Systems Monitoring** (The "God View" for Site Reliability Engineering).
    *   **Creator:** Google.
    *   **The Checklist:**
        *   **1. Latency** (Time taken to serve a request).
            *   (Nuance: Track successful requests separately from failed ones).
        *   **2. Traffic** (Demand placed on the system).
        *   **3. Errors** (Rate of failure).
            *   (Includes explicit errors and "policy" errors, like a response that was too slow).
        *   **4. Saturation** (How "full" the service is).
            *   **Difference from USE:** (In USE, saturation is a hardware queue. Here, it measures the most constrained resource, like a database connection pool).
            *   **Predictive Power:** (High saturation predicts *future* failure. If you are 99% full, a 1% increase in traffic will crash the system).

*   **Comparison Summary**
    *   **USE Method:**
        *   Best for: **Debugging deep infrastructure** (Linux servers, Databases).
        *   Check: Utilization, Saturation, Errors.
    *   **RED Method:**
        *   Best for: **Monitoring Services** (APIs, Web Apps).
        *   Check: Rate, Errors, Duration.
    *   **Golden Signals:**
        *   Best for: **High-level Alerting & Capacity Planning**.
        *   Check: Latency, Traffic, Errors, Saturation.
