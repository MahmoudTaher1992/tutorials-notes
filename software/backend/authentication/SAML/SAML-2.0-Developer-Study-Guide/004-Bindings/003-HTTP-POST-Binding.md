Based on the Table of Contents you provided, here is a detailed explanation of **Section 21: HTTP POST Binding**.

This guide covers the technical mechanics of how SAML messages are transported using the HTTP POST method, which is the most common way to transport SAML Assertions.

---

# 21. HTTP POST Binding

The **HTTP POST Binding** defines how SAML protocol messages (AuthnRequests, Responses, High-level protocol messages) are transported within the **body** of an HTML form via an HTTP POST request.

Unlike the Redirect Binding (which puts data in the URL), the POST Binding puts data in the payload. It is primarily used when the SAML message is too large to fit in a URL, which is almost always the case when an Identity Provider (IdP) sends a signed Assertion to a Service Provider (SP).

### 1. How It Works
The communication process relies on the User Agent (the user's browser) acting as a "courier." The server does not send the data directly to the other server; instead, it gives the browser an HTML form and tells it to submit that form to the destination.

#### The Workflow (IdP to SP Example):
1.  **Generation:** The IdP generates a SAML Response (containing the User's identity assertion).
2.  **Packaging:** The IdP wraps this XML message into an HTML form.
3.  **Delivery:** The IdP sends this HTML page to the User's browser.
4.  **Submission:** The browser receives the page. Usually, JavaScript on the page automatically executes and "POSTs" the form to the SP’s `AssertionConsumerService` (ACS) URL.
5.  **Processing:** The SP receives the POST request, extracts the XML, validates it, and logs the user in.

### 2. Base64 Encoding (No Compression)
A critical technical difference between the **POST Binding** and the **Redirect Binding** is how the data is encoded.

*   **Redirect Binding (GET):** Uses Deflate Compression first, then Base64, then URL Encoding.
*   **POST Binding:** Uses **Base64 Encoding only**.

Because HTTP POST bodies have no effective size limit (unlike URLs, which are often capped at 2kb or 4kb), there is no need to compress the XML. The raw XML string is simply Base64 encoded and placed into a form input named `SAMLResponse` (or `SAMLRequest`).

**Example Payload:**
```html
<input type="hidden" name="SAMLResponse" value="PD94bWwgdmVyc2lvbj0iMS4wIi...?wqcDM+..." />
```

### 3. Auto-Submitting Forms
To provide a seamless "Single Sign-On" experience, the user should not have to manually click a button to send the SAML Response. The HTTP POST Binding utilizes JavaScript to bridge this gap.

When the IdP sends the HTML to the browser, it typically looks like this:

```html
<!DOCTYPE html>
<html>
<head><title>SAML 2.0 POST</title></head>
<body onload="document.forms[0].submit()">
    <noscript>
        <p>
            Note: Since your browser does not support JavaScript, 
            you must press the Continue button once to proceed.
        </p>
    </noscript>
    
    <form action="https://sp.example.com/acs" method="post">
        <!-- The Protocol Message -->
        <input type="hidden" name="SAMLResponse" value="Base64EncodedXMLString..." />
        
        <!-- Optional RelayState to remember where the user was going -->
        <input type="hidden" name="RelayState" value="token123" />
        
        <input type="submit" value="Continue" />
    </form>
</body>
</html>
```

*   **`onload="..."`**: Triggers the form submission immediately upon page load.
*   **`<noscript>`**: Provides a fallback button for security-conscious users who have disabled JavaScript.

**Note:** This momentary loading of the HTML page before the redirect occurs is often noticed by users as a screen flicker or a "flash."

### 4. Signature in XML (XML-DSig)
In the HTTP Redirect Binding, the digital signature is detached (it is a separate query parameter in the URL).

In the **HTTP POST Binding**, the signature is **embedded** within the XML message itself using the **XML Digital Signature (XML-DSig)** standard.

*   The XML is canonicalized (standardized format).
*   A digest (hash) is created.
*   The signature is inserted into the `<saml:Response>` or `<saml:Assertion>` XML element.
*   The SP must parse the full XML structure to find and validate the `<ds:Signature>` block.

### 5. Use Cases

#### A. Delivering Assertions (IdP -> SP)
This is the **primary use case**. A SAML Assertion contains heavy data:
*   User attributes (Name, Email, Roles, etc.).
*   Digital Signatures (long crypto strings).
*   X.509 Certificates (often embedded for validation).

This XML blob is usually 4KB to 10KB+ in size. URLs cannot handle this; therefore, the IdP nearly always uses the POST Binding to send the login success response to the Service Provider.

#### B. Sending Signed AuthnRequests (SP -> IdP)
While the SP *usually* uses the Redirect binding to send users to the login page (because the request is small), some SPs prefer the POST binding for requests if:
*   They need to sign the request and the signature logic prefers XML-DSig over URL parameters.
*   The request includes complex Scoping or huge Extensions.

#### C. Privacy and Security
Data sent via GET (Redirect Binding) appears in:
*   Browser History.
*   Proxy Logs.
*   Server Access Logs.

Data sent via POST does not appear in logs or history. If the implementation requires sending Sensitive Personal Information (SPI), the POST binding is preferred (though the payload should also be encrypted).

### Summary Comparison

| Feature | HTTP POST Binding | HTTP Redirect Binding |
| :--- | :--- | :--- |
| **HTTP Method** | POST | GET |
| **Data Location** | HTTP Body (Form Data) | URL Query String |
| **Size Limit** | Virtually Unlimited | ~2048 characters |
| **Encoding** | Base64 | Deflate + Base64 + URL Encode |
| **Signature** | Embedded in XML (XML-DSig) | Separate Query Parameter |
| **User Experience** | "Flicker" (Form Auto-submit) | Seamless Redirect |
| **Primary Use** | Sending Responses/Assertions | Sending Login Requests |
