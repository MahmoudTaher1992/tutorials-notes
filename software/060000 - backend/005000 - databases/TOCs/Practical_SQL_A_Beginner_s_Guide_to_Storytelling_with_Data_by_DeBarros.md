manager at Red Hat, Inc.
BRIEF CONTENTS
Foreword by Sarah Frostenson
Acknowledgments
Introduction
Chapter 1: Creating Your First Database and Table
Chapter 2: Beginning Data Exploration with SELECT
Chapter 3: Understanding Data Types
Chapter 4: Importing and Exporting Data
Chapter 5: Basic Math and Stats with SQL
Chapter 6: Joining Tables in a Relational Database
Chapter 7: Table Design That Works for You
Chapter 8: Extracting Information by Grouping and Summarizing
Chapter 9: Inspecting and Modifying Data
Chapter 10: Statistical Functions in SQL
Chapter 11: Working with Dates and Times
Chapter 12: Advanced Query Techniques
Chapter 13: Mining Text to Find Meaningful Data
Chapter 14: Analyzing Spatial Data with PostGIS
Chapter 15: Saving Time with Views, Functions, and Triggers
Chapter 16: Using PostgreSQL from the Command Line
Chapter 17: Maintaining Your Database
Chapter 18: Identifying and Telling the Story Behind Your Data
Appendix: Additional PostgreSQL Resources
Index
CONTENTS IN DETAIL
FOREWORD by Sarah Frostenson
ACKNOWLEDGMENTS
INTRODUCTION
What Is SQL?
Why Use SQL?
About This Book
Using the Book’s Code Examples
Using PostgreSQL
Installing PostgreSQL
Working with pgAdmin
Alternatives to pgAdmin
Wrapping Up
1
CREATING YOUR FIRST DATABASE AND TABLE
Creating a Database
Executing SQL in pgAdmin
Connecting to the Analysis Database
Creating a Table
The CREATE TABLE Statement
Making the teachers Table
Inserting Rows into a Table
The INSERT Statement
Viewing the Data
When Code Goes Bad
Formatting SQL for Readability
Wrapping Up
Try It Yourself
2
BEGINNING DATA EXPLORATION WITH SELECT
Basic SELECT Syntax
Querying a Subset of Columns
Using DISTINCT to Find Unique Values
Sorting Data with ORDER BY
Filtering Rows with WHERE
Using LIKE and ILIKE with WHERE
Combining Operators with AND and OR
Putting It All Together
Wrapping Up
Try It Yourself
3
UNDERSTANDING DATA TYPES
Characters
Numbers
Integers
Auto-Incrementing Integers
Decimal Numbers
Choosing Your Number Data Type
Dates and Times
Using the interval Data Type in Calculations
Miscellaneous Types
Transforming Values from One Type to Another with CAST
CAST Shortcut Notation
Wrapping Up
Try It Yourself
4
IMPORTING AND EXPORTING DATA
Working with Delimited Text Files
Quoting Columns that Contain Delimiters
Handling Header Rows
Using COPY to Import Data
Importing Census Data Describing Counties
Creating the us
counties
2010 Table
_
_
Census Columns and Data Types
Performing the Census Import with COPY
Importing a Subset of Columns with COPY
Adding a Default Value to a Column During Import
Using COPY to Export Data
Exporting All Data
Exporting Particular Columns
Exporting Query Results
Importing and Exporting Through pgAdmin
Wrapping Up
Try It Yourself
5
BASIC MATH AND STATS WITH SQL
Math Operators
Math and Data Types
Adding, Subtracting, and Multiplying
Division and Modulo
Exponents, Roots, and Factorials
Minding the Order of Operations
Doing Math Across Census Table Columns
Adding and Subtracting Columns
Finding Percentages of the Whole
Tracking Percent Change
Aggregate Functions for Averages and Sums
Finding the Median
Finding the Median with Percentile Functions
Median and Percentiles with Census Data
Finding Other Quantiles with Percentile Functions
Creating a median() Function
Finding the Mode
Wrapping Up
Try It Yourself
6
JOINING TABLES IN A RELATIONAL DATABASE
Linking Tables Using JOIN
Relating Tables with Key Columns
Querying Multiple Tables Using JOIN
JOIN Types
JOIN
LEFT JOIN and RIGHT JOIN
FULL OUTER JOIN
CROSS JOIN
Using NULL to Find Rows with Missing Values
Three Types of Table Relationships
One-to-One Relationship
One-to-Many Relationship
Many-to-Many Relationship
Selecting Specific Columns in a Join
Simplifying JOIN Syntax with Table Aliases
Joining Multiple Tables
Performing Math on Joined Table Columns
Wrapping Up
Try It Yourself
7
TABLE DESIGN THAT WORKS FOR YOU
Naming Tables, Columns, and Other Identifiers
Using Quotes Around Identifiers to Enable Mixed Case
Pitfalls with Quoting Identifiers
Guidelines for Naming Identifiers
Controlling Column Values with Constraints
Primary Keys: Natural vs. Surrogate
Foreign Keys
Automatically Deleting Related Records with CASCADE
The CHECK Constraint
The UNIQUE Constraint
The NOT NULL Constraint
Removing Constraints or Adding Them Later
Speeding Up Queries with Indexes
B-Tree: PostgreSQL’s Default Index
Considerations When Using Indexes
Wrapping Up
Try It Yourself
8
EXTRACTING INFORMATION BY GROUPING AND
SUMMARIZING
Creating the Library Survey Tables
Creating the 2014 Library Data Table
Creating the 2009 Library Data Table
Exploring the Library Data Using Aggregate Functions
Counting Rows and Values Using count()
Finding Maximum and Minimum Values Using max() and min()
Aggregating Data Using GROUP BY
Wrapping Up
Try It Yourself
9
INSPECTING AND MODIFYING DATA
Importing Data on Meat, Poultry, and Egg Producers
Interviewing the Data Set
Checking for Missing Values
Checking for Inconsistent Data Values
Checking for Malformed Values Using length()
Modifying Tables, Columns, and Data
Modifying Tables with ALTER TABLE
Modifying Values with UPDATE
Creating Backup Tables
Restoring Missing Column Values
Updating Values for Consistency
Repairing ZIP Codes Using Concatenation
Updating Values Across Tables
Deleting Unnecessary Data
Deleting Rows from a Table
Deleting a Column from a Table
Deleting a Table from a Database
Using Transaction Blocks to Save or Revert Changes
Improving Performance When Updating Large Tables
Wrapping Up
Try It Yourself
10
STATISTICAL FUNCTIONS IN SQL
Creating a Census Stats Table
Measuring Correlation with corr(Y, X)
Checking Additional Correlations
Predicting Values with Regression Analysis
Finding the Effect of an Independent Variable with r-squared
Creating Rankings with SQL
Ranking with rank() and dense
_
rank()
Ranking Within Subgroups with PARTITION BY
Calculating Rates for Meaningful Comparisons
Wrapping Up
Try It Yourself
11
WORKING WITH DATES AND TIMES
Data Types and Functions for Dates and Times
Manipulating Dates and Times
Extracting the Components of a timestamp Value
Creating Datetime Values from timestamp Components
Retrieving the Current Date and Time
Working with Time Zones
Finding Your Time Zone Setting
Setting the Time Zone
Calculations with Dates and Times
Finding Patterns in New York City Taxi Data
Finding Patterns in Amtrak Data
Wrapping Up
Try It Yourself
12
ADVANCED QUERY TECHNIQUES
Using Subqueries
Filtering with Subqueries in a WHERE Clause
Creating Derived Tables with Subqueries
Joining Derived Tables
Generating Columns with Subqueries
Subquery Expressions
Common Table Expressions
Cross Tabulations
Installing the crosstab() Function
Tabulating Survey Results
Tabulating City Temperature Readings
Reclassifying Values with CASE
Using CASE in a Common Table Expression
Wrapping Up
Try It Yourself
13
MINING TEXT TO FIND MEANINGFUL DATA
Formatting Text Using String Functions
Case Formatting
Character Information
Removing Characters
Extracting and Replacing Characters
Matching Text Patterns with Regular Expressions
Regular Expression Notation
Turning Text to Data with Regular Expression Functions
Using Regular Expressions with WHERE
Additional Regular Expression Functions
Full Text Search in PostgreSQL
Text Search Data Types
Creating a Table for Full Text Search
Searching Speech Text
Ranking Query Matches by Relevance
Wrapping Up
Try It Yourself
14
ANALYZING SPATIAL DATA WITH POSTGIS
Installing PostGIS and Creating a Spatial Database
The Building Blocks of Spatial Data
Two-Dimensional Geometries
Well-Known Text Formats
A Note on Coordinate Systems
Spatial Reference System Identifier
PostGIS Data Types
Creating Spatial Objects with PostGIS Functions
Creating a Geometry Type from Well-Known Text
Creating a Geography Type from Well-Known Text
Point Functions
LineString Functions
Polygon Functions
Analyzing Farmers’ Markets Data
Creating and Filling a Geography Column
Adding a GiST Index
Finding Geographies Within a Given Distance
Finding the Distance Between Geographies
Working with Census Shapefiles
Contents of a Shapefile
Loading Shapefiles via the GUI Tool
Exploring the Census 2010 Counties Shapefile
Performing Spatial Joins
Exploring Roads and Waterways Data
Joining the Census Roads and Water Tables
Finding the Location Where Objects Intersect
Wrapping Up
Try It Yourself
15
SAVING TIME WITH VIEWS, FUNCTIONS, AND TRIGGERS
Using Views to Simplify Queries
Creating and Querying Views
Inserting, Updating, and Deleting Data Using a View
Programming Your Own Functions
Creating the percent
_
change() Function
Using the percent
_
change() Function
Updating Data with a Function
Using the Python Language in a Function
Automating Database Actions with Triggers
Logging Grade Updates to a Table
Automatically Classifying Temperatures
Wrapping Up
Try It Yourself
16
USING POSTGRESQL FROM THE COMMAND LINE
Setting Up the Command Line for psql
Windows psql Setup
macOS psql Setup
Linux psql Setup
Working with psql
Launching psql and Connecting to a Database
Getting Help
Changing the User and Database Connection
Running SQL Queries on psql
Navigating and Formatting Results
Meta-Commands for Database Information
Importing, Exporting, and Using Files
Additional Command Line Utilities to Expedite Tasks
Adding a Database with createdb
Loading Shapefiles with shp2pgsql
Wrapping Up
Try It Yourself
17
MAINTAINING YOUR DATABASE
Recovering Unused Space with VACUUM
Tracking Table Size
Monitoring the autovacuum Process
Running VACUUM Manually
Reducing Table Size with VACUUM FULL
Changing Server Settings
Locating and Editing postgresql.conf
Reloading Settings with pg_
ctl
Backing Up and Restoring Your Database
Using pg_
dump to Back Up a Database or Table
Restoring a Database Backup with pg_
restore
Additional Backup and Restore Options
Wrapping Up
Try It Yourself
18
IDENTIFYING AND TELLING THE STORY BEHIND YOUR
DATA
Start with a Question
Document Your Process
Gather Your Data
No Data? Build Your Own Database
Assess the Data’s Origins
Interview the Data with Queries
Consult the Data’s Owner
Identify Key Indicators and Trends over Time
Ask Why
Communicate Your Findings
Wrapping Up
Try It Yourself
APPENDIX
ADDITIONAL POSTGRESQL RESOURCES
PostgreSQL Development Environments
PostgreSQL Utilities, Tools, and Extensions
PostgreSQL News
Documentation
INDEX