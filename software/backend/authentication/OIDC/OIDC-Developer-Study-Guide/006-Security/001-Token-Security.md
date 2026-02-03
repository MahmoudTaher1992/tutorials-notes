Based on the Table of Contents you provided, **006-Security/001-Token-Security.md** corresponds to **Section 19: Token Security**.

This section focuses on how to protect the OIDC tokens (ID Token, Access Token, Refresh Token) from being stolen, leaked, or misused. Since OAuth 2.0 and OIDC tokens are often "Bearer Tokens" (meaning anyone holding the token can use it, like cash), securing them is critical.

Here is a detailed explanation of the four core concepts typically covered in this file:

---

### 1. Token Storage Best Practices
Where you save a token dictates how easily an attacker can steal it. The recommendations change based on the type of application.

#### For Browser-Based Apps (SPAs - React, Angular, Vue)
*   **The Problem:** Browsers are vulnerable to **XSS (Cross-Site Scripting)**. If an attacker manages to run a malicious script on your page, they can read anything stored in `localStorage` or `sessionStorage`.
*   **Don't:** Store tokens in `localStorage` or `sessionStorage` if possible. This is the easiest way for XSS attacks to steal identity.
*   **Do (Best Practice):** Use **BFF (Backend for Frontend)** pattern. The actual tokens are handled by a lightweight backend proxy. The backend sets an `HttpOnly` cookie with the browser.
    *   *Why?* JavaScript cannot read `HttpOnly` cookies, making them immune to XSS token theft.
*   **Do (Alternative):** Store tokens **In-Memory** (in a JavaScript variable) within the SPA.
    *   *Pros:* Secure from generic XSS file scraping (harder to steal than localStorage).
    *   *Cons:* The token is lost if the user refreshes the page. You need a mechanism (like a background iframe or refresh worker) to silently get a new token on reload.

#### For Mobile/Native Apps (iOS, Android, Desktop)
*   **Don't:** Store tokens in plain text files or shared preferences.
*   **Do:** Use the Operating System's secure storage hardware.
    *   **iOS:** Keychain Services.
    *   **Android:** EncryptedSharedPreferences / Keystore.
    *   **Windows:** DPAPI (Data Protection API).

#### For Backend/Server-Side Apps
*   **Do:** Store tokens in an encrypted database or a secure session store (like Redis with encryption enabled).

---

### 2. Secure Transmission (TLS)
This refers to protecting the token while it travels through the internet.

*   **The Rule:** OIDC/OAuth 2.0 **requires** the use of TLS (Transport Layer Security), commonly known as **HTTPS**.
*   **The Risk (Man-in-the-Middle):** If you send a token over standard HTTP, the text is clear. Someone sitting on the same coffee shop WiFi can analyze the network traffic, see the `Authorization: Bearer <token>` header, copy the token, and hack the user's account.
*   **Mitigation:**
    *   All endpoints (Authorization, Token, UserInfo) must use HTTPS.
    *   Implement **HSTS (HTTP Strict Transport Security)** headers to force browsers to reject any insecure connection attempts.

---

### 3. Token Binding
This is a concept designed to prevent token theft from being useful.

*   **The Concept:** Standard Bearer tokens are like **Cash**. If you drop a $20 bill and I pick it up, I can spend it. The store doesn't check if the bill belongs to me.
*   **Token Binding:** This turns the token into a **Credit Card**. Even if I steal your credit card, I (ideally) cannot use it without your PIN or signature.
*   **How it works:** When the server issues a token, it cryptographically "binds" that token to the specific client (app) or the specific TLS connection that requested it.
*   **The Result:** If a hacker steals the token and tries to use it from their own computer, the server will reject it because the "binding" (the connection or client signature) doesn't match.

---

### 4. Sender-Constrained Tokens (DPoP, mTLS)
These are the two specific methods used to implement "Token Binding" (making stolen tokens useless).

#### mTLS (Mutual TLS)
*   **How it works:**
    1.  The Client (App) has a specialized Client Certificate.
    2.  When connecting to the server, they perform a handshake where the client proves it owns that certificate.
    3.  The detailed Access Token includes a "hash" or "thumbprint" of that client certificate (Claim: `cnf`).
*   **The Check:** When the client calls the API, the API checks: "Does the certificate being used for this connection match the hash inside the token?"
*   **Pros:** Extremely secure. Financial Grade APIs (banking) usually require this.
*   **Cons:** Hard to set up infrastructure-wise.

#### DPoP (Demonstrating Proof-of-Possession)
*   **How it works (Application Layer):** This is newer and easier than mTLS.
    1.  The Client generates a public/private key pair locally.
    2.  When asking for a token, the Client sends its Public Key to the server.
    3.  The Server puts the Public Key inside the Access Token.
    4.  Every time the Client calls the API, it creates a small digital signature using its Private Key.
*   **The Protection:** If a hacker steals the token, they still fail. The server will see the token, look at the public key inside it, and ask: "Where is the signature signed by the private key?" The hacker doesn't have the private key (it never left the legitimate client), so the request is denied.
