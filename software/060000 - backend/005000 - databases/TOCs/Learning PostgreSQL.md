Table of Contents
Preface xi
Chapter 1: Relational Databases 1
Database management systems 1
A brief history 2
Database categories 3
The NoSQL databases 3
The CAP theorem 3
NoSQL motivation 4
Key value databases 4
Columnar databases 4
Document databases 5
Graph databases 5
Relational and object relational databases 5
ACID properties 6
The SQL Language 6
Basic concepts 7
Relation 7
Tuple 8
Attribute 9
Constraint 10
Relational algebra 14
The SELECT and PROJECT operations 16
The RENAME operation 18
The Set theory operations 18
The CROSS JOIN (Cartesian product) operation 19
Data modeling 21
Data model perspectives 22
[ i ]
Table of Contents
The entity-relation model 22
Sample application 23
Entities, attributes, and keys 24
Mapping ER to Relations 28
UML class diagrams 29
Summary 29
Chapter 2: PostgreSQL in Action 31
An overview of PostgreSQL 31
PostgreSQL history 31
The advantages of PostgreSQL 32
Business advantages of PostgreSQL 32
PostgreSQL user advantages 33
PostgreSQL applications 33
Success stories 34
Forks 35
PostgreSQL architecture 36
PostgreSQL abstract architecture 36
The PostgreSQL community 38
PostgreSQL capabilities 38
Replication 38
Security 39
Extension 39
NoSQL capabilities 41
Foreign data wrapper 42
Performance 42
Very rich SQL constructs 43
Installing PostgreSQL 43
Installing PostgreSQL on Ubuntu 44
Client installation 44
Server installation 45
Basic server configuration 47
Installing PostgreSQL on Windows 48
The PostgreSQL clients 50
The psql client 51
PostgreSQL utility tools 58
Backup and replication 58
Utilities 59
PgAdmin III 59
Summary 60
[ ii ]
Table of Contents
Chapter 3: PostgreSQL Basic Building Blocks 61
Database coding 61
Database naming conventions 61
PostgreSQL identifiers 62
Documentation 63
Version control system 63
PostgreSQL objects hierarchy 64
Template databases 65
User databases 66
Roles 69
Tablespace 70
Template procedural languages 71
Settings 71
Setting parameters 71
Setting a context 72
PostgreSQL high-level object interaction 74
PostgreSQL database components 75
Schema 75
Schema usages 76
Table 77
PostgreSQL native data types 78
Numeric types 79
Character types 81
Date and time types 86
The car web portal database 90
Summary 93
Chapter 4: PostgreSQL Advanced Building Blocks 95
Views 95
View synopsis 98
Views categories 99
Materialized views 100
Updatable views 102
Indexes 104
Index types 108
Partial indexes 108
Indexes on expressions 109
Unique indexes 110
Multicolumn indexes 111
Best practices on indexes 112
[ iii ]
Table of Contents
Functions 114
PostgreSQL native programming languages 114
Creating a function in the C language 115
Creating functions in the SQL language 117
Creating a function in the PL/pgSQL language 117
PostgreSQL function usages 118
PostgreSQL function dependency 118
PostgreSQL function categories 119
PostgreSQL anonymous functions 121
PostgreSQL user-defined data types 122
The PostgreSQL CREATE DOMAIN command 122
The PostgreSQL CREATE TYPE command 124
Triggers and rule systems 127
The PostgreSQL rule system 128
The PostgreSQL trigger system 131
Triggers with arguments 135
Using triggers to make views updatable 138
Summary 141
Chapter 5: SQL Language 143
SQL fundamentals 144
SQL lexical structure 145
Querying the data with the SELECT statement 149
The structure of the SELECT query 150
Select-list 152
SQL expressions 153
DISTINCT 158
FROM clause 159
Selecting from multiple tables 160
Self-joins 166
WHERE clause 167
Comparison operators 168
Pattern matching 169
Row and array comparison constructs 170
Grouping and aggregation 172
GROUP BY clause 172
HAVING clause 175
Ordering and limiting the results 176
Subqueries 178
Set operations – UNION, EXCEPT, and INTERSECT 180
Dealing with NULLs 182
[ iv ]
Table of Contents
Changing the data in the database 184
INSERT statement 184
UPDATE statement 186
UPDATE using sub-select 186
UPDATE using additional tables 187
DELETE statement 188
TRUNCATE statement 189
Summary 189
Chapter 6: Advanced Query Writing 191
Common table expressions 191
Reusing SQL code with CTE 193
Recursive and hierarchical queries 196
Changing data in multiple tables at a time 201
Window functions 204
Window definition 205
The WINDOW clause 207
Using window functions 207
Window functions with grouping and aggregation 211
Advanced SQL 212
Selecting the first records 212
Set returning functions 213
Lateral subqueries 216
Advanced usage of aggregating functions 219
Transaction isolation and multiversion concurrency control 222
Summary 226
Chapter 7: Server-Side Programming with PL/pgSQL 227
Introduction 227
SQL language and PL/pgSQL – a comparison 228
PostgreSQL function parameters 229
Function authorization-related parameters 229
Function planner-related parameters 231
Function configuration-related parameters 235
The PostgreSQL PL/pgSQL control statements 236
Declaration statements 237
Assignment statements 239
Conditional statements 242
Iteration 246
The loop statement 246
The while loop statement 247
The for loop statement 248
[ v ]
Table of Contents
Returning from the function 250
Returning void 250
Returning a single row 250
Returning multiple rows 251
Function predefined variables 253
Exception handling 254
Dynamic SQL 257
Executing DDL statements in dynamic SQL 257
Executing DML statements in dynamic SQL 258
Dynamic SQL and the caching effect 258
Recommended practices when using dynamic SQL 259
Summary 262
Chapter 8: PostgreSQL Security 263
Authentication in PostgreSQL 263
PostgreSQL pg_hba.conf 264
Listen addresses 265
Authentication best practices 266
PostgreSQL default access privileges 267
Role system and proxy authentication 271
PostgreSQL security levels 272
Database security level 273
Schema security level 274
Table-level security 275
Column-level security 275
Row-level security 276
Encrypting data 276
PostgreSQL role password encryption 276
pgcrypto 277
One-way encryption 278
Two-way encryption 280
Summary 283
Chapter 9: The PostgreSQL System Catalog and System
Administration Functions 285
The system catalog 285
Getting the database cluster and client tools version 289
Getting ready 289
How to do it… 289
There's more… 290
[ vi ]
Table of Contents
Terminating and canceling user sessions 290
Getting ready 290
How to do it… 290
How it works… 291
There's more… 291
Setting and getting database cluster settings 291
Getting ready 291
How to do it… 292
There's more… 293
Getting the database and database object size 293
Getting ready 294
How to do it… 294
There's more… 294
Cleaning up the database 295
Getting ready 295
How to do it… 296
There's more… 297
Cleaning up data in the database 298
Getting ready 298
How to do it… 299
There's more… 300
Managing database locks 301
Adding missing indexes on foreign keys and altering
the default statistic 303
Getting ready 303
How to do it… 303
Getting the views dependency tree 304
Getting ready 304
How to do it… 304
There's more… 308
Summary 308
Chapter 10: Optimizing Database Performance 311
PostgreSQL configuration tuning 312
Maximum number of connections 312
Memory settings 312
Hard disk settings 313
Planner-related settings 314
Benchmarking is your friend 314
[ vii ]
Table of Contents
Tuning PostgreSQL queries 315
The EXPLAIN command and execution plan 316
Detecting problems in query plans 319
Common mistakes in writing queries 320
Unnecessary operations 320
Misplaced indexes 322
Unnecessary table or index scans 324
Using correlated nested queries 325
Using CTE when not mandatory 325
Using the PL/pgSQL procedural language consideration 326
Cross column correlation 326
Table partitioning 328
Constraint exclusion limitations 331
Summary 331
Chapter 11: Beyond Conventional Data types 333
PostgreSQL arrays 334
Common functions of arrays and their operators 339
Modifying and accessing arrays 340
Indexing arrays in PostgreSQL 342
Hash store 342
Modifying and accessing an hstore 344
Indexing an hstore in PostgreSQL 345
The PostgreSQL JSON data type 346
JSON and XML 347
The JSON data type 347
Modifying and accessing JSON types 347
Indexing a JSON data type 350
The PostgreSQL RESTful API with JSON 351
A PostgreSQL full text search 356
The tsquery and tsvector data types 357
The tsvector data type 357
The tsquery data type 358
Pattern matching 358
Full text search indexing 360
Summary 361
Chapter 12: Testing 363
Unit testing 364
Unit testing in databases 364
Unit test frameworks 368
Schema difference 370
[ viii ]
Table of Contents
The interfaces test 372
Data difference 373
PostgreSQL benchmarks 376
Summary 378
Chapter 13: PostgreSQL JDBC 379
Introduction to JDBC 379
Connecting to a PostgreSQL database 380
Installing the driver 380
Initializing the driver 381
Obtaining a connection 381
Error handling 383
SQLWarnings 383
Issuing a query and processing the results 384
Static statements 384
PreparedStatements 385
Using a ResultSet 387
Navigating through a ResultSet 387
Reading row data 388
Handling null values 388
Scrollable and updateable ResultSets 389
Using cursors 391
Getting information about the table structure 392
Function handling 393
Calling a stored function 393
Getting a ResultSet from a stored function 394
Getting a ResultSet from a function returning SETOF 394
Getting a ResultSet from a function returning a refcursor 395
Design considerations 395
Summary 396
Chapter 14: PostgreSQL and Hibernate 397
Introduction to ORM and Hibernate 397
Hibernate overview and architecture 398
Installation and configuration 398
Installation of Hibernate 399
Configuring Hibernate 399
Getting a session from the SessionFactory 400
Mapping classes to tables 401
Creating an entity class 402
Creating a mapping file 402
Using annotation-based mapping 404
[ ix ]
Table of Contents
Working with entities 405
States of an entity 405
Making a new entity persistent 406
Loading an entity from the database 407
Loading a list of entries 408
Named queries 409
Creating dynamic queries 410
Modifying entities 411
Deleting entities 412
Using association mapping 412
One-to-many and many-to-one mappings 412
One-to-one mapping and component mapping 415
Many-to-many mapping 416
Fetching strategies 417
Configuring the fetch type 418
Configuring the fetch mode 418
Tuning the performance of Hibernate 419
Using caching 420
Using connection pools 421
Dealing with partitioned tables 423
Summary 424
Index 425