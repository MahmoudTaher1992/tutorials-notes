Based on the Table of Contents provided (specifically section 25), here is a detailed explanation of **004-Bindings/007-URI-Binding.md**.

---

# SAML 2.0 URI Binding

## 1. What is the SAML URI Binding?

In the world of SAML, a **Binding** maps a SAML protocol message onto a standard messaging format (like HTTP or SOAP).

Most developers are familiar with the **HTTP POST Binding** (sending the XML data inside an HTML form) or the **HTTP Redirect Binding** (sending the XML data inside a long URL parameter).

The **URI (Uniform Resource Identifier) Binding** is different. Instead of transporting the actual SAML message (the XML) directly to the partner, the sender transmits a **link (URI)** that points to where the message is stored. The receiver then visits that link to retrieve the actual data.

### The Analogy
*   **POST Binding:** I send you an email with a 10MB file attached. You have the file immediately, but the email is heavy.
*   **URI Binding:** I send you an email with a "Dropbox" link. The email is tiny. To get the file, you have to click the link and download it yourself.

---

## 2. How It Works (The Workflow)

The URI Binding is a **"Pull" model** rather than a "Push" model.

1.  **Generation:** The Identity Provider (IdP) generates a SAML Assertion regarding a user.
2.  **Storage:** The IdP stores this assertion in a secure location on its own web server (or a repository).
3.  **Transmission:** The IdP sends a message to the Service Provider (SP) containing a **URI reference** (e.g., `https://idp.example.com/assertions/12345`).
4.  **Resolution:** The SP receives the URI. It then performs an **HTTP GET** request to that URL.
5.  **Retrieval:** The IdP authenticates the request (usually via SSL/TLS mutual authentication) and responds with the actual **MIME-encoded SAML Assertion** (the XML).

---

## 3. Technical Specifics

### The Message Format
When the URI is dereferenced (accessed), the response is not just raw text. It must use a specific **MIME Type** so the receiving application knows how to parse it.

Common MIME types used in URI Binding:
*   `application/samlassertion+xml` (For a specific assertion)
*   `application/samlmetadata+xml` (For metadata)

### Security Considerations
Because the assertion contains sensitive user data, you cannot simply leave the URL open to the public internet.
*   **SSL/TLS (HTTPS) is mandatory.**
*   The IdP usually requires the SP to present a client certificate during the HTTP GET request to prove its identity before releasing the XML data.

---

## 4. Comparison: URI Binding vs. Artifact Binding

This is a common point of confusion because both involve sending a "reference" rather than the data.

| Feature | **Artifact Binding** | **URI Binding** |
| :--- | :--- | :--- |
| **What is sent?** | An opaque string (e.g., `AAQA7...`) called an "Artifact." | A actionable URL (e.g., `https://idp.com/get/123`). |
| **How to open it?** | Requires a **SOAP** back-channel call. The SP must build a specific `<ArtifactResolve>` XML request. | Requires a simple **HTTP GET** request. No complex SOAP envelope required. |
| **Complexity** | High (XML-over-SOAP). | Medium (Standard Web Request). |

**URI Binding is lighter weight** than Artifact Binding because it doesn't require the full overhead of SOAP messaging to retrieve the data.

---

## 5. Use Cases (When to use it?)

As noted in the Table of Contents (*"Limited Use Cases"*), this is **not** the standard binding for everyday Browser SSO (like logging into Salesforce or Slack).

Primary use cases include:

1.  **Mobile/Constrained Devices:** If the client is a mobile phone with limited bandwidth or rigid URL length limits, sending a massive XML blob via POST or Redirect might crash the browser or get truncated. Sending a tiny URL is safer.
2.  **Large Payloads:** If the SAML Assertion contains hundreds of attributes (making it several megabytes in size), it is inefficient to pass this through the user's browser. It is better to pass a link and let the servers transfer the heavy data directly.
3.  **IdP Discovery:** Sometimes used in discovery protocols where an entity needs to point to its configuration data without embedding the whole thing.

---

## 6. Summary

*   **Definition:** A method of transporting SAML messages by sending a pointer (URI) rather than the message itself.
*   **Mechanism:** The receiver performs an HTTP GET on the URI to "pull" the XML data.
*   **Pros:** Keeps the browser request light; avoids URL length limitations; avoids passing sensitive data through the user's browser (if implemented correctly).
*   **Cons:** Requires direct network connectivity between the SP and the IdP (firewalls can block this); slower user experience due to the extra round-trip to fetch the data.
*   **Status:** While part of the standard, it is **rarely implemented** in commercial SSO solutions compared to HTTP-POST and HTTP-Redirect.
