Here is a detailed explanation of **Section 052: Single Page Application (SPA) Integration**.

This section focuses on the specific security challenges and implementation strategies required when building browser-based applications (like React, Angular, Vue, etc.) that connect to an OAuth 2.0 Authorization Server.

Because SPAs run entirely in the browser (an insecure environment), they are classified as **Public Clients**. They cannot keep a `client_secret` safe, and their source code is readable by anyone.

---

### 1. Authorization Code + PKCE (Proof Key for Code Exchange)

Historically, SPAs used the **Implicit Flow**, which returned tokens directly in the browser URL hash. This is now insecure and deprecated. The modern standard is **Authorization Code Flow with PKCE**.

*   **The Problem:** Since an SPA cannot hold a `client_secret` to prove its identity to the token endpoint, a malicious app could theoretically intercept an authorization code and exchange it for a token.
*   **The Solution (PKCE):** PKCE adds a dynamic secret created on the fly for every single login attempt.

**The Flow Steps:**
1.  **Code Verifier:** The SPA generates a random cryptographic string (the `code_verifier`).
2.  **Code Challenge:** The SPA hashes this string (usually SHA-256) to create a `code_challenge`.
3.  **Authorization Request:** The SPA redirects the user to the Authorization Server, sending the `code_challenge` along with the request.
4.  **Exchange:** After the user logs in, the Server returns an Authorization Code.
5.  **Token Request:** The SPA sends the `code` **AND** the original un-hashed `code_verifier` to the token endpoint.
6.  **Validation:** The Server hashes the `verifier` received in step 5. If it matches the `challenge` received in step 3, it knows the request came from the same application that started the flow.

---

### 2. Token Storage Options

Once the SPA receives the Access Token (and optionally a Refresh Token), it must store them to make API calls. There are significant security trade-offs for each storage mechanism in a browser.

#### A. Local Storage / Session Storage
*   **How:** You save the JWT/Access Token in `window.localStorage`.
*   **Pros:** Very easy to implement. Persists across page reloads (Local) or tabs (Session).
*   **Cons (Major Security Risk):** Vulnerable to **XSS (Cross-Site Scripting)**. If an attacker can inject malicious JavaScript into your site (via a compromised dependency or unchecked input), that script can read `localStorage`, steal the token, and send it to the attacker.
*   **Verdict:** Generally discouraged for high-security applications, but often used for low-risk scenarios.

#### B. In-Memory Storage
*   **How:** The token is stored in a JavaScript variable inside the SPA closure.
*   **Pros:** More secure against XSS. Even if malicious script runs, it is much harder (though not impossible) to scrape memory variables than reading generic LocalStorage.
*   **Cons:** The token is lost whenever the user refreshes the page or opens a new tab. This requires complex logic to silently re-authenticate the user immediately upon load.

#### C. HTTP-Only Cookies (Best for Security)
*   **How:** The server sets the token inside an `HttpOnly` cookie.
*   **Pros:** JavaScript cannot read the cookie. This makes the token immune to XSS theft.
*   **Cons:** Vulnerable to **CSRF (Cross-Site Request Forgery)**, requiring anti-CSRF tokens and strict `SameSite` cookie policies. (See the BFF pattern below).

---

### 3. Silent Refresh Strategies

Access tokens should be short-lived (e.g., 10–15 minutes). To prevent the user from being logged out constantly, the app needs to get new tokens without popping up a login window.

#### A. Refresh Token Rotation (Public Clients)
Since SPAs are public clients, giving them a long-lived Refresh Token is risky. If stolen, an attacker has long-term access.
*   **Strategy:** Secure SPAs use **Refresh Token Rotation**.
*   **Mechanism:** Every time the SPA uses a Refresh Token to get a new Access Token, the server **revokes the old Refresh Token** and issues a brand new one.
*   **Security Benefit:** If an attacker steals a Refresh Token, they can use it once. But when the legitimate user tries to use it later, the server detects the reuse (because the token was already rotated) and invalidates *all* tokens immediately, triggering a new login requirement.

#### B. `iframe` with `prompt=none` (Legacy/Failing)
*   **Old Way:** Load a hidden iframe pointing to the Auth Server with `prompt=none`. If the user has a session cookie at the Auth Server, it returns a new token.
*   **Current Status:** This is breaking due to **ITP (Intelligent Tracking Prevention)** in browsers like Safari and Chrome, which block third-party cookies. This method is largely considered obsolete.

---

### 4. BFF Pattern Implementation (Backend-for-Frontend)

This is currently considered the **most secure architecture** for SPAs.

The core philosophy is: **Do not handle tokens in the Browser (JavaScript) at all.**

#### How it works:
1.  **Architecture:** You deploy a lightweight backend (Node.js, Go, .NET) specifically for the SPA (this is the BFF).
2.  **Proxying:** The SPA rarely talks to the Resource Server (API) directly. It talks to the BFF.
3.  **The Flow:**
    *   The SPA requests login.
    *   The **BFF** (Server-side) handles the Authorization Code flow, PKCE, and exchanges the code for the Access/Refresh Tokens.
    *   The BFF keeps the Access Token in server-side memory (or an encrypted session).
    *   The BFF issues a **standard Session Cookie (HttpOnly, Secure, SameSite)** to the browser.
4.  **API Calls:** Use the Session Cookie to call the BFF -> BFF attaches the Bearer Token -> Calls the upstream API -> Returns data to SPA.

#### Why use BFF?
*   **Security:** High.
*   **XSS Protection:** Access Tokens are never in the browser, so JS cannot steal them.
*   **Simplicity:** The SPA doesn't need to worry about token refresh logic; the BFF handles it.
*   **Complexity:** Higher infrastructure cost (you need to host a backend server to serve the frontend).

### Summary Implementation Recommendation

| Feature | Low Security / Low Risk App | High Security / Fintech / Medical |
| :--- | :--- | :--- |
| **Flow** | Auth Code + PKCE | Auth Code + PKCE (via BFF) |
| **Storage** | LocalStorage | **BFF (Server-side Session / HttpOnly Cookies)** |
| **Refresh** | Refresh Token Rotation | Handled Server-side by BFF |
| **Complexity**| Low (Client-only) | Medium (Requires Backend) |
