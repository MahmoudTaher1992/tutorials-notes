Table of Contents
Chapter 1: RethinkDB Architecture and Data Model 1
RethinkDB Architectural components 1
Client drivers 2
RethinkDB Query Engine 2
RethinkDB Clusters 3
Pushing changes to RethinkDB client 3
Query execution in RethinkDB 5
File system and data storage 8
About Direct I/O 9
Data Storage 10
Sharding and Replication 11
Sharding in RethinkDB 11
Range Based Sharding 12
Replication in RethinkDB 13
Indexing in RethinkDB 13
Automatic failover handling in RethinkDB 14
About voting replicas 14
RethinkDB data model 15
RethinkDB data types 16
Binary objects 17
Geospatial queries in RethinkDB 18
Supported data types 18
RethinkDB model relationship 18
Embedded Arrays 19
Merits of embedded arrays 19
Demerits of embedded arrays 19
Document linking in multiple tables 20
Merits of document linking: 21
Demerits of document linking: 21
Constraints and limitation in RethinkDB 26
Summary 27
Chapter 2: RethinkDB Query language 29
Embedding ReQL in programming language. Performing CRUD operation using RethinkDB and Node 29
32
Creating new records 32
Reading the document data 33
Updating the document 34
Deleting the document 35
ReQL queries are chainable 37
ReQL queries are executed on Server 37
Performing conditional queries 37
Traversing over nested fields 40
Performing string operations 42
Performing MapReduce operations 44
Grouping the data 44
Counting the data 46
Sum 46
Avg 47
Min and Max 47
Distinct 48
Contains 48
Map and reduce 49
Calling HTTP APIs using ReQL 49
Handling binary objects 51
Performing JOINS 52
Accessing changefeed (realtimefeed ) in RethinkDB 53
Application of changefeed 55
Performing geolocation operations 56
Storing a coordinate 56
pagebreak //pagebreakFinding distance between points 56
Performing administrative operations 57
Summary 57
Index 58