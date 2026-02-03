Based on the Table of Contents you provided, here is a detailed explanation of **Part 10, Item 37: Debugging & Troubleshooting**.

This section focuses on the practical skills required to fix issues when OpenID Connect integrations fail. Because OIDC relies on strict protocols, cryptography, and HTTP redirects, "silent failures" are common.

Here is the detailed breakdown of that module:

---

# 1. Common Errors & Solutions
OIDC defines specific error codes (RFC 6749). Understanding what these codes actually mean is half the battle.

### `redirect_uri_mismatch`
*   **The Symptom:** The user logs in at the Provider (e.g., Google/Auth0), but when trying to return to your app, they see an error page on the Provider's side.
*   **The Cause:** The `redirect_uri` you sent in the authorization request does not **exactly** match one of the URIs whitelisted in the Provider’s dashboard.
*   **The Fix:** Check for trailing slashes (`/`), HTTP vs HTTPS, and port numbers. `http://localhost:3000/callback` is not the same as `http://localhost:3000/callback/`.

### `invalid_client`
*   **The Symptom:** The exchange of an Authorization Code for a Token fails (Backend-to-Server).
*   **The Cause:** Wrong Client ID, wrong Client Secret, or the Authentication method (Basic Auth vs. POST body) is incorrect.
*   **The Fix:** Regenerate the secret and ensure the Basic Auth header is base64 encoded correctly (`client_id:client_secret`).

### `invalid_grant`
*   **The Symptom:** A user was logged in, but suddenly their refresh token stops working, or the initial code exchange fails.
*   **The Cause:**
    *   The Authorization Code has already been used (codes are one-time use).
    *   The Authorization Code expired (usually valid for only 60 seconds).
    *   The Refresh Token has been revoked or expired.

### `nonce` or `state` Mismatch
*   **The Symptom:** The Provider redirects back to your app, but your app rejects the login immediately.
*   **The Cause:**
    *   **State:** The random string sent to prevent CSRF attacks didn't match what returned.
    *   **Nonce:** The random string sent to prevent replay attacks is not present in the ID Token Claims.
*   **The Fix:** Ensure your client library is storing these values (in cookies or local storage) before redirecting the user, so it can compare them upon return.

---

# 2. Decoding & Inspecting JWTs
The **ID Token** and **Access Token** are usually JSON Web Tokens (JWTs). You cannot debug them effectively without looking inside.

### The Tool
Use [jwt.io](https://jwt.io) or a CLI tool like `step-cli` to decode tokens.
*   *Warning:* **Never** paste a production token into a public website debugger. Use local tools for real user data.

### What to inspect in the Payload:
1.  **`iss` (Issuer):** Does this match your configuration? (e.g., `https://accounts.google.com` vs `accounts.google.com`). A mismatch causes validation failure.
2.  **`aud` (Audience):** Does this match your Client ID? If the token was meant for a different app, your API should reject it.
3.  **`exp` (Expiration):** Is the current time (`Date.now() / 1000`) greater than this verification timestamp?
4.  **`iat` (Issued At):** Was this token issued in the future? (Clock skew issues between your server and the Identity Provider).

### What to inspect in the Header:
1.  **`alg`:** Is it `RS256` (Asymmetric) or `HS256` (Symmetric)? If your code expects a public key check but receives an HS256 token signed with a secret, it is a vulnerability.
2.  **`kid` (Key ID):** Does this key ID exist in the Provider's JWKS endpoint (`/.well-known/jwks.json`)? If not, the provider rolled over their keys, and your app hasn't refreshed its cache.

---

# 3. Network Traffic Analysis
OIDC is an HTTP-heavy protocol. You need to verify exactly what is being sent over the wire.

### Browser Tools (Chrome/Firefox DevTools)
1.  **Preserve Log:** Validation errors happen during redirects. Open the Network tab and check the "Preserve Log" box. Without this, the browser clears the logs when the page refreshes/redirects, and you lose the error data.
2.  **The Authorize Request:** Look for the first call to the IdP. Check the query parameters:
    *   Are `scope`, `response_type`, and `client_id` correct?
3.  **The Callback:** Look for the request returning to your application.
    *   Does the URL verify contain `code=` or `error=access_denied`?

### Advanced Proxies (Burp Suite, Fiddler, Charles)
Sometimes browser tools aren't enough (e.g., debugging a Mobile App or a Server-Side call).
*   **HTTPS Interception:** These tools install a root certificate on your machine to decrypt HTTPS traffic.
*   **Use verification:** Verify that your server is sending the `Authorization: Basic <base64>` header correctly during the back-channel token exchange.

---

# 4. Logging Best Practices
When your code is running on a server, logs are your only eyes.

### What NOT to Log (Security Risk)
*   **Full Access/Refresh Tokens:** If your logs are leaked, attackers can hijack user sessions.
*   **Client Secrets:** Never output configuration objects to logs without redaction.
*   **PII (Personally Identifiable Information):** Be careful logging the raw `id_token` if it contains emails or addresses, depending on GDPR/Compliance rules.

### What TO Log
1.  **Correlation IDs:** Generate a unique ID at the start of the login flow and pass it through. This allows you to find all logs related to a single user's failed login attempt.
2.  **Token Metadata:** Log the `exp` (expiration), `sub` (user ID), and `kid` (key ID)—but not the signature/content.
    *   *Example:* `Login failed for User <sub-hash>: Token expired at <timestamp>`
3.  **Upstream Usage:** Log the specific HTTP Status Code and Body returned by the Identity Provider (e.g., "Provider returned 400 Bad Request: Invalid Scope").

---

# Summary Checklist for Troubleshooting
If you are stuck, run through this order:

1.  **Configuration Check:** Do Client ID, Secret, and Redirect URIs match exact strings in the IDP dashboard?
2.  **Discovery Check:** Can your server reach `/.well-known/openid-configuration`?
3.  **Clock Check:** Is your server's system time synced? (NTP)
4.  **Network Trace:** Use "Preserve Log" to see if the error is happening *sending* to the provider or *returning* from it.
5.  **Decode:** Crack open the JWT to ensure the claims match what your code expects.
