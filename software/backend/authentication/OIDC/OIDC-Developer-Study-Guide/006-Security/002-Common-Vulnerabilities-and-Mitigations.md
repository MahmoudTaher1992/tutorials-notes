Based on the Table of Contents you provided, here is a detailed explanation of **Section 20: Common Vulnerabilities and Mitigations**.

This section focuses on specific attacks that target the OIDC/OAuth flows and how developers can code defensively to prevent them.

---

### 1. CSRF Attacks & State Parameter
**The Vulnerability (Cross-Site Request Forgery):**
In an OIDC login flow, your application (the Client) sends the user to the Identity Provider (e.g., Google/Auth0) to log in. Once logged in, the Provider redirects the user back to your app with a temporary code.
An attacker can start a login flow on their own machine, get a valid code for *their* account, and then trick a victim into clicking a link that feeds that code to the *victim's* session.
*   **Result:** The victim unwittingly logs into your application as the attacker. The victim might then save credit card info or upload private data, thinking it is their account, but they are actually uploading it to the attacker's account.

**The Mitigation (The `state` parameter):**
*   Before redirecting the user to login, the Client generates a random, cryptographically secure string (the `state`).
*   This string is stored in the user's browser cookie and sent to the Provider.
*   The Provider must return this exact `state` value alongside the authorization code.
*   **Check:** Your app compares the returned `state` with the one stored in the cookie. If they don't match, the request did not originate from your user's current session, and the login is rejected.

### 2. Token Leakage via Referrer
**The Vulnerability:**
This primarily affects the (now legacy) **Implicit Flow** where tokens are returned directly in the URL (e.g., `https://myapp.com/callback#access_token=xyz`).
If the user lands on that page and immediately clicks a link to an external site (or loads a third-party image/script), the browser sends the current URL (containing the sensitive token) in the HTTP `Referer` header to that third party.

**The Mitigation:**
1.  **Stop using Implicit Flow:** Use **Authorization Code Flow with PKCE**. This ensures tokens are exchanged via a back-channel (server-to-server) call, never appearing in the browser URL.
2.  **Referrer Policy:** If you must use URLs with tokens, set the HTTP header `Referrer-Policy: no-referrer` on your callback page.

### 3. Open Redirector Attacks
**The Vulnerability:**
Authorization Servers and Clients often use a `redirect_uri` parameter to know where to send the user after an action. If the validation of this URI is weak (e.g., checks if the URL *starts* with `myapp.com` or allows wildcards), an attacker can exploit it.
*   **Example:** An attacker constructs a link: `https://auth-server.com/login?redirect_uri=https://myapp.com.evil-site.com`. If the validator is lazy, it sees "myapp.com" and approves it.

**The Mitigation:**
*   **Exact Matching:** The Authorization Server must compare the requested `redirect_uri` against a pre-registered list using an exact string match. No wildcards (`*`) or partial matches should be allowed.

### 4. Authorization Code Injection
**The Vulnerability:**
This is a sophisticated attack where an attacker intercepts a legitimate authorization code meant for the victim and swaps it, or injects a stolen code into the victim's browser session. It is particularly dangerous for public clients (mobile apps/SPAs) that cannot keep secrets.

**The Mitigation (PKCE - Proof Key for Code Exchange):**
*   **How it works:** When the app asks to log in, it creates a random secret (`code_verifier`) and keeps it in memory. It sends a hashed version (`code_challenge`) to the Provider.
*   When the Provider returns the Authorization Code, the app exchanges the code for a token but *must* verify it possesses the original secret (`code_verifier`).
*   Because the attacker cannot guess the random secret in the victim's memory, the injected code is useless because the token exchange will fail.

### 5. ID Token Substitution
**The Vulnerability:**
An attacker obtains a valid ID Token granted to *Client A* (e.g., a generic forum using Google Login). The attacker then presents this token to *Client B* (e.g., a banking app using Google Login).
If *Client B* only checks "Is this signature valid?" and "Is this token from Google?", it says yes. The attacker has now logged into the banking app using a token meant for a forum.

**The Mitigation:**
*   **Audience (`aud`) Validation:** Every ID Token contains an `aud` claim (Audience). This claim contains the Client ID of the app the token was meant for.
*   Your application **must** check that the `aud` claim in the received token matches your specific Client ID exactly.

### 6. Replay Attacks & Nonce
**The Vulnerability:**
An attacker intercepts a valid ID Token used by the victim during login. Later, the attacker sends that exact same token to the Client application to "simulating" a login, hoping the Client accepts it as a fresh session.

**The Mitigation (The `nonce` parameter):**
*   Similar to `state`, the Client generates a random string called a `nonce` (Number used ONCE) and sends it in the initial login request.
*   The Provider embeds this `nonce` inside the ID Token's payload (claims).
*   **Check:** When the Client receives the ID Token, it checks if the `nonce` inside the token matches the one it just generated. If an attacker replays an old token, the `nonce` will be old or missing from the current session storage, and the attack fails.

### 7. Mix-Up Attacks
**The Vulnerability:**
This occurs when an application supports multiple Identity Providers (e.g., "Log in with Google" OR "Log in with Facebook").
An attacker tricks the Client into thinking they are logging in with *Provider A* (e.g., attacker's malicious provider), but the browser is actually redirected to *Provider B* (legitimate). The Client might send the authorization code meant for the legitimate provider to the attacker's provider.

**The Mitigation:**
*   **Issuer Validation:** Strictly validate the `iss` (Issuer) claim in the token against the configuration of the provider you *thought* you were talking to.
*   **JARM / Response Mode:** Ensuring the response from the provider is signed helps verify who sent the authorization code.
