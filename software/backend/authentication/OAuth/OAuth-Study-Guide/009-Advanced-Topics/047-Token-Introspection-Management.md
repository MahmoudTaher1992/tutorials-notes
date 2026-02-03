Here is a detailed explanation of **Topic 047: Token Introspection & Management**.

This topic deals with the architecture of how a Resource Server (API) determines if an Access Token is valid, how to handle that validation performantly, and how to stop a token from working before it expires.

---

# 47. Token Introspection & Management

In a standard OAuth flow, the Client sends a token to the Resource Server (API). The API must determine: **"Is this token valid, and what is it allowed to do?"**

There are two fundamental ways to answer this question, leading to the distinction between **Introspection** (asking the issuer) and **Local Validation** (checking the signature).

## 1. Centralized vs. Distributed Validation

This is the core architectural decision when designing an OAuth system.

### Option A: Local / Distributed Validation (Stateless)
*   **Token Format:** JWT (JSON Web Tokens).
*   **Method:** The Resource Server (RS) downloads the public signing keys (JWKS) from the Authorization Server (AS). When a request comes in, the RS validates the cryptographic signature and checks the expiration claim (`exp`) locally.
*   **Pros:** Extremely fast; no network call to the AS for every API request; highly scalable.
*   **Cons:** **"The Revocation Problem."** Once a JWT is issued, it is valid until it expires. If an administrator bans a user or revokes a client's access, the JWT remains valid until its time is up.

### Option B: Centralized Validation (Introspection)
*   **Token Format:** Reference Tokens (Opaque strings) or JWTs.
*   **Method:** The RS receives the token and sends it back to the AS via an HTTP POST request to the **Introspection Endpoint** (defined in RFC 7662). The AS checks its database to see if the token is currently active.
*   **Pros:** **Ultimate Security and Control.** Allows for real-time revocation. If a user is banned, the AS returns `active: false` immediately.
*   **Cons:** **Latency and Load.** Every single API call results in a network call to the Authorization Server. If your API gets 10,000 requests/second, your Auth Server gets 10,000 introspection requests/second.

## 2. The Introspection Endpoint (RFC 7662)

To manage centralized validation, OAuth 2.0 defines a standard endpoint.

**The Request:**
 The RS (acting as a client) authenticates itself and sends the token to the AS.

```http
POST /introspect HTTP/1.1
Host: auth-server.com
Content-Type: application/x-www-form-urlencoded
Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW

token=mF_9.B5f-4.1JqM&token_type_hint=access_token
```

**The Response:**
The AS looks up the token in its store. If valid, it returns the metadata associated with it.

```json
{
  "active": true,
  "client_id": "l238j323ds-23ij4",
  "username": "jdoe",
  "scope": "read write",
  "sub": "Z5O3upPC88QrAjx00dis",
  "aud": "https://protected.example.net/resource",
  "iss": "https://server.example.com/",
  "exp": 1419356238,
  "iat": 1419350238
}
```

If the token is expired, revoked, or invalid, the response is simply:
```json
{
  "active": false
}
```

## 3. Token Caching Strategies

Because Introspection introduces significant network latency (the "Chatty" protocol problem), developers implement caching strategies to balance security and performance.

### The "Short Cache" Pattern
Instead of introspecting every single request, the Resource Server (or API Gateway) introspects the token once and caches the result for a short duration (e.g., 30 seconds to 2 minutes).

*   **Request 1:** Introspect (Network call: 100ms) -> Store result in Redis/Memory with TTL 60s.
*   **Seconds 1–59:** Serve requests using cached result (0ms).
*   **Minute 2:** Cache expired. Introspect again.

**The Trade-off:** access is effectively irrevocable during the cache window. If you revoke a token at second 5, the user can still access the API until second 60. This is usually an acceptable risk for most applications compared to the performance cost of zero caching.

## 4. Real-Time Revocation Checking

Revocation management is the primary driver for choosing Introspection over stateless JWTs.

**scenarios requiring Introspection:**
1.  **High-Security Finance/Banking:** If a fraudulent transaction is detected, access must be cut *instantly*.
2.  **User Logout:** When a user clicks "Logout," they expect their session to end everywhere. With stateless JWTs, the token technically still works. With introspection, the AS deletes the token session, and the next API call fails.
3.  **Employee Termination:** If an employee leaves a company, their access to internal tools must cease immediately.

### The "Phantom Token" Pattern (Best of Both Worlds)
This is an advanced architectural pattern often used with API Gateways.

1.  **Client:** Holds an **Opaque (Reference) Token**. This is secure because no data is leaked to the browser/app.
2.  **API Gateway:** Receives the Opaque Token. It calls the **Introspection Endpoint**.
3.  **Auth Server:** Validates the token and returns the JSON metadata.
4.  **API Gateway:** Converts the Opaque Token into a **JWT** (using the metadata) and passes the *JWT* downstream to the microservices.
5.  **Microservices:** Use **Local Validation** on the JWT.

**Result:** You get the security/revocability of Introspection (at the edge) and the performance of stateless validation (inside your internal network).

## Summary: How to Choose?

| Scenario | Recommended Strategy |
| :--- | :--- |
| **Public API (High Traffic)** | **Stateless JWTs.** Introspection is too slow and expensive for massive scale. |
| **Internal Enterprise App** | **Introspection.** Traffic is manageable, and security/instant revocation is usually a requirement. |
| **Banking / Sensitive Data** | **Introspection (or Short-lived JWTs).** Security takes priority over latency. |
| **Microservices Mesh** | **Phantom Token Pattern.** Introspect at the gateway, JWT internally. |
