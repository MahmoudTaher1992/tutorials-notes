# Integration Patterns Complete Study Guide - Part 6: Security Patterns

## 11.0 Security Integration Patterns

### 11.1 Authentication Flows
#### 11.1.1 OAuth 2.0 Flows
- 11.1.1.1 Authorization code flow — browser-based — user redirected to auth server — PKCE required
  - 11.1.1.1.1 PKCE — Proof Key for Code Exchange — code_verifier + code_challenge — prevent intercept
  - 11.1.1.1.2 Authorization code — short-lived — exchanged for access + refresh token — one-time use
  - 11.1.1.1.3 Redirect URI — must match registered — CSRF state parameter — nonce for OIDC
- 11.1.1.2 Client credentials flow — machine-to-machine — no user — service authenticates directly
  - 11.1.1.2.1 client_id + client_secret → access token — background jobs / microservices / daemons
  - 11.1.1.2.2 Token caching — cache access token until near expiry — avoid token per request
- 11.1.1.3 Device authorization flow — input-constrained devices — TV / CLI — code on screen
  - 11.1.1.3.1 User enters code on phone/browser — device polls until authorized — no redirect
- 11.1.1.4 Token exchange (RFC 8693) — service A's token → service B's token — impersonation / delegation
  - 11.1.1.4.1 subject_token + actor_token — on-behalf-of / may-act semantics — microservice chain

#### 11.1.2 SAML 2.0
- 11.1.2.1 XML-based — enterprise SSO — identity provider (IdP) → service provider (SP) — SOAP/POST
  - 11.1.2.1.1 SAML assertion — XML signed — attributes — NameID — audience restriction
  - 11.1.2.1.2 SP-initiated — user hits SP → redirect to IdP → login → POST assertion back
  - 11.1.2.1.3 IdP-initiated — user starts at IdP portal — clicks app — assertion sent to SP

### 11.2 Token Patterns
#### 11.2.1 JWT (JSON Web Token)
- 11.2.1.1 Three parts — header.payload.signature — base64url encoded — self-contained
  - 11.2.1.1.1 Header — alg (RS256/ES256/HS256) + typ — algorithm + token type
  - 11.2.1.1.2 Payload claims — sub / iss / aud / exp / iat / jti — standard + custom
  - 11.2.1.1.3 Signature — prevents tampering — public key verification — no DB lookup needed
- 11.2.1.2 JWT validation — check signature → verify exp → verify aud + iss → check jti (if revokable)
  - 11.2.1.2.1 Algorithm confusion attack — force HS256 with public key — always specify expected alg
  - 11.2.1.2.2 alg=none attack — strip signature — always reject none algorithm explicitly
- 11.2.1.3 Token revocation — JWT is stateless — revoke via allowlist/denylist or short expiry
  - 11.2.1.3.1 Short-lived access token (15min) + long-lived refresh token — balance security + UX
  - 11.2.1.3.2 jti denylist — Redis SET — check jti on each request — revoke specific token

#### 11.2.2 API Keys
- 11.2.2.1 Opaque key — not self-describing — lookup in DB/cache on each request — simple
  - 11.2.2.1.1 Key format — prefix+random — sk_live_xxxx — identifiable + random — Stripe style
  - 11.2.2.1.2 Key hashing — store SHA-256 of key — compare hash — no plaintext at rest
  - 11.2.2.1.3 Scoped keys — per-resource permissions — read-only vs read-write — least privilege

### 11.3 Transport & Message Security
#### 11.3.1 Mutual TLS (mTLS)
- 11.3.1.1 Both client + server present certificates — bilateral authentication — zero trust
  - 11.3.1.1.1 Service mesh mTLS — Istio/Linkerd auto-provision certs — SPIFFE/SPIRE identity
  - 11.3.1.1.2 Certificate rotation — short-lived certs — automated renewal — Vault PKI / cert-manager
- 11.3.1.2 mTLS in microservices — sidecar proxy handles certs — service code unaware — transparent

#### 11.3.2 HMAC Request Signing
- 11.3.2.1 Sign request body + headers + timestamp — receiver verifies signature — tamper-evident
  - 11.3.2.1.1 AWS Signature v4 — HMAC-SHA256 — canonical request — signing key hierarchy
  - 11.3.2.1.2 Replay prevention — timestamp in signature — reject if > 5 min old — freshness check
  - 11.3.2.1.3 Webhook signing — GitHub / Stripe sign payload — verify X-Hub-Signature-256 header

### 11.4 Zero Trust Integration
#### 11.4.1 Zero Trust Principles
- 11.4.1.1 Never trust — always verify — every request authenticated + authorized regardless of network
  - 11.4.1.1.1 Workload identity — SPIFFE ID — cryptographic service identity — not IP-based trust
  - 11.4.1.1.2 Least privilege — token scoped to minimum required — time-limited — just-in-time
- 11.4.1.2 OIDC for workloads — GitHub Actions / Kubernetes / AWS ECS — short-lived federated identity
  - 11.4.1.2.1 No stored secrets — dynamic credential via OIDC exchange — Vault / cloud IAM trust
