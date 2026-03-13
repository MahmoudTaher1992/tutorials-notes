# Bundlers - Part 6: Dev Server & Plugin Architecture

## 11.0 Dev Server & Hot Module Replacement

### 11.1 Dev Server Architecture
#### 11.1.1 Request-Time Compilation
- 11.1.1.1 On-demand transform — serve file only when browser requests it — no pre-build
  - 11.1.1.1.1 First request latency — file transformed on first request — subsequent requests cached
  - 11.1.1.1.2 Cold start advantage — skip building unused routes — only build what's viewed
- 11.1.1.2 Pre-bundling phase — bundle node_modules once at startup — CJS → ESM — esbuild fast
  - 11.1.1.2.1 Dependency discovery scan — scan entry for bare imports — bundle all deps together
  - 11.1.1.2.2 Pre-bundle cache — stored in `node_modules/.vite` — invalidated by lockfile change
- 11.1.1.3 Middleware chain — connect/Koa — plugin dev server middleware hooks — req/res intercept
  - 11.1.1.3.1 Plugin `configureServer` — add custom middleware — run before or after core middlewares

#### 11.1.2 HTTP Semantics
- 11.1.2.1 Module negotiation — `Accept: application/javascript` — proper MIME for ESM
  - 11.1.2.1.1 `text/javascript` — correct MIME type — bundler must respond with correct Content-Type
- 11.1.2.2 304 Not Modified — `ETag` or `Last-Modified` — in-memory cache check — skip re-transform
  - 11.1.2.2.1 ETag = module content hash — stable per version — browser conditional GET

### 11.2 HMR Protocol
#### 11.2.1 HMR Message Types
- 11.2.1.1 `connected` — server → client — initial handshake on WebSocket open
- 11.2.1.2 `update` — server → client — `{ type: 'js-update', updates: [{path, timestamp}] }`
  - 11.2.1.2.1 Timestamp query param — `?t=1234567890` — cache-busts updated module
  - 11.2.1.2.2 CSS update — type `css-update` — replace `<link>` href in DOM — no page reload
- 11.2.1.3 `full-reload` — server → client — page reload when HMR boundary not found
- 11.2.1.4 `prune` — server → client — module removed from graph — cleanup callbacks
- 11.2.1.5 `error` — server → client — transform error — display overlay

#### 11.2.2 HMR API (Client-Side)
- 11.2.2.1 `import.meta.hot.accept(cb)` — self-accept — module handles own update
  - 11.2.2.1.1 `cb(newModule)` — receives fresh module exports — swap state manually
  - 11.2.2.1.2 No accept → propagate to parent — walks import graph up — find boundary
- 11.2.2.2 `import.meta.hot.accept(['./dep'], cb)` — accept dep update — handle dep change
  - 11.2.2.2.1 Framework integration — React Fast Refresh, Vue HMR — implement via plugin
- 11.2.2.3 `import.meta.hot.dispose(cb)` — cleanup before update — clear timers/subscriptions
  - 11.2.2.3.1 `data` object — `import.meta.hot.data.state` — pass state across HMR cycles
- 11.2.2.4 `import.meta.hot.invalidate()` — force full reload from within module — escape hatch

### 11.3 WebSocket Communication
#### 11.3.1 WebSocket Server
- 11.3.1.1 Bundler runs WebSocket server alongside HTTP — same process — shared event bus
  - 11.3.1.1.1 Port — same as dev server or `server.hmr.port` override — configurable
  - 11.3.1.1.2 Secure WebSocket (wss) — required with HTTPS — certificate sharing with dev server
- 11.3.1.2 Reconnection — client auto-reconnects on disconnect — exponential backoff
  - 11.3.1.2.1 Server restart detection — reconnect → server version check → full reload if mismatch

### 11.4 Module Update Propagation
#### 11.4.1 Invalidation Graph Walk
- 11.4.1.1 Changed file → mark dirty → walk reverse dep edges to find HMR boundary
  - 11.4.1.1.1 HMR boundary — first module with `hot.accept` in the path — update stops here
  - 11.4.1.1.2 No boundary found — propagate to root entry — trigger full reload
- 11.4.1.2 Multi-path invalidation — A changed — B and C both import A — both paths checked
  - 11.4.1.2.1 Shortest path wins — send update for boundary closest to changed file

#### 11.4.2 Circular Dep in HMR Graph
- 11.4.2.1 Cycle in import graph — invalidation may loop — bundler must deduplicate visited nodes
  - 11.4.2.1.1 Visited set — DFS with seen set — prevents infinite traversal

### 11.5 Full Reload Fallback
#### 11.5.1 Trigger Conditions
- 11.5.1.1 No HMR boundary found — propagated to entry — browser full reload
  - 11.5.1.1.1 Config file change — `vite.config.ts` changed — server restarts — client reloads
  - 11.5.1.1.2 `.env` file change — env vars changed — full reload required — no partial update
