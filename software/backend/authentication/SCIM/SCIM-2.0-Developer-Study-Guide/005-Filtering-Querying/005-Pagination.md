Based on the Table of Contents, you are asking for a detailed explanation of **Section 28: Pagination**, which is part of *Part 5: Filtering & Querying*.

In SCIM 2.0 (RFC 7644), pagination is the mechanism used to retrieve large datasets for a resource (like Users or Groups) in smaller, manageable chunks rather than receiving thousands of records in a single HTTP response.

Here is a detailed breakdown of how SCIM pagination works.

---

### 1. Index-Based Pagination (The Standard)

SCIM uses an "offset-based" or "index-based" system. Unlike many programming arrays that start at 0, **SCIM is 1-based**. The first item in a list is at index 1.

There are two primary query parameters used in the HTTP GET request to control this:

#### `startIndex`
*   **Definition:** The 1-based index of the first result in the current set of list results.
*   **Default:** If omitted, the server assumes `startIndex=1`.
*   **Behavior:**
    *   `startIndex=1` gets the first record.
    *   `startIndex=11` skips the first 10 records and starts at the 11th.
    *   If the `startIndex` is greater than the total number of results, the server returns an empty list (no error).

#### `count`
*   **Definition:** The maximum number of resources the client wants returned in the response.
*   **Default:** There is no strict standard default, but servers usually default to a reasonable number (e.g., 20, 50, or 100) if not specified.
*   **Behavior:**
    *   This is an **upper limit**. The server may return fewer items than requested (due to server-side limits or running out of results), but it should never return more.
    *   **Special Case (`count=0`):** If a client requests `count=0`, the server should return a response with **no resources**, but populated `totalResults`. This is used to "check the size" of a query without downloading the data.

---

### 2. The Response Structure (`ListResponse`)

When a client requests a list of resources, the server returns a JSON object specifically formatted as a `ListResponse`. It contains metadata about the pagination so the client knows "where" they are in the dataset.

**Example Request:**
```http
GET /Users?startIndex=1&count=5
```

**Example Response:**
```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:ListResponse"],
  "totalResults": 100,
  "itemsPerPage": 5,
  "startIndex": 1,
  "Resources": [
    { "id": "user1", "userName": "alice" },
    { "id": "user2", "userName": "bob" },
    ... (3 more users)
  ]
}
```

#### Pagination Attributes in Response:
*   **`totalResults`**: The total number of results matching the client's query (filter). In the example above, even though we only asked for 5, there are 100 users total in the database.
*   **`itemsPerPage`**: The distinct number of resources returned in the `Resources` array. This usually matches the requested `count`, unless you are on the last page.
*   **`startIndex`**: The index corresponding to the first resource in this specific response.

---

### 3. How to Iterate (The Logic)

To retrieve all users, a client application implements a loop:

1.  **Requests Page 1:** `?startIndex=1&count=100` helps
2.  **Server Responds:** `totalResults: 500`, `itemsPerPage: 100`.
3.  **Client Calculates:** "I have 100 out of 500. I need to get the next batch."
4.  **Requests Page 2:** `?startIndex=101&count=100` (Previous startIndex + previous itemsPerPage).
5.  **Repeat** until `startIndex + itemsPerPage - 1 >= totalResults`.

---

### 4. Cursor-Based Pagination (Non-Standard)

While SCIM defines index-based pagination, large-scale Service Providers (like Slack, Facebook, or extensive directories) often struggle with it. Using `startIndex` on a database with millions of users is performance-heavy (the database has to count through 1,000,000 records just to return record 1,000,001).

SCIM allows for extension parameters. Some implementations opt for **Cursor-Based Pagination**:
*   Instead of `startIndex`, the client sends `nextCursor=eyJ...`.
*   The server returns a `nextCursor` string in the response metadata.
*   This is faster for the database but prevents the client from jumping to a specific page (e.g., "Go to page 5"). They can only click "Next".
*   *Note: This is not in the core RFC 7644 spec but is a common real-world adaptation.*

---

### 5. Best Practices & Edge Cases

#### Sorting is Crucial
If you paginate without sorting (e.g., `sortBy=userName`), the database might return results in an inconsistent order. You might see "Alice" on Page 1, and then see "Alice" again on Page 2 if the database internal order shifted. Always combine pagination with a sort.

#### Large Dataset Handling
*   **Server Side:** Servers usually enforce a hard limit (cap). If a client requests `count=10000`, the server should ignore that and return a safe max (e.g., 500) and indicate `itemsPerPage=500`.
*   **Client Side:** Clients should never assume `itemsPerPage` equals the `count` they requested. Always trust the `itemsPerPage` returned by the server.

#### Data Consistency (The "Moving Target" Problem)
Because SCIM is stateless, data can change between pages.
*   *Scenario:* You fetch Page 1 (Users 1-10).
*   *Event:* User 5 is deleted by an admin.
*   *Scenario:* You fetch Page 2 starting at index 11.
*   *Result:* Because User 5 is gone, everybody shifted up. The user that *was* at index 11 is now at index 10. You just missed a user.
*   *Fix:* This is an inherent weakness of index-based pagination. Cursor-based pagination solves this, but for standard SCIM, clients simply have to be aware of this risk during long synchronizations.
