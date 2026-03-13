# Git & Git Hosting Services - Part 6: GitHub Core

## 10.0 GitHub Core Features

### 10.1 Repositories & Collaboration
#### 10.1.1 Repository Settings
- 10.1.1.1 Visibility — public / private / internal (Enterprise) — scoped access
  - 10.1.1.1.1 Internal — visible to all org members — not public — GitHub Enterprise Cloud
  - 10.1.1.1.2 Forking policy — disable fork for private repos — data loss prevention
- 10.1.1.2 Branch protection rules — enforce workflow — protect main/release branches
  - 10.1.1.2.1 Require PR reviews — N approvals required — dismiss stale reviews on push
  - 10.1.1.2.2 Require status checks — CI must pass — require branches up to date — merge gate
  - 10.1.1.2.3 Require signed commits — all commits on branch must be signed — security
  - 10.1.1.2.4 Restrict who can push — allowlist — protect main from direct push
  - 10.1.1.2.5 Rulesets — new model — repo / org / enterprise level — non-bypassable — 2023+
- 10.1.1.3 CODEOWNERS — .github/CODEOWNERS — path patterns → teams/users — auto-review request
  - 10.1.1.3.1 * @org/backend-team — catch-all — team owns anything not matched above
  - 10.1.1.3.2 CODEOWNERS required review — branch protection requires CODEOWNER approval
  - 10.1.1.3.3 Multiple owners — /api/ @alice @org/api-team — any one must approve — OR logic

#### 10.1.2 Pull Requests
- 10.1.2.1 PR lifecycle — open → review → approve → merge — event-driven collaboration
  - 10.1.2.1.1 Draft PR — work in progress — no merge — request early feedback — not yet ready
  - 10.1.2.1.2 Review request — request specific users/teams — routing + accountability
- 10.1.2.2 Review types — approve / request changes / comment — only approve unblocks merge
  - 10.1.2.2.1 Review thread — inline comments on diff — resolved per-thread — async collaboration
  - 10.1.2.2.2 Suggestion — reviewers propose code changes — author applies with click — efficient
- 10.1.2.3 Merge strategies — merge commit / squash / rebase — per-repo or per-PR choice
  - 10.1.2.3.1 Squash and merge — all commits → one commit — clean main history — common SaaS
  - 10.1.2.3.2 Rebase and merge — linear — individual commits preserved — no merge commit
  - 10.1.2.3.3 Merge commit — full history — merge commit visible — accurate ancestry
- 10.1.2.4 Auto-merge — merge automatically when all checks pass + approvals met — efficiency
  - 10.1.2.4.1 Dependabot PRs — auto-merge minor/patch — reduce review noise — bot PRs

### 10.2 Issues & Project Management
#### 10.2.1 Issues
- 10.2.1.1 Issue templates — .github/ISSUE_TEMPLATE/ — structured bug reports + feature requests
  - 10.2.1.1.1 YAML front matter — title / labels / assignees — pre-filled fields — consistent
  - 10.2.1.1.2 Issue forms — form elements — required fields — dropdowns — better DX than Markdown
- 10.2.1.2 Labels — categorize + filter — type:bug / priority:high / status:blocked — custom scheme
- 10.2.1.3 Milestones — group issues by version / sprint — progress % — due date — planning
- 10.2.1.4 GitHub Projects (V2) — board / table / roadmap — cross-repo — custom fields — workflows
  - 10.2.1.4.1 Custom fields — priority / estimate / sprint — flexible schema — team-specific
  - 10.2.1.4.2 Automation — auto-add items from repo — auto-archive closed — workflow triggers

### 10.3 GitHub Packages
#### 10.3.1 Package Registry
- 10.3.1.1 Supported ecosystems — npm / Docker / Maven / NuGet / RubyGems / Go modules
  - 10.3.1.1.1 ghcr.io — GitHub Container Registry — Docker images — separate from packages
  - 10.3.1.1.2 Scoped to org — packages.OWNER — auth via GITHUB_TOKEN — CI native
- 10.3.1.2 Package permissions — inherit repo permissions — or configure independently
  - 10.3.1.2.1 Public package — anyone can pull — good for open source — no auth needed
  - 10.3.1.2.2 Private package — org members only — PAT or Actions token — access control

### 10.4 Discussions
#### 10.4.1 GitHub Discussions
- 10.4.1.1 Forum-style — Q&A / announcements / general — separate from issues — community
  - 10.4.1.1.1 Answered question — mark best answer — surfaces in search — knowledge base
  - 10.4.1.1.2 Polls — gather community input — feature prioritization — engagement
- 10.4.1.2 Convert discussion to issue — actionable item found in discussion — traceability link
