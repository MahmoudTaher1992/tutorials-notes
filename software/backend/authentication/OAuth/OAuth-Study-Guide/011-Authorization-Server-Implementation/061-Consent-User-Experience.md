Here is a detailed explanation of section **061-Consent-User-Experience** within the context of **Authorization Server Implementation**.

---

# 061 - Consent & User Experience

In an Authorization Server (AS), the **Consent** phase is the critical moment where the **Resource Owner** (the user) grants the **Client** (the application) specific permissions (`scopes`) to access their data.

From an implementation perspective, this is not just a UI screen; it is a complex logic flow involving security, database records, and trust management.

Here is a detailed breakdown of how to implement the Consent & User Experience.

---

## 1. The Anatomy of a Consent Screen

The consent screen is the "contract" between the user and the application. If this screen is confusing, users will either abandon the flow (loss of conversion) or, worse, blindly click "Allow" on malicious applications (security risk).

A proper Authorization Server must generate a screen containing the following elements:

### A. Identity Verification
*   **The User:** Display who is currently logged in (e.g., name, avatar, email).
    *   *UX Note:* Provide a "Not you?" link to switch accounts.
*   **The Client:** Clearly display the name, logo, and verified status of the application requesting access.
    *   *Security Note:* If the client is public or unverified, display a warning banner (e.g., "This app has not been verified by Google/Apple").
*   **The Client's URL:** Show the domain where the user will be redirected to prevent phishing.

### B. Scope Translation (The "Human" Element)
The Authorization Request sends technical scope strings (e.g., `crm.read`, `payment:write`). You must translate these into plain language.
*   **Bad:** "Allow app to access `user:email`"
*   **Good:** "View your email address."
*   **Better:** "View your email address (alice@example.com)."

### C. The Visual Hierarchy
Scopes should be grouped by sensitivity:
1.  **Identity Data:** (Low risk) Name, Avatar.
2.  **Functional Data:** (Medium risk) Calendar, Contacts.
3.  **Sensitive Data:** (High risk) Payments, Health data, Sending emails.
    *   *Implementation:* High-risk scopes should be highlighted (e.g., bold text, warning icons).

---

## 2. Backend Logic: Handling the Consent Decision

When the user clicks "Allow" or "Deny," the Authorization Server performs specific logic.

### A. Storing Consent (Trust on First Use)
You need a database table to track what the user has agreed to. This prevents the user from seeing the consent screen every single time they log in.

**Example Database Structure:**
```sql
TABLE UserConsents (
    id UUID PRIMARY KEY,
    user_id UUID,
    client_id UUID,
    scope VARCHAR[],  -- e.g., ["openid", "profile", "email"]
    granted_at TIMESTAMP,
    last_used_at TIMESTAMP
);
```

### B. Logic Flow (Pseudo-Code)
When an Authorization Request hits the `/authorize` endpoint:

1.  **Authenticate User:** (User logs in).
2.  **Fetch Existing Consents:** Check the DB: *Has this user already granted these specific scopes to this specific client?*
3.  **Evaluate:**
    *   **Scenario A (Full Match):** The user previously granted all requested scopes. -> **Skip Consent Screen** (issue code immediately).
    *   **Scenario B (New Scopes/Incremental Auth):** The user granted `profile` previously, but now the client wants `profile` + `calendar`. -> **Show Consent Screen** (highlighting *only* the new permission).
    *   **Scenario C (First Time):** No record exists. -> **Show Consent Screen**.
4.  **Process Decision:**
    *   If **Allow**: Save/Update `UserConsents` table and generate Auth Code.
    *   If **Deny**: Redirect to the client with `error=access_denied`.

### C. First-Party vs. Third-Party
*   **First-Party Apps:** (Apps owned by the same company as the Auth Server). You usually perform **Implied Consent**. You do authentication, but skip the consent screen because the user assumes the company's own app has access to the user's data.
*   **Third-Party Apps:** ALWAYS require explicit consent.

---

## 3. Advanced UX Features

### A. Granular Consent (GDPR Compliance)
Instead of a binary "Yes/No" for the whole bundle, allow users to uncheck specific permissions.
*   *Example:* User agrees to "View Profile" but unchecks "Send Emails on my behalf."
*   *Implementation:* The AS must issue a token containing **only** the scopes the user kept checked, not necessarily all the scopes the client requested. The Client application must be written recursively to handle "partial" access.

### B. Consent Persistence Options
On the UI, you may offer a checkbox: *"Remember my decision."*
*   **Unchecked:** The consent is "Ephemeral" (valid only for this session/token). Do not write to the `UserConsents` table.
*   **Checked:** Write to the DB (standard OAuth behavior).

### C. Transactional Authorization (Rich Authorization Requests)
For high-security actions (e.g., banking), consent implies a specific transaction, not long-term access.
*   *Scope:* `payment_transfer`
*   *Consent Screen:* "Do you want to send **$50.00** to **Merchant X**?"
*   *Implementation:* This consent is never stored permanently. It is one-time use (based on RFC 9396).

---

## 4. Consent Revocation (User Control)

An Authorization Server is incomplete without a "My Apps" or "Security Settings" dashboard for the user. User experience doesn't end at granting access; it includes managing it.

### The Dashboard
The user should see a list of all apps having access to their account.
*   **View:** "App Name," "Access Granted Date," "Specific permissions (scopes)."
*   **Action:** "Revoke Access."

### Revocation Logic
When a user clicks "Revoke":
1.  Delete the record from the `UserConsents` table.
2.  **Critical:** Immediately revoke all **Access Tokens** and **Refresh Tokens** associated with that `client_id` and `user_id` combination.
3.  (Optional) Send a webhook (Security Event Token) to the Client App telling them they have been disconnected (using protocols like *Shared Signals Framework*).

---

## 5. Security & Attack Prevention in UI

The consent screen is a prime target involved in **Illicit Consent Grants** (a form of phishing).

1.  **Anti-Clickjacking:** Ensure the consent screen sets `X-Frame-Options: DENY` or `Content-Security-Policy: frame-ancestors 'none'`. Attackers try to overlay an invisible iframe of your consent button over a "Play Game" button on their site.
2.  **App Impersonation:** Authorization Servers should strictly validate that the Client Name and Logo match the domain registered.
3.  **Scope Description Injection:** Ensure that the text explaining the scope is sanitized and controlled by the AS, not injected blindly from the Client's description.

## Summary Checklist for Developers

1.  **Design:** Does the screen clearly separate the User, the Client, and the Permissions?
2.  **Storage:** Do you have a database schema to remember user choices per client?
3.  **Logic:** Can your AS handle incremental consent (asking only for *new* scopes)?
4.  **Control:** Can the user uncheck specific scopes (if your business logic allows)?
5.  **Revocation:** Is there a portal for users to remove app access later?
