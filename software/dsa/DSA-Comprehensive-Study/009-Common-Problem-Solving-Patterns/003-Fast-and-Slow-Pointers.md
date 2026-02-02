Here is a detailed explanation of the **Fast and Slow Pointers** pattern, also technically known as **Floyd’s Cycle Finding Algorithm** (or the "Tortoise and the Hare" algorithm).

---

# Pattern: Fast & Slow Pointers (The Tortoise and the Hare)

## 1. The Core Concept
This pattern involves using **two pointers** typically labeled `slow` and `fast` to iterate through a sequence (like an array or a Linked List).

Unlike the "Two Pointers" pattern where pointers might move toward each other (start and end), in this pattern, **both pointers move in the same direction, but at different speeds.**

*   **The Slow Pointer (Tortoise):** Moves one step at a time (`next`).
*   **The Fast Pointer (Hare):** Moves two steps at a time (`next.next`).

## 2. The Mental Model (Analogy)
Imagine two runners on a race track:
1.  **Straight Track (No Cycle):** If the track is a straight line, the Fast runner will simply reach the finish line first. The Slow runner will never catch up.
2.  **Circular Track (Cycle):** If the track is a circle (a loop), the Fast runner will eventually run all the way around and "lap" (catch up to) the Slow runner from behind.

## 3. Why is this useful?
The primary reason we use this pattern is **Space Efficiency**.

If you wanted to detect a loop in a Linked List simply, you could use a Hash Set to store every node you visit. If you encounter a node that is already in the Set, you found a loop. However, this takes **O(N) Space** (memory).

The Fast & Slow Pointers approach solves this in **O(1) Space** (constant memory) because you only need two variables (`slow` and `fast`), regardless of how large the list is.

---

## 4. Common Use Cases

There are three major problems solved by this pattern:

### A. Cycle Detection (Does a loop exist?)
This is the classic interview question. Given a Linked List, determine if it has a cycle.

**The Algorithm:**
1.  Initialize `slow` and `fast` at the head of the list.
2.  Move `slow` by 1, move `fast` by 2.
3.  **Check:**
    *   If `fast` reaches `null` (end of list), there is **no cycle**.
    *   If `fast` equals `slow` (they meet), there **is a cycle**.

```javascript
function hasCycle(head) {
  let slow = head;
  let fast = head;

  while (fast !== null && fast.next !== null) {
    slow = slow.next;       // Move 1 step
    fast = fast.next.next;  // Move 2 steps

    if (slow === fast) {
      return true; // Use Case: Cycle detected!
    }
  }

  return false; // Fast reached the end
}
```

### B. Finding the Middle of a Linked List
This is a clever mathematical trick used often in sorting algorithms (like Merge Sort on Linked Lists).

**The Logic:**
Since the `fast` pointer moves twice as fast as the `slow` pointer, when the `fast` pointer reaches the **end** of the list, the `slow` pointer will be exactly in the **middle**.

**The Algorithm:**
1.  Initialize `slow` and `fast` at the head.
2.  Loop while `fast` and `fast.next` are not null.
3.  Move `slow` by 1, `fast` by 2.
4.  When the loop ends, return `slow`.

```javascript
function findMiddle(head) {
  let slow = head;
  let fast = head;

  while (fast !== null && fast.next !== null) {
    slow = slow.next;
    fast = fast.next.next;
  }
  
  // Fast is at the end, so Slow must be at the middle
  return slow; 
}
```

### C. Finding the Start of a Cycle
If you know a cycle exists, where does it begin?

**The Algorithm:**
1.  **Phase 1:** Perform the standard cycle detection. Wait until `slow` and `fast` meet.
2.  **Phase 2:** Once they meet:
    *   Reset **one** pointer (e.g., `slow`) back to the `head` of the list.
    *   Keep the `fast` pointer at the meeting point.
    *   Now, move **both** pointers usually, **1 step at a time**.
    *   The point where they collide *again* is the mathematical start of the cycle.

*(Note: The proof for why this works involves modular arithmetic, but for coding interviews, memorizing the steps is usually sufficient.)*

---

## 5. Summary of Complexity

| Metric | Complexity | Explanation |
| :--- | :--- | :--- |
| **Time Complexity** | **O(N)** | In the worst case (no cycle or large cycle), we iterate through the list proportional to the number of nodes. |
| **Space Complexity** | **O(1)** | We only store two variables (`slow` and `fast`), regardless of the input size. |

## 6. How to Identify this Pattern
You should consider using Fast & Slow Pointers if:
1.  The problem involves a **Linked List** or an Array that implies a "jumping" sequence.
2.  The problem asks for **cycle detection**.
3.  The problem asks to find the **middle element** or the **k-th to last element** (a variation where fast starts `k` steps ahead).
4.  The problem involves a conceptual "loop" (e.g., The "Happy Number" LeetCode problem).
