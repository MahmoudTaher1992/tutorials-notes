Table of Contents
Preface 1
Chapter 1: Graphs and Graph Theory – an Introduction 7
Introduction to and history of graphs 7
Definition and usage of graph theory 11
Social studies 13
Biological studies 14
Computer science 15
Flow problems 16
Route problems 17
Web search 18
Test questions 19
Summary 20
Chapter 2: Graph Databases – Overview 21
Background 21
Navigational databases 23
Relational databases 25
NoSQL databases 28
Key-Value stores 29
Column-Family stores 30
Document stores 31
Graph databases 32
The Property Graph model of graph databases 34
Node labels 36
Relationship types 36
Why (or why not) graph databases 37
Why use a graph database? 37
Complex queries 37
In-the-clickstream queries on live data 39
Path finding queries 39
Table of Contents
Why not use a graph database, and what to use instead 40
Large, set-oriented queries 40
Graph global operations 40
Simple, aggregate-oriented queries 41
Test questions 41
Summary 42
Chapter 3: Getting Started with Neo4j 43
Neo4j – key concepts and characteristics 43
Built for graphs, from the ground up 44
Transactional, ACID-compliant database 44
Made for Online Transaction Processing 46
Designed for scalability 48
A declarative query language – Cypher 49
Sweet spot use cases of Neo4j 50
Complex, join-intensive queries 51
Path finding queries 51
Committed to open source 52
The features 53
The support 53
The license conditions 54
Installing Neo4j 56
Installing Neo4j on Windows 56
Installing Neo4j on Mac or Linux 62
Using Neo4j in a cloud environment 65
Test Questions 71
Summary 71
Chapter 4: Modeling Data for Neo4j 73
The four fundamental data constructs 73
How to start modeling for graph databases 75
What we know – ER diagrams and relational schemas 75
Introducing complexity through join tables 77
A graph model – a simple, high-fidelity model of reality 78
Graph modeling – best practices and pitfalls 79
Graph modeling best practices 79
Design for query-ability 80
Align relationships with use cases 80
Look for n-ary relationships 81
Granulate nodes 82
Use in-graph indexes when appropriate 84
Graph database modeling pitfalls 86
Using "rich" properties 86
Node representing multiple concepts 87
[ ii ]
Table of Contents
Unconnected graphs 88
The dense node pattern 88
Test questions 89
Summary 90
Chapter 5: Importing Data into Neo4j 91
Alternative approaches to importing data into Neo4j 92
Know your import problem – choose your tooling 93
Importing small(ish) datasets 96
Importing data using spreadsheets 96
Importing using Neo4j-shell-tools 100
Importing using Load CSV 103
Scaling the import 107
Questions and answers 110
Summary 111
Chapter 6: Use Case Example – Recommendations 113
Recommender systems dissected 113
Using a graph model for recommendations 115
Specific query examples for recommendations 117
Recommendations based on product purchases 118
Recommendations based on brand loyalty 119
Recommendations based on social ties 120
Bringing it all together – compound recommendations 121
Business variations on recommendations 122
Fraud detection systems 123
Access control systems 124
Social networking systems 125
Questions and answers 126
Summary 126
Chapter 7: Use Case Example – Impact Analysis and Simulation 127
Impact analysis systems dissected 128
Impact analysis in Business Process Management 128
Modeling your business as a graph 129
Which applications are used in which buildings 130
What buildings are affected if something happens to Appl_9? 131
What BusinessProcesses with an RTO of 0-2 hours would be affected by a fire
at location Loc_100 132
Impact simulation in a Cost Calculation environment Modeling your product hierarchy as a graph Working with a product hierarchy graph Calculating the price based on a full sweep of the tree Calculating the price based on intermediate pricing 134
134
136
137
138
[ iii ]
Table of Contents
Impact simulation on product hierarchy 140
Questions and Answers 142
Summary 142
Chapter 8: Visualizations for Neo4j 143
The power of graph visualizations 143
Why graph visualizations matter! 143
Interacting with data visually 144
Looking for patterns 145
Spot what's important 145
The basic principles of graph visualization 146
Open source visualization libraries 147
D3.js 148
Graphviz 149
Sigma.js 150
Vivagraph.js 151
Integrating visualization libraries in your application 152
Visualization solutions 153
Gephi 154
Keylines 155
Linkurio.us 156
Neo4j Browser 157
Tom Sawyer 158
Closing remarks on visualizations 159
The "fireworks" effect 159
The "loading" effect 159
Questions and answers 160
Summary 160
Chapter 9: Other Tools Related to Neo4j 161
Data integration tools 161
Talend 163
MuleSoft 164
Business Intelligence tools 165
Modeling tools 168
Arrows 168
OmniGraffle 170
Questions and answers 171
Summary 171
Appendix A: Where to Find More Information Related to Neo4j 173
Online tools 173
Google group 174
Stack Overflow 175
[ iv ]
Table of Contents
The Neo4j community website 176
The new Neo4j website 177
The Neo4j Blog 178
GraphGists collection 179
The Cypher reference card 180
Other books 181
Events 181
Meetup 181
GraphConnect 182
Conferences 182
Training 182
Neo Technology 183
Appendix B: Getting Started with Cypher 185
The key attributes of Cypher 185
Key operative words in Cypher 187
The Cypher refcard 189
Syntax 190
Index 195