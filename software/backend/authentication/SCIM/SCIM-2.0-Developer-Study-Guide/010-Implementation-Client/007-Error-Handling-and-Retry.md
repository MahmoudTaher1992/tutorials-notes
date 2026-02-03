Based on **Part 10 (Implementation - Client)** of the Table of Contents, here is a detailed explanation of section **059: Error Handling and Retry**.

This section focuses on how a SCIM Client (the system sending data, such as an Identity Provider like Okta/Azure AD or a custom script) manages failures when talking to a SCIM Service Provider (the application receiving data, like Slack/Zoom).

Since networks are unreliable and APIs have limits, a "fire and forget" approach will result in data inconsistencies (e.g., a user is hired in HR but their account is never created in the app).

---

### 1. Transient vs. Permanent Errors
The first step in error handling is classifying the type of error based on the HTTP Status Code or the network exception. This classification dictates the client's next move.

#### **Transient Errors (Retriable)**
These are temporary issues. If the client waits and tries again, the request is likely to succeed.
*   **Network Timeouts:** The server didn't respond in time, or the connection dropped.
*   **HTTP 429 (Too Many Requests):** The Service Provider is rate-limiting the client.
*   **HTTP 500 (Internal Server Error):** The server crashed momentarily but might be back up.
*   **HTTP 502/503/504 (Bad Gateway / Service Unavailable):** The application is deploying, starting up, or overloaded.

#### **Permanent Errors (Non-Retriable)**
These issues indicate a fundamental problem with the request data or configuration. Retrying the exact same request will result in the exact same failure.
*   **HTTP 400 (Bad Request):** The payload violates the schema (e.g., missing a required field like `userName`).
*   **HTTP 401/403 (Unauthorized/Forbidden):** Valid credentials are missing or expired.
*   **HTTP 404 (Not Found):** Trying to DELETE or PATCH a user ID that doesn't exist.
*   **HTTP 409 (Conflict):** Trying to POST (create) a user that already exists.

---

### 2. Retry Strategies
When a **Transient Error** is detected, the client must decide how to retry.

*   **Immediate Retry:** Retrying immediately (0ms delay). This is generally **bad practice** because if the server is overloaded, immediate retries will only increase the load, potentially crashing the server further.
*   **Fixed Interval:** Waiting a set time (e.g., 5 seconds) between attempts. Better, but still not ideal for high-load scenarios.
*   **Incremental Interval:** Waiting 5s, then 10s, then 15s.

**Idempotency Considerations:**
When retrying, the client must ensure it doesn't accidentally perform an action twice.
*   **Safe:** `PUT`, `DELETE`, and `GET` are idempotent (retrying them has the same result as doing it once).
*   **Risky:** `POST` (Create) is not idempotent. If the client sends a Create request, the server processes it, but the *response* is lost in a network timeout, the client might retry and create a duplicate. Validating against `409 Conflict` errors handles this specific risk.

---

### 3. Exponential Backoff
This is the industry-standard algorithm for handling retries, specifically for **HTTP 429** and **5xx** errors.

Instead of retrying at fixed intervals, the client increases the wait time exponentially after every failure.

*   **Attempt 1 initiates.** Fails.
*   **Wait:** 1 second.
*   **Attempt 2 initiates.** Fails.
*   **Wait:** 2 seconds.
*   **Attempt 3 initiates.** Fails.
*   **Wait:** 4 seconds.
*   **Attempt 4 initiates.** Fails.
*   **Wait:** 8 seconds.

**Jitter:**
To prevent the "Thundering Herd" problem (where 1,000 clients all fail at once and all retry at exactly the same second), developers add "Jitter" (randomness).
*   *Formula:* `Wait = (Base_Time * 2^attempts) + Random_Ms`

---

### 4. Circuit Breaker Pattern
While retries handle individual request failures, the **Circuit Breaker** handles total system outages.

If the SCIM Service Provider is completely down (e.g., returning 503s for 100% of requests), it is wasteful for the Client to keep trying thousands of user updates.

*   **Closed State (Normal):** Requests flow through normally.
*   **Open State (Broken):** After a threshold of failures (e.g., 10 failures in 10 seconds), the "Circuit Breaks." The client **stops sending requests entirely** and immediately fails local operations without touching the network. This gives the target system time to recover.
*   **Half-Open State (Testing):** After a cooldown period (e.g., 5 minutes), the client lets **one** request through. If it succeeds, the circuit closes (resumes normal operation). If it fails, it goes back to Open.

---

### 5. Dead Letter Handling (DLQ)
What happens when a request fails, we retry it 5 times via exponential backoff, and it *still* fails?

We cannot simply discard the request, or the systems will be out of sync (example: Access was revoked in HR, but the generic retry failed, so the user still has access in the app).

**The Solution: Dead Letter Queue (DLQ)**
1.  **Max Retries Reached:** The code gives up on real-time processing.
2.  **Quarantine:** The JSON payload, the target URL, the operation type (PUT/POST), and the last error message are serialized and saved to a persistent storage (database table or message queue like AWS SQS / RabbitMQ).
3.  **Alerting:** The system logs an error or sends an alert to the administrator indicating "Provisioning failed for User X."

---

### 6. Manual Intervention Workflows
This refers to the UI or operational processes required to fix items stuck in the Dead Letter Queue.

Automated retries cannot fix **Permanent Errors** (like Bad Data). Humans must get involved.

**The Workflow:**
1.  **Notification:** The Admin receives an alert: "Sync failed for user `jdoe` - Invalid Attribute."
2.  **Investigation:** The Admin checks the provisioning logs/dashboard. They see the Service Provider returned `400 Bad Request: "Title" must be under 50 characters`.
3.  **Remediation:**
    *   *Option A:* The Admin updates the user in the source system (shortens the title).
    *   *Option B:* The Admin updates the SCIM mapping configuration to truncate titles automatically.
4.  **Replay:** The Admin clicks a "Retry" button in the dashboard, which pulls the failed event from the DLQ and attempts to send it to the Service Provider again.
