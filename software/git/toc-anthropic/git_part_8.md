# Git & Git Hosting Services - Part 8: GitHub Security & GitLab

## 12.0 GitHub Security

### 12.1 GitHub Advanced Security (GHAS)
#### 12.1.1 Code Scanning (CodeQL)
- 12.1.1.1 CodeQL — semantic code analysis — query language — find vulnerability patterns
  - 12.1.1.1.1 codeql-analysis.yml — default workflow — auto-detect language — PR + push scan
  - 12.1.1.1.2 Built-in queries — CWE coverage — SQL injection / XSS / path traversal / etc.
  - 12.1.1.1.3 Custom queries — .ql files — org-specific patterns — proprietary vulnerability checks
- 12.1.1.2 Third-party SARIF — any tool → SARIF format → upload to GitHub — unified results
  - 12.1.1.2.1 upload-sarif action — github/codeql-action/upload-sarif — surface in Security tab
- 12.1.1.3 Dismissing alerts — false positive / won't fix — reason required — audit trail

#### 12.1.2 Secret Scanning
- 12.1.2.1 Push protection — block push containing known secret pattern — pre-push gate
  - 12.1.2.1.1 Partner patterns — 200+ providers — AWS / Azure / GCP / Stripe / Twilio — known formats
  - 12.1.2.1.2 Custom patterns — regex — catch internal tokens — org-defined secret formats
  - 12.1.2.1.3 Bypass — require justification — audit log entry — emergency access only
- 12.1.2.2 Validity checks — probe provider API — confirm if secret still active — prioritize
  - 12.1.2.2.1 Active secret = critical — revoke immediately — inactive = low priority
- 12.1.2.3 Non-provider patterns — high entropy strings — configurable — reduce false negatives

### 12.2 Dependabot
#### 12.2.1 Dependency Updates
- 12.2.1.1 Dependabot alerts — known CVE in dependency — GHSA database — severity + fix version
  - 12.2.1.1.1 Auto-dismiss — low severity + no exploitable path — reduce noise — configurable
- 12.2.1.2 Dependabot security updates — auto-PR for vulnerable dependency — one-click merge
  - 12.2.1.2.1 Grouped updates — multiple deps in one PR — ecosystem grouping — reduces PR count
- 12.2.1.3 Dependabot version updates — scheduled non-security updates — keep deps current
  - 12.2.1.3.1 .github/dependabot.yml — package-ecosystem / directory / schedule — per-ecosystem
  - 12.2.1.3.2 Ignore rules — ignore certain packages / versions — stability over currency
  - 12.2.1.3.3 Auto-merge — merge passing minor/patch updates — manual for major — policy

---

## 13.0 GitLab

### 13.1 GitLab CI/CD
#### 13.1.1 Pipeline Architecture
- 13.1.1.1 .gitlab-ci.yml — pipeline definition — stages + jobs — root of repo — YAML
  - 13.1.1.1.1 stages: — ordered list — all jobs in stage run in parallel — next stage after all pass
  - 13.1.1.1.2 Job — stage + script — artifact — environment — rules — the execution unit
  - 13.1.1.1.3 include: — import shared configs — project / local / remote / template — DRY
- 13.1.1.2 Rules vs. only/except — rules: preferred — condition-based — more expressive
  - 13.1.1.2.1 rules: if: '$CI_PIPELINE_SOURCE == "merge_request_event"' — MR-only job
  - 13.1.1.2.2 rules: changes: — run only if specified file paths changed — selective CI
  - 13.1.1.2.3 workflow: rules: — control entire pipeline creation — skip for docs-only changes

#### 13.1.2 Runners
- 13.1.2.1 GitLab runners — executor types — shell / Docker / Kubernetes / VirtualBox
  - 13.1.2.1.1 Docker executor — run job in container — clean environment — most common
  - 13.1.2.1.2 Kubernetes executor — job pod per CI job — autoscale — cloud-native
  - 13.1.2.1.3 Runner tags — assign jobs to specific runner pools — GPU / macOS / windows
- 13.1.2.2 GitLab SaaS runners — shared / minutes-based — free tier 400 min/month
  - 13.1.2.2.1 Large runners — 4/8 cores — extra minutes consumed — spot instances available

### 13.2 Merge Requests & Features
#### 13.2.1 Merge Requests
- 13.2.1.1 MR vs PR — same concept — GitLab term — more CI integration — built-in environments
  - 13.2.1.1.1 MR pipeline — dedicated pipeline per MR — merge_request_event source — isolated
  - 13.2.1.1.2 Merge when pipeline succeeds — queue merge — auto-complete on green — efficiency
- 13.2.1.2 Merge trains — queue multiple MRs — test in combined state — no integration failure
  - 13.2.1.2.1 Train position — MR queued — tested with all ahead-in-train commits — safe merge
  - 13.2.1.2.2 Fast-forward merge train — no merge commits — linear history — clean log
- 13.2.1.3 Approval rules — require N approvals — specific users / roles / CODEOWNERS integration
  - 13.2.1.3.1 Approval groups — specific teams must approve — compliance requirement — enforced

### 13.3 GitLab Environments & DORA
#### 13.3.1 Environments
- 13.3.1.1 Environment definition — environment: name: production url: — track deployments
  - 13.3.1.1.1 Protected environments — only certain roles can deploy — mandatory approvals
  - 13.3.1.1.2 Review apps — dynamic environment per MR — ephemeral — demo + test branch
- 13.3.1.2 DORA metrics — GitLab tracks automatically — deployment frequency / lead time / MTTR
  - 13.3.1.2.1 Deployment frequency — deploys to production per day — engineering velocity
  - 13.3.1.2.2 Lead time for changes — commit to production — reduce with trunk-based dev
  - 13.3.1.2.3 Change failure rate — % deployments causing incident — quality signal
  - 13.3.1.2.4 MTTR — time to restore service — incident resolution speed — reliability
