Based on **Section 18** of your Table of Contents, here is a detailed explanation of the **Read Operation (GET)** in SCIM 2.0.

---

# Detailed Explanation: SCIM Read Operation (GET)

In SCIM 2.0, the **GET** method is the primary mechanism for retrieving resource information from a Service Provider. It corresponds to the **Read** function in standard CRUD (Create, Read, Update, Delete) architecture.

While GET is also used for searching and listing users (which is covered in Section 22), **Section 18 specifically focuses on retrieving a single resource by its unique identifier.**

## 1. Retrieving a Single Resource
To retrieve a specific identity (User) or object (Group), the Client must know the resource's unique `id`.

*   **The `id`:** This is the server-assigned, unique identifier (e.g., a UUID like `2819c223-7f76-453a-919d-413861904646`). It is assigned when the resource is created via POST.
*   **The Operation:** The client sends an HTTP GET request to the specific URL of that resource.

## 2. Resource Endpoint URLs
SCIM URLs follow a strict RESTful hierarchy. To get a specific resource, you append the resource's ID to the endpoint path.

**Format:**
`GET {BaseURL}/{ResourceType}/{id}`

**Examples:**
*   **Get a User:** `GET https://api.example.com/scim/v2/Users/2819c223-7f76-453a-919d-413861904646`
*   **Get a Group:** `GET https://api.example.com/scim/v2/Groups/e9e30dba-f08f-4109-8486-d5c6a331660a`

## 3. Response Format
If the request is successful, the Service Provider returns:
1.  **HTTP Status 200 OK**
2.  **Headers:** Including `Content-Type: application/scim+json` and an `ETag` (identifying the version of the resource).
3.  **Body:** A JSON object representing the full resource.

**Key components of the response body:**
*   **`schemas`:** The list of schema URIs defining the resource (e.g., Core User, Enterprise Extension).
*   **`id`:** The unique ID (matching the URL).
*   **`meta`:** Metadata about the resource (creation time, last modified time, version).
*   **Attributes:** All readable attributes (email, name, active status, etc.).

## 4. Attribute Selection (Projection)
Sometimes, a resource contains a massive amount of data (e.g., a Group with 50,000 members, or a User with a large photo blob), but the Client only needs specific fields. SCIM allows you to request only what you need.

### A. The `attributes` Parameter (Whitelisting)
This tells the server: "Return *only* these specific fields."
*   **Request:** `GET /Users/{id}?attributes=userName,emails`
*   **Result:** The server returns the `id`, `schemas`, `meta`, plus *only* `userName` and `emails`. All other data is stripped.

### B. The `excludedAttributes` Parameter (Blacklisting)
This tells the server: "Return everything *except* these specific fields."
*   **Request:** `GET /Users/{id}?excludedAttributes=photos,groups`
*   **Result:** The server returns the full user object but omits the `photos` and `groups` arrays to save bandwidth.

## 5. Status Codes
These are the standard HTTP status codes expected for a GET by `id` operation:

| Code | Meaning | Context |
| :--- | :--- | :--- |
| **200** | OK | The resource was found and returned successfully. |
| **304** | Not Modified | Used if the Client sent an `If-None-Match` header (ETag) and the resource has not changed since that version. The body will be empty. |
| **404** | Not Found | The `id` provided in the URL does not exist in the Service Provider. |
| **403** | Forbidden | The client is authenticated but does not have permission to view this specific resource. |
| **401** | Unauthorized | The client failed authentication (bad token/password). |

## 6. Error Handling
If the request fails (e.g., 404 Not Found), the response body should contain a SCIM Error message formatted in JSON to help the developer understand why.

**Example Error Response:**
```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:Error"],
  "status": "404",
  "detail": "Resource 2819c223... not found"
}
```

## 7. Complete Examples

### Scenario A: Successful Full Retrieval
**Request:**
```http
GET /scim/v2/Users/2819c223-7f76-453a-919d-413861904646 HTTP/1.1
Host: api.example.com
Authorization: Bearer <token>
Accept: application/scim+json
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/scim+json
ETag: W/"3694e05e9dff591"

{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"],
  "id": "2819c223-7f76-453a-919d-413861904646",
  "meta": {
    "resourceType": "User",
    "created": "2023-01-10T02:00:12Z",
    "lastModified": "2023-01-12T02:00:12Z",
    "location": "https://api.example.com/scim/v2/Users/2819c223..."
  },
  "userName": "bjensen",
  "name": {
    "formatted": "Ms. Barbara J Jensen III",
    "familyName": "Jensen",
    "givenName": "Barbara"
  },
  "active": true,
  "emails": [
    {
      "value": "bjensen@example.com",
      "type": "work",
      "primary": true
    }
  ]
}
```

### Scenario B: Attribute Selection (Minimizing Data)
**Request:**
We only want to know if the user is active or not.
```http
GET /scim/v2/Users/2819c223...?attributes=active,userName HTTP/1.1
Authorization: Bearer <token>
```

**Response:**
```json
{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"],
  "id": "2819c223-7f76-453a-919d-413861904646",
  "userName": "bjensen",
  "active": true
}
```
*(Note: `schemas` and `id` are always returned, even if not requested).*
