Based on item **61. Identity Provider Integration** from your Table of Contents, here is a detailed explanation.

This section focuses on the **Client-side** of the SCIM protocol. In this context, the Identity Provider (IdP) acts as the **SCIM Client**, and the application you are building (or integrating with) acts as the **SCIM Service Provider**.

The IdP is the "Source of Truth." When a user is hired, fired, or promoted in the IdP, the IdP sends SCIM API requests to your application to make the underlying database match.

---

# 61. Identity Provider Integration

This section explores how the major players in the Identity space enforce SCIM standards. While the SCIM RFCs (7643/7644) are standards, every IdP implements the "Client" a little differently. If you are building a SCIM API, you must account for these nuances.

## 1. Okta as SCIM Client
Okta is arguably the most common SCIM client developer interaction. They strictly adhere to the standard but have very specific workflows.

*   **How it works:**
    *   Admins enable "Provisioning" on an App Integration.
    *   Okta performs a "Test API Credentials" check (usually a `GET /Users` with `count=1` or strictly checking the Base URL).
*   **Key Workflows:**
    *   **User Assignment:** Triggers a `POST /Users`.
    *   **Push Groups:** Okta treats Group Push as a distinct operation from User Assignment. It will send `POST /Groups` and then patch members into it.
*   **Developer Nuances (The "Okta Quirks"):**
    *   **Deactivation:** Okta prefers `active: false` (PATCH or PUT) over `DELETE`. It rarely sends a hard DELETE command unless specifically configured to "Delete users" (which is usually off by default).
    *   **Import:** Okta has a feature to "Import" users from your app. This requires your `GET /Users` endpoint to support pagination (`startIndex`) and filtering (`filter=lastModified gt "..."`) perfectly.
    *   **OAIN:** To get listed in the Okta Integration Network, your SCIM implementation must pass their valid automated test suite (Runscope).

## 2. Azure Active Directory (Microsoft Entra ID) as SCIM Client
Azure AD is the standard for enterprise environments. Its SCIM client behavior is known for being specific about "Delta" updates and "Matching."

*   **How it works:**
    *   Azure AD runs a synchronization job in the background (cycle time varies, usually every 40 mins).
    *   It uses **Scope Filters** to determine which users to sync.
*   **Key Workflows:**
    *   **The "Matching" Step:** Before creating a user, Azure AD almost always sends a `GET /Users?filter=userName eq "email@example.com"` to see if the user already exists. If your filter logic is broken, Azure AD will create duplicate users or fail.
*   **Developer Nuances:**
    *   **No DELETE Support (Default):** Azure AD behaves strictly regarding "Soft Delete." When a user is unassigned, it sends a `PATCH` request setting `active: false`. It initiates a hard `DELETE` only 30 days of the user being in the recycle bin (IdP side).
    *   **Batching:** Azure AD frequently uses valid PATCH requests to update groups, but can be heavy on the API rate limits during the initial sync.
    *   **Connection Testing:** When an admin clicks "Test Connection," Azure attempts to connect to the `/Users` endpoint. It expects a strictly formatted 200 OK.

## 3. OneLogin as SCIM Client
OneLogin is developer-friendly and allows for extensive custom attribute mapping in the UI.

*   **How it works:**
    *   Uses "Provisioning" tabs within App connectors.
    *   Allows administrators to map "OneLogin Attribute X" -> "SCIM Attribute Y".
*   **Developer Nuances:**
    *   **Custom Headers:** OneLogin makes it very easy to inject custom HTTP headers into SCIM requests, which is excellent for testing distinct authentication methods or passing Tenant IDs.
    *   **Strict JSON:** OneLogin expects standard SCIM JSON responses. If your `schemas` array is missing in the response, OneLogin often throws a generic error.

## 4. PingIdentity (PingFederate/PingOne) as SCIM Client
Ping is common in legacy and hybrid-cloud enterprise environments.

*   **How it works:**
    *   **PingFederate:** An on-premise server software. It uses "Outbound Provisioning Channels."
    *   **PingOne:** The cloud version.
*   **Key Workflows:**
    *   PingFederate is essentially an ETL (Extract, Transform, Load) tool. It pulls from a datastore (like AD) and pushes to SCIM.
*   **Developer Nuances:**
    *   **Acceptance of 404:** Ping handles "User Not Found" very gracefully during update attempts, whereas some other IdPs might error out and stop the sync.
    *   **Schema Discovery:** PingFederate can actually query your `/Schemas` endpoint to build its internal mapping UI. If your `/Schemas` endpoint is broken, admins cannot map attributes in Ping.

## 5. Google Workspace as SCIM Client
Google is a massive IdP, but its SCIM client capabilities are often considered more rigid than Okta or Azure.

*   **How it works:**
    *   Configured via "SAML apps" where "Auto-provisioning" is turned on.
*   **Developer Nuances:**
    *   **Attribute Limitation:** Google is strict about the core schema. Mapping custom attributes (using the SCIM Extension schema) can be difficult or impossible depending on the specific Google Workspace license.
    *   **Group Flattening:** Google sometimes struggles with nested groups in SCIM. It prefers to flatten group structures before sending them to the application.
    *   **Hard vs. Soft Delete:** Google allows admins to choose what happens when a user is suspended in Workspace: Suspend in App (Soft) or Delete in App (Hard).

## 6. JumpCloud as SCIM Client
JumpCloud targets SMBs and acts as a cloud directory replacement for Active Directory.

*   **How it works:**
    *   Uses "Identity Management" connectors.
*   **Developer Nuances:**
    *   **Group-Centric:** JumpCloud relies heavily on Group membership to trigger provisioning.
    *   **Keys:** Usually relies on a rigid Header `x-api-key` or standard Bearer token for authentication.

---

### Summary Table: Developer Implementation Strategy

If you are building a SCIM Service Provider (API), here is how you should code to handle these implementation differentiators:

| Feature | Implementation Strategy |
| :--- | :--- |
| **Authentication** | Support **Long-Lived Bearer Tokens**. All listed IdPs support this easily. |
| **Filters** | You **must** support `eq` (equals) on `userName` and `email`. Azure AD and Okta rely on this to prevent duplicates. |
| **Deactivation** | Do not rely on `DELETE`. Implement logic that listens for `PATCH { active: false }` to revoke access without deleting data. |
| **Rate Limiting** | Implement a `429 Too Many Requests` response. During an "Initial Sync," Azure AD or Okta might try to push 10,000 users at once. Your API needs to tell them to slow down. |
| **Schema** | Implement the `/Schemas` endpoint correctly. Advanced clients (Ping, tailored Okta apps) will read this to generate their UI. |

### Why this matters (Business Context)
For a SaaS company, building one "Standards Compliant" SCIM API theoretically allows you to sell to customers using **any** of these IdPs. However, in reality, you will likely build "The SCIM API," and then write small middleware or documentation tweaks to handle the specific behavior of Azure AD vs. Okta.
