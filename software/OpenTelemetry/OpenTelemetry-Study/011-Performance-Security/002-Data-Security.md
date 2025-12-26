Here is a detailed explanation of **Part XI, Section B: Data Security** from your OpenTelemetry study plan.

This module focuses on ensuring that your observability pipeline does not become a security vulnerability. Because OTel collects deep insights (request bodies, database queries, headers), it often accidentally captures secrets, PII (Personally Identifiable Information), or auth tokens.

---

# 002-Data-Security.md

## 1. The Security Challenge in Observability
Observability data is often treated as "debug data," but it frequently contains the most sensitive information in your organization.
*   **The Risk:** A developer logs a request payload to debug an error. That payload contains a user's password, a credit card number, or an API key.
*   **The Consequence:** If your tracing backend (e.g., Jaeger, Datadog) is not compliant with PCI/GDPR/HIPAA, you have just caused a data breach.

We secure OpenTelemetry in three layers:
1.  **Sanitization:** Cleaning data (Redaction).
2.  **Authentication:** Verifying who sends/receives data.
3.  **Encryption:** Securing the data in transit (TLS).

---

## 2. Redacting PII via Processors
The most effective place to sanitize data is at the **OpenTelemetry Collector**. While you *can* try to stop developers from logging secrets in code, human error is inevitable. The Collector acts as a firewall for your data.

### A. The Attributes Processor
This processor allows you to modify attributes of Spans, Logs, or Metrics. You can hash, redact, or delete keys.

**Common Actions:**
*   `delete`: Remove the attribute entirely.
*   `hash`: Keep the ability to correlate (e.g., "User A had 5 errors") without knowing the User ID (SHA-256).
*   `upsert`: Overwrite the value (e.g., replacing a value with `****`).

**Configuration Example (`config.yaml`):**
```yaml
processors:
  attributes/redaction:
    actions:
      # 1. Delete a specific dangerous attribute
      - key: http.request.header.authorization
        action: delete
      
      # 2. Redact an email address (replace value)
      - key: user.email
        action: update
        value: "[REDACTED_EMAIL]"
      
      # 3. Hash a User ID so we can still count unique users, but can't ID them
      - key: user.id
        action: hash
```

### B. The Redaction Processor (or Transform Processor)
For more complex scenarios—like finding a credit card number *inside* a log message string—you need regex capabilities.

**Using the Transform Processor (OTTL):**
The OpenTelemetry Transformation Language (OTTL) is the modern standard for this logic.

```yaml
processors:
  transform:
    error_mode: ignore
    trace_statements:
      - context: span
        statements:
          # Regex replace credit card numbers in the db.statement attribute
          - replace_pattern(attributes["db.statement"], "\\b(?:\\d[ -]*?){13,16}\\b", "****")
```

---

## 3. Implementing Authentication
By default, the OTel Collector accepts data from anyone who can reach its network port. In production, especially across public networks, you must authenticate agents.

Authentication in the Collector is handled via **Extensions**.

### A. Server-Side Auth (Receivers)
This protects the Collector from unauthorized agents pushing bad data.

1.  **Define the Auth Extension:**
    ```yaml
    extensions:
      basicauth/server:
        htpasswd:
          file: ./.htpasswd # Contains user:hashed_pass
    ```

2.  **Enable it in the Service:**
    ```yaml
    service:
      extensions: [basicauth/server]
    ```

3.  **Apply it to the Receiver:**
    ```yaml
    receivers:
      otlp:
        protocols:
          grpc:
            auth:
              authenticator: basicauth/server
    ```

### B. Client-Side Auth (Exporters)
This allows the Collector to authenticate *itself* against a backend (like Honeycomb, Datadog, or a central Collector).

```yaml
extensions:
  oauth2client:
    client_id: "my-collector-id"
    client_secret: "my-secret"
    token_url: "https://auth.example.com/token"

exporters:
  otlp/backend:
    endpoint: "api.vendor.com:4317"
    auth:
      authenticator: oauth2client
```

---

## 4. TLS & mTLS Encryption
Data traveling between your application and the Collector (or Collector to Backend) must be encrypted.

### A. Simple TLS (Server-Side)
The Collector presents a certificate, and the Client (Application) verifies it. This prevents "Man-in-the-Middle" attacks.

**Collector Config (Receiver):**
```yaml
receivers:
  otlp:
    protocols:
      grpc:
        tls:
          cert_file: /etc/otel/certs/server.crt
          key_file: /etc/otel/certs/server.key
```

### B. mTLS (Mutual TLS)
This is the gold standard for Zero Trust networks.
1.  The **Collector** proves its identity to the App.
2.  The **App** proves its identity to the Collector.
If either fails, the connection is dropped.

**Collector Config (Receiver):**
```yaml
receivers:
  otlp:
    protocols:
      grpc:
        tls:
          cert_file: /certs/server.crt
          key_file: /certs/server.key
          # This line enforces mTLS. The Collector will REJECT
          # any client that doesn't present a cert signed by this CA.
          client_ca_file: /certs/ca.crt 
```

---

## 5. Security Checklist for Production

1.  **Block Metadata:** Ensure your cloud resource detectors aren't pulling in environment variables that contain secrets (`process.env`).
2.  **Log Scrubbing:** Use the `transform` processor to regex-scrub log bodies for patterns like `eyJ...` (JWTs) or `password=`.
3.  **Network Isolation:** Do not expose the OTel Collector ports (4317/4318) to the public internet unless absolutely necessary (and if you do, use mTLS).
4.  **Sampling:** Use sampling to reduce the attack surface. If you don't store the trace, it can't be leaked.
5.  **Least Privilege:** The OTel Collector process should run as a non-root user with minimal file system access.