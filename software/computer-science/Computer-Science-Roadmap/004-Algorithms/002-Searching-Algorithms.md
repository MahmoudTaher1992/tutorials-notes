Based on the roadmap you provided, **Section IV-B: Searching Algorithms** is a fundamental pillar of Computer Science because almost every application involves retrieving data.

Here is a detailed explanation of the three categories listed in that section: **Linear Search**, **Binary Search**, and **Search in Trees (BFS/DFS)**.

---

### 1. Linear Search (Sequential Search)

This is the simplest and most intuitive searching logic. It is the "brute force" approach.

*   **How it works:** You start at the beginning of a list and check every single element, one by one, until you find the target or reach the end of the list.
*   **Data Requirement:** The data **does not** need to be sorted. It works on any list.
*   **Real-world Analogy:** You are looking for a specific paper in a disorganized pile. You pick up the first paper, look at it, put it down. You pick up the next, and so on.

**Pseudocode:**
```python
def linear_search(arr, target):
    for i from 0 to length of arr:
        if arr[i] == target:
            return i  # Found it!
    return -1  # Not found
```

**Complexity Analysis:**
*   **Time Complexity:** $O(n)$ (Linear Time).
    *   *Best Case:* The item is the very first one ($O(1)$).
    *   *Worst Case:* The item is the last one or not there at all ($O(n)$).
*   **Space Complexity:** $O(1)$ (No extra memory required).

---

### 2. Binary Search

This is a "Divide and Conquer" algorithm. It is vastly more efficient than Linear Search but comes with a strict requirement.

*   **Data Requirement:** The data **MUST be sorted** (e.g., in numerical or alphabetical order).
*   **How it works:**
    1.  Look at the element in the exact **middle** of the array.
    2.  If the middle element is your target, you are done.
    3.  If your target is **smaller** than the middle, you generally ignore the entire right half of the array. You only look at the left half.
    4.  If your target is **larger**, you ignore the left half and only look at the right.
    5.  Repeat this process until the item is found or the search space becomes empty.

*   **Real-world Analogy:** Looking for a word in a physical dictionary. You open it to the middle. If you are looking for "Apple" and you opened to "M", you know "Apple" is in the first half. You ignore the second half entirely.

**Pseudocode:**
```python
def binary_search(sorted_arr, target):
    low = 0
    high = length of sorted_arr - 1

    while low <= high:
        mid = (low + high) // 2
        if sorted_arr[mid] == target:
            return mid
        elif sorted_arr[mid] < target:
            low = mid + 1  # Target is in the right half
        else:
            high = mid - 1 # Target is in the left half
    return -1
```

**Complexity Analysis:**
*   **Time Complexity:** $O(\log n)$ (Logarithmic Time).
    *   *Why?* Every step cuts the problem size in half.
    *   *Scale:* If you have 1,000,000 items:
        *   Linear Search takes up to 1,000,000 steps.
        *   Binary Search takes roughly $\log_2(1,000,000) \approx 20$ steps.
*   **Space Complexity:** $O(1)$ (Iterative approach).

---

### 3. Search in Trees & Graphs (BFS and DFS)

When data isn't in a straight line (like an array) but strictly connected (like folders on your computer, or friends on a social network), we use Tree/Graph traversals.

#### A. Breadth-First Search (BFS)
*   **Strategy:** "Wide" before "Deep".
*   **How it works:** Start at a root node. Check all immediate neighbors (children). Then check all neighbors of those neighbors. It moves layer by layer.
*   **Data Structure Used:** **Queue** (First In, First Out).
*   **Analogy:** Dropping a stone in a pond. The ripples move outward in perfect circles, hitting everything at distance 1, then distance 2, etc.
*   **Primary Use Case:** Finding the **shortest path** in an unweighted graph (e.g., GPS finding the fewest stops, or "degrees of separation" on LinkedIn).

#### B. Depth-First Search (DFS)
*   **Strategy:** "Deep" before "Wide".
*   **How it works:** Start at a root node. Pick one path and follow it as far as possible until you hit a dead end (leaf node). Then **backtrack** and try the next path.
*   **Data Structure Used:** **Stack** (Last In, First Out) OR **Recursion**.
*   **Analogy:** Solving a maze. You keep walking until you hit a wall, then you turn around and try the last junction you passed.
*   **Primary Use Case:** Solving puzzles (mazes, Sudoku), detecting cycles in code dependencies, or mapping out an entire area.

**Complexity Analysis (for both BFS/DFS):**
*   **Time Complexity:** $O(V + E)$
    *   Where $V$ is the number of Vertices (nodes) and $E$ is the number of Edges (connections). You must visit every node and travel every wire.
*   **Space Complexity:** $O(V)$ (to store the queue or the recursion stack).

### Summary Comparison

| Algorithm | Best For... | Sorted Data Needed? | Time Complexity (Avg) |
| :--- | :--- | :--- | :--- |
| **Linear Search** | Small lists or unsorted data | No | $O(n)$ |
| **Binary Search** | Large, static datasets | **Yes** | $O(\log n)$ |
| **BFS** | Finding shortest paths in graphs | N/A (Graph structure) | $O(V+E)$ |
| **DFS** | Maze solving, path existence | N/A (Graph structure) | $O(V+E)$ |
