Based on **Part 13: Migration & Interoperability** of the table of contents, here is a detailed explanation of section **79. Migrating from SAML 1.1 to SAML 2.0**.

---

# 79. Migrating from SAML 1.1 to SAML 2.0

SAML 2.0 was released in 2005. While it is the industry standard today, some legacy systems still run on SAML 1.1. Migrating is critical because SAML 2.0 is not just an update—it is a significant overhaul that merges SAML 1.1 with specifications from the Liberty Alliance (ID-FF) and the Shibboleth project.

Here is a detailed breakdown of the four sub-topics involved in this migration.

---

### 1. Key Differences
The most important thing to understand is that **SAML 2.0 is not backward compatible with SAML 1.1**. They use different XML Namespaces, different terminologies, and different processing rules.

| Feature | SAML 1.1 | SAML 2.0 |
| :--- | :--- | :--- |
| **Terminology** | "Source Site" and "Destination Site" | **Identity Provider (IdP)** and **Service Provider (SP)** |
| **XML Namespace** | `urn:oasis:names:tc:SAML:1.0:assertion` | `urn:oasis:names:tc:SAML:2.0:assertion` |
| **Initiation** | Usually IdP-Initiated only (SP-Init was non-standard/hacky). | Native support for **SP-Initiated** and IdP-Initiated flows via `AuthnRequest`. |
| **Encryption** | Did not support XML Encryption. Relied entirely on HTTPS transport security. | Native support for **EncryptedAssertions** (XML Enc) within the payload. |
| **Logout** | No standard definition for Global Logout. | Standardized **Single Logout (SLO)** Protocol. |
| **Bindings** | Primarily HTTP-POST (push model). | HTTP-Redirect (GET) for requests, HTTP-POST for responses, and Artifact bindings. |
| **Identifiers** | `NameIdentifier` | `NameID` (with robust formats like Persistent/Transient). |

---

### 2. Migration Steps
Migrating a Service Provider (SP) or Identity Provider (IdP) from 1.1 to 2.0 involves a "rip and replace" of the protocol layer rather than a simple configuration tweak.

#### Phase A: Inventory and Assessment
Identify all integrations currently using SAML 1.1. Since the protocols cannot mix within a single logic flow, you must treat the migration as a new integration setup.

#### Phase B: Library Updates
Most modern SAML libraries (e.g., OneLogin, Spring Security SAML) are built for SAML 2.0. If you are using a legacy library that *only* supports 1.1, you must upgrade to a modern library (e.g., OpenSAML v3 or v4, or a language-specific framework).

#### Phase C: Metadata Generation
SAML 1.1 relied heavily on manual configuration exchange. SAML 2.0 relies on **SAML Metadata**.
*   **Action:** You must generate a compliant `EntityDescriptor` XML file.
*   **IdP:** Define `IDPSSODescriptor` blocks.
*   **SP:** Define `SPSSODescriptor` blocks (including your ACS URLs).

#### Phase D: Configuration Changes
1.  **Change Endpoints:** Switch the target URL on the IdP from the SAML 1.1 listener to the SAML 2.0 Consumer Service (ACS).
2.  **Request Format:** Ensure the SP sends a SAML 2.0 `AuthnRequest` (usually via HTTP-Redirect) instead of simply waiting for a POST.
3.  **Claims/Attributes:** Validate that the attribute URNs haven't changed. For example, SAML 1.1 might send an email as a simple string, whereas SAML 2.0 might require a specific `NameFormat` (e.g., `urn:oasis:names:tc:SAML:2.0:attrname-format:uri`).

---

### 3. Backward Compatibility strategies
Since the protocols are incompatible, how do you keep the lights on during migration? You use **Dual-Stack Support**.

#### For Identity Providers (IdP)
An IdP can be configured to support *both* SAML 1.1 and SAML 2.0 simultaneously.
*   The IdP maintains two sets of metadata bindings.
*   If an application sends a request to the SAML 1.1 endpoint, the IdP responds with SAML 1.1 XML.
*   If an application sends a request to the SAML 2.0 endpoint (Sending an `AuthnRequest`), the IdP responds with SAML 2.0 XML.
*   **Migration Path:** This allows you to migrate Service Providers one by one without a "Big Bang" cutover.

#### For Service Providers (SP)
It is harder for an SP to support both simultaneously for the *same* login button unless you implement logic to detect which IdP user is trying to log in. Usually, an SP cuts over completely to 2.0 once the IdP confirms readiness.

---

### 4. Testing Strategies
When moving from 1.1 to 2.0, standard connectivity tests are not enough.

#### A. Namespace Validation
Ensure your parser is strictly checking for `urn:oasis:names:tc:SAML:2.0:assertion`. A common security vulnerability occurs when a parser accepts a 1.1 assertion (which might lack signatures or encryption) and treats it as a valid 2.0 session.

#### B. Signature Verification
SAML 2.0 has strict rules about where the XML Signature sits (e.g., signing the whole `Response` vs. signing the `Assertion`). SAML 1.1 signatures were often handled differently or relied solely on checking the SSL certificate of the connection. You must verify that **XML Digital Signatures** are validating correctly.

#### C. Replay Attacks
SAML 1.1 implementations often had weak checks for replay attacks. In SAML 2.0, you must explicitly test that the `NotOnOrAfter` conditions and the `ID` cache are working to prevent a captured assertion from being used twice.

#### D. The "RelayState"
In SAML 1.1, directing a user back to the specific page they attempted to access was often custom-coded. In SAML 2.0, test the **RelayState** parameter to ensure deep-linking works correctly after the migration.

### Summary Checklist for Developer Migration
1.  [ ] **Metadata:** Create valid SAML 2.0 XML metadata.
2.  [ ] **Bindings:** Switch from legacy POST-only flows to Redirect+POST flows.
3.  [ ] **Security:** Enable Assertion Encryption (if required) and validate XML Signatures.
4.  [ ] **Attributes:** Map legacy 1.1 attribute names to 2.0 formats.
5.  [ ] **Cleanup:** Once migrated, disable the SAML 1.1 listeners to reduce the attack surface.
