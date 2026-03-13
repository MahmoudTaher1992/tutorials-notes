# Git & Git Hosting Services - Part 2: Rebasing & Remote Operations

## 3.0 Rebasing & History Rewriting

### 3.1 Rebase Mechanics
#### 3.1.1 How Rebase Works
- 3.1.1.1 Rebase — reapply commits on top of new base — new SHAs — linear history
  - 3.1.1.1.1 Each commit replayed — patch applied to new base — conflicts per commit
  - 3.1.1.1.2 New commits ≠ original — different parent → different SHA — not same commit
  - 3.1.1.1.3 git rebase <upstream> — replay current branch commits on top of upstream
- 3.1.1.2 Rebase vs merge — rebase = linear clean history — merge = accurate history with merge commit
  - 3.1.1.2.1 Rebase tradeoff — rewrites history — simplifies log — don't rebase shared branches
  - 3.1.1.2.2 Merge tradeoff — preserves exact history — log has merge commits — harder to bisect

#### 3.1.2 Interactive Rebase
- 3.1.2.1 git rebase -i HEAD~N — reword / edit / squash / fixup / drop / reorder commits
  - 3.1.2.1.1 squash — combine commit with previous — merge commit messages — clean up WIP
  - 3.1.2.1.2 fixup — like squash but discard commit message — silent squash
  - 3.1.2.1.3 reword — change commit message only — keep changes — editorial fix
  - 3.1.2.1.4 edit — stop at commit — amend files — git rebase --continue — surgical fix
  - 3.1.2.1.5 drop — remove commit entirely — careful with dependencies — may conflict
- 3.1.2.2 Autosquash — git rebase -i --autosquash — fixup! and squash! commits auto-placed
  - 3.1.2.2.1 git commit --fixup=SHA — create fixup commit — prefix "fixup! original msg"
  - 3.1.2.2.2 rebase.autosquash=true — always apply autosquash — streamlined workflow

### 3.2 History Rewriting Tools
#### 3.2.1 Amending
- 3.2.1.1 git commit --amend — modify last commit — message or files — new SHA
  - 3.2.1.1.1 --no-edit — amend without changing message — add forgotten file — quick fix
  - 3.2.1.1.2 Never amend pushed commits — remote diverges — force push required — dangerous

#### 3.2.2 Advanced History Tools
- 3.2.2.1 git cherry-pick SHA — apply specific commit to current branch — copy not move
  - 3.2.2.1.1 Cherry-pick range — git cherry-pick A..B — apply range — maintain relative order
  - 3.2.2.1.2 -x flag — append "(cherry picked from commit SHA)" — traceability
- 3.2.2.2 git filter-repo — rewrite entire history — remove files / secrets / paths — fast
  - 3.2.2.2.1 Remove file from all history — --path secret.txt --invert-paths — scrub secrets
  - 3.2.2.2.2 Replaces BFG Repo Cleaner — maintained — recommended by GitHub
- 3.2.2.3 git reflog — local log of HEAD movements — recover lost commits — safety net
  - 3.2.2.3.1 git reflog expire —expire=90.days.ago — default retention — GC cleans after
  - 3.2.2.3.2 git reset --hard HEAD@{N} — restore to previous HEAD state — undo rebase

---

## 4.0 Remote Operations

### 4.1 Fetch, Pull & Push
#### 4.1.1 Fetch
- 4.1.1.1 git fetch — download remote objects + update remote tracking refs — no merge
  - 4.1.1.1.1 --prune — delete local remote tracking refs no longer on remote — clean up
  - 4.1.1.1.2 --all — fetch all remotes — useful with multiple remotes — fork workflow
  - 4.1.1.1.3 Fetch does not touch working tree — safe always — inspect before merging
- 4.1.1.2 git pull — fetch + merge (or rebase) — shortcut — auto-merge can surprise
  - 4.1.1.2.1 pull.rebase=true — pull with rebase — linear history — preferred
  - 4.1.1.2.2 pull.ff=only — fail if not fast-forwardable — safe — forces explicit rebase

#### 4.1.2 Push
- 4.1.2.1 git push origin branch — upload local commits — update remote ref — requires ff
  - 4.1.2.1.1 Rejected push — remote has commits not in local — fetch + rebase first — then push
  - 4.1.2.1.2 push.default=simple — only push current tracking branch — safe default — Git 2.0+
- 4.1.2.2 Force push — --force — overwrite remote history — dangerous on shared branches
  - 4.1.2.2.1 --force-with-lease — safer force — fails if remote has new commits — preferred
  - 4.1.2.2.2 --force-if-includes — even safer — checks fetched ref included in local — Git 2.30+
- 4.1.2.3 Delete remote branch — git push origin --delete branch — or git push origin :branch

### 4.2 Clone Options
#### 4.2.1 Clone Variants
- 4.2.1.1 Full clone — download entire history — all objects — .git fully populated
- 4.2.1.2 Shallow clone — --depth N — only N commits of history — smaller — CI use case
  - 4.2.1.2.1 Shallow boundary — grafted commits — some operations limited — no full log
  - 4.2.1.2.2 Unshallow — git fetch --unshallow — convert shallow to full — when needed
- 4.2.1.3 Partial clone — --filter=blob:none — omit blobs until needed — large repo CI
  - 4.2.1.3.1 Treeless clone — --filter=tree:0 — no trees until checked out — fastest CI clone
  - 4.2.1.3.2 Blobless clone — --filter=blob:none — fetch blobs on checkout — good balance
- 4.2.1.4 Sparse checkout — --sparse — only checkout subset of working tree — monorepo
  - 4.2.1.4.1 git sparse-checkout set path/to/dir — track only specified paths — fast writes

### 4.3 Multiple Remotes
#### 4.3.1 Remote Management
- 4.3.1.1 git remote add name URL — add second remote — upstream / fork / mirror workflow
  - 4.3.1.1.1 Fork workflow — origin = fork / upstream = canonical — sync upstream changes
  - 4.3.1.1.2 git remote set-url origin — update URL — SSH to HTTPS switch — credential change
- 4.3.1.2 Refspec — fetch = +refs/heads/*:refs/remotes/origin/* — mapping rule
  - 4.3.1.2.1 Custom refspec — fetch PR refs — +refs/pull/*/head:refs/remotes/origin/pr/*
