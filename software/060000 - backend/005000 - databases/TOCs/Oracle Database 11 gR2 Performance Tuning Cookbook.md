Table of Contents
Preface 1
7
7
12
17
20
23
28
29
32
36
41
41
42
48
54
59
65
71
79
83
84
89
96
Chapter 1: Starting with Performance Tuning Introduction Reviewing the performance tuning process Exploring the example database Acquiring data using a data dictionary and dynamic performance views Analyzing data using Statspack reports Diagnosing performance issues using the alert log Analyzing data using Automatic Workload Repository (AWR) Analyzing data using Automatic Database Diagnostic Monitor (ADDM) A working example Chapter 2: Optimizing Application Design Introduction Optimizing connection management Improving performance sharing reusable code Reducing the number of requests to the database using stored procedures Reducing the number of requests to the database using sequences Reducing the number of requests to the database using materialized views Optimizing performance with schema denormalization Avoiding dynamic SQL Chapter 3: Optimizing Storage Structures 83
Introduction Avoiding row chaining Avoiding row migration Using LOBs Using index clusters
103
Using hash clusters 109
Indexing the correct way
113
Table of Contents
Rebuilding index 123
Compressing indexes
128
Using reverse key indexes 130
Using bitmap indexes 136
Migrating to index organized tables
142
Using partitioning 146
Chapter 4: Optimizing SQL Code 153
Introduction 153
Using bind variables
154
Avoiding full table scans 164
Exploring index lookup 173
Exploring index skip-scan and index range-scan
177
Introducing arrays and bulk operations
181
Optimizing joins 187
Using subqueries 192
Tracing SQL activity with SQL Trace and TKPROF 201
Chapter 5: Optimizing Sort Operations 207
Introduction 207
Sorting—in-memory and on-disk 208
Sorting and indexing
215
Writing top n queries and ranking
224
Using count, min/max, and group-by 232
Avoiding sorting in set operations: union, minus, and intersect 240
Troubleshooting temporary tablespaces 248
Chapter 6: Optimizing PL/SQL Code 253
Introduction 253
Using bind variables and parsing 254
Array processing and bulk-collect 257
Passing values with NOCOPY (or not) 262
Using short-circuit IF statements 266
Avoiding recursion 269
Using native compilation 271
Taking advantage of function result cache 276
Inlining PL/SQL code 281
Using triggers and virtual columns 284
Chapter 7: Improving the Oracle Optimizer 291
Introduction 291
Exploring optimizer hints 292
Collecting statistics 298
Using histograms 305
ii
Table of Contents
Managing stored outlines 310
Introducing Adaptive Cursor Sharing for bind variable peeking 317
Creating SQL Tuning Sets 327
Using the SQL Tuning Advisor 331
Configuring and using SQL Baselines 335
Chapter 8: Other Optimizations 341
Introduction 341
Caching results with the client-side result cache 342
Enabling parallel SQL 346
Direct path inserting 351
Using create table as select 355
Inspecting indexes and triggers overhead 359
Loading data with SQL*Loader and Data Pump 366
Chapter 9: Tuning Memory 375
Introduction 375
Tuning memory to avoid Operating System paging 376
Tuning the Library Cache 384
Tuning the Shared Pool 388
Tuning the Program Global Area and the User Global Area 396
Tuning the Buffer Cache 400
Chapter 10: Tuning I/O 411
Introduction 411
Tuning at the disk level and strategies to distribute Oracle files 412
Striping objects across multiple disks
419
Choosing different RAID levels for different Oracle files 422
Using asynchronous I/O 425
Tuning checkpoints 428
Tuning redo logs 433
Chapter 11: Tuning Contention 437
Introduction 437
Detecting and preventing lock contention 438
Investigating transactions and concurrency 444
Tuning latches 452
Tuning resources to minimize latch contention 457
Minimizing latches using bind variables 460
Appendix A: Dynamic Performance Views 469
ALL_OBJECTS 469
DBA_BLOCKERS 470
DBA_DATA_FILES 470
iii
Table of Contents
DBA_EXTENTS 471
DBA_INDEXES
471
DBA_SQL_PLAN_BASELINES 472
DBA_TABLES 472
DBA_TEMP_FILES
473
DBA_VIEWS 474
DBA_WAITERS
474
INDEX_STATS 474
DBA_SEQUENCES 475
DBA_TABLESPACES
476
DBA_TAB_HISTOGRAMS 476
V$ADVISOR_PROGRESS
477
V$BUFFER_POOL_STATISTICS 477
V$CONTROLFILE
478
V$DATAFILE 478
V$DB_CACHE_ADVICE 479
V$DB_OBJECT_CACHE 480
V$ENQUEUE_LOCK 480
V$FILESTAT 481
V$FIXED_TABLE 482
V$INSTANCE_RECOVERY 482
V$LATCH 483
V$LATCH_CHILDREN 483
V$LIBRARYCACHE 484
V$LOCK 485
V$LOCKED_OBJECT 486
V$LOG 486
V$LOG_HISTORY 487
V$LOGFILE 488
V$MYSTAT 488
V$PROCESS 489
V$ROLLSTAT 489
V$ROWCACHE 490
V$SESSION 490
V$SESSION_EVENT 491
V$SESSTAT 492
V$SGA 492
V$SGAINFO 493
V$SHARED_POOL_RESERVED 493
V$SORT_SEGMENT 494
V$SQL 494
iv
Table of Contents
V$SQL_PLAN 495
V$SQLAREA 496
V$STATNAME 496
V$SYSSTAT 497
V$SYSTEM_EVENT 498
V$TEMPFILE 498
V$TEMPSTAT 499
V$WAITSTAT 499
X$BH 500
Appendix B: A Summary of Oracle Packages
Used for Performance Tuning 501
DBMS_ADDM 501
DBMS_ADVISOR 502
DBMS_JOB 502
DBMS_LOB 503
DBMS_MVIEW 503
DBMS_OUTLN 503
DBMS_OUTLN_EDIT 504
DBMS_SHARED_POOL 504
DBMS_SPACE 505
DBMS_SPM 505
DBMS_SQL 505
DBMS_SQLTUNE 506
DBMS_STATS 506
DBMS_UTILITY 507
DBMS_WORKLOAD_REPOSITORY 507
Index 509