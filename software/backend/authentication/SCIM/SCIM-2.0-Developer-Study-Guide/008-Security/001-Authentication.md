Based on the Table of Contents provided, **Part 4: Protocol Operations** covers the mechanics of how SCIM clients (like Okta, Azure AD, or a custom script) communicate with SCIM Service Providers (like a SaaS application or database).

SCIM is a RESTful API standard, which means it uses standard HTTP verbs (GET, POST, etc.) to manage the lifecycle of identities.

Here is a detailed explanation of items 16 through 23.

---

### 16. HTTP Methods in SCIM
This section defines the standard "verbs" used to take action on resources (Users or Groups). SCIM dictates exactly how these methods should behave to ensure compatibility.

*   **GET:** Used to **read** data. It can retrieve a specific user by ID or search for a list of users. It is "safe" (does not change data).
*   **POST:** Used to **create** new resources. It is not idempotent (sending the same POST twice creates two different users).
*   **PUT:** Used for **full replacement**. You send the *entire* object. If an attribute is missing in the request, it is removed from the server.
*   **PATCH:** Used for **partial updates**. You send instructions to modify specific fields (e.g., "change the department to Sales") without sending the whole user object.
*   **DELETE:** Used to **remove** a resource permanently.

### 17. Create Operation (POST)
This is how a new User or Group is onboarded into an application.

*   **Endpoint:** Sent to the root of the resource type, e.g., `/Users` or `/Groups`.
*   **Request:** The body contains a JSON representation of the user. It must include all "required" attributes defined in the schema (usually `userName` and `active`).
*   **Server Logic:** The server validates the data, checks for uniqueness (e.g., is `userName` taken?), generates a unique system `id`, and stores the data.
*   **Response:**
    *   **201 Created:** Success.
    *   The response body **must** include the full resource as created, including the server-assigned `id`, `meta` data (created dates), and `Location` header.

### 18. Read Operation (GET)
This operation retrieves the details of a specific resource.

*   **Endpoint:** Specified by ID, e.g., `/Users/2819c223-7f76`.
*   **Attribute Selection:** Clients can request specific fields to reduce bandwidth using the `attributes` query parameter (e.g., `?attributes=userName,email`).
*   **Response:**
    *   **200 OK:** Returns the JSON resource.
    *   **404 Not Found:** If the ID does not exist.
    *   **304 Not Modified:** If using ETag caching and the data hasn't changed.

### 19. Replace Operation (PUT)
PUT is a strict "overwrite" command. This matches the definitions in standard REST APIs but is often a source of bugs for developers who confuse it with PATCH.

*   **Concept:** "Make the resource on the server look *exactly* like the JSON I just sent."
*   **The Danger:** If a user has a `phoneNumber` on the server, and the Client sends a PUT request that omits the `phoneNumber` field, the server **must delete** the phone number.
*   **Immutability:** You cannot change the `id` via PUT.
*   **Response:** Like POST, it returns the updated resource with a **200 OK**.

### 20. Partial Update Operation (PATCH)
PATCH is the most powerful and complex operation in SCIM. It allows clients to be efficient by sending only changes rather than the whole profile.

*   **Request Structure:** The body is not a User object. It is a specific `urn:ietf:params:scim:api:messages:2.0:PatchOp` schema.
*   **Operations Array:** The body contains a list of operations to perform in order:
    1.  **Add:** Adds a value (e.g., add a user to a group).
    2.  **Remove:** Deletes a value (e.g., remove a specific phone number).
    3.  **Replace:** Overwrites a specific value (e.g., change `active: true` to `active: false`).
*   **Pathing:** SCIM uses "paths" to target specific nested attributes.
    *   *Example:* `path="emails[type eq 'work'].value"` targets only the work email address.
*   **Usage:** This is heavily used for Group management (adding one member without re-uploading the list of 5,000 existing members) and disabling users (toggling `active` to false).

### 21. Delete Operation (DELETE)
This removes the resource from the Service Provider.

*   **Endpoint:** `/Users/{id}`
*   **Response:** **204 No Content**. This indicates success but returns no body (because the object is gone).
*   **Soft vs. Hard Delete:** SCIM DELETE implies the resource is gone. However, many enterprise apps practice "Soft Delete" (keeping the data but marking it trash). To achieve a Soft Delete logically in SCIM, clients usually perform a **PATCH** to set `active: false`. The DELETE verb usually means a "Hard Delete."

### 22. List/Query Operation (GET)
This allows the client to search the database or download all users.

*   **Endpoint:** `/Users` (without an ID).
*   **Filtering:** The client uses the `filter` parameter to search.
    *   *Example:* `/Users?filter=userName eq "bjensen"`
*   **Pagination:** Essential for large databases.
    *   `startIndex`: The index of the first result (1-based).
    *   `count`: How many results to return per page.
*   **Response:** Returns a `ListResponse` JSON wrapper containing:
    *   `totalResults`: How many matches exist in total.
    *   `Resources`: An array containing the actual User objects.

### 23. Bulk Operations
This allows the client to bundle many operations into a single HTTP request to save network latency.

*   **Scenario:** An HR system needs to onboard 500 employees at once. Sending 500 individual POST requests is slow; sending 1 Bulk POST is fast.
*   **Endpoint:** `/Bulk`
*   **Structure:** A JSON body containing an array of operations (method, path, data).
*   **bulkId:** A crucial concept. It allows you to create dependencies within the bulk request.
    *   *Example:* Operation 1 creates a User (assigns temp ID `bulkId:1`). Operation 2 adds `bulkId:1` to a Group. The server resolves `bulkId:1` to the actual real ID created in step 1.
*   **failOnErrors:** An integer setting. If set to `1`, the server stops processing the moment one operation fails. If higher, it attempts to process the rest even if one fails.
