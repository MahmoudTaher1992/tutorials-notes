Here is a detailed breakdown of **Item 002: Sliding Window** from the "Common Problem-Solving Patterns" section.

---

# Pattern: The Sliding Window

## 1. The Concept (The "What" and "Why")
The Sliding Window is an optimization technique used primarily on **Arrays** and **Strings**.

Imagine you have a long strip of paper with numbers on it, and you cut a square hole in a piece of cardboard (the "window"). You place the cardboard over the strip so you can only see a few numbers at a time. As you slide the cardboard one position to the right, one number disappears from the left, and a new number appears on the right.

### The Problem it Solves
In a "Brute Force" approach, if asked to calculate something regarding a subarray (e.g., "Find the maximum sum of 3 consecutive elements"), you would usually use nested loops.
*   **The Outer Loop:** Selects the starting point.
*   **The Inner Loop:** Iterates through the next $k$ elements to calculate the sum.

**This results in $O(N \times K)$ or roughly $O(N^2)$ time complexity.** This is slow for large inputs.

### The Sliding Window Solution
The Sliding Window pattern reduces this to **$O(N)$** linear time. Instead of recalculating the entire valid scope from scratch, you reuse the result from the previous step.

You treat the data as a window that grows, shrinks, or slides.
1.  **Remove** the influence of the element leaving the window.
2.  **Add** the influence of the element entering the window.

---

## 2. Types of Sliding Windows

There are two main variations of this pattern:

### A. Fixed Window Size
The length of the window ($k$) is fixed. You slide the window one step at a time.
*   **Use case:** "Find the maximum sum of a subarray of size $k$."
*   **Logic:**
    1. Calculate the sum of the first $k$ elements.
    2. Slide one step right: Subtract the element going out ($i-k$), add the element coming in ($i$).

### B. Dynamic (Variable) Window Size
 The window grows or shrinks depending on certain conditions.
*   **Use case:** "Find the *smallest* subarray with a sum greater than $s$."
*   **Logic:**
    1. Grow the window (expand right) until the condition is met.
    2. Shrink the window (contract left) while the condition remains true to try and find the minimum size.

---

## 3. Visual Example (Fixed Size)

**Problem:** Given array `[1, 3, 2, 6, -1, 4]` and `k=3`, find the maximum sum of contiguous subarray of size 3.

**Brute Force Way:**
1. `[1, 3, 2]` -> Sum = 6
2. `[3, 2, 6]` -> Sum = 11 (Recalculated 3+2+6)
3. `[2, 6, -1]` -> Sum = 7 (Recalculated 2+6-1)
... and so on.

**Sliding Window Way:**
1. First Window: `[1, 3, 2]`
   *   `Current Sum` = 6
   *   `Max Due` = 6

2. **Slide Right**:
   *   Remove `1` (leftmost)
   *   Add `6` (new right)
   *   `Current Sum` = 6 - 1 + 6 = 11
   *   `Max Due` = 11

3. **Slide Right**:
   *   Remove `3`
   *   Add `-1`
   *   `Current Sum` = 11 - 3 + (-1) = 7

*Notice we never used an inner loop to add numbers up again. We just adjusted the total.*

---

## 4. Code Examples

### A. Fixed Window Algorithm (Python)
*Problem: Find maximum sum of a subarray of size K.*

```python
def max_sub_array_of_size_k(k, arr):
    max_sum = 0
    window_sum = 0
    window_start = 0

    for window_end in range(len(arr)):
        # Add the next element
        window_sum += arr[window_end] 

        # Slide the window only if we've hit size k
        # (index is zero based, so we check if index >= k - 1)
        if window_end >= k - 1:
            max_sum = max(max_sum, window_sum)
            
            # Subtract the element going out
            window_sum -= arr[window_start] 
            # Slide the start ahead
            window_start += 1 
            
    return max_sum
```

### B. Dynamic Window Algorithm (Python)
*Problem: Find the smallest length of a contiguous subarray with a sum greater than or equal to `S`.*

```python
def min_sub_array_len(s, arr):
    window_sum = 0
    min_length = float('inf')
    window_start = 0

    for window_end in range(len(arr)):
        # 1. Expand the window
        window_sum += arr[window_end]
        
        # 2. Shrink the window as small as possible 
        # while the condition is still true
        while window_sum >= s:
            min_length = min(min_length, window_end - window_start + 1)
            window_sum -= arr[window_start]
            window_start += 1

    if min_length == float('inf'):
        return 0
    return min_length
```

---

## 5. How to Identify Sliding Window Problems

If you see a problem statement containing **these three factors**, it is likely a Sliding Window problem:

1.  **Data Structure:** Array, String, or Linked List.
2.  **Constraint:** You are looking for a **contiguous** block (substring, subarray). *Note: If it asks for a "subsequence" (which doesn't need to be contiguous), this pattern usually doesn't apply.*
3.  **Goal:** You need to calculate something like:
    *   Longest substring with distinct characters.
    *   Maximum sum subarray of size K.
    *   Smallest subarray with sum greater than X.
    *   String anagrams.

## 6. Summary for Interviews

*   **Complexity:** Time: $O(N)$, Space: $O(1)$.
*   **Key Insight:** Avoid re-computation. Don't sum 10 numbers, then shift one spot and sum 10 numbers again. Just subtract the old and add the new.
*   **Pointers:** Usually involves a `window_start` and a `window_end`.
*   **Edge Cases:**
    *   Window size larger than array size.
    *   Empty array.
    *   Dynamic window never satisfying the condition.
