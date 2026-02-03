Based on **Item 55** of your Table of Contents, here is a detailed explanation of **Session Management** in the context of a SAML 2.0 implementation.

---

# 55. Session Management in SAML 2.0

Session management is one of the most misunderstood and complex aspects of SAML. Unlike monolithic applications where authentication and session storage happen in the same place, SAML operates in a distributed environment where the entity verifying identity (IdP) is separate from the entity hosting the application (SP).

Here is a breakdown of the critical components of SAML Session Management.

## 1. SP Session vs. IdP Session
In a Federated Identity model, there is no single "Global Session." Instead, there are two distinct, decoupled sessions created during a login flow.

### The IdP Session
*   **Creation:** Created when the user successfully authenticates with the Identity Provider (e.g., enters credentials, performs MFA).
*   **Purpose:** Maintains the user's logged-in state at the central authority. If the user navigates to a *different* Service Provider while this session is active, they will be logged in automatically (SSO) without re-entering credentials.
*   **Cookie:** The IdP sets its own domain cookies (e.g., `idp_session_id`).

### The SP Session
*   **Creation:** Created strictly **after** the SP receives and validates the SAML Assertion from the IdP.
*   **Purpose:** Grants access to the specific local application.
*   **Cookie:** The SP sets its own domain cookies (e.g., `JSESSIONID`, `PHPSESSID`, `ASP.NET_SessionId`).

### The Decoupling Problem
Once the SAML Assertion is consumed and the SP session is created, the two sessions generally live independently.
*   If the user closes the SP tab, the IdP session usually remains alive.
*   If the IdP session times out, the SP session usually remains alive until its own local timeout triggers.

## 2. Session Index Tracking
To bridge the gap between these two independent sessions, SAML 2.0 uses an identifier called the **Session Index**.

When an IdP issues an assertion, it includes an `AuthnStatement` within the XML. This statement contains a `SessionIndex` attribute.

**Example XML:**
```xml
<saml:AuthnStatement 
    AuthnInstant="2023-10-27T10:00:00Z" 
    SessionIndex="_b796522c-8c76-4700-a612-9856372ec0a1">
    <saml:AuthnContext>
        <saml:AuthnContextClassRef>
            urn:oasis:names:tc:SAML:2.0:ac:classes:Password
        </saml:AuthnContextClassRef>
    </saml:AuthnContext>
</saml:AuthnStatement>
```

### Implementation Requirement
The Service Provider **must** store this `SessionIndex` (usually in a database or in the user's session data) alongside the `NameID` and the local Session ID.

**Why?**
If the IdP sends a **Logout Request** (Single Logout), it will typically send the `SessionIndex`. The SP uses this index to look up which local session to invalidate. Without tracking the `SessionIndex`, the SP cannot perform specific logouts.

## 3. Session Timeout Strategies
Because sessions are decoupled, you must decide how to handle timeouts.

### Strategy A: Local SP Timeout (Most Common)
The SP ignores the IdP's state after login.
*   **Configuration:** The SP uses standard web app timeouts (e.g., "Log out after 30 minutes of inactivity").
*   **Pros:** Simple to implement.
*   **Cons:** If the user is disabled at the IdP, they assume they still have access until the SP session naturally expires.

### Strategy B: SessionDerived from Assertion (SessionNotOnOrAfter)
The IdP can include a `SessionNotOnOrAfter` attribute in the `AuthnStatement`.
*   **Logic:** The SP inspects this timestamp and forces the local session to expire at that specific time, regardless of user activity.
*   **Usage:** Often used in high-security banking or healthcare apps where sessions must not exceed a specific duration (e.g., 15 minutes).

### Strategy C: "Keep Alive" / Passive Checks
The SP periodically checks if the user is still logged into the IdP.
*   **Mechanism:** The SP redirects the user to the IdP with `IsPassive="true"`.
    *   If the IdP session is alive, it instantly returns a new SAML Response.
    *   If the IdP session is dead, it returns an error/failure, and the SP kills the local session.
*   **Pros:** Tighter security; syncs SP and IdP states.
*   **Cons:** Heavy traffic on the browser and the IdP.

## 4. Session Revocation
How do you immediately stop a user from accessing the app?

### SP-Initiated Revocation
The user clicks "Logout" in your app.
1.  **Local Logout:** You destroy the SP session cookies.
2.  **Federated Logout (Optional):** You redirect the user to the IdP's Single Logout (SLO) URL. This asks the IdP to kill its session and potentially notify other SPs (see Item 53 in your TOC).

### IdP-Initiated Revocation
An administrator bans a user, or the user logs out from a dashboard.
1.  The IdP sends a SAML `LogoutRequest` to the SP's registered Single Logout Service (SLS) endpoint.
2.  **Implementation:**
    *   The SP receives the XML.
    *   Parses the `NameID` and `SessionIndex`.
    *   Finds the corresponding server-side session.
    *   Destroys it.

**Critical Note:** If you are using stateless sessions (e.g., JWTs stored in browser cookies) without a server-side database validation, **IdP-Initiated Revocation is nearly impossible** because the server cannot reach into the user's browser to delete the JWT.

## 5. Concurrent Session Handling
SAML accounts for scenarios where a user logs in from multiple devices (Laptop, Phone, Tablet) simultaneously.

*   **Different Session Indices:** Usually, every time a user logs in, the IdP generates a *new* `SessionIndex`.
    *   *Login 1 (Laptop):* `SessionIndex="...A1"`
    *   *Login 2 (Phone):* `SessionIndex="...B2"`
*   **SP Implementation:**
    *   Your SP must be able to map a single `NameID` (User ID) to *multiple* active sessions/Session Indices.
    *   If a logout request comes for `...A1`, you must only kill the Laptop session, leaving the Phone session active (unless the IdP requests a global logout).

### Security Risk: Session Fixation
Implementing SAML does not automatically protect you from Session Fixation.
*   **The Attack:** An attacker tricks a victim into authenticating using a session ID known to the attacker.
*   **The Fix:** Upon successfully validating the SAML Assertion, the SP implementation **must always regenerate the local Session ID**. Never attach the authenticated user state to the anonymous session ID they had before logging in.

---

### Implementation Checklist for Developers

1.  [ ] **Store `SessionIndex`:** Ensure your user object or session storage saves the `SessionIndex` from the `AuthnStatement`.
2.  [ ] **Store `NameID`:** Save the persistent identifier (Subject).
3.  [ ] **Regenerate ID:** Cycle the session ID immediately after processing the SAML Response to prevent fixation.
4.  [ ] **Define Timeout:** explicitly set your local application idle timeout.
5.  [ ] **Handle SLO (Optional but recommended):** Build an endpoint to accept `LogoutRequest` messages, look up the session by `SessionIndex`, and destroy it.
