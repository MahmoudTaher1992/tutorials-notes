Here is a detailed explanation of section **73. Audit & Compliance** from Part 14: Operations & Monitoring.

In the context of OAuth 2.0 and identity management, **Audit and Compliance** refers to the practice of recording, storing, and analyzing detailed logs of authorization events to prove that the system is secure and adheres to legal or industry-standard regulations.

---

### 1. Audit Logging Requirements

An OAuth Authorization Server (AS) is the "front door" to your ecosystem. Because it controls access, every interaction with it must be traceable.

#### **What to Log (Key Events)**
To answer the questions *"Who did what?"* and *"Is the system under attack?"*, you must log the following events:

*   **Token Issuance:** Every time an Access Token or Refresh Token is generated.
*   **Authentication Failures:** Failed login attempts (indicates brute force or credential stuffing).
*   **Authorization Code Grants:** When a user approves a client application.
*   **Token Validation/Introspection:** Who is checking if a token is valid?
*   **Revocation Events:** When a token is manually or automatically killed.
*   **Client Management:** Creation of new OAuth clients, rotation of client secrets, or changes to redirect URIs.
*   **Consent Actions:** When a user grants or denies a specific scope (e.g., "Allow app to read email").

#### **Anatomy of an Audit Log**
A robust audit log entry should contain the **5 Ws**:
1.  **Who:** `sub` (User ID) and `client_id`.
2.  **What:** Event type (e.g., `TOKEN_MINTED`, `LOGIN_FAILED`).
3.  **When:** High-precision timestamp (ISO 8601).
4.  **Where:** IP Address (`x-forwarded-for`), User Agent, and Geo-location (if available).
5.  **Why/How:** Grant Type used (e.g., `authorization_code`), scopes requested vs. granted.

#### **Critical Security Warning: What NOT to Log**
**Never** log sensitive credentials in clear text. This creates a massive security vulnerability known as "Log Injection" or "Credential Leakage."
*   ❌ **Do NOT log:** Passwords, full Access Token strings, Refresh Token strings, biometrics, or Client Secrets.
*   ✅ **Do log:** Token Hashes (e.g., SHA-256 of the token signature) or Token IDs (`jti`).

---

### 2. Compliance Frameworks

Organizations adopt OAuth 2.0 because it helps meet the strict requirements of various regulatory frameworks. Here is how OAuth auditing maps to these standards:

#### **SOC 2 (System and Organization Controls)**
*   **Requirement:** Companies must demonstrate they have controls in place to prevent unauthorized access and can detect anomalies.
*   **OAuth Role:** Your audit logs provide the *evidence* for SOC 2 auditors. You must prove that you review logs for suspicious activity (e.g., an unusual spike in Client Credentials grants).

#### **GDPR (General Data Protection Regulation)**
*   **Requirement:** Data Protection and Privacy.
*   **OAuth Role:**
    *   **Consent:** You must prove the user explicitly consented to share their data with a third-party app. The OAuth consent flow log is your legal proof.
    *   **Right to Access:** If a user asks, "Who has access to my data?", the OAuth token issuance logs provide the answer (e.g., "App X has access to your profile").

#### **PCI-DSS (Payment Card Industry Data Security Standard)**
*   **Requirement:** Securing credit card data.
*   **OAuth Role:** If your OAuth implementation protects payment APIs, the logs must be immutable (cannot be changed by admins). Logs must need to be retained for at least one year, with immediate availability for the last three months.

#### **FAPI (Financial-grade API)**
*   **Requirement:** High-security profile for Open Banking.
*   **OAuth Role:** Requires "Non-repudiation." The logs must be detailed enough to prove (in a court of law) that a specific user authorized a specific money transfer via a specific client.

---

### 3. Data Retention Policies

Logs cannot be kept forever (due to storage costs and privacy laws), but they cannot be deleted too soon (due to compliance laws).

*   **Retention Period:**
    *   *Operational Logs (Hot Storage):* Keep for 14–30 days. Used for debugging live issues.
    *   *Audit/Compliance Logs (Cold Storage):* Keep for 1–7 years depending on the industry (e.g., Banking usually requires 7 years).
*   **Secure Storage:** Audit logs should be shipped to a separate, secure environment (e.g., AWS S3 with Object Lock, Splunk, Datadog) immediately upon generation. This prevents an attacker who compromises the Auth Server from deleting the logs that reveal their presence.
*   **Destruction:** When the retention period expires, data must be securely deleted (scrubbed), especially if it contains identifying user information (PII).

---

### Summary Checklist for Implementation

If you are building or configuring the Audit system for OAuth:

1.  **Immutability:** Ensure developers/admins cannot edit the logs once written.
2.  **Sanitization:** Implement a filter to strip secrets/tokens before writing to disk.
3.  **Correlation IDs:** Ensure the trace ID from the API Gateway passes through to the Authorization Server logs so you can trace a request end-to-end.
4.  **Alerting:** Set up alerts on the audit logs (e.g., "Alert me if `login_failed` > 10 events per minute").
