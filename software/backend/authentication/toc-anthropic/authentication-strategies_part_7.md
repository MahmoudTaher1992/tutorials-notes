# Authentication Strategies — Part 7: Security Attack Vectors & Performance

---

## 11.0 Security Attack Vectors & Defenses

### 11.1 Credential-Based Attacks
#### 11.1.1 Brute Force & Credential Stuffing
- 11.1.1.1 Rate limiting — IP-based + account-based thresholds
  - 11.1.1.1.1 Exponential backoff lockout — 5 fail → 30s, 10 fail → 5min
  - 11.1.1.1.2 Progressive CAPTCHA — introduce challenge after N failures
- 11.1.1.2 Credential stuffing defenses — breached password detection
  - 11.1.1.2.1 HaveIBeenPwned k-Anonymity API — hash prefix lookup (privacy-preserving)
  - 11.1.1.2.2 Offline breach list integration — background scanning
- 11.1.1.3 Account lockout policies — hard vs. soft lockout trade-offs

#### 11.1.2 Password Spraying
- 11.1.2.1 Low-and-slow detection — aggregate failed logins per password across accounts
- 11.1.2.2 Anomaly detection — failed auth per time window per IP range

#### 11.1.3 Phishing & Social Engineering
- 11.1.3.1 Domain spoofing — homograph attacks, Unicode lookalikes
- 11.1.3.2 Real-time phishing proxies — AiTM (Attacker-in-the-Middle)
- 11.1.3.3 Phishing-resistant auth — FIDO2 origin binding defeats AiTM

### 11.2 Session & Token Attacks
#### 11.2.1 Session Hijacking
- 11.2.1.1 XSS-based cookie theft — mitigated by HttpOnly flag
- 11.2.1.2 Network sniffing — mitigated by Secure flag + HSTS
- 11.2.1.3 Session fixation — mitigated by ID regeneration on login

#### 11.2.2 JWT-Specific Attacks
- 11.2.2.1 alg:none exploit — server accepts unsigned token → whitelist algorithms
- 11.2.2.2 Algorithm confusion RS256→HS256 — use public key as HMAC secret
- 11.2.2.3 Weak secret brute-force — HMAC keys < 128 bits
  - 11.2.2.3.1 hashcat JWT mode — GPU brute force of weak secrets (HS256)
- 11.2.2.4 Embedded JWK injection — trusting key embedded in token header

#### 11.2.3 CSRF Attacks
- 11.2.3.1 Classic CSRF — forged state-changing request from victim's browser
- 11.2.3.2 Login CSRF — force victim to log into attacker's session
- 11.2.3.3 CSRF bypass with JSON — exploiting preflight CORS limitation

### 11.3 OAuth-Specific Attacks
#### 11.3.1 Authorization Code Interception
- 11.3.1.1 Without PKCE — code stolen from redirect URI query logs
- 11.3.1.2 Custom scheme hijacking — mobile app redirect abuse

#### 11.3.2 Open Redirect in OAuth
- 11.3.2.1 redirect_uri parameter manipulation
- 11.3.2.2 Fragment smuggling via open redirect chain

#### 11.3.3 Mix-Up Attacks
- 11.3.3.1 Malicious AS injecting code for legitimate AS
- 11.3.3.2 Mitigation — iss validation in redirect response (RFC 9207)

#### 11.3.4 SSRF via OAuth Callbacks
- 11.3.4.1 Malicious redirect_uri pointing to internal services
- 11.3.4.2 Defense — strict allowlist of redirect URIs

### 11.4 Token Leakage & Supply Chain
#### 11.4.1 Token Leakage Paths
- 11.4.1.1 Referrer header — token in URL leaks to third-party scripts
- 11.4.1.2 Browser history — access tokens in URL fragment or query string
- 11.4.1.3 Log injection — Bearer token captured in application access logs
- 11.4.1.4 Postman/insomnia collection leakage — credentials in exported files

#### 11.4.2 Auth Library Vulnerabilities
- 11.4.2.1 JSON parser differential — jwt_decode vs. jwt_verify confusion
- 11.4.2.2 Key confusion in multi-algorithm libraries — library version drift

---

## 12.0 Performance & Scalability

### 12.1 Authentication Latency Budgets
#### 12.1.1 Cryptographic Operation Cost
- 12.1.1.1 bcrypt verification — ~100ms at cost=12 (intentional; budget accordingly)
- 12.1.1.2 JWT signature verification — RS256 ~1ms, ES256 ~0.5ms, HS256 ~0.1ms
- 12.1.1.3 WebAuthn assertion verification — ~5ms (EC signature + counter check)
- 12.1.1.4 Password hashing at registration — run async, return immediately

#### 12.1.2 Network Latency Reduction
- 12.1.2.1 JWKS caching — eliminate per-request key fetch
- 12.1.2.2 Session store colocation — Redis on same node/rack as app server
- 12.1.2.3 CDN-cached discovery docs — reduce OIDC metadata fetch latency

### 12.2 Token Caching Strategies
#### 12.2.1 Access Token Caching (Client-Side)
- 12.2.1.1 Cache until exp − 30s — proactive refresh before expiry
- 12.2.1.2 Per-scope cache keys — scope-differentiated token storage

#### 12.2.2 Introspection Response Caching
- 12.2.2.1 Cache active responses — TTL = min(token_exp, cache_max)
- 12.2.2.2 Cache inactive responses — short TTL (10-30s) to detect re-activation

#### 12.2.3 JWKS Cache Management
- 12.2.3.1 Respect Cache-Control max-age from JWKS endpoint
- 12.2.3.2 Force refresh on unknown kid — key rotation without downtime
- 12.2.3.3 Negative caching for non-existent kids — prevent hammering

### 12.3 High-Throughput Auth Architecture
#### 12.3.1 Stateless JWT at Scale
- 12.3.1.1 No centralized state for verification — horizontal scaling
- 12.3.1.2 Blocklist scaling — bloom filter + periodic compaction
  - 12.3.1.2.1 False positive rate tuning — memory vs. accuracy tradeoff
  - 12.3.1.2.2 Two-level filter — bloom check + Redis fallback for positives

#### 12.3.2 Auth Service Design Patterns
- 12.3.2.1 Dedicated auth service — isolated, independently scalable
- 12.3.2.2 Read replicas for session store — distribute verification load
- 12.3.2.3 Async token refresh — background refresh before expiry
- 12.3.2.4 Circuit breaker on auth service — degrade gracefully on failure

#### 12.3.3 Rate Limiting Auth Endpoints
- 12.3.3.1 Token bucket per IP — login endpoint (e.g., 10 req/s)
- 12.3.3.2 Sliding window per user — 20 attempts / 15 min
- 12.3.3.3 Global rate limiter — DDoS protection on auth service
- 12.3.3.4 Distributed rate limiting — Redis-based sliding window across nodes

---

> **Navigation:** [← Part 6: SSO & mTLS](authentication-strategies_part_6.md) | [Part 8: Specific Implementations →](authentication-strategies_part_8.md)
