Here is a detailed explanation of **Part IV: Algorithms – E. Dynamic Programming**.

---

### What is Dynamic Programming (DP)?

At its core, Dynamic Programming is an optimization technique used to solve complex problems by breaking them down into simpler **overlapping subproblems**.

Unlike Divide and Conquer (like Merge Sort), where subproblems are independent, DP is used when the subproblems overlap—meaning the algorithm solves the same small problem over and over again. DP solves each subproblem once and **stores the result** to avoid redundant work.

**Key Requirements for DP:**
1.  **Optimal Substructure:** The solution to the main problem can be constructed from solutions to its subproblems.
2.  **Overlapping Subproblems:** The same subproblems are calculated repeatedly.

---

### 1. The Two Main Approaches: Memoization & Tabulation

There are two ways to implement Dynamic Programming. Generally, they solve the same problem with the same time complexity, but the way they use memory and the order of execution differs.

#### A. Memoization (Top-Down Approach)
Think of this as **Recursion + Caching**.
*   **How it works:** You start with the main problem and break it down recursively. Before computing a result, you check a "memo" (a lookup table, hash map, or array) to see if you have already solved this specific subproblem.
*   **Process:**
    1.  Call function with input $N$.
    2.  Check cache. If result exists, return it.
    3.  If not, compute result using recursion.
    4.  Save result in cache.
    5.  Return result.
*   **Pros:** Easy to write if you already know the recursive logic; solves only the necessary subproblems.
*   **Cons:** Recursion depth limits (Stack Overflow) on very large inputs.

#### B. Tabulation (Bottom-Up Approach)
Think of this as **Filling a Table iteratively**.
*   **How it works:** You start with the smallest possible subproblem (the base case) and systematically build up the solution to larger problems until you reach the goal.
*   **Process:**
    1.  Create a table (array) of size $N$.
    2.  Fill in the base cases (e.g., index 0 and 1).
    3.  Use a loop (iteration) to fill index 2, then 3, all the way to $N$.
    4.  The answer is usually found in the last cell of the table.
*   **Pros:** No recursion overhead; often faster in practice; easy to optimize space.
*   **Cons:** Solves *all* subproblems, even if some aren't needed for the final answer.

---

### 2. Classic Problems

These are the "standard" problems used to teach DP because they illustrate different patterns (Linear DP, 2D DP, Pick/Leave patterns).

#### A. Fibonacci Sequence (The "Hello World" of DP)
*   **The Problem:** Find the $n$-th Fibonacci number, where $F(n) = F(n-1) + F(n-2)$.
*   **The Issue:** A standard recursive solution computes $F(n-2)$ twice (once for $F(n)$ and once for $F(n-1)$). This leads to exponential time complexity ($O(2^n)$).
*   **The DP Solution:**
    *   **Tabulation:** Create an array `dp`. Set `dp[0]=0`, `dp[1]=1`. Loop from 2 to $n$: `dp[i] = dp[i-1] + dp[i-2]`.
    *   **Time Complexity:** $O(n)$ (Linear).

#### B. 0/1 Knapsack (The "Pick or Leave" Pattern)
*   **The Problem:** You have a knapsack with a weight capacity $W$. You have a list of items, each with a specific **Wait** and **Value**. You must maximize the total value without exceeding weight $W$. You cannot break items (hence "0/1" - you take the whole item or none).
*   **The Logic:** For every item, you have two choices:
    1.  **Include it:** Add its value to the total, subtract its weight from capacity, and solve for remaining items.
    2.  **Exclude it:** Don't take it, keep capacity the same, and solve for remaining items.
*   **DP State:** `dp[i][w]` = Max value considering first $i$ items with capacity $w$.
*   **Recurrence:**
    $$dp[i][w] = \max(\text{value}[i] + dp[i-1][w-\text{weight}[i]], \quad dp[i-1][w])$$

#### C. Longest Increasing Subsequence (LIS)
*   **The Problem:** Given an array of integers (e.g., `[10, 9, 2, 5, 3, 7, 101, 18]`), find the length of the longest subsequence where elements are in strictly increasing order.
    *   *Result:* `[2, 3, 7, 101]` (Length 4).
*   **The Logic:** A classic Single-Array DP.
*   **DP State:** `dp[i]` represents the length of the longest increasing subsequence that **ends** at index $i$.
*   **Algorithm:** For every element $i$, look back at all previous elements $j$ (where $j < i$). If `arr[i] > arr[j]`, then we can extend the sequence ending at $j$.
*   **Recurrence:** `dp[i] = max(dp[j]) + 1` for all valid $j$.

#### D. Longest Common Subsequence (LCS) (The "Grid/String" Pattern)
*   **The Problem:** Given two strings, find the length of the longest subsequence present in both. (e.g., "ABCDE" and "ACE" $\rightarrow$ "ACE", length 3).
*   **The Logic:** This requires a 2D Matrix.
*   **DP State:** `dp[i][j]` = length of LCS between string A (up to index $i$) and string B (up to index $j$).
*   **Recurrence:**
    1.  If characters match (`A[i] == B[j]`): `dp[i][j] = 1 + dp[i-1][j-1]` (Diagonal + 1).
    2.  If they don't match: `dp[i][j] = max(dp[i-1][j], dp[i][j-1])` (Take the best result from either removing a char from A or removing a char from B).

---

### Summary Table

| Concept | Explanation | Real-world Analogy |
| :--- | :--- | :--- |
| **Memoization** | Top-down recursion + Caching | Writing answers on a cheat sheet so you don't re-calculate them. |
| **Tabulation** | Bottom-up iteration (loops) | Filling a spreadsheet row by row. |
| **Fibonacci** | Sum of previous two | Population growth modeling. |
| **Knapsack** | Max value with weight limit | Resource allocation, Budgeting. |
| **LCS** | Longest shared sequence | Diff tools (Git), DNA sequence alignment. |
| **LIS** | Longest increasing sequence | Stock market analysis (longest growth streak). |
