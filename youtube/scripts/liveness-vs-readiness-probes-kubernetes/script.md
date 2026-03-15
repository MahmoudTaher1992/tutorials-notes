# Kubernetes Probes: Liveness vs Readiness

**Tone:** Serious / Educational
**Duration:** ~30 seconds

| Sentence | Type |
|----------|------|
| Misconfiguring Kubernetes health probes is a leading cause of outages. | Hook |
| Here is the difference between liveness and readiness probes. | Title Reveal |
| Liveness and readiness probes look similar but do completely different things. | Introduction |
| Liveness probe fails → Kubernetes restarts your container immediately. | Body – Point 1 |
| Readiness probe fails → Kubernetes stops routing traffic without restarting. | Body – Point 2 |
| A liveness probe set too aggressively will restart healthy pods under load. | Body – Point 3 |
| Use readiness to gate traffic; use liveness only for unrecoverable crashes. | Conclusion |
| If your pods restart under load, your liveness probe thresholds are wrong. | CTA |
