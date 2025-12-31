Here is the bash script to generate the PHP study guide structure.

To use this:
1. Copy the code block below.
2. Save it to a file, for example: `setup_php_study.sh`.
3. Give it execution permissions: `chmod +x setup_php_study.sh`.
4. Run it: `./setup_php_study.sh`.

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="PHP-Comprehensive-Study"

# Create the root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating directory structure in $(pwd)..."

# ==========================================
# PART I: PHP Fundamentals & Core Concepts
# ==========================================
PART_DIR="001-PHP-Fundamentals-Core-Concepts"
mkdir -p "$PART_DIR"

# File: 001-Introduction-to-PHP.md
cat << 'EOF' > "$PART_DIR/001-Introduction-to-PHP.md"
# Introduction to PHP

- What is PHP? (Server-side scripting, common use cases)
- Evolution and History (From Personal Home Page to a modern language)
- The Role of PHP in the Modern Web (WordPress, Laravel, APIs, CLI)
- PHP Versions and the Importance of Staying Current (PHP 7.x vs 8.x features)
- The PHP Execution Model (Request -> Web Server -> PHP Interpreter -> Response)
EOF

# File: 002-Setting-Up-Development-Environment.md
cat << 'EOF' > "$PART_DIR/002-Setting-Up-Development-Environment.md"
# Setting Up a Development Environment

- Local Server Stacks (XAMPP, MAMP, WAMP)
- Professional Environments:
  - LAMP/LEMP Stack (manual setup on Linux)
  - Virtualization with Vagrant
  - Containerization with Docker & Docker Compose (modern standard)
  - Managed environments (Laravel Valet, Herd)
- Using the PHP Built-in Web Server
- Configuring `php.ini` (error reporting, memory limits, etc.)
EOF

# ==========================================
# PART II: Core Language Constructs & Structures
# ==========================================
PART_DIR="002-Core-Language-Constructs-Structures"
mkdir -p "$PART_DIR"

# File: 001-Basic-Syntax-and-Variables.md
cat << 'EOF' > "$PART_DIR/001-Basic-Syntax-and-Variables.md"
# Basic Syntax and Variables

- PHP Tags (`<?php ... ?>`) and embedding in HTML
- Comments, Statements, and Expressions
- Variables: Declaration, Scope (global, local, static), and Superglobals
- Constants (using `define()` and `const`)
- Magic Constants (`__FILE__`, `__DIR__`, `__FUNCTION__`)
EOF

# File: 002-Data-Types-Type-Juggling.md
cat << 'EOF' > "$PART_DIR/002-Data-Types-Type-Juggling.md"
# Data Types & Type Juggling

- Scalar Types: `string`, `int`, `float`, `bool`
- Compound Types: `array`, `object`
- Special Types: `null`, `resource`
- Modern Types: Enums (PHP 8.1+)
- Type Juggling and Casting (implicit vs. explicit conversion)
- Output and Debugging (`echo`, `print`, `var_dump()`, `print_r()`)
EOF

# File: 003-Control-Structures-Operators.md
cat << 'EOF' > "$PART_DIR/003-Control-Structures-Operators.md"
# Control Structures & Operators

- Conditional Logic: `if/else/elseif`, `switch`, Ternary Operator
- The `match` Expression (PHP 8.0+)
- Loops: `for`, `foreach`, `while`, `do-while`
- Operators: Arithmetic, Assignment, Comparison, Logical, Bitwise
- Modern Operators: Null Coalescing (`??`), Nullsafe (`?->`)
EOF

# File: 004-Functions.md
cat << 'EOF' > "$PART_DIR/004-Functions.md"
# Functions

- Declaring and Calling Functions
- Parameters: Positional, Default Values, Type Hinting (Scalar, Array, Object)
- Return Types and `void`
- Modern Function Features:
  - Named Arguments (PHP 8.0+)
  - Anonymous Functions (Closures) and `use`
  - Arrow Functions (PHP 7.4+)
  - Variadic Functions and the Spread Operator (`...`)
- Callback Functions and Callable Types
EOF

# File: 005-Advanced-Data-Structures.md
cat << 'EOF' > "$PART_DIR/005-Advanced-Data-Structures.md"
# Advanced Data Structures

- Arrays Deep Dive:
  - Indexed vs. Associative Arrays
  - Multi-dimensional Arrays
  - Essential Array Functions (`array_map`, `array_filter`, `array_reduce`, sorting functions)
