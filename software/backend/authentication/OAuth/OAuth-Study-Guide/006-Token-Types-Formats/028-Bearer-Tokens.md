Based on **Section 28** of your Table of Contents, here is a detailed explanation of **Bearer Tokens (RFC 6750)**.

---

# 28. Bearer Tokens (RFC 6750)

Bearer tokens are the pre-eminent standard for OAuth 2.0 access tokens. Understanding them is fundamental to understanding how modern APIs secure resources.

### 1. What are Bearer Tokens?

A **Bearer Token** is a security token with a very simple property: **"Any party in possession of the token (the 'bearer') can use it to get access to the associated resources."**

To understand this, use the **Cash Analogy**:
*   **Credit Card (Proof-of-Possession):** To use a credit card, you must have the card *and* often provide a PIN or signature to prove you are the owner.
*   **Cash (Bearer Token):** If you drop a $20 bill on the ground and someone else picks it up, they can verify it is real money and spend it. The shopkeeper does not check ID; they simply respect that the person *bearing* the cash has the right to spend it.

In OAuth 2.0, the Authorization Server issues a string (the token) to the Client. The Client sends this string to the Resource Server (API). The API trusts the token without requiring the Client to perform a complex cryptographic signature verification for every single request.

### 2. Transmitting Bearer Tokens

RFC 6750 defines exactly how a Client should send this token to the Resource Server. There are three defined methods, but they are not created equal.

#### A. Authorization Header (The Standard / Best Practice)
This is the most common and secure method. The client adds an HTTP header to the request.

**Syntax:**
```http
Authorization: Bearer <token>
```

**Example Request:**
```http
GET /resource/123 HTTP/1.1
Host: api.example.com
Authorization: Bearer mF_9.B5f-4.1JqM
```

*   **Pros:** It separates authentication data from application logic/parameters. It is not logged in server access logs (usually).
*   **Cons:** Slightly larger request size (negligible).

#### B. Form-Encoded Body Parameter (Discouraged)
The client sends the token as a parameter in the body of the HTTP request.

**Requirements:**
1.  The HTTP method must be one that has a body (typically `POST`).
2.  The `Content-Type` header must be `application/x-www-form-urlencoded`.

**Example Request:**
```http
POST /resource HTTP/1.1
Host: api.example.com
Content-Type: application/x-www-form-urlencoded

access_token=mF_9.B5f-4.1JqM&other_param=value
```

*   **Why Discouraged:** It prevents you from using HTTP GET (since GET requests typically shouldn't have bodies). It mixes protocol credentials with application data.

#### C. URI Query Parameter (Highly Discouraged / Removed in OAuth 2.1)
The client sends the token as part of the URL itself.

**Example Request:**
```http
GET /resource?access_token=mF_9.B5f-4.1JqM HTTP/1.1
Host: api.example.com
```

*   **Why it is Dangerous:**
    *   **Browser History:** The token stays in the user's browser history.
    *   **Server Logs:** Web servers almost always log the full URL. This means your access tokens are written in plain text in log files, which might be read by unauthorized admins or ingested by third-party logging services (Splunk, Datadog, etc.).
    *   **Referrer Header:** If the page links to an external site, the full URL (including the token) is sent to that external site in the `Referer` header.
*   **Status:** OAuth 2.0 allowed this carefully; **OAuth 2.1 explicitly removes support for this method.**

### 3. Security Considerations

Because Bearer tokens are like cash, security measures focus entirely on **Preventing Theft**. If an attacker steals the token, they can impersonate the user until the token expires.

*   **TLS/HTTPS is Mandatory:** You must *never* send a Bearer token over unencrypted HTTP. If you do, anyone on the network (coffee shop Wi-Fi, ISP, etc.) can sniff the packet, copy the token, and hack the user's account.
*   **Token Storage:**
    *   **Server-side Clients:** Store tokens in a secure database or encrypted session.
    *   **Browser Clients (SPAs):** Storing in `localStorage` is common but vulnerable to XSS (Cross-Site Scripting). If an attacker can run a script on your page, they can read `localStorage` and steal the token. The current recommendation is usually the "Backend-for-Frontend" (BFF) pattern (using HttpOnly cookies) to keep tokens out of the browser entirely.
*   **Short Lifespans:** To mitigate the damage of a stolen token, Bearer tokens usually have short expiration times (e.g., 15 minutes to 1 hour). When they expire, the client uses a **Refresh Token** (which is kept much more securely) to get a new Access Token.

### Summary Table

| Feature | Description |
| :--- | :--- |
| **Concept** | "Possession is 9/10ths of the law." Whoever holds it, rules it. |
| **Simplicity** | extensive complexity during setup, but extremely simple to use for API calls. |
| **Format** | Can be **JWT** (readable data) or **Opaque** (random string), but the transport method implies "Bearer". |
| **Transport** | **Authorization Header** (Use this one!), Body (Avoid), URL (Don't do it). |
| **Major Risk** | Token theft (Replay attacks). |
| **Mitigation** | TLS (HTTPS), Short expiration times, Secure storage. |
