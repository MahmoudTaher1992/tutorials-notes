# Package Manager Complete Study Guide (Ideal / Angel Method)
## Part 2: Ideal Package Manager — Manifest, Registry & Security

---

### 5. The Package Manifest

#### 5.1 Manifest Structure (package.json as reference model)
- 5.1.1 Identity fields — `name`, `version`, `description`, `homepage`, `keywords`
- 5.1.2 Author & license — `author`, `contributors`, `license` (SPDX identifiers)
- 5.1.3 Repository pointer — `repository.url`, `bugs.url` for discoverability
- 5.1.4 Entry points — `main` (CJS), `module` (ESM), `exports` map (conditional exports)
- 5.1.5 `bin` field — declare executable scripts, linked to PATH on install
- 5.1.6 `files` array — explicit allowlist of what gets published (alternative to `.npmignore`)
- 5.1.7 `engines` field — Node.js version requirements, `engineStrict` enforcement
- 5.1.8 `os` & `cpu` fields — platform-specific packages (optional installs)

#### 5.2 Dependency Declaration Fields
- 5.2.1 `dependencies` — required at runtime, installed for consumers
- 5.2.2 `devDependencies` — only needed to develop/test, not installed by consumers
- 5.2.3 `peerDependencies` — host package must provide, not bundled
- 5.2.4 `optionalDependencies` — install if possible, continue if fails
- 5.2.5 `bundleDependencies` (bundledDependencies) — included in published tarball
- 5.2.6 `peerDependenciesMeta` — mark peers as optional, avoid hard failures

#### 5.3 Scripts
- 5.3.1 Lifecycle hooks — `preinstall`, `install`, `postinstall`, `prepare`, `prepublish`
- 5.3.2 Custom scripts — `build`, `test`, `lint`, `start`, `dev`
- 5.3.3 `pre` / `post` prefix convention — `prebuild`, `postbuild` auto-chaining
- 5.3.4 Script environment — `PATH` includes `node_modules/.bin` automatically
- 5.3.5 Cross-platform scripts — `cross-env`, `rimraf` for Windows compatibility
- 5.3.6 Security risk of `postinstall` — arbitrary code execution on install

#### 5.4 Conditional Exports (`exports` field)
- 5.4.1 Path mapping — `"."` → `./dist/index.js` precise subpath control
- 5.4.2 Condition keys — `import` (ESM), `require` (CJS), `browser`, `node`, `default`
- 5.4.3 Subpath exports — `"./utils"` → `./dist/utils.js` (prevent deep imports)
- 5.4.4 Subpath patterns — wildcard patterns for directory exports
- 5.4.5 Package self-referencing — import your own package by name in tests
- 5.4.6 Dual CJS+ESM publishing — shipping both formats, avoiding dual-package hazard

---

### 6. Registry Interaction

#### 6.1 Registry Protocol
- 6.1.1 npm registry API — RESTful JSON, CouchDB-based document structure
- 6.1.2 Package metadata endpoint — `GET /<name>` returns all versions + metadata
- 6.1.3 Version-specific metadata — `GET /<name>/<version>` returns single version
- 6.1.4 Tarball download — `GET /<name>/-/<name>-<version>.tgz`
- 6.1.5 Registry API authentication — Bearer token, `Authorization` header
- 6.1.6 OCI-based registries — emerging standard for non-JS ecosystems

#### 6.2 Authentication & Configuration
- 6.2.1 `.npmrc` file — registry URL, auth tokens, proxy settings (per-scope config)
- 6.2.2 Token types — legacy auth token, granular access token, automation token
- 6.2.3 Scoped registry configuration — `@myorg:registry=https://my.registry.com`
- 6.2.4 `npm login` / `npm token` — interactive vs CI token management
- 6.2.5 2FA on publish — required for popular packages on npm registry
- 6.2.6 CI/CD authentication — environment variables, secret injection, token rotation

#### 6.3 Scopes & Namespaces
- 6.3.1 Scoped packages — `@org/package` — namespace prevents name collisions
- 6.3.2 Public vs private scopes — `@org/package` can be public on npm.com
- 6.3.3 Scope-to-registry mapping — redirect `@company/*` to private registry
- 6.3.4 Dist-tags — `npm dist-tag add pkg@1.0.0 stable` — named aliases
- 6.3.5 Package deprecation — `npm deprecate` — warn consumers without unpublishing
- 6.3.6 Unpublish policy — npm 72-hour window, `npm unpublish` implications

#### 6.4 Private Registries
- 6.4.1 Use cases — proprietary code, security controls, bandwidth savings, air-gapped
- 6.4.2 Verdaccio — open-source, proxy + cache + private storage
- 6.4.3 GitHub Packages — registry tied to GitHub org, GitHub Actions integration
- 6.4.4 AWS CodeArtifact — IAM-based auth, cross-account, multiple formats
- 6.4.5 JFrog Artifactory — enterprise, multi-format (npm, PyPI, Maven, Docker)
- 6.4.6 Google Artifact Registry — multi-format, VPC-SC, Workload Identity
- 6.4.7 Sonatype Nexus — enterprise, OSSRH gateway to Maven Central

---

### 7. Security

#### 7.1 Threat Model
- 7.1.1 Typosquatting — `lodash` vs `lodashs`, `event-emitter` vs `eventemitter`
- 7.1.2 Dependency confusion — internal package name published to public registry
- 7.1.3 Account takeover — compromised maintainer credentials → malicious publish
- 7.1.4 Malicious `postinstall` — install hook runs arbitrary code on developer machines
- 7.1.5 Protestware — maintainer adds political messaging or destructive payload
- 7.1.6 Vulnerable transitive deps — your dep's dep has a CVE you inherit
- 7.1.7 Subdependency sprawl — 1 direct dep → 500 transitive deps, unmanageable surface

#### 7.2 Defense Mechanisms
- 7.2.1 `npm audit` — checks dependency tree against npm Advisory Database
- 7.2.2 Integrity hashes — `sha512` in lock file verified on install
- 7.2.3 Lock file commitment — reproducible installs, prevent silent version drift
- 7.2.4 Package signing — Sigstore, npm provenance attestations (2023+)
- 7.2.5 SBOM (Software Bill of Materials) — CycloneDX, SPDX — full dep inventory
- 7.2.6 Supply chain frameworks — SLSA levels, provenance for build artifacts
- 7.2.7 Disable `postinstall` — `--ignore-scripts` flag for CI environments

#### 7.3 Vulnerability Management
- 7.3.1 npm audit fix — auto-apply compatible updates for audited issues
- 7.3.2 npm audit fix --force — allows major version bumps (may break things)
- 7.3.3 Overrides / resolutions — force a specific version of a transitive dep
- 7.3.4 Dependabot — GitHub-native automated PR for vulnerable dep updates
- 7.3.5 Renovate Bot — more configurable alternative to Dependabot
- 7.3.6 Snyk / Socket.dev / Grype — deeper analysis, runtime risk scoring
- 7.3.7 CVE databases — NVD, OSV (Open Source Vulnerabilities), GitHub Advisory DB

#### 7.4 Registry Security Practices
- 7.4.1 Scoped packages for internal code — prevent dependency confusion by pre-claiming names
- 7.4.2 Private registry with allowlist — only pre-approved packages installable
- 7.4.3 Token principle of least privilege — separate publish vs read-only tokens
- 7.4.4 Audit CI gates — block builds with unresolved high/critical audit findings
- 7.4.5 Package provenance linking — npm ≥9.5 `--provenance` links build to source + CI
- 7.4.6 2FA enforcement — organization-level mandatory 2FA for publish actions
