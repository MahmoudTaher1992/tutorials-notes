# Bundlers - Part 5: Source Maps & Caching

## 9.0 Source Maps

### 9.1 VLQ Encoding & v3 Format
#### 9.1.1 Source Map v3 Structure
- 9.1.1.1 JSON format — `version`, `sources`, `names`, `mappings` — standard fields
  - 9.1.1.1.1 `sources` array — list of original file paths — relative to map file
  - 9.1.1.1.2 `sourcesContent` — embed original source inline — self-contained map — larger file
- 9.1.1.2 `mappings` field — VLQ-encoded string — semicolons = output lines — commas = segments
  - 9.1.1.2.1 Segment structure — up to 5 VLQ fields: generated col, source idx, orig line, orig col, name idx
  - 9.1.1.2.2 VLQ encoding — Base64 6-bit groups — continuation bit at MSB — signed integers
- 9.1.1.3 `x_google_ignoreList` — mark generated/vendor segments — DevTools skip in call stacks
  - 9.1.1.3.1 Bundler emits `ignoreList` for node_modules — cleaner stack traces in browser devtools

#### 9.1.2 Source Map Index (Multi-Part)
- 9.1.2.1 `sections` array — each section has `offset` + nested map — for concatenated outputs
  - 9.1.2.1.1 `offset: { line, column }` — where in output this section begins
  - 9.1.2.1.2 Rarely used — most bundlers flatten to single `mappings` string — simpler tooling

### 9.2 Source Map Types
#### 9.2.1 Inline vs External
- 9.2.1.1 Inline — `//# sourceMappingURL=data:application/json;base64,...` — self-contained
  - 9.2.1.1.1 Size impact — base64 map often 3–5× source size — large bundles bloat significantly
  - 9.2.1.1.2 Use case — unit test runners / CI where no file serving — convenience over size
- 9.2.1.2 External — `//# sourceMappingURL=bundle.js.map` — separate `.map` file
  - 9.2.1.2.1 `hidden` source map — no `sourceMappingURL` comment — map exists but not auto-loaded
  - 9.2.1.2.2 Hidden use case — error monitoring (Sentry) — upload maps to service, never serve to users

#### 9.2.2 Source Map Granularity
- 9.2.2.1 `devtool: 'source-map'` (Webpack naming) — full line+column mapping — slowest
- 9.2.2.2 `devtool: 'cheap-module-source-map'` — line only — faster — good for dev iteration
  - 9.2.2.2.1 `cheap` = column info dropped — still maps to original line — sufficient for most debugging
- 9.2.2.3 `devtool: 'eval-source-map'` — `eval()` with inline maps per module — fastest rebuild
  - 9.2.2.3.1 Security policy risk — `eval` blocked by strict CSP — unusable in CSP-enforced environments

### 9.3 Source Map Chaining
#### 9.3.1 Transform Chain Composition
- 9.3.1.1 Each transform produces partial map — `A→B` then `B→C` — compose to `A→C`
  - 9.3.1.1.1 `remapping` library — Mozilla — compose arbitrary map chains — used by many bundlers
  - 9.3.1.1.2 MagicString — tracks mutations — emits incremental map — used in Rollup
- 9.3.1.2 Map merging correctness — errors propagate if any link in chain is wrong
  - 9.3.1.2.1 Null mappings — segments without source info — break chain — show as `(anonymous)`
  - 9.3.1.2.2 Column offset errors — off-by-one in column — common Babel/SWC bug — check with tests

### 9.4 Debug Info Preservation
#### 9.4.1 Function Names in Maps
- 9.4.1.1 `names` array — preserved original identifiers — appear in browser call stack frames
  - 9.4.1.1.1 Minifier must emit names — Terser: `keep_fnames` — esbuild: auto-includes names
  - 9.4.1.1.2 Anonymous function naming — `const foo = () => {}` → name inferred as `foo` — modern engines
- 9.4.1.2 Source map validation — `source-map-validator` — check maps for correctness
  - 9.4.1.2.1 Common issue — minifier strips all mappings for DCE'd code — positions shift

---

## 10.0 Caching & Incremental Builds

