# Comprehensive SQL Database Study Guide — Table of Contents

---

## Module 1: Foundations of Databases

### 1.1 Introduction to Databases
- What is a Database?
- Why Databases Exist (vs. flat files, spreadsheets)
- Real-world use cases
- Types of data: structured, semi-structured, unstructured
- Database vs. Data Warehouse vs. Data Lake

### 1.2 Database Models
- Hierarchical Model
- Network Model
- Relational Model
- Document Model
- Graph Model
- Key-Value Model
- Comparison table of models

### 1.3 The Relational Model Deep Dive
- Tables, Rows, and Columns
- Domains and Data Types
- Tuples and Relations
- Mathematical foundation: Set Theory basics
- Codd's 12 Rules of Relational Databases
- Relational Algebra overview:
  - Selection $\sigma$
  - Projection $\pi$
  - Union $\cup$
  - Intersection $\cap$
  - Difference $-$
  - Cartesian Product $\times$
  - Join $\bowtie$

### 1.4 DBMS vs. RDBMS
- What is a DBMS?
- What is an RDBMS?
- Popular RDBMS systems: MySQL, PostgreSQL, SQL Server, Oracle, SQLite
- Cloud-native databases: Amazon RDS, Google Cloud SQL, Azure SQL
- Choosing the right RDBMS

---

## Module 2: Database Design

### 2.1 Entity-Relationship (ER) Modeling
- Entities and Entity Sets
- Attributes:
  - Simple vs. Composite
  - Single-valued vs. Multi-valued
  - Derived attributes
- Relationships and Relationship Sets
- Cardinality:
  - One-to-One $(1:1)$
  - One-to-Many $(1:N)$
  - Many-to-Many $(M:N)$
- Participation constraints: Total vs. Partial
- Weak Entities and Identifying Relationships
- Drawing ER Diagrams: Chen notation vs. Crow's Foot

### 2.2 Enhanced ER (EER) Modeling
- Specialization and Generalization
- Inheritance in EER
- Aggregation
- Disjoint vs. Overlapping constraints
- Total vs. Partial specialization

### 2.3 Normalization
- Goals of Normalization: reduce redundancy, avoid anomalies
- Functional Dependencies (FD)
  - Definition: $X \rightarrow Y$
  - Armstrong's Axioms: Reflexivity, Augmentation, Transitivity
  - Closure of a set of FDs
  - Canonical Cover
- Normal Forms:
  - **1NF** — Atomic values, no repeating groups
  - **2NF** — No partial dependencies ($X \rightarrow Y$ where $X \subset$ PK)
  - **3NF** — No transitive dependencies
  - **BCNF** — Boyce-Codd Normal Form
  - **4NF** — Multi-valued dependencies
  - **5NF** — Join dependencies
- Lossless Decomposition
- Dependency Preservation
- Denormalization and when to use it

### 2.4 Physical Data Modeling
- Translating ER diagrams to tables
- Choosing Primary Keys
- Surrogate keys vs. Natural keys
- Composite keys
- Mapping relationships to foreign keys
- Mapping M:N relationships to junction tables
- Indexes at the design stage

### 2.5 Database Design Best Practices
- Naming conventions: tables, columns, constraints
- Data type selection guidelines
- Avoiding common design mistakes
- Documentation and data dictionaries

---

## Module 3: SQL Language Fundamentals

### 3.1 SQL Overview
- History of SQL: SEQUEL to SQL
- SQL Standards: SQL-86, SQL-92, SQL:1999, SQL:2003, SQL:2011, SQL:2016
- SQL Sublanguages:
  - DDL — Data Definition Language
  - DML — Data Manipulation Language
  - DQL — Data Query Language
  - DCL — Data Control Language
  - TCL — Transaction Control Language

### 3.2 Data Types
- **Numeric Types:**
  - `INT`, `SMALLINT`, `BIGINT`, `TINYINT`
  - `DECIMAL(p, s)`, `NUMERIC(p, s)`
  - `FLOAT`, `REAL`, `DOUBLE PRECISION`
- **String Types:**
  - `CHAR(n)`, `VARCHAR(n)`, `TEXT`
  - `NCHAR`, `NVARCHAR` for Unicode
