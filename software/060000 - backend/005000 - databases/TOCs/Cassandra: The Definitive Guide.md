Table of Contents
Foreword . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . xv
Preface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . xvii
1. Introducing Cassandra . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1
What’s Wrong with Relational Databases? 1
A Quick Review of Relational Databases 6
RDBMS: The Awesome and the Not-So-Much 6
Web Scale 12
The Cassandra Elevator Pitch 14
Cassandra in 50 Words or Less 14
Distributed and Decentralized 14
Elastic Scalability 16
High Availability and Fault Tolerance 16
Tuneable Consistency 17
Brewer’s CAP Theorem 19
Row-Oriented 23
Schema-Free 24
High Performance 24
Where Did Cassandra Come From? 24
Use Cases for Cassandra 25
Large Deployments 25
Lots of Writes, Statistics, and Analysis 26
Geographical Distribution 26
Evolving Applications 26
Who Is Using Cassandra? 26
Summary 28
2. Installing Cassandra . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 29
Installing the Binary 29
Extracting the Download 29
vii
What’s In There? 29
Building from Source 30
Additional Build Targets 32
Building with Maven 32
Running Cassandra 33
On Windows 33
On Linux 33
Starting the Server 34
Running the Command-Line Client Interface 35
Basic CLI Commands 36
Help 36
Connecting to a Server 36
Describing the Environment 37
Creating a Keyspace and Column Family 38
Writing and Reading Data 39
Summary 3. The Cassandra Data Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 41
40
The Relational Data Model 41
A Simple Introduction 42
Clusters 45
Keyspaces 46
Column Families 47
Column Family Options 49
Columns 49
Wide Rows, Skinny Rows 51
Column Sorting 52
Super Columns 53
Composite Keys 55
Design Differences Between RDBMS and Cassandra 56
No Query Language 56
No Referential Integrity 56
Secondary Indexes 56
Sorting Is a Design Decision 57
Denormalization 57
Design Patterns 58
Materialized View 59
Valueless Column 59
Aggregate Key 59
Some Things to Keep in Mind 60
Summary 60
viii | Table of Contents
4. 5. 6. Sample Application . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 61
Data Design 61
Hotel App RDBMS Design 62
Hotel App Cassandra Design 63
Hotel Application Code 64
Creating the Database 65
Data Structures 66
Getting a Connection 67
Prepopulating the Database 68
The Search Application 80
Twissandra 85
Summary 85
The Cassandra Architecture . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 87
System Keyspace 87
Peer-to-Peer 88
Gossip and Failure Detection 88
Anti-Entropy and Read Repair 90
Memtables, SSTables, and Commit Logs 91
Hinted Handoff 93
Compaction 94
Bloom Filters 95
Tombstones 95
Staged Event-Driven Architecture (SEDA) 96
Managers and Services 97
Cassandra Daemon 97
Storage Service 97
Messaging Service 97
Hinted Handoff Manager 98
Summary 98
Configuring Cassandra . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 99
Keyspaces 99
Creating a Column Family 102
Transitioning from 0.6 to 0.7 103
Replicas 103
Replica Placement Strategies 104
Simple Strategy 105
Old Network Topology Strategy 106
Network Topology Strategy 107
Replication Factor 107
Increasing the Replication Factor 108
Partitioners 110
Table of Contents | ix
7. Random Partitioner 110
Order-Preserving Partitioner 110
Collating Order-Preserving Partitioner 111
Byte-Ordered Partitioner 111
Snitches 111
Simple Snitch 111
PropertyFileSnitch 112
Creating a Cluster 113
Changing the Cluster Name 113
Adding Nodes to a Cluster 114
Multiple Seed Nodes 116
Dynamic Ring Participation 117
Security 118
Using SimpleAuthenticator 118
Programmatic Authentication 121
Using MD5 Encryption 122
Providing Your Own Authentication 122
Miscellaneous Settings 123
Additional Tools 124
Viewing Keys 124
Importing Previous Configurations 125
Summary 127
Reading and Writing Data . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 129
Query Differences Between RDBMS and Cassandra 129
No Update Query 129
Record-Level Atomicity on Writes 129
No Server-Side Transaction Support 129
No Duplicate Keys 130
Basic Write Properties 130
Consistency Levels 130
Basic Read Properties 132
The API 133
Ranges and Slices 133
Setup and Inserting Data 134
Using a Simple Get 140
Seeding Some Values 142
Slice Predicate 142
Getting Particular Column Names with Get Slice 142
Getting a Set of Columns with Slice Range 144
Getting All Columns in a Row 145
Get Range Slices 145
Multiget Slice 147
x | Table of Contents
8. 9. Deleting 149
Batch Mutates 150
Batch Deletes 151
Range Ghosts 152
Programmatically Defining Keyspaces and Column Families 152
Summary 153
Clients . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 155
Basic Client API 156
Thrift 156
Thrift Support for Java 159
Exceptions 159
Thrift Summary 160
Avro 160
Avro Ant Targets 162
Avro Specification 163
Avro Summary 164
A Bit of Git 164
Connecting Client Nodes 165
Client List 165
Round-Robin DNS 165
Load Balancer 165
Cassandra Web Console 165
Hector (Java) 168
Features 169
The Hector API 170
HectorSharp (C#) 170
Chirper 175
Chiton (Python) 175
Pelops (Java) 176
Kundera (Java ORM) 176
Fauna (Ruby) 177
Summary 177
Monitoring . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 179
Logging 179
Tailing 181
General Tips 182
Overview of JMX and MBeans 183
MBeans 185
Integrating JMX 187
Interacting with Cassandra via JMX 188
Cassandra’s MBeans 190
Table of Contents | xi
10. 11. xii | Table of Contents
org.apache.cassandra.concurrent 193
org.apache.cassandra.db 193
org.apache.cassandra.gms 194
org.apache.cassandra.service 194
Custom Cassandra MBeans 196
Runtime Analysis Tools 199
Heap Analysis with JMX and JHAT 199
Detecting Thread Problems 203
Health Check 204
Summary 204
Maintenance . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 207
Getting Ring Information 208
Info 208
Ring 208
Getting Statistics 209
Using cfstats 209
Using tpstats 210
Basic Maintenance 211
Repair 211
Flush 213
Cleanup 213
Snapshots 213
Taking a Snapshot 213
Clearing a Snapshot 214
Load-Balancing the Cluster 215
loadbalance and streams 215
Decommissioning a Node 218
Updating Nodes 220
Removing Tokens 220
Compaction Threshold 220
Changing Column Families in a Working Cluster 220
Summary 221
Performance Tuning . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 223
Data Storage 223
Reply Timeout 225
Commit Logs 225
Memtables 226
Concurrency 226
Caching 227
Buffer Sizes 228
Using the Python Stress Test 228
Generating the Python Thrift Interfaces 229
Running the Python Stress Test 230
Startup and JVM Settings 232
Tuning the JVM 232
Summary 234
12. Integrating Hadoop . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 235
What Is Hadoop? 235
Working with MapReduce 236
Cassandra Hadoop Source Package 236
Running the Word Count Example 237
Outputting Data to Cassandra 239
Hadoop Streaming 239
Tools Above MapReduce 239
Pig 240
Hive 241
Cluster Configuration 241
Use Cases 242
Raptr.com: Keith Thornhill 243
Imagini: Dave Gardner 243
Summary 244
Appendix: The Nonrelational Landscape . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 245
Glossary . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 271
Index . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 285
Table of Contents | xiii