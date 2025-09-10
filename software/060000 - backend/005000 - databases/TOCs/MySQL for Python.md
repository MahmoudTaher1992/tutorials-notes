Table of Contents
Preface 1
Chapter 1: Getting Up and Running with MySQL for Python 7
Getting MySQL for Python 7
Using a package manager (only on Linux) 8
Using RPMs and yum 9
Using RPMs and urpm 9
Using apt tools on Debian-like systems 9
Using an installer for Windows 10
Using an egg file 10
Using a tarball (tar.gz file) 14
Importing MySQL for Python 17
Accessing online help when you need it 18
MySQLdb 18
_mysql 19
Connecting with a database 20
Creating a connection object 20
Creating a cursor object 22
Interacting with the database 22
Closing the connection 23
Multiple database connections 23
Summary 24
Chapter 2: Simple Querying 25
A brief introduction to CRUD 25
Forming a query in MySQL 26
SELECT 27
* (asterisk) 27
FROM 28
staff 28
; (semicolon) 29
Table of Contents
Other helpful quantifiers 29
WHERE 30
GROUP BY 30
HAVING 32
ORDER BY 33
LIMIT 35
INTO OUTFILE 37
Passing a query to MySQL 37
A simple SELECT statement 38
Modifying the results 39
Using user-defined variables 40
Determining characteristics of a database and its tables 41
Determining what tables exist 42
Assigning each table a number 43
Offering the options to the user 43
Allowing the user to detail a search query 44
Changing queries dynamically 45
Pattern matching in MySQL queries 45
Putting it into practice 46
Project: A command-line search utility 48
Preparing a database for searching 49
Planning your work, then working your plan 50
Develop a well-abstracted search functionality 50
Specifying the search term from the command-line 52
Implementing and incorporating the other functions: -t, -f, and -o 55
Including an option for an output file 57
Room to grow 57
Summary 58
Chapter 3: Simple Insertion 59
Forming a MySQL insertion statement 60
INSERT 60
INTO 61
Table name 61
Column names 61
VALUES 63
<some values> 64
; (semicolon) 66
Helpful ways to nuance an INSERT statement 66
INSERT...SELECT... 66
INSERT DELAYED… 70
INSERT...ON DUPLICATE KEY UPDATE... 71
[ ii ]
Table of Contents
Passing an insertion through MySQL for Python 72
Setting up the preliminaries 72
A simple INSERT statement 73
More complex INSERT commands 75
Using user-defined variables 75
Using metadata 77
Querying the database for its structure 78
Retrieving the table structure 80
Changing insertion values dynamically 82
Validating the value of name 83
Validating the value of price 83
Querying the user for a correction 84
Passing fish and price for validation 84
Essentials: close and commit 85
In need of some closure 85
What happened to commit? 85
Why are these essentials non-essential? 85
Project: A command-line insertion utility 86
The necessary modules 86
The main() thing 87
Coding the flag system 88
Testing the values passed by the user 88
Try to establish a database connection 89
Showing the tables 90
Showing the table structure, if desired 90
Accepting user input for the INSERT statement 91
Building the INSERT statement from the user input and executing it 92
Committing changes and closing the connection 93
Coding the other functions 93
valid_digit() and valid_string() 93
valid_table() 94
query() 94
Calling main() 95
Room to grow 99
Summary 100
Chapter 4: Exception Handling 101
Why errors and warnings are good for you 101
Errors versus warnings: There's a big difference 104
The two main errors in MySQLdb 104
DatabaseError 105
InterfaceError 105
Warnings in MySQL for Python 105
[ iii ]
Table of Contents
Handling exceptions passed from MySQL 105
Python exception-handling 105
Catching an exception from MySQLdb 106
Raising an error or a warning 107
Making exceptions less intimidating 108
Catching different types of exceptions 109
Types of errors 109
DataError 110
IntegrityError 110
InternalError 111
NotSupportedError 111
OperationalError 111
ProgrammingError 112
Customizing for catching 113
Catching one type of exception 113
Catching different exceptions 114
Combined catching of exceptions 115
Raising different exceptions 115
Creating a feedback loop 116
Project: Bad apples 117
The preamble 118
Making the connection 119
Sending error messages 119
The statement class 121
The main() thing 125
Try, try again 126
If all else fails 126
Room to grow 127
Summary 128
Chapter 5: Results Record-by-Record 129
The problem 129
Why? 131
Computing resources 131
Local resources 132
Web applications 133
Network latency 134
Server-client communications 134
Apparent responsiveness 134
Pareto's Principle 134
How? 135
The fetchone() method 135
The fetchmany() method 136
Iteration: What is it? 137
Generating loops 138
[ iv ]
Table of Contents
while...if loops 138
The for loop 139
Iterators 140
Illustrative iteration 141
Iteration and MySQL for Python 141
Generators 142
Using fetchone() in a generator 142
Using fetchmany() in a generator 143
Project: A movie database 144
Getting Sakila 145
Creating the Sakila database 145
The structure of Sakila 146
Planning it out 148
The SQL statements to be used 148
Returning the films of an actor 148
Returning the actors of a film 149
Accepting user data 150
A MySQL query with class 150
The __init__ method: The consciousness of the class 151
Setting the query's type 151
Creating the cursor 152
Forming the query 153
Executing the query 154
Formatting the results 155
Formatting a sample 155
Formatting a larger set of results 156
The main() thing 157
Calling main() 158
Running it 159
Room to grow 159
Summary 160
Chapter 6: Inserting Multiple Entries 161
The problem 161
Why not a MySQL script? 162
Lack of automation 162
Debugging the process 162
Why not iterate? 163
A test sample: Generating primes 163
Comparing execution speeds 166
Introducing the executemany() method 166
executemany(): Basic syntax 167
executemany(): Multiple INSERT statements 168
executemany(): Multiple SELECT statements 170
[  ]
Table of Contents
executemany(): Behind the scenes 170
MySQL server has gone away 173
Command-line option configuration 173
Using a configuration file 174
More than 16 MB is often unnecessary 174
Project: Converting a CSV file to a MySQL table 175
The preamble 175
The options 176
Defining the connection 177
Creating convert 177
The main() function 178
Calling main() 181
Room to grow 181
Summary 182
Chapter 7: Creating and Dropping 183
Creating databases 183
Test first, create second 184
CREATE specifications 185
Specifying the default character set 185
Specifying the collation for a database 186
Declaring collation 186
Finding available character sets and collations 187
Removing or deleting databases 187
Avoiding errors 188
Preventing (illegal) access after a DROP 188
Creating tables 189
Covering our bases 190
Avoiding errors 191
Creating temporary tables 191
Dropping tables 192
Playing it safe 192
Avoiding errors 193
Removing user privileges 193
Doing it in Python 193
Creating databases with MySQLdb 194
Testing the output 194
Dynamically configuring the CREATE statement 195
Dropping databases with MySQLdb 195
Creating tables in Python 195
Verifying the creation of a table 196
Another way to verify table creation 197
Dropping tables with MySQLdb 198
[ vi ]
Table of Contents
Project: Web-based administration of MySQL 198
CGI vs PHP: What is the difference? 199
Basic CGI 200
Using PHP as a substitute for CGI 202
CGI versus PHP: When to use which? 203
Some general considerations for this program 203
Program flow 203
The basic menu 204
Authorization details 206
Three operational sections of the dialogue 206
The variables 206
Planning the functions 207
Code of each function 207
Connecting without a database 207
Connecting with a database 208
Database action 208
Table action 209
Query action 210
execute() 211
The HTML output 212
Basic definition 212
The message attribute 213
Defining header() 213
Defining footer() 213
Defining body() 214
Defining page() 214
Getting the data 214
Using CGI 214
Using PHP 215
Defining main() 217
Room to grow 218
Summary 218
Chapter 8: Creating Users and Granting Access 219
A word on security 219
Creating users in MySQL 220
Forcing the use of a password 221
Restricting the client's host 221
Creating users from Python 223
Removing users in MySQL 224
DROPping users in Python 225
GRANT access in MySQL 225
Important dynamics of GRANTing access 226
The GRANT statement in MySQL 226
Using REQUIREments of access 229
[ vii ]
Table of Contents
Using a WITH clause 230
Granting access in Python 231
Removing privileges in MySQL 233
Basic syntax 233
After using REVOKE, the user still has access!? 233
Using REVOKE in Python 235
Project: Web-based user administration 236
New options in the code 236
Adding the functions: CREATE and DROP 239
Adding CREATE and DROP to main() 240
Adding the functions: GRANT and REVOKE 241
Adding GRANT and REVOKE to main() 241
Test the program 243
New options on the page 244
Room to grow 244
Summary 245
Chapter 9: Date and Time Values 247
Date and time data types in MySQL 247
DATETIME 248
Output format 248
Input formats 248
Input range 249
Using DATETIME in a CREATE statement 249
DATE 249
Output and Input formats 249
Input range 250
TIMESTAMP 250
Input of values 250
Range 251
Defaults, initialization, and updating 251
YEAR 252
Two-digit YEAR values 252
Four-digit YEAR values 252
Valid input 253
TIME 253
Format 254
Invalid values 255
Date and time types in Python 256
Date and time functions 257
NOW() 260
CURDATE() 260
CURTIME() 261
DATE() 261
[ viii ]
Table of Contents
DATE_SUB() and DATE_ADD() 262
DATEDIFF() 266
DATE_FORMAT() 267
EXTRACT() 269
TIME() 270
Project: Logging user activity 270
The log framework 272
The logger() function 273
Creating the database 273
Using the database 274
Creating the table 274
Forming the INSERT statement 274
Ensure logging occurs 275
Room to grow 276
Summary 277
Chapter 10: Aggregate Functions and Clauses 279
Calculations in MySQL 280
COUNT() 281
SUM() 282
MAX() 283
MIN() 284
AVG() 284
The different kinds of average 285
Trimming results 287
DISTINCT 287
GROUP_CONCAT() 289
Specifying the delimiter 290
Customizing the maximum length 290
Using GROUP_CONCAT() with DISTINCT 291
Server-side sorting in MySQL 292
GROUP BY 293
ORDER BY 294
Using a universal quantifier 294
Sorting alphabetically or from low-to-high 295
Reversing the alphabet or sorting high-to-low 296
Sorting with multiple keys 298
Putting it in Python 298
Project: Incorporating aggregate functions 300
Adding to qaction() 300
New variables 301
New statement formation 302
Revising main() 305
Setting up the options 308
[ ix ]
Table of Contents
Changing the HTML form 309
Summary 310
Chapter 11: SELECT Alternatives 311
HAVING clause 312
WHERE versus HAVING: Syntax 312
WHERE versus HAVING: Aggregate functions 312
WHERE versus HAVING: Application 314
Subqueries 317
Unions 319
Joins 321
LEFT and RIGHT joins 321
OUTER joins 323
INNER joins 324
NATURAL joins 326
CROSS joins 327
Doing it in Python 327
Subqueries 328
Unions 329
Joins 329
Project: Implement HAVING 330
Revising the Python backend 331
Revising qaction() 331
Revising main() 333
Revising the options 336
Revising the HTML interface 337
Room to grow 338
Summary 339
Chapter 12: String Functions 341
Preparing results before their return 341
CONCAT() function 342
SUBSTRING() or MID() 343
TRIM() 344
Basic syntax 344
Options 345
Alternatives 346
REPLACE() 347
INSERT() 348
REGEXP 350
Accessing and using index data 354
LENGTH() 354
INSTR() or LOCATE() 355
[  ]
Table of Contents
INSTR() 356
LOCATE() 356
Nuancing data 357
ROUND() 357
FORMAT() 359
UPPER() 360
LOWER() 360
Project: Creating your own functions 360
Hello() 361
Capitalise() 362
DELIMITER 362
The function definition 362
Calling the function 364
Defining the function in Python 365
Defining the function as a Python value 365
Sourcing the MySQL function as a Python module 366
Sourcing the function as MySQL code 366
Room to grow 367
Summary 367
Chapter 13: Showing MySQL Metadata 369
MySQL's system environment 370
ENGINE 371
The most popular engines 372
Transactions 372
Specifying the engine 373
ENGINE status 373
SHOW ENGINES 374
Profiling 375
SHOW PROFILE 375
SHOW PROFILES 376
SHOW system variables 376
Accessing database metadata 377
DATABASES 377
Using the USE command 378
Accessing metadata about tables 378
SHOW TABLES 378
SHOW TABLE STATUS 379
Showing columns from a table 379
FUNCTION STATUS 380
Accessing user metadata 383
SHOW GRANTS 383
PRIVILEGES 384
Project: Building a database class 384
Writing the class 384
[ xi ]
Table of Contents
Defining fetchquery() and some core methods 385
Retrieving table status and structure 386
Retrieving the CREATE statements 386
Define main()—part 1 387
Writing resproc() 388
Define main()—part 2 389
The preamble 389
Modules and variables 390
Login and USE 390
Closing out the program 390
Room to grow 391
Summary 391
Chapter 14: Disaster Recovery 393
Every database needs a backup plan 394
Offline backups 394
Live backups 395
Choosing a backup method 395
Copying the table files 396
Locking and flushing 397
Unlocking the tables 398
Restoring the data 398
Delimited backups within MySQL 398
Using SELECT INTO OUTFILE to export data 398
Using LOAD DATA INFILE to import data 399
Archiving from the command line 400
mysqldump 400
mysqlhotcopy 403
Backing up a database with Python 405
Summary 406
Index 407