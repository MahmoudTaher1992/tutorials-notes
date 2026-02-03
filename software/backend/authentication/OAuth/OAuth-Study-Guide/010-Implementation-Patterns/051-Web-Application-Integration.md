This section concentrates on **Traditional Web Applications** (often called "Regular Web Apps" or "Server-Side Apps"). These are applications built with frameworks like Java Spring Boot, ASP.NET Core, PHP (Laravel), Python (Django/Flask), or Node.js (Express) where the **HTML is rendered on the server**.

Unlike Single Page Applications (SPAs) or Mobile Apps, these applications run on a secure server that is under your control. This classifies them as **Confidential Clients**, meaning they can safely hold a secret (the Client Secret) without exposing it to the user.

Here is a detailed breakdown of the four pillars of Web Application Integration:

---

### 1. The Server-Side Flow (Authorization Code Grant)

In a web application integration, the goal is to get an Access Token, but **never reveal that token to the end-user's browser**. The browser is treated as an insecure medium.

**The Workflow:**
1.  **Initiation:** The user clicks "Login" in the browser. The server responds with an HTTP 302 Redirect to the Authorization Server (AS).
2.  **Consent:** The user logs in and consents at the Authorization Server.
3.  **The Callback:** The AS redirects the browser back to a specific URL on your server (the callback URL) with a one-time `code` in the query string.
4.  **The Exchange (Back-Channel):** This is the crucial step. Your server takes the `code`. It combines it with its `client_id` and `client_secret` and makes a direct HTTP POST request to the AS behind the scenes.
    *   *Note:* Because this happens server-to-server, the browser/user never sees this request.
5.  **The Token:** The AS verifies the secret and the code, then returns the Access Token (and Refresh Token) to your server.

**Why this is secure:**
Even if a hacker intercepts the URL with the `code` in the browser functionality, they cannot exchange it for a token because they do not have the `client_secret`, which is safely stored in your server's environment variables.

---

### 2. Session Management (The "Token Proxy")

Once your server has the Access Token, it needs to remember who the user is for subsequent page loads. However, you should **not** send the Access Token to the browser.

**The Application Session Pattern:**
Instead of sending the raw OAuth tokens to the browser, you utilize a traditional **Session Cookie**.

1.  **Token Receipt:** Upon receiving the Access Token and ID Token from the provider, your server validates them.
2.  **Session Creation:** Your server creates a session entry (in memory, Redis, or a database). Inside this session entry, you store the Access Token and Refresh Token.
3.  **Cookie Issuance:** Your server issues a secure, HTTP-only, encrypted cookie (like `JSESSIONID` or `connect.sid`) to the browser. This cookie contains *only* a reference ID to the session on the server.
4.  **Subsequent Requests:**
    *   The browser requests a page and sends the **Session Cookie**.
    *   Your server reads the cookie, looks up the session in memory.
    *   Your server retrieves the **Access Token** from the stored session.
    *   Your server calls external APIs (Resource Servers) using that Access Token.

**Key Takeaway:** The Browser holds a *Session Cookie*; the Server holds the *Access Token*. The server acts as a proxy.

---

### 3. Token Storage

Since the application is server-side, you have persistent storage options that are safer than a browser's LocalStorage.

**Where to store tokens on the server:**

*   **In-Memory Store (e.g., Redis, Memcached):** This is the most common pattern. The session ID points to a key in Redis, and the value contains the User Profile, Access Token, and Refresh Token.
    *   *Pros:* Fast, auto-expiring sessions.
    *   *Cons:* Requires infrastructure setup.
*   **Encrypted Database:** You might store tokens in a SQL database linked to the user's account ID.
    *   *Security Rule:* Tokens must be encrypted at rest (AES-256) so that database admins cannot steal them.
*   **Encrypted Client-Side Cookie (Stateless):** You can encrypt the Access Token itself and shove it into the cookie sent to the browser.
    *   *Pros:* No backend storage requirement (stateless).
    *   *Cons:* Cookies have size limits (4KB). If the token is large (like a complex JWT), it might fit not. Also, increased network traffic per request.

---

### 4. Logout Handling

Logout in OAuth is significantly more complex than simple authentication because there are up to three layers of "sessions" active:
1.  **The Application Session:** (The cookie between Browser and Your App).
2.  **The Authorization Server Session:** (The cookie between Browser and Auth0/Okta/Keycloak).
3.  **The Resource Server Dependency:** (Are tokens still valid elsewhere?).

**The Logout Implementation:**

1.  **Local Logout:**
    *   The user clicks "Logout" in your app.
    *   Your server destroys the application session (deletes the data from Redis) and clears the browser cookie.
    *   *Result:* The user is logged out of *your* app. However, if they click "Login" again, they might be automatically logged back in because they are still logged into the Authorization Server (SSO).

2.  **RP-Initiated Logout (Global Logout):**
    *   After performing Local Logout, your server redirects the user's browser to the Authorization Server's `end_session_endpoint`.
    *   You usually pass an `id_token_hint` (to prove who is logging out) and a `post_logout_redirect_uri` (where to send the user after they are fully signed out).
    *   *Result:* The user is logged out of your app AND the identity provider.

3.  **Back-Channel Logout (Advanced):**
    *   If the user logs out of the central Authorization Server (e.g., via a dashboard), the AS sends a background webhook request to your server saying, "User XYZ has logged out."
    *   Your server receives this and deletes the specific session from its database/Redis.
    *   *Result:* Next time the user clicks a link, their session is invalid.

### Summary Checklist for Web App Integration

*   **Grant Type:** Authorization Code Grant.
*   **Client Auth:** Yes, use `client_secret` (preferably `client_secret_post` or `client_secret_basic`, or Mutual TLS for high security).
*   **Transport:** Tokens are exchanged server-to-server.
*   **Browser Storage:** Use only `HttpOnly`, `Secure`, `SameSite` cookies to store a Session ID. **Never** store the Access Token in LocalStorage/SessionStorage for a server-side app.
*   **Refresh Tokens:** Store securely on the backend; handle rotation logic on the server.
