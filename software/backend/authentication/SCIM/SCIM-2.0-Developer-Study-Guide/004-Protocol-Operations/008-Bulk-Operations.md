Based on **Section 23 (Bulk Operations)** of your Table of Contents, here is a detailed explanation of how Bulk Operations work in SCIM 2.0.

---

### What are SCIM Bulk Operations?

In a standard REST API, if you need to create 100 users, you typically have to send 100 separate HTTP POST requests. This causes **network latency** (the time it takes for requests to travel back and forth) and puts a heavy load on connection management.

**SCIM Bulk Operations** allow a Client to send a single HTTP request containing a list of multiple operations (Create, Update, Delete) to be processed by the Service Provider.

#### Key Characteristics
*   **Endpoint:** `/Bulk`
*   **HTTP Method:** Always `POST`
*   **Purpose:** Throughput optimization and efficiency.
*   **Content Type:** `application/scim+json`

---

### 1. The Request Structure

A Bulk Request is a JSON object wrapper that contains an array called `Operations`.

**Top-Level Attributes:**
*   **`schemas`**: Must include `urn:ietf:params:scim:api:messages:2.0:BulkRequest`.
*   **`failOnErrors`**: An integer. It specifies how many errors the server should tolerate before stopping the processing of the batch.
    *   Set to `1`: The server stops processing immediately after the first error.
    *   Set to a high number: The server attempts to process all operations, even if some fail.
*   **`Operations`**: An array of operation objects.

**Inside an Operation Object:**
*   **`method`**: The HTTP method for this specific item (`POST`, `PUT`, `PATCH`, `DELETE`).
*   **`path`**: The resource path relative to the Base URL (e.g., `/Users`, `/Groups/123`).
*   **`bulkId`**: A temporary string identifier (required for `POST` operations, optional for others).
*   **`data`**: The JSON payload for that specific operation (e.g., the User profile data).

---

### 2. The `bulkId` Concept (Crucial)

The most consistent challenge in bulk provisioning is **dependencies**.

**The Scenario:** You want to create a User ("Alice") and immediately add her to a Group ("Engineering") in the *same* request.
**The Problem:** You cannot add Alice to the group because the server hasn't created her yet, so she doesn't have an `id` (like `12345`) assigned by the server.

**The Solution: `bulkId`**
SCIM allows you to assign a temporary ID (`bulkId`) to the `POST` operation. Later operations in the same bulk request can reference that temporary ID.

**Syntax for referencing:** `bulkId:[string]`

**Example Flow:**
1.  **Op 1 (Create User):**
    *   `method`: `POST`
    *   `bulkId`: `tempId_Alice`
2.  **Op 2 (Update Group):**
    *   `method`: `PATCH`
    *   `path`: `/Groups/GroupingID`
    *   `value`: `[{ "value": "bulkId:tempId_Alice" }]`

 The server will resolve `bulkId:tempId_Alice` to the actual server-generated ID when processing Op 2.

---

### 3. Concrete Example: Bulk Request

Here is a JSON payload demonstrating creating a user and updating a generic user in one go.

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
      "bulkId": "qwerty",
      "data": {
        "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"],
        "userName": "alice",
        "name": {
          "familyName": "Smith",
          "givenName": "Alice"
        }
      }
    },
    {
      "method": "PATCH",
      "path": "/Users/b7c14771-226c-4d05",
      "data": {
        "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
        "Operations": [
          {
            "op": "replace",
            "path": "active",
            "value": false
          }
        ]
      }
    }
  ]
}
```

---

### 4. The Response Structure

The server responds with a `BulkResponse` object. Even if individual operations failed, the HTTP Status of the Bulk Request itself is usually **200 OK** (because the bulk request was received and processed). You must inspect the JSON body to see if specific operations succeeded.

**Response Attributes:**
*   **`status`**: The HTTP response code for that specific operation (e.g., "201" for created, "200" for OK, "409" for Conflict).
*   **`location`**: The URL of the resource created.
*   **`response`**: The resource data (if applicable).

**Example Response:**
```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:BulkResponse"],
  "Operations": [
    {
      "method": "POST",
      "bulkId": "qwerty",
      "location": "https://example.com/v2/Users/92b79f26",
      "status": "201"
    },
    {
      "method": "PATCH",
      "location": "https://example.com/v2/Users/b7c14771-226c-4d05",
      "status": "200"
    }
  ]
}
```

---

### 5. Limits and Considerations

When implementing this (as per Section 29 of your ToC: Service Provider Configuration), the server publishes its limits:

1.  **`maxOperations`**: The maximum number of operations allowed in one request (e.g., 1000).
2.  **`maxPayloadSize`**: The maximum size of the request body in bytes.

#### Error Handling Note
Bulk operations are generally **not ACID transactional**.
*   If you send 10 operations, and operation #5 fails:
*   Operations #1-#4 usually remain committed (they do not rollback).
*   Processing stops or continues based on the `failOnErrors` count you provided.

### Summary Checklist for Developers
1.  Check the `/ServiceProviderConfig` endpoint to see if `bulk` is supported.
2.  Use `POST` on `/Bulk`.
3.  Use `bulkId` to link resources created within the same batch.
4.  Always check the `status` code *inside* the response body, not just the HTTP header, to confirm success.
