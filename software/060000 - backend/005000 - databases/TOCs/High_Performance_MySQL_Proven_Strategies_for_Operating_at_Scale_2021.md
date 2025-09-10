Table of Contents
Foreword. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . xiii
Preface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . xv
1. MySQL Architecture. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1
MySQL’s Logical Architecture 1
Connection Management and Security 2
Optimization and Execution 3
Concurrency Control 3
Read/Write Locks 4
Lock Granularity 4
Transactions 6
Isolation Levels 8
Deadlocks 9
Transaction Logging 10
Transactions in MySQL 11
Multiversion Concurrency Control 13
Replication 15
Datafiles Structure 16
The InnoDB Engine 16
JSON Document Support 17
Data Dictionary Changes 17
Atomic DDL 18
Summary 18
2. Monitoring in a Reliability Engineering World. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . The Impact of Reliability Engineering on DBA Teams 19
20
Defining Service Level Goals 20
v
What Does It Take to Make Customers Happy? 22
What to Measure 23
Defining SLIs and SLOs 23
Monitoring Solutions 24
Monitoring Availability 25
Monitoring Query Latency 27
Monitoring for Errors 27
Proactive Monitoring 29
Measuring Long-Term Performance 36
Learning Your Business Cadence 36
Tracking Your Metrics Effectively 37
Using Monitoring Tools to Inspect the Performance 37
Using SLOs to Guide Your Overall Architecture 38
Summary 39
3. Performance Schema. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 41
Introduction to Performance Schema 41
Instrument Elements 42
Consumer Organization 44
Resource Consumption 45
Limitations 46
sys Schema 46
Understanding Threads 46
Configuration 48
Enabling and Disabling Performance Schema 48
Enabling and Disabling Instruments 48
Enabling and Disabling Consumers 50
Tuning Monitoring for Specific Objects 51
Tuning Threads Monitoring 51
Adjusting Memory Size for Performance Schema 52
Defaults 53
Using Performance Schema 53
Examining SQL Statements 53
Examining Read Versus Write Performance 62
Examining Metadata Locks 63
Examining Memory Usage 64
Examining Variables 66
Examining Most Frequent Errors 70
Examining Performance Schema Itself 71
Summary 73
vi | Table of Contents
5. 4. Operating System and Hardware Optimization. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 75
What Limits MySQL’s Performance? 75
How to Select CPUs for MySQL 76
Balancing Memory and Disk Resources 76
Caching, Reads, and Writes 76
What’s Your Working Set? 77
Solid-State Storage 78
An Overview of Flash Memory 78
Garbage Collection 79
RAID Performance Optimization 79
RAID Failure, Recovery, and Monitoring 81
RAID Configuration and Caching 83
Network Configuration 86
Choosing a Filesystem 87
Choosing a Disk Queue Scheduler 89
Memory and Swapping 90
Operating System Status 92
Other Helpful Tools 95
Summary 96
Optimizing Server Settings. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 99
How MySQL’s Configuration Works 100
Syntax, Scope, and Dynamism 101
Persisted System Variables 103
Side Effects of Setting Variables 103
Planning Your Variable Changes 104
What Not to Do 105
Creating a MySQL Configuration File 106
Minimal Configuration 107
Inspecting MySQL Server Status Variables 108
Configuring Memory Usage 109
Per-Connection Memory Needs 109
Reserving Memory for the Operating System 109
The InnoDB Buffer Pool 110
The Thread Cache 111
Configuring MySQL’s I/O Behavior 112
The InnoDB Transaction Log 113
Log Buffer 113
The InnoDB Tablespace 115
Other I/O Configuration Options 118
Configuring MySQL Concurrency 119
Safety Settings 120
Table of Contents | vii
6. 7. Advanced InnoDB Settings 122
Summary 124
Schema Design and Management. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 125
Choosing Optimal Data Types 126
Whole Numbers 127
Real Numbers 127
String Types 128
Date and Time Types 135
Bit-Packed Data Types 136
JSON Data 139
Choosing Identifiers 142
Special Types of Data 144
Schema Design Gotchas in MySQL 145
Too Many Columns 145
Too Many Joins 145
The All-Powerful ENUM 145
The ENUM in Disguise 146
NULL Not Invented Here 146
Schema Management 146
Schema Management as Part of the Data Store Platform 147
Summary 154
Indexing for High Performance. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 155
Indexing Basics 156
Types of Indexes 156
Benefits of Indexes 161
Indexing Strategies for High Performance 162
Prefix Indexes and Index Selectivity 162
Multicolumn Indexes 165
Choosing a Good Column Order 167
Clustered Indexes 170
Covering Indexes 178
Using Index Scans for Sorts 180
Redundant and Duplicate Indexes 182
Unused Indexes 185
Index and Table Maintenance 186
Finding and Repairing Table Corruption 186
Updating Index Statistics 187
Reducing Index and Data Fragmentation 188
Summary 189
viii | Table of Contents
9. 8. Query Performance Optimization. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 191
Why Are Queries Slow? 191
Slow Query Basics: Optimize Data Access 192
Are You Asking the Database for Data You Don’t Need? 192
Is MySQL Examining Too Much Data? 194
Ways to Restructure Queries 198
Complex Queries Versus Many Queries 198
Chopping Up a Query 199
Join Decomposition 200
Query Execution Basics 201
The MySQL Client/Server Protocol 202
Query States 204
The Query Optimization Process 205
The Query Execution Engine 217
Returning Results to the Client 218
Limitations of the MySQL Query Optimizer 219
UNION Limitations 219
Equality Propagation 220
Parallel Execution 220
SELECT and UPDATE on the Same Table 220
Optimizing Specific Types of Queries 221
Optimizing COUNT() Queries 221
Optimizing JOIN Queries 223
Optimizing GROUP BY with ROLLUP 223
Optimizing LIMIT and OFFSET 223
Optimizing SQL_CALC_FOUND_ROWS 225
Optimizing UNION 225
Summary 226
Replication. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 227
Replication Overview 227
How Replication Works 229
Replication Under the Hood 230
Choosing Replication Format 230
Global Transaction Identifiers 231
Making Replication Crash Safe 232
Delayed Replication 233
Multithreaded Replication 234
Semisynchronous Replication 237
Replication Filters 237
Replication Failover 239
Planned Promotions 239
Table of Contents | ix
10. Unplanned Promotions 240
Trade-Offs of Promotion 240
Replication Topologies 241
Active/Passive 241
Active/Read Pool 242
Discouraged Topologies 244
Replication Administration and Maintenance 247
Monitoring Replication 247
Measuring Replication Lag 248
Determining Whether Replicas Are Consistent with the Source 249
Replication Problems and Solutions 251
Binary Logs Corrupted on the Source 251
Nonunique Server IDs 251
Undefined Server IDs 252
Missing Temporary Tables 252
Not Replicating All Updates 252
Excessive Replication Lag 252
Oversized Packets from the Source 254
No Disk Space 254
Replication Limitations 254
Summary 255
Backup and Recovery. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 257
Why Backups? 258
Defining Recovery Requirements 259
Designing a MySQL Backup Solution 260
Online or Offline Backups? 261
Logical or Raw Backups? 263
What to Back Up 265
Incremental and Differential Backups 266
Replication 268
Managing and Backing Up Binary Logs 269
Backup and Recovery Tools 269
MySQL Enterprise Backup 269
Percona XtraBackup 270
mydumper 270
mysqldump 270
Backing Up Data 270
Logical SQL Backups 270
Filesystem Snapshots 272
Percona XtraBackup 278
Recovering from a Backup 281
x | Table of Contents
11. 12. 13. Restoring Logical Backups 282
Restoring Raw Files from Snapshot Restoring with Percona XtraBackup 284
Starting MySQL After Restoring Raw Files 283
285
Summary 286
Scaling MySQL. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 287
What Is Scaling? 287
Read- Versus Write-Bound Workloads 289
Understanding Your Workload 289
Read-Bound Workloads 290
Write-Bound Workloads 291
Functional Sharding 291
Scaling Reads with Read Pools 292
Managing Configuration for Read Pools 294
Health Checks for Read Pools 295
Choosing a Load-Balancing Algorithm 297
Queuing 298
Scaling Writes with Sharding 299
Choosing a Partitioning Scheme 300
Multiple Partitioning Keys 302
Querying Across Shards 302
Vitess 303
ProxySQL 306
Summary 311
MySQL in the Cloud. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 313
Managed MySQL 313
Amazon Aurora for MySQL 314
GCP Cloud SQL 317
MySQL on Virtual Machines 318
Machine Types in Cloud 318
Choosing the Right Machine Type 319
Choosing the Right Disk Type 320
Additional Tips 322
Summary 324
Compliance with MySQL. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . What Is Compliance? 326
Service Organization Controls Type 2 Sarbanes–Oxley Act 326
Payment Card Industry Data Security Standard 325
326
327
Table of Contents | xi
A. B. Health Insurance Portability and Accountability Act 327
Federal Risk and Authorization Management Program 327
General Data Protection Regulation 327
Schrems II 328
Building for Compliance Controls 328
Secrets Management 329
Separation of Roles and Data 332
Tracking Changes 333
Backup and Restore Procedures 338
Summary 341
Upgrading MySQL. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 343
MySQL on Kubernetes. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 349
Index. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 353