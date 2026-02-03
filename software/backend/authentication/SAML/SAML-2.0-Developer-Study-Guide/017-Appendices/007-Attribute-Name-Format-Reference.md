Based on the Table of Contents you provided, simple **Appendix G (Attribute Name Format Reference)** serves as a technical lookup guide for the `NameFormat` attribute found within SAML Attribute Statements.

Here is a detailed explanation of what this section covers, why it exists, and the specific formats it references.

---

### 1. The Purpose of Attribute Name Formats

In a SAML Assertion, an Identity Provider (IdP) sends user data (like email, department, role) to a Service Provider (SP). This happens in the `<AttributeStatement>`.

However, simply naming an attribute "email" is risky.
*   Does "email" mean a personal email or work email?
*   Is "Role" a simple string (like "admin") or a complex LDAP Distinguished Name?
*   Are we using the standard OID (Object Identifier) naming convention or a custom one?

The **Attribute Name Format** is a specific URI flagged in the XML that tells the Service Provider **how to interpret the name of the attribute.** It ensures that both parties are speaking the same "language" regarding data labeling.

### 2. Where it lives in the XML

This appendix references the values allowed in the `NameFormat` field of the `<Attribute>` tag:

```xml
<saml:AttributeStatement>
  <saml:Attribute 
      Name="urn:oid:2.5.4.42" 
      NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri"> <!-- THIS PART -->
      <saml:AttributeValue>John</saml:AttributeValue>
  </saml:Attribute>
</saml:AttributeStatement>
```

### 3. The Reference List (The Contents of Appendix G)

This appendix is essentially a table of the standard URI strings defined by the OASIS SAML 2.0 specification. These are the three most common formats you will find in this reference:

#### A. Unspecified
*   **URI:** `urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified`
*   **Explanation:** This acts as the "default" or "I don't care" setting. It tells the SP: "Here is an attribute name; interpret it however we agreed upon manually."
*   **Use Case:** Common in simple, custom integrations where the IdP just sends `Name="email"` and the SP knows to look for the string "email".

#### B. URI Reference (The "Strict" Standard)
*   **URI:** `urn:oasis:names:tc:SAML:2.0:attrname-format:uri`
*   **Explanation:** This indicates that the `Name` of the attribute is a formal URI (Uniform Resource Identifier). This is often an X.500/LDAP OID (Object Identifier).
*   **Use Case:** This is the most formal and interoperable method. Instead of sending `Firstname`, the IdP sends `urn:oid:2.5.4.42`. Because OIDs are globally unique standards, any SP worldwide knows exactly what that data is. Microsoft ADFS and many academic federations (like InCommon) prefer this.

#### C. Basic (The "Legacy" Format)
*   **URI:** `urn:oasis:names:tc:SAML:2.0:attrname-format:basic`
*   **Explanation:** This format is used when the attribute name is a simple string (no URIs), but it strictly follows SAML 1.1 naming conventions.
*   **Use Case:** Used for backward compatibility with older systems or simpler implementations where the overhead of full OIDs isn't desired, but the structure of "Unspecified" is too loose.

### 4. Why a Developer Needs This Appendix

If you are building a SAML integration (either an IdP or an SP), you will encounter errors if these formats do not align.

1.  **Attribute Mapping Failures (SP Side):**
    If your code expects to receive the `NameFormat` as "Unspecified" and the name "Email", but the IdP sends the `NameFormat` as "URI" and the name "urn:oid:0.9.2342.19200300.100.1.3", your code will fail to find the user's email address, and the login will likely crash or create a blank user profile.

2.  **Configuration (IdP Side):**
    When configuring an IdP (like Okta, Keycloak, or Azure AD), you often have a dropdown menu asking for "Name Format." You cannot just guess. You must look at the SP's metadata or documentation to see which format they require. This Appendix provides the exact URI string you need to select or paste into your configuration.

### Summary Table

| Format Name | URI String | Attribute Name Example |
| :--- | :--- | :--- |
| **Unspecified** | `urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified` | `email` |
| **URI** | `urn:oasis:names:tc:SAML:2.0:attrname-format:uri` | `urn:oid:0.9.2342.19200300.100.1.3` |
| **Basic** | `urn:oasis:names:tc:SAML:2.0:attrname-format:basic` | `mail` |
