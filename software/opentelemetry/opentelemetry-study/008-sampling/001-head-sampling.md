Here is a detailed explanation of **Part VIII, Section A: Head Sampling (Client-Side)**.

This guide corresponds to the file path `software/OpenTelemetry/OpenTelemetry-Study/008-Sampling/001-Head-Sampling.md`.

---

# Head Sampling (Client-Side)

In distributed systems, generating a Trace for every single request (100% sampling) is often too expensive in terms of storage, network bandwidth, and CPU processing. **Sampling** is the process of selecting a subset of traces to record and export, discarding the rest.

**Head Sampling** is the technique where the decision to sample (keep) or drop a trace is made **at the beginning (the "Head")** of the request lifecycle, usually within the application's SDK.

## 1. The Core Concept

Imagine a nightclub.
*   **Head Sampling** is the bouncer at the front door deciding who gets in. Once you are in, you are in. If you are rejected at the door, nothing inside is recorded about you.
*   **Tail Sampling** (the alternative) is letting everyone in, recording their behavior, and then deciding at the exit which records to keep based on what happened inside (e.g., "only keep records of people who started a fight").

In OpenTelemetry, Head Sampling happens effectively at the moment a root span is created.

### Why Head Sampling?
*   **Efficiency:** If the SDK decides *not* to sample a trace at the very beginning, it stops collecting data immediately. This saves CPU and memory overhead for the rest of that request's lifecycle.
*   **Simplicity:** It is stateless and requires no external coordination. The decision is made locally by the service.

---

## 2. Built-in Sampling Strategies

OpenTelemetry provides several standard samplers out of the box. You configure these when initializing the `TracerProvider`.

### A. AlwaysOn (Always Sample)
*   **Behavior:** Records 100% of traces. Every request results in a trace being sent to your backend.
*   **Return Decision:** `RecordAndSample`.
*   **Use Case:**
    *   Local development.
    *   Low-traffic services.
    *   Debugging a specific issue where you cannot afford to miss a single event.

### B. AlwaysOff (Never Sample)
*   **Behavior:** Records 0% of traces. No data is exported.
*   **Return Decision:** `Drop`.
*   **Use Case:**
    *   Disabling tracing temporarily without removing code.
    *   High-noise, low-value signals (e.g., a health-check endpoint that gets pinged every second).

### C. TraceIDRatioBased (Probabilistic)
*   **Behavior:** Samples a specific percentage of traces based on the `TraceID`.
*   **Configuration:** You provide a ratio (e.g., `0.1` for 10%, `0.01` for 1%).
*   **The Math:**
    *   The `TraceID` is a 128-bit random number.
    *   The sampler looks at the bits of the TraceID. If the ID is lower than the threshold determined by the ratio, it samples.
    *   **Deterministic:** Because it is based on the *ID* (not a random roll of dice per service), if Service A decides to sample Trace `123`, Service B (downstream) will inherently make the same decision if it uses the same logic, ensuring you don't get broken traces.
*   **Use Case:** High-traffic production systems where you want a statistically representative sample without blowing up your budget.

---

## 3. ParentBased Sampling (Respecting Context)

This is the most critical concept in distributed tracing.

If Service A calls Service B, they are part of the same Trace.
*   If Service A decides **NOT** to sample (drop), Service B should also drop.
*   If Service A decides **TO** sample, Service B should also sample.

If Service B ignores Service A's decision and makes its own random choice, you get **broken traces** (e.g., you see the database call, but not the API call that triggered it).

**`ParentBased`** is a composite sampler. It checks the **Context** (incoming HTTP headers) first.

### How `ParentBased` logic works:
1.  **Is there a parent span?** (Did this request come from another service?)
    *   **Yes, and Parent said SAMPLE:** $\rightarrow$ **SAMPLE** (Trust the parent).
    *   **Yes, and Parent said DROP:** $\rightarrow$ **DROP** (Trust the parent).
2.  **Is this a Root Span?** (No parent, the request started here)
    *   **Yes:** $\rightarrow$ Fallback to a "Root Sampler" (usually `TraceIdRatioBased` or `AlwaysOn`).

### The Standard Production Configuration
In 99% of production scenarios, you will use a combination of **ParentBased** and **TraceIdRatioBased**.

*   **Config:** `ParentBased(root=TraceIdRatioBased(0.1))`
*   **Result:**
    *   If a request hits the frontend (root), it has a 10% chance of being sampled.
    *   If it *is* sampled, that "sampled flag" is passed to the backend.
    *   The backend sees the flag, and `ParentBased` ensures it records the rest of the trace.

---

## 4. Configuration via Environment Variables

OpenTelemetry allows you to set these samplers without changing code, using the standard environment variables.

| Variable | Value Examples | Description |
| :--- | :--- | :--- |
| `OTEL_TRACES_SAMPLER` | `always_on` | Sample everything. |
| | `always_off` | Sample nothing. |
| | `traceidratio` | Use the ratio sampler (ignores parent context—dangerous for distributed apps). |
| | `parentbased_always_on` | Respect parent; if no parent, sample 100%. |
| | `parentbased_traceidratio` | **(Recommended)** Respect parent; if no parent, use ratio. |
| `OTEL_TRACES_SAMPLER_ARG` | `0.5` | The argument for the sampler. For ratio, this means 50%. |

**Example Production Config (Bash):**
```bash
export OTEL_TRACES_SAMPLER=parentbased_traceidratio
export OTEL_TRACES_SAMPLER_ARG=0.1
```

---

## 5. Pros and Cons of Head Sampling

### Pros
1.  **Low Overhead:** The most resource-efficient method. If a trace is dropped at the start, no CPU is wasted creating Span objects, serializing them, or transmitting them over the network.
2.  **Predictable Cost:** You can mathematically calculate your storage costs. If you have 10,000 requests/sec and sample at 1%, you know you will store 100 traces/sec.
3.  **Easy to Setup:** Configurable via environment variables with zero infrastructure changes.

### Cons
1.  **The "Interesting Error" Problem:** This is the biggest drawback.
    *   Imagine an error occurs 1 in 1,000 requests.
    *   You are sampling at 1% (1 in 100).
    *   Statistically, **you will likely miss the error.** The sampler decided to drop the trace *before* the error actually happened.
2.  **Rigidity:** You cannot make decisions based on the *result* of the request (latency, status code, specific attributes) because the decision happens before the request executes.

### Summary Table

| Feature | Details |
| :--- | :--- |
| **Decision Point** | Start of the request (Root Span creation). |
| **Performance** | High (Discards data early). |
| **Fidelity** | Low for rare events/errors. |
| **Complexity** | Low (Client-side only). |
| **Ideal For** | High-volume traffic, monitoring general trends, strict budget control. |