Based on the Table of Contents you provided, here is a detailed, engineering-focused explanation of Section **3.C. Searching & Filtering**.

This section describes how the Identity Provider (IdP) queries your application to see who already exists, who needs updates, or to list users for reconciliation.

---

# 3.C. Searching & Filtering

In the SCIM protocol, Searching and Filtering are performed via HTTP `GET` requests on the resource endpoints (e.g., `/Users` or `/Groups`).

Without these features, an IdP (like Okta or Azure AD) would be blind. Before it tries to create a user `alice@company.com`, it needs to ask your app: *"Does Alice already exist?"* If you don't implement this, the IdP will try to create a duplicate, receive a conflict error, and the sync will fail.

## i. The Filter Parameter

The `filter` parameter is essentially a SQL `WHERE` clause passed via the URL query string. It allows clients to define complex criteria to return specific subsets of resources.

### The Syntax
The basic syntax is: `Attribute Operator Value`

**Example:**
```http
GET /Users?filter=userName eq "bjensen@example.com"
```

### The Operators
To implement this, your backend needs to parse these operators and translate them into database queries (e.g., SQL, Mongo). Common operators include:

| Operator | Meaning | SQL Equivalent | Use Case |
| :--- | :--- | :--- | :--- |
| **eq** | Equals | `=` | Finding a specific user by email or username. |
| **ne** | Not Equals | `<>` | Excluding specific users. |
| **co** | Contains | `LIKE '%...%'` | Searching users by substring (expensive op). |
| **sw** | Starts With | `LIKE '...%'` | Autocomplete or finding users by department prefix. |
| **pr** | Present | `IS NOT NULL` | Finding users who have a specific attribute populated (e.g., users with an ID). |
| **gt/lt** | Greater/Less Than | `>` / `<` | Filtering by `meta.lastModified` (Syncs since date X). |
| **and/or** | Logical | `AND` / `OR` | Complex queries. |

### Handling Complex/Nested Attributes
SCIM resources are JSON. Attributes like `emails` are complex arrays.
A filter might look like this:
`filter=emails[type eq "work" and value co "@example.com"]`

**Engineering Challenge:**
This requires your parser to handle nested logic. You are asking: *"Find me users where one of the items in the 'emails' array has a type of 'work' AND that same item's value contains '@example.com'."*

### URL Encoding
IdPs will URL-encode the filter. Your server must decode this before processing.
*   **Raw:** `userName eq "alice"`
*   **Sent:** `userName%20eq%20%22alice%22`

---

## ii. Pagination

SCIM synchronization often involves thousands of users. If an IdP asks for a list of all users (`GET /Users`), and you return 50,000 JSON objects in one request, your API will time out or crash.

SCIM handles this via **Offset Pagination** (not cursor-based).

### The Parameters
The client sends these two parameters in the URL query string:

1.  **`startIndex`**: The 1-based index of the first result to return.
    *   **CRITICAL NOTE:** SCIM is **1-based** (like Lua or Fortran), not 0-based.
    *   `startIndex=1` is the first item.
2.  **`count`**: The specific number of items the client wants (page size).

**Request Example:**
*"Give me page 2, assuming a page size of 10."*
```http
GET /Users?startIndex=11&count=10
```

### The Response (`ListResponse`)
When returning a list (filtered or not), you must wrap the user objects in a standard SCIM `ListResponse` envelope so the IdP knows how many pages exist.

**JSON Response Structure:**
```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:ListResponse"],
  "totalResults": 500,    // How many matches exist in the DB total (for this filter)
  "startIndex": 11,       // The start index you are returning
  "itemsPerPage": 10,     // How many items are in the 'Resources' array below
  "Resources": [
      { "id": "123", "userName": "Bob", ... },
      { "id": "124", "userName": "Alice", ... }
      // ... 8 more users
  ]
}
```

---

## Engineering Implementation Notes ("Gotchas")

If you are building the SCIM Server, keep these three things in mind:

1.  **Case Insensitivity:**
    The SCIM spec dictates that filtering on strings (like `userName`) should be **case-insensitive**.
    *   `filter=userName eq "Alice"` should match `alice`.
    *   *Implementation:* If your underlying database is Case Sensitive (e.g., standard Postgres), you must implement `LOWER(col) = LOWER(val)` or use case-insensitive collation keys.

2.  **Attribute Selection (`attributes` param):**
    Sometimes an IdP only wants to check IDs to sync groups. They might send:
    `GET /Users?attributes=id,userName`
    To save bandwidth and DB processing, your API should only return those specific fields in the JSON response, ignoring the rest (like the massive `photo` blob).

3.  **Parsing Libraries:**
    **Reinventing the wheel is dangerous here.** Writing a Regex to parse a complex SCIM filter string (`(a eq b) or (c pr)`) is error-prone and vulnerable to injection attacks.
    *   *Recommendation:* Use an existing SCIM SDK for your language (e.g., `scim-sdk-java`, `scim2-csharp`, or standard libraries in Node.js) to parse the filter string into an Abstract Syntax Tree (AST) that you can safely convert to a DB query.
