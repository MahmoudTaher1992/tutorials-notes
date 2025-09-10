Table of Contents
Preface 1
7
9
10
12
13
14
14
16
19
25
26
27
27
28
28
29
29
30
31
31
32
32
32
33
34
35
Chapter 1: What Is a PostgreSQL Server? Why program in the server? Using PL/pgSQL for integrity checks About this book's code examples Switching to the expanded display Moving beyond simple functions Data comparisons using operators Managing related data with triggers Auditing changes Data cleaning Custom sort orders Programming best practices KISS – keep it simple stupid DRY – don't repeat yourself YAGNI – you ain't gonna need it SOA – service-oriented architecture Type extensibility On caching Wrap up – why program in the server? Performance Ease of maintenance Simple ways to tighten security Summary Chapter 2: Server Programming Environment Cost of acquisition Availability of developers Licensing 36
Table of Contents
Predictability 37
Community 37
Procedural languages 38
Platform compatibility 39
Application design 40
Databases are considered harmful 40
Encapsulation 41
What does PostgreSQL offer? 41
Data locality 42
More basics 43
Transactions 43
General error reporting and error handling 44
User-defined functions (UDF) 44
Other parameters 46
More control 46
Summary 47
Chapter 3: Your First PL/pgSQL Function 49
Why PL/pgSQL? 50
Structure of a PL/pgSQL function 50
Accessing function arguments 51
Conditional expressions 53
Loops with counters 58
Looping through query results 59
PERFORM versus SELECT 62
Returning a record 63
Acting on function results 66
Summary 67
Chapter 4: Returning Structured Data 69
Sets and arrays 69
Returning sets 70
Returning a set of integers 70
Using a set-returning function 71
Returning rows from a function 72
Functions based on views 73
OUT parameters and records 78
OUT parameters 78
Returning records 78
Using RETURNS TABLE 80
Returning with no predefined structure 81
Returning SETOF ANY 83
Variadic argument lists 85
[ ii ]
Summary of RETURN SETOF variants Returning cursors Iterating over cursors returned from another function Wrap up of functions returning a cursor(s) Other ways to work with structured data Complex data types for modern world – XML and JSON XML data type and returning data as XML from functions Returning data in the JSON format Summary Chapter 5: PL/pgSQL Trigger Functions Creating the trigger function Creating the trigger Simple "Hey, I'm called" trigger The audit trigger 102
Disallowing DELETE 104
Disallowing TRUNCATE 106
Modifying the NEW record 106
Timestamping trigger 107
Immutable fields trigger 108
Controlling when a trigger is called 109
Conditional trigger 110
Trigger on specific field changes 111
Visibility 111
And most importantly – use triggers cautiously! 112
Variables passed to the PL/pgSQL TRIGGER function 112
Summary 113
Chapter 6: Debugging PL/pgSQL 115
''Manual'' debugging with RAISE NOTICE 116
Throwing exceptions 118
Logging to a file 120
Advantages of RAISE NOTICE 121
Disadvantages of RAISE NOTICE 122
Visual debugging 122
Getting the debugger installed 122
Installing pgAdmin3 122
Using the debugger 123
Advantages of the debugger Disadvantages of the debugger 124
125
Summary 125
Table of Contents
86
86
88
90
90
90
91
93
96
97
97
98
98
[ iii ]
Table of Contents
Chapter 7: Using Unrestricted Languages 127
Are untrusted languages inferior to trusted ones? 127
Will untrusted languages corrupt the database? 128
Why untrusted? 129
Why PL/Python? 129
Quick introduction to PL/Python 130
A minimal PL/Python function 130
Data type conversions 131
Writing simple functions in PL/Python 132
A simple function 132
Functions returning a record 133
Table functions 135
Running queries in the database 136
Running simple queries 136
Using prepared queries 137
Caching prepared queries 138
Writing trigger functions in PL/Python 138
Exploring the inputs of a trigger 140
A log trigger 141
Constructing queries 144
Handling exceptions 145
Atomicity in Python 147
Debugging PL/Python 148
Using plpy.notice() for tracking the function's progress 148
Using assert 150
Redirecting sys.stdout and sys.stderr 150
Thinking out of the "SQL database server" box 152
Generating thumbnails when saving images 152
Sending an e-mail 153
Summary 154
Chapter 8: Writing Advanced Functions in C 155
Simplest C function – return (a + b) 156
add_func.c 156
Version 0 call conventions 158
Makefile 158
CREATE FUNCTION add(int, int) 160
add_func.sql.in 160
Summary for writing a C function 161
Adding functionality to add(int, int) 162
Smart handling of NULL arguments 162
Working with any number of arguments 164
Basic guidelines for writing C code 170
Memory allocation 170
[ iv ]
Table of Contents
Use palloc() and pfree() 171
Zero-fill the structures 171
Include files 171
Public symbol names 172
Error reporting from C functions 172
"Error" states that are not errors 173
When are messages sent to the client 174
Running queries and calling PostgreSQL functions 174
Sample C function using SPI 175
Visibility of data changes 177
More info on SPI_* functions 177
Handling records as arguments or returned values 177
Returning a single tuple of a complex type 179
Extracting fields from an argument tuple 181
Constructing a return tuple 181
Interlude – what is Datum 182
Returning a set of records 183
Fast capturing of database changes 186
Doing something at commit/rollback 187
Synchronizing between backends 187
Additional resources for C 188
Summary 189
Chapter 9: Scaling Your Database with PL/Proxy 191
Simple single-server chat 191
Dealing with success – splitting tables over multiple databases 199
What expansion plans work and when 199
Moving to a bigger server 199
Master-slave replication – moving reads to slave 199
Multimaster replication 200
Data partitioning across multiple servers 200
Splitting the data 201
PL/Proxy – the partitioning language 204
Installing PL/Proxy 204
PL/Proxy language syntax 204
CONNECT, CLUSTER, and RUN ON 205
SELECT and TARGET 206
SPLIT – distributing array elements over several partitions 207
Distribution of data 208
Configuring PL/Proxy cluster using functions 209
Configuring PL/Proxy cluster using SQL/MED 211
Moving data from the single to the partitioned database 212
Summary 213
[ v ]
Table of Contents
Chapter 10: Publishing Your Code as PostgreSQL Extensions 215
When to create an extension 215
Unpackaged extensions 217
Extension versions 217
The .control file 218
Building an extension 219
Installing an extension 221
Publishing your extension 222
Introduction to the PostgreSQL Extension Network 222
Signing up to publish your extension 222
Creating an extension project the easy way 225
Providing the metadata about the extension 226
Writing your extension code 230
Creating the package 231
Submitting the package to PGXN 231
Installing an extension from PGXN 234
Summary 235
Index 237