# Authentication Strategies — Part 1: Foundational Concepts & Session-Based Auth

---

## 1.0 Foundational Concepts & Theory

### 1.1 Authentication vs. Authorization
#### 1.1.1 Definitions & Conceptual Boundaries
- 1.1.1.1 Authentication — identity verification (who are you?)
- 1.1.1.2 Authorization — permission verification (what can you do?)
- 1.1.1.3 Authentication as prerequisite to authorization
- 1.1.1.4 Decoupling auth systems from application logic

#### 1.1.2 Identity Claims & Principals
- 1.1.2.1 Claims-based identity model
- 1.1.2.2 Subject (sub) vs. actor claims
- 1.1.2.3 Principal vs. credential distinction
- 1.1.2.4 Delegated identity vs. direct identity

### 1.2 Cryptographic Primitives
#### 1.2.1 Password Hashing Algorithms
- 1.2.1.1 SHA-256 / SHA-512 — NOT suitable for passwords; collision resistance only
- 1.2.1.2 bcrypt — adaptive cost factor (work factor tuning)
  - 1.2.1.2.1 Cost factor selection — GPU attack resistance thresholds (2^N iterations)
  - 1.2.1.2.2 Salt generation — 128-bit random salt embedded in hash string
- 1.2.1.3 Argon2 (id/i/d variants) — memory-hard KDF; winner of Password Hashing Competition
  - 1.2.1.3.1 Memory parameter (m) — minimum 64MB for web auth
  - 1.2.1.3.2 Parallelism parameter (p) — thread count vs. resource constraints
  - 1.2.1.3.3 Iterations (t) — time cost tuning
- 1.2.1.4 scrypt — N/r/p parameters, sequential memory access
- 1.2.1.5 PBKDF2 — HMAC-SHA iterations, FIPS compliance use cases

#### 1.2.2 Symmetric Encryption
- 1.2.2.1 AES-256-GCM — authenticated encryption, nonce management
  - 1.2.2.1.1 Nonce uniqueness guarantee — counter-based vs. random nonce tradeoffs
  - 1.2.2.1.2 Authentication tag verification before decryption
- 1.2.2.2 ChaCha20-Poly1305 — software-friendly alternative to AES
- 1.2.2.3 Key derivation from passwords — HKDF expand/extract phases

#### 1.2.3 Asymmetric Cryptography
- 1.2.3.1 RSA (2048/4096-bit) — PKCS#1 v1.5 vs. RSASSA-PSS for JWT signing
  - 1.2.3.1.1 Modulus size vs. performance tradeoff
  - 1.2.3.1.2 Padding oracle attacks on PKCS#1 v1.5
- 1.2.3.2 ECDSA — P-256, P-384 curves, deterministic signing (RFC 6979)
  - 1.2.3.2.1 Nonce reuse catastrophe — k-reuse leads to private key recovery
  - 1.2.3.2.2 Point validation requirements — subgroup membership checks
- 1.2.3.3 EdDSA (Ed25519/Ed448) — cofactor safety, fault attack resistance
- 1.2.3.4 ECDH — key agreement for session key establishment

#### 1.2.4 Message Authentication Codes (MACs)
- 1.2.4.1 HMAC-SHA256 — key length requirements (≥256-bit)
- 1.2.4.2 Timing-safe comparison — constant-time equals for MAC verification
- 1.2.4.3 Truncated MAC security — minimum 80-bit output threshold

### 1.3 Identity Models & Protocols
#### 1.3.1 Centralized vs. Federated Identity
- 1.3.1.1 Centralized — single IdP, single user store
- 1.3.1.2 Federated — trust assertions between independent IdPs
- 1.3.1.3 Decentralized — DIDs (Decentralized Identifiers), W3C spec

#### 1.3.2 Credential Types (Authentication Factors)
- 1.3.2.1 Knowledge factors — passwords, PINs, security questions
- 1.3.2.2 Possession factors — TOTP apps, hardware keys, SMS codes
- 1.3.2.3 Inherence factors — biometrics (fingerprint, face, voice)
- 1.3.2.4 Location factors — IP geofencing, GPS-based assertions

### 1.4 Trust Models & Security Boundaries
#### 1.4.1 Zero Trust Architecture Principles
- 1.4.1.1 Never trust, always verify — continuous per-request auth
- 1.4.1.2 Least-privilege access — minimal scope per token/session
- 1.4.1.3 Micro-segmentation — independent auth per service

#### 1.4.2 Threat Models
- 1.4.2.1 Attacker capability assumptions (insider, remote, MITM)
- 1.4.2.2 Asset classification (PII, financial, medical)
- 1.4.2.3 Authentication strength ladder — NIST AAL1/2/3

---

## 2.0 Session-Based Authentication

