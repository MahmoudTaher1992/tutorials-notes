Based on the Table of Contents you provided, here is a detailed explanation of **Part VI, Section B: Adaptive Sampling**.

---

# Detailed Explanation: Adaptive Sampling in Jaeger

**Adaptive Sampling** is one of the most powerful features in Jaeger. It solves the primary problem of standard "Head-Based" sampling: **Traffic Imbalance.**

In a standard distributed system, some endpoints receive massive traffic (e.g., `GET /health` or `GET /status`), while others receive very little but critical traffic (e.g., `POST /checkout` or `POST /refund`).

If you use a fixed sampling rate (e.g., 10%) for everything:
1.  **High-volume endpoints:** You will collect thousands of useless traces, clogging your storage.
2.  **Low-volume endpoints:** You might miss the one critical trace you actually need to debug a problem.

**Adaptive Sampling automates the adjustment of sampling rates per endpoint (operation) to ensure you get a consistent number of traces across the board.**

---

## 1. How the Feedback Loop Works

Adaptive sampling introduces a **feedback loop** between the backend (Collector) and the application (Client/Agent). It changes the decision-making process from "Static" to "Dynamic."

### The Workflow:
1.  **Reporting:** All Jaeger Clients (in your microservices) periodically send throughput data to the Jaeger Collector. They say, *"I am Service A, and I am seeing 100 requests/second for the `/login` operation."*
2.  **Calculation:** The Jaeger Collector aggregates this data. It has a configuration target, usually defined as **"Target Traces Per Second"** (e.g., keep 1 trace per second per operation).
3.  **Adjustment:**
    *   If `/login` has 100 req/s, and the target is 1 trace/s, the Collector calculates a sampling probability of **1% (0.01)**.
    *   If `/checkout` has 0.5 req/s, and the target is 1 trace/s, the Collector calculates a probability of **100% (1.0)**.
4.  **Instruction:** The Collector sends these specific probabilities back to the Client (usually via the Jaeger Agent sidecar).
5.  **Execution:** The Client updates its internal sampling logic in real-time.

## 2. Per-Operation Granularity

The defining characteristic of Adaptive Sampling is that it calculates rates **per operation**, not just per service.

### Scenario: The "Payment Service"
Imagine a Payment Service with two operations:

| Operation | Traffic Volume | Importance | Without Adaptive (Fixed 10%) | With Adaptive (Target 1 trace/sec) |
| :--- | :--- | :--- | :--- | :--- |
| **`GET /health`** | 1,000 req/s | Low (Noise) | **100 traces/s** (Storage Spam) | **0.1%** (1 trace/s) |
| **`POST /pay`** | 2 req/s | High (Revenue) | **0.2 traces/s** (Data Loss) | **50%** (1 trace/s) |

**Result:** With Adaptive Sampling, you stop flooding your database with health checks, and you capture almost every payment request, ensuring you have data when a transaction fails.

## 3. Configuration & Architecture

To enable Adaptive Sampling, the architecture requires specific components to talk to each other.

### The Components
1.  **The Client (Application):** Must be configured to use `Remote` sampling. It polls the backend for strategies.
2.  **The Agent:** Proxies the sampling strategies from the Collector to the Client.
3.  **The Collector:** The "Brain." It tracks the history of traffic volume in memory and calculates the new probabilities.

### Key Configuration Parameters
In the Jaeger Collector configuration, you typically tweak these values:
*   **`sampling.target-samples-per-second`**: The goal. (Default is often 1). If an endpoint gets less traffic than this, it samples 100%. If it gets more, the rate is lowered to meet this target.
*   **`sampling.initial-sampling-probability`**: What rate should a new service use before the Collector has enough data to calculate an adaptive rate? (e.g., start at 0.001).
*   **`sampling.min-sampling-probability`**: The floor. Never sample less than this (to ensure at least *some* data is always caught).

## 4. Advantages & Trade-offs

### Advantages
*   **Cost Efficiency:** Drastically reduces storage costs by ignoring high-frequency, low-value traffic.
*   **Observability:** Guarantees visibility into low-frequency, high-value endpoints.
*   **Automation:** No need to manually deploy configuration changes to services when traffic patterns change (e.g., during Black Friday). The system auto-scales the sampling down as traffic goes up.

### Trade-offs / Complexity
*   **Memory Overhead:** The Collector must keep track of every operation for every service in memory to calculate rates. In massive environments with high cardinality (millions of unique operation names), this requires significant RAM.
*   **Latency:** There is a slight delay. If traffic spikes instantly from 1 to 10,000 req/s, it might take a minute for the Collector to recalculate and tell the Client to "slow down sampling," resulting in a temporary burst of stored traces.

## Summary

In the context of your Table of Contents, **Adaptive Sampling** is the "Smart Mode" of Head-Based sampling. It moves the intelligence from a static config file into the **Jaeger Collector**, allowing the system to self-regulate based on how busy specific parts of your application are.
