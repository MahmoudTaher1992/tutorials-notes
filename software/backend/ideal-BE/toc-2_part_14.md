# The Ideal Backend — Framework Specifics

## Table of Contents — Part 14: Go & Rust Frameworks

> Format: items that match the Ideal are referenced as "→ Ideal §X.X".
> Items marked **Unique** are specific to this framework.

---

### Go (Gin / Echo / Fiber)

#### Language & Runtime
- → Ideal §1 (Go, statically typed, compiled, garbage collected)
- **Unique: Goroutines** — lightweight concurrency (millions of concurrent goroutines)
- **Unique: Channels** — CSP-style inter-goroutine communication
- **Unique: Single binary deployment** — compile to standalone executable, no runtime needed
- **Unique: Fast compilation** — near-instant build times

#### Framework Landscape
- **Gin** — most popular, fast, middleware-focused
- **Echo** — similar to Gin, slightly more features
- **Fiber** — Express-inspired, built on fasthttp
- **Chi** — lightweight, `net/http` compatible
- **Standard library (`net/http`)** — production-ready without frameworks

#### Routing & HTTP → Ideal §4
- Gin: `r.GET("/users/:id", handler)`, route groups
- Echo: `e.GET("/users/:id", handler)`, route groups
- **Unique: `net/http` ServeMux** — Go 1.22+ has pattern matching built-in
- **Unique: Context passing** — `context.Context` for cancellation and deadlines

#### Middleware → Ideal §5
- `func(c *gin.Context)` / `echo.MiddlewareFunc`
- `c.Next()` for chain continuation
- **Unique: `net/http` middleware** — `func(next http.Handler) http.Handler` pattern (standard)

#### Auth → Ideal §6
- JWT via `golang-jwt/jwt` library
- OAuth2 via `golang.org/x/oauth2`
- No framework-provided auth — manual implementation or libraries
- **Unique: Minimal auth libraries** — Go community favors writing auth logic explicitly

#### Validation → Ideal §8
- `go-playground/validator` — struct tag validation (`validate:"required,email"`)
- Manual validation (common in Go)
- **Unique: Struct tags** — validation rules embedded in struct definitions

#### Database → Ideal §10
- GORM (full ORM, Active Record style)
- sqlx (enhanced `database/sql`)
- **Unique: `database/sql`** — standard library database interface
- **Unique: Ent** — Facebook's type-safe entity framework
- golang-migrate for migrations
- **Unique: sqlc** — compile SQL to type-safe Go code

#### Caching → Ideal §12
- `go-redis/redis` (Redis client)
- `patrickmn/go-cache` (in-memory)
- **Unique: `sync.Map`** — concurrent-safe map in standard library

#### Real-time → Ideal §22
- `gorilla/websocket` — WebSocket library
- **Unique: Goroutine-per-connection** — natural concurrency model for WebSockets
- Melody, Centrifugo for WebSocket infrastructure

#### API Design → Ideal §17
- `swaggo/swag` — generate Swagger from code comments
- **Unique: Protocol Buffers / gRPC** — Go has first-class gRPC support
- `grpc-go` — Google's official gRPC implementation

#### Background Jobs → Ideal §27
- Asynq (Redis-based), Machinery
- **Unique: Simple goroutine-based workers** — no framework needed for basic background work
- `robfig/cron` for scheduled tasks

#### Testing → Ideal §43
- **Unique: `testing` package** — built into standard library
- **Unique: Table-driven tests** — idiomatic Go testing pattern
- `httptest` — HTTP testing utilities in standard library
- testify for assertions and mocking
- **Unique: `go test -race`** — built-in race condition detector

#### Performance → Ideal §53
- **Unique: Exceptionally high performance** — close to C/Rust for network I/O
- **Unique: Low memory footprint** — goroutines use ~2KB stack
- **Unique: `pprof`** — built-in profiling tool (CPU, memory, goroutines, blocking)

#### Error Handling → Ideal §9
- **Unique: Explicit error returns** — `value, err := function()` pattern (no exceptions)
- **Unique: `errors.Is()`, `errors.As()`** — error wrapping and checking
- **Unique: Sentinel errors and custom error types**

