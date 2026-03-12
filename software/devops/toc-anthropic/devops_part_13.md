# DevOps Engineering Study Guide - Part 13: Phase 2 — Terraform & Ansible

## 18.0 Terraform & Ansible

### 18.1 Terraform
→ See Ideal §5.1 Terraform Core, §5.2 Modules, §5.3 Workspaces

#### 18.1.1 Terraform-Unique Features
- **Unique: HCL language** — typed — functions — meta-arguments — provider schema
  - 18.1.1.1 moved block — refactor without destroy — rename resource in state
  - 18.1.1.2 check block — post-apply assertions — validate external conditions
  - 18.1.1.3 import block (TF 1.5+) — declarative import — generate config from existing
- **Unique: Provider ecosystem** — 3000+ providers — Terraform Registry — versioned
  - 18.1.1.4 Provider aliases — multiple AWS accounts — same provider, different configs
  - 18.1.1.5 Null provider — null_resource — triggers — local-exec provisioner
- **Unique: Terraform Cloud / Enterprise** — remote state + runs — team collaboration
  - 18.1.1.6 Remote execution — Terraform Cloud runs plan/apply — audit trail
  - 18.1.1.7 Sentinel policies — policy as code — block non-compliant plans — enterprise
  - 18.1.1.8 Cost estimation — show cost delta before apply — FinOps in pipeline
- **Unique: State manipulation commands**
  - 18.1.1.9 terraform state mv — rename/move resource — no destroy + recreate
  - 18.1.1.10 terraform taint (deprecated) → terraform apply -replace — force recreate
  - 18.1.1.11 terraform console — interactive REPL — test expressions — debug
- **Unique: Data sources** — read existing infra — not managed — reference in config
  - 18.1.1.12 data.aws_ami — lookup latest AMI — always fresh — no hardcode
  - 18.1.1.13 Refresh on plan — data sources re-fetched — catch external changes
- **Unique: Lifecycle meta-arguments** — fine-grained resource behavior
  - 18.1.1.14 create_before_destroy — zero-downtime replacement — new then old deleted
  - 18.1.1.15 prevent_destroy — block accidental delete — stateful resources — DB
  - 18.1.1.16 ignore_changes — ignore drift on specific attrs — auto-scaling managed fields
- **Unique: for_each vs. count**
  - 18.1.1.17 for_each — keyed instances — stable resource address — safe add/remove
  - 18.1.1.18 count — indexed — fragile — removing middle index shifts all above

---

## 19.0 Ansible

### 19.1 Ansible Engine
→ See Ideal §6.0 Configuration Management, §6.1 Agent vs Agentless, §6.2 Secret Injection

#### 19.1.1 Ansible-Unique Features
- **Unique: Agentless SSH execution** — no persistent agent — connect + run + disconnect
  - 19.1.1.1 Connection multiplexing — ControlMaster — reuse SSH connection — faster
  - 19.1.1.2 Pipelining — send module as stdin — fewer SSH round trips — speed
- **Unique: Module library** — 5000+ modules — idempotent — OS/cloud/network/app
  - 19.1.1.3 ansible.builtin.template — Jinja2 render — deploy to node — md5 diff
  - 19.1.1.4 ansible.builtin.uri — HTTP tasks — API calls in playbook — REST automation
  - 19.1.1.5 community.docker — manage containers + images — Docker module
- **Unique: Inventory plugins** — dynamic inventory — AWS/GCP/Azure/LDAP — live
  - 19.1.1.6 aws_ec2 plugin — describe-instances — tag filter — group by tag value
  - 19.1.1.7 constructed plugin — compose — create groups from existing inventory
- **Unique: Execution environments (EE)** — container-based — portable — consistent
  - 19.1.1.8 ansible-builder — build EE image — collections + Python deps baked in
  - 19.1.1.9 ansible-runner — execute EE — containerized — AWX/AAP uses EEs
- **Unique: AWX / Ansible Automation Platform (AAP)** — GUI + API + RBAC + scheduling
  - 19.1.1.10 Workflow templates — multi-playbook — conditions + approval gates
  - 19.1.1.11 Surveys — interactive variables — form at launch — parameterize runs
  - 19.1.1.12 Job templates — encapsulate playbook + inventory + credentials — reuse
- **Unique: Collections** — distribution unit — roles + modules + plugins — Ansible Galaxy
  - 19.1.1.13 requirements.yml — declare collection deps — ansible-galaxy collection install
  - 19.1.1.14 Private Automation Hub — host internal collections — enterprise air-gap
- **Unique: Ansible Vault** — encrypt strings/files — commit encrypted secrets to Git
  - 19.1.1.15 vault_password_file — read password from script — integrate with Vault/KMS
  - 19.1.1.16 Inline encrypted vars — !vault tag — mix encrypted + plain in vars file
- **Unique: Strategy plugins** — linear (default) / free / host_pinned / mitogen
  - 19.1.1.17 free strategy — don't wait for all hosts — fastest host proceeds — async
  - 19.1.1.18 mitogen — Python import — 7x faster — drop-in — connection reuse
- **Unique: Molecule** — test Ansible roles — multiple drivers — Docker / EC2 / Vagrant
  - 19.1.1.19 Molecule test sequence — create → converge → verify → destroy — CI-ready
  - 19.1.1.20 testinfra / Ansible verify — assert file exists / service running / port open
