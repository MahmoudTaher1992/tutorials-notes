# Bundlers - Part 1: Core Architecture & Module Resolution

## 1.0 Core Architecture & Pipeline

### 1.1 Entry Point Resolution
#### 1.1.1 Single vs Multi-Entry
- 1.1.1.1 Single entry — one root module — full graph discovered via static traversal
  - 1.1.1.1.1 Index inference — dir given → tries index.js / index.ts — package.json `main` fallback
  - 1.1.1.1.2 Explicit path — absolute or repo-relative — overrides all package.json fields
- 1.1.1.2 Multi-entry — array or named map — each produces an independent output chunk
  - 1.1.1.2.1 Named entries — `{ app: './src/app.ts' }` — chunk filename inherits key
  - 1.1.1.2.2 Shared chunk extraction — common deps deduped across entries — split heuristics
- 1.1.1.3 Glob entry — `**/*.ts` pattern — one output per input — library / preserveModules mode

#### 1.1.2 HTML vs JS Entry
- 1.1.2.1 HTML entry — parse `<script type="module">` and `<link rel="stylesheet">` as graph roots
  - 1.1.2.1.1 Multi-page app — one HTML per page — independent asset graphs — shared vendor chunk
  - 1.1.2.1.2 Inline script extraction — `<script>` content becomes a virtual module
- 1.1.2.2 Virtual entry — plugin-injected — no physical file — used for polyfill / runtime shim roots

### 1.2 Build Pipeline Stages
#### 1.2.1 Resolve → Load → Transform → Bundle → Emit
- 1.2.1.1 Resolve — specifier → absolute path — plugin hooks run first — result cached
  - 1.2.1.1.1 Resolver cache — LRU map — avoids redundant `fs.stat` — critical hot path
  - 1.2.1.1.2 Resolution order — alias → tsconfig paths → node_modules → fallback
- 1.2.1.2 Load — read file bytes from disk — infer loader from extension — plugin can override
  - 1.2.1.2.1 Loader types — js / ts / jsx / tsx / css / json / file / dataurl / base64
  - 1.2.1.2.2 Virtual module load — return string content without any fs read
- 1.2.1.3 Transform — code → transformed code + source map — multiple transforms chain per file
  - 1.2.1.3.1 Chain ordering — transforms compose in plugin order — maps merged at chain end
  - 1.2.1.3.2 AST pass-through — parsed AST handed between transforms — avoids re-parse cost
- 1.2.1.4 Bundle — link modules — rewrite import bindings — inline or chunk-reference resolved
  - 1.2.1.4.1 CJS wrapping — `function(module,exports,require){}` wrapper — synchronous require
  - 1.2.1.4.2 ESM scope hoisting — rename exports to flat namespace — no runtime module object
- 1.2.1.5 Emit — write chunks + assets to `outDir` — `generateBundle` / `writeBundle` hooks fire
  - 1.2.1.5.1 `emitFile` API — programmatic asset emission — returns ref ID for URL injection
  - 1.2.1.5.2 In-memory mode — `write: false` — return bundle map — programmatic consumers

#### 1.2.2 Two-Phase Architecture (Analysis + Generation)
- 1.2.2.1 Analysis phase — complete graph walk — mark used/unused exports — no output written yet
  - 1.2.2.1.1 Pre-analysis plugins — can add/remove modules before DCE marking — use with care
- 1.2.2.2 Generation phase — render code per chunk — apply minification — write to disk
  - 1.2.2.2.1 Deterministic output — same input → same bytes — required for CI cache validity

### 1.3 Parallel & Concurrent Processing
#### 1.3.1 Module-Level Parallelism
- 1.3.1.1 Parallel resolve+load — queue with concurrency limit — default 16–64 concurrent modules
  - 1.3.1.1.1 IO vs CPU split — disk reads parallelize freely — transforms require worker pool
  - 1.3.1.1.2 `UV_THREADPOOL_SIZE` — Node.js libuv fs thread pool size — tune for disk-heavy builds
- 1.3.1.2 Worker threads — CPU transforms off main thread — main thread owns graph state only
  - 1.3.1.2.1 Warm worker pool — pre-spawn N workers — amortize V8 startup (~30 ms/worker)
  - 1.3.1.2.2 Transferable buffers — `ArrayBuffer` ownership transfer — zero serialization cost

#### 1.3.2 Pipeline Parallelism
- 1.3.2.1 Overlap stages — while module A loads, module B transforms — pipeline depth optimization
  - 1.3.2.1.1 Ordering constraint — parent cannot bundle until all transitive children resolved
- 1.3.2.2 Parallel chunk write — all output files written concurrently — bounded semaphore
  - 1.3.2.2.1 Write concurrency ceiling — `min(chunks, OS_FD_LIMIT / 4)` — prevent fd exhaustion

### 1.4 Worker Thread Architecture
#### 1.4.1 Orchestrator/Worker Pattern
- 1.4.1.1 Main thread owns graph — workers are stateless transform processors
  - 1.4.1.1.1 Task message shape — `{ id, code, filename, loader }` → worker → `{ code, map }`
  - 1.4.1.1.2 Worker recycling — reuse after each task — avoid per-task V8 init cost
- 1.4.1.2 Shared memory — `SharedArrayBuffer` for large sources — `postMessage` passes only offset
  - 1.4.1.2.1 Lock-free reads — workers read-only from shared buffer — no mutex needed

