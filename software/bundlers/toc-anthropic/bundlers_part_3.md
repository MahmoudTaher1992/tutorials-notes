# Bundlers - Part 3: Output Formats & Code Splitting

## 5.0 Output Formats & Bundling

### 5.1 Output Format Types
#### 5.1.1 ESM (ECMAScript Modules)
- 5.1.1.1 `import` / `export` syntax preserved — native browser `<script type="module">` compatible
  - 5.1.1.1.1 Top-level await — ESM-only — async module init — CJS cannot represent this
  - 5.1.1.1.2 Named export preservation — tree-shakeable by downstream bundlers — library ideal
- 5.1.1.2 `format: 'esm'` — Rollup/Vite — `"type": "module"` in package.json for Node.js

#### 5.1.2 CJS (CommonJS)
- 5.1.2.1 `module.exports` / `require()` — synchronous — Node.js native — no tree shaking by consumers
  - 5.1.2.1.1 Named exports CJS — `exports.foo = ...` — must use `{ foo } = require()` — no static analysis
  - 5.1.2.1.2 Default export interop — `module.exports = fn` — ESM consumer uses `import fn` or `import.default`
- 5.1.2.2 `format: 'cjs'` — `__esModule` interop flag — `exports.default` + `exports.__esModule = true`

#### 5.1.3 IIFE (Immediately Invoked Function Expression)
- 5.1.3.1 Self-contained — wraps bundle in `(function(){...})()` — global variable exposed
  - 5.1.3.1.1 `name` option — `var MyLib = (function(){...})()` — UMD-less browser global
  - 5.1.3.1.2 `extend: true` — append to existing global — `var MyLib = MyLib || {}` pattern
- 5.1.3.2 Use case — browser `<script>` tag — no module loader — legacy CDN distribution

#### 5.1.4 UMD (Universal Module Definition)
- 5.1.4.1 Runtime detect — AMD → CJS → global — one file works in all environments
  - 5.1.4.1.1 UMD boilerplate — ~15 lines of factory wrapper — small overhead per bundle
  - 5.1.4.1.2 Deprecated pattern — prefer separate ESM + CJS outputs with `exports` field

#### 5.1.5 SystemJS
- 5.1.5.1 `format: 'system'` — Rollup — SystemJS module loader format — legacy Angular apps
  - 5.1.5.1.1 Dynamic import support in older browsers — polyfill-based — SystemJS runtime required

### 5.2 Minification
#### 5.2.1 JavaScript Minification
- 5.2.1.1 Whitespace removal — strip spaces/newlines/comments — safe — always applied first
  - 5.2.1.1.1 Legal comment preservation — `/*! license */` — `@license` — configurable
- 5.2.1.2 Identifier mangling — rename local vars to `a`, `b`… — ~20–30% extra reduction
  - 5.2.1.2.1 Top-level mangling — `toplevel: true` — rename module-level names — risky with `eval`
  - 5.2.1.2.2 Reserved names — `keep_classnames` / `keep_fnames` — regex preserve pattern
- 5.2.1.3 Constant folding — `1 + 2` → `3` — unreachable branch removal — inlining
  - 5.2.1.3.1 `passes` — multiple compression passes — diminishing returns after 2–3
  - 5.2.1.3.2 esbuild minifier — ~10–15% less reduction than Terser — 100× faster
- 5.2.1.4 Unsafe optimizations — `unsafe_arrows` / `unsafe_methods` — break rare edge cases
  - 5.2.1.4.1 `pure_getters` — assume getters have no side effects — enables more dead code removal

#### 5.2.2 CSS Minification
- 5.2.2.1 cssnano — PostCSS-based — merge rules, shorten values, remove comments
  - 5.2.2.1.1 `lightningcss` — Rust-based — faster — used by Vite 4.4+ as default CSS minifier
- 5.2.2.2 Property value shorthand — `margin: 10px 10px 10px 10px` → `margin: 10px`

### 5.3 Scope Hoisting / Module Concatenation
#### 5.3.1 Mechanism
- 5.3.1.1 Merge modules into single scope — eliminate module wrapper functions — smaller + faster
  - 5.3.1.1.1 Binding renaming — `import { foo } from './a'` → inline `a_foo` — no wrapper needed
  - 5.3.1.1.2 Prerequisite — pure ESM — no side-effectful re-exports — no circular deps in group
- 5.3.1.2 Module groups — connected acyclic subgraph — hoisted together — isolated chunks separate
  - 5.3.1.2.1 Star export caveat — `export * from './x'` — all of x's exports must be known statically
  - 5.3.1.2.2 Dynamic import boundary — cannot hoist across async chunk boundary

### 5.4 Polyfill Injection
#### 5.4.1 Core-js Integration
- 5.4.1.1 `useBuiltIns: 'usage'` — Babel — inject only polyfills used in each file — minimal size
  - 5.4.1.1.1 `corejs: 3` — specify version — patch-level matters for new proposals
  - 5.4.1.1.2 Duplicate polyfill risk — each file injects own copy without dedup — use `entry` mode
