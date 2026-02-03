Based on item **#37 Native Application Security (RFC 8252)** from your Table of Contents, here is a detailed explanation.

This section deals with the specific challenges and protocols required to secure OAuth 2.0 flows within installed **Native Applications** (Mobile apps on iOS/Android and Desktop applications).

---

# 037 - Native Application Security (RFC 8252)

Native applications operate in a fundamentally different security environment than server-side web applications. They run on the user's device (an environment the developer does not control) and are arguably the most complex client type to secure in OAuth.

**RFC 8252 (OAuth 2.0 for Native Apps)** is the industry standard (Best Current Practice) regarding how these apps should perform authorization.

## 1. The Core Problem: Public Clients & Secret safety
Native apps are classified as **Public Clients**.
*   **No Secrets:** You cannot embed a `client_secret` in the source code of an iPhone or Android app. Doing so allows anyone to decompile the app and extract the secret.
*   **Untrusted Environment:** The code runs on the user's device, which might be compromised or have malicious apps installed.

## 2. System Browser vs. Embedded WebView
This is the single most important rule in RFC 8252.

### The Old Way (Insecure): Embedded WebViews
In the past, developers would open a "WebView" (a mini-browser frame) *inside* their app to show the login screen.
*   **The Risk:** When the user enters their password, the application hosting the WebView has technically full access to the keystrokes and the DOM. A malicious "Solitaire" app could pop up a WebView showing a legitimate Google login page, but secretly record the username and password as the user types.
*   **The UX Issue:** The user has to sign in every single time because the WebView doesn't share cookies with the main system browser.

### The Standard Way (Secure): System Browser / External User Agent
RFC 8252 mandates using the device's **System Browser** (or safe in-app tabs like `ASWebAuthenticationSession` on iOS or `Android Custom Tabs`).
*   **The Flow:** The app triggers the OS to open the default browser (e.g., Chrome or Safari) to the Authorization Server URL.
*   **Security Benefit:** The app *cannot* spy on the password input. The browser is sandboxed from the app.
*   **UX Benefit:** If the user is already logged into Google/Facebook/Okta in their mobile Chrome/Safari, they are instantly logged in (SSO) without typing credentials.

## 3. How to Get the Token Back: Redirect URIs
Since the user is now in Chrome/Safari, how does the browser send the Authorization Code back to your native app? There are three main methods defined in this section:

### A. Custom URI Schemes
*   **Format:** `myapp://callback`
*   **How it works:** The developer registers a custom protocol (e.g., `myapp://`) with the OS. When the browser redirects to this URL, the OS pauses the browser and opens the application meant to handle that protocol.
*   **Security Risk:** **Namespace Collision.** On many older OS versions, multiple apps could register the same scheme. A malicious app could register `myapp://` and potentially intercept the Authorization Code meant for the legitimate app.

### B. Claimed HTTPS Schemes (Universal Links / App Links)
*   **Format:** `https://www.myapp.com/callback`
*   **How it works:** This is the *preferred* modern approach. The OS verifies that the app actually "owns" the domain by checking a file uploaded to the web server (`apple-app-site-association` or `assetlinks.json`).
*   **Benefit:** Because the OS verifies ownership, a malicious app cannot hijack the redirect. Only the legitimate app opens.

### C. Loopback Interface Redirect (Desktop Apps)
*   **Format:** `http://127.0.0.1:8080/callback`
*   **Context:** Used primarily for Desktop/CLI apps (Node.js CLIs, Electron apps).
*   **How it works:** The app spins up a tiny temporary HTTP server on `localhost`. The browser redirects to localhost, and the app's temporary server catches the request containing the code.

## 4. The "Interception Attack" & PKCE
Because Custom URI Schemes allow for the possibility of a malicious app stealing the Authorization Code, **PKCE (Proof Key for Code Exchange)** is absolutely mandatory for native apps.

*   **The Vulnerability:** Without client secrets, if a hacker installs a malicious app that listens to `myapp://`, they can steal the Authorization Code. If they have the Code, they can swap it for a Token immediately.
*   **The Fix (PKCE):**
    1.  **Start:** The app generates a random secret (`code_verifier`) and keeps it in memory.
    2.  **Request:** The app sends a hash of that secret (`code_challenge`) to the Authorization Server.
    3.  **Interception:** If a hacker steals the authorization code, they try to exchange it for a token.
    4.  **Block:** The Authorization Server asks: "Prove you initiated this request by showing me the original `code_verifier`."
    5.  **Result:** The hacker doesn't have the verifier (it's inside the legitimate app's memory), so the server denies the token.

## Summary Checklist for Native App Security
To comply with Section 37 (RFC 8252):

1.  **External User Agent:** NEVER use embedded WebViews for login. Use `SFAuthenticationSession` (iOS) or `Custom Tabs` (Android).
2.  **PKCE:** ALWAYS use PKCE (RFC 7636).
3.  **Redirects:** Prefer **Universal Links/App Links** over Custom URI Schemes (`myapp://`) to prevent interception.
4.  **Storage:** Store the tokens securely (using iOS Keychain or Android Keystore), not in local storage or plain text preferences.
