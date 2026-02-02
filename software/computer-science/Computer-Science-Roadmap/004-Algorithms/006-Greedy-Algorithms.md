Based on the roadmap you provided, **Greedy Algorithms** fall under `Part IV: Algorithms > Section F`. This is a crucial concept in computer science because it represents a specific way of thinking about solving optimization problems.

Here is a detailed explanation of the concept, the theory behind it, and the specific examples listed in your roadmap.

---

# Part IV, F: Greedy Algorithms

### 1. What is a Greedy Algorithm?
A Greedy Algorithm is an approach to solving problems by making the **locally optimal choice** at each stage with the hope of finding a **global optimum**.

In simpler terms: At every step of the algorithm, it asks, *"What looks best right now?"* and takes that path, without worrying about the future consequences or looking back at previous steps.

#### Key Characteristics:
1.  **Greedy Choice Property:** You can make a choice that looks best at the moment, and that choice will lead to the correct final answer. You don't need to reconsider it later.
2.  **Optimal Substructure:** An optimal solution to the problem contains within it/is composed of optimal solutions to sub-problems.
3.  **Irrevocability:** Once a decision is made (e.g., "I will take this coin"), it is never changed.

#### When does it work?
Greedy algorithms are generally used for **Optimization Problems** (maximizing profit, minimizing cost, minimizing time).
*   **Pros:** They are usually very fast and easy to implement compared to Dynamic Programming because they don't have to explore every possibility.
*   **Cons:** They do not work for every problem. For some problems, being "greedy" leads to a bad result (getting stuck in a local maximum).

---

### 2. The Classic Problems (From your Roadmap)

Your roadmap specifically lists **Activity Selection** and **Fractional Knapsack**. These are the two textbook examples used to prove that Greedy works.

#### A. Activity Selection Problem

**The Scenario:**
You have a meeting room and a list of requested activities. Each activity has a **Start Time** and an **End Time**. The room can only hold one activity at a time.
*   **Goal:** Select the *maximum number* of non-overlapping activities.

**The Greedy Strategy:**
To pack the most meetings into the day, you should always pick the meeting that **finishes the earliest**. Why? because finishing early leaves the most remaining time for other activities.

**Algorithm Steps:**
1.  **Sort** all activities by their **Finish Time** (in ascending order).
2.  Select the first activity (the one that ends soonest).
3.  Move to the next activity in the sorted list.
    *   If its *Start Time* is greater than or equal to the *Finish Time* of the previously selected activity, select it.
    *   If not (it overlaps), skip it.
4.  Repeat until the end of the list.

**Example:**
*   A1: [1, 3]
*   A2: [2, 5]
*   A3: [4, 7]
*   A4: [1, 8]
*   A5: [5, 9]

*Sorted by Finish Time:* A1(end 3), A2(end 5), A3(end 7), A4(end 8), A5(end 9).
1.  Pick **A1** (ends at 3).
2.  Check A2 (starts at 2): Overlaps with A1. Skip.
3.  Check A3 (starts at 4): Starts after A1 finishes. Pick **A3**. (Current finish is now 7).
4.  Check A4 (starts at 1): Overlaps. Skip.
5.  Check A5 (starts at 5): Overlaps with A3. Skip.
*   **Result:** You selected A1 and A3.

---

#### B. Fractional Knapsack Problem

**The Scenario:**
You are a thief with a knapsack (bag) that can hold a maximum weight of `W`. There are items in a shop, each with a specific **Value** and **Weight**.
*   **Unique Twist:** Example: Gold dust, flour, or sugar. You can take a *fraction* of an item (e.g., you can take half the bag of flour).
*   **Goal:** Maximize the total value in the knapsack.

**The Greedy Strategy:**
Since you can take fractions, you should prioritize the items that give you the **most value per unit of weight**. You aren't looking for the heaviest item or the most expensive item total—you want the *densest* value.

**Algorithm Steps:**
1.  Calculate the **Ratio** (Value / Weight) for every item.
2.  **Sort** the items by this Ratio in descending order (highest value-per-weight first).
3.  Loop through the sorted items:
    *   If the whole item fits in the remaining bag space, take the whole thing.
    *   If the item is too heavy for the remaining space, take as much of it as possible (fill the rest of the bag) and stop.

**Example:**
*   Capacity: 50 kg
*   Item A: Value 60, Weight 10 (Ratio: 6.0)
*   Item B: Value 100, Weight 20 (Ratio: 5.0)
*   Item C: Value 120, Weight 30 (Ratio: 4.0)

1.  **Order:** A, then B, then C.
2.  Pick **Item A**: Weight is 10. Bag has 40 left. Value = 60.
3.  Pick **Item B**: Weight is 20. Bag has 20 left. Value = 60 + 100 = 160.
4.  Pick **Item C**: Weight is 30, but Bag only has 20 left.
    *   We cannot take all of C.
    *   We take *fractional* part: 2/3 of Item C.
    *   Value taken = 120 * (20/30) = 80.
    *   Total Value = 160 + 80 = **240**.

**Contrast Note:**
If you *could not* break the items (called the **0/1 Knapsack Problem**), Greedy would **fail**. You would need Dynamic Programming for that. The fact that it is "Fractional" makes it solvable with Greedy logic.

---

### Summary Checklist for Interview/Exams
If asked about Greedy Algorithms:
1.  **Define:** Making the locally optimal choice hoping for a global optimum.
2.  **Attributes:** Fast, efficient, but doesn't work for all problems.
3.  **Examples:**
    *   **Activity Selection:** Helps understand scheduling. Key = Sort by finish time.
    *   **Fractional Knapsack:** Helps understand resource allocation. Key = Sort by Value/Weight ratio.
    *   **Huffman Coding:** (Another common example) Used for file compression by creating a greedy tree based on frequency.
    *   **Dijkstra's Algorithm:** Finds the shortest path in a graph (uses a greedy approach by always visiting the closest unvisited node).
