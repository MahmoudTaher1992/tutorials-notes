Here is a detailed explanation of **Part 15, Item 75: OpenID Connect Relationship**.

This section represents one of the most critical conceptual leaps in the OAuth ecosystem: understanding the difference between **Authorization** (OAuth 2.0) and **Authentication** (OpenID Connect), and how they work together.

---

# 075 - OpenID Connect (OIDC) Relationship

## 1. The Core Concept: Authorization vs. Authentication
To understand the relationship, you must first understand the deficit in OAuth 2.0 that OpenID Connect (OIDC) fixes.

*   **OAuth 2.0 is for Authorization:** It allows a user to grant an application limited access to resources (e.g., "Allow this app to read my Google Calendar"). It is analogous to giving a Valet key to a parking attendant. The key starts the car, but it doesn't tell the car *who* is driving it.
*   **OpenID Connect is for Authentication:** It is a layer built **on top** of OAuth 2.0 that allows the application to verify the identity of the user (e.g., "Log in with Google"). It is analogous to showing an ID card or Passport.

**The Relationship:**
OIDC is a "profile" of OAuth 2.0. It uses the exact same mechanics (redirects, tokens, endpoints) but creates a standard way to verify identity.

---

## 2. OIDC as an OAuth Extension

Before OIDC, developers used OAuth 2.0 for login (authentication) in "hacky" ways. Example:
1.  Do a standard OAuth flow to get an Access Token.
2.  Call a non-standard API endpoint (like `/me`, `/user/profile`, or `/whoami`) using that token.
3.  The API returns a JSON object with the user's name.

**The Problem:** Every provider (Facebook, Google, LinkedIn) implemented the `/me` endpoint differently. There was no standard format for the user data.

**The OIDC Solution:**
OIDC standardizes this process. If you add the **scope** `openid` to your OAuth authorization request, the Authorization Server switches behavior:
1.  **Standard Scope:** It recognizes `openid` means "The client wants to know *who* the user is."
2.  **Standard Endpoint:** It provides a `UserInfo` endpoint that returns standard claims (`sub`, `name`, `email`, `picture`).
3.  **New Token:** It issues a new type of token specifically for the client: the **ID Token**.

---

## 3. ID Tokens vs. Access Tokens

This is the most strictly tested area in security, as confusing these two leads to major vulnerabilities.

### The Access Token (OAuth 2.0)
*   **Purpose:** **Authorization**. It allows access to an API.
*   **Analogy:** A Hotel Key Card. It lets you into the room, but it doesn't have your name printed on it.
*   **Audience:** The **Resource Server** (API). The Client App should treat this as an opaque string; it is not meant to be read by the Client App.
*   **Format:** Can be a JWT, but often is just a random string (opaque/reference token).
*   **Usage:** Sent in the HTTP Header: `Authorization: Bearer <token>`.

### The ID Token (OpenID Connect)
*   **Purpose:** **Authentication**. It proves to the Client App that the user logged in successfully and provides profile data.
*   **Analogy:** A Passport or ID Card. It has your photo, name, and expiration date. It is useless for opening doors (APIs).
*   **Audience:** The **Client Application**. The intended recipient is the app itself, so it can say "Welcome, Alice!"
*   **Format:** **Always** a JSON Web Token (JWT).
*   **Usage:** Parsed by the Client App to extract user info. **Never** sent to an API.

### Comparison Table

| Feature | Access Token | ID Token |
| :--- | :--- | :--- |
| **Protocol** | OAuth 2.0 | OpenID Connect |
| **Concept** | Granting Access (Permission) | Verifying Identity (Profile) |
| **Intended Consumer** | The API (Resource Server) | The Client App (Mobile/Web App) |
| **Content** | Scopes, Permissions | User Profile, Issuer, Login Time |
| **Format** | Opaque or proprietary JWT | Standardized JWT |

---

## 4. When to Use OAuth vs. OIDC

In modern development, you rarely choose "one or the other." You usually use them together, but you must know which *parts* of the response to use for what task.

### Scenario A: "Log in with..." (OIDC)
**Goal:** You want to onboard a user without making them create a password.
1.  **Request:** Scope `openid profile email`.
2.  **Outcome:** You receive an **ID Token**.
3.  **Action:** decode the ID Token, get the `email` and `sub` (subject/user ID), and create a session for that user in your app.

### Scenario B: "Import my Contacts" (OAuth 2.0)
**Goal:** You want to ask the API for the user's contact list.
1.  **Request:** Scope `contacts.read`.
2.  **Outcome:** You receive an **Access Token**.
3.  **Action:** Call `GET /contacts` with the Access Token in the header.

### Scenario C: The Hybrid (Most Common)
**Goal:** Log the user in AND get permission to update their calendar.
1.  **Request:** Scope `openid profile calendar.write`.
2.  **Outcome:** You receive **both** an ID Token and an Access Token.
3.  **Action:**
    *   Use the **ID Token** to display "Logged in as Bob."
    *   Use the **Access Token** to POST a new meeting to the Calendar API.

---

## 5. Dangerous Pitfall: The "Audience" Bug

A common security vulnerability occurs when a developer uses an **Access Token** for authentication.

**The Attack:**
1.  Attacker creates a malicious client app.
2.  Victim logs into the malicious app using Google (generating a Google Access Token).
3.  The malicious app takes that Access Token and sends it to the **Honest App's** backend.
4.  The Honest App validates the token with Google used the introspect endpoint. Google says, "Yes, this is a valid token for User A."
5.  The Honest App logs User A in.

**The Catch:** The token was valid, **but it was issued to the Malicious App, not the Honest App.**

**The Fix (Use OIDC):**
If you use an **ID Token**, inside the JWT there is a claim called `aud` (Audience). It contains the Client ID of the app the token is intended for. The Honest App checks the ID Token: *"Is `aud` equal to MY Client ID?"* If not, it rejects the login, preventing the attack.

**Summary Rule:**
*   Use **ID Tokens** to log users in.
*   Use **Access Tokens** to call APIs.
