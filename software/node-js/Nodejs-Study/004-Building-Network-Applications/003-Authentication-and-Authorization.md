This section of the roadmap focuses on the single most critical aspect of building secure network applications: **Security**.

Here is a detailed explanation of Part IV, Section C: **Authentication & Authorization**.

---

### 1. The Core Concepts: AuthN vs. AuthZ
Before diving into the tools, you must understand the difference between the two:

*   **Authentication (AuthN):** *Who are you?*
    *   Verifying the identity of a user (e.g., logging in with a username and password).
*   **Authorization (AuthZ):** *What are you allowed to do?*
    *   Verifying permissions once the user is identified (e.g., an "Admin" can delete posts, but a "Guest" can only read them).

---

### 2. Strategies for Authentication
There are three main ways to handle authentication in Node.js applications:

#### A. Session-Based Authentication (Stateful)
*   **How it works:** When a user logs in, the server creates a unique "Session ID" and stores the user's data in the server's memory (or a database like Redis). The Session ID is sent to the user's browser as a **Cookie**.
*   **Pros:** Easy to revoke access (just delete the session on the server).
*   **Cons:** Harder to scale. If you have multiple servers, they all need access to the same session storage.
*   **Use Case:** Traditional server-rendered websites (monoliths).

#### B. JSON Web Tokens (JWT) (Stateless)
*   **How it works:** When a user logs in, the server generates a signed token (a long string) containing the user's ID. This token is sent to the client. The server **does not save** the token. For subsequent requests, the client sends the token back. The server uses a mathematical formula to verify the signature.
*   **Pros:** Highly scalable. The server doesn't need to check a database to verify the user; it just checks the signature.
*   **Cons:** Harder to revoke access immediately (since the server doesn't store the token).
*   **Use Case:** REST APIs, Mobile Apps, Single Page Applications (React, Vue).

#### C. API Keys
*   **How it works:** A long, secret string is generated for a user or a service. This key is sent in the HTTP headers of every request.
*   **Use Case:** Machine-to-Machine communication (e.g., your app talking to the Stripe API or OpenAI API).

---

### 3. Hashing Passwords with `bcrypt`
**Rule #1 of Security:** Never store passwords in plain text in your database. If your database is hacked, everyone's passwords are stolen.

You must **Hash** passwords. Hashing is a one-way process (you can turn `password123` into a hash, but you cannot turn the hash back into `password123`).

*   **The Library:** `bcrypt` (or `bcryptjs`) is the industry standard.
*   **Salting:** Bcrypt adds a random string (salt) to the password before hashing it. This prevents hackers from using "Rainbow Tables" (pre-computed lists of common passwords) to crack hashes.
*   **Slowness:** Bcrypt is designed to be slow. This makes it computationally expensive for hackers to try to brute-force guess passwords.

**Example Workflow:**
1.  **Registration:** User sends "mypassword". Server runs `bcrypt.hash("mypassword")` → results in `$2b$10$EixZa...`. Save that hash in the DB.
2.  **Login:** User sends "mypassword". Server fetches the hash from DB. Server runs `bcrypt.compare("mypassword", storedHash)`. If `true`, login succeeds.

---

### 4. Implementing JWTs with `jsonwebtoken`
The `jsonwebtoken` (npm package) is the standard library for creating and verifying tokens.

**Structure of a JWT:**
A JWT looks like `xxxxx.yyyyy.zzzzz`. It has three parts:
1.  **Header:** The algorithm used.
2.  **Payload:** The data (e.g., `{ userId: 123, role: 'admin' }`). **Note:** This is readable by anyone! Never put passwords or sensitive secrets here.
3.  **Signature:** The header + payload + a secret key (known only to the server), hashed together.

**Code Logic:**
*   **Signing (Login):**
    ```javascript
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1h' });
    ```
*   **Verifying (Middleware protection):**
    ```javascript
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded; // User is authenticated
        next();
    } catch (err) {
        // Token is invalid or expired
    }
    ```

---

### 5. Comprehensive Auth with `Passport.js`
Writing manual login logic for standard email/password is fine, but what if you want to add "Login with Google," "Login with Facebook," or "Login with GitHub"?

**Passport.js** is authentication middleware that modularizes this process.

*   **Strategies:** Passport uses plugins called "Strategies."
    *   `passport-local`: For standard Username/Password login.
    *   `passport-jwt`: For verifying JWTs on API routes.
    *   `passport-google-oauth20`: For "Sign in with Google."
*   **How it works:** You configure the strategy once in your main file. In your routes, you simply use:
    ```javascript
    app.post('/login', passport.authenticate('local'), (req, res) => {
        // If we get here, the user is logged in
    });
    ```

### Summary of Workflow
In a modern Node.js API, the flow usually looks like this:

1.  **Sign Up:** Client sends email/password -> Node uses `bcrypt` to hash password -> Save user to DB.
2.  **Login:** Client sends email/password -> Node finds user -> Node compares password with `bcrypt` -> If match, Node uses `jsonwebtoken` to sign a token -> Sends token to Client.
3.  **Protected Route:** Client requests `/api/profile` (sends token in Header) -> Node Middleware verifies token -> If valid, Node sends back profile data.
