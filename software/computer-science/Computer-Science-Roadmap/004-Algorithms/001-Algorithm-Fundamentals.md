Based on the roadmap provided, here is a detailed explanation of **Part IV: Algorithms – Section A: Algorithm Fundamentals**.

This section represents the theoretical bedrock of Computer Science. Before you write code to sort data or find the shortest path on a map, you must understand how to design the logic and measure how efficient that logic is.

---

### 1. Algorithmic Thinking & Problem Solving
This is the "soft skill" of computer science. It is the mental process of looking at a problem and defining a step-by-step procedure to solve it.

*   **The Goal:** To take a vague request (e.g., "Find the duplicate number in this list") and turn it into a precise set of instructions that a computer can execute blindly.
*   **The 4 Pillars:**
    1.  **Decomposition:** Breaking a complex problem into smaller, manageable sub-problems.
    2.  **Pattern Recognition:** Observing trends or similarities in data (e.g., "This looks like a sorting problem").
    3.  **Abstraction:** Filtering out unnecessary details to focus on the core logic (e.g., ignoring what the specific numbers are and focusing on how they compare to one another).
    4.  **Algorithm Design:** Creating the actual steps.
*   **Corner Cases:** A key part of problem-solving is asking, "What if the input is empty? What if it is negative? What if the list is sorted backwards?"

### 2. Pseudocode & Flowcharts
These are communication tools used to plan algorithms before writing actual syntax (like Python or C++).

*   **Pseudocode:**
    *   This is "fake code." It uses human-readable English structured like code.
    *   It ignores syntax rules (semicolons, braces) to focus entirely on logic.
    *   *Example:*
        ```text
        For every number in the list:
            If number is greater than max_value:
                Set max_value to number
        Return max_value
        ```
*   **Flowcharts:**
    *   A visual representation of the flow of control. Standard shapes are used:
        *   **Oval:** Start/End.
        *   **Rectangle:** Process/Action (e.g., `x = x + 1`).
        *   **Diamond:** Decision (e.g., `Is x > 0?`).
        *   **Parallelogram:** Input/Output.
        *   **Arrows:** Show the direction of the flow.

### 3. Asymptotic Analysis (Big O, Ω, Θ)
This is the mathematical standard for comparing algorithms. In CS, we rarely measure efficiency in seconds (because different computers have different speeds). Instead, we measure how the **number of operations** grows effectively as the **input size ($n$)** grows.

*   **Big O Notation ($O$): The Upper Bound (Worst Case)**
    *   This answers: "What is the longest this algorithm could possibly take?"
    *   This is the industry standard because we care most about ensuring our code doesn't crash under heavy load.
    *   *Example:* Searching an unsorted list for a specific number is $O(n)$, because the number might be at the very end.
*   **Big Omega Notation ($\Omega$): The Lower Bound (Best Case)**
    *   This answers: "What is the fastest this could possibly run?"
    *   *Example:* Searching a list is $\Omega(1)$ if the item happens to be the very first one you look at.
*   **Big Theta Notation ($\Theta$): The Tight Bound**
    *   This is used when the Best Case and Worst Case are essentially the same complexity class.
    *   If an algorithm is always $O(n)$ and always $\Omega(n)$, it is said to be $\Theta(n)$.

**Common Complexity Classes (Ranked Fast to Slow):**
1.  **$O(1)$ - Constant:** Instant. Doesn't matter if input is 1 or 1 million (e.g., accessing an array index).
2.  **$O(\log n)$ - Logarithmic:** Very fast. Cuts the problem in half every step (e.g., Binary Search).
3.  **$O(n)$ - Linear:** Time grows directly with input (e.g., a Loop).
4.  **$O(n \log n)$ - Linearithmic:** The standard for good sorting algorithms (e.g., Merge Sort).
5.  **$O(n^2)$ - Quadratic:** Slow. Usually caused by nested loops (e.g., Bubble Sort).
6.  **$O(2^n)$ - Exponential:** Very slow. Input grows slightly, time explodes (e.g., naive recursion).

### 4. Recursion & Recursive Complexity
Recursion occurs when a function calls itself to solve a smaller instance of the problem.

*   **The Anatomy of Recursion:**
    1.  **Base Case:** The condition that stops the recursion (e.g., `if n == 0: return`). Without this, you get a "Stack Overflow" error.
    2.  **Recursive Case:** The part where the function calls itself with modified arguments (e.g., `return n + factorial(n-1)`).
*   **The Call Stack:**
    *   Every time a recursive call happens, the computer saves the current state in memory (the stack). High recursion depth = high memory usage ($O(n)$ space complexity).
*   **Recursive Complexity Analysis:**
    *   Analyzing loops is easy (count the iterations). Analyzing recursion is harder.
    *   We often use **Recurrence Relations** to describe the cost.
    *   *Example (Merge Sort):* $T(n) = 2T(n/2) + O(n)$.
        *   This means: "To solve size $n$, I solve 2 sub-problems of size $n/2$, plus some linear work to combine them."
    *   **The Master Theorem:** A mathematical "cheat sheet" formula used to quickly determine the Big O complexity of these recurrence relations without doing the long math every time.
