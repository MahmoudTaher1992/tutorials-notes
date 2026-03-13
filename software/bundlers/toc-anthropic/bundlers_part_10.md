# Bundlers - Part 10: Parcel, SWC & Rolldown

## 20.0 Parcel

### 20.1 Zero-Config Asset Graph
#### 20.1.1 Auto-Detection
- 20.1.1.1 **Unique: No config file required** — entry point is enough — all loaders auto-installed
  - 20.1.1.1.1 **Unique: `@parcel/transformer-*`** — auto-installed on demand — first build downloads deps
  - 20.1.1.1.2 **Unique: Target inference** — `package.json` `main`/`module`/`browser` → auto-configure output
- 20.1.1.2 **Unique: HTML entry** — `parcel index.html` — follows all linked assets recursively
  - 20.1.1.2.1 `<script>`, `<link rel="stylesheet">`, `<img>` — all become graph roots
  - 20.1.1.2.2 Inline `<style>` and `<script>` — extracted and processed — injected back as transformed

### 20.2 Asset Graph Architecture
#### 20.2.1 Multi-Language Graph
- 20.2.1.1 **Unique: Unified asset graph** — CSS, JS, HTML, images — all first-class nodes
  - 20.2.1.1.1 Cross-language deps — JS `import './style.css'` — CSS `url('./img.png')` — all edges
  - 20.2.1.1.2 **Unique: Asset types have separate pipeline stages** — Transformer/Bundler/Optimizer per type
- 20.2.1.2 **Unique: `AssetGraph` vs `BundleGraph`** — two distinct graph phases
  - 20.2.1.2.1 AssetGraph — raw dependencies — pre-bundling — one node per source file
  - 20.2.1.2.2 BundleGraph — post-bundling — grouped chunks — tree-shaken + split

### 20.3 Transformer / Packager / Optimizer Pipeline
#### 20.3.1 Three Stages
- 20.3.1.1 **Unique: Transformer** — convert source to canonical form — Babel/SWC/Sass → JS/CSS
  - 20.3.1.1.1 Multiple transformers per file type — pipeline chain — each transformer in series
  - 20.3.1.1.2 **Unique: `@parcel/transformer-babel`** — uses Babel — full AST transforms
- 20.3.1.2 **Unique: Packager** — combine assets into output bundle — JS packager stitches modules
  - 20.3.1.2.1 → Scope hoisting: See Ideal §5.3 — Parcel implements own scope hoisting engine
  - 20.3.1.2.2 **Unique: Parcel runtime** — injected module registry for non-scope-hoisted output
- 20.3.1.3 **Unique: Optimizer** — minify/compress final bundle — Terser / SWC minify / lightningcss
  - 20.3.1.3.1 Per-asset-type optimizer — JS optimizer ≠ CSS optimizer — separate plugins

#### 20.3.2 Parcel Scope Hoisting
- 20.3.2.1 **Unique: Parcel's own scope hoisting** — separate from Rollup — handles CommonJS interop
  - 20.3.2.1.1 **Unique: `module.exports` detection** — static analysis of CJS in scope hoisting
  - 20.3.2.1.2 CJS → ESM static wrapping — wraps CJS in ESM-compatible module — enables tree-shake

### 20.4 Parcel Plugins
#### 20.4.1 Plugin Types
- 20.4.1.1 **Unique: Named plugin roles** — Resolver / Transformer / Bundler / Packager / Optimizer / Reporter
  - 20.4.1.1.1 Single interface per role — no catch-all hook — cleaner separation of concerns
- 20.4.1.2 **Unique: `@parcel/plugin` base** — extend base class — strongly typed API
  - 20.4.1.2.1 `Transformer.transform({ asset })` — return `Array<Asset>` — one input → many outputs
  - 20.4.1.2.2 `Resolver.resolve({ specifier })` — return `{ filePath }` or null
- 20.4.1.3 `.parcelrc` — config file — maps pipeline stages to plugin arrays
  - 20.4.1.3.1 `"extends": "@parcel/config-default"` — inherit default pipeline — override selectively

### 20.5 LMDB Persistent Cache
#### 20.5.1 Cache Implementation
- 20.5.1.1 → See Ideal §10.5.1.1 for LMDB fundamentals
- 20.5.1.2 **Unique: Parcel stores every asset graph node in LMDB** — transform results, resolved paths
  - 20.5.1.2.1 **Unique: Sub-millisecond cache reads** — memory-mapped — zero-copy — fastest persistent cache
  - 20.5.1.2.2 **Unique: Worker-safe** — LMDB single-writer multi-reader — safe for Parcel worker pool
- 20.5.1.3 **Unique: `.parcel-cache/`** — default cache dir — delete to bust — no config needed

---

## 21.0 SWC (Speedy Web Compiler)

### 21.1 Rust-Based Transform Architecture
#### 21.1.1 Design
- 21.1.1.1 **Unique: Rust implementation** — transpile JavaScript/TypeScript — not a bundler by default
  - 21.1.1.1.1 **Unique: Babel-compatible API** — drop-in replacement for `@babel/core` transform
  - 21.1.1.1.2 **Unique: `@swc/core`** — Node.js binding — native addon — 20–70× faster than Babel
- 21.1.1.2 **Unique: Concurrent file transforms** — Rayon parallel — each file independent — no ordering
  - 21.1.1.2.1 Thread pool per process — default = CPU count — `SWC_PARALLEL` env override

