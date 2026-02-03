Based on **Part 12 (Resource Server Implementation)** of the study guide, **Section 66: Error Responses** focuses on how a Resource Server (your API) communicates with a Client application when an access token validation fails.

This specific section relies heavily on **RFC 6750 (The OAuth 2.0 Authorization Framework: Bearer Token Usage)**.

Here is a detailed breakdown of how Resource Servers should handle error responses.

---

### The Core Mechanism: The `WWW-Authenticate` Header

When a Resource Server denies a request, it shouldn't just return a JSON error body. According to the OAuth spec, it **must** include the HTTP `WWW-Authenticate` response header.

 This header tells the Client:
1.  **Scheme:** Usually `Bearer`.
2.  **Realm:** A grouping of protected resources (e.g., `realm="my_api"`).
3.  **Error Code:** A standardized machine-readable code explaining *why* it failed.
4.  **Error Description:** A human-readable text (optional but recommended).

---

### 1. `invalid_request`
**HTTP Status:** `400 Bad Request`

This error occurs when the request itself is malformed. It has nothing to do with the validity of the token's data, but rather how the token was transmitted or the syntax of the request.

**Common Causes:**
*   The request is missing the required parameter.
*   The request includes an unsupported parameter or repeats a parameter.
*   **Double Token Binding:** The client sent the token in the **Header** AND in the **Query String** (this is strictly forbidden).

**Example Response:**
```http
HTTP/1.1 400 Bad Request
WWW-Authenticate: Bearer realm="example",
                  error="invalid_request",
                  error_description="The request contains two access tokens"
```

---

### 2. `invalid_token`
**HTTP Status:** `401 Unauthorized`

This is the most common error. It means the Resource Server found the token, but the token itself is bad. The client behaves as if it is not logged in.

**Common Causes:**
*   **Expired:** The token's lifetime (`exp`) has passed.
*   **Revoked:** The user logged out or changed their password, and the Authorization Server revoked this specific token.
*   **Malformed:** The JWT signature doesn't match, or the token string is not in the expected format.
*   **Wrong Audience/Issuer:** The token was issued by a different server or intended for a different API.

**Client Action:** The client must discard the Access Token. It should try to use a Refresh Token to get a new one, or force the user to log in again.

**Example Response:**
```http
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Bearer realm="example",
                  error="invalid_token",
                  error_description="The access token expired"
```

---

### 3. `insufficient_scope`
**HTTP Status:** `403 Forbidden`

This is a critical distinction in OAuth.
*   **401 (`invalid_token`)** means "I don't know who you are" or "Your ID is fake/expired."
*   **403 (`insufficient_scope`)** means "I know exactly who you are, and your token is valid, **BUT** you don't have permission to do this specific thing."

**Common Cause:**
The client has a token with scope `read:user`, but tries to POST to `/api/users` which requires the `write:user` scope.

**Client Action:** The client usually needs to send the user back to the Authorization Server to ask for additional consent (request the missing scope).

**Example Response:**
```http
HTTP/1.1 403 Forbidden
WWW-Authenticate: Bearer realm="example",
                  error="insufficient_scope",
                  scope="write:user"
```
*(Note: The server often includes a `scope` attribute in the header indicating exactly which scope was missing.)*

---

### Summary Table for Implementation

When building your Resource Server (API), your authentication middleware should follow this logic flow to determine the error response:

| Check | Scenario | Error Code (RFC 6750) | HTTP Status |
| :--- | :--- | :--- | :--- |
| **1. Syntax** | Did the client send the token in the Headers AND the Body? Is the header malformed? | `invalid_request` | **400** |
| **2. Validity** | Is the token expired? Is the signature wrong? Is it revoked? | `invalid_token` | **401** |
| **3. Permissions** | Is the token valid, but lacks the specific `scope` required for this endpoint? | `insufficient_scope` | **403** |

### Implementation Tip: Security Considerations

1.  **Don't be too verbose:** In the `error_description`, verify you aren't leaking internal infrastructure details (e.g., "Database connection failed while checking token"). Keep it to "The token is invalid."
2.  **Header is Mandatory:** Many developers forget the `WWW-Authenticate` header and only return a JSON body (e.g., `{ "message": "error" }`). While the JSON body is helpful for the frontend developer, the **Header** is what standard OAuth libraries look for to automatically handle token refreshes.
