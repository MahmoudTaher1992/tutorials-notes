Based on the Table of Contents provided, specifically **Part 10: Implementation - Client**, here is a detailed explanation of item **58. Bulk Provisioning**.

This section focuses on how a **SCIM Client** (typically an Identity Provider like Okta/Azure AD or a custom script) should construct and manage bulk operations when talking to a SCIM Service Provider.

---

# 58. Bulk Provisioning (Client Implementation)

Bulk provisioning in SCIM 2.0 (defined in RFC 7644 Section 3.7) allows a client to send a large collection of resource operations (Create, Update, Delete) in a single HTTP `POST` request.

For a Client developer, implementing Bulk is critical for performance when dealing with large datasets, such as initial user migrations or nightly HR synchronizations.

## 1. When to Use Bulk
Not every operation should use the Bulk endpoint. The Client needs logic to decide when to switch strategies.

*   **Initial Identity Migration:** When onboarding thousands of users from a CSV or legacy database, sending 10,000 individual `POST /Users` requests is inefficient and likely to hit rate limits. Bulk is required here.
*   **Periodic Synchronization:** If your system runs a nightly "reconciliation" job that updates hundreds of records, bundle them into bulk requests.
*   **Complex Dependent Creations:** When you need to create a User and immediately add them to a Group within the same logical transaction, Bulk ensures these happen together.
*   **Real-Time Updates (Avoid Bulk):** If a single user changes their password or updates a profile, use standard single-resource endpoints (`PATCH /Users/{id}`). The overhead of constructing a Bulk wrapper is unnecessary for single events.

## 2. Bulk Request Construction
The Client must construct a JSON payload sent to the `/Bulk` endpoint.

**Key Components:**
*   **Method:** Always `POST`.
*   **Schemas:** Must include `urn:ietf:params:scim:api:messages:2.0:BulkRequest`.
*   **Operations:** An ordered array containing specific operations. Each item in the array looks like a mini-HTTP request (method, path, data).

**Example Request:**
```json
POST /v2/Bulk
Host: example.com
Content-Type: application/scim+json

{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:BulkRequest"],
  "failOnErrors": 1,
  "Operations": [
    {
      "method": "POST",
      "path": "/Users",
      "bulkId": "temp-123",
      "data": {
        "userName": "alice@example.com",
        "name": { "familyName": "Smith", "givenName": "Alice" }
      }
    },
    {
      "method": "POST",
      "path": "/Users",
      "bulkId": "temp-456",
      "data": {
        "userName": "bob@example.com",
        "name": { "familyName": "Jones", "givenName": "Bob" }
      }
    }
  ]
}
```

## 3. Dependency Ordering & `bulkId`
This is the most complex concept for the Client to implement.

**The Problem:** You want to create a User and add them to a Group in the *same* Bulk request. However, the User doesn't exist yet, so the Service Provider (Server) hasn't assigned an `id` (e.g., GUID). How do you tell the Group to include the User?

**The Solution (`bulkId`):**
1.  **Assign a Temporary ID:** The Client generates a unique string (the `bulkId`) for the User creation operation (e.g., `client-temp-id-1`).
2.  **Reference the Temporary ID:** In the subsequent Group operation, instead of using the User's real ID, you use the syntax `bulkId:client-temp-id-1`.
3.  **Server Resolution:** The Service Provider processes the User creation first, assigns a real ID, and then automatically swaps the `bulkId` reference in the Group operation with the newly created real ID.

**Client Implementation Logic:**
*   The Client must sort operations topologically. Creations referenced by other operations must appear *earlier* in the `Operations` array.
*   `bulkId` is only required for `POST` (Create) operations where other operations depend on the result.

## 4. `failOnErrors` Parameter
The Client handles error tolerance via the `failOnErrors` integer in the request body.

*   **Transactional approach (`failOnErrors`: 1):** If *any* operation in the batch fails, the Server stops processing subsequent operations immediately.
    *   *Use case:* When operations are interdependent (e.g., don't create the Group if the User creation failed).
*   **Best-effort approach (`failOnErrors`: High Number):** The Server attempts to process everything, regardless of individual failures.
    *   *Use case:* Syncing 1,000 independent users. If one user has a malformed email, you don't want the other 999 to fail.

## 5. Response Processing
The Client receives a `BulkResponse`. It does **not** simply return "200 OK". It returns a status for *every single operation* inside the bulk wrapper.

**Client Responsibility:**
1.  **Parse the Array:** Iterate through the `Operations` array in the response.
2.  **Map correlation:** Use the `bulkId` returned in the response to match the result back to the original request component.
3.  **Check Statuses:**
    *   Operation 1: Status 201 (Created) → Success (Save the new `id` locally).
    *   Operation 2: Status 409 (Conflict) → Failure (User already exists).
4.  **Handle Partial Failures:** If `failOnErrors` didn't stop the batch, the Client must logically separate the successes from the failures and report/retry the failures.

## 6. Error Recovery
When a Bulk request fails (functionally or via network error), the cleanup logic is difficult.

*   **If the HTTP Request fails (e.g., 504 Gateway Timeout):** The Client doesn't know which operations inside the bulk succeeded or failed.
    *   *Strategy:* The Client should query the Service Provider (GET /Users filter by userName) to check which resources were created before retrying.
*   **If specific operations fail (e.g., 400 Bad Request):**
    *   The Client logs the error for that specific user.
    *   The Client ensures dependent operations (like adding that failed user to a group) are also marked as failed/skipped.

## 7. Performance Tuning
To build an efficient Client:

1.  **Check Service Provider Config:** Call the `/ServiceProviderConfig` endpoint first. Look for `bulk.maxOperations` and `bulk.maxPayloadSize`.
    *   *Example:* If the server says `maxOperations: 100`, do not send a batch of 500. Split it into 5 requests of 100.
2.  **Batched & Threaded:** Don't just loop linearly.
    *   Accumulate changes in a queue.
    *   When the queue hits the `maxOperations` limit (or a time limit, e.g., 5 seconds), flush the queue as a Bulk Request.
    *   Run multiple Bulk Requests in parallel (respecting the server's HTTP rate limits).
3.  **Payload Size:** Even if `maxOperations` is high, a huge JSON payload might timeout. It is often safer to stick to smaller batches (e.g., 50-100 items) to ensure request stability.
