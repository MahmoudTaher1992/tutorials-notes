Based on the Table of Contents provided, here is the detailed explanation for **Section 11: Hybrid Flow**. This content corresponds to the file path `003-Authentication-Flows/004-Hybrid-Flow.md`.

---

# 11. Hybrid Flow

The **Hybrid Flow** is exactly what its name suggests: it is a combination of the **Authorization Code Flow** and the **Implicit Flow**.

In the standard Authorization Code Flow, all tokens (ID, Access, Refresh) are delivered to the backend. In the Implicit Flow (legacy), tokens are delivered directly to the browser. The Hybrid Flow allows the client to receive some tokens immediately in the front channel (browser) while receiving an authorization code to exchange for other tokens in the back channel (server).

### 1. Why use Hybrid Flow?
The primary use case for Hybrid Flow is an application that has significant logic on **both** the client-side (JavaScript) and the server-side.

*   **Front-End needs:** Instant access to the ID Token to confirm the user is logged in, verify the signature, and display UI elements (like a profile picture) without waiting for a server round-trip.
*   **Back-End needs:** A secure, long-lived Access Token and Refresh Token to call APIs or maintain a session, which should never be exposed to the browser.

### 2. High-Level Diagram

```text
User           Browser (Front)        Client Server (Back)          Authorization Server (OP)
 |                    |                        |                                |
 1. Click Login       |                        |                                |
 |------------------->|                        |                                |
                      | 2. Redirect with response_type="code id_token"          |
                      |-------------------------------------------------------->|
                      |                                                         | 3. Auth & Consent
                      |                                                         |<-- User Logic -->
                      |                                                         |
                      | 4. Redirect with #code=XYZ & #id_token=JWT              |
                      |<--------------------------------------------------------|
 5. Validate ID Token |                        |                                |
    & Extract Code    |                        |                                |
                      | 6. Send "code" to Server                                |
                      |----------------------->|                                |
                      |                        | 7. Exchange "code" for Tokens  |
                      |                        |------------------------------->|
                      |                        |                                |
                      |                        | 8. Return Access & Refresh Tkn |
                      |                        |<-------------------------------|
                      |                        |                                |
 9. Session Established
```

### 3. The `response_type` Combinations
The defining characteristic of the Hybrid Flow is the `response_type` parameter used in the initial authorization request. While Authorization Code flow uses `code` and Implicit uses `token` or `id_token`, Hybrid uses a **space-separated list** of values.

There are three allowed combinations:

1.  **`response_type=code id_token`** (Most Common)
    *   **Browser gets:** Authorization Code + ID Token.
    *   **Server gets:** Interchanges the Code for Access Token + Refresh Token.
    *   *Usage:* Frontend creates the UI context immediately; Backend handles API data securely.

2.  **`response_type=code token`**
    *   **Browser gets:** Authorization Code + Access Token.
    *   **Server gets:** Interchanges the Code for (another) Access Token + Refresh Token.
    *   *Usage:* Frontend needs to call an API immediately implies less security for the frontend Access Token.

3.  **`response_type=code id_token token`**
    *   **Browser gets:** Authorization Code + ID Token + Access Token.
    *   **Server gets:** Interchanges the Code for Access/Refresh Tokens.
    *   *Usage:* Maximum availability of artifacts, but maximizes exposure surface.

### 4. Technical Nuances & Security constraints
Because this flow touches the browser (Implicit) and the server (Code), it has specific security requirements:

#### A. The Nonce is Mandatory
In Hybrid Flow, the `nonce` parameter is **required** in the authorization request.
*   The generic client generates a cryptographic random string.
*   It sends it in the request.
*   The OP includes this nonce inside the returned ID Token claim.
*   The client validates that the `nonce` in the ID Token matches the one it sent. This prevents replay attacks.

#### B. The `c_hash` (Code Hash) Claim
Because the browser receives an ID Token *and* a Code side-by-side, how do you know the Code belongs to that specific ID Token?
*   The ID Token delivered to the browser will contain a claim called `c_hash`.
*   The client must hash the Authorization Code and compare it to this `c_hash` to ensure the artifacts are bound together and haven't been swapped by a Man-in-the-Middle (MitM).

### 5. Step-by-Step Implementation Walkthrough

1.  **The Request:**
    The client redirects the user to the implementation of the Authorization Endpoint:
    ```http
    GET /authorize?
    response_type=code id_token
    &client_id=s6BhdRkqt3
    &redirect_uri=https://client.example.com/cb
    &scope=openid profile email
    &state=af0ifjsldkj
    &nonce=n-0S6_WzA2Mzkw
    ```

2.  **The Response:**
    The Provider redirects back to the Client using the **Fragment** (hash) of the URL, not the query string (to prevent the token from being logged in server history):
    ```http
    HTTP/1.1 302 Found
    Location: https://client.example.com/cb#
    code=SplxlOBeZQQYbYS6WxSbIA
    &id_token=eyJhbGciOiJSUzI1...
    &state=af0ifjsldkj
    ```

3.  **Client-Side Processing:**
    *   The JavaScript on the page reads the URL hash.
    *   It validates the ID Token (signature, expiration, aud, iss, nonce).
    *   It extracts user info (e.g., username) and updates the DOM.
    *   It sends the `code` to the backend via an AJAX/Fetch POST.

4.  **Server-Side Processing:**
    *   The backend validates the `code`.
    *   The backend exchanges the `code` at the Token Endpoint (just like standard OAuth).
    *   The backend receives the long-lived Access Token and Refresh Token.

### 6. Trade-offs

| Pros | Cons |
| :--- | :--- |
| **Immediacy:** The frontend app feels faster because identity data is available immediately without waiting for a backend handshake. | **Complexity:** It is significantly harder to implement than standard Code Flow because you have to handle security validation in two places (JS and Server). |
| **Flexibility:** Allows splitting responsibilities between a public client (browser) and a confidential client (server). | **Security Surface:** Because the ID Token is exposed in the URL fragment (Front Channel), there is a slightly higher risk of leakage than a pure back-channel flow. |
| **Migration:** Useful for legacy applications transitioning from Implicit flow to a more secure backend flow. | **Deprecation Risk:** With the rise of Authorization Code Flow with PKCE, the Hybrid Flow is becoming less necessary. |

### 7. Modern Recommendation
While Hybrid Flow is standard OIDC, the industry is shifting toward **Authorization Code Flow with PKCE** for *all* scenarios.

If using PKCE, the frontend initiates the flow, the code is returned to the browser, and the browser (or backend) exchanges it. Modern Single Page Applications (SPAs) often use "Backend for Frontend" (BFF) patterns where the Code Flow happens entirely on the server, and the server simply issues a secure HttpOnly cookie to the frontend, eliminating the need for Hybrid Flow's complexity.
