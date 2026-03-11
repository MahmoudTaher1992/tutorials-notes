# Package Manager Complete Study Guide (Ideal / Angel Method)
## Part 4: Implementations — JavaScript Ecosystem (npm, Yarn, pnpm, Bun)

> **Ideal mappings** reference sections from Parts 1-3.
> Only features **unique** to each implementation are expanded here.

---

### Phase 2.1: npm

#### Ideal Mappings
- Dependency resolution → Ideal §4.1
- Lock file → Ideal §4.4
- Registry → Ideal §6
- Security → Ideal §7
- Publishing → Ideal §10

#### **Unique: npm**

##### NPM.1 History & Architecture
- NPM.1.1 npm v1-v2 — nested install, extreme duplication
- NPM.1.2 npm v3 — flat/hoisted install, determinism issues
- NPM.1.3 npm v5 — lock file (`package-lock.json`) introduced
- NPM.1.4 npm v7 — workspaces, peer deps auto-install, `package-lock.json` v2
- NPM.1.5 npm v8-v10 — overrides field, `package-lock.json` v3, provenance

##### NPM.2 Key Commands
- NPM.2.1 `npm install` — resolve + fetch + link, updates lock file
- NPM.2.2 `npm ci` — clean install from lock file only, faster, no lock file update
- NPM.2.3 `npm install --save-dev/-D` — add to devDependencies
- NPM.2.4 `npm install --save-optional/-O` — add to optionalDependencies
- NPM.2.5 `npm update` — update deps within SemVer range, update lock file
- NPM.2.6 `npm outdated` — show packages with newer versions available
- NPM.2.7 `npm ls` — display installed dependency tree
- NPM.2.8 `npm exec` / `npx` — run package binaries without global install

##### NPM.3 Unique Features
- NPM.3.1 `overrides` field — force specific transitive dep version
- NPM.3.2 `npm fund` — list funding info for installed packages
- NPM.3.3 npm provenance — `--provenance` links published package to source + CI run
- NPM.3.4 Workspaces — `--workspace/-w` flag for targeted workspace commands
- NPM.3.5 `npm explain` — trace why a package is in the tree
- NPM.3.6 `npm query` — CSS-selector-like queries over dependency graph (npm v8.18+)

---

### Phase 2.2: Yarn (Classic v1 + Berry v2+)

#### Ideal Mappings
- Workspaces → Ideal §9.1
- Caching → Ideal §8.2
- Security → Ideal §7

#### **Unique: Yarn Classic (v1)**
- YC.1 `yarn.lock` format — custom format, not JSON, human-readable diff-friendly
- YC.2 Parallel installs — concurrent fetches from the start (faster than early npm)
- YC.3 Offline mirror — `yarn-offline-mirror` for fully offline installs
- YC.4 `yarn why` — explain why a package is installed
- YC.5 `resolutions` field — force specific transitive dep version (predates npm overrides)
- YC.6 Legacy workspaces — original workspace implementation, still widely used

#### **Unique: Yarn Berry (v2+)**

##### YB.1 Plug'n'Play (PnP) Architecture
- YB.1.1 No `node_modules` — packages stored as zip archives in `.yarn/cache`
- YB.1.2 `.pnp.cjs` loader — custom Node.js resolver maps packages to cache locations
- YB.1.3 Strict mode — phantom dependency errors surface immediately
- YB.1.4 Zero-install — commit `.yarn/cache` to git, no install step needed
- YB.1.5 IDE integration — `yarn dlx @yarnpkg/sdks` to configure editor PnP support

##### YB.2 Berry-Specific Features
- YB.2.1 `workspace:` protocol — `"@myorg/utils": "workspace:^"` cross-workspace deps
- YB.2.2 `portal:` protocol — symlink to external directory (like link: but different)
- YB.2.3 Constraints — Turing-complete workspace dependency rules (`constraints.pro`)
- YB.2.4 Yarn plugins — extend Yarn with custom resolvers, fetchers, commands
- YB.2.5 `nodeLinker` setting — `pnp` (default), `node-modules` (compat), `pnpm` (hard links)
- YB.2.6 `.yarnrc.yml` — YAML config, replaces `.npmrc` for Berry projects

---

### Phase 2.3: pnpm

