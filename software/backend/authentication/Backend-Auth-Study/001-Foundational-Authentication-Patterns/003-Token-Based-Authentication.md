Based on the study plan you provided, here is a detailed explanation of section **1.C: Token-Based Authentication (Stateless)**.

---

### The Big Picture: Stateless vs. Stateful
To understand Token-Based Authentication, you must first understand what it refers to as "Stateless."

*   **Stateful (Cookie/Session):** When you log in, the server creates a record in its memory or database ("User 123 is logged in"). It gives you a Session ID. Every time you make a request, the server looks up that ID in its database to see if you are still logged in.
*   **Stateless (Token-Based):** The server **does not** keep a record that you are logged in. Instead, it gives you a "signed" digital ID card (the Token). When you make a request, you show that card. The server validates the signature on the card to know it’s real. It doesn't need to look up a database session.

---

### i. How it Works
Here is the step-by-step lifecycle of Token-Based Authentication:

1.  **Login:** The Client (Browser/Mobile App) sends credentials (username/password) to the Server.
2.  **Verification:** The Server verifies the password is correct.
3.  **Token Issuance:** Instead of creating a session in a database, the Server generates a **Token** (usually a JWT).
    *   This token contains data inside it (e.g., User ID, Role, Expiration Date).
    *   The Server **signs** this token with a secret key (digital signature).
4.  **Storage:** The Server sends the token to the Client. The Client stores it (usually in LocalStorage or memory).
5.  **Subsequent Requests:** When the Client wants data (e.g., "Get my profile"), it attaches the token to the HTTP Request Header, usually looking like this:
    `Authorization: Bearer <token_string>`
6.  **Validation:** The Server receives the request. It looks at the signature on the token. If the signature is valid, the server knows the token was created by them and hasn't been tampered with. It processes the request.

---

### ii. Use Case
Why is this method preferred for modern development?

*   **Modern APIs & Single Page Applications (SPAs):** Frameworks like React, Vue, and Angular often speak to API backends that might sit on different domains. Tokens handle Cross-Origin (CORS) scenarios more easily than cookies.
*   **Mobile Applications:** Native headers (Android/iOS) generally don’t handle cookies the same way web browsers do. Sending a Token in a header is much easier to implement on mobile.
*   **Scalability (Microservices):** If you have 50 different servers, you don't want all 50 of them trying to look up a session in a centralized database every time a user clicks a button. Because the token is self-contained, any server with the Secret Key can verify the user instantly.

---

### iii. Core Component: JWT (JSON Web Token)
The industry standard format for these tokens is **JWT** (pronounced "jot"). A JWT is a string of characters separated by two dots (`.`), resulting in three parts:

`Header.Payload.Signature`

#### a. Purpose
A JWT is **Self-Contained**. This means the token itself carries all the necessary information about the user. The server doesn't need to ask the database "Who is this user?" because the User ID is written right inside the token.

#### b. Structure (The 3 parts)

**1. Header (The "Metadata")**
This tells the server what kind of token it is and what mathematical algorithm was used to sign it.
```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

**2. Payload (The "Claims" / Data)**
This is the actual data. It contains "Claims"—statements about the user.
*   **Registered Claims:** Standard fields like `exp` (Expiration time), `sub` (Subject/User ID).
*   **Custom Claims:** Data you want to include, like `role: "admin"` or `name: "Alice"`.
*   *Warning:* This part is easily readable by anyone (it is just Base64 encoded). **Never put passwords or sensitive secrets in the payload.**
```json
{
  "sub": "1234567890",
  "name": "John Doe",
  "role": "admin",
  "exp": 1716239022
}
```

**3. Signature (The "Security Seal")**
This prevents users from faking tokens.
*   The server takes the **Header** + the **Payload** + a hidden **Secret Key** (that only the server knows).
*   It mashes them together using the algorithm (e.g., HS256).
*   It generates a unique string (the signature).

**How the verification works:**
If a hacker takes a token and changes `role: "user"` to `role: "admin"` in the payload, the **Signature** will no longer match the data. The server will reject the token immediately.

---

### Summary Analogy: The Hotel Key Card

*   **Cookie/Session:** You go to the front desk. The clerk looks at the guest book (database), sees you are in Room 202, and lets you in. They have to check the book every time.
*   **Token (JWT):** The clerk gives you a plastic key card with a magnetic strip. You don't need to talk to the clerk anymore. You go straight to your room. The lock on the door checks the code on the magnetic strip (Signature). If the code mimics the hotel's secret pattern, the door opens. The lock doesn't need to call the front desk to ask if you are a guest; the card itself is proof.
