Here is a detailed explanation of **Pushed Authorization Requests (PAR)**, defined in **RFC 9126**.

To understand PAR, we first need to look at the "traditional" way OAuth authorization requests work and the problems that PAR solves.

---

### 1. The Problem: "Front-Channel" Authorization Requests

In standard OAuth 2.0 (the Authorization Code Flow), the Client Application starts the process by constructing a URL and redirecting the user's browser to the Authorization Server (AS).

**The URL looks something like this:**

```http
GET /authorize?
    response_type=code
    &client_id=my-client-app
    &state=xyz
    &redirect_uri=https://client.example.com/cb
    &scope=read write
    &code_challenge=...
```

**The Issues with this approach:**

1.  **Integrity (Tampering):** The request passes through the user's browser (the "Front-Channel"). Technically, a sophisticated user or malicious script in the browser could modify parameters (e.g., changing the `scope` or `redirect_uri`) before the Authorization Server sees them.
2.  **Confidentiality (Privacy):** All parameters are visible in the URL. If you are sending Personally Identifiable Information (PII) inside a `login_hint` or complex `claims`, that data might be logged in browser history, proxy logs, or Referrer headers.
3.  **Size Limits:** Browsers and servers have limits on how long a URL can be (typically around 2048 characters). As OAuth gets more complex (e.g., using **Rich Authorization Requests** or large OIDC `claims` objects), the data simply won't fit in a URL query string.
4.  **Late Authentication:** The Authorization Server doesn't know *who* sent the user until the user arrives. It cannot validate the client's credentials until the very end of the flow (token exchange), or unless the client is using signed request objects (JAR).

---

### 2. The Solution: Pushed Authorization Requests (PAR)

**PAR (RFC 9126)** flips this model. Instead of sending the authorization parameters through the **browser** (Front-Channel), the Client sends them directly to the Authorization Server via a backend API call (Back-Channel) **before** the user represents is redirected.

#### The PAR Flow Integration

This adds one step to the beginning of the flow:

1.  **Client -> AS (Back-Channel):** The client sends a `POST` request to a new endpoint (usually `/par` or `/pushed_authorization_request`) containing all the parameters (`scope`, `response_type`, `redirect_uri`, etc.).
    *   *Crucially, the client authenticates during this step (using its Client Secret or mTLS).*
2.  **AS -> Client:** The AS saves these parameters, generates a unique reference code called a **`request_uri`**, and sends it back to the client.
3.  **Client -> User Browser (Front-Channel):** The client redirects the user to the `/authorize` endpoint, but instead of sending a giant list of parameters, it sends **only** the `request_uri`.
4.  **User Browser -> AS:** The AS sees the `request_uri`, looks up the saved parameters, and proceeds with the login/consent screen as usual.

---

### 3. Detailed Breakdown (From your TOC)

#### Purpose & Benefits
*   **Enhanced Security:** Because the parameters are sent directly server-to-server, the user (or malware in the browser) cannot intercept or tamper with the request. The AS knows exactly what the Client requested before the user even arrives.
*   **Client Authentication:** The Client is verified immediately. If a registered client sends an invalid redirect URI or bad scope, the PAR endpoint rejects it immediately with a standard API error (JSON) rather than showing a confusing error page to the end-user later.
*   **No URL Size Limits:** Because the data is sent via an HTTP `POST` body, there is effectively no limit. You can send massive JSON objects used in decentalized identity or complex banking API requests (Rich Authorization Requests).
*   **Privacy:** Sensitive data inside the request is hidden from the browser URL bar and web logs.

#### Request Structure (The "Push")
Instead of a GET request via the browser, the client makes a POST request.

**Example Request:**
```http
POST /as/par HTTP/1.1
Host: auth-server.example.com
Content-Type: application/x-www-form-urlencoded
Authorization: Basic czZCaGRSa3F0MzpnWDFmZskz... (Client Authentication)

response_type=code
&client_id=my-client-app
&state=af0ifjsldkj
&redirect_uri=https://client.example.com/cb
&scope=read write
&code_challenge=E9Melhoa2OwvFr...
```

**Example Response:**
```json
{
  "request_uri": "urn:ietf:params:oauth:request_uri:6c38w549-9c58...",
  "expires_in": 600
}
```
*   The `request_uri` is a one-time use key (or short-lived reference) to the data sent above.

#### Integration with Authorization Endpoint
Once the client has the `request_uri`, it initiates the redirect. This is the only part the user sees.

**The Redirect URL:**
```http
GET /authorize?client_id=my-client-app&request_uri=urn:ietf:params:oauth:request_uri:6c38w549...
```
*   Notice how clean the URL is.
*   The `client_id` is usually included so the AS can easily identify which client config to load to validate the `request_uri`, though strictly speaking, the `request_uri` contains all context.

#### Confidentiality & Integrity
*   **Integrity:** In traditional OAuth, ensuring the `redirect_uri` wasn't tampered with relies on strict string matching rules. With PAR, since the Client posted the `redirect_uri` over an authenticated HTTPS connection directly to the AS, the AS **knows** it is valid. The user physically cannot change the scope or redirect URI because they are stored in the server's cache, not the URL.
*   **Confidentiality:** The complexity is hidden. This is vital for **JAR (JWT Secured Authorization Requests)**. Without PAR, if you use JAR, you have to pass a massive signed JWT in the URL query string, which looks ugly and hits size limits. With PAR, you POST the signed JWT to the server, and the URL stays short.

### Summary Comparison

| Feature | Standard OAuth 2.0 | OAuth 2.0 with PAR |
| :--- | :--- | :--- |
| **Transmission** | Browser URL (Query Params) | Server-to-Server (HTTP POST) |
| **URL Length** | Limited (~2KB) | Unlimited |
| **Tamper Proof?** | No (relies on validation later) | Yes (Cryptographically secure channel) |
| **Client Auth** | Happens at Token Endpoint (End) | Happens at PAR Endpoint (Start) |
| **Privacy** | Params visible in URL/Logs | Params hidden from browser |

**When strictly enforced:**
High-security environments (like FAPI - Financial-grade API) often **mandate** PAR usage. They configure the Authorization Server to *reject* any request to `/authorize` that contains parameters in the URL, forcing all clients to use the Pushed Authorization Request flow.
