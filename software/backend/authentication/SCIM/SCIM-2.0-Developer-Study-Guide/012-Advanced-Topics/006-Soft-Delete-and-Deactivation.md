Based on **Section 71: Soft Delete and Deactivation** of the Study Guide, here is a detailed explanation.

In the context of Identity Management and SCIM, the way we handle a user leaving an organization is critical. We rarely want to immediately erase a user's data the moment they quit; instead, we usually want to simply stop them from logging in while keeping their data for audit purposes.

Here is the deep dive into the difference between **Soft Delete (Deactivation)** and **Hard Delete**.

---

### 1. The Concept of "active" vs. "deleted"

In SCIM 2.0, the "state" of a user is primarily controlled by two mechanisms:
1.  **The `active` Attribute (Soft Delete/Deactivation):** This is a boolean flag in the Core User Schema.
2.  **The `DELETE` HTTP Method (Hard Delete):** This is the protocol command to remove the resource entirely.

#### The `active` Attribute
*   **Schema Location:** `urn:ietf:params:scim:schemas:core:2.0:User`
*   **Type:** Boolean (`true` or `false`)
*   **Description:** A Boolean value indicating the user's administrative status.

### 2. Deactivation (Soft Delete)

When an Identity Provider (Client) wants to "Soft Delete" a user, it **does not send a HTTP DELETE request**. Instead, it performs an **Update** operation to change the `active` attribute to `false`.

**The Workflow:**
1.  **Trigger:** An employee is terminated in the HR system.
2.  **Action:** The SCIM Client sends a `PATCH` (or `PUT`) request to the Service Provider.
3.  **Payload:**
    ```json
    PATCH /Users/2819c223-7f76-453a-919d-413861904646
    Host: api.example.com
    Content-Type: application/scim+json

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
4.  **Service Provider Behavior:**
    *   The application **must not** delete the user record.
    *   The application **must** revoke login access immediately.
    *   The application **should** terminate active sessions (invalidate tokens).
    *   The user's history, logs, and group memberships usually remain intact.
    *   **Billing implications:** Many SaaS apps stop billing for a user once `active` is set to `false`, freeing up a "seat."

### 3. Hard Delete (Ref. Section 21)

Hard Delete is the permanent removal of data. This is often done to comply with GDPR "Right to be Forgotten" requests or data retention policies (e.g., "Delete users who have been inactive for 7 years").

**The Workflow:**
1.  **Action:** The SCIM Client sends a `DELETE` request.
2.  **Request:**
    ```http
    DELETE /Users/2819c223-7f76-453a-919d-413861904646
    Host: api.example.com
    ```
3.  **Service Provider Behavior:**
    *   The user record is permanently removed from the database.
    *   Subsequent `GET` requests for this ID will return `404 Not Found`.
    *   All group memberships for this user are removed.
    *   **Restoration is impossible** via SCIM; the user would have to be re-created as a brand new resource with a new `id`.

### 4. Comparison Table

| Feature | Deactivation (Soft Delete) | Hard Delete |
| :--- | :--- | :--- |
| **SCIM Operation** | `PATCH` or `PUT` | `DELETE` |
| **Attribute Changed** | `active: false` | N/A (Resource removed) |
| **Data Persistence** | Record stays in DB; history preserved. | Record removed; history lost or archived strictly in logs. |
| **Reversibility** | **High.** Just set `active: true`. | **None.** Requires re-creation. |
| **User Experience** | "Your account has been disabled." | "User not found" or "Account does not exist." |
| **Identifier (`id`)** | The immutable SCIM `id` persists. | The SCIM `id` is freed (though usually GUIDs are never reused). |
| **Uniqueness** | The `userName` is still taken. You cannot create a new user with the same name. | The `userName` is freed. You *can* create a new user with the same name. |

### 5. Reactivation Workflows

One of the main reasons for using Soft Delete is the ease of **Reactivation**.

If an employee goes on sabbatical and returns, or a contractor is rehired:
1.  The SCIM Client sends a `PATCH` request setting `"value": true` on the `active` attribute.
2.  The Service Provider re-enables login.
3.  Because the record wasn't deleted, the user immediately regains access to their old files, history, and teams.

### 6. Implementation Challenges for Developers relative to Section 71

If you are building a SCIM interface, here are the "Gotchas" regarding this topic:

*   **Uniqueness Constraints:** If a user "jdoe" is soft-deleted (`active: false`), most systems enforce that you **cannot** create a *new* user named "jdoe". The username is still "occupied" by the deactivated account.
*   **Filtering:** When implementing the List/Query endpoint (`GET /Users`), clients often want to see only active users. You must support filtering like:
    `GET /Users?filter=active eq true`
*   **Billing Logic:** Your application logic needs to hook into the `active` attribute change. If the SCIM payload sets `active: false`, your billing system should likely stop charging for that user license dynamically.
*   **Cascading Logic:**
    *   *Hard Delete:* Usually cascades (delete user -> remove from groups).
    *   *Soft Delete:* Usually does *not* cascade (disable user -> keep in groups, but the group membership is effectively dormant).

### Summary
In SCIM 2.0, **Soft Delete** is the standard for day-to-day user lifecycle management (Offboarding), handled via the **`active`** attribute. **Hard Delete** is reserved for data cleanup and privacy compliance, handled via the **`DELETE`** verb.
