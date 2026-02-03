Based on the Table of Contents you provided, here is a detailed explanation of **Part 4: Protocol Operations, Section 16: HTTP Methods in SCIM**.

---

# 16. HTTP Methods in SCIM

SCIM (System for Cross-domain Identity Management) is a RESTful API. This means it relies on standard HTTP verbs (methods) to perform actions on resources (Users or Groups). However, SCIM defines specific rules for how these methods behave to ensure consistency across different Identity Providers (Okta, Azure AD, etc.) and Service Providers (SaaS apps).

Here is the breakdown of the five core methods used in SCIM and the concepts of Safety and Idempotency.

## 1. GET (Read)
**Usage:** Retrieval of information.
**SCIM Behavior:**
The GET method is used to retrieve resources from the Service Provider. It never modifies data.

*   **Retrieve Single Resource:** Fetches a specific user or group by their ID.
    *   *Example:* `GET /Users/2819c223-7f76-453a…`
*   **List/Query Resources:** Fetches a list of users or groups. It supports query parameters to filter results.
    *   *Example:* `GET /Users?filter=userName eq "alice"`
*   **Discovery:** Used to read configuration endpoints like `/Schemas` or `/ServiceProviderConfig`.

## 2. POST (Create)
**Usage:** Creation of new resources.
**SCIM Behavior:**
POST is used when you want to add a *new* User or Group to the system.

*   **ID Generation:** Generally, the Service Provider (the server) generates the unique `id` for the resource, not the client.
*   **Response:** On a successful create, the server returns a `201 Created` status code and returns the full JSON representation of the created user (including the new system-generated ID).
*   **Bulk Operations:** POST is also exclusively used for the `/Bulk` endpoint to send a large batch of mixed operations (creates, updates, and deletes) in a single HTTP request.

## 3. PUT (Replace)
**Usage:** Full replacement of a resource.
**SCIM Behavior:**
This is the most dangerous method if misunderstood. PUT replaces the **entire** resource with the data provided in the request body.

*   **The "Nulling" Effect:** If a User has 10 attributes (Email, Phone, Title, Department, etc.) and you send a PUT request containing *only* the Email, **the Service Provider is expected to delete the other 9 attributes** (reset them to null or default).
*   **Use Case:** It is rarely used for minor updates. It is typically used for synchronization integration where the source system is the absolute "source of truth" and enforces its exact state onto the target.

## 4. PATCH (Partial Update)
**Usage:** Updating specific attributes of a resource without affecting others.
**SCIM Behavior:**
PATCH is the preferred method for updating users in modern SCIM implementations because it is more bandwidth-efficient and safer than PUT.

*   **Granularity:** You can change a user's `title` without having to send (or know) their `phoneNumber`.
*   **Operations:** The SCIM PATCH body is unique; it contains an array of "operations" (`add`, `remove`, `replace`).
    *   *Example:* "Replace the password" OR "Add a new email to the list of emails."
*   **Protocol Requirement:** While powerful, implementing PATCH logic on the server side is complex, so some older Service Providers may not support it (though they are required to by the SCIM 2.0 standard).

## 5. DELETE (Remove)
**Usage:** Removal of a resource.
**SCIM Behavior:**
Used to delete a specific User or Group via their ID.

*   **Standard Behavior:** Once deleted, a GET request for that ID should return `404 Not Found`.
*   **Hard vs. Soft Delete:** SCIM specification dictates that DELETE removes the resource. However, internal business logic often converts this to a "Soft Delete" (disabling the account or marking it as archived) to preserve audit trails. To strictly "Disable" a user without deleting them, you should use `PATCH` to set `active: false`.

---

## Method Safety & Idempotency

When building or integrating SCIM, understanding these two architectural concepts is critical for reliability, especially when network errors occur (e.g., "I sent the request but didn't get a response. Should I send it again?").

### 1. Safety
A method is considered **Safe** if it does not alter the state of the server.
*   **SAFE:** `GET` (Reading data doesn't change it).
*   **UNSAFE:** `POST`, `PUT`, `PATCH`, `DELETE` (These all modify data).

### 2. Idempotency
A method is **Idempotent** if making the same request multiple times produces the same result as making it once. This is crucial for retry logic.

*   **PUT (Idempotent):** If you send "Set name to 'Bob'" five times, the name is still 'Bob'. It is safe to retry a PUT if the connection drops.
*   **DELETE (Idempotent):** If you send "Delete User 123" twice, the first time it deletes the user. The second time it might return an error (404), but the *system state* is the same (User 123 is gone).
*   **POST (NOT Idempotent):** If you send "Create User 'Alice'" twice, you will end up with **two** users named Alice with different IDs. You must be careful retrying POST requests.
*   **PATCH (Usage Dependent):**
    *   If the PATCH says "Replace Name with Bob", it is idempotent.
    *   If the PATCH says "Add value 'X' to the list", executing it twice might result in 'X' appearing twice in the list. Therefore, **PATCH is generally treated as non-idempotent.**

### Summary Table

| Method | Action | Implementation | Safe? | Idempotent? |
| :--- | :--- | :--- | :--- | :--- |
| **GET** | Read | `/Users/{id}` or `/Users` | **Yes** | **Yes** |
| **POST** | Create | `/Users` | No | **No** |
| **PUT** | Replace | `/Users/{id}` | No | **Yes** |
| **PATCH** | Update | `/Users/{id}` | No | **No** (Usually) |
| **DELETE** | Remove | `/Users/{id}` | No | **Yes** |