- 5.4.1.2 `useBuiltIns: 'entry'` — single import at bundle entry — one canonical polyfill set
  - 5.4.1.2.1 Browserslist targets — polyfill only what targets lack — auto-computed per env

### 5.5 Banner / Footer / Intro / Outro
#### 5.5.1 Content Injection
- 5.5.1.1 `banner` — string or function — prepended to each output chunk — license headers
  - 5.5.1.1.1 Function banner — `(chunk) => string` — per-chunk dynamic content
- 5.5.1.2 `intro` / `outro` — injected inside module wrapper — access to module scope
  - 5.5.1.2.1 Global injections — `var __filename = ${JSON.stringify(id)}` — per-chunk context

---

## 6.0 Code Splitting & Chunking

### 6.1 Static Code Splitting
#### 6.1.1 Manual Chunks
- 6.1.1.1 `manualChunks` — map module IDs to chunk names — force grouping
  - 6.1.1.1.1 Function form — `(id) => 'vendor'` — regex-based grouping — flexible
  - 6.1.1.1.2 Circular reference in manual chunks — must group entire cycle together
- 6.1.1.2 Entry chunks — each entry point = one chunk — shared deps extracted automatically
  - 6.1.1.2.1 `splitDeps` threshold — only extract shared chunk if shared by N+ entries — configurable

### 6.2 Dynamic import()
#### 6.2.1 Async Chunk Creation
- 6.2.1.1 Each distinct `import('./x')` call → new async chunk boundary
  - 6.2.1.1.1 Chunk ID — hash of content or name from chunk naming function
  - 6.2.1.1.2 Async chunk loading — bundler injects loader runtime — `__import__` or native `import()`
- 6.2.1.2 Shared async chunk — if two dynamic imports share a dep — extracted to shared chunk
  - 6.2.1.2.1 Waterfall prevention — preload parent's children eagerly — avoids sequential round trips
  - 6.2.1.2.2 `modulePreload` polyfill — Vite injects for browsers without native modulepreload

#### 6.2.2 Lazy Route Splitting
- 6.2.2.1 React.lazy / Vue defineAsyncComponent — wraps dynamic import — Suspense boundary
  - 6.2.2.1.1 Route-level split — one chunk per route — common SPA pattern — O(routes) chunks
  - 6.2.2.1.2 Named lazy chunks — `/* @vite-chunk-name: home */` magic comment — readable hashes

### 6.3 Vendor Chunking Strategies
#### 6.3.1 Common Patterns
- 6.3.1.1 All-vendor chunk — `node_modules` → single `vendor.js` — poor caching granularity
  - 6.3.1.1.1 Problem — any dep update busts entire vendor cache — defeats long-term caching
- 6.3.1.2 Granular vendor chunks — one chunk per package or group — fine-grained cache control
  - 6.3.1.2.1 `manualChunks: (id) => id.includes('node_modules') ? id.split('/')[...pkg-name] : null`
  - 6.3.1.2.2 Too many chunks — waterfall requests — set minimum chunk size (default 500 kB)
- 6.3.1.3 Stable hash strategy — content hash — vendor chunk hash unchanged if code unchanged
  - 6.3.1.3.1 `chunkFileNames: '[name]-[hash].js'` — content hash in filename — CDN cache busting

### 6.4 Chunk Optimization Algorithms
#### 6.4.1 Rollup's Default Algorithm
- 6.4.1.1 Facet analysis — determine which modules are always loaded together — merge into one chunk
  - 6.4.1.1.1 `experimentalMinChunkSize` — merge small chunks below threshold — reduces request count
  - 6.4.1.1.2 Side effect awareness — do not merge if merging causes side effects to execute earlier
- 6.4.1.2 Chunk graph — chunks as nodes — async import as edge — minimize parallel round trips
  - 6.4.1.2.1 `output.experimentalDeepDynamicChunkOptimization` — Rollup 4 — better shared chunk placement

#### 6.4.2 Vite's Chunking
- 6.4.2.1 Uses Rollup's algorithm post-build — analysis same as Ideal §6.4.1
  - 6.4.2.1.1 **Unique: `build.rollupOptions.output.manualChunks`** — Vite exposes Rollup option directly
  - 6.4.2.1.2 **Unique: `build.chunkSizeWarningLimit`** — warn on chunks > limit (default 500 kB)

### 6.5 Preloading & Prefetching Hints
#### 6.5.1 `<link rel="modulepreload">`
- 6.5.1.1 Fetch + parse in advance — browser fetches module before it is needed — reduces latency
  - 6.5.1.1.1 Bundler-generated preloads — Vite injects `<link>` for all static imports of entry
  - 6.5.1.1.2 Polyfill — browsers without modulepreload support — `modulepreload: 'polyfill'`
- 6.5.1.2 `<link rel="prefetch">` — low-priority — fetch on idle — future navigation hint
  - 6.5.1.2.1 Route prefetch — trigger on hover before click — ~200 ms head start
