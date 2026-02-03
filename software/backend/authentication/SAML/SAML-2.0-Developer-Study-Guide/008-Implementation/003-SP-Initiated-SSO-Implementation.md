Based on item **#51** in your Table of Contents, here is a detailed explanation of **SP-Initiated SSO Implementation**.

This section describes the most common scenario: A user tries to access your application (the Service Provider) without being logged in, and your application sends them to the specific login server (Identity Provider) to authenticate.

---

# 008-Implementation / 003-SP-Initiated-SSO-Implementation

## 1. The Concept
**SP-Initiated SSO** begins when the user attempts to access a protected resource on your application (like a dashboard or profile page) directly. Since the application does not detect an active session, it initiates the federation process.

## 2. The Flow Walkthrough
Before writing code, you must understand the "dance" between the three parties: The **User Agent** (Browser), the **Service Provider** (You/SP), and the **Identity Provider** (IdP).

1.  **Request:** User creates a request to `https://myapp.com/dashboard`.
2.  **Interception:** The SP checks for a legitimate session cookie. None is found.
3.  **Generation:** The SP generates a SAML `AuthnRequest` (Authentication Request).
4.  **Redirect:** The SP redirects the User Agent to the IdP’s Single Sign-On URL, carrying the `AuthnRequest` as a payload.
5.  **Authentication:** The IdP sees the request, challenges the user for credentials (username/password, MFA), and validates them.
6.  **Generation:** The IdP generates a SAML `Response` containing a SAML `Assertion`.
7.  **Post:** The IdP sends the active Browser back to the SP's **Assertion Consumer Service (ACS)** URL with the Response.
8.  **Validation:** The SP receives the Response, validates the signature, extracts user data, creates a local session, and redirects the user to the original requested page (`/dashboard`).

---

## 3. AuthnRequest Generation
The core of SP-Initiated SSO is the `AuthnRequest` XML object. When your code generates this, it must include specific attributes:

*   **ID:** A random, unique UUID string (e.g., `_a75ad...`). You must save this ID in a temporary cookie or database to validate the response later.
*   **IssueInstant:** The timestamp (UTC) of generation.
*   **Destination:** The URL of the IdP (where you are sending the user).
*   **Issuer:** Your application's **Entity ID** (must match what is in your Metadata).
*   **AssertionConsumerServiceURL:** Where you want the IdP to send the user back after login.

**XML Example (Simplified):**
```xml
<samlp:AuthnRequest 
    xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol"
    ID="_123456789" 
    Version="2.0" 
    IssueInstant="2023-10-27T10:00:00Z"
    Destination="https://idp.example.com/sso"
    AssertionConsumerServiceURL="https://myapp.com/saml/acs">
    <saml:Issuer>https://myapp.com/metadata</saml:Issuer>
</samlp:AuthnRequest>
```

---

## 4. Redirect vs. POST to IdP
How do you get this XML to the IdP? You must choose a **Binding**.

### HTTP Redirect Binding (Most Common for Requests)
Since the `AuthnRequest` is usually small, you use an HTTP 302 Redirect.
1.  **Deflate** the XML.
2.  **Base64** encode the result.
3.  **URL Encode** that string.
4.  Append it as a query parameter: `?SAMLRequest=...`.
5.  **Signature:** If the IdP requires signed requests, you calculate the signature of the query string and append `&Signature=...`.

### HTTP POST Binding
If the request is too large for a URL (rare for requests), you generate an HTML form with a hidden input named `SAMLRequest` containing the Base64 XML, and use JavaScript to auto-submit the form `onload`.

---

## 5. RelayState
When sending the user to the IdP, you should also send a parameter called `RelayState`.
*   **Purpose:** To remember where the user originally wanted to go.
*   **Usage:** If the user clicked a link to `/deep/link/page`, but had to login first, you put that URL in the `RelayState`.
*   **The IdP's Duty:** The IdP **must** return this value back to you exacty as is when sending the SAML Response.

---

## 6. Response Handling (ACS Endpoint)
You must implement an endpoint (e.g., `/saml/acs`) that listens for `HTTP POST` requests. The IdP will post the `SAMLResponse` here.

### Processing Steps:
1.  **Decode:** Base64 decode the `SAMLResponse` parameter.
2.  **Parse:** Parse the XML structure.
3.  **Check Status:** Look at the `<samlp:Status>` tag. Is it `Success`? If not, handle the error (e.g., user denied access).

---

## 7. Assertion Processing (Validation)
**This is the most critical security step.** Do not trust the XML just because it arrived.

1.  **Signature Verification:**
    *   Extract the XML Signature.
    *   Validate it using the **IdP's Public Key/Certificate** (which you stored from their Metadata).
    *   *Security Note:* Ensure the signature covers the whole Assertion, not just a part of it (prevents XML Signature Wrapping attacks).
2.  **Audience Restriction:**
    *   Check `AudienceRestriction`. Does the value match your SP Entity ID? If it's for another app, reject it.
3.  **Time Validity:**
    *   Check `NotBefore` and `NotOnOrAfter`. Is the current time within this window? (Allow for 3-5 minutes of clock skew).
4.  **Replay Attack Detection:**
    *   Check the Assertion ID. Have you processed this ID recently? If yes, reject.
5.  **InResponseTo Validation:**
    *   Check the `InResponseTo` attribute. Does it match the `ID` of the `AuthnRequest` you generated in Step 3? (This proves *you* started the flow).

---

## 8. Session Creation
Once the SAML is validated:
1.  **Extract Identity:** Pull the `NameID` (e.g., `user@example.com`) and any attribute statements (First Name, Groups, Role).
2.  **Local User Lookup:** Check if this user exists in your database.
    *   *JIT Provisioning:* If they don't exist, and your policy allows it, create the user account now (Just-In-Time Provisioning).
3.  **Create Session:** Create a standard application session (e.g., set a session cookie, issue a JWT, etc.).
    *   *Important:* The SAML flow is now **over**. The user interacts with your app via your standard session mechanism, not SAML.
4.  **Final Redirect:** Read the `RelayState` you received back and redirect the user there. If `RelayState` is empty, go to a default homepage.

---

## 9. Error Scenarios to Handle

*   **Denied Access:** The IdP returns a status code `urn:oasis:names:tc:SAML:2.0:status:Responder` (indicating failure). Show a friendly "Login Failed" message.
*   **Mismatched Clock:** The IdP's server time is significantly different from yours. Ensure your libraries allow for "Clock Skew" (usually 180 seconds).
*   **No Active Key:** If the IdP rotated their certificate and you didn't update your config, signature validation will fail.
*   **Deep linking loss:** If you fail to implement `RelayState`, users will always land on the homepage after login, losing their original destination (bad UX).
