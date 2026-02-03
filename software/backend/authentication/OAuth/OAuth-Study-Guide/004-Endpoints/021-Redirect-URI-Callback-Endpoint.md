Based on **item 21** of the provided study guide, here is a detailed explanation of the **Redirect URI (Callback Endpoint)** in the context of OAuth 2.0 and OAuth 2.1.

---

# 21. Redirect URI / Callback Endpoint

The **Redirect URI**, often referred to as the **Callback URL**, is one of the most critical components of the OAuth flow. It serves as the bridge that safely transports the User (Resource Owner) back from the Authorization Server to the Client Application after authentication is complete.

## 1. Purpose and Behavior

In an OAuth flow (specifically the **Authorization Code Grant**), the Client application sends the user away to the Authorization Server (e.g., Google, Auth0, or a corporate login page). Once the user logs in and consents to the access request, the Authorization Server needs a way to send the user—and the critical **Authorization Code**—back to the Client application.

The **Redirect URI** is the address where the Authorization Server sends this response.

### How it works effectively:
1.  **The Request:** The Client sends a request to the Authorization Endpoint containing a `redirect_uri` parameter.
    > `GET /authorize?response_type=code&client_id=123&redirect_uri=https://app.com/callback`
2.  **The Authentication:** The user logs in at the Authorization Server.
3.  **The Redirect:** If successful, the Authorization Server instructs the browser to navigate to the provided URI, appending the code.
    > `HTTP 302 Location: https://app.com/callback?code=AUTH_CODE_HERE&state=xyz`
4.  **The Handling:** The Client’s specific endpoint (e.g., `/callback`) activates. It grabs the `code` from the URL query strings and initiates the backend exchange for an Access Token.

## 2. Validation Rules & Registration

Because the Redirect URI is the delivery vehicle for security credentials (codes or tokens), it cannot be dynamic or arbitrary. It must be pre-registered to prevent **Token Hijacking**.

### The "Allow List"
Before an application can ever perform an OAuth handshake, the developer must log into the Authorization Server’s dashboard (e.g., Google Cloud Console, Auth0 Dashboard) and input the specific URL(s) their app uses.

*   **Registration:** The developer registers `https://myapp.com/callback`.
*   **Runtime Check:** When the OAuth flow starts, the Client sends `redirect_uri=https://myapp.com/callback`.
*   **Validation:** The Authorization Server checks: *Does the URI in the request match the URI in the database for this Client ID?*
    *   **Match:** Proceed.
    *   **Mismatch:** Error `redirect_uri_mismatch`. The flow stops immediately.

## 3. Exact Match vs. Pattern Matching

Historically, OAuth 2.0 implementations varied in how strictly they validated these URIs.

### Pattern Matching / Wildcards (The Old, Dangerous Way)
Some older implementations allowed developers to register wildcards, such as `https://*.myapp.com/*`.
*   **Risk:** This is highly dangerous. If an attacker can claim a subdomain (e.g., `blog.myapp.com`) or find an Open Redirect vulnerability on a allowed path, they can trick the Authorization Server into sending the auth code to a server they control.

### Exact Matching (The Standard & OAuth 2.1 Requirement)
Modern security best practices and **OAuth 2.1** aggressively enforce **Exact String Matching**.
*   **Rule:** The URI provided in the request must be identical, character-for-character, to the registered URI.
*   **No fragments:** Usually cannot contain `#`.
*   **No relative paths:** Must be an absolute URI.
*   **No wildcards:** `https://app.com/*` is invalid.

## 4. Localhost Considerations

Developing OAuth apps locally poses a challenge because exact matching requires a fixed URL, but developers often use dynamic ports or `http` instead of `https`.

### Exception for Loopback Interfaces
The OAuth standards (specifically in **Native Apps** and **OAuth 2.1**) make a small exception for "loopback" addresses (`127.0.0.1` or `[::1]`).
1.  **Dynamic Ports:** Authorization Servers may allow the port to vary at runtime for localhost (e.g., `http://127.0.0.1:anything/callback`), or the Client can spin up a temporary local web server on a random port to listen for the code.
2.  **HTTP vs HTTPS:** While production URIs *must* use TLS (`https`), localhost is generally explicitly allowed to use plain `http` during development.

**Note:** The string `localhost` is technically distinct from `127.0.0.1`. Some security guidance recommends using the IP `127.0.0.1` to avoid potential DNS resolving attacks, though many ecosystem providers support both.

## 5. Security Implications

This endpoint is a primary target for attackers.

### Authorization Code Interception
If the Redirect URI validation is weak (e.g., allows wildcards), an attacker can generate a link that looks legitimate but sends the `code` to their server.
*   *Before:* `https://myapp.com/callback` (Legit)
*   *Attack:* `https://myapp.com/open-redirect?url=attacker.com` (If the Auth Server validates only the domain, it might redirect here, which then forwards the sensitive code to `attacker.com`).

### Mix-Up Attacks
If a client interacts with multiple Authorization Servers (e.g., "Login with Google" AND "Login with Facebook"), an attacker might trick the client into sending a code intended for Google to the attacker's server. Strict Redirect URI matching combined with the `state` parameter and **PKCE** helps mitigate this.

### Referrer Leakage
If the page located at `https://myapp.com/callback` contains external assets (like images or analytics scripts hosted on third-party sites), the browser might send the URL (containing the `code`) in the `Referer` [sic] header to those third parties.
*   **Mitigation:** The Callback Endpoint should immediately process the code, clear the URL bar (using `history.replaceState`), or ensure it has a `Referrer-Policy: no-referrer` header.

## Summary Checklist for Developers

When implementing the Callback Endpoint:
1.  **Register strictly:** Only register the exact URL you need (e.g., `https://api.myapp.com/oauth/callback`).
2.  **Use HTTPS:** Never use HTTP for redirect URIs in production.
3.  **Process Quickly:** Exchange the code for a token immediately on the backend.
4.  **Sanitize History:** Don't leave the `?code=...` sitting in the user's browser address bar history.
5.  **Use PKCE:** Even if your Redirect URI is hijacked, without the PKCE Code Verifier, the intercepted code is useless to the attacker.
