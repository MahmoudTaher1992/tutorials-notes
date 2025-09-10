Table of Contents
Preface
1
An Introduction to Query Tuning and Optimization
Query Processor Architecture 20
Warnings on execution plans 47
Parsing and binding 22
Getting plans from a trace or
Query optimization 23
the plan cache 53
Generating candidate execution plans 23
sys.dm_exec_query_plan DMF 53
Plan cost evaluation 24
SQL Trace/Profiler 54
Query execution and plan caching 24
Extended events 57
Analyzing execution plans 26
Removing plans from the plan cache 59
Graphical plans 27
SET STATISTICS TIME and
XML plans 34
IO statements 60
Text plans 37
Summary 62
Plan properties 39
2
Troubleshooting Queries
query_hash and plan_hash 74
DMVs and DMFs 66
Finding expensive queries 76
sys.dm_exec_requests and sys.dm_
exec_sessions Sys.dm_exec_query_stats Understanding statement_start_offset
and statement_end_offset sql_handle and plan_handle 66
68
72
73
Blocking and waits SQL Trace Extended events Mapping SQL Trace events to
extended events Working with extended events 88
78
80
84
87
viii
Table of Contents
The Data Collector 101
Querying the Data Collector tables 106
Configuration 101
Using the Data Collector 104
Summary 108
3
The Query Optimizer
Query optimization research 110
Joins 131
Introduction to query
Transformation rules 134
processing 111
The Memo 147
The sys.dm_exec_query_
Statistics 154
optimizer_info DMV 113
Full optimization 156
Parsing and binding 119
Search 0 158
Simplification 122
Search 1 158
Contradiction detection 123
Search 2 160
Foreign Key Join elimination 126
Summary 163
Trivial plan optimization 130
4
The Execution Engine
Data access operators 166
Nested Loops Join 181
Scans 166
Merge Join 183
Seeks 169
Hash Join 186
Bookmark lookup 170
Parallelism 187
Aggregations 175
The exchange operator 189
Sorting and hashing 175
Limitations 194
Stream Aggregate 176
Updates 196
Hash Aggregate 178
Per-row and per-index plans 198
Distinct Sort 180
Halloween protection 200
Joins 181
Summary 202
Table of Contents ix
Introduction to indexes 204
The Database Engine
Creating indexes 205
Tuning Advisor 220
Clustered indexes versus
Tuning a workload using the
heaps 210
plan cache 223
Clustered index key 213
Offload of tuning overhead to test
Covering indexes 214
server 224
Filtered indexes 215
Missing indexes 230
Understanding index
Index fragmentation 233
operations 217
Unused indexes 235
Summary 237
5
Working with Indexes
6
Understanding Statistics
7
In-Memory OLTP
In-memory OLTP
architecture 286
Exploring statistics 240
Statistics on computed
Creating and updating statistics 240
Inspecting statistics objects 243
columns 264
Filtered statistics 267
The density vector 246
Statistics on ascending keys 270
Histograms 249
Trace flag 2389 273
A new cardinality
estimator 253
Trace flag 4137 258
UPDATE STATISTICS
with ROWCOUNT and
PAGECOUNT 277
Cardinality estimation
Statistics maintenance 280
errors 259
Cost estimation 283
Incremental statistics 261
Summary 284
Tables and indexes 288
x
Table of Contents
Creating in-memory OLTP tables 289
Hash indexes 295
Nonclustered or range indexes 299
Natively compiled stored
procedures 305
8
Understanding Plan Caching
Batch compilation and
recompilation 316
Exploring the plan cache 320
How to remove plans from
memory 322
Understanding
parameterization 323
Autoparameterization 324
The Optimize for Ad Hoc
Workloads option 325
Forced parameterization 327
Stored procedures 328
9
The Query Store
Using the Query Store 352
Querying the Query Store 357
10
Intelligent Query Processing
Overview of intelligent query
processing 362
Creating natively compiled stored
procedures 305
Inspecting DLLs 307
Limitations and later
enhancements 310
Summary 313
Parameter sniffing 330
Optimizing for a typical
parameter 332
Optimizing on every execution 333
Local variables and the OPTIMIZE
FOR UNKNOWN hint 334
Disabling parameter sniffing 336
Parameter sniffing and SET options
affecting plan reuse 337
Parameter-sensitive plan
optimization 344
Summary 350
Summary 359
Parameter-sensitive plan optimization 363
Memory grant feedback 363
Table of Contents xi
Persistence and percentile 364
Cardinality estimation
feedback 370
Degree of parallelism
feedback 373
11
An Introduction to Data Warehouses
12
Understanding Query Hints
Breaking down complex
queries 402
OR logic in the WHERE clause 403
Joins on aggregated datasets 406
Hints 407
When to use hints 408
Types of hints 409
Joins 410
Aggregations 414
Interleaved execution 374
Table variable deferred
compilation 376
Adaptive joins 378
Summary 380
Data warehouses 382
Batch mode processing 391
Star join query optimization 384
Creating columnstore indexes 392
Columnstore indexes 388
Hints 398
Performance benefits 390
Summary 400
FORCE ORDER 415
The INDEX, FORCESCAN,
and FORCESEEK hints 420
FAST N 423
The NOEXPAND and
EXPAND VIEWS hints 424
Plan guides 426
USE PLAN 429
Summary 431
Index
Other Books You May Enjoy