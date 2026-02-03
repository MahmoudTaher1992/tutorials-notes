Based on **Item 74** in your Table of Contents, here is a detailed explanation of **Account Linking** within the context of SAML 2.0.

---

# 74. Account Linking in SAML 2.0

### What is Account Linking?
Account Linking is the process of establishing a relationship between a user’s identity as defined by the **Identity Provider (IdP)** and an existing user account at the **Service Provider (SP)**.

In a perfect world, a user has one identity created at the IdP, and the SP creates a local account automatically based on that identity (Just-In-Time Provisioning). However, in reality, users often already have accounts at the SP (created manually or via legacy systems) before Single Sign-On (SSO) is implemented. Account Linking bridges the gap between the "SAML User" and the "Local Database User."

---

### 1. Persistent vs. Transient Identifiers
The foundation of Account Linking lies in the `NameID` format used in the SAML Assertion. The SP needs a way to recognize the user returning in the future.

*   **Transient Identifiers (`urn:oasis:names:tc:SAML:2.0:nameid-format:transient`)**:
    *   **Behavior:** The IdP generates a random, temporary ID for the user for *that specific session*. If the user logs out and logs back in, they get a *different* ID.
    *   **Impact on Linking:** Account linking is **impossible** (or useless) with transient IDs because the SP cannot recognize the user upon their return. This is used for anonymous or guest access.

*   **Persistent Identifiers (`urn:oasis:names:tc:SAML:2.0:nameid-format:persistent`)**:
    *   **Behavior:** The IdP generates a unique, opaque string (e.g., `A93-F32-X11`) specific to that user and that SP. This ID never changes for that pair.
    *   **Impact on Linking:** This is the standard for Account Linking. It allows the SP to build a mapping table: `IdP_ID: A93-F32-X11` maps to `Local_User_ID: 502`. Even if the user changes their email address at the IdP, the Persistent ID remains the same, maintaining the link.

---

### 2. Linking Strategies
There are several ways to establish the link between the IdP identity and the SP account.

#### A. Automatic Linking (Implicit)
This relies on a shared attribute, typically an **Email Address**.
1.  **Flow:** The IdP sends a SAML assertion containing `email=user@company.com`.
2.  **Logic:** The SP searches its local database for a user with `user@company.com`.
3.  **Action:** If found, the SP logs the user into that local account.
4.  **Risk:** If the IdP doesn't verify emails, a malicious user could claim an email they don't own at the IdP and hijack an admin account at the SP. This requires a high degree of trust in the IdP.

#### B. Interactive / User-Initiated Linking
This is the most secure method usually implemented when an SP switches to SSO for the first time.
1.  **Flow:** The IdP sends a SAML assertion for `User A`.
2.  **Logic:** The SP does not recognize the SAML ID.
3.  **Prompt:** The SP displays a screen: *"We see you are logging in via SSO. Do you have an existing account?"*
4.  **Verification:** The user enters their **old username and password** for the SP.
5.  **Action:** If the credentials are correct, the SP updates the local user record, saving the **SAML NameID** into a column (e.g., `federated_id`). Future logins are automatic.

#### C. Administrative Linking (Batch)
This occurs "out-of-band" (outside the login flow).
1.  **Scenario:** The company IT admin wants to enable SSO for 1,000 employees.
2.  **Process:** The admin exports a list of User IDs from the IdP.
3.  **Action:** The admin runs a script against the SP's database or API to populate the `federated_id` field for all users based on a common key (like Employee ID or Email).
4.  **Result:** When users try SSO for the first time, the link already exists.

---

### 3. The Name Identifier Management Interaction
SAML define a specific protocol for managing these links, though in modern web development, it is often handled via API calls rather than XML messages.

*   **`ManageNameIDRequest`**:
    *   The IdP can send a request to the SP saying, *"The user known as `A93-F32-X11` will essentially be changing their ID to `B77-Y22-Z99`."*
    *   Alternatively, it allows the IdP to tell the SP to **Terminate** the association (effectively unlinking them).

---

### 4. Unlinking Accounts
Unlinking is the process of breaking the bond between the IdP and SP identities.

*   **User Action:** A user might go to their profile settings in the SP and click "Disconnect Google Account." The SP deletes the stored `federated_id` from the database. Next time the user tries SSO, they will be treated as a new user or prompted to link again.
*   **Security Necessity:** If a user leaves the organization and their IdP account is disabled, the specific link is broken. However, if the user re-joins the company and gets a *new* IdP account (new UUID), the SP must ensure the old link doesn't grant access incorrectly.

### Summary Checklist for Developers

When implementing Account Linking, you must decide:
1.  **Matching Criteria:** Will you trust email matching, or force a password login to link?
2.  **Storage:** You need a column in your User table (e.g., `saml_subject_id`) to store the persistent ID from the IdP.
3.  **Conflict Resolution:** What happens if an SSO user tries to link to an account that is already linked to a *different* SSO user? (Usually, reject the attempt).
