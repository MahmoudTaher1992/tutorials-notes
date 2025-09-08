Contents
 Introduction 
.. Database languages .. Users and designers Advantages and disadvantages of dbmss 


. Information and data 
. Integrity constraints .. Tuple constraints Databases and database management systems 


. .. Keys Data models .. Keys and null values 


.. Referential constraints Conclusions .. Schemas and instances 


Bibliography .. Abstraction levels in dbmss . Exercises 


.. Data independence 
. Languages and users 
. Bibliography 
Part I. Relational databases 13
 The relational model 
. The structure of the relational model 
.. Logical models in database systems 
.. Relations and tables 
.. Relations with attributes 
.. Relations and databases 
.. Incomplete information and null values 
viii Contents
 Relational algebra and calculus 
. Relational algebra 
.. Union, intersection, difference 
.. Renaming 
.. Selection 
.. Projection 
.. Join 
.. Queries in relational algebra 
.. Equivalence of algebraic expressions 
.. Algebra with null values 
.. Views 
. Relational calculus 
.. Domain relational calculus 
.. Qualities and drawbacks of domain calculus 
.. Tuple calculus with range declarations 
. Datalog 
. Bibliography 
. Exercises 
 sql 
. Data definition in sql 
.. Elementary domains 
.. Schema definition 
.. Table definition 
.. User defined domains 
.. Default domain values 
.. Intra-relational constraints 
.. Inter-relational constraints 
.. Schema updates 
.. Relational catalogues 
. sql queries 
.. The declarative nature of sql 
.. Simple queries 
.. Aggregate queries 
.. Group by queries 
.. Set queries 
.. Nested queries 
. Data modification in sql 
.. Insertions 
.. Deletions 
.. Updates 
. Other definitions of data in sql 
.. Generic integrity constraints 
.. Assertions 
.. Views 
Contents ix
. .. Views in queries 
Access control 
.. Resources and privileges 
.. Commands for granting and revoking privileges 
. Use of sql in programming languages 
.. Integration problems 
.. Cursors 
.. Dynamic sql 
. . .. Procedures 
Summarizing examples 
Bibliography 
. Exercises 
Part II. Database design 155
 Design techniques and models 
. The database design process 
.. The life cycle of information systems 
.. Methodologies for database design 
. The Entity-Relationship model 
.. The basic constructs of the model 
.. Other constructs of the model 
.. Final overview of the e-r model 
. Documentation of e-r schemas 
.. Business rules 
.. Documentation techniques 
. Bibliography 
. Exercises 
 Conceptual design 
. Requirements collection and analysis 
. General criteria for data representation 
. Design strategies 
.. Top-down strategy 
.. Bottom-up strategy 
.. Inside-out strategy 
.. Mixed strategy 
. Quality of a conceptual schema 
. A comprehensive method for conceptual design 
. An example of conceptual design 
. case tools for database design 
. Bibliography 
. Exercises 
 Logical design 
. Performance analysis on e-r schemas 
x Contents
. Restructuring of e-r schemas 
.. Analysis of redundancies 
.. Removing generalizations 
.. Partitioning and merging of entities and relationships 
.. Selection of primary identifiers 
. Translation into the relational model 
.. Entities and many-to-many relationships 
.. One-to-many relationships 
.. Entities with external identifiers 
.. One-to-one relationships 
.. Translation of a complex schema 
.. Summary tables 
.. Documentation of logical schemas 
. An example of logical design 
. .. Restructuring phase 
.. Translation into the relational model 
Logical design using case tools 
. Bibliography 
. Exercises 
 . . Normalization 
Redundancies and anomalies 
Functional dependencies 
. Boyce–Codd normal form 
. .. Definition of Boyce–Codd normal form 
.. Decomposition into Boyce–Codd normal form 
Decomposition properties 
.. Lossless decomposition 
. .. Preservation of dependencies 
.. Qualities of decompositions 
Third normal form 
.. Definition of third normal form 
. .. Decomposition into third normal form 
.. Other normalization techniques 
Database design and normalization 
.. Verification of normalization on entities 
.. Verification of normalization on relationships 
. .. Further decomposition of relationships 
.. Further restructurings of conceptual schemas 
Bibliography 
. Part  Exercises 
III. Database technology 281
Technology of a database server 
. Definition of transactions 
Contents xi
.. acid properties of transactions 
.. Transactions and system modules 
. Concurrency control 
.. Architecture of concurrency control 
.. Anomalies of concurrent transactions 
.. Concurrency control theory 
.. Lock management 
.. Deadlock management 
. Buffer management 
.. Architecture of the buffer manager 
.. Primitives for buffer management 
.. Buffer management policies 
.. Relationship between buffer manager and file system 
. Reliability control system 
.. Architecture of the reliability control system 
.. Log organization 
.. Transaction management 
.. Failure management 
. Physical access structures 
.. Architecture of the access manager 
.. Organization of tuples within pages 
.. Sequential structures 
.. Hash-based structures 
.. Tree structures 
. Query optimization 
.. Relation profiles 
.. Internal representation of queries 
.. Cost-based optimization 
. . Physical database design 
.. Definition of indexes in sql 
Bibliography 
. Exercises 
 Distributed architectures 
