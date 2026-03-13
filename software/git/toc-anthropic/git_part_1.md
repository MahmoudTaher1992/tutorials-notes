# Git & Git Hosting Services - Part 1: Data Model & Branching

## 1.0 Git Data Model

### 1.1 Object Types
#### 1.1.1 The Four Objects
- 1.1.1.1 Blob — file content — no name or path — pure bytes — content-addressed
  - 1.1.1.1.1 SHA-1 hash — 40-char hex — hash of "blob {size}\0{content}" — unique ID
  - 1.1.1.1.2 Identical content = same blob — deduplication automatic — efficient storage
- 1.1.1.2 Tree — directory — list of (mode, name, SHA) entries — blobs + subtrees
  - 1.1.1.2.1 Mode — 100644 regular file / 100755 executable / 040000 directory / 120000 symlink
  - 1.1.1.2.2 Recursive — tree points to trees — entire working directory as a tree object
- 1.1.1.3 Commit — snapshot pointer — tree SHA + parent SHA(s) + author + message
  - 1.1.1.3.1 Parent commits — zero (root) / one (normal) / two+ (merge commit) — DAG structure
  - 1.1.1.3.2 Commit immutability — content includes parent SHA — any change = new SHA — hash chain
  - 1.1.1.3.3 Author vs committer — author = who wrote change — committer = who applied — differ on rebase
- 1.1.1.4 Tag — annotated tag — object with tagger + date + message + GPG signature
  - 1.1.1.4.1 Lightweight tag — just a ref pointing to commit — no tag object — no signature
  - 1.1.1.4.2 Annotated tag — full object — signed — immutable — preferred for releases

#### 1.1.2 Content-Addressable Storage
- 1.1.2.1 Object store — .git/objects/ — first 2 chars = subdir — remaining 38 = filename
  - 1.1.2.1.1 Loose objects — one file per object — created on commit — GC packs them later
  - 1.1.2.1.2 Zlib compression — each object deflated — small on disk — fast inflate
- 1.1.2.2 SHA-256 transition — git init --object-format=sha256 — collision resistance — migration path
  - 1.1.2.2.1 SHA-1 weakness — theoretical collision — SHAttered attack — SHA-256 future default
  - 1.1.2.2.2 Compatibility shim — SHA-256 repos work with SHA-1 remotes — interop layer

### 1.2 References
#### 1.2.1 Ref Types
- 1.2.1.1 Branch — .git/refs/heads/branch-name — pointer to commit — moves on new commit
  - 1.2.1.1.1 HEAD — .git/HEAD — points to current branch (symbolic ref) or commit (detached)
  - 1.2.1.1.2 Detached HEAD — HEAD → commit SHA directly — no branch moves — easy to lose work
- 1.2.1.2 Remote tracking ref — refs/remotes/origin/main — last known state of remote — read-only
  - 1.2.1.2.1 Updated on fetch — not on checkout — stale until next fetch
- 1.2.1.3 Tags — refs/tags/ — lightweight = file with SHA — annotated = file pointing to tag object
- 1.2.1.4 Packed refs — .git/packed-refs — many refs in one file — performance optimization
  - 1.2.1.4.1 git pack-refs --all — consolidate loose refs — faster lookup — large repos

### 1.3 The DAG
#### 1.3.1 Commit Graph
- 1.3.1.1 Directed acyclic graph — commits are nodes — parent pointers are edges — no cycles
  - 1.3.1.1.1 Ancestry — commit A is ancestor of B if there is a path B → ... → A
  - 1.3.1.1.2 Reachability — all objects reachable from a ref are retained — unreachable = GC'd
- 1.3.1.2 commit-graph file — .git/objects/info/commit-graph — cached graph — faster operations
  - 1.3.1.2.1 Stores generation numbers — topological sort acceleration — log / merge-base speedup
  - 1.3.1.2.2 git commit-graph write --reachable — regenerate — auto with gc.writeCommitGraph

---

## 2.0 Branching & Merging

### 2.1 Branch Mechanics
#### 2.1.1 Branch Operations
- 2.1.1.1 Create branch — git branch name [start-point] — new ref pointing to start-point
  - 2.1.1.1.1 git switch -c name — create + checkout — modern preferred over checkout -b
  - 2.1.1.1.2 Orphan branch — git switch --orphan name — no parent commit — empty history
- 2.1.1.2 Branch tracking — local branch → remote tracking branch — upstream relationship
  - 2.1.1.2.1 git branch -u origin/main — set upstream — push/pull know where to go
  - 2.1.1.2.2 git branch -vv — show tracking info + ahead/behind counts — status overview

### 2.2 Merge Strategies
#### 2.2.1 Merge Types
- 2.2.1.1 Fast-forward merge — no divergence — just move branch pointer — no merge commit
  - 2.2.1.1.1 --no-ff — force merge commit even if FF possible — preserve branch history
  - 2.2.1.1.2 FF-only — --ff-only — fail if not fast-forwardable — safe linear history
- 2.2.1.2 Three-way merge — merge base + ours + theirs — diff2 approach — creates merge commit
  - 2.2.1.2.1 Merge base — LCA (lowest common ancestor) in commit DAG — git merge-base A B
  - 2.2.1.2.2 Conflict — both sides changed same hunk — must resolve manually
- 2.2.1.3 Octopus merge — merge 3+ branches at once — no conflict resolution — feature branches
- 2.2.1.4 Merge strategies — ort (default) / recursive / resolve / ours / subtree
  - 2.2.1.4.1 ort — Ostensibly Recursive's Twin — replaces recursive — faster — correct renames
  - 2.2.1.4.2 ours — discard theirs entirely — keep our version — diverge intentionally

#### 2.2.2 Conflict Resolution
- 2.2.2.1 Conflict markers — <<<<<<< HEAD / ======= / >>>>>>> branch — manual resolution required
  - 2.2.2.1.1 diff3 style — show merge base in conflict — git config merge.conflictstyle diff3
  - 2.2.2.1.2 zdiff3 — improved — collapse common context — cleaner view — git 2.35+
- 2.2.2.2 Merge tools — git mergetool — vimdiff / IntelliJ / VS Code — three-pane resolution
- 2.2.2.3 rerere — reuse recorded resolution — git config rerere.enabled true — repeat conflicts
  - 2.2.2.3.1 Records conflict + resolution — replays automatically — long-lived branches
  - 2.2.2.3.2 git rerere forget — remove bad recording — reset stored resolution
