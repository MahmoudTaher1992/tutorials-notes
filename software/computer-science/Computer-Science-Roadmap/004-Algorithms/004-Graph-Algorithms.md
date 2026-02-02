Based on the Table of Contents you provided, specifically **Part IV (Algorithms) -> Section D (Graph Algorithms)**, here is a detailed breakdown of the concepts, mechanics, and applications of these algorithms.

Graph algorithms are critical in Computer Science because graphs model relationships (social networks, roads, internet routing, dependencies).

---

### 1. Traversals: BFS & DFS
Traversal is the process of visiting (checking/updating) every node in a graph.

#### **BFS (Breadth-First Search)**
*   **Concept:** Explores the graph layer-by-layer. It starts at a root node and explores all immediate neighbors (depth 1) before moving to neighbors of neighbors (depth 2).
*   **Data Structure:** Uses a **Queue** (First-In-First-Out).
*   **Key Property:** In an unweighted graph, BFS naturally finds the **shortest path** (in terms of number of edges) between the start node and any other node.
*   **Time Complexity:** $O(V + E)$ (Vertices + Edges).
*   **Application:** Web crawlers, peer-to-peer networks, finding the closest friend in a social graph.

#### **DFS (Depth-First Search)**
*   **Concept:** Explores as deep as possible along each branch before backtracking. It goes down a path until it hits a dead end, then steps back to find a new path.
*   **Data Structure:** Uses a **Stack** (or Recursion).
*   **Key Property:** Good for exploring exhaustive possibilities or checking connectivity.
*   **Time Complexity:** $O(V + E)$.
*   **Application:** Solving mazes (backtracking), topological sorting, detecting cycles.

---

### 2. Shortest Path Algorithms
These algorithms find the path between two vertices with the minimum sum of edge weights (e.g., shortest driving time).

#### **Dijkstra’s Algorithm**
*   **Concept:** A greedy algorithm. It keeps track of the shortest known distance to every node. It repeatedly picks the unvisited node with the smallest current distance, visits it, and updates ("relaxes") the distances to its neighbors.
*   **Constraint:** Does **not** work with negative edge weights.
*   **Structure:** Uses a **Min-Priority Queue**.
*   **Complexity:** $O(E + V \log V)$.
*   **Application:** Google Maps (calculating driving distance), IP routing (OSPF).

#### **Bellman-Ford Algorithm**
*   **Concept:** Similar goal to Dijkstra, but it relaxes *all* edges $V-1$ times. It is slower but more robust.
*   **Key Feature:** It **can** handle negative edge weights. Crucially, it can detect **Negative Weight Cycles** (a loop where the total cost decreases every time you travel it).
*   **Complexity:** $O(V \times E)$.
*   **Application:** Routing protocols like RIP, financial arbitrage detection.

#### **A* (A-Star) Search**
*   **Concept:** An informed search algorithm. It is an optimized version of Dijkstra. Instead of just looking at the distance traveled so far ($g(n)$), it adds a **Heuristic** ($h(n)$)—an estimate of the distance remaining to the goal.
*   **Formula:** $f(n) = g(n) + h(n)$.
*   **Application:** Pathfinding in video games (NPC movement), robotics navigation.

---

### 3. Minimum Spanning Tree (MST)
An MST takes a connected, weighted graph and identifies a subset of edges that connects all vertices together with the **minimum total edge weight**, without forming any cycles.

#### **Kruskal’s Algorithm**
*   **Strategy:** "Edge-centric."
*   **Logic:**
    1. Sort all edges by weight from smallest to largest.
    2. Iterate through sorted edges. If an edge connects two nodes that aren't already connected (check using **Union-Find** data structure), add it to the tree.
*   **Best for:** Sparse graphs (fewer edges).
*   **Complexity:** $O(E \log E)$.

#### **Prim’s Algorithm**
*   **Strategy:** "Vertex-centric."
*   **Logic:**
    1. Start at an arbitrary node.
    2. Maintain a "visited" set and an "unvisited" set.
    3. Always pick the smallest edge that connects a visited node to an unvisited node.
*   **Best for:** Dense graphs (lots of edges).
*   **Complexity:** $O(E + V \log V)$ using a Fibonacci heap.

---

### 4. Network Flow
These algorithms determine the maximum amount of "stuff" (water, data, traffic) that can flow from a **Source** to a **Sink** in a network where every edge has a capacity limit.

#### **Ford-Fulkerson Method**
*   **Concept:** Find a path from Source to Sink where capacity remains (an "augmenting path"). Push as much flow as possible along that path. Update the "residual graph" (remaining capacity). Repeat until no paths exist.
*   **Outcome:** Calculates Max Flow. By the Max-Flow Min-Cut theorem, this also tells you the "bottleneck" (Min-Cut) of the system.

#### **Edmonds-Karp Algorithm**
*   **Concept:** A specific implementation of Ford-Fulkerson.
*   **Differentiation:** It uses **BFS** to find the augmenting paths. By always choosing the shortest path (fewest edges) to push flow through, it guarantees the algorithm terminates efficiently.
*   **Complexity:** $O(V \times E^2)$.

---

### 5. Cycle Detection & Topological Sort

#### **Cycle Detection**
*   **Undirected Graph:** Use **Union-Find**. If you try to connect two nodes that are already in the same set, a cycle exists. Alternatively, use DFS (if you see a visited node that isn't your direct parent).
*   **Directed Graph:** Use DFS with a recursion stack. If you encounter a node that is currently in the active recursion stack, a back-edge (cycle) exists.

#### **Topological Sort**
*   **Requirement:** The graph must be a **DAG** (Directed Acyclic Graph).
*   **Concept:** Linear ordering of vertices such that for every directed edge $u \to v$, vertex $u$ comes before vertex $v$ in the ordering.
*   **Algorithms:**
    1.  **Kahn’s Algorithm:** Count in-degrees (number of incoming edges). Repeatedly remove nodes with in-degree 0 and update neighbors.
    2.  **DFS Method:** Perform DFS; push the node to a stack only after visiting all its neighbors. Reverse stack at the end.
*   **Application:** Task scheduling, resolving package dependencies (like `npm install` or `pip`), build systems (Makefiles).
