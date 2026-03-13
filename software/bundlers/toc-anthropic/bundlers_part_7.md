# Bundlers - Part 7: Configuration, Performance, Security & Observability

## 13.0 Configuration System

### 13.1 Config File Resolution
#### 13.1.1 Discovery
- 13.1.1.1 Config file lookup — `bundler.config.ts` → `.js` → `.mjs` → `.cjs` — first found
  - 13.1.1.1.1 `--config` CLI flag — explicit path — skip auto-discovery
  - 13.1.1.1.2 Config in package.json — `"bundler": {}` key — simpler for small projects
- 13.1.1.2 Config as ESM or CJS — bundler detects format from extension or `type` in package.json
  - 13.1.1.2.1 TypeScript config — bundler self-transpiles config file — esbuild/Jiti used

#### 13.1.2 `defineConfig` Helper
- 13.1.2.1 Type inference — wraps config object — provides TypeScript autocomplete — no runtime effect
  - 13.1.2.1.1 Overloaded forms — `defineConfig({})` / `defineConfig((env) => {})` — fn for env-aware

### 13.2 Environment-Specific Config
#### 13.2.1 Mode System
- 13.2.1.1 `mode` — `development` / `production` / `test` — injected into `process.env.NODE_ENV`
  - 13.2.1.1.1 Custom modes — `--mode staging` — load `.env.staging` — full custom env
  - 13.2.1.1.2 Mode vs NODE_ENV — can differ — `mode=staging` with `NODE_ENV=production`
- 13.2.1.2 `.env` file loading — `.env` → `.env.local` → `.env.{mode}` — order = priority
  - 13.2.1.2.1 `VITE_` prefix — only exposed to client — non-prefixed stays server-only
  - 13.2.1.2.2 `envPrefix` config — customize prefix — `REACT_APP_` for CRA compat

### 13.3 Programmatic API
#### 13.3.1 Build API
- 13.3.1.1 `build(config)` — returns `Promise<RollupOutput>` — invoke from Node.js scripts
  - 13.3.1.1.1 Multiple outputs — call build in loop — or `output: [...]` array — one pass
  - 13.3.1.1.2 Watch mode — `build({ watch: {} })` — returns `RollupWatcher` with event emitter
- 13.3.1.2 `createServer(config)` — programmatic dev server — test tooling / custom integration
  - 13.3.1.2.1 `server.listen()` — start HTTP — returns server info with port + URLs

### 13.4 Config Merging
#### 13.4.1 Deep Merge Behavior
- 13.4.1.1 Plugin arrays — concatenated — order preserved — `pre` plugins first
  - 13.4.1.1.1 `mergeConfig(base, override)` — Vite utility — smart array merge vs object merge
  - 13.4.1.1.2 `define` object — shallow merged — override wins per key
- 13.4.1.2 Function config — `defineConfig((env) => mergeConfig(base, envSpecific(env)))`

---

## 14.0 Performance & Optimization

### 14.1 Native vs JS Implementations
#### 14.1.1 Rust/Go Bundlers
- 14.1.1.1 Go (esbuild) — parallel goroutines — low memory — 10–100× faster than Webpack
  - 14.1.1.1.1 No GC pause — Go GC concurrent — minimal stop-the-world — consistent latency
  - 14.1.1.1.2 Single binary — no npm install — no node_modules — fast CI cold start
- 14.1.1.2 Rust (Rolldown, SWC, Oxc) — zero-cost abstractions — arena allocators — low overhead
  - 14.1.1.2.1 Oxc parser — 3× faster than Babel — 3× lower memory — used in Rolldown/Biome
  - 14.1.1.2.2 Rayon parallelism — data-parallel transforms — automatic thread pool — work-stealing

#### 14.1.2 WASM in Node.js
- 14.1.2.1 SWC/Oxc WASM build — runs in Node.js without native addon — portable at perf cost
  - 14.1.2.1.1 WASM ~2× slower than native — GC pressure via WASM-GC — acceptable for many
  - 14.1.2.1.2 Native addon preferred — `@swc/core` with .node binary — fast but platform-specific

### 14.2 Parallelism Strategies
#### 14.2.1 Thread Pool Sizing
- 14.2.1.1 Worker count = CPU logical cores — `os.cpus().length` — default in most bundlers
  - 14.2.1.1.1 Hyper-threading — 2 threads/core — transforms often IO-bound enough to benefit
  - 14.2.1.1.2 CI environment — container CPUs limited — check `nproc` — over-allocation wastes RAM
- 14.2.1.2 Work-stealing scheduler — idle threads steal tasks from busy threads — balanced load
  - 14.2.1.2.1 Rayon (Rust) — built-in work-stealing — no manual thread management needed

### 14.3 Bundle Size Analysis
#### 14.3.1 Tools
- 14.3.1.1 `rollup-plugin-visualizer` — treemap / sunburst / network — per-module size breakdown
  - 14.3.1.1.1 `stats.html` output — open in browser — interactive — gzip / brotli / raw size toggle
- 14.3.1.2 `vite-bundle-analyzer` — Vite wrapper — auto-opens after build — `--open` flag
- 14.3.1.3 `bundlephobia.com` — per-package cost analysis — check before adding dependency
  - 14.3.1.3.1 Duplicate detection — same package in multiple versions — bundle size multiplied

