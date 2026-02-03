Based on the Table of Contents provided, **Section 101: Ruby Implementation** focuses on how to build SCIM 2.0 capabilities specifically within the Ruby ecosystem, predominantly using the **Ruby on Rails** framework.

Since SCIM is a strict specification involving complex JSON schemas, filtering syntax, and specific HTTP headers, building it from "scratch" in a standard Rails controller is difficult and error-prone. This section covers the libraries (Gems) and design patterns used to simplify this process.

Here is a detailed explanation of the three main concepts within this section:

---

### 1. `scim_rails`
**Type:** Ruby Gem (Engine)  
**Primary Use Case:** Building a Service Provider (Hosting a SCIM API).

This is currently the most popular and widely supported standard for adding SCIM to a Rails application. It is designed as a Rails Engine, meaning it mounts directly into your application and provides a pre-built structure.

*   **How it works:**
    *   **Mounting:** You mount the engine in your `config/routes.rb` (e.g., `mount ScimRails::Engine => '/scim/v2'`).
    *   **Configuration:** It uses an initializer file (`config/initializers/scim_rails.rb`) to map SCIM logic to your existing application logic.
    *   **Model Mapping:** You explicitly tell the gem how to map SCIM attributes to your ActiveRecord models.
        *   *Example:* Map SCIM `userName` to your User model's `email` column.
        *   *Example:* Map SCIM `active` (boolean) to a custom method like `user.archived?`.
*   **Key Features:**
    *   **Content-Type Handling:** Automatically handles the strict `application/scim+json` header requirements.
    *   **Response Formatting:** Automatically serializes your User and Group models into standard SCIM JSON responses.
    *   **Filter Parsing:** It includes logic to translate SCIM filter strings (e.g., `filter=userName eq "alice"`) into ActiveRecord queries.

### 2. `scimitar`
**Type:** Ruby Gem  
**Primary Use Case:** Building a Service Provider (Hosting a SCIM API), with a focus on Custom Schemas.

Scimitar is an alternative to `scim_rails`. While `scim_rails` is excellent for standard User/Group implementations, `scimitar` is often praised for being more flexible if you need to define **Custom Resource Types** or heavily customized Schemas beyond the standard RFC definition.

*   **How it works:**
    *   It provides a DSL (Domain Specific Language) to define schemas programmatically.
    *   It offers controller mixins/inheritance that allows you to write your own controllers but inherit the complex SCIM logic (like parsing PATCH requests).
*   **Key Distinction:**
    *   Use **`scim_rails`** if you want a "plug-and-play" solution for standard User provisioning from Okta/Azure AD.
    *   Use **`scimitar`** if you are building a specialized SCIM API that uses complex custom attributes or non-standard resources (e.g., provisioning "Devices" or "Licenses" instead of just Users).

### 3. Implementation Patterns
This subsection covers the architectural decisions a Ruby developer must make when integrating these gems or writing custom SCIM logic.

#### A. Authentication & Security
SCIM usually relies on a Bearer Token. In a Ruby implementation, this pattern typically looks like:
*   **Middleware:** Using `Rack::Cors` to allow requests from the Identity Provider (IdP).
*   **Token Auth:** Utilizing `ActionController::HttpAuthentication::Token::ControllerMethods`.
*   **Tenant Scoping:** If the app is multi-tenant (SaaS), the implementation must determine *which* company directory to query based on the Bearer Token provided in the request headers.

#### B. The "Mutable/Immutable" Attribute Problem
SCIM allows attributes to be defined as `readOnly` or `immutable`.
*   *Ruby Pattern:* You cannot simply use `User.update(params)`. You must implement a translation layer that sanitizes the incoming params. If an IdP tries to update an immutable field (like a generic database `id`), the Rails app must either ignore it or throw a SCIM standard error (400 Bad Request with `mutability` error type), depending on the strictness level.

#### C. Handling the PATCH Method
SCIM uses `PATCH` differently than standard Rails `update` actions. SCIM PATCH requests contain an array of operations (`add`, `remove`, `replace`) and paths (e.g., `emails[type eq "work"].value`).
*   *Implementation Pattern:* Parsing these paths is difficult. The pattern usually involves loading the User model, applying the JSON operations in memory, validating the result, and *then* saving. This differs from standard Rails CRUD which usually maps params directly to database columns.

#### D. Error Handling Mapping
Ruby exceptions must be mapped to specific SCIM JSON error responses.
*   `ActiveRecord::RecordNotFound` $\rightarrow$ **404 Not Found**
*   `ActiveRecord::RecordInvalid` $\rightarrow$ **409 Conflict** (if uniqueness violation) or **400 Bad Request**.
*   The implementation requires a global error handler (using `rescue_from` in the Controller) to ensure the response body is a valid JSON SCIM Error object, not a generic HTML 500 page.

#### E. Service Provider Configuration
A compliant SCIM implementation must expose endpoints like `/ServiceProviderConfig` and `/Schemas`.
*   *Pattern:* Instead of hardcoding these responses, Ruby implementations typically introspect the configuration (reading which attributes are enabled in the initializer) to dynamically generate these JSON discovery artifacts so they never drift from the actual code behavior.

---

### Summary Table for Ruby Developers

| Feature | `scim_rails` | `scimitar` |
| :--- | :--- | :--- |
| **Setup Speed** | Fast (DSL in initializer) | Medium (Requires more controller setup) |
| **Custom Resources** | Harder | Easier |
| **Routing** | Automated (Engine) | Manual (Standard Rails Routes) |
| **Filtering (SQL)** | Built-in basic support | Built-in support |
| **Best For** | Standard SaaS User Provisioning | Complex/Custom Identity APIs |
