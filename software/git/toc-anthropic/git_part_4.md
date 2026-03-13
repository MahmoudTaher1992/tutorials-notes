# Git & Git Hosting Services - Part 4: Hooks, Submodules & Subtrees

## 7.0 Hooks & Automation

### 7.1 Client-Side Hooks
#### 7.1.1 Commit Workflow Hooks
- 7.1.1.1 pre-commit — runs before commit message prompt — staged files available — lint/format
  - 7.1.1.1.1 Exit code 0 = pass / non-zero = abort commit — no commit if hook fails
  - 7.1.1.1.2 git commit --no-verify — bypass all hooks — emergency use only — document reason
  - 7.1.1.1.3 Run fast — developer waits — < 5 seconds ideal — slow hooks = bypass temptation
- 7.1.1.2 prepare-commit-msg — modify default commit message — prepend ticket ID from branch name
  - 7.1.1.2.1 Parse branch name — extract JIRA-123 prefix — inject into message template
- 7.1.1.3 commit-msg — validate commit message format — enforce Conventional Commits / ticket ref
  - 7.1.1.3.1 Conventional Commits — type(scope): description — feat / fix / chore / docs / refactor
  - 7.1.1.3.2 commitlint — validate message against config — used with Husky — standard tooling
- 7.1.1.4 post-commit — after commit completes — notification / CI trigger — read-only result

#### 7.1.2 Push & Checkout Hooks
- 7.1.2.1 pre-push — runs before push — receive list of refs — run tests before push
  - 7.1.2.1.1 Protect against pushing to main — check ref name — abort if main — safety net
  - 7.1.2.1.2 Run test suite — slow — opt-in — --no-verify for speed — CI is primary gate
- 7.1.2.2 post-checkout — after git checkout — set up environment — install deps if changed
  - 7.1.2.2.1 Check if package.json changed — auto-run npm install — seamless branch switch
- 7.1.2.3 post-merge — after merge / pull — reinstall deps — sync env — auto-run scripts

### 7.2 Server-Side Hooks
#### 7.2.1 Server Hooks
- 7.2.1.1 pre-receive — runs before refs updated — reject push on policy violation — powerful
  - 7.2.1.1.1 Receives old/new SHA per ref — can inspect commit contents — enforce any rule
  - 7.2.1.1.2 Use case — block force push to protected branches — enforce commit signing
- 7.2.1.2 update — per-ref version of pre-receive — called once per pushed ref — finer control
- 7.2.1.3 post-receive — after successful push — trigger CI / send notification / update mirror
  - 7.2.1.3.1 CI trigger — curl webhook — replace if using hosting service native CI

### 7.3 Hook Management Tools
#### 7.3.1 Husky
- 7.3.1.1 Husky — npm package — manage git hooks in package.json — JS/TS projects
  - 7.3.1.1.1 .husky/ directory — hook scripts — version-controlled — shared across team
  - 7.3.1.1.2 npm prepare script — installs hooks on npm install — automatic team setup
- 7.3.1.2 lint-staged — run linters on staged files only — fast pre-commit — targeted
  - 7.3.1.2.1 Config — *.ts: [eslint --fix, prettier --write] — per-glob commands — incremental

#### 7.3.2 Lefthook
- 7.3.2.1 Lefthook — fast Go binary — multi-language — parallel hook execution — no Node required
  - 7.3.2.1.1 lefthook.yml — declarative config — pre-commit / commit-msg / pre-push sections
  - 7.3.2.1.2 Parallel jobs — run linter + type check simultaneously — faster than sequential

---

## 8.0 Submodules & Subtrees

### 8.1 Git Submodules
#### 8.1.1 Submodule Mechanics
- 8.1.1.1 Submodule — nested git repo — parent records (path, URL, SHA) — .gitmodules file
  - 8.1.1.1.1 git submodule add URL path — clone into path + record in .gitmodules
  - 8.1.1.1.2 Parent stores commit SHA — pinned version — not branch — explicit update needed
  - 8.1.1.1.3 .gitmodules — text file — submodule URL + path + branch — committed to repo
- 8.1.1.2 Clone with submodules — git clone --recurse-submodules — or post: git submodule update --init
  - 8.1.1.2.1 --remote-submodules — clone to track remote branch tip — mutable version
- 8.1.1.3 Update submodule — git submodule update --remote — pull latest from upstream
  - 8.1.1.3.1 Detached HEAD in submodule — expected — cd into submodule to work — switch branch

#### 8.1.2 Submodule Pitfalls
- 8.1.2.1 Forgetting to push submodule — parent references unpushed SHA — CI fails — common mistake
  - 8.1.2.1.1 git push --recurse-submodules=on-demand — push submodule first automatically
- 8.1.2.2 Submodule version drift — teammates on different SHA — diverging environments
- 8.1.2.3 Complexity — steep learning curve — automation needed — consider alternatives

### 8.2 Git Subtrees
#### 8.2.1 Subtree Merge Strategy
- 8.2.1.1 git subtree — external repo content merged into subdirectory — no nested .git
  - 8.2.1.1.1 git subtree add --prefix=dir URL branch --squash — add external as subdir
  - 8.2.1.1.2 No .gitmodules — subtree content is part of parent repo — simpler clone
  - 8.2.1.1.3 Contributor does not need to know about subtree — transparent — normal git
- 8.2.1.2 git subtree pull — update subtree from upstream — fetch + merge subtree prefix
  - 8.2.1.2.1 --squash — collapse upstream history — cleaner parent log — recommended
- 8.2.1.3 git subtree push — contribute back to upstream — split subtree + push — two-way sync

#### 8.2.2 Subtree vs Submodule
- 8.2.2.1 Submodule — separate repo — explicit version pinning — complex workflows — best for strict versioning
- 8.2.2.2 Subtree — merged into parent — simpler clone — history mixed — best for shared lib in monorepo
- 8.2.2.3 Vendor directory — copy-paste dependency — no git link — simplest — manual updates only
