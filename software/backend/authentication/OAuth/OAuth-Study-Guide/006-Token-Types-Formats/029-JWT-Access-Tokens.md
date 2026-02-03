Based on **Part 6, Section 29** of your Table of Contents, here is a detailed explanation of **JWT Access Tokens (RFC 9068)**.

---

# 029. JWT Access Tokens (RFC 9068)

## 1. Concept: What is a JWT Access Token?

In the early days of OAuth 2.0, the format of the Access Token was not defined. It was just a string. However, the industry largely converged on using **JSON Web Tokens (JWT)** as the standard format for these tokens.

**RFC 9068** officially standardized how to issue Access Tokens in JWT format.

A JWT (pronounced "jot") is a **self-contained**, **stateless** token.
*   **Self-contained:** It carries all the necessary information (user ID, permissions, expiration) inside the token itself.
*   **Stateless:** The Resource Server (API) does not need to call the Authorization Server (database) to validate the token. It can validate it using cryptography.

---

## 2. Structure & Claims

A JWT is a string of characters separated by two dots (`.`) into three parts: `Header.Payload.Signature`.

### The Header
Describes *how* the token was signed and what kind of token it is.
According to RFC 9068, a JWT Access Token header should look like this:

```json
{
  "typ": "at+jwt",
  "alg": "RS256",
  "kid": "123456"
}
```
*   **`typ`**: Explicitly set to `at+jwt` (Access Token + JWT). This prevents other types of JWTs (like ID Tokens) from being accidentally accepted as Access Tokens.
*   **`alg`**: The algorithm used to sign the token (e.g., RSA 256).
*   **`kid`**: Key ID, telling the API which public key to use to verify the signature.

### The Payload (Claims)
The payload contains the data (claims) about the authorization. RFC 9068 mandates specific standard claims:

| Claim | Full Name | Description |
| :--- | :--- | :--- |
| **`iss`** | Issuer | The URL of the Authorization Server that created the token. (e.g., `https://auth.example.com`). |
| **`sub`** | Subject | The unique identifier of the User (Resource Owner). (e.g., `user_123`). |
| **`aud`** | Audience | Who is this token for? This identifies the Resource Server (API). (e.g., `https://api.example.com`). **Crucial for security.** |
| **`exp`** | Expiration | The timestamp (Unix time) when the token expires. |
| **`iat`** | Issued At | The timestamp when the token was created. |
| **`jti`** | JWT ID | A unique identifier for this specific token string. Useful for tracking and preventing replay attacks. |
| **`client_id`** | Client ID | The identifier of the application attempting to access the API. |
| **`scope`** | Scope | A space-separated list of permissions granted (e.g., `read:profile write:orders`). |

### The Signature
This is the cryptographic proof. It takes the Header + Payload and signs them using a private key held only by the Authorization Server.

---

## 3. Signing Algorithms

Access tokens are "signed" to ensure integrity (no one tampered with the data). Distributing the keys for validation is critical.

*   **Symmetric (HMAC / HS256):** The Auth Server and the API share the *same* secret password. The Auth Server signs with it, and the API validates with it.
    *   *Risk:* If the API is compromised, the attacker gets the secret and can forge tokens.
*   **Asymmetric (RSA / RS256 or ECDSA / ES256):** **The Industry Standard.**
    *   **Private Key:** Held securely by the Authorization Server. Used to *sign* the token.
    *   **Public Key:** Shared publicly (usually via a JWKS endpoint). Used by APIs to *verify* the token.
    *   *Benefit:* Even if an API is hacked, the attacker only finds the Public Key, so they cannot forge new tokens.

---

## 4. Validation Steps

When a Resource Server (API) receives a JWT Access Token, it must perform these checks **before** serving data:

1.  **Signature Check:** Retrieve the Authorization Server's public key (using the `kid` in the header) and verify the signature matches the content.
2.  **Expiration Check (`exp`):** Is the current time *before* the expiration time?
3.  **Issuer Check (`iss`):** Did this token come from the trusted Authorization Server?
4.  **Audience Check (`aud`):** Is this token actually meant for *me* (this API)? (If the token was issued for the "Billing API", the "Messaging API" should reject it).
5.  **Scope Check (`scope`):** Does the token have the specific scope required for the requested endpoint? (e.g., does it have `write` permission?)

---

## 5. Pros & Cons (JWT vs. Opaque Tokens)

In OAuth, you can use Structured (JWT) tokens or Opaque (Reference) tokens. Here is why you would choose JWTs (and the downsides).

### Pros (Why use JWTs?)
1.  **Stateless Scalability:** The API validates the token via math (cryptography), not by asking the database. This reduces latency and load on the Auth Server.
2.  **Data Portability:** The API immediately knows the User ID (`sub`) and permissions (`scope`) just by decoding the token, without needing to look them up.
3.  **Standardization:** With RFC 9068, libraries across all languages (Java, Python, JS, Go) know exactly how to handle these tokens.

### Cons (The risks)
1.  **Immediate Revocation is Hard:** Because the API doesn't call home to validate, it doesn't know if the admin just banned the user. The token remains valid until it expires (`exp`).
    *   *Mitigation:* Use short token lifetimes (e.g., 5-10 minutes).
2.  **Size:** JWTs can get large if they contain many claims/scopes. This adds overhead to every HTTP request.
3.  **Visibility:** The payload is Base64 encoded, **not encrypted**. Anyone who intercepts the token can read the data (though they can't change it).
    *   *Rule:* Never put secrets (like passwords or social security numbers) inside a JWT Access Token.
