Based on the study guide outline provided, **Part 11, Section 58: Implementing Core Endpoints** focuses on the logic required to build the backend of an Authorization Server (AS). This is the "engine room" of OAuth where requests are validated and tokens are issued.

Here is a detailed explanation of the four sub-topics within this section:

---

### 1. Authorization Endpoint Logic (`GET /authorize`)

The Authorization Endpoint is the interface used by the **Resource Owner (User)**. It is essentially a user-facing controller that handles navigation, authentication, and permission delegation.

**The Workflow Logic:**
1.  **Input Validation:**
    *   The server receives a request containing `response_type`, `client_id`, `redirect_uri`, `scope`, `state`, and `code_challenge` (for PKCE).
    *   **Logic:** It must check if the `client_id` exists in the database.
    *   **Logic:** It must strictly validate that the `redirect_uri` provided matches exactly what was pre-registered for that client. If it doesn't match, the server **must not** redirect; it should show an error page immediately to prevent Open Redirect attacks.

2.  **User Authentication:**
    *   The endpoint checks if the user has an active session (e.g., via an HTTP-only cookie).
    *   **Logic:** If the user is unauthenticated, the server redirects them to a Login Page (often an internal URL like `/login`). After successful login, the user is redirected back to this flow.

3.  **Parameter Persistence:**
    *   During the login/consent dance, the server must remember the original query parameters (`client_id`, `state`, etc.). This is often done by storing the request in a temporary session or passing signed parameters.

4.  **Code Generation (Happy Path):**
    *   If the user approves (see "Consent Management" below), the server generates a cryptographically random **Authorization Code**.
    *   **Storage:** The server stores this code in a database or cache (e.g., Redis) with a short expiration (e.g., 30-60 seconds). It maps the code to:
        *   The User ID
        *   The Client ID
        *   The approved Scopes
        *   The `redirect_uri` used
        *   The PKCE `code_challenge`

5.  **Redirection:**
    *   The server redirects the browser to the `redirect_uri` with `code` and `state` as query parameters.

---

### 2. Consent Management

Consent Management is the logic that decides whether to stop the flow and ask the user for permission.

**The Logic Flow:**
1.  **Check Existing Consent:**
    *   Before showing a "Allow/Deny" screen, the server queries its database: *"Has User A already granted Client B access to Scope C?"*
    *   **Auto-Approve:** If the permission exists and hasn't been revoked, skip the UI and generate the code immediately.
    *   **First-Party Clients:** Often, internal apps (First-Party) are trusted and skip consent entirely.

2.  **Render Consent Screen:**
    *   If no prior consent exists, render a page displaying:
        *   Client Name ("MyApp wants to access...")
        *   Scopes requested ("Read your email," "Access calendar")
        *   Allow / Deny buttons.

3.  **Process Decision:**
    *   **Deny:** If the user clicks Deny, redirect to the `redirect_uri` with `error=access_denied`.
    *   **Allow:** Save this consent decision in the database (so the user isn't asked again next time), then proceed to generate the Authorization Code.

---

### 3. Token Endpoint Logic (`POST /token`)

The Token Endpoint is a machine-to-machine interface. No HTML is returned here; only JSON. It swaps credentials (codes or secrets) for tokens.

**The Workflow Logic:**
1.  **Client Authentication:**
    *   The server looks at the `Authorization` header (Basic Auth) or the `client_secret` in the body.
    *   **Logic:** Verify the secret matches the hash stored in the Client Database. If the client is "Public" (no secret), proceed with PKCE checks.

2.  **Grant Validation (e.g., Authorization Code Grant):**
    *   The server looks up the `code` provided in the request body.
    *   **Checks:**
        1.  Is the code valid and not expired?
        2.  Does the `client_id` match the one bound to the code?
        3.  Does the `redirect_uri` param match exactly the one used during the Authorization Request? (This prevents code injection attacks).
        4.  **PKCE Check:** Hash the incoming `code_verifier` and compare it to the stored `code_challenge`. If they don't match, reject.

3.  **Replay Protection:**
    *   **Crucial Logic:** Once a code is used, **delete it immediately**.
    *   If a request comes in with a code that has already been used, standard logic dictates revoking all tokens previously issued based on that code (treating it as an attack).

4.  **Token Minting:**
    *   Generate the **Access Token** (e.g., sign a JWT payload containing `sub`, `iss`, `exp`, `scope`).
    *   (Optional) Generate a **Refresh Token**.

5.  **Response:**
    *   Return HTTP 200 with the JSON payload:
        ```json
        {
          "access_token": "eyJhbG...",
          "token_type": "Bearer",
          "expires_in": 3600,
          "refresh_token": "rt_..."
        }
        ```

---

### 4. Error Handling

Proper error implementation is dictated by RFC 6749. The server must handle errors differently depending on *where* they occur.

**A. Errors at Authorization Endpoint:**
*   **Redirectable Errors:** If the request is valid but failed (e.g., User denied consent), the server redirects to the callback URL with error params:
    *   `HTTP 302 Location: https://client.com/cb?error=access_denied&state=xyz`
*   **Non-Redirectable Errors:** If the `redirect_uri` is invalid or missing, or the `client_id` is unknown, the server **must not redirect** (as it might send the user to an attacker's site). Instead, it renders a generic HTTP 400 error page to the user.

**B. Errors at Token Endpoint:**
*   Always return HTTP 400 (Bad Request) or 401 (Unauthorized), never a redirect.
*   Return a JSON body:
    ```json
    {
      "error": "invalid_grant",
      "error_description": "The authorization code has expired."
    }
    ```
*   **Common Error Codes to implement:**
    *   `invalid_request`: Missing parameter.
    *   `invalid_client`: Wrong client secret.
    *   `invalid_grant`: Bad code or refresh token.
    *   `unauthorized_client`: Client not allowed to use this flow.
    *   `unsupported_grant_type`: Server doesn't support the requested flow.
