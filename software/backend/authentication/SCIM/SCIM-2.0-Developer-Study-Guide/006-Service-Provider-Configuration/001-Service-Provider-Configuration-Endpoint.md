Based on **Part 6, Section 29** of your Table of Contents, here is a detailed explanation of the **Service Provider Configuration Endpoint**.

---

# 006-Service-Provider-Configuration
## 001-Service-Provider-Configuration-Endpoint

### What is it?
In SCIM 2.0, the **Service Provider Configuration Endpoint** acts as the "capabilities statement" or the "discovery document" for the SCIM API to which you are connecting.

Because the SCIM standard is flexible, not every Service Provider (server) implements every single feature. For example, some simple servers might not support complex sorting, or they might not allow you to update 1,000 users in a single request (Bulk). Use this endpoint to find out exactly what the server can and cannot do.

**The Endpoint URL:**
```http
GET /ServiceProviderConfig
```
*Note: This endpoint is Read-Only. You cannot POST or PUT to it to change the server's configuration.*

---

### Key Components of the Configuration Resource

When a Client calls this endpoint, the Server returns a JSON object containing specific attributes defined in the schema `urn:ietf:params:scim:schemas:core:2.0:ServiceProviderConfig`.

Here are the specific sub-components mentioned in your Table of Contents:

#### 1. `documentationUri`
*   **Type:** Reference (URL)
*   **Purpose:** This provides a link to human-readable documentation about the Service Provider's specific implementation of SCIM. Use this if you are a developer debugging an integration and need to read the manual.

#### 2. `patch`
*   **Context:** SCIM supports updating resources partially (e.g., just changing a phone number) using the HTTP `PATCH` verb.
*   **Configuration:**
    *   `supported` (Boolean): Does this server accept `PATCH` requests? If `false`, the client must use `PUT` (full resource replacement) for updates.

#### 3. `bulk`
*   **Context:** The `/Bulk` endpoint allows clients to send a single HTTP request containing multiple operations (creates, updates, deletes).
*   **Configuration:**
    *   `supported` (Boolean): Can the server handle bulk requests?
    *   `maxOperations` (Integer): The maximum number of operations allowed in a single payload (e.g., 1000). The client needs to know this so it can chunk its data appropriately.
    *   `maxPayloadSize` (Integer): The maximum size of the request body in bytes.

#### 4. `filter`
*   **Context:** Clients often need to search for specific users (e.g., `filter=userName eq "bjensen"`).
*   **Configuration:**
    *   `supported` (Boolean): Does the server support querying/searching?
    *   `maxResults` (Integer): The maximum number of resources the server will return in a single response. This forces clients to use pagination.

#### 5. `changePassword`
*   **Context:** This defines how password changes are handled.
*   **Configuration:**
    *   `supported` (Boolean): Does the server allow password changes via SCIM?
    *   *Note: In SCIM 2.0, password changes are usually done by updating the standard `password` attribute on the User resource.*

#### 6. `sort`
*   **Context:** Clients may request results be sorted (e.g., `sortBy=name&sortOrder=descending`).
*   **Configuration:**
    *   `supported` (Boolean): Sorting is computationally expensive. Many servers disable this. If `false`, the server ignores sort parameters and returns results in default order (usually by creation date or ID).

#### 7. `etag`
*   **Context:** ETags (Entity Tags) are used for versioning and concurrency control (preventing two people from overwriting the same user at the same time).
*   **Configuration:**
    *   `supported` (Boolean): If `true`, the server will return an `ETag` header with resources. The client can then use `If-Match` headers in updates to ensure they are updating the latest version of the data.

#### 8. `authenticationSchemes`
*   **Context:** This is critical. It tells the Client how to log in to the API. It is a multi-valued complex attribute.
*   **Common Values:**
    *   **OAuth Bearer Token:** Standard for modern apps.
    *   **HTTP Basic:** Username/Password (Base64 encoded).
    *   **API Key:** Simple token passed in a header.
*   **Structure:** Each scheme object typically includes the `name`, `description`, `specUri` (link to auth specs), and `type` (e.g., `oauthbearertoken`).

---

### Example Response
Here is what the JSON response from `/ServiceProviderConfig` looks like in practice:

```json
{
  "schemas": [
    "urn:ietf:params:scim:schemas:core:2.0:ServiceProviderConfig"
  ],
  "documentationUri": "http://example.com/help/scim.html",
  "patch": {
    "supported": true
  },
  "bulk": {
    "supported": true,
    "maxOperations": 1000,
    "maxPayloadSize": 1048576
  },
  "filter": {
    "supported": true,
    "maxResults": 200
  },
  "changePassword": {
    "supported": false
  },
  "sort": {
    "supported": true
  },
  "etag": {
    "supported": true
  },
  "authenticationSchemes": [
    {
      "name": "OAuth Bearer Token",
      "description": "Authentication scheme using the OAuth 2.0 Bearer Token Standard",
      "specUri": "http://www.rfc-editor.org/info/rfc6750",
      "type": "oauthbearertoken",
      "primary": true
    }
  ],
  "meta": {
    "location": "https://example.com/v2/ServiceProviderConfig",
    "resourceType": "ServiceProviderConfig",
    "created": "2023-01-01T12:00:00Z",
    "lastModified": "2023-01-01T12:00:00Z",
    "version": "W/\"v1\""
  }
}
```

### Why is this important for a Developer?

1.  **For Client Developers (Part 10 of your TOC):** Before your code tries to sync 5,000 users, you should call this endpoint. If `bulk.supported` is false, your code must switch to sending 5,000 individual requests. If `patch.supported` is false, you cannot send partial updates.
2.  **For Service Provider Developers (Part 9 of your TOC):** You must implement this endpoint. It is mandatory for SCIM compliance. It allows you to protect your system (by setting `maxOperations` limits) and manage expectations with integrating clients.
