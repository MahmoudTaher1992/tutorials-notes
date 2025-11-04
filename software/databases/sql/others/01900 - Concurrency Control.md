Concurrency Control
19.1. Concurrency Problems (Lost Updates, Dirty Reads, Phantoms)
19.2. Concurrency Control Mechanisms
19.2.1. Locking Protocols (Two-Phase Locking, Granularity)
19.2.2. Timestamp-Based and Optimistic Protocols
19.2.3. Multiversion Concurrency Control (MVCC)
19.3. Transaction Isolation Levels
19.3.1. Read Uncommitted, Read Committed, Repeatable Read, Serializable
19.4. Deadlocks: Prevention, Detection, and Resolution



Of course! As your super teacher for Database Systems, I will gladly provide a detailed explanation of Concurrency Control. This is a crucial topic that explains how a database can handle many users and operations at the same time without corrupting data or producing incorrect results. It is the core mechanism that enforces the "**I**" (Isolation) in the ACID properties.

Let's break down your requested table of contents in detail.

# Concurrency Control

*   **Goal**: [To manage simultaneous operations on a database without them interfering with one another, ensuring the consistency and integrity of the data.]
*   **Analogy**: [Imagine two librarians trying to update the same card catalog entry at the same time. Without rules (concurrency control), one librarian might erase the other's work, or a student might read an entry that is only half-updated. Concurrency control provides the rules to prevent this chaos.]

---

## 19.1. Concurrency Problems (Anomalies)

*   [These are the specific types of errors that can occur if multiple transactions are not managed correctly. Normalization solves data redundancy problems; concurrency control solves these operational problems.]

*   ### Lost Update Problem
    *   **Definition**: [When one transaction's successful update is overwritten by another transaction, causing the first update to be "lost".]
    *   **Scenario**:
        *   [Transaction A reads an item's inventory count, which is 10.]
        *   [Transaction B also reads the inventory count, which is still 10.]
        *   [Transaction A adds 5 to the count (10 + 5 = 15) and writes the result '15' back to the database.]
        *   [Transaction B subtracts 2 from the count it read (10 - 2 = 8) and writes its result '8' back to the database, overwriting A's update.]
        *   **Incorrect Result**: [The final count is 8. **Correct Result should be 13** (10 + 5 - 2).]

*   ### Dirty Read Problem (Reading Uncommitted Data)
    *   **Definition**: [When a transaction reads data that has been modified by another transaction but has **not yet been committed**.]
    *   **Scenario**:
        *   [Transaction A updates an employee's salary from $50,000 to $60,000, but does not commit yet.]
        *   [Transaction B reads the employee's salary and sees the "dirty" value of $60,000, using it to calculate a new pension contribution.]
        *   [Transaction A then fails and **rolls back**, reverting the salary to $50,000.]
        *   **Incorrect Result**: [Transaction B has now made a decision based on data that never officially existed.]

*   ### Non-Repeatable Read Problem
    *   **Definition**: [When a transaction reads the same data item twice and gets a different value each time because another transaction **committed** a change in between the two reads.]
    *   **Scenario**:
        *   [Transaction A reads a product's price and sees $100.]
        *   [Transaction B updates the product's price to $120 and commits.]
        *   [Transaction A reads the same product's price again within the same transaction and now sees $120. Its initial read is no longer repeatable.]
        *   **Problem**: [This creates an inconsistent view of the data within a single transaction.]

*   ### Phantom Read Problem
    *   **Definition**: [When a transaction runs the same query twice and the **set of rows** returned is different because another transaction **committed** an `INSERT` or `DELETE` operation.]
    *   **Non-Repeatable vs. Phantom**: [A non-repeatable read is when the *value* of a specific row changes. A phantom read is when the *number of rows* changes (a new "phantom" row appears or an existing row disappears).]
    *   **Scenario**:
        *   [Transaction A runs a query: `SELECT COUNT(*) FROM Employees WHERE DepartmentID = 5;` and gets a result of 10.]
        *   [Transaction B adds a new employee to Department 5 and commits.]
        *   [Transaction A runs the exact same query again and now gets a result of 11.]
        *   **Problem**: [The data set has changed, which could invalidate the logic of the first transaction.]

---

## 19.2. Concurrency Control Mechanisms

### 19.2.1. Locking Protocols (Pessimistic)

*   **Approach**: [**Pessimistic Concurrency Control**. It assumes conflicts *will* happen and prevents them by acquiring **locks** on data. A transaction must acquire a lock before it can access a piece of data.]
*   **Lock Types**:
    *   **Shared Lock (Read Lock)**:
        *   [Allows multiple transactions to read the same resource concurrently. If Transaction A holds a shared lock, other transactions can also get a shared lock on the same data.]
        *   **Constraint**: [No transaction can acquire an exclusive lock on the data until all shared locks are released.]
    *   **Exclusive Lock (Write Lock)**:
        *   [Grants exclusive access to a resource. If Transaction A holds an exclusive lock, no other transaction can get any kind of lock (shared or exclusive) on that data.]
*   **Two-Phase Locking (2PL) Protocol**:
    *   **Goal**: [A protocol that ensures **serializability** (the result is the same as if the transactions had run one after another in some order).]
    *   **The Two Phases**:
        1.  **Growing Phase (Expanding)**: [The transaction can only **acquire** new locks. It cannot release any.]
        2.  **Shrinking Phase (Contracting)**: [Once the transaction releases its first lock, it enters this phase. It can now only **release** locks and cannot acquire any new ones.]
    *   **Strict 2PL**: [The most common commercial implementation. It follows the growing phase, but holds **all locks** until the transaction either `COMMIT`s or `ABORT`s. This prevents dirty reads.]
*   **Lock Granularity**:
    *   [Refers to the **size of the data item** being locked (e.g., a single field, a row, a page of data, or an entire table). There is a trade-off between concurrency and overhead.]
        *   **Fine Granularity (e.g., row-level locks)**: [Higher concurrency (many users can work on the same table), but more overhead to manage all the locks.]
        *   **Coarse Granularity (e.g., table-level locks)**: [Lower concurrency (only one user can write to a table at a time), but very little overhead.]

### 19.2.2. Timestamp-Based and Optimistic Protocols

*   **Approach**: [**Optimistic Concurrency Control**. It assumes conflicts are rare. Transactions are allowed to work on data without acquiring locks.]
*   **Timestamp-Based Protocol**:
    *   **Methodology**:
        *   [Every transaction is assigned a unique **timestamp** when it starts.]
        *   [Every data item has a **read-timestamp** and a **write-timestamp** (the timestamp of the last transaction to read/write it).]
        *   [When a transaction tries to access data, its timestamp is compared to the data's timestamps. If a conflict is detected (e.g., a transaction with an older timestamp tries to write to data that has already been read by a newer transaction), the conflicting transaction is aborted and restarted.]
*   **Optimistic Protocol**:
    *   [Transactions read data into a private workspace, make their changes there, and then try to commit. During the commit phase (validation), the system checks if any other committed transaction has modified the data that this transaction read. If a conflict is found, the transaction is rolled back.]

### 19.2.3. Multiversion Concurrency Control (MVCC)

*   **Approach**: [A highly popular and advanced form of optimistic control used by databases like PostgreSQL, Oracle, and SQL Server's Snapshot Isolation.]
*   **Methodology**:
    *   [When a transaction modifies data, the database does **not** overwrite the old data. Instead, it creates a **new version** of the data item.]
    *   [Each transaction is given a consistent "snapshot" of the database at the time it began. It can only see the versions of data that were committed before it started.]
    *   **Key Benefit**: [**Readers don't block writers, and writers don't block readers.**]
        *   [A transaction that is reading data can continue to read the old, consistent version, even while another transaction is creating a new version of that same data.]

---

## 19.3. Transaction Isolation Levels

*   **Concept**: [The SQL standard defines four isolation levels that allow a database administrator to make a trade-off between **concurrency (performance)** and **consistency (correctness)**. A stricter level prevents more anomalies but reduces concurrency.]

### 19.3.1. The Four Levels

*   **Read Uncommitted (Lowest Level)**
    *   [Allows a transaction to read uncommitted changes made by other transactions.]
    *   **Anomalies Allowed**: [**Dirty Reads**, Non-Repeatable Reads, Phantom Reads.]
*   **Read Committed**
    *   [Ensures a transaction can only read data that has been committed. This is the default level for most databases (e.g., PostgreSQL, SQL Server).]
    *   **Anomalies Prevented**: [Dirty Reads.]
    *   **Anomalies Allowed**: [Non-Repeatable Reads, Phantom Reads.]
*   **Repeatable Read**
    *   [Guarantees that if a transaction reads the same row multiple times, it will get the same data each time.]
    *   **Anomalies Prevented**: [Dirty Reads, Non-Repeatable Reads.]
    *   **Anomalies Allowed**: [**Phantom Reads** (because new rows can still be inserted by other transactions).]
*   **Serializable (Highest Level)**
    *   [The strictest level. It guarantees that the concurrent execution of transactions will produce the same result as if they were executed one after another in some order.]
    *   **Anomalies Prevented**: [**All of them**: Dirty Reads, Non-Repeatable Reads, Phantom Reads.]
    *   **Implementation**: [Often achieved using strict two-phase locking or by forcing transactions to wait if they might conflict.]

---

## 19.4. Deadlocks: Prevention, Detection, and Resolution

*   **Definition**: [A **deadlock** occurs when two or more transactions are waiting indefinitely for resources held by each other, creating a circular dependency.]
*   **Classic Example**:
    *   [Transaction A locks `Resource X` and requests a lock on `Resource Y`.]
    *   [Transaction B locks `Resource Y` and requests a lock on `Resource X`.]
    *   [Neither transaction can proceed. They are in a "deadly embrace".]

*   ### Deadlock Prevention
    *   [Strategies that make deadlocks structurally impossible. For example, requiring all transactions to acquire locks in the same predefined order (e.g., always lock Table A before Table B). This is often impractical to enforce in complex systems.]

*   ### Deadlock Detection
    *   [The most common approach. The database system periodically checks for deadlocks.]
    *   **Method**: [It builds a "wait-for" graph, where a directed edge from Transaction A to Transaction B means A is waiting for a resource held by B. If the system detects a **cycle** in this graph, a deadlock exists.]

*   ### Deadlock Resolution
    *   [Once a deadlock is detected, the system must break it.]
    *   **Method**: [It chooses one transaction as a **"victim"** and **aborts** it (rolls it back). This releases its locks, allowing the other transaction(s) to proceed. The application may then be able to restart the aborted transaction.]
    *   **Timeout**: [A simpler, less precise method. If a transaction waits for a lock for longer than a predefined timeout period, it is automatically aborted, assuming a deadlock might have occurred.]