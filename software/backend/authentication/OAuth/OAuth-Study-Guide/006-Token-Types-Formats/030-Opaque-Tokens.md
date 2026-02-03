Based on item **#30** in the provided Table of Contents, here is a detailed explanation of **Opaque Tokens** within the context of OAuth 2.0.

---

# 30. Opaque Tokens

In the OAuth 2.0 ecosystem, tokens (specifically Access Tokens) generally fall into two categories: **Structured Components** (like JWTs) and **Opaque Tokens** (or Reference Tokens).

While JWTs carry data *inside* them, **Opaque Tokens** are simply random strings of characters that act as a reference ID.

## 1. Structure & Generation

### What is an Opaque Token?
An opaque token is a proprietary handle or identifier. To the Client application and the Resource Server (API), the token is just a "blob" of text. It contains no meaningful data in and of itself.

*   **Analogy:** Think of a **Coat Check Ticket**. The ticket itself is just a piece of paper with the number "104" on it. The number "104" tells you nothing about the coat (is it a leather jacket? a raincoat?). To identify the coat, you must take the ticket back to the check counter (the Authorization Server).

### Generation
Unlike JWTs, which are generated using base64 encoding and cryptographic signatures, Opaque tokens generate differently:
1.  **Format:** They are usually Cryptographically Secure Pseudo-Random Numbers (CSPRNG), UUIDs, or hex strings (e.g., `8709ec5a-1f6c-4aa7-9204-748956402484`).
2.  **Creation:** When a user logs in, the Authorization Server (AS) creates a session record in its database containing the user's ID, scope, and expiration.
3.  **Mapping:** The AS generates the random string (the Opaque token) and maps it to that database record.

## 2. Token Storage (Stateful Authorization)

The defining characteristic of Opaque tokens is that they require **State** on the Authorization Server.

*   **Server-Side:** The Authorization Server MUST persist the token. If the server reboots and loses its memory/database, the tokens become invalid because the reference is lost.
*   **Client-Side:** The Client application stores the Opaque token exactly the same way it stores a JWT (e.g., in a secure HTTPOnly cookie or secure storage). The client does not care about the format; it simply attaches the string to the `Authorization: Bearer` header.

## 3. Introspection Requirements (RFC 7662)

Since the Resource Server (API) cannot decrypt or "read" the token, it cannot validate the token locally. It requires an extra step called **Introspection**.

### The Flow:
1.  **Client Request:** The Client sends a request to the API: `GET /account` with header `Authorization: Bearer <opaque_string>`.
2.  **API Check:** The API looks at the string. It means nothing.
3.  **Introspection Call:** The API makes a back-channel request to the Authorization Server's **Introspection Endpoint**.
4.  **Lookup:** The Authorization Server looks up `opaque_string` in its database.
5.  **Response:**
    *   If found and valid: The AS returns a JSON object with information (e.g., `{ "active": true, "sub": "user123", "scope": "read" }`).
    *   If expired or revoked: The AS returns `{ "active": false }`.

## 4. Pros & Cons vs. JWT (Structured Tokens)

This is the most critical part of the study guide: knowing when to choose Opaque tokens over JWTs.

### Pros of Opaque Tokens

1.  **Immediate Revocation (Security):**
    *   This is the biggest advantage. If a user loses their phone, or an admin bans a user, the Authorization Server simply deletes the token row from its database. The *very next time* the API attempts to introspect that token, it will fail. (JWTs, by contrast, remain valid until they expire, which makes revocation hard).
2.  **Small Payload Size:**
    *   Opaque tokens are usually much shorter strings than JWTs (which can get very large if they contain many claims/permissions).
3.  **Privacy / Data Hiding:**
    *   The token reveals **nothing** to the Client or anyone who intercepts it. A decoder cannot be used to see the User ID, email, or scopes inside the token. Ideally, the frontend client should not need to know what is inside the access token.

### Cons of Opaque Tokens

1.  **Latency (Performance):**
    *   Every single API request usually triggers a corresponding request to the Authorization Server for introspection. If you have 1,000 API calls, you have 1,000 introspection calls. This is known as being "chatty."
2.  **Authorization Server Load:**
    *   The AS becomes a bottleneck. If the AS goes down or its database locks up, *all* API validation stops immediately.
3.  **Complexity:**
    *   You must implement the Introspection logic RFC 7662 on your Resource Servers.

### Summary Comparison Table

| Feature | Opaque Token | JWT (Self-Contained) |
| :--- | :--- | :--- |
| **Readability** | Unreadable random string | Base64 encoded JSON (readable) |
| **Validation** | Remote (via Introspection) | Local (via Signature verification) |
| **Revocation** | Immediate and easy | Difficult (requires blacklists or short lifespans) |
| **Performance** | Slower (extra network hop) | Faster (stateless verification) |
| **Storage** | Stateful (DB required on AS) | Stateless (Signature required) |

## Use Case Recommendation (The "Phantom Token" Pattern)

A popular architectural pattern (often used by Gateways) combines the best of both worlds:

1.  **Outside the Network:** The Client is given an **Opaque Token**. This keeps it small and secure (revokable).
2.  **The API Gateway:** When the request hits the Gateway, the Gateway performs the Introspection *once*, gets the user data, and swaps the Opaque Token for a **JWT**.
3.  **Inside the Network:** The microservices pass the **JWT** around. They can validate it locally for high performance without calling the Authorization Server constantly.
