Here is a detailed explanation of **Section 23: Introspection Endpoint** based on RFC 7662.

---

# 23. Introspection Endpoint (RFC 7662)

The Introspection Endpoint allows a Resource Server (API) or a client to query the Authorization Server to determine the active state of an OAuth 2.0 token and to determine its meta-information.

While JWTs (JSON Web Tokens) are "self-contained" and can be validated using cryptography without calling home, **Opaque Tokens** (random strings) *must* be validated by asking the server that issued them. This is the primary purpose of the Introspection Endpoint.

## 1. Purpose & Behavior

The Introspection endpoint answers the question: **"Is this token currently valid, and if so, who is it for?"**

### Role in the Flow
1.  **Client** sends an Access Token (e.g., `Bearer ag5...`) to the **Resource Server (API)**.
2.  The Resource Server receives the token but, if it is opaque, it doesn't know what it means or if it has expired.
3.  The **Resource Server** makes a POST request to the **Introspetion Endpoint** on the Authorization Server.
4.  The **Authorization Server** looks up the token in its database to check if it is valid, not expired, and not revoked.
5.  It returns a JSON object indicating the status.

### Why is this better than generic validation?
It allows for **Reference Tokens**. The token carried by the client is just an ID. The actual data (user ID, scopes) is stored on the server. This allows the Authorization Server to revoke a token instantly. If you revoke a JWT, it remains valid until it expires; if you revoke a Reference Token, the next introspection call returns `active: false`.

---

## 2. Request Structure

The introspection request is typically a `POST` request sent by the Resource Server to the Authorization Server.

*   **Authentication:** Since this is an internal check, the Resource Server must authenticate itself (e.g., using a Client ID and Secret allocated specifically for the API).
*   **Content-Type:** `application/x-www-form-urlencoded`

### Parameters
*   **`token` (Required):** The string value of the token being checked.
*   **`token_type_hint` (Optional):** A hint about the type of token (e.g., `access_token` or `refresh_token`). This helps the database search faster but does not guarantee the type.

### Example Request
```http
POST /introspect HTTP/1.1
Host: server.example.com
Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
Content-Type: application/x-www-form-urlencoded

token=mF_9.B5f-4.1JqM&token_type_hint=access_token
```

---

## 3. Response Structure

The response is a JSON object. The most critical field is `active`.

### Scenario A: The Token is Valid (`active: true`)
If the token is valid, the server returns `active: true` and includes metadata about the token.

```json
{
  "active": true,
  "scope": "read write",
  "client_id": "client_12345",
  "username": "jdoe",
  "token_type": "Bearer",
  "exp": 1419356238,
  "iat": 1419350238,
  "sub": "Z5O3upPC88QrAjx00dis",
  "aud": "https://protected.example.net/resource"
}
```
*   **sub:** The user (Subject) the token represents.
*   **scope:** What permissions are granted.
*   **exp:** When the token expires.

### Scenario B: The Token is Invalid (`active: false`)
If the token is expired, revoked, malformed, or simply doesn't exist, the server returns `200 OK` with `active: false`.

```json
{
  "active": false
}
```
**Crucial Note:** The endpoint does **not** return a 404 Not Found or 400 Bad Request for an invalid token string. It returns 200 OK with `active: false`. This prevents "Token Scanning" (attackers guessing tokens to see which ones generate different error codes).

---

## 4. Active vs. Inactive Tokens

The Authorization Server determines the state based on internal logic.

### Active Token Logic
To returns `active: true`, the token must be:
1.  Issued by this Authorization Server.
2.  Not expired (current time is before `exp`).
3.  **Not revoked** (this is the key benefit of introspection).
4.  Formatted correctly.

### Inactive Token Logic
It returns `active: false` if:
1.  The token string is gibberish.
2.  The token has expired.
3.  The user logged out (causing token revocation).
4.  The administrator banned the client or user.

---

## 5. Performance Considerations

Introspection introduces latency.

*   **The Latency Problem:** In a standard JWT flow, the API validates the token locally (0ms network latency). In Introspection, *every* API call triggers an HTTP call to the Authorization Server. If your API gets 1,000 requests/second, your Authorization Server also gets hit 1,000 times/second.
*   **The Mitigation (Caching):** Resource Servers usually implement **short-lived caching**.
    *   *Step 1:* Introspect the token.
    *   *Step 2:* If valid, cache the result for a short period (e.g., 60 seconds or 5 minutes).
    *   *Step 3:* For subsequent requests with the same token, check the cache first.
    *   *Trade-off:* This creates a small window where a revoked token might still work until the cache expires.

---

## 6. When to Use Introspection vs. Local Validation

This is a major architectural decision in OAuth implementation.

| Feature | **Local Validation (Stateless JWT)** | **Introspection (Opaque / Reference Tokens)** |
| :--- | :--- | :--- |
| **Token Format** | Structured (Base64 JSON) | Random String (Opaque) |
| **Verification** | Cryptographic signature check (using Public Key). | HTTP Request to Introspection Endpoint. |
| **Privacy** | Low. Anyone with the token can decode it to see user info (claims). | High. The token string reveals nothing about the user/scopes to the public. |
| **Revocation** | **Hard.** Cannot revoke easily before expiration without complex blacklists. | **Instant.** As soon as the DB state changes, the token stops working. |
| **Performance** | **Fast.** No network overhead. | **Slower.** Requires network round-trip per validation (unless cached). |
| **Size** | Large (contains data). Can hit header limits. | Small (just a reference ID). |

### Summary: When to choose which?

1.  **Use Introspection (Reference Tokens) if:**
    *   You require **immediate revocation** (e.g., banking apps, high-security enterprise apps).
    *   You want to keep your internal architecture (claims, user IDs) **private** from the client (P II leakage prevention).
    *   The token payload is very large.

2.  **Use Local Validation (JWTs) if:**
    *   You have a high-traffic system (microservices) and cannot afford the network latency of introspection.
    *   You need stateless authentication across distributed services.
