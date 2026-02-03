Based on the Table of Contents provided, specifically **Part 11: Authorization Server Implementation**, here is a detailed explanation of section **060-Client-Management**.

---

# 060 - Client Management

In the context of building an Authorization Server (AS), **Client Management** refers to the backend logic, database structures, and administrative interfaces required to register, configure, and control the applications ("Clients") that are allowed to request tokens from your server.

Without a robust Client Management system, your Authorization Server cannot distinguish between a legitimate application (like your company's mobile app) and a malicious script trying to steal user data.

Here is a breakdown of the three key pillars of Client Management:

## 1. Registration Workflows
This defines **how** an application becomes known to the Authorization Server. You cannot issue a token to a `client_id` that doesn't exist in your database.

### Types of Registration
*   **Manual (Static) Registration:**
    *   **Workflow:** An administrator logs into the Authorization Server’s admin console, clicks "Create Client," and manually types in the details.
    *   **Use Case:** Internal applications, first-party apps, or high-security environments where you want strict control over who integrates with your API.
*   **Self-Service Developer Portal:**
    *   **Workflow:** A third-party developer logs into a portal (like "Login with Google" or "Facebook for Developers"), creates a project, and the system automatically generates a Client ID and Secret.
    *   **Implementation:** The AS needs a frontend portals and APIs to handle these requests automatically.
*   **Dynamic Client Registration (RFC 7591):**
    *   **Workflow:** The client application makes a POST request to a registration endpoint on the AS to register itself programmatically.
    *   **Use Case:** Open ecosystem standards like Open Banking or Mobile Connect, where manual registration doesn't scale.

### Critical Data to Store
When implementing the database schema for a Client, you must store:
*   **Client ID:** The public identifier (unique index).
*   **Client Name/Logo:** For the Consent Screen (so users know *who* is asking for access).
*   **Allowed Redirect URIs:** **(Security Critical)** The specific URLs where the AS is allowed to send tokens/codes. If this is not strictly managed, you open the door to code interception attacks.
*   **Client Type:** Confidential (server-side) vs. Public (SPA/Mobile).

## 2. Secret Management & Rotation
Confidential clients require credentials to authenticate themselves to the Authorization Server (e.g., when exchanging a code for a token).

### Storage Best Practices
*   **Hashing:** Never store `client_secret` in plain text. It should be hashed (e.g., using bcrypt or Argon2), exactly like user passwords.
*   **Encryption:** If the AS needs to display the secret back to the user once (upon creation), it might be encrypted, but hashing is generally preferred for security.

### Secret Rotation
Secrets can be leaked (committed to GitHub, hardcoded in apps). The Client Management system must support **Rotation** without downtime.
1.  **Dual-Secret Support:** The AS implementation should allow a single Client to have *multiple* active secrets simultaneously.
2.  **The Rotation Flow:**
    *   The Admin generates a **New Secret**.
    *   The AS accepts both **Old Secret** and **New Secret**.
    *   The Developer updates their application to use the **New Secret**.
    *   The Admin revokes/deletes the **Old Secret**.
    *   *Result:* No downtime for the end-users.

### Alternative Credentials
Advanced Client Management systems support authenticators beyond shared secrets:
*   **mTLS (Mutual TLS):** Storing the Subject DN or a reference to the Client's X.509 certificate.
*   **Private Key JWT:** Storing the Client's Public Key (JWK) to verify signed assertions.

## 3. Client Policy Enforcement
Not all clients are created equal. Your implementation must allow granular configuration of what each specific client is *allowed* to do.

### Grant Type Restrictions
*   Does this client have permission to use the `client_credentials` grant?
*   *Implementation:* If a SPA (Single Page App) tries to use `client_credentials`, the AS should reject it because SPAs cannot keep secrets safe.
*   *Strict Rule:* Explicitly whitelist allowed Grant Types per client (e.g., "Client A" can only use `authorization_code`, while "Client B" can use `client_credentials`).

### Scope Restrictions
*   **Scope Whitelisting:** Even if a user consents, the Client should not be allowed to ask for scopes it hasn't been pre-approved for.
*   *Example:* A "Weather Widget" app should generally not be allowed to request the `delete_user_account` scope. The Client Management system validates requested scopes against the client's "Allowed Scopes" list.

### Token Configuration
Different clients may need different security postures:
*   **Access Token Lifetime:** An internal banking dashboard might get a 10-minute token, while a music player app might get a 1-hour token.
*   **Refresh Token policies:** Does this client get a refresh token? Does it rotate? How long does it last?
*   **PKCE Enforcement:** For modern implementations, the system should have a toggle (or default setting) to **require** PKCE for every request coming from specific clients.

---

### Summary for Developers
When implementing **Section 060 (Client Management)**, you are essentially building the **User Profile system for Applications**. You need to build:
1.  **The Database Schema:** To hold IDs, secrets, redirect URIs, and policy flags.
2.  **The Admin API/UI:** To allow admins to onboard apps and rotate keys.
3.  **The Validation Logic:** Middleware that checks "Is this Client ID valid?", "Is this Redirect URI whitelisted?", and "Is this Grant Type allowed for this client?" during every auth request.
