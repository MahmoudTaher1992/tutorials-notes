Based on Part 12, item #70 of the Table of Contents, here is a detailed explanation of **Password Management** within the context of the SCIM 2.0 protocol.

In modern identity management, syncing passwords between systems is generally discouraged in favor of Single Sign-On (SSO) protocols like SAML or OIDC. However, there are legacy systems or specific use cases where an Identity Provider (IdP) must push a password to a Service Provider (SP). SCIM 2.0 provides a standardized mechanism for this.

---

### 1. Password Attribute Handling

In the SCIM Core User Schema (`urn:ietf:params:scim:schemas:core:2.0:User`), there is a specific attribute defined simply as `password`.

*   **Type:** String.
*   **Purpose:** It is intended to hold the clear-text password of the user.
*   **Transmission Security:** Because this attribute holds a clear-text password, SCIM **mandates** the use of transport layer security (HTTPS/TLS). Sending a SCIM request with a password over HTTP is a critical security vulnerability.

**Example Request (Creating a user with a password):**
```json
POST /Users
{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"],
  "userName": "bjensen",
  "name": {
    "givenName": "Barbara",
    "familyName": "Jensen"
  },
  "password": "CorrectHorseBatteryStaple123!",
  "active": true
}
```

### 2. Write-Only Semantics

The most important security characteristic of the `password` attribute in SCIM is its **attribute definition**.

*   **Mutability:** `writeOnly`
*   **Returned:** `never`

This means that while a Client (the IdP) can **set** or **update** the password, the Service Provider (the App) will **never return** the password in a response.

*   If you perform a `GET /Users/{id}`, the JSON response will contain the `userName`, `emails`, etc., but the `password` field will be entirely absent.
*   Even if you specifically request it (?attributes=password), the server must ignore the request and not return it.
*   **Why?** This prevents an administrator or a compromised client application with "Read" access from harvesting user passwords from the API.

### 3. Password Sync Strategies

When implementing SCIM, organizations usually choose one of three strategies regarding this attribute:

#### A. No Password Sync (Best Practice)
The SCIM client creates the user but **omits** the password field entirely.
*   **Authentication:** The application relies on SAML or OIDC (SSO) for authentication.
*   **Benefits:** No secrets are transmitted; improved security.

#### B. Initial Random Password
The SCIM client generates a high-entropy random password when creating the user (`POST`), but never updates it later.
*   **Use Case:** The application requires a password to exist in its database to activate the account, even if the user primarily uses SSO.
*   **Security:** Users do not know this password and cannot use it.

#### C. Continuous Synchronization
The SCIM client pushes password updates whenever the user changes their password in the central directory (AD/LDAP).
*   **Mechanism:** The IdP sends a `PATCH` or `PUT` request containing the new password.
*   **Risk:** High. This exposes credentials to the target application. If the target app is compromised, the user's main directory password is compromised.

### 4. Password Policy Integration

A major challenge in SCIM password management is dealing with the Service Provider's local password policies (complexity, length, history).

*   **The Conflict:** The IdP might allow a 6-character password, but the SP requires 12 characters + special symbols.
*   **Handling Errors:** If the IdP tries to push a password that violates the SP's policy, the SCIM SP should return an HTTP **400 Bad Request**.
*   **The SCIM Error Message:**
    ```json
    {
      "schemas": ["urn:ietf:params:scim:api:messages:2.0:Error"],
      "status": "400",
      "scimType": "invalidValue",
      "detail": "Password does not meet complexity requirements: must include a special character."
    }
    ```
*   **Discovery:** The `/ServiceProviderConfig` endpoint has a flag called `changePassword`. If `true`, the SP supports password changes. However, SCIM does not currently have a standard way for the SP to programmatically publish its exact complexity rules (regex, length) to the Client.

### 5. Self-Service Password Reset (SSPR)

SCIM plays a specific role in SSPR workflows to keep systems in sync.

1.  **User Forgets Password:** The user initiates a reset at the Identity Provider (e.g., Okta, Azure AD).
2.  **Validation:** The user verifies their identity via SMS/Email/MFA.
3.  **Directory Update:** The password is updated in the central directory.
4.  **SCIM Propagation:** If "Continuous Synchronization" is enabled, the IdP detects the change and immediately fires a SCIM `PATCH` request to all connected downstream applications to update the password there as well.

**Note:** If a user changes their password directly inside the Application (Service Provider), that change is **rarely** synced back to the IdP (SCIM is predominantly uni-directional). This causes "Password Drift," where the user has different passwords for the dashboard vs. the specific app. This is why apps usually remove the "Change Password" button if SCIM/SSO is active.
