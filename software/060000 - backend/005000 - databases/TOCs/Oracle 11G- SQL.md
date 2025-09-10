B R I E F C O N T E N T S
Preface xvi
Chapter 1 Overview of Database Concepts 1
Chapter 2 Basic SQL SELECT Statements 25
Chapter 3 Table Creation and Management 57
Chapter 4 Constraints 99
Chapter 5 Data Manipulation and Transaction Control 137
Chapter 6 Additional Database Objects 175
Chapter 7 User Creation and Management 213
Chapter 8 Restricting Rows and Sorting Data 243
Chapter 9 Joining Data from Multiple Tables 283
Chapter 10 Selected Single-Row Functions 331
Chapter 11 Group Functions 383
Chapter 12 Subqueries and MERGE Statements 427
Chapter 13 Views 471
Appendix A Tables for the JustLee Books Database 511
Appendix B SQL*Plus and SQL Developer Overview 519
Appendix C Oracle Resources 527
Appendix D SQL*Loader 529
Appendix E SQL Tuning Topics 533
Appendix F SQL in Various Databases 551
Glossary 555
Index 563
www.allitebooks.com
T A B L E O F C O N T E N T S
Preface xvi
Chapter 1 Overview of Database Concepts 1
Introduction 2
Database Terminology 2
Database Management System 3
Database Design 4
Entity-Relationship (E-R) Model 5
Database Normalization 6
Relating Tables in the Database 10
Structured Query Language (SQL) 12
Databases Used in This Textbook 13
Basic Assumptions 13
Tables in the JustLee Books Database 14
Topic Sequence 16
Software Used in This Textbook 16
Chapter Summary 17
Review Questions 17
Multiple Choice 18
Hands-On Assignments 21
Advanced Challenge 22
Case Study: City Jail 22
Chapter 2 Basic SQL SELECT Statements 25
Introduction 26
Creating the JustLee Books Database 27
SELECT Statement Syntax 30
Selecting All Data in a Table 31
Selecting One Column from a Table 33
Selecting Multiple Columns from a Table 34
Operations in the SELECT Statement 36
Using Column Aliases 36
Using Arithmetic Operations 39
NULL Values 40
Using DISTINCT and UNIQUE 42
Using Concatenation 44
Chapter Summary 49
Review Questions 50
Multiple Choice 51
Hands-On Assignments 54
Advanced Challenge 55
www.allitebooks.com
Chapter 3 Table Creation and Management 57
Introduction 58
Table Design 59
Table Creation 63
Defining Columns 63
Viewing a List of Tables: USER_TABLES 65
Viewing Table Structures: DESCRIBE 66
Table Creation with Subqueries 67
CREATE TABLE . . . AS COMMAND 68
Modifying Existing Tables 70
ALTER TABLE . . . ADD Command 70
ALTER TABLE . . . MODIFY Command 71
ALTER TABLE . . . DROP COLUMN Command 75
ALTER TABLE . . . SET UNUSED/DROP UNUSED COLUMNS Command 76
Renaming a Table 79
Truncating a Table 81
Deleting a Table 83
Chapter Summary 88
Review Questions 90
Multiple Choice 90
Hands-On Assignments 94
Advanced Challenge 94
Case Study: City Jail 95
Chapter 4 Constraints 99
Introduction 100
Creating Constraints 101
Creating Constraints at the Column Level 102
Creating Constraints at the Table Level 102
Using the PRIMARY KEY Constraint 103
Using the FOREIGN KEY Constraint 106
Using the UNIQUE Constraint 110
Using the CHECK Constraint 112
Using the NOT NULL Constraint 114
Including Constraints During Table Creation 116
Adding Multiple Constraints on a Single Column 120
Viewing Constraint Information 120
Disabling and Dropping Constraints 122
Using DISABLE/ENABLE 122
Dropping Constraints 123
Chapter Summary 126
Review Questions 128
Multiple Choice 129
Hands-On Assignments 132
Advanced Challenge 134
Case Study: City Jail 134
viii Table of Contents
www.allitebooks.com
Chapter 5 Data Manipulation and Transaction Control 137
Introduction 138
Inserting New Rows 139
Using the INSERT Command 139
Handling Virtual Columns 144
Handling Single Quotes in an INSERT Value 146
Inserting Data from an Existing Table 148
Modifying Existing Rows 150
Using the UPDATE Command 150
Using Substitution Variables 152
Deleting Rows 156
Using Transaction Control Statements 157
COMMIT and ROLLBACK Commands 158
SAVEPOINT Command 159
Using Table Locks 162
LOCK TABLE Command 162
SELECT . . . FOR UPDATE Command 163
Chapter Summary 165
Review Questions 167
Multiple Choice 167
Hands-On Assignments 170
Advanced Challenge 171
Case Study: City Jail 172
Chapter 6 Additional Database Objects 175
Introduction 176
Sequences 177
Creating a Sequence 178
Using Sequence Values 183
Altering Sequence Definitions 185
Removing a Sequence 188
Indexes 188
B-Tree Indexes 190
Bitmap Indexes 196
Function-Based Indexes 197
Index Organized Tables 198
Verifying an Index 199
Altering or Removing an Index 200
Synonyms 201
Deleting a Synonym 204
Chapter Summary 205
Review Questions 207
Multiple Choice 208
Hands-On Assignments 211
Advanced Challenge 212
Case Study: City Jail 212
Table of Contents ix
www.allitebooks.com
Chapter 7 User Creation and Management 213
Introduction 214
Data Security 215
Creating a User 216
Creating Usernames and Passwords 216
Assigning User Privileges 218
System Privileges 218
Granting System Privileges 219
Object Privileges 220
Granting Object Privileges 220
Managing Passwords 224
Using Roles 225
Creating and Assigning Roles 226
Using Predefined Roles 228
Using Default Roles 229
Enabling Roles After Login 230
Viewing Privilege Information 230
Removing Privileges and Users 232
Revoking Privileges and Roles 232
Dropping a Role 234
Dropping a User 234
Chapter Summary 235
Review Questions 237
Multiple Choice 237
Hands-On Assignments 241
Advanced Challenge 241
Case Study: City Jail 242
Chapter 8 Restricting Rows and Sorting Data 243
Introduction 244
WHERE Clause Syntax 245
Rules for Character Strings 246
Rules for Dates 248
Comparison Operators 248
BETWEEN . . . AND Operator 255
IN Operator 256
LIKE Operator 258
Logical Operators 262
Treatment of NULL Values 265
ORDER BY Clause Syntax 267
Secondary Sort 270
Sorting by SELECT Order 272
Chapter Summary 274
Review Questions 276
Multiple Choice 277
Hands-On Assignments 281
x Table of Contents
Advanced Challenge 281
Case Study: City Jail 281
Chapter 9 Joining Data from Multiple Tables 283
Introduction 284
Cartesian Joins 285
Cartesian Join: Traditional Method 286
Cartesian Join: JOIN Method 288
Equality Joins 289
Equality Joins: Traditional Method 291
Equality Joins: JOIN Method 296
Non-Equality Joins 302
Non-Equality Joins: Traditional Method 303
Non-Equality Joins: JOIN Method 304
Self-Joins 305
Self-Joins: Traditional Method 306
Self-Joins: JOIN Method 307
Outer Joins 308
Outer Joins: Traditional Method 309
Outer Joins: JOIN Method 310
Set Operators 312
Chapter Summary 319
Review Questions 322
Multiple Choice 323
Hands-On Assignments 329
Advanced Challenge 329
Case Study: City Jail 330
Chapter 10 Selected Single-Row Functions 331
Introduction 332
Case Conversion Functions 333
The LOWER Function 333
The UPPER Function 334
The INITCAP Function 335
Character Manipulation Functions 336
The SUBSTR Function 336
The INSTR Function 338
The LENGTH Function 340
The LPAD and RPAD Functions 340
The LTRIM and RTRIM Functions 342
The REPLACE Function 342
The TRANSLATE Function 343
The CONCAT Function 344
Number Functions 344
The ROUND Function 344
The TRUNC Function 345
Table of Contents xi
The MOD Function 346
The ABS Function 347
The POWER Function 348
Date Functions 348
The MONTHS_BETWEEN Function 349
The ADD_MONTHS Function 350
The NEXT_DAY and LAST_DAY Functions 351
The TO_DATE Function 352
Rounding Date Values 354
Truncating Date Values 355
CURRENT_DATE Versus SYSDATE 355
Regular Expressions 357
Other Functions 359
The NVL Function 359
The NVL2 Function 362
The NULLIF Function 363
The TO_CHAR Function 365
The DECODE Function 367
The CASE Expression 369
The SOUNDEX Function 369
The TO_NUMBER Function 370
The DUAL Table 371
Chapter Summary 372
Review Questions 376
Multiple Choice 377
Hands-On Assignments 381
Advanced Challenge 381
Case Study: City Jail 382
Chapter 11 Group Functions 383
Introduction 384
Group Functions 386
The SUM Function 386
The AVG Function 388
The COUNT Function 390
The MAX Function 393
The MIN Function 394
Grouping Data 395
Restricting Aggregated Output 398
Nesting Functions 402
Statistical Group Functions 403
The STDDEV Function 403
The VARIANCE Function 404
Enhanced Aggregation for Reporting 405
The GROUPING SETS Expression 407
The CUBE Extension 409
xii Table of Contents
The ROLLUP Extension 411
Chapter Summary 417
Review Questions 419
Multiple Choice 420
Hands-On Assignments 424
Advanced Challenge 425
Case Study: City Jail 425
Chapter 12 Subqueries and MERGE Statements 427
Introduction 428
Subqueries and Their Uses 429
Single-Row Subqueries 429
Single-Row Subquery in a WHERE Clause 429
Single-Row Subquery in a HAVING Clause 434
Single-Row Subquery in a SELECT Clause 435
Multiple-Row Subqueries 437
The IN Operator 438
The ALL and ANY Operators 438
Multiple-Row Subquery in a HAVING Clause 443
Multiple-Column Subqueries 445
Multiple-Column Subquery in a FROM Clause 445
Multiple-Column Subquery in a WHERE Clause 447
NULL Values 448
NVL in Subqueries 449
IS NULL in Subqueries 450
Correlated Subqueries 451
Nested Subqueries 453
DML Actions Using Subqueries 455
MERGE Statements 456
Chapter Summary 460
Review Questions 461
Multiple Choice 462
Hands-On Assignments 467
Advanced Challenge 468
Case Study: City Jail 469
Chapter 13 Views 471
Introduction 472
Creating a View 474
Creating a Simple View 476
DML Operations on a Simple View 480
Creating a Complex View 484
DML Operations on a Complex View with an Arithmetic Expression 484
DML Operations on a Complex View Containing Data from Multiple Tables 489
DML Operations on a Complex View Containing Functions or Grouped Data 491
Table of Contents xiii
DML Operations on a Complex View Containing DISTINCT or ROWNUM 493
Summary Guidelines for DML Operations on a Complex View 495
Dropping a View 495
Creating an Inline View 496
TOP-N Analysis 496
Creating a Materialized View 499
Chapter Summary 502
Review Questions 503
Multiple Choice 504
Hands-On Assignments 508
Advanced Challenge 508
Case Study: City Jail 509
Appendix A Tables for the JustLee Books Database 511
CUSTOMERS Table 511
BOOKS Table 512
ORDERS Table 513
ORDERITEMS Table 514
AUTHOR Table 515
BOOK AUTHOR Table 516
PUBLISHER Table 517
PROMOTION Table 517
Appendix B SQL*Plus and SQL Developer Overview 519
Introduction 519
SQL*Plus 519
SQL Developer 523
Appendix C Oracle Resources 527
Oracle Academic Initiative (OAI) 527
Oracle Certification Program (OCP) 527
Oracle Technology Network (OTN) 527
International Oracle Users Group (IOUG) 527
Appendix D SQL*Loader 529
Introduction 529
Read a Fixed Format File 529
Read a Delimited File 532
Appendix E SQL Tuning Topics 533
Introduction 533
Tuning Concepts and Issues 533
Identifying Problem Areas in Coding 533
Processing and the Optimizer 535
The Explain Plan 537
Timing Feature 542
xiv Table of Contents
Selected SQL Tuning Guidelines and Examples 543
Avoiding Unnecessary Column Selection 544
Index Suppression 545
Concatenated Indexes 547
Subqueries 548
Optimizer Hints 549
Appendix F SQL in Various Databases Introduction 551
Suppressing Duplicates 551
Locating a Value in a String Displaying the Current Date 552
Specifying a Default Date Format Replacing NULL Values in Text Data Adding Time to Dates 553
Extracting Values from a String 551
552
552
553
553
Concatenating 554
Data Structures 554
Glossary 555
Index 563