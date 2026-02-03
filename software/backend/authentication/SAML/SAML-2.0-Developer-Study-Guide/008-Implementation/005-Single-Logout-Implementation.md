Based on the Table of Contents you provided, specifically item **53. Single Logout Implementation** in Part 8, here is a detailed explanation of the logic, architecture, and coding requirements needed to implement SAML 2.0 Single Logout (SLO).

---

# 008-Implementation / 005-Single-Logout-Implementation

## Overview
Single Logout (SLO) is the most complex part of the SAML ecosystem. While Single Sign-On (SSO) sets up a session, SLO aims to securely terminate that session across the Identity Provider (IdP) and **all** Service Providers (SPs) the user accessed during that session.

If a user logs into Google (IdP), then accesses Salesforce (SP1) and Slack (SP2), clicking "Logout" in Salesforce should ideally log them out of Slack and Google as well.

---

## 1. The Core Flows

There are two primary ways SLO is triggered.

### A. SP-Initiated Logout
The user clicks "Logout" within a specific application (e.g., Salesforce).

**The Workflow:**
1.  **User Trigger:** User clicks "Logout" at the SP.
2.  **SP Action:** The SP terminates its own local session.
3.  **SP Request:** The SP generates a SAML `LogoutRequest` and sends it to the IdP (usually via HTTP Redirect).
4.  **IdP Action:** The IdP verifies the request, terminates its own session, and looks up which *other* SPs are active.
5.  **Propagation:** The IdP sends `LogoutRequest` messages to all other active SPs (e.g., Slack).
6.  **Other SP Responses:** The other SPs terminate their sessions and send `LogoutResponse` messages back to the IdP.
7.  **Final Response:** The IdP sends a final `LogoutResponse` back to the initiating SP.
8.  **Completion:** The initiating SP displays a "You have been logged out" page.

### B. IdP-Initiated Logout
The user clicks "Logout" at the IdP dashboard (e.g., the Okta or Azure AD portal).

**The Workflow:**
1.  **User Trigger:** User clicks "Logout" at the IdP.
2.  **IdP Action:** The IdP terminates its own session.
3.  **Propagation:** The IdP iterates through all SPs participating in the current session.
4.  **Requests:** The IdP sends a `LogoutRequest` to SP1, SP2, SP3, etc.
5.  **Responses:** Each SP terminates its local session and sends a `LogoutResponse` to the IdP.
6.  **Completion:** The IdP displays a final status report (e.g., "Logged out of App A, App B...").

---

## 2. Session Tracking Requirements

To make SLO work, you cannot simply authenticate the user and forget them. Both parties must maintain state.

### The `SessionIndex`
The critical link in SLO is the `SessionIndex`.
- When the IdP initiates SSO, it includes a `SessionIndex` in the `<AuthnStatement>`.
- **SP Requirement:** The SP must store this `SessionIndex` (usually in a database or encrypted cookie) alongside the user's local session ID/Cookie.
- **IdP Requirement:** The IdP must store a list of all SPs (EntityIDs) associated with that specific `SessionIndex`.

**Why?** When a `LogoutRequest` comes in, it doesn't say "Log out User ID 5." It says "Log out the principal associated with `SessionIndex` 12345."

### Implementation Data Structure
**IdP Session Store Example:**
```json
{
  "globalSessionId": "xyz-123",
  "principal": "john.doe@example.com",
  "sessionIndex": "idx-999",
  "participatingSPs": [
    "https://salesforce.com/sp",
    "https://slack.com/sp"
  ]
}
```

**SP Session Store Example:**
```json
{
  "localCookieId": "abc-local-cookie",
  "samlSessionIndex": "idx-999",
  "nameID": "john.doe@example.com"
}
```

---

## 3. The Protocol Messages

### The LogoutRequest (XML)
Whether sent by SP or IdP, the structure is roughly the same:

