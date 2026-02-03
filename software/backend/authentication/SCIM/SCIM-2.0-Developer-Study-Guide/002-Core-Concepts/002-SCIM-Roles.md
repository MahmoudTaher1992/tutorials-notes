Based on **Part 2, Section 6** of the syllabus you provided, here is a detailed explanation of **SCIM Roles**.

In the world of SCIM (System for Cross-domain Identity Management), every interaction is defined by two primary actors. Understanding these two roles is fundamental because SCIM is a strict **Client-Server** model.

---

### 1. SCIM Client (The Provisioning Source)

The **SCIM Client** is the active party in the relationship. It is the system that acts as the "Source of Truth" or the decision-maker regarding user identities.

*   **Function:** It initiates all HTTP requests (GET, POST, PATCH, PUT, DELETE).
*   **Responsibility:**
    *   Detects changes in user data (e.g., "Alice was promoted," "Bob was fired").
    *   Translates its internal data format into standard SCIM JSON.
    *   Sends the data to the Service Provider.
    *   Handles errors or retries if the Service Provider is down.
*   **Analogy:** The **Mailman**. The mailman picks up the letter and drives it to the house. The house doesn't chase the mailman; the mailman goes to the house.

### 2. SCIM Service Provider (The Target System)

The **SCIM Service Provider (SP)** is the passive party. It is the application or database that needs to receive user data to function.

*   **Function:** It exposes a RESTful API (web endpoints) waiting for requests.
*   **Responsibility:**
    *   Listens for incoming SCIM requests.
    *   Validates the security (Authentication/Authorization) of the request.
    *   Validates the payload (e.g., "Is the email address valid?").
    *   Persists the change to its own database.
    *   Returns an HTTP response code (e.g., `201 Created` or `409 Conflict`).
*   **Analogy:** The **Mailbox**. The mailbox sits there waiting for the mailman to insert mail. It holds the mail (data) until the resident (the application) reads it.

---

### 3. Identity Provider as SCIM Client

In 90% of modern implementations, the **Identity Provider (IdP)** plays the role of the SCIM Client.

Systems like **Okta, Microsoft Entra ID (Azure AD), OneLogin, or JumpCloud** act as the central directory for a company. When an IT Admin creates a user in the IdP, the IdP triggers a SCIM request to downstream applications.

**The Workflow:**
1.  **HR Trigger:** HR adds a new employee, "Jane Doe," into the IdP.
2.  **Mapping:** The IdP converts Jane's data into SCIM JSON format.
3.  **Transmission:** The IdP (SCIM Client) sends a `POST /Users` request to Slack.
4.  **Result:** Jane can now log into Slack without a manual invite.

### 4. SaaS Application as Service Provider

SaaS (Software as a Service) applications act as the **SCIM Service Provider**.

Applications like **Slack, Zoom, GitHub, Dropbox, and Salesforce** build SCIM-compliant API endpoints so they don't have to build custom connectors for every single customer.

*   **The Goal:** By implementing the SCIM Service Provider standard, a SaaS app says: "I speak the universal language. If you send me standard JSON user data, I will create the account."
*   **The Burden:** The Service Provider has the harder engineering job. They must handle mapping complex queries, filtering, patching, and security compliance as defined in RF 7643/7644.

---

### 5. Role Interactions (How they talk)

The relationship between the Client and Service Provider is strictly **unidirectional** regarding the initiation of the connection. The Client always calls the Service Provider.

Here are the standard interactions:

#### A. Provisioning (Create)
*   **Scenario:** New employee hired.
*   **Client:** Sends `POST /Users` with JSON body.
*   **Service Provider:** Creates user in database, returns `201 Created` with the new ID.

#### B. Update (Push Updates)
*   **Scenario:** Employee changes Department or gets married (name change).
*   **Client:** Sends `PATCH /Users/{id}` with only the changed attribute (e.g., changing `lastName`).
*   **Service Provider:** Updates the record and returns `200 OK`.

#### C. Reconciliation (Pull/Discovery)
Sometimes the Client needs to know if the data is in sync.
*   **Scenario:** The IdP runs a nightly sync job.
*   **Client:** Sends `GET /Users?filter=userName eq "jane@example.com"`.
*   **Service Provider:** Searches database and returns the User Resource JSON.
*   **Client:** Compares the returned JSON with its own database to see if anything doesn't match.

#### D. Deprovisioning (Disable/Delete)
*   **Scenario:** Employee leaves the company.
*   **Client:** Sends `PATCH /Users/{id}` setting generic attribute `active: false`. (Note: Most enterprises prefer disabling users over deleting them via `DELETE` to preserve history).
*   **Service Provider:** Revokes the user's login access immediatly.

### Summary Diagram

```text
       +------------------+                        +------------------+
       |   SCIM CLIENT    |                        |   SCIM PROVIDER  |
       |                  |  HTTP Request (JSON)   |                  |
       | (Identity Prov.) | ====================>  |   (SaaS App)     |
       |                  |                        |                  |
       |  "Source of      |                        |  "Destination"   |
       |    Truth"        |  <===================  |                  |
       +------------------+   HTTP Response        +------------------+
               |                                            |
      [Has User Database]                          [Has User Database]
      [Initiates Calls]                            [Listens for Calls]
```

### Why this distinction matters?

If you are a **developer**:
*   If you are building a tool to *manage* users across other apps, you are building a **SCIM Client**.
*   If you are building a SaaS app and want enterprises to buy your software, you need to build a **SCIM Service Provider** endpoint so they can automatically onboard their users.
