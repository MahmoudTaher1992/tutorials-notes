Based on **Part 1, Section 3** of your Table of Contents, here is a detailed explanation of the core **OAuth 2.0 Terminology**.

Understanding these terms is critical because the RFC specifications and all documentation (Auth0, Okta, etc.) use them strictly. If you confuse the "Client" with the "Resource Owner," the security models will not make sense.

---

# 3. OAuth 2.0 Terminology

To make this easier to understand, we will use a **Hotel Key Card Analogy** alongside the technical definitions.

### 1. Resource Owner (RO)
*   **The Analogy:** The **Hotel Guest**. This person paid for the room and has the right into it.
*   **Technical Definition:** An entity capable of granting access to a protected resource. When the resource owner is a person, they are referred to as an **End-User**.
*   **In Practice:** This is the **User** logging into your application. They own their data (photos, email components, profile), and they are the only ones who can say "Yes, this app is allowed to see my data."

### 2. Client
*   **The Analogy:** A **Butler Service** hired by the Guest. The Butler needs to get into the room to deliver food, but they can't get in unless the Guest gives them permission (or a key).
*   **Technical Definition:** An application making protected resource requests on behalf of the Resource Owner and with its authorization.
*   **In Practice:** This is **Your Application**.
    *   It could be a Mobile App, a Website, a Single Page App (SPA), or a CLI tool.
    *   *Important Note:* Calling it a "Client" is confusing for web developers who think "Client = Browser." In OAuth, a server-side web app (Node.js/PHP backend) is still called the "Client" because it is a client of the Authorization Server.

### 3. Authorization Server (AS)
*   **The Analogy:** The **Hotel Front Desk**. The Butler cannot just walk into the room. The Front Desk must first ID the Guest, verify the booking, and then issue a Key Card to the Butler.
*   **Technical Definition:** The server issuing access tokens to the client after successfully authenticating the resource owner and obtaining authorization.
*   **In Practice:** The Identity Provider.
    *   Examples: **Auth0, Okta, Amazon Cognito, Keycloak**, or Google (when you use "Log in with Google").
    *   It handles the login screen (username/password) so the Client application doesn't have to.

### 4. Resource Server (RS)
*   **The Analogy:** The **Electronic Door Lock** on the hotel room. It doesn't care who the person is (Guest or Butler); it only cares if the Key Card is valid and active.
*   **Technical Definition:** The server hosting the protected resources, capable of accepting and responding to protected resource requests using access tokens.
*   **In Practice:** Your **API** (e.g., a Node.js Express API, Python Flask API).
    *   It holds the database connections.
    *   It checks the Access Token in the Authorization header to see if access should be granted.

### 5. Protected Resource
*   **The Analogy:** The **Inside of the Room** (or specific items in the room, like the Minibar).
*   **Technical Definition:** The data or service that the Client wants to access, which belongs to the Resource Owner.
*   **In Practice:** A specific **API Endpoint**.
    *   Example: `GET /api/v1/user/profile` or `POST /api/v1/photos`.

### 6. Redirect URI / Callback URL
*   **The Analogy:** The specific **Meeting Point** in the lobby where the Front Desk hands the Key Card to the Butler. The Front Desk won't mail the key to a random address; they will only hand it over at a pre-verified location.
*   **Technical Definition:** The URL where the Authorization Server sends the user (and the authorization code/token) after they have successfully logged in and granted permission.
*   **In Practice:** An endpoint in your application logic.
    *   Example: `https://myapp.com/callback` or `https://myapp.com/api/auth/callback/google`.
    *   **Security:** This *must* be pre-registered with the Authorization Server to prevent attackers from intercepting tokens.

### 7. Scope
*   **The Analogy:** The **Access Level** on the Key Card.
    *   Does the card open the room? Yes.
    *   Does it open the VIP Lounge? No.
    *   Does it open the Gym? Yes.
*   **Technical Definition:** A mechanism to limit the application's access to a user's account. It represents the permissions the Client is asking for.
*   **In Practice:** A string or list of strings separated by spaces.
    *   Standard Scopes: `openid`, `profile`, `email`.
    *   Custom Scopes: `read:messages`, `write:orders`, `delete:admin`.
    *   When the user sees the consent screen ("This app wants to view your contacts"), that text is generated based on the requested *Scope*.

### 8. Grant (Authorization Grant)
*   **The Analogy:** The **Process/Paperwork** required to get the key.
    *   Are you the Guest? Showing ID is one type of Grant.
    *   Are you a Cleaner? Showing your employee badge is a different type of Grant.
*   **Technical Definition:** A credential representing the resource owner's authorization (to access its protected resources) used by the client to obtain an access token.
*   **In Practice:** The generic term for the **Flow** or **Method** being used.
    *   *Authorization Code Grant:* The standard flow for users.
    *   *Client Credentials Grant:* For server-to-server communication (no user).
    *   *Refresh Token Grant:* Exchanging an old token for a new one.

### 9. Token (Access Token)
*   **The Analogy:** The **Key Card** itself.
*   **Technical Definition:** A string of characters that acts as a credential used to access protected resources.
*   **In Practice:** Usually a JSON Web Token (JWT) or an Opaque string.
    *   The Client sends this token to the Resource Server (API) usually in the Header:
    *   `Authorization: Bearer <token_string_here>`
    *   If the token is valid, the API returns the data.

---

### Summary of Interactions

1.  **Resource Owner** (User) wants to use the **Client** (App).
2.  **Client** redirects User to **Authorization Server** (Auth0/Google).
3.  User logs in and approves **Scopes** (Permissions).
4.  **Authorization Server** redirects User back to **Client** (Redirect URI) with a temporary code (Grant).
5.  **Client** exchanges that code for an **Access Token**.
6.  **Client** sends **Access Token** to **Resource Server** (API) to get **Protected Resources** (Data).
