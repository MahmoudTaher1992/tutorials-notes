#!/bin/bash

# Root Directory Name
ROOT_DIR="Backend-Auth-Master-Plan"

# Create Root Directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating directory structure for: $ROOT_DIR"

# ==============================================================================
# PHASE 1: The Core Foundations
# ==============================================================================
PHASE_DIR="001-Phase-1-Core-Foundations"
mkdir -p "$PHASE_DIR"

# --- 1. HTTP & Cryptography Basics ---
TOPIC_DIR="$PHASE_DIR/01-HTTP-and-Cryptography-Basics"
mkdir -p "$TOPIC_DIR"

# A. Transport Security
cat <<'EOF' > "$TOPIC_DIR/001-A-Transport-Security.md"
# A. Transport Security

*   i. TLS/SSL Handshake (Why HTTPS is non-negotiable).
*   ii. Man-in-the-Middle (MitM) attacks.
EOF

# B. Cryptographic Primitives
cat <<'EOF' > "$TOPIC_DIR/002-B-Cryptographic-Primitives.md"
# B. Cryptographic Primitives

*   i. **Hashing vs. Encryption vs. Encoding** (Base64 is NOT encryption).
*   ii. **Symmetric Encryption** (Shared Secret) vs. **Asymmetric Encryption** (Public/Private Key).
*   iii. Digital Signatures (Ensuring integrity).
EOF

# --- 2. Credential Management (The "User" Database) ---
TOPIC_DIR="$PHASE_DIR/02-Credential-Management"
mkdir -p "$TOPIC_DIR"

# A. Storing Passwords Securely
cat <<'EOF' > "$TOPIC_DIR/001-A-Storing-Passwords-Securely.md"
# A. Storing Passwords Securely

*   i. **Evolution:** Plaintext -> MD5 -> SHA-256 -> Salted Hash -> Adaptive Algorithms.
*   ii. **Modern Standards:** Argon2id (Best), bcrypt, scrypt, PBKDF2.
*   iii. **Entropy & Salting:** Preventing Rainbow Table attacks.
EOF

# B. Defensive Measures
cat <<'EOF' > "$TOPIC_DIR/002-B-Defensive-Measures.md"
# B. Defensive Measures

*   i. Account Lockout Policies vs. Exponential Backoff.
*   ii. Credential Stuffing detection.
EOF


# ==============================================================================
# PHASE 2: Authentication Strategies (AuthN)
# ==============================================================================
PHASE_DIR="002-Phase-2-Authentication-Strategies"
mkdir -p "$PHASE_DIR"

# --- 3. Stateful Authentication (Session-Based) ---
TOPIC_DIR="$PHASE_DIR/03-Stateful-Authentication"
mkdir -p "$TOPIC_DIR"

# A. The Lifecycle
cat <<'EOF' > "$TOPIC_DIR/001-A-The-Lifecycle.md"
# A. The Lifecycle

*   i. Login -> Server generates `session_id` -> Stores in Redis/DB -> Sends Cookie.
EOF

# B. Cookie Security Hardening
cat <<'EOF' > "$TOPIC_DIR/002-B-Cookie-Security-Hardening.md"
# B. Cookie Security Hardening

*   i. `HttpOnly` (Prevent XSS theft).
*   ii. `Secure` (HTTPS only).
*   iii. `SameSite` (Lax/Strict) to prevent CSRF.
*   iv. `Domain` and `Path` scoping.
EOF

# C. Scaling Issues
cat <<'EOF' > "$TOPIC_DIR/003-C-Scaling-Issues.md"
# C. Scaling Issues

*   i. The "Sticky Session" problem and distributed stores (Redis).
EOF

# --- 4. Stateless Authentication (Token-Based) ---
TOPIC_DIR="$PHASE_DIR/04-Stateless-Authentication"
mkdir -p "$TOPIC_DIR"

# A. JSON Web Tokens (JWT) Deep Dive
cat <<'EOF' > "$TOPIC_DIR/001-A-JWT-Deep-Dive.md"
# A. JSON Web Tokens (JWT) Deep Dive

*   i. **Structure:** Header, Payload (Claims), Signature.
*   ii. **JWS (Signed)** vs. **JWE (Encrypted)**: Do you need to hide the payload data?
*   iii. **Signing Algorithms:** HS256 (Symmetric) vs. RS256/ES256 (Asymmetric).
EOF

