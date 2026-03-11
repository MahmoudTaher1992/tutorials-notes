# The Ideal Backend — Framework Specifics

## Table of Contents — Part 10: ASP.NET Core & Spring Boot

> Format: items that match the Ideal are referenced as "→ Ideal §X.X".
> Items marked **Unique** are specific to this framework.

---

### ASP.NET Core (C#)

#### Language & Runtime
- → Ideal §1 (C#, statically typed, .NET runtime / CLR)
- **Unique: Multi-targeting** — .NET 6/7/8/9+, cross-platform via .NET Core
- **Unique: AOT compilation** — Native AOT for minimal footprint and fast startup

#### Framework Architecture
- → Ideal §2.1 (MVC pattern with Controllers)
- → Ideal §2.2 (built-in DI container, constructor injection, lifetime scopes)
- **Unique: Minimal APIs** — lightweight alternative to controllers (`app.MapGet`)
- **Unique: Blazor Server/WASM** — full-stack C# with SignalR

#### Routing & HTTP → Ideal §4
- Attribute routing (`[Route]`, `[HttpGet]`) and conventional routing
- **Unique: Endpoint routing** — unified routing pipeline for MVC, Razor, gRPC, SignalR

#### Middleware → Ideal §5
- `app.Use()`, `app.Map()`, `app.Run()` pipeline
- **Unique: Request delegates** — function-based middleware
- **Unique: Filters** — action filters, result filters, exception filters, authorization filters

#### Auth → Ideal §6
- ASP.NET Identity framework (users, roles, claims)
- `[Authorize]` attribute, policy-based authorization
- **Unique: ANCM (ASP.NET Core Module)** — IIS integration (→ web-server TOC §9.6)

#### Database → Ideal §10
- Entity Framework Core (Code First, Database First, migrations)
- **Unique: LINQ** — language-integrated queries
- Dapper as micro-ORM alternative

#### Caching → Ideal §12
- `IMemoryCache`, `IDistributedCache` interfaces
- **Unique: Output caching middleware** (built-in response caching)

#### Real-time → Ideal §22
- **Unique: SignalR** — WebSockets with automatic fallback, hub pattern, groups

#### Testing → Ideal §43
- xUnit, NUnit, MSTest
- `WebApplicationFactory` for integration testing
- **Unique: `TestServer`** — in-memory test host

#### API Design → Ideal §17
- OpenAPI via Swashbuckle / NSwag
- **Unique: API controllers with `[ApiController]`** — automatic model validation, binding

#### Background Jobs → Ideal §27
- **Unique: `IHostedService` and `BackgroundService`** — built-in background workers
- Hangfire, Quartz.NET for advanced scheduling

#### Performance → Ideal §53
- **Unique: Kestrel** — high-performance, cross-platform web server
- **Unique: System.IO.Pipelines** — low-allocation I/O
- **Unique: gRPC-first support** — first-class gRPC with code generation

#### Resilience → Ideal §24
- **Unique: Microsoft.Extensions.Http.Resilience** (Polly v8 integration)
- `IHttpClientFactory` with retry/circuit breaker policies

---

### Java Spring Boot

#### Language & Runtime
- → Ideal §1 (Java, statically typed, JVM)
- **Unique: GraalVM Native Image** — AOT compilation for fast startup
- **Unique: Kotlin support** — first-class Kotlin as alternative language
- **Unique: Virtual Threads (Project Loom)** — lightweight concurrency (Java 21+)

#### Framework Architecture
- → Ideal §2.1 (MVC via Spring MVC)
- → Ideal §2.2 (Spring IoC container — the original DI framework)
- **Unique: Spring Boot auto-configuration** — convention-based bean wiring
- **Unique: Spring Boot starters** — curated dependency bundles
- **Unique: Profiles** — environment-specific bean configuration

#### Routing & HTTP → Ideal §4
- `@RestController`, `@RequestMapping`, `@GetMapping`, `@PostMapping`
- **Unique: Spring WebFlux** — reactive, non-blocking alternative to Spring MVC

#### Middleware → Ideal §5
- Servlet filters, Spring interceptors (`HandlerInterceptor`)
- **Unique: AOP (Aspect-Oriented Programming)** — cross-cutting concerns via `@Aspect`

#### Auth → Ideal §6
- **Unique: Spring Security** — comprehensive security framework
- OAuth2 Resource Server, SAML, LDAP, form login, JWT
- Method-level security (`@PreAuthorize`, `@Secured`)

#### Database → Ideal §10
- Spring Data JPA (Hibernate), Spring Data JDBC
- **Unique: Spring Data repositories** — interface-based, auto-implemented queries
- **Unique: Spring Data** — unified data access for JPA, MongoDB, Redis, Elasticsearch, R2DBC
- Flyway, Liquibase for migrations

#### Caching → Ideal §12
- `@Cacheable`, `@CacheEvict`, `@CachePut` annotations
- **Unique: Cache abstraction** — pluggable backends (Caffeine, Redis, EhCache)

#### Real-time → Ideal §22
- Spring WebSocket, STOMP protocol
- **Unique: Spring Integration** — enterprise messaging patterns

#### Testing → Ideal §43
- JUnit 5, Mockito, AssertJ
- `@SpringBootTest` for full context tests
- **Unique: `@DataJpaTest`, `@WebMvcTest`** — slice testing (load only relevant beans)
- Testcontainers first-class support

#### API Design → Ideal §17
- SpringDoc OpenAPI (Swagger)
- **Unique: Spring HATEOAS** — hypermedia-driven REST APIs
- Spring for GraphQL

#### Background Jobs → Ideal §27
- `@Scheduled`, `@Async` annotations
- **Unique: Spring Batch** — enterprise batch processing framework
- **Unique: Spring Integration / Spring Cloud Stream** — message-driven microservices

#### Microservices → Ideal §29
- **Unique: Spring Cloud** — complete microservices toolkit
  - Spring Cloud Gateway (API gateway)
  - Spring Cloud Config (centralized configuration)
  - Spring Cloud Netflix (Eureka service discovery)
  - Spring Cloud Circuit Breaker (Resilience4j)
  - Spring Cloud Sleuth → Micrometer Tracing (distributed tracing)

#### Event-Driven → Ideal §28
- **Unique: Spring Cloud Stream** — Kafka/RabbitMQ binding abstraction
- **Unique: Spring Modulith** — modular monolith with domain events

#### Performance → Ideal §53
- **Unique: Spring Native** — GraalVM native compilation
- **Unique: Project CRaC** — checkpoint/restore for instant startup

---

> **Navigation:** [← Part 9: DevOps & DX](toc-2_part_9.md) | [Part 11: NestJS & Django →](toc-2_part_11.md)
