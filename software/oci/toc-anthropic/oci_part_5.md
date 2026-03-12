# OCI Complete Study Guide - Part 5: Phase 1 — Security & Identity

## 5.0 Security & Identity

### 5.1 IAM — Tenancy, Compartments & Policies
#### 5.1.1 Tenancy & Compartment Hierarchy
- 5.1.1.1 Tenancy — root compartment — created at account signup — immutable OCID
  - 5.1.1.1.1 Home region — IAM resources created here — replicated to subscribed regions
  - 5.1.1.1.2 Tenancy admin — full access — protect with MFA — break-glass account
- 5.1.1.2 Compartments — logical container — resource isolation — nested up to 6 levels
  - 5.1.1.2.1 Compartment inheritance — policies on parent apply to all children
  - 5.1.1.2.2 Moving resources — move compartment — 15-min lag — policies must exist
  - 5.1.1.2.3 Compartment quotas — limit resource type per compartment — cost control

#### 5.1.2 IAM Principals
- 5.1.2.1 Users — human identities — local or federated — per-region console access
  - 5.1.2.1.1 API keys — RSA key pair — up to 3 per user — rotate regularly
  - 5.1.2.1.2 Auth tokens — legacy API — Swift/IDCS — no key pair needed
- 5.1.2.2 Groups — collection of users — policies attach to group not user
  - 5.1.2.2.1 Dynamic groups — match by resource attribute — instance principal
  - 5.1.2.2.2 Dynamic group rules — ANY {resource.type='instance', ...} — CEL-like
- 5.1.2.3 Service principals — OCI services — access other OCI services
  - 5.1.2.3.1 Authorize service — allow service X to manage Y in compartment Z

#### 5.1.3 IAM Policies
- 5.1.3.1 Policy — Allow/Deny — subject — verb — resource type — location
  - 5.1.3.1.1 Verbs — inspect / read / use / manage — increasing permission hierarchy
  - 5.1.3.1.2 Resource type aggregates — all-resources / database-family / object-family
  - 5.1.3.1.3 Conditions — where request.user.id= / where target.bucket.name=
- 5.1.3.2 Policy inheritance — policies at compartment — apply to all nested resources
  - 5.1.3.2.1 No explicit deny — deny by default — allow policies grant access only
  - 5.1.3.2.2 DENY statements — OCI IAM supports explicit DENY — override allows
- 5.1.3.3 Tenancy-level policies — in root compartment — apply to entire tenancy
  - 5.1.3.3.1 Cross-tenancy policies — endorse + admit — source + target tenancy

### 5.2 Identity Domains (OCI IAM with Identity Domains)
#### 5.2.1 Identity Domain Architecture
- 5.2.1.1 Identity domain — user store + MFA + federation + app catalog — per-tenancy
  - 5.2.1.1.1 Domain types — Free / Oracle Apps / Premium — feature tiers
  - 5.2.1.1.2 Default domain — created automatically — OCI console users
- 5.2.1.2 Federation — SAML 2.0 + OIDC — external IdP → OCI identities
  - 5.2.1.2.1 SAML IdP metadata — upload XML — assertion attribute mapping
  - 5.2.1.2.2 Group mapping — IdP group → OCI group — policy-ready identity
- 5.2.1.3 SCIM provisioning — sync users from Okta/Azure AD — automated lifecycle
  - 5.2.1.3.1 Just-in-time provisioning — auto-create user on first login — SAML
  - 5.2.1.3.2 De-provisioning — disable user when removed in IdP — revoke access

#### 5.2.2 MFA & Adaptive Authentication
- 5.2.2.1 MFA factors — TOTP, FIDO2, Push Notification (Oracle Mobile Auth)
  - 5.2.2.1.1 Enrollment bypass — admin override — lost device recovery
  - 5.2.2.1.2 Trusted devices — remember device N days — reduce friction
- 5.2.2.2 Adaptive authentication — risk score — anomalous login → step-up MFA
  - 5.2.2.2.1 Risk factors — new device, new location, failed attempts
  - 5.2.2.2.2 Sign-on policies — conditions → MFA required / deny / allow

### 5.3 Vault (KMS + Secrets)
#### 5.3.1 Vault Architecture
- 5.3.1.1 Virtual Private Vault (VPV) — dedicated HSM partition — not shared
  - 5.3.1.1.1 FIPS 140-2 Level 3 HSM — key material never leaves HSM unencrypted
  - 5.3.1.1.2 VPV vs. Default Vault — dedicated vs. shared HSM partition — cost tradeoff
- 5.3.1.2 Master Encryption Keys (MEK) — AES-128/256, RSA, ECDSA — key types
  - 5.3.1.2.1 Envelope encryption — MEK wraps DEK — DEK wraps data — standard pattern
  - 5.3.1.2.2 Key version — rotate by creating new version — decrypt with prior version
  - 5.3.1.2.3 External Key Management — EKMS — key in on-prem HSM — OCI calls out
- 5.3.1.3 Secrets — credentials — password/API key/TLS cert — versioned
  - 5.3.1.3.1 Secret rotation — manual or rule-based — increment version
  - 5.3.1.3.2 Expiry rule — expire version after N days — alert before expiry
  - 5.3.1.3.3 Secret bundles — retrieve by name + version + stage — app integration

### 5.4 Cloud Guard & Security Zones
#### 5.4.1 Cloud Guard
- 5.4.1.1 Cloud Guard — CSPM — detector recipes — responder recipes — continuous
  - 5.4.1.1.1 Detector recipe — OCI Managed or custom — check resource config
  - 5.4.1.1.2 Problem — finding — resource + risk level + detector — action queue
  - 5.4.1.1.3 Responder recipe — auto-remediate — delete public bucket — notify
- 5.4.1.2 Threat Detector — ML-based — anomalous instance activity — cloud threats
  - 5.4.1.2.1 Instance activity — crypto mining signal — unusual network — flag

#### 5.4.2 Security Zones
- 5.4.2.1 Security Zone — compartment + max security recipe — deny risky operations
  - 5.4.2.1.1 Max Security recipe — blocks public buckets, no unencrypted volumes
  - 5.4.2.1.2 Custom recipe — select subset of policies — flexible enforcement

### 5.5 Bastion Service
#### 5.5.1 Bastion Architecture
- 5.5.1.1 Managed bastion — no bastion VM — SSH tunnels to private resources
  - 5.5.1.1.1 Managed SSH session — direct SSH to instance — OCI tunnels traffic
  - 5.5.1.1.2 Port forwarding session — forward local port → private IP:port — DB access
  - 5.5.1.1.3 Session TTL — max 3 hours — auto-expire — no persistent access
- 5.5.1.2 CIDR allowlist — restrict who can create bastion sessions — IP control
  - 5.5.1.2.1 IAM policy — manage bastion-session — restrict to jump-host IP range

### 5.6 OS Management Hub
#### 5.6.1 OS Management Hub Architecture
- 5.6.1.1 Centralized patch management — Oracle Linux, Windows — agent-based
  - 5.6.1.1.1 Managed instance groups — tag-based — patch schedules — concurrency
  - 5.6.1.1.2 Lifecycle environments — test → staging → production — controlled rollout
- 5.6.1.2 Software sources — OCI-hosted mirrors — yum/apt repos — no internet needed
  - 5.6.1.2.1 Custom software source — upload RPMs — private repo — internal packages
