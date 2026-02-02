Here is a detailed explanation of **Part VIII, Section A: Tries (Prefix Trees)**.

---

# 08-A: Tries (Prefix Trees)

## 1. What is a Trie?
A **Trie** (pronounced "try" comes from the word re**trie**val) is a specialized tree-based data structure that is extremely efficient at storing and searching for strings. It is also known as a **Prefix Tree**.

Unlike a Binary Search Tree (where nodes are sorted by value), a Trie is structured around the **characters** of the strings it stores.

### The Core Concept
Imagine you want to store the words: `"cat"`, `"car"`, and `"dog"`.
*   **Root:** The root node is empty.
*   **Level 1:** From the root, we branch out based on the first letter. There is a branch for 'c' and a branch for 'd'.
*   **Level 2:** From the 'c' node, we branch to 'a'.
*   **Level 3:** From the 'a' node, we branch to 't' (finishing "cat") and 'r' (finishing "car").

**Key Characteristic:** All words that share a common prefix (like "ca-" in "cat" and "car") share the same path and nodes in the tree. This is what makes it a "Prefix" tree.

## 2. Anatomy of a Trie Node
A single node in a Trie usually contains two things:

1.  **Children:** A data structure pointing to the next characters.
    *   *Implementation:* This is often an **Array** of size 26 (for English lowercase letters) or a **Hash Map/Dictionary** (mappings like `{'a': <Node>, 'b': <Node>}`).
2.  **IsEndOfWord (Boolean):** A flag to indicate if this node represents the end of a valid word.
    *   *Why?* If we store "apple", we have nodes `a-p-p-l-e`. If we also want to recognize "app" as a word, the second 'p' node must have this flag set to `True`.

## 3. Visual Representation
Let's visualize storing: **"APP", "APPLE", "ADD"**

```text
       [ROOT]
        /
      [A] 
      / \
    [P] [D]
    /     \
  *[P]    *[D]  <-- "ADD" ends here (star indicates IsEndOfWord=True)
   /
 [L]
 /
*[E]            <-- "APPLE" ends here
```
*   Note that **"APP"** ends at the second P.
*   Note that **"APPLE"** continues from that same P.
*   **"ADD"** branches off earlier.

## 4. Core Operations

### A. Insertion
To insert a word:
1.  Start at the root.
2.  Iterate through every character of the word.
3.  Check if the current node has a child for that character.
    *   **If yes:** Move to that child.
    *   **If no:** Create a new node for that character and link it.
4.  After processing the last character, mark the current node's `isEndOfWord` flag as `True`.

### B. Searching (Whole Word)
To find if a word exists (e.g., "apple"):
1.  Start at the root.
2.  For each character in "apple", check if the child node exists.
    *   **If no:** The word doesn't exist. Return `False`.
    *   **If yes:** Move to the next node.
3.  Once you reach the end of the string, check the `isEndOfWord` flag.
    *   If it is `True`, the word exists.
    *   If it is `False` (e.g., searching for "app" when only "apple" is stored, and "app" wasn't explicitly marked), return `False` (or return true if you just care that it's a prefix).

### C. StartsWith (Prefix Search)
This is the Trie's superpower. To check if *any* word starts with "app":
1.  Follow the logic for Searching.
2.  If you successfully traverse all characters in "app" without hitting a dead end, return `True`. You do **not** need to check the `isEndOfWord` flag.

## 5. Complexity Analysis

Let $L$ be the length of the word (key) we are inserting or searching.
Let $N$ be the total number of words.

| Operation | Time Complexity | Why? |
| :--- | :--- | :--- |
| **Insert** | **O(L)** | We perform one step for each character in the word. |
| **Search** | **O(L)** | We traverse down for each character. Immediate fail if char is missing. |
| **Prefix** | **O(L)** | Same as search, but stops after the prefix length. |

**Comparison to Hash Maps:**
*   A Hash Map is $O(1)$ average, but in worst-case scenarios with collisions, it can be $O(L)$ (computing the hash of a string requires reading every character).
*   However, Tries are strictly $O(L)$ in the worst case, making them very predictable.

**Space Complexity:**
*   **O(N $\times$ L)** in the worst case (no common prefixes).
*   However, Tries save space when many words share prefixes (e.g., "interest", "interesting", "interested" share 90% of their nodes).

## 6. Real-World Applications

### 1. Autocomplete (Typeahead)
When you type "Alg" into Google, it suggests "Algorithm", "Algebra", etc.
*   **How:** The system traverses the Trie to "A-l-g". It then looks at all children appearing below that node to suggest completions.

### 2. Spell Checkers
To check if a word is spelled correctly, simply search the Trie. If you hit a dead end or stop at a node where `isEndOfWord` is false, the word is misspelled.

### 3. IP Routing (Longest Prefix Match)
Internet routers use a variation of Tries to decide where to send packets. They look at the binary structure of an IP address and match the longest known sequence in their routing table.

### 4. Boggle / Word Games
Solving a Boggle board involves checking if a random string of characters exists in a dictionary. A Trie allows you to stop searching immediately if the sequence "XY" doesn't exist in the dictionary, saving massive amounts of time compared to other lookups.

## 7. Code Implementation (Python Example)

Here is a clean, readable implementation:

```python
class TrieNode:
    def __init__(self):
        # Dictionary to hold children nodes
        # Key: Character, Value: TrieNode
        self.children = {}
        # Flag to mark end of a word
        self.is_end_of_word = False

class Trie:
    def __init__(self):
        self.root = TrieNode()

    def insert(self, word: str) -> None:
        current = self.root
        for char in word:
            # If char not in children, create new node
            if char not in current.children:
                current.children[char] = TrieNode()
            # Move to next node
            current = current.children[char]
        # Mark the end
        current.is_end_of_word = True

    def search(self, word: str) -> bool:
        current = self.root
        for char in word:
            if char not in current.children:
                return False
            current = current.children[char]
        # It's only a match if the "end" flag is set
        return current.is_end_of_word

    def startsWith(self, prefix: str) -> bool:
        current = self.root
        for char in prefix:
            if char not in current.children:
                return False
            current = current.children[char]
        # If we traversed the whole prefix, it exists
        return True
```
