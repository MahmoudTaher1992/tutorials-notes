# Azure Complete Study Guide - Part 5: Security & Identity (Phase 1 — Ideal)

## 5.0 Security & Identity

### 5.1 Microsoft Entra ID (Azure AD)
#### 5.1.1 Entra ID Tenant & Objects
- 5.1.1.1 Tenant — dedicated Entra ID directory — isolated namespace
  - 5.1.1.1.1 Multi-tenant apps — supported by multi-tenant app registration
  - 5.1.1.1.2 B2B collaboration — guest users — external Entra tenants / social IDs
- 5.1.1.2 Principal types — Users, Groups, Service Principals, Managed Identities
  - 5.1.1.2.1 Workload identities — service principals + managed identities
  - 5.1.1.2.2 App registration vs. Enterprise App — registration = definition, EA = instance

#### 5.1.2 Authentication
- 5.1.2.1 Primary Refresh Token (PRT) — SSO token — device-level — 14-day validity
  - 5.1.2.1.1 Cloud AP plugin — Windows Hello for Business — FIDO2 keys
- 5.1.2.2 Modern auth — OAuth 2.0 / OIDC — MSAL library
  - 5.1.2.2.1 Auth code + PKCE — SPA / mobile — no client secret needed
  - 5.1.2.2.2 Client credentials — service-to-service — certificate preferred over secret
- 5.1.2.3 MFA — Authenticator app / FIDO2 / SMS / OATH TOTP
  - 5.1.2.3.1 Number matching — prevent MFA fatigue — required since 2023
  - 5.1.2.3.2 Phishing-resistant MFA — FIDO2 / CBA — required for AAL3

#### 5.1.3 Conditional Access
- 5.1.3.1 Signal → Decision → Enforcement — zero-trust access control
  - 5.1.3.1.1 Signals — user/group, IP, device compliance, app, risk, location
  - 5.1.3.1.2 Controls — block, require MFA, require compliant device, session limits
- 5.1.3.2 Named locations — IP ranges or countries — trusted network definition
- 5.1.3.3 Sign-in risk policy — Identity Protection ML — Low/Medium/High
  - 5.1.3.3.1 Leaked credentials — dark web scanning — user risk elevation
  - 5.1.3.3.2 Atypical travel — impossible speed between sign-ins — anomaly detection

#### 5.1.4 Privileged Identity Management (PIM)
- 5.1.4.1 Just-in-time (JIT) privileged access — activate role for limited time
  - 5.1.4.1.1 Eligible vs. Active assignments — eligible requires activation
  - 5.1.4.1.2 Activation requirements — MFA, justification, approval, duration limit
- 5.1.4.2 Access reviews — periodic review of role assignments — auto-remediate
  - 5.1.4.2.1 Machine learning recommendations — "approve" vs. "deny" suggestions

### 5.2 Azure RBAC & Azure Policy
#### 5.2.1 Azure RBAC
- 5.2.1.1 Role definition — actions + notActions + dataActions + notDataActions
  - 5.2.1.1.1 Control plane actions — Microsoft.Compute/virtualMachines/write
  - 5.2.1.1.2 Data plane actions — Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read
- 5.2.1.2 Assignment scopes — Management Group → Subscription → Resource Group → Resource
  - 5.2.1.2.1 Deny assignments — override allow — Azure Blueprints / PIM-driven
- 5.2.1.3 Custom roles — JSON definition — up to 5000 per tenant
  - 5.2.1.3.1 Assignable scopes — restrict where custom role can be assigned

#### 5.2.2 Azure Policy
- 5.2.2.1 Policy definitions — built-in (500+) or custom — JSON
  - 5.2.2.1.1 Effect types — Deny, Audit, Append, Modify, DeployIfNotExists, AuditIfNotExists
  - 5.2.2.1.2 DeployIfNotExists — remediation task — deploy compliant config automatically
- 5.2.2.2 Initiatives (policy sets) — group multiple policies — compliance score
  - 5.2.2.2.1 CIS Benchmark, NIST 800-53, ISO 27001, PCI DSS built-in initiatives
- 5.2.2.3 Exemptions — waive resource from policy — Waiver or Mitigated categories
  - 5.2.2.3.1 Expiry date — time-bound exemption — auto-expire

### 5.3 Azure Key Vault
#### 5.3.1 Key Vault Tiers & Objects
- 5.3.1.1 Standard — software-protected keys + secrets + certificates
- 5.3.1.2 Premium — HSM-protected keys — FIPS 140-2 Level 2
- 5.3.1.3 Managed HSM — dedicated FIPS 140-2 Level 3 — single-tenant HSM cluster
  - 5.3.1.3.1 Security domain — encrypted backup of HSM state — admin recovery
  - 5.3.1.3.2 Local RBAC — Managed HSM-specific roles — no Azure RBAC inheritance

