Based on the Table of Contents you provided, **Section 39: Migration Strategies** is a critical chapter. It moves away from *how* OIDC works and focuses on *how to adopt it* when you already have an existing system.

Moving to OpenID Connect (OIDC) is rarely a "greenfield" (start from scratch) project. Most often, developers are tasked with modernizing a legacy system.

Here is a detailed explanation of the three pillars mentioned in that section.

---

### 1. Migrating from SAML to OIDC

**The Scenario:**
Your enterprise uses SAML 2.0 (Security Assertion Markup Language). SAML is robust but old. It uses heavy XML payloads, relies heavily on browser redirects (making it hard to use with Mobile Apps or SPAs), and is difficult to debug. You want to switch to OIDC for its JSON-based, mobile-friendly nature.

**The Strategy: The "Bridge" or "Broker" Pattern**
You rarely rewrite all applications to switch from SAML to OIDC overnight. Instead, you use an Identity Broker (like Keycloak, Auth0, or IdentityServer).

*   **Step 1: The Gateway:** You set up an OIDC Provider (IdP) that acts as a "middleman."
*   **Step 2: Federation:** You configure the new OIDC IdP to trust the old SAML IdP.
*   **Step 3: The Translation:**
    1. The Client App (e.g., Mobile App) talks **OIDC** to the New IdP.
    2. The New IdP redirects the user to the Old SAML IdP for login.
    3. The Old SAML IdP returns an **XML Assertion**.
    4. The New IdP consumes the XML, maps the attributes (e.g., `urn:oid:email`) to JSON claims (`email`), and issues an **OIDC ID Token**.
*   **Result:** Your apps get modern OIDC tokens, but your user database remains in the legacy SAML system during the transition.

**Mapping Challenges:**
*   You must create a map between SAML Attributes (often complex URNs) and OIDC Standard Claims (`sub`, `email`, `given_name`).

---

### 2. Migrating from Custom Identity to OIDC

**The Scenario:**
You have a "Users" table in a SQL database. You built the login screen yourself years ago. You hash passwords using MD5 or SHA1 (which are now insecure), or maybe bcrypt. You use standard HTTP Sessions (cookies). You want to move to a managed OIDC Provider (like Okta, Cognito, or Auth0) to offload security risks.

**The Major Hurdle:**
You cannot simply move the users to the new system because **you cannot decrypt their passwords**. You cannot import them into the new system because you don't know the plain text password to hash it into the new format.

**Strategy A: Password Reset (The "Nuclear" Option)**
*   Import all user emails to the new system.
*   Email every user: "We have updated our security. Please click here to reset your password."
*   *Pros:* Clean slate, secure.
*   *Cons:* High user friction; you will lose users who can't be bothered to reset.

**Strategy B: Lazy Migration (Just-In-Time / JIT provisioning)**
This is the preferred pattern for seamless migration.
1.  **The Trigger:** User attempts to log in to the new OIDC login page.
2.  **The Check:** The new IdP sees the user doesn't exist (or has no password set locally).
3.  **The Hook:** The IdP triggers a background script/webhook to your **Legacy Database**.
4.  **Verification:** The script checks the credentials against the old database.
5.  **Migration:** If the legacy credentials are correct, the script:
    *   Returns "Success" to the IdP.
    *   The IdP saves the user (and hashes the password into the *new* format) in its own database.
6.  **Completion:** The user is logged in. Next time, the IdP handles it natively. The legacy DB is no longer needed for that user.

---

### 3. Gradual Rollout Strategies

You should avoid a "Big Bang" migration (switching everything off and on at once). If it fails, your entire business stops.

Here are the patterns for gradual migration:

#### A. The "Strangler Fig" Pattern
Named after a vine that grows around a tree and eventually replaces it.
*   You have 10 applications.
*   You migrate **one** application to OIDC. The others stay on the legacy auth.
*   Once that is stable, you migrate the next.
*   *Requirement:* Your users might have to log in twice (once for old apps, once for new apps) unless you implement a "Session Sharing" mechanism between the old and new systems (complex but doable).

#### B. The API Gateway Facade
If you have backend APIs relying on legacy mechanics (like looking up a Session ID in a database):
1.  Implement an API Gateway (like Kong or Apigee).
2.  Update your Frontend to send OIDC Access Tokens.
3.  The Gateway validates the Token.
4.  The Gateway **injects** the legacy headers/cookies required by the backend services.
5.  The backend services don't know anything changed.
6.  Over time, you update the backends to accept Tokens natively.

#### C. Dual-Stack Support
Modify your application to accept **both** mechanisms for a short time.
*   *Logic:*
    ```python
    if request.has_header("Authorization: Bearer ..."):
        validate_oidc_token()
    elif request.has_cookie("JSESSIONID"):
        validate_legacy_session()
    else:
        return 401 Unauthorized
    ```
*   This allows you to roll out the frontend changes slowly (e.g., to 10% of users) without breaking the backend.

### Summary Checklist for Migration

1.  **Inventory:** List all apps and APIs relying on the old identity.
2.  **User Migration:** Decide between Bulk Import (if possible), Password Reset, or JIT Migration.
3.  **Protocol Translation:** Do you need to support SAML and OIDC simultaneously?
4.  **Rollout:** Pick an app to be the "Canary" (the first test case) before rolling out to the rest.
