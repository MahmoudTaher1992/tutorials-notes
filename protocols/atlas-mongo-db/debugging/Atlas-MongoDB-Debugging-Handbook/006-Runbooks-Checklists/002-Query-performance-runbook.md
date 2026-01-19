Based on the comprehensive Table of Contents you provided, the file **`006-Runbooks-Checklists/002-Query-performance-runbook.md`** is arguably the most critical operational document used by developers and DBAs.

This runbook acts as the **"Step-by-Step Guide"** for when you have identified that **slow queries** are the root cause of your performance issues (usually identified during Section 2 "Fast Triage").

Here is a detailed explanation of what this runbook contains and how to execute it.

---

# 🐢 Explanation of: Query Performance Runbook
**File path:** `006-Runbooks-Checklists/002-Query-performance-runbook.md`

### 🎯 Objective
To identify inefficient queries that are consuming high CPU or Disk I/O, analyze their execution plan (why they are slow), and apply specific fixes (indexing or code changes) to optimize them.

---

## Phase 1: Identification (Where is the bad query?)

This section of the runbook guides you on how to find the "offender" using Atlas tools.

1.  **Atlas Performance Advisor:**
    *   *Action:* Check this first. It suggests indexes based on slow query logs.
    *   *Goal:* See if Atlas already knows the answer. If it suggests an index, evaluate it and apply it.
2.  **Profiler / Query Profiler:**
    *   *Action:* Sort queries by **Execution Time (descending)** or **Total Keys Examined**.
    *   *Goal:* Identify the specific "Query Shape" (fingerprint) that is taking the longest.
3.  **Real-Time Performance Panel (RTPP):**
    *   *Action:* Look for the "Slowest Operations" list on the right side.
    *   *Goal:* Grab the live culprit during an active incident.

---

## Phase 2: Analysis (The "ESR" & Metrics Check)

Once you have the query text, the runbook explains how to diagnose *why* it is bad using three key metrics.

### 1. The "Examined vs. Returned" Ratio
This is the single most important metric in MongoDB query tuning.
*   **nReturned:** How many documents the user asked for (e.g., 10).
*   **totalKeysExamined / totalDocsExamined:** How many index entries or documents the database had to read to find those 10.
*   ** The Rule:** The ratio should be as close to **1:1** as possible.
    *   ✅ **Good:** Scanned 15 docs to return 10.
    *   ❌ **Bad:** Scanned 100,000 docs to return 10.

### 2. The Execution Stages (The "Explain Plan")
The runbook will dictate running `db.collection.find({...}).explain("executionStats")`. You are looking for these keywords:
*   **`COLLSCAN` (Collection Scan):** 🚨 **CRITICAL FAIL.** This means MongoDB had to read the *entire* hard drive (every document) to find your data because no index existed.
*   **`IXSCAN` (Index Scan):** ✅ **GOOD.** An index was used.
*   **`SORT_KEY_GENERATOR`:** ⚠️ **WARNING.** The sort happened in memory (expensive) rather than using an index.

### 3. The ESR Rule (Equality, Sort, Range)
The runbook checks if your index follows the **ESR Framework**:
1.  **E (Equality):** Fields matched exactly (`status: "active"`) must go first in the index.
2.  **S (Sort):** Fields used for sorting (`createdAt: -1`) must go second.
3.  **R (Range):** Fields with range operators (`price: { $gt: 50 }`) must go last.

---

## Phase 3: Diagnosis (Common Patterns)

This part of the runbook lists common "Anti-Patterns" to check against.

| Issue | Symptom | Runbook Fix |
| :--- | :--- | :--- |
| **Missing Index** | Query is a `COLLSCAN`. High CPU + Disk Read. | Create an index covering the query fields. |
| **Inefficient Index** | Query uses an index (`IXSCAN`) but still scans 10k docs to return 1. | Reorganize index fields to match the **ESR** rule. |
| **In-Memory Sort** | Error: "Sort operation used more than 32MB of RAM". | Create an index that includes the sort field. |
| **Unbounded Array** | Query performance degrades as an array inside a document grows. | redesign schema or use `$slice` projection. |
| **Regex Pre-fix** | `name: /.*smith/` (starts with wildcard). | Remove leading wildcard or use Atlas Search (Lucene). |

---

## Phase 4: Remediation (The Fix)

The runbook concludes with safe steps to apply the fix without crashing production.

1.  **Rolling Index Strategy:**
    *   *The Rule:* Never build an index in the foreground on a massive collection during peak hours.
    *   *Atlas:* Use the Atlas UI "Rolling Index Build" feature (which does it one replica node at a time).
2.  **Code Optimization:**
    *   If an index isn't possible, change the code to select fewer fields (`projection`), use `limit()`, or remove the `sort()` if the app handles it.
3.  **Validation:**
    *   Run `explain("executionStats")` again after the fix.
    *   Confirm the **Examined vs. Returned** ratio has dropped to near 1:1.

---

### Summary "Cheat Sheet" for this file:
If you are reading `002-Query-performance-runbook.md`, you are likely asking:
> *"Why is this query taking 5 seconds?"*

**The answer is usually:**
1.  You are engaging in a **COLLSCAN** (missing index).
2.  You are sorting in memory because your index doesn't account for the sort order.
3.  You have a Regex query that cannot use an index.
