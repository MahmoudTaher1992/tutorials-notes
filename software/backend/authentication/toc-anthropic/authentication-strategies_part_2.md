# Authentication Strategies — Part 2: Token-Based Authentication (JWT)

---

## 3.0 Token-Based Authentication (JWT)

### 3.1 JWT Structure & Encoding
#### 3.1.1 Header
- 3.1.1.1 alg field — algorithm identifier (RS256, ES256, HS256, EdDSA)
- 3.1.1.2 typ claim — "JWT" literal vs. content-type hints
- 3.1.1.3 kid (Key ID) — key lookup hint for verification
  - 3.1.1.3.1 JWKS key rotation — matching kid to public key set
  - 3.1.1.3.2 Missing kid handling — fallback to single-key mode
- 3.1.1.4 cty (Content Type) — nested JWT indicators
- 3.1.1.5 x5t — X.509 certificate thumbprint for cert-bound tokens

#### 3.1.2 Payload (Claims)
- 3.1.2.1 Registered claims — iss, sub, aud, exp, nbf, iat, jti
  - 3.1.2.1.1 iss validation — exact string match or URL comparison
  - 3.1.2.1.2 aud validation — single string vs. array semantics
  - 3.1.2.1.3 exp leeway — clock skew tolerance (typical: 60-300s)
  - 3.1.2.1.4 jti uniqueness — replay prevention via seen-token cache
- 3.1.2.2 Public claims — IANA-registered well-known names
- 3.1.2.3 Private claims — application-defined (roles, tenantId, etc.)

#### 3.1.3 Signature
- 3.1.3.1 Base64URL encoding — no padding, URL-safe alphabet
- 3.1.3.2 Concatenation format — header.payload.signature
- 3.1.3.3 Signature verification pipeline steps

### 3.2 Signing Algorithms
#### 3.2.1 Symmetric (HMAC)
- 3.2.1.1 HS256/384/512 — shared secret key, HMAC-SHA family
  - 3.2.1.1.1 Secret key length requirements — minimum 256 bits for HS256
  - 3.2.1.1.2 Key distribution problem — shared secret exposure risk across services
- 3.2.1.2 Algorithm confusion attacks — "none" algorithm stripping

#### 3.2.2 Asymmetric (RSA/ECDSA/EdDSA)
- 3.2.2.1 RS256/384/512 — RSA-PKCS1v15 + SHA-2 family
- 3.2.2.2 PS256/384/512 — RSA-PSS (preferred over PKCS1v15)
- 3.2.2.3 ES256/384/512 — ECDSA with P-256/P-384/P-521
- 3.2.2.4 EdDSA — Ed25519 curve, OKP key type in JWKS

#### 3.2.3 Algorithm Selection Guidance
- 3.2.3.1 Public verification use case → RS256 or ES256 (public key distributable)
- 3.2.3.2 Internal microservice use → HS256 with secret rotation
- 3.2.3.3 Maximum security → EdDSA (Ed25519)

### 3.3 Claims Design Patterns
#### 3.3.1 Minimal Claims Principle
- 3.3.1.1 PII in tokens — risk of leakage in logs/intermediaries
- 3.3.1.2 Reference tokens vs. self-contained — opaque ID lookup vs. embedded data
- 3.3.1.3 Claims inflation — token size impact on HTTP headers (8KB header limit)

#### 3.3.2 Role & Permission Encoding
- 3.3.2.1 Flat roles array — `roles: ["admin", "user"]`
- 3.3.2.2 Scoped permissions — `permissions: ["read:users", "write:posts"]`
- 3.3.2.3 Hierarchical scopes — namespace prefixes for microservices

#### 3.3.3 Multi-Tenancy Claims
- 3.3.3.1 tenantId claim — partition key for multi-tenant systems
- 3.3.3.2 Tenant-specific key signing — isolation between tenant tokens

### 3.4 Token Lifecycle Management
#### 3.4.1 Access Token Lifetimes
- 3.4.1.1 Short-lived access tokens — 5-15 minute window
  - 3.4.1.1.1 Trade-off: revocation delay vs. refresh overhead
  - 3.4.1.1.2 Clock synchronization — NTP requirements for exp validation
- 3.4.1.2 Long-lived tokens — API integrations, risks and mitigations

#### 3.4.2 Refresh Token Pattern
- 3.4.2.1 Refresh token storage — DB-backed vs. opaque vs. JWT
- 3.4.2.2 Refresh token rotation — issue new on each use
  - 3.4.2.2.1 Rotation race condition — concurrent refresh requests
  - 3.4.2.2.2 Reuse detection — detecting stolen refresh tokens via family invalidation
- 3.4.2.3 Refresh token families — tree-based revocation on theft detection
- 3.4.2.4 Absolute refresh token TTL — max session length enforcement

#### 3.4.3 Token Revocation
- 3.4.3.1 Blocklist/denylist approach — Redis set `revoked:{jti}`
  - 3.4.3.1.1 Bloom filter optimization — probabilistic false-positive rate
  - 3.4.3.1.2 TTL alignment with token expiry — automatic cleanup
- 3.4.3.2 Token versioning — user-level `token_version` counter in DB
- 3.4.3.3 Short expiry as revocation proxy — no revocation needed for <5min tokens

### 3.5 JWT Validation Pipeline
#### 3.5.1 Mandatory Validation Steps (in order)
- 3.5.1.1 Algorithm verification — whitelist allowed algorithms (never trust alg header blindly)
- 3.5.1.2 Signature verification before claim inspection
- 3.5.1.3 exp / nbf / iat temporal claim validation
- 3.5.1.4 iss validation — trusted issuer list
- 3.5.1.5 aud validation — intended audience match

#### 3.5.2 Key Resolution
- 3.5.2.1 JWKS endpoint fetching — `/.well-known/jwks.json`
  - 3.5.2.1.1 JWKS caching — `Cache-Control` header respect
  - 3.5.2.1.2 Forced refresh on unknown kid — rotate without downtime
- 3.5.2.2 Static public key config — embedded PEM for closed systems

#### 3.5.3 Validation Error Handling
- 3.5.3.1 Expired token — distinct 401 response (not generic auth fail)
- 3.5.3.2 Invalid signature — generic 401 (avoid algorithm leak in response)
- 3.5.3.3 Missing claims — fail-closed default

### 3.6 JWT Attack Vectors
#### 3.6.1 Algorithm Confusion
- 3.6.1.1 alg:none attack — stripping signature verification
  - 3.6.1.1.1 Mitigation — explicit algorithm whitelist, reject `none`
- 3.6.1.2 RS256→HS256 confusion — using public key as HMAC secret
  - 3.6.1.2.1 Mitigation — algorithm pinned per key type in validator

#### 3.6.2 Claim Manipulation
- 3.6.2.1 Unsigned token forgery without algorithm check
- 3.6.2.2 exp extension — time manipulation on weak parsers

#### 3.6.3 Key Injection Attacks
- 3.6.3.1 Embedded JWK header attack — server trusts key embedded in token
- 3.6.3.2 x5c chain injection — untrusted certificate in header field

#### 3.6.4 Token Leakage Paths
- 3.6.4.1 Referrer header — token in URL leaks to third-party analytics
- 3.6.4.2 Browser history — access tokens in URL fragment/query string
- 3.6.4.3 Log injection — Bearer token captured in application access logs
- 3.6.4.4 LocalStorage XSS — script access to token in browser storage

---

> **Navigation:** [← Part 1: Foundations & Sessions](authentication-strategies_part_1.md) | [Part 3: OAuth 2.0 →](authentication-strategies_part_3.md)
