# Cloud Design Patterns - Part 14: Security & Identity (II)

## 7.0 Security & Identity Patterns (continued)

### 7.4 Gatekeeper Pattern
#### 7.4.1 Pattern Intent
- 7.4.1.1 Dedicated validation host — sanitizes and validates all requests before forwarding to backend
- 7.4.1.2 Backend services only reachable through gatekeeper — reduces attack surface
#### 7.4.2 Gatekeeper Responsibilities
- 7.4.2.1 Input validation — schema validation, size limits, type checking, injection prevention
  - 7.4.2.1.1 SQL injection prevention — parameterized queries only; never string concatenation
  - 7.4.2.1.2 XSS prevention — encode output; Content-Security-Policy header enforcement
- 7.4.2.2 Authentication enforcement — reject unauthenticated requests before they reach backend
- 7.4.2.3 Authorization pre-check — coarse-grained access control at gateway layer
- 7.4.2.4 Rate limiting — prevent abuse before reaching application logic
#### 7.4.3 Gatekeeper vs. API Gateway
- 7.4.3.1 API Gateway — routing + protocol + aggregation; security is one of many features
- 7.4.3.2 Gatekeeper — security-first; minimal functionality; hardened perimeter enforcement
#### 7.4.4 WAF Integration
- 7.4.4.1 Web Application Firewall — OWASP Top 10 rule sets; IP reputation; geo-blocking
  - 7.4.4.1.1 AWS WAF — managed rule groups; rate-based rules; Bot Control; Fraud Control
  - 7.4.4.1.2 Cloudflare WAF — edge-based; global IP reputation; L7 DDoS mitigation
- 7.4.4.2 WAF false positive management — tune rules per application; use COUNT mode before BLOCK

### 7.5 Secrets Management
#### 7.5.1 Pattern Intent
- 7.5.1.1 Store, distribute, and rotate sensitive credentials without hardcoding in code or config
- 7.5.1.2 Centralize secrets governance — audit who accessed what secret and when
#### 7.5.2 Secrets Storage Solutions
- 7.5.2.1 HashiCorp Vault — dynamic secrets, leases, auto-rotation; KV v2 with versioning
  - 7.5.2.1.1 Dynamic DB credentials — Vault generates short-lived DB user on request; no static creds
  - 7.5.2.1.2 Vault Agent — sidecar that authenticates to Vault and writes secrets to local file
- 7.5.2.2 AWS Secrets Manager — managed; native rotation Lambda; KMS encryption; resource policies
  - 7.5.2.2.1 Secret rotation — Lambda executes rotation on schedule; zero-downtime handshake
- 7.5.2.3 Azure Key Vault — secrets, keys, certificates; Managed Identity for access (no credentials)
- 7.5.2.4 GCP Secret Manager — versioned; IAM-controlled; automatic replication
#### 7.5.3 Secrets Injection Patterns
- 7.5.3.1 Environment variable injection — Kubernetes ExternalSecrets operator; secret sync at pod start
- 7.5.3.2 File-mounted secrets — secrets written to tmpfs volume; app reads file at startup
- 7.5.3.3 Direct SDK access — app calls Secrets Manager API at runtime; latest value always fetched
  - 7.5.3.3.1 Caching with TTL — avoid API rate limits; refresh before expiry
#### 7.5.4 Secret Rotation
- 7.5.4.1 Rotation cadence — short-lived credentials preferred over rotation of long-lived secrets
- 7.5.4.2 Zero-downtime rotation — dual-active period; both old and new credentials valid briefly
- 7.5.4.3 Rotation audit trail — log every access, issuance, and rotation event
#### 7.5.5 Anti-patterns to Avoid
- 7.5.5.1 Secrets in source code — scan with git-secrets, truffleHog, Semgrep pre-commit hooks
- 7.5.5.2 Secrets in environment variables at build time — leaked in image layers and CI logs
- 7.5.5.3 Shared service accounts — no attribution; use unique workload identities per service

### 7.6 mTLS & Certificate Lifecycle
#### 7.6.1 mTLS Fundamentals
- 7.6.1.1 Mutual TLS — both client and server present X.509 certificates; bidirectional authentication
- 7.6.1.2 Trust model — both sides verify certificate chain against trusted CA (internal PKI)
  - 7.6.1.2.1 SPIFFE/SPIRE — cloud-native PKI; issues SVIDs (X.509 JWTs) to workloads
#### 7.6.2 Certificate Issuance & Trust Chain
- 7.6.2.1 Root CA → Intermediate CA → Leaf certificate hierarchy
  - 7.6.2.1.1 Root CA offline — kept air-gapped; only signs intermediate CAs
- 7.6.2.2 Short-lived certificates — 24h or less; frequent rotation reduces revocation complexity
- 7.6.2.3 ACME protocol — automated cert issuance via Let's Encrypt or internal ACME server
  - 7.6.2.3.1 cert-manager (Kubernetes) — automates ACME issuance and renewal
#### 7.6.3 mTLS in Service Mesh
- 7.6.3.1 Automatic mTLS — Istio/Linkerd inject sidecar; negotiate mTLS without app changes
  - 7.6.3.1.1 Permissive mode — accept both mTLS and plaintext during migration
  - 7.6.3.1.2 Strict mode — reject all non-mTLS connections; enforce post-migration
- 7.6.3.2 SPIFFE SVID rotation — cert refreshed before expiry; connection drained, not dropped
#### 7.6.4 Certificate Revocation
- 7.6.4.1 CRL (Certificate Revocation List) — published list of revoked certs; polling latency issue
- 7.6.4.2 OCSP (Online Certificate Status Protocol) — real-time query; OCSP stapling improves perf
- 7.6.4.3 Short-lived cert strategy — avoid revocation by ensuring certs expire before they can be misused
  - 7.6.4.3.1 Max exposure window — 24h cert TTL limits blast radius of compromised private key
#### 7.6.5 mTLS Performance Impact
- 7.6.5.1 TLS handshake overhead — full handshake ~1-2ms; session resumption (TLS 1.3) ~0.5ms
- 7.6.5.2 Session tickets / resumption — avoid full handshake on reconnect; reduce latency
- 7.6.5.3 ALPN negotiation — negotiate gRPC/HTTP2/HTTP1.1 within TLS handshake
