Here is the bash script to generate your Spring Boot study structure.

You can save this code into a file (e.g., `setup-spring-boot-study.sh`), give it execution permissions (`chmod +x setup-spring-boot-study.sh`), and run it.

```bash
#!/bin/bash

# Define Root Directory
ROOT_DIR="Spring-Boot-Study"

echo "Creating directory structure for: $ROOT_DIR"
mkdir -p "$ROOT_DIR"

# ==========================================
# Part I: Introduction & Core Concepts
# ==========================================
PART_DIR="$ROOT_DIR/001-Introduction-And-Core-Concepts"
mkdir -p "$PART_DIR"

# A. What is Spring Boot?
cat <<EOF > "$PART_DIR/001-What-is-Spring-Boot.md"
# What is Spring Boot?

* Evolution From Spring Framework
* Motivation: Simplifying Spring Applications
* Convention over Configuration
EOF

# B. Spring Boot vs. Spring Framework
cat <<EOF > "$PART_DIR/002-Spring-Boot-vs-Spring-Framework.md"
# Spring Boot vs. Spring Framework

* Boilerplate Reduction
* Embedded Servers
* Auto-configuration and Starters
* Opinionated Defaults
EOF

# C. Application Structure & Lifecycle
cat <<EOF > "$PART_DIR/003-Application-Structure-Lifecycle.md"
# Application Structure & Lifecycle

* Project Directory Structure
* Spring Boot Main Class and \`@SpringBootApplication\`
* Lifecycle of a Spring Boot App
* Dependency Management with [Maven/Gradle]
EOF

# D. Module Overview
cat <<EOF > "$PART_DIR/004-Module-Overview.md"
# Module Overview

* Spring Data, Web, Security, Actuator, etc.
EOF

# ==========================================
# Part II: Configuration & Dependency Injection
# ==========================================
PART_DIR="$ROOT_DIR/002-Configuration-And-Dependency-Injection"
mkdir -p "$PART_DIR"

# A. Dependency Injection (DI) and Inversion of Control (IoC)
cat <<EOF > "$PART_DIR/001-Dependency-Injection-IoC.md"
# Dependency Injection (DI) and Inversion of Control (IoC)

* Beans and Context
* Types: Constructor vs. Field vs. Setter Injection
* Profiles and Qualifiers
EOF

# B. Configuration Approaches
cat <<EOF > "$PART_DIR/002-Configuration-Approaches.md"
# Configuration Approaches

* Application Properties & YAML Files (\`application.properties\` vs. \`application.yml\`)
* Externalizing Configuration (Environment Variables, Command-line Args, Config Server)
* Type-safe Configuration (ConfigurationProperties)
* Profiles for Environment-Specific Config
EOF

# C. Bean Scopes and Component Scanning
cat <<EOF > "$PART_DIR/003-Bean-Scopes-Component-Scanning.md"
# Bean Scopes and Component Scanning

* Singleton, Prototype, Request, Session Scopes
* \`@Component\`, \`@Service\`, \`@Repository\`, \`@Controller\`
* Customizing Component Scanning
EOF

# ==========================================
# Part III: Building Web/REST APIs
# ==========================================
PART_DIR="$ROOT_DIR/003-Building-Web-REST-APIs"
mkdir -p "$PART_DIR"

# A. Spring MVC Fundamentals
cat <<EOF > "$PART_DIR/001-Spring-MVC-Fundamentals.md"
# Spring MVC Fundamentals

* Dispatcher Servlet, Handler Mapping, Interceptors
* REST Controller vs. MVC Controller (\`@RestController\` vs. \`@Controller\`)
EOF

# B. Defining Endpoints
cat <<EOF > "$PART_DIR/002-Defining-Endpoints.md"
# Defining Endpoints

* Mapping Paths (\`@GetMapping\`, \`@PostMapping\`, etc.)
* Path Variables, Request Params, and Request Bodies
* Request Validation (\`@Valid\`)
EOF

# C. Response Handling
cat <<EOF > "$PART_DIR/003-Response-Handling.md"
# Response Handling

* ResponseEntity and HTTP Status Codes
* Exception Handling (\`@ControllerAdvice\`, \`@ExceptionHandler\`)
* Response Serialization (Jackson for JSON)
EOF

# D. Content Negotiation
cat <<EOF > "$PART_DIR/004-Content-Negotiation.md"
# Content Negotiation

* Produces and Consumes
* Customizing Message Converters
EOF

# E. API Documentation
cat <<EOF > "$PART_DIR/005-API-Documentation.md"
# API Documentation

* Swagger / OpenAPI Integration (Springdoc, Swagger-UI)
* API Versioning Techniques
EOF

# ==========================================
# Part IV: Data Persistence
# ==========================================
PART_DIR="$ROOT_DIR/004-Data-Persistence"
mkdir -p "$PART_DIR"

# A. Spring Data Overview
cat <<EOF > "$PART_DIR/001-Spring-Data-Overview.md"
# Spring Data Overview

* JPA (Hibernate), JDBC, MongoDB, Redis
* CRUD Repository, JpaRepository, PagingAndSortingRepository
EOF

# B. Configuring Data Sources
cat <<EOF > "$PART_DIR/002-Configuring-Data-Sources.md"
# Configuring Data Sources

* Datasource Properties
* In-memory Databases (H2, HSQLDB, Derby)
* Profile-based DB Config
EOF

# C. Entity Relationships & Lifecycle
cat <<EOF > "$PART_DIR/003-Entity-Relationships-Lifecycle.md"
# Entity Relationships & Lifecycle

* Entity Mapping (\`@Entity\`, \`@Table\`)
* Relationships (\`@OneToMany\`, \`@ManyToOne\`, \`@ManyToMany\`)
* Entity Lifecycle Callbacks
* Lazy vs. Eager Loading
EOF

# D. Query Methods
cat <<EOF > "$PART_DIR/004-Query-Methods.md"
# Query Methods

* Derived Query Methods
* JPQL and Native Queries (\`@Query\`)
* Projections and DTO Mapping
EOF

# E. Transactions
cat <<EOF > "$PART_DIR/005-Transactions.md"
# Transactions

* Transaction Management with \`@Transactional\`
* Propagation & Isolation Levels, Rollback Scenarios
EOF

# ==========================================
# Part V: Security
# ==========================================
PART_DIR="$ROOT_DIR/005-Security"
mkdir -p "$PART_DIR"

# A. Spring Security Basics
cat <<EOF > "$PART_DIR/001-Spring-Security-Basics.md"
# Spring Security Basics

* Security Filters & Chain Concept
* Authentication vs. Authorization
* UserDetailsService, AuthenticationManager
EOF

# B. Authentication Mechanisms
cat <<EOF > "$PART_DIR/002-Authentication-Mechanisms.md"
# Authentication Mechanisms

* In-memory, JDBC-based, LDAP Authentication
* JWT (JSON Web Tokens): Custom Filters, Stateless Auth
* OAuth2 & OpenID Connect (Client & Resource Server)
EOF

# C. Authorization Strategies
cat <<EOF > "$PART_DIR/003-Authorization-Strategies.md"
# Authorization Strategies

* Role-based Access (RBAC) with \`@PreAuthorize\`, \`@Secured\`
* Method and URL Level Security
EOF

# D. Other Security Concerns
cat <<EOF > "$PART_DIR/004-Other-Security-Concerns.md"
# Other Security Concerns

* CSRF Protection and CORS
* Password Encoding & Hashing
* Custom Login/Logout Pages (Form-based, Basic, etc.)
EOF

# ==========================================
# Part VI: Microservices & Cloud-Native Development
# ==========================================
PART_DIR="$ROOT_DIR/006-Microservices-Cloud-Native"
mkdir -p "$PART_DIR"

# A. Introduction to Microservices with Spring Boot
cat <<EOF > "$PART_DIR/001-Introduction-To-Microservices.md"
# Introduction to Microservices with Spring Boot

* Principles and Patterns
* Inter-Service Communication (REST, Feign, gRPC)
EOF

# B. Service Discovery & Registration
cat <<EOF > "$PART_DIR/002-Service-Discovery-Registration.md"
# Service Discovery & Registration

* Spring Cloud Netflix Eureka
* Consul, Zookeeper
EOF

# C. Distributed Configuration
cat <<EOF > "$PART_DIR/003-Distributed-Configuration.md"
# Distributed Configuration

* Spring Cloud Config Server and Client
* Centralized Secrets Management
EOF

# D. API Gateway and Edge Services
cat <<EOF > "$PART_DIR/004-API-Gateway-Edge-Services.md"
# API Gateway and Edge Services

* Spring Cloud Gateway, Zuul Proxy
* Rate Limiting and Request Filtering
EOF

# E. Resilience Patterns
cat <<EOF > "$PART_DIR/005-Resilience-Patterns.md"
# Resilience Patterns

* Circuit Breaker (Resilience4J/Hystrix)
* Retry and Bulkhead Patterns
EOF

# F. Distributed Tracing & Observability
cat <<EOF > "$PART_DIR/006-Distributed-Tracing-Observability.md"
# Distributed Tracing & Observability

* Sleuth, Zipkin, Micrometer
* Centralized Logging
EOF

# ==========================================
# Part VII: Monitoring, Management & Production Concerns
# ==========================================
PART_DIR="$ROOT_DIR/007-Monitoring-Management"
mkdir -p "$PART_DIR"

# A. Spring Boot Actuator
cat <<EOF > "$PART_DIR/001-Spring-Boot-Actuator.md"
# Spring Boot Actuator

* Built-in Endpoints: health, metrics, env, info, mappings
* Custom Actuator Endpoints
* Health Checks (Liveness/Readiness)
* Security for Actuator Endpoints
EOF

# B. Metrics & Monitoring
cat <<EOF > "$PART_DIR/002-Metrics-And-Monitoring.md"
# Metrics & Monitoring

* Micrometer Integration (Prometheus, Grafana)
* Application/Business Metrics, Custom Metrics
EOF

# C. Logging
cat <<EOF > "$PART_DIR/003-Logging.md"
# Logging

* SLF4J, Logback, Log4j2 Integration
* Log Formatting, Profiles, External Systems (ELK)
EOF

# ==========================================
# Part VIII: Testing
# ==========================================
PART_DIR="$ROOT_DIR/008-Testing"
mkdir -p "$PART_DIR"

# A. Unit & Integration Testing
cat <<EOF > "$PART_DIR/001-Unit-Integration-Testing.md"
# Unit & Integration Testing

* Testing Annotations: \`@SpringBootTest\`, \`@WebMvcTest\`, \`@DataJpaTest\`, etc.
* Mocking Dependencies (\`@MockBean\`, Mockito)
* Testing Controllers, Repositories, Services
* TestContainers for Integration Testing with DBs
EOF

# B. Testing APIs
cat <<EOF > "$PART_DIR/002-Testing-APIs.md"
# Testing APIs

* MockMvc and WebTestClient
* Testing Authentication/Security
* Generating API Documentation from Tests (Spring REST Docs)
EOF

# C. End-to-End/Acceptance Testing
cat <<EOF > "$PART_DIR/003-E2E-Acceptance-Testing.md"
# End-to-End/Acceptance Testing

* Selenium, RestAssured
* Contract Testing (Pact)
EOF

# D. Test Data Management
cat <<EOF > "$PART_DIR/004-Test-Data-Management.md"
# Test Data Management

* Flyway/Liquibase for Test Seeds
* @Sql scripts for Integration
EOF

# ==========================================
# Part IX: Deployment & Operations
# ==========================================
PART_DIR="$ROOT_DIR/009-Deployment-And-Operations"
mkdir -p "$PART_DIR"

# A. Building & Packaging
cat <<EOF > "$PART_DIR/001-Building-And-Packaging.md"
# Building & Packaging

* Spring Boot Maven & Gradle Plugins
* Creating Executable JARs/WARs
* Dockerizing Spring Boot Applications
EOF

# B. Cloud Deployment
cat <<EOF > "$PART_DIR/002-Cloud-Deployment.md"
# Cloud Deployment

* Deploying to AWS (Elastic Beanstalk, ECS, Lambda), Azure, GCP
* Kubernetes Deployment (Spring Cloud Kubernetes, Helm, ConfigMaps)
* 12-Factor Principles in Spring Boot
EOF

# C. Continuous Integration/Continuous Deployment
cat <<EOF > "$PART_DIR/003-CI-CD.md"
# Continuous Integration/Continuous Deployment

* Automated Testing and Build Pipelines (Jenkins, GitHub Actions, GitLab CI)
* Managing Environment Variables and Secrets
EOF

# ==========================================
# Part X: Advanced Topics & Best Practices
# ==========================================
PART_DIR="$ROOT_DIR/010-Advanced-Topics-Best-Practices"
mkdir -p "$PART_DIR"

# A. Asynchronous and Event-driven Architectures
cat <<EOF > "$PART_DIR/001-Async-And-Event-Driven.md"
# Asynchronous and Event-driven Architectures

* Asynchronous Methods with \`@Async\`
* Spring Events
* Messaging with RabbitMQ (Spring AMQP), Kafka (Spring Kafka)
EOF

# B. Reactive Programming
cat <<EOF > "$PART_DIR/002-Reactive-Programming.md"
# Reactive Programming

* WebFlux (Reactive REST / Functional Endpoints)
* Project Reactor: Mono & Flux
* R2DBC for Reactive Data Access
EOF

# C. Performance Optimization
cat <<EOF > "$PART_DIR/003-Performance-Optimization.md"
# Performance Optimization

* Connection Pooling (HikariCP)
* Caching (Spring Cache Abstraction, Redis)
* Profiling and Benchmarking
EOF

# D. Internationalization (i18n) & Localization (l10n)
cat <<EOF > "$PART_DIR/004-Internationalization-Localization.md"
# Internationalization (i18n) & Localization (l10n)

* Message Sources
* Resource Bundles
EOF

# E. API Versioning and Evolution Patterns
cat <<EOF > "$PART_DIR/005-API-Versioning.md"
# API Versioning and Evolution Patterns
EOF

# F. Application Modularization
cat <<EOF > "$PART_DIR/006-Application-Modularization.md"
# Application Modularization

* Multi-module Maven/Gradle
EOF

# G. Code Quality and Best Practices
cat <<EOF > "$PART_DIR/007-Code-Quality-Best-Practices.md"
# Code Quality and Best Practices

* Linting, Static Analysis (Checkstyle, PMD, SonarQube)
* Layered Architecture, Package Structure (Domain-Driven Design)
EOF

# ==========================================
# Part XI: Resources & Ecosystem
# ==========================================
PART_DIR="$ROOT_DIR/011-Resources-And-Ecosystem"
mkdir -p "$PART_DIR"

# A. Spring Boot Official Documentation
cat <<EOF > "$PART_DIR/001-Official-Documentation.md"
# Spring Boot Official Documentation
EOF

# B. Community Guides and Tutorials
cat <<EOF > "$PART_DIR/002-Community-Guides.md"
# Community Guides and Tutorials
EOF

# C. Notable Open Source Projects
cat <<EOF > "$PART_DIR/003-Open-Source-Projects.md"
# Notable Open Source Projects and Example Applications
EOF

# D. Reference Books
cat <<EOF > "$PART_DIR/004-Reference-Books.md"
# Reference Books and Further Learning Tracks
EOF

echo "Done! Hierarchy created in '$ROOT_DIR'"
```
