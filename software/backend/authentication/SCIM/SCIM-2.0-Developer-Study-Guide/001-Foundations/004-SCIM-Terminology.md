Based on the Table of Contents provided, **Part 1, Section 4: SCIM Terminology** is the glossary foundation for understanding how SCIM works. Before a developer can implement SCIM, they must agree on what specific words mean, as SCIM uses standard API terms in very specific ways.

Here is a detailed explanation of each term listed in that section:

---

### 1. Service Provider (SP)
*   **Definition:** The application or system that "owns" the user accounts and where the identity data needs to end up. It acts as the HTTP Server.
*   **The Role:** The Service Provider implements the SCIM API endpoints. It receives requests (like "Create User") and executes them in its database.
*   **Real-World Examples:** Slack, Dropbox, Salesforce, GitHub.
*   **Why it matters:** If you are building a SaaS app and want companies to easily onboard their employees, you are building a **Service Provider**.

### 2. Client (Identity Provider / Provisioning System)
*   **Definition:** The system that manages the "source of truth" for identities. It initiates the HTTP requests to the Service Provider.
*   **The Role:** The Client detects changes in its own database (e.g., "John Doe was hired") and sends SCIM commands (POST, PUT, PATCH, DELETE) to the Service Provider to keep everything in sync.
*   **Real-World Examples:** Okta, Microsoft Azure Active Directory (Entra ID), OneLogin, or a custom Python script running on a server.
*   **Note:** In SCIM, the "Client" is rarely a human web browser; it is almost always a backend server acting on behalf of an administrator.

### 3. Resource
*   **Definition:** A specific JSON object that represents a data entity. It is the fundamental unit of data exchanged in SCIM.
*   **The Role:** When the Client sends data to the Service Provider, it sends a Resource. Every Resource must have a unique identifier (`id`).
*   **Examples:**
    *   **User Resource:** A JSON object representing "Alice Smith."
    *   **Group Resource:** A JSON object representing the "Engineering Team."

### 4. Resource Type
*   **Definition:** The classification or definition of a Resource. It tells the system what "kind" of object we are dealing with.
*   **The Role:** SCIM allows for discovery. A Client can ask a Service Provider, "What types of resources do you support?" The SP might reply, "I support Users and Groups."
*   **Standard Types:** `User`, `Group`.
*   **Custom Types:** Some systems might define custom types like `Device` or `Contractor`.

### 5. Schema
*   **Definition:** The blueprint or set of rules that defines the structure of a Resource. It dictates what fields exist, what data types they use (string, integer, boolean), and which fields are required.
*   **The Role:** Before a Client sends data, it must know the Schema so it doesn't send invalid JSON.
*   **Example:** The User Schema defines that a user must have a `userName` (string) and may have `emails` (array).
*   **URI Identifier:** Schemas are identified by long URNs, e.g., `urn:ietf:params:scim:schemas:core:2.0:User`.

### 6. Attribute
*   **Definition:** An individual data field within a Resource.
*   **The Role:** Attributes hold the actual data. SCIM attributes have specific characteristics, such as `mutability` (can it be changed?), `uniqueness` (must it be unique?), and `required` (is it mandatory?).
*   **Types of Attributes:**
    *   **Simple:** `userName` (String), `active` (Boolean).
    *   **Multi-Valued:** `emails` (A list of email objects).
    *   **Complex:** Attributes that contain sub-attributes (e.g., `name` contains `givenName` and `familyName`).

### 7. Endpoint
*   **Definition:** The specific URL (Uniform Resource Locator) where the Service Provider listens for SCIM requests.
*   **The Role:** The Client sends HTTP methods (GET, POST, PATCH) to these URLs.
*   **Standard Endpoints:**
    *   `/Users` (To manage User resources)
    *   `/Groups` (To manage Group resources)
    *   `/Schemas` (To read the configuration)
    *   `/ServiceProviderConfig` (To see what features the server supports)

### 8. Bulk Operation
*   **Definition:** A method of performing multiple operations (Create, Update, Delete) in a single HTTP request.
*   **The Role:** Instead of making 1,000 separate HTTP calls to import 1,000 users (which is slow and eats up bandwidth), the Client sends one large JSON payload containing all the operations.
*   **Key Concept:** Bulk operations in SCIM support dependencies. For example, creating a User *and* adding them to a Group in the same request using temporary IDs (`bulkId`).

---

### Summary: How they fit together

> The **Client** (e.g., Okta) looks at the **Schema** to understand how to format data. It creates a **Resource** (e.g., a User JSON object) containing specific **Attributes** (name, email). It sends this Resource to the **Service Provider's** (e.g., Slack) **Endpoint** via an HTTP request. If onboarding a whole company at once, it uses a **Bulk Operation**.
