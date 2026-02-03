Based on **Section 36** of the Table of Contents, here is a detailed explanation of **SCIM 2.0 Error Handling**.

---

# 007-Protocol-Details / 004-Error-Handling

In standard REST APIs, error handling is often limited to returning an HTTP status code (like `404 Not Found` or `500 Internal Server Error`). However, SCIM needs to communicate specific identity-related problems (e.g., *"This user exists, but the username is taken"* or *"You tried to patch a group, but the member path is invalid"*).

To solve this, SCIM defines a specific **JSON Error Schema**. When an error occurs, the server returns an HTTP error code *and* a JSON body describing the issue.

### 1. The SCIM Error Response Structure

When a SCIM Service Provider (server) encounters an error, it returns a JSON object governed by the unique schema URN: `urn:ietf:params:scim:api:messages:2.0:Error`.

#### The Anatomy of an Error
A standard error response looks like this:

```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:Error"],
  "status": "409",
  "scimType": "uniqueness",
  "detail": "User 'bjensen' already exists."
}
```

#### Key Fields:
1.  **`schemas` (Required):**
    *   Must contain the specific string `urn:ietf:params:scim:api:messages:2.0:Error`. This tells the client, "This is not a User or Group resource; this is an error message."
2.  **`status` (Required):**
    *   The HTTP status code expressed as a string (e.g., "400", "404", "409").
3.  **`scimType` (Optional but Critical):**
    *   A keyword defined by the SCIM RFC that provides the machine-readable "sub-cause" of the error. This is most common with **400 Bad Request** errors.
4.  **`detail` (Optional):**
    *   A human-readable explanation. This is useful for developers debugging the integration or for display in UI logs.

---

### 2. The `scimType` Error Codes

The `scimType` allows the client to programmatically decide how to fix the request. It usually accompanies a **400 Bad Request** status, but can appear with others.

Here are the specific `scimType` values defined in RFC 7644:

| `scimType` | HTTP Status | Description & Use Case |
| :--- | :--- | :--- |
| **`uniqueness`** | 400 / 409 | **Conflict detected.** A unique attribute (like `userName` or `externalId`) collides with an existing resource.<br>*Response:* The client must choose a different value before retrying. |
| **`tooMany`** | 400 / 413 | **Result set too large.** The client requested a list of resources (via `GET` or `bulk`), but the server refuses because the result set exceeds limits.<br>*Response:* The client should refine logic to use pagination. |
| **`mutability`** | 400 | **Immutable attribute modification.** The client attempted to update an attribute that is defined as `readOnly` or `immutable` in the schema (e.g., trying to change the `id` of a user). |
| **`sensitive`** | 400 | **Security restriction.** The client tried to filter/search based on a sensitive attribute (like `password`). The server refuses to process the query for security reasons. |
| **`invalidSyntax`** | 400 | **Bad JSON or HTTP.** The request body is not valid JSON, or the request is logically malformed. |
| **`invalidFilter`** | 400 | **Bad Filter Syntax.** The filter provided in the URL query is syntactically incorrect (e.g., `filter=userName eq`). |
| **`invalidPath`** | 400 | **Path not found.** Specifically used in **PATCH** operations. The `path` provided in the operation does not exist or matches nothing (e.g., removing a specific group member that isn't in the group). |
| **`noTarget`** | 400 | **Missing target.** Also used in **PATCH**. The operation expects a target, but none was specified or found. |
| **`invalidValue`** | 400 | **Data validation failure.** A submitted attribute value is the wrong type (e.g., sending a String where a Boolean is required) or format (e.g., a malformed email structure). |
| **`invalidVers`** | 412 | **Version Mismatch.** Used when `ETags` are involved. The client sent an `If-Match` header (optimistic locking), but the version on the server has changed since the client last read it. |

---

### 3. HTTP Status Code Mapping

While the JSON body gives details, the HTTP Status Code in the header is the first thing a client checks.

*   **400 Bad Request:** The most common SCIM error. It implies the client sent something wrong (bad JSON, bad filter, invalid data type).
*   **401 Unauthorized:** The client is not logged in, or the Bearer token is expired/invalid.
*   **403 Forbidden:** The client is logged in but does not have permission to perform this action (e.g., a "Read Only" client trying to `POST` a user).
*   **404 Not Found:** The resource ID specified in the URL (e.g., `/Users/12345`) does not exist.
*   **409 Conflict:** Usually signifies a uniqueness violation (duplicate username), though `400` with `scimType: uniqueness` is also valid.
*   **412 Precondition Failed:** The resource was modified by someone else (ETag mismatch).
*   **413 Payload Too Large:** The request body (usually a Bulk request) is too large for the server to process at once.
*   **500 Internal Server Error:** The server crashed or had an unhandled exception. The client may retry this later.
*   **501 Not Implemented:** The client attempted a feature (like `PATCH` or `Bulk`) that the Service Provider does not support.

---

### 4. Real-World Examples

#### Example 1: Creating a user that already exists (Integrity Error)
The client tries to create a user with email `alice@company.com`, but Alice already exists.

*   **HTTP Header:** `409 Conflict`
*   **Body:**
    ```json
    {
      "schemas": ["urn:ietf:params:scim:api:messages:2.0:Error"],
      "status": "409",
      "scimType": "uniqueness",
      "detail": "One or more values in the 'emails' attribute is not unique."
    }
    ```

#### Example 2: Bad Filter Syntax
The client sends a GET request: `GET /Users?filter=userName eq` (missing the value).

*   **HTTP Header:** `400 Bad Request`
*   **Body:**
    ```json
    {
      "schemas": ["urn:ietf:params:scim:api:messages:2.0:Error"],
      "status": "400",
      "scimType": "invalidFilter",
      "detail": "The filter expression is malformed. Expected value after 'eq'."
    }
    ```

### Summary for Developers
*   **Service Providers:** You *must* implement the Error Schema. Do not just return a 400 status with an empty body; explain *why* using `scimType`.
*   **Clients:** Check the `status` first. If it is 400, parse the JSON body and switch on `scimType` to determine if you need to fix your filter, change a username, or correct a data type.