- **Date and Time Types:**
  - `DATE`, `TIME`, `DATETIME`, `TIMESTAMP`
  - `INTERVAL`
- **Boolean Types**
- **Binary Types:** `BLOB`, `BYTEA`, `VARBINARY`
- **JSON and XML Types**
- **NULL** — meaning and implications
- Type casting and conversion

### 3.3 DDL — Data Definition Language
- `CREATE DATABASE`
- `CREATE SCHEMA`
- `CREATE TABLE`
  ```sql
  CREATE TABLE employees (
      employee_id INT PRIMARY KEY,
      first_name  VARCHAR(50) NOT NULL,
      last_name   VARCHAR(50) NOT NULL,
      hire_date   DATE,
      salary      DECIMAL(10, 2)
  );
  ```
- `ALTER TABLE`
  - `ADD COLUMN`, `DROP COLUMN`, `MODIFY COLUMN`
  - `ADD CONSTRAINT`, `DROP CONSTRAINT`
- `DROP TABLE`, `DROP DATABASE`
- `TRUNCATE TABLE`
- `RENAME TABLE`
- Constraints:
  - `PRIMARY KEY`
  - `FOREIGN KEY` with `ON DELETE` and `ON UPDATE` actions
  - `UNIQUE`
  - `NOT NULL`
  - `CHECK`
  - `DEFAULT`
- `CREATE INDEX`, `DROP INDEX`
- `CREATE VIEW`, `DROP VIEW`
- `CREATE SEQUENCE`

### 3.4 DML — Data Manipulation Language
- **INSERT:**
  ```sql
  INSERT INTO employees (first_name, last_name, salary)
  VALUES ('Alice', 'Smith', 75000.00);
  ```
  - Insert multiple rows
  - Insert from a SELECT: `INSERT INTO ... SELECT`
- **UPDATE:**
  ```sql
  UPDATE employees
  SET salary = salary * 1.10
  WHERE department_id = 3;
  ```
  - Updating with JOINs
- **DELETE:**
  ```sql
  DELETE FROM employees
  WHERE hire_date < '2000-01-01';
  ```
  - DELETE with JOINs
- **MERGE (UPSERT):**
  ```sql
  MERGE INTO target_table AS target
  USING source_table AS source
  ON target.id = source.id
  WHEN MATCHED THEN UPDATE SET ...
  WHEN NOT MATCHED THEN INSERT ...;
  ```

---

## Module 4: Querying with SQL (DQL)

### 4.1 The SELECT Statement
- Basic `SELECT` structure
- `SELECT *` vs. explicit columns
- Column aliases with `AS`
- Literal values and expressions in SELECT
- `DISTINCT`
- `LIMIT` / `TOP` / `FETCH FIRST n ROWS`

### 4.2 Filtering Data
- `WHERE` clause
- Comparison operators: `=`, `<>`, `!=`, `<`, `>`, `<=`, `>=`
- Logical operators: `AND`, `OR`, `NOT`
- `BETWEEN ... AND ...`
- `IN (...)` and `NOT IN (...)`
- `LIKE` and `ILIKE` with wildcards `%` and `_`
- `IS NULL` and `IS NOT NULL`
- `EXISTS` and `NOT EXISTS`

### 4.3 Sorting and Limiting Results
- `ORDER BY` with ASC and DESC
- Multi-column sorting
- Sorting by expressions
- `NULLS FIRST` / `NULLS LAST`
- `LIMIT` and `OFFSET` for pagination

### 4.4 Aggregate Functions
- `COUNT(*)`, `COUNT(column)`, `COUNT(DISTINCT column)`
- `SUM()`, `AVG()`, `MIN()`, `MAX()`
- `GROUP BY`
- `HAVING` — filtering aggregated results
- Difference between `WHERE` and `HAVING`
- `ROLLUP`, `CUBE`, `GROUPING SETS`
- `GROUPING()` function

### 4.5 Joins
- **INNER JOIN**
  ```sql
  SELECT e.first_name, d.department_name
  FROM employees e
  INNER JOIN departments d ON e.department_id = d.department_id;
  ```
