# Git & Bitbucket: Comprehensive Study Table of Contents

## Part I: Git Fundamentals & Core Concepts

### A. Introduction to Distributed Version Control
*   **What is Version Control?** The motivation behind tracking changes.
*   **Centralized vs. Distributed VCS:** Key differences and the benefits of a distributed model.
*   **Git's Philosophy:** Understanding the core principles of speed, simplicity, and non-linear development.
*   **The Three States of a File:** Working Directory, Staging Area (Index), and Repository (`.git` directory).
*   **Bitbucket as a Git Host:** The role of a remote repository and collaboration platform.

### B. Setting Up Your Environment
*   **Installing Git:** Configuration for different operating systems (Windows, macOS, Linux).
*   **First-Time Git Configuration:** Setting your username and email (`git config`).
*   **Creating a Bitbucket Account:** Navigating the Bitbucket interface.
*   **Authentication:**
    *   Setting up SSH keys for secure communication with Bitbucket.
    *   Using HTTPS with App Passwords.

### C. Basic Git Commands & Workflow
*   **Initializing a Repository:** `git init`.
*   **Cloning an Existing Repository:** `git clone`.
*   **The Basic Workflow:**
    *   Checking the Status: `git status`.
    *   Staging Changes: `git add`.
    *   Committing Changes: `git commit`.
*   **Viewing History:** `git log` and its various formatting options.
*   **Pushing Changes to Bitbucket:** `git push`.
*   **Pulling Changes from Bitbucket:** `git pull`.
*   **Ignoring Files:** The purpose and syntax of `.gitignore`.

## Part II: Branching, Merging, & Collaboration

### A. Branching in Git
*   **What are Branches?** The power of isolated development.
*   **Creating Branches:** `git branch <branch-name>`.
*   **Switching Branches:** `git checkout <branch-name>` and `git switch <branch-name>`.
*   **Creating and Switching in One Command:** `git checkout -b <new-branch-name>`.
*   **Listing and Deleting Branches.**
*   **HEAD Pointer:** Understanding what it is and how it moves.

### B. Merging Strategies
*   **Fast-Forward Merge:** The simplest merge scenario.
*   **Three-Way Merge (Recursive):** Handling divergent branches.
*   **Resolving Merge Conflicts:** Identifying and fixing conflicts manually.

### C. Rebasing
*   **`git rebase` vs. `git merge`:** The pros and cons of each.
*   **Interactive Rebasing (`git rebase -i`):**
    *   Squashing, reordering, and editing commits.
    *   Maintaining a clean and linear history.
*   **The Golden Rule of Rebasing:** Never rebase public branches.

### D. Bitbucket for Collaboration
*   **Pull Requests (PRs):** The core of code review and collaboration.
    *   Creating a Pull Request in Bitbucket.
    *   The review process: adding reviewers, leaving comments, and requesting changes.
    *   Merging an approved Pull Request.
*   **Forks:** Contributing to repositories you don't have write access to.

## Part III: Advanced Git Concepts & Commands

### A. Undoing Changes
*   **Amending the Last Commit:** `git commit --amend`.
*   **Reverting Commits:** `git revert`.
*   **Resetting Commits:** `git reset` (soft, mixed, hard).
*   **Cleaning the Working Directory:** `git clean`.
*   **The Reflog:** Recovering "lost" commits.

### B. Advanced Tools
*   **Stashing Changes:** `git stash` to save uncommitted work.
*   **Cherry-Picking:** `git cherry-pick` to apply specific commits from another branch.
*   **Git Tags:** Creating lightweight and annotated tags for releases.
*   **Git Hooks:** Automating tasks at different points in the Git workflow.
*   **Submodules and Subtrees:** Managing repositories within other repositories.

### C. Git Internals
*   **The Object Model:** Blobs, trees, commits, and tags.
*   **Understanding the `.git` directory.**

## Part IV: Bitbucket Administration & Workflows

### A. Repository Management
*   **Creating and Deleting Repositories.**
*   **Repository Settings:** General settings, descriptions, and project keys.
*   **Importing and Forking Repositories.**

### B. User and Group Management
*   **Access Control:** Read, write, and admin permissions.
*   **Global, Project, and Repository Permissions.**
*   **Branch Permissions:** Restricting pushes and merges to specific branches.

### C. Common Branching Strategies
*   **Git Flow:** A structured approach with feature, develop, release, and hotfix branches.
*   **GitHub Flow:** A simpler model based on feature branches and pull requests.
*   **GitLab Flow:** A variation that incorporates environment branches.
*   **Trunk-Based Development:** A strategy of committing directly to a single main branch.

### D. Security Best Practices
*   **Enforcing Two-Factor Authentication (2FA).**
*   **IP Whitelisting.**
*   **Regularly Rotating Keys and Passwords.**
*   **Scanning for Sensitive Data in Repositories.**

## Part V: CI/CD & Automation with Bitbucket Pipelines

### A. Introduction to CI/CD
*   **Core Concepts:** Continuous Integration, Continuous Delivery, Continuous Deployment.
*   **The Role of Bitbucket Pipelines.**

### B. Getting Started with Pipelines
*   **Enabling Pipelines for a Repository.**
*   **The `bitbucket-pipelines.yml` file:** Structure and syntax.
*   **Defining Steps and Scripts.**
*   **Using Docker Images as Build Environments.**

### C. Advanced Pipeline Configuration
*   **Using Caching to Speed Up Builds.**
*   **Parallel Steps for Faster Testing.**
*   **Scheduled Pipelines.**
*   **Deployments to Different Environments (Test, Staging, Production).**
*   **Variables and Secrets Management.**

## Part VI: Integrations & Tooling

### A. Jira Integration
*   **Connecting Bitbucket and Jira.**
*   **Smart Commits:** Referencing Jira issues in commit messages, branch names, and pull requests.
*   **Viewing Development Information in Jira.**
*   **Creating Branches from Jira Issues.**

### B. Working with the Command Line
*   **Bitbucket CLI:** Interacting with Bitbucket from the command line for automation.

### C. Git GUI Clients
*   **Sourcetree:** Atlassian's free Git client.
*   **GitKraken:** A popular cross-platform Git GUI.
*   **IDE Integrations:** Using Git and Bitbucket within VS Code, IntelliJ, etc.

## Part VII: Performance & Troubleshooting

### A. Git Performance Optimization
*   **Managing Large Repositories:**
    *   Git LFS (Large File Storage).
    *   Shallow clones (`--depth`).
*   **Garbage Collection:** `git gc` for repository maintenance.
*   **Optimizing for Repositories with Many Files.**

### B. Troubleshooting Common Issues
*   **Common Git Errors and Their Solutions.**
*   **Debugging Pipeline Failures.**
*   **Resolving Complex Merge Conflicts.**

---

### **Appendices**
*   **Glossary of Git and Bitbucket Terms.**
*   **Git Command Quick Reference.**
*   **Further Reading and Resources.**