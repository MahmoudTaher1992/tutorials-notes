This section is arguably the most important data structure concept in modern software development. While arrays utilize numeric indices to locate data, **Hash Tables** allow us to use *meaningful data* (like strings or objects) to locate data instantly.

Here is a detailed breakdown of **Part III: Hashing & Associative Structures -> A. Hash Tables**.

---

# 003 — Hash Tables: The Deep Dive

## 1. The Core Idea: Mapping Keys to Values
To understand Hash Tables, we must look at the limitation of a standard Array.

*   **The Array Limitation:** To get data from an array instantly ($O(1)$), you **must know the index** (e.g., `arr[5]`). If you only know the value ("Alice") and want to find her phone number, you have to search every element ($O(n)$).
*   **The Hash Table Solution:** A Hash Table is a hack on top of an array. It creates a mechanism where the **Key** ("Alice") effectively becomes the **Index**.

**The Mental Model:**
Imagine a library. Instead of organizing books alphabetically (which takes time to search), updates, or shift, imagine a "Magic Box."
1. You insert the book title "Harry Potter" into the box.
2. The box spits out a number: `492`.
3. You walk exactly to Shelf `492` and place the book there.
4. Next time you want "Harry Potter," you put the title in the box, it gives you `492`, and you go straight there. No searching required.

## 2. Hash Functions
The "Magic Box" in the analogy above is the **Hash Function**. It is a mathematical algorithm that takes an input (Key) and converts it into an integer (Hash Code).

### Properties of a Good Hash Function:
1.  **Deterministic:** If you put "Alice" in 100 times, you must get the exact same number 100 times. If the number changes, you lose your data.
2.  **Efficient:** The calculation must be very fast (constant time). If the math takes a long time, the table becomes slow.
3.  **Uniform Distribution:** It should spread keys evenly across the available slots. It shouldn't dump "Apple", "Banana", and "Carrot" all into index `5`.

### How it maps to an Array Index:
The Hash Function usually produces a huge integer (e.g., `8572910`). But your underlying array might only have `10` slots.
We use the **Modulo Operator (%)** to fit the big number into the small array.

$$ \text{Index} = \text{hash("Key")} \ \% \ \text{ArraySize} $$

## 3. The Collision Problem
This is the "Achilles' Heel" of Hash Tables.

Because the possible number of keys (infinite strings) is larger than your array size (finite memory), **two different keys will eventually result in the same index.**

*   `hash("Alice")` % 10 $\rightarrow$ Index 2
*   `hash("Bob")`   % 10 $\rightarrow$ Index 5
*   `hash("Charlie")` % 10 $\rightarrow$ **Index 2**  (⚠️ COLLISION!)

"Charlie" wants to sit where "Alice" is already sitting. How we handle this defines the implementation of the Hash Table.

## 4. Collision Resolution Strategies

There are two main ways to handle collisions:

### A. Separate Chaining (The "Bucket" Method)
Instead of storing the actual value in the slot, each slot in the array contains a pointer to a **Linked List** (or another data structure).
*   **Scenario:** Alice is at computer 2. Charlie is hashed to computer 2.
*   **Resolution:** We attach Charlie to Alice using a Linked List.
*   **Retrieval:** Go to Index 2. Traverse the short list: Is this Alice? No. Is this Charlie? Yes.
*   **Pros:** Easy to implement; the table never logically "fills up."
*   **Cons:** Uses extra memory for pointers; if the hash function is bad, one slot becomes a giant list, creating $O(n)$ access time.

### B. Open Addressing (The "Find Another Seat" Method)
All data is stored directly in the array slots. No Linked Lists.
*   **Scenario:** Charlie hashes to Index 2, but Alice is there.
*   **Resolution:** Charlie looks for another empty slot based on a set rule.

#### Probing Techniques:
1.  **Linear Probing:** "Is index 3 open? No. Index 4? Yes. Sit there." (Standard Step: +1)
2.  **Quadratic Probing:** "Is index 3 open? No. Index 6? No. Index 11?" (Step increases quadratically: $1^2, 2^2, 3^2...$)
3.  **Double Hashing:** Use a second hash function to calculate the step size.

*   **Pros:** Better memory cache performance (data is contiguous).
*   **Cons:** **Clustering.** If many items collide near index 2, they form a solid block of filled spots, forcing new items to search longer and longer to find a seat.

## 5. Load Factor and Rehashing
How do we ensure the Hash Table stays fast ($O(1)$) and doesn't degrade into a slow search ($O(n)$)? We watch the **Load Factor**.

$$ \text{Load Factor } (\alpha) = \frac{\text{Number of Items}}{\text{Size of Array}} $$

*   **The Threshold:** In most languages (like Java's HashMap), the threshold is **0.75**. This means when the table is 75% full, it is considered "at capacity."
*   **Rehashing (The Costly Step):**
    1.  Create a **new array** double the size of the old one.
    2.  **Re-calculate the hash** for *every single item* in the old table and insert them into the new table. (We have to re-hash because `Hash % 10` is different from `Hash % 20`).
    3.  Delete the old table.

This allows the table to remain sparse enough that collisions are rare.

## 6. Performance Scenario

| Operation | Average Case | Worst Case | Why Worst Case? |
| :--- | :--- | :--- | :--- |
| **Search** | $O(1)$ | $O(n)$ | All keys collide into one slot (Linked List becomes length N). |
| **Insert** | $O(1)$ | $O(n)$ | Same as above, or triggers a resize/rehash. |
| **Delete** | $O(1)$ | $O(n)$ | Same as above. |

*Note: In the real world, with good hash functions and resizing, we almost always treat Hash Tables as $O(1)$.*

### Summary
1.  **Hash Tables** turn $O(n)$ search into $O(1)$ average search.
2.  They use a **Hash Function** to turn a Key into an Index.
3.  You must handle **Collisions** (via Chaining or Open Addressing).
4.  You must **Resize** the table when it gets too full to keep it fast.
