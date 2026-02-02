Based on the roadmap provided, here is a detailed explanation of **Part IV: Algorithms – Section C: Sorting Algorithms**.

Sorting is the process of arranging data in a specific order (usually ascending or descending). It is one of the most fundamental areas of Computer Science because efficient sorting is necessary for efficient searching (like Binary Search) and data analysis.

We categorize these algorithms into three main groups based on their efficiency (Time Complexity) and approach.

---

### 1. Basic / Elementary Sorts ($O(n^2)$)
These are easy to understand and implement but are generally inefficient for large datasets. They rely on comparing elements one by one.

#### **A. Bubble Sort**
*   **Concept:** Imagine air bubbles rising to the top of a liquid. The algorithm iterates through the list, comparing adjacent elements. If they are in the wrong order, it swaps them. This process repeats until no swaps are needed.
*   **Mechanism:** In each full pass, the largest unsorted element "bubbles up" to its correct position at the end.
*   **Complexity:** Time: $O(n^2)$ | Space: $O(1)$ (In-place).
*   **Best Use Case:** Teaching purposes or extremely small datasets. Practically never used in production due to slowness.

#### **B. Selection Sort**
*   **Concept:** The algorithm divides the list into a "sorted" part (left) and an "unsorted" part (right).
*   **Mechanism:** It scans the unsorted part to find the absolute **minimum** element and swaps it with the first element of the unsorted part. It essentially "selects" the smallest item and places it in order.
*   **Complexity:** Time: $O(n^2)$ (Always—even if the array is already sorted) | Space: $O(1)$.
*   **Best Use Case:** When memory writes is extremely expensive (as it makes the minimum number of swaps), but generally avoided.

#### **C. Insertion Sort**
*   **Concept:** Think of sorting a hand of playing cards. You pick one card and place it into the correct position relative to the sorted cards already in your hand.
*   **Mechanism:** It iterates from the second element to the last. For each element, it shifts previous elements forward until the correct spot is found for the current element.
*   **Complexity:** Time: $O(n^2)$ (Worst case), but **$O(n)$ (Best case)** if data is merely sorted.
*   **Best Use Case:** Very efficient for **small datasets** (often faster than Quick Sort for arrays < 20 items) or data that is **already mostly sorted**.

---

### 2. Efficient / Divide & Conquer Sorts ($O(n \log n)$)
These algorithms use recursion to break the problem down into smaller pieces, sort them, and combine them. These are the industry standards for general-purpose sorting.

#### **A. Merge Sort**
*   **Concept:** Uses the "Divide and Conquer" strategy. It splits the array in half recursively until every sub-array has only 1 element. Then, it **merges** those sorted sub-arrays back together.
*   **Mechanism:** The "Merge" step compares the leading elements of two sorted arrays and picks the smaller one to build the final array.
*   **Complexity:** Time: Guaranteed $O(n \log n)$ | Space: $O(n)$ (it requires extra memory to hold the temp arrays).
*   **Key Feature:** It is **Stable** (preserves the order of equal elements).
*   **Best Use Case:** Sorting Linked Lists; applications where stability is required; external sorting (when data is too big for RAM).

#### **B. Quick Sort**
*   **Concept:** Also Divide and Conquer, but sorts "in-place." It picks a **Pivot** element and partitions the array.
*   **Mechanism:** All elements smaller than the pivot are moved to the left; all elements larger are moved to the right. The pivot is then locked in its final position. The process repeats recursively for the left and right sides.
*   **Complexity:**
    *   Average Time: $O(n \log n)$.
    *   Worst Case: $O(n^2)$ (if the pivot breaks the array unevenly, e.g., picking the smallest element in a sorted list).
    *   Space: $O(\log n)$ (stack space for recursion).
*   **Best Use Case:** The standard sorting algorithm in most standard libraries (like C++ `std::sort`). It is usually faster than Merge Sort in practice due to better cache locality.

#### **C. Heap Sort**
*   **Concept:** Uses a **Binary Heap** data structure (specifically a Max-Heap).
*   **Mechanism:**
    1.  Transform the array into a Max-Heap (parent node is always larger than children).
    2.  Swap the root (largest element) with the last element of the array.
    3.  Reduce the heap size by 1 and "heapify" (fix the heap property) the root.
    4.  Repeat.
*   **Complexity:** Time: Guaranteed $O(n \log n)$ | Space: $O(1)$ (In-place).
*   **Best Use Case:** Systems with tight memory constraints where $O(n)$ space for Merge Sort is not allowed, and the $O(n^2)$ risk of Quick Sort is unacceptable (e.g., embedded systems).

---

### 3. Non-Comparison / Linear Sorts ($O(n)$ or $O(nk)$)
These algorithms do **not** compare elements ($A > B$). Instead, they rely on the mathematical properties of the data (usually integers) to sort them.

#### **A. Counting Sort**
*   **Concept:** Relies on knowing the range of the input data (e.g., integers between 0 and 100).
*   **Mechanism:** It creates a "count array" to store the frequency of each distinct number. It then uses arithmetic to place elements directly into their target position.
*   **Complexity:** Time: $O(n + k)$ where $k$ is the range of data.
*   **Best Use Case:** Sorting integers where the range ($k$) is not significantly larger than the number of elements ($n$).

#### **B. Radix Sort**
*   **Concept:** Processes integer keys by individual digits.
*   **Mechanism:** It uses a stable sub-routine (like Counting Sort) to sort the numbers starting from the Least Significant Digit (LSD) to the Most Significant Digit (MSD).
    *   *Example:* Sort by the ones place, then tens place, then hundreds place.
*   **Complexity:** Time: $O(nk)$ where $k$ is the number of digits.
*   **Best Use Case:** Sorting numbers or fixed-length strings (like ID numbers).

#### **C. Bucket Sort**
*   **Concept:** Distributes elements into a number of "buckets."
*   **Mechanism:**
    1.  Create $n$ empty buckets.
    2.  Scatter the inputs into buckets based on their value (e.g., values 0.0-0.1 go to bucket 1).
    3.  Sort each individual bucket (usually using Insertion Sort).
    4.  Gather the buckets back together.
*   **Best Use Case:** Floating point numbers that are uniformly distributed over a range (e.g., 0.0 to 1.0).

---

### Summary Comparison Table

| Algorithm | Avg Time | Worst Time | Space | Stable? | Method |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Bubble** | $O(n^2)$ | $O(n^2)$ | $O(1)$ | Yes | Exchanging |
| **Selection** | $O(n^2)$ | $O(n^2)$ | $O(1)$ | No | Selection |
| **Insertion** | $O(n^2)$ | $O(n^2)$ | $O(1)$ | Yes | Insertion |
| **Merge** | $O(n \log n)$ | $O(n \log n)$ | $O(n)$ | Yes | Merging |
| **Quick** | $O(n \log n)$ | $O(n^2)$ | $O(\log n)$ | No | Partitioning |
| **Heap** | $O(n \log n)$ | $O(n \log n)$ | $O(1)$ | No | Selection |
| **Counting** | $O(n+k)$ | $O(n+k)$ | $O(k)$ | Yes | Hashing |

*(**Stability:** If two objects have the same key, a Stable sort preserves their original order. This is vital when sorting by multiple criteria, e.g., sorting a file list by Date, then by Name.)*
