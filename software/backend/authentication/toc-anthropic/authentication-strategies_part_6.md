# Authentication Strategies — Part 6: SSO, Federated Identity & mTLS

---

## 9.0 Single Sign-On (SSO) & Federated Identity

### 9.1 SSO Architecture Patterns
#### 9.1.1 Centralized IdP Model
- 9.1.1.1 Single authentication point — one login for all Service Providers (SPs)
- 9.1.1.2 Session propagation — IdP session shared across SPs via assertions
- 9.1.1.3 Logout propagation — SLO (Single Logout) complexity

#### 9.1.2 Federation Topologies
- 9.1.2.1 Hub-and-spoke — central IdP to multiple SPs
- 9.1.2.2 Mesh federation — bilateral trust between multiple IdPs
- 9.1.2.3 Circle of Trust — Liberty Alliance model

### 9.2 SAML 2.0
#### 9.2.1 SAML Components
- 9.2.1.1 Principal (user), Identity Provider (IdP), Service Provider (SP)
- 9.2.1.2 Assertion — XML document with authentication statement
  - 9.2.1.2.1 AuthnStatement — authentication event, method, timestamp
  - 9.2.1.2.2 AttributeStatement — user attributes (email, roles, groups)
  - 9.2.1.2.3 AuthzDecisionStatement — authorization decision (rarely used)
- 9.2.1.3 Metadata — SP + IdP XML descriptors with certificates and endpoints

#### 9.2.2 SAML Flows
- 9.2.2.1 SP-Initiated SSO (most common)
  - 9.2.2.1.1 AuthnRequest → IdP redirect → Assertion POST → ACS URL
  - 9.2.2.1.2 RelayState — return URL preservation across redirect
- 9.2.2.2 IdP-Initiated SSO
  - 9.2.2.2.1 No AuthnRequest — unsolicited response to SP
  - 9.2.2.2.2 Replay attack vector — missing request correlation

#### 9.2.3 SAML Security
- 9.2.3.1 XML signature validation — SignedInfo element check
  - 9.2.3.1.1 Signature Wrapping Attacks (XSW) — unsigned copy alongside signed
  - 9.2.3.1.2 Comment injection — XML namespace manipulation
- 9.2.3.2 Assertion encryption — EncryptedAssertion protects in-transit
- 9.2.3.3 Replay prevention — AssertionID tracking + NotOnOrAfter
- 9.2.3.4 InResponseTo validation — correlate response to AuthnRequest ID

### 9.3 OIDC-Based SSO
#### 9.3.1 OIDC Session Linkage
- 9.3.1.1 IdP session_state parameter — RP polls for changes
- 9.3.1.2 RP-initiated logout — `end_session_endpoint` redirect with id_token_hint
- 9.3.1.3 Back-channel logout token — `logout_token` with `sid` claim

#### 9.3.2 Multi-RP Logout Challenges
- 9.3.2.1 Propagation to all RPs sharing IdP session
- 9.3.2.2 Race conditions — best-effort logout delivery model

### 9.4 Identity Federation & JIT Provisioning
#### 9.4.1 Just-In-Time (JIT) User Provisioning
- 9.4.1.1 Auto-create users on first SSO assertion receipt
- 9.4.1.2 Attribute mapping — IdP claim → local user field mapping config
- 9.4.1.3 Conflict handling — email collision with existing local account
- 9.4.1.4 Attribute update on subsequent logins — profile sync strategy

#### 9.4.2 SCIM (System for Cross-domain Identity Management)
- 9.4.2.1 SCIM 2.0 — REST API for user provisioning/deprovisioning (RFC 7642-7644)
- 9.4.2.2 Push vs. pull sync models
- 9.4.2.3 SCIM endpoint security — Bearer token + TLS
- 9.4.2.4 Schema extensions — custom attributes per enterprise

#### 9.4.3 Entitlement Management
- 9.4.3.1 Role mapping from IdP groups to local roles
- 9.4.3.2 Group-based access provisioning
- 9.4.3.3 Deprovisioning workflows — timely access revocation on IdP removal

---

## 10.0 Certificate-Based Authentication & Mutual TLS (mTLS)

### 10.1 PKI Fundamentals for Authentication
#### 10.1.1 Certificate Hierarchy
- 10.1.1.1 Root CA — offline, air-gapped trust anchor
- 10.1.1.2 Intermediate CA — online issuance proxy (limits root exposure)
- 10.1.1.3 Leaf certificates — end-entity, 1-2 year validity maximum

#### 10.1.2 Certificate Fields for Auth
- 10.1.2.1 Subject DN — Common Name, Organization, OU
- 10.1.2.2 Subject Alternative Names (SAN) — email, URI, DNS names
- 10.1.2.3 Extended Key Usage — clientAuth OID (1.3.6.1.5.5.7.3.2)

### 10.2 mTLS Handshake Flow
#### 10.2.1 TLS 1.3 Mutual Authentication Steps
- 10.2.1.1 Server sends CertificateRequest during handshake
- 10.2.1.2 Client sends Certificate + CertificateVerify
  - 10.2.1.2.1 CertificateVerify signature — private key proof of possession
- 10.2.1.3 Server validates client cert chain to trusted CA

#### 10.2.2 Certificate Validation Steps
- 10.2.2.1 Chain validation — path building to trusted root
- 10.2.2.2 Revocation check — CRL or OCSP stapling
  - 10.2.2.2.1 OCSP stapling — server fetches + caches OCSP response
  - 10.2.2.2.2 CRL distribution point — periodic CRL download
- 10.2.2.3 Temporal validation — notBefore / notAfter constraints
- 10.2.2.4 Key usage validation — clientAuth in EKU

### 10.3 mTLS in Service Mesh & APIs
#### 10.3.1 Service Mesh mTLS
- 10.3.1.1 Istio mTLS — sidecar proxy (Envoy) handles TLS termination
  - 10.3.1.1.1 STRICT mode — reject all plaintext connections
  - 10.3.1.1.2 PERMISSIVE mode — allow both for migration
- 10.3.1.2 SPIFFE/SPIRE — workload identity via X.509 SVIDs
  - 10.3.1.2.1 SVID URI format — `spiffe://trust-domain/workload-id`
  - 10.3.1.2.2 Automatic cert rotation — before expiry without restart
  - 10.3.1.2.3 Federation across trust domains — SPIFFE bundle endpoints

#### 10.3.2 API Gateway mTLS
- 10.3.2.1 Client certificate passthrough headers — `X-Client-Cert`
- 10.3.2.2 Certificate-bound access tokens (RFC 8705)
  - 10.3.2.2.1 `cnf.x5t#S256` claim — certificate thumbprint binding in token
  - 10.3.2.2.2 RS validates token binding against presented certificate

#### 10.3.3 Certificate Lifecycle Management
- 10.3.3.1 Automated issuance — cert-manager, AWS ACM Private CA
- 10.3.3.2 Rotation automation — pre-expiry refresh without downtime
- 10.3.3.3 Certificate pinning — public key pinning risks and deprecation

---

> **Navigation:** [← Part 5: Passwordless & MFA](authentication-strategies_part_5.md) | [Part 7: Security Attacks & Performance →](authentication-strategies_part_7.md)
