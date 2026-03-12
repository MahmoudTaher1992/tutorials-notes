# GCP Complete Study Guide - Part 5: Security & Identity (Phase 1 — Ideal)

## 5.0 Security & Identity

### 5.1 IAM (Principals, Roles, Policies)
#### 5.1.1 IAM Principal Types
- 5.1.1.1 Google Account — personal Gmail or Workspace — human user
- 5.1.1.2 Service Account — machine identity — managed by Google or user
  - 5.1.1.2.1 Google-managed SA — auto-rotated keys — service agents
  - 5.1.1.2.2 User-managed SA — explicit creation — 10 keys max — rotate manually
  - 5.1.1.2.3 SA impersonation — roles/iam.serviceAccountTokenCreator — act as SA
- 5.1.1.3 Google Group — collection — batch permission assignment
- 5.1.1.4 allUsers / allAuthenticatedUsers — public access principals — avoid
- 5.1.1.5 Workforce Identity Pool — external IdP users — OIDC/SAML — no Google accounts
  - 5.1.1.5.1 Mapped attributes — google.groups, google.email — CEL expressions

#### 5.1.2 IAM Roles
- 5.1.2.1 Primitive roles — Owner/Editor/Viewer — coarse — legacy — avoid
- 5.1.2.2 Predefined roles — service-specific — roles/storage.objectViewer
  - 5.1.2.2.1 900+ predefined roles — updated by Google as services evolve
- 5.1.2.3 Custom roles — org or project scope — curated permissions
  - 5.1.2.3.1 Launch stages — alpha/beta/GA permissions — unstable in custom roles
  - 5.1.2.3.2 300 permission max per custom role
- 5.1.2.4 Role conditions — CEL expressions — time-based, resource.name, ip
  - 5.1.2.4.1 Temporary access — expiry in condition — JIT access pattern
  - 5.1.2.4.2 Resource name conditions — grant access to specific bucket only

#### 5.1.3 IAM Policy Structure
- 5.1.3.1 Policy — bindings[] + auditConfigs + etag — JSON/YAML
  - 5.1.3.1.1 Binding — role + members[] + condition — one per role
  - 5.1.3.1.2 etag — optimistic concurrency — prevent blind overwrites
- 5.1.3.2 Policy hierarchy — Organization → Folder → Project → Resource
  - 5.1.3.2.1 Union of grants — all ancestor bindings apply — no deny inheritance
  - 5.1.3.2.2 Parent cannot restrict child — child can grant more than parent
- 5.1.3.3 Deny policies — explicit deny — override allows — newer feature
  - 5.1.3.3.1 DenyRule — deniedPermissions + exceptions + denialCondition
  - 5.1.3.3.2 Deny evaluated after allow — deny wins — attach at org/folder level

### 5.2 Workload Identity Federation
#### 5.2.1 WIF Architecture
- 5.2.1.1 Exchange external token for Google access token — no SA key needed
  - 5.2.1.1.1 Supported IdPs — AWS, Azure AD, GitHub Actions, GitLab, Kubernetes
  - 5.2.1.1.2 OIDC or SAML 2.0 — token exchange — Security Token Service (STS)
- 5.2.1.2 Identity Pool — container for external identities
  - 5.2.1.2.1 Pool provider — OIDC endpoint + allowed audiences
  - 5.2.1.2.2 Attribute mapping — google.subject = assertion.sub
- 5.2.1.3 Direct resource access — principal set conditions — no SA impersonation needed
  - 5.2.1.3.1 principalSet://iam.googleapis.com/projects/*/workloadIdentityPools/...

### 5.3 Cloud KMS & Cloud HSM
#### 5.3.1 Cloud KMS Key Hierarchy
- 5.3.1.1 Key Ring → Key → Key Version — logical grouping
  - 5.3.1.1.1 Key Ring location — regional/multi-region/global — matches data
  - 5.3.1.1.2 Key purpose — ENCRYPT_DECRYPT, ASYMMETRIC_SIGN, ASYMMETRIC_DECRYPT, MAC
- 5.3.1.2 Key algorithms — AES-256-GCM, RSA 2048/3072/4096, EC P-256/P-384
  - 5.3.1.2.1 Primary version — active — encrypt uses this — older versions decrypt
  - 5.3.1.2.2 Auto-rotation — schedule — new version created, old remains active
- 5.3.1.3 Envelope encryption — DEK encrypted by KEK (KMS key)
  - 5.3.1.3.1 Encrypt — generate DEK → encrypt data → encrypt DEK via KMS
  - 5.3.1.3.2 Decrypt — call KMS to decrypt DEK → decrypt data locally

#### 5.3.2 Cloud HSM & Cloud EKM
- 5.3.2.1 Cloud HSM — FIPS 140-2 Level 3 — HSM-protected keys in Cloud KMS
  - 5.3.2.1.1 Same API as KMS — add --protection-level HSM — transparent
