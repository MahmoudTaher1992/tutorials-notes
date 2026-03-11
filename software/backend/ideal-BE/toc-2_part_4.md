# The Ideal Backend — Complete Study Guide

## Table of Contents — Part 4: API (§17–22)

---

### 17. API Design (REST, GraphQL, gRPC)

#### 17.1 REST API Design
- 17.1.1 Resource naming conventions (nouns, plural)
- 17.1.2 HTTP methods mapped to CRUD
- 17.1.3 Status code usage guidelines
- 17.1.4 HATEOAS and hypermedia
- 17.1.5 Query parameters vs path parameters
- 17.1.6 Envelope vs flat response structure
- 17.1.7 Partial responses (field selection)

#### 17.2 GraphQL API Design
- 17.2.1 Schema definition (types, queries, mutations)
- 17.2.2 Resolvers and data fetching
- 17.2.3 Input types and arguments
- 17.2.4 Enums and custom scalars
- 17.2.5 Error handling in GraphQL
- 17.2.6 Introspection and schema documentation

#### 17.3 gRPC API Design
- 17.3.1 Protocol Buffers (.proto) schema definition
- 17.3.2 Unary, server-streaming, client-streaming, bidirectional RPC
- 17.3.3 gRPC metadata and headers
- 17.3.4 gRPC status codes
- 17.3.5 gRPC-Web for browser clients

#### 17.4 API Documentation
- 17.4.1 OpenAPI/Swagger specification
- 17.4.2 Auto-generated docs from code (decorators, annotations)
- 17.4.3 Interactive API explorer (Swagger UI, Redoc)
- 17.4.4 GraphQL Playground / Apollo Studio
- 17.4.5 Postman/Insomnia collections

---

### 18. GraphQL Advanced Patterns

#### 18.1 Performance Patterns
- 18.1.1 DataLoader and batching (N+1 prevention)
- 18.1.2 Query complexity analysis and depth limiting
- 18.1.3 Persisted queries (whitelisted queries)
- 18.1.4 Automatic persisted queries (APQ)

#### 18.2 Federation & Composition
- 18.2.1 Schema stitching
- 18.2.2 Apollo Federation (subgraphs, gateway)
- 18.2.3 Entity references and `@key` directive
- 18.2.4 Federated tracing

#### 18.3 Advanced Features
- 18.3.1 Subscriptions (real-time via WebSockets)
- 18.3.2 Directives (custom and built-in)
- 18.3.3 Code-first vs schema-first approach
- 18.3.4 File uploads in GraphQL
- 18.3.5 Relay-style pagination (connections, edges, nodes)

---

### 19. API Versioning & Deprecation

#### 19.1 Versioning Strategies
- 19.1.1 URL path versioning (`/v1/`, `/v2/`)
- 19.1.2 Header-based versioning (`Accept-Version`)
- 19.1.3 Query parameter versioning (`?version=2`)
- 19.1.4 Content negotiation versioning (media types)
- 19.1.5 No versioning (evolving APIs)

#### 19.2 Backward Compatibility
- 19.2.1 Additive changes (safe)
- 19.2.2 Breaking changes (unsafe)
- 19.2.3 Deprecation notices and sunset headers
- 19.2.4 Migration guides for consumers
- 19.2.5 Running multiple versions simultaneously

#### 19.3 API Lifecycle Management
- 19.3.1 Alpha, beta, stable, deprecated, sunset phases
- 19.3.2 Changelog and release notes
- 19.3.3 Consumer notification strategies
- 19.3.4 Monitoring deprecated endpoint usage

---

### 20. Rate Limiting, Quotas & API Metering

#### 20.1 Rate Limiting Algorithms
- 20.1.1 Fixed window
- 20.1.2 Sliding window log
- 20.1.3 Sliding window counter
- 20.1.4 Token bucket
- 20.1.5 Leaky bucket

#### 20.2 Implementation Patterns
- 20.2.1 Per-user / per-API-key / per-IP limiting
- 20.2.2 Tiered rate limits (free, pro, enterprise)
- 20.2.3 Distributed rate limiting (Redis-based)
- 20.2.4 Rate limit headers (`X-RateLimit-*`, `Retry-After`)
- 20.2.5 Graceful degradation vs hard rejection

#### 20.3 API Metering & Quotas
- 20.3.1 Usage tracking per API key
- 20.3.2 Monthly/daily quotas
- 20.3.3 Metering for billing (pay-per-use)
- 20.3.4 Usage dashboards and alerts
- 20.3.5 Abuse detection and automatic blocking

---

### 21. Webhooks

#### 21.1 Outgoing Webhooks
- 21.1.1 Event-triggered HTTP callbacks
- 21.1.2 Payload design and event types
- 21.1.3 Signature verification (HMAC)
- 21.1.4 Retry logic and exponential backoff
- 21.1.5 Dead letter queues for failed deliveries
- 21.1.6 Webhook logs and debugging

#### 21.2 Incoming Webhooks
- 21.2.1 Receiving webhooks from third parties (Stripe, GitHub, etc.)
- 21.2.2 Signature validation
- 21.2.3 Idempotency handling (duplicate events)
- 21.2.4 Async processing of webhook payloads

#### 21.3 Webhook Management
- 21.3.1 Subscription management (register, update, delete)
- 21.3.2 Event filtering per subscription
- 21.3.3 Webhook testing tools (ngrok, webhook.site)
- 21.3.4 Versioning webhook payloads

---

### 22. Real-time (WebSockets, SSE)

#### 22.1 WebSockets
- 22.1.1 HTTP upgrade handshake
- 22.1.2 Connection lifecycle (open, message, close, error)
- 22.1.3 Rooms and channels (namespaces)
- 22.1.4 Broadcasting and targeted messaging
- 22.1.5 Authentication for WebSocket connections
- 22.1.6 Scaling WebSockets (sticky sessions, Redis pub/sub adapter)

#### 22.2 Server-Sent Events (SSE)
- 22.2.1 Unidirectional server-to-client streaming
- 22.2.2 Event types and event IDs
- 22.2.3 Auto-reconnection and `Last-Event-ID`
- 22.2.4 SSE vs WebSockets — when to use which

#### 22.3 Real-time Libraries & Patterns
- 22.3.1 Socket.IO, SignalR, Phoenix Channels, Action Cable
- 22.3.2 Pub/Sub pattern for real-time
- 22.3.3 Presence tracking (who's online)
- 22.3.4 Optimistic updates and conflict resolution
- 22.3.5 Long polling as fallback

---

> **Navigation:** [← Part 3: Data](toc-2_part_3.md) | [Part 5: Protection (§23–26) →](toc-2_part_5.md)
