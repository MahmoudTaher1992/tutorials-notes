Based on **Section 34: Security Mitigations** of your provided study guide, here is a detailed explanation of the essential defensive mechanisms used to secure OAuth 2.0 implementations.

These mitigations are critical because OAuth relies heavily on browser redirects and bearer tokens, both of which have specific attack vectors.

---

### 1. State Parameter for CSRF Protection

The **State** parameter is the classic defense against **Cross-Site Request Forgery (CSRF)**, specifically "Login CSRF" or "Client-Side CSRF."

*   **The Attack:** An attacker starts an authorization flow on their own device, gets an Authorization Code, but stops before exchanging it. They then trick a victim (e.g., via a phishing link) into clicking a link that resumes *the attacker's* flow on the *victim's* browser. The victim logs in, but the application links the victim's session to the *attacker's* external account.
*   **The Mitigation:**
    1.  **Generate:** The Client generates a random, cryptographically secure string (the `state`) before sending the user to the Authorization Server (AS).
    2.  **Store:** The Client stores this string temporarily (e.g., in a secure cookie or session storage).
    3.  **Send:** The Client includes `&state=xyz123` in the authorization request URL.
    4.  **Verify:** The AS returns the exact same state value in the redirect response (`code=...&state=xyz123`). The Client compares the returned state with the stored state. If they don't match, the request stops.

### 2. PKCE (Proof Key for Code Exchange) for Code Interception

PKCE (pronounced "pixy") is the modern standard for preventing **Authorization Code Interception attacks**.

*   **The Attack:** Primarily affects mobile and native apps using Custom URI Schemes (e.g., `myapp://`). A malicious app installed on the user's device registers the same URI scheme. When the Authorization Server redirects the user back with the Code, the malicious app intercepts it and exchanges it for a token.
*   **The Mitigation:**
    1.  **Code Verifier:** The Client generates a random secret string (the `code_verifier`).
    2.  **Code Challenge:** The Client hashes this secret (SHA-256) to create a `code_challenge`.
    3.  **Auth Request:** The Client sends the `code_challenge` (not the secret) in the authorization request.
    4.  **Token Request:** After getting the auth code, the Client sends the code *and* the original raw `code_verifier` to the Token Endpoint.
    5.  **Validation:** The server hashes the `code_verifier` just received. It must match the `code_challenge` sent in step 3. The attacker cannot swap the code because they don't have the original `code_verifier`.

### 3. Exact Redirect URI Matching

This prevents **Open Redirector** and **Token Leakage** attacks.

*   **The Attack:** If an Authorization Server allows "fuzzy" matching (e.g., allowing any URL that starts with `https://client.com/`), an attacker can craft a link like `https://client.com/oauth/callback?forward_to=attacker.com`. The code is sent to the legitimate domain but immediately forwarded to the attacker via an open direct vulnerability on the client.
*   **The Mitigation:**
    *   The Authorization Server must compare the `redirect_uri` string sent in the request **character-for-character** against the URI registered during client setup.
    *   No wildcards (`*`) and no partial matching should be allowed. `https://app.com/callback` is distinct from `https://app.com/callback/`.

### 4. TLS Everywhere (Transport Layer Security)

This is the baseline requirement for OAuth 2.0 to prevent **Man-in-the-Middle (MitM) attacks**.

*   **The Attack:** An attacker on the same network (e.g., public API, Coffee Shop WiFi) sniffs the traffic. If HTTP is used, they can read the Authorization Code, Access Token, or Client Secret in plain text.
*   **The Mitigation:**
    *   All endpoints (Authorization, Token, UserInfo, API) must use **HTTPS**.
    *   Requests explicitly made over plain HTTP should be rejected by the server with an error.

### 5. Short-Lived Access Tokens

This mitigates the blast radius of **Token Theft**.

*   **The Attack:** An attacker manages to steal an Access Token (e.g., via XSS or browser history). They can now access the user's data.
*   **The Mitigation:**
    *   Access Tokens should expire quickly (e.g., 5 to 15 minutes).
    *   If a token is stolen, the attacker only has a small window of opportunity to use it.
    *   When the token expires, the legitimate application uses a Refresh Token to get a new one. The attacker (presumably) does not have the Refresh Token.

### 6. Refresh Token Rotation

This is a critical defense for public clients (SPAs, Mobile Apps) that cannot keep secrets safe.

*   **The Attack:** If a Refresh Token (which is long-lived) is stolen, the attacker can generate new Access Tokens indefinitely.
*   **The Mitigation:**
    *   **One-time use:** Every time a Client uses a Refresh Token to get a new Access Token, the Authorization Server returns a fresh Access Token *and* a **new** Refresh Token.
    *   **The Kick:** The old Refresh Token is immediately invalidated.
    *   **The Alarm:** If the Authorization Server receives a request using an *already used* (old) Refresh Token, it assumes theft has occurred. It immediately **revokes the entire chain** (the new refresh token and all active access tokens for that user/device).

### 7. Token Binding / Sender-Constraining

This prevents **Bearer Token Replay** attacks completely.

*   **The Attack:** A standard OAuth token is a "Bearer" token—like cash. Whoever holds it can spend it. If stolen, the thief looks just like the legitimate user.
*   **The Mitigation:** "Sender-Constrained" tokens bind the token to something only the legitimate client possesses.
    *   **mTLS (RFC 8705):** The token is bound to the Client's TLS Certificate. The API verifies that the entity using the token is using the same Certificate used to request it.
    *   **DPoP (Demonstrating Proof-of-Possession - RFC 9449):** The Client generates a simplified public/private key pair. The token is bound to the public key. To use the token, the client must sign the request with the private key. A thief cannot use the stolen token without the private key.

### 8. `iss` (Issuer) Parameter for Mix-Up Prevention

This protects against **Mix-Up Attacks**.

*   **The Attack:** This is complex but dangerous. It happens when a Client supports multiple Identity Providers (e.g., "Log in with Google" and "Log in with Malicious-IdP").
    1.  The attacker tricks the Client into thinking the user wants to log in with "Malicious-IdP."
    2.  The Client sends the user to the Malicious-IdP.
    3.  The Malicious-IdP immediately redirects the user to the *Honest-IdP* (e.g., Google).
    4.  The user logs into Google and returns a code.
    5.  The Client (confused) sends that Google code to the Malicious-IdP (thinking that's who initiated the flow).
    6.  The Attacker now has a valid Google code for the user.
*   **The Mitigation:**
    *   The Authorization Server includes an `iss` (Issuer) parameter in the redirect response (alongside the `code`).
    *   `https://client.com/callback?code=abc...&iss=https://google.com`
    *   The Client checks the `iss`. If the Client thought it was talking to "Malicious-IdP" but receives an `iss` saying "Google," it detects the mismatch and aborts.
