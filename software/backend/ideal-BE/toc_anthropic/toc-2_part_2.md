# The Ideal Backend — Complete Study Guide

## Table of Contents — Part 2: Core (§4–9)

---

### 4. Routing & HTTP

#### 4.1 Route Definition
- 4.1.1 Declarative routing (decorators/attributes) vs imperative routing
- 4.1.2 Route parameters (path params, query params)
- 4.1.3 Route constraints and validation
- 4.1.4 Wildcard and catch-all routes
- 4.1.5 Route grouping and prefixing

#### 4.2 HTTP Method Handling
- 4.2.1 Mapping methods to handlers (GET, POST, PUT, PATCH, DELETE)
- 4.2.2 HEAD and OPTIONS auto-handling
- 4.2.3 Method override for legacy clients

#### 4.3 Route Organization
- 4.3.1 Controller-based routing
- 4.3.2 File-based routing (Next.js-style)
- 4.3.3 Resource/RESTful route conventions
- 4.3.4 Nested routes and sub-routers
- 4.3.5 Route naming and URL generation

#### 4.4 Request & Response Objects
- 4.4.1 Parsing request body (JSON, form data, multipart)
- 4.4.2 Reading headers and cookies
- 4.4.3 Building responses (status codes, headers, body)
- 4.4.4 Streaming responses
- 4.4.5 Redirect helpers

---

### 5. Middleware & Pipeline

#### 5.1 Middleware Concept
- 5.1.1 What middleware is (request/response interceptors)
- 5.1.2 Middleware execution order (pipeline)
- 5.1.3 Global vs route-specific middleware
- 5.1.4 Short-circuiting the pipeline

#### 5.2 Common Middleware Types
- 5.2.1 Logging middleware
- 5.2.2 Authentication middleware
- 5.2.3 CORS middleware
- 5.2.4 Body parsing middleware
- 5.2.5 Compression middleware
- 5.2.6 Rate limiting middleware

#### 5.3 Advanced Pipeline Concepts
- 5.3.1 Guards (pre-handler authorization checks)
- 5.3.2 Interceptors (transform request/response)
- 5.3.3 Filters (exception handling)
- 5.3.4 Pipes (input transformation and validation)
- 5.3.5 Before/after hooks and lifecycle events

---

### 6. Authentication & Authorization

#### 6.1 Authentication Strategies
- 6.1.1 Session-based authentication (cookies + server-side store)
- 6.1.2 Token-based authentication (JWT)
- 6.1.3 OAuth 2.0 and OpenID Connect flows
- 6.1.4 API key authentication
- 6.1.5 Multi-factor authentication (MFA/2FA)
- 6.1.6 Passwordless authentication (magic links, passkeys/WebAuthn)
- 6.1.7 Social login (Google, GitHub, Facebook)
- 6.1.8 SSO (Single Sign-On) with SAML and OIDC

#### 6.2 Authorization Models
- 6.2.1 RBAC (Role-Based Access Control)
- 6.2.2 ABAC (Attribute-Based Access Control)
- 6.2.3 Permission-based access control
- 6.2.4 Policy-based authorization
- 6.2.5 Resource ownership checks
- 6.2.6 Scope-based authorization (OAuth scopes)

#### 6.3 Token Management
- 6.3.1 Access tokens vs refresh tokens
- 6.3.2 Token storage (HTTP-only cookies vs localStorage)
- 6.3.3 Token rotation and revocation
- 6.3.4 Token blacklisting strategies
- 6.3.5 JWT claims design and best practices

---

### 7. Session & State Management

#### 7.1 Server-Side Sessions
- 7.1.1 In-memory session stores
- 7.1.2 Database-backed sessions
- 7.1.3 Redis/Memcached session stores
- 7.1.4 Session expiration and cleanup

#### 7.2 Stateless Design
- 7.2.1 Why stateless backends scale better
- 7.2.2 Encoding state in tokens
- 7.2.3 Client-side state management
- 7.2.4 Stateless vs stateful trade-offs

#### 7.3 Distributed State
- 7.3.1 Sticky sessions and session affinity
- 7.3.2 Centralized session stores in clusters
- 7.3.3 State synchronization challenges

---

### 8. Validation & Serialization

#### 8.1 Input Validation
- 8.1.1 Schema-based validation (Joi, Zod, class-validator, Pydantic)
- 8.1.2 Decorator/annotation-based validation
- 8.1.3 Custom validation rules
- 8.1.4 Nested object validation
- 8.1.5 Validation error formatting and response structure

#### 8.2 DTOs (Data Transfer Objects)
- 8.2.1 Why DTOs matter (decoupling internal models from API)
- 8.2.2 Request DTOs vs response DTOs
- 8.2.3 Auto-mapping between DTOs and entities
- 8.2.4 Partial DTOs for PATCH operations

#### 8.3 Serialization & Deserialization
- 8.3.1 JSON serialization (naming conventions, null handling)
- 8.3.2 XML serialization
- 8.3.3 Protocol Buffers and MessagePack
- 8.3.4 Content negotiation (Accept header)
- 8.3.5 Custom serializers and transformers
- 8.3.6 Circular reference handling

---

### 9. Error Handling

#### 9.1 Error Strategy
- 9.1.1 Exception-based vs result-based error handling
- 9.1.2 Global exception handlers/filters
- 9.1.3 Domain exceptions vs infrastructure exceptions
- 9.1.4 Error hierarchy and custom exception classes

#### 9.2 Error Response Format
- 9.2.1 RFC 7807 Problem Details standard
- 9.2.2 Consistent error envelope structure
- 9.2.3 Validation error formatting
- 9.2.4 Error codes and machine-readable identifiers
- 9.2.5 Stack traces in development vs production

#### 9.3 Error Handling Patterns
- 9.3.1 Try-catch boundaries
- 9.3.2 Error propagation through middleware
- 9.3.3 Async error handling
- 9.3.4 Unhandled exception safety nets
- 9.3.5 Error logging and alerting integration

---

> **Navigation:** [← Part 1: Foundation](toc-2_part_1.md) | [Part 3: Data (§10–16) →](toc-2_part_3.md)
