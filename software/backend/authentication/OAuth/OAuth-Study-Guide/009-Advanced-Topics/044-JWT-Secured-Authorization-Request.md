Here is a detailed explanation of **Topic 044: JWT-Secured Authorization Request (JAR)** from section **Part 9: Advanced Topics** of the study guide.

---

# 44. JWT-Secured Authorization Request (JAR) - RFC 9101

## The Problem: Standard Authorization Requests
In a standard OAuth 2.0 flow, the client initiates the process by redirecting the user’s browser to the Authorization Server. This is typically done via a URL Query String, like this:

```http
GET /authorize?
    response_type=code
    &client_id=my-client-id
    &redirect_uri=https://client.com/callback
    &scope=openid profile
    &state=xyz123
    &nonce=abc987
```

**Weaknesses of this approach:**
1.  **Integrity:** The parameters are not signed. If a sophisticated attacker (or a malicious browser extension) modifies the `redirect_uri` or `scope` in transit within the browser, the Authorization Server might not know the difference.
2.  **Confidentiality:** All parameters are visible in the URL. This means sensitive data (like personally identifiable information in `claims` or custom scopes) can leak via browser history, proxy logs, or `Referer` headers.
3.  **Replay:** If an attacker captures the URL, they might be able to replay the request.

## The Solution: JAR (RFC 9101)
**JWT-Secured Authorization Request (JAR)** solves these issues by packaging the authorization parameters into a **JWT (JSON Web Token)** instead of sending them as loose query parameters.

This JWT is known as the **Request Object**.

### 1. The Request Object
The Request Object is a JWT that contains all the Authorization Request parameters as claims within its payload.

**Example of a decoded Request Object Payload:**
```json
{
  "iss": "my-client-id",
  "aud": "https://auth-server.com",
  "response_type": "code",
  "client_id": "my-client-id",
  "redirect_uri": "https://client.com/callback",
  "scope": "openid profile",
  "state": "xyz123",
  "exp": 1615467890,
  "nbf": 1615467000
}
```
*   **Standard Claims:** It includes standard JWT claims like `iss` (issuer), `aud` (audience/authorization server), `exp` (expiration), and `nbf` (not before) to prevent replay attacks.
*   **OAuth Parameters:** It includes the standard OAuth parameters (`response_type`, `scope`, etc.).

### 2. Signed & Encrypted Requests
Because the Request Object is a JWT, it leverages JOSE (Javascript Object Signing and Encryption) standards:

*   **JWS (Signed):** The client signs the JWT using its private key.
    *   *Benefit:* The Authorization Server uses the client's public key to verify the signature. This guarantees **Integrity** (nobody tampered with the parameters) and **Authenticity** (it definitely came from this client).
*   **JWE (Encrypted):** The client can optionally encrypt the JWT using the Authorization Server's public key.
    *   *Benefit:* This guarantees **Confidentiality**. Even if the URL is logged, the parameters are hidden inside an encrypted blob.

### 3. Passing by Value vs. by Reference
Once the Client creates the Request Object (the JWT), it needs to send it to the Authorization Server. There are two ways to do this:

#### A. Passing by Value (`request` parameter)
The client includes the actual JWT string directly in the Authorization URL.

```http
GET /authorize?
    client_id=my-client-id
    &request=eyJhbGciOiJSUzI1NiIs... (The long JWT string) ...
```
*   **Pros:** Stateless; no extra infrastructure needed.
*   **Cons:** JWTs can be very large. Browser URLs have length limits (often 2kb - 8kb). If the request is complex (complex claims or scopes), the URL might be truncated, causing the request to fail.

#### B. Passing by Reference (`request_uri` parameter)
The client hosts the JWT at a URL accessible by the Authorization Server, or pushes it to the server beforehand (using PAR - Pushed Authorization Requests). The client sends the URL pointing to the JWT.

```http
GET /authorize?
    client_id=my-client-id
    &request_uri=https://client.com/requests/req-id-1234
```
*   **Pros:** Bypasses browser URL length limits; allows for much larger, complex requests; more secure as the JWT isn't permanently in the browser history.
*   **Cons:** Requires either a storage mechanism on the client side or usage of PAR (RFC 9126).

### 4. Security Benefits Summary

| Feature | Standard OAuth Request | JAR (JWT-Secured) |
| :--- | :--- | :--- |
| **Tamper Proofing** | No (Relies on TLS only) | **Yes** (Signed by Client Key) |
| **Sender Authenticity** | No (Anyone can redirect usually) | **Yes** (Signature Verification) |
| **Confidentiality** | No (Visible in URL) | **Yes** (If JWE is used) |
| **Replay Protection** | Low (Relies on nonce/state) | **High** (via `exp`, `jti`, `nbf` claims) |
| **Complexity** | Low | Medium (Requires key management) |

### Relationship with FAPI (Financial-grade API)
JAR is a core requirement for **FAPI** profiles (used in Open Banking). In high-security environments (banking, healthcare), you cannot trust query parameters sent via the browser. You almost *must* use signed Request Objects to ensure that a malicious actor hasn't altered the transaction details (e.g., changing the payment amount in the scope or claims) during the redirection.
