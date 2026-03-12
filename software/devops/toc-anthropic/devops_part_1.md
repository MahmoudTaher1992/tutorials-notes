# DevOps Engineering Study Guide - Part 1: Phase 1 — Version Control & SCM

## Phase 1: The Ideal DevOps Platform

---

## 1.0 Version Control & Source Code Management

### 1.1 Git Internals
#### 1.1.1 Object Model
- 1.1.1.1 Four object types — blob, tree, commit, tag — content-addressed SHA-1/SHA-256
  - 1.1.1.1.1 Blob — file content only — no filename — same content = same hash
  - 1.1.1.1.2 Tree — directory listing — blob + tree refs + filenames + permissions
  - 1.1.1.1.3 Commit — tree ref + parent refs + author/committer + message
  - 1.1.1.1.4 Tag — annotated tag — points to commit — signed with GPG key
- 1.1.1.2 Object storage — .git/objects — loose objects + packfiles
  - 1.1.1.2.1 Loose objects — one file per object — SHA-1 as path — zlib compressed
  - 1.1.1.2.2 Packfile — binary delta-compressed — .pack + .idx — git gc creates
  - 1.1.1.2.3 Delta compression — store diff vs. base object — reduce disk by 80%+
- 1.1.1.3 Content-addressable storage — hash of content = identity — immutable history
  - 1.1.1.3.1 SHA-1 collision concerns — git transitioning to SHA-256
  - 1.1.1.3.2 Object integrity check — git fsck — detect corruption

#### 1.1.2 References & Index
- 1.1.2.1 Refs — .git/refs/ — named pointers to commits — branches, tags, remotes
  - 1.1.2.1.1 HEAD — current branch pointer or detached HEAD
  - 1.1.2.1.2 Packed-refs — compacted ref file — many refs performance optimization
- 1.1.2.2 Index (staging area) — .git/index — binary tree — tracks staged changes
  - 1.1.2.2.1 Index entries — filename + stat data + SHA — dirty detection
  - 1.1.2.2.2 git add — hash object → write to index — stage partial files with -p
- 1.1.2.3 Reflog — .git/logs — history of ref changes — recovery tool
  - 1.1.2.3.1 Recover lost commits — git reflog + git checkout — dangling objects
  - 1.1.2.3.2 Reflog expiry — 90 days default — git gc prunes after expiry

#### 1.1.3 Network Protocol
- 1.1.3.1 Smart HTTP — stateful — packfile negotiation — most common
  - 1.1.3.1.1 Upload-pack — server side — fetch protocol
  - 1.1.3.1.2 Receive-pack — server side — push protocol
- 1.1.3.2 SSH transport — key-based auth — most secure for push
  - 1.1.3.2.1 SSH agent forwarding — CI/CD key chain — avoid key on disk
- 1.1.3.3 Bundle — offline transport — git bundle create — air-gap sync

### 1.2 Branching Strategies
#### 1.2.1 Trunk-Based Development (TBD)
- 1.2.1.1 Single main branch — short-lived feature branches < 2 days — continuous merge
  - 1.2.1.1.1 Feature flags — disable incomplete features — deploy anytime — decouple release
  - 1.2.1.1.2 Branch by abstraction — incremental refactor — always deployable
- 1.2.1.2 Release branches — cut from trunk — cherry-pick hotfixes — stable release
  - 1.2.1.2.1 Release branch naming — release/1.2 — semantic versioning
  - 1.2.1.2.2 Hotfix flow — fix on trunk first — backport to release branch

#### 1.2.2 GitFlow
- 1.2.2.1 Main branches — main + develop — perpetual — protected
  - 1.2.2.1.1 main — production state — tagged releases only
  - 1.2.2.1.2 develop — integration — next release accumulation
- 1.2.2.2 Supporting branches — feature/, release/, hotfix/
  - 1.2.2.2.1 feature/xyz — branch from develop — merge back to develop — delete
  - 1.2.2.2.2 release/1.0 — branch from develop → merge to main + develop
  - 1.2.2.2.3 hotfix/abc — branch from main → merge to main + develop

#### 1.2.3 GitHub Flow & Ship/Show/Ask
- 1.2.3.1 GitHub Flow — branch → PR → review → merge to main — simple
  - 1.2.3.1.1 Deploy branch before merge — validate in production — then merge
- 1.2.3.2 Ship/Show/Ask — categorize changes — skip review for Ship
  - 1.2.3.2.1 Ship — low-risk — merge directly — inform team
  - 1.2.3.2.2 Show — merge + PR notification — async review
  - 1.2.3.2.3 Ask — block on review — high-risk or unfamiliar area

### 1.3 Merge Strategies & Conflict Resolution
#### 1.3.1 Merge Types
- 1.3.1.1 Fast-forward merge — no divergence — pointer advance — clean history
- 1.3.1.2 Three-way merge — common ancestor + two tips — merge commit created
  - 1.3.1.2.1 Merge commit — preserves branch topology — useful for GitFlow
- 1.3.1.3 Squash merge — all commits → one — clean main history
  - 1.3.1.3.1 Squash loses authorship granularity — tradeoff: clean vs. detailed log
- 1.3.1.4 Rebase — replay commits on new base — linear history — rewrites SHA
  - 1.3.1.4.1 Interactive rebase — squash, fixup, reorder, edit — history surgery
  - 1.3.1.4.2 Golden rule — never rebase public branches — breaks others' clones

#### 1.3.2 Conflict Resolution
- 1.3.2.1 Conflict markers — <<<< / ==== / >>>> — manual resolution required
  - 1.3.2.1.1 Rerere — reuse recorded resolution — .git/rr-cache — automate repeat conflicts
- 1.3.2.2 Merge drivers — .gitattributes — custom merge tool per file type
  - 1.3.2.2.1 union merge driver — accept both sides — lock files / changelogs
- 1.3.2.3 ours/theirs strategy — choose one side — resolves all conflicts automatically

### 1.4 Hooks & Automation
#### 1.4.1 Client-Side Hooks
- 1.4.1.1 pre-commit — run linters/formatters — block bad commits — exit 1 fails
  - 1.4.1.1.1 Husky — npm pre-commit hook manager — .husky/ directory
  - 1.4.1.1.2 pre-commit framework — Python tool — multi-language hooks — .pre-commit-config.yaml
- 1.4.1.2 commit-msg — enforce conventional commits — regex validate message
  - 1.4.1.2.1 Conventional Commits spec — type(scope): description — machine-readable
  - 1.4.1.2.2 commitlint — validate commit-msg — integrates with Husky
- 1.4.1.3 prepare-commit-msg — auto-prepend ticket ID — branch name parsing

#### 1.4.2 Server-Side Hooks
- 1.4.2.1 pre-receive — validate push — reject non-compliant — centralized policy
  - 1.4.2.1.1 Force push protection — detect non-fast-forward — block protected branches
  - 1.4.2.1.2 Secret scanning — pre-receive hook — regex match API keys — block push
- 1.4.2.2 post-receive — trigger CI — webhook equivalent — notify external systems
  - 1.4.2.2.1 CI trigger — post-receive → curl Jenkins/GitHub Actions — kickoff build
