Table of Contents
Preface xi
Chapter 1: SQL Crash Course 1
What Is a Database? 1
SQL 1
NoSQL 2
Database Management Systems (DBMS) 3
A SQL Query 6
The SELECT Statement 7
Order of Execution 9
A Data Model 10
Chapter 2: Where Can I Write SQL Code? 13
RDBMS Software 14
SQLite 15
MySQL 17
Oracle 17
PostgreSQL 18
SQL Server 19
iii
Database Tools 20
Connect a Database Tool to a Database 22
Other Programming Languages 24
Connect Python to a Database 25
Connect R to a Database 31
Chapter 3: The SQL Language 37
Comparison to Other Languages 37
ANSI Standards 39
SQL Terms 41
Keywords and Functions 42
Identifiers and Aliases 43
Statements and Clauses 45
Expressions and Predicates 47
Comments, Quotes, and Whitespace 48
Sublanguages 50
Chapter 4: Querying Basics 53
The SELECT Clause 55
Aliasing Columns 57
Qualifying Columns 59
Selecting Subqueries 61
DISTINCT 63
The FROM Clause 66
From Multiple Tables 66
From Subqueries 69
The WHERE Clause 73
Filtering on Subqueries 75
The GROUP BY Clause 78
The HAVING Clause 83
The ORDER BY Clause 85
iv | Table of Contents
The LIMIT Clause 88
Chapter 5: Creating, Updating, and Deleting 91
Databases 91
Display Names of Existing Databases 93
Display Name of Current Database 94
Switch to Another Database 95
Create a Database 95
Delete a Database 96
Creating Tables 97
Create a Simple Table 98
Display Names of Existing Tables 100
Create a Table That Does Not Already Exist 100
Create a Table with Constraints 101
Create a Table with Primary and Foreign Keys 105
Create a Table with an Automatically Generated Field 108
Insert the Results of a Query into a Table 110
Insert Data from a Text File into a Table 112
Modifying Tables 115
Rename a Table or Column 115
Display, Add, and Delete Columns 117
Display, Add, and Delete Rows 119
Display, Add, Modify, and Delete Constraints 120
Update a Column of Data 124
Update Rows of Data 125
Update Rows of Data with the Results of a Query 126
Delete a Table 128
Indexes 129
Create an Index to Speed Up Queries 131
Views 133
Create a View to Save the Results of a Query 135
Table of Contents | v
Transaction Management 138
Double-Check Changes Before a COMMIT 139
Undo Changes with a ROLLBACK 141
Chapter 6: Data Types 143
How to Choose a Data Type 145
Numeric Data 147
Numeric Values 147
Integer Data Types 148
Decimal Data Types 150
Floating Point Data Types 151
String Data 154
String Values 154
Character Data Types 156
Unicode Data Types 159
Datetime Data 161
Datetime Values 161
Datetime Data Types 165
Other Data 172
Boolean Data 172
External Files (Images, Documents, etc.) 173
Chapter 7: Operators and Functions 179
Operators 180
Logical Operators 181
Comparison Operators 182
Math Operators 189
Aggregate Functions 191
Numeric Functions 193
Apply Math Functions 194
Generate Random Numbers 196
vi | Table of Contents
Round and Truncate Numbers 197
Convert Data to a Numeric Data Type 198
String Functions 199
Find the Length of a String 199
Change the Case of a String 200
Trim Unwanted Characters Around a String 201
Concatenate Strings 203
Search for Text in a String 203
Extract a Portion of a String 206
Replace Text in a String 207
Delete Text from a String 208
Use Regular Expressions 209
Convert Data to a String Data Type 217
Datetime Functions 218
Return the Current Date or Time 218
Add or Subtract a Date or Time Interval 220
Find the Difference Between Two Dates or Times 221
Extract a Part of a Date or Time 226
Determine the Day of the Week of a Date 228
Round a Date to the Nearest Time Unit 229
Convert a String to a Datetime Data Type 230
Null Functions 234
Return an Alternative Value if There Is a Null Value 235
Chapter 8: Advanced Querying Concepts 237
Case Statements 238
Display Values Based on If-Then Logic
for a Single Column 239
Display Values Based on If-Then Logic
for Multiple Columns 240
Grouping and Summarizing 242
Table of Contents | vii
GROUP BY Basics 242
Aggregate Rows into a Single Value or List 245
ROLLUP, CUBE, and GROUPING SETS 247
Window Functions 250
Rank the Rows in a Table 252
Return the First Value in Each Group 255
Return the Second Value in Each Group 256
Return the First Two Values in Each Group 257
Return the Prior Row Value 258
Calculate the Moving Average 259
Calculate the Running Total 261
Pivoting and Unpivoting 263
Break Up the Values of a Column into Multiple
Columns 263
List the Values of Multiple Columns in a Single
Column 265
Chapter 9: Working with Multiple Tables and Queries 269
Joining Tables 270
Join Basics and INNER JOIN 274
LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN 277
USING and NATURAL JOIN 279
CROSS JOIN and Self Join 281
Union Operators 284
UNION 285
EXCEPT and INTERSECT 289
Common Table Expressions 291
CTEs Versus Subqueries 293
Recursive CTEs 295
viii | Table of Contents
Chapter 10: How Do I…? Find the Rows Containing Duplicate Values Select Rows with the Max Value for Another Column 303
303
306
Concatenate Text from Multiple Fields into a Single
Field 308
Find All Tables Containing a Specific Column Name Update a Table Where the ID Matches Another Table 311
313
Index 317