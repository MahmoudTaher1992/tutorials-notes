Here is a detailed explanation of **Section 16: Token Exchange Grant (RFC 8693)** from your study guide.

---

# 16. Token Exchange Grant (RFC 8693)

The **Token Exchange Grant** is one of the more advanced and powerful features in the modern OAuth ecosystem. Unlike standard flows (like Authorization Code) where a user interacts with a browser to get a token, Token Exchange is primarily a back-end protocol used between microservices and gateways.

It addresses the **"On-Behalf-Of"** problem: *How does Service A call Service B while maintaining the identity of the original user, without sharing the exact same token?*

## 1. The Core Concept
In complex architectures (like microservices), a token issued to a client might validly identify the user, but it might not be valid for an internal downstream service.

**Token Exchange allows a client to request a new set of tokens by presenting an existing valid token.**

It effectively says to the Authorization Server:
> "Here is a token I have (Subject Token). Please validate it and give me a new token that I can use to call a specific downstream service (Audience)."

## 2. Key Terminology
To understand this grant, you must distinct between two entities defined in the RFC:

*   **The Subject (Subject Token):** The entity (usually the End-User) that the existing token represents. This is the "who" the token is about.
*   **The Actor (Actor Token):** The entity requesting the exchange. This is the application or service currently holding the token and asking to act on the user's behalf.

## 3. Top Use Cases

### A. The "On-Behalf-Of" Flow (Delegation)
*   **Scenario:** A User logs into a **Web App**. The App calls **Service A**. **Service A** needs to fetch data from **Service B** to fulfill the request.
*   **Problem:** Service A cannot just pass the User's token to Service B if:
    *   Service B requires a different Scope.
    *   Service B requires a different Audience (`aud`).
    *   Service B requires a different token format (e.g., opaque vs JWT).
*   **Solution:** Service A sends the User's token to the Authorization Server, performs a Token Exchange, and gets a *new* token specifically meant for Service B.

### B. Impression vs. Delegation
*   **Delegation:** The new token usually contains claims about *both* the User (Subject) and Service A (Actor). It says "Service A is acting on behalf of User X." Access rights are the intersection of what the User can do and what Service A is allowed to do.
*   **Impersonation:** The new token *looks exactly* like the User logged in directly. There is no trace of Service A in the token claims. This is common when swapping administrative tokens or legacy system integration.

### C. Token Transformation
*   Swapping a **SAML Assertion** for an **OAuth Access Token**.
*   Swapping an **Opaque Token** (reference token) for a **JWT** (to pass to a service that needs to read claims).

## 4. The Flow Diagram

1.  **Client (Service A)** possesses a token (Subject Token) representing the User.
2.  **Client** requests an exchange from the **Authorization Server (AS)**.
3.  **AS** validates the Subject Token and the Client's credentials.
4.  **AS** mints a new token (intended for Service B).
5.  **Client** uses the new token to call **Service B**.

## 5. Technical Implementation (The Request & Response)

This occurs at the standard **Token Endpoint** (`POST /oauth/token`).

### The Request
The client makes a POST request including the following standard and extension parameters:

```http
POST /token HTTP/1.1
Host: auth-server.com
Content-Type: application/x-www-form-urlencoded

grant_type=urn:ietf:params:oauth:grant-type:token-exchange
&client_id=service-a-client-id
&client_secret=service-a-secret
&subject_token=abc...123              <-- The existing token
&subject_token_type=urn:ietf:params:oauth:token-type:access_token
&audience=service-b-resource-id       <-- Where I want to use the new token
&requested_token_type=urn:ietf:params:oauth:token-type:access_token
```

*   **`grant_type`**: Must be the specific URN: `urn:ietf:params:oauth:grant-type:token-exchange`.
*   **`subject_token`**: The actual token string you want to swap.
*   **`subject_token_type`**: Identifies what kind of token you sent (Access Token, Refresh Token, ID Token, SAML 1/2, or JWT).
*   **`audience`** (Optional): Indicates the target service where the new token will be used. This helps the Authorization Server restrict the scope of the new token.

### Optional: Actor Token
If Service A wants to explicitly declare "I am the one asking," it can include:
*   `actor_token`: The token representing Service A's own identity.
*   `actor_token_type`: The type of the actor token.

### The Response
If successful, the server returns a standard JSON OAuth response:

```json
{
  "access_token": "xyz...789",
  "issued_token_type": "urn:ietf:params:oauth:token-type:access_token",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "read:data"
}
```

*   **`issued_token_type`**: Tells the client what type of token was actually returned (usually a JWT or Access Token).

## 6. Composite Tokens (The `act` claim)
If the exchange resulted in **Delegation** (not impersonation), the resulting JWT often contains an `act` claim.

**Example Decoded JWT Payload:**
```json
{
  "sub": "user_123",       // The Subject (The End User)
  "aud": "service-b",      // The Target Audience
  "act": {                 // The Actor (Who requested this?)
    "sub": "service-a"
  }
}
```
When Service B receives this, it knows: "This is `user_123`, but `service-a` is the one driving the car." Service B can then decide if it trusts Service A to touch User 123's data.

## 7. Security Considerations
1.  **Trust Relationships:** The Authorization Server must explicitly trust Client A to exchange tokens for Target B. You don't want any random client swapping tokens to access sensitive administrative APIs.
2.  **Scope Downgrading:** Ideally, the exchanged token should not have *more* privileges than the original subject token (unless specifically designed for privilege escalation, which is risky).
3.  **Audience Restriction:** Without token exchange, developers often reuse the exact same token across multiple microservices. This is bad security ("Audience Logic Bomb"). Token Exchange solves this by ensuring Service B receives a token specifically minted for *it*, not for the generic Web App.

## Summary for the Exam/Guide
*   **RFC:** 8693
*   **Goal:** Swap one token for another.
*   **Primary Use:** Microservices calling other microservices (BFF to Backend, or Service to Service) while maintaining user context.
*   **Key Parameters:** `grant_type` (long URN), `subject_token`, `audience`.
*   **Distinction:** Supports both **Impersonation** (Subject only) and **Delegation** (Subject + Actor via `act` claim).
