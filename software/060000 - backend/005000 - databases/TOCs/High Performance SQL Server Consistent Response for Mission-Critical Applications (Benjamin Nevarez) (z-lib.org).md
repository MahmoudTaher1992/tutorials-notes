Table of Contents
About the Author                          xiii
About the Technical Reviewer                      xv
Acknowledgments                           xvii
Introduction                             xix
Part I: SQL Server Internals                  1
Chapter 1:   How SQL Server Works                      3
TDS/Network Protocols                             4
How Work Is Performed                              6
SQLOS                                   6
Schedulers                                  7
Workers                                  9
SQL Server on Linux                            13
Query Optimization                                14
Parsing and Binding                            18
Simplification                               22
Trivial Plan Optimization                            25
Transformation Rules                             26
The Memo                                 37
Full Optimization                                39
Cost Estimation                                46
Statistics                                   49
Plan Caching                                52
v
Table of Contents
Query Execution                                54
Operators                                  54
Data Access Operators                           56
Aggregations                                 57
Joins                                   58
Parallelism                                59
Updates                                   60
Memory Grants                                60
Locks and Latches                              62
Summary                                   64
Chapter 2:   SQL Server on Linux                     67
Microsoft Announcements                           67
A Bit of History                                 69
SQLOS                                     70
Project Helsinki                                 71
Drawbridge                                   73
SQLPAL                                     76
Summary                                   78
Part II: Design and Configuration               79
Chapter 3:   SQL Server Configuration                   81
Statistics Update                               82
Standard Automatic Statistics Update                       85
Trace Flag 2371                                85
tempdb Configuration                               86
Query Optimizer Hotfix Servicing Model                        86
max degree of parallelism                           88
cost threshold for parallelism                            92
Instant File Initialization                             93
vi
Table of Contents
Cardinality Estimator                               95
optimize for ad hoc workloads                            96
SQL Server Enterprise Edition                          97
Memory Configuration                              98
Lock Pages in Memory                             100
backup compression default                          101
query governor cost limit                            101
blocked process threshold                             102
Advanced Trace Flags                             103
Configuring SQL Server on Linux                        104
Using Environment Variables                           109
Performance Best Practices                            111
Memory and the Out-of-Memory Killer                     111
Kernel Settings                                112
Additional Configurations                           118
Summary                                 119
Chapter 4:   tempdb Troubleshooting and Configuration             121
DML Contention                               122
Describing tempdb Latch Contention                     126
Fixing tempdb Latch Contention                        128
Using Multiple Data Files                           128
Trace Flags 1117 and 1118                            129
SQL Server 2016 Enhancements                        130
What Is New in SQL Server 2019                        133
Memory-Optimized tempdb Metadata                      133
tempdb Events                               138
DDL Contention                                 144
vii
Table of Contents
tempdb Spill Warnings                             144
Sort Warning                                 145
Hash Warning                              146
Exchange Warning                              147
Monitoring Disk Space                             147
Summary                                 149
Part III: Monitoring                     151
Chapter 5:   Analyzing Wait Statistics                   153
Introduction                                  154
Wait Information                               161
sys.dm_os_wait_stats                            161
sys.dm_exec_session_wait_stats                      166
Extended Events                              166
system_health Extended Event Session                     170
Example: Analyzing CXPACKET Waits                         173
Latches and Spinlocks                            177
Common Waits                               179
CXPACKET                                  180
CXCONSUMER                               180
PAGELATCH_* and PAGEIOLATCH_*                      180
ASYNC_NETWORK_IO                            180
SOS_SCHEDULER_YIELD                            181
THREADPOOL                                181
PREEMPTIVE_*                               181
OLEDB                                  182
IO_COMPLETION                             182
WRITELOG                                  182
Timer Wait Types                               182
What Is New on SQL Server 2019                          184
Blocking                                   185
viii
Table of Contents
In-Memory OLTP                                 186
Summary                                 187
Chapter 6:   The Query Store                       189
Why Is a Query Slow?                             189
Plan Changes                                 190
How the Query Store Can Help                          191
Plan Regressions                             192
SQL Server Upgrades                           192
Application/Hardware Changes                        193
Identify Expensive Queries                         193
Identify Ad Hoc Workloads                           193
Architecture                                194
Enabling, Purging, and Disabling the Query Store                  197
Using the Query Store                              204
Performance Troubleshooting                          211
Incomplete Queries                               214
Force Failure                                  218
Wait Statistics                                221
Catalog Views                                  224
Live Query Statistics                               226
Summary                                 229
Part IV: Performance Tuning and Troubleshooting         231
Chapter 7:   SQL Server In-Memory Technologies             233
In-Memory OLTP                                 234
Enhancements After the Initial Release                      237
Memory-Optimized Tables                           238
Indexes                                  242
Natively Compiled Modules                           245
Changing Tables and Natively Compiled Modules                 247
Native Compilation                            250
ix
Table of Contents
Memory-Optimized Table Variables                        252
Current Limitations                             253
Columnstore Indexes                              254
Examples                                257
Operational Analytics                              263
Using Disk-Based Tables                            267
Using Memory-Optimized Tables                       270
Summary                                 274
Chapter 8:   Performance Troubleshooting                  275
Performance Counters                            276
Comparing Batches and Transactions                       278
Log Growths                                282
Data File(s) Size (KB)                            284
Page Reads/Sec                             284
Page Writes/Sec                             285
Page Life Expectancy                           285
Buffer Cache Hit Ratio                             286
% Processor Time                               286
Processor Queue Length                            288
Latches                                   288
Locks                                  288
LogicalDisk and PhysicalDisk                         289
SQL Compilations/Sec and Recompilations/Sec                   289
Memory Grants                                290
Processes Blocked                            290
Log Flush Counters                             290
Checkpoint Pages/Sec                           291
Memory Manager                              291
sys.dm_os_performance_counters                      292
Dynamic Management Views and Functions                     293
sys.dm_io_virtual_file_stats                         293
x
Table of Contents
sys.dm_os_volume_stats                            296
sys.dm_db_index_usage_stats                         296
sys.dm_exec_query_stats                         298
sys.dm_db_index_physical_stats                       299
sys.dm_exec_query_optimizer_info                      301
sys.dm_os_sys_info                              302
sys.dm_os_windows_info                           303
sys.dm_os_host_info                           304
SQL Trace/Extended Events                          304
SQL Server Data Collector                           306
Operator-Level Performance Statistics                        308
Trace Flags on Plans                               309
Summary                                 310
Chapter 9:   Indexing                        311
How SQL Server Uses Indexes                          312
Where to Use Indexes                            315
Index Usage Validation                            317
Index Maintenance                            319
Heaps                                 320
Clustered Indexes                               321
Nonclustered Indexes                            322
Filtered Indexes                              323
Working with Indexes                               324
The Missing Indexes Feature                           335
The Database Engine Tuning Advisor                        338
Summary                                 347
Chapter 10:   Intelligent Query Processing                349
Batch Mode Adaptive Joins                            350
Memory Grant Feedback                             353
Interleaved Execution                               355
xi
Table of Contents
Batch Mode on Rowstore                            359
Table Variable Deferred Compilation                       360
Scalar UDF Inlining                                361
Approximate Count Distinct                          362
Summary                                 363
Chapter 11:   SQL Server Storage                    365
Storage Types                                  367
Flash-Based Storage                             368
Database Configuration                            369
Database Files                              370
Fragmentation                                371
Virtual Log Files                               372
Compression                                 373
Metrics and Performance                             373
Resource Monitor                              375
Diskspd                                   376
SQLIOSim                                379
DMVs/DMFs                                 381
Volume Configuration                               381
RAID Levels                                 382
RAID 0                                  382
RAID 1                                  383
RAID 5                                  384
RAID 6                                  385
RAID 10                                   385
Query Processing                               386
Summary                                 387
Index                              389