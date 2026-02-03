Based on the Table of Contents provided, **Part 4: Protocol Operations** covers the mechanics of how SCIM clients (like Okta or Azure AD) communicate with Service Providers (your application) to manage data. This section explains the standard API calls defined by RFC 7644.

Here is a detailed explanation of items 16 through 23.

---

### 16. HTTP Methods in SCIM
SCIM is a RESTful protocol, meaning it relies on standard HTTP verbs to perform actions. This section maps CRUD (Create, Read, Update, Delete) concepts to HTTP methods.

*   **GET:** Used to retrieve specific resources (a user) or query lists of resources (search for users). It must be "safe" (should not modify data).
*   **POST:** Used primarily to create new resources. It is also used for the standard `/Bulk` endpoint and search queries that are too long to fit in a URL.
*   **PUT:** Used for a "full replacement" update. It tells the server, "Replace the existing resource entirely with this new data."
*   **PATCH:** Used for "partial updates." It tells the server, "Change only these specific fields." Using PATCH is generally preferred over PUT in SCIM to reduce bandwidth and complexity.
*   **DELETE:** Used to remove a resource permanently.

### 17. Create Operation (POST)
This explains how to bring a user or group into existence in the target system.

*   **Endpoint:** Sent to `/Users` or `/Groups`.
*   **Request Format:** A JSON body containing the attributes (e.g., `userName`, `name`, `emails`).
*   **Server Logic:** The server handles the logic of generating a unique `id`. Even if a client sends an ID, the server typically ignores it and creates a new system ID.
*   **Response:**
    *   **201 Created:** Success.
    *   **Location Header:** The response header must include the URL to the newly created resource.
    *   **Body:** Returns the full JSON representation of the created user (including the server-generated `id`, `created` timestamp, and `meta` data).

### 18. Read Operation (GET)
This details how to retrieve information.

*   **Retrieve Single:** `GET /Users/{id}` looks up a specific user by their unique SCIM ID.
*   **Response:**
    *   **200 OK:** Returns the JSON resource.
    *   **404 Not Found:** If the ID does not exist.
*   **Attribute Selection:** Clients can append `?attributes=userName,active` to the URL. The server should then return *only* those specific fields (plus required ones like `id`), which saves bandwidth.

### 19. Replace Operation (PUT)
This covers the "all-or-nothing" update strategy.

*   **Logic:** If you `PUT` a resource to `/Users/{id}`, the server expects the payload to contain the **entire** state of the user.
*   **The Risk:** If the existing user has an attribute `department: "Sales"` and you send a PUT request that omits the department field, the server interprets this as a command to **delete** the department.
*   **Immutable Attributes:** The server must ignore attempts to change read-only fields (like `id` or `created`) rather than throwing an error, provided the rest of the request is valid.

### 20. Partial Update Operation (PATCH)
This is the most complex but most critical operation for developers to understand.

*   **Why use it:** If you only want to change a user's status to `active: false` without sending their address, phone number, and groups, you use PATCH.
*   **Request Structure:** SCIM PATCH does not just accept a partial user object. It accepts an **Operations Array**.
    *   **`op`**: The action (`add`, `remove`, `replace`).
    *   **`path`**: The specific attribute context (e.g., `emails[type eq "work"].value`).
    *   **`value`**: The new data.
*   **Example:**
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

### 21. Delete Operation (DELETE)
This explains how to remove identities.

*   **Endpoint:** `DELETE /Users/{id}`.
*   **Soft vs. Hard Delete:**
    *   **Hard Delete:** The data is wiped from the database.
    *   **Soft Delete:** Many enterprises prefer not to delete data. Often, an Identity Provider (IdP) sends a PATCH to set `active: false` to disable a user. However, if they send a `DELETE` command, the SCIM spec implies the resource should no longer be retrievable via the API.
*   **Response:** Returns `204 No Content` on success.

### 22. List/Query Operation (GET)
This describes how to handle searching and listing multiple users.

*   **Endpoint:** `GET /Users` (without an ID).
*   **Pagination:** SCIM uses **Index-based pagination** (unlike many APIs that use pages).
    *   `startIndex`: The 1-based index of the first result (e.g., 1).
    *   `count`: How many results to return (e.g., 50).
*   **Filtering:** Using the `filter` query parameter (e.g., `GET /Users?filter=userName eq "alice@example.com"`).
*   **Sorting:** Using `sortBy` and `sortOrder` (ascending/descending).
*   **Response format:** A special wrapper JSON called `ListResponse` which contains the array of `Resources`, `totalResults`, and `itemsPerPage`.

### 23. Bulk Operations
This section details how to perform massive changes in a single HTTP request to avoid rate limits and network latency.

*   **Endpoint:** `POST /Bulk`.
*   **Structure:** A large JSON payload containing an array of operations. Each item mimics a standard REST call (method: POST, path: /Users, data: {...}).
*   **`failOnErrors`:** An integer specifying how many errors are acceptable before the server stops processing the remaining items in the batch.
*   **`bulkId`:** A unique feature allowing you to resolve dependencies within the same request.
    *   *Example:* You can define a User creation operation and give it `bulkId: "tempUser1"`. In the *same* request, you can add a Group member pointing to `bulkId: "tempUser1"`. The server resolves "tempUser1" to the actual ID it generates for the user when it executes the group addition.
