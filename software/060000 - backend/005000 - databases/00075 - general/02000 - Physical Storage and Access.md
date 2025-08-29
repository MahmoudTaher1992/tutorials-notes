# Physical Storage and Access

## The Operating System's Files

* the data ultimately lives in files on the Operating System's file system
    * stored on secondary storage (HDD or SSD)
* Location
    * a big file
    * a disk partition
        * pros
            * Bypassing OS File System Overhead
            * 
        * i.e.
            * Oracle Database
                * in the past
                * specific high-performance setups
        



        Hello! As your super teacher specializing in Database Systems, I'm here to explain **Physical Storage and Access: The Filing System in Relational Databases**.

This topic is all about *how* your database actually stores information on the computer's hard drive and *how* it finds that information quickly when you ask for it. Think of it like organizing a massive library so you can instantly grab any book you need, rather than rummaging through every single one.

### Physical Storage and Access: The Filing System in Relational Databases

*   **Goal**: [To optimize how data is *actually* stored and retrieved from slower secondary storage (like a hard drive) to make database operations fast and efficient.]
    *   **Key Consideration**: [This process is highly dependent on the specific Database Management System (DBMS) you are using.]

*   **Physical Database Design**: [The final phase in database design, focusing on the real-world implementation of the logical schema (your tables and relationships).]
    *   **Purpose**: [Determines the best way to lay out data on disk and create structures to access it quickly, based on how your applications will use the data.]
    *   **Output**: [The **physical schema**, which defines how tables are stored and what access structures (like indexes) are used.]

*   **Key Internal Components**
    *   **Buffer Manager**:
        *   **Role**: [Manages the flow of data between the slow disk and the fast main memory (RAM).]
        *   **Functionality**: [Optimizes input/output (I/O) operations by keeping frequently accessed **pages** (fixed-size blocks of data) in a temporary storage area in RAM called the **buffer pool**.]
        *   **Benefit**: [Reduces the number of slow disk reads, making queries much faster.]
    *   **Access Manager (Relational Storage System - RSS)**:
        *   **Role**: [Responsible for executing the actual physical data reads and writes as instructed by the database's query optimizer.]
        *   **Functionality**: [Provides "access methods"—software modules that know *how* to locate, insert, update, and delete individual data records (called **tuples** or rows) within the database pages.]

*   **Organization of Tuples within Pages**
    *   **Concept**: [Describes how individual rows (tuples) are structured and managed within the fixed-size data blocks called **pages**, which are the fundamental units transferred to/from disk.]
    *   **Pages**: [The database system reads and writes data to and from the disk in whole pages, not byte by byte.]
    *   **Page Structure Components**:
        *   **Page Header/Trailer**: [Control information specific to the database, such as the page ID, pointers to next/previous pages, the number of tuples in the page, and the amount of free space.]
        *   **Page Dictionary (Slot Directory)**: [Contains pointers (offsets) that indicate the exact starting location of each tuple within that specific page.]
        *   **Useful Part**: [The actual application-specific data (your rows/tuples).]
        *   **Checksum**: [Used to verify the data integrity of the page, ensuring it hasn't been corrupted.]
    *   **Tuple Storage**:
        *   [Tuples can be **fixed-length** (all rows have the same size) or **variable-length** (rows can have different sizes, common with text fields).]
        *   [Often, the page dictionary and the actual data grow from opposite ends of the page, leaving free space in the middle for future insertions or updates.]

*   **Physical Access Structures (Indexes)**
    *   **Purpose**: [To enable very efficient, associative access to data, allowing the database to find specific rows quickly based on key values without scanning the entire table.]
    *   **Analogy**: [Like the index at the back of a textbook: you look up a keyword, and it gives you page numbers directly, instead of you reading the whole book to find mentions of that keyword.]
    *   **Definition**: [Defined by the database designer using Data Definition Language (DDL) commands (e.g., `CREATE INDEX`).]
    *   **Types**:
        *   **Sequential Structures**:
            *   **Concept**: [Tuples are physically arranged one after another on disk.]
            *   **Entry-Sequenced Organization**: [Tuples are stored in the order they are inserted. Good for simply adding new data at the end.]
            *   **Sequentially Ordered Organization**: [Tuples are physically ordered on disk based on the values of a specific "key" field (e.g., by `EmployeeID`).]
                *   **Pros**: [Highly efficient for queries that involve searching for a specific value or a range of values on that ordered key (e.g., all employees with IDs between 100 and 200).]
                *   **Cons**: [High cost for insertions/updates, as maintaining the physical order on disk can require a lot of data movement.]
        *   **Hash-Based Structures**:
            *   **Concept**: [Uses a **hashing function** to directly calculate the exact disk location (block number) where a tuple with a specific key value should be stored or retrieved.]
            *   **How it Works**: [You give it a key (e.g., `ProductID`), the hashing function crunches it and immediately tells you which disk block to go to.]
            *   **Pros**: [**Extremely fast** for equality queries (`WHERE ProductID = 'XYZ'`), often requiring only one disk I/O.]
            *   **Cons**: [Inefficient for range queries (`WHERE ProductID BETWEEN 'A' AND 'Z'`) because related keys aren't necessarily stored physically close together. Can suffer from **collisions** (when two different keys hash to the same location), leading to slower "overflow chains."]
        *   **Tree Structures (B-Trees & B+ Trees)**:
            *   **Concept**: [The most widely used type of index in relational databases, organized as a hierarchical, balanced tree structure where each node typically corresponds to a disk page.]
            *   **Balanced**: [All paths from the root (top) of the tree to any leaf (bottom) node are of equal length, ensuring consistent and fast access times regardless of which data you're looking for.]
            *   **Node Contents & Search**: [Intermediate nodes contain ordered keys and pointers to child nodes, guiding the search down the tree until the desired data is found in a leaf node.]
            *   **B+ Tree (Most Common)**:
                *   **All data in leaves**: [A key difference is that **all actual data (or pointers to it) is stored exclusively in the leaf nodes.** Intermediate nodes *only* contain keys and pointers to direct the search.]
                *   **Linked Leaves**: [**Leaf nodes are linked together sequentially** (like a chain). This is a huge advantage for range queries, as once the first item in the range is found, the database can simply scan across the linked leaf nodes without going back up the tree.]
            *   **Pros**:
                *   **Excellent for both equality queries** (`WHERE Name = 'Alice'`) **and range queries** (`WHERE Age BETWEEN 20 AND 30`).
                *   **Self-balancing**: [Automatically adjusts its structure (through splits and merges) to maintain performance even with many insertions and deletions.]
            *   **Cons**: [Requires traversing multiple disk pages (levels of the tree) during a search, though typically only a few levels are needed even for huge databases.]

*   **Index Definition in SQL (Common Syntax)**
    *   `CREATE INDEX IndexName ON TableName (Attribute1 [ASC|DESC], Attribute2 [ASC|DESC], ...);`
        *   [Used to create a new index on specified table columns.]
        *   `UNIQUE`: [An optional keyword that ensures no two rows can have the same value for the indexed attributes.]
        *   **Example**: `CREATE INDEX CustomerEmailIndex ON Customers(EmailAddress);`
    *   `DROP INDEX IndexName;`
        *   [Used to remove an existing index.]
        *   **Example**: `DROP INDEX CustomerEmailIndex;`
    *   **Best Practice**: [Create indexes on columns frequently used in `WHERE` clauses (for filtering data) and `JOIN` conditions (for combining data from multiple tables). However, be careful not to create too many indexes, as they add overhead to data modification operations (inserts, updates, deletes).]