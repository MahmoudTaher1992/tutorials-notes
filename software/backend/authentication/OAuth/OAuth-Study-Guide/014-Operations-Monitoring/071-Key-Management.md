Here is a detailed explanation of **Section 71: Key Management** from the Operations & Monitoring part of the OAuth 2.0/2.1 Developer Study Guide.

---

# 71. Key Management

In the context of OAuth 2.0 and OpenID Connect, **Key Management** refers to the lifecycle of the cryptographic keys used to secure tokens (specifically JWTs - JSON Web Tokens).

When an Authorization Server (AS) issues an Access Token or ID Token, it usually **signs** it. This signature allows the Resource Server (RS) or Client to verify that the token came from a trusted source and has not been tampered with. The security of the entire OAuth ecosystem rests on protecting the keys used to create these signatures.

Here is a breakdown of the specific sub-topics involved in Key Management:

### 1. Signing Key Generation
This is the process of creating the cryptographic secrets.

*   **Symmetric vs. Asymmetric Keys:**
    *   **Symmetric (e.g., HMAC-SHA256 / HS256):** The *same* key is used to sign the token and validate it. This is simpler but risky because the Authorization Server must share the secret key with every Resource Server. If one API is compromised, the signing key is compromised, allowing attackers to forge tokens.
    *   **Asymmetric (e.g., RSA-SHA256 / RS256, ECDSA / ES256):** A **Private Key** is used by the Authorization Server to sign the token, and a corresponding **Public Key** is used by Resource Servers to validate it.
    *   **Recommendation:** OAuth 2.1 and modern security standards highly recommend **Asymmetric Keys**. The private key never leaves the Authorization Server, while the public key can be freely distributed.

*   **Algorithm Selection:**
    *   **RS256 (RSA Signature with SHA-256):** The industry standard. Widely supported.
    *   **ES256 (Elliptic Curve Digital Signature Algorithm):** Newer, faster, and uses smaller keys for the same security level, but slightly less library support than RSA.
    *   **EdDSA:** Emerging standard, very fast and secure, but support is still growing.

### 2. Key Rotation Strategies
Cryptographic keys should not live forever. If a private key is accidentally leaked, or if a cryptographic weakness is found in an algorithm, you must change the keys. This process is called **Rotation**.

*   **The "Golden Ticket" Problem:** If an attacker gets your private signing key, they can generate valid tokens for any user, with any scope, forever. Regular rotation mitigates the impact of a potential leak.
*   **Zero-Downtime Rotation (The Dance):** You cannot simply delete the old key and start using a new one, or valid tokens currently in use by users will suddenly fail validation.
    1.  **Generate** a new key pair (Key B).
    2.  **Publish** Key B's public key alongside the old Key A's public key in the JWKS endpoint (see below).
    3.  **Switch** the Authorization Server to start signing *new* tokens with the Private Key B.
    4.  **Retain** Public Key A in the JWKS endpoint for a grace period (e.g., 1 to 24 hours) so that tokens signed with Key A can still be validated until they expire.
    5.  **Remove** Key A entirely after the grace period.

### 3. Key Storage (HSM & KMS)
Where do you keep the Private Key? This is the most critical security question for an Authorization Server.

*   **Bad Practice:** Storing private keys in the application source code (git), in simple text files on the server (file system), or as plain environment variables.
*   **Good Practice (Secrets Managers):** Using tools like HashiCorp Vault or Kubernetes Secrets. This is better than plain text but still exposes the key to the application memory.
*   **Best Practice (HSM / Cloud KMS):** Using a **Hardware Security Module (HSM)** or Cloud Key Management Service (e.g., AWS KMS, Azure Key Vault, Google Cloud KMS).
    *   **How it works:** The private key is generated *inside* the hardware device and **never leaves it**. Even the Authorization Server application does not know the private key.
    *   **Signing:** The application sends the hash of the token to the KMS/HSM, the device signs it internally, and returns the signature.
    *   **Benefit:** Even if hackers get root access to your Authorization Server, they cannot steal the private key.

### 4. JWKS Endpoint Management
The **JSON Web Key Set (JWKS)** is a standard (RFC 7517) for distributing public keys.

*   **The Endpoint:** The Authorization Server exposes a public URL (e.g., `https://auth.example.com/.well-known/jwks.json`).
*   **The Structure:** It returns a JSON object containing an array of public keys. Each key usually contains a `kid` (Key ID).
*   **The `kid` Header:** When an AS signs a token, it puts a `kid` in the JWT header. When the Resource Server receives a token:
    1.  It reads the `kid` from the token header.
    2.  It looks up the corresponding public key with that `kid` in the JWKS.
    3.  It uses that key to validate the signature.
*   **Caching Strategy:** Resource Servers should cache the JWKS response to avoid making an HTTP request to the Auth Server for every single API call. However, they must also handle "cache misses" skillfully (if a token has an unknown `kid`, it might be because the keys were just rotated, so the RS should refresh its cache).

---

### Summary Checklist for Operations
If you are operating an OAuth system, Section 71 requires you to answer these questions:
1.  **Algorithm:** Are we using asymmetric keys (RS256 or ES256)?
2.  **Storage:** Is the private key stored securely (preferably in a KMS/HSM)?
3.  **Rotation:** Do we have an automated process to rotate keys regularly (e.g., every 90 days)?
4.  **Overlap:** Does our rotation process enable the new key while keeping the old public key available to prevent outages?
5.  **Distribution:** Is our JWKS endpoint highly available and properly configured with Cache-Control headers?
