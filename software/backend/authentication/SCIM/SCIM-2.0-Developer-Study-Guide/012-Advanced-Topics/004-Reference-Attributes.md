Based on **Part 12, Item 69** of your Table of Contents, here is a detailed explanation of **Reference Attributes** in SCIM 2.0.

---

# 012-Advanced-Topics/004-Reference-Attributes.md

## Overview
In the world of relational databases, we use Foreign Keys to link identifiers between tables. In SCIM 2.0 (a JSON-based REST usage), we use **Reference Attributes**.

A Reference Attribute is a specific type of attribute that does not hold data itself but instead points to another Resource where the data lives. The most common examples are:
*   **Group Members:** A Group resource contains a list of members. The Group doesn't store the members' full profiles; it only stores references to the User resources.
*   **Manager:** A User resource often has a `manager` attribute. This is a reference to another User resource.

## 1. The `$ref` Attribute
When you inspect a SCIM resource that lists relationships (like the `members` array in a Group), you will see a complex object containing a sub-attribute named `$ref`.

The `$ref` attribute defines the **URI** (Uniform Resource Identifier) of the target resource.

### Example: A Group Resource
```json
{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:Group"],
  "id": "e9e30dba-f08f-4109-8486-d5c6a331660a",
  "displayName": "Tour Guides",
  "members": [
    {
      "value": "2819c223-7f76-453a-919d-413861904646",
      "$ref": "https://example.com/v2/Users/2819c223-7f76-453a-919d-413861904646",
      "display": "Babs Jensen"
    }
  ]
}
```

In the structure above, the `members` attribute is the Reference Attribute. It contains three key pieces of information to help the client:
1.  **`value`**: The immutable unique identifier (`id`) of the referenced resource.
2.  **`$ref`**: The direct URL to fetch the full details of that resource.
3.  **`display`** (Optional): A read-only string (like the user's name) so the client can display a label without having to make a second API call immediately.

## 2. Absolute vs. Relative References
The SCIM RFC 7643 specifies that `$ref` should be a URI. Implementers must decide between two formats:

### Absolute References (Recommended)
This includes the protocol, domain, api base, and resource path.
*   **Format:** `https://api.scim.service/v2/Users/123`
*   **Pros:** The client doesn't need to know the base URL configuration. They can blindly take the string and perform an HTTP GET request to retrieve the data.
*   **Cons:** If the service changes domains or moves behind a proxy, hardcoded absolute URLs in the database can become stale.

### Relative References
This includes only the path relative to the SCIM root.
*   **Format:** `/Users/123` or even `Users/123`
*   **Pros:** Easier to manage if the application is deployed across multiple environments (Dev/Prod) with different domains.
*   **Cons:** The client must be smart enough to prepend the Base URL before making a request.

**Best Practice:** most major SCIM implementations (Azure AD, Okta, etc.) utilize **Absolute URIs** for the `$ref` attribute to ensure compliance with loose HATEOAS (Hypermedia as the Engine of Application State) principles.

## 3. Reference Resolution
Reference Resolution is the act of a Client System "following the link."

SCIM is designed to use **Lazy Loading**. When you GET a Group, the server does **not** automatically expand the full JSON of every member inside that response. Doing so would result in massive payloads.

Instead:
1.  The Client requests the Group.
2.  The Server returns the Group including the `$ref` URLs for members.
3.  If the Client needs details on Member A, the Client performs a separate HTTP GET request specifically to the URL found in Member A's `$ref`.

## 4. Cross-Resource References
SCIM is technically "Cross-Domain," but within a single Service Provider, it is very common to have Cross-Resource references. This refers to linking different **Resource Types**.

### Homogeneous References
Linking a resource to the same type of resource.
*   *Example:* A **Group** nested inside another **Group**. The `members` attribute of a Group can point to Users *or* other Groups.

### Heterogeneous References
Linking a resource to a completely different type.
*   *Example:* A **User** has a relationship to a **Device** (Custom Resource).
*   *Example:* A **User** has a `manager`. The Manager is also a User, but semantically it represents a hierarchical relationship.

To handle this, reference attributes often include a `type` sub-attribute:
```json
"members": [
  {
    "value": "123",
    "$ref": "https://example.com/v2/Groups/123",
    "display": "Regional Managers",
    "type": "Group"  <-- Indicates the referenced resource is a Group
  }
]
```

## 5. Circular Reference Handling
A major risk with Reference Attributes is the Circular Reference (or Infinite Loop).

**The Scenario:**
1.  Group A is a member of Group B.
2.  Group B is a member of Group A.

If a naive client script tries to "flatten" these groups (resolve all members recursively) without tracking which IDs it has already visited, the script will enter an infinite loop of HTTP requests until it crashes or times out.

### Server-Side Handling
SCIM servers generally do not perform deep validation of circular dependencies upon creation because it is computationally expensive. If valid IDs are provided, the server usually accepts them.

### Client-Side Handling
It is the **Client's responsibility** to handle circular references. When writing a SCIM client that resolves references (e.g., finding the "Level 0" manager or flattening nested groups):
1.  **Maintain a Cache:** Keep a list of `id`s visited during the current operation.
2.  **Check before Fetching:** Before calling the `$ref` URL, check if that ID is in your visited list.
3.  **Break the Loop:** If the ID exists in the list, stop processing that branch.
