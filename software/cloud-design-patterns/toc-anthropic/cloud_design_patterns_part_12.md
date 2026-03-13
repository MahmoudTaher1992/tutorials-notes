# Cloud Design Patterns - Part 12: API & Service Integration (II)

## 6.0 API & Service Integration Patterns (continued)

### 6.5 Ambassador / Sidecar
#### 6.5.1 Pattern Intent
- 6.5.1.1 Co-located helper process handles cross-cutting network concerns on behalf of main process
- 6.5.1.2 Offload retry, circuit breaking, observability, mTLS from application code to sidecar
#### 6.5.2 Ambassador Pattern
- 6.5.2.1 Local proxy — application connects to localhost; ambassador handles upstream routing
  - 6.5.2.1.1 Use case — legacy app cannot be modified; ambassador adds modern networking features
- 6.5.2.2 Protocol bridging — ambassador converts HTTP to gRPC; app uses HTTP only
#### 6.5.3 Sidecar Pattern
- 6.5.3.1 Sidecar container in same Kubernetes pod — shares network namespace and lifecycle
  - 6.5.3.1.1 Envoy sidecar — all inbound/outbound traffic intercepted via iptables rules
- 6.5.3.2 Sidecar responsibilities — observability (traces, metrics, logs), auth, rate limiting
- 6.5.3.3 Sidecar lifecycle — injected automatically via MutatingAdmissionWebhook (Istio, Linkerd)
#### 6.5.4 Sidecar vs. Library
- 6.5.4.1 Library — in-process; lower latency; language-specific; harder to upgrade centrally
- 6.5.4.2 Sidecar — out-of-process; adds ~0.5-1ms per hop; language-agnostic; centrally upgradeable
- 6.5.4.3 Selection — polyglot environment favors sidecar; single-language stack may prefer library

### 6.6 Gateway Aggregation & Offloading
#### 6.6.1 Gateway Aggregation
- 6.6.1.1 Combine responses from multiple backend calls into a single response
  - 6.6.1.1.1 Reduces client round trips — one API call vs. N parallel client calls
- 6.6.1.2 Partial failure handling — return partial data if one backend fails (with degradation flag)
- 6.6.1.3 GraphQL as aggregation layer — client specifies exactly what data is needed
  - 6.6.1.3.1 DataLoader — batch and deduplicate downstream service calls within one GraphQL resolve
#### 6.6.2 Gateway Offloading
- 6.6.2.1 Authentication — validate tokens once at gateway; pass claims downstream as headers
- 6.6.2.2 SSL termination — centralize certificate management; reduce per-service complexity
- 6.6.2.3 Request validation — schema validation at gateway; reject malformed requests early
- 6.6.2.4 Response caching — gateway caches idempotent responses; reduces backend load
- 6.6.2.5 Logging and tracing — correlate all requests via trace ID injected at gateway

### 6.7 Service Mesh Architecture
#### 6.7.1 Service Mesh Concepts
- 6.7.1.1 Data plane — set of sidecar proxies that handle all service-to-service traffic
- 6.7.1.2 Control plane — manages and configures the data plane; distributes policies
  - 6.7.1.2.1 Istio control plane — istiod (Pilot, Citadel, Galley merged); xDS API
  - 6.7.1.2.2 Linkerd control plane — destination service, identity service, proxy injector
#### 6.7.2 Service Mesh Capabilities
- 6.7.2.1 mTLS — automatic mutual TLS between all services; zero-trust within cluster
  - 6.7.2.1.1 Certificate issuance — sidecar gets SVID from SPIRE/SPIFFE; auto-rotate before expiry
- 6.7.2.2 Traffic management — weighted routing, header matching, fault injection, traffic mirroring
  - 6.7.2.2.1 Istio VirtualService — define routing rules; DestinationRule — define subsets/policies
- 6.7.2.3 Observability — automatic L7 metrics, distributed traces, and access logs across all services
- 6.7.2.4 Resilience policies — circuit breaking, retry, timeout configured in mesh; no code changes
#### 6.7.3 Service Mesh Overhead
- 6.7.3.1 Latency addition — sidecar adds ~0.5-1ms per hop (sub-1% of p99 for most services)
- 6.7.3.2 Resource overhead — each Envoy sidecar consumes ~50-200MB RAM; significant at scale
- 6.7.3.3 Operational complexity — CRD proliferation; requires mesh expertise to operate
#### 6.7.4 Ambient Mesh (Istio Ambient)
- 6.7.4.1 Removes per-pod sidecar — moves L4 to ztunnel DaemonSet; L7 to waypoint proxies
- 6.7.4.2 Benefits — reduced resource consumption; no pod restart required for mesh enrollment
- 6.7.4.3 Waypoint proxies — L7 policies applied only where needed; not on every pod
#### 6.7.5 Service Mesh vs. API Gateway
- 6.7.5.1 Service mesh — east-west (internal service-to-service) traffic
- 6.7.5.2 API Gateway — north-south (external client → internal service) traffic
- 6.7.5.3 Dual use — Istio Ingress Gateway can serve both roles; or combine Istio + Kong/AWS APIM
