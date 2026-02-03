Based on the Table of Contents you provided, specifically **Section 86** (part of Part 14: Operations & Monitoring), here is a detailed explanation of `014-Operations-Monitoring/007-Troubleshooting.md`.

This section focuses on diagnosing and fixing problems when the communication between the **Identity Provider (IdP/Client)** and the **Service Provider (SP/Application)** breaks down.

---

# Detailed Explanation: SCIM Troubleshooting

Troubleshooting SCIM is critical because identity synchronization happens in the background. When it fails, users may lose access to applications, or terminated employees may retain access, creating security risks.

Here is a breakdown of the specific troubleshooting categories listed in your TOC:

## 1. Common Issues
These are the high-level categories of errors developers encounter most frequently.

*   **Schema Mismatches:** The Identity Provider sends an attribute (e.g., `urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:costCenter`) but the Service Provider does not recognize that schema or attribute name, resulting in a **400 Bad Request**.
*   **JSON Formatting:** Invalid JSON syntax (e.g., missing commas, wrong data types like sending a string "true" instead of a boolean `true`).
*   **Case Sensitivity:** SCIM definitions state that attribute names (like `userName`) should be case-insensitive, but some poorly implemented Service Providers enforce case sensitivity, causing requests to fail.
*   **Immutable Attributes:** Attempting to modify an attribute that the server has defined as `mutability: readOnly` or `immutable` (like the `id` field).

## 2. Sync Failures
This occurs when the provisioning cycle runs, but the data doesn't update in the target system.

*   **Symptom:** The IdP reports a "Success" status, but the user doesn't exist in the application.
*   **Root Cause - "Silent Failures":** The API might be returning a **200 OK** even though it failed to write to the database. This is a violation of the SCIM protocol but happens in custom implementations.
*   **Root Cause - `externalId` Conflicts:** The IdP tries to create a user, but a user with that email already exists in the app (created manually). If the app requires the `externalId` to match the IdP's unique ID, the sync will fail.
*   **Troubleshooting Step:** Check the **Audit Logs** on the Service Provider side to see if the request actually reached the server and what the internal error message was.

## 3. Authentication Problems
Before SCIM payloads are exchanged, the handshake must occur.

*   **Bearer Token Expiry:** The most common issue. OAuth tokens expire. If the IdP receives a **401 Unauthorized**, the token needs to be refreshed.
*   **Scope Issues:** The token provided might have `read` access but not `write` access. The client will be able to perform GET requests but will fail on POST/PUT/PATCH with **403 Forbidden**.
*   **IP Whitelisting:** Many corporate SCIM implementations enforce IP allow-lists. If the IdP rotates its NAT gateway IPs, traffic might be blocked at the firewall level before even reaching the application logic.

## 4. Filter Errors
Retrieving specific users or groups is done via the `filter` parameter. This is a common point of failure due to syntax complexity.

*   **Unsupported Operators:** A client might try to use `filter=userName sw "J"` (starts with), but the Service Provider might only support `eq` (equals).
    *   *Fix:* Check the `/ServiceProviderConfig` endpoint to see which filter options are supported (`filter.supported: true`).
*   **URL Encoding:** The filter string contains special characters (spaces, quotes). If these are not properly URL-encoded (e.g., space becoming `%20`), the server may reject the request.
*   **Complex Attribute Filtering:** Filtering on nested attributes (e.g., `filter=emails[type eq "work" and value co "@example.com"]`) is complex to implement. Many servers fail to parse nested logic correctly.

## 5. Performance Issues
As the user base grows, SCIM integrations often slow down.

*   **Timeouts (504 Gateway Timeout):** If a `GET /Users` request tries to return 50,000 users without pagination, the request will time out.
    *   *Fix:* Ensure the client is using `startIndex` and `count` for pagination.
*   **Rate Limiting (429 Too Many Requests):** If the IdP tries to perform a "Full Sync" and sends 10,000 separate HTTP requests in one minute, the API gateway will block them.
    *   *Fix:* Implement **Exponential Backoff** logic in the client.
*   **Missing Database Indexes:** If the Service Provider allows filtering by `userName`, but the underlying database column isn't indexed, the search query will be slow, causing latency spikes.

## 6. Data Inconsistencies
This is the "Split Brain" scenario where the IdP thinks a user is "Active" but the App thinks they are "Inactive," or attributes differ.

*   **The "Dirty Read" Problem:** A SCIM client updates a user, then immediately reads the user back to confirm. If the Service Provider uses an eventually consistent database (like NoSQL), the read might return the *old* data, causing the client to think the update failed.
*   **Manual Overwrites:** An IT admin manually changes a user's email in the application. The IdP doesn't know about this change until the next reconciliation/sync event.
*   **Canonical Value Issues:** The IdP sends a country as "United States," but the app expects "US". The app might silently reject the value or not update it, leading to a mismatch.

---

### Diagnosis Methodology Checklist

When troubleshooting this section, a developer is usually advised to follow this path:

1.  **Check HTTP Status Codes:** verify if it's Auth (401/403), Logic (400/409), or Server (500) related.
2.  **Inspect the Payload:** Copy the JSON body from the failed request and validate it against the SCIM schema definitions (RFC 7643).
3.  **Check `/ServiceProviderConfig`:** Does the server actually support the feature (Patch, Bulk, Sort) you are trying to use?
4.  **Analyze the `externalId`:** Ensure the link between the IdP user and the SP user is correctly mapped to prevent duplicate user creation or failed updates.
