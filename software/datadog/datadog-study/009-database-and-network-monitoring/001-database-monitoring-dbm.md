Based on the Table of Contents you provided, specifically **Section IX (Database & Network Monitoring), Subsection A**, here is a detailed explanation of **Database Monitoring (DBM)**.

---

# Detailed Explanation: Database Monitoring (DBM)

In the Datadog ecosystem, **Database Monitoring (DBM)** is a specialized product designed to bridge the gap between Infrastructure monitoring (watching the server) and APM (watching the code).

While standard Infrastructure monitoring tells you that your database server has **high CPU**, DBM tells you exactly **which SQL query** is causing that high CPU.

Here is a breakdown of the specific concepts listed in your TOC:

### 1. Query Metrics and Explain Plans

This is the core value proposition of DBM. It moves beyond generic stats (like "connections count") and looks at the actual SQL statements being executed.

#### **Query Metrics (Normalized Queries)**
Datadog does not just log every single raw SQL query (which would be noisy and expensive). Instead, it creates **Normalized Queries**.
*   **Raw:** `SELECT * FROM users WHERE id = 101;` and `SELECT * FROM users WHERE id = 102;`
*   **Normalized:** `SELECT * FROM users WHERE id = ?;`

By grouping these, DBM provides historical metrics for that specific query signature:
*   **Throughput:** How many times per minute is this query called?
*   **Latency:** What is the average, p95, and p99 execution time?
*   **Total Time:** The cumulative time the database spent working on this specific query (high total time usually indicates the biggest bottleneck).
*   **Rows:** Average number of rows returned or scanned.

#### **Explain Plans**
Knowing a query is slow is step one. Knowing *why* it is slow is step two.
*   An **Explain Plan** is the execution strategy the database engine generates for a specific query.
*   Datadog captures these plans periodically or for particularly slow queries.
*   **Visualizing the bottleneck:** The DBM UI visualizes the plan to show you if the database is doing a **Sequential Scan** (reading the whole table—slow) vs. an **Index Scan** (jumping to the data—fast).
*   It helps developers decide if they need to add an Index to a table or rewrite the query.

### 2. Host vs. Database View

A common problem in troubleshooting is "Context Switching." DBM attempts to unify the view of the hardware and the software.

#### **The Host View (Infrastructure)**
This focuses on the resources available to the machine running the database:
*   **CPU Utilization:** Is the server maxed out?
*   **Memory:** Is there any RAM left, or are we swapping to disk?
*   **Disk I/O:** Is the hard drive writing as fast as it can (IOPS saturation)?

#### **The Database View (Internal Engine Metrics)**
This focuses on what the Database Engine (e.g., Postgres process) reports internally:
*   **Buffer Cache Hit Ratio:** Is the data in memory, or does the DB have to fetch it from the slow disk?
*   **Locks:** Is a query waiting because another query locked the table?
*   **Replication Lag:** Is the Read Replica falling behind the Master node?
*   **Active Connections:** Are we hitting the connection limit?

**The Correlation:** DBM overlays these two views. You can select a spike in CPU on the Host view and immediately see which Queries were running at that exact moment in the Database view.

### 3. Supported Engines

Datadog DBM is not available for every single database type; it requires deep integration into the specific database's performance schema. As of the current landscape, the primary supported engines are:

*   **PostgreSQL:**
    *   Works by connecting to the `pg_stat_statements` extension, which Postgres uses to track query execution statistics.
    *   Supports self-hosted, AWS RDS, and Aurora.
*   **MySQL / MariaDB:**
    *   Works by querying the `performance_schema`.
    *   Supports self-hosted, AWS RDS, Aurora, and Azure Database for MySQL.
*   **SQL Server (Microsoft):**
    *   Uses Dynamic Management Views (DMVs) to extract performance data.
    *   Supports Azure SQL and self-hosted on Windows/Linux.
*   **Oracle:**
    *   Recently added support for Oracle Database monitoring.

---

### How it works (Technical Context)

To make DBM work, you generally have to perform three distinct configuration steps that differ from standard Agent installation:

1.  **Grant Permissions:** You must create a specific Datadog user inside your database and grant it permission to read system tables (like `pg_stat_statements` or `performance_schema`).
2.  **Agent Configuration:** You must update the `conf.yaml` for the specific integration (e.g., `postgres.d/conf.yaml`) to enable `dbm: true`.
3.  **Tagging:** To link your Application (APM) to your Database (DBM), you must ensure `service`, `env`, and `version` tags match. This allows you to click a slow endpoint in APM (e.g., `/checkout`) and jump directly to the SQL query causing the slowness in DBM.

### Security Note (PII Obfuscation)
Because DBM analyzes actual SQL queries, there is a risk of capturing Personally Identifiable Information (e.g., `SELECT * FROM users WHERE email = 'john@example.com'`).
Datadog Agents are configured by default to **obfuscate** literals in SQL queries before sending the data to the cloud, replacing sensitive data with `?`.
