Based on **Item 43** of the Table of Contents, here is a detailed explanation of **XML Signature in SAML**.

---

# 43. XML Signature in SAML

In the context of SAML 2.0, security is paramount because the entire protocol relies on passing identity information over untrusted networks (like the public Internet) via a web browser.

**XML Digital Signature (XMLDSig)** is the mechanism SAML uses to guarantee three things:
1.  **Integrity:** The message has not been tampered with since it was created.
2.  **Authenticity:** The message definitely came from the entity that claims to have sent it (the Identity Provider or Service Provider).
3.  **Non-Repudiation:** The sender cannot deny having sent the message (because it was signed with their private key).

## 1. The Concept: Enveloped Signatures
SAML typically uses **Enveloped Signatures**. This means the digital signature is placed *inside* the XML element that it is signing.

**Visualizing the Structure:**
If an Identity Provider sends a SAML Response, the signature is embedded within that response structure.

```xml
<samlp:Response ID="_123456" ...>
    <Issuer>https://idp.example.com</Issuer>
    
    <!-- THE SIGNATURE BLOCK STARTS HERE -->
    <ds:Signature>
        <ds:SignedInfo>...</ds:SignedInfo>
        <ds:SignatureValue>...</ds:SignatureValue>
    </ds:Signature>
    <!-- THE SIGNATURE BLOCK ENDS HERE -->

    <saml:Assertion>
        <!-- User data flows here -->
    </saml:Assertion>
</samlp:Response>
```

In this example, the `<ds:Signature>` verifies the integrity of the parent `<samlp:Response>`.

## 2. Anatomy of the `<Signature>` Element
The XMLDSig structure is complex. Here are the critical components developer's need to understand:

### A. `<SignedInfo>`
This is the actual data that gets signed. It contains the instructions on *how* to validate the signature. It includes:
*   **Canonicalization Method:** Algorithm used to standardize the XML format (see section 3 below).
*   **Signature Method:** The algorithm used to generate the signature (e.g., RSA-SHA256).
*   **Reference:** A pointer to the element being signed.

### B. `<Reference>` (The "Pointer")
The Reference element is crucial. It tells the verifier: "I am signing the element with the ID `_123456`."
*   **URI Attribute:** Uses a fragment identifiers (e.g., `URI="#_123456"`).
*   **Transforms:** Instructions on how to allow the signature to sit *inside* the document without breaking the hash (usually "Enveloped Signature Transform").
*   **DigestMethod:** The hashing algorithm (e.g., SHA-256).
*   **DigestValue:** The actual hash of the target element.

### C. `<SignatureValue>`
This is the cryptographic result. It is the `<SignedInfo>` element hashed and then encrypted using the sender's **Private Key**.

### D. `<KeyInfo>` (Optional but common)
This element may contain the X.509 Certificate (Public Key) so the receiver can verify the signature immediately. *Note: For high security, many implementations ignore this and use a pre-stored certificate to avoid trusting a key sent by a hacker.*

## 3. Canonicalization (C14N)
XML is flexible. You can add whitespace, change attribute order, or change namespace prefixes without changing the logical meaning of the XML.
*   **The Problem:** Cryptographic hashing is byte-sensitive. A single extra space changes the entire hash.
*   **The Solution:** Canonicalization (C14N).

Before signing (and before verifying), the XML parser runs a C14N algorithm. It conceptually "normalizes" the XML (removes whitespace, sorts attributes alphabetically, fixes namespaces) so that the hash is consistent regardless of formatting.
*   **Common Algorithm:** `Exclusive XML Canonicalization` (`http://www.w3.org/2001/10/xml-exc-c14n#`).

## 4. Signing & Digest Algorithms
SAML security depends heavily on the strength of the algorithms used.

### Digest Algorithms (The Fingerprint)
This creates a hash of the content.
*   **SHA-1:** *Deprecated/Insecure.* Do not use.
*   **SHA-256:** The current industry standard.
*   **SHA-384 / SHA-512:** High security.

### Signing Algorithms (The Lock)
This encrypts the hash using the Private Key.
*   **RSA-SHA256:** The most common standard. Uses an RSA key pair.
*   **ECDSA (Elliptic Curve):** Newer, faster, and uses smaller keys for the same security level, but older SAML stacks might not support it.

## 5. What to Sign: The Scope
In a SAML exchange, you can sign different parts of the message. This often causes configuration errors.

### A. Signing the Response (`<Response>`)
The IdP signs the outer envelope.
*   **Pros:** Verifies the transmission as a whole.
*   **Cons:** If the inner Assertion is extracted and moved to another XML document, it is no longer signed.

### B. Signing the Assertion (`<Assertion>`)
The IdP signs the specific user identity data *inside* the response.
*   **Pros:** The Assertion remains secure even if extracted from the Response. This is critical for "Bearer" tokens.
*   **Cons:** Slightly more processing overhead.

### C. Message Signing (Sign Everything)
Many IdPs sign **both** the Response and the Assertion to ensure maximum security.

## 6. How Verification Works (The SP's Job)
When a Service Provider (SP) receives a signed SAML message, it performs these steps:

1.  **Locate the Signature:** Find the `<ds:Signature>` block.
2.  **Determine Target:** Look at `<Reference URI="#ID">` to see what was signed.
3.  **Canonicalize:** Apply C14N to the target XML element.
4.  **Calculate Hash:** Hash the canonicalized XML using the algorithm specified in `<DigestMethod>`.
5.  **Compare Hash:** Ensure the calculated hash matches the value in `<DigestValue>`. (This proves **Integrity**).
6.  **Verify Signature:** Use the IdP's Public Key to decrypt the `<SignatureValue>` and compare it against the `<SignedInfo>`. (This proves **Authenticity**).

If any step fails, the SAML Login is rejected immediately.