. . Client-server architecture 
Distributed databases 
.. Applications of distributed databases 
.. Local independence and co-operation 
.. Data fragmentation and allocation 
.. Transparency levels 
.. Classification of transactions 
. Technology of distributed databases 
.. Distributed query optimization 
.. Concurrency control 
.. Failures in distributed systems 
xii Contents
. Two-phase commit protocol 
.. New log records 
.. Basic protocol 
.. Recovery protocols 
.. Protocol optimization 
.. Other commit protocols 
. Interoperability 
.. Open Database Connectivity (odbc) 
.. x-open Distributed Transaction Processing (dtp) 
. Co-operation among pre-existing systems 
. Parallelism 
.. Inter-query and intra-query parallelism 
.. Parallelism and data fragmentation 
.. Speed-up and scale-up 
.. Transaction benchmarks 
. Replicated databases 
.. New functions of replication managers 
. Bibliography 
. Exercises 
Part IV . Database evolution 395
 Object databases 
. Object-Oriented databases (oodbmss) 
.. Types 
.. Classes 
.. Methods 
.. Generalization hierarchies 
.. Persistence 
.. Redefinition of methods 
.. Refinement of properties and methods 
.. The object-oriented database manifesto 
. The odmg standard for object-oriented databases 
.. Object Definition Language: odl 
.. Object Query Language: oql 
. Object-Relational databases (ordbmss) 
.. sql- data model 
.. sql- query language 
.. The third generation database manifesto 
. Multimedia databases 
.. Types of multimedia data 
.. Queries on multimedia data 
.. Document search 
.. Representation of spatial data 
. Technological extensions for object-oriented databases 
Contents xiii
.. Representation of data and identifiers 
.. Complex indexes 
.. Client-server architecture 
.. Transactions 
.. Distribution and interoperability:  
. Bibliography 
. Exercises 
 Active databases 
. Trigger behaviour in a relational system 
. Definition and use of triggers in Oracle 
.. Trigger syntax in Oracle 
.. Behaviour of triggers in Oracle 
.. Example of execution 
. Definition and use of triggers in  
.. Trigger syntax in  
.. Behaviour of triggers in  
.. Example of execution 
. Advanced features of active rules 
. Properties of active rules 
. Applications of active databases 
.. Referential integrity management 
.. Business rules 
. Bibliography 
. Exercises 
 Data analysis 
. Data warehouse architecture 
. Schemas for data warehouses 
.. Star schema 
.. Star schema for a supermarket chain 
.. Snowflake schema 
. Operations for data analysis 
.. Query formulation interfaces 
.. Drill-down and roll-up 
.. Data cube 
. Development of the data warehouse 
.. Bitmap and join indexes 
.. View materialization 
. Data mining 
.. The data mining process 
.. Data mining problems 
.. Data mining perspectives 
. Bibliography 
. Exercises 
xiv Contents
 Databases and the World Wide Web 
. The Internet and the World Wide Web 
.. The Internet 
.. The World Wide Web 
.. html 
.. http 
.. Gateways 
. Information systems on the Web 
.. Publication and consultation on the Web 
.. Transactions on the Web 
.. Electronic commerce and other new applications 
. Design of data-intensive Web sites 
.. A logical model for data-intensive hypertexts 
.. Levels of representation in Web hypertexts 
.. Design principles for a data-intensive Web site 
. Techniques and tools for database access through the Web 
.. Database access through cgi programs 
.. Development tools 
.. Shortcomings of the cgi protocol 
.. Simulating long connections for transactions 
.. Server-based alternatives to the cgi approach 
.. Client-based alternatives to the cgi approach 
. Bibliography 
. Exercises 
Part V . Appendices & Bibliography 519
Appendix A Microsoft Access 
. System characteristics 
. Definition of tables 
.. Specification of join paths 
.. Populating the table 
. Query definition 
.. Query By Example 
.. The sql interpreter 
. Forms and reports 
. The definition of macros 
Appendix B DB2 Universal Database 
. db overview 
.. Versions of the system 
.. Instances and schemas of db 
.. Interaction with db 
. Database management with db 
.. Interactive tools 
.. Application programs 
Contents xv
. Advanced features of db 
.. Extension of sql for queries 
.. Object-oriented features of db 
Appendix C Oracle PL/SQL 
. Tools architecture of Oracle 
. Base domains 
. The object-relational extension of Oracle 
. pl/sql language 
.. Execution of pl/sql in a client-server environment 
.. Declarations of variables and cursors 
.. Control structures 
.. Management of exceptions 
.. Procedures 
.. Packages 
Bibliography 
Index 