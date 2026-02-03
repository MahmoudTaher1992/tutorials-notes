Based on the Table of Contents provided, **Section 6: The ID Token Deep Dive** (found in *002-Core-OIDC-Concepts/003-ID-Token-Deep-Dive.md*) is the technical heart of OpenID Connect. This is where OIDC differentiates itself from standard OAuth 2.0.

Here is a detailed explanation of the concepts covered in that section.

---

# Only the "ID Token Deep Dive" Explained

The **ID Token** is the "Driver’s License" of the digital identity world. While an Access Token allows you to *do* things (authorization), the ID Token proves *who you are* (authentication).

## 1. JWT Structure (Header, Payload, Signature)
The ID Token is always formatted as a **JSON Web Token (JWT)**. It is a string connecting three parts separated by dots (`.`), typically looking like `aaaaa.bbbbb.ccccc`.

### A. The Header
This describes **how** the token was signed. It is a JSON object encoded in Base64Url.
```json
{
  "alg": "RS256",  // The algorithm used (e.g., RSA Signature with SHA-256)
  "typ": "JWT",    // The type of token
  "kid": "12345"   // Key ID: Which key (in the JWKS) validates this signature
}
```

### B. The Payload
This contains the actual data, known as **Claims**. This is the "body" of the ID card containing your name, ID number, and expiration date.
```json
{
  "iss": "https://accounts.google.com",
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022
}
```

### C. The Signature
This is the cryptographic proof. The Identity Provider takes the Header and Payload, applies the algorithm specified in the Header (e.g., RS256) using their **Private Key**, and generates this signature.
*   **Why it matters:** Your application uses the Provider's **Public Key** to verify this signature. If it matches, you know 100% that the data inside hasn't been tampered with.

---

## 2. Standard Claims
The OIDC specification mandates a set of specific fields (claims) inside the payload so that all applications know how to read them.

*   **`iss` (Issuer):** *Who created this token?*
    *   Example: `https://auth0.com` or `https://accounts.google.com`.
    *   *Validation:* You must check that this matches exactly the URL of the provider you trust.
*   **`sub` (Subject):** *Who is the user?*
    *   This is the unique identifier for the user within the Identity Provider (e.g., `twitter|45678`).
    *   *Note:* This should be stable; even if a user changes their email, the `sub` stays the same.
*   **`aud` (Audience):** *Who is this token for?*
    *   This will contain your application's **Client ID**.
    *   *Validation:* You must reject any token where the `aud` does not match your Client ID. This prevents malicious apps from tricking your app into accepting their tokens.
*   **`exp` (Expiration Time):** *When does this token die?*
    *   A Unix timestamp. If the current time is after this, the token is trash.
*   **`iat` (Issued At):** *When was this created?*
    *   Used to determine the age of the token.
*   **`nonce`:** *Number used ONCE.*
    *   A random string sent by your app during the initial request and returned in the token.
    *   *Validation:* If the `nonce` in the token doesn't match the one you stored in your browser/session before the redirect, it's a replay attack.

---

## 3. Optional Claims
These provide extra context about *how* the authentication happened.

*   **`auth_time`:** The time the user *actually* entered their credentials (password/MFA). This is distinct from `iat` (when the token was printed).
    *   *Use Case:* Banking apps might check this. If `auth_time` was 30 minutes ago, they might force you to re-login.
*   **`acr` (Authentication Context Class Reference):** How strong was the login?
    *   Example values: `Level 1` (Password only), `Level 2` (MFA/2FA).
*   **`amr` (Authentication Methods References):** Specific methods used.
    *   Example array: `["pwd", "otp", "face"]`.
*   **`azp` (Authorized Party):** Used when the entity requesting the token is different from the audience. (Rare in simple apps, common in mobile apps accessing backends).

---

## 4. Custom Claims
OIDC allows developers to add non-standard information to the payload.

*   **Namespacing:** To avoid collisions with standard claims, it's best practice to namespace these (e.g., URL format).
*   **Example:**
    ```json
    {
      "https://myapp.com/roles": ["admin", "editor"],
      "https://myapp.com/subscription_level": "premium"
    }
    ```

---

## 5. ID Token Validation Steps (The most critical part)
If a developer receives an ID Token and simply decodes the Base64 without validating it, **they have introduced a critical security vulnerability.** Anyone can forge a Base64 string.

The validation process involves these mandatory steps:

1.  **Verify the Signature:** Fetch the public keys (JWKS) from the provider and cryptographically verify the signature matches the header/payload.
2.  **Verify the `iss`:** Does the issuer URL match exactly what your configuration expects?
3.  **Verify the `aud`:** Is this token aimed at YOUR application (Client ID)?
4.  **Verify the `exp`:** Is the current time < expiration time?
5.  **Verify the `nonce`:** (If using Implicit or Hybrid flow) Does the nonce match what you sent?

### Summary
The **ID Token Deep Dive** module teaches you that an ID Token is a signed JSON document that asserts identity. It is the primary artifact that allows your application to say: **"I know who this user is, and I can prove it."**
