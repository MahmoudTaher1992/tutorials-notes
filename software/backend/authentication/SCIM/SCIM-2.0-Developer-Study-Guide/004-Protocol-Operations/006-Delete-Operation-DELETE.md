Based on the Table of Contents provided, here is a detailed explanation of **Section 21: Delete Operation (DELETE)**.

This section focuses on how a client (like an Identity Provider) instructs a Service Provider (like a SaaS app) to remove a resource permanently using the SCIM protocol.

---

# 21. Delete Operation (DELETE)

The SCIM `DELETE` operation corresponds to Section 3.6 of RFC 7644. It is used to remove a specific resource (User or Group) from the Service Provider's data store.

## 1. Request Format

The request for a delete operation is one of the simplest in the SCIM protocol because it does not require a message body (payload). It targets a specific resource specifically by its system-generated `id`.

**Key Components:**
*   **Method:** `DELETE`
*   **Endpoint:** `/{ResourceType}/{id}` (e.g., `/Users/2819c223...`)
*   **Headers:**
    *   `Authorization`: Bearer token (required).
    *   `If-Match`: (Optional but recommended) The specific `version` (ETag) of the resource you intend to delete. This prevents deleting a record that has changed since you last read it.

**Syntax:**
```http
DELETE /Users/{id} HTTP/1.1
Host: example.com
Authorization: Bearer <token>
```

> **Note:** You cannot typically delete resources using a filter (e.g., `DELETE /Users?filter=userName eq 'alice'`). You must look up the resource first to get its `id`, then issue the delete against that specific ID.

## 2. Response Format & Status Codes

Because the goal is to remove data, a successful response usually returns no data.

### Success Scenario
If the deletion is successful, the server returns **HTTP 204 No Content**. There is no JSON body in this response.

```http
HTTP/1.1 204 No Content
```

### Error Scenarios
If the deletion fails, the server should return a standard SCIM Error JSON body.

*   **404 Not Found:** Use this if the Client tries to delete a resource ID that does not exist.
*   **412 Precondition Failed:** If the Client sent an `If-Match` header (ETag), but the version on the server is different (meaning the user was updated by someone else recently), the server rejects the delete to prevent race conditions.
*   **400 Bad Request / 500 Internal Error:** Used for general logic or server failures.

## 3. Soft Delete vs. Hard Delete

This is a critical architectural decision in Identity Management.

### Hard Delete (Standard SCIM DELETE)
When a `DELETE` request is sent, the resource is permanently removed. If a Client creates a user with the same name later, it is treated as a brand new resource with a new `id`.
*   **Pros:** Clean data, GDPR compliance (right to be forgotten).
*   **Cons:** Loss of audit history; if the user returns, they lose previous permissions/history.

### Soft Delete (Deactivation)
Many modern enterprises prefer not to actually delete data immediately. They prefer to **Deactivate** users.
*   **How to implement:** Do **not** use the HTTP `DELETE` method.
*   **Correct Method:** Use HTTP `PATCH` or `PUT` to set the attribute `active` to `false`.
    ```json
    { "op": "replace", "path": "active", "value": false }
    ```
*   **Why:** This allows the user to be reactivated later with all their history intact.

> **Developer Tip:** If you are building a Service Provider, you must decide if an HTTP `DELETE` request triggers a true database delete or just sets a "deleted_at" timestamp (hidden soft delete). However, to the SCIM Client, a 404 must be returned for subsequent GET requests to comply with the protocol.

## 4. Cascading Deletes

When implementing `DELETE`, the Service Provider must handle relationships between resources to maintain data integrity.

*   **Deleting a User:**
    *   If the User is a member of Groups, they must be removed from those Groups. Reference integrity must be maintained.
    *   If the User owns other resources (e.g., documents), the application logic must decide whether to transfer ownership or delete those assets.
*   **Deleting a Group:**
    *   This should **only** delete the Group definition.
    *   It **must not** delete the Users who are members of that group.

## 5. Examples

### Example A: Successful Delete
**Request:**
```http
DELETE /v2/Users/2819c223-7f76-453a-919d-413861904646 HTTP/1.1
Host: api.scim.example.com
Authorization: Bearer eyJhbGciOiJSUzI1...
```

**Response:**
```http
HTTP/1.1 204 No Content
```

### Example B: Delete with Version Check (ETag)
The client wants to ensure they are deleting the specific version of the user they saw 5 minutes ago.
**Request:**
```http
DELETE /v2/Users/2819c223-7f76-453a-919d-413861904646 HTTP/1.1
Host: api.scim.example.com
Authorization: Bearer eyJhbGciOiJSUzI1...
If-Match: W/"3694e05e9dff591"
```

**Response (If ETag matches):**
```http
HTTP/1.1 204 No Content
```

**Response (If ETag differs - e.g., User was just updated):**
```http
HTTP/1.1 412 Precondition Failed
Content-Type: application/scim+json

{
    "schemas": ["urn:ietf:params:scim:api:messages:2.0:Error"],
    "status": "412",
    "detail": "Resource version mismatch."
}
```

### Example C: Resource Not Found
If the client tries to delete a user that has already been deleted:

**Response:**
```http
HTTP/1.1 404 Not Found
Content-Type: application/scim+json

{
     "schemas": ["urn:ietf:params:scim:api:messages:2.0:Error"],
     "status": "404",
     "detail": "Resource 2819c223... not found."
}
```
