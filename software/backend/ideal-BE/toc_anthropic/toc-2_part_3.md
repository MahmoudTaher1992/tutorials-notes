# The Ideal Backend — Complete Study Guide

## Table of Contents — Part 3: Data (§10–16)

---

### 10. Database & ORM

#### 10.1 Database Connectivity
- 10.1.1 Connection strings and configuration
- 10.1.2 Connection pooling (min, max, idle timeout)
- 10.1.3 Multiple database connections
- 10.1.4 Read/write splitting at connection level

#### 10.2 ORM Fundamentals
- 10.2.1 Active Record vs Data Mapper patterns
- 10.2.2 Entity/model definition and decorators
- 10.2.3 Relationships (one-to-one, one-to-many, many-to-many)
- 10.2.4 Eager loading vs lazy loading
- 10.2.5 Query builder vs raw SQL
- 10.2.6 ORM vs micro-ORM vs raw queries — when to use each

#### 10.3 Migrations
- 10.3.1 Schema migrations (up/down)
- 10.3.2 Migration generation and naming conventions
- 10.3.3 Migration history and tracking
- 10.3.4 Zero-downtime migrations (expand-contract pattern)
- 10.3.5 Data migrations vs schema migrations

#### 10.4 Transactions
- 10.4.1 ACID guarantees
- 10.4.2 Transaction scoping (per-request, explicit)
- 10.4.3 Nested transactions and savepoints
- 10.4.4 Distributed transactions and two-phase commit
- 10.4.5 Transaction isolation levels

---

### 11. Database Advanced Patterns

#### 11.1 Query Optimization
- 11.1.1 N+1 query problem and solutions
- 11.1.2 Indexing strategies
- 11.1.3 Query plan analysis (EXPLAIN)
- 11.1.4 Denormalization trade-offs
- 11.1.5 Materialized views

#### 11.2 Scaling Patterns
- 11.2.1 Read replicas
- 11.2.2 Write splitting
- 11.2.3 Horizontal sharding strategies
- 11.2.4 Vertical partitioning
- 11.2.5 Table partitioning (range, list, hash)

#### 11.3 Advanced Data Patterns
- 11.3.1 Soft deletes (paranoid records)
- 11.3.2 Temporal tables and history tracking
- 11.3.3 Polymorphic associations
- 11.3.4 Multi-tenancy at database level (schema-per-tenant, row-level isolation)
- 11.3.5 Database-per-service in microservices
- 11.3.6 Event sourcing storage patterns

---

### 12. Caching

#### 12.1 Caching Layers
- 12.1.1 Application-level in-memory cache
- 12.1.2 Distributed cache (Redis, Memcached)
- 12.1.3 HTTP caching headers (Cache-Control, ETag)
- 12.1.4 CDN caching
- 12.1.5 Database query cache

#### 12.2 Caching Strategies
- 12.2.1 Cache-aside (lazy loading)
- 12.2.2 Write-through cache
- 12.2.3 Write-behind (write-back) cache
- 12.2.4 Read-through cache
- 12.2.5 Refresh-ahead cache

#### 12.3 Cache Invalidation
- 12.3.1 TTL-based expiration
- 12.3.2 Event-driven invalidation
- 12.3.3 Tag-based invalidation
- 12.3.4 Cache stampede prevention (locking, early expiration)
- 12.3.5 Stale-while-revalidate pattern

#### 12.4 Caching Best Practices
- 12.4.1 Cache key design
- 12.4.2 Serialization format for cached data
- 12.4.3 Cache warming strategies
- 12.4.4 Monitoring cache hit rates

---

### 13. Search Integration

#### 13.1 When to Add Search
- 13.1.1 Database LIKE queries vs full-text search
- 13.1.2 When to introduce a search engine
- 13.1.3 Search engine options (Elasticsearch, Meilisearch, Algolia, Typesense)

#### 13.2 Integration Patterns
- 13.2.1 Syncing data to search index (dual-write vs change data capture)
- 13.2.2 Index mapping and schema design
- 13.2.3 Keeping search index in sync (eventual consistency)
- 13.2.4 Search-as-primary vs search-as-secondary

#### 13.3 Search Features in Backend
- 13.3.1 Full-text search API endpoints
- 13.3.2 Autocomplete and suggestions
- 13.3.3 Faceted search and aggregations
- 13.3.4 Fuzzy matching and typo tolerance
- 13.3.5 Search result ranking and boosting

---

### 14. Pagination, Filtering & Sorting

#### 14.1 Pagination Strategies
- 14.1.1 Offset-based pagination (page/limit)
- 14.1.2 Cursor-based pagination (keyset)
- 14.1.3 Seek pagination
- 14.1.4 Deep pagination problems and solutions
- 14.1.5 Total count trade-offs

#### 14.2 Filtering
- 14.2.1 Query parameter-based filters
- 14.2.2 Compound/nested filters
- 14.2.3 Filter operators (eq, gt, lt, in, like, between)
- 14.2.4 Filter validation and injection prevention

#### 14.3 Sorting
- 14.3.1 Single-field and multi-field sorting
- 14.3.2 Default sort order
- 14.3.3 Sort stability and tie-breaking
- 14.3.4 Sorting on computed/related fields

---

### 15. Data Import/Export & Bulk Operations

#### 15.1 Import Operations
- 15.1.1 CSV/Excel file import
- 15.1.2 JSON/XML bulk import
- 15.1.3 Streaming large file imports
- 15.1.4 Validation during import (fail-fast vs collect-errors)
- 15.1.5 Upsert strategies (insert or update)

#### 15.2 Export Operations
- 15.2.1 CSV/Excel generation
- 15.2.2 Streaming large exports
- 15.2.3 Background export jobs with download links
- 15.2.4 Export format negotiation

#### 15.3 Bulk Database Operations
- 15.3.1 Batch insert strategies
- 15.3.2 Bulk update patterns
- 15.3.3 Bulk delete with safeguards
- 15.3.4 Transaction management for bulk operations

---

### 16. Data Seeding & Fixtures

#### 16.1 Database Seeding
- 16.1.1 Seed scripts for development environments
- 16.1.2 Reference/lookup data seeding (countries, currencies)
- 16.1.3 Idempotent seeding (run multiple times safely)
- 16.1.4 Environment-specific seeds (dev vs staging vs prod)

#### 16.2 Test Fixtures & Factories
- 16.2.1 Factory pattern for test data generation
- 16.2.2 Faker libraries for realistic data
- 16.2.3 Fixture files (JSON, YAML)
- 16.2.4 Database state setup and teardown for tests
- 16.2.5 Snapshot-based test databases

---

> **Navigation:** [← Part 2: Core](toc-2_part_2.md) | [Part 4: API (§17–22) →](toc-2_part_4.md)
