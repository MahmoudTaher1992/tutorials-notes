Based on **Part 5: Filtering & Querying** of the study guide, here is a detailed explanation of section **27. Sorting**.

This section details how a Client (e.g., an Identity Provider) requests that the Service Provider (the API) return resources in a specific order. This is defined in **RFC 7644 Section 3.4.2.3**.

---

### **27. Sorting**

Sorting is a feature used during **HTTP GET (List)** requests. It allows the client to organize the output, which is particularly useful when displaying lists of users in a UI or when performing pagination to ensure a deterministic order of records.

It is important to note that **sorting is optional** for Service Providers. A client can discover if a server supports sorting by checking the `/ServiceProviderConfig` endpoint.

#### **1. `sortBy` Parameter**
The `sortBy` parameter specifies the attribute whose value will determine the order of the results.

*   **Syntax:** Use the attribute name as defined in the SCIM schema.
*   **Case Sensitivity:** The sorting logic typically respects the `caseExact` boolean defined in the attribute's schema definition. For example, `userName` is often case-insensitive, while specialized IDs might be case-sensitive.
*   **Namespace:** If the attribute is part of an extension (like the Enterprise User extension), strictly speaking, you should include the full schema URN, though many implementations allow the short name if it is unique.

**Example Request:**
```http
GET /Users?sortBy=userName
```
*Result:* Returns the list of users ordered alphabetically by their unique username.

#### **2. `sortOrder` Parameter**
The `sortOrder` parameter dictates the direction of the sort applied to the attribute defined in `sortBy`. This parameter is ignored if `sortBy` is not present.

*   **Valid Values:**
    *   `ascending`: Sorts from A to Z, 0 to 9, or oldest to newest.
    *   `descending`: Sorts from Z to A, 9 to 0, or newest to oldest.

**Example Request:**
```http
GET /Users?sortBy=meta.lastModified&sortOrder=descending
```
*Result:* Returns users starting with the one most recently updated.

#### **3. Default Sort Order**
If the Client provides a `sortBy` parameter but **omits** the `sortOrder` parameter, the SCIM specification mandates a default behavior:

*   **The default is `ascending`.**

**Example:**
```http
GET /Users?sortBy=title
```
Is functionally equivalent to:
```http
GET /Users?sortBy=title&sortOrder=ascending
```

*Note: If the client provides neither `sortBy` nor `sortOrder`, the order of results is undefined and depends entirely on the database implementation (often insertion order or primary key order).*

#### **4. Sorting Complex Attributes**
Complex attributes are attributes that hold other sub-attributes (e.g., `name` contains `familyName` and `givenName`).

*   **Dot Notation:** To sort by a complex attribute, you must specify the exact sub-attribute path using a period (`.`). You cannot simply sort by `name`; you must sort by `name.familyName`.
*   **Multi-Valued Complex Attributes:** This is the most difficult scenario (e.g., sorting by `emails.value`). Since a user can have multiple emails, the Service Provider usually looks for the sub-attribute where `primary` is `true`.
    *   If no value is marked "primary," the behavior is implementation-specific (the server might pick the first value it finds to use as the sort key).

**Example Request:**
```http
GET /Users?sortBy=name.familyName
```

#### **5. Multi-Level Sorting Limitations**
In SQL, you can easily do something like `ORDER BY Department, LastName` (sorting by department, and then by name within that department).

*   **SCIM Limitation:** The SCIM 2.0 standard **does not support multi-level sorting**.
*   You can strictly provide **only one** attribute in the `sortBy` parameter.
*   If a client sends `sortBy=department,name.familyName`, the server will likely return a `400 Bad Request` or an `invalidSyntax` error.

**Workaround:** If multi-level sorting is required, the Client must request the data sorted by the primary requirement (e.g., Department) and then perform the secondary sort (e.g., Name) in memory on the Client side.

---

### **Summary Table**

| Parameter | Required? | Description | Example |
| :--- | :--- | :--- | :--- |
| **`sortBy`** | Optional | The attribute string to sort by. | `userName`, `name.familyName` |
| **`sortOrder`** | Optional | Direction of sort. Defaults to `ascending`. | `ascending`, `descending` |

### **Example Scenario: Pagination with Sorting**
Sorting is rarely used alone; it is almost always paired with Pagination (`startIndex` and `count`) to ensure the user doesn't miss records as they click "Next Page."

**Request:** "Give me the first 10 users, sorted by their Employee Number (descending)."

```http
GET /Users?startIndex=1&count=10&sortBy=urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:employeeNumber&sortOrder=descending
```
