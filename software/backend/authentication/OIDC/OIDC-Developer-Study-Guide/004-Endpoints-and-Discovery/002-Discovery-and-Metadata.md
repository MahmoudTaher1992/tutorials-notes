Based on **Part 4, Section 14** of your Table of Contents, here is a detailed explanation of **Discovery and Metadata**.

---

# 14. Discovery & Metadata

In the early days of authentication protocols, developers had to manually read documentation to find specific URLs (where to send the user for login, where to exchange tokens, etc.) and hardcode them into their applications. This was brittle and prone to errors.

**OIDC Discovery** solves this by defining a standard way for an **OpenID Provider (OP)** (like Google, Auth0, or Keycloak) to publish a JSON document that describes exactly how it works.

### 1. The Well-Known Configuration Endpoint
The heart of OIDC Discovery is a specific URL path defined by the standard. If you know the root URL of the Identity Provider (the "Issuer"), you can automatically find its configuration.

The standard path is:
`/.well-known/openid-configuration`

**How it works:**
If your Identity Provider's Issuer URL is `https://idp.example.com`, your application (the Client) will perform an HTTP `GET` request to:
`https://idp.example.com/.well-known/openid-configuration`

### 2. Provider Metadata Fields
When the client makes that request, the Provider returns a JSON object containing **Metadata**. This is the "instruction manual" for the client.

Here are the most critical fields found in that JSON response:

#### A. Endpoint Locations
Instead of guessing where to send requests, the JSON tells you exactly where they are:
*   **`issuer`**: The unique identifier of the provider. (Must match the URL used to fetch the config).
*   **`authorization_endpoint`**: The URL where you redirect the user's browser to log in.
*   **`token_endpoint`**: The URL where your server exchanges an Authorization Code for an Access Token.
*   **`userinfo_endpoint`**: The URL used to fetch user profile details using an Access Token.
*   **`jwks_uri`**: (Crucial) The URL containing the **JSON Web Key Set**. This contains the *public keys* your app needs to verify the digital signature of the ID Token.

#### B. Capabilities & Support
The metadata also tells your application what features are enabled:
*   **`scopes_supported`**: A list of scopes the server allows (e.g., `["openid", "profile", "email", "offline_access"]`).
*   **`response_types_supported`**: Tells you which flows are allowed (e.g., `["code"]` for Authorization Code flow).
*   **`grant_types_supported`**: Which grant types are allowed (e.g., `["authorization_code", "refresh_token"]`).
*   **`subject_types_supported`**: Usually `public` (everyone gets the same user ID) or `pairwise` (each client gets a different user ID for the same user).

**Example JSON Response (Simulated):**
```json
{
  "issuer": "https://idp.example.com",
  "authorization_endpoint": "https://idp.example.com/oauth/authorize",
  "token_endpoint": "https://idp.example.com/oauth/token",
  "userinfo_endpoint": "https://idp.example.com/propfil",
  "jwks_uri": "https://idp.example.com/.well-known/jwks.json",
  "scopes_supported": ["openid", "profile", "email"],
  "response_types_supported": ["code", "id_token"]
}
```

### 3. Dynamic Discovery
**Dynamic Discovery** refers to the coding pattern where your application is not hardcoded with endpoints.

**Static Configuration (The Old Way):**
You put `AUTH_URL`, `TOKEN_URL`, `USERINFO_URL`, and `JWKS_URL` all inside your `.env` file. If the provider changes a URL, your app breaks.

**Dynamic Configuration (The OIDC Way):**
1.  You only provide your app with **one** URL: The Issuer URL (e.g., `https://accounts.google.com`).
2.  When your application starts up, it automatically hits `/.well-known/openid-configuration`.
3.  It parses the JSON and configures itself automatically.

This is highly recommended because it allows the endpoints to change (or keys to rotate) without you needing to deploy code changes.

### 4. Caching Considerations
While Dynamic Discovery is powerful, it introduces a performance consideration. You do not want to fetch the metadata JSON every time a user tries to log in.

*   **HTTP Overhead:** Fetching the config adds network latency to the login process.
*   **Rate Limiting:** If you have high traffic, the Identity Provider might block you (Rate Limit) for requesting the configuration too often.

**Best Practices:**
1.  **Cache on Startup:** Most OIDC libraries fetch the configuration once when the application boots up and store it in memory.
2.  **Respect HTTP Headers:** The Provider will usually send `Cache-Control` headers. Your app should respect these (e.g., cache for 24 hours).
3.  **Key Rotation Logic:** If your application tries to validate a token signature and fails (because the key isn't in your cache), sophisticated clients will automatically trigger a "refresh" of the Discovery document effectively saying, "My keys are old, let me check if the server published new ones."

### Summary of the Flow
1.  **Developer** configures App with `Issuer URL`.
2.  **App** (at startup) GETs `Issuer URL` + `/.well-known/openid-configuration`.
3.  **Provider** returns JSON Metadata.
4.  **App** caches endpoints (Auth, Token, JWKS).
5.  **User** clicks "Login".
6.  **App** reads `authorization_endpoint` from cache and redirects user there.
