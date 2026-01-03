Here is the response separated into the two requested formats.

***

### Response to Prompt 2 (System Prompt: Senior Technical Analyst)

**Role:** Senior Technical Analyst
**Summary:**

Profiling dynamic languages (Python/Ruby) presents a unique **"Dual Stack" challenge**: standard system tools monitor the C-based Interpreter (Native Stack), while developers need insights into their script logic (User Stack).

*   **`cProfile` (Development Focus):** Uses **deterministic profiling** by hooking every function call.
    *   *Insight:* Provides 100% accurate call counts but incurs heavy execution overhead (2x-3x slowdown), making it **unsafe for production**.
*   **`py-spy` (Production Focus):** Uses **sampling** via process introspection (reading memory from outside).
    *   *Insight:* Negligible overhead allows for profiling live/production systems. It generates **Flame Graphs** but sacrifices absolute precision for statistical trends.
*   **The GIL (Global Interpreter Lock):** Forces single-core execution for threads.
    *   *Insight:* Distorts metrics by masking "waiting for lock" as "CPU usage." Effective profiling must distinguish between **CPU Time** (working) and **Wall Time** (waiting).
*   **Core Complexity:** Tools must bridge the gap between the static C runtime and dynamic, runtime-defined Python functions to resolve symbols correctly.

***

### Response to Prompt 3 (System Prompt: Super Teacher)

**Role:** I am your Computer Science Teacher specializing in Software Performance and Runtime Environments.

**Summary:**

Below is the breakdown of how we analyze languages like Python. Since you are a high school student, I will avoid sports analogies. Instead, imagine a **Translator**. When you speak (Python code), the Translator (Interpreter) converts it into a language the machine understands (C code).

*   **1. The Core Context: Interpreted vs. Compiled**
    *   **The "Dual Stack" Problem** [The main hurdle in profiling dynamic languages]
        *   **The Native Stack** [What the Operating System sees]
            *   The Interpreter itself (e.g., C functions like `PyEval_EvalFrame`).
            *   *Analogy:* [Watching the Translator's lips move.]
        *   **The User Stack** [What you care about]
            *   Your actual code (e.g., `def calculate_data`).
            *   *Analogy:* [Understanding the actual meaning of the story you are telling.]
        *   **The Goal:** We need tools that ignore the "Translator" and focus on your "Story."

*   **2. The Tools: Two Different Approaches**
    *   **Option A: `cProfile`** (The Built-in Standard)
        *   **Method:** **Deterministic Profiling**
            *   It places "hooks" on every single function start and stop.
            *   *Analogy:* [Imagine a teacher stopping you after every single word you read to log it in a notebook. It is very precise, but it makes you read much slower.]
        *   **Pros:** Perfect accuracy on how many times a function ran.
        *   **Cons:**
            *   **High Overhead** [Slows program down by 2x or 3x].
            *   **Usage:** Only for debugging on your laptop, **NEVER** in production.
    *   **Option B: `py-spy`** (The Modern Solution)
        *   **Method:** **Sampling Profiling**
            *   It sits outside the program and takes "snapshots" of the memory 100 times a second.
            *   *Analogy:* [A security camera taking a photo every few seconds. It captures what is happening without interrupting the people moving around.]
        *   **Pros:**
            *   **Low Overhead** [Safe to use on a live website with real users].
            *   **Flame Graphs** [Visual charts that are easier to read than text tables].
        *   **Cons:** Might miss very fast functions that happen between snapshots.

*   **3. The GIL (Global Interpreter Lock)**
    *   **The Concept:** A lock that prevents Python from using more than one CPU core at a time for Python code.
    *   **The Profiling Trap:**
        *   **CPU Time** vs. **Wall Time**
            *   **CPU Time:** The processor is actually calculating math.
            *   **Wall Time:** The total time passed on the clock (including waiting).
        *   **The Danger:** You might see 100% CPU usage and think the code is working hard, but it might actually just be **waiting** to get the Key (GIL) to the room.

*   **4. Why is this hard? (The Technical Challenges)**
    *   **Symbol Resolution**
        *   Standard tools (like Linux `perf`) look at the binary.
        *   They see "Interpreter doing work" rather than "Python function name."
    *   **Dynamic Nature**
        *   Python functions can be created while the program is running, making them hard to track compared to compiled code (C++) which is set in stone before running.