#### DX → Ideal §47
- **Unique: `go fmt`** — enforced formatting (no debates)
- **Unique: `go vet`** — static analysis built-in
- **Unique: `golangci-lint`** — meta-linter aggregating 100+ linters

---

### Rust (Actix Web / Axum)

#### Language & Runtime
- → Ideal §1 (Rust, statically typed, compiled, no GC)
- **Unique: Ownership and borrowing** — memory safety without garbage collection
- **Unique: Zero-cost abstractions** — no runtime overhead for abstractions
- **Unique: Async runtime** — Tokio (most popular), async-std
- **Unique: Compile-time safety** — most errors caught at compile time

#### Framework Landscape
- **Actix Web** — mature, actor-based, very high performance
- **Axum** — by Tokio team, tower middleware, ergonomic
- **Rocket** — macro-heavy, ergonomic, batteries-included
- **Warp** — filter-based composition

#### Routing & HTTP → Ideal §4
- Axum: `Router::new().route("/users/:id", get(handler))`
- Actix: `web::resource("/users/{id}").route(web::get().to(handler))`
- **Unique: Type-safe extractors** — request data extracted via function parameters

#### Middleware → Ideal §5
- Axum: Tower middleware and layers
- Actix: Transform trait, middleware factories
- **Unique: Tower ecosystem** — composable middleware layers (shared across Rust HTTP ecosystem)

#### Auth → Ideal §6
- `jsonwebtoken` crate for JWT
- Manual implementation (common in Rust)
- **Unique: Type-safe auth extractors** — compile-time enforcement of auth requirements

#### Validation → Ideal §8
- `validator` crate — derive macro validation
- **Unique: Serde** — `serde_json` for serialization/deserialization (ubiquitous in Rust)
- **Unique: Type system as validation** — newtypes and enums prevent invalid states

#### Database → Ideal §10
- **Unique: SQLx** — compile-time checked SQL queries (verifies against real DB)
- Diesel (ORM with type-safe query builder)
- Sea-ORM (async ORM inspired by ActiveRecord)
- `sqlx::migrate!()` for migrations

#### Caching → Ideal §12
- `redis` crate
- `moka` — concurrent in-memory cache (Caffeine-inspired)

#### Real-time → Ideal §22
- `tokio-tungstenite` — async WebSocket library
- Axum built-in WebSocket support

#### API Design → Ideal §17
- `utoipa` — derive OpenAPI from Rust types
- `tonic` — gRPC framework (Protobuf code generation)
- `async-graphql` — GraphQL framework

#### Background Jobs → Ideal §27
- Tokio tasks (`tokio::spawn`) for async background work
- `apalis` — background job framework
- **Unique: Async tasks are lightweight** — Tokio can handle millions of concurrent tasks

#### Testing → Ideal §43
- **Unique: Built-in test framework** — `#[test]`, `#[tokio::test]`
- **Unique: Doc tests** — code examples in documentation are compiled and tested
- `reqwest` for HTTP client testing
- **Unique: `cargo test`** — single command runs all tests

#### Performance → Ideal §53
- **Unique: Highest performance tier** — consistently tops benchmarks (TechEmpower)
- **Unique: Predictable latency** — no GC pauses
- **Unique: Memory efficiency** — minimal allocations, zero-copy where possible

#### Error Handling → Ideal §9
- **Unique: `Result<T, E>`** — errors are values, must be handled
- **Unique: `?` operator** — ergonomic error propagation
- `thiserror` and `anyhow` crates for error handling ergonomics

#### DX → Ideal §47
- **Unique: `cargo`** — build tool, package manager, test runner (all-in-one)
- **Unique: Compiler error messages** — famously helpful and detailed
- **Unique: Steep learning curve** — ownership model requires mindset shift
- `clippy` — official linter with actionable suggestions
- **Unique: Long compile times** — trade-off for runtime performance

---

> **Navigation:** [← Part 13: Rails & Express.js](toc-2_part_13.md) | [Part 15: Phoenix, Flask, Hono + Comparisons →](toc-2_part_15.md)
