Based on the Table of Contents provided, here is a detailed explanation of section **1.B: The Actors**.

In the world of SCIM (System for Cross-domain Identity Management), understanding "Who does what" is vital because the terminology often confuses developers. The relationship is based on a **Client-Server** model, but specifically regarding who **initiates** the HTTP requests.

Here is the breakdown of the two distinct actors.

---

### i. The SCIM Client (The Identity Provider / IdP)

The **SCIM Client** is the **Active Party**. In almost all SCIM workflows, this entity starts the conversation.

*   **Who they usually appear as:**
    *   **Identity Providers (IdP):** Okta, Microsoft Entra ID (formerly Azure AD), OneLogin, PingIdentity, Rippling, JumpCloud.
*   **Their Role:**
    *   **Source of Truth:** They hold the master list of employees, their job titles, departments, and active status.
    *   **The "Trigger":** When an IT admin adds a new employee to the IdP, the IdP triggers a workflow to sync that data downstream.
    *   **REST Client:** Technically speaking, the IdP acts as the HTTP Client. It constructs the JSON payload and sends `POST`, `PUT`, `PATCH`, or `DELETE` requests.
*   **The "Push" Model:**
    *   Unlike some systems where an application wakes up and asks "Do you have new users for me?" (Polling), the SCIM Client **pushes** data.
    *   *Example:* Okta (Client) says to your App: *"Hey, I have a new user named Alice. Create an account for her right now."*

### ii. The SCIM Server (The Service Provider / SP)

The **SCIM Server** is the **Passive Party**. This is usually the application that you are building or integrating.

*   **Who they usually appear as:**
    *   **SaaS Applications (Service Providers):** Slack, Dropbox, Zoom, AWS, GitHub, or **Your Custom B2B SaaS App**.
*   **Their Role:**
    *   **The Receiver:** They wait for instructions. They do not maintain the master HR record; they simply maintain a local account so the user can log in to their specific tool.
    *   **REST API Host:** The Service Provider must build and host the API endpoints (e.g., `https://api.myapp.com/scim/v2/Users`).
    *   **The Compliance Officer:** The Server receives the JSON, validates it (checks if the email is valid, if the name is missing), and then writes the user to its own database.
*   **The Response:**
    *   After the Client pushes data, the Server replies with HTTP Status Codes:
        *   `201 Created` (Success)
        *   `409 Conflict` (User already exists)
        *   `403 Forbidden` (Invalid API Token)

---

### Visualizing the Relationship

To understand the dynamic, imagine a **New Employee (John)** joining a company.

```mermaid
graph LR
    A[IT Admin] -- 1. Creates User 'John' --> B(SCIM Client / IdP)
    B -- 2. POST /Users { "userName": "John" } --> C(SCIM Server / Your App)
    C -- 3. Saves to DB & Returns 201 Created --> B
```

1.  **The Trigger:** The IT Admin logs into **Okta (The SCIM Client)** and creates John's employee profile.
2.  **The Action:** Okta detects that John is assigned to **Your App (The SCIM Server)**. Okta instantly fires an API call to your server.
3.  **The Result:** Your App validates the request and creates a local user record for John so he can log in immediately.

### Why is this confusing?

Developers often find this confusing because of the terms "Client" and "Server."

In a typical web app scenario:
*   The **Web Browser** is the Client.
*   **Okta** is usually a Server (for logging in).

**However, in SCIM:**
*   **Okta becomes the Client** because it is *making* the outbound API call.
*   **Your App becomes the Server** because it is *receiving* the API call.

### Summary Table

| Feature | SCIM Client (IdP) | SCIM Server (SP) |
| :--- | :--- | :--- |
| **Real World Role** | The HR Department / Boss | The Building Security / Keymaker |
| **Examples** | Okta, Azure AD, OneLogin | Slack, Jira, Your SaaS App |
| **Technical Role** | Initiates requests (Sender) | Host Endpoints (Receiver) |
| **Data Authority** | Master source of truth | Local copy / Replica |
| **Direction** | Pushes changes Out | Ingests changes In |
