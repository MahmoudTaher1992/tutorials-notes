# OCI Complete Study Guide - Part 12: Phase 2 — Security & Observability

## 14.0 OCI Security

### 14.1 OCI IAM-Unique Features
→ See Ideal §5.1 IAM, §5.2 Identity Domains, §5.3 Vault, §5.4 Cloud Guard, §5.5 Bastion

#### 14.1.1 Compartment Model-Unique Features
- **Unique: Compartments** — OCI-exclusive hierarchy — resource isolation + IAM scope
  - 14.1.1.1 Nested compartments — up to 6 levels — inherit parent IAM policies
  - 14.1.1.2 No equivalent in AWS/Azure — OCI's unique organizational primitive
  - 14.1.1.3 Compartment quotas — limit instance count/DB count per compartment — FinOps
- **Unique: IAM policy language** — Allow group G to verb resource-type in compartment C
  - 14.1.1.4 Verb hierarchy — inspect < read < use < manage — additive permissions
  - 14.1.1.5 Explicit DENY — DENY statement — overrides any allow — fine-grained
  - 14.1.1.6 Cross-tenancy policies — endorse + admit — partner tenancy access
- **Unique: Dynamic Groups** — instance principal — group by resource attributes
  - 14.1.1.7 Instance.compartment.id condition — scope DG to compartment — least privilege
  - 14.1.1.8 Function principal — DG for functions — keyless access to OCI services
- **Unique: Tag-based IAM conditions** — policy condition on defined tags
  - 14.1.1.9 where target.resource.tag.namespace.key = 'value' — attribute-based access

#### 14.1.2 Identity Domains-Unique Features
- **Unique: App catalog** — 100+ pre-integrated SaaS apps — SSO + SCIM provisioning
  - 14.1.2.1 Oracle SaaS native — Fusion/EBS/JDE — seamless SSO — no 3rd-party IdP
  - 14.1.2.2 Domain replication — home region → subscribed regions — HA federation
- **Unique: Oracle Mobile Authenticator** — push notification MFA — OCI native app
  - 14.1.2.3 Offline TOTP fallback — no network required — continue working offline
- **Unique: Adaptive intelligence** — risk-based auth — device fingerprint + geolocation
  - 14.1.2.4 Sign-on policy — conditions → challenge or block — per application

#### 14.1.3 Vault-Unique Features
- **Unique: Virtual Private Vault** — dedicated HSM partition — per-tenant isolation
  - 14.1.3.1 FIPS 140-2 Level 3 HSM — key material sealed — non-exportable
  - 14.1.3.2 Cross-region replication of secrets — Vault replication — DR access
- **Unique: External Key Management (EKMS)** — key stored on-prem HSM — OCI calls out
  - 14.1.3.3 HYOK (Hold Your Own Key) — OCI never sees plaintext key — compliance
  - 14.1.3.4 Thales + Entrust EKMS partners — OCI-managed EKMS endpoint
- **Unique: Secret rotation with Functions** — function trigger on expiry — auto-rotate
  - 14.1.3.5 Custom rotation logic — update DB password + increment secret version

#### 14.1.4 Cloud Guard-Unique Features
- **Unique: Responder recipes** — auto-remediate — delete public bucket, stop instance
  - 14.1.4.1 Conditional responder — only remediate if tagged with auto-remediate=true
  - 14.1.4.2 Notifications — Slack/PagerDuty via Notification topic — SOC integration
- **Unique: Security Zones** — deny risky operations at API level — preventive control
  - 14.1.4.3 Max Security recipe — block public buckets, require CMEK, deny non-private subnet
  - 14.1.4.4 Custom recipe — mix policies — right-size restrictions per team
- **Unique: Cloud Guard + Security Advisor** — combined recommendations — guided fix
  - 14.1.4.5 Security score — % compliant resources — dashboard — executive view

---

## 15.0 OCI Observability

### 15.1 OCI Monitoring-Unique Features
→ See Ideal §6.1 Monitoring, §6.2 Logging, §6.3 APM

#### 15.1.1 Monitoring-Unique Features
- **Unique: MQL (Monitoring Query Language)** — time-series operations — groupBy + rate()
  - 15.1.1.1 Absence detection — absent() — alert if metric stops reporting — OCI native
  - 15.1.1.2 Metric math — combine namespaces — composite alarms — OCI native
- **Unique: Alarm suppression** — suppress during maintenance — avoid false pages
  - 15.1.1.3 Suppression window — start + end time — alarm state preserved but not notified
- **Unique: Oracle Database metrics** — DB-specific — AAS, wait events, CDB/PDB metrics
  - 15.1.1.4 oci_database namespace — Exadata + ADB metrics — out-of-box DB observability

#### 15.1.2 Logging-Unique Features
- **Unique: Log Analytics** — integrated SIEM — 200+ log source parsers — no extra SIEM
  - 15.1.2.1 Oracle-specific parsers — Oracle DB alert log, Audit log, WebLogic — built-in
  - 15.1.2.2 Log Explorer cluster command — auto-group similar logs — anomaly surface
  - 15.1.2.3 Machine learning — infrequent patterns — surface rare events — threat hunting
- **Unique: Audit log always-on** — all API calls — 90-day retention — non-configurable
  - 15.1.2.4 Audit event — who + what + when + source IP + compartment — full trail
  - 15.1.2.5 Export via Service Connector Hub → Object Storage — long-term archive
- **Unique: Service Connector Hub** — pipeline — log/metric/stream → target
  - 15.1.2.6 Log → Object Storage — automatic batching — cost-efficient archival
  - 15.1.2.7 Log → Functions — real-time processing — alerting + enrichment pipeline

#### 15.1.3 APM-Unique Features
- **Unique: APM Domain + private data key** — per-domain — secure agent communication
  - 15.1.3.1 Public vs. private data key — browser agents use public — server use private
- **Unique: OCI Trace Explorer** — flame graph + waterfall — correlation with logs
  - 15.1.3.2 Correlated log search — trace → open Log Analytics in context — root cause
- **Unique: Synthetic Monitoring** — vantage points — on-demand or scheduled
  - 15.1.3.3 Scripted browser monitor — Selenium WebDriver — multi-step user journey
  - 15.1.3.4 REST API monitor — OCI-managed probers — global coverage — latency map
