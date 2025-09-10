Table of Contents
Preface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . xiii
1. 2. Retrieving Records. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1
1.1 Retrieving All Rows and Columns from a Table 1
1.2 Retrieving a Subset of Rows from a Table 2
1.3 Finding Rows That Satisfy Multiple Conditions 2
1.4 Retrieving a Subset of Columns from a Table 3
1.5 Providing Meaningful Names for Columns 4
1.6 Referencing an Aliased Column in the WHERE Clause 5
1.7 Concatenating Column Values 6
1.8 Using Conditional Logic in a SELECT Statement 7
1.9 Limiting the Number of Rows Returned 8
1.10 Returning n Random Records from a Table 10
1.11 Finding Null Values 11
1.12 Transforming Nulls into Real Values 12
1.13 Searching for Patterns 13
1.14 Summing Up 14
Sorting Query Results. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 2.1 Returning Query Results in a Specified Order 2.2 Sorting by Multiple Fields 2.3 Sorting by Substrings 17
2.4 Sorting Mixed Alphanumeric Data 2.5 Dealing with Nulls When Sorting 2.6 Sorting on a Data-Dependent Key 15
15
16
18
21
27
2.7 Summing Up 28
vii
3. 4. 5. Working with Multiple Tables. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 3.1 Stacking One Rowset atop Another 3.2 Combining Related Rows 31
3.3 Finding Rows in Common Between Two Tables 3.4 Retrieving Values from One Table That Do Not Exist in Another 29
29
33
34
3.5 Retrieving Rows from One Table That Do Not Correspond to Rows in
Another 40
3.6 Adding Joins to a Query Without Interfering with Other Joins 3.7 Determining Whether Two Tables Have the Same Data 3.8 Identifying and Avoiding Cartesian Products 3.9 Performing Joins When Using Aggregates 3.10 Performing Outer Joins When Using Aggregates 3.11 Returning Missing Data from Multiple Tables 3.12 Using NULLs in Operations and Comparisons 42
44
51
52
57
60
64
3.13 Summing Up 65
Inserting, Updating, and Deleting. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 4.1 Inserting a New Record 4.2 Inserting Default Values 68
4.3 Overriding a Default Value with NULL 4.4 Copying Rows from One Table into Another 4.5 Copying a Table Definition 4.6 Inserting into Multiple Tables at Once 4.7 Blocking Inserts to Certain Columns 4.8 Modifying Records in a Table 4.9 Updating When Corresponding Rows Exist 4.10 Updating with Values from Another Table 4.11 Merging Records 81
4.12 Deleting All Records from a Table 4.13 Deleting Specific Records 83
4.14 Deleting a Single Record 4.15 Deleting Referential Integrity Violations 4.16 Deleting Duplicate Records 85
4.17 Deleting Records Referenced from Another Table 67
68
70
70
71
72
74
75
77
78
83
84
85
87
4.18 Summing Up 89
Metadata Queries. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 5.1 Listing Tables in a Schema 5.2 Listing a Table’s Columns 5.3 Listing Indexed Columns for a Table 5.4 Listing Constraints on a Table 5.5 Listing Foreign Keys Without Corresponding Indexes 91
91
93
94
95
97
viii | Table of Contents
5.6 Using SQL to Generate SQL 100
5.7 Describing the Data Dictionary Views in an Oracle Database 5.8 Summing Up 102
103
6. Working with Strings. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 105
6.1 Walking a String 106
6.2 Embedding Quotes Within String Literals 108
6.3 Counting the Occurrences of a Character in a String 109
6.4 Removing Unwanted Characters from a String 110
6.5 Separating Numeric and Character Data 112
6.6 Determining Whether a String Is Alphanumeric 116
6.7 Extracting Initials from a Name 120
6.8 Ordering by Parts of a String 125
6.9 Ordering by a Number in a String 126
6.10 Creating a Delimited List from Table Rows 132
6.11 Converting Delimited Data into a Multivalued IN-List 136
6.12 Alphabetizing a String 141
6.13 Identifying Strings That Can Be Treated as Numbers 147
6.14 Extracting the nth Delimited Substring 153
6.15 Parsing an IP Address 160
6.16 Comparing Strings by Sound 162
6.17 Finding Text Not Matching a Pattern 164
6.18 Summing Up 167
7. Working with Numbers. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 169
7.1 Computing an Average 169
7.2 Finding the Min/Max Value in a Column 171
7.3 Summing the Values in a Column 173
7.4 Counting Rows in a Table 175
7.5 Counting Values in a Column 177
7.6 Generating a Running Total 178
7.7 Generating a Running Product 179
7.8 Smoothing a Series of Values 181
7.9 Calculating a Mode 182
7.10 Calculating a Median 185
7.11 Determining the Percentage of a Total 187
7.12 Aggregating Nullable Columns 190
7.13 Computing Averages Without High and Low Values 191
7.14 Converting Alphanumeric Strings into Numbers 193
7.15 Changing Values in a Running Total 196
7.16 Finding Outliers Using the Median Absolute Deviation 197
7.17 Finding Anomalies Using Benford’s Law 201
Table of Contents | ix
8. 9. 10. 11. 7.18 Summing Up 203
Date Arithmetic. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 205
8.1 Adding and Subtracting Days, Months, and Years 205
8.2 Determining the Number of Days Between Two Dates 208
8.3 Determining the Number of Business Days Between Two Dates 210
8.4 Determining the Number of Months or Years Between Two Dates 215
8.5 Determining the Number of Seconds, Minutes, or Hours Between Two
Dates 218
8.6 Counting the Occurrences of Weekdays in a Year 220
8.7 Determining the Date Difference Between the Current Record and the
Next Record 231
8.8 Summing Up 237
Date Manipulation. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 9.1 Determining Whether a Year Is a Leap Year 9.2 Determining the Number of Days in a Year 9.3 Extracting Units of Time from a Date 9.4 Determining the First and Last Days of a Month 9.5 Determining All Dates for a Particular Weekday Throughout a Year 239
240
246
249
252
255
9.6 Determining the Date of the First and Last Occurrences of a Specific
Weekday in a Month 261
9.7 Creating a Calendar 268
9.8 Listing Quarter Start and End Dates for the Year 281
9.9 Determining Quarter Start and End Dates for a Given Quarter 286
9.10 Filling in Missing Dates 293
9.11 Searching on Specific Units of Time 301
9.12 Comparing Records Using Specific Parts of a Date 302
9.13 Identifying Overlapping Date Ranges 305
9.14 Summing Up 311
Working with Ranges. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 10.1 Locating a Range of Consecutive Values 10.2 Finding Differences Between Rows in the Same Group or Partition 10.3 Locating the Beginning and End of a Range of Consecutive Values 10.4 Filling in Missing Values in a Range of Values 10.5 Generating Consecutive Numeric Values 313
313
317
323
326
330
10.6 Summing Up 333
Advanced Searching. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 11.1 Paginating Through a Result Set 11.2 Skipping n Rows from a Table 335
335
338
x | Table of Contents
12. 13. 11.3 Incorporating OR Logic When Using Outer Joins 339
11.4 Determining Which Rows Are Reciprocals 341
11.5 Selecting the Top n Records 343
11.6 Finding Records with the Highest and Lowest Values 344
11.7 Investigating Future Rows 345
11.8 Shifting Row Values 347
11.9 Ranking Results 350
11.10 Suppressing Duplicates 351
11.11 Finding Knight Values 353
11.12 Generating Simple Forecasts 359
11.13 Summing Up 367
Reporting and Reshaping. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 369
12.1 Pivoting a Result Set into One Row 369
12.2 Pivoting a Result Set into Multiple Rows 372
12.3 Reverse Pivoting a Result Set 377
12.4 Reverse Pivoting a Result Set into One Column 379
12.5 Suppressing Repeating Values from a Result Set 382
12.6 Pivoting a Result Set to Facilitate Inter-Row Calculations 384
12.7 Creating Buckets of Data, of a Fixed Size 386
12.8 Creating a Predefined Number of Buckets 388
12.9 Creating Horizontal Histograms 390
12.10 Creating Vertical Histograms 392
12.11 Returning Non-GROUP BY Columns 394
12.12 Calculating Simple Subtotals 397
12.13 Calculating Subtotals for All Possible Expression Combinations 400
12.14 Identifying Rows That Are Not Subtotals 410
12.15 Using Case Expressions to Flag Rows 412
12.16 Creating a Sparse Matrix 414
12.17 Grouping Rows by Units of Time 416
12.18 Performing Aggregations over Different Groups/Partitions
Simultaneously 420
12.19 Performing Aggregations over a Moving Range of Values 12.20 Pivoting a Result Set with Subtotals 422
429
12.21 Summing Up 434
Hierarchical Queries. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 13.1 Expressing a Parent-Child Relationship 13.2 Expressing a Child-Parent-Grandparent Relationship 13.3 Creating a Hierarchical View of a Table 13.4 Finding All Child Rows for a Given Parent Row 13.5 Determining Which Rows Are Leaf, Branch, or Root Nodes 435
436
440
444
449
450
Table of Contents | xi
13.6 Summing Up 458
14. Odds ’n’ Ends. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 14.1 Creating Cross-Tab Reports Using SQL Server’s PIVOT Operator 14.2 Unpivoting a Cross-Tab Report Using SQL Server’s UNPIVOT Operator 14.3 Transposing a Result Set Using Oracle’s MODEL Clause 14.4 Extracting Elements of a String from Unfixed Locations 14.5 Finding the Number of Days in a Year (an Alternate Solution for Oracle) 14.6 Searching for Mixed Alphanumeric Strings 14.7 Converting Whole Numbers to Binary Using Oracle 14.8 Pivoting a Ranked Result Set 14.9 Adding a Column Header into a Double Pivoted Result Set 14.10 Converting a Scalar Subquery to a Composite Subquery in Oracle 14.11 Parsing Serialized Data into Rows 14.12 Calculating Percent Relative to Total 14.13 Testing for Existence of a Value Within a Group 459
459
461
463
467
470
472
474
477
481
493
495
500
502
14.14 Summing Up 505
A. Window Function Refresher. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 507
B. Common Table Expressions. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 535
Index. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 539