# Integration Patterns Complete Study Guide - Part 8: API Gateways & Service Mesh

## 13.0 API Gateways & Service Mesh

### 13.1 API Gateway Patterns
#### 13.1.1 Gateway Responsibilities
- 13.1.1.1 Request routing — match path/host/method → upstream service — L7 routing
  - 13.1.1.1.1 Path rewriting — /api/v1/users → /users — strip prefix — version abstraction
  - 13.1.1.1.2 Canary routing — route 5% traffic to new version — header-based — gradual rollout
  - 13.1.1.1.3 Blue/green switching — route all traffic to one version — instant cutover
- 13.1.1.2 Cross-cutting concerns — auth / rate limiting / caching / logging / tracing — offloaded
  - 13.1.1.2.1 JWT validation — verify signature + claims — 401 on fail — service skips auth logic
  - 13.1.1.2.2 Rate limiting — token bucket / sliding window — per IP / per client / per endpoint
  - 13.1.1.2.3 Request/response transformation — add/remove headers — body transformation — plugin
- 13.1.1.3 SSL/TLS termination — decrypt at gateway — internal plain HTTP — offloads cert management

#### 13.1.2 Kong
- 13.1.2.1 Nginx-based — declarative config — plugin architecture — open source + enterprise
  - 13.1.2.1.1 Plugins — key-auth / jwt / oauth2 / rate-limiting / proxy-cache / request-transformer
  - 13.1.2.1.2 Services + Routes — Service = upstream — Route = matching rule → Service
  - 13.1.2.1.3 Admin API — REST API to configure Kong — or declarative YAML (deck) — GitOps
- 13.1.2.2 Kong Gateway plugins pipeline — request → plugin chain → upstream → plugin chain → response

#### 13.1.3 AWS API Gateway
- 13.1.3.1 REST API — HTTP API — WebSocket API — three products — different features + cost
  - 13.1.3.1.1 HTTP API — lower cost — JWT auth — simpler routing — use for modern APIs
  - 13.1.3.1.2 REST API — full feature — request/response transform — API keys — usage plans
- 13.1.3.2 Integration types — Lambda / HTTP / AWS Service / Mock / VPC Link
  - 13.1.3.2.1 Lambda proxy — full request forwarded to Lambda — response from Lambda — simple
  - 13.1.3.2.2 VPC Link — connect API Gateway to private VPC services — NLB endpoint — secure
- 13.1.3.3 Stages + deployments — immutable deployment — stage variables — canary on stage

### 13.2 Service Mesh
#### 13.2.1 Sidecar Proxy Pattern
- 13.2.1.1 Sidecar — proxy container per pod — intercept all inbound/outbound traffic — transparent
  - 13.2.1.1.1 iptables rules — redirect traffic to sidecar — no app code change — automatic
  - 13.2.1.1.2 Envoy proxy — L4/L7 proxy — Istio data plane — xDS config API — dynamic config

#### 13.2.2 Istio
- 13.2.2.1 Control plane — istiod — push config to Envoy sidecars via xDS — centralized policy
  - 13.2.2.1.1 Pilot — service discovery + routing rules → Envoy CDS/LDS/RDS/EDS — live config
  - 13.2.2.1.2 Citadel (now istiod) — cert management — SPIFFE mTLS — automatic rotation
- 13.2.2.2 Traffic management — VirtualService + DestinationRule — fine-grained routing control
  - 13.2.2.2.1 VirtualService — HTTP match rules — weight-based routing — fault injection — retries
  - 13.2.2.2.2 DestinationRule — subsets (v1/v2) — load balancing policy — circuit breaker — TLS mode
  - 13.2.2.2.3 Fault injection — inject 5s delay or 500 error — chaos testing — resilience validate
- 13.2.2.3 Observability — automatic metrics + traces + access logs — no app instrumentation
  - 13.2.2.3.1 Prometheus metrics — request rate / error rate / latency — golden signals per service
  - 13.2.2.3.2 Distributed tracing — trace ID propagated by Envoy — Jaeger / Zipkin / Tempo

#### 13.2.3 Linkerd
- 13.2.3.1 Lightweight service mesh — Rust micro-proxy — lower overhead than Envoy — simpler ops
  - 13.2.3.1.1 mTLS automatic — no config needed — all pod-to-pod traffic encrypted — on by default
  - 13.2.3.1.2 HTTP/2 + gRPC first-class — retries + timeouts per route — golden metrics built-in
- 13.2.3.2 Service profiles — per-route metrics — retry budget — timeout — declare in CRD
  - 13.2.3.2.1 Retry budget — % of total requests retried — prevent retry storm — cap retries
