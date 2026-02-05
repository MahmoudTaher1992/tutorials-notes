# 21. Relational Database Profiling Specifics

## 21.1 SQL Query Profiling
- 21.1.1 SELECT statement profiling
- 21.1.1.1 Projection efficiency
- 21.1.1.2 Selection predicate analysis
- 21.1.1.3 Join clause profiling
- 21.1.1.4 GROUP BY and aggregation cost
- 21.1.1.5 ORDER BY and sorting overhead
- 21.1.1.6 DISTINCT processing
- 21.1.1.7 LIMIT/OFFSET pagination issues
- 21.1.2 INSERT statement profiling
- 21.1.2.1 Single-row vs. bulk insert
- 21.1.2.2 Constraint checking overhead
- 21.1.2.3 Trigger execution impact
- 21.1.2.4 Index maintenance during insert
- 21.1.3 UPDATE statement profiling
- 21.1.3.1 Row location and modification
- 21.1.3.2 Index update overhead
- 21.1.3.3 Wide update vs. narrow update
- 21.1.4 DELETE statement profiling
- 21.1.4.1 Soft delete vs. hard delete
- 21.1.4.2 Cascade delete impact
- 21.1.4.3 Large delete operations
- 21.1.5 MERGE/UPSERT profiling

## 21.2 Schema-Related Profiling
- 21.2.1 Normalization impact analysis
- 21.2.2 Denormalization trade-offs
- 21.2.3 Data type selection impact
- 21.2.3.1 Storage size implications
- 21.2.3.2 Comparison and computation cost
- 21.2.4 Constraint enforcement overhead
- 21.2.4.1 Primary key checks
- 21.2.4.2 Foreign key checks
- 21.2.4.3 Check constraints
- 21.2.4.4 Unique constraints
- 21.2.5 Null handling overhead

## 21.3 Stored Procedure and Function Profiling
- 21.3.1 Procedure execution time breakdown
- 21.3.2 Statement-level profiling within procedures
- 21.3.3 Cursor performance
- 21.3.3.1 Cursor types and overhead
- 21.3.3.2 Row-by-row processing cost
- 21.3.4 Dynamic SQL profiling
- 21.3.5 Recursive procedure analysis
- 21.3.6 User-defined function overhead
- 21.3.6.1 Scalar function per-row cost
- 21.3.6.2 Table-valued function profiling

## 21.4 View Profiling
- 21.4.1 View expansion overhead
- 21.4.2 Nested view complexity
- 21.4.3 Materialized view refresh profiling
- 21.4.3.1 Full refresh vs. incremental refresh
- 21.4.3.2 Refresh scheduling optimization
- 21.4.4 Indexed view maintenance cost

## 21.5 Relational-Specific Tools (Mention Only)
- 21.5.1 PostgreSQL: `EXPLAIN ANALYZE`, `pg_stat_statements`, `auto_explain`, `pgBadger`
- 21.5.2 MySQL: `EXPLAIN`, `Performance Schema`, `slow_query_log`, `MySQL Enterprise Monitor`
- 21.5.3 SQL Server: `Execution Plans`, `Query Store`, `DMVs`, `Extended Events`, `SQL Profiler`
- 21.5.4 Oracle: `EXPLAIN PLAN`, `V$ views`, `AWR`, `ASH`, `SQL Trace`, `TKPROF`
- 21.5.5 SQLite: `EXPLAIN QUERY PLAN`, `sqlite3_profile()`
