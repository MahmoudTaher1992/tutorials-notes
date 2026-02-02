# 📚 The Engineering Master Plan: Backend AuthN & AuthZ

## Phase 1: The Core Foundations
*Goal: Understand the primitives before using the frameworks.*

*   **1. HTTP & Cryptography Basics**
    *   **A. Transport Security**
        *   i. TLS/SSL Handshake (Why HTTPS is non-negotiable).
        *   ii. Man-in-the-Middle (MitM) attacks.
    *   **B. Cryptographic Primitives**
        *   i. **Hashing vs. Encryption vs. Encoding** (Base64 is NOT encryption).
        *   ii. **Symmetric Encryption** (Shared Secret) vs. **Asymmetric Encryption** (Public/Private Key).
        *   iii. Digital Signatures (Ensuring integrity).

*   **2. Credential Management (The "User" Database)**
    *   **A. Storing Passwords Securely**
        *   i. **Evolution:** Plaintext $\rightarrow$ MD5 $\rightarrow$ SHA-256 $\rightarrow$ Salted Hash $\rightarrow$ Adaptive Algorithms.
        *   ii. **Modern Standards:** Argon2id (Best), bcrypt, scrypt, PBKDF2.
        *   iii. **Entropy & Salting:** Preventing Rainbow Table attacks.
    *   **B. Defensive Measures**
        *   i. Account Lockout Policies vs. Exponential Backoff.
        *   ii. Credential Stuffing detection.

## Phase 2: Authentication Strategies (AuthN)
*Goal: Managing "Who the user is" in stateful and stateless environments.*

*   **3. Stateful Authentication (Session-Based)**
    *   **A. The Lifecycle**
        *   i. Login $\rightarrow$ Server generates `session_id` $\rightarrow$ Stores in Redis/DB $\rightarrow$ Sends Cookie.
    *   **B. Cookie Security Hardening**
        *   i. `HttpOnly` (Prevent XSS theft).
        *   ii. `Secure` (HTTPS only).
        *   iii. `SameSite` (Lax/Strict) to prevent CSRF.
        *   iv. `Domain` and `Path` scoping.
    *   **C. Scaling Issues:** The "Sticky Session" problem and distributed stores (Redis).

*   **4. Stateless Authentication (Token-Based)**
    *   **A. JSON Web Tokens (JWT) Deep Dive**
        *   i. **Structure:** Header, Payload (Claims), Signature.
        *   ii. **JWS (Signed)** vs. **JWE (Encrypted)**: Do you need to hide the payload data?
        *   iii. **Signing Algorithms:** HS256 (Symmetric) vs. RS256/ES256 (Asymmetric).
    *   **B. The Storage Debate**
        *   i. **LocalStorage:** Vulnerable to XSS.
        *   ii. **HttpOnly Cookie:** Vulnerable to CSRF (but mitigated by SameSite/tokens).
        *   iii. **The BFF Pattern (Backend for Frontend):** Keeping tokens completely off the client-side.
    *   **C. Token Lifecycle & Security**
        *   i. **Access Tokens vs. Refresh Tokens:** Why short lifespans matter.
        *   ii. **Refresh Token Rotation:** Preventing token theft replay attacks.
        *   iii. **Revocation Strategies:**
            *   Blocklisting (Redis).
            *   Versioned Tokens (Database lookup).
            *   Short expiration times.

## Phase 3: Delegated Auth & Federation (OAuth2 / OIDC)
*Goal: "Login with Google" and Microservices Identity.*

*   **5. OAuth 2.0 Framework (Authorization)**
    *   **A. Roles & Terminology**
        *   Resource Owner, Client, Auth Server (AS), Resource Server (RS).
    *   **B. Grant Types (The Flows)**
        *   i. **Authorization Code Flow with PKCE:** The *Gold Standard* for Mobile/SPA/Web.
        *   ii. **Client Credentials Flow:** Machine-to-Machine (M2M) communication.
        *   iii. **Deprecated Flows:** Implicit Flow and Password Grant (Why they are insecure).
    *   **C. Scopes & Consent:** Designing granular permission requests.

*   **6. OpenID Connect (OIDC) (Identity)**
    *   **A. The Identity Layer**
        *   i. How OIDC standardizes the UserInfo endpoint and ID Token.
    *   **B. The ID Token**
        *   i. Format (JWT).
        *   ii. Audience (`aud`), Issuer (`iss`), and Subject (`sub`) validation.
    *   **C. Discovery:** The `/.well-known/openid-configuration` endpoint.

*   **7. Enterprise SSO (SAML 2.0)**
    *   **A. Architecture**
        *   i. Identity Provider (IdP) vs. Service Provider (SP).
    *   **B. The Flow**
        *   i. SP-Initiated vs. IdP-Initiated SSO.
    *   **C. The Packet:** Analyzing the XML SAML Assertion.

## Phase 4: Authorization (AuthZ)
*Goal: Controlling "What the user can do."*

*   **8. Access Control Models**
    *   **A. RBAC (Role-Based Access Control)**
        *   i. User $\rightarrow$ Roles $\rightarrow$ Permissions.
        *   ii. Pros: Simple. Cons: Role Explosion.
    *   **B. ABAC (Attribute-Based Access Control)**
        *   i. Dynamic policies based on Time, Location, Department, Resource Owner.
    *   **C. ReBAC (Relationship-Based Access Control)**
        *   i. Graph-based (e.g., "User is a member of a Group that owns this Folder").
        *   ii. Inspired by Google Zanzibar.

*   **9. Implementation Architecture**
    *   **A. Decoupled Authorization**
        *   i. Moving logic out of code and into Policy Engines.
        *   ii. **OPA (Open Policy Agent)** and Rego language.
    *   **B. Enforcement Points**
        *   i. API Gateway (Coarse-grained).
        *   ii. Service/Method Level (Fine-grained).
        *   iii. Database Level (Row Level Security).

## Phase 5: Advanced Security & Future Trends
*Goal: Protecting against sophisticated attacks and removing passwords.*

*   **10. MFA (Multi-Factor Authentication)**
    *   **A. Factors:** Knowledge (Password), Possession (Phone/Key), Inherence (Biometrics).
    *   **B. Implementation:**
        *   i. TOTP (Time-based One-Time Password) - Authenticator Apps.
        *   ii. SMS/Email OTP (Weak, susceptible to SIM swapping).
        *   iii. Recovery Codes strategy.

*   **11. Passwordless & FIDO2**
    *   **A. WebAuthn API**
        *   i. Public Key Cryptography in the browser.
    *   **B. Passkeys**
        *   i. Syncing private keys across ecosystems (Apple/Google/Microsoft).
        *   ii. Phishing resistance (Domain binding).

*   **12. API Security Best Practices**
    *   **A. Rate Limiting & Throttling:** Preventing Brute Force/DDoS on Auth endpoints.
    *   **B. Broken Object Level Authorization (BOLA/IDOR):** The #1 API vulnerability.
    *   **C. Logging & Auditing:** What to log (User ID, IP) and what NOT to log (Tokens, Passwords).