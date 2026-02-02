Here is a detailed breakdown of **Part II, Section C: Stacks**.

---

# 002-Core-Linear-Data-Structures/003-Stacks.md

## 1. The Core Concept: LIFO
The Stack is a linear data structure that follows a specific order for adding and removing elements: **LIFO (Last-In, First-Out)**.

**The Real-World Analogy:**
Think of a stack of dinner plates at a buffet.
1.  **Push:** You put a new plate on **top** of the stack.
2.  **Pop:** You can only take the plate that is on the **top**.
3.  **LIFO:** The **Last** plate you put down is the **First** one you take off. The first plate you put down (at the bottom) is the last one you can access.

Unlike an Array, where you can access an element at index 5 or index 10 randomly, in a Stack, you generally **cannot** access elements in the middle. You only have access to the **Top**.

## 2. The Stack ADT (Abstract Data Type)
An ADT defines *what* a data structure does, not *how* it does it. A Stack must support these primary operations:

1.  **`push(element)`**: Adds an element to the top of the stack.
2.  **`pop()`**: Removes and returns the top element. (Throws an error if empty).
3.  **`peek()`** (or `top()`): Returns the top element *without* removing it.
4.  **`isEmpty()`**: Returns `true` if the stack has no elements.
5.  **`size()`**: Returns the number of elements in the stack.

### Visualizing Operations
Imagine an empty stack.

```text
Action: Push(10)    Action: Push(20)    Action: Pop()      Action: Peek()
   |    |              |    |              |    |             |    |
   |    |              | 20 | < Top        |    |             |    |
   |_10_|              |_10_|              |_10_| < Top       |_10_| < Top creates Result: 10
```

## 3. Implementation Strategies
Since a Stack is an ADT, we have to code it using existing structures. There are two common ways to build one:

### A. Using a Dynamic Array (e.g., Python List, JavaScript Array, C++ Vector)
This is the most common implementation because modern arrays are highly optimized.
*   **The "Top" is the End:** We treat the *end* of the array as the top of the stack.
*   **Push:** `array.append(item)` — $O(1)$ amortized.
*   **Pop:** `array.pop()` — $O(1)$.

### B. Using a Linked List
*   **The "Top" is the Head:** We treat the *head* (first node) of the list as the top.
*   **Push:** Create a new node and point it to the current head. Update head pointer. — $O(1)$.
*   **Pop:** Move the head pointer to `head.next` and return the old head's data. — $O(1)$.

**Which is better?**
*   **Arrays** are usually better due to **Cache Locality**. The computer can read contiguous memory (arrays) faster than jumping around memory (linked lists).
*   **Linked Lists** effectively avoid the "stack overflow" limit found in fixed-size arrays, but consume more memory per item due to storing pointers.

## 4. Complexity Analysis (Big-O)

| Operation | Time Complexity | Note |
| :--- | :--- | :--- |
| **Push** | **O(1)** | Constant time (no loops required). |
| **Pop** | **O(1)** | Constant time. |
| **Peek** | **O(1)** | You just look at the last item. |
| **Search** | **O(n)** | To find an item deep in the stack, you must pop everything above it first. |

*Note: Stacks are designed for speed at the "Top." If you frequently need to search for items, a Stack is the wrong tool.*

## 5. Major Applications (Why do we need this?)

You use Stacks more often than you realize. They are fundamental to how computers run code.

### A. The "Call Stack" (Recursion)
How does a computer know where to return to after a function finishes?
*   When Function A calls Function B, the computer **pushes** Function A's state (variables, line number) onto the "Call Stack."
*   Function B runs.
*   When B finishes, the computer **pops** the stack to resume Function A exactly where it left off.
*   *Error:* If you call functions infinitely (infinite recursion), the stack fills up, and you get a **Stack Overflow**.

### B. Undo / Redo Mechanisms
Text editors (Ctrl+Z) use stacks.
*   **Action:** You type "Hello". -> Push "Type 'Hello'" to the `UndoStack`.
*   **Action:** You delete "o". -> Push "Delete 'o'" to the `UndoStack`.
*   **Undo:** Pop "Delete 'o'" (reverse the action). Push it to the `RedoStack`.

### C. String Parsing & Syntax Checking
Compilers use stacks to check for balanced parentheses/brackets in code: `if (a == b) { print(x); }`
*   **Algorithm:**
    1. Scan string left to right.
    2. If you see an opening `(`, `{`, `[`, **Push** it.
    3. If you see a closing `)`, `}`, `]`, **Pop** from the stack.
    4. If the popped item matches the closing bracket, continue. If not (or if stack is empty), syntax error.
    5. At the end, if the stack is not empty, you have an unclosed bracket.

### D. Depth-First Search (DFS)
When traversing a Graph or a Tree (like a maze), DFS goes as deep as possible before backtracking.
*   You proceed down a path, **pushing** nodes onto the stack to remember where you came from.
*   When you hit a dead end, you **pop** to go back to the previous intersection.

---

### Summary Checklist for Interview Prep:
1.  [ ] Can I explain LIFO?
2.  [ ] Can I implement a Stack from scratch using an Array?
3.  [ ] Can I implement a Stack from scratch using a Linked List?
4.  [ ] Can I solve the "Valid Parentheses" problem (LeetCode ~20)?
5.  [ ] Do I understand why recursion creates a stack in memory?
