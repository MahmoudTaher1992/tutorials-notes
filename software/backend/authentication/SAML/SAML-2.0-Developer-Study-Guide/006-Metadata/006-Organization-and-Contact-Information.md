Based on **Part 6 (Metadata), Item 40** of your Table of Contents, here is a detailed explanation of **Organization and Contact Information** in SAML 2.0.

---

# 40. Organization and Contact Information

In the world of SAML Metchadta, most elements are machine-readable configurations (URLs, certificates, bindings). However, the **Organization** and **Contact Information** sections are the "human-readable" parts of the metadata.

They answer two fundamental questions for any entity entering a federation:
1.  **Who owns this entity?** (Organization)
2.  **Who do I talk to if it breaks?** (ContactPerson)

## 1. The `<md:Organization>` Element

This element provides information about the entity (company, university, government agency) responsible for operating the Identity Provider (IdP) or Service Provider (SP).

While this might look like simple administrative data, it is used programmatically by **Identity Discovery Services** (Discovery Interfaces or "WAYF" pages) to display a list of available organizations to the user.

### Structure & Sub-elements
The `<md:Organization>` element contains three specific child elements. Note that all of these elements **must** include an `xml:lang` attribute to specify the language (e.g., "en", "fr", "es").

1.  **`OrganizationName`**:
    *   The official, legal name of the organization.
    *   *Example:* "Acme Corporation Inc." or "University of Example, Department of IT".
2.  **`OrganizationDisplayName`**:
    *   A user-friendly name suitable for display in a User Interface (UI). This is what a user sees on a login selection screen.
    *   *Example:* "Acme Corp" or "Example U".
3.  **`OrganizationURL`**:
    *   A URI that points to the organization's general website (not the SSO login page). It helps users verify they are selecting the correct institution.
    *   *Example:* `https://www.acme.com`

### XML Example
```xml
<md:Organization>
    <md:OrganizationName xml:lang="en">Acme Corporation International</md:OrganizationName>
    <md:OrganizationDisplayName xml:lang="en">Acme Corp</md:OrganizationDisplayName>
    <md:OrganizationURL xml:lang="en">https://www.acme.com</md:OrganizationURL>
</md:Organization>
```

---

## 2. The `<md:ContactPerson>` Element

This element provides contact details for specific roles within the organization. You can encompass multiple `<md:ContactPerson>` elements in a single metadata file.

This is critical for operational stability. If an IdP's certificate is about to expire, or if an SP is sending malformed requests, the federation operator or the partner administrator needs to know who to email.

### The `contactType` Attribute
Every contact person must be assigned a `contactType`. The SAML specification defines several standard types:

1.  **`technical`**:
    *   **Who:** Developers, System Administrators, DevOps.
    *   **Purpose:** Contact for technical interoperability problems, server errors, or configuration mishaps.
2.  **`support`**:
    *   **Who:** Help Desk, Customer Support.
    *   **Purpose:** Contact for end-user inquiries (e.g., "I can't log in"). Federation operators rarely use this, but it is useful for deep-linking support pages.
3.  **`administrative`**:
    *   **Who:** CIO, IT Director, Policy Manager.
    *   **Purpose:** Contact for policy decisions, legal agreements, or contract signing regarding the federation.
4.  **`billing`**: (Less common)
    *   **Who:** Finance department.
    *   **Purpose:** Used in commercial federations where participation fees apply.
5.  **`other`**:
    *   Any other role not covered above (e.g., Security Incident Response).

### Sub-elements
*   `Company`: The company name (useful if the contact is a third-party contractor).
*   `GivenName`: The first name.
*   `SurName`: The last name.
*   `EmailAddress`: **The most critical field.** Format is usually `mailto:user@example.com`.
*   `TelephoneNumber`: Phone number.

### XML Example
```xml
<!-- Technical Contact -->
<md:ContactPerson contactType="technical">
    <md:GivenName>Alice</md:GivenName>
    <md:SurName>Smith</md:SurName>
    <md:EmailAddress>mailto:tech-ops@acme.com</md:EmailAddress>
</md:ContactPerson>

<!-- Support Contact -->
<md:ContactPerson contactType="support">
    <md:Company>Acme Service Desk</md:Company>
    <md:EmailAddress>mailto:helpdesk@acme.com</md:EmailAddress>
    <md:TelephoneNumber>+1-555-0199</md:TelephoneNumber>
</md:ContactPerson>
```

---

## 3. Best Practices for Implementation

When defining Organization and Contact Information, developers and admins should follow these best practices to ensure long-term maintainability.

### A. Use Distribution Lists, Not Individuals
Do not put a specific person's email (e.g., `bob.jones@company.com`) in the metadata.
*   **Why?** Bob might quit, go on vacation, or get promoted. If the SSL certificate expiration warning goes only to Bob, and Bob has left the company, the production SSO will go down.
*   **Do:** Use aliases like `sso-admins@company.com`, `idp-support@company.com`, or `security@company.com`.

### B. Localization (Multi-language Support)
If your application serves a global audience (e.g., Canada or the EU), you should include multiple `Organization` entries with different `xml:lang` tags.
*   *Example:*
    *   English: `<md:OrganizationDisplayName xml:lang="en">University of Ottawa</md:OrganizationDisplayName>`
    *   French: `<md:OrganizationDisplayName xml:lang="fr">Université d'Ottawa</md:OrganizationDisplayName>`

### C. Privacy Considerations
Since SAML metadata is often public (or at least shared widely within a federation), be mindful of PII (Personally Identifiable Information). Identifying a specific administrator by name and phone number exposes them to potential social engineering attacks. Using generic names ("IT Operations") and generic emails is safer.

### D. Security Incident Contacts
In modern federations (like InCommon or eduGAIN), there is a push to include a dedicated security contact (using `contactType="other"` and a specific attribute indicating `SIRTFI` compliance) so that if an account is compromised, other organizations know exactly who to alert to stop the breach.
