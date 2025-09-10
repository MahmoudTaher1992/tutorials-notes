Contents at a Glance
Introduction                1
Part I: A SQL Concepts Overview
HOUR 1 Welcome to the World of SQL            7
Part II: Building Your Database
HOUR 2 Defining Data 3 Managing Database 4 The Normalization Structures            . 27
Objects            41
Process              61
5 Manipulating 6 Managing Data                73
Database Transactions            . 87
Part III: Getting Effective Results from Queries
HOUR 7 Introduction to the Database Query            101
8 Using Operators to Categorize Data            . 117
9 Summarizing Data Results from a Query        . 141
10 Sorting and Grouping Data            151
11 Restructuring the Appearance of Data        . 165
12 Understanding Dates and Times            . 185
Part IV: Building Sophisticated Database Queries
HOUR 13 14 15 Joining Tables in Using Subqueries to Combining Multiple Queries              . 203
Define Queries Unknown Data          . 221
into One        . 235
Part V: SQL Performance Tuning
HOUR 16 17 Using Indexes Improving to Improve Database Performance        253
Performance          . 265
Part VI: Using SQL to Manage Users and Security
HOUR 18 Managing Database Users            . 283
19 Managing Database Security              297
Part VII: Summarized Data Structures
HOUR 20 Creating and Using Views and Synonyms        . 313
21 Working with the System Catalog          . 329
Part VIII: Applying SQL Fundamentals in Today’s World
HOUR 22 Advanced SQL Topics                343
23 Extending SQL to the Enterprise, the Internet, and the Intranet    359
24 Extensions to Standard SQL            369
Part IX: Appendixes
A Common SQL Commands            . 381
B Using MySQL for Exercises            . 387
C Answers to Quizzes and Exercises            391
D CREATE TABLE Statements for Book Examples        435
E INSERT Statements for Data in Book Examples      437
F Bonus Exercises                441
Glossary                  447
Index                    . 451
Table of Contents
Introduction What This Book Intends to Accomplish            1
What We Added to This Edition              1
What You Need                    2
Conventions Used in This Book                2
ANSI SQL and Vendor Implementations            3
Understanding the Examples and Exercises            3
1
Part I: A SQL Concepts Overview
HOUR 1: Welcome to the World of SQL 7
SQL Definition and History                7
SQL Sessions                  14
Types of SQL Commands              15
The Database Used in This Book            17
Summary                  22
Q&A                      23
Workshop                  24
Part II: Building Your Database
HOUR 2: Defining Data Structures 27
What Is Data?                    27
Basic Data Types                28
Summary                  36
Q&A                      37
Workshop                  37
vi
Sams Teach Yourself SQL in 24 Hours
HOUR 3: Managing Database Objects What What Are Is Database 41
Objects?                41
a Schema?                  42
A Table: The Primary Storage for Data            44
Integrity Constraints                52
Summary                  56
Q&A                      57
Workshop                  58
HOUR 4: The Normalization Process 61
Normalizing a Database              61
Denormalizing a Database                69
Summary                  69
Q&A                      70
Workshop                  70
HOUR 5: Manipulating Data 73
Overview of Data Manipulation            73
Populating Tables with New Data              74
Updating Existing Data                79
Deleting Data from Tables                81
Summary                  82
Q&A                      82
Workshop                  83
HOUR 6: Managing Database Transactions 87
What Is a Transaction?                87
Controlling Transactional Transactions              88
Control and Database Performance        95
Summary                  95
Q&A                      96
Workshop                  96
vii
Contents
Part III: Getting Effective Results from Queries
HOUR 7: Introduction to the Database Query 101
What Is a Query?                  101
Introduction to the SELECT Statement            101
Examples of Simple Queries                109
Summary                  113
Q&A                    113
Workshop                    114
HOUR 8: Using Operators to Categorize Data 117
What Is an Operator in SQL?              117
Comparison Operators                118
Logical Operators                  121
Conjunctive Operators                127
Negative Operators                130
Arithmetic Operators                  134
Summary                  138
Q&A                    138
Workshop                    138
HOUR 9: Summarizing Data Results from a Query 141
What Are Aggregate Functions?              141
Summary                  149
Q&A                    149
Workshop                    149
HOUR 10: Sorting and Grouping Data 151
Why Group Data?                  151
The GROUP BY Clause                  152
GROUP BY Versus ORDER BY              156
The HAVING Clause                  159
Summary                  160
viii
Sams Teach Yourself SQL in 24 Hours
Q&A                    160
Workshop                    161
HOUR 11: Restructuring the Appearance of Data 165
ANSI Character Functions                165
Various Common Character Functions          166
Miscellaneous Character Functions              175
Mathematical Functions              178
Conversion Functions                179
Combining Character Functions              181
Summary                  182
Q&A                    182
Workshop                    183
HOUR 12: Understanding Dates and Times 185
How Is a Date Stored?                186
Date Functions                  187
Date Conversions                  192
Summary                  197
Q&A                    197
Workshop                    198
Part IV: Building Sophisticated Database Queries
HOUR 13: Joining Tables in Queries 203
Selecting Data from Multiple Tables              203
Types of Joins                    204
Join Considerations                214
Summary                  218
Q&A                    218
Workshop                    219
ix
Contents
HOUR 14: Using Subqueries to Define Unknown Data 221
What Is a Subquery?                  221
Embedded Subqueries                227
Correlated Subqueries                229
Summary                  230
Q&A                    231
Workshop                    231
HOUR 15: Combining Multiple Queries into One 235
Single Queries Versus Compound Queries          235
Compound Query Operators                236
Using ORDER BY with a Compound Query          242
Using GROUP BY with a Compound Query          244
Retrieving Accurate Data                246
Summary                  246
Q&A                    246
Workshop                    247
Part V: SQL Performance Tuning
HOUR 16: Using Indexes to Improve Performance 253
What Is an Index?                  253
How Do Indexes Work?              254
The CREATE INDEX Command              255
Types of Indexes                255
When Should Indexes Be Considered?          258
When Should Indexes Be Avoided?            259
Dropping an Index                260
Summary                  261
Q&A                    261
Workshop                    262
x
Sams Teach Yourself SQL in 24 Hours
HOUR 17: Improving Database Performance 265
What Is SQL Statement Tuning?              265
Database Tuning Versus SQL Statement Tuning          266
Formatting Your SQL Statement            266
Full Table Scans                272
Other Performance Considerations            273
Performance Tools                  276
Summary                  276
Q&A                    277
Workshop                    278
Part VI: Using SQL to Manage Users and Security
HOUR 18: Managing Database Users 283
Users Are the Reason                  284
The Management Process                286
Tools Utilized by Database Users              293
Summary                  294
Q&A                    294
Workshop                    295
HOUR 19: Managing Database Security 297
What Is Database Security?                297
What Are Privileges?                  298
Controlling User Access              302
Controlling Privileges Through Roles            305
Summary                  307
Q&A                    308
Workshop                    309
xi
Contents
Part VII: Summarized Data Structures
HOUR 20: Creating and Using Views and Synonyms 313
What Is a View?                313
Creating Views                  316
WITH CHECK OPTION                320
Updating Data Through a View            321
Creating a Table from a View              322
Views and the ORDER BY Clause            323
Dropping a View                323
What Is a Synonym?                  324
Summary                  325
Q&A                    326
Workshop                    326
HOUR 21: Working with the System Catalog 329
What Is the System Catalog?                329
How Is the System Catalog Created?              331
What Is Contained in the System Catalog?            331
System Catalog Tables by Implementation            333
Querying the System Catalog              335
Updating System Catalog Objects            337
Summary                  337
Q&A                    338
Workshop                    338
Part VIII: Applying SQL Fundamentals in Today’s World
HOUR 22: Advanced SQL Topics 343
Cursors                    343
Stored Procedures and Functions              346
Triggers                    349
Dynamic SQL                    351
xii
Sams Teach Yourself SQL in 24 Hours
Call-Level Interface                352
Using Direct SQL to Versus Generate Embedded SQL              352
SQL                353
Windowed Table Functions              354
Working with XML                354
Summary                  355
Q&A                    356
Workshop                    356
HOUR 23: Extending SQL to the Enterprise, the Internet, and the Intranet 359
SQL and Accessing SQL and the Enterprise                359
a Remote Database              361
the Internet                  364
SQL and the Intranet                  365
Summary                  366
Q&A                    367
Workshop                    367
HOUR 24: Extensions to Standard SQL 369
Various Example Interactive Implementations                369
Extensions                372
SQL Statements              375
Summary                  376
Q&A                    377
Workshop                    377
Part IX: Appendixes
APPENDIX A: Common SQL Commands 381
SQL Statements                  381
SQL Clauses                  384
xiii
Contents
APPENDIX B: Using MySQL for Exercises Windows Installation 387
Instructions            387
Linux Installation Instructions            388
APPENDIX C: Answers to Quizzes and Exercises 391
Hour 1, “Welcome to the World of SQL”            391
Hour 2, “Defining Data Structures”              393
Hour 3, “Managing Database Objects”          395
Hour 4, “The Normalization Process”            398
Hour 5, “Manipulating Data”              400
Hour 6, “Managing Database Transactions”          402
Hour 7, “Introduction to the Database Query”        403
Hour 8, “Using Operators to Categorize Data”        406
Hour 9, “Summarizing Data Results from a Query”        409
Hour 10, “Sorting and Grouping Data”          412
Hour 11, “Restructuring the Appearance of Data”          414
Hour 12, “Understanding Dates and Time”            416
Hour 13, “Joining Tables in Queries”            417
Hour 14, “Using Subqueries to Define Unknown Data”        419
Hour 15, “Combining Multiple Queries into One”          421
Hour 16, “Using Indexes to Improve Performance”          423
Hour 17, “Improving Database Performance”        425
Hour 18, “Managing Database Users”          427
Hour 19, “Managing Database Security”            428
Hour 20, “Creating and Using Views and Synonyms”      429
Hour 21, “Working with the System Catalog”        430
Hour 22, “Advanced SQL Topics”              431
Hour 23, “Extending SQL to the Enterprise, the Internet, and the Intranet”  432
Hour 24, “Extensions to Standard SQL”            433
xiv
Sams Teach Yourself SQL in 24 Hours
APPENDIX D: CREATE TABLE Statements for Book Examples 435
EMPLOYEE_TBL                    435
EMPLOYEE_PAY_TBL                  435
CUSTOMER_TBL                    436
ORDERS_TBL                  436
PRODUCTS_TBL                    436
APPENDIX E: INSERT Statements for Book Examples 437
EMPLOYEE_TBL                    437
EMPLOYEE_PAY_TBL                  438
CUSTOMER_TBL                    438
ORDERS_TBL                  439
PRODUCTS_TBL                    440
APPENDIX F: Bonus Exercises 441
Glossary 447
Index 451