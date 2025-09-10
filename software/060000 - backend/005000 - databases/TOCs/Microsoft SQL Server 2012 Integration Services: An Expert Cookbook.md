Table of Contents
Preface 1
7
Chapter 1: Getting Started with SQL Server Integration Services
Introduction 7
Import and Export Wizard: First experience with SSIS 9
Getting started with SSDT
Creating the first SSIS Package Getting familiar with Data Flow Task
SSIS 2012 versus previous versions in Developer Experience Chapter 2: Control Flow Tasks Introduction 35
Executing T-SQL commands: Execute SQL Task Handling file and folder operations: File System Task Sending and receiving files through FTP: FTP Task Executing other packages: Execute Package Task Running external applications: Execute Process Task Reading data from web methods: Web Service Task Transforming, validating, and querying XML: XML Task Profiling table statistics: Data Profiling Task Batch insertion of data into a database: Bulk Insert Task Querying system information: WMI Data Reader Task Querying system events: WMI Event Watcher Task Transferring SQL server objects: DBMS Tasks Chapter 3: Data Flow Task Part 1—Extract and Load Introduction 91
Working with database connections in Data Flow Working with flat files in Data Flow Passing data between packages—Raw Source and Destination 17
25
27
30
35
36
43
48
52
57
60
64
73
76
80
84
87
91
92
104
108
Table of Contents
Importing XML data with XML Source Loading data into memory—Recordset Destination
Extracting and loading Excel data Change Data Capture 127
Chapter 4: Data Flow Task Part 2—Transformations Introduction 135
Derived Column: adding calculated columns
Audit Transformation: logging in Data Flow Aggregate Transform: aggregating the data stream Conditional Split: dividing the data stream based on conditions Lookup Transform: performing the Upsert scenario 113
118
121
135
136
139
143
148
152
OLE DB Command: executing SQL statements on each row
in the data stream 161
Merge and Union All transformations: combining input data rows
Merge Join Transform: performing different types of joins in data flow
Multicast: creating copies of the data stream 165
168
177
Working with BLOB fields: Export Column and Import Column
transformations 180
Slowly Changing Dimensions (SCDs) in SSIS
185
Chapter 5: Data Flow Task Part 3—Advanced Transformation 193
Introduction 193
Pivot and Unpivot Transformations 194
Text Analysis with Term Lookup and Term Extraction transformations 207
DQS Cleansing Transformation—Cleansing Data 214
Fuzzy Transformations—how SSIS understands fuzzy similarities 220
Chapter 6: Variables, Expressions, and Dynamism in SSIS 229
Introduction 229
Variables and data types 230
Using expressions in Control Flow 237
Using expressions in Data Flow 240
The Expression Task 246
Dynamic connection managers 249
Dynamic data transfer with different data structures 256
Chapter 7: Containers and Precedence Constraints 261
Introduction 261
Sequence Container: putting all tasks in an executable object 262
For Loop Container: looping through static enumerator till
a condition is met 266
Foreach Loop Container: looping through result set of a database query 271
ii
Table of Contents
277
282
289
Foreach Loop Container: looping through files using File Enumerator Foreach Loop Container: looping through data table Precedence Constraints: how to control the flow of task execution Chapter 8: Scripting 295
Introduction 295
The Script Task: Scripting through Control Flow 296
The Script Component as a Transformation 299
The Script Component as a Source 303
The Script Component as a Destination 310
The Asynchronous Script Component 315
Chapter 9: Deployment 323
Introduction 323
Project Deployment Model: Project Deployment from SSDT 324
Using Integration Services Deployment Wizard and
command-line utility for deployment 331
The Package Deployment Model, Using SSDT to deploy package Creating and running Deployment Utility DTUTIL—the command-line utility for deployment Protection level: Securing sensitive data 335
341
344
348
Chapter 10: Debugging, Troubleshooting, and Migrating Packages
to 2012 355
Introduction 355
Troubleshooting with Progress and Execution Results tab Breakpoints, Debugging the Control Flow Handling errors in Data Flow Migrating packages to 2012 373
Data Tap 377
Chapter 11: Event Handling and Logging Introduction 383
Logging over Legacy Deployment Model Logging over Project Deployment Model Using event handlers and system variables for custom logging Chapter 12: Execution 409
Introduction 409
Execution from SSMS
Execution from a command-line utility
Execution from a scheduled SQL Server Agent job 356
360
367
383
384
389
398
410
415
420
iii
Table of Contents
Chapter 13: Restartability and Robustness 429
Introduction 429
Parameters: Passing values to packages from outside 430
Package configuration: Legacy method to inter-relation 442
Transactions: Doing multiple operations atomic 453
Checkpoints: The power of restartability 459
SSIS reports and catalog views 464
Chapter 14: Programming SSIS 471
Introduction 471
Creating and configuring Control Flow Tasks programmatically 472
Working with Data Flow components programmatically 478
Executing and managing packages programmatically 487
Creating and using Custom Tasks 491
Chapter 15: Performance Boost in SSIS 503
Introduction 503
Control Flow Task and variables considerations for boosting performance 504
Data Flow best practices in Extract and Load 508
Data Flow best practices in Transformations 512
Working with buffer size 520
Working with performance counters 522
Index 527