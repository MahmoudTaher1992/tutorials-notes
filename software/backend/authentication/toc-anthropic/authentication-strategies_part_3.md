# Authentication Strategies — Part 3: OAuth 2.0

---

## 4.0 OAuth 2.0

### 4.1 OAuth 2.0 Actors & Roles
#### 4.1.1 Role Definitions
- 4.1.1.1 Resource Owner — end-user or entity owning the resource
- 4.1.1.2 Client — application requesting access
  - 4.1.1.2.1 Confidential clients — server-side, can securely hold secrets
  - 4.1.1.2.2 Public clients — SPAs, mobile apps, no secret capability
- 4.1.1.3 Authorization Server (AS) — issues tokens after authentication
- 4.1.1.4 Resource Server (RS) — hosts protected resources, validates tokens

#### 4.1.2 Client Registration
- 4.1.2.1 Static registration — manual client_id/secret provisioning
- 4.1.2.2 Dynamic Client Registration (RFC 7591) — programmatic registration
- 4.1.2.3 Redirect URI validation — exact match requirement (RFC 6749 §3.1.2)

### 4.2 Authorization Flows (Grant Types)
#### 4.2.1 Authorization Code Flow
- 4.2.1.1 Flow steps — redirect → authorization code → token exchange
  - 4.2.1.1.1 state parameter — CSRF protection, entropy requirements (≥128-bit)
  - 4.2.1.1.2 Code lifetime — short-lived (1-10 min), single-use enforcement
- 4.2.1.2 Authorization code interception attack vectors

#### 4.2.2 PKCE — Proof Key for Code Exchange (RFC 7636)
- 4.2.2.1 code_verifier generation — 43-128 char URL-safe random string
  - 4.2.2.1.1 Entropy requirements — minimum 32 bytes (256-bit)
- 4.2.2.2 code_challenge derivation — S256 = BASE64URL(SHA256(verifier))
- 4.2.2.3 Verifier validation at token endpoint — server checks hash match
- 4.2.2.4 PKCE as mandatory for all clients (OAuth 2.1 / RFC 9700)
- 4.2.2.5 Plain method — acceptable only when S256 not supported (avoid)

#### 4.2.3 Client Credentials Flow
- 4.2.3.1 Machine-to-machine use case — no user involvement
- 4.2.3.2 client_id + client_secret in Basic auth header vs. body
- 4.2.3.3 Token lifetime for service accounts — longer TTL considerations

#### 4.2.4 Device Authorization Flow (RFC 8628)
- 4.2.4.1 device_code + user_code issuance
- 4.2.4.2 Polling interval — minimum 5s, exponential backoff on slow_down
- 4.2.4.3 User verification URL — verification_uri_complete with embedded code
- 4.2.4.4 Expiry — device_code TTL (typically 15 min)

#### 4.2.5 Refresh Token Grant
- 4.2.5.1 grant_type=refresh_token exchange
- 4.2.5.2 Scope downgrade allowed, scope upgrade rejected

#### 4.2.6 Deprecated Grant Types (OAuth 2.1 removals)
- 4.2.6.1 Implicit Flow — removed (token in URL fragment, no PKCE possible)
- 4.2.6.2 Resource Owner Password Credentials (ROPC) — deprecated; anti-pattern

### 4.3 Token Endpoints & Responses
#### 4.3.1 Authorization Endpoint
- 4.3.1.1 Required params — response_type, client_id, redirect_uri, scope, state
- 4.3.1.2 Response modes — query, fragment, form_post (JWT Secured – JARM)

#### 4.3.2 Token Endpoint
- 4.3.2.1 Token response fields — access_token, token_type, expires_in, refresh_token
- 4.3.2.2 Bearer token type — Authorization: Bearer header
- 4.3.2.3 DPoP — Demonstrating Proof of Possession (RFC 9449)
  - 4.3.2.3.1 DPoP proof JWT — htm + htu + iat + jti claims
  - 4.3.2.3.2 DPoP nonce — replay prevention via server-issued nonce
  - 4.3.2.3.3 DPoP binding to access token — ath claim in DPoP proof

#### 4.3.3 Token Introspection (RFC 7662)
- 4.3.3.1 Introspection endpoint — POST with token parameter
- 4.3.3.2 Active/inactive response — avoid timing oracle on inactive tokens
- 4.3.3.3 Introspection caching — cache active responses until exp

#### 4.3.4 Token Revocation (RFC 7009)
- 4.3.4.1 Revocation endpoint — token_type_hint parameter
- 4.3.4.2 Cascade revocation — access + refresh tokens on logout
- 4.3.4.3 Silent success — always return 200 (prevents enumeration)

### 4.4 Scope Design
#### 4.4.1 Scope Naming Conventions
- 4.4.1.1 Resource-action pattern — `resource:action` (e.g., `users:read`)
- 4.4.1.2 OIDC standard scopes — openid, profile, email, address, phone
- 4.4.1.3 Wildcard scopes — risks of overly broad grants

#### 4.4.2 Scope Enforcement
- 4.4.2.1 AS scope validation — reject unknown scopes
- 4.4.2.2 RS scope check — per-endpoint scope requirement
- 4.4.2.3 Scope reduction on refresh — maintaining least privilege over time

#### 4.4.3 Rich Authorization Requests (RFC 9396)
- 4.4.3.1 `authorization_details` parameter — structured per-resource permissions
- 4.4.3.2 Type-specific authorization details (payment_initiation, account_info)

### 4.5 OAuth 2.0 Security Best Practices (RFC 9700)
#### 4.5.1 PKCE Mandatory for All Clients
- 4.5.1.1 Browser-based app requirements — no implicit flow
- 4.5.1.2 Native app requirements — custom schemes vs. claimed HTTPS

#### 4.5.2 Redirect URI Attacks
- 4.5.2.1 Open redirect — unvalidated redirect_uri parameter
- 4.5.2.2 Subdomain takeover via wildcard redirect matching
- 4.5.2.3 Path traversal in redirect URI matching

#### 4.5.3 Mix-Up Attacks
- 4.5.3.1 Malicious AS injecting code intended for legitimate AS
- 4.5.3.2 iss parameter validation at redirect response (RFC 9207)
- 4.5.3.3 Authorization server metadata binding

#### 4.5.4 Token Binding & Sender Constraint
- 4.5.4.1 DPoP as pragmatic binding mechanism
- 4.5.4.2 mTLS certificate-bound tokens (RFC 8705) — `cnf.x5t#S256` claim
- 4.5.4.3 Token replay prevention at RS — DPoP jti tracking

### 4.6 OAuth 2.0 for Native & Mobile Apps (RFC 8252)
#### 4.6.1 Redirect URI Strategies
- 4.6.1.1 Claimed HTTPS redirect — `https://app.example.com/callback` (preferred)
- 4.6.1.2 Custom URI schemes — `myapp://callback` (hijackable, avoid)
- 4.6.1.3 Loopback redirect — `http://127.0.0.1:{port}/callback`

#### 4.6.2 In-App Browser Requirements
- 4.6.2.1 External user agent mandate — no embedded WebViews
- 4.6.2.2 ASWebAuthenticationSession (iOS) / Chrome Custom Tabs (Android)

---

> **Navigation:** [← Part 2: JWT](authentication-strategies_part_2.md) | [Part 4: OIDC & API Keys →](authentication-strategies_part_4.md)
