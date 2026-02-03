Based on the Table of Contents provided, specifically **Part 3 (Item 18)** and **Part 5 (Item 31)**, here is a detailed explanation of the **Assertion Query/Request Profile**.

---

# SAML 2.0: Assertion Query & Request Profile

## 1. High-Level Concept
Most developers are familiar with SAML in the context of **Web Browser SSO** (where the IdP "pushes" an assertion to the SP after login).

The **Assertion Query/Request Profile** is different. It is a **"Pull" model**. It allows a Service Provider (SP) or another system to proactively contact the Identity Provider (IdP) directly—usually via a back-channel API call—to ask for specific information about a user or a past authentication event.

### Why do we need it?
*   **The SP needs more data later:** The user logged in 30 minutes ago, but now they are accessing a restricted area. The SP needs to check if the user is *still* logged in or needs to fetch the user's specific security clearance attributes which were not sent during the initial login.
*   **Offline Processing:** A batch process needs to retrieve details about a user without the user physically sitting at the browser.
*   **Audit/verification:** The SP received an Assertion Reference (Artifact) and needs to trade it for the actual data.

---

## 2. Technical Architecture
Unlike the Web Browser SSO profile, which uses HTTP Redirects and POSTs through the user's browser, this profile almost exclusively uses the **SOAP Binding** (Synchronous HTTP).

*   **Communication:** Direct Server-to-Server (Back-channel).
*   **Protocol:** SOAP over HTTP(S).
*   **Security:** Both the Request and the Response must be mutually authenticated (usually via XML Signatures and/or Client Certificate Authentication/mTLS).

---

## 3. Types of Queries
This profile defines specific query types an SP can send to an IdP.

### A. AssertionIDRequest
This is the simplest form. The SP provides a specific **Assertion ID**, and the IdP returns the corresponding XML Assertion.
*   **Use Case:** The SP received an "Artifact" (a tiny reference pointer) during login and now needs to fetch the full user data.
*   **The Question:** "I have a ticket ID `_12345`. Give me the XML Assertion associated with it."

### B. AuthnQuery (Authentication Query)
The SP asks the IdP for details regarding the authentication acts performed by a specific subject.
*   **Use Case:** Session synchronization. The user has been active on the SP for 2 hours. The SP wants to know: "Is this user still currently logged into the IdP, or did they log out over there?"
*   **The Question:** "Tell me about the authentication status of user `john.doe`."
*   **The Answer:** The IdP returns an assertion containing an `<AuthnStatement>` (e.g., "John logged in at 10:00 AM via Password"). If John is no longer logged in, the IdP returns an error or empty result.

### C. AttributeQuery
This is the most common use case for this profile. The SP asks for specific user attributes (like email, role, department, clearance_level).
*   **Use Case:** Just-In-Time resolution. The SP doesn't want to store user data. When the user clicks "Payroll," the SP queries the IdP specifically for the `salary_grade` attribute.
*   **The Question:** "Return the `department` and `role` attributes for user `john.doe`."
*   **The Answer:** The IdP returns an assertion containing an `<AttributeStatement>` with the requested values.

### D. AuthzDecisionQuery (Authorization Decision Query)
The SP asks the IdP to make a permission decision.
*   *Note: This is rarely used in modern implementations. It has largely been replaced by XACML or OPA (Open Policy Agent).*
*   **Use Case:** Centralized Policy.
*   **The Question:** "Is user `john.doe` allowed to `WRITE` to resource `/files/secret.txt`?"
*   **The Answer:** The IdP returns an `<AuthzDecisionStatement>` say "Permit" or "Deny".

---

## 4. The Request/Response Flow
Since this is a synchronous back-channel call, the flow is linear:

1.  **SP Generation:** The SP generates a SAML Query (e.g., `<AttributeQuery>`).
2.  **Signing:** The SP signs the XML with its private key.
3.  **Transport:** The SP wraps the query in a SOAP Envelope and POSTs it to the IdP's **Attribute Query Service URL**.
4.  **Processing:**
    *   The IdP verifies the signature (confirming the SP is a trusted partner).
    *   The IdP looks up the requested data in its directory (LDAP, SQL, etc.).
5.  **Response:** The IdP generates a standard SAML `<Response>` containing the requested assertion.
6.  **Completion:** The SP receives the SOAP response, parses the XML, and uses the data.

---

## 5. XML Structure Example (Attribute Query)

Here is a simplified view of what the XML looks like when an SP asks an IdP for an attribute.

**The Request (SP to IdP):**
```xml
<samlp:AttributeQuery 
    ID="req_123" 
    IssueInstant="2023-10-27T10:00:00Z" 
    Destination="https://idp.example.com/attr-service">
    
    <!-- Who are we asking about? -->
    <saml:Subject>
        <saml:NameID>john.doe@example.com</saml:NameID>
    </saml:Subject>
    
    <!-- What do we want? -->
    <saml:AttributeDesignator 
        Name="urn:oid:2.5.4.10"
        FriendlyName="OrganizationName"
        NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri"/>
        
</samlp:AttributeQuery>
```

**The Response (IdP to SP):**
Returns a standard `<samlp:Response>` that contains an Assertion with the requested Attribute Statement.

---

## 6. Pros and Cons vs. Standard SSO

| Feature | Standard Web SSO (Push) | Assertion Query (Pull) |
| :--- | :--- | :--- |
| **Direction** | IdP sends data upon Login. | SP asks for data anytime. |
| **Data Freshness** | Snapshot at moment of login. | Live/Current data. |
| **Privacy** | Minimizes data transfer (only sends what is needed for login). | Can ensure SP only gets data when explicitly needed. |
| **Performance** | Fast (one flow). | Slower (requires extra HTTP calls). |
| **Complexity** | Moderate. | High (requires strict firewall rules, Cert mgmt). |

## 7. Implementation Challenges / Why isn't it everywhere?
While powerful, the Assertion Query profile is less common than standard SSO for several reasons:

1.  **Statefulness:** The IdP must maintain a stateful session to answer questions about users. If the IdP is stateless (common in modern cloud architectures), it may not know if `john.doe` is "still" logged in.
2.  **Modern Alternatives:**
    *   **OIDC UserInfo Endpoint:** In the OpenID Connect world, the `UserInfo` endpoint does exactly what `AttributeQuery` does but using simple JSON/REST instead of heavy SOAP/XML.
    *   **SCIM:** System for Cross-domain Identity Management is now the standard for provisioning and querying user attributes, replacing many `AttributeQuery` use cases.
3.  **Network Security:** It requires the IdP to expose a SOAP endpoint to the internet (or via VPN) that accepts incoming connections from SPs, which complicates firewall configurations.
