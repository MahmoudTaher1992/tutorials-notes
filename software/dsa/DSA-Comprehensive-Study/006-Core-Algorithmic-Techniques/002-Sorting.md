Here is a detailed explanation of **Part VI, Section B: Sorting**.

Sorting is one of the most fundamental areas in computer science. It is the process of arranging data in a specific order (usually ascending or descending).

Why is this important? Because **searching** is infinitely faster on sorted data (Binary Search vs. Linear Search), and many complex algorithms (like finding the closest pair of points or data compression) rely on sorted input.

We categorize sorting algorithms based on their **Time Complexity** (how their speed changes as the dataset grows) and their mechanism.

---

### 1. Simple Sorts (Quadratic Time: $O(n^2)$)
These algorithms are easy to understand and implement but are inefficient for large datasets. They typically require nested loops (comparing every element to every other element), resulting in $n \times n$ operations.

#### **A. Bubble Sort**
*   **The Logic:** Imagine air bubbles rising to the top of a drink. Bubble sort repeatedly steps through the list, compares adjacent elements, and swaps them if they are in the wrong order. This causes the largest values to "bubble" to the end of the array one by one.
*   **Best Use Case:** Teaching algorithm logic; detecting if a list is *already* sorted (can quit early).
*   **Drawback:** Extremely slow for unsorted data.

#### **B. Selection Sort**
*   **The Logic:** The algorithm divides the list into a "sorted" part and an "unsorted" part. It scans the unsorted part to find the absolute **minimum** element and swaps it with the first element of the unsorted part. It repeats this until the sorted part grows to fill the list.
*   **Best Use Case:** When memory writes is extremely expensive (as it makes the minimum number of swaps possible—at most $n$ swaps), but generally avoided.
*   **Drawback:** It is always $O(n^2)$ even if the list is already sorted.

#### **C. Insertion Sort**
*   **The Logic:** Think of sorting a hand of playing cards. You split the hand into a sorted group and an unsorted pile. You pick a card from the pile and **insert** it into the correct position within your sorted hand by shifting the other cards over.
*   **Best Use Case:**
    1.  **Small datasets:** It is actually faster than complex sorts (like Quick Sort) for very small arrays ($< 20$ items).
    2.  **Almost sorted data:** If the data is nearly sorted, it runs in almost $O(n)$ time.
    3.  **Online Algo:** It can sort data as it arrives in real-time.

---

### 2. Efficient Sorts (Log-Linear Time: $O(n \log n)$)
These are the industry standards for sorting large datasets. They use the **Divide and Conquer** strategy to break the problem down into smaller, manageable pieces usually achieving $O(n \log n)$ time.

#### **A. Merge Sort**
*   **The Logic:**
    1.  **Divide:** Cut the array exactly in half recursively until you have sub-arrays of size 1.
    2.  **Conquer:** Merge the sub-arrays back together. During the merge, you compare the items and place them in order into a new array.
*   **Key Behavior:**
    *   **Stable:** If you have two "5"s (5a and 5b), 5a stays before 5b. Important for sorting objects with multiple properties.
    *   **Not In-Place:** Requires "auxiliary space" (extra memory) of size $O(n)$ to hold the temporary arrays during merging.
*   **Usage:** Used in Java's `Arrays.sort()` for Objects and Python's `sort` (Timsort is a hybrid of Merge and Insertion sort).

#### **B. Quick Sort**
*   **The Logic:**
    1.  **Pivot:** Pick one element (the "pivot").
    2.  **Partition:** Reorder the array so all elements smaller than the pivot are on the left, and all elements larger are on the right.
    3.  **Recursion:** Apply the same logic to the left side and the right side (Recursively).
*   **Key Behavior:**
    *   **In-Place:** Uses very little extra memory.
    *   **Unstable:** Can change the relative order of identical items.
    *   **Worst Case:** If you pick a bad pivot (e.g., picking the smallest number in a list that is already sorted), it degrades to $O(n^2)$.
*   **Usage:** Generally the fastest sorting algorithm in the real world due to **Cache Locality** (hardware optimization). Used in C++ `std::sort`.

#### **C. Heap Sort**
*   **The Logic:**
    1.  Convert the array into a **Binary Max-Heap** (a tree structure where the parent is always larger than children).
    2.  The distinct largest element is now at the root. Swap it to the end of the array.
    3.  "Heal" the heap (Heapify) to find the new largest. Repeat.
*   **Key Behavior:**
    *   **In-Place:** Sorts without extra memory arrays.
    *   **Reliable:** Guaranteed $O(n \log n)$ (unlike Quick Sort which has a bad worst-case).
    *   **Slower in practice:** It jumps around memory indices, which makes it less cache-friendly than Quick Sort.

---

### 3. Non-Comparison Sorts (Linear Time: $O(n)$)
All the algorithms above rely on comparing two numbers ($A > B$). Mathematical proof shows you cannot beat $O(n \log n)$ using comparisons. However, if we know properties about the data (e.g., they are integers within a specific range), we can break the rules.

#### **A. Counting Sort**
*   **The Logic:** If you are sorting integers between 0 and 100, you don't need to help compare them.
    1.  Create an array of size 101.
    2.  Iterate through the input: if you see a "5", increment index 5.
    3.  Reconstruct the list by looking at the counts.
*   **Constraint:** Only works on integers with a known, limited range. If you try to sort [1, 10000000] with just two elements, you waste massive memory creating the count array.

#### **B. Radix Sort**
*   **The Logic:** Sorts numbers digit-by-digit (usually starting from the "ones" place, then "tens", then "hundreds"). It uses Counting Sort as a subroutine for each digit position.
*   **Constraint:** Works well for fixed-length integers or strings. It typically runs in $O(nk)$ where $k$ is the number of digits/characters (length of the largest number).

---

### Summary Comparison Table related to Interviewing

| Algorithm | Avg Time Complexity | Worst Case | Space | Stable? | When to mention in interview? |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Bubble** | $O(n^2)$ | $O(n^2)$ | $O(1)$ | Yes | Never, unless asked "What is a bad sort?" |
| **Insertion**| $O(n^2)$ | $O(n^2)$ | $O(1)$ | Yes | When the input is **"nearly sorted"** or very small. |
| **Merge** | $O(n \log n)$ | $O(n \log n)$| $O(n)$ | Yes | When **Stability** is required (sorting Objects) or handled strictly with Linked Lists. |
| **Quick** | $O(n \log n)$ | $O(n^2)$ | $O(\log n)$| No | The **default choice** for arrays. Mention picking a random pivot avoids worst-case. |
| **Heap** | $O(n \log n)$ | $O(n \log n)$| $O(1)$ | No | When memory is extremely tight (embedded systems) and you need guaranteed speed. |
| **Counting** | $O(n+k)$ | $O(n+k)$ | $O(k)$ | Yes | When sorting integers with a **small range** (e.g., ages, grades). |
