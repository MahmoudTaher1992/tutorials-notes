# Cloud Design Patterns - Part 13: Security & Identity (I)

## 7.0 Security & Identity Patterns

### 7.1 Federated Identity & SSO
#### 7.1.1 Pattern Intent
- 7.1.1.1 Delegate authentication to a trusted external Identity Provider (IdP)
- 7.1.1.2 Enable Single Sign-On (SSO) — one login grants access to multiple services
#### 7.1.2 Identity Federation Standards
- 7.1.2.1 OAuth 2.0 — authorization framework; grants delegated access via access tokens
  - 7.1.2.1.1 Grant types — Authorization Code, Client Credentials, PKCE, Device Flow
  - 7.1.2.1.2 Access token formats — opaque (reference) vs. self-contained (JWT)
- 7.1.2.2 OpenID Connect (OIDC) — identity layer on top of OAuth 2.0; adds ID token (JWT)
  - 7.1.2.2.1 ID token claims — sub, iss, aud, exp, iat, email, groups
  - 7.1.2.2.2 UserInfo endpoint — fetch additional claims with access token
- 7.1.2.3 SAML 2.0 — XML-based federation; legacy enterprise SSO (Okta, ADFS)
  - 7.1.2.3.1 SP-initiated vs. IdP-initiated flows — redirect binding vs. POST assertion
#### 7.1.3 Token Lifecycle Management
- 7.1.3.1 Access token — short-lived (15m-1h); sent on every API request; Bearer in Authorization header
- 7.1.3.2 Refresh token — long-lived (days/weeks); exchange for new access token; store securely
  - 7.1.3.2.1 Refresh token rotation — each use issues new refresh token; old token invalidated
- 7.1.3.3 Token revocation — revoke access token via introspection endpoint or token blacklist
  - 7.1.3.3.1 Short TTL strategy — access token expires quickly; avoid revocation infrastructure
#### 7.1.4 JWT Security
- 7.1.4.1 Signature algorithms — RS256 (RSA asymmetric; public key verifiable), HS256 (HMAC shared secret)
  - 7.1.4.1.1 RS256 preferred — backend can verify without sharing secret key
- 7.1.4.2 Algorithm confusion attack — none algorithm; alg:HS256 with RS256 public key as secret
  - 7.1.4.2.1 Mitigation — explicitly whitelist allowed algorithms; reject "none"
- 7.1.4.3 JWT claim validation — validate iss, aud, exp, nbf; reject missing claims
#### 7.1.5 SSO Session Management
- 7.1.5.1 Session cookie — HttpOnly, Secure, SameSite=Strict; short absolute TTL
- 7.1.5.2 Single Logout (SLO) — propagate logout to all federated services
- 7.1.5.3 Session fixation protection — regenerate session ID after successful authentication

### 7.2 Zero Trust Architecture
#### 7.2.1 Zero Trust Principles
- 7.2.1.1 Never trust, always verify — authenticate and authorize every request regardless of origin
- 7.2.1.2 Least privilege — grant minimum permissions required for the task; no standing access
- 7.2.1.3 Assume breach — design as if attacker is already inside; limit lateral movement
#### 7.2.2 Identity-Based Access Control
- 7.2.2.1 Workload identity — services authenticate with identity (SPIFFE SVID, AWS IAM role)
  - 7.2.2.1.1 SPIFFE standard — cryptographic identities (SVIDs) for workloads; issued by SPIRE
  - 7.2.2.1.2 AWS EKS Pod Identity / IRSA — map Kubernetes service account to IAM role
- 7.2.2.2 Continuous verification — re-verify identity on each request; no implicit trust from prior auth
- 7.2.2.3 Context-aware access — incorporate device posture, location, time in authorization decision
  - 7.2.2.3.1 BeyondCorp model — access based on user identity + device state, not network location
#### 7.2.3 Micro-Segmentation
- 7.2.3.1 East-west traffic control — restrict service-to-service communication to explicit allow-list
  - 7.2.3.1.1 Kubernetes NetworkPolicy — pod-level ingress/egress rules; CNI-enforced
  - 7.2.3.1.2 Service mesh AuthorizationPolicy — L7 allow/deny per service/path/method
- 7.2.3.2 Lateral movement prevention — compromised service cannot reach unrelated services
#### 7.2.4 Zero Trust Implementation Layers
- 7.2.4.1 Identity layer — strong MFA; phishing-resistant (FIDO2/WebAuthn hardware keys)
- 7.2.4.2 Device layer — endpoint detection; certificate-based device identity (MDM)
- 7.2.4.3 Network layer — micro-segmentation; encrypted transit; private endpoints
- 7.2.4.4 Application layer — per-request authorization; RBAC/ABAC enforcement in service

### 7.3 Valet Key Pattern
#### 7.3.1 Pattern Intent
- 7.3.1.1 Issue time-limited, scope-limited credentials for direct client access to a resource
- 7.3.1.2 Avoid routing large data transfers through application server (bypass bottleneck)
#### 7.3.2 Implementation Mechanisms
- 7.3.2.1 AWS S3 Presigned URLs — HMAC-signed URL; grants GET or PUT for specific object + TTL
  - 7.3.2.1.1 Signed URL generation — SDK generates URL server-side; client uses directly
  - 7.3.2.1.2 PUT presigned URL — client uploads directly to S3; no data through app server
- 7.3.2.2 Azure SAS (Shared Access Signature) — resource URI + permissions + expiry + HMAC
  - 7.3.2.2.1 User Delegation SAS — signed with AAD user credentials; more secure than account key
- 7.3.2.3 GCP Signed URLs — similar to S3; signed with service account key or IAM credentials
#### 7.3.3 Security Constraints
- 7.3.3.1 Minimum TTL — issue shortest TTL that allows the operation to complete
- 7.3.3.2 Scope restriction — limit to exact resource (bucket/key), exact HTTP method, exact IP range
- 7.3.3.3 Token revocation challenge — presigned URLs cannot be revoked before expiry
  - 7.3.3.3.1 Mitigation — short TTL (minutes not hours); rotate signing keys to mass-revoke
