Based on **Table of Contents Item #22**, here is a detailed explanation of the **Revocation Endpoint**, defined in **RFC 7009**.

---

# 022 - Revocation Endpoint (RFC 7009)

## 1. Purpose & Overview
In standard OAuth 2.0, tokens (Access Tokens and Refresh Tokens) have a set lifetime. An Access Token might last 1 hour, and a Refresh Token might last 30 days.

However, there are scenarios where permission needs to be removed **immediately** before the natural expiration time. The Revocation Endpoint allows a **Client** to notify the **Authorization Server** that a specific token is no longer needed and should be invalidated.

**Common Use Cases:**
*   **User Logout:** The user clicks "Sign Out" in the application.
*   **Lost Device:** A user loses their phone and wants to disconnect that specific device session.
*   **App Uninstallation:** The relationship between the user and the app is severed.
*   **Security Compromise:** A token is suspected to have been leaked.

## 2. The Request Structure
To revoke a token, the Client makes a `POST` request to the revocation endpoint (e.g., `https://api.example.com/oauth/revoke`).

### Parameters
The body of the request must be `application/x-www-form-urlencoded` and include:

| Parameter | Required? | Description |
| :--- | :--- | :--- |
| **`token`** | **Yes** | The exact token string the client wants to revoke. |
| **`token_type_hint`** | No | A hint about the type of token being submitted (`access_token` or `refresh_token`). This helps the server optimize the lookup speed (e.g., searching the refresh token table first). |

### Client Authentication
*   **Confidential Clients:** If the client was issued a Client ID and Secret, it **must** authenticate when calling this endpoint just like it does at the Token Endpoint. This ensures that only the application to whom the token was issued can revoke it.
*   **Public Clients:** Public clients (like SPAs or Mobile Apps without secrets) do not authenticate but send the `client_id` parameter to identify themselves.

### Example Request (HTTP)
```http
POST /oauth/revoke HTTP/1.1
Host: server.example.com
Content-Type: application/x-www-form-urlencoded
Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW

token=45ghiukldjahdnhzdauz&token_type_hint=refresh_token
```

## 3. The Response Behavior

The response logic of the Revocation Endpoint is designed for privacy and security.

### Success (`200 OK`)
If the server successfully processes the request, it returns HTTP 200.

**Crucial Nuance:** The server will return `200 OK` in two scenarios:
1.  The token was found and successfully revoked.
2.  The token was **invalid**, **expired**, or **did not exist**.

**Why?** This prevents "Token Scanning." A malicious actor cannot call the endpoint with random strings to guess which tokens are valid based on error messages. From the Client's perspective, the goal is "Make sure this token doesn't work anymore." If the token didn't exist, the goal is already met.

### Errors
Errors typically only occur if the request specificiation is wrong:
*   `unsupported_token_type`: The server doesn't support revoking this specific kind of token.
*   `invalid_client`: The client failed authentication.

## 4. Revocation Propagation (Cascading Effects)

When a token is revoked, it often affects other related tokens. This is implementation-dependent, but common rules are:

1.  **Revoking a Refresh Token:**
    *   The Refresh Token dies.
    *   **ALL** Access Tokens associated with that Refresh Token are also immediately invalidated. (This effectively logs the user out completely).
2.  **Revoking an Access Token:**
    *   The specific Access Token dies.
    *   The Refresh Token usually **stays active**. (The user remains logged in, but that specific authorized session is cleared).

## 5. Implementation Challenges (JWT vs. Opaque Strings)

### Opaque Tokens (Reference Tokens)
Revocation is easy. The key exists in a database. The server simply finds the row for that token and deletes it or sets a flag `is_active = false`.

### JWT (JSON Web Tokens)
Revocation is hard because JWTs are stateless (self-contained). Once a JWT is issued to a client, the server stops tracking it.
*   **The Problem:** Even if the client sends a revocation request, the JWT is still statistically valid until its `exp` (expiration) timestamp.
*   **The Logic:** To support revocation with JWTs, the Authorization Server must implement a **Denylist (Blocklist)** or check a central versioning timestamp in the database on every API call.

## 6. Summary for Developers

1.  **Always implement revocation for "Sign Out".** Just deleting the token from the browser's local storage isn't enough; the token is still valid if stolen. You must tell the server to kill it.
2.  **Use `token_type_hint`.** It speeds up the database query on the server side.
3.  **Don't expect `404` for bad tokens.** You will get a `200 OK` even if you send garbage data.
4.  **Revoke the Refresh Token typically.** If you want to ensure the user is logged out, revoking the Refresh Token is more effective than revoking the Access Token alone.
