Based on the file path `012-Appendices/001-Specification-Documents.md` and the Table of Contents you provided, this section corresponds to **Appendix A: OIDC Specification Documents & RFCs Reference**.

This is one of the most critical sections for a serious developer because it lists the **"Source of Truth"** for everything discussed in the study guide.

Here is a detailed explanation of what this document contains and why it matters.

---

### What is this section?
This file acts as a **bibliography and reference library**. OpenID Connect (OIDC) and OAuth 2.0 are not single pieces of software; they are **standards** defined by technical documents.

If you are building an OIDC provider (like a custom login server) or a client (an app that logs functionality in), you cannot just "guess" how it works. You must follow the strict rules laid out in these documents to ensure your app works with Google, Okta, Microsoft, etc.

This appendix typically categorizes the documents into three layers:

### 1. The Foundation: OAuth 2.0 RFCs
OIDC cannot exist without OAuth 2.0. These documents (managed by the IETF) define the underlying plumbing.
*   **RFC 6749 (The OAuth 2.0 Framework):** The bible of OAuth. It defines flows like Authorization Code and Client Credentials.
*   **RFC 6750 (Bearer Token Usage):** Explains how to actually use an Access Token in an HTTP header (`Authorization: Bearer <token>`).
*   **RFC 7636 (PKCE):** An add-on spec that fixes security holes in mobile/SPA apps (highly recommended now).

### 2. The Data Format: The "JOSE" Suite
OIDC relies heavily on JSON Web Tokens (JWT). The rules for how to format, sign, and encrypt these tokens are in their own specifications.
*   **RFC 7519 (JSON Web Token - JWT):** Defines the header/payload/signature structure.
*   **RFC 7515 (JSON Web Signature - JWS):** How to cryptographically sign data.
*   **RFC 7517 (JSON Web Key - JWK):** The format used to share public keys so the receiver can verify the signature.

### 3. The Protocol: OIDC Specifications
These are the documents specific to OpenID Connect (managed by the OpenID Foundation), which add the "Identity" layer on top of OAuth.
*   **OpenID Connect Core 1.0:** The most important document. It defines the **ID Token**, the `UserInfo` endpoint, and how the authentication flows differ from standard OAuth.
*   **OpenID Connect Discovery 1.0:** Defines the `.well-known/openid-configuration` endpoint, allowing apps to automatically find the right URLs for login.
*   **OpenID Connect Dynamic Client Registration 1.0:** Defines how an app can register itself with an Identity Provider automatically via API.

---

### Why is this section important for a developer?

While you might use a library (like `passport.js` or `Microsoft.Identity.Web`) that hides this complexity, you need this appendix for three reasons:

1.  **Debugging Weird Errors:**
    If you get an error like `invalid_grant` or `nonce_mismatch`, library documentation is often vague. The Specification Documents define exactly *why* those errors are thrown.

2.  **Ambiguity:**
    Sometimes a tutorial says one thing, and a blog post says another. The Specification Document is the final judge. For example, if you are unsure if the `sub` (subject) claim in a token should be a global ID or an app-specific ID, **OIDC Core 1.0** gives the definitive answer.

3.  **Security Compliance:**
    The specs define keywords like **MUST**, **SHOULD**, and **MAY** (based on RFC 2119).
    *   **MUST:** If you don't do this, your system is broken or insecure.
    *   **SHOULD:** You can skip this, but you probably shouldn't.
    *   Developers read the specs to ensure they haven't missed a "MUST" requirement that opens a security vulnerability.

### Summary
In the context of your file structure, `012-Appendices/001-Specification-Documents.md` is the **technical dictionary**. You don't read it cover-to-cover like a novel; you use it to look up the exact rules when building or fixing your authentication system.
