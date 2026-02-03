Based on Part 9, Item 35 of your file, here is a detailed explanation of **OIDC & Related Specifications**.

This section serves as a look into the **future and ecosystem expansion** of OpenID Connect. While standard OIDC handles basic "User Login" well, modern architectures (microservices, high-security fintech, and decentralized web) require more specialized protocols.

Here is a breakdown of each specification listed in that section:

---

### 1. OAuth 2.0 Token Exchange (RFC 8693)

**The Problem:**
In a microservices architecture, User A logs into **Service 1**. Service 1 processes the request but needs to call **Service 2** to get more data. Service 1 cannot just pass the user's original Access Token to Service 2 because that token might be scoped only for Service 1 (audience restriction).

**The Solution:**
RFC 8693 defines a standard way for a service (Service 1) to ask the Authorization Server to trade an existing token for a **new token** meant for a different target service (Service 2).

*   **Impersonation:** The new token makes it look like the User is calling Service 2 directly.
*   **Delegation:** The new token includes information that "Service 1 is acting on behalf of the User."

**Key Mechanism:**
*   A new grant type is introduced: `urn:ietf:params:oauth:grant-type:token-exchange`.
*   The client sends the `subject_token` (the one they have) and asks for a `requested_token_type` (what they want).

---

### 2. OAuth 2.1 Draft

**The Problem:**
OAuth 2.0 and OIDC have been around for over a decade. In that time, many "best practices" documents (like the OAuth 2.0 Security BCP) were written to patch security holes, but the original RFCs still contain insecure methods (like Implicit Flow).

**The Solution:**
OAuth 2.1 is not a radical new protocol; it is a **consolidation and cleanup effort**. It takes OAuth 2.0 and merges it with all the security best practices that have emerged over the years.

**Key Changes from 2.0 to 2.1:**
*   **Implicit Flow is removed:** It is no longer allowed.
*   **ROPC (Password) Flow is removed:** Sending usernames/passwords directly to headers is banned.
*   **PKCE (Proof Key for Code Exchange) is mandatory:** Every authorization code flow (even for backend web apps) must use PKCE.
*   **Exact Redirect URI Matching:** No wildcard matching is allowed for redirect URIs.

---

### 3. OIDC for Identity Assurance

**The Problem:**
Standard OIDC tells you *who* the user is (e.g., "This is `alice@example.com`"). However, it doesn't tell you if Alice is a real person, if her passport has been checked, or if she meets anti-money laundering (AML) regulations. This is critical for banks and healthcare.

**The Solution:**
This extension allows the Identity Provider to include **Verified Claims** in the ID Token or UserInfo response. It adds a structured JSON object detailing *how* the user's identity was verified.

**Key Mechanism (`verified_claims`):**
The token will contain data looking like this:
*   **trust_framework:** "eIDAS" or "NIST-800-63A" (The rules followed).
*   **evidence:** "Passport" or "Driver's License".
*   **verification_process:** "Physical In-Person Check" or "Biometric Scan".

---

### 4. Self-Issued OpenID Provider (SIOP)

**The Problem:**
Standard OIDC relies on a central authority (Google, Facebook, Corporate IdP). This creates privacy concerns and central points of failure. If Google goes down or bans you, you lose your identity.

**The Solution:**
SIOP allows the **End-User to be their own Identity Provider**. Instead of redirecting the user to `accounts.google.com`, the application redirects the user to a **Wallet App** on their own device.

**Key Mechanism:**
*   The "Subject" identifier (`sub`) is calculated from a public key owned by the user.
*   The user signs the ID Token using a private key stored on their device (Secure Enclave).
*   This is the bridge between traditional Web2 apps and Web3/Decentralized identity.

---

### 5. Decentralized Identity & Verifiable Credentials (VCs)

**The Problem:**
Physical wallets contain credentials (ID card, gym membership, university degree). Digital identity usually just contains an email and name. How do you prove you have a degree without calling the university every time?

**The Solution:**
This relates to **SSI (Self-Sovereign Identity)**. OIDC is being adapted to act as the "transport layer" for W3C Verifiable Credentials.

**Two variations:**
1.  **OIDC for Credential Issuance (OIDC4CI):** A standard way for a user (Wallet) to ask an Issuer (University) for a digital diploma using OAuth flows.
2.  **OIDC for Verifiable Presentations (OIDC4VP):** A standard way for a Verifier (Employer) to ask a user to present that digital diploma. The user responds with a cryptographically signed credential rather than just a standard ID Token.

---

### Summary Table

| Specification | Primary Goal | Use Case |
| :--- | :--- | :--- |
| **Token Exchange** | Swapping tokens for internal services | Microservices calling other microservices. |
| **OAuth 2.1** | Security Hardening | New applications wanting to be "secure by default." |
| **Identity Assurance** | Proving the user is *real* (eKYC) | Banking, Fintech, Government Apps. |
| **SIOP** | Removing the central IdP | Privacy-focused apps, Crypto wallets. |
| **Verifiable Credentials** | Digitizing physical cards/documents | Digital Driver's License, Digital Diplomas. |
