Table of Contents
Preface 1
Chapter 1: Introducing MySQL Design 5
MySQL's Popularity and Impact 5
The Need for MySQL Design 6
"What do I do Next?" 6
Data Design Steps 6
Data as a Resource 7
But this is my Data! 7
Data Modeling 8
Overview of the Relational Model 9
Rule #1 10
Rule #2 10
Simplified Design Technique 10
Case Study 11
Our Car Dealer 11
The System's Goals 12
The Tale of the Too Wide Table 12
Summary 16
Chapter 2: Data Collecting 17
System Boundaries Identification 17
Modular Development 18
Model Flexibility 19
Document Gathering 19
General Reading 19
Forms 20
Existing Computerized Systems 20
Interviews 20
Finding the Right Users 21
Table of Contents
Perceptions 21
Asking the Right Questions 21
Existing Information Systems 21
Chronological Events 22
Sources and Destinations 22
Urgency 22
Avoid Focusing on Reports and Screens 22
Data Collected for our Case Study 22
From the General Manager 23
From the Salesperson 23
From the Store Assistant 24
Other Notes 25
Summary 25
Chapter 3: Data Naming 27
Data Cleaning 27
Subdividing Data Elements 28
Data Elements Containing Formatting Characters 29
Data that are Results 29
Data as a Column's or Table's Name 30
Planning for Changes 32
Pitfalls of the Free Fields Technique 33
Naming Recommendations 34
Designer's Creativity 34
Abbreviations 34
Clarity versus Length: an Art 35
Suffixing 35
The Plural Form 35
Naming Consistency 36
MySQL's Possibilities versus Portability 36
Table Name into a Column Name 36
Summary 37
Chapter 4: Data Grouping 39
Initial List of Tables 39
Rules for Table Layout 40
Primary Keys and Table Names 40
Data Redundancy and Dependency 41
Composite Keys 42
Improving the Structure 44
Scalability over Time 44
Empty Columns 45
Avoiding ENUM and SET 46
[ ii ]
Table of Contents
Multilingual Planning 48
Validating the Structure 48
Summary 49
Chapter 5: Data Structure Tuning 51
Data Access Policies 51
Responsibility 51
Security and Privileges 53
Views 53
Storage Engines 54
Foreign Key Constraints 55
Performance 58
Indexes 58
Helping the Query Optimizer: Analyze Table 60
Accessing Replication Slave Servers 60
Speed and Data Types 61
Table Size Reduction 62
In-Column Data Encoding 62
Case Study's Final Structure 63
Vehicle 65
Person 68
Sale 69
Other tables 72
Summary 74
Chapter 6: Supplemental Case Study 75
Results from the Document Gathering Phase 75
Preliminary List of Data Elements 80
Tables and Sample Values 80
Code Tables 81
Themed Tables 82
Composite-Key Tables 85
Airline System Data Schema 87
Sample Queries 87
Inserting Sample Values 88
Boarding Pass 88
Passenger List 88
All Persons on a Flight 89
Summary 90
Index 91
[ iii ]