- 5.3.2.2 Cloud External Key Manager (EKM) — key material in external HSM
  - 5.3.2.2.1 VPC-SC protected EKM — route via PrivateLink to on-prem HSM
  - 5.3.2.2.2 Coordinated EKM — Google holds encrypted key — EKM holds decryption

### 5.4 Secret Manager
#### 5.4.1 Secret Manager Architecture
- 5.4.1.1 Global secret — replicated across all regions — automatic
  - 5.4.1.1.1 User-managed replication — specify regions — data residency compliance
- 5.4.1.2 Secret versions — immutable — enabled/disabled/destroyed
  - 5.4.1.2.1 Destroy — permanently delete payload — metadata retained
  - 5.4.1.2.2 Access by version — latest or specific numeric version
- 5.4.1.3 Rotation notifications — Pub/Sub topic — trigger Lambda-like rotation
  - 5.4.1.3.1 Rotation schedule — rotation_period + next_rotation_time
- 5.4.1.4 Customer-managed encryption — CMEK via Cloud KMS per secret
- 5.4.1.5 Regional Secrets — secrets stored in specific region — data residency

### 5.5 Network Security
#### 5.5.1 Identity-Aware Proxy (IAP)
- 5.5.1.1 Zero-trust access — authenticate before reaching application — no VPN
  - 5.5.1.1.1 TCP forwarding — SSH/RDP through IAP — no public IP on VM
  - 5.5.1.1.2 Context-aware access — device posture, location, attributes — CEL
- 5.5.1.2 IAP for HTTPS — authenticate HTTP traffic — OIDC token injection
  - 5.5.1.2.1 x-goog-iap-jwt-assertion header — verify in application
  - 5.5.1.2.2 Cloud Run integration — require IAP auth before traffic reaches service

#### 5.5.2 VPC Service Controls (VPC-SC)
- 5.5.2.1 Service perimeter — restrict Google APIs to authorized VPCs/users
  - 5.5.2.1.1 Dry-run mode — audit without blocking — shadow enforcement
  - 5.5.2.1.2 Access policies — org-level — multiple perimeters per org
- 5.5.2.2 Access levels — define trusted contexts — IP ranges, devices, users
  - 5.5.2.2.1 Ingress rules — allow external → perimeter — specific service+action
  - 5.5.2.2.2 Egress rules — allow perimeter → external — copy to BigQuery export

### 5.6 Security Command Center (SCC) & Chronicle
#### 5.6.1 Security Command Center
- 5.6.1.1 Security posture — vulnerability + threat findings across GCP
  - 5.6.1.1.1 Built-in detectors — public buckets, open firewall, weak passwords
  - 5.6.1.1.2 Security Health Analytics — CIS GCP benchmark — 100+ checks
- 5.6.1.2 Threat Detection — Event Threat Detection + Container Threat Detection
  - 5.6.1.2.1 ETD — Cloud Logging-based — crypto mining, data exfiltration, brute force
  - 5.6.1.2.2 CTD — GKE kernel-level — malicious binaries, privilege escalation
- 5.6.1.3 Attack exposure score — quantify risk — prioritize by blast radius
  - 5.6.1.3.1 Attack path simulation — model attacker movement — critical asset focus
- 5.6.1.4 Posture Management — deploy + monitor security posture YAML
  - 5.6.1.4.1 Posture policies — bundle org constraints + SCC custom modules

#### 5.6.2 Chronicle SIEM
- 5.6.2.1 Cloud-native SIEM — petabyte-scale — flat pricing — Google infrastructure
  - 5.6.2.1.1 UDM (Unified Data Model) — normalized events — vendor-agnostic
  - 5.6.2.1.2 YARA-L 2.0 — detection rules — multi-event correlation — sliding windows
- 5.6.2.2 Chronicle SOAR — playbooks — automated response — 400+ integrations
  - 5.6.2.2.1 Case management — alert → entity enrichment → respond → close
  - 5.6.2.2.2 Siemplify-based — acquired 2022 — playbook + manual actions

### 5.7 Compliance & Governance
#### 5.7.1 Organization Policy Service
- 5.7.1.1 Constraints — boolean or list — restrict resource config at org/folder/project
  - 5.7.1.1.1 compute.requireShieldedVm — enforce Shielded VMs org-wide
  - 5.7.1.1.2 iam.allowedPolicyMemberDomains — restrict IAM to specific domains
- 5.7.1.2 Custom org constraints — IAM Conditions-like — CEL — any resource field
  - 5.7.1.2.1 Write your own: resource.name, resource.type, resource.properties
- 5.7.1.3 Policy tags — Data Catalog — column-level access in BigQuery
  - 5.7.1.3.1 Fine-grained reader/masked reader roles — PII column protection