- Working with JSON (`json_encode`, `json_decode`)
- Working with Files (`fopen`, `fread`, `fwrite`, `file_get_contents`)
EOF

# ==========================================
# PART III: HTTP & State Management
# ==========================================
PART_DIR="003-HTTP-State-Management"
mkdir -p "$PART_DIR"

# File: 001-Handling-HTTP-Requests.md
cat << 'EOF' > "$PART_DIR/001-Handling-HTTP-Requests.md"
# Handling HTTP Requests

- Understanding HTTP Methods (GET, POST, PUT, DELETE)
- Accessing Request Data: `$_GET`, `$_POST`, `$_REQUEST`
- The `$_SERVER` Superglobal (headers, server info)
- Processing Form Submissions and File Uploads (`$_FILES`)
EOF

# File: 002-State-Management.md
cat << 'EOF' > "$PART_DIR/002-State-Management.md"
# State Management

- Cookies: Setting, Reading, Deleting (`setcookie`)
- Sessions: How they work, Starting and Destroying (`session_start`)
- Session Security (session fixation, hijacking)
- Comparison: Cookies vs. Sessions
EOF

# File: 003-Sending-HTTP-Responses.md
cat << 'EOF' > "$PART_DIR/003-Sending-HTTP-Responses.md"
# Sending HTTP Responses

- Setting Headers (`header()` function) for redirects, caching, content type
- HTTP Status Codes
- Outputting JSON for APIs
EOF

# ==========================================
# PART IV: Object-Oriented Programming (OOP) in PHP
# ==========================================
PART_DIR="004-OOP-in-PHP"
mkdir -p "$PART_DIR"

# File: 001-OOP-Fundamentals.md
cat << 'EOF' > "$PART_DIR/001-OOP-Fundamentals.md"
# OOP Fundamentals

- Classes and Objects (`new` keyword)
- Properties and Methods
- Constructor and Destructor (`__construct`, `__destruct`)
- The `$this` Keyword
EOF

# File: 002-Core-OOP-Pillars.md
cat << 'EOF' > "$PART_DIR/002-Core-OOP-Pillars.md"
# Core OOP Pillars

- Encapsulation: Access Modifiers (`public`, `protected`, `private`)
- Inheritance: `extends`, `parent::`
- Polymorphism & Method Overriding
- `final` Classes and Methods
EOF

# File: 003-Advanced-OOP-Concepts.md
cat << 'EOF' > "$PART_DIR/003-Advanced-OOP-Concepts.md"
# Advanced OOP Concepts

- Abstract Classes and Methods
- Interfaces and `implements`
- Traits for Code Reuse
- Static Methods and Properties (`self::`, `static::`)
- Namespaces and Autoloading (the "why" behind PSR-4)
- Magic Methods (`__get`, `__set`, `__call`, `__toString`)
EOF

# File: 004-Modern-OOP-Patterns-Principles.md
cat << 'EOF' > "$PART_DIR/004-Modern-OOP-Patterns-Principles.md"
# Modern OOP Patterns & Principles

- Dependency Injection and Inversion of Control (IoC)
- Service Containers
- The Factory and Singleton Design Patterns
- Modern Type System Features:
  - Union Types (PHP 8.0+)
  - Intersection Types (PHP 8.1+)
  - `readonly` properties (PHP 8.1+)
EOF

# ==========================================
# PART V: Working with Databases
# ==========================================
PART_DIR="005-Working-with-Databases"
mkdir -p "$PART_DIR"

# File: 001-Database-Connectivity-Operations.md
cat << 'EOF' > "$PART_DIR/001-Database-Connectivity-Operations.md"
# Database Connectivity & Operations

- PDO vs. `mysqli`: Pros and Cons (Why PDO is preferred)
- Establishing a Connection
- Performing CRUD Operations (Create, Read, Update, Delete)
- The Importance of Prepared Statements to prevent SQL Injection
EOF

# File: 002-Advanced-Database-Techniques.md
cat << 'EOF' > "$PART_DIR/002-Advanced-Database-Techniques.md"
# Advanced Database Techniques

- Fetching Data: Different fetch modes (associative array, object)
- Database Transactions (ACID properties, `beginTransaction`, `commit`, `rollback`)
- Error Handling with PDO Exceptions
EOF

