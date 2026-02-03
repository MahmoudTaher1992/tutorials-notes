Based on Part 4 of the Table of Contents you provided, here is a detailed explanation of **Endpoints and Discovery** in OpenID Connect (OIDC).

To understand OIDC, you have to realize that the **OpenID Provider (OP)** (like Auth0, Google, or Keycloak) is essentially a web server with several specific URL "doors" (endpoints) that your application (the **Relying Party** or **RP**) knocks on to perform different tasks.

Here is the breakdown of how these endpoints work, split into **Discovery** (finding the doors) and **Usage** (opening the doors).

---

### 1. Discovery & Metadata
**"Where are the servers located?"**

Before your application can log a user in, it needs to know *where* to send the user. Hardcoding URLs (e.g., `https://google.com/auth/login`) is bad practice because URLs can change. OIDC solves this with **Discovery**.

#### The Well-Known Configuration Endpoint
*   **Identifyer:** `/.well-known/openid-configuration`
*   **Purpose:** This is the "map" or "menu" for the Identity Provider.
*   **How it works:** Your application makes a simple HTTP GET request to the root of the Identity Provider usually appending that specific path.
    *   *Example:* `GET https://accounts.google.com/.well-known/openid-configuration`
*   **The Response:** It returns a huge JSON object containing the URLs for all the *other* endpoints (Token, Authorization, UserInfo, JWKS) and configuration details (supported scopes, algorithms, etc.).

**Why is this important?**
It allows **Dynamic Client Registration**. You can point a generic OIDC library at just the base URL of a provider, and the library will auto-discover all the necessary endpoints to make authentication work.

---

### 2. The Core OIDC Endpoints
These are the endpoints used during a standard login flow (like Authorization Code Flow).

#### A. Authorization Endpoint
*   **Interaction:** Front-Channel (Browser Redirect).
*   **Purpose:** This is the **Login Page**.
*   **Process:**
    1.  Your app constructs a URL with parameters (like `client_id`, `redirect_uri`, `scope=openid profile`, `response_type=code`).
    2.  Your app redirects the user's browser to this URL.
    3.  The user sees the login screen, enters credentials, and consents to share data.
    4.  If successful, the Provider redirects the browser back to your app with an **Authorization Code**.

#### B. Token Endpoint
*   **Interaction:** Back-Channel (Server-to-Server API Call).
*   **Purpose:** Exchange the code for the actual keys (Tokens).
*   **Process:**
    1.  Your server takes the **Authorization Code** received from the step above.
    2.  It sends a POST request directly to the Provider's Token Endpoint.
    3.  This request usually includes the Client ID and Client Secret (password).
    4.  **The Response:** The Provider validates the code and returns a JSON object containing:
        *   **ID Token:** (Who the user is).
        *   **Access Token:** (Permission to access data).
        *   **Refresh Token:** (Optional, used to stay logged in).

#### C. UserInfo Endpoint
*   **Interaction:** Back-Channel.
*   **Purpose:** Retrieve extended profile data.
*   **Process:**
    1.  The ID Token received in the previous step is small and typically only contains basic info (Name, Email, Sub).
    2.  If you need more details (Address, Phone Number, etc.), your app sends the **Access Token** to the UserInfo Endpoint.
    3.  **The Response:** A JSON object with the user's full profile attributes allowed by the scopes you requested.

---

### 3. Security & Utility Endpoints

#### A. JWKS (JSON Web Key Set) Endpoint
*   **Purpose:** Cryptographic verification.
*   **The Problem:** When your app receives an **ID Token**, it is a signed JWT (JSON Web Token). How do you know the Identity Provider actually signed it and not a hacker?
*   **The Solution:**
    1.  The Provider signs the token with a **Private Key** (kept secret).
    2.  The Provider publishes the corresponding **Public Keys** at the **JWKS Endpoint**.
    3.  Your app (or library) downloads these Public Keys and uses them to verify the signature on the ID Token.

#### B. Revocation Endpoint
*   **Purpose:** Killing a token.
*   **Usage:** If a user logs out or a device is stolen, your app sends the Access Token or Refresh Token to this endpoint to invalidate it immediately.

#### C. Introspection Endpoint
*   **Purpose:** Validating a token (usually for APIs).
*   **Usage:** An API (Resource Server) receives an Access Token. Instead of trying to decode it locally, it sends the token to the Provider's Introspection Endpoint to ask: "Is this token currently active and valid?"

#### D. End Session Endpoint
*   **Purpose:** Global Logout.
*   **Usage:** If the user clicks "Logout" in your app, you might kill their local session cookies. However, they are still logged into the Identity Provider (e.g., Google). Redirecting the user to the End Session Endpoint logs them out of the Provider as well, ensuring a clean slate.

---

### Summary Flow Visualization

1.  **App** checks `/.well-known/openid-configuration` to find URLs.
2.  **App** redirects User → **Authorization Endpoint** (User logs in).
3.  **App** receives Code, sends it → **Token Endpoint** (Exchanges for Tokens).
4.  **App** validates ID Token using keys from → **JWKS Endpoint**.
5.  **App** sends Access Token → **UserInfo Endpoint** (Gets profile data).