- **LEFT (OUTER) JOIN**
- **RIGHT (OUTER) JOIN**
- **FULL (OUTER) JOIN**
- **CROSS JOIN** — Cartesian product
- **SELF JOIN**
- **NATURAL JOIN**
- Multi-table joins with 3 or more tables
- Join on multiple conditions
- Non-equi joins
- Performance considerations for joins

### 4.6 Subqueries
- Scalar subqueries
- Row subqueries
- Table subqueries: derived tables
- Correlated subqueries
- Subqueries with `IN`, `ANY`, `ALL`, `EXISTS`
- Subqueries in `SELECT`, `FROM`, `WHERE`, `HAVING`
- CTEs vs. subqueries — when to use which

### 4.7 Common Table Expressions (CTEs)
- `WITH` clause syntax
- Single and multiple CTEs
- Recursive CTEs:
  ```sql
  WITH RECURSIVE hierarchy AS (
      SELECT employee_id, manager_id, 1 AS level
      FROM employees WHERE manager_id IS NULL
      UNION ALL
      SELECT e.employee_id, e.manager_id, h.level + 1
      FROM employees e
      JOIN hierarchy h ON e.manager_id = h.employee_id
  )
  SELECT * FROM hierarchy;
  ```
- Use cases: hierarchies, graphs, date series

### 4.8 Set Operations
- `UNION` vs. `UNION ALL`
- `INTERSECT`
- `EXCEPT` / `MINUS`
- Rules: same number of columns, compatible data types
- Ordering with set operations

### 4.9 Window Functions
- What are Window Functions and why they matter
- `OVER()` clause
- `PARTITION BY`
- `ORDER BY` within a window
- Frame specification: `ROWS BETWEEN`, `RANGE BETWEEN`
- **Ranking functions:**
  - `ROW_NUMBER()`
  - `RANK()`
  - `DENSE_RANK()`
  - `NTILE(n)`
- **Offset functions:**
  - `LAG(column, offset, default)`
  - `LEAD(column, offset, default)`
  - `FIRST_VALUE()`, `LAST_VALUE()`, `NTH_VALUE()`
- **Aggregate window functions:**
  - `SUM() OVER(...)`, `AVG() OVER(...)`
  - Running totals and moving averages
- Named windows with `WINDOW` clause

---

## Module 5: Advanced SQL Features

### 5.1 Built-in Functions
- **String Functions:**
  - `CONCAT()`, `LENGTH()`, `SUBSTRING()`, `TRIM()`
  - `UPPER()`, `LOWER()`, `REPLACE()`, `POSITION()`
  - `LPAD()`, `RPAD()`, `REVERSE()`, `SPLIT_PART()`
- **Numeric Functions:**
  - `ROUND()`, `CEIL()`, `FLOOR()`, `ABS()`, `MOD()`
  - `POWER()`, `SQRT()`, `LOG()`, `EXP()`
- **Date and Time Functions:**
  - `NOW()`, `CURRENT_DATE`, `CURRENT_TIME`
  - `DATE_ADD()`, `DATE_DIFF()`, `DATE_TRUNC()`
  - `EXTRACT()`, `TO_CHAR()`, `TO_DATE()`
- **Conditional Functions:**
  - `CASE WHEN ... THEN ... ELSE ... END`
  - `COALESCE()`, `NULLIF()`, `IFNULL()`, `NVL()`
  - `IIF()`, `DECODE()`
- **Type Conversion:**
  - `CAST()`, `CONVERT()`, `::`

### 5.2 Views
- Creating and using views
- Updatable vs. read-only views
- Materialized Views:
  - Creating and refreshing
  - Use cases for performance
- Indexed views in SQL Server
- Security through views

### 5.3 Stored Procedures
- Creating stored procedures
- Input, output, and INOUT parameters
- Control flow: `IF`, `CASE`, `LOOP`, `WHILE`, `FOR`
- Exception handling: `BEGIN ... EXCEPTION ... END`
- Calling stored procedures
- Benefits and drawbacks

### 5.4 User-Defined Functions (UDFs)
- Scalar functions
- Table-valued functions
- Custom aggregate functions
- Deterministic vs. non-deterministic functions
- SQL vs. procedural language functions: PL/pgSQL, T-SQL

