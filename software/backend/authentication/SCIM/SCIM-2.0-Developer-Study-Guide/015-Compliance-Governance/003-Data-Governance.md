Based on the Table of Contents you provided, you are asking for a detailed explanation of Section **89. Data Governance** found within **Part 15: Compliance & Governance**.

Here is a detailed breakdown of what this section covers in the context of SCIM 2.0 (System for Cross-domain Identity Management).

---

# 89. Data Governance (in SCIM)

Data Governance refers to the overall management of the availability, usability, integrity, and security of the data employed in an enterprise. In the context of SCIM, this means establishing rules and standards for how user identity data flows between systems to ensure it remains accurate, consistent, and secure.

Here is an explanation of the five sub-topics listed in your Table of Contents:

### 1. Data Ownership
This defines **who** is responsible for specific sets of data. In an automated provisioning environment, it is critical to define who "owns" the user identity to prevent conflicts.

*   **The Concept:** If a user's phone number is updated, who is allowed to change it? The user themselves? The HR department? The IT helpdesk?
*   **SCIM Application:**
    *   **Business Owners:** Usually, HR owns attributes like `title`, `department`, and `manager`.
    *   **IT Owners:** IT owns attributes like `username`, `email`, and `groups`.
    *   **Conflict Resolution:** If a SCIM synchronization runs and tries to update a field, the system must know if the source system has the "right" to overwrite data in the target system.

### 2. Data Quality
This refers to the accuracy, completeness, and reliability of the data being synchronized via SCIM. "Garbage in, garbage out" is a major problem in automated provisioning.

*   **The Concept:** Ensuring that data fits the required format before it is pushed to downstream applications.
*   **SCIM Application:**
    *   **Validation:** Ensuring `emails` are actually valid email formats, `phoneNumbers` follow E.164 standards, and `country` codes match ISO standards.
    *   **Schema Enforcement:** Using the SCIM Schema to reject requests that contain invalid data types (e.g., sending text into a boolean field).
    *   **Consequence:** Poor data quality results in failed provisioning (SCIM 400 Bad Request errors) or, worse, users being created with broken profiles that prevent them from logging in.

### 3. Master Data Management (MDM)
MDM in identity (often called Identity Governance) is about determining the "Golden Record" or the "Single Source of Truth" for a user.

*   **The Concept:** An enterprise user exists in Workday, Active Directory, Salesforce, and Slack. Which system represents the "true" state of that user?
*   **SCIM Application:**
    *   **Source of Truth:** Typically, an HR system (like Workday) is the Master for employment data, while the Identity Provider (like Okta/Azure AD) is the Master for authentication credentials.
    *   **Synchronization Flow:** SCIM ensures that the Master data flows unidirectional to the downstream apps. You generally do not want a change made in a downstream app (like Slack) to overwrite data in the Master system (HR) unless specific write-back rules are established.

### 4. Data Lineage
Data lineage tracks the lifecycle of data: where it originated, where it moved, and how it was altered over time.

*   **The Concept:** Being able to trace the path of a user attribute across the IT ecosystem.
*   **SCIM Application:**
    *   **Audit Trails:** When a user is deleted from a target application, Data Lineage helps answer: "Did this happen because the user was fired in HR, because an admin manually deleted them in the IdP, or because of a script error?"
    *   **Flow Mapping:** Documenting that User Data flows: `HR System -> SCIM Client (IdP) -> SCIM Service Provider (SaaS App)`. This is required for compliance audits (like GDPR) to prove you know exactly where user personal data resides.

### 5. Attribute Authority
This is a granular approach to Master Data Management. Instead of saying "System A is the master of everything," you define masters at the **attribute level**.

*   **The Concept:** Different systems are authoritative for different pieces of information regarding the same user.
*   **SCIM Application:**
    *   **HR System Authority:** Authoritative for `employeeNumber`, `costCenter`, `organization`.
    *   **Email System Authority:** Authoritative for `email`, `proxyAddresses`.
    *   **User Authority:** The user might be the authority for `nickName` or `mobilePhone` (if allowed to self-update).
    *   **Implementation:** The SCIM Client (Provisioning Engine) must be configured to only sync specific attributes from specific sources. For example, it should ignore changes to `mobilePhone` coming from HR if the User is the authority for their own mobile number.

---

### Summary Checklist for this Section
If you are studying for a developer role or architect role regarding SCIM, you need to be able to answer:
1.  **Source of Truth:** Which system holds the correct value for `department`?
2.  **Validation:** How do we stop bad data from breaking the SCIM receiver?
3.  **Flow:** If I change a user's name in the target app locally, will the next SCIM sync overwrite my change? (In a proper Governance model, yes, it should).
