# Package Manager Complete Study Guide (Ideal / Angel Method)
## Part 5: Implementations — Other Ecosystems & Anti-Patterns

> **Ideal mappings** reference sections from Parts 1-3.
> Only ecosystem-specific features are expanded here.

---

### Phase 2.6: Python Package Management

#### Ideal Mappings
- SemVer → Ideal §3 (Python uses PEP 440)
- Virtual environments → Ideal §4.2 (isolation strategy)
- Registry → Ideal §6 (PyPI)

#### **Unique: Python**

##### PY.1 pip (classic)
- PY.1.1 `pip install` — installs to global or venv Python
- PY.1.2 `requirements.txt` — flat list of pinned deps, no dependency tree
- PY.1.3 `pip freeze` — output all installed packages with versions
- PY.1.4 `pip install -e .` — editable install for local development
- PY.1.5 `--index-url` / `--extra-index-url` — private registry configuration

##### PY.2 Virtual Environments
- PY.2.1 `venv` — stdlib, creates isolated Python environment
- PY.2.2 `virtualenv` — faster, third-party, more features than venv
- PY.2.3 `conda` — package + environment manager, handles non-Python deps
- PY.2.4 Activation — `source venv/bin/activate` required before use

##### PY.3 Poetry
- PY.3.1 `pyproject.toml` — single config file (PEP 517/518 compliant)
- PY.3.2 `poetry.lock` — deterministic lock file with full dep tree
- PY.3.3 Dependency groups — `[tool.poetry.dev-dependencies]` equivalent to devDeps
- PY.3.4 Virtual env management — auto-creates and manages venvs
- PY.3.5 Publishing — `poetry publish`, built-in build + upload workflow

##### PY.4 uv (Astral, 2024)
- PY.4.1 Rust-based — 10-100x faster than pip for installs
- PY.4.2 Drop-in pip replacement — `uv pip install`, compatible interface
- PY.4.3 `uv.lock` — cross-platform lock file
- PY.4.4 `uv sync` — install all deps from lock file
- PY.4.5 Python version management — `uv python install 3.12`

##### PY.5 PEP 440 Versioning
- PY.5.1 Version scheme — `N[.N]+[{a|b|rc}N][.postN][.devN]`
- PY.5.2 Epoch — `1!1.0` — override version sorting for major resets
- PY.5.3 Compatible release — `~=1.4.2` means `>=1.4.2, <1.5`

---

### Phase 2.7: Rust (Cargo)

#### Ideal Mappings
- Manifest → Ideal §5 (`Cargo.toml`)
- Lock file → Ideal §4.4 (`Cargo.lock`)
- Registry → Ideal §6 (crates.io)

#### **Unique: Cargo**

- RU.1 `Cargo.toml` — `[dependencies]`, `[dev-dependencies]`, `[build-dependencies]`
- RU.2 `Cargo.lock` — committed for binaries, gitignored for libraries
- RU.3 Feature flags — optional feature compilation `[features]` section
- RU.4 Workspace `Cargo.toml` — `[workspace.members]` for monorepo
- RU.5 `cargo add` / `cargo remove` — manifest editing CLI (cargo 1.62+)
- RU.6 `cargo publish` — publish to crates.io
- RU.7 `cargo vendor` — copy all deps locally for offline/air-gapped builds
- RU.8 `[patch]` section — override dep with local path or git fork
- RU.9 Build scripts (`build.rs`) — equivalent to postinstall, compile-time code gen

---

### Phase 2.8: Java/JVM (Maven & Gradle)

#### **Unique: Maven**
- MV.1 `pom.xml` — XML manifest, GAV coordinates (GroupId, ArtifactId, Version)
- MV.2 Maven Central — primary registry (requires GPG signing to publish)
- MV.3 SNAPSHOT versions — `1.0.0-SNAPSHOT` mutable, always re-fetched
- MV.4 Dependency scopes — `compile`, `test`, `provided`, `runtime`, `import`
- MV.5 BOM (Bill of Materials) — import to align versions across dependency set
- MV.6 Plugins — build lifecycle phases, plugin goals, Maven lifecycle

