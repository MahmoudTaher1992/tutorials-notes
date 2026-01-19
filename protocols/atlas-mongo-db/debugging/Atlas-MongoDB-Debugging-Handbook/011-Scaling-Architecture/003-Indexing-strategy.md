Based on the structure of your handbook, the file **`011-Scaling-Architecture/003-Indexing-strategy.md`** focuses on the long-term design and health of your indexes, rather than just "how to fix a slow query right now."

In the context of scaling and architecture, **Indexing Strategy** is about balancing **Read Performance** (getting data fast) vs. **Write Performance** (saving data fast) and **Memory Usage** (RAM).

Here is a detailed explanation of what this protocol covers, broken down by the architectural principles usually found in this section.

---

# 📂 Detailed Explanation: Indexing Strategy
### *File: 011-Scaling-Architecture/003-Indexing-strategy.md*

This section defines the "Rules of the Road" for how developers and DBAs should create indexes to ensure the cluster can scale without crashing CPU or saturating Disk I/O.

## 1. The Golden Rule: The ESR Framework
This is the foundational strategy for MongoDB indexing. If an index doesn't follow ESR, it is likely inefficient.

*   **E - Equality:** First, list fields that are queried for exact matches (e.g., `user_id = 123`).
*   **S - Sort:** Next, list fields used for sorting (e.g., `created_at: -1`).
*   **R - Range:** Last, list fields used for range filters (e.g., `price > 50` or `date > '2023-01-01'`).

**Why this matters for Scaling:**
If you put the **Range** field before the **Sort** field in your index definition, MongoDB cannot use the index to sort the results. It has to perform an in-memory "Blocking Sort," which kills CPU and effectively caps your concurrency limits.

> **Bad Strategy:** Index `{ timestamp: 1, status: 1 }`
> **Good Strategy:** Index `{ status: 1, timestamp: 1 }` (Equality first, then Sort).

## 2. The "Covered Query" Strategy
The most scalable query is one that never touches the document storage (Disk) and gets everything it needs purely from the Index (search tree).

*   **Concept:** A query is "covered" if the index contains all fields inside the query filter **AND** all fields physically returned (projected) to the client.
*   **Architecture Goal:** For your highest throughput APIs (e.g., a "Get User Balance" header called 1M times/hour), you should design indexes specifically to cover these queries.
*   **The Win:** `totalDocsExamined` becomes 0. Disk I/O drops significantly.

## 3. Index Cardinality & Selectivity
This section explains *what* makes a field worthy of an index.

*   **High Cardinality (Good):** Fields with many unique values (Email, UUID, OrderNumber). These are great for indexes.
*   **Low Cardinality (Bad):** Fields with few values (Gender, Status: Active/Inactive, Boolean).
    *   *Why:* If you index a Boolean field (`isActive`), the index sends the database to scan 50% of your documents. It’s often faster for MongoDB to just scan the whole collection than to jump back and forth using an index for a low-cardinality field.

## 4. The "Write Penalty" (Index Bloat)
Every time your application inserts, updates, or deletes a document, MongoDB must update **every single index** associated with that collection.

*   **The Scaling Problem:** If you have 30 indexes on a collection to support various reporting queries, your **Insert/Update latency** will degrade significantly. You are trading Write Throughput for Read Flexibility.
*   **Strategic Limit:** A general rule of thumb regarding architecture is to keep indexes under 5–10 per collection. If you need more, you might need a different data model or an Analytics node.

## 5. RAM vs. Index Size (The Working Set)
For MongoDB to be performant, your **Indexes must fit in RAM**.

*   **The Bottleneck:** If your total Index Size exceeds the available wiredTiger cache (RAM), MongoDB must swap index pages to and from the Disk.
*   **Result:** This causes "Disk I/O Saturation" and "IOPS Throttling," leading to the `Connections % > 80` alert mentioned in your triage section.
*   **Strategy:** Monitor the metric `mem.bits` vs `indexSize`. If Index Size is huge, you must drop unused indexes to free up RAM.

## 6. Lifecycle Management (Unused & Redundant Indexes)
Scaling isn't just about adding; it's about cleaning up.

*   **Redundant Indexes:** If you have an index on `{ user_id: 1, date: -1 }` and another on `{ user_id: 1 }`, the second one is redundant. The compound index can handle the query for `user_id` alone. This wastes RAM and disk space.
*   **Unused Indexes:** This section suggests running a script (using `$indexStats`) to find indexes that haven't been used since the last restart and dropping them.

---

# 🛠 Practical Action Plan (Runbook Context)

If you are using this document to solve an incident, here is what you are looking for:

1.  **Check for Missing Indexes:** Look at the Profiler. Are there queries with massive `COLLSCAN` (Collection Scan)? Create indexes following the **ESR** rule.
2.  **Check for Bad Indexes:** Are there queries doing an in-memory `SORT`? This means the index keys are in the wrong order.
3.  **Check Index Size:** Is `Index Size` > `System RAM`? You need to delete indexes or upgrade the cluster tier.
4.  **Consolidate:** Can you combine three different single-field indexes into one Compound Index that serves all three query patterns?

### Summary of this section's intent:
> "Don't just add an index blindly because a query is slow. Design your indexes so they fit in memory, don't kill write performance, and satisfy the specific logic (Equality, Sort, Range) of your application's busiest queries."
