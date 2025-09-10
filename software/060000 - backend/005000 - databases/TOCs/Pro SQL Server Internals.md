and ignore all my chores and duties!
Contents at a Glance
About the Author                                                  xxiii
About the Technical Reviewers                                       .xxv
Acknowledgments                                                .xxvii
Introduction                                                      xxix
■Part I: Tables and Indexes                                   1
■Chapter 1: Data Storage Internals                                     . 3
■Chapter 2: Tables and Indexes: Internal Structure and Access Methods        31
■Chapter 3: Statistics                                                55
■Chapter 4: Special Indexing and Storage Features                       . 81
■Chapter 5: SQL Server 2016 Features                                  111
■Chapter 6: Index Fragmentation                                      141
■Chapter 7: Designing and Tuning the Indexes                          . 155
■Part II: Other Things That Matter                            179
■Chapter 8: Constraints                                            . 181
■Chapter 9: Triggers                                                195
■Chapter 10: Views                                               . 213
■Chapter 11: User-Defi ned Functions                                   227
■Chapter 12: XML and JSON                                          241
■Chapter 13: Temporary Objects and TempDB                            269
v
■ CONTENTS AT A GLANCE
■Chapter 14: CLR                                                 . 293
■Chapter 15: CLR Types                                            . 311
■Chapter 16: Data Partitioning                                        335
■Part III: Locking, Blocking, and Concurrency                 . 379
■Chapter 17: Lock Types and Transaction Isolation Levels                 . 381
■Chapter 18: Troubleshooting Blocking Issues                          . 395
■Chapter 19: Deadlocks                                             407
■Chapter 20: Lock Escalation                                         423
■Chapter 21: Optimistic Isolation Levels                               . 433
■Chapter 22: Application Locks                                      . 443
■Chapter 23: Schema Locks                                          447
■Chapter 24: Designing Transaction Strategies                           457
■Part IV: Query Life Cycle                                 . 461
■Chapter 25: Query Optimization and Execution                         . 463
■Chapter 26: Plan Caching                                           491
■Part V: Practical Troubleshooting                          . 517
■Chapter 27: Extended Events                                       . 519
■Chapter 28: System Troubleshooting                                 . 545
■Chapter 29: Query Store                                            581
■Part VI: Inside the Transaction Log                         . 597
■Chapter 30: Transaction Log Internals                                 599
■Chapter 31: Backup and Restore                                    . 615
■Chapter 32: High Availability Technologies                            . 637
vi
■ CONTENTS AT A GLANCE
■Part VII: Columnstore Indexes                              657
■Chapter 33: Column-Based Storage and Batch Mode Execution            . 659
■Chapter 34: Columnstore Indexes                                   . 687
■Part VIII: In-Memory OLTP Engine                          . 715
■Chapter 35: In-Memory OLTP Internals                               . 717
■Chapter 36: Transaction Processing in In-Memory OLTP                   753
■Chapter 37: In-Memory OLTP Programmability                         . 771
Index                                                           . 793
vii
Contents
About the Author                                                  xxiii
About the Technical Reviewers                                       .xxv
Acknowledgments                                                .xxvii
Introduction                                                      xxix
■Part I: Tables and Indexes                                   1
■Chapter 1: Data Storage Internals                                     . 3
Database Files and Filegroups                                             . 3
Data Pages and Data Rows                                                 8
Large Objects Storage                                                    14
Row-Overfl ow Storage                                                              14
LOB Storage                                                                       16
SELECT * and I/O                                                        17
Extents and Allocation Map Pages                                         . 19
Data Modifi cations                                                     . 21
Much Ado about Data Row Size                                           . 23
Table Alteration                                                        . 25
Summary                                                              28
■Chapter 2: Tables and Indexes: Internal Structure and Access Methods        31
Heap Tables                                                            31
Clustered Indexes                                                      . 36
Composite Indexes                                                     . 45
ix
■ CONTENTS
Nonclustered Indexes                                                   . 46
Summary                                                              52
■Chapter 3: Statistics                                                55
Introduction to SQL Server Statistics                                       . 55
Column-Level Statistics                                                 . 58
Statistics and Execution Plans                                            . 62
Statistics and Query Memory Grants                                         65
Statistics Maintenance                                                  . 68
New Cardinality Estimator (SQL Server 2014–2016)                             69
Comparing Cardinality Estimators: Up-to-Date Statistics                                   . 71
Comparing Cardinality Estimators: Outdated Statistics                                      73
Comparing Cardinality Estimators: Indexes with Ever-Increasing
Key Values                                                                        75
Comparing Cardinality Estimators: Joins                                                 76
Comparing Cardinality Estimators: Multiple Predicates                                     77
Choosing the Model                                                                 78
Query Optimizer Hotfi xes and Trace Flag T4199                               . 79
Summary                                                              80
■Chapter 4: Special Indexing and Storage Features                       . 81
Indexes with Included Columns                                           . 81
Filtered Indexes                                                         87
Filtered Statistics                                                      . 90
Calculated Columns                                                      93
Data Compression                                                       97
Row Compression                                                                 . 98
Page Compression                                                                 102
Performance Considerations                                                         104
Sparse Columns                                                      . 106
Summary                                                             110
x
■ CONTENTS
■Chapter 5: SQL Server 2016 Features                                  111
Temporal Tables                                                      . 111
Stretch Databases                                                      118
Confi guring Stretch Database                                                       . 119
Querying Stretch Databases                                                        . 121
Stretch Database Pricing                                                            125
Row-Level Security                                                     126
Performance Impact                                                              . 128
Blocking Modifi cations                                                            . 130
Always Encrypted                                                     . 132
Always Encrypted Overview                                                        . 133
Programmability                                                                 . 134
Security Considerations and Key Management                                           135
Dynamic Data Masking                                                  136
Performance and Security Considerations                                             . 137
Combining Security Features                                            . 140
Summary                                                             140
■Chapter 6: Index Fragmentation                                      141
Types of Fragmentation                                                  141
FILLFACTOR and PAD_INDEX                                              145
Index Maintenance                                                    . 146
Designing an Index Maintenance Strategy                                  . 146
Patterns That Increase Fragmentation                                     . 148
Summary                                                             153
■Chapter 7: Designing and Tuning the Indexes                          . 155
Clustered Index Design Considerations                                      155
Identities, Sequences, and Uniqueidentifi ers                                           . 160
Nonclustered Index Design Considerations                                   165
xi
■ CONTENTS
Optimizing and Tuning Indexes                                          . 168
Detecting Unused and Ineffi cient Indexes                                               168
Index Consolidation                                                                172
Detecting Suboptimal Queries                                                        174
Summary                                                             178
■Part II: Other Things That Matter                            179
■Chapter 8: Constraints                                            . 181
Primary Key Constraints                                                . 181
Unique Constraints                                                    . 183
Foreign Key Constraints                                                . 184
Check Constraints                                                      188
Wrapping Up                                                         . 192
Summary                                                             193
■Chapter 9: Triggers                                                195
DML Triggers                                                          195
DDL Triggers                                                         . 204
Logon Triggers                                                         206
UPDATE() and COLUMNS_UPDATED() Functions                               207
Nested and Recursive Triggers                                           . 208
First and Last Triggers                                                   209
CONTEXT_INFO and SESSION_CONTEXT                                     209
Summary                                                             212
■Chapter 10: Views                                               . 213
Views                                                                213
Indexed (Materialized) Views                                             219
Partitioned Views                                                       224
Updatable Views                                                      . 224
Summary                                                             225
xii
■ CONTENTS
■Chapter 11: User-Defi ned Functions                                   227
Much Ado About Code Reuse                                            . 227
Multi-Statement Functions                                              . 229
Inline Table-Valued Functions                                           . 235
Summary                                                             240
■Chapter 12: XML and JSON                                          241
To Use or Not to Use XML or JSON? That Is the Question!                      . 241
XML Data Type                                                         243
Working with XML Data                                                             250
OPENXML                                                                        260
SELECT FOR XML                                                                  261
Working with JSON Data (SQL Server 2016)                                  262
SELECT FOR JSON                                                                 263
Built-In Functions                                                                . 264
OPENJSON                                                                       265
Summary                                                             267
■Chapter 13: Temporary Objects and TempDB                            269
Temporary Tables                                                     . 269
Table Variables                                                       . 276
User-Defi ned Table Types and Table-Valued Parameters                       . 281
Regular Tables in TempDB                                                287
Optimizing TempDB Performance                                         . 289
Summary                                                             291
■Chapter 14: CLR                                                 . 293
CLR Integration Overview                                               . 293
Security Considerations                                                . 295
Performance Considerations                                              299
Summary                                                             309
xiii
■ CONTENTS
■Chapter 15: CLR Types                                            . 311
User-Defi ned CLR Types                                                . 311
Spatial Data Types                                                      319
HierarchyId                                                          . 328
Summary                                                             334
■Chapter 16: Data Partitioning                                        335
Reasons to Partition Data                                               . 335
When to Partition?                                                      337
Data Partitioning Techniques                                              337
Partitioned Tables                                                                . 338
Partitioned Views                                                                  342
Comparing Partitioned Tables and Partitioned Views                                     . 348
Using Partitioned Tables and Views Together                                           . 349
Tiered Storage                                                         352
Moving Non-Partitioned Tables Between Filegroups                                       353
Moving Partitions Between Filegroups                                                . 356
Moving Data Files Between Disk Arrays                                               . 362
Tiered Storage in Action                                                           . 364
Tiered Storage and High Availability Technologies                                       . 367
Implementing Sliding Window Scenario and Data Purge                       . 367
Potential Issues                                                        369
Summary                                                             377
■Part III: Locking, Blocking, and Concurrency                 . 379
■Chapter 17: Lock Types and Transaction Isolation Levels                 . 381
Transactions and ACID                                                   382
Major Lock Types                                                       382
Exclusive (X) Locks                                                               . 383
Intent (I*) Locks                                                                   383
Update (U) Locks                                                                 . 384
xiv
■ CONTENTS
Shared (S) Locks                                                                 . 386
Lock Compatibility, Behavior, and Lifetime                                  . 387
Transaction Isolation Levels and Data Consistency                             392
Summary                                                             393
■Chapter 18: Troubleshooting Blocking Issues                          . 395
General Troubleshooting Approach                                        . 395
Troubleshooting Blocking Issues in Real Time                               . 396
Collecting Blocking Information for Further Analysis                          . 400
Summary                                                             405
■Chapter 19: Deadlocks                                             407
Classic Deadlock                                                       407
Deadlock Due to Nonoptimized Queries                                    . 408
Key Lookup Deadlock                                                  . 410
Deadlock Due to Multiple Updates of the Same Row                          . 411
Deadlock Troubleshooting                                                416
Reducing the Chance of Deadlocks                                         420
Summary                                                             422
■Chapter 20: Lock Escalation                                         423
Lock Escalation Overview                                                423
Lock Escalation Troubleshooting                                           427
Summary                                                             432
■Chapter 21: Optimistic Isolation Levels                               . 433
Row Versioning Overview                                               . 433
Optimistic Transaction Isolation Levels                                      434
READ COMMITTED SNAPSHOT Isolation Level                                            434
SNAPSHOT Isolation Level                                                           435
Version Store Behavior                                                 . 440
Summary                                                             442
xv
■ CONTENTS
■Chapter 22: Application Locks                                      . 443
Application Locks Overview                                             . 443
Application Locks Usage                                                 443
Summary                                                             446
■Chapter 23: Schema Locks                                          447
Schema Modifi cation Locks                                             . 447
Multiple Sessions and Lock Compatibility                                    449
Lock Partitioning                                                       452
Low-Priority Locks                                                    . 454
Summary                                                             456
■Chapter 24: Designing Transaction Strategies                           457
Considerations and Code Patterns                                        . 457
Choosing Transaction Isolation Level                                      . 459
Summary                                                             460
■Part IV: Query Life Cycle                                 . 461
■Chapter 25: Query Optimization and Execution                         . 463
Query Life Cycle                                                      . 463
Query Optimization                                                    . 464
Query Execution                                                      . 468
Operators                                                             473
Joins                                                                          . 474
Aggregates                                                                     . 477
Spools                                                                         . 479
Parallelism                                                                       481
Query and Table Hints                                                   485
INDEX Table Hint                                                                 . 485
FORCE ORDER Hint                                                               . 487
LOOP, MERGE, and HASH JOIN Hints                                                  . 487
FORCESEEK/FORCESCAN Hints                                                      . 487
xvi
■ CONTENTS
NOEXPAND/EXPAND VIEWS Hints                                                      487
FAST N Hints                                                                    . 488
Summary                                                             488
■Chapter 26: Plan Caching                                           491
Plan Caching Overview                                                 . 491
Parameter Sniffi ng                                                    . 493
Plan Reuse                                                          . 499
Plan Caching for Ad-Hoc Queries                                         . 503
Auto-Parameterization                                                 . 505
Plan Guides                                                           506
Plan Cache Internals                                                    511
Examining Plan Cache                                                   513
Summary                                                             515
■Part V: Practical Troubleshooting                          . 517
■Chapter 27: Extended Events                                       . 519
Extended Events Overview                                              . 519
Extended Events Objects                                                 520
Packages                                                                        520
Events                                                                         . 521
Predicates                                                                      . 523
Actions                                                                          525
Types and Maps                                                                   526
Targets                                                                          527
Creating Events Sessions                                               . 530
Working with Event Data                                                 531
Working with the ring_buffer Target                                                  . 532
Working with event_fi le and asynchronous_fi le_target Targets                              533
Working with event_counter and synchronous_event_counter Targets                        535
Working with histogram, synchronous_ bucketizer, and asynchronous_ bucketizer Targets      . 536
Working with the pair_matching Target                                               . 538
xvii
■ CONTENTS
System_health and AlwaysOn_Health Sessions                               539
Using Extended Events                                                 . 540
Detecting Expensive Queries                                                         540
Monitoring Page Split Events                                                         542
Extended Events in Azure SQL Databases                                    543
Summary                                                             544
■Chapter 28: System Troubleshooting                                 . 545
Looking at the Big Picture                                                545
Hardware and Network                                                            . 546
Operating System Confi guration                                                     . 547
SQL Server Confi guration                                                          . 547
Database Options                                                                . 548
Resource Governor Overview                                            . 550
SQL Server Execution Model                                              551
Wait Statistics Analysis and Troubleshooting                                . 556
I/O Subsystem and Nonoptimized Queries                                             . 557
Parallelism                                                                       562
Memory-Related Wait Types                                                        . 563
High CPU Load                                                                    565
Locking and Blocking                                                             . 566
Worker Thread Starvation                                                          . 567
ASYNC_NETWORK_IO Waits                                                        . 568
Latches and Spinlocks                                                              569
Wait Statistics: Wrapping Up                                                       . 572
Memory Management and Confi guration                                   . 574
Memory Confi guration                                                              574
Memory Allocation                                                                 575
What to Do When the Server Is Not Responding                               576
Working with Baseline                                                  578
Summary                                                             579
xviii
■ CONTENTS
■Chapter 29: Query Store                                            581
Why Query Store?                                                     . 581
Query Store Confi guration                                                582
Query Store Internals                                                  . 583
Usage Scenarios                                                      . 586
Working with Query Store in SSMS                                                    587
Working with Query Store from T-SQL                                                  591
Managing and Monitoring Query Store                                      595
Summary                                                             596
■Part VI: Inside the Transaction Log                         . 597
■Chapter 30: Transaction Log Internals                                 599
Data Modifi cations, Logging, and Recovery                                 . 599
Delayed Durability                                                      604
Virtual Log Files                                                        605
Database Recovery Models                                               607
TempDB Logging                                                       610
Excessive Transaction Log Growth                                        . 610
Transaction Log Management                                             612
Summary                                                             613
■Chapter 31: Backup and Restore                                    . 615
Database Backup Types                                                . 615
Backing Up the Database                                               . 616
Restoring the Database                                                  618
Restore to a Point in Time                                                          . 619
Restore with STANDBY                                                            . 621
Designing a Backup Strategy                                            . 622
Partial Database Availability and Piecemeal Restore                          . 626
Partial Database Backup                                                 630
xix
■ CONTENTS
Microsoft Azure Integration                                               632
Backup to Microsoft Azure                                                           632
Managed Backup to Microsoft Azure                                                   633
File Snapshot Backup for Database Files in Azure                                       . 633
Summary                                                             635
■Chapter 32: High Availability Technologies                            . 637
SQL Server Failover Cluster                                              637
Database Mirroring and AlwaysOn Availability Groups                         . 641
Technologies Overview                                                            . 641
Database Mirroring: Automatic Failover and Client Connectivity                              644
AlwaysOn Availability Groups                                                        646
Log Shipping                                                          648
Replication                                                          . 649
Designing a High Availability Strategy                                       651
Summary                                                             654
■Part VII: Columnstore Indexes                              657
■Chapter 33: Column-Based Storage and Batch Mode Execution            . 659
Data Warehouse Systems Overview                                       . 659
Columnstore Indexes and Batch Mode Execution Overview                      662
Column-Based Storage and Batch Mode Execution                                      . 663
Columnstore Indexes and Batch Mode Execution in Action                                  665
Column-Based Storage                                                  673
Storage Format                                                                  . 673
Compression and Storage Size                                                      . 675
Metadata                                                                        677
Design Considerations and Best Practices for Columnstore Indexes              . 681
Reducing Data Row Size                                                          . 681
Giving SQL Server as Much Information as Possible                                       681
Maintaining Statistics                                                             . 681
Avoiding String Columns in Fact Tables                                                 682
Summary                                                             684
xx
■ CONTENTS
■Chapter 34: Columnstore Indexes                                   . 687
Columnstore Index Types                                               . 687
Read-Only Nonclustered Columnstore Indexes
(SQL Server 2012–2014)                                                 688
Clustered Columnstore Indexes (SQL Server 2014–2016)                      . 691
Internal Structure                                                                . 691
Data Load                                                                      . 693
Delta Store and Delete Bitmap                                                      . 694
Columnstore Index Maintenance                                                      698
Nonclustered B-Tree Indexes (SQL Server 2016)                                          702
Updateable Nonclustered Columnstore Indexes
(SQL Server 2016)                                                      706
Metadata                                                             709
sys.column_store_row_groups (SQL Server 2014–2016)                                   709
sys.dm_db_column_store_row_group_physical_stats (SQL Server 2016)                    . 710
sys.internal_partitions (SQL Server 2016)                                               710
sys.dm_db_column_store_row_group_operational_stats (SQL Server 2016)                  . 711
Design Considerations                                                   711
Summary                                                             712
■Part VIII: In-Memory OLTP Engine                          . 715
■Chapter 35: In-Memory OLTP Internals                               . 717
Why In-Memory OLTP?                                                 . 717
In-Memory OLTP Engine Architecture and Data Structures                       718
Memory-Optimized Tables                                                           720
High Availability Technology Support                                                   721
Data Row Structure                                                                722
Hash Indexes                                                                     723
Nonclustered (Range) Indexes                                                        728
Hash Indexes Versus Nonclustered Indexes                                            . 735
Statistics on Memory-Optimized Tables                                               . 735
Memory Consumers and Off-Row Storage                                             . 736
xxi
■ CONTENTS
Columnstore Indexes (SQL Server 2016)                                                740
Garbage Collection                                                               . 743
Data Durability and Recovery                                            . 744
SQL Server 2016 Features Support                                         748
Memory Usage Considerations                                          . 748
Summary                                                             750
■Chapter 36: Transaction Processing in In-Memory OLTP                   753
Transaction Isolation Levels and Data Consistency                             753
Transaction Isolation Levels in In-Memory OLTP                               754
Cross-Container Transactions                                             759
Transaction Lifetime                                                   . 760
Referential Integrity Enforcement (SQL Server 2016)                           765
Transaction Logging                                                   . 766
Summary                                                             769
■Chapter 37: In-Memory OLTP Programmability                         . 771
Native Compilation                                                    . 771
Natively-Compiled Modules                                             . 775
Optimization of Natively-Compiled Modules                                            . 776
Creating Natively-Compiled Stored Procedures                                         . 776
Natively-Compiled Triggers and User-Defi ned Functions
(SQL Server 2016)                                                                . 779
Supported T-SQL Features                                                           782
Execution Statistics                                                                784
Interpreted T-SQL and Memory-Optimized Tables                              786
Memory-Optimized Table Types and Variables                               . 786
In-Memory OLTP: Implementation Considerations                            . 788
Summary                                                             790
Index                                                           . 793
xxii