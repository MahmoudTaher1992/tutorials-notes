Based on the Table of Contents provided, here is a detailed explanation of **Section 2.A: The Data Model — Core Resources**.

In standard REST APIs, you usually define your own JSON structure. In SCIM, **you do not**. SCIM enforces a strict standard so that an Identity Provider (like Okta/Azure) can talk to *any* Service Provider (like Slack/Dropbox) without custom code.

This section covers the two most fundamental building blocks of that standard: the **User** and the **Group**.

---

### 1. The Concept of "Schemas"
Before diving into the User and Group, you must understand **Schemas**. Every JSON object sent via SCIM must declare *what* it is using a specific string called a `schema`.

If you send a User to a SCIM API, the JSON **must** contain this line:
```json
"schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"]
```
This tells the receiving server: *"Validate this data using the rules defined in the Core 2.0 User specification."*

---

### 2. The User Resource
**URN:** `urn:ietf:params:scim:schemas:core:2.0:User`

This resource represents a digital identity (usually a human, but sometimes a service bot). It is a collection of attributes that describe the user.

#### Key Attributes Breakdown

1.  **`id` (Server-side ID):**
    *   **Who owns it?** The Service Provider (You/The App).
    *   **Behavior:** Must be globally unique within your database. It is usually a UUID or database primary key. Once assigned, it generally cannot change.
2.  **`externalId` (Client-side ID):**
    *   **Who owns it?** The SCIM Client (IdP/Okta).
    *   **Purpose:** This is the ID passed from Okta. It allows the IdP to say "Update the user with externalId `12345`" even if it doesn't know your internal database ID yet. This is critical for **user reconciliation**.
3.  **`userName`:**
    *   **Requirement:** Mandatory (Required).
    *   **Behavior:** Must be unique. Often usually an email address, but be careful—sometimes it's a legacy username (e.g., `jsmith`).
4.  **`active`:**
    *   **Type:** Boolean (`true`/`false`).
    *   **Purpose:** The "Kill Switch." SCIM rarely deletes users (DELETE method). Instead, it sends a PATCH to set `"active": false`. If this is false, the user should count as "De-provisioned" and be unable to log in.
5.  **`name` (Complex Attribute):**
    *   Unlike simple APIs where name is one string, SCIM breaks it down: `familyName` (Last), `givenName` (First), `middleName`, etc.
6.  **`emails` (Multi-valued Attribute):**
    *   SCIM assumes a user has multiple emails. This is an **array of objects**.
    *   Each object has a `value` (the email), a `type` (work/home), and a `primary` boolean.

#### JSON Example: A Standard User Payload
```json
{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"],
  "externalId": "00u12345abcdef",
  "userName": "bjensen@example.com",
  "active": true,
  "name": {
    "givenName": "Barbara",
    "familyName": "Jensen",
    "formatted": "Barbara Jensen"
  },
  "emails": [
    {
      "value": "bjensen@example.com",
      "type": "work",
      "primary": true
    },
    {
      "value": "babs@jensen.org",
      "type": "home"
    }
  ]
}
```

---

### 3. The Group Resource
**URN:** `urn:ietf:params:scim:schemas:core:2.0:Group`

While Users represent authentication (can I log in?), Groups represent **authorization** (what can I do?).

In SCIM, Groups are used to map "IdP Groups" (e.g., "Okta - Engineering Team") to "Application Roles" (e.g., "AWS - Admin").

#### Key Attributes Breakdown

1.  **`displayName`:**
    *   The human-readable name of the group (e.g., "HR Admin", "UnitedStates_Employees").
2.  **`members`:**
    *   This is the most important part. It is a list (array) illustrating who belongs to this group.
    *   **Performance Note:** In large organizations, a group might have 10,000 members. Therefore, when you request a group (GET), the `members` array is often empty or truncated by default to save bandwidth, unless specifically requested.

#### JSON Example: A Group Payload
```json
{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:Group"],
  "displayName": "Engineering Managers",
  "members": [
    {
      "value": "2819c223-7f76-453a-919d-413861904646",
      "$ref": "https://example.com/v2/Users/2819c223-7f76-453a-919d-413861904646",
      "display": "Barbara Jensen"
    },
    {
      "value": "902c24e2-863f-4866-8a43-8a4f8d839493",
      "display": "James Smith"
    }
  ]
}
```
*Note regarding `members`: The `value` is usually the `id` of the User Resource.*

---

### Summary for Engineers

*   **Strict Typing:** Unlike random JSON bodies, SCIM payloads must include the specific `schemas` array, or the server typically rejects the request with a 400 Bad Request.
*   **The "Active" Field:** When building the backend, do not trigger a database delete when a user leaves. Look for the `active: false` attribute change to revoke tokens and kill sessions.
*   **Mapping:** The hardest part of implementing this section is mapping your internal database schema (which might call it `first_name`) to the SCIM schema (`name.givenName`).
