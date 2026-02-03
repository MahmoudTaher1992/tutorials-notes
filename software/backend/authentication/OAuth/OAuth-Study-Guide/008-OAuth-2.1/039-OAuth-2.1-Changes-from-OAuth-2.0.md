Based on **Section 039** of the provided Table of Contents, here is a detailed explanation of the changes introduced in **OAuth 2.1**.

### The Big Picture: What is OAuth 2.1?
OAuth 2.1 is not a complete rewrite of the protocol. Instead, it is a consolidation effort. It takes the original 2012 specification (OAuth 2.0), combines it with years of security lessons learned, and integrates the **"OAuth 2.0 Security Best Current Practice" (BCP)** document.

The primary goal of OAuth 2.1 is to remove insecure patterns that were allowed in 2.0 and make security features that were previously "optional" into **mandatory defaults**.

---

### 1. PKCE is Required for All Clients
**PKCE** (Proof Key for Code Exchange) prevents authorization code interception attacks.

*   **OAuth 2.0:** PKCE was originally designed only for native mobile apps (Public Clients) that could not store a Client Secret securely. Web apps (Confidential Clients) simply used a Client Secret.
*   **OAuth 2.1:** **PKCE is now mandatory for ALL clients**, including confidential web applications and Single Page Applications (SPAs).
    *   Even if a client has a `client_secret`, it must still use PKCE.
    *   This provides a second layer of security against CSRF (Cross-Site Request Forgery) and code injection attacks.

### 2. The "Implicit Grant" is Removed
The Implicit Grant was the flow where the Access Token was returned directly in the browser URL (e.g., `https://app.com/callback#access_token=...`).

*   **OAuth 2.0:** It was the standard way for JavaScript (SPA) apps to get tokens.
*   **OAuth 2.1:** **It is completely omitted.**
    *   **Why?** Returning tokens in the URL is insecure. URLs are logged in browser history, proxy logs, and Referrer headers, making token leakage highly likely.
    *   **The Replacement:** SPAs must now use the **Authorization Code Flow with PKCE**.

### 3. The "Resource Owner Password Credentials" Grant is Removed
This was the flow where the user typed their username and password directly into the Client application's interface.

*   **OAuth 2.0:** Allowed for "trusted" first-party apps to skip the redirect to the Authorization Server.
*   **OAuth 2.1:** **It is completely omitted.**
    *   **Why?**
        1.  It teaches users to share their credentials (an anti-pattern leading to phishing).
        2.  It makes Multi-Factor Authentication (MFA) extremely difficult to implement.
        3.  If the Client app is compromised, the user's master credentials are stolen.

### 4. Bearer Tokens in URI Query Strings are Forbidden
*   **OAuth 2.0:** It was technically allowed (though meant to be a last resort) to pass an access token like this:
    `GET /api/data?access_token=mJV...`
*   **OAuth 2.1:** **This is now strictly explicitly forbidden.**
    *   **Why?** Query parameters are logged everywhere (server access logs, browser history).
    *   **The Requirement:** You must use the HTTP Header (`Authorization: Bearer <token>`) or, in specific form-post cases, the body.

### 5. Refresh Token Rotation
*   **OAuth 2.0:** Refresh Tokens were often static—they could last for months or years without changing. If one was stolen, an attacker had long-term access.
*   **OAuth 2.1:** Requires (for public clients) or strongly recommends (for confidential clients) **Refresh Token Rotation**.
    *   **How it works:** Every time a client uses a Refresh Token to get a new Access Token, the Authorization Server issues a **new** Refresh Token and invalidates the old one.
    *   **Security Benefit:** If an attacker steals a refresh token and uses it, the legitimate user's next attempt to use their (now old) refresh token will fail. This allows the Authorization Server to detect the theft and revoke *all* tokens associated with that user/device immediately.

### 6. Exact Redirect URI Matching
*   **OAuth 2.0:** Some implementations allowed "fuzzy" matching for the Redirect URI (e.g., checking only the domain name or allowing sub-paths).
*   **OAuth 2.1:** The Redirect URI sent during the authorization request must correspond using **exact string matching** to the URI registered with the Client.
    *   **Why?** To prevent Open Redirector attacks where an elusive attacker tricks the Authorization Server into sending the temporary auth code to a script controlled by the attacker on a subdomain or different path.

### Summary Comparison Table

| Feature | OAuth 2.0 | OAuth 2.1 |
| :--- | :--- | :--- |
| **Implicit Grant** | Allowed (Common for SPAs) | **Removed** (Use Code + PKCE) |
| **Password Grant** | Allowed (Common for Legacy) | **Removed** |
| **PKCE** | Optional (Recommended for Native) | **Required for All** |
| **Redirect URI** | Sometimes Loose Matching | **Exact Matching Only** |
| **Refresh Tokens** | Often Static | **Rotation Required/Recommended** |
| **Access Tokens** | Allowed in URL Query String | **Forbidden in URL Query String** |
