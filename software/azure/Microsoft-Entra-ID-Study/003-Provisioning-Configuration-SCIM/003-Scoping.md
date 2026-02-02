Based on the Table of Contents provided, here is a detailed explanation of section **3. Provisioning Configuration (SCIM Client) – Subsection C: Scoping**.

---

### **3. C. Scoping**

**The Core Concept:**
In the context of Microsoft Entra ID (formerly Azure AD), **Scoping definition** acts as a filter that determines exactly **which objects** (users or groups) should be synchronized from your directory to the external application (e.g., AWS IAM Identity Center).

Without scoping, the synchronization process might try to push every single user in your entire organization into the target application. This section is about configuring the "rules of engagement" for the sync engine.

#### **i. Sync Scope: Configuring the app to only sync "Assigned Users and Groups"**

This specific line refers to a toggle switch found inside the *Provisioning* settings of an Enterprise Application. There are generally two options here:

1.  **Sync all users and groups:** (The "Firehose" method)
    *   **What it does:** Entra ID will attempt to create an account in the target application (AWS) for every single user present in your Microsoft directory.
    *   **Why avoid this:** If you have 10,000 employees but only 50 developers need access to AWS, using this setting creates 9,950 unnecessary "ghost" accounts in AWS. It creates security risks, visual clutter, and potential licensing costs.

2.  **Sync only assigned users and groups:** (The "VIP List" method - **Recommended**)
    *   **What it does:** Entra ID will first check the "Users and Groups" tab of the Enterprise App. It will *only* provision users into AWS if they (or a group they belong to) have been explicitly assigned to the application.
    *   **How it works:**
        1.  You create a Security Group called `AWS-Developers`.
        2.  You assign `AWS-Developers` to the AWS Enterprise App in Entra ID.
        3.  The Provisioning Scope ignores everyone else in the company. It only looks at members of `AWS-Developers` and pushes their data via SCIM to AWS.

---

### **Why is Scoping Critical?**

There are three main reasons why this configuration step is vital for a healthy identity architecture:

#### **1. Security (Attack Surface Reduction)**
This is the principle of **Least Privilege**. An HR representative or a Marketing intern should not exist inside your AWS environment, even if they have zero permissions attached to their user. By scoping correctly, you ensure that if a user’s account is compromised, the attacker cannot leverage that identity to pivot into applications the user shouldn't be in.

#### **2. Lifecycle Management (The "Off-boarding" Logic)**
Scoping dictates how accounts are removed.
*   **The Scenario:** A developer moves from the "Engineering" team to the "Sales" team.
*   **The Action:** You remove the user from the `AWS-Developers` group in Entra ID.
*   **The Result:** Because the user is no longer "Assigned," they fall **out of scope**.
*   **The SCIM Trigger:** When a user falls out of scope, Entra ID sends a SCIM `disable` or `delete` command to AWS. This automatically revokes their access without an admin needing to log into AWS manually.

#### **3. Performance & Throttling**
If you sync "All Users," Entra ID has to check tens of thousands of users for changes every 40 minutes. This slows down the sync cycle. If you only scope to "Assigned Users" (e.g., 50 people), the sync is nearly instantaneous because the engine has a much smaller list to verify.

### **Advanced Scoping: "Scoping Filters"**
While the TOC highlights assigning users/groups, there is an advanced layer often used here called **Attribute-Based Scoping Filters**.

*   *Example:* You can tell Entra ID, "Sync only assigned users, **BUT** only if their `Department` attribute equals `IT`."
*   If a user is assigned the group but their department is "Finance," the Scoping Filter blocks them. This acts as a "Fail-safe" double-check to prevent accidental access.
