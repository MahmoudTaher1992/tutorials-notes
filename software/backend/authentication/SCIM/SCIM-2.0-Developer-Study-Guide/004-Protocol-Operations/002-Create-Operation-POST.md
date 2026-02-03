Based on **Part 4, Item 17** of your Table of Contents, here is a detailed explanation of the **Create Operation (POST)** in SCIM 2.0.

---

# 17. Create Operation (POST)

The **Create** operation is the primary mechanism used by a Client (like an Identity Provider, e.g., Azure AD or Okta) to add new resources to a Service Provider (your application). While this usually refers to creating **Users**, it applies equally to **Groups** and custom resources.

In SCIM, creating a resource is strictly done via the HTTP **POST** verb.

## 1. The Request

To create a resource, the SCIM client issues a POST request to the resource type endpoint (e.g., `/Users` or `/Groups`).

### Anatomy of the Request
1.  **URL:** `https://api.example.com/scim/v2/Users`
2.  **Method:** `POST`
3.  **Headers:**
    *   `Content-Type`: Must be `application/scim+json` (though many implementations accept `application/json` for compatibility).
    *   `Authorization`: Bearer token or other credentials.
4.  **Body:** A JSON object representing the resource.

### Important Rules for the Request Body
*   **The `schemas` Attribute:** Every SCIM resource **must** include the `schemas` attribute containing the URIs of the schemas used in the payload.
*   **No ID:** The client typically **should not** send an `id` in the POST body. The Service Provider is responsible for generating a globally unique identifier.
*   **Required Attributes:** The request must contain all attributes marked as "required" in the schema (e.g., `userName` for users).

### Example JSON Request (Creating a User)

```json
POST /Users
Host: api.example.com
Content-Type: application/scim+json
Authorization: Bearer <token>

{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"],
  "externalId": "701984",
  "userName": "jdoe@example.com",
  "name": {
    "givenName": "John",
    "familyName": "Doe"
  },
  "emails": [
    {
      "value": "jdoe@example.com",
      "type": "work",
      "primary": true
    }
  ],
  "active": true
}
```

---

## 2. Server-Side Processing

When the Service Provider receives the POST request, it performs several operations before saving the data:

1.  **Validation:** Checks if the JSON is valid, if required fields are present, and if data types match the schema (e.g., ensuring `active` is a boolean).
2.  **Uniqueness Check:** Checks for uniqueness where required (e.g., does a user with this `userName` already exist?).
3.  **ID Generation:** The server generates a unique string for the `id` attribute.
4.  **Metadata Generation:** The server populates the `meta` complex attribute (created date, last modified date, location URL, and version/Etag).
5.  **Handling "Write-Only" Schema:** If the request includes a `password`, the server hashes/processes it but does **not** return it in the response.
6.  **Read-Only Attributes:** If the client tries to set a read-only attribute (like `meta.created`), the server generally ignores that specific field rather than throwing an error.

---

## 3. The Response

If the creation is successful, the server must return a strict set of data to confirm the operation.

### Success Status Code
*   **201 Created:** This is the standard success code.

### Response Headers
*   **Location:** The server **must** return the HTTP Location header containing the absolute URI of the newly created resource (e.g., `https://api.example.com/scim/v2/Users/2819c223...`).
*   **ETag:** (Optional but recommended) The version identifier of the resource.

### Response Body
The body must contain the **full representation** of the created resource. This is different from a typical REST API which might return just an ID. In SCIM, the response includes:
1.  The server-generated `id`.
2.  The server-generated `meta` data.
3.  All attributes stored (including default values applied by the server).

### Example JSON Response

```json
HTTP/1.1 201 Created
Content-Type: application/scim+json
Location: https://api.example.com/scim/v2/Users/2819c223-7f76-453a-919d-413861904646
ETag: W/"3694e05e9dff591"

{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"],
  "id": "2819c223-7f76-453a-919d-413861904646",
  "externalId": "701984",
  "meta": {
    "resourceType": "User",
    "created": "2023-10-27T04:00:00Z",
    "lastModified": "2023-10-27T04:00:00Z",
    "location": "https://api.example.com/scim/v2/Users/2819c223-7f76-453a-919d-413861904646",
    "version": "W/\"3694e05e9dff591\""
  },
  "userName": "jdoe@example.com",
  "name": {
    "givenName": "John",
    "familyName": "Doe"
  },
  "emails": [
    {
      "value": "jdoe@example.com",
      "type": "work",
      "primary": true
    }
  ],
  "active": true
}
```

---

## 4. Error Handling

If the creation fails, the server must return an appropriate HTTP status code and a SCIM Error JSON body.

### Common Error Codes for POST

1.  **409 Conflict:**
    *   *Cause:* The client tried to create a User with a `userName` (or other unique attribute) that already exists in the system.
    *   *Uniqueness:* This is the most common error during provisioning.
2.  **400 Bad Request:**
    *   *Cause:* The JSON syntax is invalid, a required attribute is missing, or a data type is wrong (e.g., sending a string for a boolean field).
    *   *SCIM Detail:* Should include `scimType: "invalidSyntax"` or `scimType: "invalidValue"`.
3.  **403 Forbidden:**
    *   *Cause:* The authenticated token works, but the client doesn't have permission to create users.
4.  **404 Not Found:**
    *   *Cause:* (Rare for POST) Usually implies the endpoint `/Users` is incorrect.

### Example Error Response (Conflict)

```json
HTTP/1.1 409 Conflict
Content-Type: application/scim+json

{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:Error"],
  "status": "409",
  "scimType": "uniqueness",
  "detail": "User with userName 'jdoe@example.com' already exists."
}
```

---

## 5. Key Concept: Attribute Persistence (Returned vs. Stored)

One tricky part of the SCIM POST operation is handling different attribute characteristics:

1.  **Write-Only (`password`):** The client sends `password: "Secret123"`. The server saves the hash. The server sends back the JSON response *without* the password field.
2.  **Read-Only (`groups` in some implementations):** If a client tries to add a user to a group inside the User POST payload (e.g., sending a `groups` array), the server might ignore it because many systems require you to update the *Group* resource to add members, rather than the User resource.
3.  **Defaults:** If the client excludes `active` (and the schema defaults to `true`), the server creates the user as active and returns `active: true` in the response body.

## Summary Checklist for Developers

*   [ ] Ensure the endpoint is strictly `POST`.
*   [ ] Validate that the `schemas` array is present.
*   [ ] Generate a unique `id` on the server (do not rely on the client).
*   [ ] Return valid JSON with status `201 Created`.
*   [ ] Always return the `Location` header.
*   [ ] Never return the password in the response body.
*   [ ] Check for `userName` uniqueness and return `409 Conflict` if needed.
