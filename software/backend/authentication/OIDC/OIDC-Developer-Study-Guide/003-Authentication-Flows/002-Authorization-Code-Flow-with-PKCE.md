Based on the Table of Contents you provided, here is the detailed explanation for **Section 9: Authorization Code Flow with PKCE**.

---

# 003-Authentication-Flows / 002-Authorization-Code-Flow-with-PKCE.md

**PKCE** (pronounced "Pixy") stands for **Proof Key for Code Exchange**. It is an extension to the standard Authorization Code flow designed to secure specific types of applications. While it was originally designed for mobile apps, it is now the recommended standard for **all** applications (SPAs, Mobile, and even server-side apps).

Here is a detailed breakdown of the concepts within this section.

---

## 9.1 The Problem with Public Clients

To understand PKCE, you must understand the security gap it fills.

In the standard OAuth 2.0/OIDC world, we have two types of clients:
1.  **Confidential Clients:** Server-side apps (e.g., Python, Node.js backends) that can keep a `client_secret` hidden from users.
2.  **Public Clients:** Single Page Apps (React, Angular) or Mobile Apps (iOS, Android).

**The Problem:**
Public clients run on the user's device. You **cannot** store a `client_secret` inside a JavaScript app or a mobile binary. If you do, hackers can decompile the app, find the secret, and impersonate your application.

**The Vulnerability (Authorization Code Interception):**
If a Public Client uses the standard flow *without* a secret:
1.  The app requests a login.
2.  The user logs in.
3.   The Identity Provider sends a redirect containing an **Authorization Code** back to the app via a URL (e.g., `myapp://callback?code=123`).
4.  **Malicious Act:** If a hacker has a malicious app installed on the same phone, they can potentially "listen" for that specific custom URL scheme. They can steal the `code`.
5.  Without PKCE, the hacker can take that stolen `code` to the Token Endpoint. Since there is no Client Secret to verify the requester, the Identity Provider issues the Access Token to the hacker.

---

## 9.2 PKCE Explained (`code_verifier` & `code_challenge`)

PKCE solves the "missing secret" problem by creating a **dynamic, throw-away secret** on the fly for every single login attempt.

Instead of a static password, the app generates two strings:

### 1. The Code Verifier (`code_verifier`)
*   **What is it?** A high-entropy cryptographic random string (between 43 and 128 characters).
*   **Role:** This acts as the "password" for this specific login session.
*   **Storage:** It is created by the Client App and stored in memory or local storage. **It is never sent to the server during the initial request.**

### 2. The Code Challenge (`code_challenge`)
*   **What is it?** A transformation (hash) of the `code_verifier`.
*   **Role:** This represents the "promise" that the client creates. It is sent to the Authorization Server to say, "I have the password that matches this hash."
*   **Formula:** `code_challenge = BASE64URL-ENCODE(SHA256(ASCII(code_verifier)))`

---

## 9.3 Challenge Methods

When the client sends the challenge to the server, it must also tell the server *how* it calculated the challenge so the server can verify it later. This is the `code_challenge_method`.

There are two methods:

1.  **`S256` (Recommended):**
    *   The Client hashes the verifier using SHA-256.
    *   This is the secure method. Even if a hacker intercepts the `code_challenge`, they cannot reverse-engineer the `code_verifier` because SHA-256 is a one-way function.

2.  **`plain` (Not Recommended):**
    *   The Client sends the verifier as-is (`challenge` = `verifier`).
    *   This exists only for backwards compatibility with very old devices that cannot perform SHA-256 hashing. It does not provide security against interception attacks.

---

## 9.4 Implementation Steps (The Flow)

Here represents the lifecycle of a PKCE flow:

### Step 1: The Client Creates the Keys
The user clicks "Login". The App (Client) generates a random `code_verifier` (e.g., "xyz...123") and hashes it to create the `code_challenge` (e.g., "abc...789").

### Step 2: Authorization Request
The Client redirects the user to the OpenID Provider (OP) with the challenge:
```http
GET /authorize?
  response_type=code
  &client_id=my-app
  &redirect_uri=https://my-app.com/callback
  &scope=openid profile
  &code_challenge=abc...789       <-- THE HASHED KEY
  &code_challenge_method=S256     <-- THE METHOD
```

### Step 3: Server Interaction
*   The User logs in.
*   The OP stores the `code_challenge` and `method` temporarily, associated with this specific transaction.
*   The OP generates an **Authorization Code** and redirects back to the client.

### Step 4: Token Exchange (The "Proof")
The Client receives the Code. It now requests the tokens. **Crucially, it now sends the original clear-text `code_verifier`.**

```http
POST /token
  grant_type=authorization_code
  &code=auth_code_from_step_3
  &redirect_uri=https://my-app.com/callback
  &client_id=my-app
  &code_verifier=xyz...123        <-- THE ORIGINAL KEY
```

### Step 5: Server Validation
1.  The OP receives the request.
2.  It looks up the `code_challenge` it stored in Step 3 ("abc...789").
3.  It takes the incoming `code_verifier` ("xyz...123") and applies the `S256` hash to it.
4.  **The Check:** Does `SHA256("xyz...123")` equal "abc...789"?
    *   **If Match:** The OP knows the entity sending the code is the *exact same entity* that started the flow. Tokens are issued.
    *   **If Mismatch:** Access denied.

---

## 9.5 Why PKCE is Now Recommended for All Clients

Originally, standard OAuth 2.0 (without PKCE) was used for servers, and Implicit Flow was used for browsers. PKCE was considered a mobile-only solution.

**Current Best Practice:** Use Authorization Code Flow with PKCE for **everything** (SPAs, Mobile, and Web Servers).

1.  **Replaces Implicit Flow:** The Implicit Flow returned tokens directly in the URL (unsafe). PKCE allows SPAs to use the safer Auth Code flow without a client secret.
2.  **Prevents Code Injection:** Even for backend servers (Confidential Clients) that *do* have a `client_secret`, PKCE adds security. It ensures that the authorization code cannot be injected into the application by an attacker intercepting the redirect.
3.  **One Token Standard:** It unifies the implementation logic across mobile, web, and backend applications, reducing the maintenance burden for developers.
