Based on **Item 80** of the provided study guide, here is a detailed explanation of **SAML to OIDC Migration**.

---

# 80. SAML to OIDC Migration

Structuring a migration from the Security Assertion Markup Language (SAML) to OpenID Connect (OIDC) is one of the most common modernization tasks in Identity and Access Management (IAM) today. While SAML remains the gold standard for legacy enterprise applications, OIDC is the standard for modern web, mobile, and Single Page Applications (SPAs).

Here is a breakdown of the specific concepts listed in this section:

### 1. Feature Comparison (SAML vs. OIDC)
Before migrating, developers must understand the fundamental differences to map functionalities correctly.

| Feature | SAML 2.0 | OpenID Connect (OIDC) |
| :--- | :--- | :--- |
| **Data Format** | Heavy **XML** (Assertions). | Lightweight **JSON** (JWT - JSON Web Tokens). |
| **Primary Use Case** | Traditional Enterprise Web Apps (Browser-based). | Mobile Apps, SPAs, APIs, and Web Apps. |
| **Trust Setup** | Static **Metadata XML** exchange (tedious). | Dynamic **Discovery** (`.well-known/openid-configuration`). |
| **Transport** | Browser Redirects & POST bindings (hard to use in APIs). | RESTful HTTP calls (Authorization Header). |
| **Security** | XML Signature (XMLDSig) & Encryption. | JWS (Signing) & JWE (Encryption). |
| **User Info** | Sent in the initial SAML Assertion. | Sent in ID Token + distinct `UserInfo` endpoint. |

**Key Takeaway:** The migration isn't just syntax; it involves moving from a document-centric trust model (XML) to an API-centric trust model (REST/JSON).

### 2. Migration Strategies
There are three main approaches to moving an ecosystem from SAML to OIDC:

*   **Big Bang (Not Recommended):** Switching the Identity Provider (IdP) and all applications to OIDC overnight. This is high-risk and usually fails due to the complexity of legacy application code.
*   **The Strangler Fig Pattern (Incremental):** This is the ideal strategy. You bring up the OIDC capabilities on your IdP. You then migrate applications **one by one**. New apps are built in OIDC; old apps are refactored over time.
*   **The Abstracted Gateway:** You place an identity broker (like Keycloak, Auth0, or PingFederate) in front of your applications. The apps speak to the Broker, and the Broker speaks to the original IdP. You can then swap the protocol behind the scenes without rewriting the app immediately.

### 3. Parallel Running (Co-existence)
During migration, your Identity Provider must support **Hybrid Protocols**. This means the IdP accepts:
1.  **Incoming SAML AuthnRequests** from legacy ERP systems.
2.  **Incoming OIDC Authorize Requests** from new mobile apps.

**The Challenge:**
The critical challenge here is **SSO Session Management**. If a user logs into the OIDC mobile app, they should seamlessly be logged into the SAML web app without re-entering credentials. The IdP must maintain a central session index that maps to both the OIDC Refresh Tokens and the SAML Session Index.

### 4. Protocol Translation (The Proxy Approach)
Sometimes, you cannot touch the code of the application (e.g., a purchased COTS product that only supports SAML), but you want to modernize your central IdP to be OIDC-only (or vice versa).

**Scenario: OIDC Client talking to a Legacy SAML IdP**
*   **The Problem:** You built a React App (OIDC), but your corporate directory is an old ADFS server that only speaks SAML.
*   **The Solution (Identity Brokering):**
    1.  The React App talks OIDC to a Broker (middleware).
    2.  The Broker pauses the flow and acts as a **SAML Service Provider** to the old ADFS.
    3.  ADFS logs the user in and returns a SAML Assertion to the Broker.
    4.  The Broker converts the User Attributes from the XML Assertion into an OIDC ID Token (JWT).
    5.  The Broker returns the JWT to the React App.

This allows the modern app to "think" it is using OIDC, while the backend is actually performing SAML authentication.

### 5. User Experience (UX) Considerations
Migration affects how the user interacts with the system:

*   **Consent Screens:** OIDC introduces the concept of "Consent" (e.g., *"Do you want to share your email with this app?"*). SAML rarely does this. Migrating might suddenly surprise users with consent pop-ups unless "Imict Consent" is configured.
*   **Redirect Speed:** OIDC flows are generally faster and lighter on bandwidth than passing large base64-encoded XML blobs, leading to a snappier login experience on mobile networks.
*   **Deep Linking:** SAML uses `RelayState` to remember where a user was before logging in. OIDC uses the `state` parameter. Developers must ensure logic that redirects users back to their specific dashboard page is translated from the SAML mechanism to the OIDC mechanism.

### 6. Mapping Attributes (Claims)
The final technical hurdle is data mapping. You must translate the XML attribute standard names to the OIDC standard claims.

**Example Mapping Table:**

| SAML Attribute Name | OIDC Claim Name |
| :--- | :--- |
| `urn:oid:2.5.4.42` (GivenName) | `given_name` |
| `urn:oid:2.5.4.4` (Surname) | `family_name` |
| `urn:oid:0.9.2342.19200300.100.1.3` (Email) | `email` |
| `memberOf` (Group membership) | `groups` or `roles` |

If the OIDC token does not contain the exact claim names the application expects (previously provided by SAML), the application may break or fail to authorize the user correctly.
