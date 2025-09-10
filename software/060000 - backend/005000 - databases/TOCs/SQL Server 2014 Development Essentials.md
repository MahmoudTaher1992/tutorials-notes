Table of Contents
Preface 1
Chapter 1: Microsoft SQL Server Database Design Principles 7
Database design 8
The requirement collection and analysis phase 8
The conceptual design phase 9
The logical design phase 9
The physical design phase 10
The implementation and loading phase 10
The testing and evaluation phase 10
The database design life cycle recap 10
Table design 11
Tables 11
Entities 12
Attributes 12
Relationships 12
A one-to-one relationship 12
A one-to-many relationship 13
A many-to-many relationship 13
Data integrity 14
The basics of data normalization 14
The normal forms 15
The first normal form (1NF) 15
The second normal form (2NF) 15
The third normal form (3NF) 16
Denormalization 16
The SQL Server database architecture 16
Pages 17
Extents 18
Table of Contents
The transaction log file architecture The operation and workings of a transaction log Filegroups 21
The importance of choosing the appropriate data type SQL Server 2014 system data types Alias data types 23
Creating and dropping alias data types with SSMS 2014 Creating and dropping alias data types using the Transact-SQL DDL statement 19
20
21
22
23
23
CLR user-defined types 24
Summary 24
Chapter 2: Understanding DDL and DCL Statements in
SQL Server 25
Understanding the DDL, DCL, and DML language elements 26
Data Definition Language (DDL) statements 26
Data Manipulation Language (DML) statements 26
Data Control Language (DCL) statements 26
Understanding the purpose of SQL Server 2014 system databases 27
SQL Server 2014 system databases 27
The master database 27
The model database 28
The msdb database 28
The tempdb database 28
The resource database 29
The distribution database 29
An overview of database recovery models 29
The simple recovery model 29
The bulk-logged recovery model 29
Full recovery 30
Creating and modifying databases 30
Create, modify, and drop databases with T-SQL DDL statements 30
Creating a database with T-SQL DDL statements 30
Example 1 – creating a database based on a model database 32
Example 2 – creating a database that explicitly specifies the database data and the
transaction log file's filespecs properties Example 3 – creating a database on multiple filegroups Modifying a database with T-SQL DDL statements Example – adding a secondary data file to an existing database Dropping a database with T-SQL DDL statements Create, modify, and drop databases with SSMS 2014 Creating a database with SSMS 2014 Modifying a database with SSMS 2014 Dropping a database with SSMS 2014 32
33
33
34
35
35
35
37
38
[ ii ]
Table of Contents
Creating and managing database schemas Managing schemas using T-SQL DDL statements Managing schemas using SSMS 2014 Creating and managing tables 41
Creating and modifying tables 42
Creating and modifying tables with T-SQL DDL statements Creating a table with T-SQL DDL statements Modifying a table with T-SQL DDL statements Dropping a table with T-SQL DDL statements Creating and modifying tables with SSMS 2014 Creating a table with SSMS 2014 Modifying a table with SSMS 2014 Deleting a table with SSMS 2014 Grant, deny, and revoke permissions to securables 39
40
40
42
42
44
44
45
45
46
46
46
Grant, deny, and revoke permissions to securables with T-SQL DCL
statements 46
Granting permissions to securables with T-SQL DCL statements 47
Denying permissions to securables with T-SQL DCL statements 47
Revoking permissions to securables with T-SQL DCL statements 48
Managing permissions using SSMS 2014 48
Summary 48
Chapter 3: Data Retrieval Using Transact-SQL Statements 49
Understanding Transact-SQL SELECT, FROM, and WHERE clauses 50
The SELECT statement 50
The FROM clause 51
The WHERE clause 51
Using T-SQL functions in the query 52
Aggregate functions 52
Configuration functions 53
Cursor functions 53
Date and time functions 53
Mathematical functions 54
Metadata functions 54
Rowset functions 54
Security functions 54
String functions 55
System statistical functions 55
Multiple table queries using UNION, EXCEPT, INTERSECT, and JOINs 55
The UNION operator 56
The EXCEPT operator 57
The INTERSECT operator 58
[ iii ]
Table of Contents
The JOIN operator 59
Using INNER JOIN 59
Using outer joins 60
Subqueries 61
Examples of subqueries 62
Common Table Expressions 63
Organizing and grouping data 64
The ORDER BY clause 64
The GROUP BY clause 65
The HAVING clause 65
The TOP clause 66
The DISTINCT clause 66
Pivoting and unpivoting data 66
Using the Transact-SQL analytic window functions 68
Ranking functions 69
PERCENT RANK 71
CUME_DIST 72
PERCENTILE_CONT and PERCENTILE_DISC 73
LEAD and LAG 74
FIRST_VALUE and LAST_VALUE 76
Summary 77
Chapter 4: Data Modification with SQL Server Transact-SQL
Statements 79
Inserting data into SQL Server database tables 80
The INSERT examples 82
Example 1 – insert a single row into a SQL Server database table 82
Example 2 – INSERT with the SELECT statement 84
Example 3 – INSERT with the EXEC statement 84
Example 4 – explicitly inserting data into the IDENTITY column 85
Updating data in SQL Server database tables 86
The UPDATE statement examples 87
Example 1 – updating a single row 87
Example 2 – updating multiple rows 87
Deleting data from SQL Server database tables 88
The DELETE statement examples 89
Example 1 – deleting a single row 89
Example 2 – deleting all rows 89
Using the MERGE statement 89
The MERGE statement examples 91
The TRUNCATE TABLE statement 94
The SELECT INTO statement 94
Summary 95
[ iv ]
Table of Contents
Chapter 5: Understanding Advanced Database Programming
Objects and Error Handling 97
Creating and using variables 98
Creating a local variable 98
Creating the cursor variable 99
Creating the table variable 99
Control-of-flow keywords 100
BEGIN…END keywords 100
The IF…ELSE expression 101
A CASE statement 102
WHILE, BREAK, and CONTINUE statements 102
RETURN, GOTO, and WAITFOR statements 103
Creating and using views 104
Creating views with Transact-SQL and SSMS 2014 104
Creating, altering, and dropping views with Transact-SQL DDL statements 104
Creating, altering, and dropping views with SSMS 2014 107
Indexed views 109
Creating and using stored procedures 111
Creating a stored procedure 113
Modifying a stored procedure 117
Dropping a stored procedure 118
Viewing stored procedures 119
Executing stored procedures 120
Creating and using user-defined functions 120
Creating user-defined functions 121
Creating a user-defined scalar function 121
Creating a user-defined table-valued function 124
Modifying user-defined functions 128
Using a user-defined table-valued function 129
Dropping user-defined functions 129
Viewing user-defined functions 130
Creating and using triggers 131
Nested triggers 131
Recursive triggers 132
DML triggers 132
Inserted and deleted logical tables 133
Creating DML triggers 133
Modifying a DML trigger 135
Dropping a DML trigger 135
Data Definition Language (DDL) triggers 135
The EVENTDATA function 135
Creating a DDL trigger 135
Modifying a DDL trigger 136
[ v ]
Table of Contents
Dropping a DDL trigger 137
Disabling and enabling triggers 137
Viewing triggers 137
Handling Transact-SQL errors 138
An example of TRY...CATCH 139
An example of TRY...CATCH with THROW 140
An example of TRY...CATCH with RAISERROR 141
Summary 141
Chapter 6: Performance Basics 143
Components of SQL Server Database Engine 143
The SQL Server Relational Engine architecture 144
Parsing and binding 145
Query optimization 145
Query execution and plan caching 147
Query plan aging 148
The improved design in SQL Server 2014 for the cardinality estimation 148
Optimizing SQL Server for ad hoc workloads 148
Manually clearing the plan cache 149
The SQL Server 2014 in-memory OLTP engine 149
The limitations of memory-optimized tables 150
Indexes 151
The cost associated with indexes 151
How SQL Server uses indexes 151
Access without an index 152
Access with an index 152
The structure of indexes 152
Index types 153
Clustered indexes 153
Nonclustered indexes 154
Single-column indexes 154
Composite indexes 155
Covering indexes 157
Unique indexes 160
Spatial indexes 160
Partitioned indexes 161
Filtered indexes 161
Full-text indexes 162
XML indexes 163
Memory-optimized indexes 163
Columnstore indexes 164
Guidelines for designing and optimizing indexes 168
Avoid overindexing tables 168
Create a clustered index before creating nonclustered indexes when using
clustered indexes 168
Index columns used in foreign keys 168
[ vi ]
Table of Contents
Index columns frequently used in joins 169
Use composite indexes and covering indexes to give the query optimizer
greater flexibility 169
Limit key columns to columns with a high level of selectability 169
Pad indexes and specify the fill factor to reduce page splits 169
Rebuild indexes based on the fragmentation level 170
Query optimization statistics 170
Database-wide statistics options in SQL Server to automatically create
and update statistics 171
Manually create and update statistics 171
Determine the date when the statistics were last updated 172
Using the DBCC SHOW_STATISTICS command 172
Using the sys.stats catalog view with the
STATS_DATE() function 173
The fundamentals of transactions 173
Transaction modes 174
Implementing transactions 174
BEGIN TRANSACTION 174
COMMIT TRANSACTION 174
ROLLBACK TRANSACTION 175
SAVE TRANSACTION 175
An overview of locking 175
Basic locks 176
Optimistic and pessimistic locking 176
Transaction isolation 177
SQL Server 2014 tools for monitoring and troubleshooting SQL
Server performance 178
Activity Monitor 178
The SQLServer:Locks performance object 178
Dynamic Management Views 179
SQL Server Profiler 179
The sp_who and sp_who2 system stored procedures 180
SQL Server Extended Events 180
Summary 180
Index 181