### 2.1 Session Lifecycle
#### 2.1.1 Session Creation
- 2.1.1.1 Credential verification and session record insertion
- 2.1.1.2 Session ID generation — CSPRNG, minimum 128-bit entropy
  - 2.1.1.2.1 UUID v4 vs. opaque token comparison
  - 2.1.1.2.2 Predictability testing — TestU01, DIEHARD suite
- 2.1.1.3 Session store write atomicity — race conditions in distributed creation

#### 2.1.2 Session Retrieval
- 2.1.2.1 Cookie extraction from request headers
- 2.1.2.2 Session store lookup (hash map / DB query)
- 2.1.2.3 Session deserialization — type safety, injection risks

#### 2.1.3 Session Termination
- 2.1.3.1 Explicit logout — server-side deletion + cookie clearing
- 2.1.3.2 Timeout-based expiration (sliding vs. absolute)
  - 2.1.3.2.1 Sliding window — reset TTL on each request (Redis EXPIRE)
  - 2.1.3.2.2 Absolute expiration — hard max-age regardless of activity
- 2.1.3.3 Invalidation on password change
- 2.1.3.4 Concurrent session policy — single vs. multi-session per user

### 2.2 Session Storage Backends
#### 2.2.1 In-Memory Stores
- 2.2.1.1 HashMap session cache — O(1) read/write, no persistence
- 2.2.1.2 Memory limits and eviction — LRU eviction under pressure
- 2.2.1.3 Process restart data loss implications

#### 2.2.2 Database-Backed Sessions
- 2.2.2.1 SQL session table schema — session_id, user_id, data JSONB, expires_at
- 2.2.2.2 Indexed lookups — btree index on session_id column
- 2.2.2.3 Cleanup jobs — TTL sweep with DELETE WHERE expires_at < NOW()
- 2.2.2.4 JSONB vs. separate column storage tradeoffs

#### 2.2.3 Redis Sessions
- 2.2.3.1 Key schema — `session:{session_id}` hash or string
- 2.2.3.2 TTL management — SETEX / EXPIRE commands
  - 2.2.3.2.1 Keyspace notifications for expiry events
  - 2.2.3.2.2 Lazy vs. active expiry behavior in Redis
- 2.2.3.3 Redis Cluster sharding — consistent hashing, session affinity implications
- 2.2.3.4 Redis Sentinel vs. Cluster — failover guarantees for session availability
- 2.2.3.5 Session serialization format — JSON vs. MessagePack vs. binary

#### 2.2.4 Memcached Sessions
- 2.2.4.1 Slab allocator memory management impact on large sessions
- 2.2.4.2 No persistence — eviction under memory pressure
- 2.2.4.3 Consistent hashing across nodes

### 2.3 Cookie Management
#### 2.3.1 Cookie Security Attributes
- 2.3.1.1 HttpOnly — XSS protection, JavaScript inaccessible
- 2.3.1.2 Secure — HTTPS-only transmission
- 2.3.1.3 SameSite — Strict / Lax / None semantics and CSRF mitigation
  - 2.3.1.3.1 Lax vs. Strict for cross-origin navigation
  - 2.3.1.3.2 SameSite=None + Secure requirement for third-party contexts
- 2.3.1.4 Domain and Path scoping
- 2.3.1.5 Max-Age vs. Expires — persistent vs. session cookies

#### 2.3.2 Cookie Size Constraints
- 2.3.2.1 4KB per-cookie browser limit
- 2.3.2.2 Total cookie header size limits per domain (~8KB)
- 2.3.2.3 Cookie chunking strategies for large payloads

### 2.4 Session Security
#### 2.4.1 Session Fixation Prevention
- 2.4.1.1 Session ID regeneration on privilege escalation
- 2.4.1.2 Pre-authentication session invalidation

#### 2.4.2 Session Hijacking Mitigations
- 2.4.2.1 IP binding — fingerprint rotation trade-offs (mobile, VPN)
- 2.4.2.2 User-Agent binding — value as weak signal
- 2.4.2.3 Rotating session IDs on suspicious activity

#### 2.4.3 CSRF Protection
- 2.4.3.1 Synchronizer token pattern — token-in-form vs. double-submit cookie
- 2.4.3.2 SameSite cookie as CSRF defense layer
- 2.4.3.3 Origin/Referer header validation

### 2.5 Distributed Session Architecture
#### 2.5.1 Sticky Sessions
- 2.5.1.1 L4/L7 load balancer affinity configuration
- 2.5.1.2 Failure handling — session loss on node crash

#### 2.5.2 Centralized Session Stores
- 2.5.2.1 Redis as universal session backend
- 2.5.2.2 Replication lag implications for session consistency
- 2.5.2.3 Network partition handling — session unavailability vs. stale reads

---

> **Navigation:** [Part 2: JWT/Token Auth →](authentication-strategies_part_2.md)
