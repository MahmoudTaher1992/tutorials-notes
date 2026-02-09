Here is a detailed explanation of **Part 11: Locking Fundamentals**.

---

# 11. Locking Fundamentals: Detailed Explanation

In a database serving hundreds of users, two people will inevitably try to change the same piece of data at the same time. **Locking** is the traffic light system that prevents collisions (data corruption). It ensures **ACID** properties (specifically Isolation and Consistency) by forcing transactions to wait their turn.

## 11.1 Lock Types and Modes

Locks are not binary (locked/unlocked). There are different "modes" depending on what the user wants to do.

### 11.1.1 Shared Locks (S-Locks) - "Read Locks"
*   **Purpose:** Used for reading data (`SELECT`).
*   **Behavior:** "I am reading this book. You can read it with me, but nobody is allowed to rip out pages or write in it."
*   **Compatibility:** Compatible with other Shared locks. Multiple users can hold S-locks on the same row simultaneously. Incompatible with Exclusive locks.

### 11.1.2 Exclusive Locks (X-Locks) - "Write Locks"
*   **Purpose:** Used for modifying data (`INSERT`, `UPDATE`, `DELETE`).
*   **Behavior:** "I am rewriting this page. Nobody else can read it or write to it until I am done."
*   **Compatibility:** Incompatible with **everything**. If Transaction A holds an X-lock, Transaction B must wait to get an S-lock or an X-lock.

### 11.1.3 Update Locks (U-Locks)
*   **Purpose:** A bridge between Shared and Exclusive. Used when a transaction reads a row *intending* to update it later.
*   **Problem Solved:** Prevents **Deadlocks**. If two transactions both read (S-Lock) and then both try to upgrade to Write (X-Lock), they will block each other forever.
*   **Behavior:** Allows other readers (S-locks), but blocks other Update locks. Only one transaction can hold a U-lock; when it's ready to write, it converts to an X-lock.

### 11.1.4 Intent Locks (IS, IX, SIX)
*   **Purpose:** These are "Hierarchy Hints." They solve the problem of checking every single row to see if a table can be locked.
*   **Analogy:** If you want to lock the **entire hotel** (Table Lock), you don't want to check every single **room** (Row Lock) to see if someone is inside. You just look at the sign in the lobby.
*   **IS (Intent Shared):** "I have a read lock on a specific row inside this table."
*   **IX (Intent Exclusive):** "I have a write lock on a specific row inside this table."
*   **SIX (Shared with Intent Exclusive):** "I am reading the whole table, but I might update one specific row."

### 11.1.5 Schema Locks (Sch-M, Sch-S)
*   **Purpose:** Protects the structure (metadata) of the table.
*   **Sch-S (Stability):** Held while compiling a query. Ensures nobody drops the table while you are figuring out how to query it.
*   **Sch-M (Modification):** Held during DDL (`ALTER TABLE`, `DROP INDEX`). It blocks **all** access to the table. This is why adding a column to a 1TB table can freeze the application.

### 11.1.6 Bulk Update Locks (BU)
*   **Purpose:** Optimization for bulk loading data (e.g., `BULK INSERT` or `COPY`).
*   **Behavior:** Allows multiple threads to load data into the same table concurrently, provided they are not loading into the exact same physical pages.

### 11.1.7 Key-Range Locks
*   **Purpose:** Used in **Serializable** isolation to prevent **Phantom Reads**.
*   **Behavior:** Locks the specific rows *and* the empty "gap" between values.
*   **Example:** If you `SELECT * WHERE age BETWEEN 10 and 20`, it locks existing records (12, 15) and the empty space. It prevents someone from inserting a new record with age 14, protecting the integrity of the range.

---

## 11.2 Lock Granularity

Granularity refers to the *size* of the object being locked.

### 11.2.1 Database-level locks
*   Locks the entire database. Rare in production traffic; usually reserved for restoring backups or detaching the database.

### 11.2.2 Table-level locks
*   Locks the whole table.
*   **Pros:** Very low memory overhead (only 1 lock to manage).
*   **Cons:** Zero concurrency. Only one person can write to the table at a time.

### 11.2.3 Page-level locks
*   Locks a storage page (usually 8KB). A page might contain 100 rows.
*   **Behavior:** Common in SQL Server. If you update Row 1, you incidentally lock Rows 2-100 that live on the same page.

### 11.2.4 Row-level locks
*   Locks only the specific tuple/row being modified.
*   **Pros:** Maximum concurrency.
*   **Cons:** High memory overhead. Managing 1 million distinct locks requires lots of RAM.

