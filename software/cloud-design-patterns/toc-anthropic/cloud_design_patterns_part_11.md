# Cloud Design Patterns - Part 11: API & Service Integration (I)

## 6.0 API & Service Integration Patterns

### 6.1 API Gateway
#### 6.1.1 Pattern Intent
- 6.1.1.1 Single entry point for all client requests — routes to appropriate backend services
- 6.1.1.2 Offload cross-cutting concerns from individual services to a central layer
#### 6.1.2 Core Gateway Responsibilities
- 6.1.2.1 Request routing — path/hostname/header-based routing to backend services
- 6.1.2.2 Authentication & authorization — verify JWT/API key before forwarding
  - 6.1.2.2.1 JWT validation at gateway — JWKS endpoint; signature, expiry, audience checks
- 6.1.2.3 Rate limiting & throttling — per-client quota enforcement before backend reaches load
- 6.1.2.4 TLS termination — decrypt TLS at gateway; internal traffic uses HTTP or mTLS
- 6.1.2.5 Request/response transformation — header injection, body translation, protocol normalization
#### 6.1.3 Gateway Offloading
- 6.1.3.1 SSL/TLS termination — centralized certificate management (ACM, cert-manager)
- 6.1.3.2 Caching — cache backend responses at gateway layer; reduce backend load
- 6.1.3.3 Compression — gzip/brotli response compression at gateway
- 6.1.3.4 Request logging & tracing — inject trace IDs; emit access logs for all requests
- 6.1.3.5 CORS handling — centralized cross-origin header management
#### 6.1.4 Gateway Aggregation
- 6.1.4.1 Combine multiple backend calls into single client response
  - 6.1.4.1.1 Reduces client-side chatty I/O — one gateway call replaces N service calls
- 6.1.4.2 Parallel fan-out — fire all backend calls concurrently; wait for all or fastest
  - 6.1.4.2.1 Timeout management — gateway timeout must be > slowest backend's p99
#### 6.1.5 Gateway Failure Modes
- 6.1.5.1 Gateway as single point of failure — requires multi-AZ/multi-region deployment
- 6.1.5.2 Gateway bottleneck — compute-intensive transformation can become throughput limit
- 6.1.5.3 Timeout misconfiguration — gateway timeout shorter than backend; orphaned backend calls
#### 6.1.6 Gateway Implementations
- 6.1.6.1 AWS API Gateway — REST/HTTP/WebSocket; Lambda integration; usage plans
  - 6.1.6.1.1 AWS API GW caching — response cache per stage; TTL configurable per method
- 6.1.6.2 Kong — Nginx-based; plugin ecosystem; declarative config or Admin API
- 6.1.6.3 Envoy + Emissary Ingress / Istio Gateway — Kubernetes-native; xDS-based config
- 6.1.6.4 Azure API Management (APIM) — policies in XML; developer portal; analytics

### 6.2 Backends for Frontends (BFF)
#### 6.2.1 Pattern Intent
- 6.2.1.1 Create separate backend gateway per client type (web, mobile, IoT, partner)
- 6.2.1.2 Optimize API shape, payload, and protocol for each client's specific needs
#### 6.2.2 Why BFF Over Shared API Gateway
- 6.2.2.1 Different data needs — mobile returns minimal fields; desktop returns full payloads
- 6.2.2.2 Different protocols — mobile uses REST/JSON; partner uses GraphQL or gRPC
- 6.2.2.3 Different release cadences — mobile BFF can deploy without affecting web clients
#### 6.2.3 BFF Responsibilities
- 6.2.3.1 Data aggregation — compose responses from multiple microservices
- 6.2.3.2 Data transformation — reshape, filter, and format data for client consumption
- 6.2.3.3 Client-specific auth flows — mobile uses PKCE; web uses session cookie; BFF owns the flow
#### 6.2.4 BFF Anti-patterns
- 6.2.4.1 Shared BFF — multiple teams sharing one BFF re-creates the shared-gateway problem
- 6.2.4.2 Logic leakage — BFF grows to contain domain logic that belongs in backend services
  - 6.2.4.2.1 Rule — BFF handles protocol/shape transformation; not business rules

### 6.3 Strangler Fig
#### 6.3.1 Pattern Intent
- 6.3.1.1 Incrementally replace a legacy system by growing a new system around it
- 6.3.1.2 Named after fig tree that grows around host tree; host eventually replaced
#### 6.3.2 Migration Phases
- 6.3.2.1 Phase 1: Intercept — route all traffic through facade/proxy in front of legacy
- 6.3.2.2 Phase 2: Divert — migrate functionality to new service; redirect subset of routes
  - 6.3.2.2.1 Feature flag routing — toggle between legacy and new per feature/user segment
- 6.3.2.3 Phase 3: Retire — remove legacy system once all routes migrated and stable
#### 6.3.3 Strangler Fig + Anti-Corruption Layer
- 6.3.3.1 ACL translates between legacy data model and new domain model at the seam
- 6.3.3.2 Prevents legacy concepts from polluting new bounded context
#### 6.3.4 Risk Mitigation
- 6.3.4.1 Parallel run — new and legacy process same requests; compare outputs for correctness
- 6.3.4.2 Dark launch — new service processes traffic silently; results not served to users yet
- 6.3.4.3 Incremental cutover — migrate one route per sprint; fast rollback path preserved

### 6.4 Anti-Corruption Layer (ACL)
#### 6.4.1 Pattern Intent
- 6.4.1.1 Translate between two domain models to prevent legacy concepts corrupting new model
- 6.4.1.2 Maintain clean bounded contexts when integrating with external/legacy systems
#### 6.4.2 ACL Components
- 6.4.2.1 Facade — unified interface shielding caller from downstream complexity
- 6.4.2.2 Adapter — converts external API/protocol to internal representation
- 6.4.2.3 Translator — maps external domain objects to internal domain objects
  - 6.4.2.3.1 Example — external "Customer" with legacy fields → internal "User" aggregate
#### 6.4.3 ACL Placement
- 6.4.3.1 Client-side ACL — consuming service wraps external calls in translation layer
- 6.4.3.2 Separate ACL service — dedicated integration service; owns the translation contract
- 6.4.3.3 Gateway-embedded ACL — transformation at API gateway (request/response mapping)
#### 6.4.4 ACL Testing Strategy
- 6.4.4.1 Contract tests — verify ACL output matches expected internal model
- 6.4.4.2 Consumer-driven contracts — Pact tests ensure ACL stays aligned with external API changes
