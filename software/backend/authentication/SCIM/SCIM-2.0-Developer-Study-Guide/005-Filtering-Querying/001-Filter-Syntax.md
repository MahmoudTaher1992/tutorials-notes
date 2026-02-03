Based on the Table of Contents provided, **Section 24: Filter Syntax** (under Part 5: Filtering & Querying) deals with how a client asks the key question via the API: *"Find me specific resources that match these criteria."*

In SCIM 2.0 (RFC 7644), you don't write SQL queries. Instead, you use a specific string syntax passed in the URL query parameter named `filter`.

Here is a detailed explanation of **005-Filtering-Querying/001-Filter-Syntax.md**.

---

# Detailed Explanation: SCIM 2.0 Filter Syntax

## 1. The Basics
To filter resources, the Client sends an HTTP `GET` request to the Service Provider. The filter is passed as a URL query parameter.

**The URL structure:**
```http
GET /Users?filter={filterExpression}
```

*Note: In a real HTTP request, the filter string must be URL-encoded (e.g., spaces become `%20`), but for readability, we will write them as plain text below.*

## 2. Anatomy of a Filter Expression
A basic filter expression consists of three parts:
`[Attribute Path]` + `[Operator]` + `[Comparison Value]`

**Example:**
`userName eq "bjensen"`

1.  **Attribute Path:** The name of the field you are checking (e.g., `userName`, `active`, `emails.value`).
2.  **Operator:** How you want to compare them (e.g., `eq` for equals).
3.  **Comparison Value:** The data you are looking for (strings must be in quotes `" "`, numbers and booleans are not).

## 3. Comparison Operators
SCIM defines a specific set of abbreviations for operators. You cannot use symbols like `=`, `>`, or `<`.

| Operator | Meaning | Description | Example |
| :--- | :--- | :--- | :--- |
| **`eq`** | Equal | The attribute value must exactly match. | `userName eq "alice"` |
| **`ne`** | Not Equal | The attribute value must NOT match. | `userType ne "intern"` |
| **`co`** | Contains | The attribute string contains the specified substring. | `displayName co "Smith"` |
| **`sw`** | Starts With | The attribute string starts with the substring. | `userName sw "j"` |
| **`ew`** | Ends With | The attribute string ends with the substring. | `emails.value ew "@example.com"` |
| **`gt`** | Greater Than | Primarily for numbers or Dates. | `meta.lastModified gt "2023-01-01T00:00:00Z"` |
| **`ge`** | Greater or Equal | Greater than or equal to the value. | `age ge 18` |
| **`lt`** | Less Than | Less than the value. | `meta.created lt "2022-01-01T00:00:00Z"` |
| **`le`** | Less or Equal | Less than or equal to the value. | `itemCount le 5` |
| **`pr`** | Present | Checks if the attribute exists and is not null. (No value required). | `title pr` |

## 4. Logical Operators & Grouping
You can combine multiple criteria using logical operators.

| Operator | Meaning | Example |
| :--- | :--- | :--- |
| **`and`** | Both must be true | `title eq "Manager" and active eq true` |
| **`or`** | At least one is true | `userType eq "Employee" or userType eq "Contractor"` |
| **`not`** | Inverts the result | `not (userType eq "Guest")` |

**Grouping:**
Parentheses `()` are used to enforce precedence (order of operations).
*Example:* Find high-level employees who are either in Engineering or Sales.
```text
(department eq "Engineering" or department eq "Sales") and title eq "VP"
```

## 5. Complex Attribute Filtering (The "Path" problem)
This is the most misunderstood part of SCIM filtering. Use this when filtering attributes that are **lists of objects** (like `emails` or `addresses`).

### The Data Structure (JSON)
Imagine a user has this data:
```json
"emails": [
  { "value": "bob@work.com", "type": "work" },
  { "value": "bobby123@gmail.com", "type": "home" }
]
```

### The Wrong Way
If you want to find a user whose **work** email is "bob@work.com", you might try:
`emails.value eq "bob@work.com" and emails.type eq "work"`

**Why this is dangerous:** This query asks: "Does the user have *any* email equal to bob@work.com AND does the user have *any* email composed of type 'work'?"
This could match a user who has `bob@work.com` (as a home, non-work email) and `alice@other.com` (as a work email).

### The Right Way (Value Path Filtering)
To ensure the logic applies to the **same item** inside the list, use square brackets `[]`.

**Syntax:**
`attribute[innerAttribute operator "value" and innerAttribute operator "value"]`

**Example:**
```text
emails[value eq "bob@work.com" and type eq "work"]
```
This query asks: "Is there a *single entry* inside the emails list where the value matches AND the type matches?"

## 6. Real-World Practical Examples

**1. Find a user by specific ID (Retrieve Collection vs Single):**
```http
GET /Users?filter=id eq "2819c223-7f76-453a-919d-413861904646"
```
*(Note: Usually you would use `GET /Users/2819...` but filtering by ID is valid syntax).*

**2. Find all active users created after 2023:**
```http
GET /Users?filter=active eq true and meta.created gt "2023-01-01T00:00:00Z"
```

**3. Find all users identified as "Managers" in the Enterprise Extension:**
SCIM extensions use URIs. Use the URI to reference extended attributes.
```http
GET /Users?filter=urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:manager.displayName pr
```
*(This finds users where the manager's display name is "Present" / exists).*

**4. Find users with a specific Username (Case Insensitive typically handled by server):**
```http
GET /Users?filter=userName eq "bjensen"
```

## Summary Checklist for Developers
1.  **Encode your URL:** `filter=userName eq "bjensen"` becomes `filter=userName%20eq%20%22bjensen%22`.
2.  **Dates:** Must be in ISO 8601 format (`YYYY-MM-DDTHH:MM:SSZ`).
3.  **Booleans:** Do not put quotes around `true` or `false`.
4.  **Strings:** Must use double quotes `"`.
5.  **Complex Arrays:** Use `[]` grouping to ensure you are filtering the same object within a list.
