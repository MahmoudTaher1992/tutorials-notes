Based on Part 2, Section 8 of your Table of Contents, here is a detailed explanation of **Authentication Context** in SAML 2.0.

---

# 002-Core-Components / 004-Authentication-Context

### 1. What is Authentication Context?
In simple terms, **Authentication Context** answers the question: **"How did the user get authenticated?"**

When an Identity Provider (IdP) tells a Service Provider (SP) "This is user John Doe," that is often not enough information. A bank application, for example, needs to know if John Doe logged in using just a simple password (low security) or if he used a Smart Card and a PIN (high security).

The `AuthnContext` element in SAML provides this metadata. It describes the mechanism, strength, and quality of the authentication event.

### 2. The Two Sides of Authentication Context
This concept works in two directions:

#### A. The SP Requests it (`RequestedAuthnContext`)
When the Service Provider sends the user to the IdP to log in (via an `AuthnRequest`), it can demand a specific security level.
*   *Example:* "I need this user to log in using Multi-Factor Authentication (MFA). If they only have a password, do not let them in (or force them to upgrade)."

#### B. The IdP Asserts it (`AuthnContext`)
When the IdP sends the user back (via a `SAML Response`), it includes the Context to tell the SP what actually happened.
*   *Example:* "User John Doe is authenticated, and he used a user/password over HTTPS to prove it."

### 3. Authentication Context Classes (AuthnContextClassRef)
This is the core implementation mechanism. SAML uses specific **URIs** (Uniform Resource Identifiers) to represent different ways of logging in. These are standard strings defined in the SAML specification.

Here are the most common standard classes:

| Scenario | URI | Explanation |
| :--- | :--- | :--- |
| **Password** | `urn:oasis:names:tc:SAML:2.0:ac:classes:Password` | User authenticated via a password in clear text (rarely used now). |
| **Password (HTTPS)** | `urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport` | **(Most Common)** User entered a password over an encrypted channel (SSL/TLS). |
| **Kerberos** | `urn:oasis:names:tc:SAML:2.0:ac:classes:Kerberos` | User was authenticated via Windows Integrated Auth / Kerberos. |
| **Smart Card/Cert** | `urn:oasis:names:tc:SAML:2.0:ac:classes:X509` | User presented an X.509 digital certificate (e.g., CAC card, YubiKey). |
| **MFA/2FA** | `urn:oasis:names:tc:SAML:2.0:ac:classes:TimeSyncToken` | User used a hardware token that generates time-based codes (like RSA SecurID). |
| **Unspecified** | `urn:oasis:names:tc:SAML:2.0:ac:classes:unspecified` | The IdP isn't saying how they did it, just that they did. This is often the default if nothing else is configured. |

### 4. How it looks in XML

#### The Request (SP asks for Password over HTTPS)
```xml
<samlp:AuthnRequest ... >
  <!-- SP says: "I want PasswordProtectedTransport validation" -->
  <samlp:RequestedAuthnContext Comparison="exact">
    <saml:AuthnContextClassRef>
      urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport
    </saml:AuthnContextClassRef>
  </samlp:RequestedAuthnContext>
</samlp:AuthnRequest>
```

#### The Response (IdP confirms it)
```xml
<saml:Assertion ... >
  <saml:AuthnStatement ... >
    <saml:AuthnContext>
      <!-- IdP says: "Confirmed, used Password over HTTPS" -->
      <saml:AuthnContextClassRef>
        urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport
      </saml:AuthnContextClassRef>
    </saml:AuthnContext>
  </saml:AuthnStatement>
</saml:Assertion>
```

### 5. Advanced Concepts

#### Comparison Logic
When an SP requests a context, they can specify a `Comparison` attribute. This dictates how strict the IdP should be.
1.  **Exact:** The IdP must use exactly the method requested.
2.  **Minimum:** The IdP must use the requested method OR something stronger (e.g., if SP asks for "Password", answering with "MFA" is acceptable).
3.  **Better:** The IdP must use something stronger than what was requested.
4.  **Maximum:** The IdP must use something as strong as, but not stronger than, the request.

#### Step-Up Authentication
This is a major use case for Authentication Context.
1.  User logs into a portal to read news (Low security). IdP logs them in via a persistent Cookie (`PasswordProtectedTransport`).
2.  User clicks "Transfer Money."
3.  The SP detects this is a high-risk action. It sends a **new** SAML AuthnRequest, explicitly requesting an MFA Context (`TimeSyncToken`) and sets `ForceAuthn="true"`.
4.  The IdP sees the request. Even though the user has a cookie, the IdP forces the user to enter a 2FA code.
5.  IdP responds with the new, stronger Context.

#### Custom Contexts
While the creation of custom URIs is allowed, it is generally discouraged in public federations because it ruins interoperability. If you invent `urn:mycompany:security:retina-scan`, outside partners won't know what that means or how to validate it. However, within internal enterprise federations, custom contexts are frequently used to trigger specific internal flows.

### Summary
*   **Authentication Context** = The "Metadata of the Login."
*   **AuthnContextClassRef** = The specific string (URI) identifying the method (e.g., Password, X.509, Mobile).
*   **Purpose:** Allows the Service Provider to trust *how* securely the user was verified, not just *that* they were verified.
