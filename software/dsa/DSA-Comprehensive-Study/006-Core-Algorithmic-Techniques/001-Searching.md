Here is a detailed explanation of **Part VI, Section A: Searching**, from your Table of Contents.

Searching is one of the most fundamental actions in computer science. At its core, it asks the question: *"Does this collection of data contain a specific value, and if so, where is it?"*

Here is the breakdown of the two primary searching algorithms you need to master.

---

# 1. Linear Search (Sequential Search)

Linear search is the "brute force" method of searching. It is the most natural way a human searches for something in an unorganized pile.

### The Concept
Imagine a shelf of books that are completely jumbled (not alphabetized). To find a specific book, you have to start at the left end and look at every single spine, one by one, until you find the book or reach the end of the shelf.

### The Algorithm
1.  Start at the first element (index 0).
2.  Compare the current element with the **Target** value.
3.  If they match, return the current index (Success).
4.  If they don't match, move to the next element.
5.  If you reach the end of the list without finding the target, return a distinct value (usually `-1` or `null`) to indicate "Not Found."

### Code Example (Python)
```python
def linear_search(arr, target):
    for i in range(len(arr)):
        if arr[i] == target:
            return i  # Found, return index
    return -1  # Not found
```

### Analysis
*   **Pre-requisites:** None. The data can be sorted or unsorted.
*   **Time Complexity:**
    *   **Best Case:** $O(1)$ — The target is the very first item.
    *   **Worst Case:** $O(n)$ — The target is the very last item, or not in the list at all.
    *   **Average Case:** $O(n)$.
*   **Space Complexity:** $O(1)$ — It requires no extra memory; it just iterates.

### When to use it?
*   When the list is small.
*   When the list is **unsorted**.
*   When you only need to search once (sorting the list to use a faster search algorithm takes time, so for a single search, Linear is often faster overall).

---

# 2. Binary Search

Binary Search is the efficient, "Divide and Conquer" method. This is where algorithmic power really shines, dropping the complexity from Linear ($n$) to Logarithmic ($\log n$).

### The Concept
Imagine a fast-food menu or a dictionary where items are perfectly sorted alphabetically. You are looking for the word "Monolith".
1.  You open the book exactly to the middle. You see "M", but the word is "Monkey".
2.  "Monolith" comes *after* "Monkey".
3.  Because the book is **Sorted**, you can immediately rip out the entire first half of the book and throw it away. You know the word cannot be there.
4.  You repeat this process with the remaining pages, constantly cutting the search space in half.

### The Algorithm
**Crucial Requirement: The data MUST be sorted.**

1.  Define two pointers: `low` (start of array) and `high` (end of array).
2.  Loop while `low <= high`:
    *   Calculate the `mid` index: `mid = (low + high) // 2`.
    *   **Check:** Is `arr[mid] == target`?
        *   Yes: Return `mid`.
    *   **Decide:** Is `arr[mid] < target`?
        *   Yes: The target must be in the right half. Move `low` to `mid + 1`.
        *   No: The target must be in the left half. Move `high` to `mid - 1`.
3.  If `low` crosses `high` and the loop breaks, the target is not in the list.

### Code Example (Python - Iterative)
```python
def binary_search(arr, target):
    low = 0
    high = len(arr) - 1

    while low <= high:
        # Calculate middle index
        # (low + high) // 2 works, but the line below prevents integer overflow in typical strongly typed languages
        mid = low + (high - low) // 2

        if arr[mid] == target:
            return mid # Target found
        elif arr[mid] < target:
            low = mid + 1 # Target is in the right half
        else:
            high = mid - 1 # Target is in the left half

    return -1 # Target not found
```

### Analysis
*   **Time Complexity:** $O(\log n)$.
    *   *Why?* If you have 100 items, step 1 leaves 50. Step 2 leaves 25. Step 3 leaves 12... it shrinks incredibly fast.
    *   Searching 1,000,000 items takes at most ~20 steps ($2^{20} \approx 1,000,000$).
*   **Space Complexity:**
    *   **Iterative:** $O(1)$ (Best practice).
    *   **Recursive:** $O(\log n)$ (Due to stack memory).

### Common Pitfalls (Interview Warning)
1.  **Integer Overflow:** In languages like C++ or Java, `(low + high) / 2` can crash if the array is massive, because `low + high` might exceed the maximum integer size. The fix is to calculate mid as `low + (high - low) / 2`.
2.  **Infinite Loops:** Being careless with `+1` and `-1` (e.g., setting `low = mid` instead of `mid + 1`) can cause the loop to get stuck when only 1 or 2 elements remain.

---

# Summary Comparison

| Feature | Linear Search | Binary Search |
| :--- | :--- | :--- |
| **Data Requirement** | None (can be unsorted) | **Must be Sorted** |
| **Approach** | Sequential (One by one) | Divide and Conquer |
| **Time Complexity** | $O(n)$ | $O(\log n)$ |
| **Speed** | Slow for large data | Extremely Fast |
| **Implementation** | Very Simple | Simple logic, but tricky edge cases |

### Which one matches "Real Life"?
*   **Linear Search:** Finding your car keys in a messy room.
*   **Binary Search:** Finding a phone number in a phone book (people used to do this!).