#### **Unique: Gradle**
- GR.1 `build.gradle` / `build.gradle.kts` — Groovy or Kotlin DSL
- GR.2 `gradle.lockfile` — optional deterministic locking (`--write-locks`)
- GR.3 Configurations — `implementation`, `testImplementation`, `api`, `compileOnly`
- GR.4 Version catalogs — `libs.versions.toml` — centralized version management
- GR.5 Build caching — local + Gradle Enterprise remote cache
- GR.6 Configuration cache — cache task configuration for faster re-runs

---

### Phase 2.9: Go Modules

- GO.1 `go.mod` — module path, Go version, `require` directives
- GO.2 `go.sum` — hash of each module version for integrity
- GO.3 Module proxy — `GOPROXY=https://proxy.golang.org` — caching proxy
- GO.4 `replace` directive — redirect to local or forked module
- GO.5 `go get` — add/update dependencies
- GO.6 `go mod tidy` — remove unused deps, add missing, update go.sum
- GO.7 Vendor directory — `go mod vendor` for hermetic offline builds
- GO.8 `GONOSUMCHECK` / `GONOSUMDB` — skip checksum for private modules

---

### Phase 2.10: PHP (Composer) & Ruby (Bundler)

#### Composer
- CP.1 `composer.json` — manifest with `require`, `require-dev`, `autoload`
- CP.2 `composer.lock` — deterministic resolved versions
- CP.3 Packagist — primary PHP registry
- CP.4 `composer install` (lock) vs `composer update` (resolve)
- CP.5 Autoloading — PSR-4, PSR-0 classmap, dump-autoload

#### Bundler (Ruby)
- RB.1 `Gemfile` — manifest, source declaration
- RB.2 `Gemfile.lock` — deterministic versions, commit for apps, not gems
- RB.3 `bundle exec` — run commands in context of bundle
- RB.4 RubyGems registry — gems.org, `.gemspec` for library authoring

---

### 11. Anti-Patterns & Common Mistakes

#### 11.1 Lock File Anti-Patterns
- 11.1.1 Not committing lock file — breaks reproducibility for applications
- 11.1.2 Lock file merge conflicts ignored — blindly accepting one side, broken state
- 11.1.3 Running `npm install` in CI instead of `npm ci` — silent version drift
- 11.1.4 Using `--no-package-lock` flag — defeats the entire point of determinism

#### 11.2 Dependency Anti-Patterns
- 11.2.1 Overusing `dependencies` vs `devDependencies` — bloats consumer install
- 11.2.2 Using `*` or `latest` as version constraint — unpredictable, breaks anytime
- 11.2.3 Pinning exact versions in libraries — too restrictive, causes doppelgangers
- 11.2.4 Ignoring transitive vulnerability warnings — "not my dep" fallacy
- 11.2.5 Never running `npm audit` — security debt accumulates silently

#### 11.3 Publishing Anti-Patterns
- 11.3.1 Publishing secrets — `.env` files, tokens, private keys in tarball
- 11.3.2 Missing `files` field — whole repo included in tarball (dev files, tests, source)
- 11.3.3 No changelog — consumers can't understand what changed between versions
- 11.3.4 Publishing without building — shipping TypeScript source, not compiled JS
- 11.3.5 Accidental major release — breaking change published as minor/patch

#### 11.4 Performance Anti-Patterns
- 11.4.1 Not caching in CI — re-downloading all deps on every run
- 11.4.2 Installing all deps in Docker final stage — should separate build/runtime
- 11.4.3 Not using `--ignore-scripts` in CI — running untrusted postinstall scripts
- 11.4.4 Monorepo without task caching — rebuilding all packages regardless of changes

---

### 12. Ecosystem Comparison Summary

| Feature              | npm          | Yarn Classic  | Yarn Berry   | pnpm         | Bun          |
|----------------------|--------------|---------------|--------------|--------------|--------------|
| Lock file            | JSON v3      | Custom text   | Custom text  | YAML         | Binary       |
| Install strategy     | Hoisted      | Hoisted       | PnP / nm     | Symlinked CAS| Hoisted CAS  |
| Disk efficiency      | Low          | Low           | High (PnP)   | Very High    | High         |
| Strictness           | Low          | Low           | High (PnP)   | High         | Medium       |
| Workspaces           | Yes (v7+)    | Yes           | Yes          | Yes (YAML)   | Yes          |
| Speed                | Medium       | Medium        | Fast         | Fast         | Fastest      |
| npm compat           | Native       | High          | Medium       | High         | High         |
