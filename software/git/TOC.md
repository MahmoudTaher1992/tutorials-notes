🌳 Mastering Git for Project Management (Expanded Edition)

├── Ⅰ. Git Fundamentals (The Bedrock)
│   ├── A. Core Concepts
│   │   ├── The Three States (Modified, Staged, Committed) & The Three Trees
│   │   ├── What is a Repository (.git folder)?
│   │   ├── Understanding Commits, Hashes (SHA-1), and Pointers (HEAD)
│   │   └── Local vs. Remote Repositories
│   ├── B. Essential Commands & Configuration
│   │   ├── `git init` & `git clone`
│   │   ├── `git add` (including Interactive Staging & Patching)
│   │   ├── `git commit` (and good commit message practices)
│   │   ├── `git log` (Searching, Formatting, and Filtering)
│   │   └── `git config` (User settings, Colors, and Git Aliases)
│   └── C. Managing Remote Repositories
│       ├── `git remote` (add, show, inspect, rename, remove)
│       ├── `git fetch` (getting changes without merging)
│       ├── `git pull` (fetching and integrating)
│       └── `git push` (sharing your work with remotes)

├── Ⅱ. Branching & Merging (The Core of Collaboration)
│   ├── A. Branching Mechanics
│   │   ├── `git branch` (create, list, manage, delete)
│   │   ├── `git switch` / `git checkout` (navigating branches)
│   │   └── Remote & Tracking Branches (understanding origin/main)
│   ├── B. Combining Work: Merge vs. Rebase
│   │   ├── `git merge` (Fast-forward vs. 3-way merge)
│   │   ├── `git rebase` (The Basic Rebase & More Interesting Rebases)
│   │   ├── The Perils of Rebasing (When not to rebase)
│   │   └── Resolving Merge Conflicts (A critical skill)
│   └── C. Strategic Workflow Models
│       ├── Topic Branches (Short-lived feature branches)
│       ├── Long-Running Branches (develop, main)
│       ├── Centralized & Integration-Manager Workflows
│       └── Forked Public Project Workflow

├── Ⅲ. Managing Project History (Curating a Clean Record)
│   ├── A. Inspecting the Past
│   │   ├── `git show` & `git log` for revision selection (SHA, Ancestry Refs)
│   │   ├── `git blame` (File Annotation)
│   │   └── `git diff` (comparing commits, branches, files)
│   ├── B. Rewriting & Tidying History
│   │   ├── `git commit --amend` (fixing the last commit)
│   │   ├── Interactive Rebase (`rebase -i`): Squashing, Splitting, Reordering
│   │   └── The Nuclear Option: `filter-branch` (for deep history surgery)
│   └── C. Undoing Mistakes (The Safety Net)
│       ├── `git restore` & `git checkout -- <file>`
│       ├── `git reset` (Soft, Mixed, Hard - Demystified)
│       ├── `git revert` (creating a "safe" undo commit)
│       └── `git stash` (saving work-in-progress)

├── Ⅳ. Maintaining a Project & Team Standards
│   ├── A. Tagging & Release Management
│   │   ├── Creating Tags (Annotated vs. Lightweight)
│   │   ├── Listing, Sharing (Pushing), and Checking out Tags
│   │   └── Generating a Build Number & Preparing a Release
│   ├── B. Integrating Contributions
│   │   ├── The Pull/Merge Request Workflow
│   │   ├── Applying Patches from Email
│   │   └── Determining What Is Introduced (Commit Ranges)
│   └── C. Enforcing Quality and Security
│       ├── Commit Guidelines (Establishing team standards)
│       ├── Signing Your Work (GPG for Tags and Commits)
│       └── Client-Side & Server-Side Hooks (Automating policy)

├── Ⅴ. Platform & Tooling (GitHub, GitLab, etc.)
│   ├── A. Account & Organization Management
│   │   ├── SSH Access & Two-Factor Authentication
│   │   ├── Managing Teams and Collaborators
│   │   └── Audit Logs
│   ├── B. The Pull Request Lifecycle
│   │   ├── Forking Projects vs. Direct Collaboration
│   │   ├── Managing Pull Requests (Reviews, Mentions, Notifications)
│   │   └── Special Files: README, CONTRIBUTING
│   └── C. Automation & Scripting
│       ├── Webhooks (for CI/CD integration)
│       └── Using the API (e.g., Octokit for GitHub)

├── Ⅵ. Advanced Git for Managers
│   ├── A. Advanced Tools & Techniques
│   │   ├── `git bisect` (Automated bug hunting via binary search)
│   │   ├── `rerere` (Reuse Recorded Resolution)
│   │   ├── Submodules (Managing project dependencies)
│   │   └── Credential Storage (Helpers for auth)
│   ├── B. Server-Side & Infrastructure
│   │   ├── Understanding Protocols (HTTP, SSH, Git)
│   │   ├── Setting up a Server (Bare Repos, Git Daemon, Smart HTTP)
│   │   └── Self-Hosted Solutions (GitWeb, GitLab)
│   ├── C. Git Internals ("Under the Hood")
│   │   ├── Plumbing and Porcelain
│   │   ├── Git Objects (Blobs, Trees, Commits)
│   │   ├── Git References (Refs) & The Refspec
│   │   └── Packfiles for efficiency
│   └── D. Interoperability
│       ├── Migrating from Other VCS (Subversion, Mercurial, TFS)
│       └── Using Git as a client for other systems