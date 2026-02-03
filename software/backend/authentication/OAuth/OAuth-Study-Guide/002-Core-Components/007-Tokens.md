Based on the Table of Contents you provided, **Section 7: Tokens** falls under **Part 2: Core Components**. This is a fundamental section because tokens are the currency of the OAuth framework. Without tokens, authorization cannot be transported from the server to the client and finally to the API.

Here is a detailed explanation of each concept within Section 7.

---

# Detailed Explanation: 7. Tokens

In OAuth 2.0, tokens are digital keys that grant access to specific resources. They replace the user's actual username and password, allowing a user to grant limited access to an application without sharing their permanent credentials.

## 1. Access Tokens
The **Access Token** is the most critical component in OAuth 2.0.

*   **Definition:** A credential used by the **Client** to access a **Protected Resource**.
*   **Role:** It is the "key" the application sends to the API (Resource Server). The API checks this token to decide whether to let the request through.
*   **Characteristics:**
    *   **Short-lived:** Usually valid for a short time (e.g., 5 minutes to 1 hour) to minimize security risks if stolen.
    *   **Scoped:** It does not represent the user's full identity; it represents a specific set of permissions (scopes) granted by the user (e.g., `read:email`).
*   **How it works:** The Client typically sends this in the HTTP Header:
    ```http
    Authorization: Bearer <access_token_string>
    ```

## 2. Refresh Tokens
The **Refresh Token** solves the user experience problem created by short-lived Access Tokens.

*   **The Problem:** If Access Tokens expire every 15 minutes, the user would have to log in and approve the app 4 times an hour. This is bad UX.
*   **The Solution:** When the Authorization Server issues an Access Token, it may also issue a Refresh Token.
*   **Role:** The Client uses the Refresh Token to get a *new* Access Token when the old one expires, **without** involving the user.
*   **Security Constraints:**
    *   **Never sent to the Resource Server (API):** Typically only sent to the Authorization Server.
    *   **Long-lived:** Can be valid for days, months, or years.
    *   **Strict Storage:** Because they are powerful and long-lived, they must be stored very securely (e.g., in secure storage on mobile devices, or distinct HttpOnly cookies for web apps).

## 3. Token Types (Bearer, PoP, DPoP)
This refers to **how** the token is used and verified.

*   **Bearer Tokens:**
    *   *Concept:* "Give access to the bearer of this token."
    *   *Analogy:* Cash. If you drop a $20 bill and someone picks it up, they can use it. There is no ID check.
    *   *Risk:* If a hacker steals a Bearer token, they can use it immediately. This is the most common type used today.
*   **PoP (Proof of Possession):**
    *   *Concept:* The token is mathematically bound to a cryptographic key held by the Client.
    *   *Analogy:* A credit card with a PIN or signature. Even if you steal the card, you can't use it without the PIN/Signature.
    *   *Mechanism:* The API challenges the client to sign the request with a private key.
*   **DPoP (Demonstrating Proof of Possession):**
    *   The modern standard (RFC 9449) for implementing PoP at the application layer.
    *   It prevents **Token Replay Attacks** (where a stolen token is reused by an attacker).

## 4. Token Formats (Opaque vs. Structured)
This refers to the internal structure of the token string. The OAuth spec does not dictate the format, but there are two standard approaches:

### A. Opaque Tokens (Reference Tokens)
*   **Structure:** A random string of characters (e.g., `89d3-f542-a87d...`).
*   **Meaning:** The string means nothing to the API holding the data.
*   **Validation:** The API must send the token back to the Authorization Server (via the **Introspection Endpoint**) to ask: "Is this valid? Who is it for?"
*   **Pros:** Highly secure; tokens can be revoked instantly.
*   **Cons:** Performance hit (requires a network call for every validate check).

### B. Structured Tokens (Value Tokens / JWT)
*   **Structure:** Usually a **JSON Web Token (JWT)**. It is a long, encoded string containing data (claims).
*   **Meaning:** The token contains the data inside itself (User ID, Expiry, Scopes).
*   **Validation:** The API verifies the digital signature of the token locally using a public key. It does *not* need to call the Authorization Server.
*   **Pros:** Very fast and scalable (Stateless).
*   **Cons:** Harder to revoke immediately (requires short lifetimes or blacklisting).

## 5. Token Lifetime & Expiration
Tokens do not last forever for security reasons.

*   **Access Token Lifetime:** Kept short (seconds to minutes). This limits the "blast radius" if a token is intercepted.
*   **Refresh Token Lifetime:** Kept long (days to months) but usually involves **Rotation**.
    *   *Rotation:* Every time a Refresh Token is used, the server issues a brand new Refresh Token and invalidates the old one. If an attacker tries to use an old Refresh Token, the server detects theft and revokes everything.
*   **Metadata:** When a token is issued, the response usually includes `expires_in` (seconds), allowing the client to calculate exactly when to ask for a new one.

## 6. Token Metadata
When an Authorization Server issues a token, it sends a JSON response. The token is the main actor, but the metadata explains how to use it.

**Example Response:**
```json
{
  "access_token": "eyJhbGciOiJIUz...",    // The Token itself
  "token_type": "Bearer",                 // How to use it (Header format)
  "expires_in": 3600,                     // Lifetime in seconds
  "refresh_token": "8xlo8f...",           // The tool to get a new logical session
  "scope": "read:profile write:posts"     // Exactly what permission was granted
}
```

*   **Scope Metadata:** Crucial because the user might have approved *fewer* permissions than the app asked for. The app must check this to know what features to enable/disable.

---

### Summary Table

| Component | Purpose | Key Attribute |
| :--- | :--- | :--- |
| **Access Token** | Accessing the API | Short-lived, used frequently. |
| **Refresh Token** | Getting new Access Tokens | Long-lived, kept secret, used rarely. |
| **Bearer Token** | Usage Method | "Whoever holds it owns it." (Standard) |
| **JWT** | Format | Self-contained, stateless validation. |
| **Opaque** | Format | Random string, requires server lookup. |
