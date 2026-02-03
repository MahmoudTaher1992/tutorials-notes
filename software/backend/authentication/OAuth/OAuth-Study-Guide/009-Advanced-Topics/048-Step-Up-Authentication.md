Here is a detailed explanation of Part 9, Item 48: **Step-Up Authentication**.

---

# 48. Step-Up Authentication

Step-Up Authentication is a security pattern where an application requires a user to upgrade their current authentication level to access a specific resource. Instead of forcing the user to perform strong authentication (like MFA) immediately upon login, the application allows a "frictionless" login for general access but demands "strong" credentials only when the user attempts a sensitive action (like transferring money or changing a password).

This topic sits at the intersection of OAuth 2.0 and OpenID Connect (OIDC).

## 1. The Core Concept
In a standard session, a user logs in once. However, not all data is equally sensitive.
*   **Low Risk:** Viewing a profile picture.
*   **High Risk:** Initiating a wire transfer.

Step-Up authentication allows you to grant a "weak" Access Token (e.g., obtained via Password only) initially. When the user hits the High Risk API, the API rejects the token, signaling that the user needs to "Step Up." The client then sends the user back to the Authorization Server to perform Multi-Factor Authentication (MFA), returning with a "strong" Access Token.

---

## 2. ACR Values (Authentication Context Class Reference)
To implement Step-Up, the Authorization Server (AS) and the Resource Server (RS) need a common language to define "how secure" a token is. This is done using **ACR**.

*   **Definition:** ACR stands for **Authentication Context Class Reference**. It is a string value (often a URI or a simple code) that identifies the method and strength of the authentication used to issue the token.
*   **Where it lives:** It appears as a claim (`acr`) inside the ID Token (and often the Access Token).

### Examples of ACR Values
Usage varies by provider, but they generally map to Levels of Assurance (LoA):
*   `acr: level1` (or `urn:example:bronze`): User authenticated via Password only.
*   `acr: level2` (or `urn:example:silver`): User authenticated via Password + SMS OTP.
*   `acr: level3` (or `urn:example:gold`): User authenticated via Hardware Key (FIDO2/WebAuthn).

### How to request it
When the Client initiates the specific Step-Up authorization request, it uses the optional `acr_values` parameter:
```http
GET /authorize?
  response_type=code
  &client_id=my-client
  &scope=openid payment_write
  &acr_values=urn:example:gold
```
This tells the Authorization Server: *"Don't just log them in; ensure they authenticate with the 'gold' standard."*

---

## 3. Insufficient User Authentication Response
This describes the mechanism by which the API (Resource Server) tells the Client App that the current token is not good enough.

**The Workflow:**
1.  **Request:** The Client sends a request to a sensitive endpoint (e.g., `/api/transfer`) with a valid Access Token.
2.  **Validation:** The API inspects the Access Token. It sees the token is valid, **BUT** the `acr` claim is `level1`. The endpoint requires `level2`.
3.  **Rejection:** The API returns a **401 Unauthorized** or **403 Forbidden** error. Crucially, it includes a `WWW-Authenticate` header with specific details.

**Specific Standards (RFC 9470):**
A standardized way for the API to signal this is via the `insufficient_user_authentication` error code.

```http
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Bearer error="insufficient_user_authentication",
                  acr_values="urn:example:silver urn:example:gold"
```

This tells the developer/client: *"The token is valid, but the user didn't authenticate strongly enough. Please go back and get a token with 'silver' or 'gold' assurance."*

---

## 4. Re-Authentication Flows
Once the Client receives the "Insufficient Authentication" error, it must trigger a new flow to upgrade the session.

1.  **Catch the Error:** The frontend application intercepts the 401 error.
2.  **Redirect:** The app redirects the browser to the Authorization Server's `/authorize` endpoint.
3.  **Includes Hint:** The redirect URL includes the `acr_values` requested by the API.
4.  **User Interaction:**
    *   The AS recognizes the user has an existing session (cookie).
    *   The AS checks the current session's ACR (`level1`).
    *   The AS sees the request requires `level2`.
    *   **The Step-Up:** Instead of asking for the password again, the AS **only** prompts for the second factor (e.g., "Enter the code sent to your phone").
5.  **New Token:** After successful MFA, the AS issues a *new* Access Token containing `acr: level2`.
6.  **Retry:** The Client receives the new token and retries the API request to `/api/transfer`. This time, it succeeds.

---

## 5. The `max_age` Parameter
Step-Up is about **strength** of authentication. `max_age` is about **freshness** (recency) of authentication.

Sometimes, it doesn't matter if the user has MFA; if they logged in 5 hours ago, you might not want them changing their password or viewing credit card details without checking it's still them.

*   **Definition:** The `max_age` parameter (in the Authorization Request) specifies the maximum allowable time (in seconds) since the last active user authentication occurred.
*   **Behavior:**
    *   Client sends: `GET /authorize?...&max_age=300` (5 minutes).
    *   The Authorization Server checks the user's "Last Login Time".
    *   If the user logged in 1 hour ago, even if their session is active, the AS considers it "stale."
    *   **The Result:** The AS forces the user to re-enter their credentials (re-authenticate) to prove they are still present at the keyboard.
*   **The Token:** The resulting ID Token will include an `auth_time` claim indicating when the authentication occurred. The Client/API can validate this claim to ensure the data is fresh.

### Summary Comparison

| Feature | Concept | Use Case |
| :--- | :--- | :--- |
| **Standard Auth** | Who are you? | Logging in to see the dashboard. |
| **Step-Up (ACR)** | How strongly did you prove it? | Moving money, Admin functions. |
| **Freshness (max_age)** | Are you still there right now? | "Confirm password before continuing", Viewing CVC code. |