#### Ideal Mappings
- Content-addressable store → Ideal §8.2.4
- Monorepos/Workspaces → Ideal §9
- Security (strictness) → Ideal §7

#### **Unique: pnpm**

##### PM.1 Content-Addressable Store
- PM.1.1 Global store at `~/.pnpm-store` — one copy per unique package version globally
- PM.1.2 Hard links — project `node_modules` uses hard links to store (instant, zero disk)
- PM.1.3 Symlinked `node_modules` — only direct deps symlinked at top level (strict mode)
- PM.1.4 Virtual store — `node_modules/.pnpm` flat structure of all packages
- PM.1.5 Store integrity — `pnpm store status` verifies store not corrupted
- PM.1.6 `pnpm store prune` — remove unreferenced packages from global store

##### PM.2 Strictness by Default
- PM.2.1 No phantom dependency access — can't import packages not in your manifest
- PM.2.2 No doppelgangers — single copy of each version, enforced by architecture
- PM.2.3 `shamefully-hoist` — escape hatch for broken packages expecting npm behavior
- PM.2.4 `hoist-pattern` — selectively hoist specific packages (e.g., types)
- PM.2.5 `public-hoist-pattern` — hoist to root node_modules for tooling compatibility

##### PM.3 pnpm-Specific CLI
- PM.3.1 `pnpm add` — add to dependencies
- PM.3.2 `pnpm import` — generate pnpm lockfile from existing npm/yarn lock
- PM.3.3 `pnpm store` — manage global content-addressable store
- PM.3.4 `pnpm patch` — patch a transitive dependency locally
- PM.3.5 `pnpm --filter` — target specific workspace packages
- PM.3.6 `pnpm -r` / `--recursive` — run command in all workspace packages

##### PM.4 pnpm Workspace
- PM.4.1 `pnpm-workspace.yaml` — workspace root config, `packages:` glob patterns
- PM.4.2 `workspace:*` protocol — link to local workspace package
- PM.4.3 Catalogs (pnpm v9+) — shared dependency version definitions across workspace
- PM.4.4 `pnpm publish -r` — publish all changed workspace packages

---

### Phase 2.4: Bun

#### Ideal Mappings
- Install performance → Ideal §8.1
- npm compatibility → Ideal §5, §6

#### **Unique: Bun**

##### BN.1 Architecture
- BN.1.1 JavaScriptCore engine — WebKit engine (vs V8 in Node.js), significant speed difference
- BN.1.2 Zig implementation — low-level systems language for maximum performance
- BN.1.3 All-in-one runtime — runtime + bundler + test runner + package manager in one binary
- BN.1.4 npm compatibility — reads `package.json`, `node_modules`, publishes to npm

##### BN.2 Package Manager Features
- BN.2.1 `bun install` — claimed 10-25x faster than npm due to parallel I/O
- BN.2.2 `bun.lockb` — binary lock file format, human-unreadable but faster to parse
- BN.2.3 Global cache — similar to pnpm store, deduplicates across projects
- BN.2.4 `bun add/remove` — familiar npm-like interface
- BN.2.5 Workspaces — supports npm-style workspaces
- BN.2.6 Trust-on-install — `postinstall` scripts disabled by default, `--trust` to enable

---

### Phase 2.5: Runtime-Native Package Management

#### Deno
- DN.1 URL imports — `import { serve } from "https://deno.land/std/http/server.ts"`
- DN.2 Import maps — `deno.json` maps bare specifiers to URLs, centralized versions
- DN.3 `deno.lock` — integrity lock file for URL-based imports
- DN.4 `jsr:` specifier — JSR (JavaScript Registry) for TypeScript-first packages
- DN.5 `npm:` specifier — `import lodash from "npm:lodash"` — use npm packages without install
- DN.6 Deno workspaces — `deno.json` workspace config, monorepo support

#### Node.js corepack
- CP.1 What corepack is — built-in Node.js tool to manage package manager versions
- CP.2 `packageManager` field — `"packageManager": "pnpm@9.0.0"` in package.json
- CP.3 `corepack enable` — activates shims for yarn, pnpm, npm
- CP.4 `corepack prepare` — download and activate specific package manager version
- CP.5 Version enforcement — prevents using wrong package manager in a project
