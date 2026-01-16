Based on the table of contents provided, **Section E: Common Pitfalls ("Gotchas")** focuses on the specific frustrations engineers face when trying to profile applications (measuring where the CPU/memory is being used).

When you run a tool like `perf` or generate a Flame Graph, you expect to see a nice chart of function names and how much time they take. Often, however, you get "garbage" data. This section explains why that happens and how to fix it.

Here is a detailed explanation of the two major pitfalls listed:

---

### 1. Missing Symbols
**The Problem:**
You run a profiler (like `perf top` or create a Flame Graph), and instead of seeing human-readable function names like `handle_request` or `calculate_tax`, you see cryptic hexadecimal usage, such as `0x4f3a8b...`.

**The "Why":**
Computers execute machine code located at specific memory addresses. Humans read source code with "Symbols" (function names, variable names). To save space and prevent reverse-engineering, production binaries are often **stripped** meaning the dictionary that translates `Address 0x123` $\to$ `Function Name` has been deleted from the file.

**Specific Scenarios:**
*   **Stripped Binaries (C/C++/Rust):** If you compile with default settings for release, the map linking addresses to names is often discarded.
    *   *Fix:* You need to install "debuginfo" or "dbgsym" packages for your OS, or compile your app with symbols enabled not stripped.
*   **JIT (Just-In-Time) Compiled Languages (Java, Node.js):** This is trickier. In C++, the code is on the hard drive. In Java or Node, the code is generated *in memory* while the program runs. The Linux profiler (`perf`) looks at the hard drive, sees no code there, and gets confused.
    *   *Fix:* You must use specific flags (like Java's `perf-map-agent` or Node.js `--perf-basic-prof`). These flags force the application to write a simplistic text file (a map) to `/tmp/`, which tells the profiler: "If you see activity at memory address X, that is actually function Y."

---

### 2. Missing/Broken Stacks
**The Problem:**
You generate a Flame Graph to see the hierarchy of your code (e.g., `main()` called `server()` which called `process()`). However, the graph looks "flat." It only shows the function currently running, but not who called it. You see a lot of `[unknown]` or very short stacks.

**The "Why": The Frame Pointer Issue**
To "walk the stack" (trace the history of function calls), the profiler needs a breadcrumb trail.
*   **The Standard Way (Frame Pointers):** Traditionally, the CPU reserves a specific register (the `RBP` register on x86 architecture) to act as a bookmark. It points to the start of the current function's data. By jumping from bookmark to bookmark, the profiler can reconstruct the whole history.
*   **The Optimization (`-fomit-frame-pointer`):** Compiler writers (like those working on GCC) realized that if they didn't use that register for a bookmark, they could use it for general math, making the program roughly 1% faster. They made this the default setting (`-fomit-frame-pointer`).
*   **The Result:** The program runs slightly faster, but the "breadcrumbs" are gone. The profiler works, but it can't see the history, breaking your Flame Graphs.

**The Solutions (as listed in your text):**
1.  **Re-compiling (The easiest fix):** You re-compile your application with the flag `-fno-omit-frame-pointer`. This puts the breadcrumbs back. In fact, many modern Linux distributions (like Fedora) are switching this back on by default because observability is now considered more important than that 1% speed boost.
2.  **DWARF (The heavy fix):** DWARF is a standardized debugging format. It contains massive tables explaining how to unwind the stack without frame pointers.
    *   *Downside:* It is very slow and the data files are huge (often gigabytes). It is bad for live profiling in production.
3.  **ORC (Oops Rewind Capability):** This was created by the Linux Kernel team. It is a modern alternative to DWARF. It provides the data needed to walk the stack without frame pointers, but it is much more compact and faster to process than DWARF. It allows for profiling optimized code without the heavy overhead.

### Summary
This section of the document is warning you: **"If your profiler output looks broken, it's usually because the computer removed the names to save space (Missing Symbols) or removed the breadcrumbs to gain speed (Missing Stacks)."**
