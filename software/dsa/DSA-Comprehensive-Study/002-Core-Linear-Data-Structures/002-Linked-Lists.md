Based on the Table of Contents provided, here is a detailed breakdown of **Part II, Section B: Linked Lists**.

---

# 002-Linked-Lists: Deep Dive

## 1. Core Concept: The "Chain" vs. The "Shelf"

To understand a Linked List, it helps to contrast it with an **Array**.

*   **An Array** is like a bookshelf. Every book has a numbered slot. All slots are right next to each other. To find book #5, you go directly to slot 5.
*   **A Linked List** is like a Scavenger Hunt. You get a clue (a generic piece of data) and a note telling you exactly where the *next* clue is. The clues can be hidden anywhere in the house (memory); they don't need to be next to each other. You cannot jump to Clue #5 without reading Clues #1, #2, #3, and #4 first.

### The Component: The Node
The building block of a Linked List is the **Node**. A node is a container that holds two things:
1.  **Data (Payload):** The value you actually want to store (an integer, a string, a user object).
2.  **Next (Pointer/Reference):** The memory address of the *next* node in the chain.

**Visual Representation:**
```text
[ Data | Next ]  --->  [ Data | Next ]  --->  [ Data | Next ]  --->  NULL
   (Head)                                                          (Tail)
```

*   **Head:** The entry point. If you lose the Head pointer, the entire list is lost in memory.
*   **Tail:** The last node. Its "Next" pointer points to `NULL` (or `None`), indicating the end of the list.

---

## 2. Types of Linked Lists

### A. Singly Linked List
This is the standard version. Navigation is **one-way**. You can go from the Start to the End, but you cannot go backwards.
*   **Pro:** Uses less memory per node (only one pointer).
*   **Con:** You cannot easily access the previous element.

### B. Doubly Linked List
Each node contains **three** things: Data, a `Next` pointer, and a `Previous` pointer.
*   **Visual:** `NULL <--- [ Prev | Data | Next ] <---> [ Prev | Data | Next ] ---> NULL`
*   **Pro:** Can be traversed forwards and backwards. Deleting a node is easier because you have access to the node before it.
*   **Con:** Uses more memory (2 pointers per node instead of 1).

### C. Circular Linked List
The `Tail` node, instead of pointing to `NULL`, points back to the `Head`.
*   **Use Case:** Infinite looping buffers (like a media player playlist on "repeat" or a Round Robin CPU scheduler).

---

## 3. Operations & Time Complexity Analysis

This is where Linked Lists shine (and fail) compared to Arrays.

| Operation | Time Complexity | Explanation |
| :--- | :--- | :--- |
| **Access / Lookup** | **O(n)** (Linear) | To find the 10th element, you *must* traverse elements 1 through 9. Random access is impossible. |
| **Search** | **O(n)** (Linear) | You must check every node one by one to find a value. |
| **Insert at Head** | **O(1)** (Constant) | **The Superpower.** Create a new node, point it to the current Head, update Head pointer. No shifting required. |
| **Insert at Tail** | **O(n)** or **O(1)** | **O(n)** if you have to walk from Head to Tail. **O(1)** if you maintain a specific `tail` pointer variable. |
| **Insert Middle** | **O(n)** | You have to walk to the specific spot ($O(n)$), but the actual insertion logic is instant ($O(1)$). |
| **Delete** | **O(n)** | Similar to insertion: Finding the node takes time, but unlinking it is instant. |

### Technical Detail: Why is Insertion O(1)?
If you have an Array `[1, 2, 3, 4]`, and you want to insert `0` at the front, the computer has to shift `1` to index 1, `2` to index 2, etc., to make room. That is **O(n)**.

In a Linked List, you simple say:
1.  New Node `0` points to Old Head `1`.
2.  Head points to `0`.
No other nodes need to move or change. This makes Linked Lists ideal for Stacks and Queues.

---

## 4. Comparison: Arrays vs. Linked Lists

| Feature | Array | Linked List |
| :--- | :--- | :--- |
| **Memory** | **Contiguous Block.** Fixed size (usually). | **Scattered.** Dynamic size. Examples: `0x001`, `0x4F2`, `0xA11`. |
| **Space Efficiency** | High (just data). | Lower (Data + Pointer overhead). |
| **Access** | **Fast O(1).** Math calculation allows instant jump to index. | **Slow O(n).** Must walk the chain. |
| **Resizing** | Expensive (create new array, copy everything). | Cheap (just add a node). |
| **CPU Cache** | **Excellent.** Spatial locality allows CPU to predict next data. | **Poor.** Jumping around memory addresses causes cache misses. |

**When to use which?**
*   Use an **Array** if you need to access items by index frequently (e.g., `items[50]`) or know the size of your data beforehand.
*   Use a **Linked List** if you need constant-time insertions/deletions at the beginning of the list, or if you don't know how much data you will have (dynamic size).

---

## 5. Common Algorithmic Problems

These are the standard interview patterns involving Linked Lists.

### A. Reversing a Linked List
Ideally done in-place (without creating a new list) using **O(n)** time and **O(1)** space.
*   **Technique:** Use three pointers: `Prev`, `Current`, and `Next`. Iterate through the list flipping the arrow of `Current` to point to `Prev`.

### B. Cycle Detection (The "Runner" Technique)
How do you know if a Linked List has a loop (starts pointing back to itself)? If you iterate, you will loop forever.
*   **Technique:** **Floyd’s Cycle Finding Algorithm (Tortoise and Hare)**.
    *   Have two pointers. One moves 1 step at a time (Slow). The other moves 2 steps (Fast).
    *   If there is a loop, the Fast pointer will eventually lap the Slow pointer and they will meet.
    *   If the Fast pointer hits NULL, there is no loop.

### C. The "Middle" of the List
Finding the middle without knowing the length.
*   **Technique:** Also uses the Fast/Slow method. When the Fast pointer (2x speed) reaches the end, the Slow pointer (1x speed) will be exactly at the middle.

---

## 6. Code Implementation (Python Example)

Here is a bare-bones implementation of a Singly Linked List node and a class to manage it.

```python
class Node:
    def __init__(self, value):
        self.value = value
        self.next = None  # The pointer to the next node

class LinkedList:
    def __init__(self):
        self.head = None
    
    # O(1) Operation
    def append_start(self, value):
        new_node = Node(value)
        new_node.next = self.head  # Point new node to current head
        self.head = new_node       # Update head to be the new node

    # O(n) Operation (Printing)
    def print_list(self):
        current = self.head
        while current:
            print(f"{current.value} -> ", end="")
            current = current.next
        print("None")

# Usage
ll = LinkedList()
ll.append_start(3)
ll.append_start(2)
ll.append_start(1)
ll.print_list() 
# Output: 1 -> 2 -> 3 -> None
```
