Based on the Table of Contents you provided, the section **`012-Appendices/003-Error-Codes.md`** serves as a technical reference manual for solving problems when things go wrong during the OpenID Connect (OIDC) flow.

Since OIDC is built on top of OAuth 2.0, this appendix would contain a comprehensive list of standard error codes defined by **RFC 6749 (OAuth 2.0)** and **OIDC Core specifications**.

Here is a detailed explanation of what that file covers, broken down by where the errors occur.

---

### 1. Why this Appendix is important
In OIDC, errors are not just HTTP Status Codes (like 404 or 500). They are specific text strings (e.g., `invalid_grant`) returned in the URL or the JSON body. A developer needs this mapping to:
*   Show the correct error message to the user (e.g., "Login Failed" vs. "System Error").
*   Automate retries (e.g., if a token expired).
*   Debug integration issues during development.

---

### 2. Authorization Endpoint Errors
These errors happen when the user is sent to the Identity Provider (IdP) to log in, but something goes wrong *before* or *during* the user's interaction.
*   **Where they appear:** In the URL query parameters upon redirect back to your app (e.g., `https://yourapp.com/callback?error=access_denied`).

| Error Code | Meaning | Common Cause / Developer Action |
| :--- | :--- | :--- |
| **`invalid_request`** | The request is missing a required parameter or is malformed. | You likely forgot the `client_id`, `response_type`, or `redirect_uri` in your initial request. |
| **`unauthorized_client`** | The client is not authorized to use this method. | You are trying to use an authentication flow (like Implicit) that is disabled in the IdP settings for your app. |
| **`access_denied`** | The resource owner (user) or authorization server denied the request. | **Most Common:** The user clicked "Cancel" on the consent screen. Your app should handle this gracefully (don't crash). |
| **`unsupported_response_type`** | The server doesn't support obtaining an authorization code using this method. | You requested `response_type=token` but the server only supports `code`. |
| **`invalid_scope`** | The requested scope is invalid, unknown, or malformed. | You asked for a permission (e.g., `write:admin`) that doesn't exist or your client isn't allowed to ask for. |
| **`server_error`** | The auth server encountered an unexpected condition. | The IdP is down or having internal issues. Try again later. |
| **`temporarily_unavailable`** | The auth server is currently unable to handle the request. | The IdP is overloaded or under maintenance. |

---

### 3. OIDC-Specific Authorization Errors
OIDC adds specific requirements, particularly regarding "Silent Authentication" (checking if a user is logged in without showing a UI).

| Error Code | Meaning | Common Cause / Developer Action |
| :--- | :--- | :--- |
| **`interaction_required`** | The auth server requires user interaction. | You sent `prompt=none` (silent auth), but the user is not logged in or needs to consent. You must redirect them transparently to the login page. |
| **`login_required`** | The auth server requires user authentication. | Similar to above; the user session has expired at the IdP. |
| **`account_selection_required`** | The user needs to select a session. | The user has multiple Google/Microsoft accounts logged in, and the system doesn't know which one to use for your app. |

---

### 4. Token Endpoint Errors
These errors happen "back-channel" (server-to-server) when your application tries to exchange an Authorization Code for an Access Token or ID Token.
*   **Where they appear:** In the JSON body of the HTTP 400 Bad Request response.

| Error Code | Meaning | Common Cause / Developer Action |
| :--- | :--- | :--- |
| **`invalid_request`** | The request is missing a parameter or includes an unsupported parameter value. | You forgot to send the `grant_type` or formatted the POST body incorrectly. |
| **`invalid_client`** | Client authentication failed. | **Most Common:** Wrong `client_id` or `client_secret`. |
| **`invalid_grant`** | The provided authorization grant or refresh token is invalid, expired, revoked, or used previously. | **Crucial:** 1. The Authorization Code expired (usually subsists for only 30-60 secs).<br>2. You are trying to reuse a code (Replay Attack protection).<br>3. The Refresh Token is old/revoked. |
| **`unauthorized_client`** | The client is not authorized to use this grant type. | Your app is trying to use `grant_type=client_credentials` but is registered as a Public Client. |
| **`unsupported_grant_type`** | The authorization grant type is not supported. | The server doesn't allow the flow you are attempting. |
| **`invalid_scope`** | The requested scope is invalid. | The scope requested currently differs from what was authorized by the user earlier. |

---

### 5. Bearer Token Errors (Resource Server)
These errors happen when you try to *use* the Access Token to fetch data from an API.
*   **Where they appear:** `WWW-Authenticate` HTTP Header.

| Error Code | Meaning | Common Cause / Developer Action |
| :--- | :--- | :--- |
| **`invalid_token`** | The access token provided is expired, revoked, malformed, or invalid. | The token expired. You need to use a Refresh Token or send the user to log in again. |
| **`insufficient_scope`** | The request requires higher privileges than provided. | The token is valid, but the user doesn't have permission to do *this specific action* (e.g., a Read-Only user trying to Delete). |

### Summary of How to Use This Appendix
If you were studying this guide, you would use Appendix C to write your **Error Handling Logic**:
1.  **If `access_denied`**: Take user back to the homepage with a message "Login canceled."
2.  **If `interaction_required`**: Redirect the user to the full login page.
3.  **If `invalid_grant`**: Clear the localized session and force a fresh login (because the refresh token is dead).
