Based on Part 7, Section 33 of your Table of Contents, here is a detailed explanation of the **Common Vulnerabilities** found in OAuth 2.0 implementations.

These vulnerabilities generally arise not because the OAuth 2.0 protocol is broken, but because it is often implemented incorrectly or used in insecure environments.

---

### 1. Authorization Code Interception
**The Threat:** An attacker steals the authorization code sent from the Authorization Server to the Client application. If they get the code, they can exchange it for an Access Token and impersonate the user.

*   **How it happens:** This is most common in mobile apps (public clients) that use custom URI schemes (e.g., `myapp://callback`) for redirects.
*   **The Attack Vector:**
    1.  The attacker installs a malicious app on the user's device.
    2.  The malicious app registers the same custom URI scheme (e.g., `myapp://`) as the legitimate banking app.
    3.  When the user authenticates via the browser, the OS tries to open the app with the scheme `myapp://`.
    4.  If the malicious app intercepts this intent, it receives the Authorization Code.
*   **The Fix:** **PKCE (Proof Key for Code Exchange)**. Even if the attacker steals the code, they cannot exchange it for a token because they don't have the cryptographically generated "Code Verifier" secret created by the legitimate app at the start of the flow.

### 2. CSRF Attacks (Cross-Site Request Forgery)
**The Threat:** An attacker forces a victim to unknowingly log into the attacker's account on a client application. This is also known as "Login CSRF."

*   **How it happens:** The client application does not verify that the person returning from the Authorization Server is the same person who started the flow.
*   **The Attack Vector:**
    1.  The attacker starts an OAuth flow on their own device and gets a valid Authorization Code from Google/Facebook, but stops the browser before the code is redeemed.
    2.  The attacker constructs a link containing *their* Authorization Code and tricks the victim into clicking it.
    3.  The victim's browser sends the attacker's code to the Client App.
    4.  The Client App logs the victim in... but into the **attacker's account**.
    5.  If the victim then enters credit card info or uploads private photos, they are uploading them to the attacker's account.
*   **The Fix:** Use the **`state` parameter**. The client generates a random string (`state`) before the request, sends it to the Auth Server, and verifies that the `state` returned matches the one stored in the user's session.

### 3. Open Redirector Attacks
**The Threat:** The Authorization Server is used as a proxy to redirect users to malicious phishing sites.

*   **How it happens:** The Authorization Server trusts the `redirect_uri` parameter provided in the URL without validating it against a whitelist.
*   **The Attack Vector:**
    1.  Attacker constructs a link: `https://auth-server.com/authorize?client_id=123&redirect_uri=https://evil.com`.
    2.  The link looks legitimate because it points to `auth-server.com`.
    3.  The user authenticates.
    4.  The Auth Server redirects the user (effectively sending the token or code) to `https://evil.com`.
*   **The Fix:** **Exact String Matching**. The Auth Server must reject any `redirect_uri` that does not *exactly* match the URI registered by the developer during setup.

### 4. Token Leakage via Referrer Header
**The Threat:** Access Tokens or Authorization Codes are leaked to third-party analytics or ad services embedded on the page.

*   **How it happens:** When a browser navigates from Page A to Page B, it sends the URL of Page A in the `Referer` HTTP header.
*   **The Attack Vector:**
    1.  The Auth Server redirects the user to `https://client.com/callback?code=SECRET_CODE`.
    2.  The Client App loads immediately. The URL is still in the browser bar.
    3.  The page contains an image or script from `analytics.com`.
    4.  The browser requests the image and sends `Referer: https://client.com/callback?code=SECRET_CODE` to `analytics.com`.
    5.  Now the analytics logs have the user's authorization code.
*   **The Fix:** Use the header `Referrer-Policy: no-referrer`. Also, avoid the **Implicit Grant**, as it puts Access Tokens directly in the URL fragment.

### 5. Token Leakage in Browser History
**The Threat:** Authentication credentials remain visible to anyone with physical access to the browser history.

*   **How it happens:** Similar to the Referrer leak, this primarily affects the deprecated **Implicit Grant**.
*   **The Attack Vector:**
    1.  Implicit Grant returns the token in the URL fragment: `https://app.com/#access_token=SECRET_TOKEN`.
    2.  Fragments are not sent to the server, but they *are* saved in browser history.
    3.  The user closes the tab.
    4.  An attacker (or the next user in an internet cafe) opens the browser history, sees the URL, copies the token, and hijacks the session.
*   **The Fix:** Do not use Implicit Grant. Use **Authorization Code flow**, where the code is exchanged one-time-only on the backend, and tokens are never displayed in the URL bar.

### 6. Mix-Up Attacks
**The Threat:** A sophisticated attack where the client application is tricked into sending an authorization code (meant for a secure Identity Provider) to a malicious Identity Provider.

*   **How it happens:** Use case: An app supports "Log in with Google" AND "Log in with Malicious-IdP" (perhaps a compromised enterprise setup).
*   **The Attack Vector:**
    1.  The attacker convinces the user to click "Log in with Malicious-IdP".
    2.  The Client App starts the flow.
    3.  The attacker (controlling the Malicious IdP) instantly redirects the user's browser to the *Google* authorization endpoint instead.
    4.  The user sees the Google login screen, thinks "Oh, I must have clicked Google," and logs in.
    5.  Google issues a code to the Client.
    6.  The Client sends the code to the token endpoint of the *Malicious-IdP* (because that's who the client *thought* the user chose).
    7.  The Attacker now has a Google code valid for the user.
*   **The Fix:** The **`iss` (Issuer) parameter**. The response from the Authorization Server must include who issued it. The client sees it initiated a flow for "Malicious-IdP" but the response says `iss=google.com`—identifying the mismatch and aborting.

### 7. Clickjacking (UI Redressing)
**The Threat:** The user is tricked into clicking "Approve" on the consent screen without realizing it.

*   **How it happens:** The attacker loads the Authorization Server's consent page inside an invisible (transparent) `<iframe>`.
*   **The Attack Vector:**
    1.  The attacker creates a website describing a "Free Prize".
    2.  They overlay an invisible iframe of your Authorization Server's "Grant Access" page on top of the "Claim Prize" button.
    3.  The user clicks "Claim Prize" but is actually clicking "Approve" on the invisible iframe.
*   **The Fix:** The Authorization Server must send **`X-Frame-Options: DENY`** or `SAMEORIGIN` headers to prevent the page from being loaded inside an iframe.

### 8. Code Injection Attacks
**The Threat:** This is a variation of the Authorization Code Interception but focuses on injecting a stolen code into a legitimate user's session.

*   **How it happens:** An attacker obtains a valid authorization code (perhaps via interception or leaks) and manually forces a browser to submit that code to the client application.
*   **The Fix:** **PKCE**. Because the code is bound to the specific browser session (via the Code Verifier) that initiated the request, an injected code from a different session will fail validation.

### 9. Access Token Injection
**The Threat:** Using a valid token generated for one client to gain access to a different client.

*   **The Attack Vector:**
    1.  The user logs into "Attacker's Harmless Game" via Google (Client A). The Attacker gets a valid Google Access Token for the user.
    2.  The Attacker sends this token to "Victim's Banking App" (Client B).
    3.  If Client B simply checks "Is this signature valid?" and "Is this token expired?", it will say yes.
    4.  Client B logs the attacker in as the user.
*   **The Fix:** **Audience (`aud`) Validation**. Client B must check the token's `aud` claim to ensure the token was specifically issued for Client B (`banking-app`), not Client A (`harmless-game`).
