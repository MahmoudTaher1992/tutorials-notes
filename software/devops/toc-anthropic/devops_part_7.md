# DevOps Engineering Study Guide - Part 7: Phase 1 — IaC & Configuration Management

## 5.0 Infrastructure as Code

### 5.1 IaC Concepts & State Management
#### 5.1.1 Declarative vs. Imperative IaC
- 5.1.1.1 Declarative — describe desired state — tool reconciles — idempotent
  - 5.1.1.1.1 Convergent application — re-run = same result — safe repeated runs
  - 5.1.1.1.2 Idempotency proof — no-op on second apply if no drift
- 5.1.1.2 Imperative — ordered commands — procedural — fragile to partial failure
  - 5.1.1.2.1 Ansible in imperative mode — when: conditions + register — stateful scripts

#### 5.1.2 State Management
- 5.1.2.1 State file — map desired → actual resource IDs — critical data
  - 5.1.2.1.1 Remote state — S3 / GCS / Azure Blob / Terraform Cloud — team sharing
  - 5.1.2.1.2 State locking — DynamoDB / etcd — prevent concurrent apply — corruption
  - 5.1.2.1.3 State encryption — SSE-S3 / KMS — sensitive values in state
- 5.1.2.2 State operations — terraform state mv / rm / import — manual reconcile
  - 5.1.2.2.1 terraform import — bring existing resource under management
  - 5.1.2.2.2 State drift — actual ≠ state — terraform plan detects — refresh

### 5.2 Terraform Core Internals
#### 5.2.1 Terraform Architecture
- 5.2.1.1 Core — parse HCL — build graph — call providers
  - 5.2.1.1.1 Resource graph — DAG — dependency ordering — parallel where possible
  - 5.2.1.1.2 Plan — diff state + config → change set — human review before apply
  - 5.2.1.1.3 Apply — execute changes in dependency order — update state on success
- 5.2.1.2 Provider — plugin — gRPC — resource CRUD + schema
  - 5.2.1.2.1 Provider protocol v6 — plugin framework — required/optional attrs
  - 5.2.1.2.2 Provider lock file — .terraform.lock.hcl — pin provider versions
  - 5.2.1.2.3 Custom provider — Terraform Plugin Framework — Go — any API
- 5.2.1.3 HCL — HashiCorp Config Language — typed — functions + expressions
  - 5.2.1.3.1 for_each — map/set — dynamic resource creation — keyed instances
  - 5.2.1.3.2 dynamic blocks — generate nested config — variable-length structures
  - 5.2.1.3.3 locals — intermediate values — avoid repetition — computed expressions

#### 5.2.2 Terraform Modules
- 5.2.2.1 Module — reusable component — inputs + outputs + resources
  - 5.2.2.1.1 Root module — top-level — calls child modules
  - 5.2.2.1.2 Remote modules — Terraform Registry / Git / S3 — versioned
  - 5.2.2.1.3 Module composition — pass outputs as inputs — loosely coupled
- 5.2.2.2 Terragrunt — wrapper — DRY configs — remote state management
  - 5.2.2.2.1 terragrunt.hcl — inherit root config — reduce boilerplate
  - 5.2.2.2.2 run-all — apply across module tree — dependency-ordered

#### 5.2.3 Terraform Workspaces & Environments
- 5.2.3.1 Workspaces — separate state per workspace — dev/staging/prod
  - 5.2.3.1.1 terraform.workspace — conditional resources — env-specific config
  - 5.2.3.1.2 Workspace isolation limits — same config = not ideal for major env diffs
- 5.2.3.2 Variable files — .tfvars — per-env — -var-file= flag
  - 5.2.3.2.1 Secret vars — TF_VAR_ env vars — CI/CD injection — never commit

### 5.3 Pulumi & CDK
#### 5.3.1 Pulumi Architecture
- 5.3.1.1 Pulumi — real programming language — TypeScript/Python/Go/C# — IaC
  - 5.3.1.1.1 Pulumi engine — diff state — apply delta — same model as Terraform
  - 5.3.1.1.2 ComponentResource — reusable higher-order infra — class-based abstraction
  - 5.3.1.1.3 StackReferences — cross-stack outputs — share VPC ID across stacks
- 5.3.1.2 Testing — unit tests with mocks — integration tests — policy as code
  - 5.3.1.2.1 Unit test — mock provider — test logic without deploying — fast CI

#### 5.3.2 AWS CDK / CDKTF
- 5.3.2.1 CDK — TypeScript/Python constructs → CloudFormation — L1/L2/L3 levels
  - 5.3.2.1.1 L1 (Cfn*) — 1:1 CloudFormation — low abstraction
  - 5.3.2.1.2 L2 — sensible defaults — VPC / ECS / RDS — recommended
  - 5.3.2.1.3 L3 (patterns) — opinionated — ECS + ALB + IAM — one construct
- 5.3.2.2 CDKTF — CDK for Terraform — TypeScript constructs → Terraform JSON

---

## 6.0 Configuration Management

### 6.1 Agent vs. Agentless
#### 6.1.1 Agent-based (Chef / Puppet)
- 6.1.1.1 Chef — client/server — cookbook — recipe — converge loop
  - 6.1.1.1.1 Chef client — runs every 30 min — applies recipes — idempotent resources
  - 6.1.1.1.2 Ohai — system discovery — facts — used in cookbook logic
- 6.1.1.2 Puppet — catalog — manifest — module — declarative DSL
  - 6.1.1.2.1 Puppet master — compile catalog — send to agent — enforce
  - 6.1.1.2.2 Resource types — package/file/service — idempotent — dependency graph

#### 6.1.2 Agentless (Ansible / SSH)
- 6.1.2.1 Ansible — SSH/WinRM — push model — YAML playbooks — no agent
  - 6.1.2.1.1 Inventory — static file or dynamic — group vars — host vars
  - 6.1.2.1.2 Playbook — plays + tasks — ordered — idempotent modules
  - 6.1.2.1.3 Roles — directory structure — reusable — Ansible Galaxy
  - 6.1.2.1.4 Handlers — notify on change — restart service once at end of play
- 6.1.2.2 Connection plugins — ssh / paramiko / docker — transport layer

### 6.2 Secret Injection & Config Templating
#### 6.2.1 Ansible Vault & Templating
- 6.2.1.1 ansible-vault — encrypt vars file — AES-256 — commit encrypted
  - 6.2.1.1.1 vault-id — multiple vault passwords — granular access
- 6.2.1.2 Jinja2 templates — {{ variable }} — conditionals — loops — generate config
  - 6.2.1.2.1 template module — render + deploy to node — md5 change detection

#### 6.2.2 Drift Detection & Remediation
- 6.2.2.1 Continuous compliance — run Ansible nightly — detect + fix drift
  - 6.2.2.1.1 --check mode — dry run — report drift without changing
  - 6.2.2.1.2 --diff mode — show changed file content — visibility into change
- 6.2.2.2 Terraform drift — terraform plan -refresh-only — diff current vs. desired
  - 6.2.2.2.1 Auto-remediate — terraform apply -refresh-only — restore desired state