### 5.5 Triggers
- What are triggers?
- `BEFORE` / `AFTER` / `INSTEAD OF` triggers
- `INSERT`, `UPDATE`, `DELETE` triggers
- Row-level vs. statement-level triggers
- `NEW` and `OLD` pseudo-records
- Practical uses: auditing, data validation, cascades
- Risks: hidden logic, cascading triggers

### 5.6 Cursors
- What are cursors?
- Declaring, opening, fetching, and closing cursors
- Implicit vs. explicit cursors
- Cursor attributes
- When to use cursors and when NOT to

### 5.7 JSON and XML Support
- Storing JSON in databases
- JSON functions: `JSON_EXTRACT()`, `JSON_OBJECT()`, `JSON_ARRAY()`
- PostgreSQL `JSONB` vs. `JSON`
- XML support: `XMLQUERY`, `XMLTABLE`, `XMLElement`
- Querying semi-structured data

---

## Module 6: Transactions and Concurrency

### 6.1 Transactions
- What is a transaction?
- **ACID Properties:**
  - **A**tomicity
  - **C**onsistency
  - **I**solation
  - **D**urability
- `BEGIN`, `COMMIT`, `ROLLBACK`
- `SAVEPOINT`, `ROLLBACK TO SAVEPOINT`, `RELEASE SAVEPOINT`
- Autocommit mode
- Implicit vs. explicit transactions

### 6.2 Concurrency Problems
- **Dirty Read** — reading uncommitted data
- **Non-repeatable Read** — data changes between reads
- **Phantom Read** — new rows appear between reads
- **Lost Update** — two transactions overwrite each other
- **Deadlock** — circular lock dependency

### 6.3 Isolation Levels

| Isolation Level | Dirty Read | Non-repeatable Read | Phantom Read |
|---|---|---|---|
| READ UNCOMMITTED | Possible | Possible | Possible |
| READ COMMITTED | Prevented | Possible | Possible |
| REPEATABLE READ | Prevented | Prevented | Possible |
| SERIALIZABLE | Prevented | Prevented | Prevented |

- Setting isolation level: `SET TRANSACTION ISOLATION LEVEL ...`
- Trade-off: higher isolation means lower concurrency

### 6.4 Locking
- Shared locks vs. Exclusive locks
- Intent locks
- Row-level vs. table-level vs. page-level locking
- Optimistic vs. Pessimistic locking
- `SELECT ... FOR UPDATE` / `SELECT ... FOR SHARE`
- Deadlock detection and prevention
- Lock timeouts

### 6.5 MVCC — Multi-Version Concurrency Control
- How MVCC works
- Version chains and snapshots
- MVCC in PostgreSQL vs. Oracle vs. MySQL InnoDB
- Vacuum and garbage collection
- Benefits over traditional locking

---

## Module 7: Indexing and Performance

### 7.1 Index Fundamentals
- What is an index and how it works
- B-Tree structure:
  - Height $h = O(\log_m n)$ where $m$ is the order
  - Search, insert, delete complexity: $O(\log n)$
- Index entries and pointers
- Clustered vs. Non-clustered indexes
- Index selectivity and cardinality
- Index overhead on writes

### 7.2 Types of Indexes
- **B-Tree Index** — default, general purpose
- **Hash Index** — exact equality only
- **Bitmap Index** — low-cardinality columns
- **Full-Text Index** — text search
- **Spatial Index (GiST / SP-GiST)** — geographic data
- **Composite (Multi-column) Index** — column order matters
- **Partial Index** — index with a WHERE clause
- **Covering Index** — enables index-only scans
- **Expression / Functional Index** — e.g., `LOWER(email)`
- **Unique Index**

### 7.3 Query Execution Plans
- `EXPLAIN` and `EXPLAIN ANALYZE`
- Reading execution plans
- Common operations:
  - Sequential Scan
  - Index Scan vs. Index Only Scan
  - Bitmap Index Scan
  - Nested Loop Join
  - Hash Join
  - Merge Join
- Estimated vs. actual rows and cost
- Cost model: $\text{cost} = \text{seq\_page\_cost} \times N_{pages} + \text{cpu\_tuple\_cost} \times N_{rows}$

