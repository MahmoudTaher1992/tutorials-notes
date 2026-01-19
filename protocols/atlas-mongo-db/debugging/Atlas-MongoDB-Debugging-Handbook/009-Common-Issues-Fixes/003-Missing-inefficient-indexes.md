Based on the Table of Contents you provided, here is the detailed breakdown of what belongs in the **Common Issues & Fixes > Missing / Inefficient Indexes** section (`009-Common-Issues-Fixes/003-Missing-inefficient-indexes.md`).

This explanation follows the style of an operational handbook/runbook.

---

# 📂 003 — Missing & Inefficient Indexes
**Status:** 🩹 Fixable | **Severity:** 🔴 High (Causes High CPU & Disk I/O)

## 1. 🔍 The Problem: What is it?
The database is performing too much work to find the data required.
*   **Missing Index:** The database cannot find a lookup table, so it must read every single document in the collection (Collection Scan) to find matches.
*   **Inefficient Index:** An index exists, but it is poorly designed (e.g., wrong field order), causing the database to scan a large portion of the index or perform "in-memory sorts" to fulfill the query.

## 2. 🚨 Symptoms & Diagnosis
How do you know this is your problem?

### A. The "Ratio" Check (The Golden Metric)
In the detailed breakdown of a slow query, look at **Keys Examined** vs. **Documents Returned**.
*   **Ideal:** 1:1 ratio (Examined 1 index key, returned 1 document).
*   **Acceptable:** < 100:1.
*   **Bad:** Examining 50,000 keys/docs to return 10 documents.
    *   *This effectively means the engine did a lot of work and threw most of it away.*

### B. High CPU & Disk I/O
*   **High CPU:** Used to inspect documents and sort data in memory without an index.
*   **High Disk Read:** If the collection scan reads more data than fits in RAM, it triggers expensive disk reads.

### C. `COLLSCAN` in Profiler
If you check the **Explain Plan** or the **Profiler**, look for the stage:
*   ❌ `COLLSCAN`: (Collection Scan) - No index used. Bad.
*   ❌ `SORT`: (in-memory sort) - Data found, but no index available to handle the sort, so the CPU has to manually sort results.

---

## 3. 🔬 Root Causes & Fixes

### Scenario A: The Absolute Missing Index
**Scenario:** You query `{ email: "user@example.com" }` but have no index on `email`.
*   **What happens:** MongoDB scans 1 million user docs to find that one email.
*   **The Fix:** Create a single field index.
    ```javascript
    db.users.createIndex({ email: 1 })
    ```

### Scenario B: The "ESR" Rule Violation (Inefficient Index)
This is the most common cause of *inefficient* indexes. When creating Compound Indexes (indexes with multiple fields), the **Order Matters**.

**The Rule:** **E**quality ➡️ **S**ort ➡️ **R**ange

1.  **E (Equality):** Fields matched exactly (e.g., `status: "active"`).
2.  **S (Sort):** Fields used to sort results (e.g., `sort: { createdAt: -1 }`).
3.  **R (Range):** Fields with inequalities (e.g., `price: { $gt: 50 }`).

**Example of a bad index:**
*   **Query:** `db.orders.find({ status: "active" }).sort({ total: -1 })`
*   **Bad Index:** `{ total: 1, status: 1 }` (Sort came before Equality).
*   **Why it's bad:** MongoDB has to jump around the index to find "active" statuses.
*   **Good Index (ESR):** `{ status: 1, total: -1 }` (Equality, then Sort).

### Scenario C: Regex with Leading Wildcards
**Scenario:** You query `{ username: /.*john.*/ }` (Contains "john").
*   **The Problem:** Standard B-Tree indexes cannot define where "john" starts. This forces a full index scan or collection scan.
*   **The Fix:**
    1.  Remove the leading wildcard if possible (`/^john/` uses an index).
    2.  Use **Atlas Search** (Lucene) for full-text search requirements instead of standard regex.

---

## 4. 🛠 Improvement Workflow (Step-by-Step)

### Step 1: Use Atlas Performance Advisor
*   Go to **Atlas Console > Performance Advisor**.
*   Atlas automatically analyzes logs and suggests specific indexes (with the exact command to run) that would improve performance.
*   *Note: This usually covers "Missing Indexes" but catch subtle "Inefficient Indexes."*

### Step 2: Analyze with `explain()`
Run the slow query in Mongosh or Compass with `.explain("executionStats")`.

```javascript
db.collection.find({ ... }).explain("executionStats")
```

**Look for:**
*   `executionStages`: Should be `IXSCAN` (Index Scan), not `COLLSCAN`.
*   `totalKeysExamined`: Should be close to `nReturned`.
*   `memLimitExceeded`: If true, your sort is too heavy for memory and needs an index.

### Step 3: Rolling Index Builds
When applying the fix on a live production, **do not** just run `createIndex`.
*   In Atlas: Use the **Rolling Index Build** feature (default in newer versions) which builds the index in the background without locking the database.
*   *Warning:* Building large indexes consumes CPU and I/O. Do this during off-peak hours if the cluster is already struggling.

---

## 5. ⚠️ Pitfalls (Don'ts)

1.  **Don't Over-Index:** Every index you add makes **Writes/Updates slower** (because the DB has to update the data *and* the index list). Only add indexes that are actually used.
2.  **Don't Ignore RAM:** If your Indexes are larger than your available RAM, performance will tank (Disk thrashing). Check **Index Size** in the metrics.
3.  **Don't Index Low Cardinality Fields:** Indexing a boolean field (True/False) is usually useless because the DB still has to scan 50% of the collection. (Exception: if "True" is rare, e.g., only 1% of docs, then it is useful).
