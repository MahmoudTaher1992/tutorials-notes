# Bundlers - Part 2: Dependency Graph & Transformation Pipeline

## 3.0 Dependency Graph

### 3.1 Graph Construction
#### 3.1.1 Static Import Discovery
- 3.1.1.1 `import` / `export` statement parsing — AST-level — catches all static edges
  - 3.1.1.1.1 Re-export chains — `export { foo } from './bar'` — transitive edge — must follow
  - 3.1.1.1.2 `import type` — TypeScript — erased — bundler must not add graph edge
- 3.1.1.2 `require()` calls — CJS — heuristic detection — only string-literal args are static
  - 3.1.1.2.1 Dynamic `require` — `require(variable)` — cannot statically resolve — must externalize
  - 3.1.1.2.2 `require.resolve` — returns path string — no module execution — safe to analyze

#### 3.1.2 Module Graph Data Structures
- 3.1.2.1 Adjacency map — `moduleId → Set<depId>` — forward edges — used for traversal
  - 3.1.2.1.1 Reverse map — `moduleId → Set<importerId>` — needed for HMR propagation
  - 3.1.2.1.2 Edge metadata — `{ specifier, isType, isDynamic, isOptional }` per edge
- 3.1.2.2 Module info record — `{ id, code, ast, map, importedIds, exportedNames, facadeId }`
  - 3.1.2.2.1 Facade module — re-export-only module — marks as transparent — optimization hint

### 3.2 Circular Dependency Handling
#### 3.2.1 Detection
- 3.2.1.1 DFS cycle detection — grey/white/black coloring — O(V+E)
  - 3.2.1.1.1 Strongly connected components — Tarjan's SCC — identifies all cycles in one pass
  - 3.2.1.1.2 Warning vs error — most bundlers warn on cycle — some allow opt-in error mode
- 3.2.1.2 ESM live binding semantics — circular imports work if binding is defined before use
  - 3.2.1.2.1 TDZ (temporal dead zone) — `let`/`const` accessed before assignment → ReferenceError
  - 3.2.1.2.2 Function hoisting as escape — `function foo(){}` hoisted before TDZ — safe circular ref

#### 3.2.2 Cycle Impact on Bundling
- 3.2.2.1 Scope hoisting conflicts — circular deps force runtime module wrapper — no flat bundle
  - 3.2.2.1.1 Rollup splitCycle — detects which exports cross cycle boundary — conservative wrap
- 3.2.2.2 Execution order — bundler must pick linearization — may differ from Node.js runtime order
  - 3.2.2.2.1 Test with real runtime — bundler order ≠ Node.js order — subtle init bugs possible

### 3.3 Dynamic Import Discovery
#### 3.3.1 `import()` Expressions
- 3.3.1.1 Static string argument — `import('./routes/home')` — edge added to graph — split point
  - 3.3.1.1.1 Chunk boundary creation — dynamic import → async chunk — loaded on demand
  - 3.3.1.1.2 Preload hint generation — `<link rel="modulepreload">` injected into HTML
- 3.3.1.2 Dynamic expression — `import('./routes/' + page)` — cannot resolve statically
  - 3.3.1.2.1 Glob import — `import.meta.glob('./routes/*.ts')` — Vite-specific — resolved to map
  - 3.3.1.2.2 Eager glob — `{ eager: true }` — inlines all matches — no async chunk split

#### 3.3.2 `require.context` (Webpack Legacy)
- 3.3.2.1 Pattern-based require — dynamic directory scanning — Webpack-only — not portable
  - 3.3.2.1.1 Migration path → `import.meta.glob` in Vite / esbuild glob entry

### 3.4 External Dependencies
#### 3.4.1 Externalization
- 3.4.1.1 Peer dependencies — mark as external — not bundled — consumer provides at runtime
  - 3.4.1.1.1 `external: ['react', 'react-dom']` — string match — regex — function predicate
  - 3.4.1.1.2 `output.globals` — UMD/IIFE — maps external id → global variable name
- 3.4.1.2 Node built-ins — `fs`, `path`, `crypto` — must externalize for browser targets
  - 3.4.1.2.1 Node polyfills — `node:` prefix stripping — browser shim injection — opt-in
  - 3.4.1.2.2 `platform: 'browser'` — auto-externalizes all Node built-ins

### 3.5 Graph Traversal Algorithms
#### 3.5.1 BFS vs DFS Traversal
- 3.5.1.1 BFS — level-order — good for parallel loading — all same-depth modules loadable together
  - 3.5.1.1.1 Queue-based — FIFO — natural parallelism via concurrent `Promise.all` per level
- 3.5.1.2 DFS — depth-first — natural for scope hoisting order — execution ordering preserved
  - 3.5.1.2.1 Post-order DFS — children before parent — correct bottom-up initialization order

#### 3.5.2 Incremental Graph Updates (Watch Mode)
- 3.5.2.1 Dirty module invalidation — mark changed module + all reverse deps as dirty
  - 3.5.2.1.1 Transitive invalidation — `import A → B → C` — change C → A, B, C all dirty
  - 3.5.2.1.2 Scope pruning — only re-traverse dirty subtrees — clean modules reuse cache

