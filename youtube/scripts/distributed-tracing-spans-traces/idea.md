# Distributed Tracing: What Are Spans and Traces?

**Category**: DevOps / Observability
**Difficulty**: Beginner
**Estimated Duration**: 60 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: software/observability/001-introduction-to-observability.md

---

## Introduction

In a monolith, debugging is simple — one log file, one process. In a microservices architecture a single user request can touch dozens of services, and when it fails you have no idea where it broke. Distributed tracing solves this by attaching a unique ID to each request and recording every service hop as a structured unit called a span, giving you a complete end-to-end picture of what happened.

---

## Body

### Key Points to Cover
1. What a trace is: a trace represents the entire lifecycle of one request across all services. Every trace has a globally unique Trace ID that is propagated through HTTP headers (e.g., `traceparent`) as the request crosses service boundaries.
2. What a span is: a span is one unit of work within a trace — for example, "authenticate user", "query database", or "call payment service". Each span records its start time, duration, service name, and status.
3. How spans compose into a trace: spans are linked parent-to-child to form a tree. The root span is the entry point (e.g., the API gateway call); child spans are the downstream work it triggered. Visualising this tree immediately shows which service added the most latency.
4. Why this beats logs alone: logs tell you what happened inside one service. A trace tells you how long each service took relative to all the others, making it trivial to identify the bottleneck.

### Suggested Code Examples / Demos
- Show a simple OpenTelemetry instrumentation snippet creating a span in Node.js or Python.
- Show a Jaeger or Tempo UI with a flame graph of a slow request, highlighting the span that caused the latency.
- Show the `traceparent` header being forwarded between services.

### Common Pitfalls / Misconceptions
- Not propagating the trace context header across service calls — breaks the trace chain and produces orphaned spans.
- Only instrumenting one service — partial traces are better than none, but you lose the cross-service view that makes tracing valuable.
- Confusing tracing with logging — logs and traces are complementary; traces show where latency lives, logs show why.
- Sampling everything in high-traffic production — 100% trace sampling can be cost-prohibitive; use head-based or tail-based sampling strategies.

---

## Conclusion / Footer

Key takeaway: a trace is the story of one request; a span is a single chapter of that story. Together they turn a distributed system's "murder mystery" into a timeline. Viewer challenge: instrument one service with OpenTelemetry today and view a trace in Jaeger or your observability platform.

---

## Notes for Production
- Thumbnail idea: a flame graph or waterfall chart with one bright red span standing out.
- Related videos: the three pillars of observability, OpenTelemetry setup, Prometheus vs Jaeger.
- OpenTelemetry is the vendor-neutral standard — mention Jaeger, Tempo, and Honeycomb as common backends.
