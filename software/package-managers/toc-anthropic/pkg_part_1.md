# Package Manager Complete Study Guide (Ideal / Angel Method)
## Part 1: Ideal Package Manager — Foundation & Core Concepts

---

### 1. The Problem Space

#### 1.1 Why Package Managers Exist
- 1.1.1 Dependency hell — incompatible versions, circular dependencies, manual tracking
- 1.1.2 "Works on my machine" problem — non-reproducible environments
- 1.1.3 The before-times — manual DLL copying, vendoring, copy-paste source
- 1.1.4 The npm left-pad incident — fragility of shared global dependency graphs
- 1.1.5 Security supply chain risk — malicious packages, typosquatting, maintainer takeover
- 1.1.6 Disk space explosion — node_modules becoming the heaviest known object

#### 1.2 What an Ideal Package Manager Does
- 1.2.1 Dependency resolution — finds a consistent set of versions satisfying all constraints
- 1.2.2 Reproducibility — same input always produces identical environment
- 1.2.3 Security — verifies integrity of every installed package
- 1.2.4 Performance — fast installs, smart caching, minimal network/disk I/O
- 1.2.5 Registry interaction — publish, fetch, search, authenticate
- 1.2.6 Developer experience — clear errors, helpful warnings, fast feedback

---

### 2. Core Concepts

#### 2.1 Fundamental Terminology
- 2.1.1 Package — self-contained unit of reusable code with a name and version
- 2.1.2 Registry — centralized server hosting packages (npmjs.com, PyPI, crates.io)
- 2.1.3 Manifest — project metadata file declaring dependencies (`package.json`, `Cargo.toml`)
- 2.1.4 Lock file — snapshot of exact resolved versions + integrity hashes
- 2.1.5 Direct dependency — explicitly declared in your manifest
- 2.1.6 Transitive dependency — dependency of a dependency (indirect)
- 2.1.7 Dependency graph — DAG (Directed Acyclic Graph) of all package relationships
- 2.1.8 Peer dependency — "requires a compatible version provided by the parent"

#### 2.2 Dependency Tree Problems
- 2.2.1 Diamond dependency — A→B, A→C, B→D@1, C→D@2 — version conflict
- 2.2.2 Phantom dependencies — using packages not in your manifest (hoisting side-effect)
- 2.2.3 Doppelgangers — multiple copies of same package at different versions
- 2.2.4 Dependency confusion attack — private package name shadowed by malicious public one
- 2.2.5 Circular dependencies — A→B→A — detection and resolution strategies
- 2.2.6 Deeply nested trees — O(n²) duplication in naive nested install strategies

#### 2.3 Determinism
- 2.3.1 Deterministic installs — same manifest + lock file = identical result, always
- 2.3.2 Non-deterministic causes — floating ranges, registry mutable tags (`:latest`)
- 2.3.3 Lock file as determinism guarantee — must be committed to VCS
- 2.3.4 Integrity hashes — SHA-512 checksums verify packages are unmodified
- 2.3.5 Reproducible builds — byte-for-byte identical output regardless of environment
- 2.3.6 Hermetic builds — no network access at build time, all deps pre-fetched

---

### 3. Semantic Versioning (SemVer)

#### 3.1 The MAJOR.MINOR.PATCH Model
- 3.1.1 PATCH (0.0.X) — backward-compatible bug fixes only
- 3.1.2 MINOR (0.X.0) — backward-compatible new functionality
- 3.1.3 MAJOR (X.0.0) — breaking changes; consumers must update their code
- 3.1.4 Zero-version (0.Y.Z) — anything may change, no stability guarantees
- 3.1.5 Version lock-step problem — libraries at v0 that never ship v1

#### 3.2 Version Constraint Syntax
- 3.2.1 Exact — `1.2.3` — only this version, no flexibility
- 3.2.2 Caret (`^1.2.3`) — allow MINOR and PATCH upgrades (≥1.2.3 <2.0.0)
- 3.2.3 Tilde (`~1.2.3`) — allow PATCH upgrades only (≥1.2.3 <1.3.0)
- 3.2.4 Wildcard (`1.2.*`) — allow any PATCH version
- 3.2.5 Range (`>=1.2.3 <2.0.0`) — explicit range, maximum control
- 3.2.6 Hyphen range (`1.2.3 - 2.3.4`) — inclusive both ends

#### 3.3 Pre-release & Metadata
- 3.3.1 Pre-release identifiers — `1.0.0-alpha.1`, `1.0.0-beta.2`, `1.0.0-rc.1`
- 3.3.2 Build metadata — `1.0.0+build.123` — ignored in version comparison
- 3.3.3 Dist-tags — `latest`, `next`, `beta` — human-readable aliases for versions
- 3.3.4 Breaking change communication — CHANGELOG.md, migration guides, deprecation notices

#### 3.4 SemVer Violations & Problems
- 3.4.1 Accidental breaking changes in PATCH — common source of production incidents
- 3.4.2 "SemVer theater" — claiming compliance without actual guarantees
- 3.4.3 Calendar versioning (CalVer) — `YYYY.MM.DD` — alternative to SemVer
- 3.4.4 Lock file as the real source of truth — not the range in the manifest

---

### 4. Dependency Resolution

#### 4.1 Resolution Algorithm (Conceptual)
- 4.1.1 Input — manifest file with version constraints for direct deps
- 4.1.2 Fetch package metadata — registry lookup for available versions
- 4.1.3 Constraint solving — find versions satisfying all constraints simultaneously
- 4.1.4 SAT solver vs backtracking — different resolution strategies across ecosystems
- 4.1.5 Conflict detection — incompatible constraints → error with explanation
- 4.1.6 Output — fully-resolved dependency graph → written to lock file

#### 4.2 Installation Strategies
- 4.2.1 Nested install — each package gets its own `node_modules` subtree (npm v1-v2)
- 4.2.2 Flat/hoisted install — deduplicate by lifting common versions to root (npm v3+, yarn)
- 4.2.3 Symlinked content-addressable store — one copy on disk, hard links per project (pnpm)
- 4.2.4 Plug'n'Play (PnP) — no `node_modules` at all, zip archives + custom resolver (Yarn Berry)
- 4.2.5 Zero-install — lock file contains package zips, no install step required (Yarn Berry)
- 4.2.6 Store isolation — global cache vs project-local install vs hermetic

#### 4.3 Peer Dependency Resolution
- 4.3.1 What peer deps express — "I work alongside X but don't bundle it"
- 4.3.2 npm v7+ auto-installs peers — breaking change from v6 behavior
- 4.3.3 Peer dep conflicts — multiple packages requiring incompatible peer versions
- 4.3.4 Optional peer deps — `peerDependenciesMeta.optional: true`
- 4.3.5 Plugin ecosystems — Babel plugins, ESLint configs, Webpack loaders rely on peers
- 4.3.6 Resolution order — how managers choose between conflicting peer requirements

#### 4.4 The Lock File in Depth
- 4.4.1 What is stored — exact version, resolved URL, integrity hash, dependencies
- 4.4.2 When to commit — always (applications); debated for libraries
- 4.4.3 When lock file is updated — install, add, remove, update, upgrade commands
- 4.4.4 Lock file conflicts in git — how to resolve merge conflicts safely
- 4.4.5 Lock file formats — `package-lock.json` v3, `yarn.lock`, `pnpm-lock.yaml`
- 4.4.6 `npm ci` vs `npm install` — lock-file-only install vs resolve-and-update
