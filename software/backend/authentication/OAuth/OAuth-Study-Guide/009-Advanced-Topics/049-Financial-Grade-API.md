Here is a detailed explanation of **Section 49: Financial-Grade API (FAPI)**.

---

# 49. Financial-Grade API (FAPI)

### **What is FAPI?**
**FAPI** stands for **Financial-grade API**. It is a set of technical specifications (profiles) developed by the **OpenID Foundation**.

While OAuth 2.0 acts as a framework offering many different ways to do things (some secure, some convenient), FAPI is a strict **"Hardened Security Mode"** for OAuth 2.0 and OpenID Connect (OIDC).

**The Analogy:**
If standard OAuth 2.0 is a generic building code that allows you to build anything from a garden shed to a bank vault, **FAPI** is the specific blueprint designed strictly for building the bank vault. It removes dangerous options and mandates the highest security features.

---

### **1. Why do we need FAPI? (The Problem)**
Standard OAuth 2.0 has flexibility that creates risk in high-stakes environments:
*   **Bearer Tokens:** If stolen, anyone can use them.
*   **Plaintext Requests:** Identity data can be intercepted or tampered with.
*   **Looser Validation:** Allows for some redirect URI matching flexibility.

In banking (and healthcare), losing data means losing money or violating strict regulations (like PSD2 in Europe). FAPI was created to ensure that APIs exchanging high-value data are resistant to sophisticated attacks.

---

### **2. FAPI Versions & Profiles**

The specification has evolved from version 1.0 to 2.0.

#### **A. FAPI 1.0 (Current Standard)**
This version defines two levels of security depending on the risk of the API.

1.  **FAPI 1.0 Baseline (Read-Only):**
    *   Designed for APIs that only **read** data (e.g., fetching a transaction history).
    *   **Security Level:** Moderate. Comparable to best-practice OIDC.
    *   **Key Rules:**
        *   Must use HTTPS everywhere.
        *   Implicit Grant is forbidden.
        *   PKCE (Proof Key for Code Exchange) is mandatory.
        *   Redirect URIs must look like `https://` (no custom schemes unless strict requirements are met).

2.  **FAPI 1.0 Advanced (Read-Write - The Real "Financial Grade"):**
    *   Designed for APIs that **write** data (e.g., initiating a money transfer) or expose sensitive PII.
    *   **Security Level:** Very High.
    *   **Key Rules (additions to Baseline):**
        *   **mTLS (Mutual TLS):** Client applications must authenticate using certificates, not just secrets.
        *   **Sender-Constrained Tokens:** Access tokens are bound to the client's certificate. If a hacker steals the token but doesn't have the client's private SSL certificate, the token is useless.
        *   **JARM (JWT Secured Authorization Response Mode):** Responses from the server are signed JWTs, preventing tampering.
        *   **Encryption:** ID Tokens must be encrypted.

#### **B. FAPI 2.0 (The Future)**
FAPI 2.0 aims to make the "Advanced" profile simpler to implement while maintaining high security.
*   It drops the distinction between "Baseline" and "Advanced."
*   It focuses heavily on the **Attacker Model** (mathematically proving security against specific threats).
*   It incorporates newer standards like **DPoP** (Demonstrating Proof-of-Possession) as an alternative to the complex mTLS requirements.
*   It mandates **PAR (Pushed Authorization Requests)** to prevent frontend manipulation of request parameters.

---

### **3. Key Technical Requirements**
If you are building a FAPI-compliant application, your OAuth flow changes in specific ways:

#### **Strict Client Authentication**
You cannot use `client_secret_post` or `client_secret_basic`. You must use:
*   **`private_key_jwt`:** The client signs a JWT with a private key to prove its identity.
*   **`tls_client_auth`:** The client presents a mutual TLS certificate during the handshake.

#### **Request Objects (JAR)**
Developers cannot send authorization parameters (like `scope`, `redirect_uri`, `amount`) as simple query strings in the URL.
*   You must use a **Signed Request Object (JWT)**.
*   This ensures that the user's browser cannot tamper with the transaction details (e.g., changing the payment amount from $10 to $1000) before the server sees it.

#### **Sender-Constrained Access Tokens**
This is the hallmark of FAPI.
*   **Standard OAuth:** Returns a Bearer token.
*   **FAPI:** Returns a token bound to the TLS connection (MTLS) or a specific private key (DPoP).

#### **Grant Types**
*   **Explicitly Allowed:** Authorization Code Grant (with PKCE and OIDC).
*   **Explicitly Banned:** Implicit Grant, Password Grant.

---

### **4. Use Cases**

Although named "Financial," FAPI is used anywhere high security is required:

1.  **Open Banking (PSD2, UK Open Banking, Brazil Open Banking):**
    *   Banks must allow third-party apps (like budgeting apps) to access user bank accounts.
    *   Since this involves real money, FAPI is the mandatory standard for these APIs globally.

2.  **Open Insurance & Health:**
    *   Sharing medical records or insurance policies between providers requires the same level of security as banking.

3.  **eGovernment / Digital Identity:**
    *   Government IDs that allow citizens to sign legal documents often use FAPI profiles to ensure the identity assertion wasn't tampered with.

---

### **Summary Table: OAuth 2.0 vs. FAPI**

| Feature | Standard OAuth 2.0 | FAPI (Financial Grade) |
| :--- | :--- | :--- |
| **Philosophy** | Flexible Framework | Constrained, Secure Profile |
| **Token Type** | Bearer (usually) | Sender-Constrained (MTLS/DPoP) |
| **Request Parameters** | URL Query Strings | Signed JWTs (JAR) or Pushed (PAR) |
| **Client Auth** | Secrets allowed | Private Key or mTLS required |
| **Redirect URI** | Partial match allowed (sometimes) | Exact match required |
| **Primary Use** | Social Login, Generic APIs | Banking, Health, Critical Data |

In short, FAPI is the industry standard for **high-assurance API security**. If you are building an app that touches money or sensitive personal data, you should be looking at FAPI guidelines.
