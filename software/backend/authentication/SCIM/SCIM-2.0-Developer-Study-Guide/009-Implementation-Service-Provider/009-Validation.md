Based on **Item 52** of your Table of Contents, here is a detailed explanation of the **Validation** phase when implementing a SCIM Service Provider.

---

# 52. Validation (Service Provider Implementation)

When building a SCIM Service Provider (the API that receives user data), **Validation** is the most critical logic layer. It acts as the "Bouncer" for your database. Before any data is created or updated, it must pass a series of strict checks to ensure data integrity, security, and compliance with the SCIM standard (RFC 7643/7644).

Here is a detailed breakdown of the six sub-components of validation:

---

### 1. Schema Validation
This is the first line of defense. It checks if the JSON payload sent by the Client (e.g., Okta, Azure AD) matches the structural definitions in your SCIM implementation.

*   **Data Types:** You must ensure that attributes match their defined types.
    *   *Example:* `active` must be a Boolean (`true`/`false`), not a string "yes".
    *   *Example:* `age` (if used) must be an Integer, not a decimal.
*   **Mutability:** You must enforce rules on which attributes can be changed.
    *   **readOnly:** If a client tries to PUT/PATCH a `readOnly` attribute (like `id`, `meta.created`, or `groups` implied logic), the server should ideally ignore it or return an error depending on strictness.
    *   **immutable:** If an attribute is `immutable` (like `userName` in some systems), it can be set on creation but never changed.
*   **Canonical Values:** For attributes with a fixed list of allowed values, validate against that list.
    *   *Example:* `emails.type` should usually be "work", "home", or "other". If a client sends `"type": "fishing_trip"`, does your system support that?

### 2. Required Attribute Validation
The SCIM schema defines certain attributes as `required: true`. If a request is missing these, the operation must fail immediately.

*   **The User Resource:** The `userName` attribute is universally required. You cannot create a user without it.
*   **The Group Resource:** The `displayName` is usually required.
*   **Extension Attributes:** If you have a custom schema (e.g., Enterprise Extension), fields like `employeeNumber` might optionally be required by your specific business logic, even if the SCIM standard says they are optional.

**Implementation Tip:** Perform this check early. If `userName` is missing on a POST request, return HTTP `400 Bad Request` immediately.

### 3. Uniqueness Validation
This is the most common cause of provisioning errors. Certain attributes must be unique across your entire specific tenant or system.

*   **Primary Conflict:** `userName`. Two users cannot share the same `userName`.
*   **Secondary Conflicts:** `externalId` (the ID from the Identity Provider) is often reinforced as unique to prevent duplicate linking.
*   **Race Conditions:** Your validation logic must handle concurrency. If two requests try to create "alice@company.com" at the exact same millisecond, the database constraint should catch what the application code might miss.

**Error Handling:** If validation fails here, you must return HTTP `409 Conflict`.

### 4. Reference Validation
SCIM resources often link to other resources. Validating these links is crucial to prevent "dangling pointers" implementation.

*   **Group Membership:** When a client POSTs a new Group with a list of `members`, you must validate that every `value` (which is a User ID) in that list actually exists in your database.
*   **Manager Linking:** In the Enterprise User Extension, there is a `manager` attribute containing a `value` (the Manager's User ID). You must check if that Manager exists.
*   **Logic:**
    1.  Extract IDs from the incoming payload.
    2.  Query the database: `SELECT count(*) FROM users WHERE id IN (...)`.
    3.  If the count doesn't match the number of IDs provided, fail the request (or validly ignore the bad ones, depending on your strictness strategy).

### 5. Custom Business Rules
These are validations specific to **your** specific application (SaaS) that are not defined in the SCIM RFCs but are required for your app to function.

*   **Password Policies:** If your SCIM endpoint accepts passwords, do they meet complexity requirements (Length? Special characters?)?
*   **Data Formatting:** Does the `phoneNumber` need to be in E.164 format? Does the `costCenter` need to match a regex (e.g., `CC-123`)?
*   **Logic Constraints:**
    *   *Example:* "A user cannot be assigned to the 'Admin' group if their `userType` is 'Contractor'."
    *   *Example:* "The `preferredLanguage` must be one of the languages our application actually supports."

### 6. Validation Error Responses
When validation fails, you must return a structured response so the SCIM Client (the Identity Provider) looks at the logs and tells the IT Admin exactly what went wrong.

You should not just return text; you must return a **SCIM Error Resource**.

**HTTP Status Codes:**
*   `400 Bad Request`: General validation failures (schema, parsing, rules).
*   `409 Conflict`: Uniqueness violations (duplicate username).

**The Error Payload (`urn:ietf:params:scim:api:messages:2.0:Error`):**
SCIM defines specific `scimType` keyword to help the client understand *user_error* vs *system_error*.

**Example: Uniqueness Failure**
```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:Error"],
  "status": "409",
  "scimType": "uniqueness",
  "detail": "User with userName 'jdoe' already exists."
}
```

**Example: Mutability Failure (Trying to change a read-only field)**
```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:Error"],
  "status": "400",
  "scimType": "mutability",
  "detail": "Attribute 'id' is read-only and cannot be modified."
}
```

**Example: Invalid Value (Business Rule)**
```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:Error"],
  "status": "400",
  "scimType": "invalidValue",
  "detail": "Password must be at least 10 characters long."
}
```

### Summary of Implementation Flow
When a request hits your Service Provider:
1.  **Parse JSON:** Is it valid JSON?
2.  **Schema Check:** Do the fields exist in the schema? Are the types correct?
3.  **Required Check:** Is `userName` and `id` (if update) present?
4.  **Reference Check:** Do referenced Groups/Managers exist?
5.  **Business Logic:** Check password complexity, regex formats, specific rules.
6.  **Uniqueness:** Check DB for duplicates.
7.  **Persist:** Finally, save to the database.
