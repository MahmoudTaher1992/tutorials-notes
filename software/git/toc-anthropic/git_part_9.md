# Git & Git Hosting Services - Part 9: Bitbucket & Azure DevOps

## 14.0 Bitbucket

### 14.1 Bitbucket Core Features
#### 14.1.1 Repositories & Pull Requests
- 14.1.1.1 Workspace — top-level container — teams + repos — Bitbucket Cloud org equivalent
  - 14.1.1.1.1 Projects — group related repos — shared permissions — team organization
  - 14.1.1.1.2 Repo permissions — admin / write / read — workspace-level or repo-level — granular
- 14.1.1.2 Pull requests — review + merge — diff view — inline comments — tasks
  - 14.1.1.2.1 PR tasks — actionable checklist items — must complete before merge — lightweight
  - 14.1.1.2.2 Default reviewers — auto-add reviewers by path — CODEOWNERS equivalent
  - 14.1.1.2.3 Merge checks — minimum approvals / passing builds / no unresolved tasks — gates
- 14.1.1.3 Branch permissions — prevent direct push / require PR / require approvals — protection
  - 14.1.1.3.1 Exemptions — specific users bypass — admin overrides — emergency access
- 14.1.1.4 Jira integration — smart commits — PROJ-123 in commit message → Jira transition
  - 14.1.1.4.1 #comment — add Jira comment from commit — #done — transition issue to done
  - 14.1.1.4.2 Development panel — Jira issue shows branches/PRs/deployments — linked view

### 14.2 Bitbucket Pipelines
#### 14.2.1 Pipeline Configuration
- 14.2.1.1 bitbucket-pipelines.yml — root of repo — Docker-based — parallel steps
  - 14.2.1.1.1 pipelines: — default / branches / tags / custom / pull-requests — trigger contexts
  - 14.2.1.1.2 Step — image + script + caches + artifacts — execution unit — Docker container
  - 14.2.1.1.3 Parallel steps — parallel: steps: list — run simultaneously — reduce total time
- 14.2.1.2 Caches — named cache → paths — npm / pip / maven — built-in names + custom
  - 14.2.1.2.1 caches: — npm — automatic node_modules cache — named cache on step
- 14.2.1.3 Artifacts — pass files between steps — test results / built binaries — within pipeline
  - 14.2.1.3.1 artifacts: — paths: list — available to subsequent steps — intra-pipeline transfer
- 14.2.1.4 Deployments — environment: Production — deployment variable sets — Jira deployment link
  - 14.2.1.4.1 Deployment environments — Test / Staging / Production — Jira depl panel tracks

#### 14.2.2 Pipes
- 14.2.2.1 Pipes — reusable Docker-based step plugins — Atlassian + third-party marketplace
  - 14.2.2.1.1 atlassian/aws-s3-deploy — upload to S3 — parameterized — one-liner step
  - 14.2.2.1.2 Custom pipe — Dockerfile + pipe.yml — publish to Docker Hub — share across teams

---

## 15.0 Azure DevOps Repos

### 15.1 Azure Repos
#### 15.1.1 Repository Features
- 15.1.1.1 Git repos — same git protocol — unlimited private repos — Azure DevOps org
  - 15.1.1.1.1 SSH + HTTPS — credential manager — Azure AD auth — PAT — flexible auth
- 15.1.1.2 Branch policies — require PR / min reviewers / linked work item / comment resolution
  - 15.1.1.2.1 Required reviewer — specific user must approve — compliance — named DRI
  - 15.1.1.2.2 Automatically include reviewers — path-based — CODEOWNERS equivalent
  - 15.1.1.2.3 Build validation — build policy — PR triggers pipeline — must pass — merge gate
- 15.1.1.3 Pull requests — work item linking — auto-complete — squash merge / rebase / merge commit
  - 15.1.1.3.1 Auto-complete — merge when all policies met — queue + auto-merge — hands-off
  - 15.1.1.3.2 Bypass policies — admin + emergency — logged in audit — override with justification

#### 15.1.2 Azure Pipelines Integration
- 15.1.2.1 azure-pipelines.yml — YAML pipeline in repo — triggers on branch — CI native
  - 15.1.2.1.1 Trigger paths — only run on changes to src/ — monorepo selective CI
  - 15.1.2.1.2 Multi-stage pipeline — stages: + jobs: + steps: — deploy through environments
- 15.1.2.2 Environments — Azure DevOps environments — approval gates — deployment jobs
  - 15.1.2.2.1 Approval + checks — required reviewers — Azure Monitor check — ServiceNow gate
- 15.1.2.3 Service connections — connect to Azure / AWS / GCP / Docker Hub — centralized auth
  - 15.1.2.3.1 Workload identity federation — OIDC — no stored secrets — preferred for Azure

### 15.2 Azure DevOps Ecosystem
#### 15.2.1 Work Item Integration
- 15.2.1.1 Boards — Azure Boards — work items — epics / features / user stories / tasks / bugs
  - 15.2.1.1.1 PR ↔ work item link — commit message resolves #ID — traceability
  - 15.2.1.1.2 Branch from work item — auto-name branch from story title — linked from board
- 15.2.1.2 Test Plans — manual + automated test management — coverage tracking — Azure native
- 15.2.1.3 Artifacts — Azure Artifacts — npm / NuGet / Maven / Python / Universal packages — feed
  - 15.2.1.3.1 Upstream sources — proxy public registries — air-gapped environments — governance
