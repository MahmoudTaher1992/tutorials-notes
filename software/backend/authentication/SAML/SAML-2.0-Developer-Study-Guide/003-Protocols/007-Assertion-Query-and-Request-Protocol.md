Based on the Table of Contents provided, specifically **Section 18 ("Assertion Query & Request Protocol")** and **Section 31 ("Assertion Query/Request Profile")**, here is a detailed explanation.

---

# Assertion Query and Request Protocol

To understand this protocol, you must first understand how **Standard SAML (Web Browser SSO)** works.
*   **Standard SSO:** The Identity Provider (IdP) **pushes** data to the Service Provider (SP). You log in, and the IdP sends the SP an Assertion saying: *"This is Alice, and here is her email."*

The **Assertion Query and Request Protocol** reverses this direction. It allows the Service Provider (SP) to actively **pull** information from the Identity Provider (IdP). It essentially asks: *"I already know who this user is, but I need more details about them right now."*

This usually happens via a **back-channel** (directly server-to-server), not through the user's browser.

---

## 1. The Five Types of Queries
Attributes and authorizations can change *after* a user has logged in. This protocol allows the SP to query the IdP for specific updates using five specific request types defined in the SAML spec:

### A. Attribute Query (`<AttributeQuery>`)
**Use Case:** The most common implementation of this protocol.
The user is already logged in, but the application needs specific data that wasn’t sent during the initial login (perhaps to keep the initial token size small).
*   **The Question:** "I have a user identified as `alice@example.com`. Please send me her `Department` and `ClearanceLevel`."
*   **The Answer:** A SAML Response containing an Assertion with the requested Attribute Statements.

### B. Authentication Query (`<AuthnQuery>`)
**Use Case:** Checking session validity.
*   **The Question:** "I have a user `alice@example.com`. Is she currently authenticated with you? If so, when did she log in and how (password, MFA, etc.)?"
*   **The Answer:** A SAML Response containing an Authentication Statement (e.g., "Yes, logged in at 10:00 AM via Password").

### C. Authorization Decision Query (`<AuthzDecisionQuery>`)
**Use Case:** Offloading permission logic to the IdP.
*   **The Question:** "Can user `alice@example.com` perform the action `GET` on the resource `https://sp.com/admin-panel`?"
*   **The Answer:** A SAML Response containing: `Permit`, `Deny`, or `Indeterminate`.
*   *Note: In modern architectures, this is often replaced by XACML or OPA (Open Policy Agent), as SAML is better suited for identity than fine-grained authorization.*

### D. Assertion ID Request (`<AssertionIDRequest>`)
**Use Case:** Retrieving a specific assertion by its ID.
*   **The Question:** "I have a Reference ID (perhaps from an Artifact Binding). Please give me the actual assertion XML that corresponds to ID `#12345`."
*   **The Answer:** The specific signed Assertion requested.

### E. Subject Query (Generic)
A generalized query asking for any available assertions regarding a specific Subject (User).

---

## 2. Protocol Workflow (How it works)

Unlike Web Browser SSO, which bounces the user through the browser using HTTP Redirects or POSTs, the Assertion Query Protocol uses the **SOAP Binding** (synchronous HTTP).

1.  **The Trigger:** The SP Application determines it needs more data about a logged-in user.
2.  **The Request:** The SP generates a SOAP Envelope containing a SAML `<AttributeQuery>` (or other query type).
    *   It must include the **Subject** (NameID) so the IdP knows who is being queried.
    *   It is usually digitally signed by the SP so the IdP knows the request is legitimate.
3.  **Transport:** The SP sends this XML directly to the IdP's Attribute Service endpoint (URL). The user does not see this; it happens on the backend.
4.  **Processing:** The IdP verifies the signature, looks up the user in its directory (LDAP/AD), and retrieves the requested data.
5.  **The Response:** The IdP sends back a SOAP Envelope containing a SAML `<Response>` with the requested Assertions.

---

## 3. Example Scenario: Just-In-Time Attribute Retrieval

Imagine a user, **Bob**, logs into a generic **HR Portal**.
1.  **Standard SSO:** Bob logs in. The IdP sends a small assertion with just his `NameID` (bob123) and `Email`.
2.  **Navigation:** Bob clicks on the "Payroll" tab within the portal.
3.  **The Need:** To show the Payroll page, the SP needs Bob's `SocialSecurityNumber` and `SalaryBand`. Sending these highly sensitive details during every login is a security risk.
4.  **Assertion Query:**
    *   The SP sends an `<AttributeQuery>` to the IdP: "Send `SSN` and `Salary` for `bob123`."
5.  **Response:** The IdP validates that the HR Portal is allowed to see this data, and responds with the attributes.
6.  **Result:** The SP displays the Payroll data.

---

## 4. Key Differences from Standard SSO

| Feature | Standard Web Browser SSO | Assertion Query Protocol |
| :--- | :--- | :--- |
| **Direction** | IdP **Pushes** data to SP | SP **Pulls** data from IdP |
| **Timing** | Happens only at Login | Can happen anytime the user is active |
| **Transport** | Front-channel (Browser) | Back-channel (SOAP/HTTP) |
| **Latency** | Low (User interaction) | Higher (Network call during app logic) |
| **Use Case** | Authentication & Basic Identity | Supplemental Data & Validations |

## 5. Security Considerations

Because this protocol allows an application to blindly ask for user data without the user physically typing in a password at that exact moment, trust is critical:

1.  **Mutual Authentication:** The SP and IdP usually need **Mutual TLS (mTLS)** or strictly signed XML messages to prove they are who they say they are.
2.  **Privacy:** IdPs typically enforce strict policies (e.g., "HR Portal" can ask for Salary, but "Company Wiki" cannot, even if they use the same protocol).
3.  **NameID Mapping:** The SP must use the exact `NameID` format (Persistent, Email, etc.) that the IdP expects to correctly identify the user in the database.

## Summary
The **Assertion Query and Request Protocol** transforms SAML from a simple "door entry" system (Logging in) into a continual **Identity Service**, allowing applications to fetch up-to-date user details, check permissions, or verify history on demand via direct server-to-server communication.
