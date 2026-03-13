# Bundlers - Part 9: Rollup & esbuild

## 18.0 Rollup

### 18.1 Architecture Overview
#### 18.1.1 Core Design Principles
- 18.1.1.1 ESM-first — designed for ESM from ground up — tree shaking core feature not add-on
  - 18.1.1.1.1 CJS interop — `@rollup/plugin-commonjs` required — converts CJS → ESM at analysis
  - 18.1.1.1.2 No runtime — output has zero Rollup runtime — pure ES module or wrapped bundle
- 18.1.1.2 **Unique: Flat bundle philosophy** — scope hoisting default — no module registry overhead
  - 18.1.1.2.1 Binding inlining — `import { foo } from './a'` → `a_foo` directly — no indirection

### 18.2 Plugin Hook Lifecycle
#### 18.2.1 Build Hooks
- 18.2.1.1 → `resolveId`, `load`, `transform`, `buildStart`, `buildEnd` — See Ideal §12.2.1
- 18.2.1.2 **Unique: `moduleParsed({ id, importedIds, dynamicallyImportedIds, exportedBindings })`**
  - 18.2.1.2.1 `importedIds` — all statically imported module IDs — full dep list
  - 18.2.1.2.2 `exportedBindings` — per-module exported names → source modules — cross-module tracking

#### 18.2.2 Output Generation Hooks
- 18.2.2.1 → `renderChunk`, `generateBundle`, `writeBundle` — See Ideal §12.2.2
- 18.2.2.2 **Unique: `renderStart(outputOptions, inputOptions)`** — per output — parallel for multi-output
- 18.2.2.3 **Unique: `augmentChunkHash(chunkInfo)`** — return string to include in chunk hash
  - 18.2.2.3.1 Use case — plugin appends extra data to hash — ensures output changes if plugin state changes
- 18.2.2.4 **Unique: `resolveFileUrl({ referenceId, moduleId, fileName })`** — customize asset URL in code
- 18.2.2.5 **Unique: `resolveImportMeta(property, { moduleId })`** — handle `import.meta.X` for any property

### 18.3 Output Generation Pipeline
#### 18.3.1 Chunk Rendering
- 18.3.1.1 **Unique: Scope hoisting rendering** — merge module scopes — rename collisions — flat output
  - 18.3.1.1.1 MagicString segments — each module transformed individually — concatenated per chunk
  - 18.3.1.1.2 Export binding rendering — `export { foo_renamed as foo }` — name preserved at boundary
- 18.3.1.2 **Unique: `output.preserveModules`** — skip bundling — one output file per input — for libraries
  - 18.3.1.2.1 `preserveModulesRoot` — strip leading path from output structure — cleaner dist layout
  - 18.3.1.2.2 Use case — publish TypeScript library as individual modules — consumers tree-shake freely

### 18.4 Rollup-Specific Tree Shaking
#### 18.4.1 Binding-Level Tracking
- 18.4.1.1 → See Ideal §7.0 for tree shaking fundamentals
- 18.4.1.2 **Unique: Per-binding usage tracking** — each exported name tracked independently
  - 18.4.1.2.1 `export { a, b }` — if only `a` imported externally — `b` removed even in same chunk
- 18.4.1.3 **Unique: `treeshake.moduleSideEffects`** — per-module or global function override
  - 18.4.1.3.1 `moduleSideEffects: (id) => /polyfill/.test(id)` — mark polyfill files as side-effectful
- 18.4.1.4 **Unique: `treeshake.unknownGlobalSideEffects`** — `false` — assume unknown globals are pure
  - 18.4.1.4.1 `treeshake.propertyReadSideEffects: false` — property reads are pure — more aggressive DCE

### 18.5 Watch Mode
#### 18.5.1 Rollup Watcher
- 18.5.1.1 `rollup.watch(options)` — returns `RollupWatcher` emitting `'event'` messages
  - 18.5.1.1.1 Event types — `START` / `BUNDLE_START` / `BUNDLE_END` / `END` / `ERROR`
  - 18.5.1.1.2 `watch.buildDelay` — debounce — ms to wait after file change before rebuild
- 18.5.1.2 **Unique: `watch.exclude` / `watch.include`** — filter which files trigger rebuild
  - 18.5.1.2.1 Glob patterns — exclude `node_modules/**` — avoid re-build on lockfile changes
- 18.5.1.3 **Unique: `this.addWatchFile(path)`** — plugin adds arbitrary file to watch list
  - 18.5.1.3.1 Use case — config file read inside plugin — rebuild if config changes

### 18.6 `preserveEntrySignatures`
#### 18.6.1 Library Export Modes
- 18.6.1.1 **Unique: `'strict'`** — entry chunk exports exactly same bindings as input — no extras
  - 18.6.1.1.1 Required for libraries — consumers must see same named exports
- 18.6.1.2 **Unique: `'exports-only'`** — only export what entry exports — may drop re-export chain
- 18.6.1.3 **Unique: `false`** — entry treated like internal module — may be merged into another chunk

