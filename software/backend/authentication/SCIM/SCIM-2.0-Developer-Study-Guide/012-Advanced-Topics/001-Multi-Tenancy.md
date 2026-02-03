Here is a detailed explanation of Part 12, Section 66: **Multi-Tenancy** in the context of SCIM 2.0.

---

# 66. Multi-Tenancy in SCIM

In software architecture, **Multi-Tenancy** is a mode where a single instance of a software application serves multiple customers (tenants). For a SaaS application implementing SCIM (the Service Provider), this is a critical architectural decision.

When an Identity Provider (IdP) like Okta or Azure AD sends a request to create a user, your SCIM server must know **which customer** that user belongs to. Without proper multi-tenancy handling, you risk provisioning Company A's employees into Company B's account.

Here is a breakdown of the specific sub-topics outlined in the syllabus.

---

## 1. Tenant Identification
This describes the mechanism the SCIM server uses to determine which tenant context applies to an incoming HTTP request.

Since SCIM is stateless (RESTful), every single request (GET, POST, PATCH, DELETE) must carry specific information allowing the server to route the request to the correct data partition.

**The Strategy:**
When building the SCIM endpoint, you must decide where this "Tenant ID" lives in the HTTP request.

---

## 2. URL-Based Tenancy
This is the most common implementation for SCIM because it is explicit and easy to route at the load balancer or API Gateway level. The Tenant ID is embedded directly into the endpoint path or the domain.

### **Path-Based (Most Common)**
The tenant ID is a parameter in the URL path.
*   **Format:** `https://api.your-app.com/scim/v2/{tenantId}/Users`
*   **Example:** `POST https://api.your-app.com/scim/v2/acme-corp/Users`

**Pros:**
*   Visible in access logs (easy debugging).
*   Easy to configure in IdPs (most IdPs ask for a "Base URL").
*   RESTful compliance (The tenant is a resource container).

### **Subdomain-Based**
The tenant is identified by the specific subdomain.
*   **Format:** `https://{tenantId}.api.your-app.com/scim/v2/Users`
*   **Example:** `POST https://acme-corp.api.your-app.com/scim/v2/Users`

**Pros:**
*   Clean separation of traffic (DNS routing).
*   Cookies and security policies can be scoped to the subdomain.

---

## 3. Header-Based Tenancy
In this model, the URL remains generic, and the tenant is identified via a custom HTTP header.

*   **URL:** `https://api.your-app.com/scim/v2/Users`
*   **Header:** `X-Tenant-ID: acme-corp`

**Pros:**
*   Keeps URLs clean and short.
*   Hides the Tenant ID from browser history or casual observation (though still visible in network inspection).

**Cons:**
*   **IdP Support:** Not all Identity Providers support sending custom headers easily. Some require complex scripting to inject headers into SCIM requests.
*   Harder to debug using standard access logs (unless you configure logs to capture specific headers).

---

## 4. Token-Based Tenancy
This is considered the most secure modern approach, often used in conjunction with OAuth 2.0 Bearer tokens.

The Tenant ID is not in the URL or a custom header; it is encoded **inside the Access Token** (JWT) used for authentication.

**Workflow:**
1.  The IdP authenticates and receives an OAuth Token.
2.  Inside the payload of that token, there is a claim (e.g., `tid`, `org_id`, or `aud`).
3.  The IDP sends a request: `Authorization: Bearer <token>`.
4.  The SCIM Server decodes the token, validates the signature, extracts the `org_id`, and sets the context.

**Pros:**
*   **Security:** You cannot spoof the tenant. If you change a URL parameter in URL-based tenancy, you might access another tenant if authorization isn't checked strictly. With tokens, the tenancy is cryptographically signed.
*   **Simplicity:** The URL is generic (`/scim/v2/Users`).

**Cons:**
*   Requires the endpoint to decode the token *before* it can even decide which database to connect to.

---

## 5. Tenant Isolation
Once the request arrives and the tenant is identified, the application must ensure **Isolation**. This prevents data leakage between customers.

### **Logical Isolation (Row-Level Security)**
Most SaaS apps use a shared database.
*   Every table (Users, Groups) has a `tenant_id` column.
*   **The Golden Rule:** Every database query triggered by a SCIM request must include `WHERE tenant_id = ?`.
*   *Implementation Tip:* Use Middleware. Do not let individual developers remember to add the "WHERE" clause. The middleware detects the tenant from the URL/Token and automatically injects a filter into the ORM or Data Access Layer.

### **Authorization Validation**
A common vulnerability is **IDOR (Insecure Direct Object Reference)** in multi-tenant systems.
*   *Attack Vector:* A malicious user has a valid token for Tenant A, but they manually change the URL to `.../v2/TenantB/Users`.
*   *Defense:* If using URL-based tenancy, you must validate that the Tenant ID in the URL matches the Tenant ID allowed by the Authentication Token. If they don't match, return `403 Forbidden`.

---

## 6. Cross-Tenant Operations
This section deals with the complexities of data uniqueness and operations that might span tenants.

### **Uniqueness Constraints**
*   **Global vs. Local Uniqueness:**
    *   `userName`: Usually needs to be unique within a Tenant, but duplicates are allowed globally (e.g., `admin@test.com` can exist in Tenant A and Tenant B).
    *   `externalId`: Must be unique within the Tenant.
    *   `id` (The SCIM ID): It is highly recommended to use **UUIDs** (Universally Unique Identifiers) for the SCIM `id`. If you use auto-incrementing integers (User 1, User 2), you risk collisions or leaking business intelligence (e.g., a competitor seeing they are User ID 500 implies you only have 500 users).

### **Shared Resources**
Sometimes, resources are shared across tenants (common in B2B2C apps).
*   If a single user identity (e.g., a contractor) belongs to two different tenants (Company A and Company B), scim treats them as **two separate resources**.
*   SCIM does not natively support "linking" users across tenants. Tenant A will have a User Resource for the contractor, and Tenant B will have a totally separate User Resource for the same person.

### **Database Sharding**
For very large SCIM implementations, you might shard tenants.
*   Tenants A-M live in Database Cluster 1.
*   Tenants N-Z live in Database Cluster 2.
*   The API Gateway must perform the "Tenant Identification" step (from Section 1) and route the traffic to the correct physical infrastructure.
