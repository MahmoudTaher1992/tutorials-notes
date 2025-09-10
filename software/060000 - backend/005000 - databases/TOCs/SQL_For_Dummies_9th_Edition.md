Contents at a Glance
Introduction        1
Part 1: Getting Started with SQL    5
CHAPTER 1: CHAPTER 2: CHAPTER 3: Relational Database Fundamentals     7
SQL Fundamentals        23
The Components of SQL    55
Part 2: Using SQL to Build Databases      83
CHAPTER 4: CHAPTER 5: Building and Maintaining a Simple Database Structure    85
Building a Multi-table Relational Database    109
Part 3: Storing and Retrieving Data      CHAPTER 6: Manipulating Database Data      CHAPTER 7: Handling Temporal Data    CHAPTER 8: Specifying Values          179
CHAPTER 9: Using Advanced SQL Value Expressions   CHAPTER 10: Zeroing In on the Data You Want     CHAPTER 11: Using Relational Operators      CHAPTER 12: Delving Deep with Nested Queries    CHAPTER 13: Recursive Queries      141
143
163
209
223
259
283
303
Part 4: Controlling Operations    CHAPTER 14: Providing Database Security      CHAPTER 15: Protecting Data        CHAPTER 16: Using SQL within Applications      313
315
331
351
Part 5: Taking SQL to the Real World     CHAPTER 17: Accessing Data with ODBC and JDBC      CHAPTER 18: Operating on XML Data with SQL        377
CHAPTER 19: SQL and JSON        365
367
399
www.allitebooks.com
Part 6: Advanced Topics    CHAPTER 20: Stepping through a Dataset with Cursors    CHAPTER 21: Adding Procedural Capabilities with Persistent Stored Modules  CHAPTER 22: Handling Errors        CHAPTER 23: Triggers         Part 7: The Parts of Tens     CHAPTER 24: Ten Common Mistakes    CHAPTER 25: Ten Retrieval Tips      413
415
427
445
457
463
465
469
Appendix: ISO/IEC SQL: 2016 Reserved Words     473
Index          479
Table of Contents
INTRODUCTION      1
About This Book     1
Foolish Assumptions       2
Icons Used in This Book    2
Beyond the Book        3
Where to Go from Here    3
PART 1: GETTING STARTED WITH SQL   5
CHAPTER 1: CHAPTER 2: Relational Database Fundamentals   7
Keeping Track of Things    8
What Is a Database?      9
Database Size and Complexity    What Is a Database Management System?    Flat Files      Database Models       Relational model      Components of a relational database    Dealing with your relations    Enjoy the view      Schemas, domains, and constraints      The object model challenged the relational model  The object-relational model     Database Design Considerations    10
10
12
13
13
14
14
16
18
19
20
20
SQL Fundamentals    23
What SQL Is and Isn’t    A (Very) Little History       SQL Statements        Reserved Words     Data Types      Exact numerics       Approximate numerics      Character strings      Binary strings      Booleans        Datetimes        Intervals        XML type        ROW types        Collection types      23
25
26
28
28
29
31
33
35
36
36
38
38
41
42
Table of Contents v
REF types     User-defined types    Data type summary     Null Values      Constraints      Using SQL in a Client/Server System      The server     The client            .52
Using SQL on the Internet or an Intranet    44
44
48
49
50
50
51
52
CHAPTER 3: The Components of SQL    55
Data Definition Language     56
When “Just do it!” is not good advice    56
Creating tables       57
A room with a view    59
Collecting tables into schemas    64
Ordering by catalog     65
Getting familiar with DDL statements    66
Data Manipulation Language          .68
Value expressions    68
Predicates        72
Logical connectives    73
Set functions         .73
Subqueries        76
Data Control Language     76
Transactions     76
Users and privileges    77
Referential integrity constraints can jeopardize your data    80
Delegating responsibility for security     82
PART 2: USING SQL TO BUILD DATABASES   83
CHAPTER 4: Building and Maintaining a Simple
Database Structure    85
Using a RAD Tool to Build a Simple Database   86
Deciding what to track      86
Creating a database table      87
Altering the table structure    93
Creating an index         .95
Deleting a table      97
Building POWER with SQL’s DDL    98
Using SQL with Microsoft Access      99
Creating a table      101
Creating an index        .105
vi SQL For Dummies
Altering the table structure    Deleting a table      Deleting an index     Portability Considerations      105
106
106
107
CHAPTER 5: Building a Multi-table Relational Database 109
Designing a Database    Step 1: Defining objects      Step 2: Identifying tables and columns    Step 3: Defining tables      Domains, character sets, collations, and translations  Getting into your database fast with keys  Working with Indexes    What’s an index, anyway?       Why you should want an index      Maintaining an index      Maintaining Data Integrity      Entity integrity      Domain integrity    Referential integrity     Just when you thought it was safe   .    Potential problem areas       Constraints        Normalizing the Database      Modification anomalies and normal forms  First normal form        .136
Second normal form    Third normal form     Domain-key normal form (DK/NF)      Abnormal form      110
110
110
111
115
116
119
119
121
121
122
122
124
124
127
128
130
134
134
137
138
139
140
PART 3: STORING AND RETRIEVING DATA    141
CHAPTER 6: Manipulating Database Data    Retrieving Data      Creating Views        From tables     With a selection condition    With a modified attribute      Updating Views      Adding New Data       Adding data one row at a time      Adding data only to selected columns    Adding a block of rows to a table      143
144
145
146
147
148
149
150
151
152
152
Table of Contents vii
CHAPTER 7: CHAPTER 8: CHAPTER 9: viii SQL For Dummies
Updating Existing Data    Transferring Data      155
158
Deleting Obsolete Data          .161
Handling Temporal Data    Understanding Times and Periods      Working with Application-Time Period Tables  Designating primary keys in application-time period tables   Applying referential integrity constraints to
application-time period tables     Querying application-time period tables  Working with System-Versioned Tables     Designating primary keys in system-versioned tables   Applying referential integrity constraints to
system-versioned tables       Querying system-versioned tables      Tracking Even More Time Data with Bitemporal Tables  Formatting and Parsing Dates and Times    163
164
165
168
169
170
171
173
174
174
175
176
Specifying Values    179
Values      179
Row values        180
Literal values      180
Variables        182
Special variables    184
Column references    185
Value Expressions      186
String value expressions       186
Numeric value expressions    187
Datetime value expressions     187
Interval value expressions    188
Conditional value expressions     189
Functions      189
Set functions            .189
Value functions      193
Table functions      208
Using Advanced SQL Value Expressions  CASE Conditional Expressions    Using CASE with search conditions   Using CASE with values       A special CASE — NULLIF      Another special CASE — COALESCE    209
210
211
212
215
216
CAST Data-Type Conversions       Using CAST within SQL      Using CAST between SQL and the host language     Row Value Expressions     CHAPTER 10: Zeroing In on the Data You Want  Modifying Clauses      FROM Clauses        WHERE Clauses      Comparison predicates      BETWEEN        IN and NOT IN      LIKE and NOT LIKE     SIMILAR        NULL      ALL, SOME, ANY      EXISTS      UNIQUE        DISTINCT        OVERLAPS        MATCH        Referential integrity rules and the MATCH predicate  Logical Connectives       AND      OR      NOT      GROUP BY Clauses      HAVING Clauses       ORDER BY Clauses       Limited FETCH        Peering through a Window to Create a Result Set    Partitioning a window into buckets with NTILE     Navigating within a window     Nesting window functions    Evaluating groups of rows    Row pattern recognition       CHAPTER 11: Using Relational Operators      UNION       The UNION ALL operation    The CORRESPONDING operation      INTERSECT        EXCEPT      217
219
220
221
223
224
225
226
227
228
229
231
232
232
234
236
237
238
238
239
240
243
243
244
244
245
247
248
250
251
252
253
255
256
257
259
259
261
262
262
264
Table of Contents ix
Join Operators        Basic join     Equi-join        Cross join        Natural join     Condition join       Column-name join     Inner join     Outer join        Union join        ON versus WHERE      CHAPTER 12: Delving Deep with Nested Queries  What Subqueries Do    Nested queries that return sets of rows  Nested queries that return a single value  The ALL, SOME, and ANY quantifiers    Nested queries that are an existence test  Other correlated subqueries    UPDATE, DELETE, and INSERT    Retrieving changes with pipelined DML     CHAPTER 13: Recursive Queries    What Is Recursion?      Houston, we have a problem     Failure is not an option       What Is a Recursive Query?      Where Might You Use a Recursive Query?     Querying the hard way      Saving time with a recursive query   Where Else Might You Use a Recursive Query?   PART 4: CONTROLLING OPERATIONS    265
265
267
269
270
270
271
272
272
276
282
283
285
285
289
292
293
295
299
301
303
303
305
305
306
306
308
309
311
313
CHAPTER 14: Providing Database Security    The SQL Data Control Language    User Access Levels       The database administrator       .317
Database object owners       The public        Granting Privileges to Users       Roles      Inserting data      Looking at data      315
316
316
317
318
318
320
320
321
x SQL For Dummies
Modifying table data    Deleting obsolete rows from a table    Referencing related tables    Using domains      Causing SQL statements to be executed  Granting Privileges across Levels    Granting the Power to Grant Privileges    Taking Privileges Away    Using GRANT and REVOKE Together to Save Time and Effort    321
322
322
323
325
325
327
328
329
CHAPTER 15: Protecting Data    Threats to Data Integrity      Platform instability    Equipment failure    Concurrent access     Reducing Vulnerability to Data Corruption    Using SQL transactions       The default transaction       .338
Isolation levels      The implicit transaction-starting statement  SET TRANSACTION     COMMIT        ROLLBACK     Locking database objects      Backing up your data      Savepoints and subtransactions      Constraints Within Transactions    Avoiding SQL Injection Attacks    331
332
332
332
333
336
336
338
341
341
342
342
343
343
344
345
350
CHAPTER 16: Using SQL within Applications    SQL in an Application    Keeping an eye out for the asterisk    SQL strengths and weaknesses   Procedural languages’ strengths and weaknesses   Problems in combining SQL with a procedural language    Hooking SQL into Procedural Languages    Embedded SQL      Module language     Object-oriented RAD tools    Using SQL with Microsoft Access      351
352
352
353
353
353
354
355
358
360
361
Table of Contents xi
PART 5: TAKING SQL TO THE REAL WORLD    365
CHAPTER 17: Accessing Data with ODBC and JDBC     ODBC         The ODBC interface     Components of ODBC       ODBC in a Client/Server Environment      ODBC and the Internet    Server extensions    Client extensions    ODBC and an Intranet           .373
JDBC         367
368
368
369
370
370
371
372
373
CHAPTER 18: Operating on XML Data with SQL   How XML Relates to SQL      The XML Data Type      When to use the XML type    When not to use the XML type      Mapping SQL to XML and XML to SQL      Mapping character sets      Mapping identifiers    Mapping data types     Mapping tables      Handling null values    Generating the XML Schema    SQL Functions That Operate on XML Data    XMLDOCUMENT       XMLELEMENT      XMLFOREST      XMLCONCAT       XMLAGG        XMLCOMMENT       XMLPARSE     XMLPI       XMLQUERY        XMLCAST     Predicates      DOCUMENT      CONTENT        XMLEXISTS        VALID      377
377
378
379
380
380
381
381
382
382
383
384
385
385
385
386
386
387
388
388
388
389
389
390
390
390
390
391
xii SQL For Dummies
Transforming XML Data into SQL Tables    Mapping Non-Predefined Data Types to XML   Domain        Distinct UDT      Row      Array      Multiset        The Marriage of SQL and XML    392
393
393
394
395
396
397
398
CHAPTER 19: SQL and JSON       Using JSON with SQL    Ingesting and storing JSON data into a relational database  Generating JSON data from relational data   Querying JSON data stored in relational tables    The SQL/JSON Data Model      SQL/JSON items      SQL/JSON sequences      Parsing JSON            .402
Serializing JSON      SQL/JSON Functions    JSON API common syntax       Query functions      Constructor functions       IS JSON predicate     JSON nulls and SQL nulls      SQL/JSON Path Language       There’s More        399
400
400
400
400
401
401
402
402
403
403
404
408
411
411
411
412
PART 6: ADVANCED TOPICS      413
CHAPTER 20: Stepping through a Dataset with Cursors   Declaring a Cursor       Query expression    ORDER BY clause    Updatability clause    Sensitivity        Scrollability        Opening a Cursor      Fetching Data from a Single Row    Syntax      Orientation of a scrollable cursor      Positioned DELETE and UPDATE statements   Closing a Cursor       415
416
417
417
419
419
420
421
422
423
424
424
425
Table of Contents xiii
CHAPTER 21: Adding Procedural Capabilities with
Persistent Stored Modules   427
Compound Statements    428
Atomicity     429
Variables        430
Cursors        430
Conditions          .431
Handling conditions    431
Conditions that aren’t handled      434
Assignment     434
Flow of Control Statements      435
IF  .THEN  .ELSE  .END IF    435
CASE  .END CASE    435
LOOP  .ENDLOOP    437
LEAVE       437
WHILE  .DO  .END WHILE    438
REPEAT  .UNTIL  .END REPEAT      438
FOR  .DO  .END FOR       439
ITERATE        439
Stored Procedures       440
Stored Functions      442
Privileges       442
Stored Modules      443
CHAPTER 22: Handling Errors    SQLSTATE      WHENEVER Clause       Diagnostics Areas      Diagnostics header area       Diagnostics detail area      Constraint violation example     Adding constraints to an existing table    Interpreting the information returned by SQLSTATE   Handling Exceptions    CHAPTER 23: Triggers      Examining Some Applications of Triggers    Creating a Trigger      Statement and row triggers    When a trigger fires     The triggered SQL statement     An example trigger definition    Firing a Succession of Triggers    Referencing Old Values and New Values    Firing Multiple Triggers on a Single Table    445
445
447
448
449
450
452
453
454
455
457
457
458
459
459
459
460
460
461
462
xiv SQL For Dummies
PART 7: THE PARTS OF TENS      CHAPTER 24: Ten Common Mistakes    Assuming That Your Clients Know What They Need    Ignoring Project Scope    Considering Only Technical Factors      Not Asking for Client Feedback    Always Using Your Favorite Development Environment  Using Your Favorite System Architecture Exclusively     Designing Database Tables in Isolation    Neglecting Design Reviews      Skipping Beta Testing    Not Documenting Your Process    CHAPTER 25: Ten Retrieval Tips     Verify the Database Structure    Try Queries on a Test Database    Double-Check Queries That Include Joins    Triple-Check Queries with Subselects      Summarize Data with GROUP BY    Watch GROUP BY Clause Restrictions      Use Parentheses with AND, OR, and NOT    Control Retrieval Privileges      Back Up Your Databases Regularly   Handle Error Conditions Gracefully      463
465
465
466
466
466
467
467
467
468
468
468
469
470
470
470
470
471
471
471
472
472
472
APPENDIX: ISO/IEC SQL: 2016 RESERVED WORDS    473
INDEX       479