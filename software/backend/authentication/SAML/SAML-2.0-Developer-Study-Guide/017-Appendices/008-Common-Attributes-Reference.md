Based on the Table of Contents you provided, specifically **Appendix H: Common Attributes Reference**, here is a detailed explanation of what this section covers, why it matters, and the specific attribute standards it refers to.

---

# Detailed Explanation: Appendix H - Common Attributes Reference

In the context of SAML 2.0, **Attributes** are the pieces of information (claims) about an authenticated user that the Identity Provider (IdP) sends to the Service Provider (SP).

While SAML defines *how* to transport data, it does not dictate *what* that data should be named. This Appendix serves as a dictionary or translation guide for the most widely used standard names for user data.

### 1. Why is this Reference Necessary?
The biggest challenge in Federated Identity is **Interoperability**.
*   **IdP A** might call a user’s email `emailAddress`.
*   **IdP B** might call it `mail`.
*   **IdP C** might use an OID like `urn:oid:0.9.2342.19200300.100.1.3`.

If a developer builds an SP expecting `emailAddress`, but the IdP sends `mail`, the application won't know the user's email. This Appendix lists the agreed-upon standards so IdPs and SPs speak the same language.

### 2. The Major Attribute Families
Appendix H typically covers three main families of attributes used in enterprise and academic settings:

#### A. X.500 / LDAP Attributes (The Core)
These are the oldest and most common attributes, derived from directory standards (like Active Directory or OpenLDAP). In SAML, these are often identified by OIDs (Object Identifiers).

| Friendly Name | Standard Name (OID/URI) | Description |
| :--- | :--- | :--- |
| **cn** | `urn:oid:2.5.4.3` | Common Name (often Full Name). |
| **sn** | `urn:oid:2.5.4.4` | Surname (Last Name). |
| **givenName** | `urn:oid:2.5.4.42` | First Name. |
| **mail** | `urn:oid:0.9.2342.19200300.100.1.3` | Email address. |
| **uid** | `urn:oid:0.9.2342.19200300.100.1.1` | User ID (often the login username). |
| **telephoneNumber**| `urn:oid:2.5.4.20` | Phone number. |

#### B. eduPerson Attributes (Academic & Research)
The ToC specifically mentions **eduPerson**. This is a standard object class defined by **Internet2** for higher education. If you are integrating with universities (like via InCommon or eduGAIN), these are required.

| Friendly Name | Standard Name | Description |
| :--- | :--- | :--- |
| **eduPersonPrincipalName (eppn)** | `urn:oid:1.3.6.1.4.1.5923.1.1.1.6` | A scoped unique identifier (e.g., `jsmith@mit.edu`). This is the "Gold Standard" for user IDs in academia. |
| **eduPersonAffiliation** | `urn:oid:1.3.6.1.4.1.5923.1.1.1.1` | The user's role: `student`, `faculty`, `staff`, `alum`, `member`. |
| **eduPersonScopedAffiliation** | `urn:oid:1.3.6.1.4.1.5923.1.1.1.9` | Role + Scope: `faculty@harvard.edu`. |
| **eduPersonTargetedID** | `urn:oid:1.3.6.1.4.1.5923.1.1.1.10` | A privacy-preserving, persistent, opaque identifier unique to the specific SP. |

#### C. SCHAC (Schema for Academia)
This is a European extension to eduPerson used in international research federations.

*   **schacHomeOrganization:** The domain of the institution (e.g., `ox.ac.uk`).
*   **schacPersonalUniqueCode:** National ID numbers or student ID numbers useful for internal records.

#### D. Vendor-Specific Attributes (Microsoft/Azure)
In enterprise environments using Azure AD (Entra ID) or ADFS, attributes often look like XML URLs:

*   `http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress`
*   `http://schemas.microsoft.com/identity/claims/tenantid`
*   `http://schemas.microsoft.com/ws/2008/06/identity/claims/groups`

### 3. Attribute Name Formats
This appendix also explains the `NameFormat` property in the SAML XML, which tells the parser how to interpret the attribute name.

1.  **urn:oasis:names:tc:SAML:2.0:attrname-format:uri**
    *   The most precise format.
    *   Example Name: `urn:oid:2.5.4.42`
2.  **urn:oasis:names:tc:SAML:2.0:attrname-format:basic**
    *   Simple string names.
    *   Example Name: `givenName`
3.  **urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified**
    *   Anything goes (Vendor specific).

### 4. What it looks like in XML (The "AttributeStatement")
The reference helps developers decode XML blocks like this:

```xml
<saml:AttributeStatement>
    <!-- The Reference tells you that 2.5.4.42 is "First Name" -->
    <saml:Attribute Name="urn:oid:2.5.4.42" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri" FriendlyName="givenName">
        <saml:AttributeValue>Jane</saml:AttributeValue>
    </saml:Attribute>

    <!-- The Reference tells you that 1.3.6.1...1.6 is the "Unique scoped ID" -->
    <saml:Attribute Name="urn:oid:1.3.6.1.4.1.5923.1.1.1.6" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri" FriendlyName="eduPersonPrincipalName">
        <saml:AttributeValue>jane.doe@university.edu</saml:AttributeValue>
    </saml:Attribute>
</saml:AttributeStatement>
```

### Summary of Appendix H Utility
For a developer, this appendix is the **Look-up Table** used when configuration fails.

*   **Scenario:** You are building an app for a university. They say, "We will release EPPN and Affiliation."
*   **Usage:** You look at this appendix to find out that "EPPN" corresponds to OID `1.3.6.1.4.1.5923.1.1.1.6` so you can code your XML parser to look for that specific string.
