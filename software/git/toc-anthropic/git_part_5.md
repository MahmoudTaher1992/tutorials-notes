# Git & Git Hosting Services - Part 5: LFS & Security

## 9.0 Git LFS & Security

### 9.1 Git Large File Storage (LFS)
#### 9.1.1 LFS Architecture
- 9.1.1.1 Problem — large binaries inflate git history — slow clone — poor delta compression
  - 9.1.1.1.1 Git stores every version of every file — 100MB binary × 100 commits = 10GB repo
  - 9.1.1.1.2 LFS replaces binary with small pointer file — actual file stored on LFS server
- 9.1.1.2 Pointer file — text file — version + oid (SHA-256 hash) + size — committed to repo
  - 9.1.1.2.1 version https://git-lfs.github.com/spec/v1 — oid sha256:abc... — size 104857600
  - 9.1.1.2.2 Pointer in repo → LFS server maps oid → actual file bytes — transparent checkout
- 9.1.1.3 LFS storage — separate from git objects — HTTPS batch API — authenticated transfers
  - 9.1.1.3.1 git lfs track "*.psd" — add pattern to .gitattributes — future files tracked
  - 9.1.1.3.2 git lfs migrate import — retroactively convert existing large files — rewrite history

#### 9.1.2 LFS Operations
- 9.1.2.1 Install — git lfs install — sets up smudge/clean filters — per-machine setup
  - 9.1.2.1.1 Smudge filter — on checkout — download actual file from LFS — replace pointer
  - 9.1.2.1.2 Clean filter — on add — upload file to LFS — replace with pointer in index
- 9.1.2.2 git lfs clone — fetch LFS objects in batch — faster than sequential checkout
  - 9.1.2.2.1 GIT_LFS_SKIP_SMUDGE=1 — skip LFS download — CI that doesn't need binaries
- 9.1.2.3 git lfs prune — delete locally cached LFS objects — reclaim disk space — safe
  - 9.1.2.3.1 Remote tracking — only prune if also on remote — no data loss — conservative

### 9.2 Commit Signing
#### 9.2.1 GPG Signing
- 9.2.1.1 GPG key pair — private key signs — public key verifies — PGP web of trust
  - 9.2.1.1.1 git config user.signingkey KEY_ID — associate key with git config
  - 9.2.1.1.2 git commit -S — sign this commit — or commit.gpgsign=true — always sign
  - 9.2.1.1.3 git tag -s — signed tag — verify with git tag -v tagname — release integrity
- 9.2.1.2 GPG key management — key expiry / subkeys / smart card / YubiKey — long-term hygiene
  - 9.2.1.2.1 Subkeys for signing — primary key offline — signing subkey on device — best practice
  - 9.2.1.2.2 Key expiry — set 1 year — force renewal review — revocation if compromised

#### 9.2.2 SSH Signing (Git 2.34+)
- 9.2.2.1 SSH key for signing — simpler than GPG — same key as auth — git config gpg.format=ssh
  - 9.2.2.1.1 user.signingKey — path to SSH private key — or SSH agent socket — flexible
  - 9.2.2.1.2 allowed_signers file — map emails to public keys — local verification database
  - 9.2.2.1.3 GitHub / GitLab accept SSH signing keys — verified badge — no GPG needed
- 9.2.2.2 Vigilant mode (GitHub) — mark unsigned commits as "Unverified" — strict posture
  - 9.2.2.2.1 All commits must be signed — unverified = visible — team policy enforcement

### 9.3 Repository Security
#### 9.3.1 Secrets in History
- 9.3.1.1 Accidentally committed secret — rotate immediately — then clean history
  - 9.3.1.1.1 git filter-repo — rewrite all commits — remove file — force push — verify
  - 9.3.1.1.2 Rotation first — cleaning history ≠ secret safe — assume exposed if ever pushed
- 9.3.1.2 Pre-commit secret scanning — detect-secrets / gitleaks — block commit on match
  - 9.3.1.2.1 gitleaks protect --staged — scan staged files — pre-commit hook integration
  - 9.3.1.2.2 Baseline — .gitleaks-baseline.toml — exclude known false positives — reduce noise
- 9.3.1.3 .gitignore — exclude sensitive files — .env / credentials.json / *.pem — prevention
  - 9.3.1.3.1 Global gitignore — $HOME/.gitignore_global — IDE files / OS files — per-machine

#### 9.3.2 Access Control
- 9.3.2.1 Deploy keys — repo-specific SSH key — read-only for CI — least privilege
  - 9.3.2.1.1 Per-repo key — not account-level — compromise scoped to one repo — safer
- 9.3.2.2 Fine-grained PAT — specific repo + permission — expiry — GitHub / GitLab — scoped token
  - 9.3.2.2.1 Avoid classic PAT — too broad — fine-grained token preferred for automation
- 9.3.2.3 SSH certificate authority — organization CA signs user keys — centralized trust
  - 9.3.2.3.1 Expiring certificates — short TTL — automatic rotation — no orphaned keys
