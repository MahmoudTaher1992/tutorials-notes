Based on the outline provided, specifically section **1.C.i (Administrative Roles)**, here is a detailed explanation of what that section covers.

### Context
This section focuses on **Identity Governance** regarding the IT staff members themselves. It addresses the question: *Who is allowed to configure the AWS SSO integration within Microsoft Entra ID?*

To configure SSO, provisioning, and claims, an IT engineer needs high-level permissions. However, giving them too much power creates a massive security vulnerability.

---

### Detailed Breakdown: 1.C.i. Least Privilege

This section advocates for moving away from "God-mode" accounts and using specific, scoped roles.

#### 1. The Principle of Least Privilege (PoLP)
The core concept here is **Least Privilege**. This is a cybersecurity standard that states a user (or process) should only be granted the minimum level of access (privilege) necessary to perform their specific job function, and for the shortest time possible.

*   **The Bad Practice:** Giving an engineer "Global Administrator" rights just so they don't hit any permission errors while setting up AWS SSO.
*   **The Good Practice:** Giving the engineer "Cloud Application Administrator" rights, which allows them to set up AWS SSO but prevents them from deleting the entire directory or resetting the CEO's password.

#### 2. The Roles Compared

In Microsoft Entra ID (formerly Azure AD), there are varying tiers of administration. This section highlights the difference between the two most relevant ones for this task:

**A. Global Administrator (The "God Role")**
*   **What it is:** This is the highest level of access in a Microsoft Tenant.
*   **Power:** Can manage all aspects of Entra ID, access all data, reset passwords for *any* user (including other admins), and delete the entire tenant.
*   **The Risk:** If the engineer’s laptop is compromised or their session is hijacked while they are a Global Admin, the attacker owns the entire company.
*   **Governance Rule:** You should aim to have fewer than 5 Global Admins in your entire organization, and they should rarely be used for daily tasks.

**B. Cloud Application Administrator (The "Target Role")**
*   **What it is:** A specialized Role-Based Access Control (RBAC) role designed specifically for managing SaaS apps (like AWS, Salesforce, ServiceNow).
*   **Power:**
    *   Can create and delete Enterprise Applications (perfect for the AWS setup).
    *   Can configure SSO endpoints and certificates.
    *   Can configure user provisioning (SCIM).
*   **The Limitations (The Safety Net):**
    *   **Cannot** manage Application Proxy (servers that tunnel to on-premise apps).
    *   **Cannot** reset passwords for other administrators.
    *   **Cannot** modify Conditional Access policies (security rules).
*   **Why it is recommended:** It is the exact "puzzle piece" needed to set up the AWS integration without exposing the rest of the directory to unnecessary risk.

#### 3. Why distinguish "Cloud App Admin" vs "App Admin"?
You will often see two roles that look similar:
1.  **Application Administrator:** Can manage all apps *and* the configurations that tunnel back to on-premise servers (App Proxy). This could essentially allow an attacker a bridge into your physical office servers.
2.  **Cloud Application Administrator:** Can only manage cloud apps. It has no bridge to on-premise servers.

**Governance Decision:** Since AWS is a cloud-to-cloud integration, the engineer does not need access to on-premise tunnels. Therefore, **Cloud Application Administrator** is the safer choice.

### Summary of the Workflow described in this file
When you are setting up the "Directory Structure & Governance" (Section 1), you are establishing the rules of engagement:

1.  Identify the engineer responsible for setting up the SSO connection.
2.  Do **not** simply verify they are a Global Admin.
3.  Assign them the **Cloud Application Administrator** role.
4.  This allows them to proceed to **Section 2 (SSO Configuration)** and **Section 3 (Provisioning)** successfully, while keeping the rest of the Microsoft tenant secure.
