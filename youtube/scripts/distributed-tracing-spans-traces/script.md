# Distributed Tracing: What Are Spans and Traces?

**Tone:** Serious / Educational
**Duration:** ~60 seconds

| Sentence | Type |
|----------|------|
| Your microservices are failing and your logs tell you nothing useful. | Hook |
| This is distributed tracing — spans and traces — in 60 seconds. | Title Reveal |
| A trace tracks one user request as it crosses every service boundary. | Introduction |
| Every trace gets a unique ID that is forwarded through request headers. | Body – Point 1 |
| Each service hop creates a span — one unit of work with a duration. | Body – Point 2 |
| Spans link parent-to-child, forming a tree of your entire request. | Body – Point 2 |
| The tree instantly shows which service added the most latency. | Body – Point 3 |
| Logs tell you what happened inside one service — traces show the full picture. | Body – Point 3 |
| If you don't forward the trace header, the chain breaks and spans go orphaned. | Conclusion |
| Add OpenTelemetry to one service today and view its first trace. | CTA |
