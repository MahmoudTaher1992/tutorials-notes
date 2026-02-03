Based on Appendix D (**Status Code Reference**) of your Table of Contents, here is a detailed explanation of how status codes work in SAML 2.0.

In the SAML Protocol, the **Status Code** is the primary mechanism used to communicate the result of a request (like a login attempt or a logout request). It tells the receiving party (usually the Service Provider) whether the operation succeeded or failed, and *why*.

---

# SAML 2.0 Status Code Reference

## 1. The Structure of a Status Block
In every SAML Protocol Response (e.g., `<Response>`, `<LogoutResponse>`), there is a `<Status>` element. This element contains a hierarchy of codes:

1.  **Top-Level StatusCode:** Describes the general class of the result (Success, Client Error, or Server Error).
2.  **Second-Level StatusCode:** (Optional) Provides the specific reason for the error.
3.  **StatusMessage:** (Optional) A human-readable message explaining the error.
4.  **StatusDetail:** (Optional) Application-specific XML providing more context.

**XML Example (Login Failure):**
```xml
<samlp:Status>
    <!-- TOP LEVEL: Who caused the error? (Responder = The IdP) -->
    <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Responder">
        <!-- SECOND LEVEL: What specifically happened? (AuthnFailed) -->
        <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:AuthnFailed"/>
    </samlp:StatusCode>
    <samlp:StatusMessage>Invalid username or password.</samlp:StatusMessage>
</samlp:Status>
```

---

## 2. Top-Level Status Codes
These codes verify if the request was processed successfully or if there was a system-level error. There are only four standard top-level codes.

| Status URI | Meaning | Who is to blame? |
| :--- | :--- | :--- |
| **`Success`** | The request was successfully processed. If this is present, the XML usually contains an Assertion. | N/A |
| **`Requester`** | The request (sent by the SP) was invalid or malformed. | The Service Provider (SP) |
| **`Responder`** | The request was valid, but the IdP could not fulfill it (e.g., system error, policy denial). | The Identity Provider (IdP) |
| **`VersionMismatch`** | The IdP found a version in the request it doesn't support (e.g., SAML 1.1 vs 2.0). | Protocol Versioning |

**Note on URIs:** All SAML 2.0 status codes are prefixed with `urn:oasis:names:tc:SAML:2.0:status:`. For brevity, we usually refer to them by the last word (e.g., `Success`).

---

## 3. Second-Level Status Codes (Sub-codes)
If the Top-Level code is **not** `Success`, a second-level code usually provides the specific technical reason.

### Common Authentication Errors
These explain why a user couldn't log in.

*   **`AuthnFailed`**
    *   **Meaning:** The IdP could not authenticate the user (e.g., wrong password, account locked).
    *   **Context:** Used within a `Responder` top-level code.
*   **`UnknownPrincipal`**
    *   **Meaning:** The IdP does not recognize the username/ID provided in the request.
    *   **Context:** Often seen during Subject queries.
*   **`NoAuthnContext`**
    *   **Meaning:** The SP requested a specific type of login (e.g., MFA or Certificate), but the IdP cannot provide it or the user failed that specific method.

### Request & Policy Errors
These usually indicate configuration mismatches between the SP and IdP.

*   **`RequestDenied`**
    *   **Meaning:** The IdP is technically able to process the request, but refuses to do so based on administrative policy (e.g., "Users from this IP are blocked").
*   **`InvalidNameIDPolicy`**
    *   **Meaning:** The SP asked for a specific NameID format (like "Email") that the IdP is not configured to provide for that user.
*   **`UnsupportedBinding`**
    *   **Meaning:** The request contained a Binding URI (method of transport) that the IdP doesn't understand or allow.

### System & Protocol Errors
*   **`RequestUnsupported`**
    *   **Meaning:** The IdP does not support the specific request type (e.g., an SP sends an `AttributeQuery` to an IdP that only does SSO).
*   **`PartialLogout`**
    *   **Meaning:** During a Single Logout (SLO), the IdP successfully logged the user out locally, but failed to log the user out from *other* SPs involved in the session.
*   **`ResourceNotRecognized`**
    *   **Meaning:** The request refers to a resource (like an Artifact ID or Session Index) that the IdP cannot find in its database (perhaps it timed out).

---

## 4. How to interpret the combination
When debugging, you must look at the nested combination of codes.

| Top Level | Second Level | Interpretation |
| :--- | :--- | :--- |
| `Success` | *(None)* | **Everything worked.** Proceed to parse the assertion. |
| `Requester` | `RequestDenied` | The SP sent a valid XML request, but the IdP rejected it because signature validation failed on the SP’s request. |
| `Responder` | `AuthnFailed` | The SP request was fine, but the user typed the wrong password on the IdP login screen. |
| `Responder` | `NoAuthnContext` | The SP sent `ForceAuthn="true"` or requested `Password` context, but the user canceled the login or couldn't meet the requirement. |
| `Requester` | `InvalidNameIDPolicy` | The SP sent a metadata request for `persistent` ID, but the IdP insists on using `transient`. |

## Summary Reference Table (Cheat Sheet)

| Short Name | Full URI Suffix | Description |
| :--- | :--- | :--- |
| **AuthnFailed** | `:status:AuthnFailed` | User authentication failed. |
| **InvalidAttrNameOrValue** | `:status:InvalidAttrNameOrValue` | Specified attribute is invalid. |
| **InvalidNameIDPolicy** | `:status:InvalidNameIDPolicy` | NameID Policy cannot be met. |
| **NoAuthnContext** | `:status:NoAuthnContext` | Requested authentication context classes not supported. |
| **NoAvailableIDP** | `:status:NoAvailableIDP` | Proxy IdP cannot find a suitable upstream IdP. |
| **NoPassive** | `:status:NoPassive` | Passive authentication (`IsPassive=true`) requested, but user interaction is required. |
| **NoSupportedIDP** | `:status:NoSupportedIDP` | The requested upstream IdP is not supported. |
| **PartialLogout** | `:status:PartialLogout` | Some SPs in the session failed to confirm logout. |
| **ProxyCountExceeded** | `:status:ProxyCountExceeded` | Too many hops in a proxy chain. |
| **RequestDenied** | `:status:RequestDenied` | The IdP refuses to perform the request. |
| **RequestUnsupported** | `:status:RequestUnsupported` | The IdP does not support this protocol request. |
| **RequestVersionDeprecated**| `:status:RequestVersionDeprecated`| The SAML version is too old. |
| **RequestVersionTooHigh** | `:status:RequestVersionTooHigh` | The SAML version is too new. |
| **RequestVersionTooLow** | `:status:RequestVersionTooLow` | The SAML version is too low. |
| **ResourceNotRecognized** | `:status:ResourceNotRecognized` | The artifact/session index is unknown. |
| **TooManyResponses** | `:status:TooManyResponses` | Response limit exceeded (rare). |
| **UnknownAttrProfile** | `:status:UnknownAttrProfile` | Attribute profile unknown. |
| **UnknownPrincipal** | `:status:UnknownPrincipal` | The user ID is unknown to the IdP. |
| **UnsupportedBinding** | `:status:UnsupportedBinding` | The binding mechanism is not supported. |
