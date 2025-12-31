Based on the Table of Contents you provided, **Part XI: Administration, Security & Governance** is the section where the technical usage of the platform meets the business requirements of managing a team.

Here is a detailed explanation of **Section A: User Management**.

---

# 011-Administration-Security-Governance / 001-User-Management

This module focuses on how you control **who** has access to your data, **how** they log in, and **what** they are allowed to do once they are inside.

In modern New Relic (New Relic One model), user management is tightly coupled with billing (User Types) and security (RBAC).

## 1. Users, Groups, and Roles
This is the fundamental hierarchy of permission management in New Relic.

### Users & User Types (The Billing Aspect)
Unlike older monitoring tools that charged only by the "host" or "server," New Relic charges based on data ingest **and** the type of user. As an Administrator, you must assign a "User Type" to every person.
*   **Basic User (Free):** Can view dashboards and alerts but cannot query data deeply or configure the system. Unlimited basic users are usually free.
*   **Core User:** A middle tier (often for developers who just need to view errors and logs). They have access to telemetry data but limited access to advanced administrative features.
*   **Full Platform User:** Has access to everything (APM, Infrastructure, Logs, Creating Dashboards/Alerts). This is a paid seat.

### Groups (The Container)
You generally should not assign permissions to individual users (e.g., "Bob can edit dashboards"). Instead, you use **Groups**.
*   A Group represents a team or function (e.g., `SRE-Team`, `Developers-Backend`, `View-Only-Execs`).
*   You add Users to Groups.

### Roles (The Keys)
A Role is a collection of specific permissions.
*   **Standard Roles:** New Relic provides defaults like `Admin` (do everything), `User` (standard access), and `Read Only`.
*   **Custom Roles:** You define granular capabilities (e.g., "Can view APM data, but cannot delete Alert policies").

**How they fit together:**
> You assign a **Role** to a **Group**, and then add **Users** to that **Group**.

---

## 2. Role-Based Access Control (RBAC)
RBAC is the strategy used to enforce the "Principle of Least Privilege." It ensures users only have access to the data and tools necessary for their job.

### The Problem
In a large organization, you might have 50 different application teams. You don't want the "Checkout Team" accidentally deleting the monitors for the "Inventory Team."

### The RBAC Solution
New Relic allows you to scope roles to specific accounts or sub-accounts.

1.  **Account Scoping:** If your organization uses a Master Account with several Sub-Accounts (e.g., `Prod`, `Staging`, `Dev`), you can grant a Group `Admin` access in `Dev` but only `Read Only` access in `Prod`.
2.  **Granular Permissions:** You can toggle specific capabilities on/off, such as:
    *   *Alerting:* Create vs. View.
    *   *APM:* Delete app vs. View app.
    *   *Add-on capabilities:* Access to modify billing or api keys.

---

## 3. SAML / SSO Configuration
**SAML (Security Assertion Markup Language)** and **SSO (Single Sign-On)** move the responsibility of authentication (logging in) from New Relic to your company's Identity Provider (IdP).

### Why use it?
*   **Security:** Users don't need a separate password for New Relic. If they are logged into your corporate network (Okta, Azure AD, Google Workspace), they are logged into New Relic.
*   **Compliance:** Many regulations (SOC2, HIPAA) require enforced SSO.

### Domain Claiming
To set this up, an Admin must perform **Domain Claiming**.
1.  You prove to New Relic that you own `yourcompany.com` (usually via a DNS TXT record).
2.  Once verified, you can configure New Relic to **redirect** anyone logging in with `@yourcompany.com` to your IdP (like Okta).
3.  The IdP verifies the user and sends a token back to New Relic to log them in.

---

## 4. SCIM Provisioning
**SCIM (System for Cross-domain Identity Management)** is the automation layer on top of SSO.

While SSO handles *Authentication* (logging in), SCIM handles *Provisioning* (lifecycle management).

### The "Joiner, Mover, Leaver" Problem
Without SCIM, if an employee leaves your company, you have to remember to log into New Relic and delete their user account manually. If you forget, they might still have access.

### The SCIM Solution
SCIM creates a sync tunnel between your IdP (e.g., Azure AD or Okta) and New Relic.

1.  **Joiner (Create):** You hire a new engineer and add them to the "Engineering" group in Okta. SCIM automatically creates the user in New Relic and assigns them the correct User Type and Group.
2.  **Mover (Update):** The engineer moves to the Management team. You change their group in Okta. SCIM updates their Group/Permissions in New Relic automatically.
3.  **Leaver (Deactivate):** The employee quits. You deactivate them in Okta. SCIM sends a signal to New Relic to immediately revoke access and stop billing for that user seat.

### Summary of Workflow
The ideal "Gold Standard" setup for an Enterprise Architect studying this section is:

1.  **Configure SCIM:** To automatically create/delete users based on your HR system.
2.  **Configure SSO:** To secure the login process.
3.  **Map Groups:** Map your Active Directory groups (e.g., `g-developers`) to New Relic Groups.
4.  **Apply RBAC:** Assign specific Roles to those New Relic Groups to control what they can see/touch.
