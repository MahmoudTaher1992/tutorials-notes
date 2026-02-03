Based on the Table of Contents you provided, **Part 10: "User Resource"** is the most critical section of the Core Resources module. It defines how a human identity is represented digitally within the SCIM protocol.

Here is a detailed explanation of that specific section.

---

# Detailed Explanation: 10. User Resource

In SCIM (System for Cross-domain Identity Management), the **User Resource** is the fundamental data model used to exchange information about individuals (employees, customers, partners) between systems.

When an Identity Provider (like Okta or Azure AD) wants to create a user in an App (like Slack or Dropbox), it sends a JSON object formatted according to this definition.

## 1. The User Schema URI
Every SCIM resource must be identified by a specific schema URN (Uniform Resource Name). For the core User resource, this is:
> `urn:ietf:params:scim:schemas:core:2.0:User`

When you send a JSON payload to a SCIM server, you must include this string in the `schemas` array so the server knows it is processing a User and not a Group or a Device.

## 2. Core Attributes (Singular)
These are attributes that typically hold a single value.

### **`userName`** (Required)
*   **What it is:** The unique identifier for the user, typically used by the user to log in.
*   **Constraints:** It must be unique across the entire Service Provider.
*   **Note:** While this often looks like an email address (e.g., `alice@company.com`), it is a string. It might just be `asmith` in legacy systems.

### **`name`** (Complex Attribute)
Unlike `userName`, `name` is not a single string. It is a **Complex Attribute** containing sub-attributes to handle different cultural naming conventions:
*   `formatted`: The full name as a single string (e.g., "Ms. Barbara J Jensen, III").
*   `familyName`: Last name / Surname.
*   `givenName`: First name.
*   `middleName`: Middle name.
*   `honorificPrefix`: (e.g., "Ms.", "Dr.").
*   `honorificSuffix`: (e.g., "III", "Ph.D.").

### **`displayName`**
*   **What it is:** The name intended to be shown in the application's UI (e.g., in a chat window or email header).
*   **Difference from `name`:** `displayName` is a simple string and is often editable by the user, whereas the `name` object is usually legal/formal data coming from HR.

### **`active`**
*   **What it is:** A Boolean (`true` or `false`).
*   **Why it matters:** In SCIM, we rarely Delete users (HTTP DELETE) because that destroys history. Instead, we **Deprovision** them by setting `active: false`. This prevents login but keeps the data integrity.

### **`password`**
*   **Usage:** A write-only attribute.
*   **Security:** If a client sends this, the server updates the password. However, when you perform a GET (Read) on a user, the server should **never** return the password hash or cleartext. It should define this attribute as `returned: never`.

### **Other Singular Attributes**
*   **`nickName`**: Casual name.
*   **`profileUrl`**: A URI pointing to the user's online profile.
*   **`title`**: Job title (e.g., "Software Engineer").
*   **`userType`**: Organization-defined category (e.g., "Employee", "Contractor", "Intern").
*   **`preferredLanguage`** & **`locale`**: e.g., `en-US`. Used for localization.
*   **`timezone`**: e.g., `America/Los_Angeles`.

---

## 3. Multi-Valued Attributes
These attributes differ from the core ones because a user can have *many* of them. For example, a user can have a work email and a home email.

The standard structure for a multi-valued attribute usually includes:
*   **`value`**: The actual data (the email address, phone number, etc.).
*   **`type`**: A label distinguishing the value (e.g., "work", "home", "mobile").
*   **`primary`**: A boolean indicating which value is the main one.
*   **`display`**: A human-readable label.

### **`emails`**
The most common multi-valued attribute.
*   *Validation:* Service Providers often require at least one email where `type` is "work".
*   *Uniqueness:* Check if the email must be unique across the system (often yes).

### **`phoneNumbers`**
Stores mobile, fax, pager, etc.
*   *Format:* SCIM recommends using the RFC 3966 format (e.g., `tel:+1-201-555-0123`).

### **`addresses`**
This is a **Multi-Valued Complex** attribute. It is an array of objects, where each object contains:
*   `streetAddress`, `locality` (City), `region` (State), `postalCode`, `country`.
*   Plus `type` (work/home) and `primary`.

### **`groups`**
*   **What it is:** A list of groups the user belongs to.
*   **Directionality:** This is usually **Read-Only** on the User resource.
    *   *Why?* You typically add a user to a group by PATCHing the **Group Resource**, not by PUTting the User resource. However, when you distinct query a User via GET, the server lists their group memberships here.

### **`entitlements`**, **`roles`**, **`x509Certificates`**
*   **`entitlements`**: Specific rights (e.g., "Admin", "User", "License-A").
*   **`roles`**: Application roles (e.g., "manager").
*   **`x509Certificates`**: Public keys for certificate-based authentication.

---

## 4. Example JSON Payload
Here is what a SCIM User Resource looks like in code. This represents the structure described in your study guide:

```json
{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"],
  "id": "2819c223-7f76-453a-919d-413861904646",
  "externalId": "bjensen",
  "meta": {
    "resourceType": "User",
    "created": "2023-01-23T04:56:22Z",
    "lastModified": "2023-05-18T11:22:15Z",
    "location": "https://example.com/v2/Users/2819c223..."
  },
  "userName": "bjensen@example.com",
  "name": {
    "formatted": "Ms. Barbara J Jensen, III",
    "familyName": "Jensen",
    "givenName": "Barbara",
    "middleName": "Jane",
    "honorificPrefix": "Ms.",
    "honorificSuffix": "III"
  },
  "displayName": "Babs Jensen",
  "active": true,
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
  ],
  "phoneNumbers": [
    {
      "value": "555-555-8377",
      "type": "work"
    }
  ],
  "groups": [
    {
      "value": "e9e30dba-f08f-4109-8486-d5c6a331660a",
      "$ref": "https://example.com/v2/Groups/e9e30dba...",
      "display": "Tour Guides"
    }
  ]
}
```

## Special Note on "Enterprise Extension"
While the section you asked about (Part 10) covers the **Core** User, in real-world business scenarios, the Core schema is rarely enough. It lacks fields like "Department," "Manager," and "Employee ID."

That is why **Part 12 (Enterprise User Extension)** of your Table of Contents exists. Those fields are technically *not* part of the Core User resource; they are an **extension** that gets appended to the User JSON.
