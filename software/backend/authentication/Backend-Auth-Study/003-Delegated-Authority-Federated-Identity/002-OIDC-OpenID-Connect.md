Based on the study plan you provided, this section (**3.B** and **3.C** in your trees) is one of the most critical concepts in modern web security.

Here is a detailed explanation of **OIDC (OpenID Connect)**, broken down into its core concepts, purpose, and mechanics.

---

### 1. The High-Level Concept
**OpenID Connect (OIDC)** is an identity layer built **on top of** the OAuth 2.0 framework.

To understand OIDC, you first need to remember what OAuth 2.0 is:
*   **OAuth 2.0** is like giving a **Valet Key** to a parking attendant. The key allows them to drive your car (Authorization), but it doesn't tell the car *who* the driver is.
*   **OIDC** is like checking the driver's **ID Card**. It explicitly verifies *who* the person is (Authentication) and provides details about them (name, photo, email).

**The Golden Rule:**
> **OAuth 2.0 is for Authorization** (Can I access this resource?)
> **OIDC is for Authentication** (Who is this user?)

---

### 2. Why was OIDC created? (The History)
Before OIDC, developers tried to use OAuth 2.0 for login (authentication). They would get an OAuth Access Token and use it to call an API endpoint like `/me` to find out who the user was.

This was messy because every provider (Google, Facebook, Twitter) did it differently. There was no standard format for user data.
*   Google might return `{ "id": 123 }`.
*   Facebook might return `{ "user_id": 456 }`.

**OIDC standardized this.** It defined exactly how to ask for identity and exactly what format the identity data should be returned in.

---

### 3. How OIDC Works (The Mechanics)
Since OIDC sits on top of OAuth 2.0, the flow looks almost identical to a standard OAuth flow, with **three specific additions**:

#### A. The Scope (`openid`)
When the Client (your app) redirects the user to the Auth Server (e.g., Google), it includes a specific permission scope: `scope=openid`.
This tells the Auth Server: "I don't just want access to data; I want to know who this user is."

#### B. The ID Token (The Core Component)
This is the most important part of OIDC.
When the Auth Server responds, it sends back an **Access Token** (for APIs) *and* an **ID Token**.

The **ID Token** is always a **JWT (JSON Web Token)**. It is intended for the **Client Application** (your frontend or backend web app) to read. It contains standardized "Claims" (key-value pairs) about the user.

**Common ID Token Claims:**
*   `sub` (Subject): The unique ID of the user (e.g., `google|12345`).
*   `iss` (Issuer): Who issued the token (e.g., `https://accounts.google.com`).
*   `aud` (Audience): Who is this token for? (Your application's Client ID).
*   `exp` (Expiration): When the token expires.
*   `iat` (Issued At): When the token was created.
*   `email` / `name` / `picture`: Profile information (if requested).

#### C. The UserInfo Endpoint
OIDC defines a standard API endpoint usually called `/userinfo`. If the ID Token doesn't have all the details you need, you can use the Access Token to query this endpoint and get the full standardized user profile.

---

### 4. Step-by-Step Example: "Log in with Google"
Here is how OIDC works in a real-world scenario (Authorization Code Flow):

1.  **User Clicks Login:** User clicks "Sign in with Google" on your website.
2.  **Redirect:** Your app redirects the browser to Google with `scope=openid profile email`.
3.  **Authentication:** The user logs into Google (if not already logged in) and consents to share their profile.
4.  **Code Exchange:** Google redirects back to your site with a temporary code.
5.  **Token Request:** Your backend sends that code to Google directly.
6.  **The OIDC Response:** Google responds with **two tokens**:
    *   **Access Token:** Used to fetch the user's Google Calendar (if you asked for that).
    *   **ID Token:** A JWT containing the user's name, email, and photo URL.
7.  **Session Creation:** Your app verifies the signature of the ID Token (ensuring it really came from Google), reads the user's email, creates a session for them in your app, and logs them in.

---

### 5. Summary: OAuth 2.0 vs. OIDC

| Feature | OAuth 2.0 | OpenID Connect (OIDC) |
| :--- | :--- | :--- |
| **Purpose** | Authorization (Access) | Authentication (Identity) |
| **What you get** | Access Token | ID Token (+ Access Token) |
| **Token Format** | Arbitrary string (usually) | Always a JWT |
| **Intended Audience** | The Resource Server (The API) | The Client (The App) |
| **Question Answered** | "What is this app allowed to do?" | "Who is this user?" |

### Key Takeaway for your Study Plan
When you are implementing **Federated Identity** (allowing users to log in with external providers), you are almost certainly using **OIDC**. It provides a secure, standardized way to verify identity without forcing you to manage passwords in your own database.
