Based on the document structure you provided, Section **004 / 002-Acceptance-Criteria** represents the **Testing and Validation** phase of an AWS Identity project.

After the architect has configured the "pipes" (Service Provider) and the "water source" (Identity Provider), this section is checking to ensure the water actually flows to the right sinks without leaking.

Here is a detailed breakdown of the three criteria listed under **B. Acceptance Criteria (Verification)**.

---

### i. Successful Login
**The "Front Door" Test**

 This step validates the SAML 2.0 Trust relationship established between your External Identity Provider (e.g., Google Workspace, Okta, Azure AD) and AWS.

*   **The Workflow:**
    1.  The user navigates to the **AWS Access Portal URL** (e.g., `https://my-org.awsapps.com/start`).
    2.  Instead of asking for a username/password immediately, AWS should recognize that it requires external authentication and **redirect** the browser to the External IdP (e.g., the Google Login page).
    3.  The user enters their corporate credentials (email/password) and completes MFA.
    4.  The IdP sends a SAML assertion (a digital "passport") back to AWS.
*   **The Acceptance Criteria (Pass Condition):**
    *   The user is **not** prompted for an AWS-specific IAM user/password.
    *   The user successfully lands on the **AWS Access Portal Dashboard**. This is a simple page displaying a list of AWS Accounts or Applications.
*   **Common Failure:** A "403 Forbidden" or "Invalid SAML Request" error implies the metadata exchange (certificates/URLs) between AWS and the IdP is incorrect.

### ii. Account Visibility
**The "Directory" Test**

This step validates the **Mapping Logic** and **Group Assignments** configured in Section 3 of your document ("Authorization Strategy"). It ensures that the specific user sees *only* the specific accounts they are allowed to touch.

*   **The Workflow:**
    *   Once the user is on the AWS Portal Dashboard (from step `i`), they look at the list of available AWS Accounts inside the menu.
*   **The Acceptance Criteria (Pass Condition):**
    *   **Presence:** If the user is in the "Developers" group in the IdP, they should see the **"Dev"** and **"Staging"** AWS accounts listed.
    *   **Absence (Crucial):** The user should **NOT** see the **"Production"** or **"Billing"** accounts if they are not authorized for them.
*   **Why this matters:** This verifies the principle of **Least Privilege**. If a Junior Dev logs in and sees the "Production" account listed, the acceptance criteria has **failed**, even if the login worked.

### iii. Role Assumption
**The "Keys to the Room" Test**

This is the final and most technical step. Seeing the account on a dashboard is like seeing a door; "Role Assumption" is proving the key actually turns the lock and lets you into the room.

*   **The Workflow:**
    1.  On the Dashboard, the user clicks on an account name (e.g., "AWS-Dev-Account").
    2.  A dropdown appears showing available **Permission Sets** (e.g., `AdministratorAccess` or `ViewOnly`).
    3.  The user clicks `Management Console` next to the role.
*   **The Technical Action:**
    *   Behind the scenes, AWS Identity Center calls the AWS Security Token Service (STS). It requests temporary credentials allowing the user to "Assume" a Federation Role inside that specific account.
*   **The Acceptance Criteria (Pass Condition):**
    *   The browser redirects from the gray Access Portal to the standard, orange/black **AWS Management Console**.
    *   In the top-right corner of the console, the identity is displayed as: `ReservedSSO_ViewOnly_.../user@email.com`.
    *   The user can perform actions allowed by that role (e.g., viewing S3 buckets) and gets "Access Denied" for actions forbidden by that role (e.g., deleting a database).

---

### Summary Table for Verification

| Step | User Action | System Limit | Pass Condition |
| :--- | :--- | :--- | :--- |
| **Login** | Hit Start URL | Authentication | User lands on AWS Portal Dashboard. |
| **Visibility** | Look at Dashboard | Scope/Assignment | User sees *only* assigned accounts (e.g., Dev), not Prod. |
| **Assumption** | Click "Console" | Authorization | User enters the actual AWS Console with the correct Role active. |
