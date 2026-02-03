Based on the Table of Contents provided (specifically **Section 6: Client Registration**), here is a detailed explanation of what this component entails.

---

# 006 - Client Registration

Before an application (the **Client**) can ask an Authorization Server (like Google, Auth0, or Okta) for a token, it must be "introduced" to the server. This process is called **Client Registration**.

Think of this like getting a Drivers License. You cannot just drive a car; you must first register yourself with the DMV to get a license number. Similarly, an app must register to get a **Client ID**.

Here is the breakdown of the specific topics listed in your ToC.

---

### 1. Static Registration (Manual)
This is the most common method for most developers building standard web or mobile applications.

*   **How it works:** A developer logs into the administration console of the Authorization Server (e.g., the Google Cloud Console, Stripe Dashboard, or Auth0 Portal).
*   **The Process:** The developer manually fills out a form providing the app's name, logo, and allowed callback URLs.
*   **The Result:** The server generates the credentials (Client ID and Client Secret) which the developer then hardcodes or configures into their application’s environment variables.
*   **Best For:** First-party applications or when the number of clients is small and manageable.

### 2. Dynamic Client Registration (RFC 7591)
In complex ecosystems (like Open Banking or large SaaS federations), manually registering thousands of clients is impossible. RFC 7591 defines a protocol for applications to register themselves programmatically via an API.

*   **How it works:** The Client application sends an HTTP `POST` request to a registration endpoint provided by the Authorization Server.
*   **The Payload:** The request contains a JSON object describing the client (name, redirect URIs, desired grant types).
*   **The Response:** The Authorization Server automatically creates the client record and responds with a JSON object containing the new `client_id`, and optionally a `client_secret` and `registration_access_token`.
*   **Example Request:**
    ```http
    POST /connect/register HTTP/1.1
    Content-Type: application/json

    {
      "client_name": "My Dynamic App",
      "redirect_uris": ["https://app.example.com/callback"],
      "grant_types": ["authorization_code", "refresh_token"],
      "token_endpoint_auth_method": "client_secret_basic"
    }
    ```

### 3. Dynamic Client Management (RFC 7592)
If a client registers dynamically (using RFC 7591), how does it update its details (like changing its logo or adding a new redirect URL) later? RFC 7592 solves this.

*   **The Mechanism:** When the client is first created via RFC 7591, the server returns a `registration_client_uri` (a specific URL for that client) and a `registration_access_token` (a special permission token).
*   **Operations:**
    *   **Read:** `GET` request to the URI to see current settings.
    *   **Update:** `PUT` request with new JSON data to change settings.
    *   **Delete:** `DELETE` request to remove the client entirely.

### 4. Registration Metadata
When registering a client (statically or dynamically), specific metadata describes how the client intends to behave. The Authorization Server uses this to enforce security policies.

Key metadata fields include:
*   **`client_name`**: The human-readable name shown to users on the content screen (e.g., "Allow **CandyCrush** to access your info?").
*   **`grant_types`**: Which flows is this client allowed to use? (e.g., `authorization_code`, `client_credentials`).
*   **`response_types`**: What can the client ask for? (e.g., `code`, `token`, `id_token`).
*   **`token_endpoint_auth_method`**: How will the client authenticate? (e.g., `client_secret_basic`, `private_key_jwt`, or `none` for public clients).
*   **`logo_uri`** / **`policy_uri`**: Links to branding and legal terms.

### 5. Client ID & Client Secret
These are the credentials resulting from registration.

*   **Client ID:**
    *   **Analogy:** Username.
    *   **Visibility:** Public. It is embedded in HTML source code or mobile binary files. It allows the Authorization Server to look up the correct configuration (which login page to show, which redirect URIs are valid).
    *   **Uniqueness:** Unique within the Authorization Server.

*   **Client Secret:**
    *   **Analogy:** Password.
    *   **Visibility:** **Strictly Private.** It is known only to the Authorization Server and the Client Application.
    *   **Usage:** Used to authenticate the client when it exchanges an Authorization Code for an Access Token.
    *   **Constraint:** "Public Clients" (Single Page Apps, Mobile Apps) **cannot** store secrets securely, so they should generally register without a secret and use PKCE instead.

### 6. Redirect URI Registration
This is arguably the most critical security aspect of registration.

*   **Definition:** The **Redirect URI** (or Callback URL) is the location where the Authorization Server sends the user (and the sensitive codes/tokens) after they log in.
*   **The Security Rule:** during registration, the developer MUST tell the server exactly which URLs are allowed.
*   **Validation:** When a standard OAuth flow starts, the client sends a `redirect_uri` parameter. The Authorization Server checks this against the pre-registered list.
    *   If they match: Expectation proceeds.
    *   If they do **not** match: The server blocks the request.
*   **Why?** This prevents **Open Redirect Attacks**. Without pre-registration, an attacker could trick the flow into sending the user's access token to `https://evil-hacker.com/callback`.

---

### Summary Table

| Component | Description |
| :--- | :--- |
| **Static Registration** | Manual setup via a developer portal. |
| **Dynamic Registration** | Programmatic setup via API (RFC 7591). |
| **Registration Metadata** | Configuration settings (Grants, Auth methods, Name). |
| **Client ID** | The public identifier for the app. |
| **Client Secret** | The private password for Confidental Clients. |
| **Redirect URI** | The whitelist of allowed URLs for returning tokens. |
