Based on the Table of Contents you provided, **Section 5.B: Access Reviews** falls under the "Advanced Governance" umbrella of Microsoft Entra ID (formerly Azure AD).

This is a critical security feature designed to solve the problem of **"Privilege Creep"**—where employees accumulate access rights over time (moving from project to project or role to role) but never lose the old ones.

Here is a detailed explanation of the concepts listed in that section.

---

### What is an Access Review?
In a traditional IT environment, once a user is added to a group (e.g., `AWS-Production-Admins`), they usually stay there forever until they quit the company or an IT admin manually removes them. This is a security risk.

**Access Reviews** automate the auditing process. Instead of granting access permanently, the system periodically asks, *"Does this person still need this access?"*

#### i. Recertification (The "Ask")
This is the triggering event of the review cycle.
*   **The Definition:** It is a scheduled process (Weekly, Monthly, Quarterly, or Annually) where Entra ID generates a list of everyone currently in a specific Group or assigned to a specific Application.
*   **The Reviewer:** You can configure *who* is responsible for answering the question. Common options include:
    *   **The Manager:** Entra checks the "Manager" field on the user's profile and sends the email to them. (Best for verifying role changes).
    *   **The Group Owner:** If a DevOps lead owns the `AWS-Dev-Group`, they are asked to review the members.
    *   **Self-Review:** The users get an email asking, "Do you still need this?" (Useful for low-security apps, but less secure for Admin rights).
*   **The Experience:** The reviewer receives an email containing a link. They are taken to a portal where they see a list of users. Beside each user are two buttons: **Approve** (Keep access) or **Deny** (Remove access).
*   **Decision Support:** Entra ID is smart enough to provide recommendations. For example, if a user hasn't logged into that application in 90 days, the system will highlight that user and suggest you "Deny" access.

#### ii. Auto-Remediation (The "Action")
This is the enforcement mechanism. In the past, companies would do "paper audits" where managers signed a spreadsheet, but IT was too busy to actually go into the system and remove the users. **Auto-remediation solves this.**

*   **How it works:** When you configure the Access Review, you enable "Auto-apply results to resource."
*   **The Workflow:**
    1.  The Manager clicks **"Deny"** on a user.
    2.  As soon as the review period ends, Entra ID **automatically removes** that user from the Security Group or Application assignment.
*   **Handling Non-Responders:** You can also configure what happens if the manager *ignores* the email. A common security practice is "If reviewers don't respond, **Remove Access**." This forces managers to actively confirm access rather than silently allowing it to persist.

---

### A Real-World Scenario (Using your AWS Context)

Imagine you have a user named **Alice**.
1.  **January:** Alice joins the DevOps team. She is added to the `AWS-Production-Admins` group in Entra ID.
2.  **June:** Alice gets promoted to a Project Manager role. She no longer writes code or manages servers, but nobody remembers to remove her from the `AWS-Production-Admins` group. She still has the keys to the kingdom.
3.  **July (Access Review Kicks in):**
    *   **Recertification:** Alice's manager receives an automated email: *"Please review access for the AWS-Production-Admins group."*
    *   The manager sees Alice on the list. They think, "Wait, Alice is a PM now. She doesn't need production server access."
    *   The manager clicks **Deny**.
    *   **Auto-Remediation:** At the end of the review period, Entra ID removes Alice from the group.
    *   Because the group membership was removed, the SCIM provisioning (from Section 3) runs and automatically disables her Admin user inside AWS.

### Why is this important?
1.  **Compliance:** If your company undergoes audits (SOC2, ISO 27001, HIPAA), auditors require proof that you are regularly checking who has access to sensitive data. This feature generates a downloadable audit log of exactly who approved whom and when.
2.  **Least Privilege:** It ensures users only have the access they need *right now*, not access they needed 3 years ago.
3.  **Operational Hygiene:** It prevents the directory from becoming cluttered with "stale" accounts and permissions.