# B. The Storage Debate
cat <<'EOF' > "$TOPIC_DIR/002-B-The-Storage-Debate.md"
# B. The Storage Debate

*   i. **LocalStorage:** Vulnerable to XSS.
*   ii. **HttpOnly Cookie:** Vulnerable to CSRF (but mitigated by SameSite/tokens).
*   iii. **The BFF Pattern (Backend for Frontend):** Keeping tokens completely off the client-side.
EOF

# C. Token Lifecycle & Security
cat <<'EOF' > "$TOPIC_DIR/003-C-Token-Lifecycle-Security.md"
# C. Token Lifecycle & Security

*   i. **Access Tokens vs. Refresh Tokens:** Why short lifespans matter.
*   ii. **Refresh Token Rotation:** Preventing token theft replay attacks.
*   iii. **Revocation Strategies:**
    *   Blocklisting (Redis).
    *   Versioned Tokens (Database lookup).
    *   Short expiration times.
EOF


# ==============================================================================
# PHASE 3: Delegated Auth & Federation (OAuth2 / OIDC)
# ==============================================================================
PHASE_DIR="003-Phase-3-Delegated-Auth-Federation"
mkdir -p "$PHASE_DIR"

# --- 5. OAuth 2.0 Framework (Authorization) ---
TOPIC_DIR="$PHASE_DIR/05-OAuth-2-Framework"
mkdir -p "$TOPIC_DIR"

# A. Roles & Terminology
cat <<'EOF' > "$TOPIC_DIR/001-A-Roles-Terminology.md"
# A. Roles & Terminology

*   Resource Owner, Client, Auth Server (AS), Resource Server (RS).
EOF

# B. Grant Types (The Flows)
cat <<'EOF' > "$TOPIC_DIR/002-B-Grant-Types.md"
# B. Grant Types (The Flows)

*   i. **Authorization Code Flow with PKCE:** The *Gold Standard* for Mobile/SPA/Web.
*   ii. **Client Credentials Flow:** Machine-to-Machine (M2M) communication.
*   iii. **Deprecated Flows:** Implicit Flow and Password Grant (Why they are insecure).
EOF

# C. Scopes & Consent
cat <<'EOF' > "$TOPIC_DIR/003-C-Scopes-Consent.md"
# C. Scopes & Consent

*   Designing granular permission requests.
EOF

# --- 6. OpenID Connect (OIDC) (Identity) ---
TOPIC_DIR="$PHASE_DIR/06-OpenID-Connect"
mkdir -p "$TOPIC_DIR"

# A. The Identity Layer
cat <<'EOF' > "$TOPIC_DIR/001-A-The-Identity-Layer.md"
# A. The Identity Layer

*   i. How OIDC standardizes the UserInfo endpoint and ID Token.
EOF

# B. The ID Token
cat <<'EOF' > "$TOPIC_DIR/002-B-The-ID-Token.md"
# B. The ID Token

*   i. Format (JWT).
*   ii. Audience (`aud`), Issuer (`iss`), and Subject (`sub`) validation.
EOF

# C. Discovery
cat <<'EOF' > "$TOPIC_DIR/003-C-Discovery.md"
# C. Discovery

*   The `/.well-known/openid-configuration` endpoint.
EOF

# --- 7. Enterprise SSO (SAML 2.0) ---
TOPIC_DIR="$PHASE_DIR/07-Enterprise-SSO"
mkdir -p "$TOPIC_DIR"

# A. Architecture
cat <<'EOF' > "$TOPIC_DIR/001-A-Architecture.md"
# A. Architecture

*   i. Identity Provider (IdP) vs. Service Provider (SP).
EOF

# B. The Flow
cat <<'EOF' > "$TOPIC_DIR/002-B-The-Flow.md"
# B. The Flow

*   i. SP-Initiated vs. IdP-Initiated SSO.
EOF

# C. The Packet
cat <<'EOF' > "$TOPIC_DIR/003-C-The-Packet.md"
# C. The Packet

*   i. Analyzing the XML SAML Assertion.
EOF


# ==============================================================================
# PHASE 4: Authorization (AuthZ)
# ==============================================================================
PHASE_DIR="004-Phase-4-Authorization"
mkdir -p "$PHASE_DIR"

# --- 8. Access Control Models ---
TOPIC_DIR="$PHASE_DIR/08-Access-Control-Models"
mkdir -p "$TOPIC_DIR"

