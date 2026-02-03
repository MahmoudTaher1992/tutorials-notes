This section of the study guide focuses on the critical architectural decision of **how a Client Application proves its identity to the Authorization Server**. This is distinct from user authentication; this is about the application saying, *"I am the App you assigned Client ID X to, and here is proof."*

Here is a detailed explanation of simple to advanced methods, comparing their security, complexity, and best use cases.

---

# 027 - Choosing Authentication Methods

When registering an OAuth 2.0 client, you must decide how that client interacts with the Token Endpoint. This decision relies on the "Client Profile" (where the code runs) and the security requirements of the data being accessed.

## 1. The Menu of Options (Recap)

Before choosing, recall the available standard methods defined in OAuth 2.0 and OpenID Connect:

1.  **`none`**: No authentication.
2.  **`client_secret_basic`**: Client ID/Secret sent in an HTTP Basic Auth Header.
3.  **`client_secret_post`**: Client ID/Secret sent in the HTTP Request Body.
4.  **`client_secret_jwt`**: A JWT signed with the Client Secret (HMAC).
5.  **`private_key_jwt`**: A JWT signed with a Private Key (RSA/EC).
6.  **`tls_client_auth` (mTLS)**: Authentication via X.509 Certificates at the transport layer.

---

## 2. Security Comparison

This is the primary driver for choosing a method. As security increases, the risk of credential theft or replay attacks decreases.

| Method | Strength | Vulnerability Profile |
| :--- | :--- | :--- |
| **`none`** | **Zero** | Relies entirely on other mechanisms (Redirect URI matching, PKCE). Vulnerable to impersonation if the redirect URI is not strict. |
| **`client_secret_post`** | **Low** | The secret is sent in the body. If logs capture body parameters, the secret leaks. Vulnerable to interception if TLS terminates early. |
| **`client_secret_basic`** | **Medium** | Better than `post` because headers are rarely logged. However, it still sends the "password" (secret) over the wire on every request. |
| **`client_secret_jwt`** | **High** | The secret itself is never sent over the wire. It is used to sign a JWT. Prevents "sniffing" the secret, but effectively acts like a shared key system. |
| **`private_key_jwt`** | **Very High** | Uses Asymmetric keys. The Authorization Server holds the Public Key; the Client holds the Private Key. Even if the AS database is hacked, the attacker cannot impersonate the client because they don't have the Private Key. |
| **mTLS (`tls_client_auth`)** | **Maximum** | Authentication happens at the TCP/TLS handshake layer. It is extremely resistant to application-layer attacks and replay attacks. |

---

## 3. Implementation Complexity

Security usually comes at the cost of complexity.

*   **Low Complexity (`basic`, `post`):**
    *   **Dev Effort:** Near zero. Most HTTP libraries support Basic Auth natively.
    *   **Ops Effort:** Simple. Just store a string in an environment variable.
*   **Medium Complexity (`client_secret_jwt`):**
    *   **Dev Effort:** Requires a library to generate and sign JWTs using HMAC.
    *   **Ops Effort:** Still managing a shared secret string.
*   **High Complexity (`private_key_jwt`):**
    *   **Dev Effort:** Requires generating a JWT, signing it with a PEM file (RSA/EC), and handling assertions.
    *   **Ops Effort:** Key management lifecycle. You must generate key pairs, rotate them safely, and publish the Public Key (usually via JWKS).
*   **Very High Complexity (mTLS):**
    *   **Dev Effort:** Application must handle certificates alongside HTTP requests.
    *   **Ops Effort:** Requires a Public Key Infrastructure (PKI). You have to issue certificates, handle expirations, and configure Load Balancers/API Gateways to pass client certificates through to the application.

---

## 4. Platform Considerations

Where the code runs is the hard constraint that eliminates certain options immediately.

### A. Public Clients (SPAs, Mobile Apps, Desktop Apps)
*   **Constraint:** These apps run on user devices. They cannot keep a secret safe. If you compile a "Client Secret" into a React app or an iPhone app, a hacker can extract it in minutes.
*   **The Choice:** You **MUST** use `none`.
*   **The Mitigation:** You secure these clients using **PKCE** (Proof Key for Code Exchange) and strict Redirect URI matching, rather than a password.

### B. Confidential Clients (Server-Side Web Apps)
*   **Context:** Traditional database-driven websites (Java, .NET, Node.js, PHP).
*   **The Choice:**
    *   **Standard:** `client_secret_basic` is the industry standard for general use.
    *   **Enhanced:** If accessing PII (Personally Identifiable Information), consider `private_key_jwt`.

### C. Financial / High Security (Open Banking, Health)
*   **Context:** Machine-to-Machine communication between banks or medical systems.
*   **The Choice:** `private_key_jwt` or `tls_client_auth` (mTLS).
*   **Reason:** Regulatory compliance (like FAPI - Financial-grade API) often mandates non-repudiation. A shared secret (password) implies either party could have generated the token request; a Private Key proves exactly who sent it.

---

## 5. Decision Matrix (Summary)

Use this logic flow to choose your method:

1.  **Can the client keep a secret?**
    *   **No (SPA/Mobile):** Use **`none`** (with PKCE).
    *   **Yes (Backend):** Go to step 2.

2.  **Is the data extremely sensitive (Money, Health, Gov ID)?**
    *   **Yes:** Go to step 3.
    *   **No (User profile, benign data):** Use **`client_secret_basic`**.

3.  **Do you have an existing PKI (Certificate) Infrastructure?**
    *   **Yes:** Use **`tls_client_auth`** (mTLS).
    *   **No:** Use **`private_key_jwt`**.

---

## 6. Best Practices

Regardless of the method chosen, follow these operational rules:

1.  **Avoid `client_secret_post`:** Including secrets in the body is dangerous because server access logs often record the HTTP Body (or part of it) to debug errors. Logs almost never record the `Authorization` header.
2.  **Rotate Secrets/Keys:**
    *   If using Secrets: Change them periodically.
    *   If using Keys: Use the standard rotation mechanism (Old Key valid for verifying, New Key used for signing) to avoid downtime.
3.  **Use JWKS URI for Keys:** When using `private_key_jwt`, do not upload static public keys to the Authorization Server. Instead, host a `jwks.json` endpoint so the Authorization Server can fetch your latest public keys automatically.
4.  **Enforce Key Exactness:** If using mTLS, ensure the Authorization Server validates the specific Subject Distinguished Name (DN) or SAN of the certificate, not just that "a valid certificate exists."
