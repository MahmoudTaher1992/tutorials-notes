Based on the Table of Contents provided, **Section 9: Attributes** covers the fundamental building blocks of SCIM data. In SCIM, a "Resource" (like a User or Group) is essentially a JSON object, and **Attributes** are the fields within that object.

However, unlike a standard free-form JSON object, SCIM attributes have strict definitions (Schema) that tell the Service Provider and Client exactly how to handle the data.

Here is a detailed explanation of the concepts covered in this section:

---

### 1. Attribute Characteristics
Every attribute in SCIM is defined by a specific set of characteristics (metadata/flags) that dictate its behavior. These are defined in the Schema (RFC 7643).

*   **`name`**: The actual string key used in the JSON payload (e.g., `userName`, `active`). Use camelCase by convention.
*   **`type`**: The data format of the attribute (String, Integer, Boolean, etc.).
*   **`multiValued`**: A boolean flag.
    *   `false`: The attribute holds a single value (e.g., `userName`).
    *   `true`: The attribute holds an array of values (e.g., `emails`, `groups`).
*   **`required`**: Determines if the resource can be created without this attribute. If `true`, the Service Provider will reject a POST request missing this field.
*   **`caseExact`**: Applies to String attributes.
    *   `true`: "Admin" and "admin" are different values.
    *   `false`: "Admin" and "admin" are treated as the same value (crucial for uniqueness checks and filtering).
*   **`mutability`**: Defines who can change the data and when.
    *   `readWrite`: The default. Valid for GET, POST, PUT, PATCH.
    *   `readOnly`: The Client cannot write this (e.g., `id`, `meta.lastModified`). The Server manages it.
    *   `writeOnly`: The Client can write it, but the Server will never return it in a response (e.g., `password`).
    *   `immutable`: Can be set during creation (POST) but never changed afterward (e.g., sometimes `userName` is immutable in specific legacy systems).
*   **`returned`**: Defines when the attribute appears in the API response.
    *   `always`: Returned every time, even if not requested (e.g., `id`).
    *   `never`: Never returned (security sensitive data like passwords).
    *   `default`: Returned normally, but can be excluded if the client adds `?excludedAttributes=` to the URL.
    *   `request`: Only returned if the client specifically asks for it via `?attributes=`.
*   **`uniqueness`**: Defines constraint requirements.
    *   `none`: Duplicates allowed (e.g., `title`).
    *   `server`: Must be unique within this specific SCIM server (e.g., `userName`).
    *   `global`: Must be unique globally (rarely enforced by SCIM logic alone, usually implies GUIDs).

---

### 2. Attribute Types
SCIM supports specific data types to map JSON values to identity concepts.

*   **String**: Text sequence (UTF-8).
*   **Boolean**: `true` or `false`.
*   **Decimal**: A real number.
*   **Integer**: A whole number.
*   **DateTime**: A string formatted according to ISO 8601 (e.g., `2023-10-05T12:00:00Z`).
*   **Binary**: Arbitrary binary data, usually Base64 encoded (e.g., `photos` data).
*   **Reference**: A URI string pointing to another resource. Typically used to link users to groups or managers (e.g., `https://example.com/v2/Users/2819c`).
*   **Complex**: An attribute that contains sub-attributes (a nested JSON object). For example, `name` is a complex attribute containing `givenName` and `familyName`.

---

### 3. Sub-Attributes
This concept applies specifically to **Complex** attributes.

If an attribute is type "Complex", it does not hold a value itself; rather, it holds a set of **Sub-Attributes**.
*   **Example 1 (Complex Singular):** The `name` attribute.
    ```json
    "name": {
      "givenName": "John",  <-- Sub-attribute
      "familyName": "Doe"   <-- Sub-attribute
    }
    ```
*   **Example 2 (Complex Multi-valued):** The `emails` attribute.
    ```json
    "emails": [
      {
        "value": "john@work.com",
        "type": "work",
        "primary": true
      },
      {
        "value": "john@gmail.com",
        "type": "home"
      }
    ]
    ```
    In Example 2, `value`, `type`, and `primary` are the sub-attributes of the complex attribute `emails`.

---

### 4. Canonical Values
For certain attributes, SCIM restricts the values a client provides to a specific list of accepted strings. These are known as **Canonical Values**.

This is essentially an **Enum** (Enumeration).

*   **Common Use Case:** The `type` sub-attribute in multi-valued lists.
    *   For `emails` or `phoneNumbers`, the canonical values suggest: `work`, `home`, `mobile`, `other`.
*   **Behavior:** While the SCIM spec *suggests* these values, it often allows Service Providers to accept other values too, but standard implementation libraries rely on these canonical keys for UI mapping.

### Summary Example
Here is how these concepts visually come together in a SCIM User Resource:

```json
{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"],
  "id": "2819c223...",              // Type: String, Mutability: readOnly, Returned: always
  "userName": "bjensen",            // Type: String, Uniqueness: server, Required: true
  "active": true,                   // Type: Boolean
  "emails": [                       // Type: Complex, MultiValued: true
    {
      "value": "bjensen@example.com", // Sub-attribute
      "type": "work",                 // Sub-attribute with Canonical Values (work/home)
      "primary": true
    }
  ],
  "meta": {                         // Type: Complex, Mutability: readOnly
    "created": "2023-01-01T00:00:00Z" // Type: DateTime
  }
}
```
