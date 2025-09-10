Table of Contents
Preface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ix
1. 2. A Little Background . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1
Introduction to Databases 1
Nonrelational Database Systems 2
The Relational Model 4
Some Terminology 6
What Is SQL? 7
SQL Statement Classes 7
SQL: A Nonprocedural Language 9
SQL Examples 10
What Is MySQL? 12
What’s in Store 13
Creating and Populating a Database . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 15
Creating a MySQL Database 15
Using the mysql Command-Line Tool 17
MySQL Data Types 18
Character Data 18
Numeric Data 21
Temporal Data 23
Table Creation 25
Step 1: Design 25
Step 2: Refinement 26
Step 3: Building SQL Schema Statements 27
Populating and Modifying Tables 30
Inserting Data 31
Updating Data 35
Deleting Data 35
When Good Statements Go Bad 36
Nonunique Primary Key 36
Nonexistent Foreign Key 36
iii
D l d t W B k C
3. 4. 5. Column Value Violations 37
Invalid Date Conversions 37
The Bank Schema 38
Query Primer . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 41
Query Mechanics 41
Query Clauses 43
The select Clause 43
Column Aliases 46
Removing Duplicates 47
The from Clause 48
Tables 49
Table Links 51
Defining Table Aliases 52
The where Clause 52
The group by and having Clauses 54
The order by Clause 55
Ascending Versus Descending Sort Order 57
Sorting via Expressions 58
Sorting via Numeric Placeholders 59
Test Your Knowledge 60
Filtering . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 63
Condition Evaluation 63
Using Parentheses 64
Using the not Operator 65
Building a Condition 66
Condition Types 66
Equality Conditions 66
Range Conditions 68
Membership Conditions 71
Matching Conditions 73
Null: That Four-Letter Word 76
Test Your Knowledge 79
Querying Multiple Tables . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 81
What Is a Join? 81
Cartesian Product 82
Inner Joins 83
The ANSI Join Syntax 86
Joining Three or More Tables 88
Using Subqueries As Tables 90
Using the Same Table Twice 92
iv | Table of Contents
D l d t W B k C
Self-Joins 93
Equi-Joins Versus Non-Equi-Joins 94
Join Conditions Versus Filter Conditions 96
Test Your Knowledge 97
6. Working with Sets . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . Set Theory Primer 99
Set Theory in Practice 101
Set Operators 103
The union Operator 103
The intersect Operator 106
The except Operator 107
Set Operation Rules 108
Sorting Compound Query Results 108
Set Operation Precedence 109
Test Your Knowledge 111
7. Data Generation, Conversion, and Manipulation . . . . . . . . . . . . . . . . . . . . . . . . . . . 113
Working with String Data 113
String Generation 114
String Manipulation 119
Working with Numeric Data 126
Performing Arithmetic Functions 126
Controlling Number Precision 128
Handling Signed Data 130
Working with Temporal Data 130
Dealing with Time Zones 131
Generating Temporal Data 132
Manipulating Temporal Data 137
Conversion Functions 141
Test Your Knowledge 142
8. Grouping and Aggregates . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 143
Grouping Concepts 143
Aggregate Functions 145
Implicit Versus Explicit Groups 146
Counting Distinct Values 147
Using Expressions 149
How Nulls Are Handled 149
Generating Groups 150
Single-Column Grouping 151
Multicolumn Grouping 151
Grouping via Expressions 152
99
Table of Contents | v
D l d t W B k C
Generating Rollups 152
Group Filter Conditions 155
Test Your Knowledge 156
9. Subqueries . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 157
What Is a Subquery? 157
Subquery Types 158
Noncorrelated Subqueries 159
Multiple-Row, Single-Column Subqueries 160
Multicolumn Subqueries 165
Correlated Subqueries 167
The exists Operator 169
Data Manipulation Using Correlated Subqueries 170
When to Use Subqueries 171
Subqueries As Data Sources 172
Subqueries in Filter Conditions 177
Subqueries As Expression Generators 177
Subquery Wrap-up 181
Test Your Knowledge 181
10. Joins Revisited . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 183
Outer Joins 183
Left Versus Right Outer Joins 187
Three-Way Outer Joins 188
Self Outer Joins 190
Cross Joins 192
Natural Joins 198
Test Your Knowledge 200
11. Conditional Logic . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 203
What Is Conditional Logic? 203
The Case Expression 204
Searched Case Expressions 205
Simple Case Expressions 206
Case Expression Examples 207
Result Set Transformations 208
Selective Aggregation 209
Checking for Existence 211
Division-by-Zero Errors 212
Conditional Updates 213
Handling Null Values 214
Test Your Knowledge 215
vi | Table of Contents
D l d t W B k C
12. 13. 14. 15. Transactions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 217
Multiuser Databases 217
Locking 217
Lock Granularities 218
What Is a Transaction? 219
Starting a Transaction 220
Ending a Transaction 221
Transaction Savepoints 223
Test Your Knowledge 225
Indexes and Constraints . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 227
Indexes 227
Index Creation 228
Types of Indexes 231
How Indexes Are Used 234
The Downside of Indexes 237
Constraints 238
Constraint Creation 238
Constraints and Indexes 239
Cascading Constraints 240
Test Your Knowledge 242
Views . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 245
What Are Views? 245
Why Use Views? 248
Data Security 248
Data Aggregation 249
Hiding Complexity 250
Joining Partitioned Data 251
Updatable Views 251
Updating Simple Views 252
Updating Complex Views 253
Test Your Knowledge 255
Metadata . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 257
Data About Data 257
Information_Schema 258
Working with Metadata 262
Schema Generation Scripts 263
Deployment Verification 265
Dynamic SQL Generation 266
Test Your Knowledge 270
Table of Contents | vii
D l d t W B k C
A. B. C. ER Diagram for Example Database . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 271
MySQL Extensions to the SQL Language . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 273
Solutions to Exercises . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 287
Index . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 309