# Git & Git Hosting Services - Part 7: GitHub Actions

## 11.0 GitHub Actions

### 11.1 Workflow Fundamentals
#### 11.1.1 Workflow Structure
- 11.1.1.1 Workflow file — .github/workflows/*.yml — YAML — event-triggered — per-repo
  - 11.1.1.1.1 on: — trigger definition — push / pull_request / schedule / workflow_dispatch
  - 11.1.1.1.2 jobs: — parallel execution units — each runs on a runner — independent env
  - 11.1.1.1.3 steps: — sequential commands within job — uses (action) or run (shell) — ordered
- 11.1.1.2 Trigger types — events that start a workflow
  - 11.1.1.2.1 push — on commit to branch — branch filters — paths filters — common CI trigger
  - 11.1.1.2.2 pull_request — on PR open/sync/reopen — base branch filter — review gate
  - 11.1.1.2.3 schedule — cron syntax — nightly jobs — stale cleanup — recurring checks
  - 11.1.1.2.4 workflow_dispatch — manual trigger — inputs — web UI / gh CLI / API
  - 11.1.1.2.5 workflow_call — reusable workflow trigger — called from other workflows — DRY

#### 11.1.2 Runners
- 11.1.2.1 GitHub-hosted — ubuntu-latest / windows-latest / macos-latest — ephemeral VMs
  - 11.1.2.1.1 ubuntu-latest — 2-core / 7GB RAM / 14GB SSD — most common — fastest startup
  - 11.1.2.1.2 Pre-installed tools — Node / Python / Java / Docker / AWS CLI / etc. — no setup
  - 11.1.2.1.3 Larger runners — 4/8/16/32-core — extra cost — for compute-intensive builds
- 11.1.2.2 Self-hosted runners — own infrastructure — custom tools — behind firewall — cost control
  - 11.1.2.2.1 Runner groups — assign to org/repo — access control — team isolation
  - 11.1.2.2.2 Ephemeral self-hosted — just-in-time runner — Actions Runner Controller on K8s
  - 11.1.2.2.3 Security — disable untrusted fork workflows on self-hosted — code execution risk

### 11.2 Jobs & Steps
#### 11.2.1 Job Configuration
- 11.2.1.1 needs: — job dependency — job B waits for job A — DAG of jobs — fan-out/in
  - 11.2.1.1.1 needs outputs — pass data between jobs — job.outputs — steps.id.outputs
  - 11.2.1.1.2 if: needs.job.result == 'success' — conditional job execution — failure handling
- 11.2.1.2 Matrix strategy — run job with multiple variable combinations — parallel variants
  - 11.2.1.2.1 matrix: node: [16, 18, 20] — one job instance per value — test matrix
  - 11.2.1.2.2 include / exclude — customize matrix — add extra vars / remove specific combos
  - 11.2.1.2.3 fail-fast: false — continue matrix on one failure — see all results
- 11.2.1.3 Container jobs — runs-on + container: — run job in Docker container — custom env
  - 11.2.1.3.1 Service containers — services: postgres: — sidecar — integration test DB

#### 11.2.2 Caching
- 11.2.2.1 actions/cache — cache by key — restore on match — restore-keys for partial hit
  - 11.2.2.1.1 Cache key — hashFiles('**/package-lock.json') — invalidate on lock change
  - 11.2.2.1.2 restore-keys — fallback prefix — use older cache — faster than no cache
  - 11.2.2.1.3 10GB per repo limit — evicted after 7 days — size + date managed automatically
- 11.2.2.2 Setup actions with built-in cache — actions/setup-node cache: 'npm' — transparent
  - 11.2.2.2.1 setup-python / setup-java / setup-go — all support cache: key — native caching

### 11.3 Secrets & Environments
#### 11.3.1 Secrets Management
- 11.3.1.1 Repository secrets — Settings > Secrets — encrypted — available as ${{ secrets.NAME }}
  - 11.3.1.1.1 Org secrets — share across repos — policy — repo access list
  - 11.3.1.1.2 Environment secrets — scoped to environment — require approval before use
- 11.3.1.2 GITHUB_TOKEN — auto-created per run — scoped to repo — expires when job ends
  - 11.3.1.2.1 Permissions block — contents: read / packages: write — least privilege per job
  - 11.3.1.2.2 Default permissions — read-all or restricted — org-level policy — security posture

#### 11.3.2 Environments & OIDC
- 11.3.2.1 Environments — production / staging / preview — deployment protection rules
  - 11.3.2.1.1 Required reviewers — manual approval gate — deployment to prod — compliance
  - 11.3.2.1.2 Wait timer — delay before deploy — notification window — cancel option
- 11.3.2.2 OIDC — OpenID Connect — exchange GitHub token for cloud provider credentials
  - 11.3.2.2.1 No stored secrets — AWS / GCP / Azure trust GitHub OIDC issuer — ephemeral creds
  - 11.3.2.2.2 aws-actions/configure-aws-credentials — role-to-assume — audience — OIDC flow
  - 11.3.2.2.3 Trust policy — condition: repo + ref + environment — scoped to workflow

### 11.4 Reusable Workflows & Composite Actions
#### 11.4.1 Reusable Workflows
- 11.4.1.1 on: workflow_call — called from other workflows — share CI logic — centralized
  - 11.4.1.1.1 inputs: — typed parameters — string / boolean / number — caller provides values
  - 11.4.1.1.2 secrets: inherit — pass caller secrets — or explicit secret mapping
  - 11.4.1.1.3 outputs: — return values to caller — from job outputs — cross-workflow data
- 11.4.1.2 Composite action — action.yml — multiple steps as single action — shell + uses
  - 11.4.1.2.1 Runs: using: composite — steps array — reuse shell logic — no runner needed
