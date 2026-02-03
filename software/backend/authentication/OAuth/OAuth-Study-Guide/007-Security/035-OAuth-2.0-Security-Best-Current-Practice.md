Here is a detailed explanation of **Item 35: OAuth 2.0 Security Best Current Practice (RFC 9700)** from your developer study guide.

---

# 35. OAuth 2.0 Security Best Current Practice (RFC 9700)

## Overview
The **OAuth 2.0 Security Best Current Practice (BCP)** document usually referred to as **RFC 9700** (or historically as `draft-ietf-oauth-security-topics`), is one of the most important documents in modern OAuth ecosystem.

The original OAuth 2.0 specification (RFC 6749) was published in 2012. Since then, the web landscape has changed, computing power has increased, and hackers have found creative ways to exploit gaps in the original spec. The Security BCP does not replace OAuth 2.0; rather, it **patches** it by defining a stricter set of rules to mitigate known threats.

If you are building an OAuth system today, you should follow this BCP, not just the original 2012 specification.

---

## 1. Major Deprecations (What to Stop Doing)

The BCP explicitly removes older flows that are now considered insecure.

### A. The Implicit Grant is Removed
*   **What it was:** A flow where the Access Token was returned directly in the URL (Fragment) to the browser, skipping the code exchange step.
*   **The Risk:**
    *   **URI Leakage:** URLs appear in browser history, proxy logs, and the `Referer` header. If a token is in the URL, it is easily leaked.
    *   **Open Redirectors:** If an attacker can trick the Authorization Server into redirecting to an open redirector on the client site, they can steal the token.
    *   **Lack of Sender Constraint:** There is no way to verify who requested the token.
*   **The BCP Rule:** **Do not use the Implicit Grant.**
*   **The Replacement:** Use **Authorization Code Flow with PKCE**.

### B. The Resource Owner Password Credentials Grant (ROPCG) is Removed
*   **What it was:** The application asks the user for their username and password directly, then sends them to the server to exchange for a token.
*   **The Risk:**
    *   **Phishing:** It trains users to type their credentials into applications other than the actual Identity Provider.
    *   **High Privilege:** The app has the user's actual password. If the app is hacked or malicious, the user's identity is stolen.
    *   **No MFA:** It is very difficult (often impossible) to implement Multi-Factor Authentication with this flow.
*   **The BCP Rule:** **Do not use the Password Grant.**
*   **The Replacement:** Redirect the user to the Authorization Server's login page (Code Flow) or use Client Credentials for machine-to-machine communication.

---

## 2. New Mandates (What You Must Do)

The BCP upgrades "optional" security measures to "mandatory."

### A. PKCE (Proof Key for Code Exchange) is Mandatory
Originally, PKCE (RFC 7636) was designed only for mobile/native apps. The BCP spreads its usage to everyone.
*   **The Mechanism:** The client generates a random secret (verifier) and sends a hash of it (challenge) with the authorization request. When exchanging the code for a token, it sends the original secret.
*   **The BCP Rule:**
    *   **Public Clients (SPA, Mobile):** MUST use PKCE.
    *   **Confidential Clients (Web Apps):** SHOULD use PKCE.
*   **Why?**
    *   **Prevents Code Interception:** If an attacker steals an authorization code, they cannot use it because they don't know the secret (verifier) that created the code challenge.
    *   **Prevents Code Injection:** It prevents an attacker from injecting a stolen code into a legitimate application's session.

### B. Exact Redirect URI Matching
*   **The Issue:** In the past, servers might allow "Partial Matching" (e.g., allow any URL starting with `https://myapp.com/`). This allowed attackers to use subdomains or paths like `https://myapp.com/evil-script` to steal codes.
*   **The BCP Rule:** The Authorization Server compare the Redirect URI string **character-for-character**.
    *   No wildcards (`*`).
    *   No regular expressions.
    *   No partial matching.

---

## 3. Advanced Threat Mitigations

The BCP addresses complex attacks that were not fully understood in 2012.

### A. Preventing "Mix-Up" Attacks
**The Scenario:** A client app supports multiple Identity Providers (e.g., Login with Google and Login with Facebook). An attacker tricks the client into thinking the user wants to log in with "AttackerIDP", but actually redirects the user to "Google". The client receives a code from Google but tries to send it to the Attacker's backend to verify it.
*   **The Solution:** The Authorization Server (AS) must return its own identity in the response.
*   **Implementation:** The AS returns an `iss` (Issuer) parameter in the Authorization Response. The Client validates that the `iss` matches the server it thought it was talking to.

### B. Preventing "Code Injection" / "Code Replay"
**The Scenario:** An attacker gets a valid authorization code (perhaps their own). They paste this code into a victim's session url. The victim's client sees the code, exchanges it, and logs the victim into the *attacker's* account.
*   **The Solution:**
    *   **PKCE:** Binds the specific browser request to the token exchange.
    *   **Nonce:** Use the OpenID Connect `nonce` parameter to bind the token contents to the initial request.

### C. Access Token Leakage Prevention
*   **Bearer Token Weakness:** Standard tokens are "Bearer" tokens. Like cash, if you steal it, you can spend it.
*   **The BCP Recommendation:** Use **Sender-Constrained Tokens** (also known as Proof-of-Possession).
    *   **DPoP (Demonstrating Proof-of-Possession):** Binds the token to a private key held by the client application.
    *   **mTLS (Mutual TLS):** Binds the token to the client's TLS certificate.

### D. Refresh Token Security
Refresh tokens are powerful because they allow long-term access.
*   **The BCP Recommendation:**
    1.  **Rotation:** Every time a Refresh Token is used, issue a new one and invalidate the old one. If an attacker tries to use an old refresh token, the server detects the theft and revokes *all* tokens for that user.
    2.  **Binding:** Bind the Refresh Token to the specific client instance (via Client Authentication).

---

## Summary Checklist for Developers

If you are asked to audit an OAuth implementation against **RFC 9700 / Security BCP**, check for these 5 things:

1.  **No Implicit/Password Grants:** Only Authorization Code Flow (and Client Credentials).
2.  **PKCE Everywhere:** Is PKCE enabled for both SPAs and Web Apps?
3.  **Strict Redirect URIs:** Are wildcards disabled in the client settings?
4.  **Refresh Token Rotation:** Is the server issuing new refresh tokens on use?
5.  **Issuer Validation:** Is the client checking who sent the response (using the `iss` parameter)?
