# DevOps Engineering Study Guide - Part 11: Phase 2 — Git Platforms & CI/CD Engines

## Phase 2: Specific Tool Implementations

---

## 14.0 Git Platforms

### 14.1 GitHub
→ See Ideal §1.1 Git Internals, §1.2 Branching Strategies, §1.4 Hooks

#### 14.1.1 GitHub-Unique Features
- **Unique: GitHub Actions** — native CI/CD — YAML workflows — event-driven
  - 14.1.1.1 Events — push/pull_request/schedule/workflow_dispatch/repository_dispatch
  - 14.1.1.2 Reusable workflows — call from other repos — centralized pipeline templates
  - 14.1.1.3 OIDC federation — GitHub → AWS/GCP/Azure — keyless short-lived tokens
- **Unique: Environments** — deployment targets — required reviewers — protection rules
  - 14.1.1.4 Wait timer + required approvers — gate before prod deploy — audit log
- **Unique: Dependabot** — auto PRs for vulnerable deps + outdated versions
  - 14.1.1.5 Dependabot alerts — secret scanning + code scanning alerts — unified security
- **Unique: Code scanning (CodeQL)** — SAST built-in — alert on PR — SARIF upload
  - 14.1.1.6 Custom CodeQL queries — detect domain-specific vulnerabilities
- **Unique: GitHub Packages** — multi-format registry — npm/Maven/Docker/NuGet — same token
  - 14.1.1.7 GITHUB_TOKEN — auth to Packages — no separate secret needed in Actions
- **Unique: Branch protection rules** — require status checks — signed commits — linear history
  - 14.1.1.8 Require pull request — no direct push to main — force code review
- **Unique: GitHub Copilot / Copilot Workspace** — AI-assisted development — PR summaries

### 14.2 GitLab
→ See Ideal §1.1 Git Internals, §2.0 CI/CD Pipelines

#### 14.2.1 GitLab-Unique Features
- **Unique: GitLab CI/CD** — .gitlab-ci.yml — stages + jobs — first-class CI
  - 14.2.1.1 Auto DevOps — auto-detect + build + test + deploy — zero config
  - 14.2.1.2 CI/CD components — reusable pipeline snippets — catalog — replace templates
  - 14.2.1.3 include — multi-file pipelines — local / project / remote YAML
- **Unique: GitLab Runners** — Docker / shell / K8s executor — self-managed or SaaS
  - 14.2.1.4 K8s executor — ephemeral pods — per-job — scale to zero — ideal for large repos
  - 14.2.1.5 Runner tags — route job to specific runner — GPU / large-runner / secure
- **Unique: Merge Trains** — queue MRs — test in series — guarantee green main
  - 14.2.1.6 Speculative merge — merge train tests MR1 + MR2 together — pipeline efficiency
- **Unique: GitLab Security** — SAST + DAST + dependency scan + container scan — built-in
  - 14.2.1.7 Security dashboard — all findings — project/group — merge gate policies
- **Unique: Environments + Review Apps** — per-MR dynamic environment — preview URL
  - 14.2.1.8 stop_review action — clean up env on MR close — no orphan resources
- **Unique: GitLab Agent for K8s** — pull-based GitOps — no cluster credentials in CI

---

## 15.0 CI/CD Engines

### 15.1 Jenkins
→ See Ideal §2.0 CI/CD Pipelines, §2.5 Pipeline Security

#### 15.1.1 Jenkins-Unique Features
- **Unique: Groovy DSL (Declarative + Scripted)** — most flexible — full Java access
  - 15.1.1.1 Declarative pipeline — pipeline {} block — strict structure — simpler
  - 15.1.1.2 Scripted pipeline — node {} — full Groovy — loops/try-catch — complex logic
  - 15.1.1.3 Shared libraries — @Library annotation — centralize Groovy code — DRY
- **Unique: Plugin ecosystem** — 1800+ plugins — extend anything
  - 15.1.1.4 Blue Ocean — modern UI — pipeline visualization — deprecated but used
  - 15.1.1.5 Configuration as Code (JCasC) — YAML — reproducible Jenkins config
- **Unique: Dynamic agents** — cloud plugin — spin up EC2/K8s pods per build
  - 15.1.1.6 Kubernetes plugin — pod templates — unique pod per build — parallel scale
  - 15.1.1.7 Ephemeral agents — spin up / run / destroy — no persistent state
- **Unique: Multi-branch pipeline** — auto-discover branches — Jenkinsfile per branch
  - 15.1.1.8 Organization folder — scan GitHub/GitLab org — auto-create per repo

### 15.2 GitHub Actions
→ See Ideal §2.0 CI/CD Pipelines, §2.5 Pipeline Security

#### 15.2.1 GitHub Actions-Unique Features
- **Unique: Composite Actions** — reusable action — shell steps — no Docker needed
  - 15.2.1.1 action.yml — inputs/outputs/runs — published to marketplace
  - 15.2.1.2 Docker actions — custom container — full control — portable
- **Unique: Matrix strategy** — test across OS/version combos — parallel jobs
  - 15.2.1.3 matrix.include — add extra combos — override specific values
  - 15.2.1.4 matrix.exclude — remove specific combos — reduce unnecessary runs
- **Unique: Job outputs** — pass values between jobs — needs context
  - 15.2.1.5 outputs: — set in step — read in downstream job via needs.job.outputs.key
- **Unique: Concurrency groups** — cancel in-progress — queue latest — one at a time
  - 15.2.1.6 concurrency.cancel-in-progress — cancel older runs on same branch
- **Unique: Self-hosted runners** — on-prem — GPU — access private network
  - 15.2.1.7 Runner groups — org-level — restrict which repos use which runners

### 15.3 GitLab CI
→ See Ideal §2.0 CI/CD Pipelines

#### 15.3.1 GitLab CI-Unique Features
- **Unique: DAG pipelines** — needs: — skip stages — run when dependencies done
  - 15.3.1.1 needs: [] — parallel fan-out — not bound by stage ordering
  - 15.3.1.2 Directed Acyclic Graph — optimal execution — minimize total pipeline time
- **Unique: Artifacts + dependencies** — pass files between jobs — explicit declaration
  - 15.3.1.3 artifacts.paths + expire_in — auto-clean — storage management
  - 15.3.1.4 dependencies: — explicit artifact download — not all previous jobs
- **Unique: Rules** — replace only/except — conditional job inclusion — powerful
  - 15.3.1.5 rules.if — CI_PIPELINE_SOURCE / branch / variable — precise control
  - 15.3.1.6 workflow.rules — control whether pipeline runs at all — repo-level gate
