Here is a detailed breakdown of **Part II, Section D: Queues**.

---

# 004 - Queues

## 1. The Core Concept: FIFO
The defining characteristic of a Queue is **FIFO**: **First-In, First-Out**.

Think of a Queue exactly like a line of people waiting at a grocery store or a movie theater:
1.  **First-In:** The person who arrives first stands at the front of the line.
2.  **First-Out:** That same person is the first one to be served and leave the line.

This is the exact opposite of a **Stack** (which is LIFO - Last-In, First-Out). In a Queue, fairness is the main goal; order is preserved.

## 2. The Queue Abstract Data Type (ADT)
Regardless of how we code it under the hood, a "Queue" must support these primary operations:

1.  **Enqueue (element):** Adds an element to the **back (rear)** of the queue.
2.  **Dequeue ():** Removes and returns the element from the **front** of the queue.
3.  **Peek / Front ():** Returns the element at the front without removing it.
4.  **isEmpty ():** Returns `true` if the queue serves no elements.
5.  **isFull ():** (Optional) Returns `true` if the queue has reached max capacity (for fixed-size arrays).

## 3. Implementation Strategies
How do we build this? There are two main approaches, each with trade-offs.

### A. The Linked List Implementation (Most Common for Dynamic Queues)
This is often the cleanest way to implement a Queue because Linked Lists are naturally good at adding/removing from ends.

*   **Structure:** You maintain two pointers: `Head` (Front) and `Tail` (Rear).
*   **Enqueue:** Create a new node. Point the current `Tail.next` to the new node. Update `Tail` to be the new node.
*   **Dequeue:** Grab the data at `Head`. Move `Head` to `Head.next`.

**Cost:** All operations are **O(1)** (Constant time).

### B. The Array Implementation (The "Shifting" Problem)
If you use a standard array (like a Python List or JavaScript Array):

*   **Enqueue:** Push item to index `n`. Easy. **O(1)**.
*   **Dequeue:** Remove item at index `0`. **This is bad.** Why? Because if you remove index 0, **every other element in the array must shift to the left** to fill the gap.
*   **Result:** Dequeue becomes **O(n)**, which is too slow.

### C. The Circular Buffer (The Array Solution)
To make Arrays efficient (O(1)) for Queues, we use a **Circular Buffer** logic.
*   We do *not* shift elements.
*   We keep two integer pointers (indexes): `front` and `rear`.
*   When we remove from the front, we just increase the `front` index.
*   When `rear` reaches the end of the array, it wraps back around to index 0 (if there is space).
*   If `front` and `rear` meet, the queue is full (or empty, depending on implementation).

## 4. Complexity Analysis (Big-O)

| Operation | Time Complexity | Note |
| :--- | :--- | :--- |
| **Enqueue** | **O(1)** | Constant time. Adding to the back does not affect other elements. |
| **Dequeue** | **O(1)** | Constant time (if using Linked List or Circular Buffer). |
| **Peek** | **O(1)** | Just looking at a pointer/index. |
| **Search** | **O(n)** | You must iterate through the line to find specific logic. |
| **Space** | **O(n)** | Linear space based on the number of items stored. |

## 5. Variants of Queues

### A. Deque (Double-Ended Queue)
Pronounced "Deck". This allows you to Enqueue and Dequeue from **both** ends.
*   Insert at Front / Insert at Back
*   Remove from Front / Remove from Back
*   **Example:** Python’s `collections.deque` is a highly optimized doubly linked list implementation of this.

### B. Priority Queue
*   **Strict FIFO is broken here.**
*   Elements are assigned a "Priority."
*   **Dequeue** always removes the element with the **highest priority** (or lowest number), regardless of when it arrived.
*   **Implementation:** Usually implemented using a **Heap** (data structure), not a standard list, to keep access efficient ($O(\log n)$).
*   **Example:** A Hospital ER. A patient with a heart attack (High Priority) is treated before a patient with a cold (Low Priority), even if the cold patient arrived earlier.

## 6. Applications: Why do we need Queues?

In computer science, Queues are used whenever we need to handle things **asynchronously** (not happening at the same time) or preserve order.

1.  **Breadth-First Search (BFS):**
    *   This is the most common algorithmic use. When traversing a Graph or Tree level-by-level, we use a Queue to keep track of which neighbors to visit next.

2.  **OS Task Scheduling:**
    *   The CPU can only do one thing at a time. Processes waiting to run are placed in a Queue.

3.  **IO Buffers / Printer Spooling:**
    *   Your computer sends data to the printer faster than the printer can print. The OS puts the documents in a Queue (spool). The printer "Dequeues" one page, prints it, then asks for the next.

4.  **Web Server Request Handling:**
    *   If 1000 users hit a website efficiently, the server puts requests in a queue and processes them in order (often passed to worker threads).

## 7. Code Example (Python)

Using Python's built-in `deque` is the standard way to handle queues efficiently.

```python
from collections import deque

# Initialize
queue = deque()

# 1. Enqueue (Add to rear)
queue.append("Customer A")
queue.append("Customer B")
queue.append("Customer C")

print(f"Current Queue: {queue}") 
# Output: deque(['Customer A', 'Customer B', 'Customer C'])

# 2. Peek (Look at front)
print(f"Front of line: {queue[0]}") 
# Output: Customer A

# 3. Dequeue (Remove from front)
served_customer = queue.popleft() # O(1) operation
print(f"Served: {served_customer}")
# Output: Served: Customer A

print(f"Remaining Queue: {queue}")
# Output: deque(['Customer B', 'Customer C'])
```
