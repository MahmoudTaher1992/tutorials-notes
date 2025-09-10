Table of Contents
Preface 1
Chapter 1: Cloud Computing and Microsoft Azure Services Platform 9
What is cloud computing? 10
Why a business would like to move its business applications and
data to the cloud 10
Types of cloud services 11
Infrastructure as a Service (IaaS) 11
Platform as a Service (PaaS) 11
Software as a Service (SaaS) 12
The hybrid cloud 12
How cloud computing is implemented with examples of some
major cloud computing vendors 13
Amazon Web Services 13
SalesForce.com 14
Google 14
Microsoft 15
Windows Azure 18
Azure platform details 18
Platform components 20
Windows Azure 21
Compute: Windows Azure Hosting Service 21
Windows Azure storage 23
SQL Azure 24
Azure AppFabric 26
System requirements 28
Hardware and software required 30
Getting started with Azure Platform and accessing services 30
Exercise 1.1: Purchasing a subscription on Windows Azure Platform 31
Signing up for a Windows Live ID 31
Table of Contents
Purchasing a subscription 32
Activating the service 34
Exercise 1.2: Accessing Windows Azure Portal Verifying status of account and browsing to Windows Azure Portal Creating an account and reviewing the portal Creating a Windows Azure Service Summary 43
Chapter 2: SQL Azure Services 36
36
38
39
45
Overview of SQL Azure Services 46
Infrastructure features 46
How different is SQL Azure from SQL Server? 47
SQL Azure provisioning 47
After accessing the portal 48
Server-level administration 49
Setting up firewall rules 49
Administering at the database level 50
Role of SQL Azure database administrator 51
SQL Azure databases 51
User administration and logins 51
Migrating databases to SQL Azure 54
Monitoring SQL Azure databases 55
Data synchronization and SQL Azure 55
Application access to SQL Azure 55
Troubleshooting 56
T-SQL support in SQL Azure 57
Accessing SQL Azure Services from the portal 59
First time access to SQL Azure from the portal 59
Creating a SQL Azure Server 61
Setting up a firewall 64
Creating a user database and setting up a firewall 65
Creating a user database in the portal 66
Setting up firewall rules 68
IP ranges of Microsoft Azure data centers 71
Connecting to SQL Azure from SQL Server Management Studio 71
Connecting to SQL Azure from SSMS 71
Working with SQL Azure from SQL Server Management Studio 76
Creating queries 76
General queries 78
Querying date and time 79
Create and display firewall rules 80
Find database usage and bandwidth usage 81
Basic administration of the database objects 82
Creating logins, users, and roles 83
[ ii ]
Table of Contents
Creating, altering, and dropping databases Creating tables and indexes 88
Add, remove columns, and constraints SQL Azure templates 91
Basic monitoring of the database 87
90
92
Summary 94
Chapter 3: Working with SQL Azure Databases from
Visual Studio 2008 95
SQL Azure architecture 96
Application access to SQL Azure 98
TDS and SQL Azure 98
Microsoft data access technologies 99
Connecting to the database 100
Data providers 100
Connection string 101
Commands 102
Using connection string builders 103
Accessing SQL Azure data using the Server Management
Objects (SMO) 105
Accessing SQL Azure from Visual Studio 2010 Express 106
The easy way to connect to SQL Azure using ADO.NET 3.5, ODBC,
and OLE DB 108
Using ADO.NET to connect to the SQL Azure Database Using ODBC to connect to the SQL Azure Database Using OLE DB to connect to the SQL Azure Database Using ADO.NET to connect to a SQL Azure Database in C# 108
110
111
112
Application using a SqlConnectionStringBuilder to connect to
SQL Azure 113
Testing the effectiveness of SqlConnectionStringBuilder 115
Demo using an SqlConnectionStringBuilder to connect to SQL Azure
in C# 117
Using SQL Server Management Objects (SMO) to connect to
SQL Azure 119
SQL Server Management Objects (SMO) to connect to SQL
Azure in C# 121
Creating database objects using
ADO.NET 123
Using connection string information in application settings Inserting connection string information to the application settings file Connect to the database on the server using the settings Create a test database and drop it 123
124
126
127
[ iii ]
Table of Contents
Connect to the master database and get the Session ID Create a table if it does not exist and populate the table Creating database objects with SQL Server API Summary 133
Chapter 4: SQL Azure Tools 129
129
131
135
Microsoft tools 135
Visual Studio related 135
VS2008 136
VS2010 136
Entity Framework Provider 137
SQL Server related 138
SQL Server Management Studio 138
Import/Export Wizard 138
SyncFramework and SQL Azure 139
MySQL to SQL Azure Migration 140
Scripting support for SQL Azure 140
SQLCMD 142
BCP Utility 146
IIS7 Database Manager 150
OData and SQL Azure 155
Brand new tools 155
Third-party tools 156
SQL Azure Migration Wizard 156
Installing the SQL Azure Migration Wizard 156
SQL Azure Explorer 157
Installing the SQLAzure2010 Add-in 157
Exploring the SQL Azure in VS2010 158
Running a query in VS2010 162
SQL Azure Manager à la community 164
Installing and running the SQL Azure Manager 164
Cerebrata© 167
DBArtisan© 168
Explore SQL Azure with DBArtisan 169
Red Gate (SQL Compare©) 173
ToadSoft© 175
SQL Azure and OpenOffice 176
Summary 177
Chapter 5: Populating SQL Azure Databases 179
Sample databases used in this chapter 180
Using SQL Server Management Studio with scripts 180
Creating a script for the Northwind database 180
Running the scripted query in SQL Azure 185
Using the SQL Server Import and Export Wizard 187
[ iv ]
Table of Contents
Populating a table 187
Using the Import and Export Wizard Using the SQL Server Migration wizard 188
196
Migration from MySQL to SQL Azure using SQL Server Migration
Assistant 2008 for MySQL 206
Using SqlBulkCopy 216
Create a table in the destination server 217
Create a console application in VS2010 217
Summary 220
Chapter 6: SSIS and SSRS Applications Using SQL Azure 221
Merging sharded data 222
Splitting the data and uploading to SQL Azure 222
Merging data and loading an Access database 226
Merging columns from SQL Azure and SQL Server 230
Sorting the outputs of the sources 232
Porting output data from Merge Join to an MS Access database 236
Moving a MySQL database to SQL Azure database 238
Creating the package 238
Creating the source and destination connections 238
Creating the package 240
Creating a report using SQL Azure as data source 244
Accessing SQL Azure from Report Builder 3.0 248
Summary 254
Chapter 7: Working with Windows Azure Hosting 255
Tools needed to develop and host Cloud Service applications 256
Create and deploy an ASP.NET application 257
Create a cloud project in Visual Studio 2008 SP1 258
Test and debug in the development fabric 262
Deploy the application to the cloud from the portal 265
Windows Azure ASP.NET site with forms authentication 271
Create Windows Azure Cloud Service Project in Visual Studio 2008 272
Add a Login control to the login.aspx page 273
Add a control to login.aspx for new users to register 274
Configure authentication mode 275
Create Membership database in SQL Azure 276
Configure the connection string 278
Modify system.web to access the Membership Provider 278
Modify the Default.aspx page 279
Test and verify application authentication 279
Register users 279
Test authentication of registered users 282
Summary 283
[ v ]
Table of Contents
Chapter 8: Database Applications on Windows Azure Platform
Accessing SQL Server Databases 285
Ground-to-Cloud access 286
Using Linq to retrieve data from SQL Azure 286
Create an ASP.NET web application project 287
Creating a data context 287
Create a new data connection 288
Linq to SQL mapping 290
Add a LinqDataSource control 292
Display data with a GridView control 294
Swap connection to SQL Azure 296
Cloud-to-Cloud access 297
Default template Cloud Service Project 297
Displaying data from SQL Azure 300
Deploying the application to the hosting site 306
Cloud-to-Ground access 308
Create a console project in Visual Studio 311
Add an Entity Model Template and bind it to the database 312
Configure the WCF Data Service 315
WCF Data Service to use Windows Azure AppFabric 316
Windows Azure AppFabric 316
Hosting a ASP.NET application client for the above service 323
Summary 324
Chapter 9: Synchronizing SQL Azure 325
Using SQL Azure Data Sync Tool 327
Provisioning the database 327
Running SQL Server Agent in SSMS 334
Verifying bi-directional synchronization 337
Conflict resolution 339
Synchronizing SQL Azure data with SQL Server Compact 340
Provisioning SQL Azure Data cache 340
Reviewing SQL Server Compact database 346
Build and run synchronization 347
SQL Azure Data Sync Service 348
Summary 349
Chapter 10: Recent Developments 351
SQL Azure updates 352
SQL Azure security 353
Using SQL Azure Firewall API 354
SQL Azure with MS Access 2010 355
Import a SQL Azure table into MS Access 355
[ vi ]
Table of Contents
Creating a table in MS Access linked to SQL Azure 358
Connecting to SQL Azure from MS Excel 2010 360
OpenOffice Access to SQL Azure 361
Accessing SQL Azure with non-.NET Framework languages 366
Accessing SQL Azure with Java 366
Accessing SQL Azure with PHP 369
OData Service for SQL Azure 373
Consuming SQL Azure data with PowerPivot 377
SQL Azure with WebMatrix 381
More third-party tools to SQL Azure 383
Gem Query for SQL Azure developers 383
Managing SQL Azure databases with the Houston Project (CTP1) 384
Data Application Component and SQL Azure 386
SQL Azure with Microsoft LightSwitch 389
References 389
Summary 390
Index 391