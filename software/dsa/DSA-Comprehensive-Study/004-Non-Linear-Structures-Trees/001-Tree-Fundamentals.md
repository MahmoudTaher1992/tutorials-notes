Here is a detailed explanation of **Part IV: Non-Linear Structures - Trees / A. Tree Fundamentals**.

In the previous parts of the study plan (Arrays, Linked Lists, Stacks, Queues), everything was **Linear**. Data followed a sequential line: Element A comes before Element B, which comes before Element C.

**Trees are different.** They represent **Hierarchical** data. Instead of a line, think of a corporate, organizational chart or a family tree. In Computer Science, trees are typically drawn "upside down," with the root at the top and the leaves at the bottom.

---

### 1. Core Terminology
To work with trees, you must speak the language. Here is a breakdown of the anatomy of a tree using a visual example:

```text
       [A]  <-- Root
      /   \
    [B]   [C]  <-- Parent (A), Children (B, C)
   /   \    \
 [D]   [E]  [F] <-- Leaves (D, E, F)
```

1.  **Node**: The individual block of data (e.g., `A`, `B`, `C`, etc.).
2.  **Root**: The topmost node. It is the only node without a parent. There is only one root per tree (`A`).
3.  **Edge**: The link or connection between two nodes.
4.  **Parent**: A node that has an edge connecting to a node beneath it. `A` is the parent of `B`.
5.  **Child**: A node that has a parent above it. `B` is the child of `A`.
6.  **Siblings**: Nodes that share the same parent. `B` and `C` are siblings.
7.  **Leaf (node)**: A node with **no children**. It is the "bottom" of the tree (`D`, `E`, `F`).
8.  **Subtree**: Any node and all of its descendants form a subtree. For example, `B`, `D`, and `E` form a subtree within the larger tree.

#### The "Measurements": Height vs. Depth
This is a common interview confusion point.

*   **Depth (of a node):** The number of edges from the **Root** to that specific node.
    *   Depth of Root = 0.
    *   Depth of `B` = 1.
    *   Depth of `D` = 2.
    *   *Mnemonic: "Depth" is how deep you are diving down from the surface.*

*   **Height (of a node):** The number of edges on the longest path from that node down to a **Leaf**.
    *   Height of `D` (Leaf) = 0.
    *   Height of `B` = 1 (Path `B`->`D` or `B`->`E`).
    *   Height of Root `A` = 2.
    *   *Mnemonic: "Height" is how high the node implies the tree stands from the ground up.*

---

### 2. Tree Properties (Classifying Trees)
When we start analyzing algorithms, the *shape* of the tree dictates how fast your code runs. These terms usually apply to **Binary Trees** (trees where nodes have at most 2 children).

#### A. Full Binary Tree
Every node has either **0** children or **2** children. No node has only one child.
*   *Why it matters:* It creates a specific mathematical relationship between the number of leaves and total nodes.

#### B. Complete Binary Tree
All levels of the tree are fully filled, except possibly the last level. Imporantly, the nodes in the last level must be filled from **left to right**.
*   *Why it matters:* This is the fundamental structure used to create **Heaps** (Priority Queues). Because there are no "gaps" in the structure, complete trees can be efficiently stored in a simple Array.

#### C. Perfect Binary Tree
Every internal node has exactly 2 children, and **all leaf nodes are at the same depth.**
*   *Why it matters:* This provides the most efficient possible topology. A perfect tree of height $h$ has exactly $2^{h+1} - 1$ nodes.

#### D. Balanced Tree
The difference in height between the left subtree and the right subtree of any node is not "too big" (usually defined as a difference of no more than 1).
*   *Why it matters:* **This is the most critical concept for performance.** If a tree is balanced, search operations take **O(log n)** time.

#### E. Degenerate (Pathological) Tree
Every parent node has only one child. The tree looks like a straight line.
*   *Why it matters:* This represents the **Worst Case Scenario**. A degenerate tree effectively behaves like a Linked List. Searching it takes **O(n)** instead of O(log n).

---

### 3. Real-World Applications
Why do we use trees instead of arrays or lists?

#### A. File Systems
Your computer's hard drive is a tree.
*   Root (`/` or `C:\`)
*   Folders (internal nodes)
*   Files (leaf nodes)
*   *Why:* It allows for logical nesting and quick navigation through hierarchies.

#### B. The DOM (Document Object Model)
In Web Development, an HTML page is a tree.
*   `<html>` is the Root.
*   `<head>` and `<body>` are children.
*   `<div>`, `<p>`, and `<h1>` are nested descendants.
*   *Why:* Browsers use tree traversal algorithms to figure out what to paint on the screen.

#### C. Abstract Syntax Trees (AST)
When you write code (in Python, JS, C++), the compiler doesn't read it like a sentence. It turns it into a tree to understand the logic.
*   Code: `if (x > 5) { return true; }`
*   Tree Structure:
    *   Root: `IfStatement`
    *   Child 1: `Condition` (x > 5)
    *   Child 2: `Block` (return true)

#### D. Autocomplete (Tries)
When you type into Google, it suggests the rest of the word. This is often done using a specialized tree called a **Trie** (Prefix Tree), where each node represents a letter, and the path down represents a word.
