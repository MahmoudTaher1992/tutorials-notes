Here is a detailed explanation of **Section 72: Monitoring & Alerting** within the context of OAuth 2.0 and OAuth 2.1 operations.

When running an Authorization Server (like Keycloak, Auth0, or a custom solution), monitoring is critical because authentication is the "front door" to your entire ecosystem. If the auth service is slow, the whole app feels slow. If it is down, no one can log in.

Here is the breakdown of the four key components of OAuth monitoring:

---

### 1. Metrics to Track
You need to collect data to understand the health and performance of your system. These metrics are usually categorized into **Infrastructure**, **Protocol**, and **Business** metrics.

#### **A. Protocol/Application Metrics (The RED Method)**
*   **Request Rates (Traffic):**
    *   **Login Page Loads:** How many people are attempting to sign in?
    *   **Token Endpoint Requests:** How many apps are exchanging codes for tokens?
    *   **Introspection Requests:** How heavily are Resource Servers hitting the validator?
*   **Error Rates (The 4 Protocol Errors):**
    *   **4xx Errors vs. 5xx Errors:** A spike in 500s means your server is crashing. A spike in 400s (401/403) implies user error or attack.
    *   **Specific OAuth Errors:** Track the occurrence of specific error codes defined in the spec:
        *   `invalid_grant`: Often means bad passwords or expired codes.
        *   `invalid_client`: Wrong Client ID/Secret.
        *   `unauthorized_client`: App trying to use a grant type it isn't allowed to.
*   **Duration (Latency):**
    *   **Token Signing Time:** Crypto operations (RSA/ECDSA signing) are CPU intensive. If this slows down, login hangs.
    *   **Database/LDAP Lookup Time:** How long does it take to fetch the user profile?

#### **B. Business/Usage Metrics**
*   **Active Sessions:** How many concurrent users are logged in?
*   **Tokens Issued:** Count of Access Tokens vs. Refresh Tokens issued.
*   **MAU/DAU:** Monthly/Daily Active Users (successful logins).

---

### 2. Anomaly Detection
Anomaly detection is about finding patterns that deviate from the "baseline" (normal behavior). This is primarily used for security intelligence.

*   **Impossible Travel (Geo-velocity):**
    *   *Scenario:* A user logs in from New York at 10:00 AM and from Tokyo at 10:15 AM.
    *   *Alert:* This is physically impossible; one of the logins is likely an attacker using stolen credentials.
*   **Credential Stuffing Spikes:**
    *   *Scenario:* You usually see 1% failed logins. Suddenly, you see 40% failed logins on the `/token` or `/authorize` endpoint.
    *   *Alert:* This indicates a botnet trying thousands of username/password combinations from a leaked database.
*   **Unusual Client Behavior:**
    *   *Scenario:* A "Public Client" (like a mobile app) that usually refreshes tokens once an hour suddenly refreshes them 50 times a second.
    *   *Alert:* The app might have a bug, or someone is trying to exploit the token endpoint.
*   **Refresh Token Reuse:**
    *   *Scenario:* A Refesh Token attempting to be used *after* it has already been used (and rotated).
    *   *Alert:* This is a strong indicator of token theft.

---

### 3. Rate Limiting
Rate limiting is the active defense mechanism to protect the availability of your service.

*   **Endpoint-Specific Limits:**
    *   **Authorization Endpoint:** Lower limits (to prevent scraping/phishing attempts).
    *   **Token Endpoint:** Medium limits (heavy crypto load).
    *   **Introspection/UserInfo:** Higher limits (APIs hit these frequently).
*   **Granularity (Who gets limited?):**
    *   **Per IP Address:** Prevents a single location from overwhelming the server (DDoS).
    *   **Per Client ID:** Prevents a specific buggy application from crashing the Authorization Server for everyone else.
    *   **Per User ID:** Prevents brute-force attacks against a specific user account.
*   **Response Handling:**
    *   The server should return `HTTP 429 Too Many Requests`.
    *   Headers like `Retry-After` should be sent to tell the client when to come back.

---

### 4. Abuse Prevention
This section goes beyond simple rate limiting and deals with malicious intent and logic flaws.

*   **Brute Force Protection:**
    *   If a specific user fails authentication 5 times in 1 minute, lock the account temporarily or trigger a **CAPTCHA**.
*   **Refresh Token Rotation Enforcement:**
    *   Under OAuth 2.1 BCP (Best Current Practice), if a "used" refresh token is detected, the server should immediately revoke the **active** family of tokens (the new refresh token and access token). This stops the attacker even if they have the new token.
*   **Mix-Up Attack Detection:**
    *   Monitoring for mismatching `iss` (issuer) parameters or Redirect URIs that look similar to registered ones but are slightly off (typosquatting).
*   **Leaked Secret Scanning:**
    *   Monitoring public repositories (like GitHub) for your own Client Secrets or Signing Keys. If found, an alert should trigger an immediate rotation of keys.

### Summary Table for Alerts

| Severity | Event | Action |
| :--- | :--- | :--- |
| **P1 (Critical)** | 5xx Errors > 1% of traffic | Wake up the SRE/DevOps team. Service is failing. |
| **P1 (Critical)** | Latency (p99) > 2 seconds | Investigate database or crypto locking issues. |
| **P2 (High)** | Spike in `invalid_grant` (Credential Stuffing) | Enable aggressive Rate Limiting or IP banning. |
| **P3 (Medium)** | Refresh Token Reuse Detected | Revoke token family; Notify the specific user (suspicious activity email). |
| **P3 (Medium)** | "Impossible Travel" detected | Trigger Step-Up Auth (MFA) for that session. |
