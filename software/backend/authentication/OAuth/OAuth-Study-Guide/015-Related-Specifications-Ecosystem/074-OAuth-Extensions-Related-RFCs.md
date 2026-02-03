Here is a detailed explanation of section **74. OAuth Extensions & Related RFCs**. This section is critical because OAuth 2.0 (RFC 6749) is defined as a **framework**, not a single rigid protocol. This means it was designed to be expanded upon to handle new security threats, new device types, and new interoperability requirements.

Below is the detailed content for this specific module of the study guide.

---

# 74. OAuth Extensions & Related RFCs

## 1. The OAuth "Framework" Concept
When developers learn OAuth, they start with the core document: **RFC 6749**. However, RFC 6749 leaves many implementation details "undefined" or "optional" to allow for flexibility to fit different environments (e.g., IoT, Enterprise, Mobile, Banking).

Because of this, the IETF (Internet Engineering Task Force) has released dozens of supplementary documents over the last decade. These documents are split into **Extensions** (adding new features) and **Related RFCs** (providing clarifications, security patches, or best practices).

## 2. The "Must-Know" RFC Index
In a professional environment, you will rarely use "Plain OAuth 2.0." You will almost always use OAuth 2.0 combined with several extensions to ensure security and functionality.

Here are the most critical RFCs categorised by their function:

### A. Security Extensions (The "Patches")
These extensions fix vulnerabilities found in the original OAuth 2.0 specification.

| RFC Number | Name | Purpose | Importance |
| :--- | :--- | :--- | :--- |
| **RFC 7636** | **PKCE** (Proof Key for Code Exchange) | Prevents authorization code interception attacks. Originally for mobile/public clients, now recommended for *all* clients. | **Critical** |
| **RFC 6819** | **Threat Model** | Analyzing specific threats (token leakage, open redirects) and how to mitigate them. | High |
| **RFC 8252** | **OAuth 2.0 for Native Apps** (AppAuth) | Mandates using the System Browser (not embedded WebViews) for login on mobile devices to prevent credential theft. | **Critical** |
| **RFC 9700** | **Security BCP** (Best Current Practice) | A consolidation of all security advice accumulated over the years. It effectively deprecates the Implicit Grant and ROPC Grant. | **Critical** |

### B. Token Management Extensions
These define how to handle tokens after they are issued.

| RFC Number | Name | Purpose |
| :--- | :--- | :--- |
| **RFC 7009** | **Token Revocation** | Defines a standard endpoint (`/revoke`) for a client to notify the server that a token is no longer needed or was compromised. |
| **RFC 7662** | **Token Introspection** | Defines a standard endpoint (`/introspect`) for Resource Servers to check if an opaque token is currently active and valid. |
| **RFC 9068** | **JWT Profile for Access Tokens** | Standardizes the structure of JWTs when used as OAuth Access Tokens (defines claims like `iss`, `sub`, `client_id`, `scope`). |

### C. New Authorization Flows & Grants
These add support for scenarios not covered in 2012 (when RFC 6749 was published).

| RFC Number | Name | Purpose |
| :--- | :--- | :--- |
| **RFC 8628** | **Device Authorization Grant** | Allows input-constrained devices (Smart TVs, Consoles) to log in by displaying a code the user enters on a phone/laptop. |
| **RFC 7523** | **JWT Bearer Grant** | Allows a client to exchange a generic JWT for an Access Token. Heavily used in Server-to-Server communication. |
| **RFC 8693** | **Token Exchange** | Allows a service to exchange one token for another (e.g., impersonation or delegation in microservices). |

### D. Hardening & High Security
Used in Banking (Open Banking), Healthcare, and Enterprise.

| RFC Number | Name | Purpose |
| :--- | :--- | :--- |
| **RFC 8705** | **Mutual TLS (mTLS)** | Binds the Access Token to the Client's standardized Client Certificate. If the token is stolen, it cannot be used by a thief without the cert. |
| **RFC 9126** | **PAR (Pushed Authorization Requests)** | Instead of sending parameters in the URL (risky), the client POSTs them to the server first. |
| **RFC 9449** | **DPoP (Demonstrating Proof-of-Possession)** | Application-layer binding of tokens to keys (alternative to mTLS). Prevents replay attacks if a token is stolen. |

---

## 3. Experimental vs. Standards Track
When reading RFCs, it is vital to check the **status** of the document at the top of the header.

1.  **Proposed Standard / Internet Standard (Standards Track):**
    *   These are mature, peer-reviewed, and widely adopted.
    *   Examples: RFC 6749 (Core), RFC 7636 (PKCE).
    *   *Guidance:* Safe and recommended for production use.

2.  **Informational:**
    *   These provide general information, guidelines, or historical context but do not define a protocol.
    *   Example: RFC 6819 (Threat Model).

3.  **Experimental:**
    *   These are specifications that are published for testing and research but are not yet standards. They may change or be abandoned.
    *   *Guidance:* Use with caution. Only implement if your specific vendor requires it.

4.  **Internet-Draft (I-D):**
    *   These are works in progress. They "expire" every 6 months.
    *   *Guidance:* Do not build long-term architecture on these unless you are willing to update your code frequently.

---

## 4. Draft Specifications to Watch (The Horizon)
OAuth is still evolving. As a developer, keeping an eye on these drafts helps future-proof applications.

*   **OAuth 2.1:** This is not a "new" protocol but a housekeeping update. It takes the original OAuth 2.0 (RFC 6749) and merges it with the Security BCP, PKCE, and Native App practices into a single document. It removes legacy items (Implicit Grant, Password Grant).
*   **RAR (Rich Authorization Requests - RFC 9396):** Moves beyond simple "Scopes" (strings like `read:email`) to complex JSON objects for authorization (e.g., "Authorize a payment of $50.00 to Account X").
*   **GNAP (Grant Negotiation and Authorization Protocol):** An emerging protocol that isn't OAuth, but a potential successor, focusing on more dynamic client interaction and keys rather than just bearer tokens.

---

## 5. Summary: How to Read the Ecosystem
An effective OAuth developer understands that **RFC 6749 is just the engine**.
*   **RFC 7591/7592** is how you get the keys to the car (Registration).
*   **RFC 7636 (PKCE)** and **RFC 8705 (mTLS)** are the door locks and alarm system (Security).
*   **RFC 7662 (Introspection)** is the ID scanner at the destination (Validation).
*   **RFC 8628 (Device Flow)** provides a remote control (IoT).

Implementing "OAuth" usually means implementing the **Framework + 3 or 4 specific Extensions** relevant to your specific application type.
