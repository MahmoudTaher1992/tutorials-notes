Based on the Table of Contents provided, here is a detailed explanation of part **013-Migration-and-Interoperability/003-Hybrid-SAML-OIDC-Environments.md**.

---

# 81. Hybrid SAML/OIDC Environments

In the real world, few organizations are purely SAML or purely OpenID Connect (OIDC). Most enterprise environments are **Hybrid**, requiring legacy applications (built 10+ years ago) to coexist with modern single-page applications (SPAs) and mobile apps.

A Hybrid Environment addresses the challenge of maintaining a unified Single Sign-On (SSO) experience across two fundamentally different protocols: **SAML 2.0 (XML-based)** and **OIDC (JSON-based)**.

Here is a breakdown of the four key areas of this topic:

---

## 1. Use Cases
Why do organizations end up with hybrid environments? It is usually due to one of the following scenarios:

*   **Technology Transition (Gradual Migration):** An organization is strictly migrating to OIDC, but they cannot rewrite their 50 legacy applications overnight. They run OIDC for new apps and keep SAML for old ones indefinitely.
*   **Application Diversity:**
    *   *Legacy/COTS:* Enterprise ERPs (like SAP, Oracle) or HR systems often only support SAML.
    *   *Modern:* Mobile apps, React/Angular apps, and REST APIs require OIDC/OAuth because SAML is heavy and difficult to handle on mobile devices or strictly client-side code.
*   **Mergers and Acquisitions (M&A):** Company A (modern tech stack, OIDC) acquires Company B (legacy stack, SAML). They must integrate their Identity Providers so users from Company A can access Company B's apps.
*   **B2B vs. B2C:** A company may use SAML to federate with corporate partners (B2B) but use OIDC/Social Login (Google, Facebook) for consumer customers.

---

## 2. Architecture Patterns
How do you architect a system where users log in once and access both SAML and OIDC apps?

### A. The "Rosetta Stone" IdP (Universal IdP)
The most common pattern uses a modern Identity Provider (like Keycloak, Okta, Auth0, or Azure AD) that speaks both languages natively.

1.  **The User Session:** The user logs in *once*. The IdP creates a central session cookie.
2.  **SAML Request:** When the user visits an HR app, the IdP looks at the session and generates a **SAML Assertion** (XML).
3.  **OIDC Request:** When the user opens the mobile app, the IdP looks at the *exact same session* and issues an **ID Token/Access Token** (JWT/JSON).

### B. The Gateway / Proxy Pattern
This is used when you have an inflexible upstream IdP (e.g., an old Active Directory Federation Services instance) but need to support modern apps.

*   **OIDC-to-SAML Bridge:** Practical when you have a modern app but an old IdP.
    1.  The App talks OIDC to a **Broker**.
    2.  The Broker translates that request into SAML and talks to the **Legacy IdP**.
    3.  The Legacy IdP returns a SAML Assertion.
    4.  The Broker validates the XML, extracts user data, creates a JSON Token (JWT), and hands it back to the App.

### C. Token Exchange (RFC 8693)
This is an advanced pattern (often used in API Gateways). A client presents a SAML Assertion to an Authorization Server and exchanges it for an OAuth/OIDC Access Token to call a downstream API.

---

## 3. Identity Broker Solutions
An **Identity Broker** acts as the middleman. It trusts the external Identity Providers and is trusted by the internal applications.

*   **Keycloak:** A highly popular open-source broker. It can function as an IdP but excels at being a broker. It can add an "Authenticate with SAML" button to an OIDC login page.
*   **Shibboleth IdP:** Historically SAML-focused, but with plugins/extensions, it can now support OIDC flows, bridging the gap for academic institutions.
*   **Cloud IdPs (Auth0/Okta):** These serve as "Identity as a Service" brokers. You point a legacy SAML app to them, and they handle the complexity of authenticating the user via Social Login (OIDC) or Active Directory (LDAP/Kerberos).

**The Role of the Broker:**
1.  **Protocol Translation:** Converts XML signatures to JSON Web Key (JWK) signatures.
2.  **Session Normalization:** Maintains a session index that maps to both the version of the session (SAML) and the refresh tokens (OIDC).

---

## 4. Attribute/Claim Mapping
The biggest technical hurdle in hybrid environments is translating "User Data." SAML and OIDC speak different dialects regarding user attributes.

To make a hybrid environment work, you must create a mapping schema (a dictionary) between the two.

### Vocabulary Differences

| Feature | SAML 2.0 | OpenID Connect (OIDC) |
| :--- | :--- | :--- |
| **Data Format** | XML Elements | JSON Key-Value Pairs |
| **User ID** | `<NameID>` | `sub` (Subject) |
| **User Name** | `urn:oid:2.5.4.42` (GivenName) | `given_name` |
| **Email** | `urn:oid:0.9.2342...` (mail) | `email` |
| **Groups** | `<Attribute Name="memberOf">` | `groups` or `roles` claim |

### Mapping Strategy
When implementing a hybrid solution, you must configure the IdP/Broker to perform **Transformation**:

1.  **Ingest:** Receive the SAML Assertion.
2.  **Parse:** Extract `<AttributeValue>john.doe@example.com</AttributeValue>` from the attribute named `mail`.
3.  **Map:** Look up the OIDC equivalent for `mail` $\rightarrow$ `email`.
4.  **Inject:** Create the JWT ID Token and insert `"email": "john.doe@example.com"`.

**Common Pitfall:**
*   **Multi-valued attributes:** In SAML, a user might have multiple `<AttributeValue>` tags for "Groups." In OIDC, this must be converted into a JSON Array `["admin", "editor"]`. If the translation software blindly converts it to a single string, the application authorization will break.
