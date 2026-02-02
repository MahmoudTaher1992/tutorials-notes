Here is a detailed explanation of **Part V, Section A: Graph Fundamentals & Terminology**.

Graphs are often considered the widely applicable and powerful data structure in computer science because they model **relationships**. While arrays and linked lists are linear (one thing follows another), graphs are non-linear (things are connected in a complex network).

---

# 001 - Graph Fundamentals & Terminology

## 1. What is a Graph?
At its core, a Graph is a mathematical structure used to model pairwise relations between objects. Unlike a tree, which has a strict hierarchy (parents and children), a graph is a free-form collection of items where connections can go in any direction.

### The Anatomy of a Graph
A graph $G$ consists of two sets: $G = (V, E)$.

1.  **Vertices (Nodes):**
    *   These are the entities in the graph.
    *   *Symbol:* $V$
    *   *Analogy:* In a social network, a **Vertex** is a **Person**. In a city map, a Vertex is a **City**.
2.  **Edges (Arcs/Links):**
    *   These are the lines that connect the vertices. They represent the relationship between them.
    *   *Symbol:* $E$
    *   *Analogy:* In a social network, an **Edge** is a **Friendship**. In a map, an Edge is a **Road**.

---

## 2. Classification of Graphs
Graphs change their behavior based on the properties of their edges.

### A. Directed vs. Undirected
This distinction defines the "direction" of the relationship.

*   **Undirected Graph:**
    *   The relationship is two-way (bidirectional) by default.
    *   If Node A is connected to Node B, then Node B is automatically connected to Node A.
    *   **Example:** Facebook Friendships. If I am your friend, you are my friend.
    *   *Visual:* A — B

*   **Directed Graph (Digraph):**
    *   The relationship is one-way (unidirectional).
    *   An edge goes from an *Origin* to a *Destination*.
    *   **Example:** Twitter/Instagram. If I follow you (A -> B), you do not automatically follow me back.
    *   **Example:** Webpages. Page A links to Page B, but Page B might not link back.
    *   *Visual:* A $\rightarrow$ B

### B. Weighted vs. Unweighted
This distinction defines the "cost" of the relationship.

*   **Unweighted Graph:**
    *   All edges are considered equal. The "distance" between any two connected nodes is always 1.
    *   **Example:** Measuring the "degrees of separation" between people.

*   **Weighted Graph:**
    *   Each edge has a numerical value (weight/cost) associated with it.
    *   **Example:** Google Maps. The edge between City A and City B has a weight representing **Distance** (miles) or **Time** (minutes).
    *   When finding the "shortest path," you care about the sum of weights, not just the number of hops.

### C. Cyclic vs. Acyclic
This distinction looks at the paths available within the graph.

*   **Cyclic Graph:**
    *   The graph contains at least one **Cycle**. A cycle is a path that starts at a node, travels through other nodes, and ends up back at the starting node.
    *   *Visual:* A $\rightarrow$ B $\rightarrow$ C $\rightarrow$ A.

*   **Acyclic Graph:**
    *   A graph with no cycles. You can never return to your start point by moving forward.

#### Special Case: The DAG (Directed Acyclic Graph)
This is one of the most important structures in Computer Science.
*   **Directed:** Edges have direction.
*   **Acyclic:** No loops are allowed.
*   **Application:** Dependency resolution.
    *   *Example:* Installing software packages (Node A depends on B, B depends on C). You cannot have a circular dependency (A needs B, B needs A) or the computer freezes. DAGs solve this.

---

## 3. Key Terminology / Metrics

### Degree
The degree describes how connected a node is.
*   **In Undirected Graphs:** The number of edges attached to a node.
*   **In Directed Graphs:**
    *   **In-Degree:** How many edges point *towards* this node. (e.g., How many followers you have).
    *   **Out-Degree:** How many edges go *out* from this node. (e.g., How many people you follow).

### Path
A sequence of edges that allows you to go from Vertex A to Vertex Z.
*   **Simple Path:** A path that does not repeat nodes.

### Connected vs. Disconnected
*   **Connected Graph:** There is a path between *every* pair of vertices. (The entire graph is one "piece").
*   **Disconnected Graph:** There are vertices or groups of vertices that are isolated. Usually called "Connected Components" (islands).

### Dense vs. Sparse
*   **Sparse Graph:** Nodes typically have very few edges connected to them (e.g., a subway map). Accessing neighbors is fast.
*   **Dense Graph:** Nodes are connected to almost every other node (e.g., a flight map where every city flies to every other city).

---

## 4. Trees vs. Graphs
A common interview question is "What is the difference between a Tree and a Graph?"

**Answer:** A Tree is essentially a specific, restricted type of Graph.
*   A **Tree** is always Connected.
*   A **Tree** is always Acyclic (no loops).
*   A **Tree** with $N$ nodes must have exactly $N-1$ edges.
*   A **Graph** has none of these restrictions (it can have loops, be disconnected, or have $N^2$ edges).

---

## 5. Real-World Applications Summary

| Concept | Real-World Example | Graph Type |
| :--- | :--- | :--- |
| **Social Media** | Facebook Friends | Undirected |
| **Social Media** | Twitter/Instagram Follows | Directed |
| **Navigation** | GPS / Maps | Weighted (Miles/Traffic) |
| **Internet** | The World Wide Web | Directed (Hyperlinks) |
| **Computer Science** | Garbage Collection | Reachability in Directed Graph |
| **Project Management** | Task Scheduling (Prerequisites) | DAG (Directed Acyclic) |