### 7.4 Query Optimization
- The query optimizer: rule-based vs. cost-based
- Statistics and the `ANALYZE` command
- Writing SARGable queries
- Avoiding function calls on indexed columns in WHERE
- Index selectivity and query planner hints
- Rewriting subqueries as joins
- Avoiding `SELECT *`
- Pagination optimization: keyset vs. offset
- Partitioning for performance

### 7.5 Partitioning
- What is table partitioning?
- **Range Partitioning** — by date ranges
- **List Partitioning** — by category values
- **Hash Partitioning** — evenly distributed
- **Composite Partitioning**
- Partition pruning
- Local vs. global indexes on partitions
- Partition management: adding and dropping partitions

### 7.6 Caching and Buffer Management
- Buffer pool and shared buffer
- Page cache
- Query result caching
- Prepared statements and plan caching
- Connection pooling: PgBouncer, ProxySQL

---

## Module 8: Database Administration

### 8.1 Installation and Configuration
- Installing PostgreSQL / MySQL / SQL Server
- Key configuration files: `postgresql.conf`, `my.cnf`, `mssql.conf`
- Memory settings: `shared_buffers`, `work_mem`, `innodb_buffer_pool_size`
- Connection settings: `max_connections`
- Logging configuration
- Environment variables and ports

### 8.2 User and Role Management (DCL)
- Creating users and roles
  ```sql
  CREATE USER alice WITH PASSWORD 'secure_pass';
  CREATE ROLE readonly;
  GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;
  GRANT readonly TO alice;
  ```
- `GRANT` and `REVOKE` privileges
- Object-level vs. schema-level vs. database-level privileges
- Row-Level Security (RLS)
- Role inheritance
- Principle of least privilege

### 8.3 Backup and Recovery
- Types of backups:
  - Full backup
  - Incremental backup
  - Differential backup
  - Point-in-time recovery (PITR)
- Tools:
  - `pg_dump`, `pg_restore`, `pg_basebackup`
  - `mysqldump`, `mysqlpump`, `xtrabackup`
  - SQL Server: `BACKUP DATABASE`, `RESTORE DATABASE`
- Write-Ahead Logging (WAL) / Redo Log / Binary Log
- Recovery Time Objective (RTO) and Recovery Point Objective (RPO)
- Backup testing and verification

### 8.4 High Availability and Replication
- **Replication types:**
  - Synchronous vs. Asynchronous
  - Logical vs. Physical / Streaming
- **Replication setups:**
  - Primary-Replica (Master-Slave)
  - Multi-Primary (Multi-Master)
  - Cascading replication
- Failover and switchover
- Tools: Patroni, Orchestrator, MHA
- **Clustering:**
  - PostgreSQL with Patroni and etcd/Consul
  - MySQL Group Replication / InnoDB Cluster
  - SQL Server Always On Availability Groups
- Load balancing reads with replicas

### 8.5 Monitoring and Alerting
- Key metrics to monitor:
  - Query throughput (QPS)
  - Latency: p50, p95, p99
  - Cache hit ratio
  - Lock waits and deadlocks
  - Replication lag
  - Disk I/O, CPU, Memory
- System views and catalog tables:
  - `pg_stat_activity`, `pg_stat_user_tables`, `pg_locks`
  - `information_schema.processlist` for MySQL
  - `sys.dm_exec_requests` for SQL Server
- Monitoring tools:
  - Prometheus with `pg_exporter` / `mysqld_exporter`
  - Grafana dashboards
  - pgBadger for log analysis
  - Percona Monitoring and Management (PMM)
  - Datadog, New Relic

### 8.6 Maintenance Tasks
- `VACUUM` and `AUTOVACUUM` in PostgreSQL
- `ANALYZE` — updating table statistics
- `REINDEX` — rebuilding indexes
- `OPTIMIZE TABLE` in MySQL
- Table bloat and index bloat
- Log rotation and archiving
- Scheduled jobs: `pg_cron`, SQL Server Agent, MySQL Event Scheduler

---

## Module 9: Security

### 9.1 Authentication
- Authentication methods: password, LDAP, Kerberos, SSL certificates, SCRAM
- `pg_hba.conf` — host-based authentication
- SSL/TLS connections
- Two-factor authentication

