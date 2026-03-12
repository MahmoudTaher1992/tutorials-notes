# DevOps Engineering Study Guide - Part 10: Phase 1 — SRE, Chaos & Service Mesh

## 11.0 Artifact Management

### 11.1 Registry Architecture
#### 11.1.1 Container Registry
- 11.1.1.1 OCI Distribution Spec — registry API — push/pull — content-addressable
  - 11.1.1.1.1 Image manifest — JSON — references config blob + layer blobs by digest
  - 11.1.1.1.2 OCI Artifact — generic — Helm charts / Wasm / SBOM in registry
- 11.1.1.2 Registry proxying — cache upstream — reduce pull failures + egress cost
  - 11.1.1.2.1 Pull-through cache — Docker Hub proxy — avoid rate limits
  - 11.1.1.2.2 Air-gap registry — copy images before deploy — no internet at runtime
- 11.1.1.3 Garbage collection — remove unreferenced blobs — reclaim storage
  - 11.1.1.3.1 Mark phase — find all referenced blobs — from manifests
  - 11.1.1.3.2 Sweep phase — delete unreferenced blobs — safe after mark

#### 11.1.2 Artifact Versioning & Promotion
- 11.1.2.1 Immutable tags — once pushed never overwrite — :sha-abc123 — safe
  - 11.1.2.1.1 :latest anti-pattern — mutable — unpredictable — avoid in prod
  - 11.1.2.1.2 Digest pinning — FROM image@sha256:... — reproducible builds
- 11.1.2.2 Promotion pipeline — build once — promote same artifact through envs
  - 11.1.2.2.1 Dev registry → Staging registry → Prod registry — scan at each stage
  - 11.1.2.2.2 Tag with env — image:1.2.0-staging → image:1.2.0 — promote on approval

---

## 12.0 SRE & Reliability Engineering

### 12.1 Error Budgets & Toil Reduction
#### 12.1.1 Error Budget Management
- 12.1.1.1 Error budget burn rate — how fast consuming budget — alert on fast burn
  - 12.1.1.1.1 1-hour window burn rate > 14x — page immediately — critical
  - 12.1.1.1.2 6-hour window burn rate > 6x — ticket + investigation — urgent
- 12.1.1.2 Error budget policies — documented decisions when budget depleted
  - 12.1.1.2.1 Freeze feature work — 100% reliability work until budget restored
  - 12.1.1.2.2 Postmortem required — every budget depletion — learning + action

#### 12.1.2 Toil Definition & Reduction
- 12.1.2.1 Toil — manual, repetitive, automatable, reactive — no enduring value
  - 12.1.2.1.1 Measure toil — % on-call time — track in tickets — quantify
  - 12.1.2.1.2 Toil budget — max 50% toil — rest on engineering — SRE principle
- 12.1.2.2 Automation targets — runbooks → scripts → self-healing automation
  - 12.1.2.2.1 Runbook automation — script every runbook step — reduce human action
  - 12.1.2.2.2 Auto-remediation — alert → trigger playbook → fix without human

### 12.2 Incident Management
#### 12.2.1 Incident Response Framework
- 12.2.1.1 Incident classification — SEV1 (all users) / SEV2 (partial) / SEV3 (minor)
  - 12.2.1.1.1 SEV1 — immediate page — incident commander + comms lead + tech lead
  - 12.2.1.1.2 War room — Slack channel or bridge — single source of comms — time-box
- 12.2.1.2 Incident commander role — coordinate — not fix — delegate — status updates
  - 12.2.1.2.1 5-min status cadence — internal stakeholders — prevent noise channels
  - 12.2.1.2.2 Customer communication — status page update within 15 min of SEV1
- 12.2.1.3 Runbooks — step-by-step — linked from alert — reduce MTTR
  - 12.2.1.3.1 Runbook structure — symptoms + investigation steps + mitigation + escalation

#### 12.2.2 Postmortems
- 12.2.2.1 Blameless postmortem — psychological safety — systems not people
  - 12.2.2.1.1 Timeline — chronological — what happened + who noticed + actions taken
  - 12.2.2.1.2 Contributing factors — 5 Whys — Ishikawa diagram — root cause chain
- 12.2.2.2 Action items — SMART — owner + due date — tracked to completion
  - 12.2.2.2.1 Action prioritization — by impact on MTTR / recurrence — SLO-aware

### 12.3 Chaos Engineering
#### 12.3.1 Chaos Principles
- 12.3.1.1 Hypothesis-driven — define steady state — inject fault — observe delta
  - 12.3.1.1.1 Steady state — SLI metric — RPS + error rate + latency — measurable
  - 12.3.1.1.2 Blast radius — start small — single instance — expand gradually
- 12.3.1.2 Fault types — pod kill / network partition / latency inject / CPU stress
  - 12.3.1.2.1 Pod kill — kill random pod — test restarts + load shift
  - 12.3.1.2.2 Network partition — block egress to dependency — test circuit breaker
  - 12.3.1.2.3 Latency injection — add 500ms to service call — test timeout handling
  - 12.3.1.2.4 CPU/memory stress — exhaust resource — test autoscaling + throttling

---

## 13.0 Service Mesh

### 13.1 Service Mesh Architecture
#### 13.1.1 Data Plane / Control Plane
- 13.1.1.1 Data plane — sidecar proxies (Envoy) — intercept all pod traffic — L7
  - 13.1.1.1.1 iptables intercept — init container — redirect port 15001 → Envoy
  - 13.1.1.1.2 Envoy xDS — dynamic config from control plane — LDS/RDS/CDS/EDS
- 13.1.1.2 Control plane — configure proxies — cert distribution — policy enforcement
  - 13.1.1.2.1 Pilot — service discovery → Envoy EDS/CDS — route config
  - 13.1.1.2.2 Citadel — cert authority — issue mTLS certs — SPIFFE/SPIRE

#### 13.1.2 mTLS, Traffic Management & Observability
- 13.1.2.1 mTLS — mutual TLS — SPIFFE SVIDs — zero-trust pod-to-pod
  - 13.1.2.1.1 STRICT mode — enforce mTLS — block non-TLS — full zero-trust
  - 13.1.2.1.2 PERMISSIVE mode — accept both — migration phase — then enforce
- 13.1.2.2 Traffic management — VirtualService + DestinationRule — weighted routing
  - 13.1.2.2.1 Canary — weight: 10 to v2 — 90 to v1 — increment gradually
  - 13.1.2.2.2 Fault injection — HTTPFaultInjection — delay + abort — chaos in mesh
  - 13.1.2.2.3 Circuit breaker — outlier detection — eject unhealthy — 5xx rate
- 13.1.2.3 Observability — golden signals — automatic — no code change
  - 13.1.2.3.1 Envoy metrics — upstream_rq_total / upstream_rq_5xx / rq_time — Prometheus
  - 13.1.2.3.2 Distributed traces — Envoy generates spans — propagates B3 / W3C headers
