# Git & Git Hosting Services - Part 3: Internals & Workflows

## 5.0 Git Internals

### 5.1 Object Storage
#### 5.1.1 Packfiles
- 5.1.1.1 Pack file — .pack + .idx — many objects compressed together — efficient storage
  - 5.1.1.1.1 Delta compression — similar objects stored as base + delta — textual diffs
  - 5.1.1.1.2 Delta chains — object = base + delta1 + delta2 — GC limits chain depth
  - 5.1.1.1.3 Reverse delta — recent objects stored as base — old objects as delta — fast HEAD
- 5.1.1.2 Index file (.idx) — sorted SHA list + offsets — O(log N) binary search lookup
  - 5.1.1.2.1 v2 index — fan-out table + sorted SHAs + CRCs + offsets — large pack support
- 5.1.1.3 git pack-objects — create packfile from stdin list of SHAs — used by push/fetch
  - 5.1.1.3.1 git repack -adf — full repack — single pack — optimal — post-GC maintenance

#### 5.1.2 Garbage Collection
- 5.1.2.1 git gc — prune loose objects + pack refs + expire reflog + run maintenance tasks
  - 5.1.2.1.1 Auto-GC — triggered after ~6700 loose objects — git gc --auto — background
  - 5.1.2.1.2 Unreachable objects — not reachable from any ref — pruned after grace period
  - 5.1.2.1.3 --prune=now — prune immediately — no grace period — use after filter-repo
- 5.1.2.2 Maintenance tasks — git maintenance start — background scheduled tasks — Git 2.29+
  - 5.1.2.2.1 prefetch — background fetch — reduces interactive fetch latency — cron daily
  - 5.1.2.2.2 commit-graph — update commit-graph file — faster log/status — cron hourly

### 5.2 Internal Files
#### 5.2.1 .git Directory
- 5.2.1.1 HEAD — current branch or detached SHA — symref: refs/heads/main — or raw SHA
- 5.2.1.2 ORIG_HEAD — saved before dangerous ops — merge / rebase / reset — undo target
- 5.2.1.3 MERGE_HEAD — during merge — SHA of branch being merged — used for commit message
- 5.2.1.4 index — staging area — binary file — tree of (path, mode, SHA, stat) — efficient
  - 5.2.1.4.1 git ls-files --stage — inspect index — see staged file SHA and mode
  - 5.2.1.4.2 Cache invalidation — stat data — mtime + size — quick dirty check before hash
- 5.2.1.5 config — local repo config — remote URLs / branch tracking / user overrides
- 5.2.1.6 hooks/ — executable scripts — event-driven — not transferred on clone

#### 5.2.2 Diagnostics
- 5.2.2.1 git fsck — check object integrity — find dangling objects — corruption detection
  - 5.2.2.1.1 Dangling commit — not reachable from refs — lost after rebase — visible in reflog
  - 5.2.2.1.2 --connectivity-only — fast check — skip object content validation
- 5.2.2.2 git cat-file -p SHA — pretty print object contents — debug any object type
  - 5.2.2.2.1 git cat-file -t SHA — show object type — blob/tree/commit/tag
- 5.2.2.3 git count-objects -vH — loose object count + pack size — repo health metrics

---

## 6.0 Git Workflows

### 6.1 Branching Strategies
#### 6.1.1 GitFlow
- 6.1.1.1 Long-lived branches — main + develop + release/* + hotfix/* + feature/*
  - 6.1.1.1.1 feature/* — branch from develop — merge back to develop — never to main
  - 6.1.1.1.2 release/* — branch from develop — only bug fixes — merge to main + develop
  - 6.1.1.1.3 hotfix/* — branch from main — merge to main + develop — emergency fix
- 6.1.1.2 Strengths — clear versioning — parallel release prep — suits scheduled releases
- 6.1.1.3 Weaknesses — complex — many merge points — slow CI — not suited for continuous delivery

#### 6.1.2 GitHub Flow
- 6.1.2.1 Only main + short-lived feature branches — merge via PR — deploy from main
  - 6.1.2.1.1 Feature branch — branch → commit → PR → review → merge → deploy — simple
  - 6.1.2.1.2 Main always deployable — no release branch — CI/CD gates merge — fast cadence
- 6.1.2.2 Strengths — simple — CI-friendly — fast feedback — suits SaaS / web apps

#### 6.1.3 Trunk-Based Development
- 6.1.3.1 All developers commit to trunk (main) — no long-lived branches — CI on every commit
  - 6.1.3.1.1 Short-lived branches — < 1 day — immediate PR — merge same day
  - 6.1.3.1.2 Feature flags — hide incomplete features — decouple deploy from release
- 6.1.3.2 Feature flags — LaunchDarkly / Unleash / Flipt — runtime toggle — gradual rollout
  - 6.1.3.2.1 Flag lifecycle — created → deployed dark → enabled → cleaned up — technical debt risk
  - 6.1.3.2.2 Flag debt — stale flags — accumulate — schedule cleanup — ownership

### 6.2 Monorepo Strategies
#### 6.2.1 Monorepo at Scale
- 6.2.1.1 Sparse checkout — checkout only relevant paths — fast local development
  - 6.2.1.1.1 git sparse-checkout — cone mode — fast pattern matching — large monorepo
- 6.2.1.2 CODEOWNERS — per-path ownership — auto-assign reviewers — mandatory review
- 6.2.1.3 Change detection — git diff HEAD~1 --name-only — affected service CI — selective runs
  - 6.2.1.3.1 Turborepo / Nx — affected graph — only build/test impacted packages — cache
  - 6.2.1.3.2 Bazel — hermetic builds — fine-grained dependency — only rebuild changed
- 6.2.1.4 Virtual filesystem — VFS for Git (Microsoft) — on-demand file hydration — Windows
  - 6.2.1.4.1 Scalar — new Microsoft tool — partial clone + maintenance + sparse — Linux/Mac/Win
