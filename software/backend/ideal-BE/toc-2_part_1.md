# The Ideal Backend — Complete Study Guide

## Table of Contents — Part 1: Foundation (§1–3)

> This guide defines every component of an "angel" backend — the platonic ideal that real frameworks approximate.
> Parts 10–15 map popular frameworks against this ideal.

---

## Part I: Foundation

### 1. Language & Runtime

#### 1.1 Language Characteristics
- 1.1.1 Type system (static vs dynamic, strong vs weak)
- 1.1.2 Compiled vs interpreted vs JIT
- 1.1.3 Memory management (GC vs manual vs ownership)
- 1.1.4 Syntax paradigm (OOP, functional, multi-paradigm)
- 1.1.5 Null safety and error handling philosophy

#### 1.2 Runtime & Execution Model
- 1.2.1 Event loop vs thread-per-request
- 1.2.2 Concurrency primitives (threads, goroutines, async/await, actors, fibers)
- 1.2.3 Runtime overhead and cold start times
- 1.2.4 Native vs VM-based execution (JVM, CLR, V8, BEAM)
- 1.2.5 Single-threaded vs multi-threaded runtimes

#### 1.3 Ecosystem & Package Management
- 1.3.1 Package manager (npm, pip, Maven/Gradle, NuGet, Cargo, hex, Composer)
- 1.3.2 Ecosystem maturity and library availability
- 1.3.3 Community size and support
- 1.3.4 Long-term support and versioning policies

#### 1.4 Language Selection Criteria
- 1.4.1 Performance requirements
- 1.4.2 Team expertise and hiring pool
- 1.4.3 Ecosystem fit for domain
- 1.4.4 Scalability characteristics
- 1.4.5 Learning curve and onboarding time

---

### 2. Framework Architecture

#### 2.1 Architectural Patterns
- 2.1.1 MVC (Model-View-Controller)
- 2.1.2 MVVM (Model-View-ViewModel)
- 2.1.3 Component-based architecture
- 2.1.4 Modular architecture
- 2.1.5 Minimal/micro-framework approach

#### 2.2 Dependency Injection (DI)
- 2.2.1 What DI solves (loose coupling, testability)
- 2.2.2 Constructor injection vs property injection vs method injection
- 2.2.3 IoC containers and service registries
- 2.2.4 Lifetime/scope management (singleton, scoped, transient)
- 2.2.5 Auto-wiring vs explicit registration

#### 2.3 Module System
- 2.3.1 Feature modules vs shared modules
- 2.3.2 Module boundaries and encapsulation
- 2.3.3 Lazy loading modules
- 2.3.4 Module communication patterns

#### 2.4 Application Lifecycle
- 2.4.1 Bootstrap/startup sequence
- 2.4.2 Configuration loading order
- 2.4.3 Service initialization and teardown
- 2.4.4 Graceful shutdown hooks
- 2.4.5 Health check readiness during startup

#### 2.5 Convention vs Configuration
- 2.5.1 Convention-over-configuration philosophy
- 2.5.2 Configuration-first approach
- 2.5.3 Trade-offs: magic vs explicitness
- 2.5.4 Overriding conventions

---

### 3. Architectural Patterns (Clean, Hexagonal, DDD)

#### 3.1 Domain-Driven Design (DDD)
- 3.1.1 Ubiquitous language
- 3.1.2 Bounded contexts
- 3.1.3 Aggregates and aggregate roots
- 3.1.4 Entities vs value objects
- 3.1.5 Domain services vs application services
- 3.1.6 Domain events
- 3.1.7 Anti-corruption layers
- 3.1.8 Context mapping

#### 3.2 Clean Architecture
- 3.2.1 Dependency rule (dependencies point inward)
- 3.2.2 Layers: entities, use cases, interface adapters, frameworks
- 3.2.3 Use case driven development
- 3.2.4 Separating business logic from infrastructure

#### 3.3 Hexagonal Architecture (Ports & Adapters)
- 3.3.1 Ports (interfaces for the outside world)
- 3.3.2 Adapters (implementations of ports)
- 3.3.3 Primary/driving vs secondary/driven adapters
- 3.3.4 Testability benefits

#### 3.4 Onion Architecture
- 3.4.1 Core domain at the center
- 3.4.2 Layer dependencies
- 3.4.3 Differences from Clean Architecture

#### 3.5 Vertical Slice Architecture
- 3.5.1 Feature-based organization
- 3.5.2 Each slice contains all layers for one feature
- 3.5.3 Trade-offs vs horizontal layering

#### 3.6 Repository Pattern & Unit of Work
- 3.6.1 Repository as abstraction over data access
- 3.6.2 Generic vs specific repositories
- 3.6.3 Unit of Work for transactional boundaries
- 3.6.4 When repositories help vs add complexity

#### 3.7 CQRS (Command Query Responsibility Segregation)
- 3.7.1 Separating read and write models
- 3.7.2 Command handlers vs query handlers
- 3.7.3 When CQRS adds value vs over-engineering
- 3.7.4 CQRS with Event Sourcing

---

> **Navigation:** [Part 2: Core (§4–9) →](toc-2_part_2.md)
