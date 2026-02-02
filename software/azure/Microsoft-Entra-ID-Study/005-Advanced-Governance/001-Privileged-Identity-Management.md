This section of the document, **Advanced Governance (Identity Governance)**, focuses on moving beyond simply *giving* people access to strictly *controlling and auditing* that access over time.

In traditional IT, once a user is given Admin rights, they keep them forever until someone remembers to remove them. This section describes two advanced Microsoft Entra ID (formerly Azure AD) features designed to solve that problem: **Privileged Identity Management (PIM)** and **Access Reviews**.

Here is a detailed breakdown of each concept:

---

### A. Privileged Identity Management (PIM)
**The Core Concept:** Moving from "Always-On" access to "On-Demand" access.

In a standard setup, if you add a user to the `AWS-Production-Admins` group, they have Administrator access 24/7/365. This is dangerous because if their account is hacked at 2:00 AM on a Sunday, the hacker immediately has Admin rights.

**PIM** changes the user's status within that group.

#### i. Just-in-Time (JIT) Access
Instead of making a user a **"Active"** member of the group, you make them an **"Eligible"** member.

1.  **Select the Role/Group:** You target high-risk groups (e.g., `AWS-Prod-Admins`).
2.  **Eligibility:** The user is "Eligible" to become an admin. In their day-to-day state, they have **zero permissions**. They are just a standard user.
3.  **Activation:** When the user needs to do work in AWS:
    *   They log into the PIM portal.
    *   They click **"Activate"** on the AWS Admin role.
    *   **The Gates:** You can configure PIM to require certain checks before activating, such as:
        *   Performing MFA (Multi-Factor Authentication) again.
        *   Typing in a "Business Justification" (e.g., "Fixing Ticket #1234").
        *   Requiring approval from a manager.
4.  **The Window:** Once activated, the user is temporarily added to the group (e.g., for **4 hours**).
5.  **Expiration:** When the 4 hours serves are up, Entra ID legally removes them from the group. They are back to having zero access.

**Why is this important?** It drastically reduces the "Attack Surface." If a hacker steals the user's password, they likely won't get into the AWS environment because the user doesn't actually have admin rights at that moment.

---

### B. Access Reviews
**The Core Concept:** Solving "Permission Creep" through automated auditing.

"Permission Creep" happens when employees change teams or projects. A developer moves from Project A to Project B, but nobody remembers to remove their access to Project A's servers. Over 5 years, one user might accumulate access to everything.

**Access Reviews** automate the process of cleaning this up.

#### i. Recertification
Instead of an IT Admin manually checking spreadsheets once a year, Entra ID automates the workflow:
*   **The Trigger:** You set a schedule (e.g., Quarterly or Monthly).
*   **The Reviewer:** You decide who reviews the access. This is usually the **Manager** of the user or the **Owner** of the specific Group.
*   **The Process:**
    1.  On the 1st of the month, the Manager receives an email: *"Review access for the 'AWS-Dev-Group'."*
    2.  The Manager logs into a dashboard and sees a list of all 20 users in that group.
    3.  The system provides recommendations (e.g., "User John Doe hasn't signed in for 90 days, recommended action: Deny").
    4.  The Manager clicks **"Approve"** (Keep access) or **"Deny"** (Remove access) for each user.

#### ii. Auto-Remediation
This is the piece that actually enforces security. In the old days, even after an audit, IT had to manually go remove the users.
*   **Automatic Removal:** If the Manager clicks "Deny," Entra ID automatically removes the user from the `AWS-Dev-Group`.
*   **Fallbacks:** You can configure what happens if the Manager ignores the email. For example: *"If the reviewer does not respond within 14 days, automatically remove access."*

**Why is this important?** It ensures compliance (SOC2, ISO, HIPAA) and ensures that only the people working on a project *today* have access to it *today*.

---

### Summary of Section 5
By combining these two features, you achieve a "Zero Trust" model for Identity:

1.  **PIM** ensures that even valid admins don't have dangerous permissions while they are sleeping or answering emails.
2.  **Access Reviews** ensure that people who leave the team don't retain access simply because IT forgot to delete them.
