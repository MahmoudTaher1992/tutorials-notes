# Git & Git Hosting Services - Part 10: Self-Hosted & Comparison

## 15.0 Self-Hosted Git Hosting

### 15.1 Gitea & Forgejo
#### 15.1.1 Gitea
- 15.1.1.1 Gitea — lightweight Go binary — single executable — minimal resource footprint
  - 15.1.1.1.1 < 100MB RAM — runs on Raspberry Pi — on-prem or air-gapped — easy deploy
  - 15.1.1.1.2 SQLite / MySQL / PostgreSQL backend — flexible storage — small-to-large installs
  - 15.1.1.1.3 Docker deploy — gitea/gitea image — docker-compose with DB — minutes to running
- 15.1.1.2 Gitea Actions — GitHub Actions compatible — act_runner — reuse existing workflows
  - 15.1.1.2.1 act_runner — execute Actions YAML — Docker-based — self-hosted runner daemon
  - 15.1.1.2.2 Workflow compatibility — most GitHub Actions run unchanged — near drop-in
- 15.1.1.3 Gitea federation — ForgeFed — ActivityPub — cross-instance interaction — emerging standard

#### 15.1.2 Forgejo
- 15.1.2.1 Forgejo — community fork of Gitea — soft fork — diverging governance
  - 15.1.2.1.1 Fully open-source — Codeberg hosts Forgejo — privacy-first — EU-based
  - 15.1.2.1.2 API compatibility — GitHub/Gitea API compatible — migrate without client changes
- 15.1.2.2 Forgejo Actions — built-in CI — compatible with Gitea Actions — self-hosted first

### 15.2 Gerrit
#### 15.2.1 Gerrit Code Review
- 15.2.1.1 Gerrit — change-based review — every commit is a change — not branch-based PR
  - 15.2.1.1.1 Change-ID — magic footer in commit message — identify change across amendments
  - 15.2.1.1.2 Amendment-based workflow — push --force to same change — no new commit per fix
  - 15.2.1.1.3 Used by Android / Chromium / OpenStack — large scale — proven at Google scale
- 15.2.1.2 Submit strategies — merge / rebase if necessary / cherry-pick / merge if necessary
  - 15.2.1.2.1 Submit requirements — Code-Review+2 + Verified+1 — customizable — mandatory
- 15.2.1.3 All-Projects — global config — inherits to all repos — centralized policy

---

## 16.0 Platform Comparison & Migration

### 16.1 Feature Comparison Matrix
#### 16.1.1 Core Feature Matrix
- 16.1.1.1 CI/CD native — GitHub Actions / GitLab CI / Bitbucket Pipelines / Azure Pipelines — all have it
  - 16.1.1.1.1 GitHub Actions — largest marketplace — 20k+ actions — easiest ecosystem
  - 16.1.1.1.2 GitLab CI — most mature — most features — DORA metrics — auto DevOps
  - 16.1.1.1.3 Bitbucket Pipelines — Jira-first — Atlassian ecosystem — simpler feature set
  - 16.1.1.1.4 Azure Pipelines — enterprise — YAML + classic UI — Azure ecosystem deep integration
- 16.1.1.2 Code review — all platforms have PR/MR — differentiation in automation + policy
  - 16.1.1.2.1 GitHub CODEOWNERS — GitLab code owners — Bitbucket default reviewers — all similar
  - 16.1.1.2.2 GitLab merge trains — unique — no equivalent on GitHub/Bitbucket — serial safety
- 16.1.1.3 Security scanning — GitHub GHAS — GitLab SAST/DAST/secret detection — varies by tier
  - 16.1.1.3.1 GitHub GHAS — CodeQL + secret scanning + Dependabot — best-in-class combined
  - 16.1.1.3.2 GitLab Ultimate — SAST / DAST / IAST / container scanning — all-in-one platform
- 16.1.1.4 Self-hosted options — GitHub Enterprise Server / GitLab self-managed / Bitbucket Data Center
  - 16.1.1.4.1 GitLab — same feature parity self-managed — full control — popular for enterprises
  - 16.1.1.4.2 Gitea/Forgejo — open source — zero license cost — lightweight — hobbyist/SMB

### 16.2 Migration Strategies
#### 16.2.1 Platform Migration
- 16.2.1.1 Repository migration — git clone --mirror → push to new remote — full history preserved
  - 16.2.1.1.1 LFS migration — git lfs fetch --all + push --all — include LFS objects — complete
  - 16.2.1.1.2 GitHub Importer — web-based — migrate from GitLab / Bitbucket / SVN — metadata
- 16.2.1.2 gh CLI — GitHub CLI — gh repo migrate — scripted bulk migration — org-wide
  - 16.2.1.2.1 GitHub Enterprise Importer — GEI — migrate repos + PRs + issues — enterprise tool
- 16.2.1.3 CI/CD migration — rewrite pipelines — Actions vs .gitlab-ci.yml — semantic mapping
  - 16.2.1.3.1 GitLab → GitHub — stages → jobs with needs — variables → secrets — manual rewrite
  - 16.2.1.3.2 GitHub Actions → GitLab CI — uses → image + extends — syntax translation needed
- 16.2.1.4 Issue & PR migration — no standard — API-based — gl-exporter / github-exporter tools
  - 16.2.1.4.1 Preserve references — update cross-links — search + replace in migrated issues
