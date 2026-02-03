Based on the Table of Contents provided, here is a detailed explanation of section **77. SCIM Conformance Testing**.

---

# 77. SCIM Conformance Testing

SCIM Conformance Testing is the process of verifying that your implementation (usually a Service Provider) strictly adheres to the standards defined in **RFC 7643 (Schema)** and **RFC 7644 (Protocol)**.

While standard functional testing checks "Does it work?", conformance testing checks "Does it work **exactly how the standard says it should?**" likely ensuring interoperability with major Identity Providers (IdPs) like Okta, Azure AD, and OneLogin.

## 1. Why Conformance Testing Matters

In the world of SCIM, "close enough" is not good enough. Major IdPs write their SCIM client code based on the RFCs. If your API deviates slightly—for example, by returning a `200 OK` instead of a `201 Created` upon user creation, or by using the wrong date format—the integration will likely fail.

**Conformance testing ensures:**
*   **Interoperability:** Your app works with any standard-compliant Identity Provider.
*   **Portability:** You don't have to write custom code for Okta, then different code for Azure.
*   **Certification:** Many IdP marketplaces (like the Okta Integration Network) require proof of conformance before listing your app.

## 2. Key Areas of Conformance

A conformance test suite typically validates the following specific areas:

### A. Discovery Endpoints
The test will query your system's configuration to see if it truthfully reports its capabilities.
*   **`/ServiceProviderConfig`:** Does the server accurately report if it supports `patch`, `bulk`, `sort`, or specific `authenticationSchemes`?
*   **`/Schemas`:** Does the JSON structure of your user/group schemas match the RFC definitions?
*   **`/ResourceTypes`:** Are the endpoints for Users and Groups correctly defined?

### B. Protocol Strictness
*   **Headers:** Does the server accept and return `Content-Type: application/scim+json`?
*   **Status Codes:**
    *   Does a `POST` return `201 Created`?
    *   Does a `DELETE` return `204 No Content`?
    *   Does a failed user lookup return `404 Not Found` (and not an empty 200 list)?
*   **Case Sensitivity:** SCIM schema URNs and Attribute names are generally case-insensitive, but specific values (like IDs) might be case-sensitive. The test checks if you handle case sensitivity rules correctly.

### C. Complex Operations
*   **Filtering:** If your config says you support filtering, the test will try `filter=userName eq "bjensen"`. It will also test invalid filters to ensure you return the correct standard error (scimType: `invalidFilter`).
*   **PATCH:** This is the most common point of failure. The test will attempt complex path operations, such as adding a member to a group or replacing a specific sub-attribute.
*   **Versioning (ETags):** If supported, the test will check if you correctly support `If-Match` headers to prevent race conditions.

---

## 3. Tools for Conformance Testing

The study guide mentions specific tools used in the industry to automate this process.

### A. SCIM Compliance Checker (Postman, Open Source)
There isn't one single "official" IETF certification tool, so the community relies heavily on open-source suites.
*   **Concept:** These are typically Postman Collections or Python/Java test harnesses.
*   **Workflow:** You plug in your API Endpoint and Bearer Token. The suite runs 100+ requests against your API (Create User, Get User, Update User, Delete User, etc.) and asserts that the response JSON structure and headers match the RFC.
*   **Example Tool:** The **Microsoft SCIM Validator** or open-source libraries like `scim-validator` on GitHub.

### B. Runscope (Now part of BlazeMeter)
Runscope was a popular API monitoring tool that allowed for chaining API requests to verify logic flows.
*   **Relevance:** Developers often set up Runscope tests to "watch" their SCIM endpoints.
*   **The Test:** It verifies that if a user is created in step 1, they can be retrieved in step 2, and that the data hasn't mutated unexpectedly. It enforces contract testing.

### C. IdP-Specific Test Tools
Since most developers build SCIM to get into an app store, the IdPs provide their own validators.

**1. Okta SCIM Validator:**
*   Okta provides a testing utility specifically for the Okta Integration Network (OIN).
*   It runs a specific sequence: Create User -> Update Profile -> Deactivate User.
*   It checks for specific Okta quirks, such as handling `active: false` correctly.

**2. Microsoft Azure AD (Entra ID) Provisioning Agent:**
*   Microsoft provides an "On-demand Provisioning" test within the Azure portal.
*   It allows you to pick a single user and "force" a sync.
*   **Why it's great:** It provides a detailed log of every step: "Import User from AD" -> "Determine if User exists in Target" -> "Export to Target". If your API fails conformance (e.g., wrong attribute mapping), Azure gives a precise error log explaining which RFC rule was broken.

## 4. Common Conformance Failures (What to watch out for)

When running these tests, developers usually encounter these specific failures:

1.  **Mutability:** Trying to change an attribute marked as `readOnly` (like `id`) or `immutable` in the schema. A compliant server must ignore or reject this based on the context.
2.  **Canonical Values:** Returning a country code of "USA" when the standard expects ISO codes (e.g., "US"), or mismatching email "type" values (`work` vs `Work`).
3.  **Error Bodies:** Returning a generic HTTP 500 HTML page instead of the required SCIM JSON Error format:
    ```json
    {
      "schemas": ["urn:ietf:params:scim:api:messages:2.0:Error"],
      "status": "400",
      "scimType": "invalidFilter",
      "detail": "The filter syntax was invalid."
    }
    ```
4.  **Pagination:** The test requests `count=0` (which should return only the total number of results, usually for a pre-flight check) and the server incorrectly returns the actual list of users.

## Summary Checklist for Section 77

To master this section, you should know how to execute a test plan that validates:
1.  **JSON Schema validation** (Are all attributes correct types?).
2.  **HTTP Method correctness** (GET, POST, PUT, PATCH, DELETE).
3.  **HTTP Header correctness** (Content-Types, ETags).
4.  **Error handling compliance** (Correct SCIM error codes).
5.  **Passing the "smoke test"** of a major IdP (Okta or Azure AD).
