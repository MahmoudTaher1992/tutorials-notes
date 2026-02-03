Based on topic **68. Debugging & Troubleshooting** from the Table of Contents, here is a detailed explanation of how to diagnose and fix issues within an OAuth 2.0/2.1 implementation.

OAuth is a complex protocol involving multiple parties (User, Client App, Authorization Server, Resource Server) exchanging messages via HTTP redirects and API calls. When it breaks, it usually breaks due to configuration mismatches, network issues, or token invalidity.

Here is a breakdown of the four sub-topics:

---

### 1. Common Errors & Solutions
OAuth 2.0 defines standard error codes (RFC 6749). Understanding these is the first step in debugging.

#### A. `redirect_uri_mismatch`
*   **The Symptom:** The user clicks "Login," gets redirected to the Authorization Server, and immediately sees an error page.
*   **The Cause:** The `redirect_uri` parameter sent in the request does not **exactly** match the URI pre-registered for that Client ID in the Authorization Server.
*   **The Fix:**
    *   Check for trailing slashes (`/callback` vs `/callback/`).
    *   Check for HTTP vs HTTPS (especially during local development).
    *   Ensure URL encoding is correct.
    *   **Note:** In OAuth 2.1, exact string matching is mandatory; wildcards are generally forbidden.

#### B. `invalid_client`
*   **The Symptom:** FAILS at the Token Endpoint. The application cannot exchange a code for a token.
*   **The Cause:** Authentication failed for the client application.
*   **The Fix:**
    *   Verify the `client_id` and `client_secret` are correct.
    *   Check the Authentication Method. Is the server expecting Basic Auth header (`Authorization: Basic base64(id:secret)`), but you sent params in the POST body? Or vice versa?

#### C. `invalid_grant`
*   **The Symptom:** FAILS at the Token Endpoint.
*   **The Cause:** The provided Authorization Code or Refresh Token is invalid, expired, revoked, or has already been used.
*   **The Fix:**
    *   **Codes:** Authorization codes are usually valid for only 30-60 seconds and are one-time use. Ensure your app isn't retrying the request automatically.
    *   **Refresh Tokens:** Use database logs to check if the user revoked access or if the token expired.

#### D. `unauthorized_client`
*   **The Symptom:** The client is not allowed to use this specific flow (Grant Type).
*   **The Cause:** For example, a "Public" client (SPA) trying to use the "Client Credentials" flow, or a client requesting a Grant Type that wasn't enabled during registration.
*   **The Fix:** Update the client configuration in the Authorization Server to allow the specific `grant_type`.

#### E. `CORS Error` (Cross-Origin Resource Sharing)
*   **The Symptom:** Browser console shows red CORS errors.
*   **The Cause:** A JavaScript app (SPA) is trying to hit the Token Endpoint or UserInfo Endpoint, but the Auth Server doesn't allow requests from the app's domain.
*   **The Fix:** Configure CORS on the Authorization Server/Resource Server to whitelist the Client Application's origin (e.g., `http://localhost:3000`).

---

### 2. Token Inspection Tools
When a user is authenticated but cannot access data (HTTP 401/403), you need to look inside the token.

#### A. Decoding JWTs (JSON Web Tokens)
If your Access Token is a JWT (starts with `ey...`), it is Base64 encoded, not encrypted (usually).
*   **Tool:** Use **[jwt.io](https://jwt.io)** or a CLI tool like `jq`.
*   **What to debug:**
    *   **`exp` (Expiration):** Is the current time past this timestamp?
    *   **`iss` (Issuer):** Does this match what your Resource Server expects?
    *   **`aud` (Audience):** Is the token meant for *your* API? If the Audience is wrong, the API normally rejects it.
    *   **`scope` / `scp`:** Does the token actually have the permissions (e.g., `read:users`) required for the failing action?

#### B. Introspection (For Opaque Tokens)
If the token is a random string (Opaque), you cannot decode it.
*   **Technique:** You must use the **Introspection Endpoint** (RFC 7662).
*   **Action:** Send a POST request to the Auth Server:
    ```http
    POST /introspect
    token=8xLP5...
    ```
*   **Result:** The server returns JSON telling you if the token is `{ "active": true }` and what scopes it contains.

---

### 3. Network Traffic Analysis
Since OAuth relies heavily on HTTP redirects and headers, seeing the "wire" traffic is essential.

#### A. Browser DevTools (Network Tab)
*   **Best Practice:** Check the **"Preserve Log"** checkbox.
*   **Why?** OAuth involves redirects (302 status). Without "Preserve Log," the browser clears the network history as soon as the page redirects, hiding the error responses or parameters sent during the redirect phase.
*   **What to check:**
    *   Look at the initial Authorization Request URL. Are `client_id`, `redirect_uri`, and `scope` correct?
    *   Look at the response from the Token Endpoint. Does it contain the `access_token` or an error JSON?

#### B. HTTP Proxies (Charles Proxy, Fiddler, Wireshark)
Sometimes you cannot inspect the network easily (e.g., Mobile Apps, or Server-to-Server calls).
*   **Use Case:** Debugging native mobile apps or backend code.
*   **Setup:** Route your device/server traffic through the proxy tool on your computer.
*   **HTTPS:** You will need to install the Proxy’s Root Certificate on the device to decrypt HTTPS traffic and see the headers/body.

---

### 4. Logging Best Practices
Effective logging on the server side (Authorization Server and Resource Server) is critical for determining *why* a request was rejected.

#### A. What to Log (Safe)
*   **Timestamps:** Crucial for debugging token expiration issues.
*   **Transaction/Correlation IDs:** Generate a unique ID (e.g., UUID) at the start of a flow and pass it through every service. This allows you to trace a single login attempt across microservices.
*   **Client IDs:** Which application is making the request?
*   **Specific Error Messages:** Log the internal reason for failure (e.g., "Signature validation failed," "Audience mismatch") to the server logs, even if you return a generic "Invalid Token" to the client.

#### B. What NEVER to Log (Security Critical)
*   **Access Tokens & Refresh Tokens:** Never write the actual token strings to disk/logs. If logs are leaked, attackers gain access to user accounts.
*   **Client Secrets:** Never log the password of the application.
*   **User Passwords:** Obviously.
*   **PII (Personally Identifiable Information):** Be careful logging names or emails unless necessary and compliant with GDPR/CCPA.

#### C. Redaction
Implement log filters that automatically scrub patterns that look like tokens or specific headers (like the `Authorization: Bearer ...` header) before writing to the log file.
