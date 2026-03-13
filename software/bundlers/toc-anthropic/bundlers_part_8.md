# Bundlers - Part 8: Vite

## 17.0 Vite

### 17.1 Architecture Overview
#### 17.1.1 Dual-Mode Design
- 17.1.1.1 Dev = ESM-native dev server (no bundling) — Prod = Rollup build — two separate pipelines
  - 17.1.1.1.1 Dev/prod parity risk — dev unbundled, prod bundled — behavior divergence possible
  - 17.1.1.1.2 `vite preview` — serve prod build locally — validate before deploy — close parity check
- 17.1.1.2 Node.js server — Koa-like middleware stack — serves transformed modules on demand
  - 17.1.1.2.1 HTTP/1.1 default — HTTP/2 opt-in via `server.https` + `@vitejs/plugin-basic-ssl`
  - 17.1.1.2.2 `server.proxy` — proxy API calls to backend — avoid CORS in dev — config-driven

### 17.2 Dev Server — ESM-Native, Koa-Based
#### 17.2.1 Module Serving
- 17.2.1.1 **Unique: On-demand transform** — no bundling step — each file transformed when requested
  - 17.2.1.1.1 **Unique: Import rewriting** — bare imports → `/node_modules/.vite/deps/pkg.js` URL
  - 17.2.1.1.2 **Unique: `/@fs/` prefix** — files outside root served via special Vite path prefix
- 17.2.1.2 → Module resolution: See Ideal §2.0 — with Vite alias + tsconfig paths on top
- 17.2.1.3 **Unique: `server.warmup`** — pre-transform specified files — eliminate first-request latency
  - 17.2.1.3.1 `server.warmup.clientFiles` — warm client-side modules — Vite 5.1+

#### 17.2.2 Pre-Bundling (Dependency Optimization)
- 17.2.2.1 **Unique: esbuild pre-bundle** — node_modules pre-bundled into single ESM file at startup
  - 17.2.2.1.1 **Unique: CJS → ESM conversion** — CommonJS deps converted — browser-compatible
  - 17.2.2.1.2 **Unique: Many-small-files → few** — lodash-es 600 modules → 1 — avoids request waterfall
- 17.2.2.2 **Unique: `optimizeDeps.include`** — force pre-bundle a dep not auto-discovered
  - 17.2.2.2.1 `optimizeDeps.exclude` — prevent pre-bundling — for ESM-native deps
- 17.2.2.3 **Unique: `__vite_ssr_import__` flag** — differentiate SSR imports during pre-bundle scan

### 17.3 Production Build (Rollup)
#### 17.3.1 Rollup Integration
- 17.3.1.1 → Output formats: See Ideal §5.0 — Rollup handles all format generation
- 17.3.1.2 → Code splitting: See Ideal §6.0 — Rollup's algorithm used
- 17.3.1.3 **Unique: `build.lib`** — library mode — single entry + ESM+CJS dual output — auto-externalize
  - 17.3.1.3.1 `build.lib.entry` — string or object — named entry map for multiple exports
  - 17.3.1.3.2 **Unique: `build.lib.formats`** — `['es', 'cjs', 'umd']` — multi-format single build

#### 17.3.2 Vite-Specific Build Options
- 17.3.2.1 **Unique: `build.target`** — sets esbuild transform target for syntax lowering in prod
  - 17.3.2.1.1 Defaults to `'modules'` — browsers supporting `<script type="module">` — ES2015+
- 17.3.2.2 **Unique: `build.cssCodeSplit`** — CSS extracted per chunk — async chunk gets own CSS file
  - 17.3.2.2.1 `false` → single `style.css` — simpler deployment — no CSS chunk ordering issues
- 17.3.2.3 **Unique: `build.assetsInlineLimit`** — assets < N bytes → data URL — default 4 kB
- 17.3.2.4 **Unique: `build.sourcemap: 'hidden'`** — maps generated but not referenced — Sentry upload

### 17.4 Vite Plugin API Additions (Beyond Rollup)
#### 17.4.1 Vite-Specific Hooks
- 17.4.1.1 **Unique: `configResolved(config)`** — after config finalized — read merged config
  - 17.4.1.1.1 Use case — plugins that need to know final base URL or SSR mode
- 17.4.1.2 **Unique: `configureServer(server)`** — add dev server middleware — WebSocket — events
  - 17.4.1.2.1 `server.watcher` — chokidar instance — watch arbitrary files for HMR
  - 17.4.1.2.2 `server.ws.send({ type, data })` — push custom HMR events to browser
- 17.4.1.3 **Unique: `handleHotUpdate({ file, modules, server })`** — custom HMR update logic
  - 17.4.1.3.1 Return filtered module array — or empty array to suppress update — full control
  - 17.4.1.3.2 `server.reloadModule(mod)` — force re-transform specific module
- 17.4.1.4 **Unique: `transformIndexHtml(html)`** — transform `index.html` — inject tags
  - 17.4.1.4.1 Tag injection — `{ tag: 'script', attrs: { src: '/analytics.js' } }` — append to head

#### 17.4.2 `enforce` & `apply` Options
- 17.4.2.1 **Unique: `enforce: 'pre' | 'post'`** — plugin ordering relative to Vite core plugins
  - 17.4.2.1.1 `pre` — runs before Vite alias resolution — useful for custom resolver
- 17.4.2.2 **Unique: `apply: 'build' | 'serve'`** — restrict plugin to build or dev mode only
  - 17.4.2.2.1 Function form — `apply: (config, { command }) => ...` — conditional activation

### 17.5 SSR Mode
#### 17.5.1 Vite SSR Architecture
- 17.5.1.1 **Unique: SSR module graph** — separate from client — Node.js-resolved imports
  - 17.5.1.1.1 `ssrLoadModule(url)` — Vite-managed ESM in Node.js — HMR-aware module loading
  - 17.5.1.1.2 `ssrExternalize` — keep node_modules as Node.js `require` — not transformed
- 17.5.1.2 **Unique: `ssr.noExternal`** — force-bundle specific SSR deps — override externalize
  - 17.5.1.2.1 Use for ESM-only packages — cannot be required — must be inlined

### 17.6 Library Mode
#### 17.6.1 Library Build Config
- 17.6.1.1 → See Ideal §5.1 for output format details
- 17.6.1.2 **Unique: Auto-externalize** — `peerDependencies` auto-externalized in lib mode — no config needed
  - 17.6.1.2.1 `rollupOptions.external` still needed for non-peer externals — explicit override

### 17.7 Environment API (Vite 6)
#### 17.7.1 Multiple Environments
- 17.7.1.1 **Unique: `environments`** — client / ssr / custom — each with own module graph
  - 17.7.1.1.1 **Unique: Plugin `environment` context** — `this.environment.name` in hooks
  - 17.7.1.1.2 **Unique: Per-environment optimizeDeps** — separate pre-bundle per environment
