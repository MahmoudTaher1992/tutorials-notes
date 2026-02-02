Based on the Table of Contents you provided, specifically **Section 2.C.i (Provisioning Settings: Manual vs. SCIM)**, here is a detailed explanation of what this entails, why it matters, and how it works.

---

### The Context: The "Shadow Identity" Problem
To understand Provisioning, you first need to understand the problem.

When you integrate an external Identity Provider (IdP) like Google Workspace, Okta, or Azure AD with AWS, authentication is handled externally (you log in at Google). However, **Authorization** is handled by AWS.

AWS cannot assign permissions to a ghost. It needs a record of the user (a "shadow identity") inside the AWS Identity Center database so it can say, *"User Alice belongs to the Admin Group, so she gets AdministratorAccess."*

**Provisioning** is the process of creating and maintaining these user and group records inside AWS to match what exists in your corporate directory.

---

### 1. Manual Provisioning (The "Hard Way")
This involves a human administrator manually creating users and groups in AWS to match exactly what is in the IdP.

*   **How it works:**
    1.  You hire "Alice."
    2.  You create `alice@company.com` in Google Workspace.
    3.  You log into the AWS Console.
    4.  You create a user named `alice@company.com` in Identity Center.
    5.  **Critical Requirement:** The username/email in AWS must match the IdP *exactly* (case-sensitive). If there is a typo, the SAML login will fail because AWS won't recognize the incoming user.
*   **The Problem with Groups:** If you add Alice to the "Developers" group in Google, nothing happens in AWS. You must manually add her to the equivalent "Developers" group in AWS.
*   **The Security Risk (De-provisioning):** When Alice is fired, you disable her account in Google. However, her "shadow identity" still exists in AWS. While she can't log in (because Google blocks the auth), her permissions and record remain in AWS until you manually delete them.

**Verdict:** Only useful for tiny Proof of Concept (PoC) environments. It creates a maintenance nightmare and security risks (human error).

---

### 2. SCIM Provisioning (The Recommended "Automated Way")
**SCIM** stands for **System for Cross-domain Identity Management**. It is an open standard protocol that allows different IT systems to talk to each other about Users and Groups.

When you enable SCIM, you are building an automated synchronization pipe between your IdP (The Source of Truth) and AWS (The Receiver).

*   **How it works:**
    1.  **The Link:** AWS provides you with a **SCIM Endpoint URL** and a **Secret Access Token**. You paste these into your IdP (e.g., in the Google or Okta admin panel).
    2.  **The Interval:** Every few minutes (specifically 40 minutes for many IdPs, or instantly for others), the IdP scans for changes and pushes them to AWS via API.
*   **The Workflow:**
    *   **New Hire:** You create `box@company.com` in the IdP. SCIM automatically sends a command to AWS: *"Create User Bob."* Bob appears in AWS without you touching the AWS console.
    *   **Promotion:** You move Bob from "Junior Devs" to "Senior Architects" in the IdP. SCIM tells AWS to update his group membership. His AWS permissions update automatically.
    *   **Termination:** You suspend Bob in the IdP. SCIM sends a "Disable" or "Delete" command to AWS. Bob is immediately removed from AWS.

**Verdict:** This is the industry standard. It ensures that your AWS environment is always a perfect mirror image of your corporate directory.

---

### Summary Table: Why SCIM Wins

| Feature | Manual Provisioning | SCIM Provisioning |
| :--- | :--- | :--- |
| **Setup Effort** | Low (initially) | Medium (requires API config) |
| **Maintenance** | High (double entry for every change) | Zero (set and forget) |
| **Group Sync** | Manual | Automatic |
| **Typo Risk** | High (breaks login) | None (machine-to-machine) |
| **Security** | Risk of stale accounts remaining | Instant revocation |
| **Scale** | Fails above ~10 users | Scales to thousands |

### How to Configure This (In the Console)
In **AWS Identity Center -> Settings -> Identity Source**:
1.  You will see a toggle for **Provisioning**.
2.  If you select **Automatic (SCIM)**, AWS generates the Endpoint and Token.
3.  You copy those values.
4.  You go to your IdP (e.g., Google Workspace SAML App settings).
5.  You look for "User Provisioning" or "Auto-provisioning," paste the values, and map the attributes (e.g., `primaryEmail` -> `username`).
6.  You start the sync.