---

## 19.0 esbuild

### 19.1 Go-Based Architecture & Speed
#### 19.1.1 Why Go is Fast
- 19.1.1.1 **Unique: Go goroutines** — lightweight threads — M:N scheduling — millions concurrently
  - 19.1.1.1.1 All modules parsed in parallel — goroutine per file — shared dependency map
  - 19.1.1.1.2 Low memory — goroutine stack starts at 4 kB vs 1 MB OS thread — scale to 1000s
- 19.1.1.2 **Unique: Single-pass architecture** — parse + resolve + transform + bundle in one pass
  - 19.1.1.2.1 No intermediate AST serialization — stays in memory — no JSON round-trip
  - 19.1.1.2.2 Tradeoff — one pass means no second-pass tree-shake refinement — Rollup does 2+

### 19.2 Build API vs Transform API
#### 19.2.1 Build API
- 19.2.1.1 `esbuild.build(options)` → `Promise<BuildResult>` — full bundle — resolve deps — output files
  - 19.2.1.1.1 `entryPoints` — array or object — → See Ideal §1.1
  - 19.2.1.1.2 `bundle: true` — required to bundle — default is false (only transpile entry)
  - 19.2.1.1.3 `write: false` — return in-memory `outputFiles` — no disk write
- 19.2.1.2 `esbuild.context(options)` — persistent context — watch/serve modes — reuse state
  - 19.2.1.2.1 `context.watch()` — incremental rebuild on file change — very fast (< 10 ms)
  - 19.2.1.2.2 `context.serve({ servedir })` — built-in HTTP server — no dev middleware hooks

#### 19.2.2 Transform API
- 19.2.2.1 `esbuild.transform(code, options)` — single-file transform — no bundling
  - 19.2.2.1.1 No dependency resolution — pure transpile — TypeScript / JSX stripping
  - 19.2.2.1.2 Used by Vite for pre-bundling and hot transform — fastest JS transpile available
- 19.2.2.2 **Unique: `transformSync` / `buildSync`** — synchronous API — blocks event loop — avoid in prod

### 19.3 Plugin System
#### 19.3.1 Plugin API
- 19.3.1.1 → `name`, `setup(build)` — resolveId/load/transform equivalents via `build.onX`
  - 19.3.1.1.1 **Unique: `build.onResolve({ filter, namespace }, callback)`** — filter by regex + namespace
  - 19.3.1.1.2 **Unique: `build.onLoad({ filter, namespace }, callback)`** — load matching modules
- 19.3.1.2 **Unique: Namespace** — group virtual modules — `{ namespace: 'my-ns' }` — avoids conflicts
  - 19.3.1.2.1 `file` namespace — default — maps to real filesystem paths
  - 19.3.1.2.2 Custom namespace — `http-url` namespace — handle `https://` imports via plugin
- 19.3.1.3 **Unique: `build.onStart` / `build.onEnd`** — build lifecycle callbacks — no hook ordering
  - 19.3.1.3.1 `onEnd({ errors, warnings, metafile })` — inspect metafile — bundle analysis hook

#### 19.3.2 Plugin Limitations
- 19.3.2.1 **Unique: No `transform` chaining** — only one `onLoad` wins per file — first match
  - 19.3.2.1.1 Workaround — chain manually inside single plugin — call multiple sub-transforms
- 19.3.2.2 **Unique: No chunk control** — esbuild controls chunking — no `manualChunks` equivalent
  - 19.3.2.2.1 Vite works around this — uses Rollup for prod builds — esbuild only for transforms

### 19.4 esbuild-Specific Features
#### 19.4.1 JSX Handling
- 19.4.1.1 **Unique: Built-in JSX** — no plugin needed — `loader: 'jsx'` or `jsxFactory` option
  - 19.4.1.1.1 `jsxDev: true` — inject `__source` and `__self` props — React DevTools integration
- 19.4.1.2 → JSX runtimes: See Ideal §4.3

#### 19.4.2 CSS Handling
- 19.4.2.1 **Unique: Native CSS bundling** — `@import` inlining — CSS Modules — no PostCSS
  - 19.4.2.1.1 CSS Modules — `*.module.css` — scoped classnames — JS object export
  - 19.4.2.1.2 No PostCSS — no autoprefixer — use `postCSS` as separate step or via Vite

### 19.5 esbuild Limitations
#### 19.5.1 Known Constraints
- 19.5.1.1 **Unique: No re-export tree shaking** — `export * from` not granularly tracked — → Rollup wins
  - 19.5.1.1.1 Entire namespace pulled — worse for library bundles — use explicit named exports
- 19.5.1.2 **Unique: No TypeScript type checking** — strips types only — run `tsc --noEmit` separately
  - 19.5.1.2.1 Isolated modules required — `const enum` unsupported — `declare` enums instead
- 19.5.1.3 **Unique: `decorators` support limited** — only legacy decorators via `--supported:decorators`
