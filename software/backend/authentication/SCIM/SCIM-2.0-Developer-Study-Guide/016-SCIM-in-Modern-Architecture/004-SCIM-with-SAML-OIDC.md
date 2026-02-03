Based on the Table of Contents provided, here is a detailed explanation of **Section 4: SCIM with SAML/OIDC** within Part 16 (SCIM in Modern Architecture).

---

# SCIM with SAML/OIDC

In modern Identity and Access Management (IAM), SCIM is rarely used in isolation. It almost always works alongside an authentication protocol like **SAML (Security Assertion Markup Language)** or **OIDC (OpenID Connect)**.

While SAML and OIDC handle the "Front Door" (letting the user in), SCIM handles the "HR Department" (creating the file, updating the role, and terminating the contract).

Here is the detailed breakdown of the four sub-topics listed in your Table of Contents:

## 1. Combined Architecture
This section explains how Authentication (SAML/OIDC) and Provisioning (SCIM) coexist within a software stack without conflicting.

*   **The Division of Responsibility:**
    *   **SAML/OIDC (Authentication & Authorization):** Handles the **User Experience**. It verifies who the user is (Identity) and logs them into the application during a browser session. It is a synchronous, user-initiated action.
    *   **SCIM (Lifecycle Management):** Handles the **Backend Logistics**. It creates accounts, syncs profile updates, and deletes accounts. It is an asynchronous, system-initiated action (Server-to-Server).
*   **The Architecture Pattern:**
    *   The **Identity Provider (IdP)** (e.g., Okta, Azure AD) acts as the central hub.
    *   **Channel A (Back-Channel):** The IdP talks directly to the Application’s SCIM API to sync data. The user does not see this.
    *   **Channel B (Front-Channel):** The User’s browser redirects between the IdP and the Application to establish a session via SAML or OIDC.

## 2. SSO + Provisioning Flow
This concept details the chronological workflow of how a user interacts with a system that has both SSO and SCIM enabled.

**The "Happy Path" Workflow:**

1.  **Day 0 (Pre-Boarding - SCIM):**
    *   An administrator adds "Alice" to the IdP.
    *   The IdP immediately triggers a SCIM `POST /Users` request to the Application.
    *   The Application creates Alice's account, creates her home folder, and assigns her permissions.
    *   *Note: Alice has not even turned on her computer yet.*
2.  **Day 1 (Login - SAML/OIDC):**
    *   Alice goes to the Application login page.
    *   She is redirected to the IdP, authenticates, and is sent back with a SAML Assertion or OIDC ID Token.
    *   The Application reads her ID (`NameID` or `sub`) from the token, matches it to the account created on Day 0, and grants access immediately.
3.  **Day 100 (Termination - SCIM):**
    *   Alice leaves the company. The admin deactivates her in the IdP.
    *   The IdP immediately sends a SCIM `PATCH` (setting `active: false`) or `DELETE` request.
    *   The Application terminates her session and invalidates her API keys.
    *   *Crucial:* Even if Alice still has a valid SAML token for the next hour, the Application blocks her because the SCIM signal updated her status to "inactive" in real-time.

## 3. JIT (Just-In-Time) Provisioning vs. SCIM
One of the most common architectural questions is: *"Why do I need SCIM if my SAML/OIDC token already contains the user's email and name? Can't I just create the user when they log in?"*

This is the comparison between **JIT Provisioning** (creating users via SSO tokens) and **SCIM**.

| Feature | JIT Provisioning (SAML/OIDC) | SCIM Provisioning |
| :--- | :--- | :--- |
| **Creation Trigger** | User attempts to log in. | Admin creates user in IdP. |
| **Deprovisioning** | **Imposssible.** If a user is deleted in the IdP, the App never finds out until the user tries (and fails) to log in. The account remains "orphaned" in the app. | **Native.** SCIM sends a Delete/Deactivation signal immediately when the user is removed in the IdP. |
| **Data Freshness** | Updates occur only when the user logs in. If they don't log in for a month, their data is stale. | Updates occur immediately when changed in the IdP. |
| **Complex Data** | Limited by token size constraints (cannot send 500 group memberships in a single HTTP header). | Unlimited. Can sync complex lists, roles, and huge group structures. |
| **Pre-Provisioning** | No. Account doesn't exist until the first login. Tasks cannot be assigned to new hires beforehand. | Yes. Account exists before the user arrives. |

**Verdict:** JIT is suitable for B2C or simple apps. SCIM is required for Enterprise B2B apps where security (deprovisioning) and compliance are priorities.

## 4. Attribute Synchronization
This section details how user data attributes (Email, Last Name, Department, Manager) remain consistent between the IdP and the SP.

*   **The "Split Brain" Problem:** A user changes their last name due to marriage/divorce. They update it in the corporate directory (IdP). If the Application isn't updated, invoices or emails might go out with the wrong name.
*   **The SCIM Solution:**
    *   The IdP monitors specific mapped attributes.
    *   When a change is detected, the IdP sends a SCIM `PATCH` operation.
    *   Example:
        ```json
        PATCH /Users/123
        {
          "Operations": [
            {
              "op": "replace",
              "path": "name.familyName",
              "value": "Smith-Jones"
            }
          ]
        }
        ```
*   **The OIDC/SAML Role:** While these protocols *can* update attributes during login (via Claims/Attributes in the token), relying on this creates "data drift" for users who are active but haven't logged out and back in recently. SCIM ensures synchronization happens in the background regardless of user activity.

### Summary
In a modern architecture:
1.  **SCIM** is the **Lifecycle Engine** (Create, Update, Delete).
2.  **SAML/OIDC** is the **Key** (Access).
3.  You need **SCIM** to ensure that when a user is fired, their "Key" stops working *and* their office (account) is cleaned out immediately.
