Based on the file path `010-Implementation-Client/008-Rate-Limiting-Handling.md`, this section focuses on how a **SCIM Client** (the system sending the data, e.g., an Identity Provider or a synchronization script) should behave when the **Service Provider** (the target application, e.g., Slack or Salesforce) rejects requests because they are coming too fast.

Here is a detailed explanation of section **60. Rate Limiting Handling**.

---

### Context: Why Rate Limiting Matters for Clients
When a SCIM Client performs a synchronization—especially an initial provisioning of thousands of users—it often sends requests much faster than the Service Provider can process them. To protect their infrastructure, Service Providers implement limits (e.g., "Max 100 requests per minute").

If the Client does not handle these limits correctly, the synchronization will fail, leading to **data inconsistency** (e.g., a user is created but their group membership fails to update).

---

### 1. Detecting Rate Limits

The first step for a Client is to recognize *when* it has been throttled. The Client must inspect the HTTP response status codes for every request sent.

*   **HTTP 429 (Too Many Requests):** This is the standard status code defined in RFC 6585 and widely used in SCIM 2.0. If the Client receives a 429, it implies the server is saying, "I understand your request, but you are sending them too fast. Stop for a moment."
*   **HTTP 503 (Service Unavailable):** While less standard for rate limiting, some legacy applications use 503 to indicate temporary overload. A robust Client should treat a 503 similarly to a 429.
*   **Response Body:** Often, the Service Provider will send a JSON error body explaining the limit (e.g., `{"status": "429", "detail": "Rate limit exceeded: 50/sec"}`). The Client should log this for debugging but primarily rely on the status code for logic.

### 2. The `Retry-After` Header

When a Service Provider returns a 429 status, they should (according to HTTP standards) include a response header called `Retry-After`.

*   **What it contains:** It usually contains an integer representing the number of seconds the Client must wait before sending the next request.
*   **Client Implementation:**
    1.  Client sends `POST /Users`.
    2.  Server responds with `429 Too Many Requests` and header `Retry-After: 60`.
    3.  **CRITICAL:** The Client *must* pause its thread or process for 60 seconds.
    4.  After 60 seconds, the Client re-sends the exact same request.

If the header is missing (which happens with some Service Providers), the Client must fall back to a default strategy (usually **Exponential Backoff**, explained in section 59).

### 3. Request Throttling (Client-Side)

Rather than waiting to get rejected (reactive), a sophisticated Client implements proactive throttling. This prevents hitting the limit in the first place.

*   **Configurable Limits:** The Client usually allows an administrator to configure the "Maximum Requests Per Second" (RPS) for a specific target.
*   **Token Bucket Algorithm:** This is a common implementation pattern.
    *   Imagine a bucket that gets filled with 10 tokens every second.
    *   Every time the Client wants to make a SCIM call, it must take a token from the bucket.
    *   If the bucket is empty, the Client waits locally before sending the request.
*   **Benefit:** This smooths out traffic spikes and reduces the burden on the Service Provider, leading to a more stable sync process.

### 4. Queue-Based Approaches

When a SCIM Client needs to handle high volume (e.g., an HR system triggers 5,000 updates at 9:00 AM), it cannot send them all at once during the HTTP request flow.

*   **Decoupling:** The Client should not process the SCIM logic in the real-time web request. Instead, it pushes the provisioning task into a **Queue** (e.g., RabbitMQ, Kafka, or a database table).
*   **Worker Pattern:**
    *   **Producers:** Push "Update User" messages into the queue instantly.
    *   **Consumers (Workers):** Read messages from the queue one by one.
    *   The "Throttle" sits on the Consumer side. The Consumer processes items only as fast as the configured rate limit allows.
*   **Persistence:** If the Service Provider goes down or rate limits heavily, the messages stay safely in the queue and represent the "pending work" to be done.

### 5. Prioritization Strategies

Not all SCIM operations have equal importance. If the Client is being heavily rate-limited, it needs to decide which requests to prioritize when the window opens up.

*   **High Priority:**
    *   **Deactivations (DELETE / PATCH `active: false`):** This is a security concern. If an employee is fired, their access must be cut immediately. These requests should jump to the front of the queue.
    *   **Password Changes:** Critical for user access recovery.
*   **Low Priority:**
    *   **Profile Updates:** Changing a phone number or profile picture is not time-sensitive.
    *   **Group Membership Sync:** Can often wait a few minutes.
*   **Implementation:** The Client can maintain two queues (Fast Lane vs. Slow Lane) or assign a "weight" to queue messages. When the `Retry-After` timer expires, the worker checks the High Priority queue first.

---

### Summary Workflow for a Robust SCIM Client

1.  **Check Queue:** Pop the highest priority SCIM task.
2.  **Check Local Throttle:** Do I have tokens available to send this? If no, wait.
3.  **Send Request:** Execute HTTP request.
4.  **Handle Response:**
    *   `200/201/204`: Success. Mark task complete.
    *   `429`: **Detect Rate Limit.** Read `Retry-After` header. Put the task back at the front of the queue. Sleep the worker thread for `n` seconds.
    *   `5xx`: Server error. Implement Exponential Backoff retry.
    *   `400/404`: Implementation error. Log and do not retry (prevent infinite loops).
