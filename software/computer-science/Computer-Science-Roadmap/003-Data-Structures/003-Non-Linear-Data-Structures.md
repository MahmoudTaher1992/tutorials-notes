Based on the roadmap provided, here is a detailed explanation of **Part III, Section C: Non-Linear Data Structures**.

### Introduction: Linear vs. Non-Linear
To understand this section, you must first understand the distinction:
*   **Linear Data Structures** form a sequence (e.g., Arrays, Linked Lists, Stacks). Element A leads to Element B, which leads to Element C.
*   **Non-Linear Data Structures** do not follow a sequential order. Instead, a single element can connect to multiple other elements. This reflects hierarchical relationships (like a file system) or interconnected relationships (like a social network).

---

### 1. Trees
A Tree is a hierarchical structure consisting of nodes. One node is the **Root**, and it points to child nodes. Cycles (loops) are forbidden in trees.

*   **Binary Trees & Binary Search Trees (BST):**
    *   **Binary Tree:** Every node has at most two children (Left and Right).
    *   **BST:** A specific type of binary tree where the **Left** child is always smaller than the parent, and the **Right** child is always larger. This allows for fast lookup ($O(\log n)$), similar to binary search in an array.
*   **AVL & Red-Black Trees (Self-Balancing Trees):**
    *   A standard BST can become "unbalanced" (looking like a linked list) if you add numbers in order (1, 2, 3, 4...). This makes lookups slow ($O(n)$).
    *   **AVL and Red-Black Trees** automatically detect when they are becoming lopsided and rotate nodes to keep the height short. Most programming languages use Red-Black trees internally to implement ordered maps and sets.
*   **B-Trees / 2-3-4 Trees:**
    *   These are **multi-way trees** (nodes can have more than 2 children).
    *   **B-Trees** are critical for **Databases and File Systems**. When data is stored on a hard drive, reading is slow. B-Trees minimize the height of the tree significantly by storing many keys in a single node, reducing the number of disk accesses required to find data.
*   **Segment, Fenwick, K-D Trees (Advanced/Specialized):**
    *   **Segment/Fenwick Trees:** Used heavily in competitive programming. They allow you to process range queries very fast (e.g., "What is the sum of numbers between index 50 and 5000?") while the data effectively updates.
    *   **K-D Trees (k-dimensional):** Used for spatial data (like maps). It organizes points in multi-dimensional space. It answers questions like "Which restaurant is closest to my current GPS coordinates?"
*   **Tries (Prefix Trees):**
    *   Specifically designed for strings. Every node represents a character.
    *   **Use Case:** Autocomplete systems (e.g., typing "App" into Google and seeing "Apple," "Application").

### 2. Graphs
Graphs are the most general data structure. They consist of **Vertices (Nodes)** and **Edges (Connections)**. Unlike trees, graphs can have cycles (loops) and no specific root.

*   **Directed vs. Undirected, Weighted vs. Unweighted:**
    *   **Directed:** Interactions go one way (e.g., Twitter followers—I follow you, but you don't necessarily follow me).
    *   **Undirected:** Interactions go both ways (e.g., Facebook friends).
    *   **Weighted:** Edges have values (e.g., Roadmap—Distance between City A and City B is 50 miles).
*   **Graph Representations:**
    *   **Adjacency Matrix:** A 2D grid storing connections ($1$ if connected, $0$ if not). Fast to look up specific connections, but uses lots of memory.
    *   **Adjacency List:** An array where every index carries a list of neighbors. More memory efficient for sparse graphs (most real-world graphs).
*   **Spanning Trees:**
    *   A sub-section of a graph that connects all nodes with the minimum number of edges possible, creating a tree (no loops) out of a graph. Essential for network design (e.g., laying internet cable to connect 5 cities with the least amount of wire).
*   **Heap & Priority Queue:**
    *   *Note: Structurally heaps are trees, but they are often categorized here because they are used in Graph algorithms (like Dijkstra's).*
    *   A **Heap** keeps the highest (Max-Heap) or lowest (Min-Heap) value at the very top.
    *   **Use Case:** Priority Queues. When a CPU schedules tasks, it doesn't just do "first come, first served." It picks the "Help! System Crash" task before the "Update Clock" task. Heaps manage this efficiently.

### 3. Hash Tables
Hash tables are arguably the most used data structure in practical software engineering because they offer $O(1)$ (instant) data retrieval on average.

*   **Hashing Functions & Maps:**
    *   You take a "Key" (e.g., "Username"), feed it into a math formula (Hash Function), and it outputs an integer "Index". You store the "Value" (e.g., "User Profile") at that index in an array.
*   **Collision Resolution:**
    *   Sometimes disparate keys (like "Cat" and "Dog") might accidentally produce the same math index. This is a collision.
    *   **Chaining (Open Hashing):** Create a Linked List at that index to store both items.
    *   **Open Addressing (Closed Hashing):** If the index is full, simply look for the next available slot in the array.

### 4. Sets & Maps
These are "Abstract Data Types" that are usually implemented *using* the Trees or Hash Tables described above.

*   **Ordered vs. Unordered Variants:**
    *   **Unordered Map/Set:** Uses a **Hash Table**. Very fast ($O(1)$) but the data is in random order.
    *   **Ordered Map/Set:** Uses a **BST (Red-Black Tree)**. Slower ($O(\log n)$) but you can iterate through the data alphabetically or numerically.
*   **Skip Lists:**
    *   A probabilistic data structure. It uses multiple layers of linked lists to allow you to "skip" over sections of data. It performs similarly to a Binary Search Tree but is easier to implement concurrently (for parallel processing).
*   **Bloom Filters:**
    *   A space-efficient probabilistic structure. It tells you either "The item is definitely NOT in the set" or "The item represents MAYBE in the set."
    *   **Use Case:** Web browsers use this to check malicious URLs. If the filter says "Maybe," it does a full (slow) database check. If it says "No," it knows instantly the site is safe without checking the database.
