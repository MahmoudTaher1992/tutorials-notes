Based on **Section 35** of your Table of Contents, here is a detailed explanation of **ETags and Versioning** within the SCIM 2.0 protocol.

---

# Detailed Explanation: 007-Protocol-Details / 003-ETags-and-Versioning

In distributed systems like SCIM, multiple clients (e.g., an HR system, an IT admin panel, and an automated script) might try to read or modify the same user account at the same time. **ETags (Entity Tags)** are the mechanism SCIM uses to manage these concurrent operations safely and efficiently.

## 1. What is an ETag?
An ETag is an opaque identifier assigned by a web server to a specific version of a resource found at a URL. Think of it as a **fingerprint** or a **version number** for a specific state of a user or group.

If a User resource changes (e.g., their email is updated), the Server **must** generate a new ETag for that resource.

In SCIM, the version information appears in two places:
1.  **HTTP Header:** `ETag: "W/123456789"`
2.  **Resource Body:** Inside the `meta` attribute as `meta.version`.

## 2. Optimistic Concurrency Control
This is the main business driver for using ETags.
*   **Pessimistic Locking:** Using a "checkout" system where one user locks a file so no one else can edit it. (Bad for web APIs).
*   **Optimistic Concurrency:** Allowing anyone to read the data, but checking version numbers before allowing a `write` operation to ensure data hasn't changed in the background.

**The "Lost Update" Problem:**
Without ETags, if Admin A and Admin B both download User X's profile, and Admin A saves a change, Admin B (who is looking at old data) might save their changes moments later, effectively overwriting/deleting Admin A's work.

## 3. The `If-Match` Header (Preventing Overwrites)
To solve the "Lost Update" problem, SCIM clients use the `If-Match` HTTP header during `PUT` (Update), `PATCH` (Partial Update), or `DELETE` operations.

**The Workflow:**
1.  **Read:** Client A GETs a User. The Server returns the User JSON and an ETag header (`ETag: "v1"`).
2.  **Modify:** Client A modifies the JSON locally.
3.  **Save:** Client A sends a `PUT` request. Crucially, it includes the header: `If-Match: "v1"`.
4.  **Verification:** The Server looks at the current version of the User in the database.
    *   **Success:** If the database version is still "v1", the update proceeds. The server typically returns the new ETag "v2".
    *   **Failure:** If the database version is "v2" (because Admin B changed it 5 seconds ago), the server sees that `"v1" != "v2"`.

**The Result:** The server rejects Client A's request with HTTP Status **412 Precondition Failed**. Client A now knows they must re-download the user to see the latest data before trying again.

## 4. The `If-None-Match` Header (Caching)
This header is used primarily to save bandwidth during `GET` requests.

**The Workflow:**
1.  Client A has a cached copy of a large Group resource with ETag "v1".
2.  Client A wants to know if the group has changed, but doesn't want to download the whole thing if it hasn't.
3.  Client A sends a `GET` request with header `If-None-Match: "v1"`.
4.  **Verification:**
    *   If the server has version "v1", it returns **304 Not Modified** (with an empty body). The client uses its cache.
    *   If the server has version "v2", it returns **200 OK** and the full new JSON body.

## 5. Weak vs. Strong ETags
*   **Strong ETag (e.g., `"12345"`):** Indicates that the resource content is byte-for-byte identical.
*   **Weak ETag (e.g., `W/"12345"`):** Indicates that the resource is semantically equivalent, even if the bytes differ slightly (e.g., the JSON formatting or attribute order changed, but the actual data is the same).

SCIM servers generally use **Weak** ETags because JSON serialization order does not matter for identity data.

## 6. Practical Example

### Step A: Client fetches a user
**Request:**
```http
GET /Users/2819c223 HTTP/1.1
Host: example.com
```

**Response:**
```http
HTTP/1.1 200 OK
ETag: W/"HUJ76890"
Content-Type: application/scim+json

{
    "id": "2819c223",
    "userName": "bjensen",
    "meta": {
        "version": "W/\"HUJ76890\"",
        ...
    }
}
```

### Step B: Client attempts to update the user safely
The client wants to update `bjensen`. To ensure they aren't overwriting someone else's change, they include the ETag they received in Step A.

**Request:**
```http
PUT /Users/2819c223 HTTP/1.1
Host: example.com
If-Match: W/"HUJ76890"
Content-Type: application/scim+json

{
    "userName": "bjensen_new",
    ...
}
```

**Scenario 1: Success (No Conflict)**
The server checks version "HUJ76890". It matches. The server updates the user to "bjensen_new" and generates a new ETag ("K991122").

**Scenario 2: Failure (Conflict)**
The server checks version "HUJ76890". However, the current version in the database is "X554433" (someone else changed it).
**Response:**
```http
HTTP/1.1 412 Precondition Failed
```
*The client must now GET the user again to see what changed before re-submitting.*
