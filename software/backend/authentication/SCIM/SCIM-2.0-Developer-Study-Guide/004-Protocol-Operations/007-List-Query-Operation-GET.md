Based on **Part 4, Section 22** of your Table of Contents, here is a detailed explanation of the **List/Query Operation (GET)** in SCIM 2.0.

---

# 007-List-Query-Operation-GET (SCIM 2.0)

In SCIM 2.0, retrieving multiple resources (like Users or Groups) is done via the **List/Query Operation**. While retrieving a specific user by ID is simple, real-world integrations need to search, sort, and page through thousands of identities.

This operation uses the HTTP `GET` method on the root resource endpoint (e.g., `/Users` or `/Groups`).

## 1. The Basic List Request

At its simplest, a client can ask for all resources of a specific type.

**Request:**
```http
GET /Users
Host: example.com
Accept: application/scim+json
Authorization: Bearer <token>
```

**Response (ListResponse):**
Unlike standard REST APIs which might return a simple JSON array `[]`, SCIM returns a wrapper object called a `ListResponse`.

```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:ListResponse"],
  "totalResults": 100,
  "startIndex": 1,
  "itemsPerPage": 10,
  "Resources": [
    {
      "id": "2819c223...",
      "userName": "bjensen",
      "name": {
        "givenName": "Barbara",
        "familyName": "Jensen"
      }
      // ... other attributes
    },
    // ... more users
  ]
}
```

### Key Response Attributes:
*   **`schemas`**: Identifies this payload as a SCIM ListResponse.
*   **`totalResults`**: The total number of resources that match the request (useful for calculating how many total pages exist).
*   **`startIndex`**: The 1-based index of the first result in the current set.
*   **`itemsPerPage`**: The number of resources returned in this specific response.
*   **`Resources`**: The actual array of resource objects.

---

## 2. Filtering (Searching)

To search for specific users, you append the `filter` query parameter. This allows the client to define complex search criteria.

**Syntax:** `?filter={attribute} {operator} {value}`

**Examples:**

1.  **Exact Match:** Find a user with a specific username.
    ```http
    GET /Users?filter=userName eq "bjensen"
    ```

2.  **Contains:** Find users whose email contains "example.com".
    ```http
    GET /Users?filter=emails.value co "example.com"
    ```

3.  **Logical Operators:** Find active users in the Engineering department.
    ```http
    GET /Users?filter=active eq true and urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:department eq "Engineering"
    ```

*Note: In practice, filter strings must be URL-encoded (e.g., spaces become `%20`, quotes become `%22`).*

---

## 3. Pagination

If you have 50,000 users, you cannot download them all in one request; it would time out. SCIM uses **Offset-Based Pagination**.

### Parameters:
*   **`startIndex`**: The 1-based index (not 0-based) of the first query result. Default is 1.
*   **`count`**: The maximum number of results the client wants in the response.

### Pagination Workflow Example:

**Step 1: Get the first 50 users.**
```http
GET /Users?startIndex=1&count=50
```
*Server replies with items 1 through 50.*

**Step 2: Get the next 50 users.**
```http
GET /Users?startIndex=51&count=50
```
*Server replies with items 51 through 100.*

### Zero-Count Request
A client can send `count=0` to perform a "count only" query. This returns `totalResults` (how many match) but returns an empty `Resources` array. This is useful for dashboard counters.

---

## 4. Sorting

Clients can request the server to return the results in a specific order using `sortBy` and `sortOrder`.

### Parameters:
*   **`sortBy`**: The specific attribute to sort by (e.g., `userName`, `name.familyName`, `meta.lastModified`).
*   **`sortOrder`**:
    *   `ascending` (Default)
    *   `descending`

**Example:**
Get users, sorted by their Last Name A-Z.
```http
GET /Users?sortBy=name.familyName&sortOrder=ascending
```

---

## 5. Attribute Selection (Projection)

To improve performance and reduce bandwidth, a client can ask the server to return **only** specific attributes (or exclude specific ones). This is heavily used when listed views only need a name and ID, not the full profile.

### Parameters:
*   **`attributes`**: A comma-separated list of attributes to include.
*   **`excludedAttributes`**: A comma-separated list of attributes to remove from the default set.

**Example: Minimal Response**
The client only wants the ID and Username.
```http
GET /Users?attributes=id,userName
```

**Response:**
```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:ListResponse"],
  "totalResults": 5,
  "Resources": [
    {
      "id": "2819c...",
      "userName": "bjensen"
      // No other attributes like emails, phoneNumbers, etc. are returned
    }
    //...
  ]
}
```

---

## Summary of Query Parameters

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `filter` | String | Filter expression for searching. |
| `startIndex` | Integer | The 1-based index of the first result (Pagination). |
| `count` | Integer | The maximum number of items to return (Pagination). |
| `sortBy` | String | The attribute to sort results by. |
| `sortOrder` | String | `ascending` or `descending`. |
| `attributes` | String | Comma-separated list of attributes to return. |
| `excludedAttributes` | String | Comma-separated list of attributes to hide. |

## Common Implementation Constraints
1.  **Case Sensitivity:** SCIM standardizes schema URIs as case-insensitive, but attribute values' sensitivity depends on the schema definition (e.g., `userName` is usually not case specific, but IDs are).
2.  **Max Count:** Most servers enforce a hard limit on `count`. If you request `count=10000`, the server may override it and return only 100, indicating via `itemsPerPage` that it limited the result.
3.  **Filtering Complexity:** Not all Service Providers support complex filtering (like `or`, `not`, or grouping `()`). Clients should verify support via the `/ServiceProviderConfig` endpoint.