# A. RBAC (Role-Based Access Control)
cat <<'EOF' > "$TOPIC_DIR/001-A-RBAC.md"
# A. RBAC (Role-Based Access Control)

*   i. User -> Roles -> Permissions.
*   ii. Pros: Simple. Cons: Role Explosion.
EOF

# B. ABAC (Attribute-Based Access Control)
cat <<'EOF' > "$TOPIC_DIR/002-B-ABAC.md"
# B. ABAC (Attribute-Based Access Control)

*   i. Dynamic policies based on Time, Location, Department, Resource Owner.
EOF

# C. ReBAC (Relationship-Based Access Control)
cat <<'EOF' > "$TOPIC_DIR/003-C-ReBAC.md"
# C. ReBAC (Relationship-Based Access Control)

*   i. Graph-based (e.g., "User is a member of a Group that owns this Folder").
*   ii. Inspired by Google Zanzibar.
EOF

# --- 9. Implementation Architecture ---
TOPIC_DIR="$PHASE_DIR/09-Implementation-Architecture"
mkdir -p "$TOPIC_DIR"

# A. Decoupled Authorization
cat <<'EOF' > "$TOPIC_DIR/001-A-Decoupled-Authorization.md"
# A. Decoupled Authorization

*   i. Moving logic out of code and into Policy Engines.
*   ii. **OPA (Open Policy Agent)** and Rego language.
EOF

# B. Enforcement Points
cat <<'EOF' > "$TOPIC_DIR/002-B-Enforcement-Points.md"
# B. Enforcement Points

*   i. API Gateway (Coarse-grained).
*   ii. Service/Method Level (Fine-grained).
*   iii. Database Level (Row Level Security).
EOF


# ==============================================================================
# PHASE 5: Advanced Security & Future Trends
# ==============================================================================
PHASE_DIR="005-Phase-5-Advanced-Security"
mkdir -p "$PHASE_DIR"

# --- 10. MFA (Multi-Factor Authentication) ---
TOPIC_DIR="$PHASE_DIR/10-MFA"
mkdir -p "$TOPIC_DIR"

# A. Factors
cat <<'EOF' > "$TOPIC_DIR/001-A-Factors.md"
# A. Factors

*   Knowledge (Password), Possession (Phone/Key), Inherence (Biometrics).
EOF

# B. Implementation
cat <<'EOF' > "$TOPIC_DIR/002-B-Implementation.md"
# B. Implementation

*   i. TOTP (Time-based One-Time Password) - Authenticator Apps.
*   ii. SMS/Email OTP (Weak, susceptible to SIM swapping).
*   iii. Recovery Codes strategy.
EOF

# --- 11. Passwordless & FIDO2 ---
TOPIC_DIR="$PHASE_DIR/11-Passwordless-FIDO2"
mkdir -p "$TOPIC_DIR"

# A. WebAuthn API
cat <<'EOF' > "$TOPIC_DIR/001-A-WebAuthn-API.md"
# A. WebAuthn API

*   i. Public Key Cryptography in the browser.
EOF

# B. Passkeys
cat <<'EOF' > "$TOPIC_DIR/002-B-Passkeys.md"
# B. Passkeys

*   i. Syncing private keys across ecosystems (Apple/Google/Microsoft).
*   ii. Phishing resistance (Domain binding).
EOF

# --- 12. API Security Best Practices ---
TOPIC_DIR="$PHASE_DIR/12-API-Security-Best-Practices"
mkdir -p "$TOPIC_DIR"

# A. Rate Limiting & Throttling
cat <<'EOF' > "$TOPIC_DIR/001-A-Rate-Limiting.md"
# A. Rate Limiting & Throttling

*   Preventing Brute Force/DDoS on Auth endpoints.
EOF

# B. Broken Object Level Authorization (BOLA/IDOR)
cat <<'EOF' > "$TOPIC_DIR/002-B-BOLA-IDOR.md"
# B. Broken Object Level Authorization (BOLA/IDOR)

*   The #1 API vulnerability.
EOF

# C. Logging & Auditing
cat <<'EOF' > "$TOPIC_DIR/003-C-Logging-Auditing.md"
# C. Logging & Auditing

*   What to log (User ID, IP) and what NOT to log (Tokens, Passwords).
EOF

echo "Done! Hierarchy created in '$ROOT_DIR'"
