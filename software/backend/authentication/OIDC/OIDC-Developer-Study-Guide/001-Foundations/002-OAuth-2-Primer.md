Here is a detailed explanation of **001-Foundations / 002-OAuth-2-Primer**.

To understand OpenID Connect (OIDC), you must first understand the foundation it is built upon: **OAuth 2.0**.

### 1. OAuth 2.0 Overview
**Definition:** OAuth 2.0 is an industry-standard protocol for **Authorization** (delegated access).

**The Analogy (The Valet Key):**
Imagine you pull up to a hotel in your car. You want the valet to park your car, but you don't want to give them the ability to open your glovebox or trunk.
*   **The Master Key:** Your car key (which opens everything). In the digital world, this is your **Password**. You never want to give a third-party app your password.
*   **The Valet Key:** A special key that only starts the engine and locks the doors. In the digital world, this is an **Access Token**.

**The Goal:** OAuth 2.0 allows a user to grant a third-party application access to their resources (like their photos, contacts, or calendar) without sharing their password with that application.

---

### 2. OAuth Roles
In any OAuth transaction, there are four specific actors involved. Understanding who plays what role is critical.

1.  **Resource Owner (The User):**
    *   This is **you**. You own the data (the resource) and you are the one authorizing access to it.
2.  **Client (The Application):**
    *   This is the application trying to access your data on your behalf.
    *   *Example:* A photo printing website that wants to access your Google Photos to print them.
3.  **Authorization Server (The Security Guard):**
    *   This is the server that verifies your identity and issues tokens.
    *   *Example:* The Google Login page that asks, "Do you want to allow this printing app to see your photos?"
4.  **Resource Server (The API):**
    *   This is the server where your data actually lives. It accepts the token and validates it.
    *   *Example:* The Google Photos API.

---

### 3. OAuth 2.0 Grant Types Overview
A "Grant Type" (or Flow) is simply the method the Client uses to acquire an Access Token. Different scenarios require different flows.

*   **Authorization Code Flow:** The most common flow. The user is redirected to the Auth Server, logs in, and the Client gets a one-time code to exchange for a token. (Used for Web Apps and Mobile Apps).
*   **Client Credentials Flow:** Used when there is no user involved. The application talks directly to the API (Machine-to-Machine).
*   **Implicit Flow (Legacy):** Formerly used for Single Page Apps (SPAs), but now considered insecure and deprecated in favor of Authorization Code with PKCE.
*   **Resource Owner Password Credentials (Legacy):** The user types their username/password directly into the Client app. This is highly discouraged and generally considered insecure today.

---

### 4. Access Tokens & Refresh Tokens
When the Authorization Server agrees to give the Client access, it issues tokens:

**A. Access Token:**
*   **Purpose:** The key used to access the API (Resource Server).
*   **Format:** Usually a JWT (JSON Web Token) or an opaque string.
*   **Lifetime:** Short-lived (e.g., 1 hour) for security. If stolen, it only works for a short time.
*   **Usage:** It is sent in the HTTP header: `Authorization: Bearer <access_token>`.

**B. Refresh Token:**
*   **Purpose:** A special ticket used to get a *new* Access Token when the old one expires, without asking the user to log in again.
*   **Lifetime:** Long-lived (days, months, or years).
*   **Security:** This must be stored very securely. If the Authorization Server revokes this token, the Client loses all access.

---

### 5. Scopes in OAuth 2.0
Scopes act as the permissions list. They define **what** the Client is allowed to do.

*   Instead of giving the Client "Full Access" to your account, you give specific access.
*   **Examples:**
    *   `read:photos`: View photos only.
    *   `write:photos`: Upload new photos.
    *   `contacts.readonly`: View contacts but cannot edit them.

When the user enters the consent screen, they see: *"This application would like to view your photos."* This text maps directly to the **Scope** requested by the Client.

---

### 6. Limitations of OAuth 2.0 for Authentication (Crucial)
This is the most important concept to link OAuth to OIDC.

**The Problem:** OAuth 2.0 was designed for **Authorization** (Access), not **Authentication** (Identity).

Imagine you go to a hotel and get a key card (Access Token).
1.  **Access:** The card opens the door. The door lock doesn't care *who* is holding the card, only that the card works.
2.  **Identity:** The key card does not have your name, photo, or email address printed on it.

**If you try to use OAuth 2.0 for login (Authentication), you run into these issues:**
*   **No Standard Identity Format:** OAuth doesn't tell the Client *who* the user is. Developers had to invent non-standard hacks (like calling a `/me` endpoint) to get user details.
*   **No Standard Audience:** An Access Token is meant for the *API*, not the *Client* app. The Client app shouldn't actually read inside the Access Token.
*   **Security Risks:** Without a standardized way to verify identity, developers often made mistakes that allowed attackers to spoof logins.

**The Solution:** This is exactly why **OpenID Connect (OIDC)** was created. OIDC adds an identity layer on top of OAuth 2.0 to solve these limitations.
