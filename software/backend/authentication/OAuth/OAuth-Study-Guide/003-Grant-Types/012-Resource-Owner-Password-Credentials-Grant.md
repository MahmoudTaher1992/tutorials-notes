Based on item **#12** in your Table of Contents, here is a detailed explanation of the **Resource Owner Password Credentials Grant** (commonly referred to as the "Password Grant").

---

# 12. Resource Owner Password Credentials Grant (ROPC)

The **Resource Owner Password Credentials (ROPC)** grant is an OAuth 2.0 flow where the user provides their username and password directly to the Client application, which then sends them to the Authorization Server to get a token.

While it is part of the original RFC 6749 standard, it is currently **deprecated** and is being removed entirely in the upcoming OAuth 2.1 specification due to significant security flaws.

### 1. How the Flow Works
Unlike the "Authorization Code" flow, there is no redirection to a browser. Everything happens via a direct HTTP request from the Client to the Authorization Server.

**The Steps:**
1.  **User Input:** The Resource Owner (User) types their username and password into the Client Application's login form.
2.  **Token Request:** The Client sends a `POST` request to the Authorization Server's **Token Endpoint**, including the username, password, and the Client's own credentials (Client ID/Secret).
3.  **Validation:** The Authorization Server checks if the username/password are correct and if the Client is authorized.
4.  **Token Response:** If valid, the Authorization Server responds with an Access Token (and optionally a Refresh Token).

### 2. The Protocol (HTTP Request Example)

This is what the actual request looks like going from the Client to the Auth Server:

```http
POST /token HTTP/1.1
Host: server.example.com
Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW   <-- Encoded ClientID:ClientSecret
Content-Type: application/x-www-form-urlencoded

grant_type=password
&username=johndoe
&password=A3ddj3w
&scope=read_profile
```

### 3. Historical Use Cases (Why did this exist?)
When OAuth 2.0 was created (around 2012), this grant type was included as a "migration bridge" for two specific scenarios:

1.  **Migrating from HTTP Basic Auth:** Developers used to sending passwords with every API request needed a way to swap that methodology for tokens without rewriting their entire UI flow.
2.  **Native Mobile Apps (Legacy):** Before modern browser switching was seamless on mobile, developers wanted the login screen to be native (part of their app UI) rather than a web view, to provide a "smoother" user experience.
3.  **Highly Trusted Apps:** It was intended *only* for applications built by the same company that owns the API (First-Party Clients).

### 4. Security Risks (Why it is Deprecated)
This grant type undermines the core value proposition of OAuth (which is: "don't give your password to the app").

*   **Password Exposure:** The Client application sees, handles, and theoretically could store the user's plain-text password. If the app is malicious or compromised/hacked, the user's credentials are stolen.
*   **No Multi-Factor Authentication (MFA):** Since the flow is a single HTTP request (`POST`), there is no web interface to prompt the user for a 2FA code or a biometric scan. This makes it incompatible with modern security standards.
*   **Phishing Risk:** It teaches users that it's okay to type their Google/Facebook/Corporate password into *any* application that asks for it, rather than only on the official login page.
*   **Privilege Escalation:** Often, this grant issues tokens with full access to the user's account, whereas other flows allow the user to consent to specific scopes (e.g., "only read my calendar").

### 5. Why It Is Removed in OAuth 2.1
The OAuth working group looks at current security "Best Current Practices" (BCP). Because the risks (credential theft, lack of MFA) outweigh the benefits (easier UI implementation), **OAuth 2.1 completely removes this grant type.**

It is no longer considered secure for *any* client type, even first-party apps.

### 6. The Better Alternative
If you are currently using the Password Grant, the migration path is to switch to the **Authorization Code Flow with PKCE**.

**How the alternative works (Native App example):**
1.  Instead of a native username/password field, the app opens a system browser (e.g., ASWebAuthenticationSession on iOS or Custom Tabs on Android).
2.  The User logs in on the Authorization Server's website (which can support MFA, Passwordless, key-passes, etc.).
3.  The browser redirects back to the app with a code.
4.  The app exchanges the code for a token.

**Result:** The app gets the token it needs, but it **never acts as an intermediary for the user's password.**
