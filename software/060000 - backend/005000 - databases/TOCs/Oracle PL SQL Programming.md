Table of Contents
Preface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . xxv
Part I. Programming in PL/SQL
1. Introduction to PL/SQL. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 3
What Is PL/SQL? 3
The Origins of PL/SQL 4
The Early Years of PL/SQL 4
Improved Application Portability 5
Improved Execution Authority and Transaction Integrity 5
Humble Beginnings, Steady Improvement 6
So This Is PL/SQL 7
Integration with SQL 7
Control and Conditional Logic 8
When Things Go Wrong 9
About PL/SQL Versions 11
Oracle Database 12c New PL/SQL Features 12
Resources for PL/SQL Developers 14
The O’Reilly PL/SQL Series 15
PL/SQL on the Internet 16
Some Words of Advice 17
Don’t Be in Such a Hurry! 17
Don’t Be Afraid to Ask for Help 18
Take a Creative, Even Radical Approach 19
2. Creating and Running PL/SQL Code. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . Navigating the Database 21
Creating and Editing Source Code 21
22
SQL*Plus 23
v
www.it-ebooks.info
3. Starting Up SQL*Plus 24
Running a SQL Statement 26
Running a PL/SQL Program 27
Running a Script 29
What Is the “Current Directory”? 30
Other SQL*Plus Tasks 31
Error Handling in SQL*Plus 36
Why You Will Love and Hate SQL*Plus 36
Performing Essential PL/SQL Tasks 37
Creating a Stored Program 37
Executing a Stored Program 41
Showing Stored Programs 41
Managing Grants and Synonyms for Stored Programs 42
Dropping a Stored Program 43
Hiding the Source Code of a Stored Program 44
Editing Environments for PL/SQL 44
Calling PL/SQL from Other Languages 45
C: Using Oracle’s Precompiler (Pro*C) 46
Java: Using JDBC 47
Perl: Using Perl DBI and DBD::Oracle 48
PHP: Using Oracle Extensions 49
PL/SQL Server Pages 51
And Where Else? 51
Language Fundamentals. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 53
PL/SQL Block Structure 53
Anonymous Blocks 55
Named Blocks 57
Nested Blocks 57
Scope 58
Qualify All References to Variables and Columns in SQL Statements 59
Visibility 62
The PL/SQL Character Set 65
Identifiers 67
Reserved Words 68
Whitespace and Keywords 70
Literals 70
NULLs 71
Embedding Single Quotes Inside a Literal String 72
Numeric Literals 73
Boolean Literals 74
The Semicolon Delimiter 74
vi | Table of Contents
www.it-ebooks.info
Comments 75
Single-Line Comment Syntax 75
Multiline Comment Syntax 76
The PRAGMA Keyword 76
Labels 77
Part II. PL/SQL Program Structure
5. 4. Conditional and Sequential Control. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 83
IF Statements 83
The IF-THEN Combination 84
The IF-THEN-ELSE Combination 86
The IF-THEN-ELSIF Combination 87
Avoiding IF Syntax Gotchas 89
Nested IF Statements 90
Short-Circuit Evaluation 91
CASE Statements and Expressions 93
Simple CASE Statements 93
Searched CASE Statements 95
Nested CASE Statements 98
CASE Expressions 98
The GOTO Statement 100
The NULL Statement 101
Improving Program Readability 101
Using NULL After a Label 102
Iterative Processing with Loops. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 105
Loop Basics 105
Examples of Different Loops 106
Structure of PL/SQL Loops 107
The Simple Loop 108
Terminating a Simple Loop: EXIT and EXIT WHEN 109
Emulating a REPEAT UNTIL Loop 110
The Intentionally Infinite Loop 111
The WHILE Loop 112
The Numeric FOR Loop 114
Rules for Numeric FOR Loops 114
Examples of Numeric FOR Loops 115
Handling Nontrivial Increments 116
The Cursor FOR Loop 117
Example of Cursor FOR Loops 118
Table of Contents | vii
www.it-ebooks.info
6. Loop Labels 119
The CONTINUE Statement 120
Tips for Iterative Processing 123
Use Understandable Names for Loop Indexes 123
The Proper Way to Say Goodbye 124
Obtaining Information About FOR Loop Execution 126
SQL Statement as Loop 126
Exception Handlers. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 129
Exception-Handling Concepts and Terminology 129
Defining Exceptions 132
Declaring Named Exceptions 132
Associating Exception Names with Error Codes 133
About Named System Exceptions 136
Scope of an Exception 139
Raising Exceptions 140
The RAISE Statement 140
Using RAISE_APPLICATION_ERROR 141
Handling Exceptions 143
Built-in Error Functions 144
Combining Multiple Exceptions in a Single Handler 149
Unhandled Exceptions 149
Propagation of Unhandled Exceptions 150
Continuing Past Exceptions 153
Writing WHEN OTHERS Handling Code 155
Building an Effective Error Management Architecture 157
Decide on Your Error Management Strategy 158
Standardize Handling of Different Types of Exceptions 159
Organize Use of Application-Specific Error Codes 162
Use Standardized Error Management Programs 163
Work with Your Own Exception “Objects” 165
Create Standard Templates for Common Error Handling 167
Making the Most of PL/SQL Error Management 169
Part III. PL/SQL Program Data
7. Working with Program Data. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 173
Naming Your Program Data 173
Overview of PL/SQL Datatypes 175
Character Data 176
Numbers 177
viii | Table of Contents
www.it-ebooks.info
8. 9. Dates, Timestamps, and Intervals 178
Booleans 178
Binary Data 179
ROWIDs 179
REF CURSORs 179
Internet Datatypes 180
“Any” Datatypes 180
User-Defined Datatypes 181
Declaring Program Data 181
Declaring a Variable 181
Declaring Constants 182
The NOT NULL Clause 183
Anchored Declarations 183
Anchoring to Cursors and Tables 185
Benefits of Anchored Declarations 186
Anchoring to NOT NULL Datatypes 188
Programmer-Defined Subtypes 188
Conversion Between Datatypes 189
Implicit Data Conversion 189
Explicit Datatype Conversion 192
Strings. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 199
String Datatypes 199
The VARCHAR2 Datatype 200
The CHAR Datatype 201
String Subtypes 202
Working with Strings 203
Specifying String Constants 203
Using Nonprintable Characters 205
Concatenating Strings 206
Dealing with Case 207
Traditional Searching, Extracting, and Replacing 210
Padding 213
Trimming 215
Regular Expression Searching, Extracting, and Replacing 216
Working with Empty Strings 227
Mixing CHAR and VARCHAR2 Values 229
String Function Quick Reference 231
Numbers. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 241
Numeric Datatypes 241
The NUMBER Type 242
Table of Contents | ix
www.it-ebooks.info
10. The PLS_INTEGER Type 247
The BINARY_INTEGER Type 248
The SIMPLE_INTEGER Type 249
The BINARY_FLOAT and BINARY_DOUBLE Types 251
The SIMPLE_FLOAT and SIMPLE_DOUBLE Types 256
Numeric Subtypes 256
Number Conversions 257
The TO_NUMBER Function 258
The TO_CHAR Function 261
The CAST Function 267
Implicit Conversions 268
Numeric Operators 270
Numeric Functions 271
Rounding and Truncation Functions 271
Trigonometric Functions 272
Numeric Function Quick Reference 272
Dates and Timestamps. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 277
Datetime Datatypes 278
Declaring Datetime Variables 280
Choosing a Datetime Datatype 281
Getting the Current Date and Time 282
Interval Datatypes 284
Declaring INTERVAL Variables 286
When to Use INTERVALs 287
Datetime Conversions 289
From Strings to Datetimes 289
From Datetimes to Strings 292
Working with Time Zones 295
Requiring a Format Mask to Match Exactly 298
Easing Up on Exact Matches 299
Interpreting Two-Digit Years in a Sliding Window 299
Converting Time Zones to Character Strings 301
Padding Output with Fill Mode 302
Date and Timestamp Literals 302
Interval Conversions 304
Converting from Numbers to Intervals 304
Converting Strings to Intervals 305
Formatting Intervals for Display 306
Interval Literals 307
CAST and EXTRACT 308
The CAST Function 308
x | Table of Contents
www.it-ebooks.info
11. 12. The EXTRACT Function 310
Datetime Arithmetic 311
Date Arithmetic with Intervals and Datetimes 311
Date Arithmetic with DATE Datatypes 312
Computing the Interval Between Two Datetimes 313
Mixing DATEs and TIMESTAMPs 316
Adding and Subtracting Intervals 317
Multiplying and Dividing Intervals 317
Using Unconstrained INTERVAL Types 318
Date/Time Function Quick Reference 319
Records. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 323
Records in PL/SQL 323
Benefits of Using Records 324
Declaring Records 326
Programmer-Defined Records 327
Working with Records 330
Comparing Records 337
Trigger Pseudorecords 338
Collections. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 341
Collections Overview 342
Collections Concepts and Terminology 343
Types of Collections 345
Collection Examples 345
Where You Can Use Collections 349
Choosing a Collection Type 354
Collection Methods (Built-ins) 356
The COUNT Method 357
The DELETE Method 358
The EXISTS Method 359
The EXTEND Method 360
The FIRST and LAST Methods 361
The LIMIT Method 362
The PRIOR and NEXT Methods 362
The TRIM Method 363
Working with Collections 365
Declaring Collection Types 365
Declaring and Initializing Collection Variables 369
Populating Collections with Data 374
Accessing Data Inside a Collection 379
Using String-Indexed Collections 380
Table of Contents | xi
www.it-ebooks.info
13. Collections of Complex Datatypes 385
Multilevel Collections 389
Working with Collections in SQL 398
Nested Table Multiset Operations 406
Testing Equality and Membership of Nested Tables 408
Checking for Membership of an Element in a Nested Table 409
Performing High-Level Set Operations 409
Handling Duplicates in a Nested Table 411
Maintaining Schema-Level Collections 412
Necessary Privileges 412
Collections and the Data Dictionary 413
Miscellaneous Datatypes. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 415
The BOOLEAN Datatype 415
The RAW Datatype 417
The UROWID and ROWID Datatypes 417
Getting ROWIDs 418
Using ROWIDs 419
The LOB Datatypes 420
Working with LOBs 422
Understanding LOB Locators 423
Empty Versus NULL LOBs 425
Writing into a LOB 427
Reading from a LOB 430
BFILEs Are Different 431
SecureFiles Versus BasicFiles 436
Temporary LOBs 439
Native LOB Operations 442
LOB Conversion Functions 447
Predefined Object Types 447
The XMLType Type 448
The URI Types 451
The Any Types 453
Part IV. SQL in PL/SQL
14. DML and Transaction Management. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . DML in PL/SQL 462
A Quick Introduction to DML Cursor Attributes for DML Operations RETURNING Information from DML Statements 461
462
466
467
xii | Table of Contents
www.it-ebooks.info
15. DML and Exception Handling 468
DML and Records 470
Transaction Management 473
The COMMIT Statement 474
The ROLLBACK Statement 474
The SAVEPOINT Statement 475
The SET TRANSACTION Statement 476
The LOCK TABLE Statement 476
Autonomous Transactions 477
Defining Autonomous Transactions 478
Rules and Restrictions on Autonomous Transactions 479
Transaction Visibility 480
When to Use Autonomous Transactions 481
Building an Autonomous Logging Mechanism 482
Data Retrieval. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 485
Cursor Basics 486
Some Data Retrieval Terms 487
Typical Query Operations 488
Introduction to Cursor Attributes 489
Referencing PL/SQL Variables in a Cursor 492
Choosing Between Explicit and Implicit Cursors 493
Working with Implicit Cursors 494
Implicit Cursor Examples 495
Error Handling with Implicit Cursors 496
Implicit SQL Cursor Attributes 498
Working with Explicit Cursors 500
Declaring Explicit Cursors 501
Opening Explicit Cursors 504
Fetching from Explicit Cursors 505
Column Aliases in Explicit Cursors 507
Closing Explicit Cursors 508
Explicit Cursor Attributes 510
Cursor Parameters 512
SELECT...FOR UPDATE 515
Releasing Locks with COMMIT 516
The WHERE CURRENT OF Clause 518
Cursor Variables and REF CURSORs 519
Why Use Cursor Variables? 520
Similarities to Static Cursors 521
Declaring REF CURSOR Types 521
Declaring Cursor Variables 522
Table of Contents | xiii
www.it-ebooks.info
16. Opening Cursor Variables 523
Fetching from Cursor Variables 524
Rules for Cursor Variables 527
Passing Cursor Variables as Arguments 530
Cursor Variable Restrictions 532
Cursor Expressions 533
Using Cursor Expressions 534
Restrictions on Cursor Expressions 536
Dynamic SQL and Dynamic PL/SQL. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 537
NDS Statements 538
The EXECUTE IMMEDIATE Statement 538
The OPEN FOR Statement 543
About the Four Dynamic SQL Methods 548
Binding Variables 550
Argument Modes 551
Duplicate Placeholders 553
Passing NULL Values 554
Working with Objects and Collections 555
Dynamic PL/SQL 557
Build Dynamic PL/SQL Blocks 558
Replace Repetitive Code with Dynamic Blocks 560
Recommendations for NDS 561
Use Invoker Rights for Shared Programs 561
Anticipate and Handle Dynamic Errors 562
Use Binding Rather than Concatenation 564
Minimize the Dangers of Code Injection 566
When to Use DBMS_SQL 569
Obtain Information About Query Columns 569
Meeting Method 4 Dynamic SQL Requirements 571
Minimizing Parsing of Dynamic Cursors 578
Oracle Database 11g New Dynamic SQL Features 579
Enhanced Security for DBMS_SQL 584
Part V. PL/SQL Application Construction
17. Procedures, Functions, and Parameters. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 591
Modular Code 592
Procedures 593
Calling a Procedure 596
The Procedure Header 596
xiv | Table of Contents
www.it-ebooks.info
18. The Procedure Body 596
The END Label 597
The RETURN Statement 597
Functions 597
Structure of a Function 598
The RETURN Datatype 601
The END Label 602
Calling a Function 603
Functions Without Parameters 604
The Function Header 604
The Function Body 605
The RETURN Statement 605
Parameters 607
Defining Parameters 608
Actual and Formal Parameters 608
Parameter Modes 609
Explicit Association of Actual and Formal Parameters in PL/SQL 613
The NOCOPY Parameter Mode Qualifier 617
Default Values 618
Local or Nested Modules 619
Benefits of Local Modularization 620
Scope of Local Modules 623
Sprucing Up Your Code with Nested Subprograms 623
Subprogram Overloading 624
Benefits of Overloading 625
Restrictions on Overloading 628
Overloading with Numeric Types 629
Forward Declarations 630
Advanced Topics 631
Calling Your Function from Inside SQL 631
Table Functions 637
Deterministic Functions 647
Implicit Cursor Results (Oracle Database 12c) 649
Go Forth and Modularize! 650
Packages. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 651
Why Packages? 651
Demonstrating the Power of the Package 652
Some Package-Related Concepts 655
Diagramming Privacy 657
Rules for Building Packages 658
The Package Specification 658
Table of Contents | xv
www.it-ebooks.info
19. The Package Body 660
Initializing Packages 662
Rules for Calling Packaged Elements 666
Working with Package Data 667
Global Within a Single Oracle Session 668
Global Public Data 669
Packaged Cursors 669
Serializable Packages 674
When to Use Packages 677
Encapsulate Data Access 677
Avoid Hardcoding Literals 680
Improve Usability of Built-in Features 683
Group Together Logically Related Functionality 683
Cache Static Session Data 684
Packages and Object Types 685
Triggers. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 687
DML Triggers 688
DML Trigger Concepts 689
Creating a DML Trigger 691
DML Trigger Example: No Cheating Allowed! 696
Multiple Triggers of the Same Type 702
Who Follows Whom 703
Mutating Table Errors 705
Compound Triggers: Putting It All in One Place 706
DDL Triggers 710
Creating a DDL Trigger 710
Available Events 713
Available Attributes 713
Working with Events and Attributes 715
Dropping the Undroppable 718
The INSTEAD OF CREATE Trigger 719
Database Event Triggers 720
Creating a Database Event Trigger 721
The STARTUP Trigger 722
The SHUTDOWN Trigger 723
The LOGON Trigger 723
The LOGOFF Trigger 723
The SERVERERROR Trigger 724
INSTEAD OF Triggers 728
Creating an INSTEAD OF Trigger 728
The INSTEAD OF INSERT Trigger 730
xvi | Table of Contents
www.it-ebooks.info
20. The INSTEAD OF UPDATE Trigger 732
The INSTEAD OF DELETE Trigger 733
Populating the Tables 733
INSTEAD OF Triggers on Nested Tables 734
AFTER SUSPEND Triggers 736
Setting Up for the AFTER SUSPEND Trigger 736
Looking at the Actual Trigger 738
The ORA_SPACE_ERROR_INFO Function 739
The DBMS_RESUMABLE Package 740
Trapped Multiple Times 742
To Fix or Not to Fix? 743
Maintaining Triggers 743
Disabling, Enabling, and Dropping Triggers 743
Creating Disabled Triggers 744
Viewing Triggers 745
Checking the Validity of Triggers 746
Managing PL/SQL Code. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 749
Managing Code in the Database 750
Overview of Data Dictionary Views 751
Display Information About Stored Objects 753
Display and Search Source Code 753
Use Program Size to Determine Pinning Requirements 755
Obtain Properties of Stored Code 756
Analyze and Modify Trigger State Through Views 757
Analyze Argument Information 758
Analyze Identifier Usage (Oracle Database 11g’s PL/Scope) 759
Managing Dependencies and Recompiling Code 762
Analyzing Dependencies with Data Dictionary Views 763
Fine-Grained Dependency (Oracle Database 11g) 767
Remote Dependencies 769
Limitations of Oracle’s Remote Invocation Model 772
Recompiling Invalid Program Units 773
Compile-Time Warnings 777
A Quick Example 777
Enabling Compile-Time Warnings 778
Some Handy Warnings 780
Testing PL/SQL Programs 788
Typical, Tawdry Testing Techniques 789
General Advice for Testing PL/SQL Code 793
Automated Testing Options for PL/SQL 794
Tracing PL/SQL Execution 795
Table of Contents | xvii
www.it-ebooks.info
21. DBMS_UTILITY.FORMAT_CALL_STACK 796
UTL_CALL_STACK (Oracle Database 12c) 798
DBMS_APPLICATION_INFO 801
Tracing with opp_trace 803
The DBMS_TRACE Facility 804
Debugging PL/SQL Programs 808
The Wrong Way to Debug 809
Debugging Tips and Strategies 811
Using Whitelisting to Control Access to Program Units 816
Protecting Stored Code 818
Restrictions on and Limitations of Wrapping 818
Using the Wrap Executable 819
Dynamic Wrapping with DBMS_DDL 819
Guidelines for Working with Wrapped Code 821
Introduction to Edition-Based Redefinition (Oracle Database 11g Release 2) 821
Optimizing PL/SQL Performance. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 825
Tools to Assist in Optimization 827
Analyzing Memory Usage 827
Identifying Bottlenecks in PL/SQL Code 827
Calculating Elapsed Time 833
Choosing the Fastest Program 834
Avoiding Infinite Loops 836
Performance-Related Warnings 837
The Optimizing Compiler 838
Insights on How the Optimizer Works 840
Runtime Optimization of Fetch Loops 843
Data Caching Techniques 844
Package-Based Caching 845
Deterministic Function Caching 850
THe Function Result Cache (Oracle Database 11g) 852
Caching Summary 868
Bulk Processing for Repeated SQL Statement Execution 869
High-Speed Querying with BULK COLLECT 870
High-Speed DML with FORALL 877
Improving Performance with Pipelined Table Functions 888
Replacing Row-Based Inserts with Pipelined Function-Based Loads 889
Tuning Merge Operations with Pipelined Functions 896
Asynchronous Data Unloading with Parallel Pipelined Functions 898
Performance Implications of Partitioning and Streaming Clauses in Parallel
Pipelined Functions 902
Pipelined Functions and the Cost-Based Optimizer 903
xviii | Table of Contents
www.it-ebooks.info
22. Tuning Complex Data Loads with Pipelined Functions 909
A Final Word on Pipelined Functions 916
Specialized Optimization Techniques 917
Using the NOCOPY Parameter Mode Hint 917
Using the Right Datatype 921
Optimizing Function Performance in SQL (12.1 and higher) 922
Stepping Back for the Big Picture on Performance 923
I/O and PL/SQL. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 925
Displaying Information 925
Enabling DBMS_OUTPUT 926
Write Lines to the Buffer 926
Read the Contents of the Buffer 927
Reading and Writing Files 929
The UTL_FILE_DIR Parameter 929
Working with Oracle Directories 931
Open Files 932
Is the File Already Open? 934
Close Files 934
Read from Files 935
Write to Files 938
Copy Files 941
Delete Files 942
Rename and Move Files 943
Retrieve File Attributes 943
Sending Email 944
Oracle Prerequisites 945
Configuring Network Security 946
Send a Short (32,767 Bytes or Less) Plain-Text Message 947
Include “Friendly” Names in Email Addresses 948
Send a Plain-Text Message of Arbitrary Length 950
Send a Message with a Short (32,767 Bytes or Less) Attachment 951
Send a Small File (32,767 Bytes or Less) as an Attachment 953
Attach a File of Arbitrary Size 953
Working with Web-Based Data (HTTP) 956
Retrieve a Web Page in “Pieces” 956
Retrieve a Web Page into a LOB 958
Authenticate Using HTTP Username/Password 959
Retrieve an SSL-Encrypted Web Page (via HTTPS) 960
Submit Data to a Web Page via GET or POST 961
Disable Cookies or Make Cookies Persistent 965
Retrieve Data from an FTP Server 966
Table of Contents | xix
www.it-ebooks.info
Use a Proxy Server 966
Other Types of I/O Available in PL/SQL 967
Database Pipes, Queues, and Alerts 967
TCP Sockets 968
Oracle’s Built-in Web Server 968
Part VI. Advanced PL/SQL Topics
23. Application Security and PL/SQL. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 971
Security Overview 971
Encryption 973
Key Length 974
Algorithms 975
Padding and Chaining 977
The DBMS_CRYPTO Package 977
Encrypting Data 979
Encrypting LOBs 982
SecureFiles 982
Decrypting Data 983
Performing Key Generation 984
Performing Key Management 985
Cryptographic Hashing 991
Using Message Authentication Codes 993
Using Transparent Data Encryption 994
Transparent Tablespace Encryption 997
Row-Level Security 999
Why Learn About RLS? 1002
A Simple RLS Example 1003
Static Versus Dynamic Policies 1007
Using Column-Sensitive RLS 1012
RLS Debugging 1015
Application Contexts 1019
Using Application Contexts 1020
Security in Contexts 1022
Contexts as Predicates in RLS 1022
Identifying Nondatabase Users 1026
Fine-Grained Auditing 1028
Why Learn About FGA? 1029
A Simple FGA Example 1030
Access How Many Columns? 1032
Checking the Audit Trail 1033
xx | Table of Contents
www.it-ebooks.info
24. 25. Using Bind Variables 1035
Using Handler Modules 1036
PL/SQL Architecture. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1039
DIANA 1039
How Oracle Executes PL/SQL Code 1040
An Example 1041
Compiler Limits 1044
The Default Packages of PL/SQL 1045
Execution Authority Models 1048
The Definer Rights Model 1049
The Invoker Rights Model 1054
Combining Rights Models 1056
Granting Roles to PL/SQL Program Units (Oracle Database 12c) 1057
“Who Invoked Me?” Functions (Oracle Database 12c) 1060
BEQUEATH CURRENT_USER for Views (Oracle Database 12c) 1061
Constraining Invoker Rights Privileges (Oracle Database 12c) 1063
Conditional Compilation 1064
Examples of Conditional Compilation 1065
The Inquiry Directive 1066
The $IF Directive 1070
The $ERROR Directive 1072
Synchronizing Code with Packaged Constants 1072
Program-Specific Settings with Inquiry Directives 1073
Working with Postprocessed Code 1074
PL/SQL and Database Instance Memory 1076
The SGA, PGA, and UGA 1076
Cursors, Memory, and More 1077
Tips on Reducing Memory Use 1079
What to Do If You Run Out of Memory 1090
Native Compilation 1093
When to Run in Interpreted Mode 1094
When to Go Native 1094
Native Compilation and Database Release 1094
What You Need to Know 1095
Globalization and Localization in PL/SQL. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1097
Overview and Terminology 1099
Unicode Primer 1100
National Character Set Datatypes 1102
Character Encoding 1102
Globalization Support Parameters 1104
Table of Contents | xxi
www.it-ebooks.info
26. Unicode Functions 1105
Character Semantics 1111
String Sort Order 1115
Binary Sort 1116
Monolingual Sort 1117
Multilingual Sort 1119
Multilingual Information Retrieval 1120
IR and PL/SQL 1123
Date/Time 1126
Timestamp Datatypes 1126
Date/Time Formatting 1127
Currency Conversion 1131
Globalization Development Kit for PL/SQL 1133
UTL_118N Utility Package 1133
UTL_LMS Error-Handling Package 1136
GDK Implementation Options 1137
Object-Oriented Aspects of PL/SQL. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1141
Introduction to Oracle’s Object Features 1142
Object Types by Example 1144
Creating a Base Type 1144
Creating a Subtype 1146
Methods 1147
Invoking Supertype Methods in Oracle Database 11g and Later 1152
Storing, Retrieving, and Using Persistent Objects 1154
Evolution and Creation 1162
Back to Pointers? 1164
Generic Data: The ANY Types 1171
I Can Do It Myself 1176
Comparing Objects 1179
Object Views 1184
A Sample Relational System 1186
Object View with a Collection Attribute 1188
Object Subview 1191
Object View with Inverse Relationship 1192
INSTEAD OF Triggers 1193
Differences Between Object Views and Object Tables 1196
Maintaining Object Types and Object Views 1197
Data Dictionary 1197
Privileges 1199
xxii | Table of Contents
www.it-ebooks.info
27. 28. Concluding Thoughts from a (Mostly) Relational Developer 1201
Calling Java from PL/SQL. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1205
Oracle and Java 1205
Getting Ready to Use Java in Oracle 1207
Installing Java 1207
Building and Compiling Your Java Code 1208
Setting Permissions for Java Development and Execution 1209
A Simple Demonstration 1212
Finding the Java Functionality 1212
Building a Custom Java Class 1213
Compiling and Loading into Oracle 1215
Building a PL/SQL Wrapper 1217
Deleting Files from PL/SQL 1217
Using loadjava 1218
Using dropjava 1221
Managing Java in the Database 1221
The Java Namespace in Oracle 1221
Examining Loaded Java Elements 1222
Using DBMS_JAVA 1223
LONGNAME: Converting Java Long Names 1223
GET_, SET_, and RESET_COMPILER_OPTION: Getting and Setting (a
Few) Compiler Options 1224
SET_OUTPUT: Enabling Output from Java 1225
EXPORT_SOURCE, EXPORT_RESOURCE, and EXPORT_CLASS:
Exporting Schema Objects 1226
Publishing and Using Java in PL/SQL 1228
Call Specs 1228
Some Rules for Call Specs 1229
Mapping Datatypes 1230
Calling a Java Method in SQL 1232
Exception Handling with Java 1232
Extending File I/O Capabilities 1236
Other Examples 1240
External Procedures. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1243
Introduction to External Procedures 1244
Example: Invoking an Operating System Command 1244
Architecture of External Procedures 1246
Oracle Net Configuration 1248
Specifying the Listener Configuration 1248
Security Characteristics of the Configuration 1251
Table of Contents | xxiii
www.it-ebooks.info
Setting Up Multithreaded Mode 1252
Creating an Oracle Library 1254
Writing the Call Specification 1256
The Call Spec: Overall Syntax 1257
Parameter Mapping: The Example Revisited 1258
Parameter Mapping: The Full Story 1260
More Syntax: The PARAMETERS Clause 1262
PARAMETERS Properties 1263
Raising an Exception from the Called C Program 1266
Nondefault Agents 1269
Maintaining External Procedures 1272
Dropping Libraries 1272
Data Dictionary 1272
Rules and Warnings 1273
A. Regular Expression Metacharacters and Function Parameters. . . . . . . . . . . . . . . . . . . 1275
B. Number Format Models. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1281
C. Date Format Models. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1285
Index. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1291