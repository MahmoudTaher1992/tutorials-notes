Table of Contents
Preface 1
Chapter 1: First Steps 7
Introduction 7
Introducing PostgreSQL 9 8
Getting PostgreSQL 10
Connecting to PostgreSQL server 11
Enabling access for network/remote users 14
Using graphical administration tools 15
Using psql query and scripting tool 20
Changing your password securely 24
Avoiding hardcoding your password 25
Using a connection service file 26
Troubleshooting a failed connection 27
Chapter 2: Exploring the Database 31
Introduction 31
What version is the server? 32
What is the server uptime? 33
Locate the database server files 34
Locate the database server message log 36
List databases on this database server? 40
How many tables in a database? 43
How much disk space does a database use? 45
How much disk space does a table use? 46
Which are my biggest tables? 47
How many rows in a table? 48
Quick estimate of the number of rows in a table 49
Understanding object dependencies 53
Table of Contents
Chapter 3: Configuration 57
Introduction 57
Reading the Fine Manual (RTFM) Planning a new database 59
Changing parameters in your programs What are the current configuration settings? Which parameters are at non-default settings? Updating the parameter file 65
Setting parameters for particular groups of users Basic server configuration checklist 67
Adding an external module to PostgreSQL Running server in power saving mode Chapter 4: Server Control 73
Introduction 73
Starting the database server manually Stopping the server safely and quickly Stopping the server in an emergency Reloading the server configuration files Restarting the server quickly 78
Preventing new connections 80
Restricting users to just one session each Pushing users off the system Deciding on a design for multi-tenancy Using multiple schemas 85
Giving users their own private database Running multiple servers on one system Set up a Connection Pool Chapter 5: Tables & Data Introduction 95
Choosing good names for database objects Handling objects with quoted names Enforcing same name, same column definition Identifying and removing duplicates 103
Preventing duplicate rows 106
Finding a unique key for a set of data Generating test data 114
Randomly sampling data 117
Loading data from a spreadsheet Loading data from flat files 58
60
62
63
66
68
70
74
75
76
76
81
83
84
88
89
91
95
96
97
99
112
119
122
ii
Table of Contents
Chapter 6: Security 125
Introduction 125
Revoking user access to a table 126
Granting user access to a table 128
Creating a new user 130
Temporarily preventing a user from connecting 131
Removing a user without dropping their data 133
Checking all users have a secure password 134
Giving limited superuser powers to specific users 136
Auditing DDL changes 139
Auditing data changes 140
Integrating with LDAP 144
Connecting using SSL 145
Encrypting sensitive data 147
Chapter 7: Database Administration 153
Introduction 153
Writing a script that either all succeeds or all fails 154
Writing a psql script that exits on first error 156
Performing actions on many tables 158
Adding/Removing the columns of a table 163
Changing datatype of a column 165
Adding/Removing schemas 168
Moving objects between schemas 170
Adding/Removing tablespaces 171
Moving objects between tablespaces 174
Accessing objects in other PostgreSQL databases 177
Making views updateable 182
Chapter 8: Monitoring and Diagnosis 189
Introduction 189
Is the user connected? 193
What are they running? 194
Are they active or blocked? 196
Who is blocking them? 198
Killing a specific session 199
Resolving an in-doubt prepared transaction 201
Is anybody using a specific table? 201
When did anybody last use it? 203
How much disk space is used by temporary data? 205
Why are my queries slowing down? 208
iii
210
212
Table of Contents
Investigating and reporting a bug Producing a daily summary of logfile errors Chapter 9: Regular Maintenance 215
Introduction 215
Controlling automatic database maintenance 216
Avoiding auto freezing and page corruptions 221
Avoiding transaction wraparound 222
Removing old prepared transactions 225
Actions for heavy users of temporary tables 227
Identifying and fixing bloated tables and indexes 229
Maintaining indexes 233
Finding the unused indexes 236
Carefully removing unwanted indexes 238
Planning maintenance 239
Chapter 10: Performance & Concurrency 241
Introduction 241
Finding slow SQL statements 242
Collecting regular statistics from pg_stat* views 245
Finding what makes SQL slow 246
Reducing the number of rows returned 250
Simplifying complex SQL 251
Speeding up queries without rewriting them 257
Why is my query not using an index? 260
How do I force a query to use an index 261
Using optimistic locking 263
Reporting performance problems 265
Chapter 11: Backup & Recovery 267
Introduction 267
Understanding and controlling crash recovery 268
Planning backups 270
Hot logical backup of one database 272
Hot logical backup of all databases 274
Hot logical backup of all tables in a tablespace 276
Backup of database object definitions 277
Standalone hot physical database backup 278
Hot physical backup & Continuous Archiving 280
Recovery of all databases 283
Recovery to a point in time 286
Recovery of a dropped/damaged table 288
Recovery of a dropped/damaged tablespace 291
iv
Table of Contents
Recovery of a dropped/damaged database 292
Improving performance of backup/restore 294
Incremental/Differential backup and restore 296
Chapter 12: Replication & Upgrades 299
Introduction 299
Understanding replication concepts 300
Replication best practices 304
File-based log-shipping replication 305
Setting up streaming log replication 308
Managing log shipping replication 313
Managing Hot Standby 316
Selective replication using Londiste 321
Selective replication using Slony 2.0 325
Load balancing with pgpool-II 3.0 329
Upgrading (minor) 332
Major upgrades in-place 333
Major upgrades online using replication tools 335
Index 337