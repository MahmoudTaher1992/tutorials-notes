Here is a detailed breakdown of **Part IV, Section E: Heaps & Priority Queues**.

This is one of the most practical and frequently asked topics in coding interviews because it offers a very specific efficiency for a very specific problem: **finding the "best" (highest or lowest) element instantly.**

---

# E. Heaps & Priority Queues

To understand this section, we must first distinguish between the **Abstract Data Type (Priority Queue)** and the **Data Structure (Heap)** used to implement it.

## 1. The Priority Queue (ADT)
A standard **Queue** operates on a "First-In, First-Out" (FIFO) basis. Think of a line at a grocery store. The first person to get in line is the first person served.

A **Priority Queue** changes the rules. Every element typically has a value and a "priority." Elements with a higher priority are served before elements with lower priority, regardless of when they arrived.
*   **Analogy:** The Triage system in a hospital ER. A patient with a heart attack (High Priority) is seen before a patient with a broken finger (Low Priority), even if the broken finger arrived two hours earlier.

**The Operations:**
*   `insert(item, priority)`: Add an item.
*   `extractMax()` or `extractMin()`: Remove and return the item with the highest (or lowest) priority.
*   `peek()`: See the highest priority item without removing it.

We *could* implement this using a sorted array or a linked list, but those are slow ($O(n)$) for either insertion or deletion. To get both operations down to $O(\log n)$ (Logarithmic time), we use a **Heap**.

---

## 2. The Heap Structure
A Heap is a concrete implementation of a Priority Queue. It is a specific type of binary tree that satisfies two main rules:

### A. The Structural Property (The Shape)
A Heap must be a **Complete Binary Tree**.
*   This means the tree is completely filled on all levels, except possibly the lowest level.
*   Nodes on the lowest level are filled from **left to right**.
*   **Why?** This shape guarantees the height of the tree is always $\log n$, and it allows us to store the tree in an **Array** without gaps (more on this below).

### B. The Heap Property (The Order)
This determines how nodes relate to their parents. There are two types:

1.  **Max-Heap:** The value of every Parent node is **greater than or equal to** the values of its Children.
    *   *Result:* The biggest number is always at the Root.
2.  **Min-Heap:** The value of every Parent node is **less than or equal to** the values of its Children.
    *   *Result:* The smallest number is always at the Root.

*> **Crucial Note:** Unlike a Binary Search Tree (BST), there is no relationship between the left and right children. The left child does not need to be smaller than the right child. Heaps are **weakly ordered** compared to BSTs.*

---

## 3. Implementation using an Array (The Implicit Tree)
While we visualize Heaps as trees with circles and arrows, we virtually never code them using `Node` classes and `next/prev` pointers. We use a simple, flat **Array** (or Vector/List).

Because the tree is "Complete" (filled left-to-right), we can use math to map tree positions to array indices.

If a node is at index `i` (0-based index):
*   **Parent is at:** `floor((i - 1) / 2)`
*   **Left Child is at:** `(2 * i) + 1`
*   **Right Child is at:** `(2 * i) + 2`

**Why is this amazing?**
1.  **Memory Efficient:** No overhead for storing pointer references.
2.  **Cache Locality:** Arrays are stored contiguously in memory, making Heaps extremely fast in practice due to CPU caching.

---

## 4. Core Operations

Let's look at how we maintain the Heap Property efficiently using a **Min-Heap** as an example.

### A. Insertion (`push`) - $O(\log n)$
1.  Add the new element to the very end of the array (the bottom-leftmost available spot in the tree).
2.  **Bubble Up (Percolate Up):** Compare the new node with its Parent.
3.  If the new node is smaller than the parent, **swap them**.
4.  Repeat until the node is larger than its parent or it reaches the root.

### B. Extract Min (`pop`) - $O(\log n)$
1.  The answer is at the Root (index 0). Save it to return later.
2.  Take the **last element** in the heap (end of the array) and move it to the **Root**. (We do this to maintain the "Complete Tree" structure).
3.  **Bubble Down (Heapify Down):** Compare the new Root with its children.
4.  Swap the node with the **smaller** of the two children.
5.  Repeat until the node is smaller than both children or it becomes a leaf.

### C. Heapify (Building a Heap) - $O(n)$
If you have an unsorted array and want to turn it into a heap:
*   **Naive approach:** Insert elements one by one ($O(n \log n)$).
*   **Optimized approach (`heapify`):** Start at the last non-leaf node and "Bubble Down" backwards up to the root. mathematically, this converges to **Linear Time $O(n)$**.

---

## 5. Applications

Why do we bother learning this?

### A. Heap Sort
An in-place sorting algorithm.
1.  Turn the unsorted array into a Max-Heap ($O(n)$).
2.  Continuously `extractMax` and place it at the end of the array.
3.  **Complexity:** $O(n \log n)$ time, $O(1)$ space. It’s consistent and doesn't require extra memory like Merge Sort.

### B. The "Top K" Problem (Pattern)
This is a classic interview pattern.
*   *Question:* "Find the Kth largest element in a massive stream of numbers."
*   *Solution:* Sorting the whole stream takes too long. Instead, maintain a **Min-Heap of size K**.
    *   If a new number is larger than the Min-Heap's root, pop the root and push the new number.
    *   At the end, the root of the heap is the $K^{th}$ largest number.

### C. Graph Algorithms
*   **Dijkstra’s Algorithm** (Shortest Path): Needs to constantly pick the "next closest node." A Priority Queue makes this efficient.
*   **Prim’s Algorithm** (Minimum Spanning Tree): Similar to Dijkstra’s, selects the lowest weight edge.

### D. System Scheduling
Your OS uses a Priority Queue to decide which process runs on the CPU next. Real-time processes get higher priority than background tasks.
