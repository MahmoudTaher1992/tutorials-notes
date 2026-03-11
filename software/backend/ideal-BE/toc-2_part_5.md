# The Ideal Backend — Complete Study Guide

## Table of Contents — Part 5: Protection (§23–26)

---

### 23. Security

#### 23.1 Input Security
- 23.1.1 SQL injection prevention (parameterized queries, ORM safety)
- 23.1.2 NoSQL injection prevention
- 23.1.3 XSS prevention (output encoding, CSP headers)
- 23.1.4 Command injection prevention
- 23.1.5 Path traversal prevention
- 23.1.6 Input sanitization libraries

#### 23.2 HTTP Security
- 23.2.1 CORS configuration (origins, methods, headers, credentials)
- 23.2.2 CSRF protection (tokens, SameSite cookies, double-submit)
- 23.2.3 Security headers (Helmet.js-style)
  - Content-Security-Policy
  - Strict-Transport-Security (HSTS)
  - X-Content-Type-Options
  - X-Frame-Options
  - Referrer-Policy
  - Permissions-Policy

#### 23.3 Data Security
- 23.3.1 Password hashing (bcrypt, Argon2, scrypt)
- 23.3.2 Encryption at rest and in transit
- 23.3.3 Sensitive data masking in logs
- 23.3.4 PII handling and data classification
- 23.3.5 Secure file upload validation (MIME type, size, malware scanning)

#### 23.4 API Security
- 23.4.1 Authentication enforcement on all endpoints
- 23.4.2 Authorization checks at resource level
- 23.4.3 Mass assignment protection
- 23.4.4 Excessive data exposure prevention
- 23.4.5 OWASP API Security Top 10

#### 23.5 Infrastructure Security
- 23.5.1 TLS configuration and certificate management
- 23.5.2 HTTP-only and Secure cookie flags
- 23.5.3 Network segmentation basics
- 23.5.4 Dependency vulnerability scanning (Snyk, npm audit, Dependabot)

---

### 24. Resilience & Fault Tolerance

#### 24.1 Resilience Patterns
- 24.1.1 Circuit breaker pattern (closed, open, half-open states)
- 24.1.2 Retry with exponential backoff and jitter
- 24.1.3 Timeout policies (connect timeout, read timeout)
- 24.1.4 Bulkhead pattern (isolation of failures)
- 24.1.5 Fallback strategies (default values, cached responses, degraded mode)

#### 24.2 Graceful Degradation
- 24.2.1 Feature degradation (disable non-critical features)
- 24.2.2 Read-only mode
- 24.2.3 Queue-based load leveling
- 24.2.4 Shedding load under pressure

#### 24.3 Health & Readiness
- 24.3.1 Liveness probes (is the process alive?)
- 24.3.2 Readiness probes (is the service ready to accept traffic?)
- 24.3.3 Startup probes
- 24.3.4 Dependency health checks (database, cache, external services)
- 24.3.5 Health check aggregation

#### 24.4 Resilience Libraries
- 24.4.1 Polly (.NET), Resilience4j (Java), cockatiel (Node.js)
- 24.4.2 Istio/Envoy service mesh resilience (infrastructure-level)
- 24.4.3 Chaos engineering basics (Chaos Monkey, Gremlin)

---

### 25. Concurrency Control & Idempotency

#### 25.1 Concurrency Patterns
- 25.1.1 Optimistic locking (version columns, ETags)
- 25.1.2 Pessimistic locking (SELECT FOR UPDATE)
- 25.1.3 Advisory locks
- 25.1.4 Distributed locks (Redis SETNX, Redlock, Zookeeper)
- 25.1.5 Deadlock prevention and detection

#### 25.2 Race Condition Prevention
- 25.2.1 Database-level unique constraints
- 25.2.2 Atomic operations (increment, compare-and-swap)
- 25.2.3 Serializable transactions for critical paths
- 25.2.4 Application-level mutex patterns

#### 25.3 Idempotency
- 25.3.1 What idempotency means and why it matters
- 25.3.2 Idempotency keys (client-generated unique IDs)
- 25.3.3 Idempotent API design (which HTTP methods are naturally idempotent)
- 25.3.4 Implementing idempotency stores
- 25.3.5 Idempotency in payment processing

---

### 26. Secrets Management

#### 26.1 Secrets Fundamentals
- 26.1.1 What constitutes a secret (API keys, DB passwords, tokens, certificates)
- 26.1.2 Why environment variables alone aren't enough
- 26.1.3 Secret sprawl and detection (git-secrets, truffleHog)

#### 26.2 Secrets Management Solutions
- 26.2.1 HashiCorp Vault
- 26.2.2 AWS Secrets Manager / Parameter Store
- 26.2.3 Azure Key Vault
- 26.2.4 GCP Secret Manager
- 26.2.5 Doppler, Infisical (developer-friendly tools)

#### 26.3 Secrets Lifecycle
- 26.3.1 Secret generation and strength requirements
- 26.3.2 Secret rotation policies and automation
- 26.3.3 Secret injection at runtime (sidecar, init container, SDK)
- 26.3.4 Secret revocation and emergency rotation
- 26.3.5 Audit logging for secret access

#### 26.4 Secrets in CI/CD
- 26.4.1 CI/CD environment variables (GitHub Actions secrets, GitLab CI variables)
- 26.4.2 Never logging secrets (masking in pipelines)
- 26.4.3 Secrets in Docker builds (multi-stage builds, BuildKit secrets)

---

> **Navigation:** [← Part 4: API](toc-2_part_4.md) | [Part 6: Infrastructure (§27–29) →](toc-2_part_6.md)
