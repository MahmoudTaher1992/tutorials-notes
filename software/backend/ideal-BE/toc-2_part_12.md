# The Ideal Backend — Framework Specifics

## Table of Contents — Part 12: FastAPI & Laravel

> Format: items that match the Ideal are referenced as "→ Ideal §X.X".
> Items marked **Unique** are specific to this framework.

---

### FastAPI (Python)

#### Language & Runtime
- → Ideal §1 (Python, dynamically typed but with type hints, async-native)
- **Unique: Built on Starlette** (ASGI framework) and **Pydantic** (data validation)
- **Unique: Async-first** — native `async def` endpoints, runs on Uvicorn/Hypercorn

#### Framework Architecture
- → Ideal §2.1 (minimal/micro-framework — no enforced architecture)
- **Unique: Function-based views** — no controllers, just decorated functions
- **Unique: APIRouter** — modular route organization (similar to Blueprints)

#### Routing & HTTP → Ideal §4
- `@app.get()`, `@app.post()`, path parameters with type annotations
- **Unique: Automatic parameter extraction** from type hints (path, query, body, header)

#### Middleware → Ideal §5
- ASGI middleware (Starlette-compatible)
- **Unique: Dependency injection via `Depends()`** — replaces traditional middleware for many use cases
- **Unique: Dependencies as guards** — auth, DB sessions, permissions via `Depends()`

#### Auth → Ideal §6
- OAuth2 with Password flow, Bearer token
- **Unique: `Security` utilities** — `OAuth2PasswordBearer`, `HTTPBearer`, `APIKeyHeader`
- **Unique: Dependency-based auth** — inject current user via `Depends(get_current_user)`

#### Validation → Ideal §8
- **Unique: Pydantic models as DTOs** — automatic validation from type annotations
- **Unique: Automatic request/response model** — declared in function signature
- **Unique: JSON Schema generation** from Pydantic models
- Nested models, custom validators, field constraints

#### Database → Ideal §10
- SQLAlchemy (async and sync), Tortoise ORM, SQLModel
- **Unique: SQLModel** — created by FastAPI author, merges SQLAlchemy + Pydantic
- Alembic for migrations

#### API Design → Ideal §17
- **Unique: Automatic OpenAPI/Swagger docs** — generated from type hints, zero config
- **Unique: Automatic ReDoc** — second docs UI out of the box
- **Unique: Response models** — `response_model` parameter for output serialization

#### Real-time → Ideal §22
- WebSocket support via Starlette (`@app.websocket()`)
- SSE via streaming responses

#### Background Jobs → Ideal §27
- **Unique: `BackgroundTasks`** — simple in-process background tasks
- Celery, ARQ, SAQ for production queues

#### Testing → Ideal §43
- **Unique: `TestClient`** (Starlette) — synchronous test client for async app
- pytest with `httpx.AsyncClient` for async testing
- Dependency overrides for mocking (`app.dependency_overrides`)

#### Performance → Ideal §53
- **Unique: One of the fastest Python frameworks** — Starlette + Uvicorn (ASGI)
- **Unique: Async database drivers** (asyncpg, aiomysql)
- Comparable to Node.js/Go for I/O-bound workloads (in benchmarks)

#### DX → Ideal §47
- **Unique: Exceptional developer experience** — type hints drive everything
- **Unique: IDE auto-completion** for request params, response models, dependencies

---

### Laravel (PHP)

#### Language & Runtime
- → Ideal §1 (PHP 8.x, dynamically typed with type hints, interpreted)
- **Unique: Swoole/Octane** — async runtime for persistent PHP processes
- **Unique: PHP-FPM** — traditional request lifecycle (shared-nothing)

#### Framework Architecture
- → Ideal §2.1 (MVC pattern)
- → Ideal §2.2 (Service container — powerful IoC/DI)
- → Ideal §2.5 (strong convention-over-configuration, "batteries included")
- **Unique: Service providers** — bootstrap and register bindings
- **Unique: Facades** — static-like syntax backed by DI container

#### Routing & HTTP → Ideal §4
- `Route::get()`, `Route::post()`, route model binding
- **Unique: Route model binding** — auto-inject Eloquent model from route parameter
- **Unique: Resource routes** — `Route::resource('photos', PhotoController::class)`

#### Middleware → Ideal §5
- Middleware pipeline, route-specific and global middleware
- **Unique: Middleware groups** (`web`, `api`) with pre-configured stacks

#### Auth → Ideal §6
- **Unique: Laravel Sanctum** — SPA token auth, mobile API tokens
- **Unique: Laravel Passport** — full OAuth2 server
- **Unique: Laravel Breeze / Jetstream** — auth scaffolding with registration, login, 2FA
- Gates and Policies for authorization

#### Validation → Ideal §8
- **Unique: Form Requests** — dedicated validation classes with `rules()` and `authorize()`
- `$request->validate()` inline validation
- **Unique: 100+ built-in validation rules**

#### Database → Ideal §10
- **Unique: Eloquent ORM** — Active Record pattern, expressive query builder
- **Unique: Artisan migrations** — `php artisan make:migration`, `migrate`, `rollback`
- **Unique: Eloquent relationships** — `hasMany()`, `belongsTo()`, `morphMany()` (polymorphic)
- Database seeders and model factories

#### Caching → Ideal §12
- `Cache::get()`, `Cache::put()`, `Cache::remember()`
- Drivers: file, database, Redis, Memcached, DynamoDB
- **Unique: Cache tags** for group invalidation

#### Real-time → Ideal §22
- **Unique: Laravel Echo + Broadcasting** — event broadcasting via WebSockets
- **Unique: Pusher, Ably, Laravel Reverb** — WebSocket server options
- Channel authorization (private, presence channels)

#### API Design → Ideal §17
- API Resources (`JsonResource`, `ResourceCollection`) for response transformation
- **Unique: Eloquent API Resources** — model-to-JSON transformation layer

#### Background Jobs → Ideal §27
- **Unique: Laravel Queues** — unified API for Redis, SQS, database, Beanstalkd
- **Unique: Laravel Horizon** — Redis queue monitoring dashboard
- Job chaining, batching, rate limiting
- **Unique: Task Scheduling** — `$schedule->command()->daily()` (cron replacement)

#### SSR & Templates → Ideal §34
- **Unique: Blade templates** — `@extends`, `@section`, `@yield`, `@component`
- **Unique: Livewire** — reactive UI without JavaScript (server-driven)
- **Unique: Inertia.js** — SPA without building an API

#### Testing → Ideal §43
- **Unique: Built-in testing helpers** — `$this->get()`, `$this->postJson()`, `assertStatus()`
- **Unique: Model Factories** — `User::factory()->count(10)->create()`
- Database assertions (`assertDatabaseHas`, `assertDatabaseMissing`)
- PHPUnit and Pest (expressive testing)

#### Email → Ideal §31
- **Unique: Mailables** — `Mail::to($user)->send(new OrderShipped($order))`
- **Unique: Mail preview in browser** — render mailables without sending

#### File Storage → Ideal §30
- **Unique: Filesystem abstraction** — `Storage::disk('s3')->put()` (local, S3, FTP)

---

> **Navigation:** [← Part 11: NestJS & Django](toc-2_part_11.md) | [Part 13: Rails & Express.js →](toc-2_part_13.md)