#### 21.1.2 Transform Pipeline
- 21.1.2.1 **Unique: `.swcrc` config** — JSON — `jsc.parser` + `jsc.transform` + `env.targets`
  - 21.1.2.1.1 `jsc.parser.syntax: 'typescript'` — `tsx: true` — enables TSX parsing
  - 21.1.2.1.2 `jsc.transform.react` — `runtime: 'automatic'` — JSX automatic runtime — same as Babel
- 21.1.2.2 → TypeScript stripping: See Ideal §4.2 — SWC strips types, no type checking
- 21.1.2.3 → Decorator transforms: See Ideal §4.2.2 — SWC supports both legacy and stage-3

### 21.2 `spack` Bundler (Experimental)
#### 21.2.1 Bundler Mode
- 21.2.1.1 **Unique: `spack` CLI** — experimental SWC bundler — not production-ready as of 2025
  - 21.2.1.1.1 **Unique: `spack.config.js`** — separate config from transform — entry + output config
  - 21.2.1.1.2 **Unique: Tree shaking via SWC's binding analysis** — Rust-native — experimental quality
- 21.2.1.2 **Unique: Not used directly in production** — projects use SWC via Vite/Next.js — not spack

### 21.3 WASM Plugin System
#### 21.3.1 Plugin Interface
- 21.3.1.1 **Unique: WASM plugins** — plugins compiled to WASM — run in any environment
  - 21.3.1.1.1 `Visitor` trait — Rust — implement `visit_*` methods — walk SWC AST
  - 21.3.1.1.2 WASM limitation — cannot call into JS from WASM plugin — restricted API surface
- 21.3.1.2 **Unique: JS plugin interop** — `@swc/plugin-styled-components` — wraps Rust AST visitor

### 21.4 Integrations
#### 21.4.1 Next.js
- 21.4.1.1 **Unique: Next.js 12+ default compiler** — SWC replaces Babel — zero config migration
  - 21.4.1.1.1 `next.config.js` `swcPlugins` — WASM plugin array — custom transforms
  - 21.4.1.1.2 **Unique: Styled Components / Emotion** — built-in SWC support — no Babel plugin needed
- 21.4.1.2 **Unique: `next/compiler` options** — `styledComponents`, `emotion`, `relay`, `removeConsole`

#### 21.4.2 Jest / Vitest
- 21.4.2.1 **Unique: `@swc/jest`** — transform test files with SWC — faster than Babel-jest
  - 21.4.2.1.1 `transform: { '^.+\\.(t|j)sx?$': ['@swc/jest'] }` — Jest config
- 21.4.2.2 **Unique: Vitest uses esbuild by default** — SWC opt-in via `@vitest/swc-runner`

---

## 22.0 Rolldown

### 22.1 Rust + Oxc Architecture
#### 22.1.1 Design Goals
- 22.1.1.1 **Unique: Rollup-compatible output** — same API / plugin interface — migration target for Vite
  - 22.1.1.1.1 **Unique: Oxc parser** — 3× smaller AST than Babel — sub-10ms parse for large files
  - 22.1.1.1.2 **Unique: Oxc resolver** — Rust-native node_modules resolution — faster than `enhanced-resolve`
- 22.1.1.2 **Unique: Batteries-included** — built-in TypeScript, JSX, define, aliasing — no plugins needed
  - 22.1.1.2.1 **Unique: Built-in `oxc-minifier`** — Rust minifier integrated — no Terser dep needed

#### 22.1.2 Architecture
- 22.1.2.1 **Unique: Parallel module loading with Rayon** — async IO via Tokio — Rust async runtime
  - 22.1.2.1.1 **Unique: Zero-copy string handling** — Oxc `Atom` — interned strings — dedup in memory
  - 22.1.2.1.2 **Unique: Arena allocator** — bump allocator per build — free all at once — no GC pauses

### 22.2 Rollup Plugin Compatibility
#### 22.2.1 Plugin API Compatibility
- 22.2.1.1 **Unique: `resolveId`, `load`, `transform`** — same hooks as Rollup — JS plugins run in Node.js
  - 22.2.1.1.1 Plugin execution — JS plugins run in Node.js worker — Rust calls into JS via napi-rs
  - 22.2.1.1.2 **Unique: `transform` hook overhead** — Rust→JS bridge cost — native plugins 10× faster
- 22.2.1.2 **Unique: Compatibility flag** — `experimentalCompatHook: true` — enables Rollup-only hooks
  - 22.2.1.2.1 Target — 100% Rollup plugin compatibility — most Rollup/Vite plugins work unmodified

### 22.3 Vite Migration Path
#### 22.3.1 Vite + Rolldown
- 22.3.1.1 **Unique: Rolldown to replace Rollup in Vite** — Vite 6+ roadmap — same output guarantees
  - 22.3.1.1.1 **Unique: `rolldown-vite`** — experimental npm package — try Rolldown in Vite today
  - 22.3.1.1.2 **Unique: Dev/prod unification goal** — same Rolldown bundler for dev + prod — close parity gap
- 22.3.1.2 **Unique: 10–100× faster prod builds** — benchmarks vs Rollup — Rust parallelism advantage
  - 22.3.1.2.1 Caveat — output not 100% identical to Rollup yet — edge cases in progress

### 22.4 Current State & Roadmap (as of 2025)
#### 22.4.1 Status
- 22.4.1.1 **Unique: Beta quality** — used in production at Vite team internally — not default yet
  - 22.4.1.1.1 Tree shaking — functional but less aggressive than Rollup — active improvement area
  - 22.4.1.1.2 Source maps — full support — v3 format — chained maps supported
- 22.4.1.2 **Unique: Oxc project umbrella** — Rolldown + Oxc linter + Oxc parser — unified toolchain
  - 22.4.1.2.1 `oxc-transform` standalone — Rolldown's transform layer usable independently
