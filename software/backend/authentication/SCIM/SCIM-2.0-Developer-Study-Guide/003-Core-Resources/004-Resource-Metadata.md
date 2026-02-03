Based on the detailed Table of Contents provided, **Section 13: Resource Metadata** covers the standard attributes found within the `meta` complex attribute of a SCIM resource.

In SCIM 2.0 (RFC 7643), every retrieved resource (whether it is a User, Group, or Custom resource) contains a `meta` attribute. This attribute contains **data about the data**. It does not describe the person or entity (like a name or email does); instead, it describes the lifecycle and technical state of the JSON object itself.

Here is a detailed explanation of the **`meta` Attribute Structure** and its sub-attributes.

---

### The `meta` Attribute Structure

The `meta` attribute is a **Complex** attribute (it holds other sub-attributes). It is **Read-Only** (assigned by the Service Provider/Server, NOT the Client) and is typically returned by default in all responses.

**Example JSON Output:**
```json
{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"],
  "id": "2819c223-7f76-453a-919d-413861904646",
  "userName": "bjensen",
  "meta": {
    "resourceType": "User",
    "created": "2023-01-23T14:32:00Z",
    "lastModified": "2023-05-12T09:15:30Z",
    "location": "https://example.com/v2/Users/2819c223...",
    "version": "W/\"3694e05e9dff591\""
  }
}
```

Here is the breakdown of the specific sub-attributes listed in your Table of Contents:

#### 1. `resourceType`
*   **Definition:** A string indicating the name of the resource type of the object.
*   **Common Values:** `"User"`, `"Group"`, or a custom name like `"Device"`.
*   **Why it matters:** When a client performs a search or reads a bulk response, they might receive a mix of Users and Groups. This field tells the client strictly what kind of object this is so it knows which Schema to validate it against.

#### 2. `created`
*   **Definition:** The date and time the resource was added to the Service Provider.
*   **Format:** It must be an **ISO 8601** formatted string (e.g., `2023-01-23T14:32:00Z`).
*   **Why it matters:** Useful for auditing and reporting. It allows administrators to see "Who are the new users added in the last 30 days?"
*   **Mutability:** This value should never change once the resource is created.

#### 3. `lastModified`
*   **Definition:** The date and time the resource attributes were last updated.
*   **Format:** ISO 8601 formatted string.
*   **Why it matters:** This is arguably the most critical attribute for **Incremental Synchronization**.
    *   *Scenario:* An Identity Provider (Client) connects to the App (Server) and says, "I already synced yesterday. Only give me users where `meta.lastModified` > Yesterday."
    *   Without this attribute, the client would have to download the entire database every time to check for changes (Full Sync), which is very slow and inefficient.

#### 4. `location`
*   **Definition:** The absolute Uniform Resource Identifier (URI) of the resource.
*   **Format:** A generic URL (e.g., `https://api.app.com/scim/v2/Users/2819c...`).
*   **Why it matters:** This adheres to RESTful HATEOAS principles. It provides the client with the exact address to fetch, update, or delete *this specific* resource in the future without the client having to manually construct the URL string.

#### 5. `version` (ETag)
*   **Definition:** The version of the resource, commonly represented as an **Entity Tag (ETag)**.
*   **Format:** Usually a hash string (e.g., `W/"3694e05e9dff591"`).
*   **Why it matters:** This is used for **Concurrency Control** to prevent "Lost Updates."
    *   *Scenario:*
        1.  Admin A reads a user (Version 1).
        2.  Admin B reads the same user (Version 1).
        3.  Admin A updates the user. The server changes it to **Version 2**.
        4.  Admin B tries to update the user based on the data they saw in Version 1.
    *   *Without Version/ETag:* Admin B keeps their change, overwriting what Admin A just did.
    *   *With Version/ETag:* The server sees Admin B is sending a request based on Version 1, but the current state is Version 2. The server rejects the request (HTTP 412 Precondition Failed), forcing Admin B to reload the data first.

### Summary Table

| Attribute | Type | Server/Client | Purpose |
| :--- | :--- | :--- | :--- |
| **resourceType** | String | Server-set | Identifies object type (User/Group). |
| **created** | DateTime | Server-set | Audit trail of creation. |
| **lastModified** | DateTime | Server-set | Enables incremental syncing (Delta Sync). |
| **location** | String (URI)| Server-set | Direct link to the resource. |
| **version** | String | Server-set | Ensures data integrity during simultaneous updates. |
