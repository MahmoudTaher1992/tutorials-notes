Based on the Table of Contents you provided, here is the detailed explanation for **Section 38: SP Metadata Elements**.

This section focuses on the XML elements specific to a **Service Provider (SP)** within a SAML Metadata file. These elements tell an Identity Provider (IdP) how to communicate with the application, where to send users after login, and what cryptographic security measures are required.

---

# 006-Metadata/004-SP-Metadata-Elements.md

## Detailed Explanation: SP Metadata Elements

In SAML metadata, the root element `EntityDescriptor` describes an entity. If that entity is a Service Provider (an application), it must contain an `<SPSSODescriptor>` element. This element acts as the container for all SP-specific configurations.

Below is a breakdown of the specific child elements found within an SP's metadata.

### 1. `SPSSODescriptor`
This is the parent container. It defines the entity's role as a Service Provider.
*   **Key Attribute:** `protocolSupportEnumeration`. This is mandatory. It tells the IdP which SAML versions the SP supports.
*   **Example Value:** `urn:oasis:names:tc:SAML:2.0:protocol` (Indicates strictly SAML 2.0).
*   **Flags:** This element also houses the `AuthnRequestsSigned` and `WantAssertionsSigned` attributes (explained below).

### 2. `AssertionConsumerService` (ACS)
This is arguably the most critical element in SP metadata.
*   **Purpose:** It defines the endpoint (URL) where the IdP should send the SAML Response (containing the user's login assertion) after successful authentication.
*   **Binding:** Specifies *how* the data should be sent. The most common is `HTTP-POST`, meaning the IdP will post a form containing the assertion to this URL.
*   **Index:** An SP can have multiple ACS URLs (e.g., for different environments or bindings). The `index` identifies them, and `isDefault="true"` specifies which one to use if the request doesn't specify one.

### 3. `SingleLogoutService` (SLO)
*   **Purpose:** Defines the endpoint where the IdP should send a Logout Request or Response. This allows for valid Single Sign-Out (where logging out of one app logs you out of the IdP).
*   **Binding:** Usually `HTTP-Redirect` (for the request) or `HTTP-POST`.
*   **Location:** The URL the IdP sends the user to when logging out.

### 4. `NameIDFormat`
*   **Purpose:** Specifies the format of the username (Subject) that the SP expects to receive.
*   **Why it matters:** If an SP requires an email address to match a user account, but the IdP sends a random hash (Persistent ID), the login will fail. This element explicitly tells the IdP what format to send.
*   **Common Values:**
    *   `urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress`
    *   `urn:oasis:names:tc:SAML:2.0:nameid-format:transient` (Temporary, anonymous ID)
    *   `urn:oasis:names:tc:SAML:2.0:nameid-format:persistent` (Permanent, opaque ID)

### 5. `AuthnRequestsSigned` (Attribute of SPSSODescriptor)
*   **Type:** Boolean (`true` or `false`).
*   **Purpose:** Indicates whether the SP will **always** sign the Authentication Requests (`AuthnRequest`) it sends to the IdP.
*   **Implication:** If set to `true`, the IdP is instructed to validate the signature on every login request coming from this SP using the SP's public key (found in the `KeyDescriptor`). If the signature is missing or invalid, the IdP will reject the login.

### 6. `WantAssertionsSigned` (Attribute of SPSSODescriptor)
*   **Type:** Boolean (`true` or `false`).
*   **Purpose:** Indicates that the SP prefers (or requires) that the specific **Assertion** element inside the XML Response be signed by the IdP.
*   **Note:** The SAML Response acts as an envelope. The Envelope can be signed, and the Assertion (the letter inside) can be signed. This flag specifically requests the internal Assertion be signed.

### 7. `AttributeConsumingService`
This acts as a grouping container for the attributes the SP requires. It allows the SP to list requirements for the IdP administrator to see.
*   **ServiceName:** A human-readable name for the service (e.g., "HR Portal").
*   **Purpose:** It helps the IdP decide which attributes (like First Name, Email, Role) to release to this specific SP.

### 8. `RequestedAttribute`
Located inside the `AttributeConsumingService`, this element lists a specific piece of data the SP needs.
*   **Name:** The official name of the attribute (e.g., `urn:oid:2.5.4.42` or `givenName`).
*   **FriendlyName:** A human-readable label (e.g., "First Name").
*   **isRequired:** A boolean (`true` or `false`).
    *   `true`: The application likely cannot function without this data (e.g., email address).
    *   `false`: The data is useful but optional (e.g., office phone number).

---

## XML Example: SP Metadata

Here is how these elements look in a real Metadata file:

```xml
<md:EntityDescriptor entityID="https://sp.example.com/metadata" xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata">
    
    <!-- SPSSODescriptor Container -->
    <!-- Note the security flags AuthnRequestsSigned and WantAssertionsSigned -->
    <md:SPSSODescriptor 
        protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol"
        AuthnRequestsSigned="true"
        WantAssertionsSigned="true">

        <!-- 39. KeyDescriptor would go here (Public Key for signing) -->

        <!-- 3. SingleLogoutService -->
        <md:SingleLogoutService 
            Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"
            Location="https://sp.example.com/logout" />

        <!-- 4. NameIDFormat -->
        <md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress</md:NameIDFormat>

        <!-- 2. AssertionConsumerService (Where the token is sent) -->
        <md:AssertionConsumerService 
            Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
            Location="https://sp.example.com/acs"
            index="1"
            isDefault="true" />

        <!-- 7. AttributeConsumingService -->
        <md:AttributeConsumingService index="1">
            <md:ServiceName xml:lang="en">Example Service Provider</md:ServiceName>
            
            <!-- 8. RequestedAttribute -->
            <md:RequestedAttribute 
                Name="uid" 
                NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic"
                FriendlyName="User ID"
                isRequired="true" />
                
            <md:RequestedAttribute 
                Name="email" 
                FriendlyName="Email Address"
                isRequired="true" />
        </md:AttributeConsumingService>

    </md:SPSSODescriptor>
</md:EntityDescriptor>
```

## Summary of Usage

| Element | Who uses it? | Why? |
| :--- | :--- | :--- |
| **SPSSODescriptor** | IdP | To recognize that this entity is an application (SP). |
| **AssertionConsumerService** | IdP | The IdP redirects the browser here after login. |
| **SingleLogoutService** | IdP | The IdP redirects the browser here during logout. |
| **NameIDFormat** | IdP | Tells the IdP what format (Email, Persistent ID) to put in the `<Subject>`. |
| **AuthnRequestsSigned** | IdP | Tells the IdP to reject unsigned login requests from this SP. |
| **WantAssertionsSigned** | IdP | Tells the IdP to sign the Assertion payload. |
| **AttributeConsumingService** | IdP Admin | Used for policy configuration (which user data to allow). |
