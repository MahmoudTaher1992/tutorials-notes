Based on the detailed table of contents you provided, you are currently looking at **Phase 3, Section 6, Part B: The ID Token**.

Here is a detailed explanation of what the ID Token is, why it exists, and how to handle it securely.

---

# 06-OIDC / 002-B: The ID Token in Detail

To understand the ID Token, we must first distinguish it from the **Access Token**. This is the single biggest point of confusion in modern authentication.

*   **Access Token (OAuth 2.0):** This is a key card. It allows you to enter a room. The lock doesn't necessarily care *who* you are, only that you hold a valid card to open the door.
*   **ID Token (OpenID Connect):** This is your Driver’s License or Passport. It proves **who you are**. It contains your name, your photo, and your unique ID number.

The ID Token is the specific artifact introduced by **OpenID Connect (OIDC)** to add an "Identity Layer" on top of the standard OAuth 2.0 authorization framework.

## i. The Format (JWT)

The ID Token ensures that User Identity is portable and standardized. To achieve this, OIDC mandates that the ID Token must be a **JWT (JSON Web Token)**.

Because it is a JWT, it consists of three parts separated by dots (`.`):
1.  **Header:** Algorithm and token type.
2.  **Payload:** The data about the user (called **Claims**).
3.  **Signature:** A cryptographic proof that the token hasn't been tampered with.

### Example of a Decoded ID Token Payload
If you decode a standard ID Token from Google or Auth0, the JSON payload looks like this:

```json
{
  "iss": "https://accounts.google.com",
  "sub": "10769150350006150715113082367",
  "aud": "123-your-client-id.apps.googleusercontent.com",
  "exp": 1311281970,
  "iat": 1311280970,
  "email": "user@example.com",
  "email_verified": true,
  "name": "John Doe",
  "picture": "https://lh3.googleusercontent.com/a-/AOh14Ef..."
}
```

---

## ii. Validation: Audience (`aud`), Issuer (`iss`), and Subject (`sub`)

When your application receives an ID Token (usually after a user logs in via "Login with Google/Microsoft"), you **cannot simply trust it**. You must validate it.

Should you parse the JSON and trust the data blindly, an attacker could spoof a token. Here are the three critical fields (Claims) you must validate:

### 1. The Issuer (`iss`)
*   **What it is:** A URL identifying the entity that created and signed the token (the Identity Provider).
*   **The Check:** exact string match.
*   **Logic:** "I configured my app to trust `https://accounts.google.com`. Does this token say it came from there?"
*   **Security Risk:** If you don't check this, an attacker could set up their own Identity Server, sign a valid token from *their* server, and present it to your app. Without checking `iss`, your app might accept it.

### 2. The Audience (`aud`)
*   **What it is:** The Client ID of the application that the token is intended for.
*   **The Check:** Does the `aud` in the token match **your** Application's Client ID?
*   **Logic:** "Is this ID card meant for *my* building?"
*   **Security Risk:** This prevents **Token Substitution Attacks**.
    *   *Scenario:* A user logs into "Malicious App A" using Google. "Malicious App A" gets a valid Google ID Token for that user.
    *   "Malicious App A" then sends that token to "Your Legit App B".
    *   If "Your Legit App B" validates the signature (it's real) and the issuer (it's Google) but ignores the `aud`, it looks like a valid login.
    *   *Startling Result:* The malicious app has logged into your app as the victim. Checking `aud` ensures the token was issued specifically for *your* app.

### 3. The Subject (`sub`)
*   **What it is:** The unique identifier for the user within the Identity Provider's system.
*   **The Usage:** This is the `user_id`. It is stable and unique.
*   **Logic:** Never use `email` as the primary key if you can avoid it (people change emails). Use `sub`.
*   **Pairing:** Uniqueness is usually scoped to the Issuer. `sub: 123` from Google is different from `sub: 123` from Facebook. In your database, your user record usually links to a composite key: `{Provider: Google, Sub: 123}`.

---

## Summary of the OIDC Validation "Checklist"

When your backend receives an ID Token:

1.  **verify Signature:** Use the Identity Provider's Public Key (found via the Discovery endpoint `/.well-known/openid-configuration`) to verify the JWT signature.
2.  **verify `iss`:** Ensure it matches the configured provider URL.
3.  **verify `aud`:** Ensure it matches your specific Client ID.
4.  **verify `exp`:** Ensure the current time is before the timestamp in the `exp` claim.
5.  **verify `nonce` (Optional but recommended):** If you sent a random string during the login request, ensure the exact same string came back in the token to prevent replay attacks.

## Common Engineering Pitfall

**Do not use the ID Token for API Authorization.**

*   **ID Token:** Intended for the Client (Frontend/Mobile App) to know who the user is and display their profile picture.
*   **Access Token:** Intended to be sent to the Backend API (Resource Server) in the `Authorization: Bearer` header.

While many developers send the ID Token to the backend to "log in," once the session is established, API calls should be secured by **Access Tokens**, not ID Tokens. ID Tokens often contain Personal Identifiable Information (PII) and are meant to be consumed by the client, whereas Access Tokens are meant to be consumed by the API.
