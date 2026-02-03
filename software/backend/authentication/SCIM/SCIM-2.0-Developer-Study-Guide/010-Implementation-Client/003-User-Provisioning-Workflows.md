Based on **Item 55** of the provided Table of Contents, here is a detailed explanation of **User Provisioning Workflows** from the perspective of a **SCIM Client**.

In the SCIM architecture, the **Client** (e.g., an Identity Provider like Okta/Azure AD, or a custom script) is responsible for detecting changes in the source system (like an HR database) and pushing those changes to the **Service Provider** (the target app, like Slack or Salesforce).

These workflows represent the standard lifecycle events of an employee: **Joiner, Mover, and Leaver.**

---

### 1. Create User Flow (The "Joiner" Process)
This occurs when a new employee is hired or authorized to access an application.

*   **Trigger:** A new user record appears in the source system.
*   **SCIM Operation:** `POST /Users`
*   **The Logic:**
    1.  **Check Existence (Optional but Recommended):** Before creating, the Client often sends a `GET /Users?filter=userName eq "alice@example.com"` to ensure the user doesn't already exist to avoid a conflict.
    2.  **Construct Payload:** The Client builds the JSON body containing Core Schema attributes (userName, name, emails) and potentially Enterprise Extension attributes (employeeNumber, department, manager).
    3.  **Send Request:** The Client sends the POST request.
    4.  **Handle Response:**
        *   **201 Created:** Success. The Client **must** save the `id` returned by the Service Provider. This `id` is required for all future updates.
        *   **409 Conflict:** The user already exists. The Client should switch to an "Update" flow or log an error.

### 2. Update User Flow (The "Mover" Process)
This occurs when an employee’s details change (e.g., promotion, marriage, address change).

*   **Trigger:** An attribute (like `department`, `familyName`, or `phoneNumber`) changes in the source.
*   **SCIM Operation:** `PATCH /Users/{id}` (Preferred) or `PUT /Users/{id}` (Fallback).
*   **The Logic:**
    1.  **Retrieve ID:** The Client looks up the Service Provider's `id` for that user in its local mapping table.
    2.  **Determine Change:**
        *   **PUT (Replace):** The Client sends the *entire* user object again with the new values. This is "heavier" and requires knowning all current data.
        *   **PATCH (Partial Update):** The Client calculates the difference (delta). For example, if only the department changed, the payload looks like:
            ```json
            {
              "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
              "Operations": [
                {
                  "op": "replace",
                  "path": "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:department",
                  "value": "Engineering"
                }
              ]
            }
            ```
    3.  **Send Request:** The request is sent to the target URL.
    4.  **Verify:** Expect a `200 OK` response containing the updated resource.

### 3. Deactivate User Flow (The "Leaver" Process - Soft Delete)
This is the most common offboarding method in enterprise environments. You rarely delete financial or audit data; instead, you revoke access.

*   **Trigger:** Employee resigns, is terminated, or goes on long-term leave.
*   **SCIM Operation:** `PATCH /Users/{id}` or `PUT /Users/{id}`
*   **The Logic:**
    1.  The Client detects the user is no longer eligible for the application.
    2.  Instead of removing the account, the Client sets the SCIM Core attribute `active` to `false`.
    3.  **Payload:**
        ```json
        {
          "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
          "Operations": [
            {
              "op": "replace",
              "path": "active",
              "value": false
            }
          ]
        }
        ```
    4.  **Result:** The user record remains in the Service Provider database (preserving history), but the user can no longer log in.

### 4. Delete User Flow (The "Hard Delete" Process)
This is used for data cleanup, GDPR "Right to be Forgotten" requests, or temporary license revocation.

*   **Trigger:** Data retention policy expiry or specific privacy request.
*   **SCIM Operation:** `DELETE /Users/{id}`
*   **The Logic:**
    1.  The Client identifies the user to be permanently removed.
    2.  The Client sends the DELETE request to the specific endpoint.
    3.  **Result:**
        *   **204 No Content:** Success. The user is gone.
        *   **404 Not Found:** User was already deleted (Client should usually treat this as success).
    4.  **Client cleanup:** The Client removes the mapping `id` from its own database.

### 5. Reactivate User Flow (The "Rehire" Process)
This handles scenarios where a contractor returns, or an employee returns from leave.

*   **Trigger:** A previously deactivated user becomes active in the source system again.
*   **SCIM Operation:** `PATCH /Users/{id}`
*   **The Logic:**
    1.  The Client recognizes the user usually via an immutable ID (like Employee ID) or email.
    2.  The Client checks its mapping and sees the user already has a mapped SCIM `id` but was marked as inactive.
    3.  The Client sends a payload setting `active` to `true`.
    4.  **Result:** The user can log in again, usually retaining their old data, history, and preferences within the application.

### Summary of Client Responsibilities
For all these workflows, the **SCIM Client** is responsible for:
1.  **Idempotency:** Ensuring that sending the same update twice doesn't break the system.
2.  **Mapping Management:** Storing the link between the Source ID (e.g., HR Database ID 101) and Target ID (e.g., SCIM Resource ID `2819c919-..`).
3.  **Error Handling:** Retrying on timeouts (500 errors) or stopping on logic errors (400 Bad Request).