### 10.1 Filesystem Cache
#### 10.1.1 Cache Directory
- 10.1.1.1 Persistent cache — written to `.cache/` or `node_modules/.cache/` — survives restarts
  - 10.1.1.1.1 Cache key — file content hash + config hash + dependency version hash
  - 10.1.1.1.2 Cache miss — any key component changes → full re-transform of module
- 10.1.1.2 Cache serialization — JSON or binary (MessagePack) — balance parse speed vs size
  - 10.1.1.2.1 LMDB — memory-mapped B-tree — Parcel's choice — sub-millisecond read/write

#### 10.1.2 Cache Invalidation
- 10.1.2.1 Config change detection — hash bundler config — any option change busts all cache
  - 10.1.2.1.1 Partial invalidation — only affected modules re-built — config change may affect all
  - 10.1.2.1.2 Plugin version pinning — plugin update → new hash → cache bust — intentional
- 10.1.2.2 Dependency version change — lock file hash included in cache key
  - 10.1.2.2.1 `package-lock.json` hash — cheap to compute — detects any dep change

### 10.2 In-Memory Cache
#### 10.2.1 Module Cache
- 10.2.1.1 Parse cache — file content hash → AST — avoid re-parse within same build
  - 10.2.1.1.1 Invalidation — content change → new hash → cache miss — O(1) lookup
  - 10.2.1.1.2 Hot vs cold — in-memory only lives for process lifetime — disk cache persists
- 10.2.1.2 Transform result cache — `{ code, map }` per module — skip transforms on unchanged
  - 10.2.1.2.1 Plugin cache API — `this.cache.set(key, value)` — Rollup — persisted between builds

### 10.3 Cache Invalidation Strategies
#### 10.3.1 Content-Addressed Invalidation
- 10.3.1.1 Hash file contents — sha1/xxhash of raw bytes — change detection without timestamps
  - 10.3.1.1.1 xxhash — 64-bit non-cryptographic — 10× faster than SHA-1 — used by esbuild/Parcel
  - 10.3.1.1.2 mtime fallback — stat mtime as quick pre-check — read + hash only if mtime changed
- 10.3.1.2 Config hash — serialize config object → hash — any option change → full bust
  - 10.3.1.2.1 Normalize config before hash — sort keys, resolve functions to stubs — stable hash

#### 10.3.2 Dependency-Based Invalidation
- 10.3.2.1 Input → output dependency tracking — store `{ inputFiles: Set, hash }` per output
  - 10.3.2.1.1 Any input changed → output invalid — re-run only affected transform
  - 10.3.2.1.2 Transitive deps — CSS @import A → B — change B → invalidate A's output too

### 10.4 Module Hash Computation
#### 10.4.1 Stable Module Identity
- 10.4.1.1 Module hash = hash(source) + hash(deps) — recursive — deep content signature
  - 10.4.1.1.1 Laplacian hash — hash of module + all transitive input hashes — full subtree
  - 10.4.1.1.2 Boundary isolation — hash stops at external package boundary — dep version controls it
- 10.4.1.2 Chunk hash derivation — hash of all module hashes in chunk — stable across unrelated changes
  - 10.4.1.2.1 Counter-example — adding new chunk re-numbers IDs — busts all chunk hashes (old Webpack)
  - 10.4.1.2.2 Named IDs — use file path as module ID — stable across additions — Rollup default

### 10.5 Persistent Cache (LMDB, SQLite, Flat Files)
#### 10.5.1 Storage Backend Comparison
- 10.5.1.1 LMDB — memory-mapped — zero-copy reads — concurrent reads — single writer — Parcel
  - 10.5.1.1.1 ACID transactions — write groups — atomicity — no partial writes on crash
  - 10.5.1.1.2 Page size tuning — default 4 kB — larger pages better for big values — config option
- 10.5.1.2 SQLite — robust — WAL mode — concurrent readers — used by Next.js / Turbopack
  - 10.5.1.2.1 WAL (Write-Ahead Log) — readers not blocked by writes — `PRAGMA journal_mode=WAL`
  - 10.5.1.2.2 SQL query capability — introspect cache contents — debugging advantage over LMDB
- 10.5.1.3 Flat JSON/binary files — simple — one file per module — high inode usage on large repos
  - 10.5.1.3.1 Babel cache — `babel.config.json` + `.babel_cache_path` — flat file per transformed module
  - 10.5.1.3.2 Inode exhaustion risk — 100k+ files — some filesystems have inode limits
