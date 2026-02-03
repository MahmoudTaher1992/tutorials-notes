This section of the study guide focuses on the "Engine Room" of the Authorization Server (AS). It deals with the architectural decisions and plumbing required to create, secure, store, and invalidate the actual strings (tokens) that grant access to APIs.

Here is a detailed explanation of **Section 59: Token Generation & Management**.

---

### 1. Token Format Selection
Before writing any code, you must decide *what* your tokens look like. This is usually a choice between **Structured (By-Value)** and **Opaque (By-Reference)** tokens.

#### **A. Structured Tokens (JWT - JSON Web Tokens)**
*   **What it is:** A self-contained JSON object containing claims (data) that is cryptographically signed (RFC 7519).
*   **How it works:** The Authorization Server (AS) packs user data (User ID, scopes, expiration) into the token and signs it. The Resource Server (API) validates the signature mathematically without calling the AS.
*   **Pros:** Reduces network traffic (stateless validation); contains all necessary info for the API.
*   **Cons:** Can be large (increasing bandwidth); hard to revoke before expiration; potential to leak PII (Personally Identifiable Information) if not encrypted.
*   **Best for:** Internal microservices, scalable architectures where reducing AS load is critical.

#### **B. Opaque Tokens (Reference Tokens)**
*   **What it is:** A random string of characters (e.g., a UUID) with no inherent meaning.
*   **How it works:** The token is a "key" map pointing to data stored in the Authorization Server's database. The Resource Server must ask the AS (via Introspection) "Is this token valid? Who is it for?"
*   **Pros:** Small size; safe to pass to public clients; immediate revocation (just delete the DB entry); no data leakage.
*   **Cons:** Higher latency (requires a network call for every underlying API request); higher load on the Authorization Server.
*   **Best for:** Public clients (SPAs, Mobile), sensitive environments where immediate revocation is mandatory.

#### **C. The Phantom Token Pattern (Hybrid)**
*   A popular architectural pattern where the AS issues **Opaque** tokens to the outside world (Frontend/Mobile), but an API Gateway intercepts requests, swaps the Opaque token for a **JWT**, and passes the JWT to backend services. This offers the security of Opaque tokens with the performance of JWTs.

---

### 2. Signing Keys Management
If you choose JWTs, you need to manage the cryptography. This is how the API trusts that the AS actually created the token.

#### **A. Key Algorithms**
*   **Symmetric (HS256):** The AS and the API share a single "Secret Password." Fast, but dangerous. If the API is compromised, the attacker can mint fake tokens. **Avoid for microservices.**
*   **Asymmetric (RS256, ES256 - Recommended):** Public/Private key pair. The AS signs with a **Private Key** (kept hidden). The APIs verify with a **Public Key** (widely shared).

#### **B. JWKS (JSON Web Key Set)**
*   The AS exposes a public endpoint (usually `/.well-known/jwks.json`) containing the Public Keys.
*   Resource Servers periodically cache this JSON file to validate incoming tokens.

#### **C. Key Rotation**
*   You cannot use the same signing key forever (security risk). You must implement **Key Rotation**.
*   **The Process:**
    1.  Generate a new Key Pair via a background job.
    2.  Add the new Public Key to the JWKS endpoint.
    3.  Begin signing *new* tokens with the new Private Key.
    4.  Keep the old Public Key in the JWKS until the last token signed with the old key expires.
*   **`kid` (Key ID):** Every JWT header includes a `kid`. The API looks at the `kid`, finds the matching key in the JWKS, and verifies the signature.

---

### 3. Token Storage & Indexing
Even if using stateless JWTs (which don't technically *need* storage to work), you almost always need a persistence layer for Refresh Tokens and Authorization Codes.

#### **A. Security at Rest (Hashing)**
*   **Never store tokens in plain text.** If your database is leaked, attackers have access to everyone's accounts.
*   Store a **Hash** of the token (e.g., SHA-256).
    *   *Incoming Request:* Client sends `abc-123`.
    *   *Lookup:* Server hashes `abc-123` -> `x7z...` and looks for `x7z...` in the DB.

#### **B. Storage Technologies**
*   **Redis/Memcached:** Excellent for short-lived items like Authorization Codes, Nonces, or caching Introspection results.
*   **RDBMS (Postgres/MySQL) or NoSQL:** Better for long-lived Refresh Tokens that need relational mapping to users and clients.

#### **C. Indexing Strategies**
To ensure the AS is performant, you must index the token table correctly:
*   **By Token Hash:** For fast validation/lookup.
*   **By User ID (`sub`):** Essential for "Log out of all devices" functionality (find and delete all tokens belonging to User X).
*   **By Client ID:** To handle "Revoke access for this specific App."
*   **By Expiration Date:** To run cleanup jobs (identifying and deleting dead tokens).

---

### 4. Revocation Implementation
This refers to RFC 7009. How do you cancel a token *before* its natural expiration time (e.g., user clicks "Logout," admin bans user, device is stolen)?

#### **A. Revoking Refresh Tokens**
*   This is straightforward because Refresh Tokens usually live in a database.
*   **Action:** Delete the row from the database (or mark it `is_active=false`).
*   **Result:** When the client tries to use the Refresh Token to get a new Access Token, the AS rejects the request.

#### **B. Revoking Access Tokens (The Hard Part)**
*   **Opaque Tokens:** Easy. Delete the token from the DB. Subsequent introspection calls will fail immediately.
*   **JWTs:** Hard. Once a JWT is issued, it is valid until its `exp` timestamp, even if the user is banned in the database.
    *   *Solution 1: Short Lifetimes:* Make Access Tokens expire quickly (e.g., 5-10 minutes). Revocation is only delayed by a few minutes.
    *   *Solution 2: Deny Lists (Blocklists):* If you must revoke immediately, store the JWT's unique ID (`jti`) in a global Redis cache (Deny List). APIs must check this cache for every request. (Note: This negates the stateless benefit of JWTs).

#### **C. Cascading Revocation**
*   If a **Refresh Token** is revoked (or a "Family" of tokens in *Refresh Token Rotation*), the system must ensure that any associated Access Tokens are also considered invalid during introspection or denied during rotation attempts.
