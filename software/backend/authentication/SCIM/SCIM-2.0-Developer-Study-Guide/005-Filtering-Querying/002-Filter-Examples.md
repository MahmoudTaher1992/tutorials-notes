Based on **Part 25: Filter Examples** of the Table of Contents, here is a detailed explanation of how SCIM filtering works in practice.

In SCIM 2.0, the `filter` parameter allows a client (like an Identity Provider) to search for specific users or groups within the Service Provider (the application). The filter is passed as a query string parameter in the URL.

Here is a breakdown of the specific examples and concepts listed in that section.

---

### 1. Simple Attribute Filters
These are the most basic queries targeting top-level, singular attributes in the Core User or Group schema.

*   **Equal To (`eq`):**
    Used to find an exact match.
    *   *Request:* `GET /Users?filter=userName eq "bjensen"`
    *   *Meaning:* Find the user object where the username is exactly "bjensen".

*   **Starts With (`sw`):**
    Used for auto-complete or searching.
    *   *Request:* `GET /Users?filter=userName sw "J"`
    *   *Meaning:* Find all users whose username starts with the letter "J".

*   **Boolean checks:**
    *   *Request:* `GET /Users?filter=active eq true`
    *   *Meaning:* Return only currently active user accounts.

### 2. Multi-Valued Attribute Filters
In SCIM, attributes like `emails`, `phoneNumbers`, and `addresses` are arrays (lists). You usually need to filter based on a specific property within that list (like the `value` or the `type`).

*   **Simple sub-attribute match:**
    *   *Request:* `GET /Users?filter=emails.value eq "bjensen@example.com"`
    *   *Meaning:* Find users who have *any* email address in their list matching "bjensen@example.com".

*   **Checking for existence (`pr` - present):**
    *   *Request:* `GET /Users?filter=emails pr`
    *   *Meaning:* Find users that have at least one email address listed.

### 3. Complex Attribute Filters
Some attributes are "complex," meaning they are objects acting as a parent to other attributes. The most common example is `name`.

*   **Dot Notation:**
    You access children attributes using a dot `.`.
    *   *Request:* `GET /Users?filter=name.familyName eq "O'Malley"`
    *   *Meaning:* Find users where the family name (Last Name) is "O'Malley".

### 4. Combined Filters (Logical Operators)
You can combine multiple conditions using `and`, `or`, and grouping with parentheses `()`.

*   **The `and` Operator:**
    Both conditions must be true.
    *   *Request:* `GET /Users?filter=title eq "Manager" and userType eq "Employee"`

*   **The `or` Operator:**
    At least one condition must be true.
    *   *Request:* `GET /Users?filter=userType eq "Employee" or userType eq "Intern"`

*   **Grouping:**
    Parentheses control the order of operations (precedence).
    *   *Request:* `GET /Users?filter=userType eq "Employee" and (department eq "Sales" or department eq "Marketing")`
    *   *Meaning:* Must be an Employee, AND must be in either Sales or Marketing.

### 5. Extension Attribute Filters
SCIM allows for Schema Extensions (like the Enterprise User extension). Because these attributes do not belong to the "Core" schema, you must reference them using their full **Schema URI**.

*   **Syntax:** `urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:<AttributeName>`
*   **Example (Employee Number):**
    *   *Request:* `GET /Users?filter=urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:employeeNumber eq "701984"`
    *   *Note:* If you just wrote `filter=employeeNumber eq "701984"`, strict SCIM servers would return an error because they don't know which schema `employeeNumber` belongs to.

### 6. Common Filter Patterns (Advanced)

#### The "Value Path" Filter (Brackets `[]`)
This is a specific and powerful feature in SCIM used for multi-valued complex attributes (like emails or addresses). It ensures that multiple conditions apply to the **same item** in the array.

*   **Scenario:** Find a user with a **Work** email of **alice@company.com**.
*   **Incorrect (Dot Notation):**
    `filter=emails.type eq "work" and emails.value eq "alice@company.com"`
    *Why it's wrong:* This finds a user who has *any* "work" email AND *any* email with that value. It could match a user with a "home" email of "alice@company.com" and a different "work" email.
*   **Correct (Bracket Notation):**
    `GET /Users?filter=emails[type eq "work" and value eq "alice@company.com"]`
    *Meaning:* Look inside the `emails` array. Find an *individual entry* where both the type is work AND the value is the specific email.

#### Delta Sync (Last Modified)
This pattern is used by provisioning engines to pull only data that has changed since the last sync.
*   **Request:** `GET /Users?filter=meta.lastModified gt "2023-10-27T00:00:00Z"`
*   *Meaning:* Find all users whose records were updated **Greater Than (`gt`)** the specified timestamp.

### Important Implementation Note: URL Encoding
When actually sending these requests via HTTP, the filter string must be URL encoded because it contains spaces, quotes, and colons.

*   **Human Readable:** `filter=userName eq "bjensen"`
*   **Actual HTTP Request:** `GET /Users?filter=userName%20eq%20%22bjensen%22`
