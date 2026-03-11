# AWS Complete Study Guide - Part 16: Phase 2 — CloudFormation/CDK, Organizations, Security & Cost

## 35.0 AWS CloudFormation & CDK

### 35.1 CloudFormation Core
→ See Ideal §12.1 CloudFormation, §12.1.1 Template Anatomy, §12.1.2 Stack Operations

#### 35.1.1 CloudFormation-Unique Features
- **Unique: CloudFormation Guard (cfn-guard)** — policy-as-code — validate templates pre-deploy
  - 35.1.1.1 Guard rules language — when/then clauses — custom compliance checks
  - 35.1.1.2 cfn-guard validate — CI/CD gate — fail build on policy violation
- **Unique: CloudFormation Hooks** — pre/post operation validation — custom Lambda
  - 35.1.1.3 Hook types — PRE_CREATE, PRE_UPDATE, PRE_DELETE, PRE_PROVISION
  - 35.1.1.4 Third-party hooks — Palo Alto, Snyk — available in Registry
- **Unique: Resource Provider Development Kit (CFRPDK)**
  - 35.1.1.5 Extend CloudFormation — custom resource types — public/private registry
  - 35.1.1.6 Supports Go, Java, Python, TypeScript handlers
- **Unique: CloudFormation Public Registry** — 1000+ third-party resource types
  - 35.1.1.7 MongoDB, Datadog, Fastly — managed via CloudFormation

### 35.2 AWS CDK Core
→ See Ideal §12.2 AWS CDK, §12.2.1 CDK Architecture

#### 35.2.1 CDK-Unique Features
- **Unique: CDK Aspects** — visitor pattern — traverse construct tree post-synthesis
  - 35.2.1.1 Apply security policy globally — e.g., enforce S3 versioning everywhere
  - 35.2.1.2 Custom Annotations — warnings/errors during synthesis
- **Unique: CDK Migrate** — import existing CFN stacks/IaC into CDK app
- **Unique: CDK Watch** — hotswap deploys — Lambda/ECS — bypass CloudFormation for speed
  - 35.2.1.3 Hotswap eligible — Lambda code, ECS image, Step Functions — <5s deploy
  - 35.2.1.4 cdk watch — long-running — detects file changes — auto hotswap
- **Unique: CDK Assertions library** — unit test synthesized CloudFormation
  - 35.2.1.5 Template.fromStack() — assert resources, outputs, mappings
  - 35.2.1.6 Fine-grained assertions — hasResourceProperties — JSON path matching

---

## 36.0 AWS Organizations & Control Tower

### 36.1 Organizations Core
→ See Ideal §14.1 Organizations & SCPs, §14.2 Control Tower

#### 36.1.1 Organizations-Unique Features
- **Unique: AWS Organizations Policies (beyond SCPs)**
  - 36.1.1.1 Backup Policies — enforce AWS Backup plans — mandatory backup schedule
  - 36.1.1.2 Tag Policies — enforce tag keys/values/capitalization — compliance reporting
  - 36.1.1.3 AI Services Opt-Out Policies — prevent data use for AI model training
  - 36.1.1.4 Chatbot Policies — restrict AWS Chatbot channels
- **Unique: Delegated Administrator** — designate member account for specific services
  - 36.1.1.5 Security Hub, GuardDuty, Config, Firewall Manager — operate from security account
  - 36.1.1.6 No management account login required for security operations
- **Unique: Trusted Access** — enable AWS service integration with Organizations
  - 36.1.1.7 Services — Config, CloudTrail, RAM, Firewall Manager, Inspector, S3 Lens

---

## 37.0 AWS Security Services Deep Dive

### 37.1 AWS KMS
→ See Ideal §5.3 Key Management

#### 37.1.1 KMS-Unique Features
- **Unique: Multi-Region Keys** — same key material — different regions — decrypt in any region
  - 37.1.1.1 Primary → replicas — replicate to up to 10 regions
  - 37.1.1.2 Use case — global DynamoDB, cross-region EBS snapshot sharing
- **Unique: External Key Store (XKS)** — key material in external HSM — KMS as proxy
  - 37.1.1.3 XKS Proxy — customer operates — AWS calls proxy for crypto operations
  - 37.1.1.4 Sovereignty — key material never leaves customer HSM
- **Unique: HMAC APIs** — GenerateMac / VerifyMac — token validation without Lambda
- **Unique: Key Deletion** — 7–30 day pending deletion — no immediate delete
  - 37.1.1.5 Disable first — no new operations — no deletion waiting period

### 37.2 AWS Secrets Manager & Parameter Store
→ See Ideal §5.4 Secrets Management

#### 37.2.1 Secrets Manager-Unique Features
- **Unique: Lambda rotation templates** — single user, alternating users, master secret
  - 37.2.1.1 Multi-user strategy — create new, test, deprecate old — zero downtime
- **Unique: Secrets Manager Agent** — local cache — <1ms retrieval — reduce API costs
  - 37.2.1.2 HTTP local server — sidecar or installed — TTL-based cache refresh

### 37.3 AWS WAF, Shield & Network Firewall
→ See Ideal §5.5 Network Security, §5.6 Threat Detection

#### 37.3.1 AWS Network Firewall
- **Unique: VPC-level stateful deep packet inspection** — Suricata-compatible rules
  - 37.3.1.1 5-tuple + domain list filtering — block malware domains at network level
  - 37.3.1.2 TLS inspection — decrypt/re-encrypt — certificate authority required
  - 37.3.1.3 Centralized deployment — Transit Gateway — inspect all VPC traffic
- **Unique: Firewall Manager** — centralized WAF/SG/Shield/Network Firewall policies
  - 37.3.1.4 Scope — tag-based or OU-based — auto-remediate non-compliant accounts

---

## 38.0 AWS Cost Management Tools

### 38.1 Cost Explorer & Budgets
→ See Ideal §13.3 Cost Allocation, §13.1 Pricing Models

#### 38.1.1 Cost Tools-Unique Features
- **Unique: Cost Explorer RI/SP recommendations**
  - 38.1.1.1 Look-back period — 7/30/60 days — recommendation sensitivity
  - 38.1.1.2 Coverage vs. Utilization reports — RI effectiveness tracking
- **Unique: AWS Budgets Actions** — auto-enforce budget — IAM/SCP action on breach
  - 38.1.1.3 Apply SCP deny on budget breach — hard stop overspend
  - 38.1.1.4 Notify → confirm → execute — 3-step approval workflow
- **Unique: AWS Cost Categories** — custom grouping rules — tag + account + service
  - 38.1.1.5 Inherited value rule — propagate tag from parent account
  - 38.1.1.6 Split charge rule — distribute shared cost — proportional/fixed/even
- **Unique: S3 Storage Lens** — cross-account/cross-region S3 analytics — 29 metrics
  - 38.1.1.7 Advanced metrics — $0.20/million objects — activity, cost optimization
  - 38.1.1.8 Recommendations — identify misconfigured buckets, versioning gaps
- **Unique: AWS Cost Optimization Hub** — centralized recommendations — estimated savings
  - 38.1.1.9 Aggregates — Compute Optimizer + RI/SP + Rightsize — single view
  - 38.1.1.10 Savings estimate — 12-month projected — filter by service/account/region
