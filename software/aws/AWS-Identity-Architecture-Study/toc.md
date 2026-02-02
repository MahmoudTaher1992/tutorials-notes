# ☁️ AWS Identity Architecture (The Service Provider)

## 1. The Environment Scope: AWS Organizations
*Goal: Understanding where Identity Center lives and how it governs the multi-account structure.*

*   **A. The Management Account**
    *   i. **Root of Trust:** Why Identity Center must be enabled in the Management Account (or a Delegated Administrator account).
    *   ii. **Service Control Policies (SCPs):** The difference between Organization-level guardrails and Identity Center permissions.
*   **B. Multi-Account Strategy**
    *   i. **The Hierarchy:** Applying access to Dev, Staging, and Prod accounts centrally from one place.
    *   ii. **Member Accounts:** How Identity Center pushes roles into downstream accounts automatically.

## 2. AWS IAM Identity Center (The Engine)
*Goal: Configuring AWS to accept an external identity.*

*   **A. Service Evolution**
    *   i. **SSO vs. Identity Center:** Understanding that "AWS SSO" was renamed; the underlying technology remains the same.
*   **B. Identity Source Configuration**
    *   i. **Changing the Source:** Switching from "Identity Center Directory" to "External Identity Provider" (SAML 2.0).
    *   ii. **The Metadata Exchange:**
        *   Importing the IdP Metadata (from Google/Okta).
        *   Exporting the SP Metadata (ACS URL & Entity ID) to give to the IdP.
*   **C. Provisioning Settings**
    *   i. **Manual vs. SCIM:** Deciding whether to manually create users in AWS to match the IdP or enable automatic SCIM provisioning (recommended).

## 3. Authorization Strategy: Permission Sets
*Goal: Mapping "Who you are" (Google Groups) to "What you can do" (AWS Permissions).*

*   **A. Permission Sets vs. IAM Roles**
    *   i. **The Concept:** A Permission Set is a *template* that AWS uses to deploy standard IAM Roles into specific accounts.
    *   ii. **Abstraction:** You manage the *Set*, AWS manages the *Trust Policy* and *Role creation*.
*   **B. Defining Policies**
    *   i. **Managed Policies:** Attaching AWS Pre-defined policies (e.g., `AdministratorAccess`, `ViewOnlyAccess`).
    *   ii. **Inline Policies:** Writing custom JSON for granular access requirements.
*   **C. The Mapping Logic (The Core Task)**
    *   i. **Group-Based Assignment:** Assigning the "GCP-Dev-Group" to the "Developer Permission Set" on the "AWS-Dev-Account."
    *   ii. **Least Privilege:** Strategies for creating different Permission Sets for different environments (e.g., ReadOnly in Prod, Admin in Dev).

## 4. The End-User Experience & Verification
*Goal: Validating the integration and acceptance criteria.*

*   **A. The AWS Access Portal**
    *   i. **The Start URL:** The specific endpoint (e.g., `https://<your-id>.awsapps.com/start`) where the flow begins.
    *   ii. **IdP Redirection:** Verifying the browser redirects to the External IdP (Google) for authentication.
*   **B. Acceptance Criteria (Verification)**
    *   i. **Successful Login:** User lands on the AWS Portal dashboard after authenticating with the IdP.
    *   ii. **Account Visibility:** User sees *only* the AWS accounts they are assigned to.
    *   iii. **Role Assumption:** Clicking an account successfully opens the AWS Console with the correct Federated Role active.