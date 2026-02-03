Based on the Table of Contents you provided, **Section 28** falls under **Part 8: Implementation**. This is a crucial section because while the OIDC protocol (the theory) is the same everywhere, the *implementation details* (the practice) change drastically depending on what kind of software you are building.

The main reason this changes is based on **trust** (can the app keep a secret?) and **capabilities** (does the app have a browser? does it have a stable URL?).

Here is a detailed breakdown of **Platform-Specific Implementation**:

---

## 1. Web Applications (Server-Side)
*Examples: ASP.NET Core, Java Spring Boot, PHP Laravel, Node.js (Express), Django.*

This is the most secure scenario. The application code runs on a server that you control.

*   **Client Type:** **Confidential Client**. Because the code runs on a backend server, you can safely store a `client_secret` in an environment variable or secret manager. The user cannot see this secret.
*   **Recommended Flow:** **Authorization Code Flow** (standard).
*   **How it works:**
    1.  The browser redirects the user to the OIDC Provider (e.g., Auth0/Google).
    2.  User logs in.
    3.  A temporary `code` is sent back to your server via a URL callback.
    4.  Your **Server** talks directly to the OIDC Provider (Server-to-Server back-channel) exchanging `client_id` + `client_secret` + `code` for the tokens.
*   **Token Storage:**
    *   **Do not** send the Access/ID Tokens to the browser if you can avoid it.
    *   Create an **HTTP-Only, Secure Cookie** representing the user's session on your domain. The actual OIDC tokens stay encrypted in your server's memory or database (or inside the encrypted cookie).

## 2. Single Page Applications (SPA)
*Examples: React, Angular, Vue.js, Svelte running entirely in the browser.*

This is considered a "hostile" environment. You cannot trust the browser.

*   **Client Type:** **Public Client**. If you put a `client_secret` in your React code, anyone can right-click -> "Inspect Source" and steal it. Therefore, SPAs **do not** use client secrets.
*   **Recommended Flow:** **Authorization Code Flow with PKCE** (Proof Key for Code Exchange).
    *   *Note:* The "Implicit Flow" (returning tokens in the URL hash) was used in the past but is now **deprecated** due to security risks.
*   **How PKCE works:** Instead of a static secret, the browser generates a random "secret" (code verifier) for *every single login attempt*. It hashes it, sends the hash to the login screen, and later proves it owns the hash to get the token.
*   **Token Storage:**
    *   **LocalStorage/SessionStorage:** Easy to use, but vulnerable to XSS (Cross-Site Scripting). If a hacker runs JS on your page, they steal the token.
    *   **In-Memory:** Safer, but if the user refreshes the page, they are logged out.
    *   **Service Workers / BFF (Backend for Frontend):** The most secure modern pattern involves using a lightweight backend proxy so the SPA acts like a Server-Side app (using cookies).

## 3. Mobile Applications (Native)
*Examples: iOS (Swift), Android (Kotlin), React Native, Flutter.*

Mobile apps are installed binaries. While harder to inspect than JS, they can still be decompiled; therefore, they cannot hold static secrets safely.

*   **Client Type:** **Public Client**.
*   **Recommended Flow:** **Authorization Code Flow with PKCE**.
*   **Implementation Challenge:** There is no "URL" for the OIDC Provider to redirect back to.
*   **The Solution:**
    1.  **Custom URL Schemes:** You register a scheme like `myapp://callback` with the OS. When the login finishes, the phone opens your app.
    2.  **Universal Links (iOS) / App Links (Android):** You register `https://myapp.com/callback`. Use strict OS-level verification to prove your app owns that domain.
*   **Browser Requirement:**
    *   **DO NOT** use an embedded WebView (a mini-browser inside your app). It is insecure and users don't trust it.
    *   **DO** use the System Browser (Safari View Controller on iOS, Chrome Custom Tabs on Android). This shares the user's existing logic/cookies and is secure.

## 4. Desktop Applications
*Examples: Electron, WPF, MacOS Native Apps.*

*   **Client Type:** **Public Client**. Similar to mobile, binaries can be reverse-engineered.
*   **Recommended Flow:** **Authorization Code Flow with PKCE**.
*   **Callback Handling:**
    *   **Loopback Address:** The app spins up a tiny web server on `http://127.0.0.1:random_port`. The browser redirects to this local address after login.
    *   **Custom URI Scheme:** Like mobile, register `myapp://` with the OS registry.

## 5. CLI Tools (Command Line Interface)
*Examples: AWS CLI, Azure CLI, gcloud.*

*   **Client Type:** **Public Client**.
*   **Challenge:** You are in a text-only terminal; you cannot render a login page with username/password fields or "Sign in with Google" buttons.
*   **Recommended Flows (Two Options):**
    1.  **Local Server (preferred):** The CLI command opens your default desktop browser window to log in. The CLI listens on a local port (like Desktop apps) to capture the result.
    2.  **Device Authorization Flow (RFC 8628):** Used when there is *no browser* involved (e.g., logging in on a Smart TV or a headless server).
        *   The CLI prints: *"Go to google.com/device and enter code: ABCD-1234"*
        *   The CLI polls the server: *"Did they enter it yet? ... How about now?"*
        *   Once the user does it on their phone/laptop, the CLI gets the token.

---

### Summary Comparison Table

| Platform | Client Type | Recommended Flow | Secret used? | Trust Level |
| :--- | :--- | :--- | :--- | :--- |
| **Server-Side Web** | Confidential | Auth Code | **Yes** | High |
| **SPA** | Public | Auth Code + PKCE | No | Low |
| **Mobile** | Public | Auth Code + PKCE | No | Low |
| **Desktop** | Public | Auth Code + PKCE | No | Low |
| **CLI / IoT** | Public | Device Flow *or* PKCE | No | Low |
