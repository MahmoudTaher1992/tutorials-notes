Based on the syllabus entry you provided, **Part V, Section B: Amazon DynamoDB** focuses on AWS’s flagship generic NoSQL database. Unlike RDS (which is for SQL/Relational data), DynamoDB is designed for massive scale, high speed, and flexible data structures.

Here is a detailed explanation of every point listed in that section.

---

### 1. Core Concepts: Tables, Items, and Attributes
To understand DynamoDB, it helps to compare it to a traditional SQL database (like MySQL), but with key differences regarding flexibility.

*   **Tables:** Similar to SQL tables, this is the main container for your data (e.g., a "Users" table). However, unlike SQL, you do not define a rigid schema for the whole table—you only define the Primary Key.
*   **Items:** Roughly equivalent to a "Row" in SQL. An item is a single record in the table.
    *   *Key difference:* In SQL, every row must have the same columns. In DynamoDB, Item A can have 3 pieces of data, while Item B has 10, all within the same table.
*   **Attributes:** Equivalent to "Columns." These are the data fields attached to an item (e.g., Name, Email, Address). DynamoDB supports scalars (Strings, Numbers) and nested complex types (Lists, Maps/JSON).

### 2. Primary Keys: Partition Key and Sort Key
In DynamoDB, the Primary Key is how you uniquely identify an item. You cannot query data efficiently without using keys. There are two types of Primary Key structures:

#### A. Simple Primary Key (Partition Key only)
*   You choose one attribute (e.g., `UserID`).
*   DynamoDB uses this value as an input to an internal hash function. The result determines which physical hard drive partition the data is stored on.
*   **Best for:** 1-to-1 lookups (e.g., "Get me the user with UserID `123`").

#### B. Composite Primary Key (Partition Key + Sort Key)
*   You choose two attributes (e.g., `Artist` as Partition Key and `SongTitle` as Sort Key).
*   **How it works:** All items with the same Partition Key (`Artist`) are stored together physically. Inside that partition, they are sorted alphabetically (or numerically) by the Sort Key (`SongTitle`).
*   **Best for:** 1-to-Many relationships. It allows you to query: "Give me all songs by `Taylor Swift` (Partition) sorted by `Song Title` (Sort)."

### 3. Data Modeling in DynamoDB
This is often the hardest part for people coming from a SQL background.
*   **No Joins:** DynamoDB does not support `JOIN` operations.
*   **Access Patterns First:** In SQL, you design your data first, then write queries. In DynamoDB, you must know exactly how you will query the data *before* you create the table.
*   **Denormalization:** Because you can't join tables, you often duplicate data or store related data in a single item (nested JSON) or use a strategy called "Single Table Design" where different types of entities (Users, Orders) sit in the same table to improve retrieval speed.

### 4. Read/Write Capacity Modes
DynamoDB offers two pricing/scaling models depending on how predictable your traffic is.

#### A. Provisioned Mode (default)
*   **How it works:** You tell AWS exactly how much power you need (e.g., "I need 10 reads per second and 5 writes per second").
*   **Billing:** You pay for the capacity you reserved, whether you use it or not.
*   **Use Case:** Predictable traffic (e.g., an internal HR app used 9-5). You can use **Auto-Scaling** to adjust this, but it isn't instant.

#### B. On-Demand Mode
*   **How it works:** You don't select any capacity. AWS instantly accommodates your traffic, whether it is 0 requests or 10,000 requests per second.
*   **Billing:** You pay a higher rate per individual request, but you pay *nothing* if nobody uses the DB.
*   **Use Case:** Unpredictable traffic, startups, or new apps where you don't know the load yet.

### 5. Secondary Indexes: Global and Local
By default, you can *only* query DynamoDB efficiently using the Primary Key. But what if your Primary Key is `UserID`, but you want to search by `EmailAddress`? You need an Index.

#### A. Local Secondary Index (LSI)
*   **Constraint:** Must have the **same Partition Key** as the main table, but a **different Sort Key**.
*   **Creation:** Must be created *at the same time* you create the table. It cannot be added later.
*   **Use Case:** You want to sort the data you already have in a partition differently (e.g., Sort User's Orders by "Date" usually, but sometimes sort them by "Amount").

#### B. Global Secondary Index (GSI)
*   **Flexibility:** Can have a completely **different Partition Key** and **Sort Key** from the main table.
*   **Creation:** Can be created or deleted at any time.
*   **Concept:** Think of a GSI as a "shadow copy" of your table that is automatically kept in sync by AWS, organized differently to allow different queries.
*   **Use Case:** Your table key is `UserID`, but you create a GSI where the key is `Email` so you can login users by email.

### 6. DynamoDB Streams (Change Data Capture)
DynamoDB Streams is a feature that allows you to trigger code whenever data changes.

*   **How it works:** If you enable Streams, every time an item is Added (INSERT), Updated (MODIFY), or Deleted (REMOVE), a record of that change is put into a queue (stream).
*   **Retention:** Data is kept in the stream for 24 hours.
*   **Major Use Case:**
    *   **Lambda Triggers:** A user updates their profile picture in DynamoDB -> The Stream captures the event -> Triggers a generic AWS Lambda function -> The Lambda function resizes the image and saves it to S3.
    *   **Replication:** Replicating data to another database for analytics (like copying DynamoDB data to Redshift or ElasticSearch).
