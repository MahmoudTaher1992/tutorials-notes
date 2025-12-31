Based on the Table of Contents you provided, here is a detailed explanation of **Part X: Security & Multi-Tenancy**, specifically section **A. Access Control**.

By default, Jaeger is often deployed in a "trusting" mode (especially in the "All-in-One" distribution), meaning it has no authentication or encryption enabled. This is fine for a laptop, but dangerous in production. This section details how to lock down the system.

---

# Detailed Explanation: Access Control in Jaeger

This section covers the two main fronts of security: **Human-to-Software** (Securing the UI) and **Software-to-Software** (Securing the backend data pipes).

## 1. Securing the UI (OAuth / OIDC Integration)

The Jaeger UI allows engineers to view distributed traces. These traces often contain sensitive data (database queries, user IDs, internal API headers). Therefore, you cannot leave the UI open to the public internet or even to the entire internal network.

Since Jaeger does not have its own internal database of users and passwords, it delegates authentication to an **Identity Provider (IdP)**.

### How it works:
*   **Protocol:** Jaeger uses **OIDC (OpenID Connect)**, which sits on top of OAuth 2.0.
*   **The Flow:** When a user tries to access the Jaeger UI:
    1.  Jaeger checks if the user has a valid session token.
    2.  If not, it redirects the browser to an IdP (e.g., Keycloak, Okta, Google Auth, Azure AD).
    3.  The user logs in at the IdP.
    4.  The IdP redirects the user back to Jaeger with an ID Token (JWT).
    5.  Jaeger validates the token and grants access.

### Implementation Methods:
There are two common ways to achieve this in a Jaeger deployment:

1.  **Native Support (Jaeger Query Flags):**
    The `jaeger-query` service (which serves the UI) has built-in CLI flags to configure OIDC. You provide the Issuer URL, Client ID, and Client Secret directly to the Jaeger binary.
    *   *Example flags:* `--query.oauthtoken-url`, `--query.oidc-issuer-url`.

2.  **Reverse Proxy / Sidecar (The "Sidecar Pattern"):**
    This is often preferred in Kubernetes. You place a security proxy (like **OAuth2-Proxy** or an **Nginx** ingress with auth modules) *in front* of the Jaeger UI.
    *   The Proxy handles the login flow with Google/Okta.
    *   If successful, the Proxy passes the request to the Jaeger UI.
    *   Jaeger assumes any request reaching it is already authenticated.

---

## 2. Securing the Collector & Query APIs (TLS & mTLS)

While the UI is for humans, the **Collector** and **Query** APIs are used by software (agents, clients, and forwarded data).

*   **The Risk:** If these APIs are HTTP (plaintext), an attacker on the network can sniff the traffic (Man-in-the-Middle) to read trace data. Or, an attacker could flood the Collector with fake spans (DoS attack).
*   **The Solution:** TLS (Transport Layer Security) and mTLS (Mutual TLS).

### A. TLS (Encryption in Transit)
This ensures that data moving from your Application (or Jaeger Agent) to the Jaeger Collector cannot be read by anyone listening on the network.
*   **Server-Side TLS:** You configure the **Jaeger Collector** with a Certificate (`server.crt`) and a Key (`server.key`).
*   **Client Behavior:** The Jaeger Client/Agent verifies that the Collector is legitimate using a Certificate Authority (CA).

### B. mTLS (Mutual Authentication)
Standard TLS only proves the Server's identity to the Client. **mTLS** proves the Client's identity to the Server as well. This effectively acts as "Login credentials" for your microservices.

*   **How it works:**
    1.  The Jaeger Collector is configured with a **Client CA Pool** (a list of trusted authorities).
    2.  The Client (your microservice or the Jaeger Agent) must present its own certificate (`client.crt`) when opening a connection.
    3.  If the client does not have a certificate signed by the trusted CA, the Collector **rejects the connection**.
*   **Why use it?** It prevents unauthorized rogue scripts or compromised containers from sending garbage data to your tracing backend.

### C. gRPC vs. HTTP
Jaeger components communicate primarily via **gRPC**.
*   Securing gRPC requires specific flags (e.g., `--collector.grpc.tls.enabled=true`, `--collector.grpc.tls.cert=...`).
*   If you are using the older HTTP endpoints (Thrift), you must configure the HTTP server TLS flags separately.

---

### Summary of this Section
If you were implementing this section in a real environment, your checklist would look like this:

1.  **Frontend:** Register Jaeger as an application in your company's Okta/Keycloak. Configure `jaeger-query` with the OIDC Client Secret.
2.  **Backend:** Generate internal certificates (using cert-manager or OpenSSL). Mount these certificates into the Jaeger Collector containers and enable the `--tls` flags. Update your application SDKs to send data over HTTPS/gRPC-Secure.
