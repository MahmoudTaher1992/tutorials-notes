For more information about this title, click here
Contents
ACKNOWLEDGMENTS . . . xi
INTRODUCTION . . . . xi
PART I Relational Databases and SQL
1 Introduction to Relational Databases and SQL . 3
Understand Relational Databases . . . 4
The Relational Model . . . 5
Learn About SQL . . . . 15
The SQL Evolution . . . 15
Types of SQL Statements . . . 18
Types of Execution . . . 19
SQL Standard versus Product Implementations . . 21
2 Working with the SQL Environment . . 29
Understand the SQL Environment . . . 30
Understand SQL Catalogs . . . 32
Schemas . . . . 34
Schema Objects . . . 35
Then What Is a Database? . . . 37
Name Objects in an SQL Environment . . 40
Qualified Names . . . 41
v
vi SQL: A Beginner’s Guide
Create a Schema . . . . 42
Create a Database . . . . 44
3 Creating and Altering Tables . . 49
Create SQL Tables . . . . 50
Specify Column Data Types . . . 54
String Data Types . . . 55
Numeric Data Types . . . 57
Datetime Data Types . . . 58
Interval Data Type . . . 60
Boolean Data Type . . . 61
Using SQL Data Types . . . 62
Create User-Defined Types . . . 63
Specify Column Default Values . . . 64
Delete SQL Tables . . . . 69
4 Enforcing Data Integrity . . . 73
Understand Integrity Constraints . . . 74
Use NOT NULL Constraints . . . 76
Add UNIQUE Constraints . . . 77
Add PRIMARY KEY Constraints . . . 79
Add FOREIGN KEY Constraints . . . 83
The MATCH Clause . . . 88
The <referential triggered action> Clause . . 89
Define CHECK Constraints . . . 95
Defining Assertions . . . 97
Creating Domains and Domain Constraints . . 98
5 Creating SQL Views . . . 103
Add Views to the Database . . . 104
Defining SQL Views . . . 108
Create Updateable Views . . . 114
Using the WITH CHECK OPTION Clause . . 116
Drop Views from the Database . . . 117
6 Managing Database Security . . 123
Understand the SQL Security Model . . . 124
SQL Sessions . . . . 126
Accessing Database Objects . . . 128
Create and Delete Roles . . . 130
Grant and Revoke Privileges . . . 131
Revoking Privileges . . . 135
Grant and Revoke Roles . . . 137
Revoking Roles . . . 138
Contents vii
PART II Data Access and Modification
7 Querying SQL Data . . . 145
Use a SELECT Statement to Retrieve Data . . 146
The SELECT Clause and FROM Clause . . 147
Use the WHERE Clause to Define Search Conditions . 152
Defining the WHERE Clause . . . 156
Use the GROUP BY Clause to Group Query Results . . 159
Use the HAVING Clause to Specify Group Search Conditions . 164
Use the ORDER BY Clause to Sort Query Results . . 166
8 Modifying SQL Data . . . 175
Insert SQL Data . . . . 176
Inserting Values from a SELECT Statement . . 180
Update SQL Data . . . . 182
Updating Values from a SELECT Statement . . 185
Delete SQL Data . . . . 186
9 Using Predicates . . . 193
Compare SQL Data . . . . 194
Using the BETWEEN Predicate . . 199
Return Null Values . . . . 200
Return Similar Values . . . 203
Reference Additional Sources of Data . . 209
Using the IN Predicate . . . 209
Using the EXISTS Predicate . . . 213
Quantify Comparison Predicates . . . 216
Using the SOME and ANY Predicates . . 216
Using the ALL Predicate . . . 218
10 Working with Functions and Value Expressions . 225
Use Set Functions . . . . 226
Using the COUNT Function . . . 227
Using the MAX and MIN Functions . . 229
Using the SUM Function . . . 231
Using the AVG Function . . . 232
Use Value Functions . . . . 232
Working with String Value Functions . . 233
Working with Datetime Value Functions . . 236
Use Value Expressions . . . 238
Working with Numeric Value Expressions . . 238
Using the CASE Value Expression . . 241
Using the CAST Value Expression . . 244
Use Special Values . . . . 245
viii SQL: A Beginner’s Guide
11 Accessing Multiple Tables . . . 253
Perform Basic Join Operations . . . 254
Using Correlation Names . . . 257
Creating Joins with More than Two Tables . . 258
Creating the Cross Join . . . 259
Creating the Self-Join . . . 260
Join Tables with Shared Column Names . . 261
Creating the Natural Join . . . 262
Creating the Named Column Join . . 263
Use the Condition Join . . . 263
Creating the Inner Join . . . 264
Creating the Outer Join . . . 266
Perform Union Operations . . . 269
12 Using Subqueries to Access and Modify Data . 277
Create Subqueries That Return Multiple Rows . . 278
Using the IN Predicate . . . 279
Using the EXISTS Predicate . . . 281
Using Quantified Comparison Predicates . . 282
Create Subqueries That Return One Value . . 283
Work with Correlated Subqueries . . . 284
Use Nested Subqueries . . . 286
Use Subqueries to Modify Data . . . 288
Using Subqueries to Insert Data . . 288
Using Subqueries to Update Data . . 290
Using Subqueries to Delete Data . . 291
PART III Advanced Data Access
13 Creating SQL-Invoked Routines . . 299
Understand SQL-Invoked Routines . . . 300
SQL-Invoked Procedures and Functions . . 301
Working with the Basic Syntax . . . 301
Create SQL-Invoked Procedures . . . 303
Invoking SQL-Invoked Procedures . . 305
Add Input Parameters to Your Procedures . . 306
Using Procedures to Modify Data . . 309
Add Local Variables to Your Procedures . . 311
Work with Control Statements . . . 313
Create Compound Statements . . . 313
Create Conditional Statements . . . 314
Create Looping Statements . . . 316
Add Output Parameters to Your Procedures . . 320
Create SQL-Invoked Functions . . . 321
Contents ix
14 Creating SQL Triggers . . . 329
Understand SQL Triggers . . . 330
Trigger Execution Context . . . 331
Create SQL Triggers . . . . 333
Referencing Old and New Values . . 334
Dropping SQL Triggers . . . 335
Create Insert Triggers . . . 336
Create Update Triggers . . . 338
Create Delete Triggers . . . 343
15 Using SQL Cursors . . . 351
Understand SQL Cursors . . . 352
Declaring and Opening SQL Cursors . . 353
Declare a Cursor . . . . 355
Working with Optional Syntax Elements . . 356
Creating a Cursor Declaration . . . 360
Open and Close a Cursor . . . 363
Retrieve Data from a Cursor . . . 363
Use Positioned UPDATE and DELETE Statements . . 368
Using the Positioned UPDATE Statement . . 368
Using the Positioned DELETE Statement . . 370
16 Managing SQL Transactions . . 377
Understand SQL Transactions . . . 378
Set Transaction Properties . . . 381
Specifying an Isolation Level . . . 382
Specifying a Diagnostics Size . . . 387
Creating a SET TRANSACTION Statement . . 388
Start a Transaction . . . . 389
Set Constraint Deferability . . . 390
Create Savepoints in a Transaction . . . 392
Releasing a Savepoint . . . 394
Terminate a Transaction . . . 395
Committing a Transaction . . . 395
Rolling Back a Transaction . . . 396
17 Accessing SQL Data from Your Host Program . 403
Invoke SQL Directly . . . . 404
Embed SQL Statements in Your Program . . 406
Creating an Embedded SQL Statement . . 407
Using Host Variables in Your SQL Statements . . 408
Retrieving SQL Data . . . 411
Error Handling . . . . 413
x SQL: A Beginner’s Guide
Create SQL Client Modules . . . 417
Defining SQL Client Modules . . . 418
Use an SQL Call-Level Interface . . . 419
Allocating Handles . . . 421
Executing SQL Statements . . . 423
Working with Host Variables . . . 424
Retrieving SQL Data . . . 426
18 Working with XML Data . . . 433
Learn the Basics of XML . . . 434
Learn About SQL/XML . . . 437
The XML Data Type . . . 437
SQL/XML Functions . . . 439
SQL/XML Mapping Rule . . . 441
PART IV Appendices
A Answers to Self Test . . . 449
B SQL:2006 Keywords . . . 491
SQL Reserved Keywords . . . 492
SQL Nonreserved Keywords . . . 494
C SQL Code Used in Try This Exercises . . 497
SQL Code by Try This Exercise . . . 498
The INVENTORY Database . . . 514
Index . . . . 519