Here is a detailed breakdown of the **Merge Intervals** pattern.

This is one of the most practical and frequently asked patterns in coding interviews because it maps directly to real-world scheduling and resource management problems.

---

# Pattern: Merge Intervals

### 1. The Core Concept
The "Merge Intervals" pattern is a strategy used to deal with problems involving a collection of intervals. An interval is simply a range with a **Start Time** and an **End Time** (e.g., `[start, end]`).

**The Goal:** To efficiently handle overlapping intervals. Usually, this means combining overlapping intervals into a single, continuous interval, or finding the gaps between them.

**Real-world Analogy:**
Imagine looking at your calendar.
- You have a meeting from **9:00 AM to 10:00 AM**.
- You have another meeting from **9:30 AM to 11:00 AM**.
Because these two time blocks overlap, you effectively have one continuous block of busy time from **9:00 AM to 11:00 AM**.

### 2. Visualizing the Logic

Let's look at a standard example:
**Input:** `[[1, 3], [2, 6], [8, 10], [15, 18]]`

Visualized on a number line:

```text
Interval A:  [1-----3]
Interval B:      [2-----------6]
Interval C:                          [8-----10]
Interval D:                                        [15----18]
```

**The Problem:** Interval A and Interval B overlap.
**The Solution:** We must merge them into a new interval: `[1, 6]`.
 Intervals C and D do not overlap with anything, so they stay the same.

**Result:** `[[1, 6], [8, 10], [15, 18]]`

### 3. The Algorithm (Step-by-Step)

The "trick" to this pattern is **Sorting**. If you try to compare every interval to every other interval, it becomes very slow ($O(N^2)$). However, if you sort the intervals by their **start time**, you only need to compare adjacent intervals.

**The Recipe:**

1.  **Sort:** Sort the list of intervals typically based on the **start time** (the first number).
2.  **Initialize:** Create a list called `merged` and add the first interval to it.
3.  **Iterate:** Loop through the remaining intervals one by one.
4.  **Compare:** Look at the **last interval** in your `merged` list (let's call it `last`) and the **current interval** you are iterating over (let's call it `curr`).
    *   **Check for Overlap:** Does the `curr.start` come *before* (or exactly at) the `last.end`?
        *   `if curr.start <= last.end`: **There is an overlap.**
    *   **Action (Merge):** We need to extend the previous interval. Update `last.end` to be the maximum of `last.end` and `curr.end`.
    *   **Action (No Overlap):** If they don't overlap, simply append `curr` to the `merged` list. The `curr` now becomes the new interval to compare against the next one.

### 4. Code Implementation (Python Logic)

```python
def merge_intervals(intervals):
    # 1. Edge case: empty list
    if not intervals:
        return []

    # 2. Sort by start time (x[0])
    # Complexity: O(N log N)
    intervals.sort(key=lambda x: x[0])

    # 3. Initialize with the first interval
    merged = [intervals[0]]

    # 4. Iterate through the rest
    for current in intervals[1:]:
        last_added = merged[-1]

        # 5. Check for overlap
        # If current start is less than or equal to last end
        if current[0] <= last_added[1]:
            # Merge: The new end is the max of the two ends
            last_added[1] = max(last_added[1], current[1])
        else:
            # No overlap: just add the current interval
            merged.append(current)

    return merged
```

### 5. Complexity Analysis

*   **Time Complexity: $O(N \log N)$**
    *   The primary cost is sorting the intervals, which takes $N \log N$.
    *   The iteration through the list happens in one pass, taking linear time $O(N)$.
    *   Since $N \log N$ is larger than $N$, the total is dominated by the sort.

*   **Space Complexity: $O(N)$**
    *   We need $O(N)$ space to store the sorted list (depending on language) and $O(N)$ space to return the merged list.

### 6. Common Variations & Related Problems

Once you understand this pattern, you can solve many related interview questions:

1.  **Insert Interval:** You are given a sorted list of non-overlapping intervals and a *new* interval. You must insert the new one and merge if necessary.
2.  **Interval List Intersections:** Given two lists of intervals, find the times where the two lists intersect (e.g., when are *both* Person A and Person B free?).
3.  **Meeting Rooms II (Minimum Rooms):** Given a list of meeting times, what is the minimum number of conference rooms required? (This involves determining the maximum number of intervals overlapping at any single point in time).
4.  **Employee Free Time:** Given the working schedules of several employees, find the time blocks where *all* employees are free.

### Summary Checklist for this Pattern
1.  Are you dealing with ranges, time slots, or segments?
2.  Does the problem ask to combine them, find gaps, or find intersections?
3.  **First step:** Sort by start time!
4.  **Second step:** Iterate and keep track of the `end` time of your current active range.
