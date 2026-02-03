Based on the Table of Contents provided, here is a detailed explanation of **Part 4, Item 19: Replace Operation (PUT)**.

In the context of REST APIs and specifically SCIM (System for Cross-domain Identity Management), **PUT** is one of the most misunderstood operations because it is destructive by nature. It is distinct from `PATCH` (Partial Update) and has very specific rules regarding how attributes are handled.

---

# 004-Protocol-Operations/004-Replace-Operation-PUT.md

## 1. The Core Concept: Full Resource Replacement

The most important rule of the SCIM PUT operation is that it creates a **new state** for the resource that completely replaces the **old state**.

*   **PATCH:** "Change the email address to `alice@example.com`" (Keeps everything else simple).
*   **PUT:** "Here is the new definition of User 123. It consists *only* of this name and this email."

**The "Missing Attribute" Rule:**
If an attribute exists on the server (e.g., `department: "Sales"`) but you do **not** include it in your PUT request payload, the server interprets this as you wanting to **delete** that attribute. The attribute will be cleared (set to `null` or default).

> **Warning:** You must first `GET` the resource to know its current state, modify the JSON, and then `PUT` the entire JSON back. If you skip the `GET` step, you risk accidentally wiping out data you didn't intend to touch.

## 2. Request Format

To replace a resource, you send a customized HTTP request to the specific resource endpoint.

**URL Structure:**
`https://{host}/scim/v2/{ResourceType}/{id}`

*   **Method:** `PUT`
*   **Headers:**
    *   `Content-Type`: `application/scim+json`
    *   `Authorization`: Bearer {token}
    *   `If-Match`: {ETag} (Highly recommended for concurrency control)

**The Body:**
The body must contain the full representation of the Resource.

**Example Request:**
```json
PUT /Users/2819c223-7f76-453a-919d-413861904646 HTTP/1.1
Host: example.com
Accept: application/scim+json
Content-Type: application/scim+json
If-Match: W/"e180ee84f0671b1"

{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"],
  "id": "2819c223-7f76-453a-919d-413861904646",
  "userName": "bjensen",
  "externalId": "bjensen",
  "name": {
    "formatted": "Ms. Barbara J Jensen III",
    "familyName": "Jensen",
    "givenName": "Barbara"
  },
  "emails": [
    {
      "value": "bjensen@example.com",
      "type": "work",
      "primary": true
    }
  ],
  "active": true
}
```

## 3. Handling Special Attributes

When you send a "Full Replacement," conflict arises between what the Client sends and what the Server enforces. SCIM has specific rules for this:

### A. Immutable Attributes (e.g., `id`, `userName` often)
Attributes defined in the schema as `mutability: immutable` cannot be changed once the resource is created.
*   **Scenario:** You send a PUT request where the `id` in the body is different from the `id` in the URL.
*   **Outcome:** The Server should throw a `400 Bad Request` error with `scimType: mutability`.

### B. Read-Only Attributes (e.g., `meta.created`, `meta.lastModified`, `groups`)
Attributes defined as `mutability: readOnly` are calculated by the server. The client cannot effectively change them.
*   **Scenario:** You send a PUT request containing `"meta": { "created": "1990-01-01" }`.
*   **Outcome:** The Server **ignores** this field. It does not throw an error; it simply discards the client's value and persists its own calculated value.

### C. Write-Only Attributes (e.g., `password`)
*   **Scenario:** You include a `password` field in the PUT request.
*   **Outcome:** The password is updated. However, in the *Response*, the password field will be stripped out (never returned).

## 4. Response Format

Upon a successful replacement, the server returns the **updated resource** as it now exists on the server.

*   **Status Code:** `200 OK`
*   **Body:** The full JSON of the user (including server-generated fields like `meta.lastModified` which will have a new timestamp, and a new ETag version).

*Note: If specific attributes were requested to be excluded via the `excludedAttributes` parameter, the response will be partial.*

## 5. Status Codes

*   **200 OK:** The resource was successfully replaced.
*   **400 Bad Request:** The JSON is malformed, or you tried to modify an immutable attribute, or a required attribute is missing from the payload.
*   **404 Not Found:** The ID specified in the URL does not exist. (PUT is usually not used to create new users in SCIM, only to update existing ones).
*   **409 Conflict:** The modification would result in a duplicate value for a unique attribute (e.g., changing `userName` to one that already exists).
*   **412 Precondition Failed:** You provided an `If-Match` header (ETag), but the version on the server has changed since you last read it. This prevents overwriting someone else's work.

## 6. Comparison: PUT vs. PATCH

This is the most critical distinction for developers:

| Feature | PUT (Replace) | PATCH (Partial Update) |
| :--- | :--- | :--- |
| **Logic** | "Replace everything with this." | "Change only field X and Y." |
| **Missing Fields** | Deleted/Cleared. | Ignored/Preserved. |
| **Payload Size** | Large (Full object). | Small (Diff/Changeset). |
| **Bandwidth** | Heavy. | Light. |
| **Use Case** | Synchronization (ensure target matches source exactly). | User updates (e.g., just changing a phone number). |

## 7. Summary Workflow

To implement a robust **PUT** operation in a client application, follow this flow:
1.  **GET** the user (e.g., User A).
2.  Store the `meta.version` (ETag).
3.  Modify the object in memory (change email, remove department).
4.  **PUT** the modified object back to the server using the ETag in the `If-Match` header.
5.  If you receive `412 Precondition Failed`, go back to step 1 (someone else modified the user while you were working).
6.  If you receive `200 OK`, the update is complete.
