Based on the Table of Contents you provided, here is a detailed explanation of **Section 4: OIDC Roles & Components**.

This section describes the "actors" involved in an OpenID Connect (OIDC) authentication flow. Since OIDC is built on top of OAuth 2.0, these roles map directly to OAuth roles but have specific OIDC names to reflect that the goal is **Identity** (who you are), not just **Authorization** (what you are allowed to do).

---

# 4. OIDC Roles & Components

To understand how OIDC works, you must understand the relationship between the three main entities: the **User**, the **Application** they are trying to log into, and the **Server** that holds their user account.

Here is the breakdown of each component:

### 1. End-User (EU) / Resource Owner
*   **Who is this?** The human being sitting at the computer or holding the mobile phone.
*   **Role:** The person who wants to access a service. They "own" their identity data (username, email, profile picture).
*   **Action:** They interact with the application and, when redirected to the login screen, they enter their credentials (username/password/biometrics).
*   **OAuth 2.0 Equivalent:** *Resource Owner*.

### 2. Relying Party (RP) / Client
*   **Who is this?** The application the End-User is trying to use.
    *   *Examples:* Spotify, Trello, your company’s web portal, or a mobile app.
*   **Why is it called "Relying Party"?** Because this application does **not** want to handle your password or security questions. Instead, it **relies** on a trusted third party (the OpenID Provider) to verify your identity.
*   **Role:**
    1.  It initiates the login request.
    2.  It receives the tokens (ID Token and Access Token).
    3.  It reads the ID Token to greet the user (e.g., "Welcome back, Alice!").
*   **OAuth 2.0 Equivalent:** *Client*.

### 3. OpenID Provider (OP) / Identity Provider (IdP)
*   **Who is this?** The trusted server that holds the user database and credentials.
    *   *Examples:* Google (when you "Log in with Google"), Auth0, Okta, Microsoft Entra ID (Azure AD).
*   **Role:**
    1.  **Authentication:** It checks the user's username and password (and MFA if enabled).
    2.  **Consent:** It asks the user, "Do you want to share your email with this Application?" (if applicable).
    3.  **Issuance:** If the login is successful, it mints (creates) the **ID Token** and sends it back to the Relying Party.
*   **OAuth 2.0 Equivalent:** *Authorization Server*.

### 4. UserInfo Endpoint
*   **What is this?** This is a protected API endpoint (URL) hosted by the OpenID Provider (OP).
*   **Purpose:** The ID Token received by the Relying Party usually contains basic information (like your ID number and maybe a name). If the application needs more details (like your `phone_number`, `address`, or `profile_picture`), it asks the UserInfo Endpoint.
*   **How it works:**
    1.  The Relying Party authenticates the user and gets an **Access Token**.
    2.  The Relying Party sends the Access Token to the `UserInfo Endpoint`.
    3.  The Endpoint validates the token and returns a JSON object containing the user's details (claims).

---

## 💡 Practical Example: "Log in with Google" on Spotify

To visualize how these roles interact, let's look at a real-world scenario where you use your Google account to log into Spotify.

1.  **End-User:** **You**.
2.  **Relying Party (RP):** **Spotify**. You are on the Spotify website, but Spotify doesn't know who you are yet. You click "Log in with Google."
3.  **OpenID Provider (OP):** **Google**. Spotify redirects you to `accounts.google.com`.
    *   You enter your specific Google password on the Google screen (Spotify never sees this password).
    *   Google verifies you are who you say you are.
4.  **The Handshake:**
    *   Google sends Spotify an **ID Token** (a badge saying "This is User 123 verified by Google").
    *   Google sends Spotify an **Access Token** (key).
5.  **UserInfo Endpoint:**
    *   Spotify asks Google's UserInfo Endpoint (using the Access Token): "Can I have User 123's email and profile picture?"
    *   Google replies with the data.
    *   Spotify displays your Google profile picture in the top corner.

## Summary Comparison Table

| Term | OIDC Name | OAuth 2.0 Name | Description |
| :--- | :--- | :--- | :--- |
| **Who** | End-User | Resource Owner | The human. |
| **Where** | Relying Party (RP) | Client | The app you are logging into. |
| **Authority** | OpenID Provider (OP) | Authorization Server | The system checking your password. |
| **Data Source** | UserInfo Endpoint | Resource Server | The API returning user profile data. |
