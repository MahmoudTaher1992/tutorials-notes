# SQL: Comprehensive Study Table of Contents

## Part I: Relational Database Fundamentals & Core Concepts

### A. Introduction to Databases & SQL
- The Role of a Database in Modern Applications
- Relational vs. Non-Relational (NoSQL) Databases: Core Differences
- The Philosophy of Relational Data (Structured, ACID-compliant)
- What is SQL? (A Declarative Language for Data)
- SQL Sub-languages: DDL, DML, DQL, DCL, TCL

### B. Setting Up a Database Environment
- Choosing an RDBMS: PostgreSQL, MySQL, SQL Server, SQLite
- Installation and Configuration (Local Setup with Docker vs. Native Install)
- Connecting with a GUI Client (DBeaver, pgAdmin, DataGrip)
- Your First Database and Table: The `CREATE DATABASE` and `CREATE TABLE` Statements
- Understanding Schemas and Data Organization

## Part II: Data Query Language (DQL) - The Art of Asking Questions

### A. Basic Data Retrieval
- The `SELECT` Statement: Retrieving Columns
- The `FROM` Clause: Specifying the Source Table
- Filtering Data with the `WHERE` Clause
- Comparison Operators (`=`, `!=`, `>`, `<`, etc.)
- Logical Operators (`AND`, `OR`, `NOT`)
- `BETWEEN`, `IN`, `LIKE`, `IS NULL` for Complex Filtering
- Sorting Results with `ORDER BY` (`ASC`, `DESC`)
- Limiting Results with `LIMIT` (and `OFFSET` for pagination)
- Using `AS` for Column and Table Aliases

### B. Aggregation and Grouping
- Aggregate Functions: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- Grouping Data with `GROUP BY`
- Filtering Groups with `HAVING`
- The Difference Between `WHERE` and `HAVING`
- Aggregating on Distinct Values (`COUNT(DISTINCT column)`)

### C. Combining Data from Multiple Tables (JOINs)
- Relational Theory: Keys and Relationships
- **INNER JOIN**: Finding the Matching Rows
- **LEFT JOIN** (or LEFT OUTER JOIN): Keeping All Rows from the Left Table
- **RIGHT JOIN** (or RIGHT OUTER JOIN): Keeping All Rows from the Right Table
- **FULL OUTER JOIN**: Keeping All Rows from Both Tables
- **CROSS JOIN**: The Cartesian Product
- **Self Join**: Joining a Table to Itself
- Multi-Table Joins and Complex `ON` Conditions

## Part III: Data Definition & Manipulation (DDL & DML)

### A. Data Manipulation Language (DML)
- Adding New Data with `INSERT INTO` (single row, multiple rows)
- Modifying Existing Data with `UPDATE`
- Removing Data with `DELETE`
- `DELETE` vs. `TRUNCATE TABLE`: Differences in Performance and Logging

### B. Data Definition Language (DDL)
- Creating Tables (`CREATE TABLE`)
- Defining Data Types (Numeric, String, Date/Time, Boolean, JSON/JSONB, UUID)
- Modifying Table Structure with `ALTER TABLE` (ADD, DROP, RENAME COLUMN; ADD, DROP CONSTRAINT)
- Deleting Tables with `DROP TABLE`

### C. Data Integrity and Constraints
- **Primary Key**: Ensuring Unique Row Identification
- **Foreign Key**: Enforcing Relational Integrity
- **Unique**: Ensuring Unique Values in a Column
- **NOT NULL**: Preventing Null Values
- **CHECK**: Enforcing Custom Business Rules
- **DEFAULT**: Setting a Default Value for a Column

## Part IV: Advanced Querying Techniques

### A. Subqueries (Nested Queries)
- Scalar, Column, Row, and Table Subqueries
- Subqueries in `SELECT`, `FROM`, and `WHERE` Clauses
- Correlated vs. Non-Correlated Subqueries
- The `EXISTS` and `NOT EXISTS` Operators

### B. Common Table Expressions (CTEs)
- The `WITH` Clause: Improving Readability and Modularity
- Chaining Multiple CTEs
- Recursive CTEs for Hierarchical Data (e.g., org charts, nested comments)

