Here is a detailed explanation of **Part 13: Alternative Concurrency Control**.

---

# 13. Alternative Concurrency Control: Detailed Explanation

Traditional locking (discussed in Part 11) is "Pessimistic." It assumes a collision *will* occur, so it blocks users just in case. However, waiting for locks destroys performance in high-concurrency systems.

**Alternative Concurrency Control** refers to methods like **MVCC** (used by PostgreSQL, Oracle, MySQL InnoDB) and **Optimistic Locking** that allow multiple users to read and write simultaneously without waiting for each other, vastly improving throughput.

## 13.1 Multi-Version Concurrency Control (MVCC)

The core philosophy of MVCC is: **"Readers do not block Writers, and Writers do not block Readers."**

### 13.1.1 MVCC Principles
Instead of updating a row in place (overwriting data), the database creates a **new version** of that row.
*   **The Scenario:** Transaction A reads Row 1. Transaction B updates Row 1.
*   **The Result:** Transaction A sees the "Old Version" (consistent with when it started). Transaction B works on the "New Version." Both run instantly without locking each other.

### 13.1.2 Version Chain Management
*   Since multiple versions of a single row exist simultaneously, they are linked together.
*   **PostgreSQL:** Stores old versions in the main table heap (leads to "bloat").
*   **Oracle/MySQL:** Stores old versions in a separate storage area called "Undo Segments" or "Undo Logs."
*   **The Chain:** The database must know that `Version 3` points to `Version 2`, which points to `Version 1`.

### 13.1.3 Snapshot Creation and Management
*   When a query starts, it takes a **Snapshot**. This is not a physical copy of data; it is a list of "Transaction IDs that are currently active."
*   **Purpose:** It acts as a filter. "Show me data created by transactions that finished *before* I started. Hide everything else."

### 13.1.4 Visibility Rules
*   Every row version has creation metadata (e.g., `xmin` and `xmax` in Postgres).
*   **The Rule:** A row is visible to you **if** it was created by a committed transaction **and** not deleted by a committed transaction that happened before your snapshot.
*   **Profiling Impact:** Calculating visibility for every single row uses CPU. If the version chain is long (20 updates to one row), the CPU has to traverse 20 entries just to find the one it is allowed to see.

### 13.1.5 MVCC Overhead
MVCC solves locking, but creates new resource problems:
*   **13.1.5.1 Version Storage:** Storing 5 versions of a row takes 5x the disk space.
*   **13.1.5.2 Garbage Collection (Vacuum/Purge):** Old versions are eventually useless (no active transaction needs them). A background process (Postgres `VACUUM` or MySQL Purge Threads) must run to delete them. This eats CPU and I/O.
*   **13.1.5.3 Version Chain Traversal:** Queries get slower if they have to step over thousands of "dead" rows to find "live" data.

---

## 13.2 MVCC Profiling

How do you know if your MVCC system is healthy or drowning in old data?

### 13.2.1 Version Bloat Detection
*   **Definition:** When a table is 10GB on disk, but only contains 1GB of live data. The rest is "dead tuples" (deleted rows or old versions of updated rows).
*   **Profiling:** Comparing "Live Tuple Count * Average Row Width" vs. "Physical Table Size." Large discrepancies indicate bloat.

### 13.2.2 Long-Running Transaction Impact
*   **The Danger:** If a user starts a transaction at 9:00 AM and leaves it open until 5:00 PM, the database **cannot delete any versions** created after 9:00 AM. Why? Because that one user *might* need to see them.
*   **Result:** The "Garbage Collector" stalls, bloat accumulates rapidly, and the disk fills up.
*   **Profiling:** Monitor `MAX(transaction_duration)`. Alert immediately if it exceeds 1 hour.

### 13.2.3 Snapshot Too Old (Oracle) / SSOT (Postgres)
*   **Error:** `ORA-01555: Snapshot too old`.
*   **Cause:** A query runs for so long that the "Undo" data it needs to construct a consistent view has already been overwritten by the cleanup process.
*   **Profiling:** Track the frequency of these errors. It implies your Undo space is too small or your queries are too slow.

