# Package Manager Complete Study Guide (Ideal / Angel Method)
## Part 3: Ideal Package Manager — Performance, Monorepos & Publishing

---

### 8. Performance & Caching

#### 8.1 The Install Pipeline
- 8.1.1 Resolve phase — read manifest, check lock file, query registry metadata
- 8.1.2 Fetch phase — download tarballs, check cache first, verify integrity
- 8.1.3 Extract phase — decompress tarballs, write files to disk
- 8.1.4 Link phase — create `node_modules` structure (copy, symlink, or PnP)
- 8.1.5 Script phase — run lifecycle hooks (`postinstall`, `prepare`)
- 8.1.6 Parallelism — fetch/extract multiple packages concurrently

#### 8.2 Caching Strategies
- 8.2.1 Global cache location — `~/.npm/_cacache`, `~/.yarn/cache`, `~/.pnpm-store`
- 8.2.2 Cache key — package name + version + integrity hash
- 8.2.3 Offline mode — install from cache only, no network access
- 8.2.4 Content-addressable storage (CAS) — one copy of package bits per unique content
- 8.2.5 Hard links vs copies — pnpm hard-links from CAS, npm/yarn copy files
- 8.2.6 Cache invalidation — version change, corrupted cache, `--force` flag

#### 8.3 CI/CD Performance
- 8.3.1 Cache the global store — restore ~/.npm or ~/.pnpm-store between CI runs
- 8.3.2 `npm ci` for CI — strict lock file install, no manifest resolution, faster
- 8.3.3 Frozen lock file flags — `--frozen-lockfile` (yarn), `--ci` (pnpm)
- 8.3.4 Cache key strategy — hash `package-lock.json` or `yarn.lock` for cache invalidation
- 8.3.5 Layer caching in Docker — COPY package.json first, RUN npm ci, then COPY src
- 8.3.6 Remote caching (Turborepo/Nx) — share build caches across developers + CI

#### 8.4 Disk Space Optimization
- 8.4.1 Deduplication — single copy of package at compatible version
- 8.4.2 `npm dedupe` — post-install flatten to remove unnecessary duplicates
- 8.4.3 pnpm CAS — one copy per unique version globally across all projects
- 8.4.4 Yarn PnP — zero `node_modules`, packages as zip archives in cache
- 8.4.5 `node_modules` cleanup — `npx npkill`, regular pruning of old projects
- 8.4.6 Pruning devDependencies — `npm prune --production` for container images

---

### 9. Monorepos & Workspaces

#### 9.1 Workspace Fundamentals
- 9.1.1 Monorepo definition — multiple packages in a single git repository
- 9.1.2 Workspace config — `workspaces: ["packages/*"]` in root `package.json`
- 9.1.3 Workspace symlinks — workspace packages symlinked into root `node_modules`
- 9.1.4 Cross-package dependencies — `"@myorg/utils": "*"` or `"workspace:*"`
- 9.1.5 Workspace protocol — `workspace:^` (pnpm), `workspace:*` (yarn) — local reference
- 9.1.6 Shared devDependencies — hoisted to root, reduce duplication

#### 9.2 Monorepo Tooling

##### Turborepo
- 9.2.1 Task graph — defines which tasks depend on other tasks across packages
- 9.2.2 Remote caching — Vercel cloud cache or self-hosted, share between developers + CI
- 9.2.3 `turbo.json` — pipeline configuration, inputs, outputs, cache keys
- 9.2.4 Incremental builds — only rebuild changed packages and their dependents
- 9.2.5 Parallel execution — run tasks across all packages concurrently

##### Nx
- 9.2.6 Affected commands — `nx affected:build` — only affected by git changes
- 9.2.7 Project graph — visual dependency graph, computation caching
- 9.2.8 Generators (schematics) — scaffolding new packages, consistent structure
- 9.2.9 Executors — wrapper around build/test tools, Nx-aware

##### Lerna
- 9.2.10 Legacy tool — original monorepo manager, now maintained by Nx team
- 9.2.11 `lerna publish` — version bumping + publishing multiple packages
- 9.2.12 Independent vs fixed versioning — per-package vs synchronized version

#### 9.3 Workspace Best Practices
- 9.3.1 Package naming convention — `@scope/package-name` consistency
- 9.3.2 Shared tsconfig/eslint configs — extracted as workspace packages
- 9.3.3 Versioning strategy — independent (each package), fixed (all together)
- 9.3.4 Changesets — structured changelogs and version bumping tool
- 9.3.5 Boundary enforcement — ESLint `import/no-internal-modules` rules
- 9.3.6 Build output isolation — each package builds to its own `dist/` directory

---

### 10. Package Authoring & Publishing

#### 10.1 Package Initialization
- 10.1.1 `npm init` / `npm init <template>` — scaffold a new package
- 10.1.2 Choosing a package name — unique, descriptive, scoped when private
- 10.1.3 License selection — MIT, Apache-2.0, ISC for open source; UNLICENSED for private
- 10.1.4 Repository linking — `.repository` in package.json for discoverability
- 10.1.5 README conventions — description, install, usage, API reference, contributing

#### 10.2 Entry Points & Module Formats
- 10.2.1 CommonJS (CJS) — `require()`, `.cjs` extension, `"main"` field
- 10.2.2 ES Modules (ESM) — `import`, `.mjs` extension, `"module"` field
- 10.2.3 Dual-mode publishing — ship both CJS + ESM, `exports` map to select
- 10.2.4 TypeScript declarations — `"types"` field, `.d.ts` files, declaration maps
- 10.2.5 Tree-shaking support — ESM with named exports, avoid side-effect imports
- 10.2.6 `sideEffects` field — tell bundlers which files have side effects

#### 10.3 The Publishing Process
- 10.3.1 `npm version [patch|minor|major]` — bump version, create git tag
- 10.3.2 `npm pack` — dry-run: preview what gets published
- 10.3.3 `npm publish [--tag beta]` — publish to registry with optional dist-tag
- 10.3.4 `.npmignore` vs `files` field — control what's included in tarball
- 10.3.5 Publish checklist — tests pass, changelog updated, version bumped, tag pushed
- 10.3.6 `--dry-run` flag — rehearse publish without sending to registry

#### 10.4 Automated Releases
- 10.4.1 semantic-release — fully automated: version, changelog, publish from commits
- 10.4.2 Conventional Commits — `feat:`, `fix:`, `chore:`, `BREAKING CHANGE:` prefixes
- 10.4.3 Changesets — explicit change files, human-curated changelog, monorepo-aware
- 10.4.4 Release-please (Google) — PR-based automated release management
- 10.4.5 GitHub Actions release workflow — on tag push → test → publish
- 10.4.6 NPM publish tokens — automation token type, no 2FA prompt in CI

#### 10.5 Versioning Strategy
- 10.5.1 When to bump MAJOR — any breaking change in public API
- 10.5.2 When to bump MINOR — new backward-compatible feature or export
- 10.5.3 When to bump PATCH — bug fix, internal refactor, doc update
- 10.5.4 Deprecation — `npm deprecate pkg@"<2.0.0" "Upgrade to 2.x"` — warn consumers
- 10.5.5 Breaking change migration guides — MIGRATION.md, codemod scripts
- 10.5.6 `@deprecated` JSDoc — signal at usage site before library update
