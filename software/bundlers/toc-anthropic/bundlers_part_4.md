# Bundlers - Part 4: Tree Shaking & Asset Processing

## 7.0 Tree Shaking & Dead Code Elimination

### 7.1 Static Analysis Requirements
#### 7.1.1 ESM Prerequisite
- 7.1.1.1 Static `import`/`export` required — runtime-conditional imports defeat tree shaking
  - 7.1.1.1.1 CJS cannot be tree-shaken — `require()` is dynamic — all exports assumed used
  - 7.1.1.1.2 `module` field in package.json — ESM entry for bundlers — enables tree shaking
- 7.1.1.2 Export usage tracking — per-export used/unused tracking — unused marked for removal
  - 7.1.1.2.1 `moduleSideEffects: false` — entire module dropped if no exports used
  - 7.1.1.2.2 Used export inference — export used if any importer references binding — transitive

#### 7.1.2 Namespace Import Hazard
- 7.1.2.1 `import * as ns from './x'` — all exports marked used — disables tree shaking for `x`
  - 7.1.2.1.1 Rollup namespace analysis — tracks `ns.foo` accesses — can still tree-shake unused
  - 7.1.2.1.2 Dynamic property access — `ns[key]` — bundler must assume all properties accessed
- 7.1.2.2 Re-export barrel files — `export * from './a'; export * from './b'` — star kills shaking
  - 7.1.2.2.1 Barrel optimization — resolve through barrel at analysis time — Rollup / Vite do this
  - 7.1.2.2.2 `optimizeDeps.include` — Vite pre-bundles barrels — fast dev, full shake in prod

### 7.2 Side Effects Detection
#### 7.2.1 `sideEffects` Package Field
- 7.2.1.1 `"sideEffects": false` — whole package safe to drop unused modules
  - 7.2.1.1.1 Array form — `["./src/polyfill.js", "*.css"]` — keep specific files — drop rest
  - 7.2.1.1.2 Glob patterns — `"**/*.css"` — all CSS files have side effects — never dropped
- 7.2.1.2 Missing `sideEffects` — conservative — bundler assumes all modules have side effects
  - 7.2.1.2.1 Impact — entire `lodash-es` included even if only one fn imported — 70 kB wasted
  - 7.2.1.2.2 Library authors must set `"sideEffects": false` for modern bundling

#### 7.2.2 Module-Level Side Effects
- 7.2.2.1 Top-level statements — `console.log()`, `document.querySelector()` — cannot drop module
  - 7.2.2.1.1 IIFE calls — `(function init(){...})()` — assumed side-effectful unless annotated
  - 7.2.2.1.2 Class static fields — `static registry = new Map()` — side effect on class load
- 7.2.2.2 Safe patterns — pure function declarations — `const x = 1` literals — safe to drop if unused
  - 7.2.2.2.1 `Object.defineProperty(exports, '__esModule')` — Babel CJS emit — side effect flag

### 7.3 Pure Annotations
#### 7.3.1 `/*#__PURE__*/`
- 7.3.1.1 Call expression annotation — `/*#__PURE__*/ React.createElement(...)` — mark as pure
  - 7.3.1.1.1 If result unused — bundler drops entire call — no side effects assumed
  - 7.3.1.1.2 Babel/SWC JSX compile — auto-emits `#__PURE__` on createElement calls — automatic
- 7.3.1.2 New expression — `/*#__PURE__*/ new Foo()` — pure constructor — safe to DCE if unused
  - 7.3.1.2.1 Class instantiation for effect — pattern should NOT use `#__PURE__` — preserve intent

#### 7.3.2 `/*#__NO_SIDE_EFFECTS__*/`
- 7.3.2.1 Function declaration annotation — entire function is pure — all calls to it are pure
  - 7.3.2.1.1 Rollup 3.3+ — `/*#__NO_SIDE_EFFECTS__*/` before `function` or `const fn = () =>`
  - 7.3.2.1.2 Library usage — annotate factory functions — consumers get automatic DCE

### 7.4 Cross-Module Tree Shaking
#### 7.4.1 Re-export Chain Following
- 7.4.1.1 `export { foo } from './bar'` → follows chain to `bar` — marks only `foo` as used in `bar`
  - 7.4.1.1.1 Namespace re-export `export * from './bar'` — all of `bar` marked used — avoid in libs
  - 7.4.1.1.2 Rollup excels here — full cross-module binding tracking — best-in-class shaking
- 7.4.1.2 Partial namespace use — `import { a, b } from './ns'; use(a)` — `b` shaken even in NS
  - 7.4.1.2.1 Rollup tracks namespace property accesses — `ns.a` used, `ns.b` unused → shake `b`

#### 7.4.2 Inter-Package Tree Shaking
- 7.4.2.1 Requires ESM entry in npm package — `module` or `exports.import` field
  - 7.4.2.1.1 Bundled npm packages — tree shaking impossible — ship unbundled ESM for libs
  - 7.4.2.1.2 `sideEffects: false` + ESM — full cross-package shaking — React in prod only ~45 kB