### 11.2.5 Column-level locks
*   Extremely rare. Most databases do not support this because the overhead of tracking locks per-column outweighs the benefits.

### 11.2.6 Lock Escalation
This is a database self-defense mechanism.
*   **11.2.6.1 Escalation Thresholds:** Each lock takes up memory (e.g., 96 bytes). If a query acquires too many locks (e.g., > 5,000 row locks) or consumes too much lock memory (e.g., > 40% of pool), the database decides it is too expensive to track them individually.
*   **11.2.6.2 Impact:** The database swaps the 5,000 row locks for **1 Table Lock**.
    *   *Result:* The query continues, but suddenly **everyone else is blocked**. This is a common cause of unexpected application freezing.
*   **11.2.6.3 Prevention:**
    *   Keep transactions short.
    *   Ensure indexes are used (so you don't scan/lock the whole table to find one row).
    *   Break large batch updates into smaller chunks (update 1,000 rows at a time).

---

## 11.3 Lock Duration

How long does the lock stick around?

### 11.3.1 Transaction-duration locks
*   Held from the moment they are acquired until the transaction sends `COMMIT` or `ROLLBACK`.
*   Standard behavior for **Exclusive (Write)** locks to ensure data recovery consistency.

### 11.3.2 Statement-duration locks
*   Held only while the specific SQL statement is executing, then released immediately, even if the transaction is still open.
*   Common for **Shared (Read)** locks in lower isolation levels (Read Committed).

### 11.3.3 Short-term Latches
*   **Distinction:** Locks protect **logical data** (Rows). Latches protect **physical memory** (RAM structures).
*   **Scenario:** When the database reads a page from disk to RAM, it "Latches" the buffer pool slot so no other thread overwrites that RAM space while the data is being copied.
*   **Duration:** Microseconds. If you see high "Latch Contention," it usually means CPU/Memory pressure, not logic errors.

### 11.3.4 Lock Release Timing (Two-Phase Locking - 2PL)
*   **Phase 1 (Growing):** The transaction acquires locks as it needs them.
*   **Phase 2 (Shrinking):** The transaction releases locks (usually all at once at the end).
*   *Note:* You generally cannot release locks in the middle of a transaction, or you violate ACID properties.

---

## 11.4 Locking in Different Isolation Levels

The "Isolation Level" is a setting that tells the database how strict it should be about locking. It is a trade-off between **Data Accuracy** and **Speed/Concurrency**.

### 11.4.1 Read Uncommitted
*   **Behavior:** "Dirty Reads." Readers do not acquire Shared locks. They do not respect Exclusive locks held by others.
*   **Result:** You might read data that is about to be rolled back (data that never really happened).
*   **Locking:** Minimal locking, highest speed, dangerous data.

### 11.4.2 Read Committed (Default for PostgreSQL, SQL Server, Oracle)
*   **Behavior:** You can only read data that has been committed.
*   **Locking:**
    *   Writers hold X-locks until the transaction ends.
    *   Readers acquire S-locks, read the row, and **release them immediately**.
*   **Result:** Good concurrency. However, if you read the same row twice in one transaction, it might change in between (Non-Repeatable Read).

### 11.4.3 Repeatable Read (Default for MySQL)
*   **Behavior:** If you read a row once, it is guaranteed to stay the same for the duration of your transaction.
*   **Locking:** Readers acquire S-locks and **hold them until the transaction ends**.
*   **Result:** Prevents modification of data you are looking at, but increases the chance of deadlocks.

### 11.4.4 Serializable
*   **Behavior:** The strictest level. It simulates running transactions one after another (serially).
*   **Locking:** Uses **Key-Range Locks**. It locks not just the rows you read, but the query criteria itself.
*   **Result:** Prevents "Phantom Reads" (new rows appearing). Lowest concurrency, highest blocking.

### 11.4.5 Snapshot Isolation
*   **Behavior:** Uses **MVCC (Multi-Version Concurrency Control)** instead of locking for readers.
*   **Mechanism:** When you read, you don't get a lock. You get a "photograph" (Snapshot) of the database as it looked when your transaction started.
*   **Locking impact:** "Readers do not block Writers; Writers do not block Readers." This significantly reduces locking overhead but requires more storage (to keep old versions of rows).

### 11.4.6 Isolation level impact on lock behavior
*   **Summary:** As you move down the list (Uncommitted -> Serializable), the database holds **more locks** for **longer durations**, covering **wider ranges** of data.
*   **Trade-off:** High isolation = High data integrity, Low performance. Low isolation = High performance, Potential data anomalies.