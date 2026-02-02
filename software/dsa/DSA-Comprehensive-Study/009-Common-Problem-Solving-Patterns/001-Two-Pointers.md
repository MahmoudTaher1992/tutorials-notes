Here is a detailed explanation of **Part IX: Common Problem-Solving Patterns — A. Two Pointers**.

---

# 009-Common-Problem-Solving-Patterns / 001-Two-Pointers

## 1. What is the "Two Pointers" Pattern?

The **Two Pointers** pattern describes a technique where you create two pointers (variables usually typically named `i`, `j`, `left`, `right`, `start`, or `end`) that traverse a linear data structure (like an Array, String, or Linked List) in a specific direction or manner.

Most often, this pattern is used to **search for pairs** in a sorted array or to **modify the structure in-place**.

### The Core Problem It Solves
The naive (brute-force) approach to finding pairs usually involves nested loops:
1.  A "slow" pointer (the outer loop `i`) usually starting at index 0.
2.  A "fast" pointer (the inner loop `j`) scanning the rest of the array.

**The Brute Force Problem:**
```python
# Typically O(n^2) complexity - Too Slow!
for i in range(len(arr)):
    for j in range(len(arr)):
        # do something
```
The **Two Pointers** technique optimizes this to **O(n)** time complexity by using logic to move pointers intelligently rather than trying every combination.

---

## 2. Common Variations

There are generally three ways to implement Two Pointers:

### Variant A: Pointers moving toward each other ("Collision Course")
*   **Setup:** One pointer at the start (`left = 0`), one at the end (`right = n-1`).
*   **Condition:** While `left < right`.
*   **Use Case:** Palindromes, Two Sum (in a sorted array), Reversing an array, Container With Most Water.

### Variant B: Pointers moving in the same direction
*   **Setup:** Start both pointers at the beginning (`start = 0`, `end = 0`).
*   **Condition:** usually based on `end` reaching the length of the array.
*   **Use Case:** Removing duplicates in-place, Sliding Windows (a sub-variant), Merging two arrays.

### Variant C: One pointer in each of two different arrays
*   **Setup:** `p1` in Array A, `p2` in Array B.
*   **Condition:** While `p1 < len(A)` and `p2 < len(B)`.
*   **Use Case:** Merging sorted arrays, finding common elements (Intersections).

---

## 3. Deep Dive: "Two Sum" (Sorted Input)

This is the classic interview question to demonstrate the "Collision Course" variant.

**Problem:** Given a **sorted** array of integers, find two numbers such that they add up to a specific target number.

*   **Input:** `[1, 2, 3, 4, 6]`, Target: `6`
*   **Brute Force:** Try 1+2, 1+3, 1+4... then 2+3, 2+4... (Requires $O(n^2)$).

**The Two Pointers Approach ($O(n)$):**

Because the array is **sorted**, we know a crucial fact: moving to the right increases the value, and moving to the left decreases the value.

**The Algorithm:**
1.  Initialize `left` at index 0, `right` at index `length - 1`.
2.  Calculate `current_sum = arr[left] + arr[right]`.
3.  If `current_sum` equals `target`: **Success!**
4.  If `current_sum` is **greater than** `target`: We need a smaller sum. The only way to get a smaller sum is to move the `right` pointer to the left (decrement).
5.  If `current_sum` is **less than** `target`: We need a larger sum. Move the `left` pointer to the right (increment).

**Code Example:**
```python
def two_sum_sorted(arr, target):
    left = 0
    right = len(arr) - 1

    while left < right:
        current_sum = arr[left] + arr[right]

        if current_sum == target:
            return [left, right] # Found the indices
        
        elif current_sum > target:
            right -= 1 # Sum is too big, decrease right value
            
        else: # current_sum < target
            left += 1 # Sum is too small, increase left value

    return None # No pair found
```

---

## 4. Deep Dive: "Remove Duplicates" (In-Place)

This typically uses the "Same Direction" variant.

**Problem:** Given a sorted array, remove the duplicates **in-place** such that each element appears only once and return the new length. You cannot allocate a new array (space must be $O(1)$).

*   **Input:** `[0, 0, 1, 1, 1, 2, 2, 3, 3, 4]`
*   **Goal:** Modify array to `[0, 1, 2, 3, 4, ...]` and return length `5`.

**The Logic:**
We need one pointer (`i`) to keep track of where the next **unique** element should go (the "write" pointer), and another pointer (`j`) to scan through the array (the "read" pointer).

**The Algorithm:**
1.  Start `i` (slow runner) at index 0.
2.  Start `j` (fast runner) at index 1.
3.  Iterate `j` through the array.
4.  Compare `arr[j]` with `arr[i]`.
5.  If they are different:
    *   We found a new unique number!
    *   Move `i` forward (`i++`).
    *   Copy the value at `j` to the location `i` (`arr[i] = arr[j]`).

**Code Example:**
```python
def remove_duplicates(nums):
    if not nums:
        return 0

    write_ptr = 0 

    for read_ptr in range(1, len(nums)):
        # If the current number is different from the last unique number
        if nums[read_ptr] != nums[write_ptr]:
            write_ptr += 1
            nums[write_ptr] = nums[read_ptr]
            
    return write_ptr + 1 # +1 because pointer is 0-indexed, length is 1-indexed
```

---

## 5. When should I use Two Pointers? (The Cheat Sheet)

If you see a coding problem with these characteristics, "Two Pointers" should be your first thought:

1.  **Linear Structure:** The problem involves arrays, strings, or linked lists.
2.  **Sorted Input:** This is the biggest hint. If the array is sorted, Two Pointers is almost certainly the optimal solution (vs. Hash Maps or Binary Search).
3.  **Pairs or Triplets:** Usually asking typically to find a pair of elements that satisfy a condition (sum, difference, match).
4.  **In-Place Operations:** You are asked to reverse, swap, or move elements without using extra memory (`O(1)` space).
5.  **Palindromes:** Any logic requiring comparison of the start and end of a string.

## 6. Common Pitfalls

1.  **Infinite Loops:** When using a `while left < right` loop, ensure that inside the loop, the logic *always* either increments `left` or decrements `right`. If the logic gets stuck, your program freezes.
2.  **Off-by-One Errors:** Be careful with the initialization. In the "Two Sum" example, `right` is `len(arr) - 1`. If you use `len(arr)`, you will get an Index Out of Bounds error.
3.  **Condition Checking:** Pay attention to whether the loop should strictly be `left < right` or `left <= right`.
    *   If `left == right`, do you need to process the middle element? (e.g., in a Palindrome check, the middle element doesn't matter, but in a Binary Search, it does).
