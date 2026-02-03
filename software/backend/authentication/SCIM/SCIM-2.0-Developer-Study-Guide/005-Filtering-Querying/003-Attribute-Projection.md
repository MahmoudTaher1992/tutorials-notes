Based on **Section 26 (Attribute Projection)** of the SCIM 2.0 Developer Study Guide, here is a detailed explanation of the concept.

---

# Detailed Explanation: Attribute Projection (SCIM 2.0)

**Attribute Projection** is a mechanism in SCIM that allows a Client to specify exactly which pieces of information (attributes) the Service Provider should return in a response.

By default, when you request a resource (like a User), the server returns the full standard object. However, a User resource might contain high-bandwidth data (like high-res photos) or sensitive data that the client doesn't need for a specific operation. Attribute projection solves this by allowing you to filter the **output columns** (similar to a SQL `SELECT col_a, col_b` statement).

This is controlled via two HTTP Query Parameters: **`attributes`** and **`excludedAttributes`**.

---

## 1. The `attributes` Parameter (Inclusion)
This parameter tells the server: *"Return **only** these specific attributes (plus required metadata)."*

When you use this parameter, the server treats all other attributes as implicitly excluded.

### Usage
*   **Format:** A comma-separated list of attribute names.
*   **Complex Attributes:** Use "dot notation" to request sub-attributes (e.g., `name.familyName`).

### Example
**Scenario:** A client application generates a list of users for a directory. It only needs the user's ID, their username, and their full name. It does not need their address, emails, or groups.

**Request:**
```http
GET /Users?attributes=userName,name.formatted
```

**Response:**
```json
{
  "totalResults": 1,
  "itemsPerPage": 1,
  "startIndex": 1,
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:ListResponse"],
  "Resources": [
    {
      "id": "2819c223...", 
      "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"],
      "userName": "bjensen",
      "name": {
        "formatted": "Ms. Barbara J Jensen, III"
      },
      "meta": { ... }
    }
  ]
}
```
*Note: Even though we didn't ask for `id`, `schemas`, or `meta`, the server returned them. See "Mandatory Attributes" below.*

---

## 2. The `excludedAttributes` Parameter (Exclusion)
This parameter tells the server: *"Return everything **except** these specific attributes."*

This is useful when you want the full user profile but want to save bandwidth by omitting heavy fields.

### Usage
*   **Format:** A comma-separated list of attribute names to remove from the response.

### Example
**Scenario:** You want to sync user data, but your system effectively ignores the `photos` attribute (which contains large base64 strings) and the `x509Certificates` attribute.

**Request:**
```http
GET /Users/2819c223...?excludedAttributes=photos,x509Certificates
```

**Response:**
The server returns every attribute available for that user (emails, phone numbers, addresses, etc.) *minus* the photos and certificates.

---

## 3. Attribute Return Defaults (The Rules)

SCIM attributes have a property explicitly defined in the Schema called `returned`. This defines how projection behaves.

| Return Setting | Description | Behavior with Projection |
| :--- | :--- | :--- |
| **always** | The attribute is always returned. | **Cannot be excluded.** Even if you put it in `excludedAttributes`, the server will ignore you and send it anyway (e.g., `id`, `schemas`, `meta`). |
| **never** | The attribute is never returned. | **Cannot be included.** Even if you put it in `attributes`, the server will not send it (e.g., `password`). |
| **default** | Returned by default unless restricted. | Start included. If `attributes` parameter is used, they are removed unless listed. If `excludedAttributes` is used, they are removed if listed. |
| **request** | Only returned if explicitly asked for. | Not sent by default. Only sent if you specifically add it to the `attributes` parameter (e.g., `entitlements` is sometimes configured this way to save DB performance). |

---

## 4. Minimal Response Requests
Attribute projection isn't just for GET (Reading) requests. It permits optimization during POST (Create), PUT (Replace), and PATCH (Update) operations too.

By default, after you Create (`POST`) a user, the server responds with a `201 Created` and the **full** JSON of the user just created.

If you are creating users in bulk and don't want the server to echo back the data you just sent (to save bandwidth), you can use `attributes` to strip the response down to just the ID.

**Request:**
```http
POST /Users?attributes=id
Host: example.com
Content-Type: application/scim+json

{
  "userName": "jsmith",
  "active": true
  ...
}
```

**Response:**
The server creates the user but returns a tiny JSON body containing only the `id` (and mandatory meta/schemas), saving significant network overhead.

---

## 5. Performance Optimization
Why is this section in the study guide? Because used correctly, Attribute Projection significantly impacts system performance:

1.  **Database Efficiency:** A smart SCIM implementation (Server-side) will look at the `attributes` parameter *before* querying the database. If the client validly requests only `userName`, the SQL query effectively becomes `SELECT id, userName FROM users` rather than `SELECT *`.
2.  **Network Latency:** SCIM payloads can be heavy. Excluding `groups` (which might contain thousands of memberships) or `photos` (binary data) makes the API much snappier.
3.  **Security:** It prevents the accidental leakage of PII (Personally Identifiable Information). If a UI only needs names for a list, the API should not define the request in a way that pulls mobile phone numbers or home addresses across the wire.

## Summary Table

| Parameter | Function | Best Use Case |
| :--- | :--- | :--- |
| **No Parameter** | Returns all `default` and `always` attributes. | Fetching a full user profile for an edit screen. |
| **`attributes`** | Returns **only** listed attributes (plus `always`). | Generating list views, drop-downs, or minimizing POST response sizes. |
| **`excludedAttributes`** | Returns everything **except** the listed ones. | Getting full profiles but omitting "heavy" attributes like photos or certificates. |

**Important Note:** According to RFC 7644, Clients **should not** use both `attributes` and `excludedAttributes` in the same request. If both are present, the Server will typically honor `attributes` and ignore `excludedAttributes`.
