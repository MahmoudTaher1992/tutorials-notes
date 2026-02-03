Based on the Table of Contents you provided, specifically **Section 20: Partial Update Operation (PATCH)**, here is a detailed explanation of how SCIM PATCH works, why it is used, and how to construct these requests.

---

# Detailed Explanation: SCIM Partial Update (PATCH)

In SCIM 2.0, the **PATCH** operation is the most efficient and "surgical" method for modifying resources (Users or Groups).

### 1. The Core Concept: PATCH vs. PUT
To understand PATCH, you must understand what it replaces:
*   **PUT (Replace):** To change one attribute (e.g., a phone number), you must send the **entire** User object back to the server. If you miss a field, the server might delete it. This is "Heavy."
*   **PATCH (Partial Update):** You send **only** the specific instructions for what needs to change. This is "Lightweight" and effectively reduces network traffic and potential data loss.

### 2. The Request Structure
A SCIM PATCH request is not just a JSON object of your data; it is a list of commands.

**Endpoint:** `PATCH /Users/{id}`  
**Content-Type:** `application/scim+json`

**The Body:**
The body must define the SCIM Patch schema and an array (list) of **Operations**.

```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
  "Operations": [
    {
      "op": "replace",
      "path": "displayName",
      "value": "New Name"
    }
  ]
}
```

### 3. The `Operations` Array
The `Operations` array contains one or more objects, each consisting of up to three fields:
1.  **`op` (Required):** The action to perform (`add`, `replace`, or `remove`).
2.  **`path` (Optional):** A string indicating *where* inside the resource to apply the change. If omitted, it targets the root of the resource.
3.  **`value` (Optional):** The data to add or replace. (Not used for `remove`).

---

### 4. The Three Operation Types

#### A. `add`
Used to append new values or add new attributes.
*   **Single-value attribute:** If the attribute doesn't exist, it adds it.
*   **Multi-valued attribute (Arrays):** It appends the new value to the existing list (it does not overwrite the list).

*Example: Add a new generic email to a user.*
```json
{
  "op": "add",
  "path": "emails",
  "value": {
    "value": "brian.new@example.com",
    "type": "other"
  }
}
```

#### B. `replace`
Used to change the value of an existing attribute.
*   **Single-value:** Overwrites the old value.
*   **Multi-valued:** If you target the specific array (e.g., `path: "emails"`), it **replaces the entire list** with the new list provided. To replace just *one* item in a list, you must use a filter in the `path` (see Section 5 below).

*Example: Update the user's title.*
```json
{
  "op": "replace",
  "path": "title",
  "value": "Senior Developer"
}
```

#### C. `remove`
Used to delete an attribute or a specific value from a list.
*   Requires a `path`. 
*   Does **not** require a `value`.

*Example: Delete the user's Department.*
```json
{
  "op": "remove",
  "path": "department"
}
```

---

### 5. Path Expressions (The "Surgical" Part)
The `path` attribute is powerful because it supports **filters**. This allows you to update specific items inside a complex list (like `emails` or `addresses`) without knowing the array index.

**Scenario:** A user has 3 emails. You want to update *only* the "work" email.

**Incorrect Way:** Replace the whole `emails` array (you might accidentally delete the "home" email).
**Correct Way (Using Path Filter):**

```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
  "Operations": [
    {
      "op": "replace",
      "path": "emails[type eq \"work\"].value",
      "value": "new.work.email@example.com"
    }
  ]
}
```
*Translation:* Find the entry in the `emails` list where `type` equals "work", and replace its `value` property.

---

### 6. Complex Example (Batching Operations)
One of the best features of PATCH is atomicity. You can bundle multiple changes into one request. If one fails, the server should reject the whole request (depending on implementation).

*Scenario: A user is promoted. We need to 1) Change their title, 2) Add them to the Managers group, and 3) Remove their intern status.*

**Request:** `PATCH /Users/123`
```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
  "Operations": [
    {
      "op": "replace",
      "path": "title",
      "value": "VP of Engineering"
    },
    {
      "op": "add",
      "path": "groups",
      "value": {
        "value": "987-manager-group-id",
        "display": "Managers"
      }
    },
    {
      "op": "remove",
      "path": "userType"
    }
  ]
}
```

### 7. Response Format
Upon a successful PATCH, the server usually returns:
*   **HTTP 200 OK:** Along with the **full** updated Resource representation (JSON). This confirms to the client exactly what the user looks like now.
*   **HTTP 204 No Content:** (Less common) If the server accepts the change but doesn't return the resource body.

### 8. Common Error Codes
*   **400 Bad Request:** The JSON syntax is wrong, or the `path` is invalid (`invalidPath`).
*   **409 Conflict:** You tried to set a value that violates a uniqueness constraint (e.g., setting an email that someone else already has).
*   **412 Precondition Failed:** Used with ETags (optimistic locking) if the user was modified by someone else since you last read the data.

### Summary Checklist for Developers
1.  **Format:** Use the specific `PatchOp` schema.
2.  **Case:** Operations (`add`, `remove`, `replace`) must be lowercase.
3.  **Arrays:** Be careful with `replace` on arrays; it usually wipes the existing list unless you use precise filter paths.
4.  **Performance:** Always prefer PATCH over PUT for large directories to reduce bandwidth.