#### 14.3.2 Size Budgets
- 14.3.2.1 CI size budget enforcement — `bundlesize` / `size-limit` — fail PR if over budget
  - 14.3.2.1.1 `size-limit` config — per-path budget — gzipped — `"limit": "50 kB"`
  - 14.3.2.1.2 Compression test — gzip vs brotli — brotli ~15% smaller — test both for CDN

### 14.4 Build Speed Benchmarking
#### 14.4.1 Metrics
- 14.4.1.1 Cold build time — no cache — measures raw pipeline speed — cache-independent baseline
- 14.4.1.2 Warm build time — with filesystem cache — typical CI scenario after first run
  - 14.4.1.2.1 Hot rebuild (watch) — single file change — HMR / incremental rebuild latency
- 14.4.1.3 Profiling — `--profile` flag — flame graph — identify bottleneck hooks
  - 14.4.1.3.1 Plugin timing — Rollup outputs plugin hook durations — find slow `transform` hooks

---

## 15.0 Security

### 15.1 Supply Chain Attacks via Plugins
#### 15.1.1 Malicious Plugin Risk
- 15.1.1.1 Plugin has full Node.js access — can exfiltrate source code — read env vars — exec commands
  - 15.1.1.1.1 Audit plugins before use — check npm download counts — inspect source on GitHub
  - 15.1.1.1.2 Pin plugin versions — `package-lock.json` — avoid `^` range for build plugins
- 15.1.1.2 Typosquatting — `vit-plugin-react` vs `@vitejs/plugin-react` — check org namespace
  - 15.1.1.2.1 Use official plugins — Vite ecosystem has clear official namespace — trust chain

### 15.2 Secrets Leaked into Bundles
#### 15.2.1 `define` & `.env` Risks
- 15.2.1.1 `process.env` inlining — bundler replaces ALL `process.env.X` — including secrets
  - 15.2.1.1.1 `VITE_` prefix enforcement — only `VITE_` vars inlined — server-only vars safe
  - 15.2.1.1.2 Audit bundle for secrets — `strings bundle.js | grep -i key/token/secret` — CI check
- 15.2.1.2 Source maps in production — `sourcesContent: true` — original source in map file
  - 15.2.1.2.1 `hidden` source maps — generate maps but don't expose via `sourceMappingURL`
  - 15.2.1.2.2 Upload to Sentry/Datadog — private map upload — error tracing without public exposure

### 15.3 Prototype Pollution in Build Tools
#### 15.3.1 Attack Surface
- 15.3.1.1 Deep merge of user config — `Object.assign({}, userConfig)` without safeguards
  - 15.3.1.1.1 Malicious package.json `__proto__` key — pollutes Object prototype chain
  - 15.3.1.1.2 Mitigation — use `Object.create(null)` for merge targets — no prototype chain

### 15.4 Dependency Confusion Attacks
#### 15.4.1 Private Package Shadowing
- 15.4.1.1 Attacker publishes public pkg with same name as internal private pkg — higher version wins
  - 15.4.1.1.1 Mitigation — scoped private packages — `@company/pkg` — not shadowed by public
  - 15.4.1.1.2 Private registry first — `.npmrc` `registry` pointing to private first — fallback to npm

---

## 16.0 Observability & Diagnostics

### 16.1 Build Stats & Reporting
#### 16.1.1 Output Statistics
- 16.1.1.1 Rollup `output.stats` — per-chunk sizes — gzip estimates — module list per chunk
  - 16.1.1.1.1 JSON stats — `--json` flag — machine-readable — pipe to analyzer tooling
- 16.1.1.2 esbuild metafile — `metafile: true` — inputs/outputs/imports graph — JSON
  - 16.1.1.2.1 `esbuild.analyzeMetafile(metafile)` — ASCII treemap in terminal — built-in

### 16.2 Bundle Analysis Tools
#### 16.2.1 Visualization
- 16.2.1.1 Treemap — area proportional to size — quick visual of large contributors
- 16.2.1.2 Network graph — chunk import relationships — identify unnecessary cross-chunk deps
  - 16.2.1.2.1 Circular chunk deps — visible in network graph — refactor entry points

### 16.3 Error Messages & Diagnostics
#### 16.3.1 Structured Errors
- 16.3.1.1 Location info — `{ file, line, column }` — click-to-open in IDE via terminal links
  - 16.3.1.1.1 `this.error({ message, loc: { file, line, column } })` — Rollup plugin error API
- 16.3.1.2 Error overlay — dev server — full-screen error with source frame — HMR-driven
  - 16.3.1.2.1 Dismiss on fix — error overlay auto-clears when source fixed and HMR applied

### 16.4 Performance Tracing
#### 16.4.1 Build Profiling
- 16.4.1.1 Node.js `--prof` — V8 profiler — flame graph via `node --prof-process`
  - 16.4.1.1.1 `clinic.js` — `clinic flame` — modern Node.js profiler — async-aware
- 16.4.1.2 Plugin-level timing — wrap each plugin hook — measure duration — report slowest
  - 16.4.1.2.1 `vite-plugin-inspect` — dump each module's transform result — inspect pipeline output
