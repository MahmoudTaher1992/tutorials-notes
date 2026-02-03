Based on the Table of Contents provided, specifically **Section 63: HR System Integration**, here is a detailed explanation of that module.

In the world of Identity and Access Management (IAM), integrating the Human Resources (HR) system is often considered the "Holy Grail" of automation. This section covers how SCIM principles apply to connecting HR systems (like Workday, SAP, or BambooHR) to your identity infrastructure.

---

# 011-Common-Integrations / 003-HR-System-Integration

## 1. The Core Concept: HR as the "Source of Truth"

In a manual IT environment, when a new employee starts, HR manually emails IT to create an account. This is slow and error-prone.

In an automated SCIM environment, the HR system acts as the **Master Source of Truth**. The philosophy is simple: **"If it isn't in HR, it doesn't exist."**

*   **Upstream:** The HR system (Workday, ADP, etc.).
*   **Downstream:** The Identity Provider (Okta, Azure AD) and subsequent applications (Slack, Salesforce).

This integration creates a pipeline called **"HR-Driven Provisioning"** (often referred to as *Inbound Provisioning*).

## 2. The Joiner-Mover-Leaver (JML) Workflow

This section of the study guide focuses on the three main lifecycle events that an HR integration must handle via SCIM:

### A. Joiner (Create)
When a candidate is marked "Hired" in the HR system:
1.  The integration detects a new record.
2.  It creates a SCIM `POST` request to the Identity Provider (IdP).
3.  The IdP creates the user's core identity.
4.  **Key Challenge:** Handling "Future Dating" (Pre-hire). HR might enter the user 2 weeks before their start date. The SCIM integration must decide whether to create the account as `active: false` or wait until the start date to trigger the API.

### B. Mover (Update)
When an employee gets a promotion, changes departments, or gets married:
1.  HR updates the record (e.g., Department changes from "Sales" to "Marketing").
2.  The integration triggers a SCIM `PATCH` or `PUT` request.
3.  **The Ripple Effect:** If the Department attribute changes, the IdP often recalculates group memberships. The user is automatically removed from "Sales-SharePoint" and added to "Marketing-SharePoint" without IT intervention.

### C. Leaver (Delete/Deactivate)
When an employee is terminated or resigns:
1.  HR marks the status as "Terminated."
2.  The integration sends a SCIM request to update `active: false` (soft delete) or `DELETE` (hard delete).
3.  **Security Impact:** This is the most critical security feature. Access is revoked system-wide immediately, preventing ex-employees from stealing data.

## 3. Specific System Nuances

While SCIM is the standard, major HR players often pre-date SCIM or use their own complex APIs. The study guide highlights how these effectively map to SCIM concepts:

### Workday
*   **The Reality:** Workday does not natively push standard SCIM to most apps. It uses a complex SOAP API.
*   **The Integration:** Usually, an Identity Provider (like Azure AD or Okta) polls Workday using a specific connector, maps the SOAP data to an internal SCIM schema, and then propagates it.
*   **Write-Back:** A unique requirement for HR. Once IT creates the email address (`jane.doe@company.com`), the integration must write that attribute *back* into Workday so HR has it on file.

### SAP SuccessFactors
*   Uses OData or SFAPI.
*   Similar to Workday, it acts as the master.
*   Complex logic is often required to map SAP's "Global Assignment" or "Concurrent Employment" concepts into a single SCIM User resource.

### BambooHR / ADP
*   Often used by small-to-mid-sized businesses.
*   Integrations are usually simpler (REST-based or report-based CSV exports converted to JSON).
*   **Attribute Mapping:** Defining what "Location" means (is it "Remote" vs "Office," or "New York" vs "London") requires careful schema definitions.

## 4. Technical Challenges in HR Integration

Developers implementing this section face specific data hurdles:

### A. Data Sanitization
HR data is notoriously "dirty."
*   **Example:** Phone numbers might be entered as `(555) 123-4567`, `555.123.4567`, or `+15551234567`.
*   **SCIM Requirement:** SCIM expects strict formatting (e.g., E.164 for phones). The integration middleware must normalize this data before sending the SCIM payload.

### B. Identity Matching
If a user leaves the company and gets rehired 6 months later:
*   Do we create a new `id`?
*   Do we reactivate the old `id`?
*   The integration must use logic (often matching on `employeeNumber` or National ID) to prevent duplicate accounts.

### C. Attribute Mapping Logic
HR concepts don't always align with IT concepts.
*   **HR:** "Cost Center 1024"
*   **SCIM/IT:** "Engineering Group"
*   The developer must build a transformation layer to translate HR attributes into actionable SCIM attributes (e.g., mapping `CostCenter` to `urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:costCenter`).

## Summary Flow
The "HR System Integration" ultimately describes this architecture:

```text
[ HR System ]  <---(Proprietary/SOAP/API)--->  [ Integration Layer / IdP ]  ----(Standard SCIM 2.0)---> [ Downstream Apps ]
(Source of Truth)                               (Normalization Engine)          (Google, Slack, AWS)
   - New Hire                                      - Map Attributes                - Create User
   - Terminate                                     - Format Phones                 - Revoke Access
   - Promotion                                     - Calculate Groups              - Update Profile
```

This section teaches the student that while SCIM is the protocol for moving identity, HR integration is the **business logic** that dictates *when* and *why* those SCIM messages are sent.
