Based on your instructions, I will adopt the role defined in the **Studying** section (Prompt 3) as it contains the most specific formatting and persona requirements for your note-taking.

***

**Role:** I am your **Computer Science Teacher**, specializing in Systems Programming and Memory Management.

Here is the tree-view summary of the Native Memory Profiling material.

*   **Native Memory Profiling Fundamentals**
    *   **The Core Distinction** (Understanding who cleans up the mess)
        *   **Managed Memory** (Used by Java, Python, JavaScript)
            *   **Garbage Collector / GC** (An automated process that runs in the background to clean up unused objects so you don't have to)
        *   **Native Memory** (Used by C, C++, Rust)
            *   **Manual Management** (You ask the OS for memory, and *you* must return it; if you forget, it stays occupied forever)
    *   **Why You Should Care** (Even if you don't code in C++)
        *   **Underlying Infrastructure** (High-level languages often run on Native engines)
            *   **Node.js** (Uses native memory for `Buffer` objects and file system operations)
            *   **Python** (Libraries like NumPy do heavy calculations in C to be fast)
        *   **Debugging OOM** (If your generic "Out of Memory" crash isn't fixed by looking at your code, the leak is likely in the native extensions)

*   **Profiling Techniques & Tools**
    *   **1. Basic Tracing** (`malloc` and `free`)
        *   **The Functions** (The commands used to handle memory)
            *   `malloc(size)` (Asking the library: "Can I borrow X bytes?")
            *   `free(pointer)` (Telling the library: "I am done with this block, take it back")
        *   **The Method: Hooking** (Intercepting calls to keep a ledger)
            *   **The Ledger** (The profiler counts every `malloc` and every `free`)
            *   **Leak Detection** (If `malloc` count > `free` count, the specific lines of code that didn't return memory are identified)
    *   **2. Deep Analysis** (Valgrind and Massif)
        *   **Valgrind** (The heavy-duty instrumentation suite)
            *   **Virtual Machine** (Runs your code inside a simulator to see *everything*)
            *   **Performance Cost** (Runs 20x-50x slower than normal, so not for production speed tests)
        *   **Massif** (The Heap Profiler tool inside Valgrind)
            *   **Snapshots** (Takes pictures of memory usage at different moments in time)
            *   **Peak Usage** (Identifies the moment your app used the most RAM, helping you debug spikes)
    *   **3. Modern Sanitizers** (Faster alternatives to Valgrind)
        *   **Compiler Flags** (Special instructions added when building the code with GCC or Clang)
        *   **ASan** (AddressSanitizer)
            *   **Role** (Fast memory error detector, only ~2x slowdown)
            *   **Red Zones** (Surrounds memory blocks with "poisoned" zones to catch you if you step out of bounds)
        *   **LSan** (LeakSanitizer)
            *   **Role** (Specifically hunts for memory leaks)
            *   **Exit Scan** (Checks at the very end of the program for any allocated memory that was "lost")

*   **Common Native Memory Bugs** (The dangerous stuff)
    *   **Buffer Overflows** (Writing where you shouldn't)
        *   **The Concept** (Imagine a bucket that holds 1 Liter, but you pour 1.5 Liters into it)
        *   **The Result** (The extra liquid spills onto the floor—or in computers, it overwrites the data sitting *next* to your bucket)
        *   **The Risk** (Doesn't always crash the program immediately, but can corrupt data or allow security hacks)
    *   **Uninitialized Memory** (Using dirty data)
        *   **The Concept** (Checking into a hotel room, but the maids didn't clean it; the previous guest's stuff is still there)
        *   **The Bug** (Declaring a variable but not giving it a value; it contains random garbage bits from the last user)
        *   **The Result** (Your calculations become unpredictable because they are based on random data)
