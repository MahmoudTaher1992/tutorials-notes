Based on the Table of Contents you provided, here is a detailed explanation of **Part 1: Foundations**. This section sets the stage by defining what OAuth is, why we need it, and the language we use to describe it.

---

# Part 1: Foundations - Detailed Explanation

## 1. Introduction to Authorization

This section addresses the fundamental concepts before diving into technical specifications.

### **Authentication vs. Authorization (AuthN vs. AuthZ)**
This is the most critical distinction in identity security, often confused because they happen near each other.
*   **Authentication (Who are you?):** Verifying the identity of a user.
    *   *Example:* Logging in with a username and password. Checking a passport.
    *   *Protocol:* OpenID Connect (OIDC) handles this.
*   **Authorization (What can you do?):** Granting permission to access resources.
    *   *Example:* Once logged in, are you allowed to delete this file? The Valet key that starts the car but doesn't open the trunk.
    *   *Protocol:* **OAuth 2.0** handles this.

### **The Problem OAuth Solves**
Before OAuth, if you wanted "App A" (e.g., a budgeting app) to access your data on "App B" (e.g., your Bank), you had to give App A your **username and password** for the Bank. This is the **Password Anti-Pattern**.
*   **Risks:** App A stores your password creates a massive security risk. You cannot revoke App A's access without changing your bank password. App A has full access to your bank account, not just transaction logic.
*   **Solution:** OAuth allows the Bank to issue a strictly limited "key" (Access Token) to the Budgeting App without ever sharing your password.

### **History of OAuth**
*   **OAuth 1.0 (2010):** Secure but very difficult to implement. It required complex cryptographic signing for every single API request.
*   **OAuth 2.0 (2012):** The current standard. It shifted the complexity from the client developer to the Authorization Server and relies on HTTPS (TLS) for security rather than complex signing.
*   **OAuth 2.1 (Draft):** An upcoming cleanup of OAuth 2.0. It doesn't add new features but removes insecure "bad practices" that were allowed in 2.0 (like the Implicit Grant) and mandates security best practices (like PKCE).

### **Real-World Analogies**
*   **The Hotel Key Card:** When you check in (Authentication), the front desk (Authorization Server) gives you a key card (Access Token).
    *   The card lets you into your room and the gym (Scope).
    *   The card has an expiration date (Token Lifetime).
    *   The card does not verify *who* you are to the door reader; it simply verifies you hold the right permission.
*   **Valet Key:** You give a valet a special key. It starts the engine (Scope: Drive), but it can't open the glovebox or trunk (Scope: Storage). You delegated limited access without giving them your master key.

---

## 2. OAuth 2.0 Overview

### **What is OAuth 2.0?**
It is an open standard authorization **framework** (not a single protocol) that enables applications to obtain limited access to user accounts on an HTTP service. It works by delegating user authentication to the service that hosts the user account and authorizing third-party applications to access the user account.

### **OAuth 2.0 vs. API Keys vs. Basic Auth**
*   **Basic Auth:** Sending `username:password` in the header.
    *   *Bad:* Credentials are sent with every request. If compromised, the attacker has the user's full identity. Hard to revoke.
*   **API Keys:** A long string sent in headers.
    *   *Limitation:* Usually identifies the **Application**, not the **User**. It gives the app "master access" regardless of who is using it.
*   **OAuth 2.0:** Uses **Tokens**.
    *   *Good:* Tokens are temporary. They can be scoped (limited permissions). If stolen, they expire. They identify both the App *and* the User context.

### **Specification Documents**
If you want to read the source truth:
*   **RFC 6749 (The Core Framework):** Defines the flows, actors, and how to get tokens.
*   **RFC 6750 (Bearer Token Usage):** Defines how to actually *use* the token in an API call (e.g., `Authorization: Bearer <token>`).

---

## 3. OAuth 2.0 Terminology

To understand OAuth, you must know the four main actors and the artifacts they exchange.

### **The Actors (Roles)**

1.  **Resource Owner (RO):**
    *   **The User.** The entity capable of granting access to a protected resource.
    *   *Example:* You, sitting at your computer.

2.  **Client:**
    *   **The Application.** The software making protected resource requests on behalf of the Resource Owner. 
    *   *Note:* In OAuth, "Client" does not mean "User." It means the Study App, the Mobile App, or the Website.
    *   *Example:* A photo printing website that wants to access your Google Photos.

3.  **Authorization Server (AS):**
    *   **The Guard.** The server that verifies the user's identity and issues access tokens to the Client.
    *   *Example:* Auth0, Microsoft Entra ID (Azure AD), AWS Cognito, Google Accounts.

4.  **Resource Server (RS):**
    *   **The API.** The server hosting the protected resources (data). It accepts and validates Access Tokens.
    *   *Example:* The Google Photos API, UserInfo Endpoint.

### **Concept Definitions**

*   **Protected Resource:**
    *   The data the Client wants to access (e.g., the user's profile picture, their email list).

*   **Redirect URI (Callback URL):**
    *   A pre-registered URL on the Client app. After the user logs in at the Authorization Server, the AS redirects the browser back to this URL with the temporary code or token.
    *   *Security Critical:* If not validated strictly, attackers can steal tokens.

*   **Scope:**
    *   A parameter that limits the access granted. It defines the "size" of the permission.
    *   *Example:* `openid`, `profile`, `email`, `read:orders`, `write:database`.

*   **Grant (Grant Type):**
    *   The method (flow) the Client uses to get the Access Token.
    *   *Different scenarios need different grants:* A mobile app uses a different flow than a server-side machine-to-machine script.

*   **Token:**
    *   **Access Token:** The key used to access the API. Usually short-lived (e.g., 1 hour).
    *   **Refresh Token:** A long-lived credential used to get a *new* Access Token without prompting the user to log in again.