```xml
<samlp:LogoutRequest xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol"
                     xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion"
                     ID="_123456789"
                     Version="2.0"
                     IssueInstant="2023-10-27T10:00:00Z"
                     Destination="https://idp.example.com/slo">
    <saml:Issuer>https://sp.example.com</saml:Issuer>
    <saml:NameID Format="urn:oasis:names:tc:SAML:2.0:nameid-format:persistent">john.doe</saml:NameID>
    <samlp:SessionIndex>idx-999</samlp:SessionIndex>
</samlp:LogoutRequest>
```
**Key Implementation Detail:** You **must** validate the signature of this request to prevent Denial of Service (DoS) attacks where an attacker forces users to log out.

### The LogoutResponse (XML)
Acknowledgment that the logout happened.

```xml
<samlp:LogoutResponse ID="_987654321" Version="2.0" ...>
    ...
    <samlp:Status>
        <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
    </samlp:Status>
</samlp:LogoutResponse>
```

---

## 4. Handling Partial Logout

In a perfect world, all SPs log out successfully. In reality, networks fail, servers go down, or browsers block redirects.

**The Scenario:**
User logs out. IdP tries to log out SP1 (Success) and SP2 (Timeout/Fail).

**Implementation Logic:**
1.  **IdP Strategy:** The IdP usually sends requests to SPs asynchronously or sequentially.
2.  **Failure Handling:** If SP2 fails to respond, the IdP often marks it as a "Partial Logout."
3.  **User Notification:** The final page shown to the user should explicitly state:
    > "You have been logged out of Salesforce. However, we could not confirm logout from Slack. Please close your browser to ensure security."

**Warning:** Do not stop the logout process just because one SP failed. Continue to the next one in the list.

---

## 5. User Experience (UX) Design

SLO is disruptive. You are redirecting the user away from their current page through a chain of other pages.

1.  **The "Spinner" Page:** When the IdP is contacting other SPs, it often renders a page showing progress (e.g., "Logging you out of application A... Done. logging out of B...").
2.  **iframe Approach:** Some IdPs (like Okta) use hidden HTML iframes to trigger the `LogoutRequest` to SPs in the background to avoid full-page redirects. This is cleaner but can be blocked by modern browser privacy settings (Third-Party Cookie blocking).
3.  **The Final Landing:**
    *   If SP-Initiated: The IdP should redirect back to the SP’s `RelayState` URL (e.g., the SP's homepage).
    *   If IdP-Initiated: The IdP stays on its own login page.

---

## 6. Timeout Handling

This refers to **session expiration**, not network timeouts.

**Passive Logout (Implementation Challenge):**
If the SP session is set to expire in 30 minutes, but the IdP session lasts 8 hours:
*   **Case A:** User is idle in SP for 31 mins. SP kills local session. User is redirected to IdP. IdP sees user is still valid, immediately issues new SAML token. User effectively never logs out.
*   **Case B (SLO Integration):** User is idle at IdP (e.g., lunch break). IdP session dies.
    *   *Ideal:* IdP should send a "System Logout" signal to all SPs.
    *   *Reality:* This is hard because the user isn't actively browsing the IdP, so the IdP cannot use the user's browser to send redirects.
    *   *Solution:* This requires a "Back-Channel" binding (Server-to-Server SOAP call) rather than Redirection.

---

## 7. Implementation Checklist

### For the SP Developer:
1.  [ ] **Store SessionIndex:** Modify the login handler to save the `SessionIndex` from the SAML assertion.
2.  [ ] **Endpoint:** Create a `/slo/callback` endpoint to handle inbound `LogoutRequest` (from IdP) and `LogoutResponse` (confirmation).
3.  [ ] **Validation:** Ensure the `LogoutRequest` signature is valid and matches the IdP's certificate.
4.  [ ] **Cleanup:** Ensure the code actually destroys the application cookie/session and CSRF tokens.

### For the IdP Developer:
1.  [ ] **Session Tracking:** Database must map `SessionIndex` → `[List of SP EntityIDs]`.
2.  [ ] **Propagation Logic:** Logic to iterate through that list and fire requests.
3.  [ ] **Wait Logic:** Logic to wait for responses (with a short timeout, e.g., 3 seconds per SP) before moving to the next.
4.  [ ] **Status UI:** Build a UI to inform the user of success/partial failure.
