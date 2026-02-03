Based on Part 2, Item 5 of your Table of Contents, here is a detailed explanation of **Tokens in OIDC (OpenID Connect)**.

In OIDC, three different types of tokens work together to handle identity (who you are) and access (what you can do). Understanding the distinction between them is the most critical part of OIDC development.

---

# 002: Tokens in OIDC

OpenID Connect introduces a specific artifact—the **ID Token**—to the existing OAuth 2.0 framework. While OAuth 2.0 deals with Access and Refresh tokens, OIDC utilizes all three to provide a complete authentication and authorization system.

## 1. The ID Token (The Core OIDC Addition)

 The ID Token is the specific feature that turns OAuth 2.0 (an authorization framework) into OIDC (an authentication protocol).

*   **Analogy:** Think of the ID Token as a **Passport**. It contains details about the holder (User) and is issued by a government (OpenID Provider). Its primary purpose is to verify your identity to the person looking at it.
*   **Format:** It is **always** a JSON Web Token (JWT).
*   **Audience:** The **Client Application** (e.g., your React app or Mobile app).
*   **Purpose:**
    *   It tells the client application *who* the user is (name, email, unique ID).
    *   It tells the client *when* and *how* the user authenticated.
    *   **Important:** The ID Token is strictly for the client application to read. It should generally **not** be sent to a backend API to request data.

**Example Structure (Decoded JWT Payload):**
```json
{
  "iss": "https://accounts.google.com",   // Implementation: Issuer
  "sub": "10987654321",                   // Subject (User ID)
  "aud": "client-id-123",                 // Audience (Your App)
  "iat": 1516239022,                      // Issued At
  "exp": 1516242622,                      // Expiration time
  "name": "John Doe",                     // User Profile Data
  "email": "john@example.com"
}
```

---

## 2. The Access Token (Borrowed from OAuth 2.0)

If the ID Token is the Passport, the Access Token is the **Ticket**.

*   **Analogy:** A **Hotel Key Card**. The card reader on the hotel room door doesn't care who you are or what your name is. It only cares that the card has the correct permission code to unlock the door.
*   **Format:** It can be a JWT, but it can also be an "Opaque Token" (a random string of characters). The OIDC spec does not force a format here.
*   **Audience:** The **Resource Server** (The Backend API).
*   **Purpose:**
    *   It acts as a credential to access protected resources (e.g., `GET /api/user/orders`).
    *   The Client Application holds this token but usually acts as a simple carrier; it attaches the token to API requests (usually in the `Authorization: Bearer` header).
    *   It contains "Scopes" (permissions) like `read:orders` or `write:profile`.

---

## 3. The Refresh Token

The Refresh Token is a mechanism to improve user experience and security simultaneously.

*   **Analogy:** A **Subscription Renewal Voucher**. You can’t use it to enter the venue effectively, but you can trade it in at the counter to get a new Ticket (Access Token) when the old one expires.
*   **Format:** Usually an opaque string (random characters).
*   **Conversation:** It is comprised of a long-lived credential shared between the Client and the OpenID Provider.
*   **Purpose:**
    *   Access Tokens are short-lived for security (e.g., 1 hour). If an attacker steals one, they only have access for 1 hour.
    *   Instead of asking the user to type their username and password every hour, the Client sends the **Refresh Token** to the provider.
    *   The Provider validates it and issues a fresh Access Token (and sometimes a fresh ID Token) without user interaction.

---

## Summary Comparison Table

| Feature | ID Token | Access Token | Refresh Token |
| :--- | :--- | :--- | :--- |
| **Primary Goal** | Authentication (Identity) | Authorization (Access) | Session Management |
| **Analogy** | Passport / ID Card | Key Card / Ticket | Renewal Voucher |
| **Format** | **JWT** (Mandatory) | JWT or Opaque | Usually Opaque |
| **Consumer** | The **Client App** (Frontend) | The **API** (Backend) | The **Identity Provider** |
| **Contains** | User Profile (Name, Email) | Scopes/Permissions | Reference to session |

---

## 4. Token Lifetimes & Expiration

Security in OIDC relies heavily on managing how long these tokens live.

### Short-Lived Access Tokens
*   Access Tokens usually expire quickly (e.g., **5 minutes to 1 hour**).
*   **Why?** If a malicious script steals a user's access token, they can only damage the system for a very short window before the key stops working.

### Long-Lived Refresh Tokens
*   Refresh Tokens stay valid for a long time (e.g., **days, months, or years**).
*   **Why?** This allows the user to stay "logged in" on their phone or browser for weeks without re-entering credentials.
*   **Safe-guards:** Because Refresh tokens are powerful, they are often subject to **Rotation** (every time you use it, you get a new one) or **Revocation** (if a user clicks "Logout" or changes their password, the Refresh token is killed immediately).

### ID Token Expiration
*   ID Tokens usually have an expiration (`exp`) matching the Access Token or are treated as a "one-time" verification during the initial login. Once the app knows who the user is, the ID Token's job is mostly done until the next refresh.
