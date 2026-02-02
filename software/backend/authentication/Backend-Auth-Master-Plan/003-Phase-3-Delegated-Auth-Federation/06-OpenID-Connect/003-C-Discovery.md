Based on the Table of Contents provided, you are asking for a detailed explanation of **Phase 3, Item 6, Subsection C: Discovery**.

Here is the deep dive into that specific topic.

---

# 06. OpenID Connect (OIDC) - C. Discovery
**The `/.well-known/openid-configuration` Endpoint**

### 1. The Problem: "Hardcoding Hell"
Imagine you are building an application that allows users to "Log in with Google" or "Log in with Okta." To make this work manually, you would need to find and hardcode several specific URLs into your backend configuration:

1.  **The Authorization Endpoint:** Where you redirect the user's browser to enter their password.
2.  **The Token Endpoint:** Where your server sends the code to get an Access Token.
3.  **The UserInfo Endpoint:** Where you ask for the user's profile data.
4.  **The Public Keys (JWKS):** The cryptographic keys needed to verify that the token actually came from Google and wasn't forged.

If Google or your corporate Identity Provider (IdP) ever changed these URLs or rotated their security keys, your application would crash or fail to validate users until you manually updated your code.

### 2. The Solution: OIDC Discovery
**OIDC Discovery** is a standard defined by OpenID Connect that allows a client (your app) to **automatically** configure itself by asking the Identity Provider (IdP) for a "configuration file."

This file is always hosted at a standardized path:
`/.well-known/openid-configuration`

### 3. How it Works (The Workflow)

When your backend application starts up, it performs a "handshake" process:

1.  **Input:** You give your backend **one** piece of information: The Issuer URL (e.g., `https://accounts.google.com`).
2.  **Request:** Your backend automatically appends `/.well-known/openid-configuration` to that URL and makes an HTTP GET request.
3.  **Response:** The IdP returns a massive JSON object containing every URL and setting your app needs to function.
4.  **Configuration:** Your app parses this JSON and internally configures the logic for redirects, token exchanges, and signature verification.

### 4. Anatomy of the Configuration JSON
If you navigate to `https://accounts.google.com/.well-known/openid-configuration` in your browser right now, you will see a raw JSON file.

Here are the most critical fields inside that JSON and what they do:

#### A. `issuer`
*   **Value:** `https://accounts.google.com`
*   **Why it matters:** Security. When your app receives an ID Token, one of the fields inside the token is `iss` (Issuer). Your app compares the `iss` in the token against this field in the Discovery doc. If they don't match, the token is rejected.

#### B. `authorization_endpoint`
*   **Value:** `https://accounts.google.com/o/oauth2/v2/auth`
*   **Why it matters:** When a user clicks "Log In," this is the exact URL your backend will redirect the browser to.

#### C. `token_endpoint`
*   **Value:** `https://oauth2.googleapis.com/token`
*   **Why it matters:** After the user logs in, the browser returns a "Code." Your backend sends a POST request to *this* URL to swap that code for the actual tokens.

#### D. `jwks_uri` (The Most Important Field)
*   **Value:** `https://www.googleapis.com/oauth2/v3/certs`
*   **Why it matters:** This stands for **JSON Web Key Set URI**.
    *   Recall from **Phase 2 (JWTs)** that tokens are signed using Asymmetric Encryption (RS256).
    *   The IdP holds the *Private Key* to sign the token.
    *   Your app needs the *Public Key* to verify the signature.
    *   Instead of you pasting a static Public Key into your code, your app hits this URL to fetch the current valid Public Keys dynamically.

### 5. Why is Discovery Critical? (Key Rotation)
The primary engineering benefit of Discovery is handling **Key Rotation**.

For security reasons, Identity Providers change their cryptographic signing keys regularly (e.g., every 90 days).
1.  **Without Discovery:** You would have to manually deploy new code with the new Public Key every time Google changed theirs. If you were sleeping when they did it, your app goes down.
2.  **With Discovery:** Your OIDC Middleware (like Passport.js, Spring Security, or NextAuth) sees a token signed with a structured Key ID (`kid`). If it doesn't recognize the key, it automatically re-fetches the `jwks_uri` to get the latest keys.

### 6. Summary for the "Master Plan"
In the context of the curriculum you provided:

*   **Phase 2** taught you 1 + 1 = 2 (Manual JWT verification).
*   **Phase 3 (Discovery)** teaches you how to use a Calculator.

You stop manually writing the verification logic and instead point your library to the `/.well-known/openid-configuration` endpoint. This makes your authentication system **resilient**, **self-healing**, and **standard-compliant**.
