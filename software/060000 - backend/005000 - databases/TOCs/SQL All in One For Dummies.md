Contents at a Glance
Introduction                 1
Book I: SQL Concepts              7
Chapter 1: Understanding Relational Databases               9
Chapter 2: Modeling a System                       29
Chapter 3: Getting to Know SQL                      51
Chapter 4: SQL and the Relational Model                  63
Chapter 5: Knowing the Major Components of SQL              73
Chapter 6: Drilling Down to the SQL Nitty-Gritty               95
Book II: Relational Database Development     125
Chapter 1: System Development Overview                 127
Chapter 2: Building a Database Model                   143
Chapter 3: Balancing Performance and Correctness             161
Chapter 4: Creating a Database with SQL                 193
Book III: SQL Queries             205
Chapter 1: Values, Variables, Functions, and Expressions          207
Chapter 2: SELECT Statements and Modifying Clauses            231
Chapter 3: Querying Multiple Tables with Subqueries            275
Chapter 4: Querying Multiple Tables with Relational Operators        303
Chapter 5: Cursors                           323
Book IV: Data Security            335
Chapter 1: Protecting Against Hardware Failure and External Threats     337
Chapter 2: Protecting Against User Errors and Confl icts           367
Chapter 3: Assigning Access Privileges                  395
Chapter 4: Error Handling                        407
Book V: SQL and Programming         423
Chapter 1: Database Development Environments              425
Chapter 2: Interfacing SQL to a Procedural Language            431
Chapter 3: Using SQL in an Application Program              437
Chapter 4: Designing a Sample Application                451
Chapter 5: Building an Application                    469
Chapter 6: Understanding SQL’s Procedural Capabilities           485
Chapter 7: Connecting SQL to a Remote Database             501
Book VI: SQL and XML            515
Chapter 1: Using XML with SQL                     517
Chapter 2: Storing XML Data in SQL Tables                541
Chapter 3: Retrieving Data from XML Documents              561
Book VII: Database Tuning Overview       577
Chapter 1: Tuning the Database                     579
Chapter 2: Tuning the Environment                    591
Chapter 3: Finding and Eliminating Bottlenecks               611
Book VIII: Appendices            641
Appendix A: SQL:2008 Reserved Words                  643
Appendix B: Glossary                          651
Index                  661
Table of Contents
Introduction                 1
About This Book                        1
Foolish Assumptions                      2
Conventions Used in This Book                  2
What You Don’t Have to Read                   3
How This Book Is Organized                   3
Book I: SQL Concepts                    3
Book II: Relational Database Development           3
Book III: SQL Queries                    4
Book IV: Data Security                   4
Book V: SQL and Programming                4
Book VI: SQL and XML                   4
Book VII: Database Tuning Overview             5
Book VIII: Appendices                   5
Icons Used in This Book                     5
Where to Go from Here                     6
Book I: SQL Concepts              7
Chapter 1: Understanding Relational Databases          9
Understanding Why Today’s Databases Are Better
Than Early Databases                     9
Irreducible complexity                   10
Managing data with complicated programs          10
Managing data with simple programs            12
Which type of organization is better?            13
Databases, Queries, and Database Applications          13
Making data useful                    13
Retrieving the data you want — and only the data you want   14
Examining Competing Database Models              15
Looking at the historical background
of the competing models                 15
The hierarchical database model              16
The network database model                20
The relational database model               20
Defi ning what makes a database relational        22
Protecting the defi nition of relational databases
with Codd’s Rules                 22
Highlighting the relational database model’s
inherent fl exibility                 25
xiv
SQL All-in-One For Dummies, 2nd Edition
The object-oriented database model             25
The object-relational database model            25
The nonrelational NoSQL model               26
Why the Relational Model Won                 26
Chapter 2: Modeling a System                 29
Capturing the Users’ Data Model                 29
Identifying and interviewing stakeholders          30
Reconciling confl icting requirements            30
Obtaining stakeholder buy-in                31
Translating the Users’ Data Model to a Formal
Entity-Relationship Model                   32
Entity-Relationship modeling techniques           32
Entities                       33
Attributes                      33
Identifi ers                      34
Relationships                    35
Drawing Entity-Relationship diagrams            38
Maximum cardinality                 38
Minimum cardinality                 38
Understanding advanced ER model concepts         41
Strong entities and weak entities            41
ID-dependent entities                 42
Supertype and subtype entities            43
Incorporating business rules              44
A simple example of an ER model              45
A slightly more complex example              46
Problems with complex relationships            50
Simplifying relationships using normalization         50
Translating an ER model into a relational model        50
Chapter 3: Getting to Know SQL                 51
Where SQL Came From                     51
Knowing What SQL Does                    52
The ISO/IEC SQL Standard                    53
Knowing What SQL Does Not Do                 53
Choosing and Using an Available DBMS Implementation       54
Microsoft Access                     55
Microsoft SQL Server                   59
IBM DB2                         59
Oracle Database                     59
Sybase SQL Anywhere                   60
MySQL                         60
PostgreSQL                       61
Table of Contents xv
Chapter 4: SQL and the Relational Model            63
Sets, Relations, Multisets, and Tables               63
Functional Dependencies                    64
Keys                             65
Views                            67
Users                            68
Privileges                           68
Schemas                           68
Catalogs                           69
Connections, Sessions, and Transactions             69
Routines                           70
Paths                             71
Chapter 5: Knowing the Major Components of SQL        73
Creating a Database with the Data Defi nition Language       73
The containment hierarchy                 74
Creating tables                      75
Specifying columns                    75
Creating other objects                   75
Views                        76
Schemas                      80
Domains                      81
Modifying tables                     82
Removing tables and other objects             82
Operating on Data with the Data Manipulation Language (DML)   83
Retrieving data from a database               83
Adding data to a table                   84
Adding data the dull and boring way (typing it in)    84
Adding incomplete records              85
Adding data in the fastest and most effi cient way:
Bypassing typing altogether             86
Updating data in a table                  87
Deleting data from a table                 90
Updating views doesn’t make sense             91
Maintaining Security in the Data Control Language (DCL)      92
Granting access privileges                 92
Revoking access privileges                 93
Preserving database integrity with transactions        93
Chapter 6: Drilling Down to the SQL Nitty-Gritty         95
Executing SQL Statements                    95
Interactive SQL                      96
Challenges to combining SQL with a host language       96
Embedded SQL                      97
Module language                     99
Using Reserved Words Correctly                100
xvi
SQL All-in-One For Dummies, 2nd Edition
SQL’s Data Types                       100
Exact numerics                     101
INTEGER                      101
SMALLINT                     102
BIGINT                       102
NUMERIC                     103
DECIMAL                      103
Approximate numerics                  103
REAL                       104
DOUBLE PRECISION                 104
FLOAT                       104
Character strings                    105
CHARACTER                    105
CHARACTER VARYING                105
CHARACTER LARGE OBJECT (CLOB)          105
NATIONAL CHARACTER, NATIONAL CHARACTER
VARYING, and NATIONAL CHARACTER
LARGE OBJECT                  106
Binary strings                      106
BINARY                      107
BINARY VARYING                  107
BINARY LARGE OBJECT (BLOB)            107
Booleans                        107
Datetimes                        107
DATE                       108
TIME WITHOUT TIME ZONE             108
TIME WITH TIME ZONE               108
TIMESTAMP WITHOUT TIME ZONE          109
TIMESTAMP WITH TIME ZONE            109
Intervals                        109
XML type                        110
ROW type                     110
Collection types                     111
ARRAY                      112
Multiset                      112
REF types                        113
User-defi ned types                    113
Distinct types                    114
Structured types                  114
Data type summary                   116
Handling Null Values                     117
Applying Constraints                     118
Column constraints                   118
NOT NULL                     119
UNIQUE                      119
CHECK                       119
Table constraints                    120
Foreign key constraints                  121
Assertions                       123
Table of Contents xvii
Book II: Relational Database Development     125
Chapter 1: System Development Overview           127
The Components of a Database System             127
The database                      128
The database engine                   128
The DBMS front end                   128
The database application                 129
The user                        129
The System Development Life Cycle               129
Defi nition phase                     130
Requirements phase                   131
The users’ data model                132
Statement of Requirements              133
Evaluation phase                     133
Determining project scope              134
Reassessing feasibility                135
Documenting the Evaluation phase          136
Design phase                      136
Designing the database               136
The database application               137
Documenting the Design phase            138
Implementation phase                  138
Final Documentation and Testing phase           139
Testing the system with sample data          139
Finalizing the documentation             140
Delivering the results (and celebrating)        140
Maintenance phase                    141
Chapter 2: Building a Database Model             143
Finding and Listening to Interested Parties            143
Your immediate supervisor                144
The users                        144
The standards organization                145
Upper management                   146
Building Consensus                      146
Gauging what people want                147
Arriving at a consensus                  147
Building a Relational Model                  148
Reviewing the three database traditions           148
Knowing what a relation is                149
Functional dependencies                 150
Keys                          151
Being Aware of the Danger of Anomalies             151
Eliminating anomalies                  152
Examining the higher normal forms             156
The Database Integrity versus Performance Tradeoff        157
xviii
SQL All-in-One For Dummies, 2nd Edition
Chapter 3: Balancing Performance and Correctness       161
Designing a Sample Database                  162
The ER model for Honest Abe’s              162
Converting an ER model into a relational model       163
Normalizing a relational model               164
Handling binary relationships               166
A sample conversion                   171
Maintaining Integrity                     174
Entity integrity                     174
Domain integrity                     175
Referential integrity                   176
Avoiding Data Corruption                   177
Speeding Data Retrievals                    179
Hierarchical storage                   179
Full table scans                     180
Working with Indexes                     181
Creating the right indexes                 181
Indexes and the ANSI/ISO Standard             182
Index costs                       182
Query type dictates the best index             182
Point query                    182
Multipoint query                  182
Range query                    183
Prefi x match query                 183
Extremal query                   183
Ordering query                   183
Grouping query                   184
Equi-join query                   184
Data structures used for indexes              184
Indexes, sparse and dense                 185
Index clustering                     186
Composite indexes                    186
Index effect on join performance              187
Table size as an indexing consideration           187
Indexes versus full table scans               187
Reading SQL Server Execution Plans               188
Robust execution plans                  188
A sample database                    189
A typical query                   190
The execution plan                 190
Running the Database Engine Tuning Advisor      191
Chapter 4: Creating a Database with SQL            193
First Things First: Planning Your Database            193
Building Tables                        194
Locating table rows with keys               195
Using the CREATE TABLE statement            196
Table of Contents xix
Setting Constraints                      198
Column constraints                   198
Table constraints                    198
Keys and Indexes                       198
Ensuring Data Validity with Domains              199
Establishing Relationships between Tables            199
Altering Table Structure                    202
Deleting Tables                        203
Book III: SQL Queries             205
Chapter 1: Values, Variables, Functions, and Expressions    207
Entering Data Values                     207
Row values have multiple parts              207
Identifying values in a column               208
Literal values don’t change                208
Variables vary                      209
Special variables hold specifi c values            210
Working with Functions                    211
Summarizing data with set functions            211
COUNT                      211
AVG                        212
MAX                        212
MIN                        212
SUM                        213
Dissecting data with value functions            213
String value functions                213
Numeric value functions               215
Datetime value functions               220
Using Expressions                      221
Numeric value expressions                221
String value expressions                 221
Datetime value expressions                222
Interval value expressions                 223
Boolean value expressions                224
Array value expressions                 224
Conditional value expressions               224
Handling different cases               225
The NULLIF special CASE               226
Bypassing null values with COALESCE         227
Converting data types with a CAST expression        227
Casting one SQL data type to another         228
Using CAST to overcome data type incompatibilities
between SQL and its host language         228
Row value expressions                  229
xx
SQL All-in-One For Dummies, 2nd Edition
Chapter 2: SELECT Statements and Modifying Clauses      231
Finding Needles in Haystacks with the SELECT Statement      231
Modifying Clauses                      232
FROM clauses                      232
WHERE clauses                     233
Comparison predicates               234
BETWEEN                     235
IN and NOT IN                   236
LIKE and NOT LIKE                 237
SIMILAR                      239
NULL                       239
ALL, SOME, and ANY                240
EXISTS                       243
UNIQUE                      243
DISTINCT                     244
OVERLAPS                     244
MATCH                      245
The MATCH predicate and referential integrity     246
Logical connectives                 248
GROUP BY clauses                    250
HAVING clauses                     252
ORDER BY clauses                    253
Tuning Queries                        255
SELECT DISTINCT                    255
Query analysis provided by SQL Server 2008 R2     256
Query analysis provided by MySQL 5         258
Temporary tables                    259
The ORDER BY clause                  265
The HAVING clause                    268
The OR logical connective                 272
Chapter 3: Querying Multiple Tables with Subqueries      275
What Is a Subquery?                      275
What Subqueries Do                      275
Subqueries that return multiple values           276
Subqueries that retrieve rows satisfying a condition   276
Subqueries that retrieve rows that don’t satisfy
a condition                    277
Subqueries that return a single value            278
Quantifi ed subqueries return a single value         280
Correlated subqueries                  283
Using a subquery as an existence test         283
Introducing a correlated subquery
with the IN keyword                284
Table of Contents xxi
Introducing a correlated subquery
with a comparison operator            285
Correlated subqueries in a HAVING clause       287
Using Subqueries in INSERT, DELETE, and UPDATE Statements   288
Tuning Considerations for Statements Containing Nested Queries  291
Tuning Correlated Subqueries                 297
Chapter 4: Querying Multiple Tables with Relational Operators  303
UNION                           303
UNION ALL                       305
UNION CORRESPONDING                 306
INTERSECT                         306
EXCEPT                           308
JOINS                            308
Cartesian product or cross join              309
Equi-join                        311
Natural join                       313
Condition join                      313
Column-name join                    314
Inner join                        315
Outer join                        316
Left outer join                   316
Right outer join                   318
Full outer join                   318
ON versus WHERE                      319
Join Conditions and Clustering Indexes             320
Chapter 5: Cursors                      323
Declaring a Cursor                      324
The query expression                  325
Ordering the query result set               325
Updating table rows                   327
Sensitive versus insensitive cursors            327
Scrolling a cursor                    328
Holding a cursor                     329
Declaring a result set cursor                329
Opening a Cursor                       329
Operating on a Single Row                   331
FETCH syntax                      331
Absolute versus relative fetches              332
Deleting a row                      332
Updating a row                     332
Closing a Cursor                       333
xxii
SQL All-in-One For Dummies, 2nd Edition
Book IV: Data Security            335
Chapter 1: Protecting Against Hardware Failure and
External Threats                       337
What Could Possibly Go Wrong?                337
Equipment failure                    338
Platform instability                    339
Database design fl aws                  340
Data-entry errors                    340
Operator error                      340
Taking Advantage of RAID                   341
Striping                         341
RAID levels                       342
RAID 0                       344
RAID 1                       344
RAID 5                       344
RAID 10                      345
Backing Up Your System                    345
Preparation for the worst                 345
Full or incremental backup                346
Frequency                       346
Backup maintenance                   347
Coping with Internet Threats                  347
Viruses                         348
Trojan horses                      349
Worms                         350
Denial-of-service attacks                 351
SQL injection attacks                   351
Chipping away at your wall of protection        351
Understanding SQL injection             351
Using a GET parameter                352
Recognizing unsafe confi gurations           359
Finding vulnerabilities on your site          359
Phishing scams                     362
Zombie spambots                    363
Installing Layers of Protection                 363
Network-layer fi rewalls                  364
Application-layer fi rewalls                 364
Antivirus software                    364
Vulnerabilities, exploits, and patches            364
Education                        365
Alertness                        365
Table of Contents xxiii
Chapter 2: Protecting Against User Errors and Confl icts     367
Reducing Data-Entry Errors                  367
Data types: The fi rst line of defense             368
Constraints: The second line of defense           368
Sharp-eyed humans: The third line of defense        368
Coping with Errors in Database Design              369
Handling Programming Errors                 369
Solving Concurrent-Operation Confl icts             370
Passing the ACID Test: Atomicity, Consistency, Isolation,
and Durability                       371
Operating with Transactions                  372
Using the SET TRANSACTION statement           372
Starting a transaction                   373
Access modes                   374
Isolation levels                   374
Committing a transaction                 376
Rolling back a transaction                 376
Why roll back a transaction?             377
The log fi le                     377
The write-ahead log protocol             378
Checkpoints                    379
Implementing deferrable constraints            379
Getting Familiar with Locking                  383
Two-phase locking                    384
Granularity                       384
Deadlock                        385
Tuning Locks                         386
Measuring performance with throughput          386
Eliminating unneeded locks                387
Shortening transactions                  387
Weakening isolation levels (ver-r-ry carefully)        387
Controlling lock granularity                388
Scheduling DDL statements correctly            388
Partitioning insertions                  389
Cooling hot spots                    389
Tuning the deadlock interval               389
Enforcing Serializability with Timestamps            390
Tuning the Recovery System                  392
Chapter 3: Assigning Access Privileges            395
Working with the SQL Data Control Language           395
Identifying Authorized Users                  395
Understanding user identifi ers               396
Creating roles                   397
Destroying roles                  397
Getting familiar with roles                 396
xxiv
SQL All-in-One For Dummies, 2nd Edition
Classifying Users                       397
Granting Privileges                      398
Looking at data                     399
Deleting data                      399
Adding data                       399
Changing data                      399
Referencing data in another table             400
Using certain database facilities              401
Responding to an event                  402
Defi ning new data types                  402
Executing an SQL statement                402
Doing it all                       402
Passing on the power                   403
Revoking Privileges                      403
Granting Roles                        405
Revoking Roles                        405
Chapter 4: Error Handling                   407
Identifying Error Conditions                  407
Getting to Know SQLSTATE                  408
Handling Conditions                      410
Handler declarations                   410
Handler actions and handler effects            411
Conditions that aren’t handled               412
Dealing with Execution Exceptions: The WHENEVER Clause    412
Getting More Information: The Diagnostics Area          413
The diagnostics header area                414
The diagnostics detail area                415
Examining an Example Constraint Violation            417
Adding Constraints to an Existing Table             418
Interpreting SQLSTATE Information               419
Handling Exceptions                     420
Book V: SQL and Programming         423
Chapter 1: Database Development Environments        425
Microsoft Access                       425
The Jet engine                      426
DAO                          426
ADO                          426
ODBC                         426
OLE DB                         427
Files with the mdb extension               427
The Access Database Engine                427
Table of Contents xxv
Microsoft SQL Server                     427
IBM DB2                           428
Oracle 11gR2                         428
SQL Anywhere                        429
PostgreSQL                         429
MySQL                           429
Chapter 2: Interfacing SQL to a Procedural Language      431
Building an Application with SQL and a Procedural Language    431
Access and VBA                     432
SQL Server and the NET languages             433
The ADOdb library                 432
The ADOX library                  433
Other libraries                   433
MySQL and C++ NET or C#                434
MySQL and C                      434
MySQL and Perl                     434
MySQL and PHP                     434
MySQL and Java                     435
Oracle SQL and Java                   435
DB2 and Java                      435
Chapter 3: Using SQL in an Application Program         437
Comparing SQL with Procedural Languages            437
Classic procedural languages               438
Object-oriented procedural languages           439
Nonprocedural languages                 439
Diffi culties in Combining SQL with a Procedural Language     440
Challenges of using SQL with a classical
procedural language                  440
Challenges of using SQL with an object-oriented
procedural language                  441
Contrasting operating modes             440
Data type incompatibilities              440
Embedding SQL in an Application                441
Embedding SQL in an Oracle Pro*C application       442
Declaring host variables               444
Converting data types                445
Embedding SQL in a Java application            445
Using SQL in a Perl application               445
Embedding SQL in a PHP application            445
Using SQL with a Visual Basic NET application        446
Using SQL with other NET languages            446
xxvi
SQL All-in-One For Dummies, 2nd Edition
Using SQL Modules with an Application             446
Module declarations                   447
Module procedures                   448
Modules in Oracle                    449
Chapter 4: Designing a Sample Application           451
Understanding the Client’s Problem               451
Approaching the Problem                   452
Interviewing the stakeholders               452
Drafting a detailed statement of requirements        453
Following up with a proposal               453
Determining the Deliverables                  454
Finding out what’s needed now and later          454
Planning for organization growth              455
Greater database needs               455
Increased need for data security           455
Growth in the example scenario            455
Nailing down project scope                456
Building an Entity-Relationship Model              457
Determining what the entities are             457
Relating the entities to one another             457
Relationships                    457
Maximum cardinality                458
Minimum cardinality                 458
Business rules                   459
Transforming the Model                    460
Eliminating any many-to-many relationships         460
Normalizing the ER model                 463
Creating Tables                        464
Changing Table Structure                   467
Removing Tables                       468
Designing the User Interface                  468
Chapter 5: Building an Application               469
Designing from the Top Down                 469
Determining what the application should include       470
Designing the user interface                470
Connecting the user interface to the database        471
Coding from the Bottom Up                  473
Preparing to build the application             473
Creating the database                474
Filling database tables with sample data        475
Creating the application’s building blocks          480
Developing screen forms               480
Developing reports                 481
Gluing everything together                481
Table of Contents xxvii
Testing, Testing, Testing                    481
Fixing the bugs                     482
Turning naive users loose                 482
Bringing on the hackers                  483
Fixing the newly found bugs                483
Retesting everything one last time             483
Chapter 6: Understanding SQL’s Procedural Capabilities     485
Embedding SQL Statements in Your Code            485
Introducing Compound Statements               486
Atomicity                        487
Variables                        487
Cursors                         488
Assignment                       488
Following the Flow of Control Statements            488
IF  THEN  ELSE  END IF              489
CASE  END CASE                    489
Simple CASE statement               489
Searched CASE statement              490
LOOP  END LOOP                   491
LEAVE                         491
WHILE  DO  END WHILE               492
REPEAT  UNTIL  END REPEAT             492
FOR  DO  END FOR                 493
ITERATE                        493
Using Stored Procedures                    494
Working with Triggers                     494
Trigger events                      496
Trigger action time                    496
Triggered actions                    496
Triggered SQL statement                 497
Using Stored Functions                    497
Passing Out Privileges                     498
Using Stored Modules                     498
Chapter 7: Connecting SQL to a Remote Database        501
Native Drivers                        501
ODBC and Its Major Components                502
Application                       504
Driver manager                     505
Drivers                         505
File-based drivers                  506
DBMS-based drivers                 506
Data sources                      508
xxviii
SQL All-in-One For Dummies, 2nd Edition
What Happens When the Application Makes a Request       508
Using handles to identify objects              508
Following the six stages of an ODBC operation        510
Stage 1: The application allocates environment and
connection handles in the driver manager      510
Stage 2: The driver manager fi nds the appropriate driver  510
Stage 3: The driver manager loads the driver      510
Stage 4: The driver manager allocates environment
and connection handles in the driver         511
Stage 5: The driver manager connects to
the data source through the driver          511
Stage 6: The data source (fi nally) executes
an SQL statement                 511
Book VI: SQL and XML            515
Chapter 1: Using XML with SQL                517
Introducing XML                       517
Knowing the Parts of an XML Document             518
XML declaration                     519
Elements                        519
Nested elements                  520
The document element               520
Empty elements                   520
Attributes                        521
Entity references                     521
Numeric character references               522
Using XML Schema                      522
Relating SQL to XML                      523
Using the XML Data Type                   524
When to use the XML type                524
When not to use the XML type               525
Mapping SQL to XML                     525
Mapping character sets to XML              526
Mapping identifi ers to XML                526
Mapping data types to XML                527
Mapping nonpredefi ned data types to XML         527
DOMAIN                      527
DISTINCT UDT                   529
ROW                       529
ARRAY                      530
MULTISET                     531
Mapping tables to XML                  532
Handling null values                   532
Creating an XML schema for an SQL table          533
Table of Contents xxix
Operating on XML Data with SQL Functions            534
XMLELEMENT                      534
XMLFOREST                       534
XMLCONCAT                      535
XMLAGG                        535
XMLCOMMENT                     536
XMLPARSE                       536
XMLPI                         537
XMLQUERY                       537
XMLCAST                        538
Working with XML Predicates                  538
DOCUMENT                       538
CONTENT                        539
XMLEXISTS                       539
VALID                         539
Chapter 2: Storing XML Data in SQL Tables           541
Inserting XML Data into an SQL Pseudotable           541
Creating a Table to Hold XML Data               543
Updating XML Documents                   543
Discovering Oracle’s Tools for Updating XML Data in a Table    544
APPENDCHILDXML                    545
INSERTCHILDXML                    546
INSERTXMLBEFORE                   546
DELETEXML                       547
UPDATEXML                      548
Introducing Microsoft’s Tools for Updating XML Data in a Table   549
Inserting data into a table using OPENXML         549
Using updategrams to map data into database tables     550
Using an updategram namespace and keywords       550
Specifying a mapping schema               551
Implicit mapping                  551
Explicit mapping                  553
Elementcentric mapping               557
Attributecentric mapping              558
Mixed elementcentric and attributecentric mapping   558
Schemas that allow null values            559
Chapter 3: Retrieving Data from XML Documents        561
XQuery                           562
Where XQuery came from                 562
What XQuery requires                  562
XQuery functionality                   563
Usage scenarios                     564
xxx
SQL All-in-One For Dummies, 2nd Edition
FLWOR Expressions                      568
The for clause                      569
The let clause                      570
The where clause                    571
The order by clause                   571
The return clause                    572
XQuery versus SQL                      573
Comparing XQuery’s FLWOR expression with SQL’s SELECT
expression                      573
Relating XQuery data types to SQL data types        573
Book VII: Database Tuning Overview       577
Chapter 1: Tuning the Database                579
Analyzing the Workload                    580
Considering the Physical Design                580
Choosing the Right Indexes                   582
Avoiding unnecessary indexes               582
Choosing a column to index                582
Using multicolumn indexes                583
Clustering indexes                    583
Choosing an index type                  585
Weighing the cost of index maintenance           585
Using composite indexes                 586
Tuning Indexes                        586
Tuning Queries                        587
Tuning Transactions                     588
Separating User Interactions from Transactions          589
Minimizing Traffi c between Application and Server        589
Precompiling Frequently Used Queries              589
Chapter 2: Tuning the Environment               591
Surviving Failures with Minimum Data Loss            592
What happens to transactions when no failure occurs?    592
What happens when a failure occurs and a transaction
is still active?                     592
Tuning the Recovery System                  593
Volatile and nonvolatile memory              593
Memory system hierarchy                 594
Putting logs and transactions on different disks       595
Hard disk drive construction             596
Hard disk drive performance considerations      596
Tuning write operations                 598
Performing database dumps                598
Setting checkpoints                   599
Optimizing batch transactions               600
Table of Contents xxxi
Tuning the Operating System                  601
Scheduling threads                    601
Context switching                  602
Round-robin scheduling               603
Priority-based scheduling              603
Priority inversion                  603
Deadlock                      604
Determining database buffer size              604
Tuning the page usage factor               605
Maximizing the Hardware You Have               606
Optimizing the placement of code and data on hard disks   606
Tuning the page replacement algorithm           606
Tuning the disk controller cache              607
Adding Hardware                       607
Faster processor                     608
More RAM                       608
Faster hard disks                    608
More hard disks                     609
RAID arrays                       609
Working in Multiprocessor Environments            609
Chapter 3: Finding and Eliminating Bottlenecks         611
Pinpointing the Problem                    611
Slow query                       612
Slow update                       612
Determining the Possible Causes of Trouble           612
Problems with indexes                  612
B+ tree indexes                   613
Index pluses and minuses              613
Index-only queries                  614
Full table scans versus indexed table access      614
Pitfalls in communication                 614
ODBC/JDBC versus native drivers           615
Locking and client performance            615
Application development tools making
suboptimal decisions               616
Determining whether hardware is robust enough
and confi gured properly                616
Implementing General Pointers: A First Step Toward Improving
Performance                        617
Avoid direct user interaction               617
Examine the application/database interaction        617
Don’t ask for columns that you don’t need          618
Don’t use cursors unless you absolutely have to       618
Precompiled queries                   618
xxxii
SQL All-in-One For Dummies, 2nd Edition
Tracking Down Bottlenecks                  619
Isolating performance problems              619
Performing a top-down analysis              619
DBMS operations                  619
Hardware                     620
Partitioning                       621
Locating hotspots                    622
Analyzing Query Effi ciency                   622
Using query analyzers                  622
The Database Engine Tuning Advisor         626
SQL Server Profi ler                 631
The Oracle Tuning Advisor              633
Finding problem queries                 633
Managing Resources Wisely                  637
Analyzing a query’s access plan            634
Examining a query’s execution profi le         636
The disk subsystem                   637
The database buffer manager               638
The logging subsystem                  639
The locking subsystem                  639
Book VIII: Appendices            641
Appendix A: SQL:2008 Reserved Words             643
Appendix B: Glossary                    651
Index                   661