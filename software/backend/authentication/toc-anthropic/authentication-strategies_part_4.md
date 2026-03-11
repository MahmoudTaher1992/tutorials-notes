# Authentication Strategies — Part 4: OpenID Connect & API Key Authentication

---

## 5.0 OpenID Connect (OIDC)

### 5.1 OIDC as an OAuth 2.0 Extension
#### 5.1.1 Protocol Extension Points
- 5.1.1.1 scope=openid — triggers OIDC mode, returns ID Token
- 5.1.1.2 ID Token in addition to access token
- 5.1.1.3 UserInfo endpoint for additional claims beyond ID Token

#### 5.1.2 OIDC Flows
- 5.1.2.1 Authorization Code + PKCE (recommended for all clients)
- 5.1.2.2 Implicit flow — deprecated (token in fragment)
- 5.1.2.3 Hybrid flow — code + token in authorization response

### 5.2 ID Token Structure
#### 5.2.1 Standard ID Token Claims
- 5.2.1.1 iss — exact issuer URL match requirement
- 5.2.1.2 sub — stable opaque user identifier
  - 5.2.1.2.1 sub stability guarantee — must not change on re-login
  - 5.2.1.2.2 sub pairwise vs. public — privacy considerations per RP
- 5.2.1.3 aud — must include client_id (array or string)
- 5.2.1.4 exp / iat / auth_time — temporal validation
- 5.2.1.5 nonce — replay attack prevention
  - 5.2.1.5.1 Nonce binding — client generates, AS embeds, client verifies
- 5.2.1.6 at_hash — access token hash for binding
- 5.2.1.7 c_hash — authorization code hash in hybrid flow

#### 5.2.2 Authentication Context Claims
- 5.2.2.1 acr (Authentication Context Class Reference) — LoA indication
- 5.2.2.2 amr (Authentication Methods References) — mfa, pwd, hwk, otp values

### 5.3 OIDC Discovery (RFC 8414)
#### 5.3.1 Discovery Document
- 5.3.1.1 `/.well-known/openid-configuration` — JSON metadata endpoint
- 5.3.1.2 Required fields — issuer, authorization_endpoint, token_endpoint, jwks_uri
- 5.3.1.3 Caching strategy — long TTL with stale-while-revalidate

#### 5.3.2 JWKS Endpoint
- 5.3.2.1 Key format — RSA/EC/OKP JWK objects with use/alg fields
- 5.3.2.2 Key rotation procedure — overlap period for old keys
  - 5.3.2.2.1 Rotation window — minimum 24h overlap for cached key consumers
  - 5.3.2.2.2 kid-based routing — active vs. deprecated keys coexist

#### 5.3.3 Session Management Extensions
- 5.3.3.1 check_session_iframe — front-channel session state monitoring
- 5.3.3.2 end_session_endpoint — RP-initiated logout
- 5.3.3.3 Back-channel logout (RFC 9470) — direct IdP→RP POST notification
  - 5.3.3.3.1 logout_token — signed JWT with sid/sub + event claim
  - 5.3.3.3.2 RP must immediately invalidate session on receipt
- 5.3.3.4 Front-channel logout — iframe-based logout propagation (unreliable)

### 5.4 UserInfo Endpoint
#### 5.4.1 Endpoint Access
- 5.4.1.1 Bearer access token with openid scope
- 5.4.1.2 Signed/encrypted UserInfo response — JWT-formatted option

#### 5.4.2 Standard UserInfo Claims
- 5.4.2.1 profile scope — name, family_name, given_name, picture, website
- 5.4.2.2 email scope — email + email_verified
- 5.4.2.3 phone scope — phone_number + phone_number_verified
- 5.4.2.4 address scope — structured postal address object

### 5.5 OIDC Client Types & Registration
#### 5.5.1 Relying Party (RP) Registration
- 5.5.1.1 Metadata fields — redirect_uris, response_types, grant_types, subject_type
- 5.5.1.2 Token endpoint auth methods — client_secret_basic, private_key_jwt

#### 5.5.2 Private Key JWT Client Auth (RFC 7523)
- 5.5.2.1 Client signs assertion with private key
  - 5.5.2.1.1 iss = sub = client_id, aud = token_endpoint
  - 5.5.2.1.2 jti uniqueness — prevents replay
- 5.5.2.2 Preferred over client_secret (no shared secret)

---

## 6.0 API Key Authentication

### 6.1 API Key Design
#### 6.1.1 Key Format
- 6.1.1.1 Opaque random — CSPRNG 256-bit, base58/base64url encoding
  - 6.1.1.1.1 Prefix pattern — `sk_live_...` / `pk_test_...` for identification
  - 6.1.1.1.2 Human-readable prefix prevents accidental secret exposure in logs
- 6.1.1.2 Structured keys — key_id + key_secret split (lookup + validation)
- 6.1.1.3 Key length recommendations — minimum 128-bit entropy (256-bit preferred)

#### 6.1.2 Server-Side Key Storage
- 6.1.2.1 Hashed storage — store hash(key), never plaintext
  - 6.1.2.1.1 Algorithm — SHA-256 sufficient (keys are already high-entropy random)
  - 6.1.2.1.2 Lookup — prefix index on key_id, validate hash(secret)
- 6.1.2.2 One-time display — show full key only at creation, then hashed only

### 6.2 Key Transmission
#### 6.2.1 HTTP Header Methods
- 6.2.1.1 Authorization: Bearer — standard OAuth2 bearer usage
- 6.2.1.2 X-API-Key custom header — simple, widely supported
- 6.2.1.3 Query string `?api_key=...` — avoid (logged by servers/proxies/CDNs)

#### 6.2.2 Transport Security
- 6.2.2.1 TLS mandatory — keys transmitted in plaintext only over TLS
- 6.2.2.2 Certificate pinning — high-security API clients

### 6.3 API Key Lifecycle
#### 6.3.1 Key Provisioning
- 6.3.1.1 Per-application keys — scoped to single integration
- 6.3.1.2 Environment-based — production vs. sandbox key spaces with prefixes

#### 6.3.2 Key Rotation
- 6.3.2.1 Rotation grace period — both old and new key valid during transition
- 6.3.2.2 Forced rotation triggers — breach detection, employee offboarding
- 6.3.2.3 Rotation notification — webhook or email alert on pending expiry

#### 6.3.3 Key Revocation
- 6.3.3.1 Immediate revocation — DB flag `is_revoked = true`
- 6.3.3.2 Audit trail — revocation reason, timestamp, actor
- 6.3.3.3 Propagation delay in cached systems — cache TTL awareness

### 6.4 API Key Security
#### 6.4.1 Rate Limiting per Key
- 6.4.1.1 Token bucket / sliding window per key_id
- 6.4.1.2 Quota tiers — free vs. paid plan enforcement

#### 6.4.2 Key Scope Restrictions
- 6.4.2.1 IP allowlist binding — restrict to server-to-server only
- 6.4.2.2 Capability scoping — read-only vs. read-write keys
- 6.4.2.3 Expiring keys — time-bounded API access

#### 6.4.3 Anomaly Detection
- 6.4.3.1 Usage spike alerts — sudden volume increase per key
- 6.4.3.2 Geographic anomalies — key used from unexpected regions
- 6.4.3.3 Leaked key detection — automated scanning (GitHub, npm registry)

---

> **Navigation:** [← Part 3: OAuth 2.0](authentication-strategies_part_3.md) | [Part 5: Passwordless & MFA →](authentication-strategies_part_5.md)
