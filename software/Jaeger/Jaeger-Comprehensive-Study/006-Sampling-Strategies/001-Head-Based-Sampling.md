Based on the Table of Contents provided, here is a detailed explanation of **Part VI: Sampling Strategies**, specifically section **A. Head-Based Sampling**.

---

### What is Head-Based Sampling?

In distributed tracing, generating a trace for **every single request** (100% sampling) is often too expensive in terms of storage, network bandwidth, and CPU processing. You need a way to select a representative subset of traces to analyze.

**Head-Based Sampling** means the decision to sample (keep) or discard a trace is made at the very beginning of the request lifecycle—at the **"Head"** of the trace (the root span).

**How it works:**
1.  A user makes a request to your frontend (Service A).
2.  Service A (the "Head") decides immediately: "I will record this trace" OR "I will ignore this trace."
3.  **Context Propagation:** Service A attaches this decision (a sampled flag) to the request headers when calling Service B and C.
4.  Service B and C simply obey the flag. If Service A said "record," they record. If Service A said "drop," they do nothing.

Here are the four specific strategies listed in your outline:

---

### 1. Constant Sampling
This is the simplest binary approach. It acts like a master switch.

*   **Mechanism:** You configure the sampler to be either `1` (True) or `0` (False).
*   **param=1:** Sample **100%** of traces. Every request is recorded.
*   **param=0:** Sample **0%** of traces. No requests are recorded.
*   **When to use:**
    *   **Development/Testing:** When you are running a local test and want to see exactly what happened, you turn on 100% sampling.
    *   **Low Traffic:** If your system only gets a few requests per minute, you might as well keep all of them.
    *   **Emergency Debugging:** You briefly turn on 100% sampling in production to catch a specific bug (risky due to performance overhead).

### 2. Probabilistic Sampling
This strategy uses simple math to select a percentage of traces. It is "fair" but random.

*   **Mechanism:** You define a sampling rate between 0.0 and 1.0.
*   **Example:** If you set the rate to `0.1` (10%), the sampler effectively "flips a 10-sided coin" for every incoming request.
    *   1 request is kept.
    *   9 requests are dropped.
*   **Pros:** It provides a statistically accurate representation of your system's latency and error rates without storing petabytes of data.
*   **Cons:** You might miss a rare error. If an error happens in 1 out of 10,000 requests, and you are only sampling 1 out of 100 requests, you will likely miss the error entirely.
*   **When to use:** High-traffic production environments where you care about aggregate performance trends.

### 3. Rate Limiting Sampling
This strategy focuses on keeping a steady maximum volume of data, rather than a percentage.

*   **Mechanism:** You define a maximum number of traces per second (e.g., `5 traces/second`).
*   **How it works:** It uses a "leaky bucket" algorithm. The sampler allows the first 5 traces in that second to pass. Any subsequent request arriving in that same second is dropped until the next second starts.
*   **Pros:** It guarantees that your storage and network won't be overwhelmed, even during a massive traffic spike (DDoS or Black Friday). It makes costs predictable.
*   **Cons:** During a traffic spike, you are sampling a much smaller *percentage* of traffic, meaning you have less visibility exactly when you might need it most.
*   **When to use:** When you have strict budget constraints on storage backend (Elasticsearch/Cassandra) resources.

### 4. Guaranteed Throughput Sampling
This is a **hybrid** strategy (Probabilistic + Lower Bound) and is often the default "smart" choice in Jaeger.

*   **The Problem it Solves:**
    *   If you use *Probabilistic (0.1%)* on a low-traffic service, you might go hours without seeing a single trace.
    *   If you use *Rate Limiting*, you might miss trends during high traffic.
*   **Mechanism:** It combines two rules:
    1.  **Lower Bound:** "Guarantee that I keep at least `N` traces per second" (e.g., 2 traces/sec).
    2.  **Probability:** "If traffic is high enough that we exceed the lower bound, switch to sampling `X%` of traffic" (e.g., 0.1%).
*   **Result:**
    *   **Low Traffic:** You get at least a few traces so the system doesn't look "dead" in the dashboard.
    *   **High Traffic:** You get a statistically significant percentage of traffic for analysis.
*   **When to use:** This is the recommended strategy for most production microservices architectures as it balances visibility with cost automatically.

### Summary Comparison

| Strategy | Logic | Best For |
| :--- | :--- | :--- |
| **Constant** | All or Nothing | Local Dev, Debugging |
| **Probabilistic** | X% of traffic (Random) | High volume production analysis |
| **Rate Limiting** | Max X traces per sec | Cost control, protecting storage |
| **Guaranteed Throughput** | At least X traces/sec, then Y% | General purpose production |
