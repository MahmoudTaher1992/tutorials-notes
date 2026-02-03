Based on the Table of Contents provided, **Section 37: HTTP Status Codes** falls under **Part 7: Protocol Details**.

Since SCIM (System for Cross-domain Identity Management) is a RESTful protocol, it relies heavily on standard HTTP response codes to communicate the result of an operation. However, SCIM attaches very specific meanings to these codes regarding Identity Management.

Here is a detailed explanation of the HTTP Status Codes as defined in **RFC 7644 (SCIM 2.0 Protocol)**.

---

### 1. Success Codes (2xx)
These codes indicate that the client's request was successfully received, understood, and accepted.

#### **200 OK**
*   **Meaning:** The request succeeded.
*   **When used in SCIM:**
    *   **GET (Read):** Returned when a User or Group is successfully retrieved. The body contains the resource JSON.
    *   **PUT/PATCH (Update):** Returned when a resource is modified, and the server returns the updated resource in the response body.
    *   **POST (Search):** Returned when a `.search` query is successful.

#### **201 Created**
*   **Meaning:** The resource has been created on the server.
*   **When used in SCIM:**
    *   **POST (Create):** Strictly used when a new User or Group is created.
    *   **Requirements:** The response **must** include the resource body and the `Location` header containing the absolute URI of the new resource (e.g., `https://example.com/scim/v2/Users/12345`).

#### **204 No Content**
*   **Meaning:** The request succeeded, but there is no content to return in the body.
*   **When used in SCIM:**
    *   **DELETE:** Returned when a resource is successfully deleted.
    *   **PUT/PATCH:** Returned if the client requested an update but does *not* need the updated resource sent back (often controlled by input parameters), or if the update didn't change the current state (implementation dependent).

---

### 2. Redirection Codes (3xx)
These indicate that further action needs to be taken by the user agent to fulfill the request.

#### **304 Not Modified**
*   **Meaning:** The client has a cached version of the resource that is still valid.
*   **When used in SCIM:**
    *   Used in conjunction with **ETags** (Versioning). If a Client sends a GET request with an `If-None-Match` header matches the current version on the server, the server sends a 304 to tell the client "Your local copy is up to date; don't download it again."

---

### 3. Client Error Codes (4xx)
These indicate that the request contains bad syntax or cannot be fulfilled due to the client's actions. *Note: In SCIM, these usually accompany a JSON Error Response body explaining the details.*

#### **400 Bad Request**
*   **Meaning:** The request is malformed or invalid.
*   **When used in SCIM:** This is a generic catch-all for validation errors.
    *   Invalid JSON syntax.
    *   Missing required attributes (e.g., trying to create a User without a `userName`).
    *   Invalid filter syntax (e.g., `filter=user[name eq`).
    *   **Crucial:** This is usually paired with a SCIM `scimType` error code (e.g., `invalidFilter`, `invalidSyntax`, `mutability`) in the body.

#### **401 Unauthorized**
*   **Meaning:** Authentication is required and has failed or has not been provided.
*   **When used in SCIM:**
    *   The Bearer Token (OAuth) is missing, expired, or invalid.
    *   The Basic Auth credentials are wrong.

#### **403 Forbidden**
*   **Meaning:** The server understood the request but refuses to authorize it.
*   **When used in SCIM:**
    *   The client is authenticated, but does not have permission to perform the action.
    *   *Example:* A client with "Read-Only" scope trying to DELETE a user.
    *   *Example:* Trying to modify a sensitive attribute (like `id` or `meta`) that the server prohibits changing.

#### **404 Not Found**
*   **Meaning:** The requested resource could not be found.
*   **When used in SCIM:**
    *   **GET/PUT/PATCH/DELETE:** Requesting an operation on a specific ID (e.g., `/Users/999`) that does not exist in the database.
    *   Accessing an endpoint that doesn't exist.

#### **409 Conflict**
*   **Meaning:** The request could not be completed due to a conflict with the current state of the target resource.
*   **When used in SCIM:**
    *   **Uniqueness Violation:** Trying to create a User with a `userName` or `email` that already exists in the directory.
    *   **Constraint Violation:** Trying to add a member to a Group where that member is not a valid User.

#### **412 Precondition Failed**
*   **Meaning:** One of the preconditions defined in the request headers evaluated to false.
*   **When used in SCIM:**
    *   **Concurrency Control (ETags):** The client tries to modify a User (PUT/PATCH) and sends an `If-Match: "version-1"` header, but the server is already on `"version-2"`. This prevents the client from accidentally overwriting changes made by someone else.

#### **413 Payload Too Large**
*   **Meaning:** The request entity is larger than the server is willing or able to process.
*   **When used in SCIM:**
    *   **Bulk Operations:** The client sends a Bulk request with 10,000 operations, but the server limit is 1,000.

---

### 4. Server Error Codes (5xx)
These indicate the server failed to fulfill an apparently valid request.

#### **500 Internal Server Error**
*   **Meaning:** A generic error message given when an unexpected condition was encountered.
*   **When used in SCIM:**
    *   Database connection failure.
    *   Unhandled exception in the application code.
    *   The request was valid SCIM, but the server broke while processing it.

#### **501 Not Implemented**
*   **Meaning:** The server does not recognize the request method or lacks the ability to fulfill the request.
*   **When used in SCIM:**
    *   The Client tries to use a feature the Service Provider explicitly says it doesn't support in its `/ServiceProviderConfig`.
    *   *Example:* Sending a `PATCH` request to a server that only supports `PUT`.
    *   *Example:* Cleaning to perform a `sort` operation when the server doesn't support sorting.

---

### Summary of the SCIM Error Response Body
When a SCIM API returns a code other than 2xx (specifically 4xx or 5xx), the body of the response should not be empty or plain text. It should follow the **SCIM Error Schema** (`urn:ietf:params:scim:api:messages:2.0:Error`).

**Example of a 409 Conflict Response:**

```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:Error"],
  "status": "409",
  "scimType": "uniqueness",
  "detail": "User with userName 'alice@example.com' already exists."
}
```

*   **status:** The HTTP status code (as a string).
*   **scimType:** A more specific SCIM error keyword (e.g., `uniqueness`, `mutability`, `invalidFilter`).
*   **detail:** Human-readable explanation.
