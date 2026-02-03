Based on **Part 10, Item 57** of the Table of Contents, here is a detailed explanation of **Synchronization Strategies** in the context of a SCIM Client implementation.

---

# 010-Implementation-Client/005-Synchronization-Strategies.md

In SCIM architecture, the **Client** (usually an Identity Provider like Okta, Azure AD, or a custom script) is responsible for pushing identity data to the **Service Provider** (the SaaS application).

**Synchronization Strategies** define *how* and *when* the Client decides to send data to the Service Provider. Choosing the right strategy is critical for balancing performance, API rate limits, and data consistency.

Here are the key strategies detailed in this section:

---

## 1. Full Synchronization (The Baseline)

**Full Synchronization** is the process of reviewing every single user and group in the source system and ensuring the target system matches exactly.

### How it works:
1.  **Retrieve All Source Data:** The Client fetches all users/groups from its internal database.
2.  **Retrieve All Target Data:** The Client calls `GET /Users` and `GET /Groups` on the Service Provider (using pagination) to build a map of current state.
3.  **Comparision (Diff):** The Client compares the two datasets line-by-line.
4.  **Execution:**
    *   **Missing in Target:** Client sends `POST`.
    *   **Missing in Source:** Client sends `DELETE` (or updates `active: false` in Target).
    *   **Different:** Client sends `PUT` or `PATCH` to update attributes.

### When to use it:
*   **Initial Setup:** When you first connect an IdP to an App.
*   **Disaster Recovery:** If data corruption occurs.
*   **Periodic Cleanup:** Many organizations run a "Full Sync" once a week/month to catch any "drift" (changes made manually in the app that the IdP missed).

### Pros & Cons:
*   ✅ **Guarantees Consistency:** It is the most authoritative way to sync.
*   ❌ **Expensive:** Highly resource-intensive. If you have 100,000 users, fetching and comparing them takes a long time and eats up API quotas.

---

## 2. Incremental Sync (Scheduled Polling)

**Incremental Sync** is a scheduled process (e.g., every 40 minutes) that only processes records that have changed since the last successful sync run.

### How it works:
1.  **Watermark Tracking:** The Client stores a timestamp ("Last Run Time").
2.  **Change Detection:**
    *   *Source-Driven:* The Client queries its own database: "Give me all users modified > Last Run Time."
    *   *Target-Driven:* If the Client is pulling from another SCIM API, it might use a filter: `GET /Users?filter=lastModified ge "2023-01-01T12:00:00Z"`.
3.  **Execution:** The Client iterates through *only* the modified list and sends updates (`PATCH`/`PUT`) to the Service Provider.

### Pros & Cons:
*   ✅ **Efficient:** Only touches a fraction of the data compared to Full Sync.
*   ✅ **Regular Updates:** keeps data relatively fresh.
*   ❌ **Latency:** Updates are not instant. A user created right after a cycle finishes might verify 40 minutes for the next cycle.

---

## 3. Delta Sync (Attribute-Level changes)

While often used interchangeably with Incremental Sync, **Delta Sync** specifically refers to calculating the specific *attribute* difference rather than replacing the whole user.

### How it works:
If a user changes their Department from "Sales" to "Marketing":
*   **Without Delta (Replace):** The Client sends a `PUT` with *all* user attributes (Name, Email, Phone, Department).
*   **With Delta (Patch):** The Client calculates the exact difference and sends a `PATCH` request.
    ```json
    {
      "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
      "Operations": [
        {
          "op": "replace",
          "path": "department",
          "value": "Marketing"
        }
      ]
    }
    ```

### Pros & Cons:
*   ✅ **Payload Efficiency:** Extremely small HTTP request bodies.
*   ✅ **Security:** Minimizes risk of accidentally wiping out attributes the Client doesn't know about.
*   ❌ **Complexity:** Requires a sophisticated engine to calculate the "diff" between the previous state and the new state.

---

## 4. Event-Driven Sync (Real-Time / JIT)

**Event-Driven Sync** (often called Just-in-Time or Real-Time Provisioning) occurs immediately when an action happens in the Source system.

### How it works:
1.  **Trigger:** An admin updates a user in the IdP.
2.  **Push:** Providing the IdP architecture supports it, this event immediately triggers a job queue.
3.  **Execution:** The SCIM Client immediately sends the SCIM request to the Service Provider.

### Pros & Cons:
*   ✅ **User Experience:** Zero wait time. A new employee can log in seconds after being created in HR.
*   ❌ **Burst Traffic:** A bulk import in HR could trigger thousands of simultaneous API calls to the Service Provider, potentially hitting rate limits (429 Too Many Requests).
*   ❌ **Reliability:** If the Service Provider is down at that exact second, the event might be lost (requires robust retry logic).

---

## 5. Reconciliation (Handling "Drift")

**Reconciliation** is the logic used to link existing accounts and manage data created outside the SCIM process.

### The Problem:
What happens if you try to provision "john.doe@example.com", but that user manually signed up for the app 3 months ago?

### The Reconciliation Logic:
1.  **Matching:** Before creating a user, the Client performs a `GET /Users?filter=userName eq "john.doe@example.com"`.
2.  **Linking:**
    *   **No Match:** Send `POST` (Create new user).
    *   **Match Found:** Do not create. Instead, retrieve the ID of the existing user and store it in the Client side. This is called "account linking."
3.  **Update:** Immediately perform an update (`PUT`/`PATCH`) to ensure the existing user's data matches the IdP's data.

Reconciliation is the strategy for determining "Who is the Source of Truth" when data conflicts exist.

---

## 6. Conflict Resolution

When synchronization strategies fail or overlap, **Conflict Resolution** rules apply.

### Common Scenarios & Strategies:

| Scenario | Strategy A: Source Wins (Authoritative) | Strategy B: Target Wins (Protective) | Strategy C: Manual Intervention |
| :--- | :--- | :--- | :--- |
| **Object Conflict:** Client tries to create a user that already exists. | Overwrite the target user with Client data. | Skip the user and log an error. | Flag the user requiring Admin review to merge accounts. |
| **Attribute Conflict:** Client says Dept is "IT", App says "Eng". | Force update App to "IT". | Keep App as "Eng" (assumes App has local data). | N/A |
| **Delete Conflict:** Client creates user, App admin deletes them. | Re-create the user immediately. | Mark user as "provisioning error". | Notify Admin. |

### Best Practice for SCIM Clients:
1.  **Immutable ID:** Never rely solely on email/username for linking, as these can change. Rely on the SCIM `id` and `externalId`.
2.  **Retry Queues:** If a sync event fails (network glitch), do not drop it. Put it in an exponential backoff queue.
3.  **Rate Limiting:** The sync engine must respect the Service Provider's traffic limits to avoid being blocked.