- 11.5.1.2 HMR accept error — exception thrown in `accept` callback — fallback full reload
  - 11.5.1.2.1 Error overlay — `import.meta.hot` error display — fix code → auto-retry HMR

---

## 12.0 Plugin & Loader Architecture

### 12.1 Plugin Hook System
#### 12.1.1 Hook Types
- 12.1.1.1 First hook — first plugin returning non-null wins — used for `resolveId` / `load`
  - 12.1.1.1.1 Short-circuit — remaining plugins not called — order matters — put overrides first
- 12.1.1.2 Sequential hook — all plugins called in order — `transform` — results chain
  - 12.1.1.2.1 Chain input — each plugin receives output of previous — compose transforms
- 12.1.1.3 Parallel hook — all plugins called concurrently — `buildStart`, `buildEnd`
  - 12.1.1.3.1 Race safety — parallel hooks must not modify shared state — read-only context

#### 12.1.2 Hook Execution Context (`this`)
- 12.1.2.1 `this.resolve(id, importer)` — call resolver from within plugin — recursive resolution
- 12.1.2.2 `this.load(id)` — load another module — trigger full pipeline for dep
- 12.1.2.3 `this.emitFile({ type, name, source })` — emit asset from any hook phase
- 12.1.2.4 `this.warn(msg)` / `this.error(msg)` — structured diagnostics — location info

### 12.2 Build vs Output Hooks
#### 12.2.1 Build Hooks (Analysis Phase)
- 12.2.1.1 `buildStart(options)` — once per build — initialize plugin state — async supported
- 12.2.1.2 `resolveId(source, importer)` — intercept module resolution — return new ID or null
  - 12.2.1.2.1 Virtual module pattern — return `\0virtual:module-id` — prefix `\0` = virtual
  - 12.2.1.2.2 `{ id, external: true }` — mark as external — skip bundling
- 12.2.1.3 `load(id)` — return `{ code, map }` — intercept file read — virtual module content
- 12.2.1.4 `transform(code, id)` — mutate code per module — return `{ code, map }` or null
  - 12.2.1.4.1 Filter early — `if (!id.endsWith('.ts')) return null` — avoid unnecessary work
  - 12.2.1.4.2 Source map must be valid — incorrect map breaks debugging — use MagicString
- 12.2.1.5 `buildEnd(err?)` — after graph complete — cleanup — error if build failed
- 12.2.1.6 `moduleParsed({ id, importedIds, exportedNames })` — after each module parsed — analysis

#### 12.2.2 Output Hooks (Generation Phase)
- 12.2.2.1 `renderStart(outputOptions)` — once per output — parallel output generation start
- 12.2.2.2 `renderChunk(code, chunk, options)` — transform chunk after bundle — minify here
  - 12.2.2.2.1 Chunk metadata — `chunk.facadeModuleId` / `chunk.imports` — for banner/license gen
- 12.2.2.3 `generateBundle(options, bundle)` — inspect/mutate final bundle — delete/add chunks
  - 12.2.2.3.1 `delete bundle[fileName]` — remove unwanted output files — e.g. pure type chunks
- 12.2.2.4 `writeBundle(options, bundle)` — after files written — side effects OK here

### 12.3 Virtual Modules
#### 12.3.1 Pattern
- 12.3.1.1 `resolveId` returns `\0virtual:foo` → `load` handles `\0virtual:foo` → returns code
  - 12.3.1.1.1 `\0` prefix — prevents other plugins from intercepting — de facto convention
  - 12.3.1.1.2 Use case — inject runtime config, auto-generated routes, env types
- 12.3.1.2 Virtual module with dynamic content — return different code per build target
  - 12.3.1.2.1 `import 'virtual:icons/circle'` → SVG inline code — `unplugin-icons` pattern

### 12.4 Plugin Ordering & Priority
#### 12.4.1 `enforce` Option
- 12.4.1.1 `enforce: 'pre'` — run before core plugins — alias resolution, raw transforms
  - 12.4.1.1.1 Vite-specific — Rollup has no enforce — pre/post only in Vite plugin context
- 12.4.1.2 `enforce: 'post'` — run after core plugins — minification, bundle analysis
- 12.4.1.3 Default (no enforce) — middle — runs after pre, before post

### 12.5 `unplugin` — Universal Plugin Interface
#### 12.5.1 Cross-Bundler Plugins
- 12.5.1.1 `unplugin` — write once — adapters for Vite, Rollup, Webpack, esbuild, Rspack
  - 12.5.1.1.1 Hook mapping — `resolveId`, `load`, `transform` translated to each bundler's API
  - 12.5.1.1.2 Limitation — lowest common denominator — advanced bundler-specific hooks unavailable
