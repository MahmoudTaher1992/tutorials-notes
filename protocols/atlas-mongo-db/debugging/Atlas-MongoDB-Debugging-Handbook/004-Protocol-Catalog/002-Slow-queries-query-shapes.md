Based on the structure of the handbook you provided, the section **4.2 Slow queries & query shapes** (File: `004-Protocol-Catalog/002-Slow-queries-query-shapes.md`) is likely the **core diagnostic section** for application performance issues.

While Section 4.1 focuses on the *side effect* (connections filling up), **Section 4.2 focuses on the *cause* (inefficient code asking the database to do too much work).**

Here is a detailed explanation of what this section covers, technically and operationally.

---

# 🐢 Detailed Breakdown: Slow Queries & Query Shapes

This protocol focuses on identifying specific database operations that take too long to execute, understanding *why* they are slow, and grouping them by "shape" to assess their total impact on the system.

### 1. Concepts Definitions

#### **What is a "Slow Query"?**
A query is considered "slow" if it exceeds a defined execution threshold (e.g., 100ms). However, in a debugging context, a slow query is any operation that:
*   **Scans too many documents:** It looks through 100,000 documents to return just 1.
*   **Performs an in-memory sort:** It grabs data and has to sort it manually because it lacks a pre-sorted index.
*   **Blocks other operations:** It holds a lock for too long, preventing other users from reading/writing.

#### **What is a "Query Shape"?**
MongoDB groups similar queries together to calculate statistics. This is often called a **Query Fingerprint**.
*   **Query A:** `db.users.find({ "username": "alice" })`
*   **Query B:** `db.users.find({ "username": "bob" })`

To MongoDB, these are the **same shape**: `db.users.find({ "username": <value> })`.
*   **Why this matters:** When debugging, you don't look for "Alice's log." You look for the *Pattern* (Shape) that runs 5,000 times a minute and averages 500ms. Fixing the *shape* fixes thousands of individual slow queries.

---

### 2. The Golden Metric: The "Examined vs. Returned" Ratio

This section of the handbook typically emphasizes the most important metric in MongoDB profiling: **`KeysExamined` / `DocsExamined` vs. `nReturned`**.

*   **Ideal Scenario (1:1):** The database looks at 5 index keys, finds the 5 documents, and returns them.
    *   *Status:* ✅ Excellent.
*   **Bad Scenario (1000:1):** The database scans 1,000 documents (a "COLLSCAN" or Collection Scan) to find the 1 document that matches your criteria.
    *   *Status:* 🚨 Critical/Missing Index. This burns CPU and Disk I/O.

---

### 3. Investigation Steps (The "How-To")

This file would instruct the engineer to perform the following analysis in the MongoDB Atlas UI:

#### **A. Using the Query Profiler**
1.  Navigate to the **Profiler** tab.
2.  Sort by **Count** (to see the most frequent queries) or **Total Execution Time** (to see which queries account for the most aggregate load).
3.  Identify the **Query Shape** showing a huge bar for "Docs Examined."

#### **B. Using the Performance Advisor**
1.  Atlas automatically analyzes slow query shapes.
2.  This section checks if Atlas has already generated a **Recommended Index**.
3.  *Action:* If an index is suggested for a slow shape, creating it is usually the fix.

#### **C. Examining the "Explain Plan"**
The protocol instructs the user to run an `.explain("executionStats")` on the slow query.
*   **Look for `stages`:**
    *   **`IXSCAN`:** Good. It used an index.
    *   **`COLLSCAN`:** Bad. It scanned every document in the collection.
    *   **`SORT_KEY_GENERATOR`:** Bad. It is sorting in memory (CPU intensive).

---

### 4. Common "Query Shape" Anti-Patterns

This section often lists common coding mistakes that lead to slow shapes:

1.  **The Un-Indexed Search:** Searching by a field (e.g., `email`) that has no index.
2.  **The Regex Wildcard:** Searching for `like "%gmail%"` (contains). This forces a full scan because indexes generally work from left to right.
3.  **The "Not Equal" Trap:** Queries using `$ne` (not equal) usually cannot effectively use indexes and force scans.
4.  **Large Result Sets:** A query attempting to return 50,000 documents at once without pagination (`limit` / `skip`).

---

### 5. Resolution Strategy

Finally, this section provides the fix logic:

1.  **Add Indexes:** Create an index that matches the query shape (ESR Rule: Equality, Sort, Range).
2.  **Rewrite Query:** Change the code to avoid inefficient operators (e.g., switch from regex to a text search index).
3.  **Limit Fields (`Projection`):** Don't return the whole document if you only need the ID.
4.  **Caching:** If the query is complex but the data rarely changes, move the read to a cache (Redis) instead of hitting Atlas every time.

### Summary
In the context of your handbook, **4.2** is the step where you stop looking at *graphs* (CPU is high) and start looking at *code* (This specific `find()` command is missing an index, causing the high CPU).
