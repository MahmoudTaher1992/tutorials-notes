# Token-Based Authentication

Instead of the server remembering a user's session state (stateful), the client stores a self-contained token that holds all necessary information (stateless).

## How It Works: The Authentication Flow

1.  **User Login (Authentication)**
2.  **Server Verification**
3.  **Token Issuance**
    *   The server sends this token back to the client
4.  **Client Storage**
    *   The client application stores the token securely
        *   **Storage options**
            *   `localStorage`
            *   `sessionStorage`
            *   `HttpOnly` cookie
5.  **Subsequent Requests (Authorization)**
    *   The client sends the request in each subsequent requests
6.  **Server Validation**
    *   The server validates
        *   Token signature
            *   ensure no body tampered with it
        *   [It then validates the token's signature to ensure it's authentic and hasn't been tampered with.]
    *   [If the token is valid, the server processes the request. If not, it rejects the request with an "unauthorized" error (e.g., HTTP 401).]

## Key Components of a Token (JWT Example)

*   **JWT (JSON Web Token)**: [The most common format for tokens. A JWT is a compact, URL-safe string that is divided into three parts separated by dots (`.`).]
    *   **Header**:
        *   [Contains metadata about the token, such as the signing algorithm used (e.g., HMAC, RSA) and the token type (`typ`).]
        *   **Example**: `{"alg": "HS256", "typ": "JWT"}`
    *   **Payload (Claims)**:
        *   [Contains statements (**claims**) about the user and additional data. This is the core information the server uses for authorization.]
        *   **Registered Claims**: [Standardized claims like `iss` (issuer), `sub` (subject/user ID), and `exp` (expiration time).]
        *   **Public Claims**: [Custom claims defined by the application, but should be named carefully to avoid collisions.]
        *   **Private Claims**: [Custom claims specific to the application for sharing information between parties.]
        *   **Example**: `{"sub": "12345", "name": "John Doe", "admin": true, "exp": 1672531199}`
    *   **Signature**:
        *   [A cryptographic signature created by combining the encoded header, the encoded payload, a secret key known only to the server, and the algorithm specified in the header.]
        *   **Purpose**: [To verify the integrity of the token. The server can re-calculate the signature and compare it to the one received to ensure the header and payload have not been changed.]

## Advantages of Token-Based Authentication

*   **Stateless**:
    *   [The server does not need to store session information in memory or a database. The token itself contains all the necessary user context.]
    *   **Benefit**: [This makes the application highly scalable, as any server in a distributed system can validate the token without needing to access a central session store.]
*   **Cross-Domain / CORS Friendly**:
    *   [Tokens can be easily sent in request headers, which works across different domains. This is a significant advantage over cookies, which are often restricted by domain policies.]
*   **Decoupled & Portable**:
    *   [The authentication logic is separated from the application. The same token can be used to access different services (APIs, microservices) as long as they share the same secret key for validation.]
*   **Performance**:
    *   [Reduces the need for database lookups on every request, as the user information is already encoded in the token's payload.]
*   **Mobile-Friendly**:
    *   [It is the preferred method for authenticating mobile applications with a backend API, as it doesn't rely on browser-specific mechanisms like cookies.]

## Disadvantages & Considerations

*   **Token Storage Security**:
    *   [If a token is stolen (e.g., through a Cross-Site Scripting (XSS) attack if stored in `localStorage`), an attacker can impersonate the user until the token expires.]
    *   **Mitigation**: [Storing tokens in `HttpOnly` cookies can prevent JavaScript from accessing them, mitigating XSS risks.]
*   **No Server-Side Revocation**:
    *   [Since the system is stateless, you cannot easily invalidate a specific token on the server side before it expires. If a user's token is compromised, it remains valid until its expiration time.]
    *   **Mitigation**: [Workarounds exist, like creating a "blacklist" of revoked tokens that the server must check, but this partially negates the benefit of being stateless.]
*   **Token Size**:
    *   [If you store a lot of data in the token's payload, it can become large, increasing the size of every request header.]