# File: 003-Database-Abstraction.md
cat << 'EOF' > "$PART_DIR/003-Database-Abstraction.md"
# Database Abstraction

- Introduction to Object-Relational Mapping (ORM)
- Examples: Eloquent (Laravel), Doctrine (Symfony)
- Database Migrations for Schema Version Control
EOF

# ==========================================
# PART VI: The PHP Ecosystem: Tooling, Quality & Standards
# ==========================================
PART_DIR="006-Ecosystem-Tooling-Quality"
mkdir -p "$PART_DIR"

# File: 001-Dependency-Management.md
cat << 'EOF' > "$PART_DIR/001-Dependency-Management.md"
# Dependency Management

- **Composer**: The de-facto package manager
- `composer.json` vs. `composer.lock`
- Installing, updating, and removing packages
- Autoloading with PSR-4
EOF

# File: 002-Code-Quality-Static-Analysis.md
cat << 'EOF' > "$PART_DIR/002-Code-Quality-Static-Analysis.md"
# Code Quality & Static Analysis

- **PHPStan**, **Psalm**: Finding bugs before you run your code
- Configuration Levels and Baselines
EOF

# File: 003-Coding-Style-Linting.md
cat << 'EOF' > "$PART_DIR/003-Coding-Style-Linting.md"
# Coding Style & Linting

- **PHP_CodeSniffer** (phpcs), **PHP-CS-Fixer**: Enforcing a consistent code style
- Automating with pre-commit hooks (Husky, lint-staged)
EOF

# File: 004-Debugging-Tools.md
cat << 'EOF' > "$PART_DIR/004-Debugging-Tools.md"
# Debugging Tools

- **Xdebug**: Step-debugging, profiling, and code coverage
- Integration with IDEs (VS Code, PhpStorm)
EOF

# File: 005-PHP-FIG-PSR-Standards.md
cat << 'EOF' > "$PART_DIR/005-PHP-FIG-PSR-Standards.md"
# PHP-FIG & PSR Standards

- The Role of the PHP Framework Interop Group
- Key Standards:
  - PSR-4: Autoloader
  - PSR-12: Extended Coding Style Guide
  - PSR-7: HTTP Message Interface
  - PSR-11: Container Interface
EOF

# ==========================================
# PART VII: Modern PHP Frameworks & Application Architecture
# ==========================================
PART_DIR="007-Modern-Frameworks-Architecture"
mkdir -p "$PART_DIR"

# File: 001-Why-Use-a-Framework.md
cat << 'EOF' > "$PART_DIR/001-Why-Use-a-Framework.md"
# Why Use a Framework?

- The "Don't Reinvent the Wheel" Principle
- Structure, Security, and Scalability
EOF

# File: 002-Popular-Frameworks.md
cat << 'EOF' > "$PART_DIR/002-Popular-Frameworks.md"
# Popular Frameworks

- **Laravel**: Philosophy, Ecosystem (Eloquent, Blade, Vite)
- **Symfony**: Components-based architecture, Flexibility
- Comparison and Use-Cases
EOF

# File: 003-Core-Architectural-Concepts.md
cat << 'EOF' > "$PART_DIR/003-Core-Architectural-Concepts.md"
# Core Architectural Concepts

- MVC (Model-View-Controller) and ADR (Action-Domain-Responder) Patterns
- Routing: Mapping URLs to code
- Middleware: Intercepting and processing HTTP requests
- Templating Engines: Twig (Symfony) vs. Blade (Laravel)
EOF

# ==========================================
# PART VIII: Testing in PHP
# ==========================================
PART_DIR="008-Testing-in-PHP"
mkdir -p "$PART_DIR"

# File: 001-Types-of-Testing.md
cat << 'EOF' > "$PART_DIR/001-Types-of-Testing.md"
# Types of Testing

- Unit Testing: Isolating and testing individual classes/functions
- Integration Testing: Testing how components work together
- Functional / End-to-End Testing: Simulating user behavior (e.g., with Laravel Dusk, Panther)
EOF

# File: 002-Testing-Tools-Concepts.md
cat << 'EOF' > "$PART_DIR/002-Testing-Tools-Concepts.md"
# Testing Tools & Concepts

- **PHPUnit**: The standard for unit testing
- **Pest**: A modern, expressive testing framework built on PHPUnit
- Assertions, Test Doubles (Mocks, Stubs)
- Data Providers for testing with multiple datasets
- Test-Driven Development (TDD) workflow
EOF