---

## 4.0 Transformation Pipeline

### 4.1 Loader / Transform Chain
#### 4.1.1 Loader Selection
- 4.1.1.1 Extension → loader mapping — `.ts` → ts loader — `.vue` → vue plugin transform
  - 4.1.1.1.1 Loader override — plugin `resolveId` can return `{ id, loader }` — bypass extension
  - 4.1.1.1.2 Multi-step file — `.module.css` — double extension — specific loader priority
- 4.1.1.2 Chained transforms — multiple plugins each transform same file — compose in order
  - 4.1.1.2.1 Short-circuit — first plugin returning non-null code wins load — chain halts

### 4.2 JavaScript / TypeScript Transpilation
#### 4.2.1 Target Environments
- 4.2.1.1 `target` option — `es2015` / `es2020` / `esnext` / browserslist query
  - 4.2.1.1.1 Syntax lowering — arrow fn → function — optional chaining → ternary — per target
  - 4.2.1.1.2 `useBuiltIns` — inject corejs polyfills per target — `entry` vs `usage` mode
- 4.2.1.2 TypeScript stripping — remove type annotations — no type checking at bundle time
  - 4.2.1.2.1 `isolatedModules: true` — required for esbuild/SWC single-file transform
  - 4.2.1.2.2 `const enum` — requires full program — not supported in isolated mode — use `enum`

#### 4.2.2 Decorator Transforms
- 4.2.2.1 Legacy decorators (`experimentalDecorators`) — TS 4 style — class + property decorators
  - 4.2.2.1.1 Babel legacy plugin — `@babel/plugin-proposal-decorators` — `legacy: true`
- 4.2.2.2 TC39 stage-3 decorators — new semantics — different call signature — not backward-compatible
  - 4.2.2.2.1 TS 5 native support — `experimentalDecorators: false` default in TS 5 — breaking change

### 4.3 JSX / TSX Transformation
#### 4.3.1 JSX Runtimes
- 4.3.1.1 Classic runtime — `React.createElement` — requires React in scope — every file
  - 4.3.1.1.1 Pragma comment — `/* @jsx h */` — override createElement per file
- 4.3.1.2 Automatic runtime — React 17+ — no import needed — bundler injects runtime import
  - 4.3.1.2.1 `jsxImportSource` — tsconfig / vite config — swap react for preact/solid/etc.
  - 4.3.1.2.2 `jsx: 'preserve'` — pass JSX through untransformed — downstream tool handles

### 4.4 CSS Processing
#### 4.4.1 CSS Import Handling
- 4.4.1.1 `import './style.css'` — bundler extracts CSS — emits as separate file or inlines in JS
  - 4.4.1.1.1 CSS extraction — single `style.css` output — requires `<link>` in HTML
  - 4.4.1.1.2 CSS injection — JS inserts `<style>` at runtime — no separate file — flash of unstyled
- 4.4.1.2 CSS Modules — `.module.css` — class names locally scoped — exported as JS object
  - 4.4.1.2.1 Identifier mangling — `.foo` → `.foo_a3x2k` — hash from file path + class name
  - 4.4.1.2.2 Composition — `composes: base from './base.module.css'` — multi-class merge

#### 4.4.2 Preprocessors
- 4.4.2.1 PostCSS — plugin pipeline — autoprefixer / nesting / custom-media — runs post-CSS parse
  - 4.4.2.1.1 `postcss.config.js` — auto-discovered — applies globally to all CSS
- 4.4.2.2 Sass / Less / Stylus — compile to CSS — bundler plugin or built-in (Parcel)
  - 4.4.2.2.1 `@import` resolution — relative path — node_modules tilde (`~pkg/file`) — custom resolver

### 4.5 Environment Variable Injection
#### 4.5.1 `define` Replacement
- 4.5.1.1 Compile-time constants — `process.env.NODE_ENV` → `"production"` — string replacement
  - 4.5.1.1.1 Dead code via define — `if (process.env.NODE_ENV === 'development')` → pruned in prod
  - 4.5.1.1.2 JSON serialization — non-string values serialized — `define: { __VERSION__: '"1.0"' }`
- 4.5.1.2 `import.meta.env` — Vite convention — typed via `vite-env.d.ts` — `.env` file loaded
  - 4.5.1.2.1 `VITE_` prefix — only prefixed vars exposed to client — prevents secret leakage

### 4.6 Macros & Compile-Time Transforms
#### 4.6.1 Babel Macros
- 4.6.1.1 `babel-plugin-macros` — `import foo from 'foo.macro'` — arbitrary AST transform at call site
  - 4.6.1.1.1 `preval` macro — evaluate node code at build time — inline result as literal
  - 4.6.1.1.2 `codegen` macro — generate code string → injected as JS — metaprogramming

#### 4.6.2 Import Attributes (Stage 3)
- 4.6.2.1 `import data from './data.json' with { type: 'json' }` — explicit type hint
  - 4.6.2.1.1 Security intent — prevent MIME confusion — browser native + bundler awareness
  - 4.6.2.1.2 `assert` → `with` — syntax renamed in TC39 — bundlers must handle both
