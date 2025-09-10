Contents
About the Authors                                       xiii
About the Technical Reviewers                            xv
Acknowledgments                                      xvii
Introduction                                           xix
Chapter 1: Introduction to MongoDB■ ■                        1
Reviewing the MongoDB Philosophy                             1
Using the Right Tool for the Right Job                                    1
Lacking Innate Support for Transactions                                  3
JSON and MongoDB                                                 4
Adopting a Nonrelational Approach                                      6
Opting for Performance vs. Features                                     7
Running the Database Anywhere                                       8
Fitting Everything Together                                   9
Generating or Creating a Key                                           9
Using Keys and Values                                               10
Implementing Collections                                            10
Understanding Databases                                            11
Reviewing the Feature List                                   11
Using Document-Oriented Storage (BSON)                                11
Supporting Dynamic Queries                                          12
Indexing Your Documents                                            13
vii
■ Contents
Leveraging Geospatial Indexes                                         14
Profiling Queries                                                   14
Updating Information In-Place                                         14
Storing Binary Data                                                 15
Replicating Data                                                   15
Implementing Sharding                                              16
Using Map and Reduce Functions                                      16
The MongoDB Aggregation Framework                                  17
Getting Help                                               17
Visiting the Website                                                 17
Chatting with the MongoDB Developers                                  17
Cutting and Pasting MongoDB Code                                     18
Finding Solutions on Google Groups                                     18
Leveraging the JIRA Tracking System                                   18
Summary                                                 18
Chapter 2: Installing MongoDB■ ■                            19
Choosing Your Version                                       19
Understanding the Version Numbers                                    20
Installing MongoDB on Your System                            20
Installing MongoDB under Linux                                        21
Installing MongoDB under Windows                                     23
Running MongoDB                                          23
Prerequisites                                                      23
Surveying the Installation Layout                                      24
Using the MongoDB Shell                                            25
viii
■ Contents
Installing Additional Drivers                                  26
Installing the PHP Driver                                              27
Confirming That Your PHP Installation Works                             30
Installing the Python Driver                                           32
Confirming That Your PyMongo Installation Works                         35
Summary                                                 36
Chapter 3: The Data Model■ ■                              37
Designing the Database                                     37
Drilling Down on Collections                                           39
Using Documents                                                   41
Creating the _id Field                                               44
Building Indexes                                           45
Impacting Performance with Indexes                                    45
Implementing Geospatial Indexing                             46
Querying Geospatial Information                                       47
Using MongoDB in the Real World                              52
Summary                                                 53
Chapter 4: Working with Data■ ■                            55
Navigating Your Databases                                   55
Viewing Available Databases and Collections                             56
Inserting Data into Collections                                56
Querying for Data                                          58
Using the Dot Notation                                               60
Using the Sort, Limit, and Skip Functions                                 62
Working with Capped Collections, Natural Order, and $natural                63
ix
■ Contents
Retrieving a Single Document                                         65
Using the Aggregation Commands                                     65
Working with Conditional Operators                                     68
Leveraging Regular Expressions                                       78
Updating Data                                             78
Updating with update( )                                               78
Implementing an Upsert with the save( ) Command                         79
Updating Information Automatically                                    80
Specifying the Position of a Matched Array                               85
Atomic Operations                                                  86
Modifying and Returning a Document Atomically                          88
Renaming a Collection                                      89
Removing Data                                            90
Referencing a Database                                     91
Referencing Data Manually                                           91
Referencing Data with DBRef                                         93
Implementing Index-Related Functions                         95
Surveying Index-Related Commands                                   97
Forcing a Specified Index to Query Data                                 97
Constraining Query Matches                                          98
Summary                                                 99
Chapter 5: GridFS■ ■                                    101
Filling in Some Background                                 102
Working with GridFS                                       103
Getting Started with the Command-Line Tools                   103
Using the _id Key                                                  104
Working with Filenames                                            105
Determining a File’s Length                                          105
x
■ Contents
Working with Chunk Sizes                                           106
Tracking the Upload Date                                            106
Hashing Your Files                                                 106
Looking Under MongoDB’s Hood                              107
Using the search Command                                          109
Deleting                                                         110
Retrieving Files from MongoDB                                       111
Summing Up mongofiles                                            111
Exploiting the Power of Python                              111
Connecting to the Database                                         112
Accessing the Words                                               113
Putting Files into MongoDB                                  113
Retrieving Files from GridFS                                114
Deleting Files                                             114
Summary                                                115
Index                                                117