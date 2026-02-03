Here is a detailed explanation of **Topic 41: Resource Indicators (RFC 8707)**.

 This topic addresses a critical security and architectural challenge in OAuth 2.0: **Audience Confusion** and **Targeting Token Scope**.

---

### 41. Resource Indicators (RFC 8707)

**High-Level Summary:**
Resource Indicators provide a standardized way for an OAuth 2.0 Client to tell the Authorization Server (AS) **exactly which API (Resource Server)** it intends to use the Access Token for.

Without Resource Indicators, OAuth relies heavily on "Scopes" to define access. However, scopes define **"What"** you can do (e.g., `read`, `write`), but they do not explicitly define **"Where"** you can do it. Resource Indicators solve the "Where" problem.

---

#### 1. Purpose & The Problem it Solves
To understand the purpose, we must first look at the **"Audience Confusion"** problem.

**The Scenario:**
Imagine your organization has two different APIs:
1.  **Billing API** (`https://api.billing.com`)
2.  **Messaging API** (`https://api.messaging.com`)

Both APIs accept an OAuth Access Token. Both APIs have a scope named `read`.
*   If a Client requests a token with `scope=read`, the Authorization Server issues a token.
*   **The Risk:** If the Client sends this token to the **Messaging API**, the Messaging API accepts it. But if the Messaging API is malicious (or compromised), it can take that valid token and send it to the **Billing API** to download your invoice history. The Billing API accepts the token because it effectively says "User allowed `read`."

**The Solution (Resource Indicators):**
RFC 8707 introduces the `resource` parameter. This allows the Client to say:
> *"I want a token with `scope=read`, specifically for `https://api.billing.com`."*

The resulting token will contain an Audience claim (`aud`) specific to the Billing API. If the Messaging API tries to replay this token against the Billing API, the Billing API (or the Authorization Server) will reject it because the audience doesn't match.

---

#### 2. The `resource` Parameter
The core of this specification is a new query parameter added to the **Authorization Request** and the **Token Request**.

**Syntax Rules:**
*   The value must be an absolute URI (e.g., `https://my-api.com/v1`).
*   It cannot contain a fragment (`#`).
*   In a GET request (Authorization Endpoint), the parameter can be repeated multiple times to request access to multiple resources.

**Example Authorization Request:**
```http
GET /authorize?
    response_type=code
    &client_id=s6BhdRkqt3
    &scope=read write
    &resource=https://api.billing.com/  <-- The Resource Indicator
    &redirect_uri=https://client.example.com/cb
Host: server.example.com
```

**Example Token Request:**
```http
POST /token
Host: server.example.com
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code
&code=SplxlOBeZQQYbYS6WxSbIA
&redirect_uri=https://client.example.com/cb
&resource=https://api.billing.com/
```

---

#### 3. Audience Restriction (The "Aud" Claim)
When the Authorization Server processes a request containing a `resource` parameter, it performs **Audience Restriction**.

When the AS mints the Access Token (assuming it is a structured token like a JWT), it sets the `aud` (Audience) claim to the value provided in the `resource` parameter.

**The JWT Payload will look like this:**
```json
{
  "iss": "https://auth.example.com",
  "sub": "user_123",
  "aud": "https://api.billing.com/",  // Restricted Audience
  "scope": "read write",
  "exp": 1700000000
}
```

**Validation Logic:**
1.  The **Client** calls the Billing API with this token.
2.  The **Billing API** inspects the token. It checks: *"Is the `aud` equal to my own URL?"*
3.  **Result:** Yes. Access Granted.

If the Client tried to use this token at `https://api.messaging.com`, that API would reject it because the token was not issued for it.

---

#### 4. Multi-Resource Requests
OAuth 2.0 allows you to ask for permissions for multiple APIs in a single login flow (so the user doesn't have to log in twice). RFC 8707 handles this, but it introduces some complexity regarding the **Access Token**.

**The Challenge:**
An Access Token usually has *one* audience. If you request access for both Billing and Messaging, the AS generally cannot give you *one* Access Token that is valid for both (unless it uses a list of audiences, which is less secure).

**The Flow for Multiple Resources:**

1.  **Authorization Request:** The Client asks for both.
    ```http
    GET /authorize? ... &resource=https://api.billing.com/ &resource=https://api.messaging.com/
    ```
2.  **Authorization Grant:** The AS allows the user to consent to both sets of scopes.
3.  **Token Response:** The AS typically returns an Access Token for the **first** resource requested (or a default one), **AND** a Refresh Token valid for **all** requested resources.
4.  **Switching Context:** When the Client needs to call the *second* API (Messaging), it uses the **Refresh Token**. It sends a token refresh request specifying the *other* resource.

**Example Refresh Request for the 2nd Resource:**
```http
POST /token
...
grant_type=refresh_token
&refresh_token=...
&resource=https://api.messaging.com/
```

The AS will issue a **new** Access Token specifically targeted at the Messaging API.

---

### Summary Table: Scopes vs. Resources

| Feature | Scopes | Resource Indicators |
| :--- | :--- | :--- |
| **Question Answered** | **What** can the token do? | **Where** can the token be used? |
| **Examples** | `read`, `write`, `admin` | `https://api.graph.com`, `https://my-bank.com` |
| **Security Benefit** | Limits functionality (Principle of Least Privilege). | Prevents Audience Confusion / Token Replay at wrong servers. |
| **Token Claim** | `scope` | `aud` (Audience) |

### When should you use Resource Indicators?
1.  **Microservices Architectures:** When you have many services (APIs) and don't want a "Super Token" that works everywhere.
2.  **Zero Trust Security:** To ensure that a compromised service cannot use a user's token to access other internal services.
3.  **Third-Party APIs:** When your Authorization Server issues tokens for APIs you don't control (you want to ensure the token is *only* usable at that specific 3rd party URL).
