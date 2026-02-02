Based on the roadmap you provided, **Backtracking** is a sub-topic under **Part IV: Algorithms**.

Here is a detailed explanation of what Backtracking is, how it works, and a breakdown of the specific problems listed in your roadmap (N-Queens, Subset Sum, Hamiltonian Path).

---

# What is Backtracking?

**Backtracking** is an algorithmic technique for solving problems recursively by trying to build a solution incrementally, one piece at a time. The moment the algorithm determines that the current path cannot possibly lead to a valid solution, it abandons it (it "backtracks") and tries a different path.

### The "Maze" Analogy
Imagine you are in a maze trying to find the exit:
1.  You walk down a path.
2.  You reach a fork and choose to go **Left**.
3.  You hit a dead end.
4.  You walk back (**backtrack**) to the fork.
5.  Now you choose to go **Right**.

Unlike a "Brute Force" approach (which might try to generate every possible path at once), Backtracking is "Brute Force with a Brain." It uses **pruning**—if a partial solution violates the rules, it stops immediately and doesn't waste time exploring deeper.

---

### The 3 Core Steps of Backtracking
most backtracking algorithms follow this generic pattern inside a loop:

1.  **Choose:** Pick an option (e.g., place a number, pick a path).
2.  **Explore:** Recursively call the function to move to the next step.
3.  **Un-choose (The "Backtrack"):** If the recursive call didn't find a solution, undo the choice (e.g., remove the number) so you can try the next option.

---

### Key Problems from Your Roadmap

Your roadmap lists three classic problems that are solved using Backtracking. Here is how they work:

#### 1. The N-Queens Problem
**The Goal:** Place $N$ chess queens on an $N \times N$ chessboard so that no two queens attack each other. (Queens attack horizontally, vertically, and diagonally).

**How Backtracking solves it:**
*   **Step 1:** Start at the first row. Place a Queen in the first column.
*   **Step 2:** Move to the second row. Find a column where the Queen is safe (not attacked by the Queen in row 1).
*   **Step 3:** Move to the third row.
*   **The Constraint:** If you reach Row 5 and there is literally no safe place to put a Queen because of the placements in Rows 1–4, you have hit a "Dead End."
*   **The Backtrack:** You go back to Row 4, pick up that Queen, and move her to a different spot. Then you try Row 5 again.

#### 2. Subset Sum Problem
**The Goal:** Given a set of integers (e.g., `{3, 34, 4, 12, 5, 2}`) and a target sum (e.g., `9`), determine if any subset of these numbers adds up exactly to the target.

**How Backtracking solves it:**
*   **The Choice:** For every number in the list, you have exactly two choices: **Include** it in your sum, or **Exclude** it.
*   **The Process:**
    1.  Start with `3`. Include it? (Current sum: 3).
    2.  Next is `34`. Include it? (Current Sum: 37).
    3.  **check:** 37 > Target (9). This path is dead.
    4.  **Backtrack:** Go back before we added 34. Now try the path where we *Exclude* 34.
    5.  Next is `4`. Include it? (Current sum: 3 + 4 = 7).
    6.  Next is `2`. Include it? (Current Sum: 9). **Success!**

#### 3. Hamiltonian Path
**The Goal:** Given a graph (a collection of nodes and edges), find a path that visits **every vertex exactly once**.

**How Backtracking solves it:**
*   **Start:** Pick an arbitrary starting node (Node A).
*   **Step:** Move to a neighbor (Node B). Mark B as "visited."
*   **Recurse:** From B, move to an unvisited neighbor (Node C).
*   **Dead End:** If you are at Node D, and all of D's neighbors have already been visited, but you haven't visited the whole graph yet, you are stuck.
*   **The Backtrack:** Step back from D to C, mark D as "unvisited," and try a different neighbor of C.

---

### General Pseudocode Structure

Almost every backtracking solution looks like this in code:

```python
def solve(current_state):
    # 1. Base Case: Have we found a solution?
    if is_solution(current_state):
        print("Found solution!")
        return True

    # 2. Iterate through all possible next moves
    for choice in valid_choices(current_state):
        
        # A. Make the choice
        make_move(current_state, choice)
        
        # B. Recurse (Deep Dive)
        if solve(current_state):
            return True
            
        # C. Backtrack (Undo the choice)
        undo_move(current_state, choice)

    return False
```

### Why is this important?
Backtracking is often used for NP-Complete problems (problems where no fast, efficient solution exists). While Backtracking is essentially exponential time complexity ($O(2^n)$ or $O(n!)$), the pruning makes it much faster than a naive brute force search for typical inputs.
