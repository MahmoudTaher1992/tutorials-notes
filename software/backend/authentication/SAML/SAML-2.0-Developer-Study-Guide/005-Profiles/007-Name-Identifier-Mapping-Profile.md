Based on **Part 5: Profiles** of your Table of Contents, here is a detailed explanation of section **32. Name Identifier Mapping Profile**.

---

# 32. Name Identifier Mapping Profile

### What is it?
The **Name Identifier Mapping Profile** is a SAML 2.0 protocol interaction that allows a Service Provider (SP) (or another entity) to query an Identity Provider (IdP) to find out what a logged-in user's specific **NameID** would be in a diferent format or for a different Service Provider.

In simple terms, it is a mechanism for **Translating Identities**.

**Analogy:**
> Imagine you (the IdP) have a friend named "Robert."
> *   His banking app (SP1) knows him as `cust_882`.
> *   His email app (SP2) knows him as `bob@example.com`.
>
> The Name Identifier Mapping Profile allows the Banking App to request the IdP: *"I have a user logged in as `cust_882`. Can you tell me what his specific identifier is for the Email App?"*

---

### The Problem It Solves
In a **Federated Identity** environment, an IdP often sends different NameIDs to different SPs for the same user to maintain privacy or adhere to legacy database requirements.

*   **SP "A"** might receive a **Transient** ID (temporary).
*   **SP "B"** might receive a **Persistent** ID (permanent opaque string).
*   **SP "C"** might receive an **Email Address**.

If **SP "A"** needs to communicate directly with **SP "B"** regarding that user (for example, to call an API hosted by SP B), SP "A" needs to know what the user is called inside SP "B". SP "A" cannot simply guess this ID; it must ask the IdP to perform the mapping.

### How It Works (The Flow)

This profile is almost exclusively executed over a synchronous back-channel binding (like **SOAP over HTTP**), as it is a server-to-server communication, not a browser redirection flow.

#### 1. The Pre-requisites
*   The Principal (User) has already authenticated with the IdP.
*   The Requesting SP has an existing session with the Identifier (e.g., `id_123`).

#### 2. The Request (`NameIDMappingRequest`)
The Requesting SP sends a SOAP message to the IdP containing:
*   **The User's Current ID:** The NameID that the Requesting SP knows the user by.
*   **NameIDPolicy:** This specifies the requested **Format** (e.g., `urn:oasis:names:tc:SAML:2.0:nameid-format:persistent`) or the **SPNameQualifier** (the Entity ID of the *Target* SP).

#### 3. IdP Processing
The IdP verifies the request, checks privacy policies (to ensure SP "A" is allowed to know the user's ID for SP "B"), maps the identity in its database, and generates the new NameID.

#### 4. The Response (`NameIDMappingResponse`)
The IdP sends back a SOAP message containing:
*   **The New NameID:** The identifier corresponding to the requested format or target SP.

---

### Integration Architecture Diagram

```text
[   User   ]
     |
     | (1. User logs in)
     v
[ Service  ]  <---- (2. Request: Who is this user for SP B?) ----- [ Identity ]
[ Provider ]                                                       [ Provider ]
[    A     ]  ---- (3. Response: That user is "X-99" for SP B) --> [          ]
     |
     | (4. API Call using ID "X-99")
     v
[ Service  ]
[ Provider ]
[    B     ]
```

### Key XML Structure

#### The Request
```xml
<samlp:NameIDMappingRequest xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" ...>
    <!-- The ID SP-A currently has -->
    <saml:NameID>
        bobs_id_at_sp_a
    </saml:NameID>
    
    <!-- The Policy requesting the new ID for SP-B -->
    <samlp:NameIDPolicy Format="urn:oasis:names:tc:SAML:2.0:nameid-format:persistent"
                        SPNameQualifier="https://sp-b.example.com/metadata"
                        AllowCreate="true"/>
</samlp:NameIDMappingRequest>
```

#### The Response
```xml
<samlp:NameIDMappingResponse ...>
    <samlp:Status>
        <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
    </samlp:Status>
    <!-- The ID SP-B will recognize -->
    <saml:NameID Format="urn:oasis:names:tc:SAML:2.0:nameid-format:persistent"
                 SPNameQualifier="https://sp-b.example.com/metadata">
        bobs_id_at_sp_b
    </saml:NameID>
</samlp:NameIDMappingResponse>
```

### Use Cases

1.  **Identity Translation for Backend APIs:**
    An Enterprise Portal (SP) lets users log in. The Portal needs to fetch user-specific data from a separate HR system (another SP) and a Payroll system (another SP). The Portal uses the Mapping Profile to get the specific "HR ID" and "Payroll ID" for that user from the central IdP to make those API calls.

2.  **legacy Migration:**
    An organization is moving from `emailAddress` based identifiers to `persistent` (opaque) identifiers for better security. An SP can use this profile to query the IdP: "Here is the email address ID I have; give me the new Persistent ID for this user so I can update my database."

### Security & Privacy Considerations

*   **Privacy Leaks:** This profile essentially allows one service to "unmask" a user's identity on another service. This is often disabled by default in strict privacy configurations (like public sector or GDPR-compliant setups).
*   **Authorization:** The IdP must strictly enforce policies. Not every SP should be allowed to request a map for every other SP.
*   **Encryption:** Because NameIDs can be sensitive (like Social Security Numbers or emails), the `<NameID>` element in the response is often encrypted.

### Summary Comparison
| Feature | **NameID Mapping Profile** (Category 32) | **NameID Management Profile** (Category 33) |
| :--- | :--- | :--- |
| **Goal** | **Get** a different alias for the user. | **Change/Delete** an alias for the user. |
| **Action** | Translation / Lookup. | Update / Termination. |
| **Example** | "Tell me Bob's ID for Salesforce." | "Bob has a new email; update his ID." |
