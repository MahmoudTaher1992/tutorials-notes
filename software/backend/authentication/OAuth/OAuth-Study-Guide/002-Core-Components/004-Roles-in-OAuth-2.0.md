Based on the study guide structure you provided, here is a detailed explanation of **Part 2, Section 4: Roles in OAuth 2.0**.

---

# 004 - Roles in OAuth 2.0

To understand OAuth 2.0, you must understand the "cast of characters." OAuth is essentially an interaction between four distinct parties. The protocol defines exactly how these parties communicate to safely grant access to data without sharing passwords.

The four roles defined by the RFC 6749 specification are:
1.  **Resource Owner**
2.  **Client**
3.  **Authorization Server**
4.  **Resource Server**

Below is a detailed breakdown of each role, followed by a concrete example to tie them together.

---

### 1. Resource Owner (RO)
*   **The "User"**

**Definition:**
The entity capable of granting access to a protected resource. When the resource owner is a person, they are often referred to as the **End-User**.

**In Plain English:**
This is **you**. You own your data (your photos, your bank transactions, your email). You are the only one who can say, "Yes, I allow this application to see my data."

**Responsibilities:**
*   Provides the actual credentials (username/password) to the Authorization Server (not the app).
*    grants or denies consent (e.g., clicking "Allow" on the consent screen).

---

### 2. Client (The Application)
*   **The "App" trying to get data**

**Definition:**
An application making protected resource requests on behalf of the resource owner and with its authorization.

**In Plain English:**
This is the **application** you are using. It could be a website, a mobile app, a desktop program, or a smart TV app.
*   *Crucial distinction:* In OAuth terminology, "Client" does **not** mean the web browser or the user. It means the software that wants the data.

**Responsibilities:**
*   Redirects the user to the Authorization Server.
*   Receives the Authorization Code/Token.
*   Stores the tokens securely.
*   Uses the Access Token to call the API.

---

### 3. Authorization Server (AS)
*   **The "Security Guard"**

**Definition:**
The server issuing access tokens to the client after successfully authenticating the resource owner and obtaining authorization.

**In Plain English:**
This is the identity provider (e.g., **Google, Facebook, Okta, Auth0**). It is the engine that holds the user database and checks passwords. It acts as a trusted middleman.

**Responsibilities:**
*   Verifies the identity of the Resource Owner (checks username/password).
*   Verifies the identity of the Client (checks Client ID).
*   Asks the user for consent ("Do you want to share your contacts with this app?").
*   Issues Access Tokens and Refresh Tokens.

---

### 4. Resource Server (RS)
*   **The "API" or "Vault"**

**Definition:**
The server hosting the protected resources, capable of accepting and responding to protected resource requests using access tokens.

**In Plain English:**
This is the **API** (e.g., the Google Photos API, the Spotify API, the Bank API). It doesn't care who the user is; it only cares that a valid Access Token was sent.

**Responsibilities:**
*   Receives requests containing Access Tokens (usually in the Authorization header).
*   Validates the token (checks signature, expiration, and scopes).
*   Returns the requested data (JSON/XML) if the token is valid.

---

### Real-World Example: "Printing Your Google Photos"

Imagine you are using a website called **"SuperPrints"** to print a photo album from your **Google Photos** account.

1.  **Resource Owner:** **You**. You own the photos.
2.  **Client:** **SuperPrints**. It wants to access your photos to print them.
3.  **Authorization Server:** **accounts.google.com**. This is where you log in.
4.  **Resource Server:** **photos.googleapis.com**. This is where the actual image files live.

**The Interaction (Simplified):**

1.  **SuperPrints (Client)** says: "Please log in so I can see your photos."
2.  You are redirected to **Google (Authorization Server)**.
3.  **Google (AS)** asks **You (Resource Owner)**: "SuperPrints wants to see your photos. Is that okay?"
4.  **You (RO)** say: "Yes."
5.  **Google (AS)** hands a **Token** to **SuperPrints (Client)**.
6.  **SuperPrints (Client)** takes that Token and sends it to the **Google Photos API (Resource Server)**.
7.  The **API (RS)** sees a valid token and gives the photo files to **SuperPrints**.

---

### Role Interactions & Trust Relationships

It is important to understand the trust boundaries between these roles:

1.  **The Client is Untrusted:** The Resource Owner (User) should **never** give their username and password directly to the Client. The Client cannot be trusted to handle credentials. This is why OAuth redirects the user away to the Authorization Server to type in passwords.
2.  **The AS and RS are often Close:** In many companies (like Google or Facebook), the Authorization Server and Resource Server are technically different servers, but they belong to the same organization. However, in enterprise setups, the AS might be Okta, while the RS is an internal API hosted on AWS.
3.  **The Token is the Key:** The Resource Server trusts the Authorization Server. If the AS signs a token saying "User A allowed App B," the RS believes it without asking the user again.

### Visual Summary

| Role | Analogy (Hotel) | What it holds/knows |
| :--- | :--- | :--- |
| **Resource Owner** | The Hotel Guest | Credentials (Username/Password) |
| **Client** | The Person delivering room service | Client ID & Secret |
| **Auth Server** | The Front Desk / Reception | User Database & Policy Logic |
| **Resource Server** | The Hotel Room Door | The actual goods (Data) |

*In the hotel analogy: The Guest (RO) goes to the Reception (AS), shows ID, and gets a Key Card (Token). The Guest gives the Key Card to the delivery person (Client). The delivery person uses the Card to open the Door (RS).*
