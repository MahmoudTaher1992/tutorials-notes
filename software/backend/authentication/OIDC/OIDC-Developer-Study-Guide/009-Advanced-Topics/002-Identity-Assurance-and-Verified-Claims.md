This section of the study guide moves beyond simple methods of logging in (Authentication) and enters the realm of **Identity Verification**.

In standard OpenID Connect (OIDC), when a user registers and types their name as "Batman," the ID Token sends that name to your app. However, a bank or government agency cannot rely on that. They need to know the user is *legally* who they say they are.

Here is a detailed explanation of **Topic 32: Identity Assurance & Verified Claims**.

---

### 1. The Problem: "Self-Asserted" vs. "Verified" Data
In standard OIDC, claims like `name`, `birthdate`, and `address` are often **Self-Asserted**. This means the user typed them in, and there is no guarantee they are true.

**Identity Assurance** is the process of binding a digital account to a real-world legal identity with a specific level of confidence (Assurance Level).

*   **Standard OIDC:** "The user logged in with password `12345` and claims their name is John Doe."
*   **Identity Assurance:** "The user logged in, and we checked their Physical Passport and Driver’s License to prove they are definitely John Doe."

---

### 2. eKYC (Electronic Know Your Customer)
**eKYC** is the digital version of the "Know Your Customer" process used by banks and financial institutions.

*   **Context:** If you build a Fintech app, you cannot open a bank account for a user just because they have a Google account. You are legally required to verify their identity to prevent money laundering (AML).
*   **The OIDC Solution:** The **OpenID Connect for Identity Assurance** specification extends OIDC to perform eKYC. It allows the Identity Provider (OP) to tell the Relying Party (RP):
    1.  *Who* the user is.
    2.  *How* their identity was verified.
    3.  *When* it was verified.
    4.  *What* documents were used (e.g., Passport, ID Card).

---

### 3. Verified Claims Structure
How does this actually look in the code? The specification introduces a new claim object called `verified_claims`.

Instead of the user's data sitting at the top level of the JSON payload, verified data is wrapped inside this objects.

#### The JSON Structure
A typical `verified_claims` object has two main parts:
1.  **Verification:** Metadata about *how* the checking was done.
2.  **Claims:** The actual user data that was checked.

**Example ID Token / UserInfo Response:**
```json
{
  "sub": "user_12345",
  "email": "john@example.com", 
  
  // This is the new part
  "verified_claims": {
    "verification": {
      "trust_framework": "nist_800_63_3",
      "identity_assurance_level": "ial2",
      "time": "2023-10-25T14:30:00Z",
      "evidence": [
        {
          "type": "document",
          "method": "pipp",
          "document_details": {
            "type": "passport",
            "issuer": { "name": "USA", "country": "US" },
            "document_number": "A1234567"
          }
        }
      ]
    },
    "claims": {
      "given_name": "John",
      "family_name": "Doe",
      "birthdate": "1980-01-01"
    }
  }
}
```

#### Breakdown of Fields:
*   **`trust_framework`**: The set of rules followed (explained below).
*   **`identity_assurance_level` (IAL)**: A score indicating how strict the check was (e.g., `low`, `substantial`, `high`, or NIST levels like `ial2`).
*   **`evidence`**: Proof used. In the example above, the user showed a US Passport.
*   **`claims`**: The specific data points (Name, Birthdate) that match that passport.

---

### 4. Trust Frameworks
A **Trust Framework** is a legal or regulatory "Rule Book." It defines the standards for identity verification. Since different countries and industries have different laws, the OIDC token must specify *which* rule book was followed.

Common Trust Frameworks you might see in `verified_claims`:

*   **NIST 800-63 (USA):** Used by US federal agencies. (Levels: IAL1, IAL2, IAL3).
*   **eIDAS (Europe):** The EU standard for electronic identification. (Levels: Low, Substantial, High).
*   **AML/CTF:** Anti-Money Laundering and Counter-Terrorism Financing regulations (Banking).

**Why this matters:**
If you are building a medical app, you might be legally required to only accept tokens where `trust_framework` is `nist_800_63_3` and `identity_assurance_level` is `ial2` or higher.

---

### 5. Summary of the Flow
1.  **Request:** Your App (RP) asks the Identity Provider (OP) for verification.
    *   *Request:* "I need a user to log in, and I need you to verify their Passport."
2.  **Verification:** The OP (or a partner service) asks the user to scan their face and upload a photo of their ID.
3.  **Process:** The OP validates the ID (checks holograms, checks government databases).
4.  **Response:** The OP issues an ID Token containing the `verified_claims` object, confirming the user's legal identity.

### Key Takeaway for Developers
When working with **Identity Assurance**, you are no longer just asking "Does this user control this email address?" You are asking "Has this user legally proven they are this real-world person?"

You must write your code to look specifically inside the `verified_claims` object for sensitive data, rather than relying on top-level profile claims which might be unverified.