#### 5.3.2 Key Vault Keys
- 5.3.2.1 Key types — RSA (2048/3072/4096), EC (P-256/P-384/P-521), oct-HSM
  - 5.3.2.1.1 Key operations — encrypt, decrypt, wrapKey, unwrapKey, sign, verify
  - 5.3.2.1.2 Key version — immutable — rotation creates new version
- 5.3.2.2 Key rotation policy — auto-rotate on schedule or expiry
  - 5.3.2.2.1 Event Grid notification — rotation triggers — update dependent services
- 5.3.2.3 Bring Your Own Key (BYOK) — import key material — HSM-to-HSM transfer
  - 5.3.2.3.1 Key Transfer Blob — EC-wrapped — secure import protocol

#### 5.3.3 Key Vault Secrets & Certificates
- 5.3.3.1 Secrets — arbitrary value — versioned — 25KB max
  - 5.3.3.1.1 Content-type — tag type — differentiate connection strings from passwords
- 5.3.3.2 Certificates — managed TLS certs — auto-renewal with DigiCert/GlobalSign
  - 5.3.3.2.1 App Service binding — Key Vault reference — auto-renew without redeploy
  - 5.3.3.2.2 Let's Encrypt integration — 3rd party issuer — 90-day auto-renew

#### 5.3.4 Key Vault Access Control
- 5.3.4.1 RBAC model — Key Vault Secrets User/Officer/Administrator roles (recommended)
- 5.3.4.2 Vault access policy model — legacy — principal-level operations
- 5.3.4.3 Private Endpoint — no public access — VNet-injected key operations
  - 5.3.4.3.1 Firewall bypass — trusted Microsoft services — Azure Backup, Disk Encryption

### 5.4 Managed Identities
#### 5.4.1 Managed Identity Types
- 5.4.1.1 System-assigned — lifecycle tied to resource — auto-deleted on resource delete
  - 5.4.1.1.1 Token endpoint — http://169.254.169.254/metadata/identity — IMDS
  - 5.4.1.1.2 No credential management — platform rotates certificate
- 5.4.1.2 User-assigned — standalone resource — assigned to multiple resources
  - 5.4.1.2.1 Reuse across resources — consistent identity for resource group
  - 5.4.1.2.2 Pre-assign before deployment — avoid race conditions

### 5.5 Network Security
#### 5.5.1 Azure DDoS Protection
- 5.5.1.1 Basic — always on — platform-level — free — no SLA
- 5.5.1.2 Network (Standard) — per-VNet — $2944/month — SLA + cost protection
  - 5.5.1.2.1 Adaptive tuning — ML baseline per public IP — auto-mitigation
  - 5.5.1.2.2 Rapid response — DRR team — attack during active mitigation
  - 5.5.1.2.3 Attack analytics — real-time metrics — mitigation flows

#### 5.5.2 Microsoft Defender for Cloud
- 5.5.2.1 CSPM — Cloud Security Posture Management — secure score
  - 5.5.2.1.1 Security recommendations — prioritized — effort vs. impact matrix
  - 5.5.2.1.2 Regulatory compliance — mapping to CIS, NIST, PCI, ISO
- 5.5.2.2 CWP — Cloud Workload Protection — per-resource Defender plans
  - 5.5.2.2.1 Defender for Servers — P1 (Log Analytics) / P2 (MDE + vulnerability)
  - 5.5.2.2.2 Defender for Containers — K8s runtime protection — image scanning
  - 5.5.2.2.3 Defender for Databases — SQL, Cosmos, Redis, OSS DB anomaly detection
- 5.5.2.3 DevSecOps — GitHub/ADO integration — IaC scanning, secret detection
  - 5.5.2.3.1 Defender for DevOps — pipeline posture — SARIF upload to Defender

#### 5.5.3 Microsoft Sentinel
- 5.5.3.1 Cloud-native SIEM + SOAR — Log Analytics workspace backend
  - 5.5.3.1.1 Data connectors — 200+ — Entra, Office 365, Defender, 3rd party SIEM
  - 5.5.3.1.2 Billing — per GB ingested — Basic Logs tier for high-volume cheap data
- 5.5.3.2 Analytics rules — KQL-based — scheduled or ML anomaly — generate incidents
  - 5.5.3.2.1 Fusion — ML correlation — multi-stage attack detection
  - 5.5.3.2.2 UEBA — user and entity behavior analytics — anomaly baseline
- 5.5.3.3 Playbooks — Logic App automation — auto-respond to incidents
  - 5.5.3.3.1 Trigger — incident created/updated — entity trigger
  - 5.5.3.3.2 SOAR actions — isolate host, block IP, revoke token, create ticket
