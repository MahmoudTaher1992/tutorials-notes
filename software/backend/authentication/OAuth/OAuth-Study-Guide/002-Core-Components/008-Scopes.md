Here is a detailed explanation of **Section 8: Scopes** from your Developer Study Guide.

---

# 002-Core-Components / 008-Scopes

In the OAuth 2.0 framework, **Scopes** are the mechanism used to limit an application's access to a user's account. They are the realization of the **Principle of Least Privilege**—ensuring that an app only has the access it needs to perform its function, and nothing more.

Here is a breakdown of the specific concepts listed in your Table of Contents.

---

## 1. What are Scopes?
A **Scope** is a string (text) parameter that defines the specific permissions or access rights a Client application is requesting from the Resource Owner (the user).

### The Concept
When an application asks to connect to your Google or Facebook account, it doesn't usually get the "keys to the castle" (full administrative control). Instead, it asks for specific permissions.

### The Valet Key Analogy
Think of your car key:
*   **Master Key:** Opens the doors, trunk, glovebox, and starts the engine.
*   **Valet Key:** Starts the engine so the valet can park the car, but **cannot** open the trunk or glovebox.

In OAuth:
*   The **Master Key** is your username/password (credentials).
*   The **Valet Key** is the Access Token.
*   The **Scope** is the definition of what that Valet Key is allowed to do (e.g., `engine:start` is allowed, `trunk:open` is denied).

---

## 2. Scope Design Patterns
When designing an API, developers must decide how to structure their scopes. There are several common patterns:

### A. Resource-Based (Granular)
This pattern combines an **action** with a **resource**. It is very popular in RESTful APIs.
*   `read:orders` (View order history)
*   `write:orders` (Create a new order)
*   `delete:orders` (Cancel an order)

### B. Service-Based (Broad)
This gives access to a whole functional area or service.
*   `calendar` (Full access to the calendar)
*   `drive` (Full access to file storage)

### C. Role-Based (Administrative)
Sometimes scopes look like user roles, though this blurs the line between Authorization and Permission management.
*   `admin`
*   `moderator`

**Best Practice:** Scopes should describe **what the application wants to do**, not who the user is.

---

## 3. Scope Naming Conventions
There is no strict rule in the RFC regarding naming, but consistency is vital for security and developer experience.

### Common Formats:
1.  **Colon-separated (Action:Resource):** `read:user`, `write:database`
2.  **Dot-separated:** `user.read`, `database.write`
3.  **Simple Strings:** `email`, `profile`, `openid` (Standard OIDC scopes).
4.  **URIs (Common in Enterprise):**
    *   To avoid naming collisions between different products, companies like Microsoft and Google often use full URLs as scopes.
    *   Example: `https://graph.microsoft.com/User.Read`

**Note:** In the actual HTTP request, multiple scopes are separated by **spaces**.

---

## 4. Requesting Scopes
When the Client initiates the authorization flow, it includes a `scope` query parameter in the URL sent to the Authorization Server.

### The Request
```http
GET /authorize?
  response_type=code
  &client_id=s6BhdRkqt3
  &redirect_uri=https://client.example.com/callback
  &scope=read:contacts%20write:calendar
```

*   **Syntax:** The scopes are a space-delimited list. In the URL above, `%20` represents the space.
*   **Meaning:** "I (the application) would like to read the user's contacts AND write to their calendar."

If the client sends **no scope** parameter, the Authorization Server may treat the request as asking for a pre-defined "default" scope, or it may reject the request.

---

## 5. Scope Consent
This is the user-facing aspect of scopes. Once the server receives the request above, it authenticates the user and presents a **Consent Screen**.

### The Interaction
1.  **The Prompt:** The server asks the user: *"Application 'CoolApp' wants to: View your contacts and Manage your calendar. Do you allow this?"*
2.  **User Decision:**
    *   **Full Grant:** The user clicks "Allow."
    *   **Partial Grant:** (Supported by some servers) The user unchecks "Manage Calendar" but allows "View Contacts."
    *   **Denial:** The user clicks "Deny."

### The Result
The Authorization Server generates a token.
*   If the user allowed everything, the token contains: `scope="read:contacts write:calendar"`.
*   If the server or user limited the access, the token might only contain: `scope="read:contacts"`.

The Client Application must always check the scopes associated with the token it receives, as they might be different from what it requested.

---

## 6. Downscoping
Downscoping is the process of exchanging an existing token for a new token that has **fewer** permissions (a subset of the original scopes).

### Use Case 1: Increasing Security (Least Privilege)
Imagine you have a "God Token" that can do everything (`admin`, `read`, `write`). You want to pass a token to a third-party microservice to perform a specific task (e.g., analyze a profile picture).
You don't want that microservice to have admin rights. You "downscope" your token to create a new one that only has `read:profile_image` and pass that safe token to the microservice.

### Use Case 2: Step-up Authorization
An app might initially only ask for `read:profile` to let you log in quickly. Later, if you try to make a purchase, the app will start a new flow asking for `write:payment`. This is strictly "upscoping," but the concept of managing scope lifecycle is related.

### Implementation
Currently, standard RFCs handle this via **Token Exchange (RFC 8693)**. A client sends a valid token to the server and requests a new token with a reduced scope parameter.

---

### Summary Table

| Term | Definition |
| :--- | :--- |
| **Scope Parameter** | The string sent in the URL (e.g., `scope=email profile`). |
| **Scope Consent** | The user agreeing to the requested permissions. |
| **Access Token** | The credential that "contains" the granted scopes. |
| **Resource Server** | The API that reads the token and checks if the required scope is present before returning data. |
