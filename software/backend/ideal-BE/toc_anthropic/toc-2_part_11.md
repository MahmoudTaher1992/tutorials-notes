# The Ideal Backend — Framework Specifics

## Table of Contents — Part 11: NestJS & Django

> Format: items that match the Ideal are referenced as "→ Ideal §X.X".
> Items marked **Unique** are specific to this framework.

---

### NestJS (TypeScript / Node.js)

#### Language & Runtime
- → Ideal §1 (TypeScript, V8 runtime, event-loop concurrency)
- **Unique: Decorators and metadata reflection** — heavy use of TypeScript decorators
- **Unique: Platform-agnostic** — runs on Express or Fastify under the hood

#### Framework Architecture
- → Ideal §2.1 (MVC-inspired with Controllers, Services, Modules)
- → Ideal §2.2 (built-in DI container, constructor injection, module-scoped providers)
- **Unique: Module system** — `@Module()` decorator with imports, exports, providers, controllers
- **Unique: Angular-inspired architecture** — similar patterns to Angular frontend

#### Routing & HTTP → Ideal §4
- `@Controller()`, `@Get()`, `@Post()`, `@Param()`, `@Query()`, `@Body()`
- **Unique: Route versioning** — built-in URI, header, media type versioning

#### Middleware & Pipeline → Ideal §5
- **Unique: Full pipeline with distinct concepts:**
  - Middleware (Express/Fastify compatible)
  - Guards (`@UseGuards()` — authorization)
  - Interceptors (`@UseInterceptors()` — transform request/response, timing, caching)
  - Pipes (`@UsePipes()` — validation, transformation)
  - Exception filters (`@UseFilters()` — error handling)
- Execution order: Middleware → Guards → Interceptors (before) → Pipes → Handler → Interceptors (after) → Filters

#### Auth → Ideal §6
- **Unique: Passport.js integration** via `@nestjs/passport`
- Guards for role-based and policy-based auth
- JWT, sessions, OAuth strategies

#### Validation → Ideal §8
- **Unique: class-validator + class-transformer** — decorator-based DTO validation
- `ValidationPipe` for automatic request validation

#### Database → Ideal §10
- TypeORM, Prisma, MikroORM, Sequelize integration
- **Unique: `@nestjs/typeorm`, `@nestjs/prisma`** — dedicated integration modules
- **Unique: Repository pattern** built into TypeORM integration

#### Caching → Ideal §12
- **Unique: `@nestjs/cache-manager`** — decorator-based caching (`@CacheKey`, `@CacheTTL`)
- Redis, in-memory backends

#### Real-time → Ideal §22
- **Unique: WebSocket Gateways** — `@WebSocketGateway()`, `@SubscribeMessage()`
- Socket.IO and native WebSocket adapters
- **Unique: Redis adapter** for scaling WebSockets across instances

#### API Design → Ideal §17
- **Unique: `@nestjs/swagger`** — auto-generated OpenAPI from decorators
- **Unique: `@nestjs/graphql`** — code-first and schema-first GraphQL
- **Unique: `@nestjs/grpc`** — gRPC microservice transport

#### Background Jobs → Ideal §27
- **Unique: `@nestjs/bull`** — Bull/BullMQ queue integration with decorators
- `@Process()`, `@OnQueueActive()`, `@OnQueueCompleted()`

#### Microservices → Ideal §29
- **Unique: Built-in microservice transports** — TCP, Redis, NATS, MQTT, RabbitMQ, Kafka, gRPC
- **Unique: Hybrid applications** — HTTP + microservice in same app
- `@MessagePattern()`, `@EventPattern()` decorators

#### Testing → Ideal §43
- **Unique: `@nestjs/testing`** — `Test.createTestingModule()` for DI-aware testing
- Jest as default test runner
- Override providers for mocking in integration tests

---

### Django (Python)

#### Language & Runtime
- → Ideal §1 (Python, dynamically typed, interpreted, GIL concurrency limitation)
- **Unique: ASGI support** — async views via Django 4.x+ and Daphne/Uvicorn

#### Framework Architecture
- → Ideal §2.1 (MVT — Model-View-Template, Django's variant of MVC)
- → Ideal §2.5 (strong convention-over-configuration — "batteries included")
- **Unique: Apps system** — reusable apps as modules (`INSTALLED_APPS`)
- **Unique: Django Admin** — auto-generated admin panel from models

#### Routing & HTTP → Ideal §4
- `urlpatterns` with `path()` and `re_path()`
- **Unique: URL namespacing** — `app_name` and `namespace` for reverse URL resolution
- **Unique: URL converters** — `<int:pk>`, `<slug:slug>`, custom converters

#### Middleware → Ideal §5
- `MIDDLEWARE` list in settings (ordered pipeline)
- `process_request`, `process_view`, `process_response`, `process_exception` hooks

#### Auth → Ideal §6
- **Unique: Django auth system** — built-in User model, groups, permissions
- `@login_required`, `@permission_required` decorators
- **Unique: Custom user model** (`AUTH_USER_MODEL` — extendable auth)
- Django Allauth for social login and OAuth

#### Validation → Ideal §8
- Django Forms and ModelForms for validation
- **Unique: DRF Serializers** — `serializers.ModelSerializer` for API validation
- **Unique: Model-level validation** — `clean()`, `validators` on fields

#### Database → Ideal §10
- **Unique: Django ORM** — Active Record pattern, QuerySets, model managers
- **Unique: Migrations** — `makemigrations` / `migrate` (auto-generated from model changes)
- Multi-database routing (`DATABASE_ROUTERS`)
- **Unique: QuerySet API** — chainable, lazy evaluation (`.filter().exclude().order_by()`)

#### Caching → Ideal §12
- **Unique: Cache framework** — `cache.get()`, `cache.set()`, `@cache_page` decorator
- Backends: Memcached, Redis, database, file-based, local memory

#### Real-time → Ideal §22
- **Unique: Django Channels** — ASGI-based WebSocket support
- Channel layers (Redis, in-memory)
- Consumer classes for WebSocket handling

#### API Design → Ideal §17
- **Unique: Django REST Framework (DRF)** — the standard REST API toolkit
  - ViewSets and Routers (auto-generate URL patterns)
  - Serializers (validation + serialization)
  - Browsable API (HTML interface for API exploration)
  - Pagination, filtering, throttling built-in
- **Unique: Graphene-Django** — GraphQL integration

#### Background Jobs → Ideal §27
- Celery (de facto standard for Django async tasks)
- Django-Q, Huey as alternatives
- **Unique: `django-celery-beat`** — database-backed periodic task scheduling

#### SSR & Templates → Ideal §34
- **Unique: Django Template Language (DTL)** — `{% block %}`, `{% extends %}`, `{% include %}`
- Jinja2 as optional alternative
- Template context processors

#### Testing → Ideal §43
- **Unique: `django.test.TestCase`** — transaction-wrapped test cases
- **Unique: `django.test.Client`** — built-in HTTP test client
- `pytest-django` for pytest integration
- **Unique: Fixtures** — JSON/YAML/XML data loading

#### Admin → Built-in
- **Unique: Django Admin** — auto-CRUD from model registration
- `ModelAdmin` customization (list display, filters, search, inline editing)
- Admin actions for bulk operations

---

> **Navigation:** [← Part 10: ASP.NET Core & Spring Boot](toc-2_part_10.md) | [Part 12: FastAPI & Laravel →](toc-2_part_12.md)