### 9.2 Authorization
- Discretionary Access Control (DAC)
- Mandatory Access Control (MAC)
- Role-Based Access Control (RBAC)
- Row-Level Security (RLS) policies
- Column-level security

### 9.3 Encryption
- Encryption at rest:
  - Transparent Data Encryption (TDE)
  - File system encryption
- Encryption in transit: TLS/SSL
- Column-level encryption with `pgcrypto`
- Key management: AWS KMS, HashiCorp Vault

### 9.4 SQL Injection Prevention
- What is SQL injection?
- Parameterized queries and Prepared Statements
  ```sql
  -- Vulnerable:
  SELECT * FROM users WHERE name = '" + userInput + "';

  -- Safe (parameterized):
  SELECT * FROM users WHERE name = $1;
  ```
- Input validation and sanitization
- Stored procedures as a defense layer
- Principle of least privilege
- Web Application Firewalls (WAF)

### 9.5 Auditing and Compliance
- Database activity monitoring (DAM)
- Audit logging: `pgaudit`, SQL Server Audit
- Compliance frameworks: GDPR, HIPAA, SOC 2, PCI-DSS
- Data masking and anonymization
- Retention policies

---

## Module 10: Distributed Databases and Scalability

### 10.1 Scaling Strategies
- **Vertical Scaling (Scale-Up)** — bigger hardware
- **Horizontal Scaling (Scale-Out)** — more nodes
- Read replicas for read scaling
- Connection pooling

### 10.2 Sharding
- What is sharding?
- Sharding strategies:
  - Range-based sharding
  - Hash-based sharding: $\text{node} = hash(key) \mod N$
  - Directory-based sharding
- Cross-shard queries and transactions
- Resharding challenges
- Tools: Citus for PostgreSQL, Vitess for MySQL

### 10.3 CAP Theorem and Distributed Systems
- **C**onsistency, **A**vailability, **P**artition Tolerance
- CAP Theorem: you can only guarantee 2 of 3
- CP vs. AP systems
- PACELC theorem extension
- Eventual consistency

### 10.4 NewSQL and HTAP
- NewSQL databases: CockroachDB, TiDB, YugabyteDB, Google Spanner
- HTAP — Hybrid Transactional/Analytical Processing
- Distributed SQL: global transactions, geo-distribution
- Comparison with traditional RDBMS

---

## Module 11: Analytics and Reporting

### 11.1 OLTP vs. OLAP
- OLTP — transactional, normalized, low latency
- OLAP — analytical, denormalized, high throughput
- HTAP — hybrid approaches

### 11.2 Data Warehousing Concepts
- Star Schema
- Snowflake Schema
- Fact tables and Dimension tables
- Slowly Changing Dimensions: SCD Types 1, 2, 3
- ETL vs. ELT pipelines

### 11.3 Analytical SQL
- Complex aggregations with `ROLLUP` and `CUBE`
- Window functions for analytics
- Cohort analysis queries
- Funnel analysis
- Time-series analysis with SQL
- Percentile calculations: `PERCENTILE_CONT()`, `PERCENTILE_DISC()`

### 11.4 Reporting Tools Integration
- Connecting BI tools: Tableau, Power BI, Metabase, Superset
- SQL for reporting best practices
- Materialized views for report performance
- Data marts

---

## Module 12: Practice and Projects

### 12.1 Practice Platforms
- LeetCode — SQL track
- HackerRank — SQL challenges
- SQLZoo
- Mode Analytics SQL Tutorial
- pgexercises.com
- DataLemur

### 12.2 Suggested Projects
- **Beginner:** E-commerce database with products, orders, and customers
- **Intermediate:** Hospital management system with stored procedures and triggers
- **Advanced:** Social network with graph-like queries using recursive CTEs
- **Analytics:** Sales data warehouse with star schema and OLAP queries
- **DevOps:** Set up PostgreSQL with replication, monitoring, and automated backups

### 12.3 Certifications to Consider
- Oracle Database SQL Certified Associate
- Microsoft Certified: Azure Database Administrator Associate
- PostgreSQL certification programs
- IBM Certified Database Administrator — DB2
- Google Professional Data Engineer

---