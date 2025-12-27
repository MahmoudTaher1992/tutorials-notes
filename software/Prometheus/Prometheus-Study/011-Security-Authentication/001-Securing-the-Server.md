This section describes the "defense" of the Prometheus server itself. By default, a vanilla installation of Prometheus is **unsecured**. It communicates over plain HTTP, has no password protection, and anyone with network access to port `9090` can query your metrics, see your labels, and potentially crash the server by running heavy queries.

Here is a detailed breakdown of **011-Security-Authentication/001-Securing-the-Server**.

---

### 1. TLS Configuration (Encryption in Transit)

Before considering *who* is logging in (Authentication), you must ensure that data traveling between the user (or Grafana) and Prometheus cannot be intercepted.

**The Problem:** By default, Prometheus serves traffic on `http://<ip>:9090`. If you access this over the public internet or an untrusted network, metric data (which often contains sensitive info in labels) acts as clear text.

**The Solution:** Enable TLS (Transport Layer Security) to force HTTPS.

**How it works (Native Support):**
Since Prometheus 2.24.0, TLS is supported natively. You do not need an external proxy for this anymore. You define a `web-config.yml` file and pass it to Prometheus using the flag `--web.config.file=web-config.yml`.

**Example Configuration:**
```yaml
# web-config.yml
tls_server_config:
  cert_file: server.crt
  key_file: server.key
```
*   **cert_file:** The public certificate.
*   **key_file:** The private key.
*   **mTLS (Mutual TLS):** You can also configure `client_auth_type: RequireAndVerifyClientCert`. This forces the *client* (e.g., Grafana) to present a certificate proving who it is, adding a massive layer of security.

---

### 2. Basic Authentication (Built-in vs. Reverse Proxy)

This topic covers verifying the identity of the user or service accessing the Prometheus UI or API.

#### A. Built-in Basic Authentication
Prometheus now allows you to set a username and a hashed password directly in the configuration.

*   **Pros:** Simple to set up; no extra software needed.
*   **Cons:** Limited to "Basic Auth" (Username/Password). No "Forgot Password," no "Login with Google," no complex roles.
*   **How to setup:**
    You generate a bcrypt hash of your password and add it to the same `web-config.yml`.

    ```yaml
    # web-config.yml
    basic_auth_users:
        admin: $2b$12$hNf2lSs....(hashed_password)
        viewer: $2y$12$Gw3....(hashed_password)
    ```

#### B. Reverse Proxy Authentication (The "Sidecar" pattern)
Before native auth existed (and still heavily used today for advanced setups), the standard practice was to put a web server like **Nginx, Apache, or Traefik** *in front* of Prometheus.

*   **Architecture:** User -> Nginx (Port 443, SSL, Auth) -> Prometheus (Localhost:9090).
*   **Why use this?**
    1.  **SSO (Single Sign-On):** You want users to log in with their corporate Google, Okta, or GitHub accounts (OAuth2/OIDC). Prometheus cannot do this natively; Nginx (with `oauth2-proxy`) can.
    2.  **Fine-grained path control:** You might want to allow public access to `/metrics` but password-protect `/graph`.
    3.  **Centralized Certificate Management:** If you use Cert-Manager or Let's Encrypt, it is often easier to handle certificates at the proxy/Ingress level than inside the Prometheus app.

---

### 3. Role-Based Access Control (RBAC) in Kubernetes

When running Prometheus in Kubernetes, "Securing the Server" takes on a different meaning. It involves two directions: **Access TO Prometheus** and **Access BY Prometheus**.

#### A. Access BY Prometheus (Service Accounts)
Prometheus needs to talk to the Kubernetes API to discover targets (Pods, Nodes, Services). It does this via "Service Discovery."

*   **The Risk:** If you give Prometheus the standard `cluster-admin` role, and an attacker compromises the Prometheus container, they own your entire cluster.
*   **The Fix:** Create a specific `ClusterRole` that grants **read-only** access to specific resources.
    *   *Verbs allowed:* `get`, `list`, `watch`.
    *   *Resources allowed:* `pods`, `services`, `endpoints`, `nodes`.
    *   *Resources DENIED:* `secrets`, `configmaps` (unless necessary).

#### B. Access TO Prometheus (Network Policies & Ingress)
*   **Network Policies:** In K8s, you should use NetworkPolicies to ensure that *only* Grafana and the SRE team's IP addresses can talk to the Prometheus Pod port 9090.
*   **RBAC Proxies (kube-rbac-proxy):**
    The **Prometheus Operator** stack often deploys a sidecar called `kube-rbac-proxy`.
    *   This sits in front of Prometheus.
    *   It intercepts requests.
    *   It validates the request against Kubernetes RBAC (SubjectAccessReview).
    *   *Example:* It allows a user to query metrics only if that user has permissions in Kubernetes to view those metrics. This bridges the gap between Kubernetes Authentication and Prometheus.

---

### Summary Checklist for Securing the Server

If you were implementing this in production, your checklist would look like this:

1.  **Disable Admin API:** Ensure `--web.enable-admin-api` is **OFF** unless strictly needed (prevents remote data deletion).
2.  **Enable TLS:** Don't serve clear text. Use `web-config.yml` or a Reverse Proxy with SSL termination.
3.  **Enforce Auth:**
    *   *Simple:* Use native Basic Auth.
    *   *Enterprise:* Use a Reverse Proxy (Nginx/Envoy) with OAuth2 to tie into your company's SSO.
4.  **Least Privilege (K8s):** Ensure the ServiceAccount running Prometheus only has `list/watch` permissions on necessary resources, not full Cluster Admin.
