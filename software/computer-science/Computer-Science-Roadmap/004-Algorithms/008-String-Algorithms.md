This section of the roadmap (**004-Algorithms / 008-String-Algorithms**) focuses on how computers efficiently process, search, and analyze text. String algorithms are the backbone of search engines, DNA sequencing, text editors (Ctrl+F), and data compression.

Here is a detailed explanation of the three main categories mentioned in your roadmap:

---

### 1. Pattern Search
These algorithms solve the "Needle in a Haystack" problem: given a large text (Haystack) and a specific word/pattern (Needle), how do we find if and where the pattern exists?

#### A. KMP (Knuth-Morris-Pratt) Algorithm
*   **The Problem it Solves:** The "Naive" approach checks character by character. If a mismatch happens, it slides the pattern over by **one** slot and starts over. This is slow ($O(N \cdot M)$).
*   **How KMP Works:** It ensures we **never look back**.
    *   It pre-processes the pattern to create an **LPS Array** (Longest Prefix Suffix). This array tells the algorithm: "If you fail at index X, you don't have to start from the beginning; you can jump straight to index Y."
    *   **Example:** If you are matching "ABABX" and you match "ABAB" but fail at "X", you know the text already contains "AB". You don't restart; you shift the pattern to align the prefix "AB" with the suffix "AB" you just read.
*   **Efficiency:** Linear Time ($O(N+M)$).
*   **Use Case:** Searching in streams of data where you can't go backward (e.g., reading a file driver).

#### B. Rabin-Karp Algorithm
*   **The Concept:** It uses **Hashing** (Rolling Hash).
*   **How it Works:** Instead of comparing strings character by character, it turns strings into numbers (hashes).
    1.  Calculate the hash of the Pattern (e.g., "cat" = 123).
    2.  Calculate the hash of the first 3 letters of the text.
    3.  If the hash matches, double-check the characters (to avoid collision).
    4.  Slide the window one step right. Instead of recalculating the whole hash, use math to "subtract" the first letter and "add" the new letter (Rolling Hash).
*   **Efficiency:** Average case $O(N+M)$, worst case $O(N \cdot M)$.
*   **Use Case:** **Plagiarism detection**. It is very good at finding matches for *multiple* different patterns at the same time.

#### C. Boyer-Moore Algorithm
*   **The Concept:** It tries to skip as many characters as possible. It is the **standard** for many "Find" features in text editors.
*   **How it Works:** It compares the pattern against the text from **Right to Left** (backwards).
    *   **Bad Character Rule:** If the character in the text doesn't exist in your pattern at all, you can shift the *entire* length of the pattern past that character.
*   **Efficiency:** In the best case (when the text has none of the pattern characters), it runs in $O(N/M)$—meaning it gets *faster* the longer the pattern is.
*   **Use Case:** General-purpose string search (grep, Ctrl+F).

---

### 2. Trie (Prefix Tree) Applications
A Trie (pronounced "try" or "tree") is a specific type of tree data structure used for storing strings.

*   **Structure:**
    *   The root is empty.
    *   Each edge represents a character.
    *   Each node represents a prefix.
    *   Example: Storing "CAT" and "CAR".
        *   Root -> C -> A -> (branches split here) -> T / -> R.
*   **Why use it?**
    *   **Speed:** Searching for a word depends only on the length of the word ($L$), not the size of the dictionary ($N$).
    *   **Space:** It saves space by storing shared prefixes ("App", "Apple", "Apply" all share the "App" nodes).
*   **Key Applications:**
    1.  **Autocomplete:** When you type "Alg", the Trie goes down the A-L-G path and returns all children (Algorithm, Algebra).
    2.  **Spell Check:** Checking if a word exists in a dictionary.
    3.  **IP Routing:** Routers use Tries for "Longest Prefix Matching" to decide where to send packets.

---

### 3. Suffix Arrays / LCP Array
These are advanced structures used when Tries are too memory-intensive, often used in bioinformatics (DNA) and compression.

#### A. Suffix Array
*   **Definition:** An array of integers representing the starting indexes of all suffixes of a string, sorted alphabetically.
*   **Example:** String = "BANANA"
    *   Suffixes: BANANA, ANANA, NANA, ANA, NA, A
    *   **Sorted Suffixes:**
        1.  A (Index 5)
        2.  ANA (Index 3)
        3.  ANANA (Index 1)
        4.  BANANA (Index 0)
        5.  NA (Index 4)
        6.  NANA (Index 2)
    *   **Suffix Array Output:** `[5, 3, 1, 0, 4, 2]`
*   **Application:** It allows you to perform **Binary Search** on a string to find substrings very quickly.

#### B. LCP Array (Longest Common Prefix)
*   **Definition:** An auxiliary array used alongside the Suffix Array. It stores the length of the matching prefix between consecutive suffixes in the sorted array.
*   **Why?** In the example above, "ANA" and "ANANA" are next to each other. They share "ANA" (length 3).
*   **Major Applications:**
    1.  **Longest Repeated Substring:** Finding the longest phrase that appears twice in a book (or a DNA sequence).
    2.  **Data Compression:** Algorithms like Lempel-Ziv (used in ZIP files) use concepts similar to this to find repeated patterns and replace them with short references.

---

### Summary Comparison Table

| Algorithm/Structure | Primary Goal | Time Complexity (Search) | Best Real-World Use |
| :--- | :--- | :--- | :--- |
| **KMP** | Pattern Search | $O(N)$ | Streaming data, reading files. |
| **Rabin-Karp** | Pattern Search | $O(N)$ (Average) | Plagiarism detection (Multiple patterns). |
| **Boyer-Moore** | Pattern Search | $O(N/M)$ (Best) | Text editors (Ctrl+F). |
| **Trie** | Dictionary Storage | $O(L)$ (Word Length) | Autocomplete, Spell Checkers. |
| **Suffix Array** | Complex Analysis | $O(M \cdot \log N)$ | DNA Analysis, Data Compression. |