### 1.5 Memory Management
#### 1.5.1 Module Cache Lifecycle
- 1.5.1.1 Module map — id → `{ code, ast, map, deps }` — lives entire build duration
  - 1.5.1.1.1 AST size ratios — Babel AST ~10× source — Oxc ~3× — Rust arena allocator benefit
  - 1.5.1.1.2 Drop AST post-codegen — free AST after code generation — rebuild on watch re-entry
- 1.5.1.2 LRU plugin cache — bounded capacity — evict oldest — prevents OOM in long watch sessions
  - 1.5.1.2.1 Cache size tuning — too small → re-transform thrash — too large → OOM in monorepos

#### 1.5.2 Streaming Output
- 1.5.2.1 Stream code fragments — avoid materializing full bundle in memory — flush incrementally
  - 1.5.2.1.1 MagicString — efficient string mutations + incremental source map — industry standard
  - 1.5.2.1.2 Peak memory ≈ largest chunk × 2 — input source + rendered output — not total bundle

---

## 2.0 Module Resolution

### 2.1 Module Specifier Types
#### 2.1.1 Classification
- 2.1.1.1 Relative — `./` or `../` prefix — resolved relative to the importing file's directory
  - 2.1.1.1.1 Extension inference — try `.js` → `.ts` → `.jsx` → `.tsx` → `/index.js` — configurable
  - 2.1.1.1.2 Directory import — `./foo` → `./foo/index.js` — works in bundlers, banned in strict ESM
- 2.1.1.2 Bare — no prefix — node_modules lookup or import map hit
  - 2.1.1.2.1 Scoped packages — `@scope/pkg` — two-segment directory inside node_modules
  - 2.1.1.2.2 Deep import — `pkg/sub/path` — must be in package `exports` or legacy unlisted path
- 2.1.1.3 Absolute — `/abs/path` or `file://` URL — rare in source — common in plugin-generated IDs
- 2.1.1.4 URL specifier — `https://cdn/mod.js` — ignored/externalized by most bundlers

### 2.2 Node Resolution Algorithm
#### 2.2.1 LOAD_NODE_MODULES
- 2.2.1.1 Directory ascent — start at importer dir — walk up to fs root — check node_modules each level
  - 2.2.1.1.1 Ascent cache — memoize node_modules paths per starting dir — O(1) on repeat
  - 2.2.1.1.2 Hoisting awareness — npm/yarn hoist deps to root — reduces actual ascent depth
- 2.2.1.2 package.json field priority — `exports` > `browser` > `module` > `main` — bundler order
  - 2.2.1.2.1 `module` field — unofficial ESM hint — not Node.js spec — all major bundlers honor it
  - 2.2.1.2.2 `browser` field — string or map — swap Node-specific paths for browser equivalents

#### 2.2.2 `exports` Field Deep Dive
- 2.2.2.1 Subpath exports — `"."` default + `"./utils"` explicit — unlisted paths throw error
  - 2.2.2.1.1 Wildcard patterns — `"./icons/*"` → `"./src/icons/*.js"` — directory expansion
  - 2.2.2.1.2 Encapsulation — library controls public API surface — internal paths hidden
- 2.2.2.2 Conditional exports — matched in definition order — first truthy condition wins
  - 2.2.2.2.1 Standard conditions — `import` / `require` / `browser` / `node` / `default`
  - 2.2.2.2.2 Custom conditions — `"edge"`, `"worker"`, `"deno"` — pass via `--conditions` CLI flag
  - 2.2.2.2.3 `bundler` condition — Vite 5+ — ship raw unbundled ESM for bundler consumption

### 2.3 Path Aliasing
#### 2.3.1 Static Alias Map
- 2.3.1.1 Prefix alias — `'@': './src'` — `@` replaced with `./src` at resolve time
  - 2.3.1.1.1 Longest-prefix match — `@components` wins over `@` — specificity ordering
  - 2.3.1.1.2 tsconfig paths mirror — alias must also appear in `compilerOptions.paths` for IDE/tsc
- 2.3.1.2 Exact alias — `'vue': 'vue/dist/vue.runtime.esm.js'` — single-module swap
  - 2.3.1.2.1 Env swap — alias `'config'` → `'./config.prod.ts'` in production — conditional logic

### 2.4 Dual Package Hazard
#### 2.4.1 ESM + CJS Coexistence
- 2.4.1.1 Two instances — same pkg via `require()` AND `import` → two copies — singleton broken
  - 2.4.1.1.1 Detection — check module graph for same package at two different resolved paths
  - 2.4.1.1.2 Mitigation — ship ESM-only + `.cjs` wrapper shim — or careful `exports` conditions
- 2.4.1.2 `bundler` condition pattern — `exports.bundler` → raw `.ts` source — optimal for tree shaking
  - 2.4.1.2.1 Only safe when bundler strips all types — rely on bundler TypeScript pipeline

### 2.5 Monorepo Resolution
#### 2.5.1 Workspace Packages
- 2.5.1.1 Symlink resolution — workspace pkg → symlink in node_modules → real path resolved
  - 2.5.1.1.1 `preserveSymlinks` — keep symlink as module identity — avoids real-path mismatch
  - 2.5.1.1.2 Duplicate risk — two resolution paths to same file — broken singleton in bundle
- 2.5.1.2 Source-first resolution — resolve `.ts` source not compiled `.js` — faster DX iteration
  - 2.5.1.2.1 TypeScript project references — `composite: true` — bundler reads `tsconfig.paths`
