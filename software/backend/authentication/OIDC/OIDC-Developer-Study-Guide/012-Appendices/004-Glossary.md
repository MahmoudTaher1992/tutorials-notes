Based on the Table of Contents provided, the file **`012-Appendices/004-Glossary.md`** (labeled as **D. Glossary of Terms** in the list) is intended to be a comprehensive dictionary of the specific jargon used in OpenID Connect (OIDC) and OAuth 2.0.

Identity protocols are notorious for having a steep learning curve due to the number of acronyms and specific definitions. This file serves as a quick reference lookup.

Here is a detailed breakdown of the definitions and terms that would be included in that specific section:

---

### 1. The Core Roles (Who is involved?)

*   **Relying Party (RP):** In OIDC, the application that requires user authentication is called the Relying Party. It "relies" on the Provider to verify identity. In raw OAuth 2.0 terms, this is often called the **Client**.
*   **OpenID Provider (OP):** The server capable of authenticating the user and providing claims to the Relying Party. Examples include Auth0, Okta, Google Identity, or Keycloak. In OAuth 2.0 terms, this is the **Authorization Server**.
*   **End-User:** The human entity communicating with the Client and identifying themselves to the OpenID Provider.
*   **Resource Server:** The server hosting the protected resources (APIs) capable of accepting and responding to protected resource requests using Access Tokens.

### 2. Token Types & Formats (What is exchanged?)

*   **ID Token:** The specific artifact introduced by OIDC (not present in standard OAuth). It is a JWT (JSON Web Token) that contains information (claims) about the authentication event and the user. It is meant to be consumed by the Client aka Relying Party.
*   **Access Token:** A credential used to access protected resources (APIs). It grants permission to "do" things, whereas the ID Token proves "who" someone is.
*   **Refresh Token:** A credential used to obtain a new Access Token (and sometimes a new ID Token) when the current access token expires, without forcing the user to log in again.
*   **JWT (JSON Web Token):** An open standard (RFC 7519) that defines a compact and self-contained way for securely transmitting information between parties as a JSON object. OIDC heavily relies on JWTs.
*   **Claim:** A piece of information asserted about an entity. For example, a user's email, name, or User ID inside a token are all "Claims."

### 3. Critical Parameters (Details in the request)

*   **Nonce:** "Number used ONCE." A random string included in the authentication request and contained in the resulting ID Token. It binds the request to the token to prevent **Replay Attacks**.
*   **State:** A random value used to maintain state between the request and the callback. It is primarily used to prevent **CSRF (Cross-Site Request Forgery)** attacks.
*   **Scope:** A space-delimited list of requested permissions. In OIDC, the scope `openid` is mandatory to trigger OIDC behaviors. Other examples include `profile`, `email`, and `offline_access`.
*   **acr (Authentication Context Class Reference):** A claim inside the ID Token indicating *how* the user was authenticated (e.g., "Level 1" assurance vs. "Level 2" assurance).
*   **amr (Authentication Methods References):** A claim indicating the specific methods used for auth (e.g., `pwd` for password, `face` for FaceID, `mfa` for Multi-Factor).
*   **sub (Subject):** A unique identifier for the user within the Issuer. It is the "User ID."

### 4. Technical Components & Endpoints (How it works)

*   **Discovery Endpoint (`.well-known/openid-configuration`):** A standard URI where an OpenID Provider publishes its metadata (endpoints, supported scopes, public keys locations) so Clients can configure themselves automatically.
*   **JWKS (JSON Web Key Set):** A set of public keys exposed by the OpenID Provider. The Relying Party downloads these keys to verify the cryptographic signature of the ID Token.
*   **UserInfo Endpoint:** An API endpoint provided by the OP where the Client can send an Access Token to retrieve more details about the user (profile data) that didn't fit in the ID Token.

### 5. Security Mechanisms

*   **PKCE (Proof Key for Code Exchange):** Pronounced "Pixie." An extension to the Authorization Code flow that prevents authorization code interception attacks. It is now best practice for all clients (mobile, SPA, and web).
*   **Consent Screen:** The UI displayed by the OP asking the user to grant permissions to the Client (e.g., "Allow App X to view your Email").
*   **Confidential Client:** A client capable of maintaining the confidentiality of its credentials (e.g., a backend web server).
*   **Public Client:** A client incapable of maintaining the confidentiality of its credentials (e.g., a Single Page App running in a browser or a native Mobile App), requiring extra security measures like PKCE.

### Why this Glossary is Important
In the context of the study guide, this file acts as a **disambiguation tool**. For example, a developer might confuse `azp` (Authorized Party) with `aud` (Audience), or `State` with `Nonce`. This glossary provides the definitive RFC-compliant definitions to ensure the developer uses the terms correctly during implementation.
