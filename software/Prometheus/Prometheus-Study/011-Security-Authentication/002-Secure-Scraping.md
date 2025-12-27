This section, **011-Security-Authentication / 002-Secure-Scraping**, addresses a critical vulnerability in the Prometheus "Pull Model."

By default, many exporters (like Node Exporter) expose system metrics on an HTTP endpoint (e.g., `http://server-ip:9100/metrics`) with **no encryption** and **no authentication**. If an attacker accesses this endpoint, they can see sensitive infrastructure data (kernel versions, traffic spikes, memory usage) which helps them plan attacks.

Here is a detailed breakdown of how to implement **Secure Scraping**.

---

# Detailed Explanation: Secure Scraping

Secure scraping involves two main goals:
1.  **Encryption (Privacy):** Ensuring metric data cannot be sniffed while traveling from the Target to Prometheus (TLS/HTTPS).
2.  **Authentication & Authorization (Access Control):** Ensuring only the legitimate Prometheus server can access the `/metrics` endpoint.

## 1. The Challenge: Native Exporters are often Insecure
Most standard Prometheus exporters (Node Exporter, MySQL Exporter) were historically designed to be lightweight. They didn't natively support SSL or Basic Auth.
*   **Old Approach:** You had to run the exporter on `localhost` and put a Reverse Proxy (like Nginx) in front of it to handle security.
*   **Modern Approach:** The Prometheus **Exporter Toolkit** now allows native TLS and Basic Auth configuration directly in many exporters.

---

## 2. Authentication Methods

When configuring Prometheus to scrape a protected target, you must configure the `scrape_configs` in `prometheus.yml` to pass credentials.

### A. Bearer Token Authentication
Common in Kubernetes and modern web apps. Prometheus sends an HTTP header: `Authorization: Bearer <token>`.

**Prometheus Configuration:**
```yaml
scrape_configs:
  - job_name: 'secure-app'
    metrics_path: '/metrics'
    scheme: 'https'
    # Load token from a file (recommended for rotation/security)
    bearer_token_file: /etc/prometheus/secrets/api-token
    static_configs:
      - targets: ['api.internal.example.com:443']
```

### B. Basic Authentication
The classic Username/Password method.

**Prometheus Configuration:**
```yaml
scrape_configs:
  - job_name: 'node-exporter-secure'
    scheme: 'https'
    basic_auth:
      username: 'prom_scraper'
      password: 'super_secret_password' # Or use password_file
    static_configs:
      - targets: ['10.0.1.5:9100']
```

### C. Mutual TLS (mTLS) - The Gold Standard
In high-security environments (Zero Trust), the server (Target) validates the client (Prometheus) using a client certificate. This ensures that **only** the holder of the specific client certificate can scrape the metrics.

**Prometheus Configuration:**
```yaml
scrape_configs:
  - job_name: 'mtls-target'
    scheme: 'https'
    tls_config:
      ca_file: /etc/prom/certs/ca.pem         # To verify the Target's Identity
      cert_file: /etc/prom/certs/client.pem    # Prometheus's Identity
      key_file: /etc/prom/certs/client.key     # Private key for the Cert
    static_configs:
      - targets: ['secure-db.internal:9100']
```

---

## 3. Protecting the Target (The "Server" Side)

How do you actually lock down the `/metrics` endpoint on the application or exporter side?

### Strategy A: The "Sidecar" / Reverse Proxy Pattern
If your application or exporter does not support auth, you place a reverse proxy (Nginx, Apache, Envoy) in front of it.

1.  **Exporter** listens on `127.0.0.1:9100` (Localhost only).
2.  **Nginx** listens on `0.0.0.0:9100` (External).
3.  **Nginx** is configured with SSL certificates and `auth_basic`.
4.  Prometheus scrapes Nginx -> Nginx auths request -> proxies to Exporter.

### Strategy B: Native Exporter Security (Exporter Toolkit)
The Prometheus community released the `exporter-toolkit`. This allows you to provide a `web-config.yml` to binary exporters (like Node Exporter) to enable security without Nginx.

**web-config.yml:**
```yaml
tls_server_config:
  cert_file: /etc/node_exporter/node.crt
  key_file: /etc/node_exporter/node.key

basic_auth_users:
  prom_scraper: $2y$12$....hashed_password....
```

**Running the exporter:**
```bash
./node_exporter --web.config.file=web-config.yml
```

### Strategy C: Kubernetes RBAC & NetworkPolicies
In Kubernetes, you don't always need Basic Auth. You can use the cluster's native security.

1.  **NetworkPolicies:** Define a rule that says "Only the Pods with label `app: prometheus` are allowed to connect to `port 9090` on my application pods."
2.  **Kubelet Scraping:** When Prometheus scrapes the Kubelet (for cAdvisor metrics), it uses the Kubernetes Service Account token mounted in the Prometheus pod. The Kubelet verifies this token against the API Server to ensure Prometheus has permissions to read metrics.

---

## 4. Specific Considerations for this Section

When studying this section of your roadmap, focus on these nuances:

1.  **TLS Verification:**
    *   In production, never use `insecure_skip_verify: true`.
    *   Always ensure Prometheus has the correct CA (Certificate Authority) to validate the target's certificate.
2.  **Credential Management:**
    *   Don't hardcode passwords in `prometheus.yml`. Use `password_file` or `bearer_token_file`.
    *   In Kubernetes, map these files via Secrets.
3.  **Performance Cost:**
    *   Enabling HTTPS and Authentication adds a slight overhead (CPU for encryption handshakes). For massive scale (millions of metrics), this is negligible, but connection establishment latency is higher than plain HTTP. Prometheus uses **HTTP Keep-Alives** to mitigate this (reusing the same TCP connection for subsequent scrapes).

## Summary Table

| Method | Security Level | Complexity | Use Case |
| :--- | :--- | :--- | :--- |
| **Plain HTTP** | None (Unsafe) | Low | Local testing, strictly isolated VPCs. |
| **Basic Auth** | Medium | Medium | Simple legacy exporters, Nginx frontends. |
| **Bearer Token** | High | Medium | Kubernetes apps, OAuth2 environments. |
| **mTLS** | Very High | High | Zero-trust networks, Finance/Healthcare, Cross-cluster scraping. |
