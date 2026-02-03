Based on **Part 12: Advanced Topics, Section 73**, here is a detailed explanation of **Step-Up Authentication** within the context of SAML 2.0.

---

# 73. Step-Up Authentication in SAML

**Step-Up Authentication** is a security design pattern where an application requires a user to provide additional proof of identity to access sensitive resources, even if the user is already authenticated.

In a standard Single Sign-On (SSO) scenario, once a user logs in, they have a session. Step-Up allows a Service Provider (SP) to say, "I know you are logged in, but for *this specific action*, I need you to authenticate again using a stronger method."

Here is the breakdown of the specific components listed in your Table of Contents:

### 1. Authentication Context Requests
This is the primary mechanism SAML uses to trigger Step-Up authentication. It relies on the `<RequestedAuthnContext>` element within the SAML Authentication Request (`AuthnRequest`).

*   **The Concept:** When an SP initiates a login, it can explicitly tell the Identity Provider (IdP) *how* the user must be authenticated.
*   **The Problem:** By default, if a user has an active session at the IdP (logged in via password 10 minutes ago), the IdP will just send back a "Success" assertion without challenging the user.
*   **The Solution:** The SP sends a `RequestedAuthnContext` containing specific **SAML Authentication Context Class References (ACR)**. This tells the IdP the *level of assurance* (LOA) required.

**Example XML snippet:**
```xml
<samlp:AuthnRequest ... >
    <samlp:RequestedAuthnContext Comparison="exact">
        <!-- Requesting a Time-Based One-Time Password or Hardware Token -->
        <saml:AuthnContextClassRef>
            urn:oasis:names:tc:SAML:2.0:ac:classes:TimeSyncToken
        </saml:AuthnContextClassRef>
    </samlp:RequestedAuthnContext>
</samlp:AuthnRequest>
```

If the user only logged in with a Password (`...ac:classes:Password`), the IdP sees this request for `TimeSyncToken`, realizes the current session isn't strong enough, and prompts the user for the second factor.

### 2. Forcing Re-Authentication (`ForceAuthn`)
Sometimes, the issue isn't the *method* of authentication (e.g., password vs. MFA), but the *freshness* of the authentication.

*   **The Scenario:** A user logs into a banking portal. They walk away to get coffee. They return 15 minutes later and click "Transfer Funds." The session is still active, but the bank wants to ensure it is actually the user sitting there, not a colleague who jumped on the unlocked computer.
*   **The Mechanism (`ForceAuthn="true"`):** The SP sets the `ForceAuthn` attribute to `true` in the `AuthnRequest`.
*   **The Result:** The IdP **must** challenge the principal (user) to re-enter their credentials, even if they have a valid, active session. The IdP disregards the existing session cookie for the purpose of this specific validation.

**Example:**
```xml
<samlp:AuthnRequest ForceAuthn="true" ... >
```

### 3. MFA Step-Up Flows
This combines the previous concepts to create a tiered security experience. This is crucial for user experience (UX). You don't want to force users to use Multi-Factor Authentication (MFA) just to read a newsletter, but you do want MFA if they are changing their salary information.

**The Workflow:**
1.  **Low Friction:** The User accesses the application. The SP sends a standard SAML request. The IdP authenticates the user with a **Username/Password**. The user enters the app.
2.  **Sensitive Action:** The User clicks "Admin Settings."
3.  **Step-Up Trigger:** The SP generates a *new* SAML `AuthnRequest`.
    *   It includes a `<RequestedAuthnContext>` specifying an MFA class reference (e.g., `...ac:classes:X509` or a custom URI like `...ac:classes:mfa`).
4.  **IdP Logic:**
    *   The IdP checks the user's current session.
    *   It sees the user is authenticated via Password (LoA 1).
    *   It sees the request requires MFA (LoA 2).
    *   **The Step-Up:** The IdP challenges the user *only* for the missing factor (e.g., "Please enter the code from your phone").
5.  **Success:** The IdP sends a new SAML Response confirming the user is now authenticated with the higher context. The SP grants access to the Admin Settings.

### 4. Risk-Based Authentication
This is the most advanced variation. Instead of static rules (Page A = Password, Page B = MFA), the authentication requirements change dynamically based on context and heuristics.

*   **Behavior:** The SP and IdP evaluate the context of the login attempt.
    *   *Location:* Is the user logging in from their usual office IP or from a foreign country?
    *   *Device:* Is this a known laptop or a new browser?
    *   *Time:* Is this login happening at 3:00 AM?
*   **Implementation in SAML:**
    *   Usually, the decision logic sits at the **IdP**.
    *   The SP might send a generic request. The IdP evaluates the risk score.
    *   If the risk is **Low**: The IdP allows password-only access.
    *   If the risk is **High**: The IdP halts the flow and performs a **Step-Up** (forcing MFA or email verification) before returning the SAML Response.
    *   The IdP then includes the authentication method used in the `AuthnContext` of the response so the SP knows that a high-security check was performed.

### Summary of Differences

| Feature | Goal | Mechanism |
| :--- | :--- | :--- |
| **AuthnContext Request** | Ensure a specific *type* of credential (e.g., Smartcard). | `<RequestedAuthnContext>` |
| **ForceAuthn** | Ensure the user is *currently* present (re-enter password). | `ForceAuthn="true"` attribute |
| **MFA Step-Up** | Move from Low Security to High Security seamlessly. | IdP checks existing session vs. Requested Context. |
| **Risk-Based** | Dynamic security based on behavior/environment. | IdP logic triggers Step-Up based on heuristics. |
