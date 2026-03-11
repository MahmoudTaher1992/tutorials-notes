# The Ideal Backend — Framework Specifics

## Table of Contents — Part 13: Ruby on Rails & Express.js

> Format: items that match the Ideal are referenced as "→ Ideal §X.X".
> Items marked **Unique** are specific to this framework.

---

### Ruby on Rails

#### Language & Runtime
- → Ideal §1 (Ruby, dynamically typed, interpreted, MRI/CRuby with GVL)
- **Unique: JRuby** — JVM-based Ruby for true multi-threading
- **Unique: YJIT** — built-in JIT compiler (Ruby 3.1+, significant speedup)

#### Framework Architecture
- → Ideal §2.1 (MVC — the framework that popularized MVC for web)
- → Ideal §2.5 (the original "convention over configuration" framework)
- **Unique: "Rails Way"** — strong opinions: file naming, directory structure, naming conventions
- **Unique: Engines** — mountable mini-applications for modularity
- **Unique: Concerns** — shared behavior modules (`ActiveSupport::Concern`)

#### Routing & HTTP → Ideal §4
- `resources :users` generates full RESTful routes
- **Unique: `config/routes.rb`** — Ruby DSL for routing
- **Unique: Shallow nesting** — `resources :posts, shallow: true`

#### Middleware → Ideal §5
- Rack middleware stack
- **Unique: `before_action`, `after_action`, `around_action`** — controller-level filters
- **Unique: Rack** — the Ruby HTTP interface standard (shared with Sinatra, Hanami)

#### Auth → Ideal §6
- Devise gem (de facto auth solution)
- **Unique: `has_secure_password`** — built-in bcrypt password handling
- Pundit / CanCanCan for authorization policies

#### Validation → Ideal §8
- **Unique: ActiveModel validations** — `validates :name, presence: true, length: { maximum: 50 }`
- Model-level validation (runs before save)
- **Unique: Custom validators** — reusable validator classes

#### Database → Ideal §10
- **Unique: ActiveRecord** — the original Active Record ORM
- **Unique: Migrations** — `rails generate migration AddEmailToUsers email:string`
- **Unique: `db/schema.rb`** — declarative schema representation
- Associations: `has_many`, `belongs_to`, `has_and_belongs_to_many`, polymorphic
- **Unique: Scopes** — reusable query fragments (`scope :active, -> { where(active: true) }`)

#### Caching → Ideal §12
- **Unique: Russian doll caching** — nested fragment caching with auto-expiry
- `Rails.cache`, cache stores (Redis, Memcached, file, memory)
- **Unique: `cache` helper in views** — fragment caching in templates

#### Real-time → Ideal §22
- **Unique: Action Cable** — WebSockets integrated into Rails
- Channels, subscriptions, broadcasting
- Redis pub/sub for multi-server scaling

#### API Design → Ideal §17
- `rails new --api` — API-only mode (skip views, assets)
- **Unique: Active Model Serializers / Blueprinter / jbuilder** — JSON serialization
- **Unique: jbuilder** — Ruby DSL for JSON responses

#### Background Jobs → Ideal §27
- **Unique: Active Job** — unified interface for background job backends
- Sidekiq (Redis-based, most popular), Delayed Job, Resque, Good Job
- **Unique: Solid Queue** — database-backed queue (Rails 8+)

#### SSR & Templates → Ideal §34
- **Unique: ERB** — embedded Ruby templates (default)
- Haml, Slim as alternatives
- **Unique: Turbo + Hotwire** — HTML-over-the-wire (SPA-like feel without JS)

#### Testing → Ideal §43
- **Unique: Minitest** (default) and RSpec (community standard)
- **Unique: Fixtures** — YAML-based test data (unique to Rails)
- FactoryBot for test data factories
- **Unique: System tests** — Capybara integration for browser testing

#### Email → Ideal §31
- **Unique: Action Mailer** — `UserMailer.welcome(user).deliver_later`
- **Unique: Action Mailbox** — inbound email processing (receive and route emails)

#### File Storage → Ideal §30
- **Unique: Active Storage** — file uploads attached to models, cloud storage abstraction

#### CLI → Ideal §46
- **Unique: `rails generate`** — scaffolding for models, controllers, migrations, mailers
- **Unique: `rails console`** — IRB/Pry REPL with full app context
- **Unique: `rails dbconsole`** — direct database shell access

---

### Express.js (Node.js)

#### Language & Runtime
- → Ideal §1 (JavaScript/TypeScript, V8 runtime, event-loop single-threaded)
- Node.js `cluster` module for multi-core utilization

#### Framework Architecture
- → Ideal §2.1 (minimal/micro-framework — no enforced architecture)
- **Unique: Unopinionated** — no built-in structure, ORM, or templating
- **Unique: Middleware-centric** — the entire framework is a middleware pipeline
- Developer defines their own architecture (MVC, service-layer, etc.)

#### Routing & HTTP → Ideal §4
- `app.get()`, `app.post()`, `req`, `res`, `next`
- **Unique: `express.Router()`** — modular route handlers
- Route parameters (`:id`), query parsing built-in

#### Middleware → Ideal §5
- `app.use()` — the core abstraction
- **Unique: Everything is middleware** — body parsing, auth, logging, error handling
- `(req, res, next)` signature
- **Unique: Error middleware** — `(err, req, res, next)` four-argument pattern

#### Auth → Ideal §6
- Passport.js (strategies: JWT, OAuth, local, Google, GitHub, etc.)
- Manual JWT handling (`jsonwebtoken` package)
- No built-in auth — fully developer's choice

#### Validation → Ideal §8
- express-validator, Joi, Zod, Yup (community libraries)
- No built-in validation

#### Database → Ideal §10
- No built-in ORM — choose from:
  - Prisma, TypeORM, Sequelize, Knex.js (query builder), Mongoose (MongoDB)
- Any migration tool compatible with chosen ORM

#### Caching → Ideal §12
- No built-in caching — use `node-cache`, `ioredis`, `cache-manager`
- Middleware-based response caching (community packages)

#### Real-time → Ideal §22
- Socket.IO (most popular), `ws` (native WebSocket library)
- No built-in WebSocket support

#### API Design → Ideal §17
- Manual OpenAPI with `swagger-jsdoc` + `swagger-ui-express`
- No built-in API documentation

#### Background Jobs → Ideal §27
- BullMQ (Redis-based), Agenda (MongoDB-based), Bee-Queue
- No built-in job system

#### SSR & Templates → Ideal §34
- EJS, Handlebars, Pug via `app.set('view engine', 'ejs')`
- **Unique: Pluggable view engines** — any engine that implements Express interface

#### Testing → Ideal §43
- **Unique: supertest** — HTTP assertion library designed for Express
- Jest, Mocha, Vitest for test runners
- No built-in test utilities

#### Performance → Ideal §53
- **Unique: Lightweight** — minimal overhead, fast startup
- `compression` middleware for gzip
- Consider Fastify as higher-performance alternative

#### DX → Ideal §47
- **Unique: Massive ecosystem** — npm has a package for everything
- **Unique: Low barrier to entry** — simple mental model
- nodemon / tsx for hot reload in development

---

> **Navigation:** [← Part 12: FastAPI & Laravel](toc-2_part_12.md) | [Part 14: Go & Rust →](toc-2_part_14.md)