### C. Window Functions
- The `OVER()` Clause: Partitioning and Ordering
- Ranking Functions: `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `NTILE()`
- Offset Functions: `LEAD()`, `LAG()`
- Aggregate Window Functions (`SUM() OVER (...)`, `AVG() OVER (...)`)

### D. Set Operations
- `UNION` vs. `UNION ALL`: Combining Result Sets
- `INTERSECT`: Finding Common Rows
- `EXCEPT` (or `MINUS`): Finding Different Rows

## Part V: Schema Design & Database Architecture

### A. Database Normalization
- First Normal Form (1NF): Atomicity
- Second Normal Form (2NF): Eliminating Partial Dependencies
- Third Normal Form (3NF): Eliminating Transitive Dependencies
- Boyce-Codd Normal Form (BCNF)
- Denormalization: When and Why to Break the Rules for Performance

### B. Logical and Physical Design
- Entity-Relationship Diagrams (ERDs)
- Choosing Primary Keys (Natural vs. Surrogate Keys)
- Data Modeling Best Practices

### C. Indexes
- Why Indexes are Critical for Performance
- How Indexes Work (B-Tree, Hash)
- Creating and Dropping Indexes
- Indexing Strategies: Clustered vs. Non-Clustered, Covering Indexes, Partial Indexes
- The Trade-off: Faster Reads vs. Slower Writes

### D. Views
- Creating Views for Simplicity and Security
- Updatable vs. Read-Only Views
- Materialized Views for Caching Expensive Queries

## Part VI: Transactions & Concurrency Control

### A. Transaction Management (TCL)
- The `BEGIN`, `COMMIT`, and `ROLLBACK` Statements
- Using `SAVEPOINT` for Partial Rollbacks
- The ACID Properties (Atomicity, Consistency, Isolation, Durability)

### B. Concurrency Issues
- Understanding Lost Updates, Dirty Reads, Non-Repeatable Reads, Phantom Reads
- Database Locking Mechanisms (Pessimistic vs. Optimistic)

### C. Transaction Isolation Levels
- READ UNCOMMITTED
- READ COMMITTED
- REPEATABLE READ
- SERIALIZABLE

## Part VII: Programmability & Advanced Features

### A. Stored Procedures & Functions
- Creating and Executing Stored Procedures
- Variables, Control Flow (`IF`, `CASE`), and Loops
- Functions (Scalar vs. Table-Valued)
- Stored Procedures vs. Functions: Key Differences

### B. Triggers
- `BEFORE` vs. `AFTER` Triggers (`INSERT`, `UPDATE`, `DELETE`)
- Use Cases and Common Pitfalls (e.g., cascading triggers)

### C. Working with Complex Data Types
- Querying JSON/JSONB Data
- Using Array Types
- Geospatial Data (PostGIS in PostgreSQL)

## Part VIII: Performance Tuning & Optimization

### A. Query Analysis
- Execution Plans: Using `EXPLAIN` and `EXPLAIN ANALYZE`
- Reading an Execution Plan: Scans (Sequential vs. Index), Joins (Hash, Nested Loop, Merge)
- Identifying Bottlenecks

### B. Query Optimization Techniques
- The SARGable Principle (avoiding functions in `WHERE` clauses)
- Selective Projection (`SELECT *` is an anti-pattern)
- Optimizing Joins and Subqueries
- Database-specific tools (`pg_stat_statements`, performance schemas)

## Part IX: Security & Administration

### A. Data Control Language (DCL)
- User and Role Management (`CREATE USER`, `CREATE ROLE`)
- Granting Permissions with `GRANT`
- Revoking Permissions with `REVOKE`
- Row-Level Security (RLS)

### B. Database Security Best Practices
- Preventing SQL Injection (Prepared Statements / Parameterized Queries)
- Principle of Least Privilege
- Data Encryption (At Rest and In Transit)
- Auditing and Logging

### C. Basic Database Administration
- Backup and Recovery Strategies
- Database Maintenance (Vacuuming, Reindexing)

## Part X: SQL in the Wider Ecosystem

### A. SQL Dialects
- PostgreSQL vs. MySQL vs. SQL Server vs. Oracle: Key Syntax and Feature Differences
- SQLite for Embedded and Local Use Cases

### B. Connecting to SQL from Applications
- Drivers and Connection Strings
- Connection Pooling
- Object-Relational Mapping (ORMs): Pros, Cons, and How They Work (e.g., Sequelize, SQLAlchemy, TypeORM)
- Query Builders (e.g., Knex.js)

### C. Database Migration Tools
- The Need for Schema Version Control
- Tools like Flyway, Alembic, Knex Migrations

## Part XI: The Data Landscape Beyond Relational Databases

### A. Introduction to NoSQL
- Key-Value Stores (Redis)
- Document Databases (MongoDB)
- Column-Family Stores (Cassandra)
- Graph Databases (Neo4j)

### B. NewSQL and Hybrid Databases
- Combining the Best of Both Worlds (e.g., CockroachDB, TiDB)
- The Rise of Cloud-Native Databases (Aurora, Spanner)