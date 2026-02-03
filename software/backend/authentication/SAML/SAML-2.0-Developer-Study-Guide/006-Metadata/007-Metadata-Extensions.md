Based on part **#41: Metadata Extensions** of the table of contents, here is a detailed explanation.

---

# 41. Metadata Extensions

Standard SAML 2.0 Metadata describes the **technical** connection details (URLs, certificates, bindings). However, as Identity Federations grew, it became clear that technical details weren't enough. Administrators needed ways to describe the **User Experience (UI)**, describe **capabilities** (like specific encryption support), and apply **tags** (categories) to entities.

The **SAML V2.0 Metadata Extensions** allow you to embed this extra information inside the standard metadata XML using specific XML namespaces.

## 1. UI Elements (User Interface Information)
**Namespace:** `xmlns:mdui="urn:oasis:names:tc:SAML:metadata:ui"`

This is arguably the most common extension. It provides human-readable information used by Discovery Services (login pages where users select their IdP) and consent screens. Without this, a user might only see a confusing Entity ID URL (e.g., `https://idp.example.com/shibboleth`) instead of a recognizable name.

### Key Elements of `<mdui:UIInfo>`:
*   **`DisplayName`**: The friendly name of the service or organization (e.g., "Acme University").
*   **`Description`**: A longer text explaining what the service does.
*   **`Logo`**: A URL to an icon/logo. It includes height and width attributes. Even better, it allows embedded Base64 images for self-contained metadata.
*   **`PrivacyStatementURL`**: A link to the organization's privacy policy (GDPR compliance usually mandates this).
*   **`InformationURL`**: A link to a help page or general info about the service.

### XML Example
```xml
<md:Extensions>
  <mdui:UIInfo>
    <mdui:DisplayName xml:lang="en">Acme Corp Portal</mdui:DisplayName>
    <mdui:Description xml:lang="en">The central portal for Acme employees.</mdui:Description>
    <mdui:Logo height="64" width="64">https://acme.com/logo.png</mdui:Logo>
    <mdui:PrivacyStatementURL xml:lang="en">https://acme.com/privacy</mdui:PrivacyStatementURL>
  </mdui:UIInfo>
</md:Extensions>
```

---

## 2. Discovery Hints
**Namespace:** `xmlns:mdui="urn:oasis:names:tc:SAML:metadata:ui"` (Same namespace as UIInfo)

In large federations (like InCommon or eduGAIN) where a user must choose their Identity Provider from a list of thousands, **Discovery Hints** help the browser or the Discovery Service (WAYF - Where Are You From) automatically suggest the correct IdP.

### Key Elements of `<mdui:DiscoHints>`:
*   **`IPHint`**: A CIDR block (IP range). If the user's IP connects from this range, the Discovery Service typically pre-selects this IdP.
*   **`DomainHint`**: DNS domain names. If the user enters an email address ending in `@university.edu`, the Service Provider knows to route them to the IdP associated with that domain.
*   **`GeolocationHint`**: Coordinates used to suggest IdPs geographically close to the user.

### XML Example
```xml
<md:Extensions>
  <mdui:DiscoHints>
    <mdui:IPHint>192.168.0.0/24</mdui:IPHint>
    <mdui:DomainHint>acme.com</mdui:DomainHint>
    <mdui:DomainHint>acme.org</mdui:DomainHint>
  </mdui:DiscoHints>
</md:Extensions>
```

---

## 3. Entity Attributes
**Namespace:** `xmlns:mdattr="urn:oasis:names:tc:SAML:metadata:attribute"`

This extension allows "Metadata about the Metadata." It essentially allows you to tag an Entity (IdP or SP) with SAML Attributes that encompass the entire organization, rather than a specific user.

### Common Use Cases:
1.  **Entity Categories (Research & Scholarship):** A tag indicating that an IdP is willing to release user attributes (name, email) to any Service Provider that is also tagged as a "Research" facility. This automates attribute release policies.
2.  **Assurance Levels:** Tags indicating how strictly the organization verifies users (e.g., "Silver", "Gold", or "NIST-800-63").
3.  **Support Contact:** Tagging an entity with a support tier.

### XML Example
Here, an entity is tagged with a "Research and Scholarship" category.
```xml
<md:Extensions>
  <mdattr:EntityAttributes>
    <saml:Attribute Name="http://macedir.org/entity-category"
                    NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri">
      <saml:AttributeValue>http://refeds.org/category/research-and-scholarship</saml:AttributeValue>
    </saml:Attribute>
  </mdattr:EntityAttributes>
</md:Extensions>
```

---

## 4. Algorithm Support
**Namespace:** `xmlns:alg="urn:oasis:names:tc:SAML:metadata:algsupport"`

SAML 2.0 is old; it originally defaulted to RSA-SHA1, which is now considered insecure. To move to SHA-256 or better without breaking compatibility with older systems, entities use this extension to advertise which cryptographic algorithms they support.

### Key Functions:
*   **`DigestMethod`**: Lists supported hashing algorithms (e.g., SHA-256, SHA-512).
*   **`SigningMethod`**: Lists supported signing algorithms (e.g., RSA-SHA256).

This allows an Identity Provider to look at an SP's metadata and say, "Oh, they support SHA-256, I will sign the assertion using that instead of the weaker SHA-1."

### XML Example
```xml
<md:Extensions>
  <alg:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
  <alg:SigningMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/>
</md:Extensions>
```

---

### Summary Table

| Extension Type | Namespace Alias | Purpose | Primary Use Case |
| :--- | :--- | :--- | :--- |
| **UI Info** | `mdui` | Polish the "Look & Feel" | Display logos and friendly names on login screens. |
| **Discovery Hints** | `mdui` | Routing Logic | Helping users find their IdP automatically based on IP or Email domain. |
| **Entity Attributes** | `mdattr` | Tagging / Categorization | Automating policy decisions (e.g., "Release email to all Research apps"). |
| **Alg Support** | `alg` | Crypto Agility | Negotiating stronger encryption (SHA-256) instead of defaults. |
