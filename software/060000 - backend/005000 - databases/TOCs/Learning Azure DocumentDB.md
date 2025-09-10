Table of Contents
Preface v
Chapter 1: Getting Started with DocumentDB 1
What is DocumentDB? 2
The characteristics of a schema 2
Having JavaScript at the core 3
Indexing a document 4
DocumentDB as a service 5
Understanding performance 6
Handling transactions 6
Common use cases 6
Building the Internet of Things 7
Storing user profile information 7
Logging information 8
Building mobile solutions 8
Exploring the data model 8
DocumentDB account 9
Creating databases 9
Administering users 10
Setting permissions 10
Managing collections 11
DocumentDB versus other databases 11
Azure Table storage 11
MongoDB 11
Comparison chart 12
Understanding the price model 13
Account charges 13
Number of collections 13
Request Units 14
Understanding storage 14
Expanding resources 14
[ i ]
Table of Contents
Building your first application 16
Provisioning an account 16
Creating a database 18
Creating a collection 18
Building a console application 19
Setting up a solution 19
Saving a document 20
Summary 23
Chapter 2: Setting up and Managing Your Database 25
Managing your keys 25
Recycling keys 26
Managing read-only keys 27
Using resource tokens 27
Creating resource tokens 27
Creating a collection 28
Creating a user and its permission 29
Creating a document with permissions 30
Creating a document without permissions 31
Listing permissions 33
Setting consistency levels 33
Managing alerts 34
Monitoring your account 34
Creating alerts 37
Summary 38
Chapter 3: Basic Querying 39
Creating resources 39
Creating a collection 39
Creating a document 41
Using DocumentDB SQL 41
Using LINQ to object 41
Using LINQ 42
Updating the PersonInformation 42
Reading resources 42
Reading documents 43
Using the WHERE clause 44
Using a simple JOIN 45
Updating documents 46
Updating documents 46
Deleting documents 47
Summary 48
[ ii ]
Table of Contents
Chapter 4: Advanced Querying 49
Using the SELECT statement 49
Selecting some documents 50
Using the FROM clause 51
Aliasing 51
Joining documents 52
Selecting from subdocuments 52
Using the WHERE clause 53
Binary operators 54
The BETWEEN keyword 54
Logical operators 54
Using the IN keyword 55
Conditional expressions 55
Using built-in functions 56
Building stored procedures 56
Building triggers 58
Building user-defined functions 60
Using LINQ to DocumentDB 61
Summary 62
Chapter 5: Using REST to Access Your Database 63
Understanding the basics of REST 63
Using the GET verb 65
Using the POST verb 65
Using the PUT verb 65
Using the DELETE verb 66
Querying DocumentDB resources 66
Setting request headers 67
Generating the authorization header 67
Getting all databases 69
Adding a document 69
Summary 71
Chapter 6: Using Node.js to Access Your Database 73
Introducing Node.js 73
What is Node.js? 73
Why use Node.js? 74
Preparing Visual Studio 2015 74
Building our first Node.js application 74
Creating our first app 75
Creating a web app 75
Utilizing DocumentDB from Node.js 77
Preparing our project 78
[ iii ]
Table of Contents
Connecting to DocumentDB 78
Creating a module 79
Creating and finding a document 82
Summary 85
Chapter 7: Advanced Techniques 87
Introducing indexes 87
Explaining default indexing 87
Customizing indexing policies 89
Configuring index update mode 89
Setting index precisions 92
Manipulating paths in indexes 93
Setting different index types 94
Configuring index paths 95
Setting the index precision 98
Partitioning data 100
Using hash partitioning 100
Using range partitioning 101
Managing performance 102
Using transactions 104
Setting consistency levels 106
Using strong consistency 107
Using bounded staleness consistency 107
Using session consistency 108
Using eventual staleness consistency 108
Summary 108
Chapter 8: Putting Your Database at the Heart of Azure Solutions 109
Introducing an Internet of Things scenario 109
IoT Inc. 109
Technical requirements 111
Designing the model 111
Building a custom partition resolver 112
Building the Web API 114
Registering a device 115
Increasing search capabilities 116
Setting up Azure Search 116
Enhancing security 122
Creating and configuring Key Vault 122
Using Key Vault from ASP.NET 123
Encrypting sensitive data 125
Migrating data 125
Summary 128
Index 129