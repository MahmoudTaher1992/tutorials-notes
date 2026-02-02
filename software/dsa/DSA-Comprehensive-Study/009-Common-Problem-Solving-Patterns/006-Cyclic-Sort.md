**Cyclic Sort** is an algorithmic pattern that is incredibly efficient for solving problems involving arrays containing numbers in a given range.

While sorting algorithms like Merge Sort or Quick Sort are general-purpose ($O(n \log n)$), Cyclic Sort is a specialized **$O(n)$** approach that works only when specific conditions are met.

Here is a detailed breakdown of how it works, why it works, and how to implement it.

---

### 1. The Core Concept (The "When")

You should suspect a Cyclic Sort approach if the problem statement includes constraints like:
*   "You are given an array of size `n` containing numbers from `1` to `n`."
*   "You are given an array containing numbers from `0` to `n`."
*   "Find the missing number" or "Find the duplicate number" in a sequential range.

**Key Insight:**
Since the numbers are in a specific, unbroken range (e.g., 1 to 5), **the value of the number tells us exactly which index it should be at.**

*   If the range is `0` to `n-1`: The number `0` belongs at index `0`, `1` belongs at index `1`, etc.
*   If the range is `1` to `n`: The number `1` belongs at index `0`, `2` belongs at index `1`, etc. (Value `x` belongs at index `x-1`).

### 2. The Algorithm (The "How")

The algorithm iterates through the array. For every number it encounters, it asks: **"Is this number sitting in its correct index?"**

1.  **If yes:** Move to the next index ($i++$).
2.  **If no:** Swap the number with the number currently sitting in its "correct" position.
    *   *Crucial Note:* After swapping, **do not** increment the index ($i$). We must check the *new* number that was just swapped into our current position to see if *that* one is in the right place.

We repeat this until all numbers are in their correct spots.

### 3. Step-by-Step Visualization

Let's sort the array `[3, 5, 2, 1, 4]` (Values 1 to 5).
*   Correct Index = `Value - 1`.

**Start ($i = 0$):** `[3, 5, 2, 1, 4]`
*   Current value is `3`. It belongs at index `2`.
*   Is it there? No.
*   **Swap** index `0` with index `2`.

**Step 1 ($i = 0$):** `[2, 5, 3, 1, 4]`
*   (Notice $i$ didn't move). Current value is `2`. It belongs at index `1`.
*   Is it there? No.
*   **Swap** index `0` with index `1`.

**Step 2 ($i = 0$):** `[5, 2, 3, 1, 4]`
*   Current value is `5`. It belongs at index `4`.
*   Is it there? No.
*   **Swap** index `0` with index `4`.

**Step 3 ($i = 0$):** `[4, 2, 3, 1, 5]`
*   Current value is `4`. It belongs at index `3`.
*   Is it there? No.
*   **Swap** index `0` with index `3`.

**Step 4 ($i = 0$):** `[1, 2, 3, 4, 5]`
*   Current value is `1`. It belongs at index `0`.
*   Is it there? Yes.
*   Now we increment $i$.

**Step 5 ($i = 1$):** `[1, 2, 3, 4, 5]`
*   Value at index 1 is `2`. Correct? Yes. Increment $i$.
*   ... (The rest are all correct).

**Final Result:** `[1, 2, 3, 4, 5]`

### 4. Code Implementation (Python)

Here is the standard template for Cyclic Sort.

```python
def cyclic_sort(nums):
    i = 0
    while i < len(nums):
        # Calculate the index where the current value SHOULD be
        # (Assuming range 1 to N. If 0 to N, correct_idx = nums[i])
        correct_idx = nums[i] - 1
        
        # Check if nums[i] is already in the correct position
        if nums[i] != nums[correct_idx]:
            # SWAP: Put the number in its correct home
            nums[i], nums[correct_idx] = nums[correct_idx], nums[i]
        else:
            # If it is in the correct place, move to next
            i += 1
            
    return nums
```

### 5. Complexity Analysis

This is often counter-intuitive because there is a `while` loop (which looks linear) but we don't always increment `i`. People often fear it is $O(n^2)$. **It is not.**

*   **Time Complexity: $O(n)$**
    *   Every time we swap, we place at least one number in its *permanent, correct position*.
    *   Once a number is in its correct position, we never move it again.
    *   If there are $n$ numbers, there can be at most $n-1$ swaps in total across the entire execution.
    *   We iterate through the array once ($n$ steps) + limited swaps ($n$ steps) = $O(n)$.
*   **Space Complexity: $O(1)$**
    *   We are modifying the input array in place. We do not use extra auxiliary structures like HashMaps or Sets.

### 6. Common Variations & Problems

The power of Cyclic Sort is usually not just to "sort," but to identify anomalies (missing items or duplicates) after trying to sort.

#### Variation A: Find the Missing Number
**Problem:** Given array `[4, 0, 3, 1]` (Range 0 to `n`), find the missing number (which is 2).
1.  Run Cyclic Sort.
2.  Iterate the array one last time.
3.  Because `2` is missing, the number at index `2` will be incorrect. If `arr[i] != i`, then `i` is the missing number.

#### Variation B: Find the Duplicate Number
**Problem:** Given `[1, 3, 4, 2, 2]`.
1.  Run Cyclic Sort logic.
2.  When trying to swap `2` into its correct index, you realize the spot is *already occupied* by a `2`.
3.  Since the correct spot is taken by the same number, you have found your duplicate.

### Summary Checklist
1. Is the data in a fixed range (like 1 to N)?
2. Do I need $O(n)$ time and $O(1)$ space?
3. **Use Cyclic Sort:** Map values to indices `(val -> index)`, swap until everything is in place, then scan for the misplaced item.
