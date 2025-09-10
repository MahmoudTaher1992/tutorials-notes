Contents
Lesson 1: Introduction to Entities, Attributes, and Relationships
Introduction 1-2
Why Conceptual Modeling? 1-4
Entity Relationship Modeling 1-7
Goals of Entity Relationship Modeling 1-8
Database Types 1-9
Entities 1-10
Entities and Sets 1-12
Attributes 1-13
Relationships 1-15
Entity Relationship Models and Diagrams 1-17
Representation 1-18
Attribute Representation 1-19
Relationship Representation 1-20
Data and Functionality 1-23
Types of Information 1-24
Other Graphical Elements 1-27
Summary 1-28
Practice 1—1: Instance or Entity 1-29
Practice 1—2: Guest 1-30
Practice 1—3: Reading 1-31
Practice 1—4: Read and Comment 1-32
Practice 1—5: Hotel 1-33
Practice 1—6: Recipe 1-34
General Instructor Notes 1-35
Practices 1-38
Suggested Timing 1-41
Workshop Interviewing 1-42
.....................................................................................................................................................
iii®
Contents
.....................................................................................................................................................
Lesson 2: Entities and Attributes in Detail
Introduction 2-2
Data Compared to Information 2-4
Data 2-5
Tracking Entities 2-7
Electronic Mail Example 2-9
Evolution of an Entity Definition 2-11
Functionality 2-13
Tracking Attributes 2-14
Subtypes and Supertypes 2-17
Summary 2-20
Practice 2—1: Books 2-21
Practice 2—2: Moonlight 2-22
Practice 2—3: Shops 2-23
Practice 2—4: Subtypes 2-24
Practice 2—5: Schedule 2-25
Practice 2—6: Address 2-26
Practice 2—6: Address (continued) 2-27
Lesson 3: Relationships in Detail
Introduction 3-2
Establishing a Relationship 3-4
Relationship Types 3-9
Relationships and Attributes 3-16
Attribute Compared to Relationship 3-18
Relationship Compared to Attribute 3-19
m:m Relationships May Hide Something Resolving Relationships 3-25
Normalization During Data Modeling 3-28
Summary 3-32
Practice 3—1: Read the Relationship 3-33
Practice 3—2: Find a Context 3-34
Practice 3—3: Name the Intersection Entity Practice 3—4: Receipt 3-36
Practice 3—5: Moonlight P&O 3-37
Practice 3—6: Price List 3-39
3-20
3-35
.....................................................................................................................................................
iv Data Modeling and Relational Database Design
Contents
.....................................................................................................................................................
Practice 3—7: E-mail 3-40
Practice 3—8: Holiday 3-41
Practice 3—9: Normalize an ER Model 3-42
Lesson 4: Constraints
Introduction 4-2
Identification 4-4
Unique Identifier 4-6
Arcs 4-12
Arc or Subtypes 4-16
More About Arcs and Subtypes 4-17
Hidden Relationships 4-18
Domains 4-19
Some Special Constraints 4-20
Summary 4-24
Practice 4—1: Identification Please 4-25
Practice 4—2: Identification 4-26
Practice 4—3: Moonlight UID 4-28
Practice 4—4: Tables 4-29
Practice 4—5: Modeling Constraints 4-30
Lesson 5: Modeling Change
Introduction 5-2
Time 5-4
Date as Opposed to Day 5-5
Entity DAY 5-6
Modeling Changes Over Time 5-7
A Time Example: Prices 5-10
Current Price 5-16
Journalling 5-17
Summary 5-19
Practice 5—1: Shift 5-20
Practice 5—2: Strawberry Wafer 5-21
Practice 5—3: Bundles 5-22
Practice 5—4: Product Structure 5-24
.....................................................................................................................................................
v®
Contents
.....................................................................................................................................................
Lesson 6: Advanced Modeling Topics
Introduction 6-2
Patterns 6-4
Master Detail 6-5
Basket 6-6
Classification 6-7
Hierarchy 6-8
Chain 6-10
Network 6-11
Symmetric Relationships 6-13
Roles 6-14
Fan Trap 6-15
Data Warehouse 6-16
Drawing Conventions 6-17
Generic Modeling 6-19
Generic Models 6-20
More Generic Models 6-21
Most Generic Model 6-22
Summary 6-23
Practice 6—1: Patterns 6-24
Practice 6—2: Data Warehouse 6-25
Practice 6—3: Argos and Erats 6-26
Practice 6—4: Synonym 6-27
Lesson 7: Mapping the ER Model
Introduction 7-2
Why Create a Database Design? 7-4
Transformation Process 7-6
Naming Convention 7-8
Basic Mapping 7-12
Relationship Mapping 7-14
Mapping of Subtypes 7-20
Subtype Implementation 7-23
Summary 7-30
Practice 7—1: Mapping basic Entities, Attributes and Relationships Practice 7—2: Mapping Supertype 7-32
7-31
.....................................................................................................................................................
vi Data Modeling and Relational Database Design
Contents
.....................................................................................................................................................
Practice 7—3: Quality Check Subtype Implementation Practice 7—4: Quality Check Arc Implementation Practice 7—5: Mapping Primary Keys and Columns 7-33
7-34
7-35
Lesson 8: Denormalized Data
Introduction 8-2
Why and When to Denormalize 8-4
Storing Derivable Values 8-6
Pre-Joining Tables 8-8
Hard-Coded Values 8-10
Keeping Details With Master 8-12
Repeating Single Detail with Master 8-14
Short-Circuit Keys 8-16
End Date Columns 8-18
Current Indicator Column 8-20
Hierarchy Level Indicator 8-22
Denormalization Summary 8-24
Practice 8—1: Name that Denormalization Practice 8—2: Triggers 8-26
Practice 8—3: Denormalize Price Lists Practice 8—4: Global Naming 8-30
8-25
8-29
Lesson 9: Database Design Considerations
Introduction 9-2
Reconsidering the Database Design 9-4
Oracle Data Types 9-5
Most Commonly-Used Oracle Data Types Column Sequence 9-7
Primary Keys and Unique Keys 9-8
Artificial Keys 9-11
Sequences 9-13
Indexes 9-16
Choosing Columns to Index 9-19
When Are Indexes Used? 9-21
Views 9-23
Use of Views 9-24
Old-Fashioned Design 9-25
9-6
.....................................................................................................................................................
vii®
Contents
.....................................................................................................................................................
Distributed Design 9-27
Benefits of Distributed Design 9-28
Oracle Database Structure 9-29
Summary 9-31
Practice 9—1: Data Types 9-32
Practice 9—2: Artificial Keys 9-34
Practice 9—3: Product Pictures 9-35
Appendix A: Solutions
Introduction to Solutions A-2
Practice 1—1 Instance or Entity: Solution Practice 1—2 Guest: Solution A-5
A-4
Practice 1—3 Reading: Solution A-6
Practice 1—4 Read and Comment: Solution A-7
Practice 1—5 Hotel: Solution A-8
Practice 1—6 Recipe: Solution A-9
Practice 2—1 Books: Solution A-11
Practice 2—2 Moonlight: Solution A-12
Practice 2—3 Shops: Solution A-13
Practice 2—4 Subtypes: Solution A-14
Practice 2—5 Schedule: Solution A-15
Practice 2—6 Address: Solution A-16
Practice 3—1 Read the Relationship: Solution A-18
Practice 3—2 Find a Context: Solution A-19
Practice 3—3 Name the Intersection Entity: Solution A-20
Practice 3—4 Receipt: Solution A-21
Practice 3—5 Moonlight P&O: Solution A-23
Practice 3—6 Price List: Solution A-27
Practice 3—7 E-mail: Solution A-28
Practice 3—8 Holiday: Solution A-30
Practice 3—9: Normalize an ER Model: Solution A-32
Practice 4—1 Identification Please: Solution A-34
Practice 4—2 Identification: Solution A-36
Practice 4—3 Moonlight UID: Solution A-39
Practice 4—4 Tables: Solution A-40
Practice 4—5 Constraints: Solution A-41
.....................................................................................................................................................
viii Data Modeling and Relational Database Design
Contents
.....................................................................................................................................................
Practice 5—1 Shift: Solution A-42
Practice 5—2 Strawberry Wafer: Solution A-43
Practice 5—3 Bundles: Solution A-44
Practice 5—4 Product Structure: Solution A-46
Practice 6—1 Patterns: Solution A-47
Practice 6—2 Data Warehouse: Solution A-49
Practice 6—3 Argos and Erats: Solution A-50
Practice 6—4 Synonym: Solution A-51
Practice 7—1 Mapping basic Entities, Attributes and Relationships:
Solution A-52
Practice 7—2 Mapping Supertype: Solution A-53
Practice 7—3 Quality Check Subtype Implementation: Solution Practice 7—4 Quality Check Arc Implementation: Solution A-55
Practice 7—5 Primary Keys and Columns: Solution A-56
Practice 8—1 Name that Denormalization: Solution A-57
Practice 8—2 Triggers: Solution A-58
Practice 8—3 Denormalize Price Lists: Solution A-61
Practice 8—4 Global Naming: Solution A-63
Practice 9—1 Data Types: Solution A-64
Practice 9—2 Artificial Keys: Solution A-66
Practice 9—3 Product Pictures: Solution A-67
A-54
Appendix B: Normalization
Introduction B-2
Normalization and its Benefits B-3
First Normal Form B-7
Second Normal Form B-9
Third Normal Form B-11
Summary B-13