# ==========================================
# PART IX: Security Best Practices
# ==========================================
PART_DIR="009-Security-Best-Practices"
mkdir -p "$PART_DIR"

# File: 001-Common-Web-Vulnerabilities.md
cat << 'EOF' > "$PART_DIR/001-Common-Web-Vulnerabilities.md"
# Common Web Vulnerabilities

- Cross-Site Scripting (XSS)
- Cross-Site Request Forgery (CSRF)
- SQL Injection (revisited in context)
- File Inclusion Vulnerabilities
EOF

# File: 002-Defensive-Programming.md
cat << 'EOF' > "$PART_DIR/002-Defensive-Programming.md"
# Defensive Programming

- Input Validation: Filtering and sanitizing user data
- Output Escaping/Encoding (`htmlspecialchars`)
- CSRF Token Implementation
- Content Security Policy (CSP)
EOF

# File: 003-Authentication-Authorization.md
cat << 'EOF' > "$PART_DIR/003-Authentication-Authorization.md"
# Authentication & Authorization

- Secure Password Hashing (`password_hash`, `password_verify`)
- Implementing Login/Logout Systems
- Role-Based Access Control (RBAC)
EOF

# ==========================================
# PART X: Performance & Optimization
# ==========================================
PART_DIR="010-Performance-Optimization"
mkdir -p "$PART_DIR"

# File: 001-Caching-Strategies.md
cat << 'EOF' > "$PART_DIR/001-Caching-Strategies.md"
# Caching Strategies

- Opcode Caching (**OPcache**)
- Application-level Caching (data, objects, configuration)
- Caching Backends: Redis, Memcached
- HTTP Caching Headers
EOF

# File: 002-Profiling-Performance-Tuning.md
cat << 'EOF' > "$PART_DIR/002-Profiling-Performance-Tuning.md"
# Profiling & Performance Tuning

- Using Blackfire.io or Xdebug's profiler
- Identifying bottlenecks in code and database queries (`EXPLAIN`)
- Writing Memory-Efficient Code (Generators, `unset`)
EOF

# ==========================================
# PART XI: Advanced & Asynchronous PHP
# ==========================================
PART_DIR="011-Advanced-Asynchronous-PHP"
mkdir -p "$PART_DIR"

# File: 001-Interacting-with-the-System.md
cat << 'EOF' > "$PART_DIR/001-Interacting-with-the-System.md"
# Interacting with the System

- Command-Line Interface (CLI) Scripting
- Executing System Commands (`exec`, `shell_exec`)
- Working with Environment Variables (`.env` files, `getenv`)
EOF

# File: 002-Asynchronous-PHP.md
cat << 'EOF' > "$PART_DIR/002-Asynchronous-PHP.md"
# Asynchronous PHP

- The Event Loop Concept
- Use-cases: High-concurrency, WebSockets, long-running tasks
- Frameworks and Runtimes: **Swoole**, **RoadRunner**, **ReactPHP**
EOF

# File: 003-Building-and-Consuming-APIs.md
cat << 'EOF' > "$PART_DIR/003-Building-and-Consuming-APIs.md"
# Building and Consuming APIs

- Designing RESTful APIs
- API Authentication (API Keys, OAuth2)
- Using HTTP clients like **Guzzle** to consume external APIs
- API Documentation with OpenAPI/Swagger
EOF

# ==========================================
# PART XII: Web Servers, Deployment & DevOps
# ==========================================
PART_DIR="012-Web-Servers-Deployment-DevOps"
mkdir -p "$PART_DIR"

# File: 001-Web-Server-Configuration.md
cat << 'EOF' > "$PART_DIR/001-Web-Server-Configuration.md"
# Web Server Configuration

- Apache (`.htaccess`) vs. Nginx (server blocks)
- Understanding **PHP-FPM** (FastCGI Process Manager) and its role
EOF

# File: 002-Modern-Deployment.md
cat << 'EOF' > "$PART_DIR/002-Modern-Deployment.md"
# Modern Deployment

- Containerization with **Docker** for consistent environments
- Orchestration with Docker Compose
- CI/CD Pipelines (GitHub Actions, GitLab CI)
- Zero-Downtime Deployment Strategies
EOF

echo "Done! Directory structure created in $ROOT_DIR."
```