### 7.5 Tree Shaking Failure Modes
#### 7.5.1 Common Anti-Patterns
- 7.5.1.1 `export default { a, b, c }` — object export — all properties pulled in as one unit
  - 7.5.1.1.1 Mitigation — named exports instead — `export const a = ...; export const b = ...`
- 7.5.1.2 Augmenting `prototype` or global — `Array.prototype.flat = ...` — must keep — side effect
- 7.5.1.3 Index barrel with re-exports from CJS package — CJS dep blocks shake of entire barrel
  - 7.5.1.3.1 Diagnose with bundle analyzer — find unexpected full-package inclusions

---

## 8.0 Asset Processing

### 8.1 File Types & Handlers
#### 8.1.1 Static Asset Pipeline
- 8.1.1.1 File loader — copy to `outDir` — replace import with public URL string
  - 8.1.1.1.1 `import logo from './logo.svg'` → `logo = '/assets/logo-abc123.svg'`
  - 8.1.1.1.2 Asset base URL — `base: '/app/'` — prefix all asset URLs — CDN deployment
- 8.1.1.2 Raw loader — `import txt from './data.txt?raw'` — returns file content as string
  - 8.1.1.2.1 WASM raw — `import wasm from './mod.wasm?url'` — URL for manual fetch+instantiate

### 8.2 Content Hashing & Fingerprinting
#### 8.2.1 Hash Algorithms
- 8.2.1.1 Content hash — SHA-256 of file bytes → truncated to 8 chars — cache-busting filename
  - 8.2.1.1.1 Hash stability — same content = same hash — enables long-term CDN caching (1 year)
  - 8.2.1.1.2 Hash chain — JS chunk hash includes hashes of all its imported CSS/assets
- 8.2.1.2 Chunk hash vs file hash — chunk hash depends on imported module hashes — cascading bust
  - 8.2.1.2.1 Runtime chunk isolation — Vite splits runtime into tiny chunk — avoids cascade

#### 8.2.2 Asset Manifest
- 8.2.2.1 `manifest.json` — maps original filenames → hashed filenames — SSR template use
  - 8.2.2.1.1 `build.manifest: true` — Vite — generates `.vite/manifest.json`
  - 8.2.2.1.2 Server-side consumption — PHP/Rails/Django reads manifest — inject correct `<link>`

### 8.3 Asset Inlining (Data URL Thresholds)
#### 8.3.1 Inline vs Reference Decision
- 8.3.1.1 Size threshold — files below limit inlined as `data:` URL — reduces HTTP requests
  - 8.3.1.1.1 Default threshold — 4 kB (esbuild) / 4 kB (Vite) — configurable
  - 8.3.1.1.2 Base64 overhead — ~33% size increase — tradeoff: fewer requests vs larger JS
- 8.3.1.2 Force inline — `?inline` query — always data URL regardless of size
  - 8.3.1.2.1 Force reference — `?url` query — always return URL — even if below threshold

### 8.4 Image Optimization
#### 8.4.1 Build-Time Image Processing
- 8.4.1.1 `vite-plugin-imagemin` — lossy/lossless compression — mozjpeg / pngquant / svgo
  - 8.4.1.1.1 AVIF/WebP generation — `?format=webp` — serve modern format — fallback in HTML
- 8.4.1.2 Responsive images — `?width=400` — resize at build time — `srcset` generation
  - 8.4.1.2.1 Sharp binding — native C++ — fast — requires Node.js native addons

### 8.5 CSS Modules & CSS-in-JS
#### 8.5.1 CSS Modules Pipeline
- 8.5.1.1 Scoped class names — collision-free — auto-generated identifiers
  - 8.5.1.1.1 `generateScopedName` — `[name]__[local]__[hash:5]` — readable in dev
  - 8.5.1.1.2 Composition — `composes` keyword — multi-class without runtime overhead
- 8.5.1.2 CSS-in-JS extraction — Linaria / vanilla-extract — static extraction at build time
  - 8.5.1.2.1 Zero runtime — CSS extracted to `.css` file — no JS overhead — tree-shakeable styles

### 8.6 WASM & Binary Assets
#### 8.6.1 WebAssembly Integration
- 8.6.1.1 WASM ESM integration proposal — `import init from './mod.wasm'` — async default export
  - 8.6.1.1.1 Vite native WASM — `?init` suffix — returns async init function
  - 8.6.1.1.2 `instantiateStreaming` — fetch + compile overlap — faster than arraybuffer path
- 8.6.1.2 WASM in workers — `new Worker(new URL('./worker.wasm', import.meta.url))` — bundler-aware
  - 8.6.1.2.1 `import.meta.url` — bundler replaces with asset URL — enables worker URL pattern
