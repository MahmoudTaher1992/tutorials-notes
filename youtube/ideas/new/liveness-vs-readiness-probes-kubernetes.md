# Liveness vs. Readiness Probes in Kubernetes: Getting Them Wrong Causes Outages

**Category**: DevOps / Kubernetes
**Difficulty**: Intermediate
**Estimated Duration**: 60-90 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: `software/k8s/general.md` — Part V.C, Resource Health Probes (Liveness, Readiness, Startup)

---

## Introduction
Misconfiguring Kubernetes health probes is one of the most common causes of self-inflicted outages. Most tutorials treat liveness and readiness as interchangeable — they are not, and confusing them leads to either healthy pods being repeatedly restarted or broken pods silently receiving live traffic.

---

## Body

### Key Points to Cover
1. Liveness probe — answers "are you alive?": if it fails, Kubernetes restarts the container; use this to detect a deadlock or infinite loop state the app cannot recover from on its own
2. Readiness probe — answers "are you ready to serve traffic?": if it fails, Kubernetes removes the pod from the Service's load balancer endpoints without restarting it; use this during startup or while the app is temporarily busy
3. The critical danger of a misconfigured liveness probe — if the threshold is too low or the endpoint is too slow under load, Kubernetes starts restarting healthy pods under traffic spikes, creating a restart cascade that looks like an outage
4. The right pattern — readiness probe should fail during startup (preventing premature traffic); liveness probe should only fail for truly unrecoverable states
5. Bonus: the startup probe — disables liveness and readiness checks until the app has finished its initial startup, preventing restart loops for slow-starting apps

### Suggested Code Examples / Demos
- YAML snippet for a readiness probe: HTTP GET on `/health/ready` with generous `initialDelaySeconds`
- YAML snippet for a liveness probe: HTTP GET on `/health/live` with conservative failure thresholds
- Show `kubectl describe pod` output with probe failure events to help viewers recognise the failure pattern in the wild

### Common Pitfalls / Misconceptions
- Using the same endpoint for both probes — liveness and readiness should check different conditions; a DB connection failure might make a pod not ready but it does not mean the app needs a restart
- Setting `initialDelaySeconds` too low — the app is still starting up when the probe fires, causes an immediate restart loop
- No probes at all — Kubernetes sends traffic to pods the moment they start, even before the app is listening

---

## Conclusion / Footer
Liveness = restart if broken beyond recovery. Readiness = remove from traffic if temporarily not ready. Never use the same endpoint or thresholds for both. If your pods are mysteriously restarting under load, check your liveness probe configuration first.

---

## Notes for Production
- Thumbnail idea: two traffic lights — red "RESTART" (liveness) and amber "HOLD TRAFFIC" (readiness)
- Related video to mention: Kubernetes Deployments and rolling updates, resource requests and limits
- Reference: Kubernetes official docs on pod lifecycle
