This section focuses on how to handle security, authentication, and authorization when moving from a monolithic application to a distributed microservices architecture. In a monolith, a single session cookie or check is often enough. In microservices, requests hop between many different services, requiring a robust strategy to maintain security without sacrificing performance.

Here is a detailed breakdown of the four key concepts listed in Section 55:

---

### 1. Gateway Token Validation
**The Pattern:** The "Bouncer" at the Door.

In a microservices architecture, you want to avoid every single microservice (Product Service, Pricing Service, Inventory Service) having to reach out to the ID Provider (like Auth0, Keycloak, or Okta) to validate a token. That causes massive network chatter and latency.

Instead, you offload this responsibility to the **API Gateway** (e.g., Kong, APIGee, AWS API Gateway, Nginx).

*   **How it works:**
    1.  The Client (Frontend/Mobile) handles the OAuth flow and gets an Access Token.
    2.  The Client sends the request to the API Gateway with the token in the `Authorization: Bearer <token>` header.
    3.  **The Gateway Validates:**
        *   **If JWT (Stateless):** The Gateway downloads the public keys (JWKS) from the Authorization Server and verifies the signature, expiration, and issuer locally.
        *   **If Opaque Token (Stateful):** The Gateway calls the **Introspection Endpoint** (RFC 7662) to check if the token is active.
    4.  If valid, the Gateway allows the request to proceed to the internal microservices. If invalid, the Gateway returns `401 Unauthorized` immediately.

*   **Benefit:** Internal services can be "dumber" regarding cryptography. They rely on the extensive security check performed at the edge.

---

### 2. Propagating User Context
**The Pattern:** "Who is this?" (The Phantom Token Approach).

Once the Gateway validates the token, the downstream microservice needs to know *who* the user is (e.g., "User ID: 123", "Role: Admin").

There are two primary ways to propagate this context:

#### A. The Pass-Through (Simple but Risky)
The Gateway simply forwards the raw Access Token to the downstream service. The internal service parses the JWT to get the user ID.
*   *Pros:* Zero translation effort.
*   *Cons:* Every internal service must include JWT parsing libraries. You are exposing the raw credentials deeper into your network.

#### B. The Phantom Token / Identity Injection (Preferred)
This is the industry standard for high-security environments.
1.  **Validation:** The Gateway validates the Access Token.
2.  **Strip & Replace:** The Gateway *removes* the Access Token from the request.
3.  **Injection:** The Gateway reads the claims inside the token (Subject, Email, Groups) and inserts them as **plain HTTP Headers** (e.g., `X-User-Id: 123`, `X-Role: Manager`, `X-Email: bob@mail.com`).
4.  **Forward:** The request is sent to the microservice. Note that the microservice must be configured to **only** accept traffic from the Gateway (using mTLS or network policies) so that attackers cannot bypass the Gateway and spoof these headers.

---

### 3. Service-to-Service Authorization
**The Pattern:** "I am a machine talking to a machine."

Sometimes, microservices need to talk to each other without a user being involved (e.g., A nightly batch job running on the Billing Service needs to query the Database Service).

*   **The Problem:** The Billing Service cannot use a User's token because no user is logged in.
*   **The Solution:** **Client Credentials Grant**.
    1.  The Billing Service has its own `client_id` and `client_secret`.
    2.  It authenticates with the Authorization Server.
    3.  It receives an Access Token representing the *service itself* (Process A), not a human.
    4.  It calls the Database Service using this machine token.

*   **Zero Trust implication:** Even within your private network, Service B should verify the token from Service A. This ensures that compromised services cannot arbitrarily access other internal data.

---

### 4. Token Exchange Between Services
**The Pattern:** Delegation and Least Privilege (RFC 8693).

This is a complex scenario where **User Context** and **Service Context** mix.

*   **Scenario:**
    1.  User calls **Service A** (e.g., "Order Service") with a token scoped for `orders:write`.
    2.  **Service A** needs to call **Service B** (e.g., "Payment Service") to process a charge.
    3.  Service A should *not* just pass the user's `orders:write` token to Service B, because Service B expects a token with `payment:process` scope. Also, passing the original token allows Service B to impersonate the user against Service A (Token Replay/Leakage).

*   **The Solution:** **OAuth 2.0 Token Exchange (RFC 8693)**.
    1.  **Service A** takes the incoming User Token.
    2.  **Service A** sends the User Token to the Authorization Server saying, "I am Service A. Here is a valid token from User John. Please give me a *new* token that allows *me* to call **Service B** *on behalf of* User John."
    3.  The Auth Server verifies permissions and issues a new token specifically audienced for Service B with the correct scopes.

This pattern, often called the **"On-Behalf-Of" (OBO)** flow, maintains the principle of **Least Privilege**. Service B receives a token that is valid only for itself and contains both the User's identity and the calling Service's identity.

### Summary of the Flow

| Step | Component | Action |
| :--- | :--- | :--- |
| 1 | **Client** | Sends request `GET /orders` with `Authorization: Bearer <Token>` |
| 2 | **API Gateway** | **Validates Token** (Signature/Expiry). Extracts `sub: user_123`. |
| 3 | **API Gateway** | **Context Propagation**: Adds Header `X-User-ID: user_123` and forwards to Order Service. |
| 4 | **Order Service** | Receives request. Reads header. Needs to call Inventory Service. |
| 5 | **Order Service** | **Service-to-Service**: Uses its own Client Credentials (or Token Exchange) to get a token to talk to Inventory. |
| 6 | **Inventory** | Validates the incoming token from Order Service. Returns data. |
