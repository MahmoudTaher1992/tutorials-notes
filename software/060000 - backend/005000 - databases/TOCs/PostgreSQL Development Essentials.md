r
Table of Contents
Preface 1
Chapter 1: Advanced SQL 5
Creating views 5
Deleting and replacing views 7
Materialized views 8
Why materialized views? 8
Read-only, updatable, and writeable materialized views 8
Read-only materialized views 9
Updatable materialized views 9
Writeable materialized views 10
Creating cursors 10
Using cursors 11
Closing a cursor 12
Using the GROUP BY clause 12
Using the HAVING clause 14
Parameters or arguments 14
Using the UPDATE operation clauses 15
Using the LIMIT clause 15
Using subqueries 16
Subqueries that return multiple rows 18
Correlated subqueries 18
Existence subqueries 19
Parameters or arguments 19
Using the Union join 20
Using the Self join 21
Using the Outer join 22
Left outer join 23
Right outer join 24
Full outer join 24
Summary 26
Chapter 2: Data Manipulation 27
Conversion between datatypes 27
Introduction to arrays 28
Array constructors 28
String_to_array() 31
Array_dims( ) 32
ARRAY_AGG() 32
ARRAY_UPPER() 34
Array_length() 34
Array slicing and splicing 34
UNNESTing arrays to rows 35
Introduction to JSON 37
Inserting JSON data in PostgreSQL 37
Querying JSON 38
Equality operation 38
Containment 38
Key/element existence 39
Outputting JSON 40
Using XML in PostgreSQL 41
Inserting XML data in PostgreSQL 41
Querying XML data 42
Composite datatype 42
Creating composite types in PostgreSQL 42
Altering composite types in PostgreSQL 44
Dropping composite types in PostgreSQL 45
Summary 45
Chapter 3: Triggers 46
Introduction to triggers 46
Adding triggers to PostgreSQL 47
Modifying triggers in PostgreSQL 52
Removing a trigger function 53
Creating a trigger function 54
Testing the trigger function 55
Viewing existing triggers 56
Summary 57
Chapter 4: Understanding Database Design Concepts 58
Basic design rules 58
The ability to solve the problem The ability to hold the required data The ability to support relationships The ability to impose data integrity The ability to impose data efficiency The ability to accommodate future changes 58
59
59
59
59
59
Normalization 60
Anomalies in DBMS 60
[ ii ]
First normal form 62
Second normal form 62
Third normal form 63
Common patterns 64
Many-to-many relationships 64
Hierarchy 65
Recursive relationships 66
Summary 67
Chapter 5: Transactions and Locking 68
Defining transactions 68
ACID rules 69
Effect of concurrency on transactions 70
Transactions and savepoints 70
Transaction isolation 71
Implementing isolation levels 72
Dirty reads 72
Non-repeatable reads 73
Phantom reads 74
ANSI isolation levels 74
Transaction isolation levels 75
Changing the isolation level 75
Using explicit and implicit transactions 76
Avoiding deadlocks 76
Explicit locking 77
Locking rows 77
Locking tables 78
Summary 79
Chapter 6: Indexes and Constraints 81
Introduction to indexes and constraints 81
Primary key indexes 82
Unique indexes 83
B-tree indexes 84
Standard indexes 85
Full text indexes 86
Partial indexes 86
Multicolumn indexes 88
Hash indexes 89
GIN and GiST indexes 89
Clustering on an index 90
Foreign key constraints 91
[ iii ]
Unique constraints 92
Check constraints 94
NOT NULL constraints 95
Exclusion constraints 96
Summary 96
Chapter 7: Table Partitioning 97
Table partitioning 97
Partition implementation 102
Partitioning types 107
List partition 107
Managing partitions 109
Adding a new partition 109
Purging an old partition 110
Alternate partitioning methods 111
Method 1 111
Method 2 112
Constraint exclusion 114
Horizontal partitioning 116
PL/Proxy 117
Foreign inheritance 118
Summary 121
Chapter 8: Query Tuning and Optimization 122
Query tuning 122
Hot versus cold cache 123
Cleaning the cache 124
pg_buffercache 127
pg_prewarm 129
Optimizer settings for cached data 130
Multiple ways to implement a query 132
Bad query performance with stale statistics 134
Optimizer hints 136
Explain Plan 141
Generating and reading the Explain Plan 141
Simple example 142
More complex example 142
Query operators 143
Seq Scan 143
Index Scan 143
Sort 144
Unique 144
[ iv ]
LIMIT 144
Aggregate 144
Append 144
Result 144
Nested Loop 145
Merge Join 145
Hash and Hash Join 145
Group 145
Subquery Scan and Subplan 145
Tid Scan 145
Materialize 146
Setop 146
Summary 146
Chapter 9: PostgreSQL Extensions and Large Object Support 147
Creating an extension 147
Compiling extensions 149
Database links in PostgreSQL 150
Using binary large objects 153
Creating a large object 154
Importing a large object 154
Exporting a large object 155
Writing data to a large object 155
Server-side functions 155
Summary 156
Chapter 10: Using PHP in PostgreSQL 157
Postgres with PHP 157
PHP-to-PostgreSQL connections 158
Dealing with DDLs 161
DML operations 162
pg_query_params 163
pg_insert 164
Data retrieval 165
pg_fetch_all 165
pg_fetch_assoc 166
pg_fetch_result 167
Helper functions to deal with data fetching 168
pg_free_results 168
pg_num_rows 168
[ v ]
pg_num_fields 168
pg_field_name 168
pg_meta_data 168
pg_convert 169
UPDATE 171
DELETE 172
COPY 172
Summary 174
Chapter 11: Using Java in PostgreSQL 175
Making database connections to PostgreSQL using Java 175
Using Java to create a PostgreSQL table 178
Using Java to insert records into a PostgreSQL table 179
Using Java to update records into a PostgreSQL table 180
Using Java to delete records into a PostgreSQL table 181
Catching exceptions 182
Using prepared statements 184
Loading data using COPY 184
Connection properties 186
Summary 187
Index 188