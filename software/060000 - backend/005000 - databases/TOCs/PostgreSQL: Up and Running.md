Table of Contents
Preface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ix
1. 2. The Basics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1
Where to Get PostgreSQL 1
Notable PostgreSQL Forks 1
Administration Tools 2
What’s New in Latest Versions of PostgreSQL? 3
Why Upgrade? 4
What to Look for in PostgreSQL 9.2 4
PostgreSQL 9.1 Improvements 5
Database Drivers 5
Server and Database Objects 6
Where to Get Help 8
Database Administration . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 9
Configuration Files 9
The postgresql.conf File 10
The pg_hba.conf File 12
Reload the Configuration Files 14
Setting Up Groups and Login Roles (Users) 14
Creating an Account That Can Log In 15
Creating Group Roles 15
Roles Inheriting Rights 15
Databases and Management 16
Creating and Using a Template Database 16
Organizing Your Database Using Schemas 16
Permissions 17
Extensions and Contribs 18
Installing Extensions 19
Common Extensions 21
Backup 22
iii
3. 4. Selective Backup Using pg_dump 23
Systemwide Backup Using pg_dumpall 24
Restore 24
Terminating Connections 24
Using psql to Restore Plain Text SQL backups 25
Using pg_restore 26
Managing Disk Space with Tablespaces 27
Creating Tablespaces 27
Moving Objects Between Tablespaces 27
Verboten 27
Delete PostgreSQL Core System Files and Binaries 28
Giving Full Administrative Rights to the Postgres System (Daemon) Ac-
count 28
Setting shared_buffers Too High 29
Trying to Start PostgreSQL on a Port Already in Use 29
psql . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 31
Interactive psql 31
Non-Interactive psql 32
Session Configurations 33
Changing Prompts 34
Timing Details 35
AUTOCOMMIT 35
Shortcuts 36
Retrieving Prior Commands 36
psql Gems 36
Executing Shell Commands 37
Lists and Structures 37
Importing and Exporting Data 38
Basic Reporting 39
Using pgAdmin . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 43
Getting Started 43
Overview of Features 43
Connecting to a PostgreSQL server 44
Navigating pgAdmin 44
pgAdmin Features 45
Accessing psql from pgAdmin 45
Editing postgresql.conf and pg_hba.conf from pgAdmin 47
Creating Databases and Setting Permissions 47
Backup and Restore 48
pgScript 51
Graphical Explain 54
iv | Table of Contents
Job Scheduling with pgAgent 55
Installing pgAgent 55
Scheduling Jobs 56
Helpful Queries 57
5. 6. Data Types . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 59
Numeric Data Types 59
Serial 59
Generate Series Function 60
Arrays 60
Array Constructors 60
Referencing Elements in An Array 61
Array Slicing and Splicing 61
Character Types 62
String Functions 63
Splitting Strings into Arrays, Tables, or Substrings 63
Regular Expressions and Pattern Matching 64
Temporal Data Types 65
Time Zones: What It Is and What It Isn’t 66
Operators and Functions for Date and Time Data Types 68
XML 70
Loading XML Data 70
Querying XML Data 70
Custom and Composite Data Types 71
All Tables Are Custom 71
Building Your Own Custom Type 71
Of Tables, Constraints, and Indexes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 73
Tables 73
Table Creation 73
Multi-Row Insert 75
An Elaborate Insert 75
Constraints 77
Foreign Key Constraints 77
Unique Constraints 78
Check Constraints 78
Exclusion Constraints 79
Indexes 79
PostgreSQL Stock Indexes 79
Operator Class 81
Functional Indexes 81
Partial Indexes 82
Multicolumn Indexes 82
Table of Contents | v
7. 8. 9. SQL: The PostgreSQL Way . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 85
SQL Views 85
Window Functions 87
Partition By 88
Order By 89
Common Table Expressions 90
Standard CTE 91
Writeable CTEs 92
Recursive CTE 92
Constructions Unique to PostgreSQL 93
DISTINCT ON 93
LIMIT and OFFSET 94
Shorthand Casting 94
ILIKE for Case Insensitive Search 94
Set Returning Functions in SELECT 95
Selective DELETE, UPDATE, and SELECT from Inherited Tables 95
RETURNING Changed Records 96
Composite Types in Queries 96
Writing Functions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 99
Anatomy of PostgreSQL Functions 99
Function Basics 99
Trusted and Untrusted Languages 100
Writing Functions with SQL 101
Writing PL/pgSQL Functions 103
Writing PL/Python Functions 103
Basic Python Function 104
Trigger Functions 105
Aggregates 107
Query Performance Tuning . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 111
EXPLAIN and EXPLAIN ANALYZE 111
Writing Better Queries 113
Overusing Subqueries in SELECT 114
Avoid SELECT * 116
Make Good Use of CASE 116
Guiding the Query Planner 118
Strategy Settings 118
How Useful Is Your Index? 118
Table Stats 120
Random Page Cost and Quality of Drives 120
Caching 121
vi | Table of Contents
10. Replication and External Data . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 123
Replication Overview 123
Replication Lingo 123
PostgreSQL Built-in Replication Advancements 124
Third-Party Replication Options 125
Setting Up Replication 125
Configuring the Master 125
Configuring the Slaves 126
Initiate the Replication Process 127
Foreign Data Wrappers (FDW) 127
Querying Simple Flat File Data Sources 128
Querying More Complex Data Sources 128
Appendix: Install, Hosting, and Command-Line Guides . . . . . . . . . . . . . . . . . . . . . . . . . . . . 131
Table of Contents | vii