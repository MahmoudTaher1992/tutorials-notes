Based on the Table of Contents you provided, here is the detailed explanation for **Section 3.B: CRUD Operations**.

This section describes how the Identity Provider (IdP) syncs data to your application using standard HTTP methods.

---

# 003-The-Protocol / 002-CRUD-Operations

These are the core instructions the SCIM Client (e.g., Okta, Azure AD) sends to your SCIM Server (your app) to manage the lifecycle of a resource.

## i. POST (Create)
**The Trigger:** A new employee joins the company, or an administrator assigns a user to your application in the IdP dashboard.

**The Action:** The IdP sends a POST request to your `/Users` endpoint to create a new record.

### Key Engineering Requirements:
1.  **ID Generation:** The SCIM Server (your app) is responsible for generating the unique identifier (`id`). This `id` must be returned in the response so the IdP can store it and link their user to your user.
2.  **Uniqueness (Conflict Handling):**
    *   SCIM relies heavily on the `userName` attribute being unique.
    *   If the IdP tries to create a user with a `userName` that already exists in your database, you **must** return an HTTP `409 Conflict`.
    *   *Why?* The IdP will usually catch this error and then switch to a "Update" logic instead.

**Example Request:**
```http
POST /Users
Content-Type: application/scim+json

{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"],
  "userName": "alice.smith@example.com",
  "name": {
    "givenName": "Alice",
    "familyName": "Smith"
  },
  "active": true
}
```

**Required Response (201 Created):**
Must include the generated `id` and the `location` header.

***

## ii. PUT vs. PATCH (The Update Strategy)
**The Trigger:** A user changes their last name, moves to a new department, or is assigned to a new group.

The biggest challenge in SCIM implementation is deciding how to handle updates. There are two ways IdPs do this:

### 1. PUT (Replace)
**Logic:** "Here is the **entire** new version of the user object. Delete whatever you had before and replace it with this."

*   **Pros:** Easier to implement server-side.
*   **Cons:** Bandwidth heavy. Dangerous—if the IdP omits a field in the JSON payload (e.g., they forget to send "Department"), you are supposed to delete that data from your database.

### 2. PATCH (Partial Update)
**Logic:** "I don't want to resend the whole user. Just change this specific field."

*   **The Complexity:** SCIM PATCH is not just a JSON merge. It uses a specific "Operations" array containing `add`, `remove`, or `replace` commands and specific `path` targets.
*   **Why it is essential:**
    *   **Performance:** Crucial for Groups. Imagine a Group with 10,000 members. If you add 1 member via PUT, you have to resend all 10,001 members. With PATCH, you send one tiny JSON instruction to "add member X".
    *   **Race Conditions:** Minimizes the risk of overwriting data changed by other processes.

**Example PATCH Request (Update Last Name):**
```http
PATCH /Users/2819c223
Content-Type: application/scim+json

{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
  "Operations": [
    {
      "op": "replace",
      "path": "name.familyName",
      "value": "Johnson"
    }
  ]
}
```

***

## iii. DELETE (De-provisioning)
**The Trigger:** An employee leaves the company or is removed from the application assignment in the IdP.

There is a major distinction here between the HTTP verb and the logical action.

### 1. HTTP DELETE (Hard Delete)
*   **Action:** The IdP sends `DELETE /Users/{id}`.
*   **Result:** You physically wipe the row from your database.
*   **Usage:** Rarely used by Enterprise IdPs for users. They prefer to keep the history/logs of the user.

### 2. Soft Delete (Disable) -> The Standard Way
*   **Action:** The IdP sends a **PATCH** (or PUT) request.
*   **Payload:** Sets `"active": false`.
*   **Result:**
    *   The user remains in your database.
    *   Their session is killed instantly.
    *   They can no longer log in.
    *   Licenses are usually freed up.
*   **Why:** This allows for "Re-hire" scenarios. If the employee returns, the IdP simply sends `"active": true`, and their history/preferences are restored.

### Summary of HTTP Status Codes for CRUD
| Operation | Success Code | Common Error Code |
| :--- | :--- | :--- |
| **POST** | `201 Created` | `409 Conflict` (Duplicate user) |
| **GET** | `200 OK` | `404 Not Found` |
| **PUT/PATCH** | `200 OK` | `400 Bad Request` (Invalid syntax) |
| **DELETE** | `204 No Content` | `404 Not Found` |