### 13.2.4 Vacuum/Purge Performance
*   **13.2.4.1 Vacuum Lag:** The time gap between a row becoming "dead" and the Vacuum process removing it.
*   **13.2.4.2 Dead Tuple Accumulation:** A metric (e.g., `n_dead_tup` in Postgres) showing how many rows are waiting to be cleaned.
*   **13.2.4.3 Bloat Measurement:** Analyzing index bloat is critical too—indexes often grow faster than tables in MVCC systems because every version needs an index entry.

### 13.2.5 MVCC-Related Wait Events
*   Even in MVCC, you might wait.
*   **Example:** Waiting for "buffer content lock" (reading a page) or waiting for the "Undo Log" to flush to disk.

---

## 13.3 Optimistic Concurrency Control (OCC)

Used often in In-Memory databases (like Redis/MemSQL) or at the Application layer (Hibernate/ORM).

### 13.3.1 OCC Principles
*   **Pessimistic:** "Lock it first, then write."
*   **Optimistic:** "Read it, calculate the change, and right before saving, check if anyone else changed it. If yes, fail."
*   **Mechanics:** Uses a version number or timestamp column on the row.
    *   *Step 1:* Read Row (Version=1).
    *   *Step 2:* Update Row SET Version=2 WHERE Version=1.
    *   *Step 3:* Check: Did 1 row get updated? If 0, someone else changed it to Version 2 already.

### 13.3.2 Conflict Detection Profiling
*   Measure how often the "Check" fails.
*   If conflicts are rare (e.g., < 1%), OCC is faster than locking because it avoids the overhead of the Lock Manager.

### 13.3.3 Retry Rate Analysis
*   **Critical Metric:** When an OCC check fails, the application **must** retry the entire transaction.
*   **Profiling:** If 30% of your transactions are failing and retrying, OCC is the wrong choice. The system is doing work, throwing it away, and doing it again (high CPU waste).

### 13.3.4 OCC vs. Pessimistic Locking Trade-offs
*   **Low Contention:** OCC wins (less overhead).
*   **High Contention:** Pessimistic wins (waiting is better than re-doing work 5 times).

---

## 13.4 Latch Profiling

This is deep internal profiling. While **Locks** protect logical data (rows), **Latches** protect the database's own memory structures.

### 13.4.1 Latches vs. Locks
*   **Locks:** Long duration (entire transaction). Managed by a complex "Lock Manager." Deadlock detection exists.
*   **Latches:** Extremely short duration (microseconds). Protect physical RAM (e.g., "Don't read this memory address while I'm writing to it"). No deadlock detection (usually).

### 13.4.2 Buffer Pool Latches
*   **Scenario:** To read a page from the Buffer Pool (Cache), the database must "latch" that page to ensure it doesn't disappear or change structure while being read.
*   **Profiling:** High buffer latches usually mean "Hot Pages"—everyone is reading the exact same small table or index root page simultaneously.

### 13.4.3 Internal Structure Latches
*   **LRU Latch:** Protecting the "Least Recently Used" list. Every time you read a page, you move it to the "Recently Used" end of the list. This requires a latch.
*   **WAL/Redo Write Latch:** Serializing access to the transaction log buffer.

### 13.4.4 Latch Contention Hotspots
*   **Symptom:** High CPU usage (User + System), but low disk I/O.
*   **Cause:** **Spinlocks**. When a thread hits a latch, it doesn't "go to sleep" (which is slow); it "spins" on the CPU (executing a tight loop checking "Is it free yet?"). This burns CPU cycles rapidly.

### 13.4.5 Latch Wait Analysis
*   **Profiling Tools:**
    *   *SQL Server:* `sys.dm_os_latch_stats`.
    *   *Oracle:* `latch: cache buffers chains`.
    *   *Postgres:* `WaitEventLWLock`.
*   **Optimization:** You usually can't "tune" latches directly. You reduce latch contention by **optimizing queries** (reading fewer pages) or **partitioning data** (spreading the load across different memory structures).